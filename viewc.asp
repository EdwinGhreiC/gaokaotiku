<!--#include file="conn.asp" -->
<!--#include file="function.asp" -->
<% page_title = "�鿴�½���ϰ�ɼ�" %>
<!--#include file="header.asp" -->
<style type="text/css">
<!--
body {
	font-family: Arial, Verdana, "΢���ź�", "����";
	font-size: 10.5pt;
	color: #333;
}
-->
</style>
</head>

<body>
<% 
dim rs,sql,px
dateDiffValue = val(trim(request.querystring("ddv")))
majorID = trim(request.querystring("mid"))
if majorID = "" then majorID = 1
px = trim(request.querystring("px"))
set rs = Server.CreateObject("adodb.recordset")
sql = "SELECT top 800 * FROM Stu inner join stucj_chapter on stu.id=stucj_chapter.stuid where grade<4 and stu.majorID=" & majorID & " and datediff('d',tjsj,now)=" & dateDiffValue
if px = "jx" then     '����������
   sql = sql & " order by score desc"
elseif px = "sj" then   '��ʱ���Ⱥ���
   sql = sql & " order by tjsj desc"
else
   sql = sql & " order by stucj_chapter.id"
end if
rs.open sql,conn,1,1 
 %>
<table  class="table table-striped" width="600" align="center" >
  <tr>
    <td height="27" align="center"><a href="view.asp?px=sj">ʱ��</a></td>
    <td align="center">����</td>
    <td align="center"><a href="view.asp?px=jx">�÷�</a></td>
    <td align="center">�½ں�</td>
    <td align="center">��Ŀ�ַ���</td>
  </tr>
<% Do while not rs.eof %>
  <tr>
    <td height="25" align="center"><%= rs("tjsj") %></td>
    <td align="center"><%= rs("sname") %></td>
    <td align="center"><%= rs("score") %></td>
    <td align="center"><%= rs("chapterID") %></td>
    <td align="center"><%= left(rs("tknostr"),5) & right(rs("tknostr"),5) %></td>
  </tr>
<% rs.movenext
   Loop %>

</table>
<p align="center"><a href="index.asp" class="btn btn-primary btn-block">����</a></p>
<% 
   rs.close
   set rs = nothing
 %>
</body>
</html>
<% Call CloseConn() %>