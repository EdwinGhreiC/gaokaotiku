<!--#include file="conn.asp" -->
<!--#include file="checkadmin.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<meta http-equiv="x-ua-compatible" content="ie=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
<title>查看成绩</title>
<style type="text/css">
<!--
body {
	font-family: Arial, Verdana, "微软雅黑", "宋体";
	font-size: 10.5pt;
	color: #333;
}
-->
</style>
</head>

<body>
<% 
dim rs,sql,px
px = Trim(Request.QueryString("px"))
set rs = Server.CreateObject("adodb.recordset")
if px = "jx" then     '按分数降序
   sql = "SELECT * FROM Stu inner join stucj on stu.id=stucj.stuid order by score desc"
elseif px = "sj" then   '按时间先后降序
   sql = "SELECT * FROM Stu inner join stucj on stu.id=stucj.stuid order by tjsj desc"
else
   sql = "SELECT * FROM Stu inner join stucj on stu.id=stucj.stuid order by stucj.id"
end if
rs.open sql,conn,1,1 
 %>
<table  class="table table-striped" width="600" align="center" >
  <tr>
    <td height="27" align="center"><a href="admin.asp?px=sj">时间</a></td>
    <td align="center">姓名</td>
    <td align="center"><a href="admin.asp?px=jx">得分</a></td>
    <td align="center">题目字符串</td>
    <td align="center" colspan=2>操作</td>
  </tr>
<% Do while not rs.eof %>
  <tr>
    <td height="25" align="center"><%= rs("tjsj") %></td>
    <td align="center"><%= rs("sname") %></td>
    <td align="center"><%= rs("score") %></td>
    <td align="center"><%= left(rs("tknostr"),5) & right(rs("tknostr"),5) %></td>
    <td align="center"><a href="del.asp?delid=<%= rs("stucj.id") %>">删除</a></td>
	<td align="center"><a href="singleReset.asp?stuid=<%=rs(0)%>">重考</a></td>
  </tr>
<% rs.movenext
   Loop %>

</table>
<p align="center"><a href="index.asp" class="btn btn-primary btn-block">返回</a></p>
<% 
   rs.close
   set rs = nothing
 %>
</body>
</html>
<% Call CloseConn() %>