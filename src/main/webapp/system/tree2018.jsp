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
public JSONArray getSiteTree(tidemedia.cms.user.UserInfo userinfo_session) throws SQLException, MessageException,JSONException {

    JSONArray array = new JSONArray();

	TableUtil tu = new TableUtil();
    String sql = "select * from channel where Parent=-1 and Type=5 order by OrderNumber,id";
    ResultSet rs = tu.executeQuery(sql);
    while (rs.next()) {

		JSONObject o = new JSONObject();

		int siteid = rs.getInt("site");
		int channelID = rs.getInt("id");
		Site site = CmsCache.getSite(siteid);
		Channel channel = CmsCache.getChannel(channelID);
		//当前登录用户绑定了租户,站点不是公共站点,用户无站点权限，
		if(userinfo_session.getCompany()!=0&&(!channel.getApplication().equals("publishsite"))&&(userinfo_session.getCompany()!=site.getCompany())){
			continue ;
		}


		String Name = convertNull(rs.getString("Name"));
		String varName = "lsh_" + siteid;

		o.put("name", Name);
		o.put("type", 3);
		o.put("icon", "../images/tree/16_channel_site_icon.png");
		o.put("id", siteid);
		o.put("load", 0);
	
		array.put(o);

    }
    tu.closeRs(rs);

    return array;
}
%>
<%
long begin_time = System.currentTimeMillis();
JSONArray o2 = getSiteTree(userinfo_session);
out.println(o2);
%>
