<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%@ include file="approve_config.jsp"%>

<%
/**
* 用途：获取稿件审核结果
*/
int gid = getIntParameter(request,"globalid");
int channelid = getIntParameter(request,"channelid");
Channel channel = CmsCache.getChannel(channelid);
int approvescheme = channel.getApproveScheme();//审核方案

String sql = "select * from approve_actions where parent="+gid+" order by id asc";
TableUtil tu = new TableUtil();
ResultSet rs = tu.executeQuery(sql);
			            
String result = "<div class=\"card-body mg-t-20 bg-white hide\">";
String html = "";
int step = 0 ;//最后一次操作步骤
int action = 0 ;//最后一次操作状态
String CreateDate = "";//最后一次操作时间
int endActionId = 0 ;//最后一次驳回操作id
int end = 0 ;
while(rs.next()){
	action	= rs.getInt("Action");//是否通过
	end = rs.getInt("endApprove");//是否是最后一步审核
	int userid = rs.getInt("userid");
	String UserName	= CmsCache.getUser(userid).getName();
	CreateDate = convertNull(rs.getString("CreateDate"));
	CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",CreateDate);
	int approveId = rs.getInt("ApproveId");//审核环节id
	String approveName = convertNull(rs.getString("ApproveName"));

	if(approveId==0){
		step = 0 ;
		html = "<span class=\"mg-r-7\">提交</span><span class=\"mg-r-7\">"+UserName+"</span><span>提交审核</span>";
	}else{
		ApproveItems ai = new ApproveItems(approveId);
		step = ai.getStep();
		if(approveName.equals("")){//兼容老数据
			approveName = ai.getTitle();
		}
		html = "<span class=\"mg-r-7\">"+approveName+"</span><span class=\"mg-r-7\">"+UserName+"</span>";
		if(action==1){
			endActionId = rs.getInt("id");
			html += "<span class=\"tx-danger\">驳回</span>";
		}else{
			html += "<span class=\"tx-success\">通过</span>";
		}
	}
	result += getHtml(html,CreateDate,0,end,0,"","",0,action);

	if(action==1){
		result += "<div class=\"sh-reason mg-t-5\"><p class=\"bd pd-x-10 pd-y-5\">理由："+convertNull(rs.getString("ActionMessage"))+"</p></div></div><input type=\"hidden\"><div class=\"hide card-body mg-t-20 bg-white shadow-base bd-0\">";
	}
}
tu.closeRs(rs);

if(action==1||end==1){//最后一次操作是驳回或者是终审，不继续显示
	result = reversal(result);
	out.println(result);
	return;
}

int n = 0 ;
ArrayList<ApproveItems> list = CmsCache.getApprove(approvescheme).getApproveitems();
for(int i=0;i<list.size();i++){

	ApproveItems approve_item =  (ApproveItems)list.get(i);
	int step_ = approve_item.getStep() ;
	if(step_<step){//已进行过审核
		continue ;
	}
	String title = approve_item.getTitle();
	String userIds = approve_item.getUsers();
	String[] users = userIds.split(",");
	JSONObject json = getUserNames(users,endActionId,gid,approve_item.getId());
	String userNames = json.getString("userNames");	
	userIds = json.getString("userIds");
	int size = json.getInt("size");

	int type = approve_item.getType();
	String type_ = "";
	if(type==1){//并签
		type_ = "并签";	
		if(size==0){//并签全部通过
			continue ;
		}
	}else{
		type_ = "或签";
		if(step_==step){//或签一人通过即通过
			continue ;
		}
	}	
	
	n++ ;
	String names = "";
	int endStep = 0 ;
	String time_ = "";
	html = "<span class=\"mg-r-7\">"+title+"</span><span class=\"mg-r-7\">"+userNames+"</span>";
	if(size>1){
		html = "<span class=\"mg-r-7\">"+title+"</span><span class=\"mg-r-7\">"+size+"人"+type_+"</span>";
		names = "须"+userNames+"任意一人审核通过" ;
		if(type==1){
			names = "须"+userNames+"全部审核通过" ;
		}
	}	
	if(n==1){
		html += "<span class=\"tx-warning\">审核中</span>";	
		time_ = "已等待"+getTime(CreateDate);
	}else{
		html += "<span style=\"color:#868ba1\">等待审核</span>";	
	}
	//System.out.println("size:"+size);
	if((i+1)==list.size()){//说明是审核环节最后一步
		endStep = 1 ;
		if(type==0||size==1){//或签或者是并签最后一步
			end = 1;
		}
	}
	result += getHtml(html,time_,n,end,endStep,names,userIds,approve_item.getId(),0);
}
result = reversal(result);
out.println(result);

%>
<%!
    public String reversal(String result){
        String[] split = result.split("<input type=\"hidden\">");
        List<String> asList = Arrays.asList(split);
        Collections.reverse(asList);
        StringBuffer stringBuffer = new StringBuffer();
        int i = 0;
        for (String string : asList) {
        	if(i==0){
        	    string = string.replaceAll(" mg-t-20","");
        	    string = string.replaceAll(" shadow-base","");
        		stringBuffer.append(string+"</div>");
        	}else{
        		stringBuffer.append(string);
        	}
            i++;
        }
        result = stringBuffer.toString();
        return result;
    }
%>
