<!--#include file="conn.asp" -->
<!--#include file="function.asp" -->
<% dim username,userpwd,rs,sql
username=fdc(Request.Form("uid"))
userpwd=fdc(Request.Form("pwd"))
set rs = Server.CreateObject("adodb.recordset")
set rsId = Server.CreateObject("adodb.recordset")
response.charset = "gbk"
loginErrMsg = "用户名或密码错误!<a href='index.asp'><font color=#FF0000>返回</font></a>"
sql="select * from Stu where sname='" & username & "' and pwd='" & userpwd & "'"
rs.open sql,conn,1,1
if not rs.eof and not rs.bof then
		 writeSession rs
         response.Redirect("index.asp")
else
	if isnumeric(username) then   '输入的是数字，则转换为 id 登录
		sql = "select * from Stu where id=" & username & " and pwd='" & userpwd & "'"
		rsId.open sql,conn,1,1
		if not rsId.eof and not rsId.bof then
			writeSession rsId
			response.Redirect("index.asp")
		else
			response.write loginErrMsg     '学号输入不正确，登录失败
		end if
	else
		response.write loginErrMsg    '输入的不是数字，账号密码也不对，则登录失败
	end if
end if
rs.close
set rs=nothing


%>

<% Call CloseConn() %>
