<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    //开始办理
    int     probstatus     =   getIntParameter(request,"probstatus");
    int		ChannelID	=	getIntParameter(request,"ChannelID");
    int  ItemID      =   getIntParameter(request,"ItemID");
    int GlobalID    =    getIntParameter(request,"GlobalID");
    
    TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
    int replysid = politics.getInt("replysid");//回复记录频道
    
    Document item = null;
    if(ItemID!=0){
        item = CmsCache.getDocument(ItemID,ChannelID);
    }
    if(item!=null)
	{
		GlobalID = item.getGlobalID();
	}
    Document doc = new Document(ItemID,ChannelID);
    HashMap map=new HashMap();
    map.put("Status2","0");
    map.put("probstatus",probstatus+"");
    ItemUtil.updateItemById( ChannelID,map, ItemID,1);
    
    //提交回复
    String Title=doc.getTitle();
    String name = new UserInfo(userinfo_session.getId()).getName();
    Channel channel = CmsCache.getChannel(ChannelID);
    String ChannelName = channel.getName();

    HashMap<String, String> replaymap = new HashMap<String, String>();
    replaymap.put("Title",Title+"");
    replaymap.put("parent",GlobalID+"");
    replaymap.put("operation","6");
    replaymap.put("handler",name+"");
    
    ItemUtil.addItemGetGlobalID(replysid, replaymap);
    doc.Approve(ItemID+"",ChannelID);
    System.out.println("======================================================hahaha:"+GlobalID);
    //out.println("<script>history.go(-1);window.parent.location.reload();</script>");
%>
