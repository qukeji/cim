<%@ page import="tidemedia.cms.base.*,tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String ids = getParameter(request,"ids");
String order_numbers = getParameter(request,"order_numbers");
int channelid = getIntParameter(request,"channelid");
int globalid = getIntParameter(request,"globalid");

if(channelid>0 && order_numbers.length()>0)
{
	int[] ids_ = Util.StringToIntArray(ids,",");
	int[] order_numbers_ = Util.StringToIntArray(order_numbers,",");
	if(ids_.length==order_numbers_.length)
	{
		Channel channel = CmsCache.getChannel(channelid);
		TableUtil tu = new TableUtil();
		for(int i = 0;i<ids_.length;i++)
		{
			String sql = "update " + channel.getTableName()+" set OrderNumber="+order_numbers_[i]+" where id=" + ids_[i];
			tu.executeUpdate(sql);
		}
	}

	Document doc = CmsCache.getDocument(globalid);
	PublishManager publishmanager = PublishManager.getInstance();
	if (doc.getStatus()==1) {//状态发生变化或审核通过
		publishmanager.DocumentPublish(doc.getChannel().getId(),doc.getId(),userinfo_session.getId());
	}else
		publishmanager.OnlyDocumentPublish(doc.getChannel().getId(), doc.getId(),userinfo_session.getId());

}
%>