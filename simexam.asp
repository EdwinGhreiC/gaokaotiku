<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<% page_title = "ģ�⿼" %>
<!--#include file="header.asp"-->
<link href="tk.css" rel="stylesheet" type="text/css" />
<style>
	.hidden-number {
		color: #f5f5f5;
	}
</style>
</head>

<body>
<p align=right><a href="logout.asp">���µ�¼</a> (��¼IP: <%= session("login_ip") %>)</p>
<form name='form1' method='post' action='se_submitdata.asp'>
<%
	Dim A1()   '�洢��ѡ��
	Dim B1()   '�洢�ж���
	Dim C1()   '�洢��ѡ��

	ReDim A1(se_xzt_Display,3)  '�ض��� ��ѡ, 0Ϊ ��Ŀ��ţ�1Ϊ ��Ŀ������2Ϊ ��ȷ��, 3Ϊ ˳���
	ReDim B1(se_pdt_Display,3)  '�ж�
	ReDim C1(se_dxt_Display,3)  '��ѡ

	simExamID = val(fdc(trim(request.querystring("seid"))))
	set rsexam = server.createobject("adodb.recordset")
	sql = "select * from simexam where id=" & simExamID
	rsexam.open sql,conn,1,1
	simExamName = ""
	if not rsexam.eof then
		simExamName = rsexam("ename")
	end if
	rsexam.close
	set rsexam = nothing

	if simExamName <> "" then

		session("simExamID") = simExamID       '��ģ�⿼��id����session��

		generateQuestions se_xzt_display,1,A1  '���ɵ�ѡ������'
		generateQuestions se_pdt_display,2,B1  '�����ж�������'
		generateQuestions se_dxt_display,3,C1  '���ɶ�ѡ������'

%>
<p align='center' style='font-size:24px;font-weight:bold'> <%=simExamName%> </p>


<% 	
	'------------------------��ʾ��ѡ��------------------------
	displayQuestions se_xzt_display,1,A1

	'------------------------��ʾ��ѡ��------------------------ 
	displayQuestions se_dxt_display,3,C1

	'------------------------��ʾ�ж���------------------------  
	displayQuestions se_pdt_display,2,B1
%>


<p align='center' class=jieguo><button type="button" class="btn btn-primary btn-lg btn-block" data-toggle="modal" data-target="#confirmSubmit">�� ��</button></p>

<div class="modal fade" id="confirmSubmit" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
				ȷ��Ҫ������
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">�ر�</button>
				<button type="submit" class="btn btn-danger">ȷ���ύ</button>
			</div>
		</div>
	</div>
</div>


<p align="center"><a href='logout.asp'>�˳�</a></p>
<br/><br/>    

	<% end if %>
</form>
</body>
</html>

<%
	sub generateQuestions(displayCount,qtype,qarray)
		set rsq = Server.CreateObject("adodb.recordset")
		sql = "select * from simexamtk where qtype=" & qtype & " and simexamID=" & simExamID & " order by sn"
		rsq.open sql,conn,1,1
		i=1
		do until rsq.eof
			qarray(i,0) = rsq("id")
			qarray(i,1) = rsq("content")
			qarray(i,2) = rsq("options")
			qarray(i,3) = rsq("sn")
			i=i+1
			if i>displayCount then exit do
			rsq.movenext
		loop
		rsq.close
		set rsq = nothing
	end sub
%>

<% sub displayQuestions(displayCount,qtype,qarray) %>
	<p align='center' style='font-size:24px;font-weight:bold'> 
		<% 	select case qtype
				case 1
					response.write "����ѡ����"
				case 2
					response.write "�ж���"
				case 3
					response.write "����ѡ����"
			end select
		%>
	 </p>
	 <% for i=1 to displayCount %>
		<table class='table'>
			<tr>
				<td><pre><%=qarray(i,3)%>. <%=new_text(New_id,A1(i,0))%> <%=replace(qarray(i,1),chr(13),"<br/>")%> <span class="hidden-number">(<%=qarray(i,0)%>)</span></pre></td>
			</tr>
			<% if qtype <> 2 then '��������ж�������ʾѡ��' %>
			<tr>
				<td height='48' valign='top' class='daynav'><%=replace(qarray(i,2),chr(13),"<br/><br/>")%></td>
			</tr>
			<% end if %>
			<% 	select case qtype 
				case 1
				hiddenName = "sjnoxzt" %>
				<tr class='active'>
					<td>
						<label for="radio<%=qarray(i,3)%>_1" class="radio-inline">
							<input type="radio" name="tmxzt<%=i%>" id="radio<%=qarray(i,3)%>_1" value="A"> A
						</label>
						<label for="radio<%=qarray(i,3)%>_2" class="radio-inline">
							<input type="radio" name="tmxzt<%=i%>" id="radio<%=qarray(i,3)%>_2" value="B"> B
						</label>
						<label for="radio<%=qarray(i,3)%>_3" class="radio-inline">
							<input type="radio" name="tmxzt<%=i%>" id="radio<%=qarray(i,3)%>_3" value="C"> C
						</label>
						<label for="radio<%=qarray(i,3)%>_4" class="radio-inline">
							<input type="radio" name="tmxzt<%=i%>" id="radio<%=qarray(i,3)%>_4" value="D"> D
						</label>
					</td>
				</tr>
			<%	case 2
				hiddenName = "sjnopdt" %>			
				<tr class='active'>
					<td>
						<label for="radio<%=qarray(i,3)%>_1" class="radio-inline">
							<input type="radio" name="tmpdt<%=i%>" id="radio<%=qarray(i,3)%>_1" value="A"> A
						</label>
						<label for="radio<%=qarray(i,3)%>_2" class="radio-inline">
							<input type="radio" name="tmpdt<%=i%>" id="radio<%=qarray(i,3)%>_2" value="B"> B
						</label>
				</tr>						
			<%	case 3
				hiddenName = "sjnodxt" %>
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
			<%	end select %>

			<input type='hidden' name='<%=hiddenName & i%>'  value='<%=qarray(i,0)%>'/><br/>
		</table>
		
	 <% next %>
<% end sub %>

<% Call CloseConn() %>




