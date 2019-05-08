<!--#include file="conn.asp"-->

<!--#include file="checkuser.asp"-->
<!--#include file="config.asp"-->
<!--#include file="function.asp"-->

<% page_title = "��Ŀ�༭" %>
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
	stuID = val(request.querystring("stuid"))  '��ȡѧ�� ID �Ա�ֻ��ʾ��ѧ����¼��'
	chapterID = val(request.querystring("cid"))  '��ȡ�½� ID �Ա�ֻ��ʾ���µ���Ŀ'
	majorID = val(request.querystring("mid"))   'רҵ ID�� �ڶ�༶ʱ���Դ� url ��ȡ
	if majorID = 0 then majorID = 1   'Ĭ��Ϊ1���������'
	pstr = "?mid=" & majorID & "&stuid=" & stuID & "&cid=" & chapterID
%>

<div class="container">
	<h2 align="center">��Ŀ�༭ <a href="index.asp">����</a></h2>
	
	<div class="panel panel-default form-inline">
		<% if session("grade")>=1 and session("simExamID")="" or session("grade")>=3 then  '����Ա�������⣬��ͨ��Ա����ģ�⿼״̬��������' %>
		<form action="question_edit.asp" method="get" class="form-group">
	  		<div class="panel-body form-inline">
	    		<input type="text" class="form-control" name="qid" placeholder="�������">
	    		<input type="hidden" name="mid" value="<%=majorID%>">
	    		<input type="hidden" name="stuid" value="<%=stuID%>">
	    		<input type="hidden" name="cid" value="<%=chapterID%>">
	    		<input type="submit" value="�������" class="btn btn-primary">
	  		</div>
  		</form>
  		<form action="question_edit.asp<%=pstr%>" method="get" class="form-group">
	  		<div class="panel-body form-inline">
	    		<input type="text" class="form-control" name="qwords" placeholder="��������">
	    		<input type="hidden" name="mid" value="<%=majorID%>">
	    		<input type="hidden" name="stuid" value="<%=stuID%>">
	    		<input type="hidden" name="cid" value="<%=chapterID%>">
	    		<input type="submit" value="��������" class="btn btn-primary">
	  		</div>
  		</form>
		<% end if  %>
	</div>



<%	tag = fdc(request.querystring("tag"))   '��ʾ�޸ĳɹ�����Ϣ
	if tag = "update-success" then  %>
	<div class="alert alert-success alert-dismissible">
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		<strong>�޸ĳɹ���</strong>
	</div>
	<a href="question_edit.asp<%=pstr%>" class="btn btn-primary btn-block btn-sm">����ȫ����Ŀ</a>
<%	end if  %>

<%
	ntmbh = val(fdc(request.querystring("qid")))  '��ȡ��ţ��б�ŵ���ַҳ��ֻ��ʾһ����Ŀ
	questionWords = server.htmlencode(replace(trim(request.querystring("qwords")),"'","''")) 'ת�嵥����Ϊ����������'
	currentPage = val(fdc(request.querystring("page")))   '��ȡ��ǰҳ��
	set rs = server.createobject("adodb.recordset")
	'=============���ݲ�ͬ���û��ȼ�����ͬ�� SQL ���================
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
	'=========��ҳ����==================================================='
	if not rs.eof then
		rs.pagesize = PAGE_SIZE   'ÿҳ��ʾ�ļ�¼������ config.asp �ļ����޸�
		if currentPage = 0 then currentPage = 1   '�ȵ�1ҳС�͵���1ҳ'
		if currentPage > rs.pagecount then currentPage = rs.pagecount  '�����һҳ��͵����һҳ'
		rs.absolutepage = currentPage   '���õ�ǰҳ��
		totalPage = rs.pagecount  '��ҳ��������������Ա� rs ����ʱ����ʹ��
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
				<input type="text" name="qtype" class="form-control input-sm" placeholder="1 ����2 �У�3 ��" value="">
				<% end if %>
			</div>
			<div class="question-inputer">¼���ߣ�<%=inputerTxt(rs("inputerID"))%></div>
		</div>
		<div class="panel-body question-edit-body">
			
				<div class="ctm-ctmda">					
					<div class="question-ctm form-group col-sm-6">
						<label>��Ŀ����</label>
						<textarea class="form-control left-control" name="ctm" rows="5"><%=rs("ctm")%></textarea>
					</div>
								
					<div class="question-ctmda form-group col-sm-6">
						<label>��Ŀѡ��</label>
						<textarea class="form-control right-control" name="ctmda" rows="5"><%=rs("ctmda")%></textarea>
					</div>										
				</div>
				<div class="czqda-chapter">
					<div class="question-czqda form-group col-sm-6">
						<label>��׼��&nbsp;&nbsp;</label>
						<input class="form-control " type="text" name="czqda" value="<%=rs("czqda")%>">
					</div>
					<% if session("majorID") = 1 then %>
					<div class="question-chapter form-group col-sm-6">
						<label>�����½�&nbsp;&nbsp;</label>
						<% chapter_dropdown_editpage rs %>
					</div>
					<% end if %>
				</div>
				<div class="info col-sm-12">
					<label>��Ŀ����</label>
					<textarea class="form-control" name="info" rows="3"><%=rs("info")%></textarea>
				</div>
				<div class="question-update-btn col-sm-6">
					<input type="submit" class="btn btn-primary" value="����">
				</div>
				<div class="col-sm-6 text-right">
					<button type="button" class="btn btn-danger"  data-toggle="modal" data-target="#confirmDelete">ɾ��</button>
					<% if session("grade")>3 then %>
					<button type="button" class="btn btn-warning" data-toggle="modal" data-target="#confirmDeleteForever">����ɾ��</button>
					<% end if %>
				</div>
									
				<div class="modal fade" id="confirmDelete" tabindex="-1">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-body">
								<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
								ȷ��Ҫɾ����
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal">�ر�</button>
								<a href="delete_question.asp<%=pstr%>&action=del&qid=<%=rs("ntmbh")%>" class="btn btn-danger">ɾ��</a>
							</div>
						</div>
					</div>
				</div>


				<div class="modal fade" id="confirmDeleteForever" tabindex="-1">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-body">
								<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
								ȷ��Ҫ����ɾ����
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal">�ر�</button>
								<a href="delete_question.asp<%=pstr%>&action=delf&qid=<%=rs("ntmbh")%>" class="btn btn-danger">����ɾ��</a>
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











