require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'test/unit'
require File.expand_path('../../lib/nlpir.rb', __FILE__)

include Nlpir

$s = "坚定不移沿着中国特色社会主义道路前进,为全面建成小康社会而奋斗"
$text = "去年开始，打开百度李毅吧，满屏的帖子大多含有“屌丝”二字，一般网友不仅不懂这词什么意思，更难理解这个词为什么会这么火。然而从下半年开始，“屌丝”已经覆盖网络各个角落，人人争说屌丝，人人争当屌丝。
从遭遇恶搞到群体自嘲，“屌丝”名号横空出世“屌丝”一词最早的来源是百度“三巨头吧”对“李毅吧”球迷的恶搞称谓，有嘲讽之意，但却被李毅吧的球迷就此领受下来。“屌丝”二字蕴含着无奈和自嘲的意味，但是李毅吧球迷“不以为耻、反以为荣”，从此以“屌丝”自称，并开始一路爆红网络。"

class NlpirTest < Test::Unit::TestCase
  def test_init
    assert_equal NLPIR_TRUE,
         NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  end

  def test_exit
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))

  	assert_equal NLPIR_TRUE,
  		NLPIR_Exit()
  end
  
  def test_process_paragraph
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))

  	assert_equal "坚定不移/vl 沿着/p 中国/ns 特色/n 社会主义/n 道路/n 前进/vi ,/wd 为/v 全面/ad 建成/v 小康/n 社会/n 而/cc 奋斗/vi ",
  		NLPIR_ParagraphProcess($s).force_encoding('utf-8')
  	assert_equal "坚定不移 沿着 中国 特色 社会主义 道路 前进 , 为 全面 建成 小康 社会 而 奋斗 ",
  		NLPIR_ParagraphProcess($s,NLPIR_FALSE).force_encoding('utf-8')	
  	
  	NLPIR_Exit()

  end

  def test_process_paragraph_with_PKU_POS_MAP_SECOND
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	NLPIR_SetPOSmap(PKU_POS_MAP_FIRST)
  	assert_equal "坚定不移/v 沿着/p 中国/n 特色/n 社会主义/n 道路/n 前进/v ,/w 为/v 全面/a 建成/v 小康/n 社会/n 而/c 奋斗/v ",
  		NLPIR_ParagraphProcess($s).force_encoding('utf-8')

  	NLPIR_Exit()

  end

  def test_process_paragraphA
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	assert_equal 15,
  		NLPIR_ParagraphProcessA($s).size

  	NLPIR_Exit()
  end

  def test_process_paragraphAW
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	assert_equal 15,
  		NLPIR_ParagraphProcessAW($s).size

  	NLPIR_Exit()
  end

  def test_userDict
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	#puts NLPIR_AddUserWord("1989年春夏之交的政治风波  n")
  	NLPIR_ParagraphProcess("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
  	
    #puts NLPIR_DelUsrWord("1989年春夏之交的政治风波")
  	
  	NLPIR_Exit()
  end
  def test_ImportUserDict
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	assert_equal 5,
  		NLPIR_ImportUserDict("./userdict.txt")
      NLPIR_SaveTheUsrDic()
    puts NLPIR_ParagraphProcess("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
  	
  	NLPIR_Exit()
  end
  def test_process_file
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	NLPIR_FileProcess("./test.txt", "./test_result.txt", NLPIR_TRUE)
  	assert_equal 18395,
  		File.open("./test_result.txt").size
  	
  	NLPIR_Exit()
  end

  def test_words_count
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	assert_equal 15,
  		NLPIR_GetParagraphProcessAWordCount($s)
  	
  	NLPIR_Exit()
  end

  def test_GetKeyWords
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	assert_equal "屌丝/n_new/10.19  球迷/n/2.43  开始/v/1.74  百度/nz/1.73  网络/n/1.39  自嘲/vi/1.39  ",
  		NLPIR_GetKeyWords($text, 50,NLPIR_TRUE).force_encoding('utf-8')
  	
  	NLPIR_Exit()
  end

  def test_GetKeyWords_form_file
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	assert_equal "屌丝/n_new/15.12  网民/n_new/6.66  解构/n_new/5.27  ",
  		NLPIR_GetFileKeyWords("./test.txt",2, NLPIR_TRUE).force_encoding('utf-8')
  	
  	NLPIR_Exit()
  end

  def test_find_NewWords
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	assert_equal "屌丝/n_new/10.19  ",
  		NLPIR_GetNewWords($text, 50, NLPIR_TRUE).force_encoding('utf-8')
  	
  	NLPIR_Exit()
  end

  def test_fin_NewWords_from_file
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	assert_equal "屌丝/n_new/15.12  网民/n_new/6.66  解构/n_new/5.27  阿Q/n_new/4.99  网络亚文化/n_new/4.16  贴吧/n_new/3.33  群体自嘲/n_new/3.33  身份卑微/n_new/3.33  ",
  		NLPIR_GetFileNewWords("./test.txt", 50, NLPIR_TRUE).force_encoding('utf-8')
  	
  	NLPIR_Exit()
  end

  def test_get_finger_print
  	NLPIR_Init(nil, UTF8_CODE ,File.expand_path("../", __FILE__))
  	
  	assert_equal 499666667,
  		NLPIR_FingerPrint($text)
  	
  	NLPIR_Exit()
  end

end