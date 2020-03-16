<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
    //任务提交接口
    String callback=getParameter(request,"callback");
    JSONObject object=new JSONObject();
    int channelid		= getIntParameter(request,"ChannelID");

     ArrayList arrayList= UserInfoUtil.getUserListForSubject(userinfo_session);
    Iterator it1 = arrayList.iterator();
    JSONArray array=new JSONArray();
    JSONObject json1=new JSONObject();
    while (it1.hasNext()) {
      JSONObject json=new JSONObject();
        UserInfo userInfo=(UserInfo) it1.next();
        String name=userInfo.getName();
        String username=userInfo.getUsername();
        String pwd=userInfo.getPassword();
        String tel=userInfo.getTel();
        int id=userInfo.getId();
        json.put("id",id);
        json.put("name",name);
        json.put("username",username);
        json.put("pwd",pwd);
        json.put("tel",tel);
        array.put(json);
    }
    json1.put("result",array);
    json1.put("code",200);
    json1.put("message","成功");
    json1.put("page",2);
    out.println(json1);

%>
