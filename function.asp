<%
'���� class ��ֵ������������
function qtypeTxt(typeValue)
	select case typeValue
		case 1
			qtypeTxt = "��ѡ��"
		case 2
			qtypeTxt = "�ж���"
		case 3
			qtypeTxt = "��ѡ��"
	end select
end function

'���� inputer ��ֵ����¼��������
function inputerTxt(inputerID)
	dim stuID  '������ô���壬����������÷�Χ�������⣬�����������˵������ı������붨�壡
	stuID=inputerID
	set rsInputer = server.createobject("adodb.recordset")
	sql = "select sname from stu where id=" & stuID  '������ô��תһ�±�������������
	rsInputer.open sql,conn,1,1
	if not rsInputer.eof then
		inputerTxt = rsInputer(0)
	else
		inputerTxt = "������"
	end if
	rsInputer.close
	set rsInputer = nothing
end function


'д�� Session
Sub writeSession(theRecordset)
	session("sjtk_stuid")= theRecordset("id")
	session("sjtk_user") = theRecordset("sname")
	session("login_ip") = request.servervariables("REMOTE_ADDR")
	session("sjtk_loginstatus") = theRecordset("loginstatus")
	session("grade") = theRecordset("grade")
	session("majorID") = theRecordset("majorID")
End Sub


'����Σ���ַ� fliter-dangers-character
function fdc(str)
	str=trim(str)
	str=replace(str,"'","")
	str=replace(str,"<","")
	str=replace(str,">","")
	fdc=str
end function 


'���̣�����������
'������tk_display=��������Ŀ����ʾ���ٵ���
'     max_num=��Ŀ�������
'     min_num=��Ŀ����С���
'     arr=�����ŵ�����
'     qtype=��Ŀ����
sub generateRandNum(tk_display,max_num,min_num,arr(),qtype)

	set rsTemp = server.createObject("adodb.recordset")
	for i=1 to tk_display   '��ѡ��
	  RndNo=Int((max_num-min_num+1)*Rnd+min_num)
	  arr(i)=RndNo
	  '---------��ֹ�����ظ������------------
	  for j=1 to i-1
	      if arr(j)=arr(i) then
		      arr(i)=Int((max_num-min_num+1)*Rnd+min_num)
		      j=0
		  end if
	  next
	  '------------------------------------
	  sql = "select * from Stutest where stuid=" & session("sjtk_stuid") & " and stuno=" & i & " and class=" & qtype
	  rsTemp.open sql,conn,1,3
	  if rsTemp.eof then
	     rsTemp.addnew
		 rsTemp("stuid")=session("sjtk_stuid")
		 rsTemp("stuno")=i
		 rsTemp("tkno")=arr(i)
		 rsTemp("class")=qtype
	     rsTemp.update
	  else
	  	 '����ʱ����ԭ����
		 rsTemp("stuid")=session("sjtk_stuid")
		 rsTemp("stuno")=i
		 rsTemp("tkno")=arr(i)   
	     rsTemp.update
	  end if
	  rsTemp.close
	next
	set rsTemp = nothing

end sub  


'���̣�����������Ŀ�����ر�ҳ�棬�ٴν��룬��ȡ֮ǰ���ɵ���Ŀ
'������display_counts=��������Ŀ����ʾ���ٵ���
'     arr=�����ŵ�����
'     qtype=��Ŀ����
sub getRandNum(tk_display,arr(),qtype)

	set rsTemp= Server.CreateObject("adodb.recordset")
	for i=1 to tk_display
      sql = "select * from Stutest where stuid=" & session("sjtk_stuid") & " and stuno=" & i & " and class=" & qtype
	  rsTemp.open sql,conn,1,1
	  if not rsTemp.eof then
		 arr(i)=rsTemp("tkno")
	  end if
	  rsTemp.close
  	next
	set rsTemp = nothing

end sub


'�ַ�ת���� CLng ��ֹ��ֵ����ֹ�������ַ�'
function val(value)
	if not isnull(value) then   '�ն����ж�'
		if value = "" then      '��ֵ�ж�'
			Val = 0
		else
			if isnumeric(value) then   '�Ƿ�Ϊ�����ж�'
				Val = CLng(value)
			else
				Val = 0
			end if
		end if
	else
		Val = 0
	end if
