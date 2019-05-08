<!--#include file="conn.asp"-->

<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<% page_title = "题目编辑" %>
<!--#include file="header.asp"-->
<style>
	.panel-heading>div {
		display: inline-block;
	}
	
	.question-id {
		color: #d9534f;
		font-weight: 600;
		width: 100px;
	}

	.question-type {
		min-width: 120px;
	}

	.question-inputer {
		width: 200px;
	}

	.ctm-ctmda {
		min-height: 150px;
	}

	.czqda-chapter {
		min-height: 40px;
	}

	.info {
		min-height: 115px;
	}

	.ctm-ctmda .form-control {
		width: 100%;
	}

	.question-edit-body {
		background-color: #fafafa;
	}

</style>
</head>
<body>
<%	
	stuID = val(request.querystring("stuid"))  '获取学生 ID 以便只显示该学生的录入'
	chapterID = val(request.querystring("cid"))  '获取章节 ID 以便只显示该章的题目'
	majorID = val(request.querystring("mid"))   '专业 ID， 在多班级时可以从 url 获取
	if majorID = 0 then majorID = 1   '默认为1，计算机班'
	pstr = "?mid=" & majorID & "&stuid=" & stuID & "&cid=" & chapterID
%>

<div class="container">
	<h2 align="center">题目编辑 <a href="index.asp">返回</a></h2>
	
	<div class="panel panel-default form-inline">
		<% if session("grade")>=1 and session("simExamID")="" or session("grade")>=3 then  '管理员可以搜题，普通成员不在模拟考状态可以搜题' %>
		<form action="question_edit.asp" method="get" class="form-group">
	  		<div class="panel-body form-inline">
	    		<input type="text" class="form-control" name="qid" placeholder="输入题号">
	    		<input type="hidden" name="mid" value="<%=majorID%>">
	    		<input type="hidden" name="stuid" value="<%=stuID%>">
	    		<input type="hidden" name="cid" value="<%=chapterID%>">
	    		<input type="submit" value="搜索题号" class="btn btn-primary">
	  		</div>
  		</form>
  		<form action="question_edit.asp<%=pstr%>" method="get" class="form-group">
	  		<div class="panel-body form-inline">
	    		<input type="text" class="form-control" name="qwords" placeholder="输入内容">
	    		<input type="hidden" name="mid" value="<%=majorID%>">
	    		<input type="hidden" name="stuid" value="<%=stuID%>">
	    		<input type="hidden" name="cid" value="<%=chapterID%>">
	    		<input type="submit" value="搜索内容" class="btn btn-primary">
	  		</div>
  		</form>
		<% end if  %>
	</div>



<%	tag = fdc(request.querystring("tag"))   '显示修改成功的信息
	if tag = "update-success" then  %>
	<div class="alert alert-success alert-dismissible">
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		<strong>修改成功！</strong>
	</div>
	<a href="question_edit.asp<%=pstr%>" class="btn btn-primary btn-block btn-sm">返回全部题目</a>
<%	end if  %>

<%
	ntmbh = val(fdc(request.querystring("qid")))  '获取编号，有编号的网址页面只显示一道题目
	questionWords = server.htmlencode(replace(trim(request.querystring("qwords")),"'","''")) '转义单引号为两个单引号'
	currentPage = val(fdc(request.querystring("page")))   '获取当前页号
	set rs = server.createobject("adodb.recordset")
	'=============根据不同的用户等级处理不同的 SQL 语句================
	select case session("grade")
		case 3,4
			sql = "select * from tk where not isDeleted and majorID=" & majorID 
		case 1
			sql = "select * from tk where not isDeleted and majorID=" & majorID & " and inputerID=" & session("sjtk_stuid")
	end select
	'============================================================

	if ntmbh <> "" then 
		if ntmbh<>0 then 
			sql = sql & " and ntmbh=" & ntmbh
		end if
	end if 

	if stuID <> 0 then
		sql = sql & " and inputerID=" & stuID
	end if

	if chapterID <> 0 then
		sql = sql & " and chapter=" & chapterID
	end if

	if questionWords <> "" then
		sql = sql & " and ctm like '%" & questionWords & "%'"
	end if

	sql = sql & " order by ntmbh desc" 
	rs.open sql,conn,1,1
	'=========分页数据==================================================='
	if not rs.eof then
		rs.pagesize = PAGE_SIZE   '每页显示的记录数，在 config.asp 文件里修改
		if currentPage = 0 then currentPage = 1   '比第1页小就到第1页'
		if currentPage > rs.pagecount then currentPage = rs.pagecount  '比最后一页大就到最后一页'
		rs.absolutepage = currentPage   '设置当前页号
		totalPage = rs.pagecount  '总页数，放入参数，以便 rs 结束时仍能使用
	end if
	'==================================================================='

	for k=1 to rs.pagesize
		if rs.eof then exit for
