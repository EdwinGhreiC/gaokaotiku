<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<!--#include file="header.asp"-->
<%
set rs = server.createobject("adodb.recordset")
sql = "select * from simexam order by examtime asc"
rs.open sql,conn,1,1

tag = trim(request.querystring("tag"))
if tag = "add-success" then
	response.write "<p class='text-success'><strong>Ìí¼Ó³É¹¦</strong></p>"
end if

response.write "<ul class='list-group'>"
do while not rs.eof
	response.write "<li class='list-group-item'>" & rs("id") & ". " & rs("ename") & "</li>"
	rs.movenext
loop
response.write "</ul>"
rs.close
set rs = nothing


%>