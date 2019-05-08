<!--#include file="conn.asp"-->
<!--#include file="checkuser.asp"-->
<% page_title = "修改密码" %>
<!--#include file="header.asp"-->
	<style>
		body {
            font-family: "微软雅黑";
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
		<h2 align="center">修改密码成功 <a href="index.asp">返回首页</a></h2>	
	</div>
	<%  else  %>
	<div class="form-group">
		<h2 align="center">两次密码不一致 <a href="javascript:history.go(-1)">返回</a></h2>	
	</div>
	<%  end if  %>  
<%
	else
%>
	<div class="form-group">
		<h2>修改密码 <a href="index.asp">返回首页</a></h2>	
	</div>
	
	<form method="post" action="modifypassword.asp?action=submit">
		<div class="form-group">
			<input type="password" name="newpassword" class="form-control" placeholder="请输入新密码">
		</div>

		<div class="form-group">
			<input type="password" name="confirmpassword" class="form-control" placeholder="请再次确认">
		</div>

		<button type="submit" class="btn btn-primary btn-lg btn-block"><span class="glyphicon glyphicon-ok-sign"></span> 确认修改</button>
	</form>
<%	end if  %>
</div>
</body>
</html>