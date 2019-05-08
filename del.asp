<!--#include file="conn.asp" -->
<% 
Dim rs,sql,delid
delid = Trim(Request.QueryString("delid"))
set rs = Server.CreateObject("adodb.recordset")
sql = "delete * from stucj where id=" & delid
conn.execute(sql)
response.Redirect("admin.asp")
%>
 
<% Call CloseConn() %>