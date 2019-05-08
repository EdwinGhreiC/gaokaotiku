<!--#include file="conn.asp" -->
<!--#include file="config.asp" -->
<!--#include file="function.asp" -->
<% page_title = "每日排行" %>
<!--#include file="header.asp"-->
<style type="text/css">
body {
	font-family: Arial, Verdana, "微软雅黑", "宋体";
	font-size: 10.5pt;
	color: #333;
}

.flunk-text {
  color: #d44950;
}
</style>
</head>

<body>
<% 
majorID = trim(request.querystring("mid"))   '专业 ID， 在多班级时可以从 url 获取
if majorID = "" then majorID = 1   '默认为1，计算机班'

dateDiffValue = val(trim(request.querystring("ddv")))
dim rs,sql,px
px = Trim(Request.QueryString("px"))
set rs = Server.CreateObject("adodb.recordset")
set rs2 = Server.CreateObject("adodb.recordset")
sql = "SELECT top 40 sname,max(score) as max_score,avg(score) as avg_score FROM Stu inner join stucj on stu.id=stucj.stuid where grade<4 and score>0 and stu.majorid=" & majorID & " and dateDiff('d',tjsj,date())=" & dateDiffValue & " group by sname"   '仅取出当日记录'
if px = "xm" then     '按分数降序
    sql = sql & " order by sname"
else
    sql = sql & " order by avg(score) desc"
end if
rs.open sql,conn,1,1 
 %>
<table  class="table table-striped" width="600" align="center" >
  <tr>
    <th colspan="4" class="text-center">本日最佳排名</th>
  </tr>
  <tr>
    <td align="center">排名</td>
    <td align="center">姓名</td>
    <td align="center">平均分</td>
    <td align="center">最高分</td>
  </tr>
<%i=1 
  Do while not rs.eof %>
  <tr>
    <td align="center"><%=i%></td>
    <td align="center"><%= rs("sname") %><% if i=1 then %><span class="text-danger">（当日最佳）</span><% end if %></td>
    <td align="center"><span style="font-weight:600"><%= cint(rs("avg_score")*100+0.5)/100 %></span></td>
    <td align="center"><%= rs("max_score") %></td>
  </tr>
<% rs.movenext
   i=i+1
   Loop
   rs.close
%>



</table>

<br><br><br>
<table class="table table-striped" width="600" align="center">
    <tr>
      <th colspan="3" class="text-center"><span class="flunk-text">本日未达标名单（次数小于<%=countLevel%>次或平均分低于<%=avgLevel%>分）</span></th>
    </tr>
    <tr>
      <td align="center">姓名</th>
      <td align="center">做题次数</th>
      <td align="center">平均分</th>
    </tr>
<%
    sql = "select sname, count(score), avg(score) from stu left join stucj on (stu.grade<4 and stu.id=stucj.stuid and stu.majorID=" & majorID & " and stu.classid=" & classID & " and dateDiff('d',stucj.tjsj,date())=" & dateDiffValue & " and score>0) group by sname having count(score)<" & countLevel & " or avg(score)<" & avgLevel & " order by avg(score) desc"     '2018-3-7 添加 score>0 的筛选项，防止0分卷提交查看答案重复提交 '
    '选出姓名，做题次数，平均分，left join 没做的 count 为0，筛选班级，筛选当日数据'
    rs2.open sql,conn,1,1
    i=1
    do until rs2.eof %>
    <tr>
      <td align="center"><%=i%>. <%=rs2(0)%></td>
      <td align="center"><%=rs2(1)%></td>
      <td align="center"><%=int(rs2(2)*100+0.5)/100%></td>
    </tr>
<%  
    rs2.movenext
    i=i+1
    loop
%>
</table>

<p align="center"><a href="index.asp" class="btn btn-primary btn-block">返回</a></p>
<% 
   set rs = nothing
   set rs2 = nothing
   Call CloseConn()
 %>
<!--#include file="footer.asp"-->