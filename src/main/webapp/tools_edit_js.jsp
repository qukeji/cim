<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,java.sql.*,tidemedia.cms.util.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="config.jsp"%>
<%
String href = getParameter(request,"href").toLowerCase();
String edit_url = "";
String siteurl = "";
String fileurl = "";
int siteid = 0;
if(href.startsWith("http://"))
{
	int i = href.indexOf("/",8);
	if(i!=-1)
	{
		siteurl = href.substring(0,i);
		fileurl = href.substring(i);

		java.util.Iterator iter = CmsCache.getSites().entrySet().iterator();
		while (iter.hasNext()) {
			java.util.Map.Entry entry = (java.util.Map.Entry) iter.next();
			Site site = (Site)entry.getValue();
			if(site.getUrl().equals(siteurl)||site.getExternalUrl().equals(siteurl))
			{
				siteid = site.getId();
			}
		} 
	}

	if(siteid>0)
	{
		int gid = 0;
		int cid = 0;
		int templatetype = 0;
		TableUtil tu = new TableUtil();
		fileurl = tu.SQLQuote(Util.ClearPath(fileurl));
		String sql = "select * from generate_files where FileName='" + fileurl + "' and site="+siteid;
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
		{
			gid = rs.getInt("GlobalID");
			cid = rs.getInt("ChannelID");
			templatetype = rs.getInt("TemplateType");
		}
		tu.closeRs(rs);

		if(templatetype==2)//ÄÚÈÝ
		{
			if(gid>0)
			{
				Document doc = new Document(gid);
				edit_url = "/content/document.jsp?ItemID="+doc.getId()+"&ChannelID="+(doc.getCategoryID()>0?doc.getCategoryID():doc.getChannelID());
			}
		}
		//out.println(gid+","+cid);
	}
}
%>
tidecms.edit_url = "<%=edit_url%>"; 
