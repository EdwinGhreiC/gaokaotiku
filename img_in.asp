<!--#include file="conn.asp"-->
<!--#include file="img_upload_module.asp"-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>����Excel</title>
</head>

<body>
<!--#include file="excel_filesave.asp"-->
<%
dim conn_excel,conn_excel_str,rsexcel,sqlexcel,sqlexceldel,classid,courseid,rsexcel_table,i,rsexcelrepeat,teacherid,rscheck,isSusccess
isSusccess = 0    '��������ǵ���ɹ����ı�־
'------------������Excel������-------------------
Set conn_excel = Server.CreateObject("adodb.connection")  
'response.Write(server.MapPath("upload_excel/Student.xls"))
conn_excel_str = "Provider=Microsoft.Jet.OLEDB.4.0;Extended Properties='Excel 8.0;HDR=YES;IMEX=1';Data Source=" & Server.MapPath(UPfilename)
'Ҫ����xslx ����� "Provider=Microsoft.Ace.OLEDB.12.0;Extended Properties='Excel 12.0;HDR=YES;IMEX=1';Data Source=" & Server.MapPath("upload_excel\Student.xls")
conn_excel.open conn_excel_str
'---------------------------------------------------
'set rsexcel = Server.CreateObject("Adodb.recordset")  '��仰���˷�������, ����ʹ��movenext
set rsexcel = conn_excel.OpenSchema(20)       '  adSchemaTables=20    ȡ�ý����ĵ�һ�ű���, �����������ѯ 
classid = Trim(gsexcelupload.Form("tclsid"))
courseid = Trim(gsexcelupload.Form("tcrsid"))
'--------��ʼ��֤��ʦ�Ƿ���Ȩ�޵���------------
if Session("id")="" then
   Response.Write "��¼��ʱ"
   Response.End()
end if
teacherid = Session("id")
set rscheck = conn.execute("select  id from teacher_courses where teacher_id=" & teacherid & " and teacher_classid=" & classid & " and teacher_courseid=" & courseid)
if rscheck.eof then
   Response.Write("����ʧ��, �ƺ���û�е����Ȩ��")
   Response.End()
end if
'--------������֤

set  rsexcel_table =  Server.CreateObject("Adodb.recordset")
'response.Write rsexcel.recordcount
'rsexcel.move(2)   '�ƶ�n����¼
response.write(rsexcel("table_name") & "<br />")    '�����movenext, ����ѭ��, ȡ�õľ��ǵ�һ�ű�

 rsexcel_table.open "Select * from [" & rsexcel("table_name") & "]",conn_excel,1,1
set  rsexcelrepeat =  Server.CreateObject("Adodb.recordset")

for i=1 to rsexcel_table.recordcount
		'response.write(rsexcel_table("�ɼ�") & "&nbsp;")  ������
	if isnumeric(rsexcel_table("id"))=True and isnumeric(rsexcel_table("�ɼ�"))=True and rsexcel_table("�ɼ�")<>"" then
		rsexcelrepeat.open "Select * from score_05_2_qimo where studentid=" & rsexcel_table("id") & " and classid=" & classid & " and courseid=" & courseid,conn,1,1    '�ж�Ҫ����ļ�¼�Ƿ��Ѵ���
			if not rsexcelrepeat.eof then
				sqlexcel = "update score_05_2_qimo set score3=" & cint(rsexcel_table("�ɼ�")) & " where id =" & rsexcelrepeat("id")  '�����¼����, �����
			else 
				sqlexcel = "insert into score_05_2_qimo(studentid,classid,courseid,score3) values(" & rsexcel_table("ID") & "," & classid & "," & courseid & "," & cint(rsexcel_table("�ɼ�")) & ")"  ' �����¼������������¼�¼
			end if
		conn.execute(sqlexcel)
		rsexcelrepeat.close
		rsexcel_table.movenext
	else   ' ���벻����ô��
		Response.Write("�ɼ�δ���룬�����ǳɼ�Ϊ�ջ������ʽ���� <br /> <strong>λ��:  " & rsexcel_table("id") & "     " & rsexcel_table("ѧ������") & "     " & rsexcel_table("�ɼ�") & "</strong><br />")
		rsexcel_table.movenext
		isSusccess = 1
	end if
next
if isSusccess=0 then
   response.Write("����ɹ�<br /> <input type='button' value='�رմ���' onClick='window.close();'>")   'ֻ�ܹر�target:_blank�򿪵Ĵ���
elseif isSusccess=1 then
   response.write("�������<br /> <input type='button' value='�رմ���' onClick='window.close();'>")
end if

rsexcel_table.close
conn_excel.close

set rsexcel_table = nothing
set rsexcelrepeat = nothing
set rsexcel = nothing
set conn_excel = nothing
%>
<script language=javascript>
if(window.opener&&window.opener.refreshit)
 window.opener.refreshit();  //��ҳ��ˢ��, ��ҳ����Ǵ򿪴�ҳ����������ڵ��Ǹ�ҳ��
</script>
</body>
</html>
