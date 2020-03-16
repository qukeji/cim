<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.MessageException,
				tidemedia.cms.publish.*,
				java.sql.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
int		ItemID		=	getIntParameter(request,"ItemID");
int		GlobalID	=	getIntParameter(request,"GlobalID");

if(GlobalID!=0)
{
	ItemSnap snap = new ItemSnap(GlobalID);
	ChannelID = snap.getChannelID();
	ItemID = snap.getItemID();
}

if(ChannelID!=0 && ItemID!=0)
{
	Channel ch = CmsCache.getChannel(ChannelID);
	String SiteAddress = ch.getSite().getExternalUrl();
	if(!(SiteAddress.endsWith("/") || SiteAddress.endsWith("\\")))
	{
		SiteAddress += "/";
	}
	
	Document item = new Document(ItemID,ChannelID);

	String Address = "";
	String RealFileName = "";
	String FileName = item.getFullHref();

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
			publish.setChannelID(ChannelID);
			publish.setPublishAllItems(0);
			publish.addPublishItems(ItemID);
			publish.GenerateFile();
			//throw new MessageException("文件还没有发布!");
		}
	}
	//out.println(Address);
	//response.sendRedirect(Address);

Address=Address.replace("http://news.vodone.com/","http://msn2.vodone.com/news/");
Address=Address.replace("http://ent.vodone.com/","http://msn2.vodone.com/ent/");
Address=Address.replace("http://sports.vodone.com/","http://msn2.vodone.com/sports/");
Address=Address.replace("http://life.vodone.com/","http://msn2.vodone.com/life/");
Address=Address.replace("http://pet.vodone.com/","http://msn2.vodone.com/pet/");
Address=Address.replace("http://finance.vodone.com/","http://msn2.vodone.com/finance/");
Address=Address.replace("http://movie.vodone.com/","http://msn2.vodone.com/movie/");
Address=Address.replace("http://photo.vodone.com/","http://msn2.vodone.com/photo/");

%>
<script language=javascript>
	this.location = "<%=Address%>";
</script>
<%
}
%>
