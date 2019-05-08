<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<% page_title = "添加模拟考" %>
<!--#include file="header.asp"-->
	<style >
		.nr{
    		max-width: 600px;
    		margin-right: auto;
    		margin-left: auto;
    		text-align: center;
		}
	</style>
	<script>
		$(function(){
			$('#saveBtn').on('click', function(){
				var $btn = $(this).button('loading');
				setTimeout(function(){$btn.button('reset');},30000);
			})			
		})		
	</script>
</head>
<body>
	<div class="text-center">
		<h2><%=page_title%> <a href="index.asp">返回</a></h2>
	</div>
	<div class="nr">
		<form method="post" action="save_sim.asp">
			<label>模拟考标题</label>
			<input name="exam_name" type="text" class="form-control">
			<label>模拟考时间</label>
			<input name="exam_time" type="text" class="form-control">


			<h3>添加题目答案</h3>

			<%
			for i=1 to 100
			%>
			
			<div class="form-inline">
				<div class="form-group" style="margin-bottom: 15px">
						<%=i%>. <input type="text" class="form-control" name="answer<%=i%>"> 				
				</div>
				
			</div>

			<%
			next
			%>


			<p><button type="submit" class="btn btn-primary btn-lg" id="saveBtn" data-loading-text="正在保存..." name="submit" autocomplete="off">保存</button></p>
		</form>	
	</div>
	<br><br><br>
<!--#include file="footer.asp"-->













