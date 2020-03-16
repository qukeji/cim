<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.page.*,
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

String SiteAddress = p.getSite().getUrl();
if(!(SiteAddress.endsWith("/") || SiteAddress.endsWith("\\")))
{
	SiteAddress += "/";
}
String FileName = p.getFullTargetName();
String RealPath	= p.getSite().getSiteFolder() + "/" + FileName;

File file = new File(RealPath);
if(file.isFile() && file.exists())
{
	String Address = "";
	if(FileName.startsWith("/"))
	{
		Address = SiteAddress + FileName.substring(1);
	}
	else
	{
		Address = SiteAddress + FileName;
	}
	%>
<script language=javascript>
	this.location = "<%=Address%>";
</script><%
}
%>
