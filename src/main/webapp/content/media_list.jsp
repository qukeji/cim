<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String copyright = CmsCache.getParameter("copyright").getContent();
String background_image = CmsCache.getParameter("background_image").getContent();
String logo_image = CmsCache.getParameter("logo_image").getContent();
String Username ="";
String Username2=userinfo_session.getUsername2();
int companyid = userinfo_session.getCompany();
int role1 = userinfo_session.getRole();
boolean yunying1 = userinfo_session.hasPermission("OperateSystem");
Cookie[] cookies = request.getCookies();
if(cookies!=null)
{
    for(int i=0;i<cookies.length;i++)
    {
        if(cookies[i].getName().equals("Username"))
            Username = cookies[i].getValue();   
    }
}
Integer userId = userinfo_session.getId();
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");

String sql = "select  tp.logo,tp.code,tp.Name prjname,tp.Url,tp.groupId,up.status,tp.newpage from "+
             "tide_products tp left join (select * from user_product where UserId = '"+userId+"') up on tp.id =up.ProductId  where tp.Status = 1";
TableUtil tu = new TableUtil("user");
ResultSet Rs = tu.executeQuery(sql);

JSONArray yyzc = new JSONArray();
JSONArray yyfb = new JSONArray();
JSONArray zyhj = new JSONArray();
JSONArray scgj = new JSONArray();
while(Rs.next()){
    JSONObject obj = new JSONObject();
    String logo=Rs.getString("logo");
    String code = tu.convertNull(Rs.getString("code"));

    if("tcenter".equals(code)){
        if(role1!=1){
            continue;
        }
        if(role1==1&&companyid!=0){
            continue;
        }
    }
    if("operate".equals(code)){
        if(role1!=1||companyid!=0||(!userinfo_session.hasPermission("OperateSystem"))){
            continue;
        }
    }
    if("company".equals(code)){
        if(role1==1&&companyid!=0){
        }else{
            continue;
        }
    }

     obj.put("userId",userId);
    obj.put("logo",logo);
    obj.put("prjname",Rs.getString("prjname"));
    String href=Rs.getString("Url");//href
    if("/".equals(href.indexOf(0))){
        href = base + href;
    }
    obj.put("Url",href);
    
    obj.put("groupId",Rs.getString("groupId"));//groupId
    int newpage=Rs.getInt("newpage");//newpage
    obj.put("newpage",newpage);
    String target = "";
    if(newpage==1){
        target = "target='_blank'";//target
    }
     obj.put("target",target);
    boolean flag =(("1".equals(Rs.getString("status")))||Rs.getString("status")==null||"".equals(Rs.getString("status")));
    obj.put("status",flag);//status
	if("租户运营中心".equals(Rs.getString("prjname"))||"平台管理中心".equals(Rs.getString("prjname"))){
            if(role1!=1){
                continue;
            }
            if(role1==1&&companyid!=0){
                continue;
            }
            if("租户运营中心".equals(Rs.getString("prjname"))){
                if(!yunying1){
                    continue;
                }
            }
	}

    if("1".equals(Rs.getString("groupId"))&&flag){
        
        yyzc.put(obj);
    }else if("2".equals(Rs.getString("groupId"))&&flag){
        yyfb.put(obj);
    }else if("3".equals(Rs.getString("groupId"))&&flag){
        zyhj.put(obj);
    }else if("4".equals(Rs.getString("groupId"))&&flag){
        scgj.put(obj);
    }
}
  
String callback=getParameter(request,"callback");  
JSONArray array = new JSONArray();
JSONObject json = new JSONObject();
json.put("yyzc",yyzc);
json.put("yyfb",yyfb);
json.put("zyhj",zyhj);
json.put("scgj",scgj);
array.put(json);

 out.println(callback+"("+array+")");  

%>
   



