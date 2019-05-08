<%
	website_title = "侨中计算机专业在线测验"

	sub chapter_dropdown()
		response.write "<select name='chapter' class='form-control'>"
		response.write "	<option value='1' selected>第一章 计算机基础知识</option>"
		response.write "	<option value='2'>第二章 计算机组装与维护</option>"
		response.write "	<option value='3'>第三章 计算机网络及网页制作</option>"
		response.write "	<option value='4'>第四章 数据库知识与SQL基本操作</option>"
		response.write "	<option value='5'>第五章 数字媒体技术应用</option>"
		response.write "</select>"		
	end sub

	sub chapter_dropdown_editpage(rs)
		chapterTitle = array("","第一章 计算机基础知识","第二章 计算机组装与维护","第三章 计算机网络及网页制作","第四章 数据库知识与SQL基本操作","第五章 数字媒体技术应用")
		response.write "<select name='chapter' class='form-control'>"
		for i=1 to 5
			response.write "	<option value='" & i & "' " & dropdown_chapter_selected(rs,i) & ">" & chapterTitle(i) & "</option>"
		next 
		response.write "</select>"		
	end sub

	function dropdown_chapter_selected(rs,i)
		if rs("chapter")=i then
			dropdown_chapter_selected = "selected"
		else
			dropdown_chapter_selected = ""
		end if
	end function
%>