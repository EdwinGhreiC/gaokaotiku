<!--#include file="conn.asp" -->
<!--#include file="config.asp" -->
<!--#include file="function.asp" -->
<%
if session("sjtk_user")<>"" then   '��ֹû�� session �ˣ������±�Խ�磬��Ϊ��Щ�༶����ʾ�����Ǹ��� session �ġ�'

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
	Dim rs,rs2,sql,sql2,i,tkstr,tknostr,tmdastr    'tkstr : �ύ�󿴵�����Ŀ
	Dim zongfen     '��Ը����ۼ�
	Dim stuid       '��session��ȡ��ID�ŷ���˱���
	dim xzt_score   '��ѡ��÷�
	dim dxt_score   '��ѡ��÷�
	dim pdt_score   '�ж���÷�
	dim xzt_value   '��ѡ��ÿ���ֵ'
	dim dxt_value   '��ѡ��ÿ���ֵ'
	dim pdt_value   '�ж���ÿ���ֵ'

	xzt_value = 1.5    '��ѡ���ֵ'
	pdt_value = 1      '�ж����ֵ'
	dxt_value = 3      '��ѡ���ֵ'

	zongfen = 0
	xzt_score = 0
	pdt_score = 0
	tknostr = ""
	tmdastr = ""

	'��ȡ�Ƿ����½���ϰ����Ϣ'
	isChapterPractice = fdc(request.form("isCptp"))
	chapterID = val(request.form("cid"))
	if isChapterPractice = "y" then
		isChapterPractice = true
	else
		isChapterPractice = false
	end if
	changeQuestionCount isChapterPractice


	for i=1 to Tk_xzt_Display     '��ȡѧ����ѡ��Ĵ�����'
	    tmdaxzt(i)=Trim(Request.Form("tmxzt" & i))   '����ѡ��Ĵ�
	    tmnoxzt(i)=Val(Trim(Request.Form("sjnoxzt" & i)))  '��Ŀid
	    tknostr = tknostr & "|" & CStr(tmnoxzt(i))
	    if tmdaxzt(i)="" then
	       tmdastr= tmdastr & tmnoxzt(i) & "." & "N" & "|"
	    else
	       tmdastr= tmdastr & tmnoxzt(i) & "." & tmdaxzt(i) & "|"
	    end if
	next

	for i=1 to Tk_dxt_Display     '��ȡѧ����ѡ��Ĵ�����'
	    tmdadxt(i)=replace(replace(Trim(Request.Form("tmdxt" & i)),",","")," ","")   '����ѡ��Ĵ�, ȥ�����ź��м�Ŀո�
	    tmnodxt(i)=Val(Trim(Request.Form("sjnodxt" & i)))  '��Ŀid
	    tknostr = tknostr & "|" & CStr(tmnodxt(i))
	    if tmdadxt(i)="" then
	       tmdastr= tmdastr & tmnodxt(i) & "." & "N" & "|"
	    else
	       tmdastr= tmdastr & tmnodxt(i) & "." & tmdadxt(i) & "|"
	    end if
	next

	for i=1 to Tk_pdt_Display      '��ȡѧ���ж���Ĵ�����'
	    tmdapdt(i)=Trim(Request.Form("tmpdt" & i))   '����ѡ��Ĵ�
	    tmnopdt(i)=Val(Trim(Request.Form("sjnopdt" & i)))  '��Ŀid
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
	if not rs2.eof then   '˵����¼�Ѵ��ڣ������ύ'
		session("isSubmitted") = 1   '��Ϊ0��ʾ���ύ������Ծ�'
	else
		session("isSubmitted") = 0   '��Ϊ0��ʾδ�ύ������Ծ�'
	end if

