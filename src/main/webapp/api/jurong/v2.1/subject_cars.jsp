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
//预约车辆/设备列表
%>
<%!
//获取车辆编号
 public int getChannel(UserInfo userinfo,int type){
	int parent = 0 ;
	try{	
		TableUtil tu = new TableUtil();
		String sql = "";
		int userid = userinfo.getId();//当前登录用户id
		int task_channelid = 14348;
		if(type==2) task_channelid =14351;//频道编号
		parent=task_channelid;
	}catch(Exception e){
		e.printStackTrace();
	} 
	return parent ;
}
%>
<%
	JSONObject json = new JSONObject();

	int type = getIntParameter(request,"type");//类型 1车辆2设备
	int pages = getIntParameter(request,"page");//页码
	int pagesize = getIntParameter(request,"page_size");
	if(pages<1) pages = 1;
	if(pagesize<=0) pagesize = 20;
	int channelId = 0;//车辆/设备频道编号
	try {
		JSONArray jsonArr = new JSONArray();
		int num = 0 ;

		channelId = getChannel(userinfo_session,type);

		if(channelId==0){

			json.put("status",501);
			json.put("message","请检查频道是否存在");

		}else{

			Channel channel = CmsCache.getChannel(channelId);
			String sql = "select id,Title,state from " + channel.getTableName()+" where Active=1";
			String sql_count = "select count(*) from " + channel.getTableName()+" where Active=1";
			sql += " and Category=0" ;
			sql_count += " and Category=0" ;
			sql += " order by id desc" ;
			TableUtil tu = channel.getTableUtil();
			ResultSet rs = tu.List(sql,sql_count,pages,pagesize);
			num = tu.pagecontrol.getRowsCount();

			while(rs.next()){
				int id_ = rs.getInt("id");
				String Title = convertNull(rs.getString("Title"));
				int state = rs.getInt("state");
				String state_ = "可用";
				if(state==1){
					state_ = "不可用";
				}
				JSONObject o = new JSONObject();
				o.put("id",id_);
				o.put("name",Title);
				o.put("state",state_);
				jsonArr.put(o);

			}
			tu.closeRs(rs);
		}
		
		json.put("result",jsonArr);
		json.put("num",num);
		out.print(json);

	}catch (Exception e) {
        json.put("code","500");
        json.put("message","异常:"+e.toString());
        out.print(json);
        e.printStackTrace();
    }
%>
