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
public JSONArray list_channel_content_json(UserInfo user) throws SQLException, MessageException, JSONException
{
    long a = System.currentTimeMillis();
    int ChannelNumber = 0;
    JSONArray array = new JSONArray();

    ChannelNumber = new Tree().getChannelNumber();

    Channel ch = CmsCache.getChannel(-1);
    ArrayList childs = ch.getChildChannelIDs();
    if ((childs != null) && (childs.size() > 0))
      for (int i = 0; i < childs.size(); ++i)
      {
        JSONObject o = new JSONObject();

        int channelid = ((Integer)childs.get(i)).intValue();

        Channel child = CmsCache.getChannel(channelid);
        int type = child.getType();
        String channelname = child.getName();

        if (child.getIsShowDraftNumber() == 1)
        {
          int num = child.getNumber(0);
          if (num > 0)
            channelname = channelname + " (" + num + ")";
        }

        Site site = child.getSite();
        if (site.getContentChannelID() == 0) continue;

        Channel newch = CmsCache.getChannel(site.getContentChannelID());
        if ((type == 5) && (user.hasChannelShowRight(newch.getId()))) {
          String varName = "lsh_" + channelid;
          String icon = new Tree().getIcon(child);
          if ((child.hasChild(user)) && (ChannelNumber > 100) && (type != 5))

			  o.put("id", channelid);

          else
			  o.put("id", newch.getId());

          o.put("name", channelname);
          o.put("type", type);
          o.put("icon", icon);

          if ((type == 5) || (ChannelNumber <= 100))
          {
            JSONArray oo = new Tree().listChannel_json(newch.getId(), varName, user, ChannelNumber);
            o.put("child", oo);
          }
          array.put(o);
        }

      }


    return array;
  }
%>
<%

	JSONArray o = list_channel_content_json(userinfo_session);
	out.println(o);

%>
