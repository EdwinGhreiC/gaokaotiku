<!--#include file="checkuser.asp"-->
<% page_title = "�ж���¼��" %>
<!--#include file="header.asp"-->
	<style >
		.nr{
    		max-width: 600px;
    		margin-right: auto;
    		margin-left: auto;
    		text-align: center;
		}
	</style>

</head>
<body>
	<% session("isInputing") = "0"   '����¼��״̬ %>
	<div class="text-center"> <h2>�ж���¼��</h2> </div>
	<div class="nr">
		<form method="post" action="save_question.asp">
			<p>��Ŀ����<br /><textarea class="form-control" rows="3" name="tmnr" value=""></textarea><p>
			<p> ��ȷ�� </p>
			<p> �� <br /><input type="radio" name="zqda" value="A"><br /><p>
			<p> �� <br /><input type="radio" name="zqda" value="B"><br /><p>

			<p>
				<% chapter_dropdown %>	
			</p>

			<p>��Ŀ����<br /><textarea class="form-control" rows="3" name="tmfx" value=""></textarea></p>
			
			<p><input type="submit" class="btn btn-primary btn-lg" name="submit" value="����"><br /><p>
			<input type= "hidden"  name="qtype" value = "2">
		</form>
	</div>
<!--#include file="footer.asp"-->