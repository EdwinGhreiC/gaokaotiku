<!--#include file="conn.asp" -->
<!--#include file="config.asp" -->
<!--#include file="function.asp" -->
<% page_title = "��������" %>
<!--#include file="header.asp"-->
<script>
  $(function(){
    $('[data-toggle="popover"]').mouseup(function(){  //safari �����ר��
      this.focus();
    })      
  })
  $(function(){
    $('[data-toggle="popover"]').popover();
  })
</script>
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

set rs = Server.CreateObject("adodb.recordset")
sql = "select top 50 * from errorsets inner join tk on errorsets.questionID=tk.ntmbh where tk.majorID=" & majorID & " order by errorsets.qcount desc"   '�������50����Ŀ'
rs.open sql,conn,1,1 
 %>
<table  class="table table-bordered table-striped" width="600" align="center" >
  <tr>
    <th colspan="4" class="text-center">��Щ��Ŀ������ <a href="index.asp">������ҳ</a></th>
  </tr>
  <tr>
    <td align="center" width="40%">��Ŀ</td>
    <td align="center" width="20%">ѡ��</td>
    <td align="center" width="30%">��Ŀ����</td>
    <td align="center" width="10%">�������</td>
  </tr>
<%i=1 
  Do while not rs.eof %>
  <tr>
    <td>
      <p><%=i%>. <%= rs("ctm") %><% if i=1 then %><span class="text-danger">������֮����</span><% end if %> <span style="font-size:9px;color:#ccc">(��ţ�<%=rs("ntmbh")%>)</span></p>
      <p><button type="button" class="btn btn-default btn-xs" data-container="body" data-toggle="popover" data-trigger="focus" data-placement="bottom" data-content="<%= rs("czqda") %>">����鿴��</button></p>
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

<p align="center"><a href="index.asp" class="btn btn-primary btn-block">����</a></p>
<% 
   set rs = nothing
   set rs2 = nothing
   Call CloseConn()
 %>
<!--#include file="footer.asp"-->