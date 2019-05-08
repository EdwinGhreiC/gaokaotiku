<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<%
'Option Explicit
Dim Conn,Connstr,DB
Set Conn = Server.CreateObject("Adodb.Connection")
DB = "db1.mdb"
'Connstr = "Driver={Microsoft Access Driver (*.mdb)};dbq=" & Server.MapPath(DB) & ";uid=admin;"
connstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath(db)
Conn.open Connstr

Sub Closeconn()
    Conn.close
	Set Conn = Nothing
End Sub

session.timeout=70
'response.write session.timeout

%>
