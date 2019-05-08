<% 
	if session("sjtk_user")="" then
   		response.Redirect("login.asp")
   	elseif session("grade")<4 then
   		response.Redirect("index.asp")
	end if %>