<%@ page contentType="text/html;charset=utf-8" %>
<%!
//获取审核环节(操作信息，操作时间，是否审核中，是否最后一人审核，是否最后一步审核，当前待审核人，当前待审核人编号，当前审核环节编号，是否通过)
public String getHtml(String result,String time,int next,int end,int endStep,String userNames,String userIds,int approveId,int action){
	
	String html = "";
	html += "<div class=\"mg-y-5 sh-item d-flex justify-content-between align-items-center\">";
	html += "<p class=\"mg-b-0 tx-inverse tx-lato\">";
	html += result;
	html += "</p>";
	html += "<p class=\"mg-b-0 tx-sm\">"+time+"</p>";
	html += "</div>";

	if(!userNames.equals("")){
		html += "<div class=\"bg-gray-300 pd-x-10 pd-y-5 mg-y-5 tx-gray-700\">"+userNames+"</div>";
	}
	if(next==1){
		html += "<textarea id=\"approve\" class=\"form-control ht-100 mg-t-10\" cols=\"5\"  placeholder=\"请输入驳回理由，驳回到提交审核环节。如审核通过则不需要输入\" user=\""+userIds+"\" end=\""+end+"\" approveId=\""+approveId+"\"></textarea>";
	}
	if(endStep!=1&&end!=1&&action!=1){
		html += "<div class=\"mg-y-8 pd-l-20 tx-14\"><i class=\"fa fa-ellipsis-v\"></i> </div>";
	}

	return html ;
}
//获取用户名
public org.json.JSONObject getUserNames(String[] users,int endActionId,int gid,int approveId) throws tidemedia.cms.base.MessageException,java.sql.SQLException,org.json.JSONException{
	
	org.json.JSONObject json = new org.json.JSONObject();

	String userNames = "";
	String userIds = "";
	int size = 0 ;
	for(int i=0;i<users.length;i++){
	    int userId = 0;
	    if(users[i]!=""){
	        userId = Integer.parseInt(users[i]);
        }
		if(isApprove(userId,endActionId,gid,approveId)){
			continue;
		}

		if(!userNames.equals("")){
			userNames += "、";
		}
		userNames += tidemedia.cms.system.CmsCache.getUser(userId).getName();
		if(!userIds.equals("")){
			userIds += ",";
		}
		userIds += userId;
		size++ ;
	}

	json.put("userNames",userNames);
	json.put("userIds",userIds);
	json.put("size",size);

	return json ;
}
//判断用户是否已审核通过
public boolean isApprove(int userid,int endActionId,int gid,int approveId) throws tidemedia.cms.base.MessageException,java.sql.SQLException{
	
	boolean flag = false ;

	String sql = "select * from approve_actions where parent="+gid+" and id>"+endActionId+" and userid="+userid+" and ApproveId="+approveId;
	tidemedia.cms.base.TableUtil tu = new tidemedia.cms.base.TableUtil();
	java.sql.ResultSet rs = tu.executeQuery(sql);
	if(rs.next()){
		flag = true ;
	}
	tu.closeRs(rs);

	return flag;
}
//获取最后一次驳回操作编号
public int getAction(int gid)throws tidemedia.cms.base.MessageException,java.sql.SQLException{
	int actionId = 0;

	String sql = "select id from approve_actions where parent="+gid+" and endApprove=1 order by id asc";
	tidemedia.cms.base.TableUtil tu = new tidemedia.cms.base.TableUtil();
	java.sql.ResultSet rs = tu.executeQuery(sql);
	if(rs.next()){
		actionId = rs.getInt("id") ;
	}
	tu.closeRs(rs);

	return actionId ;
}
//获取等待时长
public String getTime(String date){
	String time_ = "";
	Long start = 0l;
	Long now = 0l;
	if(date!=""){
	    start = Long.parseLong(tidemedia.cms.util.Util.parseDate(date))/1000;
	    now =  System.currentTimeMillis()/1000;
	}
	int time = (int)(now-start);
	time_ = formatDuration(time);
	return time_ ;
}
//格式化时长，
public static String formatDuration(int duration) {
	String times = "";

	String sec = "";
	String minute = "";
	String hour = "";

	int min = 0;
	int gsm = 0;

	if ((duration / 60) % 60 > 0) {
		min = (duration / 60) % 60;// 分
	}
	if ((duration / 60 / 60) % 60 > 0) {
		gsm = (duration / 60 / 60) % 60;// 小时
	}

	if(gsm>0) times += gsm+"小时";

	times += min+"分钟";

	return times;
}
%>
