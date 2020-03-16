<%@ page import="org.json.JSONArray" %>
<%@ page import="tidemedia.cms.user.UserInfo" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.user.UserInfoUtil" %>
<%@ page pageEncoding="utf-8"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    public static ArrayList hasChannelShowRight(ArrayList<Channel> channels,ArrayList<ChannelPrivilegeItem> ChannelPermArray) throws SQLException,MessageException {
        boolean right = false;
        ArrayList arr = new ArrayList();
        //Channel channel = CmsCache.getChannel(channelid);
        for(int i = 0;i<ChannelPermArray.size();i++)
        {
            ChannelPrivilegeItem ci = (ChannelPrivilegeItem)ChannelPermArray.get(i);
            Channel cichannel = CmsCache.getChannel(ci.getChannel());
            for(int m = 0;m<channels.size();m++) {
                Channel ch = (Channel)channels.get(m);
                //System.out.println(channelid+","+ci.getChannel()+","+ci.getPermType());
                if (ci.getChannel() == ch.getId())//本频道
                {
                    int[] perms = ci.getPermArray();
                    if (perms != null) {
                        //System.out.println("len:"+perms.length);
                        for (int j = 0; j < perms.length; j++) {
                            int permtype = perms[j];
                            if (permtype == 0 || permtype == 1) {//System.out.print("true");
                                arr.add(ch);
                            }
                            if (permtype == -1) {
                                //return false;
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
                                }
                                if (permtype == -1) {
                                    right = false;
                                }
                            }
                        }
                    }
                }
            }
        }

        return arr;
    }

    //推荐的时候显示频道结构
    public JSONArray listTreeByChannelRecommendOut_json(UserInfo user, int channelID) throws SQLException, MessageException, JSONException
    {
        long start = System.currentTimeMillis();
        JSONArray array = new JSONArray();
        String siteids = ",";

        Channel channel = CmsCache.getChannel(channelID);
        String s = channel.getRecommendOut();
        //System.out.println(s);
        System.out.println("tree1:"+(System.currentTimeMillis()-start));
		
        String[] options = Util.StringToArray(s, "\n");
		System.out.println("options size:"+options.length);

        ArrayList channels_ = new ArrayList();
        for (int i = 0; i < options.length; i++) {
            String o = options[i].replace("\r", "");
            Channel ch = CmsCache.getChannel(o);
            //System.out.println(ch.getName());
            if (ch == null) continue;
            channels_.add(ch);
        }

        ArrayList channels = hasChannelShowRight(channels_,user.getChannelPermArray());

        System.out.println("tree2:" + (System.currentTimeMillis() - start));


        for (int i = 0; i < channels.size(); i++) {
            JSONObject json = new JSONObject();
            Channel ch = (Channel)channels.get(i);
            System.out.println("tree3:"+(System.currentTimeMillis()-start));
            Channel sitech = CmsCache.getChannel("s"+ch.getSiteID());

            if(!siteids.contains(","+sitech.getId()+","))
            {
                siteids += sitech.getId()+",";

                json.put("name", sitech.getName());
                json.put("id", sitech.getId());
                json.put("type", sitech.getType());
                json.put("icon", "");
                array.put(json);
            }

            int channelid = ch.getId();

            //是租户用户且频道是租户公共频道
            if(user.getCompany()>0 && ch.isShareChannel())
            {
                Channel channel_ = ChannelUtil.getCompanyChannelByShare(ch, user.getCompany());
                if(channel_!=null)
                    channelid = channel_.getId();
                else
                    break;
            }
            System.out.println("tree4:"+(System.currentTimeMillis()-start));
            //是租户用户,是租户频道,但不是同一租户（如：vms音视频媒资下的临时租户频道）
            if(user.getCompany()>0 && ch.getCompany()>0 && user.getCompany()!=ch.getCompany()){
                continue;
            }

            String varName = "lsh_" + channelid;

            JSONObject o_site = null;
            for(int j=0;j<array.length();j++){
                JSONObject o_ = array.getJSONObject(j);
                if(o_.getInt("id")==sitech.getId())
                {
                    o_site = o_;
                }
            }


            if(o_site!=null)
            {
                JSONObject json_ = new JSONObject();

                System.out.println("n:"+ch.getName());
                json_.put("name", ch.getName());
                json_.put("id", channelid);
                json_.put("type", ch.getType());
                json_.put("icon", "");
                JSONArray ooo = new JSONArray();
                if(o_site.has("child"))
                {
                    JSONArray ooo_ = o_site.getJSONArray("child");
                    if(ooo_!=null) ooo = ooo_;
                }

                //if(Tree.getChannelNumber() > 100 && ch.hasChild(user))
				if(Tree.getChannelNumber() > 100 )
                {
                    json_.put("load", 1);
                    json_.put("path", "../channel/channel_xml.jsp?id=" + channelid);
                }
                else
                {
                    json_.put("load", 0);
                    json_.put("path", "");
                    JSONArray oo = listChannel_json(channelid, varName, user,Tree.getChannelNumber());
                    json_.put("child", oo);
                }


                ooo.put(json_);

                //System.out.println(oo);
                o_site.put("child",ooo);
            }
        }
        System.out.println("tree5:"+(System.currentTimeMillis()-start));
        return array;
    }

    public JSONArray listChannel_json(int id, String s, UserInfo user,int channelnum) throws SQLException, MessageException, JSONException {
        JSONArray array = new JSONArray();

        Channel ch = CmsCache.getChannel(id);

		/*
		String a = ch.getApplication();
		//当前登录用户绑定了租户,此频道下面是租户频道(聚融，大屏),且application都是唯一值，后面再有租户频道的application设置前缀"public_"
		if(user.getCompany()!=0&&(a.startsWith("pgc_")||a.startsWith("screen")||a.startsWith("task")||a.startsWith("shenpian")||a.startsWith("shengao"))){
			//获取符合条件的租户频道,替换ch对象，后面逻辑不变
			id = getChannelID(id,user);
			ch = CmsCache.getChannel(id);
			if(id==0) return array;
		}
		*/

        ArrayList<Integer> childs = ch.getAllChildChannelIDs();

        if (childs!=null && childs.size()>0) {
            for(int i = 0;i<childs.size();i++){
                JSONObject o = new JSONObject();

                int channelid = (Integer)childs.get(i);
                Channel child = CmsCache.getChannel(channelid);

                int type = child.getType();

                String channelname = child.getName();
                if(child.getIsShowDraftNumber()==1)
                {
                    int num = child.getNumber(0);
                    if(num>0)
                        channelname = channelname + " (" + num + ")";
                }

                if (user.hasChannelShowRight(channelid)) {
                    String varName = "lsh_" + channelid;
                    String icon = "";
                    icon = "";

                    if(child.getType2()==Channel.ChannelSpecial)
                        icon = "";

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
                        //JSONArray oo = listChannel_json(channelid, varName, user, 0);
                        //o.put("child", oo);
                    }
                    array.put(o);
                }
            }
        }
        return array;
    }
%>
<%
long start = System.currentTimeMillis();
int channelid = 227;
JSONArray arr =listTreeByChannelRecommendOut_json(userinfo_session,channelid);
long end = System.currentTimeMillis();
System.out.println("time:"+(end-start)+"ms");
%>
<%=arr%>