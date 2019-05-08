<!--#include file="conn.asp"-->
<!--#include file="checkadmin.asp"-->
<% page_title = "执行 SQL 语句" %>
<!--#include file="header.asp"-->
</head>

<body>
  <div class="container">
    <%	
       	action = Trim(Request.QueryString("action"))
       	sql = Trim(Request.Form("sqltext"))
       	if action = "Exec" then
    		conn.execute sql
            response.Write "执行语句成功！ " & sql
       	end if
    %>
    <form name="form1" method="post" action="sqlexe.asp?action=Exec">
      <p>
        <input name="sqltext" type="text" class="form-control" size="80">
      </p>
      <p>
        <input type="submit" name="Submit" value="提交" class="btn btn-primary">
      </p>
    </form>
  </div>
</body>
</html>