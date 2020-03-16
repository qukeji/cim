<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
String		ids=	getParameter(request,"ItemID");

int		topicid	=	getIntParameter(request,"topicid");

int		check	=	getIntParameter(request,"check");



if(ChannelID!=0 && !ids.equals("")){
    
    int ItemID = 0;

	String[] split = ids.split(",");
	for (String id : split) {
	    ItemID = Integer.parseInt(id);
	    if(ItemID!=0){
	        Document doc = CmsCache.getDocument(ItemID,ChannelID);
            HashMap<String, String> map = new HashMap<String, String>();
            if(check==1){
                 map.put("topicid","0");
            }
            if(check==2){
                 map.put("topicid",topicid+"");
            }
            ItemUtil.updateItemById( ChannelID,map, ItemID,1);
            //调用接口配置
            if(doc.getStatus()==1){
                doc.Approve(ItemID+"",ChannelID);//发布
            }
	    }
	}
	
}
%>
