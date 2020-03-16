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
	public JSONArray listChannel_JS(UserInfo user) throws JSONException,MessageException,SQLException{
		
		JSONArray array = new JSONArray();

		int ChannelNumber = 0;
		ChannelNumber = Tree.getChannelNumber();
		Channel ch = CmsCache.getChannel(-1);
		ArrayList childs = ch.getAllChildChannelIDs();

		if ((childs != null) && (childs.size() > 0)){
			for (int i = 0; i < childs.size(); ++i) {

				JSONObject o = new JSONObject();

				int channelid = ((Integer)childs.get(i)).intValue();
				if(channelid==16492){
				Channel child = CmsCache.getChannel(channelid);
				int type = child.getType();
				String channelname = child.getName();

				if(type==5 && user.isSiteAdministrator())
				{System.out.println("user.getSite():"+user.getSite()+","+channelid);
					if(user.getSite().equals(child.getSiteID()+""))
					{}
					else
						continue;
				}

				if (child.getIsShowDraftNumber() == 1)
				{
					int num = child.getNumber(0);
					if (num > 0)
						channelname = channelname + " (" + num + ")";
				}
				if ((user.hasChannelShowRight(channelid))) {//(type == 5) || 
					String varName = "lsh_" + channelid;
					String icon = new Tree().getIcon(child);

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);

					JSONArray oo = listChannel_JS(channelid, varName, user, ChannelNumber);
					o.put("child", oo);

					array.put(o);
				}
				}
			}
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

				

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);

				
						JSONArray oo = listChannel_JS2(channelid, varName, user,channelnum );
				    	o.put("child", oo);
					
					array.put(o);
				}
			}
		}
		return array;
	}
	
	
	public JSONArray listChannel_JS2(int id, String s, UserInfo user, int channelnum) throws JSONException,MessageException,SQLException{
		
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
JSONArray o2 = listChannel_JS(userinfo_session);
out.println(o2);
%>
