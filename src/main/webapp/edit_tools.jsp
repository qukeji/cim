<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,tidemedia.cms.util.*"%><%@ page errorPage="/cms_error.jsp"%><%
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);


request.setCharacterEncoding("utf-8");
int max_perpage 	= 20;		//MAX DISPLAY RECORDS IN ONE PAGE//
String RootPath		= "/"; // root path
String TemplateRootPath		= RootPath + "/wwwroot/template"; // root path

//check user validate
tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();
if(session.getAttribute("CMSUserInfo")!=null)
{
	userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
}

String Url = getParameter(request,"Url");

if(userinfo_session==null || userinfo_session.getId()==0)
{
	String RU = (Url.equals("")?"":"?Url="+java.net.URLEncoder.encode("edit_tools.jsp?Url="+Url));
	out.println("<script>");
	out.println("parent.location=\""+request.getContextPath()+"/index.jsp"+RU+"\";");
	out.println("</script>");
	out.close();
	return;
}
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
//		return tidemedia.cms.util.Util.convertEncode(input);
	}
public void removeSession(HttpSession session,String[] items)
	{
		for(int i=0;i<items.length;i++)
		{
			session.removeAttribute(items[i]);
		}
	}%>
<%
Page p = new Page();
Url = Url.replace(p.getSite().getUrl(),"");

int pageid = p.getPageByFilename(Util.ClearPath("/" + Url));
response.sendRedirect("channel/page.jsp?id=" + pageid);
%>