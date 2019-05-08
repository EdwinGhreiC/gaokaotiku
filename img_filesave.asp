
<!--#include file="img_upload_module.asp"-->
<%   '上传文件, 文件名为随机数

set gsImgUpload = new upload_gs  '调用无组件上传类
'set img1 = gsImgUpload.file("img_upload")  '单文件提交'
upload_path = "upload_img/"

'--------获取所有非文件的文本信息---------'
for each formName in gsImgUpload.objForm    
	response.write formName & "=" & gsImgUpload.form(formName) & "<br>"
next 
'-------------------------------------'

'----------test------------'
' response.write img1.filename & " 文件名 <br>"
' response.write img1.FileSize & " 大小 <br>"
' response.write img1.filepath & " 路径 <br>"
' response.write gsImgUpload.form("abc") & " text <br>"
' response.write gsImgUpload.version & "<br>"
' response.write server.MapPath(upload_path & img1.filename) & "<br>"


set fso1 = server.createobject("scripting.FileSystemObject")

' if fso1.fileExists(server.MapPath(upload_path & img1.filename)) then '判断文件是否存在'
' 	response.write "文件已存在"
' else
' 	img1.SaveAs server.MapPath(upload_path & img1.filename)
' end if

'-------------多文件提交-------------'
for each file_form in gsImgUpload.objfile
	set img = gsImgUpload.file(file_form)
	if img.filesize>0 then
		if fso1.fileExists(server.MapPath(upload_path & file_form & img.fileExt)) then
			response.write "文件已存在<br>"
		else
			img.SaveAs server.MapPath(upload_path & file_form & "." & img.fileExt)
			response.write "上传" & file_form & "." & img.fileExt & "成功<br>"
		end if
	end if
	set img = nothing
next
'----------------------------------'

set gsImgUpload = nothing
'--------------------------'

' if img1.filename = "" then
'     'response.Write("<script language='javascript'>alert('没有选择文件');</script>")
' 	hasError = true
' else
' 	fileExt = Lcase(right(img1.filename,3))
'       if fileExt<>"jpg" and fileExt<>"png" and fileExt<>"gif" then
' 	     response.Write("只支持上传以 jpg/png/gif 结尾的图片")
' 		 response.Write("<input type='button' value='返回' onClick=location.href='img_upload.html';>")
' 		 response.End()
' 	  end if
' 	randomize
' 	dim randnumber,UPfilename
' 	randnumber = int(1000000*rnd)+10000
' 	UPfilename = upload_path & randnumber & ".jpg"
' 	if img1.FileSize>0 then
'        img1.SaveAs Server.MapPath(UPfilename)
'     end if
	
' end if

' if hasError then
' 	response.write "上传图片失败，文件为空"
' else
' 	response.Write("上传图片成功(" & UPfilename & ")<br />")
' end if
%>

