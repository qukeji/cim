<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*"%><%@ page errorPage="/cms_error.jsp"%><%
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
	String RU = (Url.equals("")?"":"?Url="+java.net.URLEncoder.encode("page.jsp?Url="+Url));
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
String ExternalUrl = "";
String pageFileName = "";
int i = Url.indexOf("http://");
int j = Url.indexOf("/",i+7);

if(j==-1)
{
	ExternalUrl = Url;
	pageFileName = "/index.shtml";
}
else
{
	ExternalUrl = Url.substring(0,j);
	pageFileName = Url.substring(j);
}

if(pageFileName.equals("")||pageFileName.equals("/"))
	pageFileName = "/index.shtml";

//out.println(pageFileName);
int siteid = 0;
int pageid = 0;

TableUtil tu = new TableUtil();
TableUtil tu2 = new TableUtil();
String sql = "select * from site where ExternalUrl='" + ExternalUrl + "'";
System.out.println(sql);
ResultSet rs = tu.executeQuery(sql);
if(rs.next())
{
	siteid = rs.getInt("id");
}

tu.closeRs(rs);

if(siteid==0)
{
	sql = "select * from site where Url='" + ExternalUrl + "'";
	rs = tu.executeQuery(sql);
	if(rs.next())
	{
		siteid = rs.getInt("id");
	}

	tu.closeRs(rs);
}

if(siteid>0)
{
	String sql2 = "select * from channel where FullPath='" + pageFileName + "' and Site=" + siteid + " order by id desc";
	ResultSet rsrs = tu2.executeQuery(sql2);
	if(rsrs.next())
	{
		pageid = rsrs.getInt("id");
	}

	tu2.closeRs(rsrs);
}

if(pageid==0)
{
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
没找到对应的页面.
</body>
</html>
<%
}
else
{
	response.sendRedirect("page/page.jsp?id=" + pageid);
}
%>