<!--#include file="conn.asp"-->
<!--#include file="checkadmin.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

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
<link href="tk.css" rel="stylesheet" type="text/css" />

<style>
	.hidden-number {
		color: #f5f5f5;
	}
</style>
</head>

<body>
<p align=right><a href="index.asp">返回首页</a> <a href="logout.asp">重新登录</a> (登录IP: <%= session("login_ip") %>)</p>
<form name="questionsForm" id="questionsForm" method='post' action='submitdata.asp'>

<%
majorID = session("majorID")
if majorID = "" then majorID = 1   '默认值'

'---------------- 章节练习 信息获取 ----------------'
action = fdc(request.querystring("action"))  'action 为特定字符时进入章节练习'
if action = "chpt" then
	isChapterPractice = true
else
	isChapterPractice = false
end if
changeQuestionCount isChapterPractice   '如果是章节练习，则修改生成的题目数量'

chapterID = val(request.querystring("cid"))   '获取章节号'
if chapterID <> 0 then
	chapterSqlStr = "chapter=" & chapterID & " and"
else
	chapterSqlStr = ""
end if
'------------------------------------------------'

Dim rs,sql,RndNo,i,T,j,rs2,sql2       'j为出现的题目的序号
Dim A1()   '存储单选题
Dim B1()   '存储判断题
Dim C1()   '存储多选题
T=Timer

ReDim A1(Tk_xzt_Display,3)  '重定义 单选, 0为 ntmbh，1为 ctm，2为 ctmda
ReDim B1(Tk_pdt_Display,3)  
ReDim C1(Tk_dxt_Display,3)  

'---------------------判断是否已生成过题目, 如果已生成, 便不在生成, 从数据库读取已有的题目
Randomize

refreshIsTooFast = false
'===============================获取题目编号，重新生成或者从已有生成中获取=============================================='



	if T - session("input_time")>=SUBMIT_MIN_INTERVAL then   '防止刷新过快
	'-------------------------------------------------------------------'


	set rs1 = Server.CreateObject("adodb.recordset")  '单选题数据池'
	set rs2 = Server.CreateObject("adodb.recordset")  '判断题数据池'
	set rs3 = Server.CreateObject("adodb.recordset")  '多选题数据池'

	sql1 = "select top " & Tk_xzt_Display & " * from tk where " & chapterSqlStr & " not isDeleted and class=1 and majorID=" & majorID & " order by Rnd(-(ntmbh+" & rnd() & "))"  'rnd 参数为正数时是
	sql2 = "select top " & Tk_pdt_Display & " * from tk where " & chapterSqlStr & " not isDeleted and class=2 and majorID=" & majorID & " order by Rnd(-(ntmbh+" & rnd() & "))"  '必须用这种方法才能生
	sql3 = "select top " & Tk_dxt_Display & " * from tk where " & chapterSqlStr & " not isDeleted and class=3 and majorID=" & majorID & " order by Rnd(-(ntmbh+" & rnd() & "))"
	
	'单选题
	i = 1
	qtype = 1
	rs1.open sql1,conn,1,1
	do while not rs1.eof
		'---------保存随机生成的题号----------'
		sqlTemp = "insert into stutest(stuid,stuno,tkno,class) values(" & session("sjtk_stuid") & "," & i & "," & rs1(0) & "," & qtype & ")"
		conn.execute(sqlTemp)
		'----------------------------------'
		'---------保存信息到数组，以便之后在界面输出----------'
		A1(i,0) = rs1("ntmbh")
		A1(i,1) = rs1("ctm")
		A1(i,2) = rs1("ctmda")
		A1(i,3) = rs1("czqda")
		'-----------------------------------------------'
		i=i+1
		if i>Tk_xzt_Display then exit do    '随机生成有 bug，有时候会超出要显示的数目上线，加这条语句限死'
		rs1.movenext
	loop
	rs1.close
	set rs1 = nothing

	'判断题
	if Tk_pdt_Display > 0 then
		i = 1
		qtype = 2
		rs2.open sql2,conn,1,1
		do while not rs2.eof
			'---------保存随机生成的题号----------'
			sqlTemp = "insert into stutest(stuid,stuno,tkno,class) values(" & session("sjtk_stuid") & "," & i & "," & rs2(0) & "," & qtype & ")"
			conn.execute(sqlTemp)
			'----------------------------------'
			'---------保存信息到数组，以便之后在界面输出----------'
			B1(i,0) = rs2("ntmbh")
			B1(i,1) = rs2("ctm")
			B1(i,3) = rs2("czqda")
			'-----------------------------------------------'
			i=i+1
			if i>Tk_pdt_Display then exit do    '随机生成有 bug，有时候会超出要显示的数目上线，加这条语句限死'
			rs2.movenext
		loop
		rs2.close
		set rs2 = nothing
	end if


	'多选题
	if Tk_dxt_Display > 0 then
		i = 1
		qtype = 3
		rs3.open sql3,conn,1,1
		do while not rs3.eof
			'---------保存随机生成的题号----------'
			sqlTemp = "insert into stutest(stuid,stuno,tkno,class) values(" & session("sjtk_stuid") & "," & i & "," & rs3(0) & "," & qtype & ")"
			conn.execute(sqlTemp)
			'----------------------------------'
			'---------保存信息到数组，以便之后在界面输出----------'
			C1(i,0) = rs3("ntmbh")
			C1(i,1) = rs3("ctm")
			C1(i,2) = rs3("ctmda")
			C1(i,3) = rs3("czqda")
			'-----------------------------------------------'
			i=i+1
			if i>Tk_dxt_Display then exit do    '随机生成有 bug，有时候会超出要显示的数目上线，加这条语句限死'
			rs3.movenext
		loop
		rs3.close
		set rs3 = nothing	
	end if

  	conn.execute("Update Stu set loginstatus=1,loginip='" & session("login_ip") & "' where id=" & session("sjtk_stuid"))  '更新数据表学生登录状态和最后登录IP
  	session("sjtk_loginstatus") = 1    '更新 session' 
  	session("input_time") = timer    '设置生成时间，以便计算时间间隔，防止刷新过快'


  	else
  		refreshIsTooFast = true
  	end if



