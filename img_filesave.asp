
<!--#include file="img_upload_module.asp"-->
<%   '�ϴ��ļ�, �ļ���Ϊ�����

set gsImgUpload = new upload_gs  '����������ϴ���
'set img1 = gsImgUpload.file("img_upload")  '���ļ��ύ'
upload_path = "upload_img/"

'--------��ȡ���з��ļ����ı���Ϣ---------'
for each formName in gsImgUpload.objForm    
	response.write formName & "=" & gsImgUpload.form(formName) & "<br>"
next 
'-------------------------------------'

'----------test------------'
' response.write img1.filename & " �ļ��� <br>"
' response.write img1.FileSize & " ��С <br>"
' response.write img1.filepath & " ·�� <br>"
' response.write gsImgUpload.form("abc") & " text <br>"
' response.write gsImgUpload.version & "<br>"
' response.write server.MapPath(upload_path & img1.filename) & "<br>"


set fso1 = server.createobject("scripting.FileSystemObject")

' if fso1.fileExists(server.MapPath(upload_path & img1.filename)) then '�ж��ļ��Ƿ����'
' 	response.write "�ļ��Ѵ���"
' else
' 	img1.SaveAs server.MapPath(upload_path & img1.filename)
' end if

'-------------���ļ��ύ-------------'
for each file_form in gsImgUpload.objfile
	set img = gsImgUpload.file(file_form)
	if img.filesize>0 then
		if fso1.fileExists(server.MapPath(upload_path & file_form & img.fileExt)) then
			response.write "�ļ��Ѵ���<br>"
		else
			img.SaveAs server.MapPath(upload_path & file_form & "." & img.fileExt)
			response.write "�ϴ�" & file_form & "." & img.fileExt & "�ɹ�<br>"
		end if
	end if
	set img = nothing
next
'----------------------------------'

set gsImgUpload = nothing
'--------------------------'

' if img1.filename = "" then
'     'response.Write("<script language='javascript'>alert('û��ѡ���ļ�');</script>")
' 	hasError = true
' else
' 	fileExt = Lcase(right(img1.filename,3))
'       if fileExt<>"jpg" and fileExt<>"png" and fileExt<>"gif" then
' 	     response.Write("ֻ֧���ϴ��� jpg/png/gif ��β��ͼƬ")
' 		 response.Write("<input type='button' value='����' onClick=location.href='img_upload.html';>")
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
' 	response.write "�ϴ�ͼƬʧ�ܣ��ļ�Ϊ��"
' else
' 	response.Write("�ϴ�ͼƬ�ɹ�(" & UPfilename & ")<br />")
' end if
%>

