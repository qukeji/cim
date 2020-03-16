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
    String Title=getParameter(request,"Title");
    String Photo=getParameter(request,"Photo");
    int  background=getIntParameter(request,"background");
    String background_photo=getParameter(request,"background_photo");
    String tv_background_photo=getParameter(request,"tv_background_photo");
    String background_color=getParameter(request,"background_color");
    String bugly=getParameter(request,"bugly");
    String tongji=getParameter(request,"tongji");
    String baidu_tongji=getParameter(request,"baidu_tongji");
	//用户是否选中全局禁言与禁止交互
	String globalBanned=getParameter(request,"globalBanned");
	String BanInteract=getParameter(request,"BanInteract");
	String sensitive_word=getParameter(request,"sensitive_word");
	String Audit_nickname=getParameter(request,"Audit_nickname");
	String Audit_avator=getParameter(request,"Audit_avator");
	String baoliao=getParameter(request,"baoliao");
	String wenzheng=getParameter(request,"wenzheng");
	String WordColor=getParameter(request,"WordColor");
    String recommend=getParameter(request,"recommend");
    String scan=getParameter(request,"scan");
    String audit_summary=getParameter(request,"audit_summary");

    int   background_area     =   getIntParameter(request,"background_area");
    int   allowcomment     =   getIntParameter(request,"allowcomment");
    int   showtype     =   getIntParameter(request,"showtype");
    int   showcomment     =   getIntParameter(request,"showcomment");
    int   showread     =   getIntParameter(request,"showread");
    int   showcommunity     =   getIntParameter(request,"showcommunity");
    int   customcategory     =   getIntParameter(request,"customcategory");
    int	  ChannelID	=	getIntParameter(request,"ChannelID");
    int   juxiancreate     =   getIntParameter(request,"juxiancreate");
    int listType = getIntParameter(request,"listType");
    String    function_switch1     =   getParameter(request,"function_switch1");
    String   function_switch2     =   getParameter(request,"function_switch2");
    
    if(function_switch1.equals("1")){
        function_switch1="2";
    }
    String function_switch3=function_switch1+","+function_switch2;

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

    HashMap politicsmap=new HashMap();
    politicsmap.put("Title",Title+"");
    politicsmap.put("Photo",Photo+"");
    politicsmap.put("background",background+"");
    politicsmap.put("background_color",background_color+"");
    politicsmap.put("background_photo",background_photo+"");
     politicsmap.put("tv_background_photo",tv_background_photo+"");
    politicsmap.put("allowcomment",allowcomment+"");
    politicsmap.put("showtype",showtype+"");
    politicsmap.put("showcomment",showcomment+"");
    politicsmap.put("showread",showread+"");
    politicsmap.put("showcommunity",showcommunity+"");
    politicsmap.put("customcategory",customcategory+"");
    politicsmap.put("juxiancreate",juxiancreate+"");
    politicsmap.put("function_switch",function_switch3+"");
    politicsmap.put("third_option",third_option4+"");
    politicsmap.put("Status","1");
    politicsmap.put("bugly",bugly);
    politicsmap.put("tongji",tongji);
    politicsmap.put("baidu_tongji",baidu_tongji);
	politicsmap.put("baidu_tongji",baidu_tongji);
	politicsmap.put("baidu_tongji",baidu_tongji);
	politicsmap.put("listType",listType+"");
	//存储全局禁言与数据交互
	politicsmap.put("globalBanned",globalBanned);
	politicsmap.put("BanInteract",BanInteract);
	//存储敏感词
	politicsmap.put("sensitive_word",sensitive_word);
	politicsmap.put("Audit_avator",Audit_avator);
	politicsmap.put("Audit_nickname",Audit_nickname);
	politicsmap.put("baoliao",baoliao);
	politicsmap.put("wenzheng",wenzheng);
	politicsmap.put("recommend",recommend);
	politicsmap.put("audit_summary",audit_summary);
	politicsmap.put("scan",scan);
	politicsmap.put("WordColor",WordColor);
	politicsmap.put("background_area",background_area+"");

    try {
        ItemUtil.updateItemById( ChannelID,politicsmap, id,1);
        Document document = new Document();
        document.setUser(userinfo_session.getId());
        document.Approve(id+"",ChannelID);
        out.println("成功");
    }catch (Exception e){
        out.println("失败"+e.toString());
    }

%>
