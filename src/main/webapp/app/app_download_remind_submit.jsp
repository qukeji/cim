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
    int   ChannelID      =   getIntParameter(request,"ChannelID");

    String Title=getParameter(request,"Title");
    String AndroidDownload=getParameter(request,"AndroidDownload");
    String IosDownload=getParameter(request,"IosDownload");
    String Photo=getParameter(request,"Photo");
    HashMap politicsmap=new HashMap();
    politicsmap.put("Title",Title+"");
    politicsmap.put("AndroidDownload",AndroidDownload+"");
    politicsmap.put("IosDownload",IosDownload+"");
    politicsmap.put("Photo",Photo+"");
   politicsmap.put("Status","1");

    try {
        //新增
        if(id==0){
            politicsmap.put("tidecms_addGlobal","1");
            id = ItemUtil.addItemGetID(ChannelID, politicsmap);
        //修改
        }else{
            ItemUtil.updateItemById( ChannelID,politicsmap,id,userinfo_session.getId());
        }
        Document document = new Document();
        document.setUser(userinfo_session.getId());
        document.Approve(id+"",ChannelID);
        out.println("成功");
    }catch (Exception e){
        out.println("失败"+e.toString());
    }
   

%>















