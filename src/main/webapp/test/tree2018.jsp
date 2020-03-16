<%@ page import="tidemedia.cms.system.*,
				org.json.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.util.*,
				java.sql.*,
				tidemedia.cms.user.UserInfo,
				java.net.URLEncoder"%>
<%@ page import="tidemedia.cms.user.UserInfoUtil" %>
<%@ page import="java.io.IOException" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%!
	public static ArrayList hasChannelShowRight(ArrayList<Channel> channels,ArrayList<ChannelPrivilegeItem> ChannelPermArray,JspWriter out_) throws SQLException, MessageException, IOException {
		boolean right = false;
		ArrayList arr = new ArrayList();
		//Channel channel = CmsCache.getChannel(channelid);
		for(int i = 0;i<ChannelPermArray.size();i++)
		{
			ChannelPrivilegeItem ci = (ChannelPrivilegeItem)ChannelPermArray.get(i);
			Channel cichannel = CmsCache.getChannel(ci.getChannel());
			for(int m = 0;m<channels.size();m++) {
				Channel ch = (Channel)channels.get(m);

				if (ci.getChannel() == ch.getId())//本频道
				{
					out_.println(ch.getId()+","+ci.getChannel()+","+ci.getPermType()+"*<br>");
					int[] perms = ci.getPermArray();
					if (perms != null) {
						//System.out.println("len:"+perms.length);
						for (int j = 0; j < perms.length; j++) {
							int permtype = perms[j];
							if (permtype == 0 || permtype == 1) {//System.out.print("true");
								arr.add(ch);
								out_.println("show1:"+ch.getId());
								break;
							}
							if (permtype == -1) {
								//return false;
								break;
							}
						}
					}
				} else {
					//包括子频道和是其父频道
					//System.out.println("inherit:"+ci.getIsInherit()+","+channel.getChannelCode()+","+cichannel.getChannelCode());
					if (ci.getIsInherit() == 1 && cichannel.getChannelCode().length() > 0 && ch.getChannelCode().startsWith(cichannel.getChannelCode())) {
						int[] perms = ci.getPermArray();
						if (perms != null) {
							for (int j = 0; j < perms.length; j++) {
								int permtype = perms[j];
								if (permtype == 0 || permtype == 1) {
									right = true;//System.out.println("true");
									arr.add(ch);
									out_.println("show2:"+ch.getId());
									break;
								}
								if (permtype == -1) {
									right = false;
									break;
								}
							}
						}
					}
				}
			}
		}

		return arr;
	}

	//频道管理中
	public JSONArray listChannel_json(int id, String s, UserInfo user,int channelnum,JspWriter out_) throws SQLException, MessageException, JSONException, IOException {
		JSONArray array = new JSONArray();
		long start = System.currentTimeMillis();
		Channel ch = CmsCache.getChannel(id);

		ArrayList<Integer> childs = ch.getAllChildChannelIDs();

		if (childs!=null && childs.size()>0) {

			ArrayList channels_ = new ArrayList();
			for(int i = 0;i<childs.size();i++) {
				JSONObject o = new JSONObject();

				int channelid = (Integer) childs.get(i);
				Channel child = CmsCache.getChannel(channelid);
				channels_.add(child);
			}

			System.out.println("tree81:"+(System.currentTimeMillis()-start));
			ArrayList channels = hasChannelShowRight(channels_,user.getChannelPermArray(),out_);
			System.out.println("tree82:"+(System.currentTimeMillis()-start));

			for(int i = 0;i<channels.size();i++){
				JSONObject o = new JSONObject();
				Channel child = (Channel)channels.get(i);
				int channelid = child.getId();
				out_.println("*"+channelid);

				int type = child.getType();

				String channelname = child.getName();
				if(child.getIsShowDraftNumber()==1)
				{
					int num = child.getNumber(0);
					if(num>0)
						channelname = channelname + " (" + num + ")";
				}

				//if (user.hasChannelShowRight(channelid)) {
					String varName = "lsh_" + channelid;
					String icon = "";
					icon = new Tree2019().getIcon(child);

					if(child.getType2()==Channel.ChannelSpecial)
						icon = new Tree2019().getIconByType2(child.getType2());

					if(channelnum > 100 && child.hasChild(user))
					{
						o.put("load", 1);
						o.put("path", "../channel/channel_xml.jsp?id=" + channelid);
					}
					else
					{
						o.put("load", 0);
						o.put("path", "");
					}

					//是租户用户且频道是租户公共频道
					if(user.getCompany()>0 && child.isShareChannel())
					{
						Channel channel_ = ChannelUtil.getCompanyChannelByShare(child, user.getCompany());
						if(channel_!=null)
							channelid = channel_.getId();
						else
							break;
					}

					//是租户用户,是租户频道,但不是同一租户（如：vms音视频媒资下的临时租户频道）
					if(user.getCompany()>0 && child.getCompany()>0 && user.getCompany()!=child.getCompany()){
						continue;
					}

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);

					if (channelnum <= 100) {
						JSONArray oo = listChannel_json(channelid, varName, user, 0,out_);
						o.put("child", oo);
					}
					array.put(o);
				//}
			}
		}
		return array;
	}

	public JSONArray listChannel_json(UserInfo user,JspWriter out_) throws SQLException, MessageException, JSONException, IOException {
		long start = System.currentTimeMillis();
		JSONArray array = new JSONArray();

		int ChannelNumber = 0;
		ChannelNumber = Tree2019.getChannelNumber();
		Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getAllChildChannelIDs();
		System.out.println("tree1:"+(System.currentTimeMillis()-start)+",ChannelNumber:"+ChannelNumber);
		if (childs!=null && childs.size()>0) {

			ArrayList channels_ = new ArrayList();
			for(int i = 0;i<childs.size();i++) {
				JSONObject o = new JSONObject();

				int channelid = (Integer) childs.get(i);
				//out_.println("child:"+channelid+"<br>");
				Channel child = CmsCache.getChannel(channelid);
				channels_.add(child);
			}
			System.out.println("tree2:"+(System.currentTimeMillis()-start));
			ArrayList channels = hasChannelShowRight(channels_,user.getChannelPermArray(),out_);
			System.out.println("tree3:"+(System.currentTimeMillis()-start));
			System.out.println("tree3 childs.size():"+childs.size()+","+channels.size());
			for(int i = 0;i<channels.size();i++){
				JSONObject o = new JSONObject();
				Channel child = (Channel)channels.get(i);
				int channelid = child.getId();
				out_.println("*"+channelid);
				//当前登录用户绑定了租户,站点不是公共站点,用户无站点权限，
				if(user.getCompany()!=0&&(!child.getApplication().equals("publishsite"))&&(user.getCompany()!=child.getSite().getCompany())){
					continue ;
				}

				int type = child.getType();
				String channelname = child.getName();

				if(child.getIsShowDraftNumber()==1)
				{
					int num = child.getNumber(0);
					if(num>0)
						channelname = channelname + " (" + num + ")";
				}

				//if (user.hasChannelShowRight(channelid)) {//type == Channel.Site_Type ||
					String varName = "lsh_" + channelid;
					String icon = new Tree2019().getIcon(child);

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);
				System.out.println("tree31:"+(System.currentTimeMillis()-start));
					JSONArray oo = listChannel_json(channelid, varName, user, ChannelNumber,out_);
				System.out.println("tree32:"+(System.currentTimeMillis()-start));
					o.put("child", oo);

					array.put(o);
				//}
			}
			System.out.println("tree4:"+(System.currentTimeMillis()-start));
		}
		//long b = System.currentTimeMillis();
		//System.out.println("listChannel_JS:" + (b-a) + "毫秒");
		return array;
	}

	public JSONArray listChannel_json_old(UserInfo user,JspWriter out_) throws SQLException, MessageException, JSONException, IOException {
		//long a = System.currentTimeMillis();
		JSONArray array = new JSONArray();

		int ChannelNumber = 0;
		ChannelNumber = Tree.getChannelNumber();
		Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getAllChildChannelIDs();

		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
				JSONObject o = new JSONObject();

				int channelid = (Integer)childs.get(i);
				Channel child = CmsCache.getChannel(channelid);

				//当前登录用户绑定了租户,站点不是公共站点,用户无站点权限，
				//if(user.getCompany()!=0&&(!child.getApplication().equals("publishsite"))&&(user.getCompany()!=child.getSite().getCompany())){
				//	continue ;
				//}

				int type = child.getType();
				String channelname = child.getName();

				if(child.getIsShowDraftNumber()==1)
				{
					int num = child.getNumber(0);
					if(num>0)
						channelname = channelname + " (" + num + ")";
				}

				if (user.hasChannelShowRight(channelid)) {//type == Channel.Site_Type ||
					String varName = "lsh_" + channelid;
					String icon = new Tree2019().getIcon(child);
					out_.println("*"+channelname+","+channelid+",<br>");
					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);

					JSONArray oo = new Tree2019().listChannel_json(channelid, varName, user, ChannelNumber);
					o.put("child", oo);

					array.put(o);
				}
				else
				{
					out_.println(":"+channelname+",");
				}
			}
		}
		//long b = System.currentTimeMillis();
		//System.out.println("listChannel_JS:" + (b-a) + "毫秒");
		return array;
	}
%>
<%
long begin_time = System.currentTimeMillis();

Tree tree = new Tree();
JSONArray o2 = listChannel_json(userinfo_session,out);
out.println(o2);
out.println("listChannel_JS:" + (System.currentTimeMillis()-begin_time) + "毫秒<br><br><br><br>");

	begin_time = System.currentTimeMillis();
	JSONArray o3 = listChannel_json_old(userinfo_session,out);
	out.println(o3);
	out.println("listChannel_JS:" + (System.currentTimeMillis()-begin_time) + "毫秒");

%>
