<!--#include file="conn.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->
<!--#include file="header.asp"-->
</head>
<body>
<%	
	stuID = val(request.querystring("stuid"))  '获取学生 ID 以便只显示该学生的录入'
	chapterID = val(request.querystring("cid"))  '获取章节 ID 以便只显示该章的题目'
	majorID = val(request.querystring("mid"))   '专业 ID， 在多班级时可以从 url 获取
	if majorID = 0 then majorID = 1   '默认为1，计算机班'
	pstr = "?mid=" & majorID & "&stuid=" & stuID & "&cid=" & chapterID
%>
<%
	qid = fdc(request.form("qid"))
	if isnumeric(qid) then qid=clng(qid) else qid = 0
	ctm = server.htmlencode(trim(request.form("ctm")))
	ctmda = server.htmlencode(trim(request.form("ctmda")))
	czqda = replace(replace(trim(request.form("czqda")),",","")," ","")
	if czqda <> "" then czqda = ucase(czqda)  '一律转成大写
	chapter = val(server.htmlencode(trim(request.form("chapter"))))
	qtype = trim(request.form("qtype"))
	if qtype<>"" then if isnumeric(qtype) then qtype = cint(server.htmlencode(qtype))
	info = server.htmlencode(trim(request.form("info")))
	response.write ctm & "," & ctmda & "," & czqda
	if ctm <> "" and czqda <> "" then
		set rs = server.createobject("adodb.recordset")
		sql = "select * from tk where ntmbh=" & qid
		rs.open sql,conn,1,3
		rs("Ctm") = Ctm     '题目描述
		rs("Ctmda") = Ctmda   '题目选项
		rs("Czqda") = Czqda   '正确答案
		rs("chapter") = chapter      '题目所属章节
		rs("info") = info      '题目分析
		if qtype<>"" then rs("class") = qtype    '题目类型 单选判断还是多选
		rs.update
		rs.close
		set rs = nothing
		response.redirect "question_edit.asp" & pstr & "&qid=" & qid & "&tag=update-success&qtype=" & qtype 
	else
		response.write "某一项不能为空<br>"
		response.write "<a href=""javascript:history.go(-1)"">返回</a>"
	end if
%>

<!--#include file="footer.asp"-->