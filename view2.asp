<!--#include file="conn.asp" -->
<!--#include file="config.asp" -->
<!--#include file="function.asp" -->
<% page_title = "ÿ������" %>
<!--#include file="header.asp"-->
<style type="text/css">
body {
	font-family: Arial, Verdana, "΢���ź�", "����";
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
majorID = trim(request.querystring("mid"))   'רҵ ID�� �ڶ�༶ʱ���Դ� url ��ȡ
if majorID = "" then majorID = 1   'Ĭ��Ϊ1���������'

dateDiffValue = val(trim(request.querystring("ddv")))
dim rs,sql,px
px = Trim(Request.QueryString("px"))
set rs = Server.CreateObject("adodb.recordset")
set rs2 = Server.CreateObject("adodb.recordset")
sql = "SELECT top 40 sname,max(score) as max_score,avg(score) as avg_score FROM Stu inner join stucj on stu.id=stucj.stuid where grade<4 and score>0 and stu.majorid=" & majorID & " and dateDiff('d',tjsj,date())=" & dateDiffValue & " group by sname"   '��ȡ�����ռ�¼'
if px = "xm" then     '����������
    sql = sql & " order by sname"
else
    sql = sql & " order by avg(score) desc"
end if
rs.open sql,conn,1,1 
 %>
<table  class="table table-striped" width="600" align="center" >
  <tr>
    <th colspan="4" class="text-center">�����������</th>
  </tr>
  <tr>
    <td align="center">����</td>
    <td align="center">����</td>
    <td align="center">ƽ����</td>
    <td align="center">��߷�</td>
  </tr>
<%i=1 
  Do while not rs.eof %>
  <tr>
    <td align="center"><%=i%></td>
    <td align="center"><%= rs("sname") %><% if i=1 then %><span class="text-danger">��������ѣ�</span><% end if %></td>
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
      <th colspan="3" class="text-center"><span class="flunk-text">����δ�������������С��<%=countLevel%>�λ�ƽ���ֵ���<%=avgLevel%>�֣�</span></th>
    </tr>
    <tr>
      <td align="center">����</th>
      <td align="center">�������</th>
      <td align="center">ƽ����</th>
    </tr>
<%
    sql = "select sname, count(score), avg(score) from stu left join stucj on (stu.grade<4 and stu.id=stucj.stuid and stu.majorID=" & majorID & " and stu.classid=" & classID & " and dateDiff('d',stucj.tjsj,date())=" & dateDiffValue & " and score>0) group by sname having count(score)<" & countLevel & " or avg(score)<" & avgLevel & " order by avg(score) desc"     '2018-3-7 ��� score>0 ��ɸѡ���ֹ0�־��ύ�鿴���ظ��ύ '
    'ѡ�����������������ƽ���֣�left join û���� count Ϊ0��ɸѡ�༶��ɸѡ��������'
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

<p align="center"><a href="index.asp" class="btn btn-primary btn-block">����</a></p>
<% 
   set rs = nothing
   set rs2 = nothing
   Call CloseConn()
 %>
<!--#include file="footer.asp"-->