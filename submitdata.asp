<!--#include file="conn.asp" -->
<!--#include file="config.asp" -->
<!--#include file="function.asp" -->
<%
if session("sjtk_user")<>"" then   '防止没有 session 了，数组下标越界，因为有些班级的显示个数是根据 session 的。'

	Dim tmdaxzt()
	Dim tmdadxt()
	Dim tmdapdt()
	Dim tmnoxzt()
	Dim tmnodxt()
	Dim tmnopdt()
	ReDim tmdaxzt(Tk_xzt_Display)
	ReDim tmdadxt(Tk_dxt_Display)
	ReDim tmdapdt(Tk_pdt_Display)
	ReDim tmnoxzt(Tk_xzt_Display)
	ReDim tmnodxt(Tk_dxt_Display)
	ReDim tmnopdt(Tk_pdt_Display)
	Dim rs,rs2,sql,sql2,i,tkstr,tknostr,tmdastr    'tkstr : 提交后看到的题目
	Dim zongfen     '答对个数累计
	Dim stuid       '从session中取出ID号放入此变量
	dim xzt_score   '单选题得分
	dim dxt_score   '多选题得分
	dim pdt_score   '判断题得分
	dim xzt_value   '单选题每题分值'
	dim dxt_value   '多选题每题分值'
	dim pdt_value   '判断题每题分值'

	xzt_value = 1.5    '单选题分值'
	pdt_value = 1      '判断题分值'
	dxt_value = 3      '多选题分值'

	zongfen = 0
	xzt_score = 0
	pdt_score = 0
	tknostr = ""
	tmdastr = ""

	'获取是否是章节练习的信息'
	isChapterPractice = fdc(request.form("isCptp"))
	chapterID = val(request.form("cid"))
	if isChapterPractice = "y" then
		isChapterPractice = true
	else
		isChapterPractice = false
	end if
	changeQuestionCount isChapterPractice


	for i=1 to Tk_xzt_Display     '获取学生单选题的答题结果'
	    tmdaxzt(i)=Trim(Request.Form("tmxzt" & i))   '考生选择的答案
	    tmnoxzt(i)=Val(Trim(Request.Form("sjnoxzt" & i)))  '题目id
	    tknostr = tknostr & "|" & CStr(tmnoxzt(i))
	    if tmdaxzt(i)="" then
	       tmdastr= tmdastr & tmnoxzt(i) & "." & "N" & "|"
	    else
	       tmdastr= tmdastr & tmnoxzt(i) & "." & tmdaxzt(i) & "|"
	    end if
	next

	for i=1 to Tk_dxt_Display     '获取学生多选题的答题结果'
	    tmdadxt(i)=replace(replace(Trim(Request.Form("tmdxt" & i)),",","")," ","")   '考生选择的答案, 去掉逗号和中间的空格
	    tmnodxt(i)=Val(Trim(Request.Form("sjnodxt" & i)))  '题目id
	    tknostr = tknostr & "|" & CStr(tmnodxt(i))
	    if tmdadxt(i)="" then
	       tmdastr= tmdastr & tmnodxt(i) & "." & "N" & "|"
	    else
	       tmdastr= tmdastr & tmnodxt(i) & "." & tmdadxt(i) & "|"
	    end if
	next

	for i=1 to Tk_pdt_Display      '获取学生判断题的答题结果'
	    tmdapdt(i)=Trim(Request.Form("tmpdt" & i))   '考生选择的答案
	    tmnopdt(i)=Val(Trim(Request.Form("sjnopdt" & i)))  '题目id
	    tknostr = tknostr & "|" & CStr(tmnopdt(i))
	    if tmdapdt(i)="" then
	       tmdastr=tmdastr & tmnopdt(i) & "." & "N" & "|"
	    else
	       tmdastr= tmdastr & tmnopdt(i) & "." & tmdapdt(i) & "|"
	    end if
	next

	set rs = Server.CreateObject("adodb.recordset")
	set rs2 = Server.CreateObject("adodb.recordset")

end if
%>
<!--#include file="header.asp"-->
<link href="tk.css" rel="stylesheet" type="text/css" />
<style>
	.full-mark {
		color: #d9534f;
	}

	.try-again a{
		color: #888;
	}
</style>
</head>

<body>
<%

stuid = CLng(session("sjtk_stuid"))
if stuid <> 0 then

	sql2 = "select * from stucj where stuid=" & stuid & " and tknostr='" & Trim(tknostr) & "'"
	rs2.open sql2,conn,1,1
	if not rs2.eof then   '说明记录已存在，不能提交'
		session("isSubmitted") = 1   '设为0表示已提交过这份试卷'
	else
		session("isSubmitted") = 0   '设为0表示未提交过这份试卷'
	end if

