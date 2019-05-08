<!--#include file="conn.asp" -->
<!--#include file="config.asp" -->
<!--#include file="function.asp" -->
<% page_title = "每周做题统计" %>
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
startDate = fdc(request.form("startDate"))   '起始日期'
endDate = fdc(request.form("endDate"))       '结束日期'
min_score = 7   '有效次数的最低分数线'


majorID = val(request.querystring("mid"))   '专业 ID， 在多班级时可以从 url 获取
if majorID = 0 then majorID = 1   '默认为1，计算机班'

dateDiffValue = 7  '没输入起始日期的情况下倒推几天'

dim rs,sql
set rs = Server.CreateObject("adodb.recordset")
set rs2 = Server.CreateObject("adodb.recordset")

if startDate <> "" and endDate <> "" then
	sql = "select sname,count(*) from stucj inner join stu on stucj.stuid=stu.id where score>=" & min_score & " and classid=" & majorID & " and tjsj between #" & startDate & "# and #" & endDate & "# group by sname order by count(*) desc"
elseif endDate <> "" then
	sql = "select sname,count(*) from stucj inner join stu on stucj.stuid=stu.id where score>=" & min_score & " and classid=" & majorID & " and dateDiff('d',tjsj,#" & endDate & "#)<=" & dateDiffValue & " group by sname order by count(*) desc"
else
	sql = "select sname,count(*) from stucj inner join stu on stucj.stuid=stu.id where score>=" & min_score & " and classid=" & majorID & " and dateDiff('d',tjsj,date())<=" & dateDiffValue & " group by sname order by count(*) desc"
end if

rs.open sql,conn,1,1
%>
<form action="view3.asp?mid=<%=majorID%>" method="post" class="form-group">
	<div class="panel-body form-inline">
	  	<label for=""> 起始日期（零点）
			<input type="date" class="form-control" name="startDate" placeholder="YYYY-MM-DD" <%if startDate<>"" then %>value="<%=startDate%>"<% end if %> > 
	  	</label>
	  	<label for=""> 截止日期（零点）
	  		<input type="date" class="form-control" name="endDate" placeholder="YYYY-MM-DD" <%if endDate<>"" then %>value="<%=endDate%>"<% end if %>>	
	  	</label>
	  	<input type="submit" value="查询" class="btn btn-primary">
	</div>
</form>

<table class="table table-striped" width="600" align="center" >
  <tr>
	<th colspan="4" class="text-center">本周做题次数排名</th>
  </tr>
  <tr>
	<td align="center">排名</td>
	<td align="center">姓名</td>
	<td align="center">次数</td>
  </tr>
<%i=1 
  Do while not rs.eof %>
  <tr>
	<td align="center"><%=i%></td>
	<td align="center"><%= rs("sname") %></td>
	<td align="center"><span style="font-weight:600"><%= rs(1) %></span></td>
  </tr>
<% rs.movenext
   i=i+1
   Loop
   rs.close
%>
</table>

<p align="center"><a href="index.asp" class="btn btn-primary btn-block">返回</a></p>
<% 
   set rs = nothing
   set rs2 = nothing
   Call CloseConn()
 %>
<!--#include file="footer.asp"-->
