<%@ page import="java.sql.ResultSet,
		java.sql.SQLException,
		java.util.ArrayList,
		java.util.List,
		org.json.JSONException,
		org.json.JSONObject,
		tidemedia.cms.system.*,
		tidemedia.cms.base.*,
		tidemedia.cms.util.*,
		tidemedia.cms.user.*,
		tidemedia.cms.app.*"%>

<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>

<%@ include file="common.jsp"%>

<%
	
	int id = getIntParameter(request,"id");		    //媒体号id
	int site = getIntParameter(request,"site");	    //客户端来源
	int pages = getIntParameter(request,"page");	//当前页
	JSONObject json1 = new JSONObject();
	if(id == 0){
	    json1.put("status", 0);
		json1.put("message", "请检查参数是否正确");
	    out.println(json1);
	    return;
	}
	
	if(pages == 0){
	    pages = 1;
	}

	int listnum = getIntParameter(request,"listnum");//每页数量

	//每页数量 默认20条
	if(listnum == 0){
		listnum = 20;
	}
	
	try{
		int channelID = (int)TIDE.get("cms_community_userwatch_channel");//从配置中获取channelID(好友关注记录)
		Channel channel = CmsCache.getChannel(channelID);
		String tableName = channel.getTableName();	//"好友关注记录" 表名
		List<Integer> userIdList = getUserId(tableName,id);


		int userChannelID = (int)TIDE.get("cms_register_channel");//从配置中获取channelID(注册用户信息)
		Channel channel1 = CmsCache.getChannel(userChannelID);
		String userTableName = channel1.getTableName();

		List list = getUsers(userTableName,userIdList,pages,listnum);
	
		JSONObject json = new JSONObject();
		json.put("count", list.size());
		json.put("list", list);

		json1.put("status", 1);
		json1.put("message", "成功");
		json1.put("result", json);
	}catch(Exception e){		
		json1.put("status", 0);
		json1.put("message", "操作失败");
		//json1.put("message", e.getMessage());
		//System.out.println("错误信息:" + e.getMessage());
	}
	
	out.println(json1);

%>

<%!

	/**
	 * @param tableName		好友关注记录表
	 * @param becompanyid	关注企业编号
	 * @return				
	 * @throws MessageException
	 * @throws SQLException
	 */
	public List<Integer> getUserId(String tableName,int becompanyid) throws MessageException, SQLException{
		TableUtil tu = new TableUtil();
		String sql = "select * from " + tableName + " where becompanyid = " + becompanyid;
		ResultSet rs = tu.executeQuery(sql);
		
		List<Integer> list = new ArrayList<Integer>();
		while(rs.next()){
			int userid = rs.getInt("userid");
			list.add(userid);
		}
		tu.closeRs(rs);
		return list;
	}

	/**
	 * 分页查询  注册用户信息
	 * @param tableName
	 * @param userIdList
	 * @param page
	 * @param listnum
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 * @throws JSONException
	 */
	public List getUsers(String tableName,List<Integer> userIdList,int page,int listnum) throws MessageException, SQLException, JSONException{
	    List list = new ArrayList();
		TableUtil tu = new TableUtil();
		String ListSql = "select * from " + tableName;
		String CountSql = "select count(*) from " + tableName;
		
		if(userIdList.size() == 0){
		    return list;
		}
		
		String sql = " where id in(";
		for (int i = 0; i < userIdList.size(); i++) {
			Integer userId = userIdList.get(i);
			if(i == 0){
				sql += "" + userId;
			}else{
				sql += "," + userId;
			}
		}
		sql += ") order by id desc ";
		ListSql += sql;
		CountSql += sql;
		ResultSet rs = tu.List(ListSql,CountSql,page,listnum);
		
		
		while(rs.next()){
			JSONObject json = new JSONObject();
			int id = rs.getInt("id");			//用户编号
			String avatar   = convertNull(rs.getString("avatar"));		//用户头像
			String username = convertNull(rs.getString("Title"));	    //用户昵称
			//String nickname = convertNull(rs.getString("nickname"));	//用户身份
			
			json.put("userid", id);
			json.put("avatar", avatar);
			json.put("username", username);
			list.add(json);
		}
		tu.closeRs(rs);
		return list;
	}


%>
