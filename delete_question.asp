<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<%  
page_title = "删除文件成功"
action = fdc(trim(request.querystring("action")))
questionID = val(fdc(trim(request.querystring("qid"))))

sessionID = val(session("sjtk_stuid"))
if session("grade")<4 and action="delf" then
	outMsg = "你没有权限执行此操作"
else
	if action="del" then
		if session("grade")<3 then    '权限小于3的要检查是否是录入者'
			sql = "update tk set isDeleted=yes where inputerID=" & sessionID & " and ntmbh=" & questionID
		else
			sql = "update tk set isDeleted=yes where ntmbh=" & questionID
		end if
		conn.execute(sql)
		outMsg = "已删除题目 <span class=""text-danger""> " & questionID & "</span>" 
	elseif action="delf" then
		sql = "delete from tk where ntmbh=" & questionID
		conn.execute(sql)
		outMsg = "已永久删除题目 <span class=""text-danger""> " & questionID & "</span>" 
	end if
end if
%>
<!--#include file="header.asp"-->
<%	
	stuID = val(request.querystring("stuid"))  '获取学生 ID 以便只显示该学生的录入'
	chapterID = val(request.querystring("cid"))  '获取章节 ID 以便只显示该章的题目'
	majorID = val(request.querystring("mid"))   '专业 ID， 在多班级时可以从 url 获取
	if majorID = 0 then majorID = 1   '默认为1，计算机班'
	pstr = "?mid=" & majorID & "&stuid=" & stuID & "&cid=" & chapterID
%>
</head>
<body>
	<div class="container">
		<h2><%=outMsg%></h2>
		<h4><a href="question_edit.asp<%=pstr%>">返回</a></h4>
	</div>

<!--#include file="footer.asp"-->

