<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%@ include file="../../../approve/approve_config.jsp"%>
<%

    int		id			= getIntParameter(request,"id");
    int  channelId=0;
    Document doc = new Document(id);
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
    String approve_status = "未提交审核";
    String url = "";
    ApproveAction approve2 = new ApproveAction(GlobalID,0);//最近一次审核操作
    int id_aa2 = approve2.getId();//审核操作id
    int approveId2 = approve2.getApproveId();//审核环节id	}

    int action2	= approve2.getAction();//是否通过
    int end2 = approve2.getEndApprove();//是否终审
    int editables = 0;

    JSONObject json1 = null;
    if(id_aa2!=0){//说明已配置审核环节
        ApproveItems ai = new ApproveItems(approveId2);//审核环节
        if(approveId2==0){//审核环节编号为0，此文章状态为提交审核
            json1 = ai.getApproveName(channel.getApproveScheme());
            approve_status = json1.get("ApproveName")+"待审核";
            editables = (int) json1.get("Editable");
        }else{
            json1 = ai.getApproveName(0);
            approve_status = json1.get("ApproveName")+"待审核";
            editables = (int) json1.get("Editable");
            int type = ai.getType();
            String userIds = ai.getUsers();

            if(!userIds.equals("")){
                String[] users = userIds.split(",");
                JSONObject json = getUserNames(users,getAction(GlobalID),GlobalID,ai.getId());
                int size = json.getInt("size");
                if(type==1){//并签要判断其他人是否审核通过
                    if(size>0){
                        approve_status = approve2.getApproveName()+"待审核";
                    }
                }
            }

            if(action2==1){//未通过
                approve_status = approve2.getApproveName()+"驳回";
            }
            if(action2==0&&end2==1){
                approve_status = approve2.getApproveName()+"通过";
            }
        }

    }
    int publisher_cmsid = doc.getIntValue("publisher_cmsid");

    String task_statusDesc=approve_status;


    String publisher_name = doc.getValue("publisher_name");
    String Users = doc.getValue("users");
    String start_time = doc.getValue("start_time");
    String Summary = doc.getValue("Summary");
    String PublishDate2=doc.getPublishDate();



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
<script>
	var Global={
        init:function() {
            this.htmlFontSize();
        },
        //设置根元素的font-size
        htmlFontSize:function(){
            var doc = document;
            var win = window;
            function initFontSize(){
                var docEl = doc.documentElement,
                    resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
                    recalc = function(){
                        var clientWidth = docEl.clientWidth;
                        if(!clientWidth) return;
                        if(clientWidth>750){
                            clientWidth=750;
                        }
                        fontSizeRate = (clientWidth / 375);
                        var baseFontSize = 50*fontSizeRate;
                        docEl.style.fontSize =  baseFontSize + 'px';
                    }
                recalc();
                if(!doc.addEventListener) return;
                win.addEventListener(resizeEvt, recalc, false);
                doc.addEventListener('DOMContentLoaded', recalc,false);
            }
            initFontSize();
        }

    };
    Global.init();
</script>
<header class="header-info">
    <div class="info-item"><span class="item-name">文稿名称：</span><span><%=Title%></span></div>
    <div class="info-item"><span class="item-name">所属栏目：</span><span><%=channelName%></span></div>
    <div class="info-item"><span class="item-name">创建时间：</span><span><%=PublishDate2%></span></div>
    <div class="info-item"><span class="item-name">文稿内容：</span><span><%=Summary%></span></div>
    <!--<div class="info-item"><span class="item-name">附件：</span><a class="file-url" href="#">选题.doc</a></div>-->
</header>
<%
    if(GlobalID!=0){


        
%>
<!--<a class="link-wrap" href="">
        <div><span>关联稿件：</span><span></span></div>
        <div class="arrow-right"></div>
    </a>-->
<%%>
<%
    ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
    int id_aa = approve.getId();//审核操作id
    if(id_aa!=0){


%>
<div class="main">
    <div class="main-wrap main-wrap1" >
        <section class="topic-wrap" >
            <div class="topic-header">
                <span>稿件状态</span>
                <div>
                    <%=task_statusDesc%>
                </div>
            </div>

            <%
                int approvescheme = channel.getApproveScheme();//审核方案
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
 
while(rs.next()){
	action	= rs.getInt("Action");//是否通过
	end = rs.getInt("endApprove");//是否是最后一步审核
	int userid2 = rs.getInt("userid");
	String UserName	= CmsCache.getUser(userid2).getName();
	CreateDate = convertNull(rs.getString("CreateDate"));
	CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",CreateDate);
	int approveId = rs.getInt("ApproveId");//审核环节id
	String approveName = convertNull(rs.getString("ApproveName"));

	if(approveId==0){
    step=0;
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
        if(approveName.equals("")){//兼容老数据
            approveName = ai.getTitle();
        }
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
    String  userIdss = approve_item.getUsers();
	String[] users = userIdss.split(",");
	JSONObject json = getUserNames(users,endActionId,GlobalID,approve_item.getId());
	String userNames = json.getString("userNames");

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
    int endStep = 0 ;
	String auditstatus = "等待审核";
	if(n==1){
		auditstatus = "审核中";
		userIds = json.getString("userIds");
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
            if(approvescheme!=0&&(action!=1&&id_aa!=0)&&Arrays.asList(users).contains(userid+"")){ %>
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
            url: "approve_wengao_submit.jsp?"+param,
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
            url: "approve_wengao_submit.jsp?"+param,
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
