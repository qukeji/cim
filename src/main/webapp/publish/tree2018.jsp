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
public JSONArray getPublishSiteTree_json(UserInfo user) throws SQLException, MessageException,JSONException
{
    JSONArray array = new JSONArray();

    String sql = "select * from channel where Parent=-1 and Type=5 order by OrderNumber,id";
    TableUtil tu = new TableUtil();
    TableUtil tu2 = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    while (rs.next()) {

		JSONObject o = new JSONObject();

		int siteid = rs.getInt("site");

		String application = convertNull(rs.getString("application"));
		int companyid = CmsCache.getSite(siteid).getCompany();
		//当前登录用户绑定了租户,站点不是公共站点,用户无站点权限，
		if(user.getCompany()!=0&&(!application.equals("publishsite"))&&(user.getCompany()!=companyid)){
			continue ;
		}

		String Name = convertNull(rs.getString("Name"));
		String varName = "lsh_" + siteid;
		
		o.put("name", Name);
		o.put("icon", "../images/tree/16_channel_site_icon.png");
		o.put("id", siteid);

		JSONArray array1 = new JSONArray();

		JSONObject o1 = new JSONObject();
		o1.put("name", "发布设置");
		o1.put("icon", "");
		o1.put("id", siteid);
		o1.put("type",1);
		array1.put(o1);

		int num = 0;
		sql = "select count(*) from publish_item where Status!=1 and Site=" + siteid;
		ResultSet rs2 = tu2.executeQuery(sql);
		if (rs2.next())
		{
			num = rs2.getInt(1);
		}
		tu2.closeRs(rs2);

		JSONObject o2 = new JSONObject();
		o2.put("name", "待发布任务"+ ((num > 0) ? "(" + num + ")" : ""));
		o2.put("icon", "");
		o2.put("id", siteid);
		o2.put("type",2);
		array1.put(o2);

		JSONObject o3 = new JSONObject();
		o3.put("name", "已发布任务");
		o3.put("icon", "");
		o3.put("id", siteid);
		o3.put("type",3);
		array1.put(o3);

		o.put("child",array1);

		array.put(o);
    }
    tu.closeRs(rs);

	JSONObject o_ = new JSONObject();
	o_.put("name", "其它");
	o_.put("icon", "../images/tree/16_channel_site_icon.png");
	o_.put("id", 0);

	JSONArray array_ = new JSONArray();
	JSONObject o1_ = new JSONObject();
	o1_.put("name", "发布设置");
	o1_.put("icon", "");
	o1_.put("id", -1);
	o1_.put("type",1);
	array_.put(o1_);

	JSONObject o2_ = new JSONObject();
	o2_.put("name", "待发布任务");
	o2_.put("icon", "");
	o2_.put("id", -1);
	o2_.put("type",2);
	array_.put(o2_);

	JSONObject o3_ = new JSONObject();
	o3_.put("name", "已发布任务");
	o3_.put("icon", "");
	o3_.put("id", -1);
	o3_.put("type",3);
	array_.put(o3_);

	o_.put("child",array_);
	array.put(o_);

    return array;
}

%>
<%
long begin_time = System.currentTimeMillis();
JSONArray o2 = getPublishSiteTree_json(userinfo_session);
out.println(o2);
%>
