<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				java.io.*,
				java.net.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

Page p = new Page(id);

String Charset = p.getRealCharset();
if(Charset.equals(""))
	Charset = "GB2312";

String TemplateFolder = p.getSite().getSiteFolder();

String Path	= TemplateFolder + "/" + p.getFullTargetName();

	if(!Path.equals(""))
	{
	//String RealPath = application.getRealPath(Path);
	String RealPath = Path;

	File file = new File(RealPath);
	if(file.exists())
	{
		URL url = null;
		URLConnection conn = null;
		InputStream is = null;
		BufferedReader br = null;
		String line = "";
		String Content = "";
		String cms_url = (request.getRequestURL()+"").replace("/content/page.jsp","");
		String Head = "<base href=\"" + p.getSite().getUrl() + "\">\r\n";
		String Body = "<div id=img_div style='font-size: 12px;color: #999999;Z-INDEX:100;VISIBILITY:visible;POSITION:absolute;TOP:8px;cursor:move' onmousedown=\"mousedown('img_div')\" onmouseup=\"mouseup('img_div')\" onmousemove='mousemove();' ondrag='return   false'><TABLE id=apy0m0 style='FILTER: Alpha(opacity=100) VISIBILITY: visible; WIDTH: 0px;' cellSpacing=0 cellPadding=0><TBODY><TR><TD><TABLE bgcolor=\"#FF0000\" cellSpacing=1 cellPadding=0><TBODY><TR><TD  class='tidecms_div' style=\"CURSOR: move\" height='100%'><div class='tidecms_edit_box'><div class='easyedit'><a href='http://www.tidemedia.com' target='_blank'><img src='" + cms_url + "/images/tidecms_easyedit.gif' alt='TideCMS 轻松页面编辑' width='135' height='11' border='0' /></a></div>&nbsp;<a href='javascript:window.location.reload();'>刷新页面</a> | <a href='javascript:page_preview(" + id + ")' target1='_blank'>预览</a> | <a href='javascript:page_publish(" + id + ")'>发布页面</a></div></TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE></div>";

		Head += "<script language=javascript src=\"" + (request.getRequestURL()+"").replace("/content/page.jsp","/common/cms_page.js") + "\"></script>\r\n";

		Head += "<link rel=\"stylesheet\" href=\"" + (request.getRequestURL()+"").replace("/content/page.jsp","/style/9/page.css") + "\" type=\"text/css\">";

		url = new URL(p.getSite().getUrl() + "/" + p.getFullTargetName());
		conn = url.openConnection();
		conn.setRequestProperty("accept","*/*");
		conn.setRequestProperty("accept-language","zh-cn");
		conn.setRequestProperty("User-Agent","Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)");
		conn.setUseCaches (false);

		conn.connect();

		is = conn.getInputStream ();
		br = new BufferedReader (new InputStreamReader (is,Charset));
		while ((line = br.readLine ()) != null)
		Content += line + "\r\n";
		is.close (); 

		//第一步处理
		Content = p.InsertHead(Content,Head);

		//第二步处理
		Content = p.InsertBeforeEndBody(Content,Body);

		//第三步处理
		Content = p.ConvertContent4(Content);

		String s_image = "";
		s_image = "/images/page_edit_menu_manage.gif";
		Content = Content.replace(s_image,cms_url + s_image);
		s_image = "/images/page_edit_menu_append.gif";
		Content = Content.replace(s_image,cms_url + s_image);


	%><%=Content%><%}else{out.println("页面文件不存在!");}}%>

