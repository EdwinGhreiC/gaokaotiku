<!--#include file="conn.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->
<!--#include file="header.asp"-->
</head>
<body>
<%	
	stuID = val(request.querystring("stuid"))  '��ȡѧ�� ID �Ա�ֻ��ʾ��ѧ����¼��'
	chapterID = val(request.querystring("cid"))  '��ȡ�½� ID �Ա�ֻ��ʾ���µ���Ŀ'
	majorID = val(request.querystring("mid"))   'רҵ ID�� �ڶ�༶ʱ���Դ� url ��ȡ
	if majorID = 0 then majorID = 1   'Ĭ��Ϊ1���������'
	pstr = "?mid=" & majorID & "&stuid=" & stuID & "&cid=" & chapterID
%>
<%
	qid = fdc(request.form("qid"))
	if isnumeric(qid) then qid=clng(qid) else qid = 0
	ctm = server.htmlencode(trim(request.form("ctm")))
	ctmda = server.htmlencode(trim(request.form("ctmda")))
	czqda = replace(replace(trim(request.form("czqda")),",","")," ","")
	if czqda <> "" then czqda = ucase(czqda)  'һ��ת�ɴ�д
	chapter = val(server.htmlencode(trim(request.form("chapter"))))
	qtype = trim(request.form("qtype"))
	if qtype<>"" then if isnumeric(qtype) then qtype = cint(server.htmlencode(qtype))
	info = server.htmlencode(trim(request.form("info")))
	response.write ctm & "," & ctmda & "," & czqda
	if ctm <> "" and czqda <> "" then
		set rs = server.createobject("adodb.recordset")
		sql = "select * from tk where ntmbh=" & qid
		rs.open sql,conn,1,3
		rs("Ctm") = Ctm     '��Ŀ����
		rs("Ctmda") = Ctmda   '��Ŀѡ��
		rs("Czqda") = Czqda   '��ȷ��
		rs("chapter") = chapter      '��Ŀ�����½�
		rs("info") = info      '��Ŀ����
		if qtype<>"" then rs("class") = qtype    '��Ŀ���� ��ѡ�жϻ��Ƕ�ѡ
		rs.update
		rs.close
		set rs = nothing
		response.redirect "question_edit.asp" & pstr & "&qid=" & qid & "&tag=update-success&qtype=" & qtype 
	else
		response.write "ĳһ���Ϊ��<br>"
		response.write "<a href=""javascript:history.go(-1)"">����</a>"
	end if
%>

<!--#include file="footer.asp"-->