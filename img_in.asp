<!--#include file="conn.asp"-->
<!--#include file="img_upload_module.asp"-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>导入Excel</title>
</head>

<body>
<!--#include file="excel_filesave.asp"-->
<%
dim conn_excel,conn_excel_str,rsexcel,sqlexcel,sqlexceldel,classid,courseid,rsexcel_table,i,rsexcelrepeat,teacherid,rscheck,isSusccess
isSusccess = 0    '这个变量是导入成功与否的标志
'------------建立与Excel的连接-------------------
Set conn_excel = Server.CreateObject("adodb.connection")  
'response.Write(server.MapPath("upload_excel/Student.xls"))
conn_excel_str = "Provider=Microsoft.Jet.OLEDB.4.0;Extended Properties='Excel 8.0;HDR=YES;IMEX=1';Data Source=" & Server.MapPath(UPfilename)
'要导入xslx 用这句 "Provider=Microsoft.Ace.OLEDB.12.0;Extended Properties='Excel 12.0;HDR=YES;IMEX=1';Data Source=" & Server.MapPath("upload_excel\Student.xls")
conn_excel.open conn_excel_str
'---------------------------------------------------
'set rsexcel = Server.CreateObject("Adodb.recordset")  '这句话加了反而不好, 不能使用movenext
set rsexcel = conn_excel.OpenSchema(20)       '  adSchemaTables=20    取得建立的第一张表名, 用来给后面查询 
classid = Trim(gsexcelupload.Form("tclsid"))
courseid = Trim(gsexcelupload.Form("tcrsid"))
'--------开始验证教师是否有权限导入------------
if Session("id")="" then
   Response.Write "登录超时"
   Response.End()
end if
teacherid = Session("id")
set rscheck = conn.execute("select  id from teacher_courses where teacher_id=" & teacherid & " and teacher_classid=" & classid & " and teacher_courseid=" & courseid)
if rscheck.eof then
   Response.Write("导入失败, 似乎你没有导入的权限")
   Response.End()
end if
'--------结束验证

set  rsexcel_table =  Server.CreateObject("Adodb.recordset")
'response.Write rsexcel.recordcount
'rsexcel.move(2)   '移动n条记录
response.write(rsexcel("table_name") & "<br />")    '如果不movenext, 不做循环, 取得的就是第一张表

 rsexcel_table.open "Select * from [" & rsexcel("table_name") & "]",conn_excel,1,1
set  rsexcelrepeat =  Server.CreateObject("Adodb.recordset")

for i=1 to rsexcel_table.recordcount
		'response.write(rsexcel_table("成绩") & "&nbsp;")  调试用
	if isnumeric(rsexcel_table("id"))=True and isnumeric(rsexcel_table("成绩"))=True and rsexcel_table("成绩")<>"" then
		rsexcelrepeat.open "Select * from score_05_2_qimo where studentid=" & rsexcel_table("id") & " and classid=" & classid & " and courseid=" & courseid,conn,1,1    '判断要插入的记录是否已存在
			if not rsexcelrepeat.eof then
				sqlexcel = "update score_05_2_qimo set score3=" & cint(rsexcel_table("成绩")) & " where id =" & rsexcelrepeat("id")  '如果记录存在, 则更新
			else 
				sqlexcel = "insert into score_05_2_qimo(studentid,classid,courseid,score3) values(" & rsexcel_table("ID") & "," & classid & "," & courseid & "," & cint(rsexcel_table("成绩")) & ")"  ' 如果记录不存在则插入新记录
			end if
		conn.execute(sqlexcel)
		rsexcelrepeat.close
		rsexcel_table.movenext
	else   ' 输入不对怎么办
		Response.Write("成绩未导入，可能是成绩为空或输入格式有误。 <br /> <strong>位置:  " & rsexcel_table("id") & "     " & rsexcel_table("学生姓名") & "     " & rsexcel_table("成绩") & "</strong><br />")
		rsexcel_table.movenext
		isSusccess = 1
	end if
next
if isSusccess=0 then
   response.Write("导入成功<br /> <input type='button' value='关闭窗口' onClick='window.close();'>")   '只能关闭target:_blank打开的窗口
elseif isSusccess=1 then
   response.write("导入完毕<br /> <input type='button' value='关闭窗口' onClick='window.close();'>")
end if

rsexcel_table.close
conn_excel.close

set rsexcel_table = nothing
set rsexcelrepeat = nothing
set rsexcel = nothing
set conn_excel = nothing
%>
<script language=javascript>
if(window.opener&&window.opener.refreshit)
 window.opener.refreshit();  //父页面刷新, 父页面就是打开此页面的链接所在的那个页面
</script>
</body>
</html>
