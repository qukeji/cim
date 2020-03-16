<%@ page import="tidemedia.cms.base.*,tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String ids = getParameter(request,"ids");
String order_numbers = getParameter(request,"order_numbers");
int channelid = getIntParameter(request,"channelid");
int LinkChannelID = getIntParameter(request,"LinkChannelID");
int globalid = getIntParameter(request,"globalid");
String table =  "relation_"+channelid+"_"+LinkChannelID;
//System.out.println("ids: "+ids+" orderNumbers: "+ order_numbers+" channelID: "+ channelid+" globalid:"+globalid);
if(channelid>0 && order_numbers.length()>0)
{
	int[] ids_ = Util.StringToIntArray(ids,",");
	int[] order_numbers_ = Util.StringToIntArray(order_numbers,",");
	//System.out.println(ids_.length+"="+order_numbers_.length);
	if(ids_.length==order_numbers_.length)
	{
		Channel channel = CmsCache.getChannel(channelid);
		TableUtil tu = new TableUtil();
		for(int i = 0;i<ids_.length;i++)
		{
			//String sql = "update " + channel.getTableName()+" set OrderNumber="+order_numbers_[i]+" where id=" + ids_[i];
			String sql = "update " + table+" set OrderNumber="+order_numbers_[i]+" where ChildGlobalID=" + ids_[i] +" and GlobalID= "+globalid;
			
			//System.out.println("sql::"+sql);
	     	int temp = tu.executeUpdate(sql);
			//System.out.println("temp:"+temp);
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