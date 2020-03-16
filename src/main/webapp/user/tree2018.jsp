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
public JSONArray listGroup_json(UserInfo user) throws SQLException, MessageException,JSONException
{
	JSONArray array = new JSONArray();

    int RootGroupID = 0;
    String Sql = "select * from user_group where Parent=-1";
	TableUtil tu_user = new TableUtil("user");
    ResultSet Rs = tu_user.executeQuery(Sql);
    if (!(Rs.next()))
    {
      tu_user.closeRs(Rs);
      return array;
    }

    String RootGroupName = convertNull(Rs.getString("Name"));
    RootGroupID = Rs.getInt("id");

    tu_user.closeRs(Rs);

    Sql = "select * from user_group where Parent=" + RootGroupID + " order by OrderNumber,id";
    Rs = tu_user.executeQuery(Sql);
    while (Rs.next())
    {
		JSONObject o = new JSONObject();

		int groupid = Rs.getInt("id");
		String groupname = convertNull(Rs.getString("Name"));

		String varName = "lsh_" + groupid;
		String icon = "";
		icon = ",'','../images/tree/icon_16_user_group.gif','../images/tree/icon_16_user_group.gif'";

		o.put("name", groupname);
		o.put("icon", icon);
		o.put("id", groupid);

		JSONArray oo = listGroup_json(groupid, varName, user);

		o.put("child", oo);

		array.put(o);
    }
    tu_user.closeRs(Rs);
    return array;
  }

  public JSONArray listGroup_json(int id, String s, UserInfo user) throws SQLException, MessageException,JSONException
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
          String varName = "lsh_" + groupid;
          String icon = "";
          icon = ",'','../images/tree/icon_16_user_group.gif','../images/tree/icon_16_user_group.gif'";

		  o.put("name", groupname);
		  o.put("icon", icon);
		  o.put("id", groupid);

		  JSONArray oo = listGroup_json(groupid, varName, user);

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
long begin_time = System.currentTimeMillis();
JSONArray o2 = listGroup_json(userinfo_session);
out.println(o2);
%>
