<%@ page errorPage="/cms_error.jsp"%><%
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
request.setCharacterEncoding("utf-8");
int max_perpage 	= 20;		//MAX DISPLAY RECORDS IN ONE PAGE//
%><%!
public String getParameter(HttpServletRequest request,String str)
	{
	if(request.getParameter(str)==null)
		return "";
	else
		return request.getParameter(str);
	}

public int getIntParameter(HttpServletRequest request,String str)
	{
	String tempstr = getParameter(request,str);
	if(tempstr.equals(""))
		return 0;
	else
		return Integer.valueOf(tempstr).intValue();
	}
public String convertNull(String input)
	{
	if(input==null)
		return "";
	else
		return input;
//		return convertEncode(input);
	}
public void removeSession(HttpSession session,String[] items)
	{
		for(int i=0;i<items.length;i++)
		{
			session.removeAttribute(items[i]);
		}
	}%>