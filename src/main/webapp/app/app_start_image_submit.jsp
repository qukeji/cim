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
    int	  GlobalID	=	getIntParameter(request,"GlobalID");
    int	  residencetime	=	getIntParameter(request,"residencetime");
    String Title=getParameter(request,"Title");
    String Photo=getParameter(request,"Photo");
    String preloadPhoto=getParameter(request,"preloadPhoto");
    
    String gif=getParameter(request,"gif");
    int   type     =   getIntParameter(request,"start_type");
    String video=getParameter(request,"video");
    String   href     =   getParameter(request,"href");

    int   countdown     =   getIntParameter(request,"countdown1");
    int   skip    =   getIntParameter(request,"skip");
    


    //System.out.println(function_switch3);
    //int   third_option     =   getIntParameter(request,"third_option");
    //int   third_option2     =   getIntParameter(request,"third_option2");
    //int   third_option3     =   getIntParameter(request,"third_option3");
    //String third_option4=""+third_option+","+third_option2+","+third_option3+"";
    //System.out.println(third_option4);

    HashMap politicsmap=new HashMap();
    politicsmap.put("type",type+"");
    politicsmap.put("Title",Title+"");
    politicsmap.put("Photo",Photo+"");
    politicsmap.put("preloadPhoto",preloadPhoto+"");
    politicsmap.put("href",href+"");
    politicsmap.put("gif",gif+"");
    politicsmap.put("video",video+"");
    politicsmap.put("countdown",countdown+"");
    politicsmap.put("skip",skip+"");
    politicsmap.put("residencetime",residencetime+"");
    politicsmap.put("Status",1+"");

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