%>	
	<form action="question_update.asp<%=pstr%>" method="post">
	<div class="panel panel-default">
		<div class="panel-heading">			
			<div class="question-id">[<%=k%>] <%=rs("ntmbh")%></div>
			<div class="question-type form-inline">
				<%=qtypeTxt(rs("class"))%>
				<% if session("grade")>=3 then %>
				<input type="text" name="qtype" class="form-control input-sm" placeholder="1 单，2 判，3 多" value="">
				<% end if %>
			</div>
			<div class="question-inputer">录入者：<%=inputerTxt(rs("inputerID"))%></div>
		</div>
		<div class="panel-body question-edit-body">
			
				<div class="ctm-ctmda">					
					<div class="question-ctm form-group col-sm-6">
						<label>题目描述</label>
						<textarea class="form-control left-control" name="ctm" rows="5"><%=rs("ctm")%></textarea>
					</div>
								
					<div class="question-ctmda form-group col-sm-6">
						<label>题目选项</label>
						<textarea class="form-control right-control" name="ctmda" rows="5"><%=rs("ctmda")%></textarea>
					</div>										
				</div>
				<div class="czqda-chapter">
					<div class="question-czqda form-group col-sm-6">
						<label>标准答案&nbsp;&nbsp;</label>
						<input class="form-control " type="text" name="czqda" value="<%=rs("czqda")%>">
					</div>
					<% if session("majorID") = 1 then %>
					<div class="question-chapter form-group col-sm-6">
						<label>所属章节&nbsp;&nbsp;</label>
						<% chapter_dropdown_editpage rs %>
					</div>
					<% end if %>
				</div>
				<div class="info col-sm-12">
					<label>题目分析</label>
					<textarea class="form-control" name="info" rows="3"><%=rs("info")%></textarea>
				</div>
				<div class="question-update-btn col-sm-6">
					<input type="submit" class="btn btn-primary" value="保存">
				</div>
				<div class="col-sm-6 text-right">
					<button type="button" class="btn btn-danger"  data-toggle="modal" data-target="#confirmDelete">删除</button>
					<% if session("grade")>3 then %>
					<button type="button" class="btn btn-warning" data-toggle="modal" data-target="#confirmDeleteForever">彻底删除</button>
					<% end if %>
				</div>
									
				<div class="modal fade" id="confirmDelete" tabindex="-1">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-body">
								<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
								确定要删除吗？
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
								<a href="delete_question.asp<%=pstr%>&action=del&qid=<%=rs("ntmbh")%>" class="btn btn-danger">删除</a>
							</div>
						</div>
					</div>
				</div>


				<div class="modal fade" id="confirmDeleteForever" tabindex="-1">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-body">
								<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
								确定要永久删除吗？
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
								<a href="delete_question.asp<%=pstr%>&action=delf&qid=<%=rs("ntmbh")%>" class="btn btn-danger">永久删除</a>
							</div>
						</div>
					</div>
				</div>
				
				<input type="hidden" name="qid" value="<%=rs("ntmbh")%>">					
		</div>
	</div>
	</form>
	<hr>
<%
	rs.movenext
	next
	rs.close
	set rs = nothing

%>

<nav aria-label="Page navigation">
  <ul class="pagination">
    <li>
      <a href="question_edit.asp?page=<%=currentPage-1%>&mid=<%=majorID%>&stu=<%=stuID%>&cid=<%=chapterID%>" aria-label="Previous">
        <span aria-hidden="true">&laquo;</span>
      </a>
    </li>
    <% for i=1 to 10 %>
    <li><a href="question_edit.asp?page=<%=i%>&mid=<%=majorID%>&stuid=<%=stuID%>&cid=<%=chapterID%>"><%=i%></a></li>
    <% if i=totalPage then exit for %>
    <% next %>
    <% if totalPage>10 then %>
    <li><a href="#">...</a></li>
    <li><a href="question_edit.asp?page=<%=totalPage%>&mid=<%=majorID%>&stuid=<%=stuID%>&cid=<%=chapterID%>"><%=totalPage%></a></li>
    <% end if %>
    <li>
      <a href="question_edit.asp?page=<%=currentPage+1%>&mid=<%=majorID%>&stuid=<%=stuID%>&cid=<%=chapterID%>" aria-label="Next">
        <span aria-hidden="true">&raquo;</span>
      </a>
    </li>
  </ul>
</nav>
<br><br><br>
</div>

<!--#include file="footer.asp"-->











