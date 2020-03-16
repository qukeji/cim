<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
//获取分组颜色
public String getGroup(int groupid) throws SQLException,MessageException,JSONException{
	TideJson json = CmsCache.getParameter("tcenter_main").getJson();//首页模块
	JSONArray arr = json.getJSONArray("main");
	for(int i=0;i<arr.length();i++){
		JSONObject json1 = arr.getJSONObject(i);//一级分组
		JSONArray arr1 = json1.getJSONArray("module");
		for(int j=0;j<arr1.length();j++){
			JSONObject json2 = arr1.getJSONObject(j);
			String class_ = json2.getString("class");
			int id = json2.getInt("id");
			if(groupid==id){
				return class_ ;
			}
		}
	}
	return "";
}
%>
<%
    Integer userId = userinfo_session.getId();
   
	String csstype = "yyzc";

	String whereSql = "";
	//获取租户的产品权限
	int companyid = userinfo_session.getCompany();
	if(companyid>0){//当前登录用户是租户用户
		String products = new Company(companyid).getProducts();
		if(products.equals("")){products="-1";}
		whereSql += " and tp.id in ("+products+")";
	}

    String sql = "select tp.id pid,up.userid uid,tp.logo,tp.groupId,tp.OrderNumber,tp.Name prjname,tp.Url,up.status from tide_products tp left join (select * from user_product where UserId = '"+userId+"') up on tp.id =up.ProductId";
	sql += " where tp.Status = 1 and groupId<5"+whereSql;
    sql +=  " and tp.Isview=1";

	sql += " order by tp.OrderNumber asc,tp.id asc";


    TableUtil tu = new TableUtil("user");
    ResultSet Rs = tu.executeQuery(sql);
    JSONArray array = new JSONArray();
    while(Rs.next()){
       
        JSONObject obj = new JSONObject();
        obj.put("logo",Rs.getString("logo"));
        obj.put("prjname",Rs.getString("prjname"));
        obj.put("Url",Rs.getString("Url"));
        //System.out.println(Rs.getString("status"));
        boolean flag =(("1".equals(Rs.getString("status")))||Rs.getString("status")==null||"".equals(Rs.getString("status")));
        obj.put("flag",flag);
        obj.put("pid",Rs.getString("pid"));
        obj.put("uid",convertNull(Rs.getString("uid")));
        array.put(obj);
    }
      out.println(array.toString());
%>
