<!--#include file="conn.asp"-->
<!--#include file="checkadmin.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

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
<link href="tk.css" rel="stylesheet" type="text/css" />

<style>
	.hidden-number {
		color: #f5f5f5;
	}
</style>
</head>

<body>
<p align=right><a href="index.asp">������ҳ</a> <a href="logout.asp">���µ�¼</a> (��¼IP: <%= session("login_ip") %>)</p>
<form name="questionsForm" id="questionsForm" method='post' action='submitdata.asp'>

<%
majorID = session("majorID")
if majorID = "" then majorID = 1   'Ĭ��ֵ'

'---------------- �½���ϰ ��Ϣ��ȡ ----------------'
action = fdc(request.querystring("action"))  'action Ϊ�ض��ַ�ʱ�����½���ϰ'
if action = "chpt" then
	isChapterPractice = true
else
	isChapterPractice = false
end if
changeQuestionCount isChapterPractice   '������½���ϰ�����޸����ɵ���Ŀ����'

chapterID = val(request.querystring("cid"))   '��ȡ�½ں�'
if chapterID <> 0 then
	chapterSqlStr = "chapter=" & chapterID & " and"
else
	chapterSqlStr = ""
end if
'------------------------------------------------'

Dim rs,sql,RndNo,i,T,j,rs2,sql2       'jΪ���ֵ���Ŀ�����
Dim A1()   '�洢��ѡ��
Dim B1()   '�洢�ж���
Dim C1()   '�洢��ѡ��
T=Timer

ReDim A1(Tk_xzt_Display,3)  '�ض��� ��ѡ, 0Ϊ ntmbh��1Ϊ ctm��2Ϊ ctmda
ReDim B1(Tk_pdt_Display,3)  
ReDim C1(Tk_dxt_Display,3)  

'---------------------�ж��Ƿ������ɹ���Ŀ, ���������, �㲻������, �����ݿ��ȡ���е���Ŀ
Randomize

