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
  public JSONArray listChannel_content_JS(int id, String s, UserInfo user, int channelnum) throws SQLException, JSONException,MessageException
  {
    JSONArray array = new JSONArray();

    int cloud_channelid = CmsCache.getParameter("sys_cloud_channelid").getIntValue();
    Channel ch = CmsCache.getChannel(id);
    ArrayList childs = ch.getChildChannelIDs();
    if ((childs != null) && (childs.size() > 0))
      for (int i = 0; i < childs.size(); ++i) {

		JSONObject o = new JSONObject();

        int channelid = ((Integer)childs.get(i)).intValue();
        Channel child = CmsCache.getChannel(channelid);

        if (child.getType2() == 8) continue;

        int type = child.getType();
        String channelname = child.getName();

        if (child.getIsShowDraftNumber() == 1)
        {
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

          if ((child.hasChild(user)) && (channelnum > 100))
          {
            o.put("load", 1);
			o.put("id", channelid);
          }
          else if (child.getId() == cloud_channelid)
          {
            String p = CmsCache.getParameterValue("sys_cloud_source");

            if (p.length() > 0)
            {
              o.put("cloud", 1);
			  o.put("id", 0);
            }
          }
          else
          {
            o.put("load", 0);
			o.put("id", channelid);
          }

		  o.put("name", channelname);
		  o.put("type", type);
		  o.put("icon", icon);

          if (channelnum <= 100){
            JSONArray oo = new Tree().listChannel_json(channelid, varName, user, 0);
			o.put("child", oo);
		  }
		  array.put(o);
        }
      }
    return array;
  }

%>
<%
long begin_time = System.currentTimeMillis();
JSONArray o2 = listChannel_content_JS(12919,"tree",userinfo_session,100);
out.println(o2);
%>
