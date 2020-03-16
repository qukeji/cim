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

	public JSONArray listSource_JS(UserInfo user) throws SQLException, MessageException,JSONException{

		JSONArray array = new JSONArray();

		int channelid;
		Channel child;
		int cloud_channelid = CmsCache.getParameter("sys_cloud_channelid").getIntValue();

		Channel ch = CmsCache.getChannel(-1);
		Channel source_ch = null;
		ArrayList childs = ch.getChildChannelIDs();
		for (int i = 0; i < childs.size(); ++i) {
		  channelid = ((Integer)childs.get(i)).intValue();
		  child = CmsCache.getChannel(channelid);
		  if (child.getType2() == 9) source_ch = child;
		}

		if (source_ch == null) return array;

		childs = source_ch.getChildChannelIDs();
		if ((childs != null) && (childs.size() > 0))
		  for (int i = 0; i < childs.size(); ++i) {

			JSONObject o = new JSONObject();

			channelid = ((Integer)childs.get(i)).intValue();
			child = CmsCache.getChannel(channelid);
			int type = child.getType();
			String channelname = child.getName();
			String varName = "lsh_" + channelid;
			String icon = new Tree().getIcon(child);

			if (child.getIsShowDraftNumber() == 1)
			{
			  int num = child.getNumber(0);
			  if (num > 0)
				channelname = channelname + " (" + num + ")";

			}

			if (child.getId() == cloud_channelid)
			{
			  String p = CmsCache.getParameterValue("sys_cloud_source");

			  if (p.length() > 0)
			  {
				o.put("name", channelname);
				o.put("path", "../source/tree_api_json.jsp");
				o.put("id", channelid);
				o.put("type", type);
				o.put("icon", icon);
				o.put("load", 1);
				o.put("cloud", 0);
			  }
			}
			else
			{
				o.put("name", channelname);
				o.put("id", channelid);
				o.put("type", type);
				o.put("icon", icon);
				o.put("load", 0);
				o.put("cloud", 0);

				JSONArray oo = listChannel_JS(channelid, varName, user, 0);
				o.put("child", oo);
			}
			array.put(o);
		}
		return array;
	}

   public JSONArray listChannel_JS(int id, String s, UserInfo user, int channelnum) throws JSONException,MessageException,SQLException{
		
		JSONArray array = new JSONArray();

		Channel ch = CmsCache.getChannel(id);
		ArrayList childs = ch.getAllChildChannelIDs();
		if ((childs != null) && (childs.size() > 0)) {

			for (int i = 0; i < childs.size(); ++i) {

				JSONObject o = new JSONObject();

				int channelid = ((Integer)childs.get(i)).intValue();
				Channel child = CmsCache.getChannel(channelid);
				int type = child.getType();
				String channelname = child.getName();

				if (child.getIsShowDraftNumber() == 1){
				  int num = child.getNumber(0);
				  if (num > 0)
					channelname = channelname + " (" + num + ")";
				}

				if (user.hasChannelShowRight(channelid)) {
					String varName = "lsh_" + channelid;
					String icon = "";
					icon = new Tree().getIcon(child);

					if (child.getType2() == 3)
						icon = new Tree().getIconByType2(child.getType2());

					if ((channelnum > 100) && (child.hasChild(user))){
						o.put("load", 1);
					}else{
						o.put("load", 0);
					}

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);
					o.put("cloud", 0);

					if (channelnum <= 100) {
						JSONArray oo = listChannel_JS(channelid, varName, user, 0);
						o.put("child", oo);
					}
					array.put(o);
				}
			}
		}
		return array;
	}

%>
<%
long begin_time = System.currentTimeMillis();
JSONArray o2 = listSource_JS(userinfo_session);
out.println(o2);
%>