refreshIsTooFast = false
'===============================��ȡ��Ŀ��ţ��������ɻ��ߴ����������л�ȡ=============================================='



	if T - session("input_time")>=SUBMIT_MIN_INTERVAL then   '��ֹˢ�¹���
	'-------------------------------------------------------------------'


	set rs1 = Server.CreateObject("adodb.recordset")  '��ѡ�����ݳ�'
	set rs2 = Server.CreateObject("adodb.recordset")  '�ж������ݳ�'
	set rs3 = Server.CreateObject("adodb.recordset")  '��ѡ�����ݳ�'

	sql1 = "select top " & Tk_xzt_Display & " * from tk where " & chapterSqlStr & " not isDeleted and class=1 and majorID=" & majorID & " order by Rnd(-(ntmbh+" & rnd() & "))"  'rnd ����Ϊ����ʱ��
	sql2 = "select top " & Tk_pdt_Display & " * from tk where " & chapterSqlStr & " not isDeleted and class=2 and majorID=" & majorID & " order by Rnd(-(ntmbh+" & rnd() & "))"  '���������ַ���������
	sql3 = "select top " & Tk_dxt_Display & " * from tk where " & chapterSqlStr & " not isDeleted and class=3 and majorID=" & majorID & " order by Rnd(-(ntmbh+" & rnd() & "))"
	
	'��ѡ��
	i = 1
	qtype = 1
	rs1.open sql1,conn,1,1
	do while not rs1.eof
		'---------����������ɵ����----------'
		sqlTemp = "insert into stutest(stuid,stuno,tkno,class) values(" & session("sjtk_stuid") & "," & i & "," & rs1(0) & "," & qtype & ")"
		conn.execute(sqlTemp)
		'----------------------------------'
		'---------������Ϣ�����飬�Ա�֮���ڽ������----------'
		A1(i,0) = rs1("ntmbh")
		A1(i,1) = rs1("ctm")
		A1(i,2) = rs1("ctmda")
		A1(i,3) = rs1("czqda")
		'-----------------------------------------------'
		i=i+1
		if i>Tk_xzt_Display then exit do    '��������� bug����ʱ��ᳬ��Ҫ��ʾ����Ŀ���ߣ��������������'
		rs1.movenext
	loop
	rs1.close
	set rs1 = nothing

	'�ж���
	if Tk_pdt_Display > 0 then
		i = 1
		qtype = 2
		rs2.open sql2,conn,1,1
		do while not rs2.eof
			'---------����������ɵ����----------'
			sqlTemp = "insert into stutest(stuid,stuno,tkno,class) values(" & session("sjtk_stuid") & "," & i & "," & rs2(0) & "," & qtype & ")"
			conn.execute(sqlTemp)
			'----------------------------------'
			'---------������Ϣ�����飬�Ա�֮���ڽ������----------'
			B1(i,0) = rs2("ntmbh")
			B1(i,1) = rs2("ctm")
			B1(i,3) = rs2("czqda")
			'-----------------------------------------------'
			i=i+1
			if i>Tk_pdt_Display then exit do    '��������� bug����ʱ��ᳬ��Ҫ��ʾ����Ŀ���ߣ��������������'
			rs2.movenext
		loop
		rs2.close
		set rs2 = nothing
	end if


	'��ѡ��
	if Tk_dxt_Display > 0 then
		i = 1
		qtype = 3
		rs3.open sql3,conn,1,1
		do while not rs3.eof
			'---------����������ɵ����----------'
			sqlTemp = "insert into stutest(stuid,stuno,tkno,class) values(" & session("sjtk_stuid") & "," & i & "," & rs3(0) & "," & qtype & ")"
			conn.execute(sqlTemp)
			'----------------------------------'
			'---------������Ϣ�����飬�Ա�֮���ڽ������----------'
			C1(i,0) = rs3("ntmbh")
			C1(i,1) = rs3("ctm")
			C1(i,2) = rs3("ctmda")
			C1(i,3) = rs3("czqda")
			'-----------------------------------------------'
			i=i+1
			if i>Tk_dxt_Display then exit do    '��������� bug����ʱ��ᳬ��Ҫ��ʾ����Ŀ���ߣ��������������'
			rs3.movenext
		loop
		rs3.close
		set rs3 = nothing	
	end if

  	conn.execute("Update Stu set loginstatus=1,loginip='" & session("login_ip") & "' where id=" & session("sjtk_stuid"))  '�������ݱ�ѧ����¼״̬������¼IP
  	session("sjtk_loginstatus") = 1    '���� session' 
  	session("input_time") = timer    '��������ʱ�䣬�Ա����ʱ��������ֹˢ�¹���'


  	else
  		refreshIsTooFast = true
  	end if



'========================================��Ŀ��Ż�ȡ����=========================================================='


'---------------------------------------------------------------------------------------
%>

<% if not refreshIsTooFast then %>
<% '------------------------��ʾ��ѡ��------------------------  %>
<p align='center' style='font-size:24px;font-weight:bold'> ����ѡ���� </p>
<% for i=1 to Tk_xzt_Display %>
<table class='table'>
	<tr>
		<td><pre><%=i%>. <%=new_text(New_id,A1(i,0))%> <%=replace(ubbToHtml(A1(i,1),"img"),chr(13),"<br/>")%> <span class="hidden-number">(<%=A1(i,0)%>)</span></pre></td>
	</tr>
	<tr>
		<td height='48' valign='top' class='daynav'><%=replace(ubbToHtml(A1(i,2),"img"),chr(13),"<br/><br/>")%></td>
	</tr>
	<tr class='active'>
		<td>
			<label for="radio<%=i%>_1" class="radio-inline">
				<input type="radio" name="tmxzt<%=i%>" id="radio<%=i%>_1" value="A"> A
			</label>
			<label for="radio<%=i%>_2" class="radio-inline">
				<input type="radio" name="tmxzt<%=i%>" id="radio<%=i%>_2" value="B"> B
			</label>
			<label for="radio<%=i%>_3" class="radio-inline">
				<input type="radio" name="tmxzt<%=i%>" id="radio<%=i%>_3" value="C"> C
			</label>
			<label for="radio<%=i%>_4" class="radio-inline">
				<input type="radio" name="tmxzt<%=i%>" id="radio<%=i%>_4" value="D"> D
			</label>
		</td>
	</tr>
	<tr>
		<td>
			<button type="button" class="btn btn-default btn-xs" data-container="body" data-toggle="popover" data-trigger="focus" data-placement="bottom" data-content="<%= A1(i,3) %>">����鿴��</button>
		</td>
	</tr>
