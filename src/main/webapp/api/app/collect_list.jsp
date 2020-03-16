<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				org.json.*,
				tidemedia.app.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>

<%
    
    appUserInfo appUserInfo=new appUserInfo();

    appUserInfo =(appUserInfo)session.getAttribute("appUserInfo");
    if (appUserInfo!=null){
        Integer userId = appUserInfo.getId();
         out.println(userId); 
        if (userId==0){
            out.println("请先登录");
            return;
        }
        try{
            String ticket_url ="http://jushi-yanshi.tidemedia.com/apiv3.4.0/ceshi_collect_list.php?userid="+userId;
            String text =  Util.postHttpUrl(ticket_url,"","utf-8");
           out.println(text);
        }catch (Exception e){
            out.println("程序异常"+e.toString());
        }
    }else{
        out.println("请先登录"); 
    }


%>


