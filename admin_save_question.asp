<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->
<!--#include file="img_upload_module.asp"-->

<%  
	set questionUpload = new upload_gs  '����������ϴ���
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

				Czqda = ucase(replace(replace(wordInput(questionUpload.form("zqda"))," ",""),",",""))  '��ȷ�𰸣��滻�ո�Ͷ���
				chapter = val(server.htmlencode(trim(questionUpload.form("chapter"))))
				info = wordinput(questionUpload.form("tmfx"))   '��Ŀ����˵��				

				someOneIsNull = false
				if Ctm <> "" and Czqda <> "" then  '�ж��ύ�Ƿ�Ϊ��'

					set rsRepeat = conn.execute("select count(*) from tk where ctm like '%" & Ctm & "%'")
					if rsRepeat(0)>0 then    '�ж���Ŀ�Ƿ��Ѵ���'
						isReped = true
					else   '��Ŀ�����ڣ���ʼ�����ļ����ύ����'
						isReped = false
						'----------------�����ϴ��ļ�----------------'
						set fso1 = server.createobject("scripting.FileSystemObject")

						Randomize
						uploadFileName = "q" & year(now) & month(now) & day(now) & hour(now) & minute(now) & second(now) & cint(9000*rnd+1000)  '�ļ�����������ʱ���뼰4λ����������'
						
						for each file_form in questionUpload.objFile
							uploadFilePath = uploadFileName   '���·���������� HTML ����ʾͼƬ
							set img = questionUpload.file(file_form)
							fileExt = lcase(right(img.filename,3))
							if fileExt = "jpg" or fileExt = "png" or fileExt = "gif" then
								if img.fileSize > 0 then
																			
									select case file_form

										case "img_question" 
											uploadFilePath = uploadFilePath       '' & "." & fileExt
											qImgHtml = "[img]" & upload_folder & uploadFilePath & "[/img]"	

										case "img_question_op_a"   '����������Сд�������ж�һֱ����'
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

									'�����ļ�, ����·��'
									absolutePath = server.mapPath(upload_folder & uploadFilePath & ".jpg") 
									img.saveAs absolutePath     '����ͼƬ'
									response.write "<span style='color: #fff'>�ļ�����ɹ���" & uploadFilePath & "; </span>"
									compressImage absolutePath,IMG_LENGTH  'ѹ��ͼƬ'
									img_urls = img_urls & "|" & uploadFilePath
									
									
								end if
							else
								imgUploadErrMsg = "ֻ���ϴ� jpg/png/gif ��β���ļ�"
							end if
						next

						if img_urls <> "" then 
							img_urls = mid(img_urls,2)  'ȥ����ǰ��� | '
						else
							img_urls = " "
						end if

						Ctm = Ctm & chr(13) & chr(10) & qImgHtml   '����ҳ����ʾͼƬ'
						Ctmda_A = wordInput(Ctmda_A) & " " & qImgHtml_A & chr(13) & chr(10)
						Ctmda_B = wordInput(Ctmda_B) & " " & qImgHtml_B & chr(13) & chr(10)
						Ctmda_C = wordInput(Ctmda_C) & " " & qImgHtml_C & chr(13) & chr(10)
						Ctmda_D = wordInput(Ctmda_D) & " " & qImgHtml_D
						'------------------------------------------'

						Ctmda = Ctmda_A & Ctmda_B & Ctmda_C & Ctmda_D  'ѡ��

						set rs = Server.CreateObject("adodb.recordset") 
						sql = "select * from tk where ctm like '%" & Ctm & "%'"
						rs.open sql,conn,1,3
						
						rs.addnew   '��ȷ���������ظ����Ͳ����¼�¼'
						rs("Ctm") = Ctm     '��Ŀ����
						rs("Ctmda") = Ctmda   '��Ŀѡ��
						rs("Czqda") = Czqda   '��ȷ��
						rs("class") = question_type   '��Ŀ����
						rs("chapter") = chapter      '��Ŀ�����½�
						rs("info") = info
						rs("inputerID") = val(session("sjtk_stuid"))    '¼���� ID
						rs("majorID") = session("majorID")       '����רҵ
						rs("imgUrls") = img_urls
						rs.update
						 
						rs.close  
						set rs = nothing						
					
					end if

				else
					someOneIsNull = True
				End if 

			sessionIdIsNull = False

			session("input_time") = timer     '��ֹ���˹����ύ
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
			
			<div><h3>�ύ���죡</h3><a href="javascript:history.go(-1)">����</a></div>

		<% elseif isReped then %>

			<div><h3>��Ŀ�Ѵ��ڣ�</h3><a href="javascript:history.go(-1)">����</a></div>

		<% else %>

			<% if someOneIsNull then %>
				
				<div><h3>ĳһ��Ϊ�գ����ܱ�����Ŀ</h3><a href="javascript:history.go(-1)">����</a></div>
			
			<% else %>

				<% if not sessionIdIsNull then %>
				<div><h2>��¼����Ŀ��</h2></div>
				<div>
					<%=replace(ubbToHtml(Ctm,"img"),chr(13),"<br>")%>
				</div>
				
				<hr>

				<% if question_type <> 2 then '��������ж������ʾ��ѡ�� %>
				<div>
					<%=replace(ubbToHtml(Ctmda,"img"),chr(13),"<br>")%>
				</div>
				<% end if %>
				
				<hr>

				<div>��ȷ�𰸣�<%=Czqda%></div>
				<% if session("majorID") = 1 then %>
				<div>�����½ڣ�<%=chapter%></div>
				<% end if %>
				<div> </div>
				<hr>
				<div><a href="admin_add_tklr.asp?qtp=<%=question_type%>">����¼����Ŀ</a></div>
				<% else %>
				<div>
					 ��¼��ʱ��������<a href="login.asp" target="_blank">��¼</a>
				</div>
				<% end if %>

			<% end if %>
		<% end if %>
	</div>

<!--#include file="footer.asp"-->