'--------------------------��ѡ�����ⲿ��---------------------------'
tkstr = tkstr & "<p align=center>����ѡ����</p>"
for i=1 to Tk_xzt_Display
    sql = "select stu.sname,tk.* from tk inner join stu on tk.inputerID=stu.id where Ntmbh=" & tmnoxzt(i)
    rs.open sql,conn,1,1
	if not rs.eof then
		if isnull(rs("info")) then info = " " else info = rs("info")

		if trim(rs("czqda")) = tmdaxzt(i) then
			zongfen = zongfen + 1    
		  	xzt_score = xzt_score + xzt_value   '��ְ����ѡ��1��1.5��
		else   '��������'
			tkstr = tkstr & "<table class='table'><tr><td>"
			tkstr = tkstr & "<span class='wronganswer'>��Ĵ�: " & tmdaxzt(i) & "&nbsp;&nbsp;&nbsp;��ȷ��: " & rs("czqda") & "</span></td></tr>"
			tkstr = tkstr & "<tr><td valign='top' class='daynav'><pre>" & i & ". " & new_text(New_id,rs("ntmbh")) & ubbToHtml(rs("ctm"),"img") & "</pre></td></tr>"
			tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav'>" & replace(rs("ctmda"),chr(13),"<br/><br/>") & "</td></tr>"
			tkstr = tkstr & "<tr><td height='6' valign='top' class='daynav'>&nbsp;</td></tr>"
			tkstr = tkstr & "<tr><td height='22' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>¼���ߣ�" & rs("sname") & "</td></tr>"
			tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>��Ŀ(" & rs("ntmbh") & ")������" & replace(info,chr(13),"<br/><br/>") & "</td></tr>"
			tkstr = tkstr & "</table><br/><hr>"
			countErrors rs   'ͳ�ƴ���'
		end if
	end if

	rs.close
next

'--------------------------��ѡ�����ⲿ��---------------------------'
if Tk_dxt_Display > 0 then
	tkstr = tkstr & "<p align=center>����ѡ����</p>"
	for i=1 to Tk_dxt_Display
	    sql = "select stu.sname,tk.* from tk inner join stu on tk.inputerID=stu.id where Ntmbh=" & tmnodxt(i)
	    rs.open sql,conn,1,1
		if not rs.eof then

			if isnull(rs("info")) then info = " " else info = rs("info")

			if trim(rs("czqda")) = tmdadxt(i) then
				zongfen = zongfen + 1    
				dxt_score = dxt_score + dxt_value   '��ְ����ѡ��1��3��
			else   '��������'
				tkstr = tkstr & "<table class='table'><tr><td>"
				tkstr = tkstr & "<span class='wronganswer'>��Ĵ�: " & tmdadxt(i) & "&nbsp;&nbsp;&nbsp;��ȷ��: " & rs("czqda") & "</span></td></tr>"
				tkstr = tkstr & "<tr><td valign='top' class='daynav'><pre>" & i & ". " & new_text(New_id,rs("ntmbh")) & ubbToHtml(rs("ctm"),"img") & "</pre></td></tr>"
				tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav'>" & replace(rs("ctmda"),chr(13),"<br/><br/>") & "</td></tr>"
				tkstr = tkstr & "<tr><td height='6' valign='top' class='daynav'>&nbsp;</td></tr>"
				tkstr = tkstr & "<tr><td height='22' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>¼���ߣ�" & rs("sname") & "</td></tr>"
				tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>��Ŀ(" & rs("ntmbh") & ")������" & replace(info,chr(13),"<br/><br/>") & "</td></tr>"
				tkstr = tkstr & "</table><br/><hr>"
				countErrors rs   'ͳ�ƴ���'
			end if
		end if

		rs.close
	next
end if

'--------------------------�ж������ⲿ��---------------------------'
if Tk_pdt_display > 0 then
	tkstr = tkstr & "<p align=center>�ж���</p>"
	for i=1 to Tk_pdt_Display
		sql = "select stu.sname,tk.* from tk inner join stu on tk.inputerID=stu.id where Ntmbh=" & tmnopdt(i)
		rs.open sql,conn,1,1
		if not rs.eof then
			
			if isnull(rs("info")) then info = " " else info = rs("info")

			if trim(rs("czqda")) = tmdapdt(i) then
				zongfen = zongfen + 1
				pdt_score = pdt_score + pdt_value   '��ְ���ж���1��1��
			else  '��������'
				tkstr = tkstr & "<table class='table'><tr><td valign='middle' bgcolor='#EEEEEE' class='daynav'>"
				tkstr = tkstr & "<span class='wronganswer'>��Ĵ�: " & showPdtResult(tmdapdt(i)) & "     ��ȷ��: " & showPdtResult(rs("czqda")) & "</span></td></tr>"
				tkstr = tkstr & "<tr><td valign='top' class='daynav'><pre>" & i & ". " & new_text(New_id,rs("ntmbh")) & ubbToHtml(rs("ctm"),"img") & "</pre></td></tr>"
				tkstr = tkstr & "<tr><td height='6' valign='top' class='daynav'>&nbsp;</td></tr>"
				tkstr = tkstr & "<tr><td height='22' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>¼���ߣ�" & rs("sname") & "</td></tr>"
				tkstr = tkstr & "<tr><td height='52' valign='top' class='daynav' style='font-size:10px;font-weight:600;'>��Ŀ(" & rs("ntmbh") & ")������" & replace(info,chr(13),"<br/><br/>") & "</td></tr>"
				tkstr = tkstr & "</table><br/><hr>"
				countErrors rs   'ͳ�ƴ���'
			end if

		end if
		rs.close
	next
