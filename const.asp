<%
	website_title = "���м����רҵ���߲���"

	sub chapter_dropdown()
		response.write "<select name='chapter' class='form-control'>"
		response.write "	<option value='1' selected>��һ�� ���������֪ʶ</option>"
		response.write "	<option value='2'>�ڶ��� �������װ��ά��</option>"
		response.write "	<option value='3'>������ ��������缰��ҳ����</option>"
		response.write "	<option value='4'>������ ���ݿ�֪ʶ��SQL��������</option>"
		response.write "	<option value='5'>������ ����ý�弼��Ӧ��</option>"
		response.write "</select>"		
	end sub

	sub chapter_dropdown_editpage(rs)
		chapterTitle = array("","��һ�� ���������֪ʶ","�ڶ��� �������װ��ά��","������ ��������缰��ҳ����","������ ���ݿ�֪ʶ��SQL��������","������ ����ý�弼��Ӧ��")
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