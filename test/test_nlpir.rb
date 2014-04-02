require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'test/unit'
require File.expand_path('../../lib/nlpir.rb', __FILE__)

include Nlpir

$s = "坚定不移沿着中国特色社会主义道路前进,为全面建成小康社会而奋斗"
$text = "去年开始，打开百度李毅吧，满屏的帖子大多含有“屌丝”二字，一般网友不仅不懂这词什么意思，更难理解这个词为什么会这么火。然而从下半年开始，“屌丝”已经覆盖网络各个角落，人人争说屌丝，人人争当屌丝。
从遭遇恶搞到群体自嘲，“屌丝”名号横空出世“屌丝”一词最早的来源是百度“三巨头吧”对“李毅吧”球迷的恶搞称谓，有嘲讽之意，但却被李毅吧的球迷就此领受下来。“屌丝”二字蕴含着无奈和自嘲的意味，但是李毅吧球迷“不以为耻、反以为荣”，从此以“屌丝”自称，并开始一路爆红网络。"
$text2 = "淋语（linguage），简称淋语、淋文，是一种主要为淋王星所使用的语言，是淋王星的官方语言。淋语属于黏着语、通过在词语上粘贴语法成分来构成句子，称为活用，其间的结合并不紧密、不改变原来词汇的含义只表语法功能。淋语博大精深自宇宙大爆炸以来已有数亿人民使用自成一个体系。"

class NlpirTest < Test::Unit::TestCase
  
  def test_process_alias
    nlpir_init(File.expand_path("../", __FILE__), UTF8_CODE)

    assert_equal "坚定不移/vl 沿着/p 中国/ns 特色/n 社会主义/n 道路/n 前进/vi ,/wd 为/v 全面/ad 建成/v 小康/n 社会/n 而/cc 奋斗/vi ",
      text_proc($s)
    assert_equal "坚定不移 沿着 中国 特色 社会主义 道路 前进 , 为 全面 建成 小康 社会 而 奋斗 ",
      text_proc($s,NLPIR_FALSE)  
    
    setPOSmap(PKU_POS_MAP_FIRST)
    assert_equal "坚定不移/v 沿着/p 中国/n 特色/n 社会主义/n 道路/n 前进/v ,/w 为/v 全面/a 建成/v 小康/n 社会/n 而/c 奋斗/v ",
      text_proc($s)

    assert_equal 15,
      text_procA($s).size
    assert_equal 15,
      text_procAW($s).size

      result=""
      words_list = text_procA($s)
      i=1
      words_list.each do |a|
        sWhichDic=""
        case a.word_type
          when 0
            sWhichDic = "核心词典"
          when 1
            sWhichDic = "用户词典"
          when 2
            sWhichDic = "专业词典"
        end
        result << "No.#{i}:start:#{a.start}, length:#{a.length}, POS_ID:#{a.sPOS},word_ID:#{a.word_ID},word_type:#{a.word_type} , UserDefine:#{sWhichDic}, Word:#{$s.byteslice(a.start,a.length)}, Weight:#{a.weight}\n"
        i += 1 
      end
      assert_equal "No.1:start:0, length:12, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:17262,word_type:0 , UserDefine:核心词典, Word:坚定不移, Weight:10520\nNo.2:start:12, length:6, POS_ID:[112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:28059,word_type:0 , UserDefine:核心词典, Word:沿着, Weight:10798\nNo.3:start:18, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:32696,word_type:0 , UserDefine:核心词典, Word:中国, Weight:6097\nNo.4:start:24, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:12288,word_type:0 , UserDefine:核心词典, Word:特色, Weight:8469\nNo.5:start:30, length:12, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:48646,word_type:0 , UserDefine:核心词典, Word:社会主义, Weight:7442\nNo.6:start:42, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:75518,word_type:0 , UserDefine:核心词典, Word:道路, Weight:8859\nNo.7:start:48, length:6, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:35004,word_type:0 , UserDefine:核心词典, Word:前进, Weight:9350\nNo.8:start:54, length:1, POS_ID:[119, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:49,word_type:0 , UserDefine:核心词典, Word:,, Weight:2703\nNo.9:start:55, length:3, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:66615,word_type:0 , UserDefine:核心词典, Word:为, Weight:5539\nNo.10:start:58, length:6, POS_ID:[97, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:40698,word_type:0 , UserDefine:核心词典, Word:全面, Weight:7844\nNo.11:start:64, length:6, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:84698,word_type:0 , UserDefine:核心词典, Word:建成, Weight:9027\nNo.12:start:70, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:81502,word_type:0 , UserDefine:核心词典, Word:小康, Weight:10000\nNo.13:start:76, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:48622,word_type:0 , UserDefine:核心词典, Word:社会, Weight:6646\nNo.14:start:82, length:3, POS_ID:[99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:32081,word_type:0 , UserDefine:核心词典, Word:而, Weight:6610\nNo.15:start:85, length:6, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:27256,word_type:0 , UserDefine:核心词典, Word:奋斗, Weight:9364\n",
