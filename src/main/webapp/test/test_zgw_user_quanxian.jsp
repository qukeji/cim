<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.text.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public static int rootid=18621;
public  int getChannelID2(String extraStr2) throws MessageException,
		SQLException {
	tidemedia.cms.system.Channel channel = CmsCache.getChannel(rootid);
	String sql = "select id from channel where ChannelCode like '"
	+ channel.getChannelCode() + "%' and Extra2 like '%"+extraStr2+"'";
	 System.out.println("getChannelID2.sql=" + sql);
	TableUtil tu = channel.getTableUtil();
	ResultSet rs = tu.executeQuery(sql);
	if (rs.next()) {
		int id = rs.getInt("id");
		tu.closeRs(rs);
		return id;
	} else {
		tu.closeRs(rs);
		return 0;
	}
}
%>
<%
TableUtil tu =  new TableUtil("zgwuser1225");
int lsj_groupid=12;
int cms_groupid=19;
String sql = "select * from mms_sso_user where groupid="+lsj_groupid;
ResultSet rs = tu.executeQuery(sql);
while(rs.next()){
	String username = rs.getString("username");
	String Summary= rs.getString("userinfo");
	String password= rs.getString("password");
	//password = StringUtils.getMD5(password);
	String usernick= rs.getString("usernick");
	int userid = rs.getInt("userid");
	out.println("userid="+userid+",username="+username+",password="+password+",usernick="+usernick);
	
	
	UserInfo userinfo = new UserInfo();
	userinfo.setName(usernick);
	userinfo.setUsername(username);
	userinfo.setPassword(password);
	//userinfo.setEmail(Email);
	//userinfo.setTel(Tel);
	userinfo.setComment(Summary);
	//userinfo.setExpireDate(ExpireDate);
	userinfo.setRole(2);//编辑
	userinfo.setGroup(cms_groupid);

	String ChannelList="";//用户频道 列表
	String PermList="";//频道权限列表
	int nodeid=0;// 老数据分类唯一id
	int cid=0;//通过 nodeid 查到的 channelid

	int canread=0;//读
	int canwrite=0;//创建、更新
	int candelete=0;//删除
	TableUtil tu2 = new TableUtil("zgw1225");//
	String sql2 = "select * from mms_ssouser_material_permisson where userid="+userid;
	//out.println("sql2="+sql2);
	ResultSet rs2 = tu2.executeQuery(sql2);
	while (rs2.next()){


		nodeid=rs2.getInt("nodeid");
		String extra2 = "nodeid:"+nodeid+"}";
		canread=rs2.getInt("canread");
		canwrite=rs2.getInt("canwrite");
		candelete=rs2.getInt("candelete");
		
		cid=getChannelID2(extra2);
		//out.println("extra2="+extra2+",cid="+cid+"</br>");
		if(cid>0){
			ChannelList+=","+cid;
			PermList+=","+cid+",1,"+canread+","+canwrite+","+canwrite+","+candelete;
		}
	}
	
	//out.println(ChannelList);
	out.println("ChannelList="+ChannelList);
	out.println("PermList="+PermList);

	tu2.closeRs(rs2);

	userinfo.setChannelList(ChannelList);
	userinfo.setPermList(PermList);
	userinfo.Add();
}
tu.closeRs(rs);
	/*UserGroup group = new UserGroup();
	group.setName("TESTS");
	group.setParent(0);
	group.Add();*/
%>