'--------------------------单选题判题部分---------------------------'
tkstr = tkstr & "<p align=center>单项选择题</p>"
for i=1 to Tk_xzt_Display
    sql = "select stu.sname,tk.* from tk inner join stu on tk.inputerID=stu.id where Ntmbh=" & tmnoxzt(i)
    rs.open sql,conn,1,1
	if not rs.eof then
		if isnull(rs("info")) then info = " " else info = rs("info")

		if trim(rs("czqda")) = tmdaxzt(i) then
			zongfen = zongfen + 1    
		  	xzt_score = xzt_score + xzt_value   '高职考单选题1题1.5分
		else   '做错的情况'
			tkstr = tkstr & "<table class='table'><tr><td>"
			tkstr = tkstr & "<span class='wronganswer'>你的答案: " & tmdaxzt(i) & "&nbsp;&nbsp;&nbsp;正确答案: " & rs("czqda") & "</span></td></tr>"
			tkstr = tkstr & "<tr><td valign='top' class='daynav'><pre>" & i & ". " & new_text(New_id,rs("ntmbh")) & ubbToHtml(rs("ctm"),"img") & "</pre></td></tr>"
			tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav'>" & replace(rs("ctmda"),chr(13),"<br/><br/>") & "</td></tr>"
			tkstr = tkstr & "<tr><td height='6' valign='top' class='daynav'>&nbsp;</td></tr>"
			tkstr = tkstr & "<tr><td height='22' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>录入者：" & rs("sname") & "</td></tr>"
			tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>题目(" & rs("ntmbh") & ")解析：" & replace(info,chr(13),"<br/><br/>") & "</td></tr>"
			tkstr = tkstr & "</table><br/><hr>"
			countErrors rs   '统计错题'
		end if
	end if

	rs.close
next

'--------------------------多选题判题部分---------------------------'
if Tk_dxt_Display > 0 then
	tkstr = tkstr & "<p align=center>多项选择题</p>"
	for i=1 to Tk_dxt_Display
	    sql = "select stu.sname,tk.* from tk inner join stu on tk.inputerID=stu.id where Ntmbh=" & tmnodxt(i)
	    rs.open sql,conn,1,1
		if not rs.eof then

			if isnull(rs("info")) then info = " " else info = rs("info")

			if trim(rs("czqda")) = tmdadxt(i) then
				zongfen = zongfen + 1    
				dxt_score = dxt_score + dxt_value   '高职考多选题1题3分
			else   '做错的情况'
				tkstr = tkstr & "<table class='table'><tr><td>"
				tkstr = tkstr & "<span class='wronganswer'>你的答案: " & tmdadxt(i) & "&nbsp;&nbsp;&nbsp;正确答案: " & rs("czqda") & "</span></td></tr>"
				tkstr = tkstr & "<tr><td valign='top' class='daynav'><pre>" & i & ". " & new_text(New_id,rs("ntmbh")) & ubbToHtml(rs("ctm"),"img") & "</pre></td></tr>"
				tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav'>" & replace(rs("ctmda"),chr(13),"<br/><br/>") & "</td></tr>"
				tkstr = tkstr & "<tr><td height='6' valign='top' class='daynav'>&nbsp;</td></tr>"
				tkstr = tkstr & "<tr><td height='22' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>录入者：" & rs("sname") & "</td></tr>"
				tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>题目(" & rs("ntmbh") & ")解析：" & replace(info,chr(13),"<br/><br/>") & "</td></tr>"
				tkstr = tkstr & "</table><br/><hr>"
				countErrors rs   '统计错题'
			end if
		end if

		rs.close
	next
end if

