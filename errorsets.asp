<!--#include file="conn.asp" -->
<!--#include file="config.asp" -->
<!--#include file="function.asp" -->
<% page_title = "错题排行" %>
<!--#include file="header.asp"-->
<script>
  $(function(){
    $('[data-toggle="popover"]').mouseup(function(){  //safari 浏览器专用
      this.focus();
    })      
  })
  $(function(){
    $('[data-toggle="popover"]').popover();
  })
</script>
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

set rs = Server.CreateObject("adodb.recordset")
sql = "select top 50 * from errorsets inner join tk on errorsets.questionID=tk.ntmbh where tk.majorID=" & majorID & " order by errorsets.qcount desc"   '错得最多的50道题目'
rs.open sql,conn,1,1 
 %>
<table  class="table table-bordered table-striped" width="600" align="center" >
  <tr>
    <th colspan="4" class="text-center">哪些题目错得最多 <a href="index.asp">返回首页</a></th>
  </tr>
  <tr>
    <td align="center" width="40%">题目</td>
    <td align="center" width="20%">选项</td>
    <td align="center" width="30%">题目分析</td>
    <td align="center" width="10%">做错次数</td>
  </tr>
<%i=1 
  Do while not rs.eof %>
  <tr>
    <td>
      <p><%=i%>. <%= rs("ctm") %><% if i=1 then %><span class="text-danger">（错题之王）</span><% end if %> <span style="font-size:9px;color:#ccc">(题号：<%=rs("ntmbh")%>)</span></p>
      <p><button type="button" class="btn btn-default btn-xs" data-container="body" data-toggle="popover" data-trigger="focus" data-placement="bottom" data-content="<%= rs("czqda") %>">点击查看答案</button></p>
    </td>
    <td><%= wordWrap(rs("ctmda")) %></td>
    <td><%= wordWrap(rs("info")) %></td>
    <td align="center"><%= rs("qcount") %></td>
  </tr>
<% rs.movenext
   i=i+1
   Loop
   rs.close
%>

</table>

<br><br><br>

<p align="center"><a href="index.asp" class="btn btn-primary btn-block">返回</a></p>
<% 
   set rs = nothing
   set rs2 = nothing
   Call CloseConn()
 %>
<!--#include file="footer.asp"-->