package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.user.UserInfoUtil;
import tidemedia.cms.util.Util;


/**
 * @author 李永海
 * 时间：20190505
 * 代替Tree.java，增加租户机制处理
 *
 */
public class Tree2019 extends Table{
	
	static boolean inited = false;
	static int	channel_number = 0;
	
	public Tree2019() throws MessageException, SQLException {
		super();
	}

	//获取频道总数量
	public static int getChannelNumber()
	{
		if(!inited)
		{
			TableUtil tu;
			try {
				tu = new TableUtil();
				String Sql = "select count(*) from channel";
				ResultSet Rs = tu.executeQuery(Sql);
				if (Rs.next()) {
					Tree2019.channel_number = Rs.getInt(1);
					Tree2019.inited = true;
				}
				tu.closeRs(Rs);						
			} catch (MessageException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return Tree2019.channel_number;
	}
	
	//用于内容中心中的频道结构展示
	public String listVideo_JS(UserInfo user) throws SQLException,MessageException {
		long a = System.currentTimeMillis();
		String JS = "";
		int ChannelNumber = 0;
		
		JS += "	var tree = new WebFXTree('','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');tree.setType('noroot');\r\n";
		
		/*
		String Sql = "select count(*) from channel";
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			ChannelNumber = Rs.getInt(1);
		}
		closeRs(Rs);
		*/
		
		ChannelNumber = Tree2019.getChannelNumber();
		
		Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
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
			
			Site site = child.getSite();
			if(site.getContentChannelID()==0) continue;
			
			Channel newch = CmsCache.getChannel(site.getContentChannelID());
			if (type == Channel.Site_Type && user.hasChannelShowRight(newch.getId())) {
				String varName = "lsh_" + channelid;
				String icon = getIcon(child);				
				if (child.hasChild(user) && ChannelNumber > 100 && type != Channel.Site_Type)
					JS += "var " + varName + " = new WebFXLoadTreeItem('"
							+ Util.JSQuote(channelname)
							+ "','../channel/channel_xml.jsp?id=" + channelid
							+ "','javascript:show(" + channelid
							+ ");\\\" ChannelID=" + channelid
							+ " ChannelType=\\\"" + type + "'" + icon
							+ ");\r\n";
				else
					JS += "var " + varName + " = new WebFXTreeItem('"
							+ Util.JSQuote(channelname) + "','javascript:show("
							+ newch.getId() + ");\\\" ChannelID=" + newch.getId()
							+ " ChannelType=\\\"" + type + "'" + icon
							+ ");\r\n";

				JS += "tree.add(" + varName + ");\r\n";

				if (type == Channel.Site_Type || ChannelNumber <= 100)
					JS += listChannel_JS(newch.getId(), varName, user,ChannelNumber);
			}
		}
		}
		
		//System.out.println("内容中心:" + (System.currentTimeMillis()-a) + "毫秒");
		return JS;
	}
	
