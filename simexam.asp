<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<% page_title = "模拟考" %>
<!--#include file="header.asp"-->
<link href="tk.css" rel="stylesheet" type="text/css" />
<style>
	.hidden-number {
		color: #f5f5f5;
	}
</style>
</head>

<body>
<p align=right><a href="logout.asp">重新登录</a> (登录IP: <%= session("login_ip") %>)</p>
<form name='form1' method='post' action='se_submitdata.asp'>
<%
	Dim A1()   '存储单选题
	Dim B1()   '存储判断题
	Dim C1()   '存储多选题

	ReDim A1(se_xzt_Display,3)  '重定义 单选, 0为 题目编号，1为 题目描述，2为 正确答案, 3为 顺序号
	ReDim B1(se_pdt_Display,3)  '判断
	ReDim C1(se_dxt_Display,3)  '多选

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

		session("simExamID") = simExamID       '将模拟考的id存入session中

		generateQuestions se_xzt_display,1,A1  '生成单选题数组'
		generateQuestions se_pdt_display,2,B1  '生成判断题数组'
		generateQuestions se_dxt_display,3,C1  '生成多选题数组'

%>
<p align='center' style='font-size:24px;font-weight:bold'> <%=simExamName%> </p>


<% 	
	'------------------------显示单选题------------------------
	displayQuestions se_xzt_display,1,A1

	'------------------------显示多选题------------------------ 
	displayQuestions se_dxt_display,3,C1

	'------------------------显示判断题------------------------  
	displayQuestions se_pdt_display,2,B1
%>


<p align='center' class=jieguo><button type="button" class="btn btn-primary btn-lg btn-block" data-toggle="modal" data-target="#confirmSubmit">交 卷</button></p>

<div class="modal fade" id="confirmSubmit" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
				确定要交卷吗？
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="submit" class="btn btn-danger">确定提交</button>
			</div>
		</div>
	</div>
</div>


<p align="center"><a href='logout.asp'>退出</a></p>
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
					response.write "单项选择题"
				case 2
					response.write "判断题"
				case 3
					response.write "多项选择题"
			end select
		%>
	 </p>
	 <% for i=1 to displayCount %>
		<table class='table'>
			<tr>
				<td><pre><%=qarray(i,3)%>. <%=new_text(New_id,A1(i,0))%> <%=replace(qarray(i,1),chr(13),"<br/>")%> <span class="hidden-number">(<%=qarray(i,0)%>)</span></pre></td>
			</tr>
			<% if qtype <> 2 then '如果不是判断题则显示选项' %>
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




