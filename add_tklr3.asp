<!--#include file="checkuser.asp"-->
<% page_title = "��ѡ��¼��" %>
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
	<div class="text-center"> <h2>��ѡ��¼��</h2> </div>
	<div class="nr">
		<form method="post" action="save_question.asp">
			<p>��Ŀ����<br /><textarea class="form-control" rows="3" name="tmnr" value=""></textarea></p>
			<p>A<br /><input type="text" class="form-control" rows="3" name="A" value=""></p>
			<p>B<br /><input type="text" class="form-control" rows="3" name="B" value=""></p>
			<p>C<br /><input type="text" class="form-control" rows="3" name="C" value=""></p>
			<p>D<br /><input type="text" class="form-control" rows="3" name="D" value=""></p>
			<p> ��ȷѡ�� </p>
			<p>
				<label for="checkbox1" class="checkbox-inline">
					<input type="checkbox" name="zqda" id="checkbox1" value="A"> A
				</label>
				<label for="checkbox2" class="checkbox-inline">
					<input type="checkbox" name="zqda" id="checkbox2" value="B"> B
				</label>
				<label for="checkbox3" class="checkbox-inline">
					<input type="checkbox" name="zqda" id="checkbox3" value="C"> C
				</label>
				<label for="checkbox4" class="checkbox-inline">
					<input type="checkbox" name="zqda" id="checkbox4" value="D"> D
				</label>
			</p>

			<p>
				<% chapter_dropdown %>	
			</p>

			<p>��Ŀ����<br /><textarea class="form-control" rows="3" name="tmfx" value=""></textarea></p>

			<p><input type="submit" class="btn btn-primary btn-lg" name="�ύ" value="����"></p>
			<p><input type= "hidden"  name="qtype" value = "3"></p>
		</form>
	</div>	
<!--#include file="footer.asp"-->









