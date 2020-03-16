<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				org.json.JSONObject"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%  
    //调用聚现接口获取企业用户
    JSONObject juxian = UserInfoUtil.getJuxianInfo(userinfo_session);
    String phone = userinfo_session.getTel();
    if(juxian.get("JuxianToken") == null || juxian.get("JuxianToken").equals("") || juxian.get("JuxianID") == null || juxian.get("JuxianID").equals("")){
        JSONObject job = new JSONObject("{\"code\": 505,\"message\": \"缺少对应的配置信息\"}");  
        out.println(job.toString());
        return;
    }
    if(phone==null||phone==""||phone.equals("")){
        JSONObject job = new JSONObject("{\"code\": 505,\"message\": \"请先绑定手机号！\"}");  
        out.println(job.toString());
        return;
    }
    String JuxianToken = (String)juxian.get("JuxianToken");
    int JuxianID = (int)juxian.get("JuxianID");
    
    TideJson juxian_user_interface = CmsCache.getParameter("juxian_user_interface").getJson();//聚现用户接口
    String userinfo = juxian_user_interface.getString("userinfo");

    String url = userinfo+"?access_token="+JuxianToken+"&phone="+phone+"&company_id="+JuxianID;
    out.println(Util.connectHttpUrl(url, "utf-8").toString());
    
%>