end function


function showPdtResult(pdt)
  if pdt<>"" then
	  if Ucase(pdt)="A" then
		 showPdtResult="��"
	  elseif Ucase(pdt)="B" then
		 showPdtResult="��"
	  end if
  else
      showPdtResult="&nbsp;&nbsp;&nbsp;&nbsp;"
  end if
end function


'����ͳ�ƣ�û����һ����Ŀ���������Ŀ������1
sub countErrors(rs)
	if session("isSubmitted") = 0 then 'Ϊ0��ʾδ�ύ'
		set rswrong = server.CreateObject("adodb.recordset")
		sql = "select * from errorsets where questionID=" & rs("ntmbh")
		rswrong.open sql,conn,1,1
		if rswrong.eof then
			sql = "insert into errorsets(questionID,qcount) values(" & rs("ntmbh") & ",1)"
			conn.execute(sql)
		else    '����Ѵ��ڣ��ͰѴ������������1'
			sql = "update errorsets set qcount=qcount+1 where questionID=" & rs("ntmbh")
			conn.execute(sql)
		end if
		rswrong.close
		set rswrong = nothing
	end if
end sub


'���ʱ�Զ�ת�����з�'
function wordWrap(strInfo)   
	if isnull(strInfo) then
		wordWrap = ""
	elseif strInfo = "" then
		wordWrap = ""
	else
		wordWrap = replace(strInfo,chr(13),"<br>")
	end if
end function


'�����������'
function wordInput(strWord)   
	if isnull(strWord) then
		wordInput = ""
	elseif strWord = "" then
		wordInput = " "
	else
		wordInput = replace(server.htmlencode(trim(strWord)),"'","&apos;")  '�滻�����ţ���������'
	end if
end function


'ѹ��ͼƬ������ AspJpeg ���'
sub compressImage(imgPath,imgLength)   'ͼƬ����·�����̱߳���'

	set upimg = server.createobject("Persits.Jpeg")   '���� ASPJpeg ����'
	upimg.open imgPath    '��ͼƬ'
	upimg.preserveAsPectRatio = true    '���ָ߿��'
	if upimg.originalWidth < upimg.originalHeight then
		upimg.width = imgLength   '���ø߶�'
	else
		upimg.height = imgLength
	end if

	upimg.save mid(imgPath,1,len(imgPath)-4) & "_s" & ".jpg"    '���棬ȥ����չ�����������λ��չ����һ��4λ�������� _s ���ټ��� .jpg ����չ��'

	'����Сͼ��ɾ��ԭͼ
	set fso1 = server.createobject("scripting.FileSystemObject")
	fso1.deleteFile imgPath

end sub


'�滻 UBB ��ǩΪ HTML ��ǩ'
function ubbToHtml(content,utype)        'utype �滻�ı�ǩ������; content ��������; url ���ӵ�ַ'
	if not isnull(utype) then
		if utype <> "" then
			select case utype
				case "img"
					content = replace(content, "[img]", "<img style=""max-height:300px"" class=""img-responsive img-rounded"" src=""")   'VB ���ַ���������˫����ת��Ϊһ��˫����'
					content = replace(content, "[/img]", "_s.jpg"">")
					ubbToHtml = content
			end select
		else
			ubbToHtml = " "
		end if
	else
		ubbToHtml = " "
	end if
end function


'������½���ϰ�����޸����ɵ���Ŀ����'
sub changeQuestionCount(isChapterPractice)
	if isChapterPractice then  '������½���ϰ���޸���Ŀ����'
		Tk_xzt_display = CHAPTER_XZT_COUNT  '��ϰģʽ����ѡ������
		Tk_pdt_display = CHAPTER_PDT_COUNT   '��ϰģʽ���ж�������
		Tk_dxt_display = CHAPTER_DXT_COUNT   '��ϰģʽ����ѡ������
	end if
end sub

%>






























