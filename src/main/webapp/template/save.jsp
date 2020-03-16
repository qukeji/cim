<%@ page import="java.io.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int TemplateID = getIntParameter(request,"TemplateID");
if(TemplateID>0)
{
	String	filecontent = getParameter(request,"filecontent");
	filecontent = StringUtils.replace(filecontent, "<!--#include", "<!--\\#include");
	//System.out.println(filecontent);
	TemplateFile tf = new TemplateFile(TemplateID);
	tf.setContent(filecontent);
	tf.setActionUser(userinfo_session.getId());
	tf.UpdateContent();

	String FileName = tf.getFileName();
	if(FileName.equals("tidemedia_api.xml"))
		CmsCache.InitTideApi();
}
%>