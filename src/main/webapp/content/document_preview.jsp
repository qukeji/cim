<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.MessageException,
				tidemedia.cms.publish.*,
				java.util.*,
				java.sql.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
int		ItemID		=	getIntParameter(request,"ItemID");
int		GlobalID	=	getIntParameter(request,"GlobalID");
String Label		=	getParameter(request,"Label");

if(GlobalID!=0)
{
	ItemSnap snap = new ItemSnap(GlobalID);
	ChannelID = snap.getChannelID();
	ItemID = snap.getItemID();
}

if(ChannelID!=0 && ItemID!=0)
{
	Channel ch = CmsCache.getChannel(ChannelID);
	String SiteAddress = ch.getSite().getUrl();
	if(!(SiteAddress.endsWith("/") || SiteAddress.endsWith("\\")))
	{
		SiteAddress += "/";
	}
	
	Document item = new Document(ItemID,ChannelID);
	int CategoryID=item.getCategoryID();
	if(CategoryID!=0){
		item = new Document(ItemID,CategoryID);
	}

	String Address = "";
	String RealFileName = "";
	String FileName = "";
	
	if(Label.length()>0)
		FileName = item.getFullHref(Label);
	else
		FileName = item.getFullHref();

	RealFileName = ch.getSite().getSiteFolder() + FileName;

	if(FileName.startsWith("/"))
	{
		Address = SiteAddress + FileName.substring(1);
	}
	else
	{
		Address = SiteAddress + FileName;
	}

	boolean useHref = false;
	String href = item.getValue("Href");
	if(!href.equals(""))
	{
		useHref = true;

		if(!href.startsWith("http"))
			Address = SiteAddress + href;
		else
			Address = href;
	}

	if(!useHref)
	{
		File file = new File(RealFileName);
		if(!file.exists())
		{
			Publish publish = new Publish();
			publish.setPublishType(Publish.ONLY_DOCUMENT_PUBLISH);
			publish.setChannelID(CategoryID==0?ChannelID:CategoryID);
			publish.setPublishAllItems(0);
			publish.addPublishItems(ItemID);
			publish.GenerateFile();
			//throw new MessageException("文件还没有发布!");
		}
	}
	//out.println(Address);
	//response.sendRedirect(Address);

//Address = "three_terminal_preview.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID;
%>
<script language=javascript>
	this.location = "<%=Address%>";
</script>
<%
}
%>
