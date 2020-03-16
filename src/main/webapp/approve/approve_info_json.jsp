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
    int gid = getIntParameter(request,"globalid");
    Document doc=new Document(gid);
    Channel channel= doc.getChannel();
    int approvescheme = channel.getApproveScheme();//审核方案

    String sql = "select * from approve_actions where parent="+gid+" order by id asc";
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    int step = 0 ;//最后一次操作步骤
    int action = 0 ;//最后一次操作状态
    String CreateDate = "";//最后一次操作时间
    int endActionId = 0 ;//最后一次驳回操作id
    int end = 0 ;
    JSONObject all=new JSONObject();
    JSONArray data=new JSONArray();
    while(rs.next()){
        JSONObject object=new JSONObject();
        action	= rs.getInt("Action");//是否通过
        end = rs.getInt("endApprove");//是否是最后一步审核
        int userid = rs.getInt("userid");
        String UserName	= CmsCache.getUser(userid).getName();
        CreateDate = convertNull(rs.getString("CreateDate"));
        CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",CreateDate);
        int approveId = rs.getInt("ApproveId");//审核环节id
        String approveName = convertNull(rs.getString("ApproveName"));
        if (approveId==0){
            step=0;
        }else {
            ApproveItems ai = new ApproveItems(approveId);
            step = ai.getStep();
            if(approveName.equals("")){//兼容老数据
                approveName = ai.getTitle();
            }
            if(action==1){
                endActionId=rs.getInt("id");
            }
        }
        object.put("title",UserName);
        object.put("userNames",approveName);
        object.put("step",step);
        object.put("endActionId",endActionId);
        object.put("approveId",approveId);
        object.put("CreateDate",CreateDate);
        object.put("action",action);
        data.put(object);
    }tu.closeRs(rs);
    if(action==1||end==1){//最后一次操作是驳回或者是终审，不继续显示
        return;
    }

    int n = 0 ;
    ArrayList<ApproveItems> list = CmsCache.getApprove(approvescheme).getApproveitems();
    JSONArray approvearr=new JSONArray();
    for(int i=0;i<list.size();i++){
        JSONObject approve=new JSONObject();
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
        String Status = "";
        int endStep = 0 ;
        String time_ = "";
        if(size>1){
            names = "须"+userNames+"任意一人审核通过" ;
            if(type==1){
                names = "须"+userNames+"全部审核通过" ;
            }
        }
        if(n==1){
            Status += "<span class=\"tx-warning\">审核中</span>";
            time_ = "已等待"+getTime(CreateDate);
        }else{
            Status += "<span style=\"color:#868ba1\">等待审核</span>";
        }
        //System.out.println("size:"+size);
        if((i+1)==list.size()){//说明是审核环节最后一步
            endStep = 1 ;
            if(type==0||size==1){//或签或者是并签最后一步
                end = 1;
            }
        }
        approve.put("title",title);
        approve.put("userNames",userNames);
        approve.put("size",size);
        approve.put("CreateDate",CreateDate);
        approve.put("end",end);
        approve.put("endStep",endStep);
        approve.put("type",type);
        approve.put("n",n);
        approve.put("names",names);
        //approve.put("Status",Status);
        approvearr.put(approve);
    }
    all.put("result",data);
    all.put("approvearr",approvearr);
    out.println(all);
%>