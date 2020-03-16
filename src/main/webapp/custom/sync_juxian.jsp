<%@ page import="java.sql.ResultSet,
 java.sql.SQLException,
 java.util.ArrayList,
 java.util.HashMap,
 org.json.JSONArray,
 org.json.JSONException,
 org.json.JSONObject,
 tidemedia.cms.base.MessageException,
 tidemedia.cms.base.TableUtil,
 tidemedia.cms.system.Channel,
 tidemedia.cms.system.CmsCache,
 tidemedia.cms.system.ItemUtil,
 tidemedia.cms.system.Log,
 tidemedia.cms.util.TideJson,
 tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
	public String ActivityUrl = "";// 聚现直播同步API地址
	public String VideoUrl = "";// 聚现视频同步API地址
	public String ColumnUrl = "";// 聚现栏目同步API地址
	public String TextImageUrl = "";// 聚现图文同步API地址
	public int juxian_activity = 3, juxian_video = 2, juxian_textimage = 1;

	// 判断表中是否存在某数据
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
	}

	/**
	 * 只是创建企业频道
	 * 
	 * @param title
	 * @param Companyid
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	public int CreateChannel(int SourceRootChannelID, String title,
			int Companyid) throws MessageException, SQLException {
		Channel p = CmsCache.getChannel(SourceRootChannelID);// 聚现资源根
		String content_url = p.getListProgram();
		String document_url = p.getDocumentProgram();
		String serialno = p.getAutoSerialNo();
		int ii = serialno.lastIndexOf("_");
		String foldername = serialno.substring(ii + 1);
		Channel channel = new Channel();
		channel.setName(title);
		channel.setParent(SourceRootChannelID);
		// channel.setFolderName(foldername );
		channel.setFolderName(foldername);
		channel.setImageFolderName(p.getImageFolderName());
		channel.setSerialNo(serialno);
		channel.setIsDisplay(p.getIsDisplay());
		channel.setIsWeight(p.getIsWeight());
		channel.setIsComment(p.getIsComment());
		channel.setIsClick(p.getIsClick());
		channel.setIsShowDraftNumber(p.getIsShowDraftNumber());
		channel.setType(1);
		channel.setHref(p.getHref());
		channel.setRecommendOut(p.getRecommendOut());
		channel.setRecommendOutRelation(p.getRecommendOutRelation());
		channel.setExtra1("");
		channel.setExtra2("{\"company\":" + Companyid + "}");
		channel.setListJS(p.getListJS());
		channel.setDocumentJS(p.getDocumentJS());
		channel.setListProgram(content_url);
		channel.setDocumentProgram(document_url);
		channel.setTemplateInherit(p.getTemplateInherit());
		channel.setActionUser(1);
		channel.Add();
		int thisChannelid = channel.getId();
		// session.removeAttribute("channel_tree_string");
		CmsCache.delChannel(thisChannelid);// 清理频道缓存
		return thisChannelid;
	}

	/**
	 * 获取全部企业Token
	 * 
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	public ArrayList<HashMap> getAllCompany(int CompanyChannelID)
			throws MessageException, SQLException {
		TableUtil tu = new TableUtil();
		String sql = "select * from "
				+ CmsCache.getChannel(CompanyChannelID).getTableName()
				+ " where status=1 and active=1";
		ResultSet rs = tu.executeQuery(sql);
		ArrayList<HashMap> Result = new ArrayList<HashMap>();
		while (rs.next()) {
			String title = rs.getString("title");
			String token = rs.getString("token");
			int companyid = rs.getInt("company_id");
			HashMap map = new HashMap();
			map.put("title", title);
			map.put("token", token);
			map.put("companyid", companyid);
			Result.add(map);
		}
		tu.closeRs(rs);
		return Result;
	}

	/**
	 * 图文资源同步接口
	 * 
	 * @param Token
	 * @param CompanyId
	 * @param Juxian_CompanyID
	 * @throws MessageException
	 * @throws SQLException
	 * @throws JSONException
	 */
	public void SyncTextImage(String Token, int CompanyId,
			int Juxian_CompanyID, String CompanyName) throws MessageException,
			SQLException, JSONException {
		if (Juxian_CompanyID == 0)
			return;
		String tableName = CmsCache.getChannel(CompanyId).getTableName();
		TableUtil tu = new TableUtil();
		int juxian_sourceid = 0;
		String sql = "select juxian_sourceid from " + tableName
				+ " where Active=1 and category=" + CompanyId
				+ " and juxian_type=" + juxian_textimage
				+ " order by juxian_sourceid desc";
		ResultSet rs = tu.executeQuery(sql);
		if (rs.next()) {
			juxian_sourceid = rs.getInt("juxian_sourceid");
		}
		tu.closeRs(rs);
		int lastjuxian_sourceid = juxian_sourceid;
		int page = 1;
		// http://console.juyun.tv/v1/columns?access_token=jx0a7b793ad625b961&page=1
		while (true) {
			String column_path = ColumnUrl + "?type=3&access_token=" + Token
					+ "&page=" + page;
			String result = Util.postHttpUrl(column_path, "");
			JSONObject resultObject = new JSONObject(result);
			JSONArray ColumnArray = resultObject.getJSONArray("result");// 获取全部栏目
			for (int i = 0; i < ColumnArray.length(); i++) {
				JSONObject ColumnObj = ColumnArray.getJSONObject(i);
				int Columnid = ColumnObj.getInt("id");
				while (true) {
					String textimage_path = TextImageUrl + "?access_token="
							+ Token + "&column_id=" + Columnid + "&id="
							+ lastjuxian_sourceid + "&type=1";
					String resultphoto = Util.postHttpUrl(textimage_path, "");
					JSONObject TextImageObject = new JSONObject(resultphoto);
					int company_id = TextImageObject.getInt("company_id");
					if (TextImageObject.getInt("code") == 200) {
						JSONArray TextImageArray = TextImageObject
								.getJSONArray("result");
						for (int l = 0; l < TextImageArray.length(); l++) {
							JSONObject CurrentImage = TextImageArray
									.getJSONObject(l);
							String summary = CurrentImage.getString("desc");
							String title = CurrentImage.getString("title");
							String photo = CurrentImage.getString("photo");
							String user = CurrentImage.getString("user");
							String content = CurrentImage.getString("content");
							String location = CurrentImage
									.getString("position");
							int id = CurrentImage.getInt("id");
							String sql1 = "select id from " + tableName
									+ " where category=" + CompanyId
									+ " and Active=1 and juxian_sourceid=" + id
									+ " and juxian_type=" + juxian_textimage
									+ " ";
							if (exists(sql1) == 0) {
								HashMap map = new HashMap();
								map.put("Title", title);
								map.put("Summary", summary);
								map.put("Photo", photo);
								map.put("juxian_user", user);
								map.put("Content", content);
								map.put("juxian_sourceid", id + "");
								map.put("DocFrom", CompanyName + "");
								map.put("juxian_companyid", company_id + "");
								map.put("juxian_type", juxian_textimage + "");
								map.put("IsPhotoNews", 0 + "");
								map.put("Title", title);
								map.put("doc_type", 0 + "");

								ItemUtil.addItemGetGlobalID(CompanyId, map);
								if (id > lastjuxian_sourceid) {// 时刻保持
																// lastjuxian_liveid
																// 为最后一条直播数据
									lastjuxian_sourceid = id;
								}

							}
						}
						if (TextImageArray.length() < 10) {
							break;
						}
					} else {
						Log.SystemLog("聚现同步视频资源失败",
								TextImageObject.getString("message"));
					}
				}
			}

			page++;
			if (ColumnArray.length() < 10) {
				break;
			}
		}

	}

	public void Init() throws MessageException, SQLException {
		// SourceChannelID=CmsCache.getParameter("sync_juxian_config").getJson().getInt("sourcechannel");

		TideJson json = CmsCache.getParameter("sync_juxian_live").getJson();
		ActivityUrl = json.getString("url");// 聚现直播列表接口
		VideoUrl = json.getString("videourl");
		ColumnUrl = json.getString("columnurl");
		TextImageUrl = json.getString("textimageurl");

	}

	/**
	 * 同步直播活动资源
	 * 
	 * @param Token
	 * @param CompanyId
	 * @throws MessageException
	 * @throws SQLException
	 * @throws JSONException
	 */
	public void SyncActivityLive(String Token, int CompanyId,
			int Juxian_CompanyID, String CompanyName) throws MessageException,
			SQLException, JSONException {
		if (Juxian_CompanyID == 0)
			return;
		String tableName = CmsCache.getChannel(CompanyId).getTableName();
		TableUtil tu = new TableUtil();
		int juxian_liveid = 0;
		String sql = "select juxian_liveid from " + tableName
				+ " where Active=1 and category=" + CompanyId
				+ " order by juxian_liveid desc";
		ResultSet rs = tu.executeQuery(sql);
		if (rs.next()) {
			juxian_liveid = rs.getInt("juxian_liveid");
		}
		tu.closeRs(rs);
		int page_ = 1;
		while (true) {
			// 获取聚现直播列表
			String url_path = ActivityUrl + "?access_token=" + Token + "&id="
					+ Juxian_CompanyID + "&page=" + page_;
			System.out.println(url_path + "<br>");
			String result = Util.connectHttpUrl(url_path);
			JSONObject json_result = new JSONObject(result);
			if (json_result.getInt("code") == 200) {// 请求接口成功
				int company_id = json_result.getInt("company_id");
				JSONArray arr = json_result.getJSONArray("result");
				for (int i = 0; i < arr.length(); i++) {
					JSONObject json_live = (JSONObject) arr.get(i);
					int id = json_live.getInt("id");// 活动编号
					String sql1 = "select id from " + tableName
							+ " where category=" + CompanyId
							+ " and Active=1 and juxian_liveid=" + id;
					if (exists(sql1) == 0) {// 说明以获取过此活动
						int start = json_live.getInt("start");// 开始时间
						int end = json_live.getInt("end");// 结束时间
						String title = json_live.getString("title");// 直播名称
						String photo = json_live.getString("photo");// 封面图
						String url = json_live.getString("url");// 分享地址
						String user = json_live.getString("user");// 创建者
						int payaction = json_live.getInt("pay");// 0 正常活动 1:付费
																// 2：口令
						// String column = json_live.getString("column");//栏目
						// String pc_url =
						// json_live.getString("pc_url");//pc页面地址
						// String app_url =
						// json_live.getString("app_url");//app页面地址

						HashMap<String, String> log_ = new HashMap<String, String>();
						log_.put("Title", title);
						log_.put("Photo", photo);
						log_.put("live_shareurl", url);
						log_.put("juxian_user", user);
						log_.put("juxian_liveid", id + "");
						log_.put("juxian_type", juxian_activity + "");
						log_.put("IsPhotoNews", 0 + "");
						log_.put("start", start + "");
						log_.put("end", end + "");
						log_.put("doc_type", 4 + "");
						log_.put("item_type", 2 + "");
						log_.put("DocFrom", CompanyName + "");
						log_.put("payaction", payaction + "");
						log_.put("juxian_companyid", company_id + "");
						ItemUtil.addItemGetGlobalID(CompanyId, log_);
					}
					// out.println(log_+"<br>");
				}
				if (arr.length() < 10) {
					break;
				}
			} else {
				Log.SystemLog("同步聚现活动失败",
						"错误信息:  " + json_result.getString("message"));
				break;
			}
			page_++;
		}
	}

	/**
	 * 同步聚现视频资源
	 * 
	 * @param Token
	 * @param CompanyId
	 * @param Juxian_CompanyID
	 * @throws MessageException
	 * @throws SQLException
	 * @throws JSONException
	 */
	public void SyncVideo(String Token, int CompanyId, int Juxian_CompanyID,
			String CompanyName) throws MessageException, SQLException,
			JSONException {
		if (Juxian_CompanyID == 0)
			return;
		String tableName = CmsCache.getChannel(CompanyId).getTableName();
		TableUtil tu = new TableUtil();
		int juxian_sourceid = 0;
		String sql = "select juxian_sourceid from " + tableName
				+ " where Active=1 and category=" + CompanyId
				+ " and juxian_type=" + juxian_video
				+ " order by juxian_sourceid desc";
		ResultSet rs = tu.executeQuery(sql);
		if (rs.next()) {
			juxian_sourceid = rs.getInt("juxian_sourceid");
		}
		tu.closeRs(rs);
		int lastjuxian_sourceid = juxian_sourceid;
		int page = 1;
		// http://console.juyun.tv/v1/columns?access_token=jx0a7b793ad625b961&page=1
		while (true) {
			String column_path = ColumnUrl + "?access_token=" + Token
					+ "&page=" + page;
			String result = Util.postHttpUrl(column_path, "");
			JSONObject resultObject = new JSONObject(result);
			JSONArray ColumnArray = resultObject.getJSONArray("result");// 获取全部栏目
			for (int i = 0; i < ColumnArray.length(); i++) {
				JSONObject ColumnObj = ColumnArray.getJSONObject(i);
				int Columnid = ColumnObj.getInt("id");
				while (true) {
					String video_path = VideoUrl + "?access_token=" + Token
							+ "&column_id=" + Columnid + "&id="
							+ lastjuxian_sourceid + "&type=1";
					String resultVideo = Util.postHttpUrl(video_path, "");
					JSONObject videoObject = new JSONObject(resultVideo);
					if (videoObject.getInt("code") == 200) {
						int company_id = videoObject.getInt("company_id");
						JSONArray VideoArray = videoObject
								.getJSONArray("result");
						for (int l = 0; l < VideoArray.length(); l++) {
							JSONObject CurrentVideo = VideoArray
									.getJSONObject(l);
							String summary = CurrentVideo.getString("desc");
							String title = CurrentVideo.getString("title");
							String photo = CurrentVideo.getString("photo");
							String user = CurrentVideo.getString("user");
							String videourl = CurrentVideo.getString("url");
							String location = CurrentVideo
									.getString("position");
							int id = CurrentVideo.getInt("id");
							String sql1 = "select id from " + tableName
									+ " where category=" + CompanyId
									+ " and Active=1 and juxian_sourceid=" + id
									+ " and juxian_type=" + juxian_video + " ";
							if (exists(sql1) == 0) {
								HashMap map = new HashMap();
								map.put("Title", title);
								map.put("Summary", summary);
								map.put("Photo", photo);
								map.put("juxian_user", user);
								map.put("videourl", videourl);
								map.put("IsPhotoNews", 0 + "");
								map.put("juxian_sourceid", id + "");
								map.put("juxian_type", juxian_video + "");
								map.put("juxian_companyid", company_id + "");
								map.put("Title", title);
								map.put("doc_type", 1 + "");
								map.put("DocFrom", CompanyName + "");
								if (videourl != null && !videourl.equals("")) {
									ItemUtil.addItemGetGlobalID(CompanyId, map);
								}
								if (id > lastjuxian_sourceid) {// 时刻保持
																// lastjuxian_liveid
																// 为最后一条直播数据
									lastjuxian_sourceid = id;
								}

							}
						}
						if (VideoArray.length() < 10) {
							break;
						}
					} else {
						Log.SystemLog("聚现同步视频资源失败",
								videoObject.getString("message"));
					}
				}
			}

			page++;
			if (ColumnArray.length() < 10) {
				break;
			}
		}

	}

	public void Execute() throws MessageException, SQLException, JSONException {
		Init();
		String siteinfo_txt = CmsCache.getParameterValue("sync_juxian_live");
		JSONObject siteinfoObj = new JSONObject(siteinfo_txt);
		JSONArray sitearray = siteinfoObj.getJSONArray("list");
		for (int i = 0; i < sitearray.length(); i++) {
			JSONObject siteobj = sitearray.getJSONObject(i);
			// String token=siteobj.getString("token");
			int siteid = siteobj.getInt("site");
			int SourceChannelID = exists("select * from channel where SerialNo='company_s"
					+ siteid + "_source'");// 获取企业资源库跟频道
			int CompanyChannelID = exists("select * from channel where SerialNo='company_s"
					+ siteid + "_info'");// 获取企业库频道编号
			ArrayList<HashMap> CompanyList = getAllCompany(CompanyChannelID);
			for (HashMap map : CompanyList) {
				String token = (String) map.get("token");
				String title = (String) map.get("title");
				int companyid = (Integer) map.get("companyid");
				int CurrentCompanyId = exists("select * from channel  where parent="
						+ SourceChannelID
						+ " and extra2 ='{\"company\":"
						+ companyid + "}' ");
				if (CurrentCompanyId == 0) {
					CurrentCompanyId = CreateChannel(SourceChannelID, title,
							companyid);// 建立企业频道
				}

				SyncActivityLive(token, CurrentCompanyId, companyid, title);
				SyncVideo(token, CurrentCompanyId, companyid, title);
				SyncTextImage(token, CurrentCompanyId, companyid, title);

			}

		}

	}
%>
<%
Execute();
%>
