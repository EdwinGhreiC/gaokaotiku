<!--#include file="conn.asp" -->
<!--#include file="checkuser.asp" -->
<% 	if session("grade")>=4 then %>
<%
		dim sql,sql2,sql3
		sql = "update stu set loginstatus=0"
		sql2 = "delete from Stutest"
		conn.execute(sql)
		conn.execute(sql2)
		page_title = "ȫ��ѧ�����óɹ�"
	else
		page_title = "û��Ȩ�޲鿴����ҳ"
	end if

	Call CloseConn()
%>
<!--#include file="header.asp"-->
</head>
<body>
    <%=page_title%>
</body>
</html>
