<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../appconfig.jsp"%>
<%@ include file="../../../approve/approve_config.jsp"%>
<%

    int		id			= getIntParameter(request,"id");
    Channel task_doc = ChannelUtil.getApplicationChannel("task_doc");
    int channelId = task_doc.getId();

    Document doc = new Document(id,channelId);
    int GlobalID = doc.getGlobalID();
    int categoryID = doc.getCategoryID();
    if(categoryID!=0){
        channelId = categoryID;
    }
    Channel channel = CmsCache.getChannel(channelId);

    String channelName = "";
    if(categoryID!=0){
        channelName = CmsCache.getChannel(categoryID).getName();
    }
    String Title=doc.getTitle();//标题
    int task_status=doc.getIntValue("task_status");//任务状态
    int publisher_cmsid = doc.getIntValue("publisher_cmsid");

    String task_statusDesc="";
    if(task_status==0){
        task_statusDesc="<span class=\"status audit\">审核中</span><div class=\"arrow up\"></div>";
    }else if (task_status==1){
        task_statusDesc="<span class=\"status pass\">审核通过</span><div class=\"arrow up\"></div>";
    }else if (task_status==2){
        task_statusDesc="<span class=\"status no-pass\">审核未通过</span><div class=\"arrow\"></div>";
    }else if(task_status==3){
        task_statusDesc="<span class=\"status pass\">已完成</span><div class=\"arrow\"></div>";
    }

    String publisher_name = doc.getValue("publisher_name");
    String Users = doc.getValue("users");
    String start_time = doc.getValue("start_time");
    String Summary = doc.getValue("Summary");
    //下一步审核
    String approve_next = "";

%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>选题详情</title>
    <link rel="stylesheet" href="./css/common.css">
    <link rel="stylesheet" href="./css/detail.css" />
</head>

<body>
<header class="header-info">
    <div class="info-item"><span class="item-name">选题名称：</span><span><%=Title%></span></div>
    <div class="info-item"><span class="item-name">所属栏目：</span><span><%=channelName%></span></div>
    <div class="info-item"><span class="item-name">选题人：</span><span><%=publisher_name%></span></div>
    <div class="info-item"><span class="item-name">参与人：</span><span><%=Users%></span></div>
    <div class="info-item"><span class="item-name">选题时间：</span><span><%=start_time%></span></div>
    <div class="info-item"><span class="item-name">选题内容：</span><span><%=Summary%></span></div>
    <!--<div class="info-item"><span class="item-name">附件：</span><a class="file-url" href="#">选题.doc</a></div>-->
