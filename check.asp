<!--#include file="conn.asp" -->
<!--#include file="function.asp" -->
<% dim username,userpwd,rs,sql
username=fdc(Request.Form("uid"))
userpwd=fdc(Request.Form("pwd"))
set rs = Server.CreateObject("adodb.recordset")
set rsId = Server.CreateObject("adodb.recordset")
response.charset = "gbk"
loginErrMsg = "�û������������!<a href='index.asp'><font color=#FF0000>����</font></a>"
sql="select * from Stu where sname='" & username & "' and pwd='" & userpwd & "'"
rs.open sql,conn,1,1
if not rs.eof and not rs.bof then
		 writeSession rs
         response.Redirect("index.asp")
else
	if isnumeric(username) then   '����������֣���ת��Ϊ id ��¼
		sql = "select * from Stu where id=" & username & " and pwd='" & userpwd & "'"
		rsId.open sql,conn,1,1
		if not rsId.eof and not rsId.bof then
			writeSession rsId
			response.Redirect("index.asp")
		else
			response.write loginErrMsg     'ѧ�����벻��ȷ����¼ʧ��
		end if
	else
		response.write loginErrMsg    '����Ĳ������֣��˺�����Ҳ���ԣ����¼ʧ��
	end if
end if
rs.close
set rs=nothing


%>

<% Call CloseConn() %>
