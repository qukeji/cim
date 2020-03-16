 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.text.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
//站点列表
%>

<%
	int company = getIntParameter(request,"company");
	int type = getIntParameter(request,"type");//type==1 租户列表   type=2 新建和编辑租户   type=3 删除租户

	JSONObject json_site =new JSONObject();
	JSONArray arr = new JSONArray();
	String siteNames = "";

	TableUtil tu = new TableUtil();
	String Sql = "select * from site";
	if(type==1||type==3){
		Sql += " where company="+company ;
	}else if(type==2){
		Sql += " where company="+company+" or company=0";
	}

	Sql += " order by id asc";
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next()){
		JSONObject json = new JSONObject();
		json.put("siteId", Rs.getInt("id"));
		json.put("siteName", convertNull(Rs.getString("Name")));
		json.put("company", Rs.getInt("company"));
		arr.put(json);

		if(!siteNames.equals("")){
			siteNames += "<br>";
		}
		siteNames += convertNull(Rs.getString("Name")) ;
	}
	tu.closeRs(Rs);
	
	json_site.put("sites",arr);

	String result = json_site.toString();
	if(type==1){
		result = siteNames ;
	}

	out.println(result);

%>