</header>
<%
    if(GlobalID!=0){


        TideJson topic_task = CmsCache.getParameter("topic_task").getJson();//选题相关频道信息
        int documentid = topic_task.getInt("document");//文稿管理频道

        String documentTable = CmsCache.getChannel(documentid).getTableName();
        String documentsql = "select * from "+documentTable+" where topicid="+GlobalID+" order by id asc";
        TableUtil documenttu = new TableUtil();
        ResultSet documentrs = documenttu.executeQuery(documentsql);

        while(documentrs.next()){
            String documentTitle	= convertNull(documentrs.getString("Title"));

%>
<!--<a class="link-wrap" href="">
        <div><span>关联稿件：</span><span><%=documentTitle%></span></div>
        <div class="arrow-right"></div>
    </a>-->
<%}
    documenttu.closeRs(documentrs);%>
<%
    ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
    int id_aa = approve.getId();//审核操作id
    if(id_aa!=0){


%>
<div class="main">
    <div class="main-wrap main-wrap1" >
        <section class="topic-wrap" >
            <div class="topic-header">
                <span>选题状态</span>
                <div>
                    <%=task_statusDesc%>
                </div>
            </div>

            <%
                int approvescheme = channel.getApproveScheme();//审核方案
//
//
                String sql = "select * from approve_actions where parent="+GlobalID+" order by id asc";
                TableUtil tu = new TableUtil();
                ResultSet rs = tu.executeQuery(sql);
            %>
            <div class="audit-process" id="box2">
                    <%
String html = "";
int step = 0 ;//最后一次操作步骤
int action = 0 ;//最后一次操作状态
String CreateDate = "";//最后一次操作时间
int endActionId = 0 ;//最后一次驳回操作id
int end = 0 ;
int approveId = 0;
while(rs.next()){
	action	= rs.getInt("Action");//是否通过
	end = rs.getInt("endApprove");//是否是最后一步审核
	int userid2 = rs.getInt("userid");
	String UserName	= CmsCache.getUser(userid2).getName();
	CreateDate = convertNull(rs.getString("CreateDate"));
	CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",CreateDate);
	approveId = rs.getInt("ApproveId");//审核环节id
	String approveName = convertNull(rs.getString("ApproveName"));

	if(approveId==0){
%>
                <div class="audit-step">
                    <div class="left">提交</div>
                    <div class="right">
                        <span class="name"><%=UserName%></span>
                        <span class="date"><%=CreateDate%></span>
                    </div>
                </div>
                    <%
	}else{
		ApproveItems ai = new ApproveItems(approveId);
		step = ai.getStep();

		if(action==1){
			endActionId = rs.getInt("id");
			%>
                <div class="audit-step">
                    <div class="left"><%=approveName%></div>
                    <div class="right">
                        <span class="status no-pass">驳回</span>
                        <span class="date"><%=CreateDate%></span>
                    </div>
                </div>
                <div class="audit-step">
                    <div class="left">

                    </div>
                    <div class="right">
                        <span class="auditor">审核人: <%=UserName%><br><%=convertNull(rs.getString("ActionMessage"))%></span>
                    </div>
                </div>
                    <%
		}else{
		%>
                <div class="audit-step">
                    <div class="left"><%=approveName%></div>
                    <div class="right">
                        <span class="status pass">通过</span>
                        <span class="date"><%=CreateDate%></span>
                    </div>
                </div>
                <div class="audit-step">
                    <div class="left">
                        <div class="line"></div>
                    </div>
                    <div class="right">
                        <span class="auditor">审核人：<%=UserName%></span>
                    </div>
                </div>
                    <%
		}
	}

}
tu.closeRs(rs);
approve_next=getHtml("","",0,end,0,"","",0,action);
String userIds = "";
int endStep = 0 ;
int userid2 = appUserInfo_session.getId();
if(action!=1&&end!=1){//最后一次操作是驳回或者是终审，不继续显示
int n = 0 ;
ArrayList<ApproveItems> list = CmsCache.getApprove(approvescheme).getApproveitems();
for(int i=0;i<list.size();i++){

	ApproveItems approve_item =  (ApproveItems)list.get(i);
	int step_ = approve_item.getStep() ;
	if(step_<step){//已进行过审核
		continue ;
	}

	String title = approve_item.getTitle();
    userIds = approve_item.getUsers();
	String[] users = userIds.split(",");
	JSONObject json = getUserNames(users,endActionId,GlobalID,approve_item.getId());
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
	String time_ = "";
	String auditstatus = "等待审核";
	if(n==1){
		auditstatus = "审核中";
	}
	String auditDesc = "须"+userNames+"审核通过";
	if(size>1){
	    if(type==1){
	        auditDesc = "须"+userNames+"全部审核通过";
	    }else{
	        auditDesc = "须"+userNames+"任意一人审核通过";
	    }
	}%>
                <div class="audit-step">
                    <div class="left"><%=title%></div>
                    <div class="right">
                        <span class="status audit"><%=auditstatus%></span>
                    </div>
                </div>
                <div class="audit-step">
                    <div class="left">
                        <div class="line"></div>
                    </div>
                    <div class="right">
                        <span class="auditor"><%=auditDesc%></span>
                    </div>
                </div>
                    <%


	//System.out.println("size:"+size);
	if((i+1)==list.size()){//说明是审核环节最后一步
		endStep = 1 ;
		if(type==0||size==1){//或签或者是并签最后一步
			end = 1;
		}
	}
	if(n==1){
	    approve_next = getHtml("","",n,end,endStep,names,userIds,approve_item.getId(),0);
	}

}


}
%>



        </section>
    </div>

    <div class="fixed-bottom-wrap">

        <%String[] users = userIds.split(",");
            System.out.println("用户列表："+userIds);
            System.out.println("用户id："+userid);
            System.out.println("用户task_status："+task_status);
            System.out.println("用户approvescheme："+approvescheme);
            System.out.println("用户action："+action);
            System.out.println("用户id_aa："+id_aa);
            if(task_status==0&&approvescheme!=0&&(action!=1&&id_aa!=0)&&Arrays.asList(users).contains(userid+"")){ %>
        <div class="fixed-bottom ">
            <div class="btn-wrap">
                <div class="btn pass-btn">通过</div>
                <div class="btn reject-btn">驳回</div>
            </div>
        </div>
        <%}%>

        <%if(publisher_cmsid==userid){
            if(task_status==1){%>
        <div class="fixed-bottom ">
            <div class="btn-wrap">
                <div class="btn edit-btn edit_finish">完成</div>
            </div>
        </div>
        <%}%>
        <%if(task_status==2){%>
        <div class="fixed-bottom ">
            <div class="btn-wrap">
                <div class="btn edit-btn">编辑</div>
            </div>
        </div>
        <%}%>
        <%if(task_status==3){%>
        <div class="fixed-bottom">
            <div class="btn-wrap">
                <div class="btn grade-btn">评分</div>
            </div>
        </div>
        <%}}%>

    </div>
    <!-- 弹窗提示 -->
    <div class="pop-modal reject-pop">
        <div class="pop-wrap">
            <div class="pop-box">
                <div class="pop-title">驳回理由：</div>
                <div class="pop-content">
                    <%=approve_next%>
                </div>
                <div class="pop-footer">
                    <div class="btn-box">
                        <div class="btn cancel">取消</div>
                        <div class="btn btn-primary confirm config_reject">确定</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="confirm-modal pass-confirm">
        <div class="confirm-wrap">
            <div class="confirm-box">
                <div class="confirm-content">
                    <p class="tip">确定审核通过</p>
                </div>
                <div class="confirm-footer">
                    <div class="btn-box">
                        <div class="btn cancel">取消</div>
                        <div class="btn btn-primary confirm config_pass">确定</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
        <%}}%>
