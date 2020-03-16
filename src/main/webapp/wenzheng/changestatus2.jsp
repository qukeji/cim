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
//改变处理状态接口
    
    int		GlobalID	=	getIntParameter(request,"GlobalID"); 
    int		ChannelID	=	getIntParameter(request,"ChannelID");
    int     ItemID      =   getIntParameter(request,"ItemID");
    int     Status2     =   getIntParameter(request,"Status2");
    
    Document doc=CmsCache.getDocument(GlobalID);
    if(GlobalID==0){
        doc = CmsCache.getDocument(ItemID,ChannelID);
    }
    HashMap map=new HashMap();
    map.put("Status2",Status2+"");
    ItemUtil.updateItemById( ChannelID,map, ItemID,1);
    //调用接口配置
    if(doc.getStatus()==1){
        doc.Approve(ItemID+"",ChannelID);//发布
    }
%>
