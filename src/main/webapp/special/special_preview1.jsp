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

int pageid = 0;

Channel channel = CmsCache.getChannel(id);

ArrayList arraylist = channel.listSubChannels();
for(int i = 0;i<arraylist.size();i++)
{
	Channel subch = (Channel)arraylist.get(i);
	if(subch.getType()==Channel.Page_Type)
		pageid = subch.getId();
}

Page p = new Page(pageid);

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
<%
    out.println(id);
%>