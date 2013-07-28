# coding: utf-8
require File.expand_path("../nlpir/version", __FILE__)
require 'fiddle'
require 'fiddle/struct'
require 'fiddle/import'
include Fiddle::CParser
include Fiddle::Importer

module Nlpir
  NLPIR_FALSE = 0
  NLPIR_TRUE = 1
  POS_MAP_NUMBER = 4
  ICT_POS_MAP_FIRST = 1            #计算所一级标注集
  ICT_POS_MAP_SECOND = 0       #计算所二级标注集
  PKU_POS_MAP_SECOND = 2       #北大二级标注集
  PKU_POS_MAP_FIRST = 3	#北大一级标注集
  POS_SIZE = 40

  Result_t = struct ['int start','int length',"char  sPOS[#{POS_SIZE}]",'int iPOS',
  		          'int word_ID','int word_type','double weight']

  GBK_CODE = 0                                                    #默认支持GBK编码
  UTF8_CODE = GBK_CODE + 1                          #UTF8编码
  BIG5_CODE = GBK_CODE + 2                          #BIG5编码
  GBK_FANTI_CODE = GBK_CODE + 3             #GBK编码，里面包含繁体字


  #提取链接库接口
  libm = Fiddle.dlopen(File.expand_path("../../bin/libNLPIR.so", __FILE__))
 
 NLPIR_Init_rb = Fiddle::Function.new(
    libm['_Z10NLPIR_InitPKci'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT],
    Fiddle::TYPE_INT
  )
  NLPIR_Exit_rb = Fiddle::Function.new(
    libm['_Z10NLPIR_Exitv'],
    [],
    Fiddle::TYPE_INT
  )
  NLPIR_ImportUserDict_rb = Fiddle::Function.new(
    libm['_Z20NLPIR_ImportUserDictPKc'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_ParagraphProcess_rb = Fiddle::Function.new(
    libm['_Z22NLPIR_ParagraphProcessPKci'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_ParagraphProcessA_rb = Fiddle::Function.new(
    libm['_Z23NLPIR_ParagraphProcessAPKcPib'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_FileProcess_rb = Fiddle::Function.new(
    libm['_Z17NLPIR_FileProcessPKcS0_i'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
    Fiddle::TYPE_DOUBLE
  )
  NLPIR_GetParagraphProcessAWordCount_rb = Fiddle::Function.new(
    libm['_Z35NLPIR_GetParagraphProcessAWordCountPKc'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_ParagraphProcessAW_rb = Fiddle::Function.new(
    libm['_Z24NLPIR_ParagraphProcessAWiP8result_t'],
    [Fiddle::TYPE_INT,Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_AddUserWord_rb = Fiddle::Function.new(
    libm['_Z17NLPIR_AddUserWordPKc'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_SaveTheUsrDic_rb = Fiddle::Function.new(
    libm['_Z19NLPIR_SaveTheUsrDicv'],
    [],
    Fiddle::TYPE_INT
  )
  NLPIR_DelUsrWord_rb = Fiddle::Function.new(
    libm['_Z16NLPIR_DelUsrWordPKc'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_GetKeyWords_rb = Fiddle::Function.new(
    libm['_Z17NLPIR_GetKeyWordsPKcib'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_GetFileKeyWords_rb = Fiddle::Function.new(
    libm['_Z21NLPIR_GetFileKeyWordsPKcib'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_GetNewWords_rb = Fiddle::Function.new(
    libm['_Z17NLPIR_GetNewWordsPKcib'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_GetFileNewWords_rb = Fiddle::Function.new(
    libm['_Z21NLPIR_GetFileNewWordsPKcib'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_FingerPrint_rb = Fiddle::Function.new(
    libm['_Z17NLPIR_FingerPrintPKc'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_LONG
  )
  NLPIR_SetPOSmap_rb = Fiddle::Function.new(
    libm['_Z15NLPIR_SetPOSmapi'],
    [Fiddle::TYPE_INT],
    Fiddle::TYPE_INT
  )

  NLPIR_NWI_Start_rb = Fiddle::Function.new(
    libm['_Z15NLPIR_NWI_Startv'],
    [],
    Fiddle::TYPE_INT
  )
  NLPIR_NWI_AddFile_rb = Fiddle::Function.new(
    libm['_Z17NLPIR_NWI_AddFilePKc'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_NWI_AddMem_rb = Fiddle::Function.new(
    libm['_Z16NLPIR_NWI_AddMemPKc'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_INT
  )
  NLPIR_NWI_Complete_rb = Fiddle::Function.new(
    libm['_Z18NLPIR_NWI_Completev'],
    [],
    Fiddle::TYPE_INT
  )
  NLPIR_NWI_GetResult_rb = Fiddle::Function.new(
    libm['_Z19NLPIR_NWI_GetResultb'],
    [Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
  NLPIR_NWI_Result2UserDict_rb = Fiddle::Function.new(
    libm['_Z25NLPIR_NWI_Result2UserDictv'],
    [],
    Fiddle::TYPE_VOIDP
  )

  #--函数

  def NLPIR_Init(sInitDirPath=nil , encoding=UTF8_CODE)
    NLPIR_Init_rb.call(sInitDirPath,encoding)
  end

  def NLPIR_Exit()
    NLPIR_Exit_rb.call()
  end

  def NLPIR_ImportUserDict(sFilename)
    NLPIR_ImportUserDict_rb.call(sFilename)
  end

  def NLPIR_ParagraphProcess(sParagraph, bPOStagged=1)
    NLPIR_ParagraphProcess_rb.call(sParagraph, bPOStagged)
  end

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

    def NLPIR_FileProcess(sSourceFilename, sResultFilename, bPOStagged=ICT_POS_MAP_FIRST)
      NLPIR_FileProcess_rb.call(sSourceFilename, sResultFilename, bPOStagged)
    end

    def NLPIR_GetParagraphProcessAWordCount(sParagraph)
      NLPIR_GetParagraphProcessAWordCount_rb.call(sParagraph)
    end

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

    def NLPIR_AddUserWord(sWord)
      NLPIR_AddUserWord_rb.call(sWord)
    end

    def NLPIR_SaveTheUsrDic()
      NLPIR_SaveTheUsrDic_rb.call()
    end

    def NLPIR_DelUsrWord(sWord)
      NLPIR_DelUsrWord_rb.call(sWord)
    end

    def NLPIR_GetKeyWords(sLine, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
      NLPIR_GetKeyWords_rb.call(sLine, nMaxKeyLimit, bWeightOut)
    end

    def NLPIR_GetFileKeyWords(sTextFile, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
      NLPIR_GetFileKeyWords_rb.call(sTextFile, nMaxKeyLimit, bWeightOut)
    end

    def NLPIR_GetNewWords(sLine, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
      NLPIR_GetNewWords_rb.call(sLine, nMaxKeyLimit, bWeightOut)
    end

    def NLPIR_GetFileNewWords(sTextFile, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
      NLPIR_GetFileNewWords_rb.call(sTextFile, nMaxKeyLimit, bWeightOut)
    end

    def NLPIR_FingerPrint(sLine)
      NLPIR_FingerPrint_rb.call(sLine)
    end

    def NLPIR_SetPOSmap(nPOSmap)
      NLPIR_SetPOSmap_rb.call(nPOSmap)
    end

    def NLPIR_NWI_Start()
      NLPIR_NWI_Start_rb.call()
    end

    def NLPIR_NWI_AddFile(sFilename)
      NLPIR_NWI_AddFile_rb.call(sFilename)
    end

    def NLPIR_NWI_AddMem(sFilename)
      NLPIR_NWI_AddMem_rb.call(sFilename)
    end

    def NLPIR_NWI_Complete()
      NLPIR_NWI_Complete_rb.call()
    end

    def NLPIR_NWI_GetResult( bWeightOut = NLPIR_FALSE)
      NLPIR_NWI_GetResult_rb.call(bWeightOut)
    end

    def NLPIR_NWI_Result2UserDict()
      NLPIR_NWI_Result2UserDict_rb.call()
    end

  end
