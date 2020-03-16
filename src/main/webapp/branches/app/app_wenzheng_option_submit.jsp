<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
    //更新app基本信息
%>
<%
    String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();
    int   id      =   getIntParameter(request,"ItemID");
    int	  ChannelID	=	getIntParameter(request,"ChannelID");


    int   mandatoryLogin     =   getIntParameter(request,"mandatoryLogin");
    int   selectionDepartment     =   getIntParameter(request,"selectionDepartment");

    HashMap map=new HashMap();
    map.put("mandatoryLogin",mandatoryLogin+"");
    map.put("selectionDepartment",selectionDepartment+"");
    try {
        ItemUtil.updateItemById( ChannelID,map, id,1);
        Document document = new Document();
        document.Approve(id+"",ChannelID);
        out.println("成功");
    }catch (Exception e){
        out.println("失败"+e.toString());
    }

%>















