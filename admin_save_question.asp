<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->
<!--#include file="img_upload_module.asp"-->

<%  
	set questionUpload = new upload_gs  '调用无组件上传类
	upload_folder = "upload_img/"


	question_type = val(questionUpload.form("qtype"))
	if session("sjtk_stuid")<>"" then
		if Timer - session("input_time")>=SUBMIT_MIN_INTERVAL then 			
			
				Ctm = wordInput(questionUpload.form("tmnr"))  
				if question_type = 1 or question_type = 3 then
					Ctmda_A = "A. " & trim(questionUpload.form("A"))
					Ctmda_B = "B. " & trim(questionUpload.form("B"))
					Ctmda_C = "C. " & trim(questionUpload.form("C"))
					Ctmda_D = "D. " & trim(questionUpload.form("D"))
				end if

				Czqda = ucase(replace(replace(wordInput(questionUpload.form("zqda"))," ",""),",",""))  '正确答案，替换空格和逗号
				chapter = val(server.htmlencode(trim(questionUpload.form("chapter"))))
				info = wordinput(questionUpload.form("tmfx"))   '题目分析说明				

				someOneIsNull = false
				if Ctm <> "" and Czqda <> "" then  '判断提交是否为空'

					set rsRepeat = conn.execute("select count(*) from tk where ctm like '%" & Ctm & "%'")
					if rsRepeat(0)>0 then    '判断题目是否已存在'
						isReped = true
					else   '题目不存在，开始保存文件和提交数据'
						isReped = false
						'----------------保存上传文件----------------'
						set fso1 = server.createobject("scripting.FileSystemObject")

						Randomize
						uploadFileName = "q" & year(now) & month(now) & day(now) & hour(now) & minute(now) & second(now) & cint(9000*rnd+1000)  '文件名由年月日时分秒及4位随机数字组成'
						
						for each file_form in questionUpload.objFile
							uploadFilePath = uploadFileName   '相对路径，用于在 HTML 中显示图片
							set img = questionUpload.file(file_form)
							fileExt = lcase(right(img.filename,3))
							if fileExt = "jpg" or fileExt = "png" or fileExt = "gif" then
								if img.fileSize > 0 then
																			
									select case file_form

										case "img_question" 
											uploadFilePath = uploadFilePath       '' & "." & fileExt
											qImgHtml = "[img]" & upload_folder & uploadFilePath & "[/img]"	

										case "img_question_op_a"   '这里必须得是小写，否则判断一直不等'
											uploadFilePath = uploadFilePath & "_A"         '' & fileExt
											qImgHtml_A = "[img]" & upload_folder & uploadFilePath & "[/img]"

										case "img_question_op_b"
												uploadFilePath = uploadFilePath & "_B"     '' & fileExt
												qImgHtml_B = "[img]" & upload_folder & uploadFilePath & "[/img]"

										case "img_question_op_c"
											uploadFilePath = uploadFilePath & "_C"         '' & fileExt
											qImgHtml_C = "[img]" & upload_folder & uploadFilePath & "[/img]"

										case "img_question_op_d" 
											uploadFilePath = uploadFilePath & "_D"         '' & fileExt
											qImgHtml_D = "[img]" & upload_folder & uploadFilePath & "[/img]"

									end select

									'保存文件, 绝对路径'
									absolutePath = server.mapPath(upload_folder & uploadFilePath & ".jpg") 
									img.saveAs absolutePath     '保存图片'
									response.write "<span style='color: #fff'>文件保存成功：" & uploadFilePath & "; </span>"
									compressImage absolutePath,IMG_LENGTH  '压缩图片'
									img_urls = img_urls & "|" & uploadFilePath
									
									
								end if
							else
								imgUploadErrMsg = "只能上传 jpg/png/gif 结尾的文件"
							end if
						next

						if img_urls <> "" then 
							img_urls = mid(img_urls,2)  '去掉最前面的 | '
						else
							img_urls = " "
						end if

						Ctm = Ctm & chr(13) & chr(10) & qImgHtml   '在网页上显示图片'
						Ctmda_A = wordInput(Ctmda_A) & " " & qImgHtml_A & chr(13) & chr(10)
						Ctmda_B = wordInput(Ctmda_B) & " " & qImgHtml_B & chr(13) & chr(10)
						Ctmda_C = wordInput(Ctmda_C) & " " & qImgHtml_C & chr(13) & chr(10)
						Ctmda_D = wordInput(Ctmda_D) & " " & qImgHtml_D
						'------------------------------------------'

						Ctmda = Ctmda_A & Ctmda_B & Ctmda_C & Ctmda_D  '选项

						set rs = Server.CreateObject("adodb.recordset") 
						sql = "select * from tk where ctm like '%" & Ctm & "%'"
						rs.open sql,conn,1,3
						
						rs.addnew   '已确定不存在重复，就插入新记录'
						rs("Ctm") = Ctm     '题目描述
						rs("Ctmda") = Ctmda   '题目选项
						rs("Czqda") = Czqda   '正确答案
						rs("class") = question_type   '题目类型
						rs("chapter") = chapter      '题目所属章节
						rs("info") = info
						rs("inputerID") = val(session("sjtk_stuid"))    '录入者 ID
						rs("majorID") = session("majorID")       '所属专业
						rs("imgUrls") = img_urls
						rs.update
						 
						rs.close  
						set rs = nothing						
					
					end if

				else
					someOneIsNull = True
				End if 

			sessionIdIsNull = False

			session("input_time") = timer     '防止后退过快提交
		else
			submitIsTooFast = True
		end if
	else
		sessionIdIsNull = True
	end if
%>
<!--#include file="header.asp"-->

</head>
<body>
	<div class="container">
		<% if submitIsTooFast then %>
			
			<div><h3>提交过快！</h3><a href="javascript:history.go(-1)">返回</a></div>

		<% elseif isReped then %>

			<div><h3>题目已存在！</h3><a href="javascript:history.go(-1)">返回</a></div>

		<% else %>

			<% if someOneIsNull then %>
				
				<div><h3>某一项为空，不能保存题目</h3><a href="javascript:history.go(-1)">返回</a></div>
			
			<% else %>

				<% if not sessionIdIsNull then %>
				<div><h2>已录入题目：</h2></div>
				<div>
					<%=replace(ubbToHtml(Ctm,"img"),chr(13),"<br>")%>
				</div>
				
				<hr>

				<% if question_type <> 2 then '如果不是判断题就显示候选项 %>
				<div>
					<%=replace(ubbToHtml(Ctmda,"img"),chr(13),"<br>")%>
				</div>
				<% end if %>
				
				<hr>

				<div>正确答案：<%=Czqda%></div>
				<% if session("majorID") = 1 then %>
				<div>所属章节：<%=chapter%></div>
				<% end if %>
				<div> </div>
				<hr>
				<div><a href="admin_add_tklr.asp?qtp=<%=question_type%>">继续录入题目</a></div>
				<% else %>
				<div>
					 登录超时，请重新<a href="login.asp" target="_blank">登录</a>
				</div>
				<% end if %>

			<% end if %>
		<% end if %>
	</div>

<!--#include file="footer.asp"-->

