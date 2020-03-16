<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,java.sql.*,org.json.*,tidemedia.cms.base.*,tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%@ include file="approve_config.jsp"%>
<%
/**
* 用途：获取稿件审核结果
*/
int gid = getIntParameter(request,"globalid");
int id = CmsCache.getDocument(gid).getId();

String sql = "select * from approve_actions where parent="+gid+" order by id desc";
TableUtil tu = new TableUtil();
ResultSet rs = tu.executeQuery(sql);

String result = "";
int actionId = 0 ;
String userIds = "";
int end = 0;
int approveId = 0;
int type = 0 ;
String ApproveName = "";
int action	= 0;
while(rs.next()){
	actionId = rs.getInt("id");
	action	= rs.getInt("Action");//是否通过
	end = rs.getInt("endApprove");
	int userid = rs.getInt("userid");
	String UserName	= CmsCache.getUser(userid).getName();
	String CreateDate = convertNull(rs.getString("CreateDate"));
	CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",CreateDate);
	approveId = rs.getInt("ApproveId");//审核环节id

	result += "<p><em class=\"tx-info\">"+UserName+" </em>于 "+CreateDate;
	if(approveId==0){
		result += " <em class=\"tx-orange\">提交审核</em></p>";
		userIds = "";
	}else{
		ApproveItems ai = new ApproveItems(approveId);
		int step = ai.getStep();
		type = ai.getType();
		userIds = ai.getUsers();
		JSONObject json = ai.getApproveName(0);
		ApproveName = (String)json.get("ApproveName");
		result += " <em class=\"tx-orange\">"+convertNull(rs.getString("ApproveName"));
		
		if(action==1){
			result += "驳回</em>";
		}else{
			result += "通过</em>";
		}

		/*if(end==1){//终审
			result += "</p>";
			break ;
		}*/
			
	}
}
tu.closeRs(rs);

if(!result.equals("")){		

	if(!userIds.equals("")&&action==0&&end==0){
		String[] users = userIds.split(",");
		JSONObject json = getUserNames(users,end,gid,approveId);
		int size = json.getInt("size");
		if(type==1&&size>0){//并签要判断其他人是否审核通过
			result += " 等待其他人员审核</p>";
		}else{
			result += " 等待"+ApproveName+"审核</p>";
		}
	}

	result += "<a href=\"javascript:approve_preview("+id+","+actionId+");\">点击查看详情</a>";
}

out.println(result);

%>