</body>

</html>
<script src="./js/jquery-1.11.1.min.js"></script>
<script src="./js/detail.js"></script>
<script type="text/javascript">
    //通过
     var userid = "<%=userid%>";
    $(".config_pass").on("click",function(){
        var approveId = $("#approve").attr("approveId");
        var endApprove = $("#approve").attr("end");
        var title = "<%=Title%>";
       
        var param =
            "globalid=<%=GlobalID%>&title="+title+"&action=0&approveId="+approveId+"&endApprove="+endApprove+"&userid="+userid;
        $.ajax({
            type: 'GET',
            url: "subject_approve_sumbit.jsp?"+param,
            success: function (data) {
                window.location.reload();
            }
        });
    });
    //驳回
    $(".config_reject").on("click",function(){
        var approveId = $("#approve").attr("approveId");
        var endApprove = $("#approve").attr("end");
        var title = "<%=Title%>";
        var content = $("#approve").val();
        if(content==""){
            alert("请输入驳回理由");
            return false;
        }
        var param =
            "globalid=<%=GlobalID%>&title="+title+"&action=1&approveId="+approveId+"&endApprove="+endApprove+"&actionMessage="+content+"&userid="+userid;

        $.ajax({
            type: 'GET',
            url: "subject_approve_sumbit.jsp?"+param,
            success: function (data) {
                window.location.reload();
            }
        });
    });
    //完成
    $(".edit_finish").on("click",function(){


        var param = "globalid=<%=GlobalID%>"+"&userid="+userid;

        $.ajax({
            type: 'GET',
            url: "subject_approve_finish.jsp?"+param,
            success: function (data) {
                window.location.reload();
            }
        });
    });

</script>
