# Nlpir

A rubygem wrapper of chinese segment tools ICTCLAS2014 [NLPIR](https://github.com/NLPIR-team/NLPIR)

[http://www.nlpir.org/](http://www.nlpir.org/)

version 1.0.0 All bugs fixed, support userdict perfectly. for X64 [here](https://github.com/JoeWoo/nlpir_x64)


## Installation

Add this line to your application's Gemfile:

    gem 'nlpir'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nlpir

## Usage


some DEFINE you may use :
```ruby

	  NLPIR_FALSE = 0
	  NLPIR_TRUE = 1
	  POS_MAP_NUMBER = 4
	  ICT_POS_MAP_FIRST = 1         #计算所一级标注集
	  ICT_POS_MAP_SECOND = 0        #计算所二级标注集
	  PKU_POS_MAP_SECOND = 2        #北大二级标注集
	  PKU_POS_MAP_FIRST = 3	        #北大一级标注集
	  POS_SIZE = 40
	
	  #词条结构体 term struct
	  Result_t = struct ['int start','int length',"char  sPOS[#{POS_SIZE}]",'int iPOS',
	  		          'int word_ID','int word_type','double weight']

	  GBK_CODE = 0                              #GBK编码
	  UTF8_CODE = GBK_CODE + 1                  #UTF8编码
	  BIG5_CODE = GBK_CODE + 2                  #BIG5编码
	  GBK_FANTI_CODE = GBK_CODE + 3             #GBK编码，包含繁体字

```

after you gem install it:
##ruby-style func
```ruby
	require 'nlpir'
		include Nlpir

		s = "坚定不移沿着中国特色社会主义道路前进  为全面建成小康社会而奋斗"
		#first of all : Call the NLPIR API nlpir_init
		
		nlpir_init(File.expand_path("../", __FILE__),UTF8_CODE)

		#example1:   Process a paragraph, and return the result text with POS or not
		 puts text_proc(s, NLPIR_TRUE)
		 puts text_proc(s, NLPIR_FALSE)
		
		#example2:   Process a paragraph, and return an array filled elements are POSed words.
		#tips: text_procA() return the array, and its memory is malloced by NLPIR, it will be freed by nlpir_exit() (memory in server)
		
		words_list = text_procA(s)
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
		  puts  "No.#{i}:start:#{a.start}, length:#{a.length}, POS_ID:#{a.sPOS},word_ID:#{a.word_ID},word_type:#{a.word_type} , UserDefine:#{sWhichDic}, Word:#{s.byteslice(a.start,a.length)}, Weight:#{a.weight}\n"
		  i += 1 
		end
		
		#example3:   Process a paragraph, and return an array filled elements are POSed words.
		#tips: text_procAW() return the array, and its memory is malloced by ruby::fiddle,and be collect by GC (memory in agent)
		
		words_list = text_procAW(s)
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
		  puts  "No.#{i}:start:#{a.start}, length:#{a.length}, POS_ID:#{a.sPOS},word_ID:#{a.word_ID},word_type:#{a.word_type} , UserDefine:#{sWhichDic}, Word:#{s.byteslice(a.start,a.length)}, Weight:#{a.weight}\n"
		  i += 1 
		end

		#example4:   Process a text file, and wirte the result text to file
		 puts file_proc("./test.txt", "./test_result.txt", NULL)


		#example5:   Get ProcessAWordCount, it returns the count of the words
		 puts count = file_wordcount(s)



		#example6:   Add/Delete a word to the user dictionary (the path of user dictionary of the path is ./data/userdict.dpat)
		 puts text_proc("我们都是爱思客")
			#add a user word
		 add_userword("都是爱思客 n")
		 add_userword("思客 n")
		 add_userword("你是 n")
		 add_userword("都是客 n")
		 add_userword("都是爱 n")
		 puts text_proc("我们都是爱思客")
			#save the user word to disk
		 save_userdict()
		 puts text_proc("我们都是爱思客")
			#delete a user word
		 del_userword("都是爱思客")
		 save_userdict()
		 puts text_proc("我们都是爱思客")

		
		#example7:   Import user-defined dictionary from a text file. and puts NLPIR result
		 puts text_proc("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
		 puts import_userdict("./userdict.txt")
		 	#you can see the example file: ./userdict.txt to know the userdict`s format requirements
		 save_userdict()
		 puts text_proc("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
		 

		#example8:   Get keywords of text
			#2nd parameter is the MaxNumber of keywords
			#3rd parameter is a swith to show the WeightOut or not  
		 puts text_keywords(s, 50,NLPIR_TRUE)


		#example9:   Get keywords from file
		 puts file_keywords("./test.txt",50, NLPIR_TRUE)


		#example10:   Find new words from text
		 puts text_newwords(s, 50, NLPIR_TRUE)


		#example11:   Find new words from file
		 puts file_newwords("./test.txt")


		#example12:   Extract a finger print from the paragraph 
		 puts text_fingerprint(s)


		#example13:   select which pos map will use  
			#ICT_POS_MAP_FIRST             #//计算所一级标注集
			#ICT_POS_MAP_SECOND        #//计算所二级标注集
			#PKU_POS_MAP_SECOND        #//北大二级标注集
			#PKU_POS_MAP_FIRST            #//北大一级标注集
		 setPOSmap(ICT_POS_MAP_FIRST)
		 puts text_proc(s)
		 setPOSmap(PKU_POS_MAP_FIRST)
		 puts text_proc(s)



		# 新词发现批量处理功能
		#以下函数为2013版本专门针对新词发现的过程，一般建议脱机实现，不宜在线处理
		#  新词识别完成后，再自动导入到分词系统中，即可完成

		NWI_start() #启动新词发现功能
		f=File.new("test.txt", "r")
		text=f.read
		NWI_addfile(text)#添加新词训练的文件，可反复添加
		NWI_complete()#添加文件或者训练内容结束
		f.close() 
		puts NWI_result()#输出新词识别结果
		#puts file_proc("a.txt","b.txt")
		NWI_result2userdict()#新词识别结果导入到用户词典


		#at the end call NLPIR_Exit() to free system materials
		nlpir_exit()


```
##c-style func

```ruby
		
		require 'nlpir'
		include Nlpir

		s = "坚定不移沿着中国特色社会主义道路前进  为全面建成小康社会而奋斗"
		#first of all : Call the NLPIR API NLPIR_Init
		
		NLPIR_Init(nil, UTF8_CODE , File.expand_path("../", __FILE__))

		#example1:   Process a paragraph, and return the result text with POS or not
		 puts NLPIR_ParagraphProcess(s, NLPIR_TRUE)
		 puts NLPIR_ParagraphProcess(s, NLPIR_FALSE)
		
		#example2:   Process a paragraph, and return an array filled elements are POSed words.
		#tips: NLPIR_ParagraphProcessA() return the array, and its memory is malloced by NLPIR, it will be freed by NLPIR_Exit() (memory in server)
		
		words_list = NLPIR_ParagraphProcessA(s)
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
		  puts  "No.#{i}:start:#{a.start}, length:#{a.length}, POS_ID:#{a.sPOS},word_ID:#{a.word_ID},word_type:#{a.word_type} , UserDefine:#{sWhichDic}, Word:#{s.byteslice(a.start,a.length)}, Weight:#{a.weight}\n"
		  i += 1 
		end
		
		#example3:   Process a paragraph, and return an array filled elements are POSed words.
		#tips: NLPIR_ParagraphProcessAW() return the array, and its memory is malloced by ruby::fiddle,and be collect by GC (memory in agent)
		
		words_list = NLPIR_ParagraphProcessAW(s)
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
		  puts  "No.#{i}:start:#{a.start}, length:#{a.length}, POS_ID:#{a.sPOS},word_ID:#{a.word_ID},word_type:#{a.word_type} , UserDefine:#{sWhichDic}, Word:#{s.byteslice(a.start,a.length)}, Weight:#{a.weight}\n"
		  i += 1 
		end

		#example4:   Process a text file, and wirte the result text to file
		 puts NLPIR_FileProcess("./test.txt", "./test_result.txt", NULL)


		#example5:   Get ProcessAWordCount, it returns the count of the words
		 puts count = NLPIR_GetParagraphProcessAWordCount(s)


		#example6:   Add/Delete a word to the user dictionary (the path of user dictionary is ./data/userdict.dpat)
		 puts NLPIR_ParagraphProcess("我们都是爱思客")
			#add a user word
		 NLPIR_AddUserWord("都是爱思客 n")
		 puts NLPIR_ParagraphProcess("我们都是爱思客")
			#save the user word to disk
		 NLPIR_SaveTheUsrDic()
		 puts NLPIR_ParagraphProcess("我们都是爱思客")
			#delete a user word
		 NLPIR_DelUsrWord("都是爱思课")
		 	#save the change to disk
		 NLPIR_SaveTheUsrDic()

		
		#example7:   Import user-defined dictionary from a text file. and puts NLPIR result
		 puts NLPIR_ParagraphProcess("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
		 puts NLPIR_ImportUserDict("./userdict.txt")
		  NLPIR_AddUserWord("1989年春夏之交的政治风波 n")
		 	#you can see the example file: ./test/userdict.txt to know the userdict`s format requirements
		 puts NLPIR_ParagraphProcess("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
		 NLPIR_DelUsrWord("1989年春夏之交的政治风波")
		 puts NLPIR_ParagraphProcess("1989年春夏之交的政治风波1989年政治风波24小时降雪量24小时降雨量863计划ABC防护训练APEC会议BB机BP机C2系统C3I系统C3系统C4ISR系统C4I系统CCITT建议")
	

		#example8:   Get keywords of text
			#2nd parameter is the MaxNumber of keywords
			#3rd parameter is a swith to show the WeightOut or not  
		 puts NLPIR_GetKeyWords(s, 50,NLPIR_TRUE)


		#example9:   Get keywords from file
		 puts NLPIR_GetFileKeyWords("./test.txt",50, NLPIR_TRUE)


		#example10:   Find new words from text
		 puts NLPIR_GetNewWords(s, 50, NLPIR_TRUE)


		#example11:   Find new words from file
		 puts NLPIR_GetFileNewWords("./test.txt")


		#example12:   Extract a finger print from the paragraph 
		 puts NLPIR_FingerPrint(s)


		#example13:   select which pos map will use  
			#ICT_POS_MAP_FIRST             #//计算所一级标注集
			#ICT_POS_MAP_SECOND        #//计算所二级标注集
			#PKU_POS_MAP_SECOND        #//北大二级标注集
			#PKU_POS_MAP_FIRST            #//北大一级标注集
		 NLPIR_SetPOSmap(ICT_POS_MAP_FIRST)
		 puts NLPIR_ParagraphProcess(s)
		 NLPIR_SetPOSmap(PKU_POS_MAP_FIRST)
		 puts NLPIR_ParagraphProcess(s)



		# 新词发现批量处理功能
		#以下函数为2013版本专门针对新词发现的过程，一般建议脱机实现，不宜在线处理
		#  新词识别完成后，再自动导入到分词系统中，即可完成

		NLPIR_NWI_Start() #启动新词发现功能
		NLPIR_NWI_AddFile("./text.txt")#添加新词训练的文件，可反复添加
		NLPIR_NWI_Complete()#添加文件或者训练内容结束
		puts NLPIR_NWI_GetResult().to_s#输出新词识别结果 可传入一个参数NLPIR_TRUE或NLPIR_FALSE，用于是否输出词性
		#puts NLPIR_FileProcess("a.txt","b.txt")
		NLPIR_NWI_Result2UserDict()#新词识别结果导入到用户词典


		#at the end call NLPIR_Exit() to free system materials
		NLPIR_Exit()

```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
