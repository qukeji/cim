<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%

    String callback=getParameter(request,"callback");
    JSONObject object=new JSONObject();
    ArrayList arrayList= UserInfoUtil.getUserListForSubject(userinfo_session);
    Iterator it1 = arrayList.iterator();
    JSONObject jsonarry=new JSONObject();
    JSONObject jsonshare=new JSONObject();
    JSONArray list=new JSONArray();
    JSONObject jsonlist=new JSONObject();
    JSONArray user_list=new JSONArray();
    JSONObject jsonuser=new JSONObject();
    while (it1.hasNext()) {
        JSONObject json=new JSONObject();
        UserInfo userInfo=(UserInfo) it1.next();
        String name=userInfo.getName();
        String username2=userInfo.getUsername();
        String pwd=userInfo.getPassword();
        String tel=userInfo.getTel();
        int id=userInfo.getId();
        json.put("userid",id);
        json.put("title",name);
        json.put("phone",tel);
        json.put("photo","");
        json.put("number",0);
        json.put("identity",0);
        user_list.put(json);
    }
    jsonuser.put("id",0);
    jsonuser.put("title","");
    //userlist
    jsonuser.put("user",user_list);
    list.put(jsonuser);

    //share
    jsonshare.put("url","");
    jsonshare.put("summary","");
    jsonshare.put("title","");
    jsonshare.put("logo","");
    jsonlist.put("share",jsonshare);
    //list
    jsonlist.put("list",list);

    jsonarry.put("code",200);
    jsonarry.put("message","成功");
    jsonarry.put("result",jsonlist);
    out.println(jsonarry);

%>
