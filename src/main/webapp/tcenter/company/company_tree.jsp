<%@ page import="tidemedia.cms.system.*,
				org.json.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%!
public JSONArray listGroup_json(int id,int type) throws SQLException, MessageException,JSONException
{
	JSONArray array = new JSONArray();

	TableUtil tu_user = new TableUtil("user");
	String Sql = "";
	if(type==1){
		Sql = "select * from user_group where company=" + id + " order by OrderNumber,id";
	}else{
		Sql = "select * from user_group where Parent=1 and company=0 order by OrderNumber,id";
	}
    
    ResultSet Rs = tu_user.executeQuery(Sql);
    while (Rs.next())
    {
		JSONObject o = new JSONObject();

		int groupid = Rs.getInt("id");
		String groupname = convertNull(Rs.getString("Name"));
		int company = 0 ;

		o.put("name", groupname);
		o.put("id", groupid);
		if(type==1){
			company = id ;
			o.put("company",company);
		}

		JSONArray oo = listGroup_json_(groupid,company);

		o.put("child", oo);

		array.put(o);
    }
    tu_user.closeRs(Rs);
    return array;
  }

  public JSONArray listGroup_json_(int id,int company) throws SQLException, MessageException,JSONException
  {
    JSONArray array = new JSONArray();

    TableUtil tu_user = new TableUtil("user");
    String Sql = "select * from user_group where Parent=" + id + " order by OrderNumber,id";
    ResultSet Rs = tu_user.executeQuery(Sql);
    if (Rs.next())
    {
      do
      {
		  JSONObject o = new JSONObject();

		  int groupid = Rs.getInt("id");
          String groupname = convertNull(Rs.getString("Name"));

		  o.put("name", groupname);
		  o.put("id", groupid);
		  o.put("company",company);

		  JSONArray oo = listGroup_json_(groupid,company);

		  o.put("child", oo);

		  array.put(o);
      }
      while (
        Rs.next());
    }

    tu_user.closeRs(Rs);

    return array;
}

%>

<%
int id = getIntParameter(request,"id");
int type = getIntParameter(request,"type");//1:租户 2:用户组  3:所有租户

if(type==3){	
	//当前登录用户的租户id
	int companyid = userinfo_session.getCompany();
	Company company = new Company();
	JSONArray arr = company.getGroup(companyid);
	out.println(arr);
}else{
	JSONArray o2 = listGroup_json(id,type);
	out.println(o2);
}
%>
