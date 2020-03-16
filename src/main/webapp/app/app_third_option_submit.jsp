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


    String   third_option1     =   getParameter(request,"third_option1");
    String   third_option2     =   getParameter(request,"third_option2");
    //判断app滑动开关值为开的时候设置自己需要的值
    if(third_option2.equals("0")){
        third_option2="2";
    }
    if(third_option2.equals("1")){
        third_option2="null";
    }
    String   third_option3     =   getParameter(request,"third_option3");
    if(third_option3.equals("0")){
        third_option3="3";
    }
    if(third_option3.equals("1")){
        third_option3="null";
    }
    String third_option4=third_option1+","+third_option2+","+third_option3;
    //System.out.println(third_option4);

    HashMap politicsmap=new HashMap();
    politicsmap.put("third_option",third_option4+"");
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















