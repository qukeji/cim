<%@ page import="java.io.*,tidemedia.cms.system.*,tidemedia.cms.util.Util"%><%@ page contentType="text/html;charset=gb2312" %><%@ include file="config.jsp"%><%if(!userinfo_session.isAdministrator()){ response.sendRedirect("../noperm.jsp");return;}
String	Type		= getParameter(request,"Type");
String	FileName	= getParameter(request,"FileName");
String	FolderName	= getParameter(request,"FolderName");
String	Charset		= getParameter(request,"Charset");
int	SiteId			= Util.getIntParameter(request,"SiteId");

//此文件的page contentType="text/html;charset=gb2312",不能是utf-8，否则使用behavior:url(#default#download)会乱码

if(Charset.equals(""))
	Charset = "GB2312";

if(!FileName.equals(""))
{
	String	Path			= "";
	if(Type.equals("File"))
	{
		Site site=CmsCache.getSite(SiteId);
		String SiteFolder=site.getSiteFolder();
		Path			= SiteFolder + "/" + FolderName + "/" + FileName;
	}
	else if(Type.equals("Template"))
	{
		String TemplateFolder =CmsCache.getDefaultSite().getTemplateFolder();

		Path			= TemplateFolder + "/" + FolderName + "/" + FileName;
	}

	if(!Path.equals(""))
	{
	//String RealPath = application.getRealPath(Path);
	String RealPath = Path;

	BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(RealPath),Charset));
	String LineString;
	String TotalString = "";
	while ((LineString = in .readLine())!=null)
	{
		TotalString += LineString+"\r\n";
	}%><%=TotalString%><%in.close();}}%>