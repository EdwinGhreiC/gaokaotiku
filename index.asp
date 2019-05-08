<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<% page_title = "��ҳ" %>
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
	  <h1>�߿����۳�̸�ϰ</h1>
	  <p class="student_name"><%=session("sjtk_user")%>(<%=session("sjtk_stuid")%>) �ѵ�¼ <a href="logout.asp" class="btn btn-logout btn-xs">�ǳ�</a> <a href="modifypassword.asp" class="btn btn-logout btn-xs">�޸�����</a></p><br>
	  <% if session("majorID") = 1 then %>
<!-- 	  <p>
	  	  <div style="font-size: 20px">ע�⣺�½̲ı��������Сϵͳ������������ԭ����<span class="text-danger">����Դ+����+CPU��</span>��Ϊ<span class="text-danger">����Դ+����+CPU+�ڴ桱</span>����ͬѧ�Ǹ���֪ʶ�㡣</div>
	  </p> -->
	  <% end if %>
	  <p>
	  	<a class="btn btn-primary btn-lg" href="practice.asp">��ϰģʽ</a>
	  	<% if session("majorID") = 1 then %>
	  	<a class="btn btn-primary btn-lg" href="simexam.asp?seid=<%=se_id%>">ģ�⿼</a>
	  	<% end if %>
	  	<a class="btn btn-default btn-lg" href="view2.asp?mid=<%=session("majorID")%>">ÿ���ۺ���ϰ����</a>
	  	<a class="btn btn-default btn-lg" href="viewc.asp?mid=<%=session("majorID")%>">ÿ���½���ϰ����</a>
	  	<a class="btn btn-default btn-lg" href="errorsets.asp?mid=<%=session("majorID")%>">�����</a>	  	
	  </p>
	  <p>
	  	<a class="btn btn-default btn-sm" href="question_edit.asp?mid=<%=session("majorID")%>">�༭��Ŀ <%if session("grade")>=3 then response.write "<span class=""text-danger""> (����Ա)</span>"%></a>
	  	<a class="btn btn-default btn-sm" href="admin_add_tklr.asp?qtp=1">��ѡ��¼��</a>
	  	<% if session("majorID") = 1 then %>
	  	<a class="btn btn-default btn-sm" href="admin_add_tklr.asp?qtp=3">��ѡ��¼��</a>
	  	<a class="btn btn-default btn-sm" href="admin_add_tklr.asp?qtp=2">�ж���¼��</a>
	  	<% end if %>
	  </p>
	  <p>
		<div class="dropdown">
		  <button class="btn btn-default dropdown-toggle" type="button" id="chapter-practice" data-toggle="dropdown">
		    �½���ϰ
		    <span class="caret"></span>
		  </button>
		  <ul class="dropdown-menu">
		  	<% for i=1 to CHAPTER_COUNT %>
		    <li><a href="practice.asp?action=chpt&cid=<%=i%>">�� <%=i%> ��</a></li>
		    <% next %>
		  </ul>
		</div>	  	
	  </p>
	  
	  <!--<p>
	  	<a class="btn btn-default btn-xs" href="#">����ģʽ(δ����)</a>
	  </p> 
	  <p>רҵID��<%=session("majorID")%></p>  -->
	
	</div>
</div>




<!--#include file="footer.asp" -->