'--------------------------判断题判题部分---------------------------'
if Tk_pdt_display > 0 then
	tkstr = tkstr & "<p align=center>判断题</p>"
	for i=1 to Tk_pdt_Display
		sql = "select stu.sname,tk.* from tk inner join stu on tk.inputerID=stu.id where Ntmbh=" & tmnopdt(i)
		rs.open sql,conn,1,1
		if not rs.eof then
			
			if isnull(rs("info")) then info = " " else info = rs("info")

			if trim(rs("czqda")) = tmdapdt(i) then
				zongfen = zongfen + 1
				pdt_score = pdt_score + pdt_value   '高职考判断题1题1分
			else  '做错的情况'
				tkstr = tkstr & "<table class='table'><tr><td valign='middle' bgcolor='#EEEEEE' class='daynav'>"
				tkstr = tkstr & "<span class='wronganswer'>你的答案: " & showPdtResult(tmdapdt(i)) & "     正确答案: " & showPdtResult(rs("czqda")) & "</span></td></tr>"
				tkstr = tkstr & "<tr><td valign='top' class='daynav'><pre>" & i & ". " & new_text(New_id,rs("ntmbh")) & ubbToHtml(rs("ctm"),"img") & "</pre></td></tr>"
				tkstr = tkstr & "<tr><td height='6' valign='top' class='daynav'>&nbsp;</td></tr>"
				tkstr = tkstr & "<tr><td height='22' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>录入者：" & rs("sname") & "</td></tr>"
				tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>题目(" & rs("ntmbh") & ")解析：" & replace(info,chr(13),"<br/><br/>") & "</td></tr>"
				tkstr = tkstr & "</table><br/><hr>"
				countErrors rs   '统计错题'
			end if

		end if
		rs.close
	next
end if

	if session("isSubmitted") = 1 then   '已提交过试卷'
		Response.Write("<p align='center' class='jiaojuanchenggong'>你已交过卷, 请不要重复提交</p>")
	else
		'------------------------将学生的得分存入数据库
		sql = "insert into stucj(stuid,score,tjsj,tknostr,tmdastr) values(" & stuid & "," & xzt_score + dxt_score + pdt_score & ",'" & Now & "','" & Trim(tknostr) & "','" & tmdastr & "')"
		sql2 = "insert into stucj_chapter(stuid,score,tjsj,tknostr,tmdastr,chapterID) values(" & stuid & "," & xzt_score + dxt_score + pdt_score & ",'" & Now & "','" & Trim(tknostr) & "','" & tmdastr & "'," & chapterID & ")"

		if zongfen >=0 then   '低于0个的不做记录, 章节练习也不做记录'
			if isChapterPractice then  '是章节练习，就插入章节成绩表'
				conn.execute(sql2)
			else
		   		conn.execute(sql)
		   	end if
		end if
		'------------------------
    end if

	response.Write("<p align='center' class=jieguo>" & session("sjtk_user") & "同学")

	if Tk_xzt_Display + Tk_dxt_Display + Tk_pdt_Display - zongfen = 0 then  '拿了满分'
		response.write "<h1 align='center' class='full-mark'>" & xzt_score+dxt_score+pdt_score & "分</h1>"
		response.write "<h2 align='center'>恭喜你，全部做对</h2>"
		response.Write("<br/><p align='center' class='try-again'><a href='stu-singlereset.asp'>这些题只是沧海一粟，再练一次巩固巩固!</a></p>")
	else

	'显示做错的选择题
	response.Write("在" & Tk_xzt_Display + Tk_dxt_Display + Tk_pdt_Display & "道题中,你一共做对<span class=wronganswer>" & zongfen & "</span>题, 做错<span class=wronganswer>" & Tk_xzt_Display + Tk_dxt_Display + Tk_pdt_Display - zongfen & "</span>题</p>")
	response.Write("<p align='center'>其中在" & Tk_xzt_Display & "道单选题中,你一共做对<span class=wronganswer>" & xzt_score/xzt_value & "</span>题")
	
	if Tk_dxt_Display > 0 then 
		response.Write("<p align='center'>其中在" & Tk_dxt_Display & "道多选题中,你一共做对<span class=wronganswer>" & dxt_score/dxt_value & "</span>题")
	end if
	
	if Tk_pdt_Display > 0 then
		response.Write("<p align='center'>在" & Tk_pdt_Display & "道判断题中,你一共做对<span class=wronganswer>" & pdt_score/pdt_value & "</span>题")
	end if

	response.Write("<p align='center' class='jieguo'>共 <span class=wronganswer>" & xzt_score + dxt_score + pdt_score & "</span> 分</p>")
	response.Write("<p align='center'><a href='index.asp'>返回首页</a> <a href='logout.asp'>注销</a></p><br/><br/>")
	response.Write("<p align='center' class=jieguo>做错的题目</p>")
	response.Write(tkstr)
	response.Write("<br/><p align='center' class=jieguo><a href='stu-singlereset.asp'>我对自己的成绩不满意 重来一次!</a></p>")
'	Response.Write("<p align='center'><span class=jiaojuanchenggong>你已成功交卷, 请关闭本网页.</span></p>")
	end if

	rs2.close
	set rs = nothing
	set rs2 = nothing

else

	response.write "考试超时，请重新<a href='login.asp'>登录</a>"

end if
%>
</body>
</html>
<%

 Call CloseConn() %>
