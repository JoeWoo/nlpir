# coding: utf-8
require File.expand_path("../nlpir/version", __FILE__)
require 'fiddle'
require 'fiddle/struct'
require 'fiddle/import'
require 'fileutils'   
include Fiddle::CParser
include Fiddle::Importer

module Nlpir
  NLPIR_FALSE = 0
  NLPIR_TRUE = 1
  POS_MAP_NUMBER = 4
  ICT_POS_MAP_FIRST = 1            #计算所一级标注集
  ICT_POS_MAP_SECOND = 0       #计算所二级标注集
  PKU_POS_MAP_SECOND = 2       #北大二级标注集
  PKU_POS_MAP_FIRST = 3     	#北大一级标注集
  POS_SIZE = 40

  Result_t = struct ['int start','int length',"char  sPOS[#{POS_SIZE}]",'int iPOS',
  		          'int word_ID','int word_type','int weight']
  
  GBK_CODE = 0                                                    #默认支持GBK编码
  UTF8_CODE = GBK_CODE + 1                          #UTF8编码
  BIG5_CODE = GBK_CODE + 2                          #BIG5编码
  GBK_FANTI_CODE = GBK_CODE + 3             #GBK编码，里面包含繁体字

  @charset = 'utf-8'

  #提取链接库接口
  libm = Fiddle.dlopen(File.expand_path("../../bin/libNLPIR.so", __FILE__))
 
 NLPIR_Init_rb = Fiddle::Function.new(
    libm['NLPIR_Init'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT],
    Fiddle::TYPE_INT
  )
  NLPIR_Exit_rb = Fiddle::Function.new(
    libm['NLPIR_Exit'],
    [],
    Fiddle::TYPE_INT
  )
  NLPIR_ImportUserDict_rb = Fiddle::Function.new(
    libm['NLPIR_ImportUserDict'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_ParagraphProcess_rb = Fiddle::Function.new(
    libm['NLPIR_ParagraphProcess'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_ParagraphProcessA_rb = Fiddle::Function.new(
    libm['NLPIR_ParagraphProcessA'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_FileProcess_rb = Fiddle::Function.new(
    libm['NLPIR_FileProcess'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_DOUBLE
  )
  NLPIR_GetParagraphProcessAWordCount_rb = Fiddle::Function.new(
    libm['NLPIR_GetParagraphProcessAWordCount'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_ParagraphProcessAW_rb = Fiddle::Function.new(
    libm['NLPIR_ParagraphProcessAW'],
    [Fiddle::TYPE_INT,Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_AddUserWord_rb = Fiddle::Function.new(
    libm['NLPIR_AddUserWord'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_SaveTheUsrDic_rb = Fiddle::Function.new(
    libm['NLPIR_SaveTheUsrDic'],
    [],
    Fiddle::TYPE_INT
  )
  NLPIR_DelUsrWord_rb = Fiddle::Function.new(
    libm['NLPIR_DelUsrWord'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_GetKeyWords_rb = Fiddle::Function.new(
    libm['NLPIR_GetKeyWords'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_GetFileKeyWords_rb = Fiddle::Function.new(
    libm['NLPIR_GetFileKeyWords'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_GetNewWords_rb = Fiddle::Function.new(
    libm['NLPIR_GetNewWords'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_GetFileNewWords_rb = Fiddle::Function.new(
    libm['NLPIR_GetFileNewWords'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_FingerPrint_rb = Fiddle::Function.new(
    libm['NLPIR_FingerPrint'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_LONG
  )
  NLPIR_SetPOSmap_rb = Fiddle::Function.new(
    libm['NLPIR_SetPOSmap'],
    [Fiddle::TYPE_INT],
    Fiddle::TYPE_INT
  )

  NLPIR_NWI_Start_rb = Fiddle::Function.new(
    libm['NLPIR_NWI_Start'],
    [],
    Fiddle::TYPE_INT
  )
  NLPIR_NWI_AddFile_rb = Fiddle::Function.new(
    libm['NLPIR_NWI_AddFile'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_NWI_AddMem_rb = Fiddle::Function.new(
    libm['NLPIR_NWI_AddMem'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_NWI_Complete_rb = Fiddle::Function.new(
    libm['NLPIR_NWI_Complete'],
    [],
    Fiddle::TYPE_INT
  )
  NLPIR_NWI_GetResult_rb = Fiddle::Function.new(
    libm['NLPIR_NWI_GetResult'],
    [Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_NWI_Result2UserDict_rb = Fiddle::Function.new(
    libm['NLPIR_NWI_Result2UserDict'],
    [],
    Fiddle::TYPE_VOIDP
  )

  #--函数

  def NLPIR_Init(sInitDirPath=nil , encoding=UTF8_CODE)
    sInitDirPath += "/Data/"
    if File.exist?(sInitDirPath)==false
      FileUtils.mkdir(sInitDirPath)
      filemother = File.expand_path("../Data/", __FILE__)
      FileUtils.copy_entry filemother,sInitDirPath
    end          
    @charset = 'gbk' if encoding == GBK_CODE
    @charset = 'utf-8' if encoding == UTF8_CODE
    @charset = 'big5' if  encoding == BIG5_CODE
    @charset = 'gbk' if encoding == GBK_FANTI_CODE
    NLPIR_Init_rb.call(nil,encoding)
  end
  alias :nlpir_init  :NLPIR_Init

  def NLPIR_Exit()
    NLPIR_Exit_rb.call()
  end
  alias :nlpir_exit :NLPIR_Exit

  def NLPIR_ImportUserDict(sFilename)
    NLPIR_ImportUserDict_rb.call(sFilename)
  end
  alias :import_userdict :NLPIR_ImportUserDict

  def NLPIR_ParagraphProcess(sParagraph, bPOStagged=NLPIR_TRUE)
    NLPIR_ParagraphProcess_rb.call(sParagraph, bPOStagged).to_s.force_encoding(@charset)
  end
  alias :text_proc :NLPIR_ParagraphProcess

  def NLPIR_ParagraphProcessA(sParagraph)
    resultCount = NLPIR_GetParagraphProcessAWordCount(sParagraph)
    pResultCount = Fiddle::Pointer.to_ptr(resultCount)
    p = NLPIR_ParagraphProcessA_rb.call(sParagraph, pResultCount.ref.to_i)
    pVecResult = Fiddle::Pointer.new(p.to_i)
    words_list = []
    words_list << Result_t.new(pVecResult)
    for i in 1...resultCount  do
        words_list << Result_t.new(pVecResult += Result_t.size)
    end
    return words_list
  end
  alias :text_procA :NLPIR_ParagraphProcessA

  def NLPIR_GetParagraphProcessAWordCount(sParagraph)
    NLPIR_GetParagraphProcessAWordCount_rb.call(sParagraph)
  end
  alias :text_wordcount :NLPIR_GetParagraphProcessAWordCount

  def NLPIR_FileProcess(sSourceFilename, sResultFilename, bPOStagged=NLPIR_TRUE)
    NLPIR_FileProcess_rb.call(sSourceFilename, sResultFilename, bPOStagged)
  end
  alias :file_proc :NLPIR_FileProcess

  
  def NLPIR_ParagraphProcessAW(sParagraph)
    free = Fiddle::Function.new(Fiddle::RUBY_FREE, [TYPE_VOIDP], TYPE_VOID)
    resultCount = NLPIR_GetParagraphProcessAWordCount(sParagraph)
    pVecResult = Pointer.malloc(Result_t.size*resultCount,free)
    NLPIR_ParagraphProcessAW_rb.call(resultCount,pVecResult)
    words_list = []
    words_list << Result_t.new(pVecResult)
    for i in 1...resultCount do
        words_list << Result_t.new(pVecResult+=Result_t.size)
    end
    return words_list
  end
  alias :text_procAW :NLPIR_ParagraphProcessAW


  def NLPIR_AddUserWord(sWord)
    NLPIR_AddUserWord_rb.call(sWord)
  end
  alias :add_userword :NLPIR_AddUserWord

  def NLPIR_SaveTheUsrDic()
    NLPIR_SaveTheUsrDic_rb.call()
  end
  alias :save_userdict :NLPIR_SaveTheUsrDic

  def NLPIR_DelUsrWord(sWord)
    NLPIR_DelUsrWord_rb.call(sWord)
  end
  alias :del_userword :NLPIR_DelUsrWord

  def NLPIR_GetKeyWords(sLine, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
    NLPIR_GetKeyWords_rb.call(sLine, nMaxKeyLimit, bWeightOut).to_s.force_encoding(@charset)
  end
  alias :text_keywords :NLPIR_GetKeyWords

  def NLPIR_GetFileKeyWords(sTextFile, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
    line = NLPIR_GetFileKeyWords_rb.call(sTextFile, nMaxKeyLimit, bWeightOut).to_s
    line.force_encoding('gbk')
    line.encode!(@charset)
  end
  alias :file_keywords :NLPIR_GetFileKeyWords

  def NLPIR_GetNewWords(sLine, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
    NLPIR_GetNewWords_rb.call(sLine, nMaxKeyLimit, bWeightOut).to_s.force_encoding(@charset)
  end
  alias :text_newwords :NLPIR_GetNewWords

  def NLPIR_GetFileNewWords(sTextFile, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
    NLPIR_GetFileNewWords_rb.call(sTextFile, nMaxKeyLimit, bWeightOut).to_s.force_encoding(@charset)
  end
  alias :file_newwords :NLPIR_GetFileNewWords

  def NLPIR_FingerPrint(sLine)
    NLPIR_FingerPrint_rb.call(sLine)
  end
  alias :text_fingerprint :NLPIR_FingerPrint

  def NLPIR_SetPOSmap(nPOSmap)
    NLPIR_SetPOSmap_rb.call(nPOSmap)
  end
  alias :setPOSmap :NLPIR_SetPOSmap

  def NLPIR_NWI_Start()
    NLPIR_NWI_Start_rb.call()
  end
  alias :NWI_start :NLPIR_NWI_Start

  def NLPIR_NWI_AddFile(sFilename)
    NLPIR_NWI_AddFile_rb.call(sFilename)
  end
  alias :NWI_addfile :NLPIR_NWI_AddFile

  def NLPIR_NWI_AddMem(sFilename)
    NLPIR_NWI_AddMem_rb.call(sFilename)
  end
  alias :NWI_addmem :NLPIR_NWI_AddMem

  def NLPIR_NWI_Complete()
    NLPIR_NWI_Complete_rb.call()
  end
  alias :NWI_complete :NLPIR_NWI_Complete

  def NLPIR_NWI_GetResult( bWeightOut = NLPIR_FALSE)
    NLPIR_NWI_GetResult_rb.call(bWeightOut)
  end
  alias :NWI_result :NLPIR_NWI_GetResult

  def NLPIR_NWI_Result2UserDict()
    NLPIR_NWI_Result2UserDict_rb.call()
  end
  alias :NWI_result2userdict :NLPIR_NWI_Result2UserDict

  end