	//显示频道管理中的频道导航
	public String listChannel_JS(UserInfo user) throws SQLException,MessageException {
		//long a = System.currentTimeMillis();
		String JS = "";
		int ChannelNumber = 0;
    
		String Sql = "";
		ResultSet Rs;

		JS += "	var tree = new WebFXTree('','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');\r\n";

		/*
		Sql = "select count(*) from channel";
		Rs = executeQuery(Sql);
		if (Rs.next()) {
			ChannelNumber = Rs.getInt(1);
		}
		closeRs(Rs);
		*/
		
		ChannelNumber = Tree2019.getChannelNumber();
		
		Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getAllChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
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
			
			if (type == Channel.Site_Type || user.hasChannelShowRight(channelid)) {
				String varName = "lsh_" + channelid;
				String icon = getIcon(child);
				
				JS += "var " + varName + " = new WebFXTreeItem('"	+ Util.JSQuote(channelname) + "','javascript:show("
							+ channelid + ");\\\" ChannelID=" + channelid + " ChannelType=\\\"" + type + "'" + icon
							+ ");\r\n";

				JS += "tree.add(" + varName + ");\r\n";

				JS += listChannel_JS(channelid, varName, user,ChannelNumber);
			}
		}
		}
		//long b = System.currentTimeMillis();
		//System.out.println("listChannel_JS:" + (b-a) + "毫秒");
		return JS;
	}
	
	
	public JSONArray listChannel_json(UserInfo user) throws SQLException,MessageException, JSONException {
		//long a = System.currentTimeMillis();
		JSONArray array = new JSONArray();

		int ChannelNumber = 0;
		ChannelNumber = Tree2019.getChannelNumber();
		Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getAllChildChannelIDs();

		if (childs!=null && childs.size()>0) {
			ArrayList channels_ = new ArrayList();
			for(int i = 0;i<childs.size();i++) {
				JSONObject o = new JSONObject();

				int channelid = (Integer) childs.get(i);
				//out_.println("child:"+channelid+"<br>");
				Channel child = CmsCache.getChannel(channelid);
				channels_.add(child);
			}

			ArrayList channels = UserInfoUtil.hasChannelShowRight(channels_,user);

			for(int i = 0;i<channels.size();i++){
				JSONObject o = new JSONObject();
				Channel child = (Channel)channels.get(i);
				int channelid = child.getId();
				
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

				//if (user.hasChannelShowRight(channelid)) {//type == Channel.Site_Type ||
					String varName = "lsh_" + channelid;
					String icon = getIcon(child);

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);

					JSONArray oo = listChannel_json(channelid, varName, user, ChannelNumber);
					o.put("child", oo);

					array.put(o);
				//}
			}
		}
		//long b = System.currentTimeMillis();
		//System.out.println("listChannel_JS:" + (b-a) + "毫秒");
		return array;
	}

	//用于资源中心中的频道结构展示
	public String listSource_JS(UserInfo user) throws SQLException,MessageException {
		String JS = "";
		int cloud_channelid = CmsCache.getParameter("sys_cloud_channelid").getIntValue();//云资源对应的频道编号
		
		JS += "	var tree = new WebFXTree('','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');tree.setType('noroot');\r\n";
		
		Channel ch = CmsCache.getChannel(-1);
		Channel source_ch = null;
		ArrayList<Integer> childs = ch.getChildChannelIDs();
		for(int i = 0;i<childs.size();i++){
			int channelid = (Integer)childs.get(i);
			Channel child = CmsCache.getChannel(channelid);
			if(child.getType2()==Channel.Source_Channel_Type2) source_ch = child;
		}
		
		if(source_ch==null) return "";
		
		childs = source_ch.getChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
				int channelid = (Integer)childs.get(i);
				Channel child = CmsCache.getChannel(channelid);
				int type = child.getType();
				String channelname = child.getName();
				String varName = "lsh_" + channelid;
				String icon = getIcon(child);
				
				if(child.getIsShowDraftNumber()==1)
				{
					int num = child.getNumber(0);
					if(num>0)
						channelname = channelname + " (" + num + ")";
				}
				
				//System.out.println("channelname:"+channelname);
				if(child.getId()==cloud_channelid)
				{
					String p = CmsCache.getParameterValue("sys_cloud_source");//云资源中心地址
					//System.out.println("p:"+p);

					if(p.length()>0)
					{
						
						
						JS += "var " + varName + " = new WebFXLoadTreeItem('"
								+ Util.JSQuote(channelname)
								+ "','../source/tree_api2.jsp','javascript:show(" + channelid
								+ ");\\\" ChannelID=" + channelid
								+ " ChannelType=\\\"" + type + "'" + icon
								+ ");\r\n";
						JS += "tree.add(" + varName + ");\r\n";
					}
				}
				else
				{
					JS += "var " + varName + " = new WebFXTreeItem('"
							+ Util.JSQuote(channelname) + "','javascript:show("
							+ channelid + ");\\\" ChannelID=" + channelid
							+ " ChannelType=\\\"" + type + "'" + icon
							+ ");\r\n";
					JS += "tree.add(" + varName + ");\r\n";
					JS += listChannel_JS(channelid, varName, user,0);
				}							
		}
		}
		return JS;
	}

	public String listChannel_JS_xml(int id, UserInfo user)	throws SQLException, MessageException {
		String JS = "<tree>";

		Channel ch = CmsCache.getChannel(id);
		ArrayList<Integer> childs = ch.getAllChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
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
					// String varName = "lsh_" + channelid;
					String icon = "";
					icon = getIconForXML(child);
					
					if(child.getType2()==Channel.ChannelSpecial)
						icon = getIconForXMLByType2(child.getType2());

					if (child.hasChild(user)) {
						JS += "<tree text=\"" + Util.XMLQuote(channelname)
						+ "\" src=\"../channel/channel_xml.jsp?id="
						+ channelid + "\" action=\"javascript:show("
						+ channelid + ");&quot; ChannelID=" + channelid
						+ " ChannelType=&quot;" + type + "\"" + icon
						+ " />\r\n";
					} else
						JS += "<tree text=\"" + Util.XMLQuote(channelname)
						+ "\" action=\"javascript:show(" + channelid
						+ ");&quot; ChannelID=" + channelid
						+ " ChannelType=&quot;" + type + "\"" + icon
						+ " />\r\n";
				}
			}
		}

		JS += "</tree>";
		//System.out.println(JS);
		return JS;
	}
	
	//类似于listChannel_JS_xml，全部返回
	public String listChannel_JS_xml2(int id, UserInfo user)	throws SQLException, MessageException {
		String JS = "<tree>";

		Channel ch = CmsCache.getChannel(id);
		ArrayList<Integer> childs = ch.getAllChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
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
					// String varName = "lsh_" + channelid;
					String icon = "";
					icon = getIconForXML(child);
					
					if(child.getType2()==Channel.ChannelSpecial)
						icon = getIconForXMLByType2(child.getType2());

					if (child.hasChild(user)) {
						JS += "<tree text=\"" + Util.XMLQuote(channelname)
						+ "\" src=\"../channel/channel_xml.jsp?id="
						+ channelid + "\" action=\"javascript:show("
						+ channelid + ");&quot; ChannelID=" + channelid
						+ " ChannelType=&quot;" + type + "\"" + icon
						+ " />\r\n";
					} else
						JS += "<tree text=\"" + Util.XMLQuote(channelname)
						+ "\" action=\"javascript:show(" + channelid
						+ ");&quot; ChannelID=" + channelid
						+ " ChannelType=&quot;" + type + "\"" + icon
						+ " />\r\n";
				}
			}
		}

		JS += "</tree>";
		//System.out.println(JS);
		return JS;
	}
	
	//网页管理的频道结构树
	public String listChannel_content_JS(UserInfo user) throws SQLException,MessageException {
		String JS = "";
		long a = System.currentTimeMillis();
		int ChannelNumber = 0;

		JS += "	var tree = new WebFXTree('','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');\r\n";

		/*
		Sql = "select count(*) from channel";
		Rs = executeQuery(Sql);
		if (Rs.next()) {
			ChannelNumber = Rs.getInt(1);
		}
		closeRs(Rs);
		*/
		ChannelNumber = Tree2019.getChannelNumber();

		Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
				int channelid = (Integer)childs.get(i);
				Channel child = CmsCache.getChannel(channelid);
				int type = child.getType();
				String channelname = child.getName();
				
				if(child.getIsShowDraftNumber()==1)
				{
					int num =child.getNumber(0);
					if(num>0)
						channelname = channelname + " (" + num + ")";
				}
			
			if (type == Channel.Site_Type && user.hasChannelShowRight(channelid)) {
				String varName = "lsh_" + channelid;
				String icon = "";
				icon = getIcon(child);

				JS += "var " + varName + " = new WebFXTreeItem('" + Util.JSQuote(channelname) + "','javascript:show("
							+ channelid + ");\\\" ChannelID=" + channelid + " ChannelType=\\\"" + type + "'" + icon
							+ ");\r\n";

				JS += "tree.add(" + varName + ");\r\n";

				if (type == Channel.Site_Type || ChannelNumber <= 100)
					JS += listChannel_content_JS(channelid, varName, user,ChannelNumber);
			}
		}}
		//System.out.println("listChannel_JS:" + (System.currentTimeMillis()-a) + "毫秒");
		return JS;
	}
	
	//网页管理的频道结构树
	public String listChannel_content_JS(int id, String s, UserInfo user,int channelnum) throws SQLException, MessageException {
		String JS = "";
		int cloud_channelid = CmsCache.getParameter("sys_cloud_channelid").getIntValue();//云资源对应的频道编号
		Channel ch = CmsCache.getChannel(id);
		ArrayList<Integer> childs = ch.getChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
				int channelid = (Integer)childs.get(i);
				Channel child = CmsCache.getChannel(channelid);
				
				if(child.getType2()==Channel.Content_Channel_Type2) continue;
				
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
					icon = getIcon(child);
					
					if(child.getType2()==Channel.ChannelSpecial)
						icon = getIconByType2(child.getType2());
					
					if(child.hasChild(user) && channelnum > 100)
					{
						JS += "var " + varName + " = new WebFXLoadTreeItem('"
								+ Util.JSQuote(channelname)
								+ "','../channel/channel_xml.jsp?id=" + channelid
								+ "','javascript:show(" + channelid
								+ ");\\\" ChannelID=" + channelid
								+ " ChannelType=\\\"" + type + "'" + icon
								+ ");\r\n";
						JS += s + ".add(" + varName + ");\r\n";
					}
					else
					{
						if(child.getId()==cloud_channelid)
						{
							String p = CmsCache.getParameterValue("sys_cloud_source");//云资源中心地址
							//System.out.println("p:"+p);

							if(p.length()>0)
							{																
								JS += "var " + varName + " = new WebFXLoadTreeItem('"
										+ Util.JSQuote(channelname)
										+ "','../source/tree_api2.jsp','javascript:show(" + channelid
										+ ");\\\" ChannelID=" + channelid
										+ " ChannelType=\\\"" + type + "'" + icon
										+ ");\r\n";
								JS += "tree.add(" + varName + ");\r\n";
							}
						}
						else
						{
								JS += "var " + varName + " = new WebFXTreeItem('"
										+ Util.JSQuote(channelname) + "','javascript:show("
										+ channelid + ");\\\" ChannelID=" + channelid
										+ " ChannelType=\\\"" + type + "'" + icon
										+ ");\r\n";
								JS += s + ".add(" + varName + ");\r\n";
						}
					}
					
					if (channelnum <= 100)
					JS += listChannel_JS(channelid, varName, user,0);
					
				}
			}
		}
		return JS;
	}
	//频道管理中
	public String listChannel_JS(int id, String s, UserInfo user,int channelnum) throws SQLException, MessageException {
		//long a = System.currentTimeMillis();
		String JS = "";
		//StringBuffer js = new StringBuffer(); 
		Channel ch = CmsCache.getChannel(id);
		ArrayList<Integer> childs = ch.getAllChildChannelIDs();

		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
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
				
				//System.out.println("user:"+user.getId()+",channel:"+channelid+",result:"+user.hasChannelShowRight(channelid)+",channelnum:"+channelnum);
				if (user.hasChannelShowRight(channelid)) {
					String varName = "lsh_" + channelid;
					String icon = "";
					icon = getIcon(child);
					
					if(child.getType2()==Channel.ChannelSpecial)
						icon = getIconByType2(child.getType2());

					if(channelnum > 100 && child.hasChild(user))
					{
						JS += "var " + varName + " = new WebFXLoadTreeItem('"
								+ Util.JSQuote(channelname)
								+ "','../channel/channel_xml.jsp?id=" + channelid
								+ "','javascript:show(" + channelid
								+ ");\\\" ChannelID=" + channelid
								+ " ChannelType=\\\"" + type + "'" + icon
								+ ");\r\n";
								
					}
					else
					{
						
					JS += "var " + varName + " = new WebFXTreeItem('"
							+ Util.JSQuote(channelname) + "','javascript:show("
							+ channelid + ");\\\" ChannelID=" + channelid
							+ " ChannelType=\\\"" + type + "'" + icon
							+ ");\r\n";
							
					}
					
					JS += s + ".add(" + varName + ");\r\n";
					
					if (channelnum <= 100)
					JS += listChannel_JS(channelid, varName, user,0);
				}
			} //while (Rs.next());
		}

		//closeRs(Rs);

		//long b = System.currentTimeMillis();
		//System.out.print(" " + (b-a) + "(" + id + ") ");
		
		return JS;
	}

	//用于推荐
	public String listTreeByField(UserInfo user,int fieldid) throws SQLException,MessageException 
	{
		String JS = "";

		JS += "	var tree = new WebFXTree('推荐栏目','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');\r\n";
		
		Field field = new Field(fieldid);
		String s = field.getRecommendChannel();
		
		String[] options = Util.StringToArray(s, "\n");
		for (int i = 0; i < options.length; i++) {
			String o = options[i].replace("\r", "");
			
			Channel ch = CmsCache.getChannel(o);
			
			if(ch==null) break;
			
			int channelid = ch.getId();
			String varName = "lsh_" + channelid;
			
			String icon = getIcon(ch);
			
			JS += "var " + varName + " = new WebFXTreeItem('"
			+ Util.JSQuote(ch.getName()) + "','javascript:show("
			+ channelid + ");\\\" ChannelID=" + channelid
			+ " ChannelType=\\\"" + ch.getType() + "'" + icon
			+ ");\r\n";
			
			JS += "tree.add(" + varName + ");\r\n";
			
			JS += listChannel_JS(channelid, varName, user,0);
		}
		
		return JS;
	}
    public JSONArray listTreeByField_json(UserInfo user,int fieldid) throws SQLException,MessageException, JSONException
    {
        JSONArray array = new JSONArray();

        Field field = new Field(fieldid);
        String s = field.getRecommendChannel();

        String[] options = Util.StringToArray(s, "\n");
        for (int i = 0; i < options.length; i++) {
            JSONObject json = new JSONObject();

            String o = options[i].replace("\r", "");

            Channel ch = CmsCache.getChannel(o);

            if(ch==null) break;

            int channelid = ch.getId();
            String varName = "lsh_" + channelid;

            String icon = getIcon(ch);

            json.put("name", ch.getName());
            json.put("id", channelid);
            json.put("type", ch.getType());
            json.put("icon", icon);

            JSONArray oo = listChannel_json(channelid, varName, user,Tree2019.getChannelNumber());
            json.put("child", oo);

            array.put(json);
        }

        return array;
    }

    //用于推荐
	public String listTreeByChannelRecommend(UserInfo user,int channelID) throws SQLException,MessageException 
	{
		String JS = "";

		JS += "	var tree = new WebFXTree('推荐栏目','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');\r\n";
		
		Channel channel = CmsCache.getChannel(channelID);
		String s = channel.getAttribute1();
		
		String[] options = Util.StringToArray(s, "\n");
		for (int i = 0; i < options.length; i++) {
			String o = options[i].replace("\r", "");
			String o2 = "";
			int ii = o.indexOf("(");
			if(ii!=-1)
			{
				o2 = o.substring(ii);
				o = o.substring(0,ii);
			}
			
			Channel ch = CmsCache.getChannel(o);
			
			if(ch==null) break;
			
			int channelid = ch.getId();
			String varName = "lsh_" + channelid;
			
			String icon = "";
			if (ch.getType() == 0)// 频道
				icon = ",'','../images/tree/16_channel_icon.png','../images/tree/16_openchannel_icon.png'";
			else if (ch.getType() == 1)// 分类
				icon = ",'','../images/tree/16_channel_class_icon.png','../images/tree/16_openchannel_class_icon.png'";
			else if (ch.getType() == 2)// 页面
				icon = ",'','../images/tree/16_page_icon.png'";
			else if(ch.getType() == Channel.MirrorChannel_Type) //镜像频道
				icon = ",'','../images/tree/16_channel_mirror_icon.png','../images/tree/16_openchannel_mirror_icon.png'";

			
			JS += "var " + varName + " = new WebFXTreeItem('"
			+ Util.JSQuote(ch.getName()+o2) + "','javascript:show("
			+ channelid + ");\\\" ChannelID=" + channelid
			+ " ChannelType=\\\"" + ch.getType() + "'" + icon
			+ ");\r\n";
			
			JS += "tree.add(" + varName + ");\r\n";
			
			JS += listChannel_JS(channelid, varName, user,Tree2019.getChannelNumber());
		}
		
		return JS;
	}
    public JSONArray listTreeByChannelRecommend_json(UserInfo user,int channelID) throws SQLException,MessageException, JSONException
    {
        JSONArray array = new JSONArray();

        Channel channel = CmsCache.getChannel(channelID);
        String s = channel.getAttribute1();

        String[] options = Util.StringToArray(s, "\n");
        for (int i = 0; i < options.length; i++) {
            JSONObject json = new JSONObject();

            String o = options[i].replace("\r", "");
            String o2 = "";
            int ii = o.indexOf("(");
            if(ii!=-1)
            {
                o2 = o.substring(ii);
                o = o.substring(0,ii);
            }

            Channel ch = CmsCache.getChannel(o);

            if(ch==null) break;

            int channelid = ch.getId();
            String varName = "lsh_" + channelid;

            String icon = "";
            if (ch.getType() == 0)// 频道
                icon = ",'','../images/tree/16_channel_icon.png','../images/tree/16_openchannel_icon.png'";
            else if (ch.getType() == 1)// 分类
                icon = ",'','../images/tree/16_channel_class_icon.png','../images/tree/16_openchannel_class_icon.png'";
            else if (ch.getType() == 2)// 页面
                icon = ",'','../images/tree/16_page_icon.png'";
            else if(ch.getType() == Channel.MirrorChannel_Type) //镜像频道
                icon = ",'','../images/tree/16_channel_mirror_icon.png','../images/tree/16_openchannel_mirror_icon.png'";

            json.put("name", ch.getName()+o2);
            json.put("id", channelid);
            json.put("type", ch.getType());
            json.put("icon", icon);

            JSONArray oo = listChannel_json(channelid, varName, user,Tree2019.getChannelNumber());
            json.put("child", oo);

            array.put(json);
        }

        return array;
    }
	
	//用于荐出
	public String listTreeByChannelRecommendOut(UserInfo user,int channelID) throws SQLException,MessageException 
	{
		String JS = "";
		String siteids = ",";

		JS += "	var tree = new WebFXTree('引用栏目','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');\r\n";
		
		Channel channel = CmsCache.getChannel(channelID);
		String s = channel.getRecommendOut();
		//System.out.println(s);
		String[] options = Util.StringToArray(s, "\n");
		for (int i = 0; i < options.length; i++) {
			String o = options[i].replace("\r", "");
			Channel ch = CmsCache.getChannel(o);
			//System.out.println(ch.getName());
			if(ch==null) break;
			
			Channel sitech = CmsCache.getChannel("s"+ch.getSiteID());
			String rootvarName = "lsh_" + sitech.getId();
			
			if(!siteids.contains(","+sitech.getId()+","))
			{
				siteids += sitech.getId()+",";
				JS += "var " + rootvarName + " = new WebFXTreeItem('"
				+ Util.JSQuote(sitech.getName()) + "','javascript:show("
				+ sitech.getId() + ");\\\" ChannelID=" + sitech.getId()
				+ " ChannelType=\\\"" + sitech.getType() + "'" + getIcon(Channel.Site_Type)
				+ ");\r\n";
				
				JS += "tree.add(" + rootvarName + ");\r\n";
			}
			
			int channelid = ch.getId();
			String varName = "lsh_" + channelid;
			
			JS += "var " + varName + " = new WebFXTreeItem('"
			+ Util.JSQuote(ch.getName()) + "','javascript:show("
			+ channelid + ");\\\" ChannelID=" + channelid
			+ " ChannelType=\\\"" + ch.getType() + "'" + getIcon(ch)
			+ ");\r\n";
			
			JS += rootvarName + ".add(" + varName + ");\r\n";
			
			JS += listChannel_JS(channelid, varName, user,Tree2019.getChannelNumber());
		}
		
		return JS;
	}
	
	//推荐的时候显示频道结构
	public JSONArray listTreeByChannelRecommendOut_json(UserInfo user,int channelID) throws SQLException,MessageException, JSONException
	{
		//System.out.println("listTreeByChannelRecommendOut_json");
		JSONArray array = new JSONArray();
		String siteids = ",";

		Channel channel = CmsCache.getChannel(channelID);
		String s = channel.getRecommendOut();
		//System.out.println(s);
		String[] options = Util.StringToArray(s, "\n");

		ArrayList channels_ = new ArrayList();
		for (int i = 0; i < options.length; i++) {
			String o = options[i].replace("\r", "");
			Channel ch = CmsCache.getChannel(o);
			//System.out.println(ch.getName());
			if (ch == null) continue;
			channels_.add(ch);
		}

		ArrayList channels = UserInfoUtil.hasChannelShowRight(channels_,user);

		for (int i = 0; i < channels.size(); i++) {
			JSONObject json = new JSONObject();
			Channel ch = (Channel)channels.get(i);
			Channel sitech = CmsCache.getChannel("s"+ch.getSiteID());

			if(!siteids.contains(","+sitech.getId()+","))
			{
				siteids += sitech.getId()+",";

				json.put("name", sitech.getName());
				json.put("id", sitech.getId());
				json.put("type", sitech.getType());
				json.put("icon", getIcon(Channel.Site_Type));
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
				json_.put("name", ch.getName());
				json_.put("id", channelid);
				json_.put("type", ch.getType());
				json_.put("icon", getIcon(ch));
				JSONArray ooo = new JSONArray();
				if(o_site.has("child"))
				{
					JSONArray ooo_ = o_site.getJSONArray("child");
					if(ooo_!=null) ooo = ooo_;
				}

				int number = Tree2019.getChannelNumber();
				//System.out.println("recomment:"+ch.getName()+","+number);

				if(number > 100 && ch.hasChild(user))
				{
					json_.put("load", 1);
					json_.put("path", "../channel/channel_xml.jsp?id=" + channelid);
				}
				else {
					json_.put("load", 0);
					json_.put("path", "");
					JSONArray oo = listChannel_json(channelid, varName, user, number);
					json_.put("child", oo);
				}
				
				ooo.put(json_);

				//System.out.println(oo);
				o_site.put("child",ooo);
			}
		}

		return array;
	}
	
	//用于集合选择
	public String listTreeByGroupField(UserInfo user,int fieldid) throws SQLException,MessageException 
	{
		String JS = "";

		JS += "	var tree = new WebFXTree('推荐栏目','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');\r\n";
		
		Field field = new Field(fieldid);
		String s = field.getGroupChannel();
		
		String[] options = Util.StringToArray(s, "\n");
		for (int i = 0; i < options.length; i++) {
			String o = options[i].replace("\r", "");
			
			Channel ch = CmsCache.getChannel(o);
			
			if(ch==null) break;
			
			int channelid = ch.getId();
			String varName = "lsh_" + channelid;
			
			String icon = "";
			if (ch.getType() == 0)// 频道
				icon = ",'','../images/tree/16_channel_icon.png','../images/tree/16_openchannel_icon.png'";
			else if (ch.getType() == 1)// 分类
				icon = ",'','../images/tree/16_channel_class_icon.png','../images/tree/16_openchannel_class_icon.png'";
			else if (ch.getType() == 2)// 页面
				icon = ",'','../images/tree/16_page_icon.png'";
			else if(ch.getType() == Channel.MirrorChannel_Type) //镜像频道
				icon = ",'','../images/tree/16_channel_mirror_icon.png','../images/tree/16_openchannel_mirror_icon.png'";

			
			JS += "var " + varName + " = new WebFXTreeItem('"
			+ Util.JSQuote(ch.getName()) + "','javascript:show("
			+ channelid + ");\\\" ChannelID=" + channelid
			+ " ChannelType=\\\"" + ch.getType() + "'" + icon
			+ ");\r\n";
			
			JS += "tree.add(" + varName + ");\r\n";
			
			JS += listChannel_JS(channelid, varName, user,0);
		}
		
		return JS;
	}
	
	//用于子集合选择
	public String listTreeByGroupChildField(UserInfo user,int fieldid) throws SQLException,MessageException 
	{
		String JS = "";

		JS += "	var tree = new WebFXTree('推荐栏目','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');\r\n";
		
		Field field = new Field(fieldid);
		String s = field.getGroupChannel();
		
		String[] options = Util.StringToArray(s, "\n");
		for (int i = 0; i < options.length; i++) {
			String o = options[i].replace("\r", "");
			
			Channel ch = CmsCache.getChannel(o);
			
			if(ch==null) break;
			
			int channelid = ch.getId();
			String varName = "lsh_" + channelid;
			
			String icon = "";
			if (ch.getType() == 0)// 频道
				icon = ",'','../images/tree/16_channel_icon.png','../images/tree/16_openchannel_icon.png'";
			else if (ch.getType() == 1)// 分类
				icon = ",'','../images/tree/16_channel_class_icon.png','../images/tree/16_openchannel_class_icon.png'";
			else if (ch.getType() == 2)// 页面
				icon = ",'','../images/tree/16_page_icon.png'";
			else if(ch.getType() == Channel.MirrorChannel_Type) //镜像频道
				icon = ",'','../images/tree/16_channel_mirror_icon.png','../images/tree/16_openchannel_mirror_icon.png'";

			
			JS += "var " + varName + " = new WebFXTreeItem('"
			+ Util.JSQuote(ch.getName()) + "','javascript:show("
			+ channelid + ");\\\" ChannelID=" + channelid
			+ " ChannelType=\\\"" + ch.getType() + "'" + icon
			+ ");\r\n";
			
			JS += "tree.add(" + varName + ");\r\n";
			
			JS += listChannel_JS(channelid, varName, user,0);
		}
		
		return JS;
	}
	
	// 附加模版对应的文件树状列表
	public String listChannel_Publish_Files_JS(UserInfo user)
			throws SQLException, MessageException {
		String JS = "";
		int RootChannelID = 0;

		String Sql = "select * from channel where Parent=-1";
		ResultSet Rs = executeQuery(Sql);
		if (!Rs.next()) {
			closeRs(Rs);
			return "";
		} else {
			String RootChannelName = convertNull(Rs.getString("Name"));
			RootChannelID = Rs.getInt("id");

			JS += "	var tree = new WebFXTree('" + Util.JSQuote(RootChannelName)
					+ "','javascript:show1()\" ChannelID=\"0');\r\n";
			JS += "	tree.setBehavior('classic');\r\n";
		}

		closeRs(Rs);

		Sql = "select * from channel where Parent=" + RootChannelID
				+ " order by OrderNumber,id";
		Rs = executeQuery(Sql);
		while (Rs.next()) {
			int channelid = Rs.getInt("id");
			int type = Rs.getInt("Type");
			String channelname = convertNull(Rs.getString("Name"));

			String varName = "lsh_" + channelid;

			String path = "";
			if (type == 0)
				path = convertNull(Rs.getString("FullPath")) + "/";
			else if (type == 1) {
				Channel cate = CmsCache.getChannel(CmsCache.getChannel(
						channelid).getParentTableChannelID());
				// CmsCache.getChannel(CmsCache.getChannel(channelid).getParentTableChannel());
				path = cate.getFullPath() + "/";
				// path = cate.getFullPath() + "/" + cate.getIndexFile();
			}

			path = path.replace("//", "/");

			JS += "var " + varName + " = new WebFXTreeItem('"
					+ Util.JSQuote(channelname) + "','javascript:show1(\\'"
					+ Util.JSQuote(path) + "\\');\\\" ChannelID=" + channelid
					+ " ChannelType=\\\"" + type + "'"
					+ (type == 1 ? ",'','../images/save.gif'" : "") + ");\r\n";
			JS += "tree.add(" + varName + ");\r\n";

			JS += listChannel_Publish_Files_JS(channelid, varName, user);

			int m = 0;
			String sql = "select * from channel_template where Channel="
					+ channelid + " and TemplateType=3";
			ResultSet rs = executeQuery(sql);
			while (rs.next()) {
				String TargetName = convertNull(rs.getString("TargetName"));
				String varName_ = "lsh_" + channelid + "_" + (m++);
				JS += "var " + varName_ + " = new WebFXTreeItem('"
						+ Util.JSQuote(TargetName)
						+ "','javascript:show(this);\\\" ChannelID="
						+ channelid + " ChannelType=\\\"" + 3 + "'"
						+ (",'','../images/save.gif'") + ");\r\n";
				JS += varName + ".add(" + varName_ + ");\r\n";
			}
			closeRs(rs);
		}

		return JS;
	}

	// 附加模版对应的文件树状列表
	public String listChannel_Publish_Files_JS(int id, String s, UserInfo user)
			throws SQLException, MessageException {
		String JS = "";

		String Sql = "select * from channel where Parent=" + id
				+ " order by OrderNumber,id";
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			do {
				int channelid = Rs.getInt("id");
				int type = Rs.getInt("Type");
				String channelname = convertNull(Rs.getString("Name"));
				String varName = "lsh_" + channelid;

				String path = "";
				if (type == 0)
					path = convertNull(Rs.getString("FullPath")) + "/";
				else if (type == 1) {
					Channel cate = CmsCache.getChannel(CmsCache.getChannel(
							channelid).getParentTableChannelID());
					path = cate.getFullPath() + "/";
					// path = cate.getFullPath() + "/" + cate.getIndexFile();
				}

				path = path.replace("//", "/");

				JS += "var " + varName + " = new WebFXTreeItem('"
						+ Util.JSQuote(channelname) + "','javascript:show1(\\'"
						+ Util.JSQuote(path) + "\\');\\\" ChannelID="
						+ channelid + " ChannelType=\\\"" + type + "'"
						+ (type == 1 ? ",'','../images/save.gif'" : "")
						+ ");\r\n";
				JS += s + ".add(" + varName + ");\r\n";

				JS += listChannel_Publish_Files_JS(channelid, varName, user);

				int m = 0;
				String sql = "select * from channel_template where Channel="
						+ channelid + " and TemplateType=3";
				ResultSet rs = executeQuery(sql);
				while (rs.next()) {
					String TargetName = convertNull(rs.getString("TargetName"));
					String varName_ = "lsh_" + channelid + "_" + (m++);
					JS += "var " + varName_ + " = new WebFXTreeItem('"
							+ Util.JSQuote(TargetName)
							+ "','javascript:show(this);\\\" ChannelID="
							+ channelid + " ChannelType=\\\"" + 3 + "'"
							+ (",'','../images/save.gif'") + ");\r\n";
					JS += varName + ".add(" + varName_ + ");\r\n";
				}
				closeRs(rs);

			} while (Rs.next());
		}

		closeRs(Rs);

		return JS;
	}
	
	//直播频道tree
	public String listChannel_live_JS(int id, String s, UserInfo user,int channelnum) throws MessageException, SQLException {
		String JS = "";
		Channel ch = CmsCache.getChannel(id);
		ArrayList<Integer> childs = ch.getChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
				
				int channelid = (Integer)childs.get(i);
				Channel child = CmsCache.getChannel(channelid);
				if(child.getType2()==Channel.Content_Channel_Type2) continue;
				
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
					icon = getIcon(child);
					if(child.getType2()==Channel.ChannelSpecial)
						icon = getIconByType2(child.getType2());
					
					if(child.hasChild(user) && channelnum > 100)
					{
						
						JS += "var " + varName + " = new WebFXLoadTreeItem('"
								+ Util.JSQuote(channelname)
								+ "','../channel/channel_xml.jsp?id=" + channelid
								+ "','javascript:show(" + channelid
								+ ");\\\" ChannelID=" + channelid
								+ " ChannelType=\\\"" + type + "'" + icon
								+ ");\r\n";
					}
					else
					{
					JS += "var " + varName + " = new WebFXTreeItem('"
							+ Util.JSQuote(channelname) + "','javascript:show("
							+ channelid + ");\\\" ChannelID=" + channelid
							+ " ChannelType=\\\"" + type + "'" + icon
							+ ");\r\n";
					}
					JS += s + ".add(" + varName + ");\r\n";
					if (channelnum <= 100)
						JS += listChannel_JS(channelid, varName, user,0);
					//判断是否为节目单频道，动态输出其下的台的信息 14154：分台管理频道id
					//var lsh_14271 = new WebFXTreeItem('中央台','javascript:show(14271);\" ChannelID=14271 ChannelType=\"0','','../images/tree/16_channel_icon.png','../images/tree/16_openchannel_icon.png');
					//lsh_14254.add(lsh_14271);
					//修改播控的channelType=100，节目单的channeltype=101；
					if(channelid == 14275){
						int channelid_= 14284;//分台管理频道
						TableUtil tu  = new TableUtil();
						String sql = "select * from "+CmsCache.getChannel(channelid_).getTableName()+" where status=1";
						ResultSet rs = tu.executeQuery(sql);
						String title = "";
						int gid = 0;
						String varname2 = "";
						while(rs.next()){
							title = rs.getString("Title");
							gid = rs.getInt("GlobalID");
							varname2 = "lsh_" +gid;
							channelid = gid;
							channelname = title;
							JS += "var " + varname2 + " = new WebFXTreeItem('" + Util.JSQuote(channelname) + "','javascript:show("
							+ channelid + ");\\\" ChannelID=" + channelid + " ChannelType=\\\"" + 0 + "'" + icon
							+ ");\r\n";
							JS += varName+".add(" + varname2 + ");\r\n";
							//嵌套添加子集
							TableUtil tu2  = new TableUtil();
							//频道中查询电视台的子集
							String sql2 = "select * from "+CmsCache.getChannel(14286).getTableName()+" where Parent="+channelid+" and status=1";
							ResultSet rs2 = tu2.executeQuery(sql2);
							String title2 = "";
							int gid2 = 0;
							String varname22 = "";
							while(rs2.next()){
								title2 = rs2.getString("Title");
								gid2 = rs2.getInt("GlobalID");
								varname22 = "lsh_" +gid2;
								channelid = gid2;
								channelname = title2;
								JS += "var " + varname22 + " = new WebFXTreeItem('" + Util.JSQuote(channelname) 
								+ "','javascript:show("+ channelid + ",1);\\\" ChannelID=" 
								
								+ channelid + " ChannelType=\\\"" + 101 + "'" + icon
								+ ");\r\n";
								JS += varname2+".add(" + varname22 + ");\r\n";
								//嵌套添加子集
							}
							tu2.closeRs(rs2);
						}
						tu.closeRs(rs);
						
					}
				}
			}
		}
		return JS;
	}
	
	/**
	 * @info 获取广告投放频道
	 * @param channel
	 * @param user
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	public String listAdTree(int channel,UserInfo user) throws MessageException, SQLException
	{
		String siteids ="";
		Channel ch = CmsCache.getChannel(channel);
		//System.out.println(ch.getName());
	    String JS="var tree = new WebFXTree('引用栏目','javascript:show(-1)\" ChannelID=\"0');\r\n";
	    JS+= "tree.setBehavior('classic');\r\n";
		Channel sitech = CmsCache.getChannel("s"+ch.getSiteID());
		String rootvarName = "lsh_" + sitech.getId();
		
		if(!siteids.contains(","+sitech.getId()+","))
		{
			siteids += sitech.getId()+",";
			JS += "var " + rootvarName + " = new WebFXTreeItem('"
			+ Util.JSQuote(sitech.getName()) + "','javascript:show("
			+ sitech.getId() + ");\\\" ChannelID=" + sitech.getId()
			+ " ChannelType=\\\"" + sitech.getType() + "'" + getIcon(Channel.Site_Type)
			+ ");\r\n";
			
			JS += "tree.add(" + rootvarName + ");\r\n";
		}
		
		int channelid = ch.getId();
		String varName = "lsh_" + channelid;
		
		JS += "var " + varName + " = new WebFXTreeItem('"
		+ Util.JSQuote(ch.getName()) + "','javascript:show("
		+ channelid + ");\\\" ChannelID=" + channelid
		+ " ChannelType=\\\"" + ch.getType() + "'" + getIcon(ch)
		+ ");\r\n";
		
		JS += rootvarName + ".add(" + varName + ");\r\n";
		
		JS += listChannel_JS(channelid, varName, user,Tree2019.getChannelNumber());
	
		return JS;
	}
	
	public void Add() throws SQLException, MessageException {
		
	}

	public void Delete(int id) throws SQLException, MessageException {
		
	}

	public void Update() throws SQLException, MessageException {
		
	}

	public boolean canAdd() {
		return false;
	}

	public boolean canDelete() {
		return false;
	}

	public boolean canUpdate() {
		return false;
	}
	
	public String getIcon(int type)
	{
		String icon = "";

		if (type == 0)// 频道
			icon = ",'','../images/tree/16_channel_icon.png','../images/tree/16_openchannel_icon.png'";
		else if (type == 1)// 分类
			icon = ",'','../images/tree/16_channel_class_icon.png','../images/tree/16_openchannel_class_icon.png'";
		else if (type == 2)// 页面
			icon = ",'','../images/tree/16_page_icon.png'";
		else if(type == Channel.MirrorChannel_Type) //镜像频道
			icon = ",'','../images/tree/16_channel_mirror_icon.png','../images/tree/16_openchannel_mirror_icon.png'";
		else if(type == Channel.Site_Type) //站点
			icon = ",'','../images/tree/16_channel_site_icon.png','../images/tree/16_channel_site_icon.png'";
		
		
		return icon;
	}
	
	public String getIcon(Channel channel)
	{
		String icon = "";

		if(channel.getIcon().length()>0)
		{
			icon = ",'','../images/channel_icon/" + channel.getIcon() + "','../images/channel_icon/"+channel.getIcon()+"'";
		}
		else
		{
		int type = channel.getType();
		icon = getIcon(type);
		}
		
		return icon;
	}
	
	public String getIconForXML(Channel channel)
	{
		String icon = "";
		
		if(channel.getIcon().length()>0)
		{
			icon = " icon=\"../images/channel_icon/" + channel.getIcon() + "\" openIcon=\"../images/channel_icon/"+channel.getIcon()+"\"";
		}
		else
		{
		int type = channel.getType();
		if (type == 0)// 频道
			icon = " icon=\"../images/tree/16_channel_icon.png\" openIcon=\"../images/tree/16_openchannel_icon.png\"";
		else if (type == 1)// 分类
			icon = " icon=\"../images/tree/16_channel_class_icon.png\" openIcon=\"../images/tree/16_openchannel_class_icon.png\"";
		else if (type == 2)// 页面
			icon = " icon=\"../images/tree/16_page_icon.png\"";
		else if(type == Channel.MirrorChannel_Type) //镜像频道
			icon = " icon=\"../images/tree/16_channel_mirror_icon.png\" openIcon=\"../images/tree/16_openchannel_mirror_icon.png\"";
		}
		
		return icon;
	}
	
	public String getIconByType2(int type)
	{
		String icon = "";
		
		if (type == Channel.ChannelSpecial)// 专题频道
			icon = ",'','../images/tree/icon_16_special.png','../images/tree/icon_16_special.png'";

		return icon;
	}
	
	public String getIconForXMLByType2(int type)
	{
		String icon = "";
		if (type == Channel.ChannelSpecial)// 专题频道
			icon = " icon=\"../images/tree/icon_16_special.png\" openIcon=\"../images/tree/icon_16_special.png\"";
		
		return icon;
	}		
	
	//用于内容中心中的频道结构展示
	public JSONArray list_channel_content_json(UserInfo user) throws SQLException,MessageException, JSONException {
		long a = System.currentTimeMillis();
		String JS = "";
		int ChannelNumber = 0;
		JSONArray array = new JSONArray();
		JS += "	var tree = new WebFXTree('','javascript:show(-1)\" ChannelID=\"0');\r\n";
		JS += "	tree.setBehavior('classic');tree.setType('noroot');\r\n";
		
		ChannelNumber = Tree2019.getChannelNumber();
		
		Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getChildChannelIDs();
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
			
			Site site = child.getSite();
			if(site.getContentChannelID()==0) continue;
			
			Channel newch = CmsCache.getChannel(site.getContentChannelID());
			if (type == Channel.Site_Type && user.hasChannelShowRight(newch.getId())) {
				String varName = "lsh_" + channelid;
				String icon = getIcon(child);				
				if (child.hasChild(user) && ChannelNumber > 100 && type != Channel.Site_Type)
					JS += "var " + varName + " = new WebFXLoadTreeItem('"
							+ Util.JSQuote(channelname)
							+ "','../channel/channel_xml.jsp?id=" + channelid
							+ "','javascript:show(" + channelid
							+ ");\\\" ChannelID=" + channelid
							+ " ChannelType=\\\"" + type + "'" + icon
							+ ");\r\n";
				else
					JS += "var " + varName + " = new WebFXTreeItem('"
							+ Util.JSQuote(channelname) + "','javascript:show("
							+ newch.getId() + ");\\\" ChannelID=" + newch.getId()
							+ " ChannelType=\\\"" + type + "'" + icon
							+ ");\r\n";

				JS += "tree.add(" + varName + ");\r\n";
				o.put("name",channelname);
				o.put("id",channelid);
				o.put("type",type);
				o.put("icon",icon);	
				if (type == Channel.Site_Type || ChannelNumber <= 100)
				{
					JSONArray oo = listChannel_json(newch.getId(), varName, user,ChannelNumber);
					o.put("child",oo);
				}
				array.put(o);
			}
		}
		}
		//System.out.println("内容中心:" + (System.currentTimeMillis()-a) + "毫秒");
		return array;
	}

	//网页管理的频道结构树
	public JSONArray listChannel_content_json(UserInfo user) throws SQLException,MessageException, JSONException {
		JSONObject o = new JSONObject();
		JSONArray array = new JSONArray();
		int ChannelNumber = 0;

		ChannelNumber = Tree2019.getChannelNumber();

		Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
				int channelid = (Integer)childs.get(i);
				Channel child = CmsCache.getChannel(channelid);
				int type = child.getType();
				String channelname = child.getName();

				if(child.getIsShowDraftNumber()==1)
				{
					int num =child.getNumber(0);
					if(num>0)
						channelname = channelname + " (" + num + ")";
				}

				if (type == Channel.Site_Type && user.hasChannelShowRight(channelid)) {
					String varName = "lsh_" + channelid;
					String icon = "";
					icon = getIcon(child);

					JSONObject site = new JSONObject();
					site.put("name",channelname);
					site.put("id",channelid);
					site.put("type",type);
					site.put("icon",icon);

					if (type == Channel.Site_Type || ChannelNumber <= 100)
					{
						JSONArray oo = listChannel_content_json(channelid, varName, user,ChannelNumber);
						site.put("child",oo);
					}

					array.put(site);
				}
			}
		}
		return array;
	}
	//网页管理的频道结构树
	public JSONArray listChannel_content_json(int id, String s, UserInfo user,int channelnum) throws SQLException, MessageException, JSONException {
		JSONArray array = new JSONArray();

		int cloud_channelid = CmsCache.getParameter("sys_cloud_channelid").getIntValue();//云资源对应的频道编号
		Channel ch = CmsCache.getChannel(id);
		ArrayList<Integer> childs = ch.getChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
				JSONObject o = new JSONObject();

				int channelid = (Integer)childs.get(i);
				Channel child = CmsCache.getChannel(channelid);

				if(child.getType2()==Channel.Content_Channel_Type2) continue;

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
					icon = getIcon(child);

					if(child.getType2()==Channel.ChannelSpecial)
						icon = getIconByType2(child.getType2());

					if(child.hasChild(user) && channelnum > 100)
					{
						o.put("load", 1);
						o.put("path", "../channel/channel_xml.jsp?id="+channelid);
					}
					else
					{
						if(child.getId()==cloud_channelid)
						{
							String p = CmsCache.getParameterValue("sys_cloud_source");//云资源中心地址
							//System.out.println("p:"+p);

							if(p.length()>0)
							{
								o.put("cloud", 1);
								o.put("path", "../source/tree_api2.jsp");
							}
						}
						else
						{
							o.put("load", 0);
						}
					}
					o.put("name", channelname);
					o.put("type", type);
					o.put("icon", icon);
					o.put("id", channelid);

					if (channelnum <= 100) {
						JSONArray oo = listChannel_json(channelid, varName, user, 0);
						o.put("child", oo);
					}
					array.put(o);
				}
			}
		}
		return array;
	}
	
	
	
	//频道管理中
	public JSONArray listChannel_json(int id, String s, UserInfo user,int channelnum) throws SQLException, MessageException, JSONException {
		JSONArray array = new JSONArray();

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

			ArrayList channels = UserInfoUtil.hasChannelShowRight(channels_,user);

			for(int i = 0;i<channels.size();i++){
				JSONObject o = new JSONObject();
				Channel child = (Channel)channels.get(i);
				int channelid = child.getId();
								
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
					icon = getIcon(child);

					if(child.getType2()==Channel.ChannelSpecial)
						icon = getIconByType2(child.getType2());

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
					//if(user.getCompany()>0 && child.getCompany()>0 && user.getCompany()!=child.getCompany()){
					//	continue;
					//}

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);
					
					if (channelnum <= 100) {
						JSONArray oo = listChannel_json(channelid, varName, user, 0);
						o.put("child", oo);
					}
					array.put(o);
				//}
			}
		}
		return array;
	}
	
	
	//内容管理频道树(不包括导航不出现的)
	public JSONArray listChannel_json_display(UserInfo user) throws SQLException,MessageException, JSONException {
		//long a = System.currentTimeMillis();
		JSONArray array = new JSONArray();

		int ChannelNumber = 0;
		ChannelNumber = Tree2019.getChannelNumber();
		Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getChildChannelIDs();

		if (childs!=null && childs.size()>0) {
			ArrayList channels_ = new ArrayList();
			for(int i = 0;i<childs.size();i++) {
				JSONObject o = new JSONObject();

				int channelid = (Integer) childs.get(i);
				//out_.println("child:"+channelid+"<br>");
				Channel child = CmsCache.getChannel(channelid);
				channels_.add(child);
			}

			ArrayList channels = UserInfoUtil.hasChannelShowRight(channels_,user);

			for(int i = 0;i<channels.size();i++){
				JSONObject o = new JSONObject();
				Channel child = (Channel)channels.get(i);
				int channelid = child.getId();
				
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

				//if (user.hasChannelShowRight(channelid)) {//type == Channel.Site_Type ||
					String varName = "lsh_" + channelid;
					String icon = getIcon(child);

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);

					JSONArray oo = listChannel_json_display(channelid, varName, user, ChannelNumber);
					o.put("child", oo);

					array.put(o);
				//}
			}
		}
		//long b = System.currentTimeMillis();
		//System.out.println("listChannel_JS:" + (b-a) + "毫秒");
		return array;
	}
		//导航显示的频道
		public JSONArray listChannel_json_display(int id, String s, UserInfo user,int channelnum) throws SQLException, MessageException, JSONException {
			JSONArray array = new JSONArray();

			Channel ch = CmsCache.getChannel(id);

			ArrayList<Integer> childs = ch.getChildChannelIDs();

			if (childs!=null && childs.size()>0) {

				ArrayList channels_ = new ArrayList();
				for(int i = 0;i<childs.size();i++) {
					JSONObject o = new JSONObject();

					int channelid = (Integer) childs.get(i);
					Channel child = CmsCache.getChannel(channelid);
					channels_.add(child);
				}

				ArrayList channels = UserInfoUtil.hasChannelShowRight(channels_,user);

				for(int i = 0;i<channels.size();i++){
					JSONObject o = new JSONObject();
					Channel child = (Channel)channels.get(i);
					int channelid = child.getId();
									
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
						icon = getIcon(child);

						if(child.getType2()==Channel.ChannelSpecial)
							icon = getIconByType2(child.getType2());

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
						//if(user.getCompany()>0 && child.getCompany()>0 && user.getCompany()!=child.getCompany()){
						//	continue;
						//}

						o.put("name", channelname);
						o.put("id", channelid);
						o.put("type", type);
						o.put("icon", icon);
						
						if (channelnum <= 100) {
							JSONArray oo = listChannel_json_display(channelid, varName, user, 0);
							o.put("child", oo);
						}
						array.put(o);
					//}
				}
			}
			return array;
		}
	//获取租户频道
	//20190505 可以删除
	public int getChannelID__(int parent,UserInfo user) throws MessageException, SQLException{
		
		int id = 0 ;
		Channel ch = CmsCache.getChannel(parent);
		ArrayList<Integer> childs = ch.getAllChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
				int channelid = (Integer)childs.get(i);
				Channel child = CmsCache.getChannel(channelid);
				if(user.getCompany()==child.getCompany()){
					id = channelid ;
				}				
			}
		}
		
		return id ;
	}
	
	//一稿多发推荐的时候显示频道结构
		public JSONArray listTreeByChannelRecommendOut_json1(UserInfo user,int channelID,int RelationchannelType) throws SQLException,MessageException, JSONException
		{
			JSONArray array = new JSONArray();
			String Sql = "select * from channel_recommend where ChannelID=" + channelID + " and RelationchannelType=" + RelationchannelType+" and Type=1";
			ResultSet Rs = executeQuery(Sql);
			ArrayList<Integer> list = new ArrayList<Integer>();
			while(Rs.next()) {
				//int RelationID =Rs.getInt("RelationID");
				list.add(Rs.getInt("RelationID"));
			}
			closeRs(Rs);
			for (int i = 0; i < list.size(); i++) {
				int id = list.get(i);//推荐频道的id
				Channel ch = CmsCache.getChannel(id);
				//System.out.println(ch.getName());
				if(ch==null) continue;
				//没有权限
				if(!user.hasChannelShowRight(ch.getId())) 
				{
					//System.out.println("userid:"+user.getUsername()+",no perm channel:"+ch.getId()+","+ch.getName());
					continue;
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
				
				//是租户用户,是租户频道,但不是同一租户（如：vms音视频媒资下的临时租户频道）
				if(user.getCompany()>0 && ch.getCompany()>0 && user.getCompany()!=ch.getCompany()){
					continue;
				}
				
				String varName = "lsh_" + channelid;
		
				JSONObject json_ = new JSONObject();
				json_.put("name", ch.getName());
				json_.put("id", channelid);
				json_.put("type", ch.getType());
				json_.put("icon", getIcon(ch));

				int number = Tree.getChannelNumber();

				if(number > 100 && ch.hasChild(user))
				{
					json_.put("load", 1);
					json_.put("path", "../channel/channel_xml.jsp?id=" + channelid);
				}
				else {
					json_.put("load", 0);
					json_.put("path", "");
					JSONArray oo = listChannel_json(channelid, varName, user, number);
					json_.put("child", oo);
				}
				array.put(json_);
			}

			return array;
		}
}
