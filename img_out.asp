<!--#include file="conn.asp"-->
<% 'Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" 生成xlsx %>
<%' Response.ContentType = "application/vnd.ms-excel" %>
<%
response.write "duandian"
dim rsExcelOut,sql,conn_excel,app_excel,excel01,File_Excel_Path
set rsExcelOut = Server.Createobject("adodb.recordset")
set app_excel =CreateObject("Excel.Application")
app_excel.Application.Visible = False

'Set excel01 = app_excel.Workbooks.Add  '新建Excel
File_Excel_Path = Server.MapPath("upload_excel\Template_Excel.xls")  '根据模板打开

On Error Resume Next
Set excel01 = app_excel.Workbooks.Open(File_Excel_Path)
'if Err.number=9 then Set excel01=app_excel.Workbooks.Open(File_Excel_Path)


'excel01.WorkSheets(1).cells(1,1).value ="id"  
'excel01.WorkSheets(1).cells(1,2).value = "stu_name" 
'excel01.WorkSheets(1).cells(1,3).value = "cj" 

'------------获取科目名和班级名-----------
dim classid,courseid,ClassName,CourseName,rsClass,rsCourse
set rsClass = Server.Createobject("adodb.recordset")
set rsCourse = Server.Createobject("adodb.recordset")
classid = Trim(Request.Querystring("tclsid"))
courseid = Trim(Request.Querystring("tcrsid"))
sql = "Select * from class where id=" & classid

rsClass.open sql,conn,1,1
ClassName = rsClass("class_name")
rsClass.close
set rsClass=nothing
sql = "Select * from course where id=" & courseid
rsCourse.open sql,conn,1,1
CourseName = rsCourse("course_name")
rsCourse.close
set rsCourse=nothing
'-------------------------------------------

excel01.WorkSheets(1).cells(1,4).value = "  科目:" & CourseName

dim r  '行号
r=2 
sql="select * from student where class='" & ClassName & "'"
rsExcelOut.open sql,conn,1,1
Do while not rsExcelOut.eof 
excel01.WorkSheets(1).cells(r,1).value = rsExcelOut("id") 
excel01.WorkSheets(1).cells(r,2).value = rsExcelOut("stu_name") 
rsExcelOut.movenext 
r = r + 1 
Loop 
'randomize
'dim randnumber
'randnumber = int(rnd*10000+10000)
dim FileNameForDown, FilePathForDown
FileNameForDown = "upload_excel/Score_" &  Trim(Request.QueryString("tclsid")) & Trim(Request.QueryString("tcrsid")) & ".xls"
FilePathForDown =  Server.MapPath(FileNameForDown)

dim excel_fso
Set excel_fso = Server.CreateObject("Scripting.FileSystemObject") 
if excel_fso.FileExists(FilePathForDown) then
   excel_fso.DeleteFile(FilePathForDown)   '如果已存在, 就先删除已有文件
end if
Set excel_fso = nothing

excel01.SaveAs FilePathForDown    '保存文件
app_excel.Application.Quit     '导出以后退出Excel
Set app_excel = nothing     '注销Excel对象
Response.Write("成功生成了一个Excel文件!")
Response.Redirect(FileNameForDown)
%>