result

    add_userword("1989年春夏之交的政治风波  n")
    assert_equal "1989年春夏之交的政治风波/n 1989年政治风波/n 24小时降雪量/n 24/m 小时/q 降雨量/n 863/m 计划/n ABC/n 防护/v 训练/v APEC/n 会议/n BB/n 机/n BP机/n C2系统/n C3I/n 系统/n C3/n 系统/n C4ISR/n 系统/n C4I/n 系统/n CCITT/n 建议/n ",
      text_proc("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
    del_userword("1989年春夏之交的政治风波")

    assert_equal 5,
      import_userdict("./userdict.txt")
      save_userdict()
    assert_equal "1989年春夏之交的政治风波/n 1989年政治风波/n 24小时降雪量/n 24/m 小时/q 降雨量/n 863/m 计划/n ABC/n 防护/v 训练/v APEC/n 会议/n BB/n 机/n BP机/n C2系统/n C3I/n 系统/n C3/n 系统/n C4ISR/n 系统/n C4I/n 系统/n CCITT/n 建议/n ",
      text_proc("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
    
    file_proc("./test.txt", "./test_result.txt", NLPIR_TRUE)
    assert_equal 16932,
      File.open("./test_result.txt").size

    assert_equal 15,
      text_wordcount($s)

    assert_equal "李毅/n/4.57#球迷/n/2.20#屌丝/n_newword/1.77#开始/v/1.74#百度/n/1.39#",
      text_keywords($text, 50,NLPIR_TRUE)
    assert_equal "李毅/n/8.90#社会/n/4.06#",
      file_keywords("./test.txt",2, NLPIR_TRUE)
      
    assert_equal "淋语/n_new/4.99#",
      text_newwords($text2, 50, NLPIR_TRUE)
    assert_equal "淋语/n_new/5.96#指淋淋/n_new/5.60#",
      file_newwords("./findnewword.txt", 50, NLPIR_TRUE)

    assert_equal 1644572591,
      text_fingerprint($text)
    nlpir_exit()

  end

#   def test_process_origin
#   	NLPIR_Init(File.expand_path("../", __FILE__), UTF8_CODE)
#     setPOSmap(ICT_POS_MAP_SECOND)
#   	assert_equal "坚定不移/vl 沿着/p 中国/ns 特色/n 社会主义/n 道路/n 前进/vi ,/wd 为/v 全面/ad 建成/v 小康/n 社会/n 而/cc 奋斗/vi ",
#   		NLPIR_ParagraphProcess($s)
#   	assert_equal "坚定不移 沿着 中国 特色 社会主义 道路 前进 , 为 全面 建成 小康 社会 而 奋斗 ",
#   		NLPIR_ParagraphProcess($s,NLPIR_FALSE)	
  	
#     NLPIR_SetPOSmap(PKU_POS_MAP_FIRST)
#     assert_equal "坚定不移/v 沿着/p 中国/n 特色/n 社会主义/n 道路/n 前进/v ,/w 为/v 全面/a 建成/v 小康/n 社会/n 而/c 奋斗/v ",
#       NLPIR_ParagraphProcess($s)

#     assert_equal 15,
#       NLPIR_ParagraphProcessA($s).size
#     assert_equal 15,
#       NLPIR_ParagraphProcessAW($s).size

#       result=""
#       words_list = NLPIR_ParagraphProcessA($s)
#       i=1
#       words_list.each do |a|
#         sWhichDic=""
#         case a.word_type
#           when 0
#             sWhichDic = "核心词典"
#           when 1
#             sWhichDic = "用户词典"
#           when 2
#             sWhichDic = "专业词典"
#         end
#         result << "No.#{i}:start:#{a.start}, length:#{a.length}, POS_ID:#{a.sPOS},word_ID:#{a.word_ID},word_type:#{a.word_type} , UserDefine:#{sWhichDic}, Word:#{$s.byteslice(a.start,a.length)}, Weight:#{a.weight}\n"
#         i += 1 
#       end
#       assert_equal "No.1:start:0, length:12, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:17262,word_type:0 , UserDefine:核心词典, Word:坚定不移, Weight:10520\nNo.2:start:12, length:6, POS_ID:[112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:28059,word_type:0 , UserDefine:核心词典, Word:沿着, Weight:10798\nNo.3:start:18, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:32696,word_type:0 , UserDefine:核心词典, Word:中国, Weight:6097\nNo.4:start:24, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:12288,word_type:0 , UserDefine:核心词典, Word:特色, Weight:8469\nNo.5:start:30, length:12, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:48646,word_type:0 , UserDefine:核心词典, Word:社会主义, Weight:7442\nNo.6:start:42, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:75518,word_type:0 , UserDefine:核心词典, Word:道路, Weight:8859\nNo.7:start:48, length:6, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:35004,word_type:0 , UserDefine:核心词典, Word:前进, Weight:9350\nNo.8:start:54, length:1, POS_ID:[119, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:49,word_type:0 , UserDefine:核心词典, Word:,, Weight:2703\nNo.9:start:55, length:3, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:66615,word_type:0 , UserDefine:核心词典, Word:为, Weight:5539\nNo.10:start:58, length:6, POS_ID:[97, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:40698,word_type:0 , UserDefine:核心词典, Word:全面, Weight:7844\nNo.11:start:64, length:6, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:84698,word_type:0 , UserDefine:核心词典, Word:建成, Weight:9027\nNo.12:start:70, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:81502,word_type:0 , UserDefine:核心词典, Word:小康, Weight:10000\nNo.13:start:76, length:6, POS_ID:[110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:48622,word_type:0 , UserDefine:核心词典, Word:社会, Weight:6646\nNo.14:start:82, length:3, POS_ID:[99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:32081,word_type:0 , UserDefine:核心词典, Word:而, Weight:6610\nNo.15:start:85, length:6, POS_ID:[118, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],word_ID:27256,word_type:0 , UserDefine:核心词典, Word:奋斗, Weight:9364\n",
# result

#     NLPIR_AddUserWord("1989年春夏之交的政治风波  n")
#     assert_equal "1989年春夏之交的政治风波/n 1989年政治风波/n 24小时降雪量/n 24/m 小时/q 降雨量/n 863/m 计划/n ABC/n 防护/v 训练/v APEC/n 会议/n BB/n 机/n BP机/n C2系统/n C3I/n 系统/n C3/n 系统/n C4ISR/n 系统/n C4I/n 系统/n CCITT/n 建议/n ",
#       NLPIR_ParagraphProcess("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
#     NLPIR_DelUsrWord("1989年春夏之交的政治风波")

#     assert_equal 5,
#       NLPIR_ImportUserDict("./userdict.txt")
#       NLPIR_SaveTheUsrDic()
#     assert_equal "1989年春夏之交的政治风波/n 1989年政治风波/n 24小时降雪量/n 24/m 小时/q 降雨量/n 863/m 计划/n ABC/n 防护/v 训练/v APEC/n 会议/n BB/n 机/n BP机/n C2系统/n C3I/n 系统/n C3/n 系统/n C4ISR/n 系统/n C4I/n 系统/n CCITT/n 建议/n ",
#       NLPIR_ParagraphProcess("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
    
#     NLPIR_FileProcess("./test.txt", "./test_result.txt", NLPIR_TRUE)
#     assert_equal 16932,
#       File.open("./test_result.txt").size

#     assert_equal 15,
#       NLPIR_GetParagraphProcessAWordCount($s)

#     assert_equal "李毅/n/4.57#球迷/n/2.20#屌丝/n_newword/1.77#开始/v/1.74#百度/n/1.39#",
#       NLPIR_GetKeyWords($text, 50,NLPIR_TRUE)
#     assert_equal "李毅/n/8.90#社会/n/4.06#",
#       NLPIR_GetFileKeyWords("./test.txt",2, NLPIR_TRUE)
      
#     assert_equal "淋语/n_new/4.99#",
#       NLPIR_GetNewWords($text2, 50, NLPIR_TRUE)
#     assert_equal "淋语/n_new/5.96#指淋淋/n_new/5.60#",
#       NLPIR_GetFileNewWords("./findnewword.txt", 50, NLPIR_TRUE)

#     assert_equal 1644572591,
#       NLPIR_FingerPrint($text)
#   	NLPIR_Exit()

#   end
end