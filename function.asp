<%
'根据 class 的值返回题型文字
function qtypeTxt(typeValue)
	select case typeValue
		case 1
			qtypeTxt = "单选题"
		case 2
			qtypeTxt = "判断题"
		case 3
			qtypeTxt = "多选题"
	end select
end function

'根据 inputer 的值返回录入者姓名
function inputerTxt(inputerID)
	dim stuID  '必须这么定义，否则变量作用范围会有问题，会溢出。所以说函数里的变量必须定义！
	stuID=inputerID
	set rsInputer = server.createobject("adodb.recordset")
	sql = "select sname from stu where id=" & stuID  '必须这么中转一下变量，否则会出错
	rsInputer.open sql,conn,1,1
	if not rsInputer.eof then
		inputerTxt = rsInputer(0)
	else
		inputerTxt = "无名氏"
	end if
	rsInputer.close
	set rsInputer = nothing
end function


'写入 Session
Sub writeSession(theRecordset)
	session("sjtk_stuid")= theRecordset("id")
	session("sjtk_user") = theRecordset("sname")
	session("login_ip") = request.servervariables("REMOTE_ADDR")
	session("sjtk_loginstatus") = theRecordset("loginstatus")
	session("grade") = theRecordset("grade")
	session("majorID") = theRecordset("majorID")
End Sub


'过滤危险字符 fliter-dangers-character
function fdc(str)
	str=trim(str)
	str=replace(str,"'","")
	str=replace(str,"<","")
	str=replace(str,">","")
	fdc=str
end function 


'过程：生成随机题号
'参数：tk_display=本类型题目共显示多少道；
'     max_num=题目的最大编号
'     min_num=题目的最小编号
'     arr=存放题号的数组
'     qtype=题目类型
sub generateRandNum(tk_display,max_num,min_num,arr(),qtype)

	set rsTemp = server.createObject("adodb.recordset")
	for i=1 to tk_display   '单选题
	  RndNo=Int((max_num-min_num+1)*Rnd+min_num)
	  arr(i)=RndNo
	  '---------防止产生重复随机数------------
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
	  	 '重做时覆盖原来的
		 rsTemp("stuid")=session("sjtk_stuid")
		 rsTemp("stuno")=i
		 rsTemp("tkno")=arr(i)   
	     rsTemp.update
	  end if
	  rsTemp.close
	next
	set rsTemp = nothing

end sub  


'过程：重新生成题目后，若关闭页面，再次进入，获取之前生成的题目
'参数：display_counts=本类型题目共显示多少道；
'     arr=存放题号的数组
'     qtype=题目类型
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


'字符转数字 CLng 防止空值，防止非数字字符'
function val(value)
	if not isnull(value) then   '空对象判断'
		if value = "" then      '空值判断'
			Val = 0
		else
			if isnumeric(value) then   '是否为数字判断'
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
		 showPdtResult="对"
	  elseif Ucase(pdt)="B" then
		 showPdtResult="错"
	  end if
  else
      showPdtResult="&nbsp;&nbsp;&nbsp;&nbsp;"
  end if
end function


'错题统计，没做错一道题目，错误的题目次数加1
sub countErrors(rs)
	if session("isSubmitted") = 0 then '为0表示未提交'
		set rswrong = server.CreateObject("adodb.recordset")
		sql = "select * from errorsets where questionID=" & rs("ntmbh")
		rswrong.open sql,conn,1,1
		if rswrong.eof then
			sql = "insert into errorsets(questionID,qcount) values(" & rs("ntmbh") & ",1)"
			conn.execute(sql)
		else    '如果已存在，就把错误做错次数加1'
			sql = "update errorsets set qcount=qcount+1 where questionID=" & rs("ntmbh")
			conn.execute(sql)
		end if
		rswrong.close
		set rswrong = nothing
	end if
end sub


'输出时自动转换换行符'
function wordWrap(strInfo)   
	if isnull(strInfo) then
		wordWrap = ""
	elseif strInfo = "" then
		wordWrap = ""
	else
		wordWrap = replace(strInfo,chr(13),"<br>")
	end if
end function


'内容输入过滤'
function wordInput(strWord)   
	if isnull(strWord) then
		wordInput = ""
	elseif strWord = "" then
		wordInput = " "
	else
		wordInput = replace(server.htmlencode(trim(strWord)),"'","&apos;")  '替换单引号，否则会出错'
	end if
end function


'压缩图片，借助 AspJpeg 组件'
sub compressImage(imgPath,imgLength)   '图片绝对路径，短边长度'

	set upimg = server.createobject("Persits.Jpeg")   '创建 ASPJpeg 对象'
	upimg.open imgPath    '打开图片'
	upimg.preserveAsPectRatio = true    '保持高宽比'
	if upimg.originalWidth < upimg.originalHeight then
		upimg.width = imgLength   '设置高度'
	else
		upimg.height = imgLength
	end if

	upimg.save mid(imgPath,1,len(imgPath)-4) & "_s" & ".jpg"    '保存，去掉扩展名（点加上三位扩展名，一共4位），加上 _s ，再加上 .jpg 的扩展名'

	'生成小图后删除原图
	set fso1 = server.createobject("scripting.FileSystemObject")
	fso1.deleteFile imgPath

end sub


'替换 UBB 标签为 HTML 标签'
function ubbToHtml(content,utype)        'utype 替换的标签的类型; content 文章内容; url 链接地址'
	if not isnull(utype) then
		if utype <> "" then
			select case utype
				case "img"
					content = replace(content, "[img]", "<img style=""max-height:300px"" class=""img-responsive img-rounded"" src=""")   'VB 的字符串中两个双引号转义为一个双引号'
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


'如果是章节练习，则修改生成的题目数量'
sub changeQuestionCount(isChapterPractice)
	if isChapterPractice then  '如果是章节练习就修改题目数量'
		Tk_xzt_display = CHAPTER_XZT_COUNT  '练习模式，单选题数量
		Tk_pdt_display = CHAPTER_PDT_COUNT   '练习模式，判断题数量
		Tk_dxt_display = CHAPTER_DXT_COUNT   '练习模式，多选题数量
	end if
end sub

%>






























