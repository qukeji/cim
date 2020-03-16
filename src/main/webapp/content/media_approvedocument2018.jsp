<%@ page
	import="tidemedia.cms.system.*,
				java.sql.*,
				java.util.*,
				tidemedia.cms.base.MessageException,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../config.jsp"%>

<%!// 判断表中是否存在某数据
	public static int exists(String sql) {
		int id = 0;
		try {
			TableUtil tu = new TableUtil();
			ResultSet rs = tu.executeQuery(sql);
			if (rs.next()) {// 数据存在，返回ID
				id = rs.getInt("id");
			}
			tu.closeRs(rs);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return id;
	}%>
<%
	//int parent_channelid =15913;
	int ChannelID = getIntParameter(request, "ChannelID");
	String ItemID = getParameter(request, "ItemID");//企业id
	//String title_channel = getParameter(request,"title_channel");//企业名
	int CategoryID = getIntParameter(request, "CategoryID");
	int currPage = getIntParameter(request, "currPage");
	int rowsPerPage = getIntParameter(request, "rowsPerPage");

	if (ChannelID != 0 && !ItemID.equals("")) {
		ChannelPrivilege cp = new ChannelPrivilege();
		if (cp.hasRight(userinfo_session, CategoryID > 0 ? CategoryID : ChannelID, 3)) {
			Document document = new Document();
			document.setUser(userinfo_session.getId());
			document.Approve(ItemID, ChannelID);
		}

		String url = "";
		if (CategoryID == 0) {
			url = "content2018.jsp?id=" + ChannelID;
		} else {
			url = "content2018.jsp?id=" + CategoryID;
		}
		url += "&currPage=" + currPage + "&rowsPerPage=" + rowsPerPage;

		int[] ItemID_ = Util.StringToIntArray(ItemID, ",");
		//String [] channelname=title_channel.split(",");

		//根据频道ID获取频道对象
		Channel channelWl1 = CmsCache.getChannel(ChannelID);
		//获取频道所属站点ID
		int siteId = channelWl1.getSiteID();
		//定义频道标识名
		String channel_SerialNo = "company_s" + siteId + "_source";

		for (int i = 0; i < ItemID_.length; i++) {
			Document doc = CmsCache.getDocument(ItemID_[i], ChannelID);
			int Type = doc.getIntValue("Type");
			int jushi_userid = doc.getIntValue("jushi_userid");
			int juxian_userid = doc.getIntValue("juxian_userid");
			int company_id = doc.getIntValue("company_id");

			if (Type == 0) {
				channel_SerialNo += "_personal";
			} else if (Type == 1) {
				channel_SerialNo += "_organiza";
			}
			String channelname = doc.getTitle();
			//根据频道标识名获取频道对象
			Channel channelWl2 = CmsCache.getChannel(channel_SerialNo);
			//获取频道ID
			int parent_channelid = channelWl2.getId();
			System.out.println("channelWl2=================" + channelWl2);
			Channel channel_parent = CmsCache.getChannel(parent_channelid);
			String recommendOut = channel_parent.getRecommendOut();
			String recommendOutRelation = channel_parent.getRecommendOutRelation();
			String documentProgram = channel_parent.getDocumentProgram();
			String documentJS = channel_parent.getDocumentJS();
			String serialno = CmsCache.getChannel(parent_channelid).getAutoSerialNo();
			//System.out.println("serialno标识号"+serialno);
			int index = serialno.lastIndexOf("_");
			String folder = "";
			if (index != -1) {
				folder = serialno.substring(index + 1);
			} else {
				folder = serialno;
			}
			String Extra2 = "{\"company\":" + ItemID_[i] + "}";
			String Extra2_ = "{\"company\":" + company_id + "}";
			String Extra2_1= "{\"user\":" + juxian_userid + "}";
			//判断频道是否存在
			int CurrentCompanyId = exists("select id from channel where parent=" + parent_channelid
					+ " and extra2 in ('" + Extra2 + "','" + Extra2_ + "','" + Extra2_1 + "')");
			if (CurrentCompanyId == 0) {//说明此企业未生成对应频道
				Channel channel = new Channel();
				channel.setName(channelname);
				channel.setTemplateInherit(1);
				channel.setIsDisplay(1);
				channel.setFolderName(folder);
				channel.setParent(parent_channelid);
				channel.setType(1);
				channel.setSerialNo(serialno);
				channel.setExtra2(Extra2);
				channel.setRecommendOut(recommendOut);
				channel.setRecommendOutRelation(recommendOutRelation);
				channel.setDocumentProgram(documentProgram);
				channel.setDocumentJS(documentJS);
				if (jushi_userid == 0) {
					if (Type == 0) {
						channel.setExtra2("{\"user\":" + juxian_userid + "}");
					} else if (Type == 1) {
						channel.setExtra2("{\"company\":" + company_id + "}");
					}
				}

				channel.Add();
				int thisChannelid = channel.getId();
				CmsCache.delChannel(thisChannelid); //清除频道缓存
				//频道列表地址
				String filePath = Util.ClearPath(channel.getFullPath() + "/list_1_0.shtml");
				TableUtil tu = new TableUtil();
				/*System.out.println("sql = "+"update " + CmsCache.getChannel(ChannelID).getTableName() + " set listurl='"
						+ tu.SQLQuote(filePath) + "',jushi_channelid="+thisChannelid+" where id=" + ItemID);*/
				//更新媒体号审核字段jushi_channelid
				tu.executeUpdate("update " + CmsCache.getChannel(ChannelID).getTableName() + " set listurl='"
						+ tu.SQLQuote(filePath) + "',jushi_channelid="+thisChannelid+" where id=" + ItemID);

				/*tu.executeUpdate("update " + CmsCache.getChannel(ChannelID).getTableName() + " set jushi_channelid="
						+ thisChannelid + " where id=" + ItemID);*/

			}
		}

		session.removeAttribute("channel_tree_string");
		response.sendRedirect(url);

	}
%>
