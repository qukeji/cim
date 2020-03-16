<%@ page import="tidemedia.cms.system.*,
				org.json.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.util.*,
				java.sql.*,
				tidemedia.cms.user.UserInfo,
				java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%!

public JSONArray listGroup_json() throws SQLException, MessageException,JSONException
{
    JSONArray array = new JSONArray();

	TableUtil tu = new TableUtil();

    int RootGroupID = 0;
    String Sql = "select * from spider_group where Parent=-1";
    ResultSet Rs = tu.executeQuery(Sql);
    if (!(Rs.next()))
    {
      tu.closeRs(Rs);
      return array;
    }

    String RootGroupName = convertNull(Rs.getString("Name"));
    RootGroupID = Rs.getInt("id");

    tu.closeRs(Rs);

    
    Sql = "select * from spider_group where Parent=" + RootGroupID + " order by OrderNumber,id";
    Rs = tu.executeQuery(Sql);
    while (Rs.next())
    {

		JSONObject o = new JSONObject();

		int groupid = Rs.getInt("id");
		String groupname = convertNull(Rs.getString("Name"));

		String varName = "lsh_" + groupid;
		String icon = "";
		icon = ",'','../images/tree/icon_16_user_group.gif','../images/tree/icon_16_user_group.gif'";

		o.put("name", groupname);
		o.put("id", groupid);
		o.put("icon", icon);

		JSONArray oo = listGroup_json(groupid, varName);
		o.put("child", oo);

		array.put(o);
    }
    tu.closeRs(Rs);

    return array;
}

public JSONArray listGroup_json(int id, String s) throws SQLException, MessageException,JSONException
{
    JSONArray array = new JSONArray();

    TableUtil tu = new TableUtil();
    String Sql = "select * from spider_group where Parent=" + id + " order by OrderNumber,id";
    ResultSet Rs = tu.executeQuery(Sql);
    if (Rs.next())
    {
      do
      {
		  JSONObject o = new JSONObject();
          int groupid = Rs.getInt("id");
          String groupname = convertNull(Rs.getString("Name"));

          String varName = "lsh_" + groupid;
          String icon = "";

          icon = ",'','../images/tree/icon_16_user_group.gif','../images/tree/icon_16_user_group.gif'";

		  o.put("name", groupname);
		  o.put("id", groupid);
		  o.put("icon", icon);

		  JSONArray oo = listGroup_json(groupid, varName);
		  o.put("child", oo);

		  array.put(o);
      }
      while (
        Rs.next());
    }

    tu.closeRs(Rs);

    return array;
}

%>
<%
JSONArray o2 = listGroup_json();
out.println(o2);
%>
