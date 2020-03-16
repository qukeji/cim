<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.io.*,
				java.net.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    public  String HttpUrl(String url,String charset,String token)
    {
        String content = "";
        String sCurrentLine = "";
        java.net.URL l_url;
        try {
            if(charset.length()==0) charset = "utf-8";
            l_url = new java.net.URL(url);
            java.net.HttpURLConnection con = (java.net.HttpURLConnection) l_url.openConnection();
            HttpURLConnection.setFollowRedirects(true);
            con.setConnectTimeout(60000);//连接超时,1分钟,防止网络异常，程序僵死
            con.setReadTimeout(60000);//读操作超时,1分钟
            con.setInstanceFollowRedirects(true);//支持重定向
            con.setRequestProperty("token",token);
            con.connect();
            java.io.InputStream l_urlStream = con.getInputStream();
            java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream,charset));
            while ((sCurrentLine = l_reader.readLine()) != null)
            {
                content+=sCurrentLine + "\r\n";
            }
        } catch (MalformedURLException e) {
            System.out.println("cann't connect " + url);
            //e.printStackTrace(System.out);
        } catch (IOException e) {
            System.out.println("cann't connect " + url);
            //e.printStackTrace(System.out);
        }

        return content;
    }
%>
<%
String code =   getParameter(request,"code");
int action =  getIntParameter(request,"action");
int company_id =getIntParameter(request,"company_id");//企业id
int userid = 	userinfo_session.getId();
UserInfo userInfo = new UserInfo(userid);
String phone = userInfo.getTel();
TideJson tidejson = CmsCache.getParameter("juxian_api").getJson();
String openUrl = tidejson.getString("company_toolOpen_url")+"?companyId="+company_id;//移动工具开启或关闭接口
String token =Util.createToken(0,phone,"",company_id,1);
//String token =Util.createToken(0,"19953313232","",4,1);
String openResult=HttpUrl(openUrl+"&code="+URLEncoder.encode(code,"utf-8") +"&action="+ action,"utf-8",token);
 /*   System.out.println("phone==============="+phone);
    System.out.println("company_id==============="+company_id);
    System.out.println("token==============="+token);
    System.out.println("openUrl==============="+openUrl+"&code="+code+"&action="+action);
    System.out.println("openResult==============="+openResult);*/
out.println(openResult);

%>












