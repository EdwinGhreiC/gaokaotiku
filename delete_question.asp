<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<%  
page_title = "ɾ���ļ��ɹ�"
action = fdc(trim(request.querystring("action")))
questionID = val(fdc(trim(request.querystring("qid"))))

sessionID = val(session("sjtk_stuid"))
if session("grade")<4 and action="delf" then
	outMsg = "��û��Ȩ��ִ�д˲���"
else
	if action="del" then
		if session("grade")<3 then    'Ȩ��С��3��Ҫ����Ƿ���¼����'
			sql = "update tk set isDeleted=yes where inputerID=" & sessionID & " and ntmbh=" & questionID
		else
			sql = "update tk set isDeleted=yes where ntmbh=" & questionID
		end if
		conn.execute(sql)
		outMsg = "��ɾ����Ŀ <span class=""text-danger""> " & questionID & "</span>" 
	elseif action="delf" then
		sql = "delete from tk where ntmbh=" & questionID
		conn.execute(sql)
		outMsg = "������ɾ����Ŀ <span class=""text-danger""> " & questionID & "</span>" 
	end if
end if
%>
<!--#include file="header.asp"-->
<%	
	stuID = val(request.querystring("stuid"))  '��ȡѧ�� ID �Ա�ֻ��ʾ��ѧ����¼��'
	chapterID = val(request.querystring("cid"))  '��ȡ�½� ID �Ա�ֻ��ʾ���µ���Ŀ'
	majorID = val(request.querystring("mid"))   'רҵ ID�� �ڶ�༶ʱ���Դ� url ��ȡ
	if majorID = 0 then majorID = 1   'Ĭ��Ϊ1���������'
	pstr = "?mid=" & majorID & "&stuid=" & stuID & "&cid=" & chapterID
%>
</head>
<body>
	<div class="container">
		<h2><%=outMsg%></h2>
		<h4><a href="question_edit.asp<%=pstr%>">����</a></h4>
	</div>

<!--#include file="footer.asp"-->

