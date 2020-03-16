<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
String		ItemID	=	getParameter(request,"ItemID");

int		CategoryID	=	getIntParameter(request,"CategoryID");
int		check	=	getIntParameter(request,"check");

if(ChannelID!=0 && !ItemID.equals(""))
{
	boolean result = false;

	if(check==1)
	{
		result = ItemUtil2.checkHasRecommendOut(ItemID,ChannelID);
	}
	
	if(!result)//û�б��Ƽ���ȥ��ǿ��ɾ��
	{	
		ChannelPrivilege cp = new ChannelPrivilege();
		if(cp.hasRight(userinfo_session,CategoryID>0?CategoryID:ChannelID,4))
		{
			Document document = new Document();
			document.setUser(userinfo_session.getId());
			document.Delete(ItemID,ChannelID);
			ApproveDocument.DeleteByCAI(ItemID, ChannelID);
			out.println(JsonUtil.success("�ɹ�ɾ��"));
		}
	}
	else
	{
		out.println(JsonUtil.fail(""));
	}
}
%>
