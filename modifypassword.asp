<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<% page_title = "�޸�����" %>
<!--#include file="header.asp"-->
	<style>
		body {
            font-family: "΢���ź�";
			background-color: #eee;
		}
		.login {
			background-color: #fff;
			margin: 50px auto 50px auto;
			max-width: 400px;
			padding: 40px;
			border: 1px solid #ddd;
			box-shadow: 1px 1px 2px #eee;
			border-radius: 4px;
		}
		h2 {
			font-size: 20px;
		}
	</style>
</head>
<body>
<div class="login">
<%
	action = request.querystring("action")
	if action <> "" then
		newpassword = request.form("newpassword")
		confirmpassword = request.form("confirmpassword")
		if newpassword = confirmpassword then
			sessionID = clng(session("sjtk_stuid"))
			sql = "update stu set pwd='" & newpassword & "' where id=" & sessionID
			conn.execute(sql)
%>
	<div class="form-group">
		<h2 align="center">�޸�����ɹ� <a href="index.asp">������ҳ</a></h2>	
	</div>
	<%  else  %>
	<div class="form-group">
		<h2 align="center">�������벻һ�� <a href="javascript:history.go(-1)">����</a></h2>	
	</div>
	<%  end if  %>  
<%
	else
%>
	<div class="form-group">
		<h2>�޸����� <a href="index.asp">������ҳ</a></h2>	
	</div>
	
	<form method="post" action="modifypassword.asp?action=submit">
		<div class="form-group">
			<input type="password" name="newpassword" class="form-control" placeholder="������������">
		</div>

		<div class="form-group">
			<input type="password" name="confirmpassword" class="form-control" placeholder="���ٴ�ȷ��">
		</div>

		<button type="submit" class="btn btn-primary btn-lg btn-block"><span class="glyphicon glyphicon-ok-sign"></span> ȷ���޸�</button>
	</form>
<%	end if  %>
</div>
</body>
</html>