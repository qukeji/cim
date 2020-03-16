<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.util.StringUtils,
				tidemedia.cms.user.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	String		ChannelID			= getParameter(request,"ChannelID");//推荐到的频道编号
	String	RecommendItemID			= getParameter(request,"RecommendItemID");//推荐出去的文档编号
	int		RecommendChannelID		= getIntParameter(request,"RecommendChannelID");//推荐出去的文档来自的频道编号
	int		IsApprove				= getIntParameter(request,"IsApprove");//推荐出去的文档来自的频道编号

	int GlobalID					= 0;
	String desc = "";
	
	//System.out.println("ChannelID======"+ChannelID);
	//System.out.println("RecommendItemID======"+RecommendItemID);
	ChannelPrivilege cp = new ChannelPrivilege();

	String[] ids = Util.StringToArray(ChannelID, ",");
	for (int i = 0; ids!=null && i<ids.length; i++) 
	{
		int channelid_ = Util.parseInt(ids[i]);

		if(!cp.hasRight(userinfo_session,channelid_,2))
		{
			//response.sendRedirect("../close_pop.jsp");return;
		}
		else
		{
			Channel ch = CmsCache.getChannel(channelid_);

			boolean canApprove = ch.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);

			int IsApprove_ = IsApprove;
			if(!canApprove) IsApprove_ = 0;

			String approve_desc = "";
			//if(IsApprove_==1) approve_desc = "(发布)";
			//if(IsApprove_==0) approve_desc = "(未发布)";

			new Recommend().recommendOutItems(channelid_,RecommendItemID,RecommendChannelID,IsApprove_,userinfo_session.getId());

			if(desc.length()>0)
				desc += ","+ch.getName()+approve_desc;
			else
				desc += ch.getName()+approve_desc;
		}
	}
%>
<script>
var	dialog = new top.TideDialog();
dialog.showAlert("你选择的文章已经成功推荐到频道：<%=desc%>.");
top.TideDialogClose({refresh:'right'});
</script>