'========================================题目编号获取结束=========================================================='


'---------------------------------------------------------------------------------------
%>

<% if not refreshIsTooFast then %>
<% '------------------------显示单选题------------------------  %>
<p align='center' style='font-size:24px;font-weight:bold'> 单项选择题 </p>
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
			<button type="button" class="btn btn-default btn-xs" data-container="body" data-toggle="popover" data-trigger="focus" data-placement="bottom" data-content="<%= A1(i,3) %>">点击查看答案</button>
		</td>
	</tr>
</table>

<input type='hidden' name='sjnoxzt<%=i%>' value='<%=A1(i,0)%>'/><br/>

<% next %>
<% '---------------------------End---------------------------- %>


<% '------------------------显示多选题------------------------  %>
<p align='center' style='font-size:24px;font-weight:bold'> 多项选择题 </p>

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
			<button type="button" class="btn btn-default btn-xs" data-container="body" data-toggle="popover" data-trigger="focus" data-placement="bottom" data-content="<%= C1(i,3) %>">点击查看答案</button>
		</td>
	</tr>
</table>

<input type='hidden' name='sjnodxt<%=i%>'  value='<%=C1(i,0)%>'/><br/>

<% next %>
<% '---------------------------End---------------------------- %>

<% '------------------------显示判断题------------------------  %>
<p align='center' style='font-size:24px;font-weight:bold'> 判断题 </p>

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
			<button type="button" class="btn btn-default btn-xs" data-container="body" data-toggle="popover" data-trigger="focus" data-placement="bottom" data-content="<%= B1(i,3) %>">点击查看答案</button>
		</td>
	</tr>
</table>

<input type="hidden" name="sjnopdt<%=i%>" value="<%=B1(i,0)%>" /><br/>

<% next %>
<% '---------------------------End---------------------------- %>


<% if isChapterPractice then '增加隐藏元素，表示是否是章节练习，以及章节号' %>
<input type="hidden" name="isCptp" value="y">
<input type="hidden" name="cid" value="<%=chapterID%>">
<% end if %>


<% else   '提交过快' %>
<h3>请不要刷新过快</h3>
<% end if %>


</form>

<p align="center"><a href="index.asp" class="btn btn-default btn-block">返回</a></p>

<br/><br/>本页面加载了<%=(Timer-T)*1000%>毫秒    <a href='logout.asp'>退出</a>

<% Call CloseConn() %>
<!--#include file="footer.asp"-->





