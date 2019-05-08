<!--#include file="checkuser.asp"-->
<% page_title = "判断题录入" %>
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
	<% session("isInputing") = "0"   '重置录入状态 %>
	<div class="text-center"> <h2>判断题录入</h2> </div>
	<div class="nr">
		<form method="post" action="save_question.asp">
			<p>题目内容<br /><textarea class="form-control" rows="3" name="tmnr" value=""></textarea><p>
			<p> 正确答案 </p>
			<p> 对 <br /><input type="radio" name="zqda" value="A"><br /><p>
			<p> 错 <br /><input type="radio" name="zqda" value="B"><br /><p>

			<p>
				<% chapter_dropdown %>	
			</p>

			<p>题目分析<br /><textarea class="form-control" rows="3" name="tmfx" value=""></textarea></p>
			
			<p><input type="submit" class="btn btn-primary btn-lg" name="submit" value="保存"><br /><p>
			<input type= "hidden"  name="qtype" value = "2">
		</form>
	</div>
<!--#include file="footer.asp"-->