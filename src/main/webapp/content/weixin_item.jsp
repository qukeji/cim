<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
*   用途:tcenter稿件入库到微信系统对应公众号的素材库
*	1,胡翔20191010 创建
*/

String title = getParameter(request,"Title");
String content = getParameter(request,"Content");
String new_type = "";
String author = userinfo_session.getName();
String description = getParameter(request,"Summary");
String imagepath = "";
String orders = "";
String url = "";
String imagepath1 = "";
String content_md5 = "";
int isshow = 0;
int leave_word = 0;
String ID = UUID.randomUUID().toString().replaceAll("-", "");
 ChannelRecommend  cr = new ChannelRecommend();
 JSONArray array =  new ChannelRecommend().findWeiXinAccount(userinfo_session.getId());
 String accountid = array.getJSONObject(0).get("id").toString();
 //String accountid =  cr.findWeiXinAccountId(userinfo_session.getId());
 String sql = "insert into weixin_newsitem (new_type,author,content,description,imagepath,orders,title,"
		 +"url,create_date,accountid,isshow,leave_word,imagepath1,content_md5,ID) values('"+new_type+"','"+author+"','"+content
		 +"','"+description+"','"+imagepath+"','"+orders+"','"+title+"','"+url+"',now(),'"+accountid+"',"+isshow
		 +","+leave_word+",'"+imagepath1+"','"+content_md5+"','"+ID+"')";
 TableUtil tu =  new TableUtil();
 tu.executeUpdate(sql);
 JSONObject json = new JSONObject();
 json.put("message", "操作成功");
 json.put("id",ID);
 System.out.println("入库微信成功id===="+ID);
 out.println(json);
 return;
%>