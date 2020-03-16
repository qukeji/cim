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
    //更新app基本信息
%>
<%
    String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();
    int   id      =   getIntParameter(request,"ItemID");
    int	  ChannelID	=	getIntParameter(request,"ChannelID");
	String AppDepartment  = getParameter(request,"AppDepartment");

    int   mandatoryLogin     =   getIntParameter(request,"mandatoryLogin");
    int   selectionDepartment     =   getIntParameter(request,"selectionDepartment");

    HashMap map=new HashMap();
    map.put("mandatoryLogin",mandatoryLogin+"");
    map.put("selectionDepartment",selectionDepartment+"");
    map.put("AppDepartment",AppDepartment);
    try {
        //新增
        if(id==0){
            map.put("tidecms_addGlobal","1");
            id = ItemUtil.addItemGetID(ChannelID, map);
        //修改
        }else{
            ItemUtil.updateItemById( ChannelID,map,id,userinfo_session.getId());
        }
        Document document = new Document();
        document.setUser(userinfo_session.getId());
        document.Approve(id+"",ChannelID);
        out.println("成功");
    }catch (Exception e){
        out.println("失败"+e.toString());
    }

%>