end if

	if session("isSubmitted") = 1 then   '���ύ���Ծ�'
		Response.Write("<p align='center' class='jiaojuanchenggong'>���ѽ�����, �벻Ҫ�ظ��ύ</p>")
	else
		'------------------------��ѧ���ĵ÷ִ������ݿ�
		sql = "insert into stucj(stuid,score,tjsj,tknostr,tmdastr) values(" & stuid & "," & xzt_score + dxt_score + pdt_score & ",'" & Now & "','" & Trim(tknostr) & "','" & tmdastr & "')"
		sql2 = "insert into stucj_chapter(stuid,score,tjsj,tknostr,tmdastr,chapterID) values(" & stuid & "," & xzt_score + dxt_score + pdt_score & ",'" & Now & "','" & Trim(tknostr) & "','" & tmdastr & "'," & chapterID & ")"

		if zongfen >=0 then   '����0���Ĳ�����¼, �½���ϰҲ������¼'
			if isChapterPractice then  '���½���ϰ���Ͳ����½ڳɼ���'
				conn.execute(sql2)
			else
		   		conn.execute(sql)
		   	end if
		end if
		'------------------------
    end if

	response.Write("<p align='center' class=jieguo>" & session("sjtk_user") & "ͬѧ")

	if Tk_xzt_Display + Tk_dxt_Display + Tk_pdt_Display - zongfen = 0 then  '��������'
		response.write "<h1 align='center' class='full-mark'>" & xzt_score+dxt_score+pdt_score & "��</h1>"
		response.write "<h2 align='center'>��ϲ�㣬ȫ������</h2>"
		response.Write("<br/><p align='center' class='try-again'><a href='stu-singlereset.asp'>��Щ��ֻ�ǲ׺�һ�ڣ�����һ�ι��̹���!</a></p>")
	else

	'��ʾ�����ѡ����
	response.Write("��" & Tk_xzt_Display + Tk_dxt_Display + Tk_pdt_Display & "������,��һ������<span class=wronganswer>" & zongfen & "</span>��, ����<span class=wronganswer>" & Tk_xzt_Display + Tk_dxt_Display + Tk_pdt_Display - zongfen & "</span>��</p>")
	response.Write("<p align='center'>������" & Tk_xzt_Display & "����ѡ����,��һ������<span class=wronganswer>" & xzt_score/xzt_value & "</span>��")
	
	if Tk_dxt_Display > 0 then 
		response.Write("<p align='center'>������" & Tk_dxt_Display & "����ѡ����,��һ������<span class=wronganswer>" & dxt_score/dxt_value & "</span>��")
	end if
	
	if Tk_pdt_Display > 0 then
		response.Write("<p align='center'>��" & Tk_pdt_Display & "���ж�����,��һ������<span class=wronganswer>" & pdt_score/pdt_value & "</span>��")
	end if

	response.Write("<p align='center' class='jieguo'>�� <span class=wronganswer>" & xzt_score + dxt_score + pdt_score & "</span> ��</p>")
	response.Write("<p align='center'><a href='index.asp'>������ҳ</a> <a href='logout.asp'>ע��</a></p><br/><br/>")
	response.Write("<p align='center' class=jieguo>�������Ŀ</p>")
	response.Write(tkstr)
	response.Write("<br/><p align='center' class=jieguo><a href='stu-singlereset.asp'>�Ҷ��Լ��ĳɼ������� ����һ��!</a></p>")
'	Response.Write("<p align='center'><span class=jiaojuanchenggong>���ѳɹ�����, ��رձ���ҳ.</span></p>")
	end if

	rs2.close
	set rs = nothing
	set rs2 = nothing

else

	response.write "���Գ�ʱ��������<a href='login.asp'>��¼</a>"

end if
%>
</body>
</html>
<%

 Call CloseConn() %>
