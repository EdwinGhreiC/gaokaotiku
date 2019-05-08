<!--#include file="conn.asp" -->
<%
Dim sql,stuid
stuid = session("sjtk_stuid")
if stuid<>"" then
    sql = "Update Stu set loginstatus=0 where id=" & stuid    '状态重置为0
    conn.execute(sql)
    sql = "delete from stutest where stuid=" & stuid          '删除原先生成的题目
    conn.execute(sql)
    session("sjtk_loginstatus") = 0
    response.Redirect("index.asp")
end if
%>

<% Call CloseConn() %>
