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
public JSONArray listGroup_json(String serialNo) throws SQLException, MessageException,JSONException
{
    JSONArray array = new JSONArray();

    int RootGroupID = 0;

    String Sql = "select * from template_group where Parent=-1";

    if (serialNo.length() > 0)
      Sql = "select * from template_group where SerialNo='" + serialNo + "'";

	TableUtil tu1 = new TableUtil();
    ResultSet Rs = tu1.executeQuery(Sql);
    if (!(Rs.next()))
    {
      tu1.closeRs(Rs);
      return array;
    }

    String RootGroupName = convertNull(Rs.getString("Name"));
    RootGroupID = Rs.getInt("id");

    tu1.closeRs(Rs);

    TableUtil tu = new TableUtil();
    Sql = "select * from template_group where Parent=" + RootGroupID + " order by OrderNumber,id";
    Rs = tu.executeQuery(Sql);
    while (Rs.next())
    {

		JSONObject o = new JSONObject();

      int groupid = Rs.getInt("id");
      String groupname = convertNull(Rs.getString("Name"));

      String varName = "lsh_" + groupid;
      String icon = "";
      icon = ",'','',''";

	  o.put("name", groupname);
	  o.put("icon", icon);
	  o.put("id", groupid);

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
    String Sql = "select * from template_group where Parent=" + id + " order by OrderNumber,id";
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

        icon = ",'','',''";

		o.put("name", groupname);
		o.put("icon", icon);
		o.put("id", groupid);

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
long begin_time = System.currentTimeMillis();
JSONArray o2 = listGroup_json("");
out.println(o2);
%>
