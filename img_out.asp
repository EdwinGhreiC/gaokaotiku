<!--#include file="conn.asp"-->
<% 'Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ����xlsx %>
<%' Response.ContentType = "application/vnd.ms-excel" %>
<%
response.write "duandian"
dim rsExcelOut,sql,conn_excel,app_excel,excel01,File_Excel_Path
set rsExcelOut = Server.Createobject("adodb.recordset")
set app_excel =CreateObject("Excel.Application")
app_excel.Application.Visible = False

'Set excel01 = app_excel.Workbooks.Add  '�½�Excel
File_Excel_Path = Server.MapPath("upload_excel\Template_Excel.xls")  '����ģ���

On Error Resume Next
Set excel01 = app_excel.Workbooks.Open(File_Excel_Path)
'if Err.number=9 then Set excel01=app_excel.Workbooks.Open(File_Excel_Path)


'excel01.WorkSheets(1).cells(1,1).value ="id"  
'excel01.WorkSheets(1).cells(1,2).value = "stu_name" 
'excel01.WorkSheets(1).cells(1,3).value = "cj" 

'------------��ȡ��Ŀ���Ͱ༶��-----------
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

excel01.WorkSheets(1).cells(1,4).value = "  ��Ŀ:" & CourseName

dim r  '�к�
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
   excel_fso.DeleteFile(FilePathForDown)   '����Ѵ���, ����ɾ�������ļ�
end if
Set excel_fso = nothing

excel01.SaveAs FilePathForDown    '�����ļ�
app_excel.Application.Quit     '�����Ժ��˳�Excel
Set app_excel = nothing     'ע��Excel����
Response.Write("�ɹ�������һ��Excel�ļ�!")
Response.Redirect(FileNameForDown)
%>