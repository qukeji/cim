package tidemedia.cms.system;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.Util;

public class ChannelRecommend extends Table  implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int id;
	private int ChannelID;
	private int RelationID;// 关系频道id:推荐频道id/引用频道id
	private int FieldRelation;//频道关系  0-默认关系  1-自定义关系
	private int RelationchannelType;// 关系频道类型：0-网站 1-APP 2-两微 3-三方媒体 4-电视端 5-其他
	private int Type;// 操作：1-推荐 2-引用
	private String Relationship;// 对应关系
	private String CreateDate = "";
	private int ActionUser;//userinfo_session

	public ChannelRecommend() throws MessageException, SQLException {
		super();
	}

	public ChannelRecommend(int id) throws SQLException, MessageException {
		String Sql = "";

		Sql = "select * from channel_recommend where id=" + id;
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(Sql);
		if (Rs.next()) {
			setId(Rs.getInt("id"));
			setChannelID(Rs.getInt("ChannelID"));
			setRelationID(Rs.getInt("RelationID"));
			setFieldRelation(Rs.getInt("FieldRelation"));
			setRelationchannelType(Rs.getInt("RelationchannelType"));
			setType(Rs.getInt("Type"));
			setRelationship(convertNull(Rs.getString("Relationship")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));
			tu.closeRs(Rs);
		} else {
			tu.closeRs(Rs);
		}
	}
	
	//原频道id，推荐到频道id，操作
	public ChannelRecommend(int ChannelID,int RelationID,int Type) throws SQLException, MessageException {
		String Sql = "";

		Sql = "select * from channel_recommend where ChannelID=" + ChannelID+" and RelationID="+RelationID+" and Type="+Type;
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(Sql);
		if (Rs.next()) {
			setId(Rs.getInt("id"));
			setChannelID(Rs.getInt("ChannelID"));
			setRelationID(Rs.getInt("RelationID"));
			setFieldRelation(Rs.getInt("FieldRelation"));
			setRelationchannelType(Rs.getInt("RelationchannelType"));
			setType(Rs.getInt("Type"));
			setRelationship(convertNull(Rs.getString("Relationship")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));
			tu.closeRs(Rs);
		} else {
			tu.closeRs(Rs);
		}
	}
	
	// 获取频道id获取当前推荐或者引用的列表 
	public List<ChannelRecommend> getChannelRecommendListByChannelId(int ChannelID, int Type)
			throws SQLException, MessageException {
		String serialNoAll = "";
		if(Type == 1){
			serialNoAll = getOutSerialNo(ChannelID);
		}else{
			serialNoAll = getInSerialNo(ChannelID);
		}
		TableUtil tu = new TableUtil();
		List<ChannelRecommend> list = new ArrayList<ChannelRecommend>();
		if(serialNoAll.length() > 0){
			String[] options = Util.StringToArray(serialNoAll, "\n");
			for (int i = 0; i < options.length; i++) {
				Channel channel1 = CmsCache.getChannel(options[i]);//options[i]站点id
				String Sql = "select * from channel_recommend where ChannelID=" + ChannelID + " and RelationID="+channel1.getId()+ " and Type=" + Type;
				System.out.println("sql getChannelRecommendListByChannelId="+Sql);
				ResultSet Rs = tu.executeQuery(Sql);
				while(Rs.next()) {
					ChannelRecommend cr = new ChannelRecommend();
					cr.setId(Rs.getInt("id"));
					cr.setChannelID(Rs.getInt("ChannelID"));
					cr.setRelationID(Rs.getInt("RelationID"));
					cr.setFieldRelation(Rs.getInt("FieldRelation"));
					cr.setRelationchannelType(Rs.getInt("RelationchannelType"));
					cr.setType(Rs.getInt("Type"));
					cr.setRelationship(convertNull(Rs.getString("Relationship")));
					cr.setCreateDate(convertNull(Rs.getString("CreateDate")));
					list.add(cr);
				}
				tu.closeRs(Rs);
			}
			return list;
		}else{//判断是否为继承频道 需要获取父频道在改表中的数据
			int isExtend  = 1;//0 是继承  1是不继承
			if(Type == 1){//推荐
				isExtend =  ChannelUtil.getFieldValueType(ChannelID,"RecommendOut");
				if(isExtend == 0){//继承查询
					int parentChannelid = queryAloneChannelRecommendOut(ChannelID);//查询独立关系的父频道
					if(parentChannelid != 0){
						list = getChannelRecommendListByParentChannelId(parentChannelid,Type);
						return list;
					}
				}
			}else{//引用
				isExtend = ChannelUtil.getFieldValueType(ChannelID,"Attribute1");
				if(isExtend == 0){//继承,查询
					int parentChannelid = queryAloneChannelAttribute1(ChannelID);
					if(parentChannelid != 0){
						list = getChannelRecommendListByParentChannelId(parentChannelid,Type);
						return list;
					}
				}
			}
		}
		return list;
	}
	
	public List<ChannelRecommend> getChannelRecommendListByParentChannelId(int ChannelID,int Type) throws MessageException, SQLException{
		String serialNoAll = "";
		if(Type == 1){
			serialNoAll = getOutSerialNo(ChannelID);
		}else{
			serialNoAll = getInSerialNo(ChannelID);
		}
		TableUtil tu = new TableUtil();
		List<ChannelRecommend> list = new ArrayList<ChannelRecommend>();
		if(serialNoAll.length() > 0){
			String[] options = Util.StringToArray(serialNoAll, "\n");
			for (int i = 0; i < options.length; i++) {
				Channel channel1 = CmsCache.getChannel(options[i]);//options[i]站点id
				String Sql = "select * from channel_recommend where ChannelID=" + ChannelID + " and RelationID="+channel1.getId()+ " and Type=" + Type;
				ResultSet Rs = tu.executeQuery(Sql);
				while(Rs.next()) {
					ChannelRecommend cr = new ChannelRecommend();
					cr.setId(Rs.getInt("id"));
					cr.setChannelID(Rs.getInt("ChannelID"));
					cr.setRelationID(Rs.getInt("RelationID"));
					cr.setFieldRelation(Rs.getInt("FieldRelation"));
					cr.setRelationchannelType(Rs.getInt("RelationchannelType"));
					cr.setType(Rs.getInt("Type"));
					cr.setRelationship(convertNull(Rs.getString("Relationship")));
					cr.setCreateDate(convertNull(Rs.getString("CreateDate")));
					list.add(cr);
				}
				tu.closeRs(Rs);
			}
			return list;
		}
		return list;
	}
	
	//推荐 --查询独立关系的父频道
	public  int   queryAloneChannelRecommendOut(int channelid) throws MessageException, SQLException{
		Channel channel = CmsCache.getChannel(channelid);
		int parent = channel.getParent();
		if(parent == -1){//如果是站点,返回0
			return 0;
		}
		int isExtend = ChannelUtil.getFieldValueType(parent,"RecommendOut");
		if(isExtend == 0){//继承
			return queryAloneChannelRecommendOut(parent);
		}else{
			return parent;
		}
	}
	
	//推荐 --查询独立关系的父频道
	public  int   queryAloneChannelAttribute1(int channelid) throws MessageException, SQLException{
		Channel channel = CmsCache.getChannel(channelid);
		int parent = channel.getParent();
		if(parent == -1){//如果是站点,返回0
			return 0;
		}
		int isExtend = ChannelUtil.getFieldValueType(parent,"Attribute1");
		if(isExtend == 0){//继承
			return queryAloneChannelAttribute1(parent);
		}else{
			return parent;
		}
	}
	
	public  List<Integer> getRelationIdListByChannelId(int ChannelID, int RelationchannelType)
			throws SQLException, MessageException {

		String Sql = "select RelationID from channel_recommend where ChannelID=" + ChannelID + " and RelationchannelType=" + RelationchannelType;
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(Sql);
		List<Integer> list = new ArrayList<Integer>();
		while(Rs.next()) {
			list.add(Rs.getInt("RelationID"));
		}
		tu.closeRs(Rs);
		return list;
	}
	
	//应用到子频道 ChannelID--当前频道id(父频道id)   不管频道是否是继承关系都同步(覆盖)设置,并且修改子频道为独立关系
	public String ApplyToSubchannels(int ChannelID, int Type)
			throws SQLException, MessageException, JSONException{
			JSONObject json = new JSONObject();
			Channel channel = CmsCache.getChannel(ChannelID);
			ArrayList<Channel> listAllSubChannels = channel.listAllSubChannels();
			List<Integer> childChannelIDs = new ArrayList<Integer>();
			for (int i = 0; i < listAllSubChannels.size(); i++) {
				Channel channel1 = listAllSubChannels.get(i);
				childChannelIDs.add(channel1.getId());
			}
			if(childChannelIDs.isEmpty()) {
				json.put("status", "error");
				json.put("message", "应用失败,当前频道没有子频道");
				return json.toString();
			}

			List<ChannelRecommend> crlist = getChannelRecommendListByChannelId(ChannelID,Type);
			if(crlist.isEmpty()) {//如果为空,删除所有子频道内容 将子频道修改为独立频道
				for (Integer childChannelID : childChannelIDs) {
					DeleteByChannelID(childChannelID,Type);
					changeChannelAlone(childChannelID,Type);
				}
				json.put("status", "success");
				json.put("message", "应用成功");
				return json.toString();
			}
			boolean isSuccess = changeChildChannels(crlist,childChannelIDs,Type);
			if(isSuccess) {
				json.put("status", "success");
				json.put("message", "应用成功");
				return json.toString();
			}else {
				json.put("status", "error");
				json.put("message", "出错啦");
				return json.toString();
			}
	}
	
	public boolean changeChildChannels(List<ChannelRecommend> crlist,List<Integer> childChannelIDs,int Type) throws SQLException, MessageException {//pdid 父频道id childChannelIDs子频道ids
		
		for (Integer childChannelID : childChannelIDs) {
			DeleteByChannelID(childChannelID,Type);
			//将子频道修改为独立频道
			changeChannelAlone(childChannelID,Type);
			for (ChannelRecommend cr : crlist) {//复制父频道内容到子频道
				setChannelID(childChannelID);
				setRelationID(cr.getRelationID());
				setFieldRelation(cr.getFieldRelation());
				setRelationchannelType(cr.getRelationchannelType());
				setType(cr.getType());
				setRelationship(convertNull(cr.getRelationship()));
				setCreateDate(String.valueOf(new Date().getTime()));
				Add();
			}
			Channel channel = CmsCache.getChannel(ChannelID);
			ArrayList<Channel> listAllSubChannels = channel.listAllSubChannels();
			List<Integer> childChannelIDlist = new ArrayList<Integer>();
			for (int i = 0; i < listAllSubChannels.size(); i++) {
				Channel channel1 = listAllSubChannels.get(i);
				childChannelIDlist.add(channel1.getId());
			}
			if(childChannelIDlist.isEmpty()) {
				continue;
			}else {
				changeChildChannels(crlist,childChannelIDlist,Type);
			}
			
		}
		return true;
	}
	
	//继承上级处理  ---父频道推荐设置覆盖当前频道,并修改当前频道为继承关系,不允许进行其他操作
	public String changeChannelRelation(int ChannelID, int Type) throws SQLException, MessageException,JSONException {//频道关系：1-继承上级 2-独立关系
		JSONObject json = new JSONObject();
			Channel channel = CmsCache.getChannel(ChannelID);
			int parentid = channel.getParent();
			if(parentid == 0) {
				json.put("status", "error");
				json.put("message", "该频道是顶级频道,无法继承上级频道");
				return  json.toString();
			}
			DeleteByChannelID(ChannelID,Type);
			changeChannelextend(ChannelID,Type);//设置继承关系
			json.put("status", "success");
			json.put("message", "设置成功");
			return  json.toString();
	}
	
	//设置当前频道为独立频道
	public  void changeChannelAlone(int ChannelID,int Type) throws MessageException, SQLException {
		String sql = "";
		if(Type == 1) {//推荐
			sql += "update channel set RecommendOut ='' where id="+ ChannelID;
		}else {//引用
			sql += "update channel set Attribute1 ='' where id="+ ChannelID;
		}
		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);
		int siteID = CmsCache.getChannel(ChannelID).getSiteID();
		new Log().ChannelLog(LogAction.channel_edit, ChannelID, ActionUser,siteID);
		CmsCache.delChannel(ChannelID);
	}
	
	//设置当前频道为继承频道
	public  void changeChannelextend(int ChannelID,int Type) throws MessageException, SQLException {
		String sql = "";
		if(Type == 1) {//推荐
			sql += "update channel set RecommendOut ='***' where id="+ ChannelID;
		}else {//引用
			sql += "update channel set Attribute1 ='***' where id="+ ChannelID;
		}
		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);
		int siteID = CmsCache.getChannel(ChannelID).getSiteID();
		new Log().ChannelLog(LogAction.channel_edit, ChannelID, ActionUser,siteID);
		CmsCache.delChannel(ChannelID);
	}
		
	//获取推荐表所有推荐相关频道的站点标识 用\n分割
	public String getOutSerialNo(int id) throws MessageException, SQLException{
		String serialNoAll = "";
		String sql = "select * from channel_recommend where ChannelID ="+id+" and Type = 1 order by CreateDate desc";
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		List<Integer>  RelationIDList = new ArrayList<Integer>();
		while (rs.next()) {
			int RelationID = rs.getInt("RelationID");
			RelationIDList.add(RelationID);
		}
		tu.closeRs(rs);
		for (int i = 0; i < RelationIDList.size(); i++) {
			//Channel channel = CmsCache.getChannel(RelationIDList.get(i));
			String serialNo = new Channel().getSerialNo((int)RelationIDList.get(i));//引用频道频道标识
			if(i == RelationIDList.size()-1){
				serialNoAll += serialNo;
			}else{
				serialNoAll += serialNo+"\n";
			}
		}
		return  serialNoAll;
	}
	
	//获取推荐表所有引用相关频道的站点标识 用\n分割
	public String getInSerialNo(int id) throws MessageException, SQLException{
		String serialNoAll = "";
		String sql = "select * from channel_recommend where ChannelID ="+id+" and Type = 2  order by CreateDate desc";
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		List<Integer>  RelationIDList = new ArrayList<Integer>();
		while (rs.next()) {
			int RelationID = rs.getInt("RelationID");
			RelationIDList.add(RelationID);
		}
		tu.closeRs(rs);
		for (int i = 0; i < RelationIDList.size(); i++) {
			//Channel channel = CmsCache.getChannel(RelationIDList.get(i));
			String serialNo = new Channel().getSerialNo((int)RelationIDList.get(i));//引用频道频道标识
			if(i == RelationIDList.size()-1){
				serialNoAll += serialNo;
			}else{
				serialNoAll += serialNo+"\n";
			}
		}
		return  serialNoAll;
	}
	
	@Override
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		Sql = "insert into channel_recommend (";
		Sql += "ChannelID,RelationID,FieldRelation,RelationchannelType,Type,Relationship,CreateDate";
		Sql += ") values(";
		Sql += "" + ChannelID + "";
		Sql += "," + RelationID + "";
		if(StringUtils.isBlank(Relationship)) {//Relationship为空  默认关系  FieldRelation= 0
			Sql += ",0";
		}else {
			Sql += ",1";
		}
		Sql += "," + RelationchannelType + "";
		Sql += "," + Type + "";
		if(StringUtils.isBlank(Relationship)) {//Relationship为空  默认
			Relationship="Title=Title\n" + 
					"PublishDate=PublishDate\n" + 
					"Summary=Summary\n" + 
					"Photo=Photo\n" + 
					"Content=Content\n" + 
					"DocForm=DocForm\n" + 
					"IsPhotoNews=IsPhotoNews";
			Sql += ",'" + SQLQuote(Relationship) + "'";
		}else {//不为空  自定义 
			Sql += ",'" + SQLQuote(Relationship) + "'";
		}
		Sql += ",now()";

		Sql += ")";
		executeUpdate_InsertID(Sql);
		int siteID = CmsCache.getChannel(ChannelID).getSiteID();
		new Log().ChannelLog(LogAction.channel_edit, ChannelID, ActionUser,siteID);
		CmsCache.delChannel(ChannelID);
	}

	@Override
	public void Delete(int cid) throws SQLException, MessageException {

		String Sql = "";
		Sql = "delete from channel_recommend where id=" + cid;

		TableUtil tu = new TableUtil();
		tu.executeUpdate(Sql);
		int siteID = CmsCache.getChannel(ChannelID).getSiteID();
		new Log().ChannelLog(LogAction.channel_edit, ChannelID, ActionUser,siteID);
		CmsCache.delChannel(id);
	}
	
	//根据channelId删除
	public void DeleteByChannelID(int ChannelID,int Type) throws SQLException, MessageException {

		String Sql = "";
		Sql = "delete from channel_recommend where ChannelID=" + ChannelID +" and Type ="+Type;

		TableUtil tu = new TableUtil();
		tu.executeUpdate(Sql);
		int siteID = CmsCache.getChannel(ChannelID).getSiteID();
		new Log().ChannelLog(LogAction.channel_edit, ChannelID, ActionUser,siteID);
		CmsCache.delChannel(ChannelID);
	}
	
	public void UpdateChannelRecommend(int id,int RelationchannelType,String Relationship) throws SQLException, MessageException {
		String Sql = "";
		if(StringUtils.isBlank(Relationship)){
			Relationship="Title=Title\n" +
					"PublishDate=PublishDate\n" +
					"Summary=Summary\n" +
					"Photo=Photo\n" +
					"Content=Content\n" +
					"DocForm=DocForm\n" +
					"IsPhotoNews=IsPhotoNews";
			Sql = "update channel_recommend set RelationchannelType = "+RelationchannelType+",Relationship='"+SQLQuote(Relationship)+"',FieldRelation=0 where id=" + id;
		}else {
			Sql = "update channel_recommend set RelationchannelType = "+RelationchannelType+",Relationship='"+SQLQuote(Relationship)+"',FieldRelation=1 where id=" + id;
		}
		TableUtil tu = new TableUtil();
		tu.executeUpdate(Sql);
		int siteID = CmsCache.getChannel(ChannelID).getSiteID();
		new Log().ChannelLog(LogAction.channel_edit, ChannelID, ActionUser,siteID);
		CmsCache.delChannel(ChannelID);
	}
	
	public void addChannelRecommend(List<Integer> childChannelIDs,int RelationID,int Type,ChannelRecommend cr) throws Exception {//添加
		for(Integer childChanneladdID : childChannelIDs){
			int  addflag;
			Channel channeladd = CmsCache.getChannel(childChanneladdID);
			if(Type == 1){//推荐
			 	addflag = ChannelUtil.getFieldValueType(channeladd.getId(),"RecommendOut");
			}else{//引用
				addflag = ChannelUtil.getFieldValueType(channeladd.getId(),"Attribute1");
			}
			if(addflag == 0){//继承关系
				ChannelRecommend cr1=  new ChannelRecommend();
				cr1.setChannelID(childChanneladdID);
				cr1.setRelationID(cr.getRelationID());
				cr1.setRelationchannelType(cr.getRelationchannelType());
				cr1.setType(cr.getType());
				cr1.setRelationship(convertNull(cr.getRelationship()));
				cr1.setActionUser(cr.getActionUser());
				cr1.Add();
				ArrayList<Channel> listAllSubChannels = channeladd.listAllSubChannels();
				List<Integer> childChannelIDlist = new ArrayList<Integer>();
				for (int i = 0; i < listAllSubChannels.size(); i++) {
					Channel channel = listAllSubChannels.get(i);
					childChannelIDlist.add(channel.getId());
				}
				if(childChannelIDlist.isEmpty()) {
					continue;
				}else {
					addChannelRecommend(childChannelIDlist,RelationID,Type,cr);
				}
			}else{//独立关系
				continue;
			}
		}
	
	}
	
	
	@Override
	public boolean canAdd() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean canUpdate() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean canDelete() {
		// TODO Auto-generated method stub
		return false;
	}
	
	@Override
	public void Update() throws SQLException, MessageException {
		// TODO Auto-generated method stub
		
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getChannelID() {
		return ChannelID;
	}

	public void setChannelID(int channelID) {
		ChannelID = channelID;
	}

	public int getRelationID() {
		return RelationID;
	}

	public void setRelationID(int relationID) {
		RelationID = relationID;
	}

	public int getRelationchannelType() {
		return RelationchannelType;
	}
	
	public int getFieldRelation() {
		return FieldRelation;
	}

	public void setFieldRelation(int fieldRelation) {
		FieldRelation = fieldRelation;
	}

	public void setRelationchannelType(int relationchannelType) {
		RelationchannelType = relationchannelType;
	}

	public int getType() {
		return Type;
	}

	public void setType(int type) {
		Type = type;
	}

	public String getRelationship() {
		return Relationship;
	}

	public void setRelationship(String relationship) {
		Relationship = relationship;
	}

	public String getCreateDate() {
		return CreateDate;
	}

	public void setCreateDate(String string) {
		CreateDate = string;
	}

	public int getActionUser() {
		return ActionUser;
	}

	public void setActionUser(int actionUser) {
		ActionUser = actionUser;
	}

	public static String getAttribute2Relationship(int channelID, int relationID) throws MessageException, SQLException {
		String Relationship = "";
		String Relationship1="Title=Title\n" + 
				"PublishDate=PublishDate\n" + 
				"Summary=Summary\n" + 
				"Photo=Photo\n" + 
				"Content=Content\n" + 
				"DocForm=DocForm\n" + 
				"IsPhotoNews=IsPhotoNews";//默认值
		int FieldRelation = 0;
		String sql ="select * from channel_recommend where ChannelID = "+ channelID +" and RelationID ="+ relationID +" and Type = 2";
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next()){
			FieldRelation = rs.getInt("FieldRelation");
			Relationship = rs.getString("Relationship");
		}
		tu.closeRs(rs);
		if(FieldRelation == 0){//默认关系
			return Relationship1;
		}else{//自定义关系
			return Relationship;
		}
	}

	public static String getRecommendOutRelationship(int ChannelID, int relationID) throws MessageException, SQLException {

		//判断目标频道是否配置字段对应关系
		String sql ="select * from channel_recommend where ChannelID = "+ ChannelID +" and RelationID ="+ relationID +" and Type = 1";
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		String Relationship = "";
		int FieldRelation = 0;
		while(rs.next()){
			FieldRelation = rs.getInt("FieldRelation");//0：默认关系 1：自定义关系
			Relationship = rs.getString("Relationship");
		}
		tu.closeRs(rs);

		if(Relationship.equals("")){//说明未配置字段对应关系
			//判断目前频道是否是继承子频道
			Channel channel = CmsCache.getChannel(relationID);
			int type = channel.getType();
			if(type==1){//继承子频道,查父级的字段对应关系
				int parent = channel.getParent();
				return getRecommendOutRelationship(ChannelID,parent);
			}else{//默认值
				Relationship="Title=Title\n" +
							"PublishDate=PublishDate\n" +
							"Summary=Summary\n" +
							"Photo=Photo\n" +
							"Content=Content\n" +
							"DocForm=DocForm\n" +
							"IsPhotoNews=IsPhotoNews";
			}
		}

		return Relationship;
	}
	
	//查询当前登录用户绑定的微信公众号 weixin_account
	public JSONArray  findWeiXinAccount(int userId) throws MessageException, SQLException, JSONException {
		UserInfo userInfo = new UserInfo(userId);
		String username = userInfo.getUsername();
		JSONArray jsonArray = new JSONArray();
		String sql = "select * from weixin_account where USERNAME = '"+username+"'";
		ResultSet rs = executeQuery(sql);
		while(rs.next()){
			JSONObject jsonObject = new JSONObject();
			String id = rs.getString("id");
			String accountname = rs.getString("accountname");
			jsonObject.put("id", id);
			jsonObject.put("accountname", accountname);
			jsonArray.put(jsonObject);
		}
		closeRs(rs);
		return jsonArray;
	}

	//删除频道时删除channel_recommend表数据
	public static void deleteByChannel(int channelId) throws MessageException, SQLException {
		String sql = "delete from channel_recommend where ChannelID = "+channelId;
		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);
	}
}