</table>

<input type='hidden' name='sjnoxzt<%=i%>' value='<%=A1(i,0)%>'/><br/>

<% next %>
<% '---------------------------End---------------------------- %>


<% '------------------------��ʾ��ѡ��------------------------  %>
<p align='center' style='font-size:24px;font-weight:bold'> ����ѡ���� </p>

<% for i=1 to Tk_dxt_Display %>

<table class='table'>
	<tr>
		<td><pre><%=i%>. <%=new_text(New_id,C1(i,0))%> <%=replace(ubbToHtml(C1(i,1),"img"),chr(13),"<br/>")%> <span class="hidden-number">(<%=C1(i,0)%>)</span></pre></td>
	</tr>
	<tr>
		<td height='48' valign='top' class='daynav'><%=replace(ubbToHtml(C1(i,2),"img"),chr(13),"<br/><br/>")%></td>
	</tr>
	<tr class='active'>
		<td>
			<label for="checkbox<%=i%>_1" class="checkbox-inline">
				<input type="checkbox" name="tmdxt<%=i%>" id="checkbox<%=i%>_1" value="A"> A
			</label>
			<label for="checkbox<%=i%>_2" class="checkbox-inline">
				<input type="checkbox" name="tmdxt<%=i%>" id="checkbox<%=i%>_2" value="B"> B
			</label>
			<label for="checkbox<%=i%>_3" class="checkbox-inline">
				<input type="checkbox" name="tmdxt<%=i%>" id="checkbox<%=i%>_3" value="C"> C
			</label>
			<label for="checkbox<%=i%>_4" class="checkbox-inline">
				<input type="checkbox" name="tmdxt<%=i%>" id="checkbox<%=i%>_4" value="D"> D
			</label>
		</td>
	</tr>
	<tr>
		<td>
			<button type="button" class="btn btn-default btn-xs" data-container="body" data-toggle="popover" data-trigger="focus" data-placement="bottom" data-content="<%= C1(i,3) %>">����鿴��</button>
		</td>
	</tr>
</table>

<input type='hidden' name='sjnodxt<%=i%>'  value='<%=C1(i,0)%>'/><br/>

<% next %>
<% '---------------------------End---------------------------- %>

<% '------------------------��ʾ�ж���------------------------  %>
<p align='center' style='font-size:24px;font-weight:bold'> �ж��� </p>

<% for i=1 to Tk_pdt_Display %>

<table class='table'>
	<tr>
		<td><pre><%=i%>. <%=new_text(New_id,B1(i,0))%> <%=replace(ubbToHtml(B1(i,1),"img"),chr(13),"<br/>")%> <span class="hidden-number">(<%=B1(i,0)%>)</span></pre></td>
	</tr>
	<tr class='active'>
		<td>
			<label for="radiopdt<%=i%>_1" class="radio-inline">
				<input type="radio" name="tmpdt<%=i%>" id="radiopdt<%=i%>_1" value="A"> A
			</label>
			<label for="radiopdt<%=i%>_2" class="radio-inline">
				<input type="radio" name="tmpdt<%=i%>" id="radiopdt<%=i%>_2" value="B"> B
			</label>
		</td>
	</tr>
	<tr>
		<td>
			<button type="button" class="btn btn-default btn-xs" data-container="body" data-toggle="popover" data-trigger="focus" data-placement="bottom" data-content="<%= B1(i,3) %>">����鿴��</button>
		</td>
	</tr>
</table>

<input type="hidden" name="sjnopdt<%=i%>" value="<%=B1(i,0)%>" /><br/>

<% next %>
<% '---------------------------End---------------------------- %>


<% if isChapterPractice then '��������Ԫ�أ���ʾ�Ƿ����½���ϰ���Լ��½ں�' %>
<input type="hidden" name="isCptp" value="y">
<input type="hidden" name="cid" value="<%=chapterID%>">
<% end if %>


<% else   '�ύ����' %>
<h3>�벻Ҫˢ�¹���</h3>
<% end if %>


</form>

<p align="center"><a href="index.asp" class="btn btn-default btn-block">����</a></p>

<br/><br/>��ҳ�������<%=(Timer-T)*1000%>����    <a href='logout.asp'>�˳�</a>

<% Call CloseConn() %>
<!--#include file="footer.asp"-->





