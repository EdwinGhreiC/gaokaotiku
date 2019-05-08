<!--#include file="conn.asp" -->
<% 
Dim sql
sql = "Update Stu set loginstatus=0 where id=" & trim(request.querystring("stuid"))
conn.execute(sql)
response.Redirect("admin.asp")
%>
 
<% Call CloseConn() %>