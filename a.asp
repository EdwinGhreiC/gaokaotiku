<!--#include file="conn.asp" -->
<%
'Ôö¼Ó±í'
sql="create table stucj_chapter(id counter primary key,stuid long default 0,score single default 0,tjsj time default now(),tknostr memo,tmdastr memo,chapterID long default 0)"
conn.execute(sql)
%>
<%
' dim rs,sql,i,j,sql2
' set rs= Server.CreateObject("adodb.recordset")
' j=1
' for i=10424 to 10929
' sql2="select ntmbh from tk where ntmbh=" & i
' rs.open sql2,conn,1,1
'    if not rs.eof then
'       sql="update tk set no=" & j & " where ntmbh=" & i
'       conn.execute(sql)
'       j=j+1
'    end if
' rs.close
' next 

' for i=36 to 100
' 	sql = "insert into simexamtk(sn) values(" & i & ")"
' 	conn.execute(sql)
' next

' set rs=nothing


' Set Jpeg = Server.CreateObject("Persits.Jpeg")
' Response.Write Jpeg.Expires
%>