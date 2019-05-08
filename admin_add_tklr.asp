<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->
<%  qtype = val(request.querystring("qtp")) 
	select case qtype
		case 1
			outstr = "单选题"
		case 3
			outstr = "多选题"
		case 2
			outstr = "判断题"
		case else
			outstr = "未知题型"
	end select
%>
<% page_title = outstr & "录入" %>
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
	<% 'session("isInputing") = "0"   '重置录入状态 %>
	
	<div class="text-center">
		<h2><%=outstr & "录入"%> <a href="index.asp">返回</a></h2>
		<span class="text-danger">只能上传 jpg/png/gif 结尾的图片</span><br><br>
	</div>
	<div class="nr">
		<form method="post" enctype="multipart/form-data" action="admin_save_question.asp">
			<p>题目内容<br /><textarea class="form-control" rows="3" name="tmnr" value=""></textarea></p>
			<p>		
				<input type="file" name="img_question">					
			</p>
			<% if qtype = 1 or qtype = 3 then %>
			<p>A<br /><input type="text" class="form-control" rows="3" name="A" value=""><input type="file" name="img_question_op_a"></p>
			<p>B<br /><input type="text" class="form-control" rows="3" name="B" value=""><input type="file" name="img_question_op_b"></p>
			<p>C<br /><input type="text" class="form-control" rows="3" name="C" value=""><input type="file" name="img_question_op_c"></p>
			<p>D<br /><input type="text" class="form-control" rows="3" name="D" value=""><input type="file" name="img_question_op_d"></p>
			<% end if %>
			<p> 正确答案 </p>
			<% 
				if qtype=1 or qtype=3 then
					inputType = ""
					if qtype=1 then
						inputType = "radio"
					elseif qtype=3 then
						inputType = "checkbox"
					end if
			%>
			<p>
			<%
				for i=1 to 4   '循环生成4个选项'
			%>
				<label for="<%=inputType & i%>" class="<%=inputType%>-inline">
					<input type="<%=inputType%>" name="zqda" id="<%=inputType & i%>" value="<%=chr(96+i)%>"> <%=chr(64+i)%>
				</label>
			<%
				next
			%>
			</p>
			<% elseif qtype=2 then %>
				<p>
					<label for="radio1" class="radio-inline">
						<input type="radio" name="zqda" id="radio1" value="A"> 正确
					</label>
					<label for="radio2" class="radio-inline">
						<input type="radio" name="zqda" id="radio2" value="B"> 错误
					</label>
				<p>	
			<% end if %>
			<% if session("majorID") = 1 then %>
			<p>
				<% chapter_dropdown %>
			</p>
			<% end if %>

			<p>题目分析<br /><textarea class="form-control" rows="3" name="tmfx" value=""></textarea></p>

			<p><button type="submit" class="btn btn-primary btn-lg" id="saveBtn" data-loading-text="正在保存..." name="submit" autocomplete="off">保存</button></p>
			<input type= "hidden"  name="qtype" value = "<%=qtype%>">
		</form>	
	</div>
	<br><br><br>
<!--#include file="footer.asp"-->













