<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<% page_title = "���ģ�⿼" %>
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
		<h2><%=page_title%> <a href="index.asp">����</a></h2>
	</div>
	<div class="nr">
		<form method="post" action="save_sim.asp">
			<label>ģ�⿼����</label>
			<input name="exam_name" type="text" class="form-control">
			<label>ģ�⿼ʱ��</label>
			<input name="exam_time" type="text" class="form-control">


			<h3>�����Ŀ��</h3>

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


			<p><button type="submit" class="btn btn-primary btn-lg" id="saveBtn" data-loading-text="���ڱ���..." name="submit" autocomplete="off">����</button></p>
		</form>	
	</div>
	<br><br><br>
<!--#include file="footer.asp"-->













