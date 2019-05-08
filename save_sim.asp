<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<%

'添加考试名称和时间'
exam_name = trim(request.form("exam_name"))
exam_time = trim(request.form("exam_time"))

sql = "insert into simexam(ename,examtime,inputtime) values('" & exam_name & "',#" & exam_time & "#,#" & now & "#)"
conn.execute(sql)
'添加考试名称完毕，开始添加答案'
set rs = conn.execute("select id from simexam where ename='" & exam_name & "'")
exam_id = rs(0)
set rs = nothing

dim answer(100)
for i=1 to 100
	answer(i) = trim(request.form("answer" & i))
	if answer(i) = "" then answer(i) = "P"
	if i<=60 then
		qtype = 1
	elseif i<=70 then
		qtype = 3
	elseif i<=100 then
		qtype = 2
	end if
	sql = "insert into simexamtk(answer,sn,qtype,simexamID) values('" & answer(i) & "'," & i & "," & qtype & "," & exam_id & ")"
	conn.execute(sql)
next

response.redirect("index.asp")

%>