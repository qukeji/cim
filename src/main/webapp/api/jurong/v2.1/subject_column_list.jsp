 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%
//审核栏目接口
%>
<%!
 public HashMap<String, Object> getList(UserInfo userinfo){
	HashMap<String, Object> map = new HashMap<String, Object>() ;

	try{

		TableUtil tu = new TableUtil();
		String sql = "";

		int userid = userinfo.getId();//当前登录用户id
		int task_channelid = 14271 ;//选题频道编号
		int parent = task_channelid ;
		
		sql = "select * from channel where parent="+parent+" order by id asc";
		System.out.println(sql);
		ResultSet rs1 = tu.executeQuery(sql);
		JSONArray arr = new JSONArray();
		while(rs1.next()){
			JSONObject o = new JSONObject();
			int id = rs1.getInt("id");
			//验证用户权限
			Channel channel = CmsCache.getChannel(id);
			Boolean isShow = channel.hasRight(userinfo,1);
			if(isShow){
				o.put("id",id);
				o.put("name",convertNull(rs1.getString("Name")));
				o.put("num",getNumber(id));
				arr.put(o);
			}
		}
		tu.closeRs(rs1);
		
		map.put("result",arr);
		map.put("status",200);
		map.put("message","成功");
		
	}catch(Exception e){
		map.put("status",500);
		map.put("message","程序异常");
		e.printStackTrace();
	} 
	return map ;
}

//指定频道编号
public int getNumber(int channelid) throws MessageException, SQLException
{
	int num = 0;
	Channel channel = CmsCache.getChannel(channelid);
	if(channel.getType()!=0 && channel.getType()!=1) return 0;
	
	String Sql = "select count(*) from " + channel.getTableName() + " where Active!=0";
	if(channel.getType()==1)
		Sql += " and Category=" + channelid;
	else
        Sql += " and Category=0";

	TableUtil tu = new TableUtil();
	ResultSet rs = tu.executeQuery(Sql);
	if (rs.next())
		num = rs.getInt(1);
	tu.closeRs(rs);
	
	return num;
}
%>
<%
	JSONObject json = new JSONObject();


	HashMap<String, Object> map = getList(userinfo_session);
	json = new JSONObject(map);
	out.println(json);

%>
