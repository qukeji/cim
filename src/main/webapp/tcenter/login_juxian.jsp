<%@ page import="tidemedia.cms.user.UserInfo,tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.system.*,
              java.net.URLEncoder"%>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    String phone = userinfo_session.getTel();
    String name =userinfo_session .getName();
    //String name =userinfo_session .getUsername();
    int  uid = userinfo_session.getId();
    String source = CmsCache.getCompany();
    int companyid = userinfo_session.getCompany();
    Company company = new Company(companyid);
    int company_id = company.getJuxianID();
    String message="";
    String token="";
    if (phone.equals("")){
         out.println("<script > alert('对不起! 手机号不能为空');window.close();</script>");
        return;
    }
    TideJson json = CmsCache.getParameter("juxian_api").getJson();

    if (companyid==0){//如果当前登录用户未绑定租户（companyid=0），从系统参数里获取企业id和token（juxian_api）
        //父企业token
        token = json.getString("juxian_token");
        //父企业id
        company_id = json.getInt("juxian_id");
    }else{
        token=company.getJuxianToken();
    }
    String url = json.getString("login_url");//登录接口
	int type = getIntParameter(request,"type");
	if(type==1){
		url = json.getString("daobotai_url");//导播台接口
	}
	//token加密
	String aes = phone+company_id;
	String keyStr = token.substring(2);
	aes = Util.AES_Encrypt(keyStr,"",aes);
    //url=url+"?phone="+phone+"&name="+name+"&uid="+uid+"&source="+source+"&company_id="+company_id+"&token="+aes;
    url=url+"?phone="+phone+"&name="+URLEncoder.encode(name,"utf-8")+"&uid="+uid+"&source="+URLEncoder.encode(source,"utf-8")+"&company_id="+company_id+"&token="+URLEncoder.encode(aes,"utf-8");
   //url=url+"?phone="+phone+"&username="+name+"&uid="+uid+"&company_id="+company_id+"&token="+aes;
    response.sendRedirect(url);
%>
