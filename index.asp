<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<% page_title = "首页" %>
<!--#include file="header.asp"-->
<style>
	.jumbotron {
		background-color: #fff;
	}

	.jumbotron .student_name {
		font-size: 14px;
		color: #d9534f;
		font-weight: 500;
	}

	.btn-logout {
		background-color: #ccc;
		color: #666;
	}

	.btn-default,.btn-primary {
		margin-bottom: 15px;
	}
</style>
</head>

<body>
<div class="container">
	<div class="jumbotron">
	  <h1>高考理论冲刺复习</h1>
	  <p class="student_name"><%=session("sjtk_user")%>(<%=session("sjtk_stuid")%>) 已登录 <a href="logout.asp" class="btn btn-logout btn-xs">登出</a> <a href="modifypassword.asp" class="btn btn-logout btn-xs">修改密码</a></p><br>
	  <% if session("majorID") = 1 then %>
<!-- 	  <p>
	  	  <div style="font-size: 20px">注意：新教材变更，将最小系统法的启动型由原来的<span class="text-danger">“电源+主板+CPU”</span>改为<span class="text-danger">“电源+主板+CPU+内存”</span>，请同学们更新知识点。</div>
	  </p> -->
	  <% end if %>
	  <p>
	  	<a class="btn btn-primary btn-lg" href="practice.asp">练习模式</a>
	  	<% if session("majorID") = 1 then %>
	  	<a class="btn btn-primary btn-lg" href="simexam.asp?seid=<%=se_id%>">模拟考</a>
	  	<% end if %>
	  	<a class="btn btn-default btn-lg" href="view2.asp?mid=<%=session("majorID")%>">每日综合练习排行</a>
	  	<a class="btn btn-default btn-lg" href="viewc.asp?mid=<%=session("majorID")%>">每日章节练习排行</a>
	  	<a class="btn btn-default btn-lg" href="errorsets.asp?mid=<%=session("majorID")%>">错题榜</a>	  	
	  </p>
	  <p>
	  	<a class="btn btn-default btn-sm" href="question_edit.asp?mid=<%=session("majorID")%>">编辑题目 <%if session("grade")>=3 then response.write "<span class=""text-danger""> (管理员)</span>"%></a>
	  	<a class="btn btn-default btn-sm" href="admin_add_tklr.asp?qtp=1">单选题录入</a>
	  	<% if session("majorID") = 1 then %>
	  	<a class="btn btn-default btn-sm" href="admin_add_tklr.asp?qtp=3">多选题录入</a>
	  	<a class="btn btn-default btn-sm" href="admin_add_tklr.asp?qtp=2">判断题录入</a>
	  	<% end if %>
	  </p>
	  <p>
		<div class="dropdown">
		  <button class="btn btn-default dropdown-toggle" type="button" id="chapter-practice" data-toggle="dropdown">
		    章节练习
		    <span class="caret"></span>
		  </button>
		  <ul class="dropdown-menu">
		  	<% for i=1 to CHAPTER_COUNT %>
		    <li><a href="practice.asp?action=chpt&cid=<%=i%>">第 <%=i%> 章</a></li>
		    <% next %>
		  </ul>
		</div>	  	
	  </p>
	  
	  <!--<p>
	  	<a class="btn btn-default btn-xs" href="#">考试模式(未开放)</a>
	  </p> 
	  <p>专业ID：<%=session("majorID")%></p>  -->
	
	</div>
</div>




<!--#include file="footer.asp" -->