<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"id");


if(ChannelID!=0 )
{
	Channel channel = CmsCache.getChannel(ChannelID);
	String SiteFolder = channel.getSite().getSiteFolder();
	String FolderName = channel.getFullPath() + "/";
	ArrayList cts = channel.getChannelTemplates(3);
	if(cts!=null && cts.size()>0)
	{
		for(int i = 0;i<cts.size();i++)
		{
			ChannelTemplate ct = (ChannelTemplate)cts.get(i);
			String TargetName = ct.getTargetName();
			String FileName = FolderName + TargetName;
			new Publish().InsertToBePublished(FileName,SiteFolder,channel);
		}
	}

	PublishManager.getInstance().CopyFileNow();
}
%>
