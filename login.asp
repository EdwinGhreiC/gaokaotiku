<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="GBK">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>���м����רҵ���߲���</title>
	<link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css">
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
	<div class="form-group">
		<h2>��ְ�����۲������߲���(2018)</h2>	
	</div>
	
	<form method="post" action="check.asp">
		<div class="form-group">
			<input type="text" name="uid" class="form-control" placeholder="����/ѧ��">
		</div>

		<div class="form-group">
			<input type="password" name="pwd" class="form-control" placeholder="����">
		</div>

		<button type="submit" class="btn btn-primary btn-lg btn-block"><span class="glyphicon glyphicon-ok-sign"></span> �� ¼</button>
	</form>
</div>
</body>
</html>