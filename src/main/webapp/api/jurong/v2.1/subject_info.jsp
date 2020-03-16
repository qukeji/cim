<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%

    int		id			= getIntParameter(request,"id");
    //Channel task_doc = ChannelUtil.getApplicationChannel("task_doc");
    int channelId = 14271;

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
    String score=doc.getValue("score");
    int task_status=doc.getIntValue("rwzt");//任务状态
    int publisher_cmsid = doc.getUser();

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

    String publisher_name=doc.getUserName();
    String Users = doc.getValue("users");
    String start_time = doc.getPublishDate();
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
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/detail.css" />
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
    <div class="info-item"><span class="item-name">选题名称：</span><span><%=Title%></span></div>
    <div class="info-item"><span class="item-name">所属栏目：</span><span><%=channelName%></span></div>
    <div class="info-item"><span class="item-name">选题人：</span><span><%=publisher_name%></span></div>
    <div class="info-item"><span class="item-name">参与人：</span><span><%=Users%></span></div>
    <div class="info-item"><span class="item-name">选题时间：</span><span><%=start_time%></span></div>
    <div class="info-item"><span class="item-name">选题内容：</span><span><%=Summary%></span></div>
    <%if (!score.equals("")){%>
    <div class="info-item"><span class="item-name topic-header">选题评分：</span><span><%=score%></span></div>
    <%}%>
    <!--<div class="info-item"><span class="item-name">附件：</span><a class="file-url" href="#">选题.doc</a></div>-->
</header>
<%
    if(GlobalID!=0){
%>
<%
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
            %>
            <div class="audit-process" id="box2">
                    <%
        String html = "";
        int step = 0 ;//最后一次操作步骤
        int action = 0 ;//最后一次操作状态
        String CreateDate = "";//最后一次操作时间
        int endActionId = 0 ;//最后一次驳回操作id
        int end = 0 ;
    %>

        </section>
    </div>
    <div class="fixed-bottom-wrap">
        <%
            System.out.println("channelId:"+channelId);
            System.out.println(channel.getName());
            System.out.println(userinfo_session.getName());
            System.out.println("CanApprove:"+channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove));



            if(task_status==0&&channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove)){%>
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
        <%}}%>
        <%if(task_status==3&&score.equals("")){%>
        <div class="fixed-bottom">
            <div class="btn-wrap">
                <div class="btn grade-btn">评分</div>
            </div>
        </div>
        <%}%>
    </div>
    <!-- 弹窗提示 -->
    <div class="pop-modal reject-pop">
        <div class="pop-wrap">
            <div class="pop-box">
                <div class="confirm-content">
                    <p class="tip">确定驳回</p>
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
    <div class="pop-modal pingfeng-pop">
        <div class="pop-wrap">
            <div class="pop-box">
                <div class="pop-title">选题评分：</div>
                <div class="pop-content" >
                    <textarea id="approve2" class="form-control" rows="1" cols="1" placeholder="" style="font-size: 30px"></textarea>
                </div>
                <div class="pop-footer">
                    <div class="btn-box">
                        <div class="btn cancel">取消</div>
                        <div class="btn btn-primary confirm config_pingfeng">确定</div>
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
    <%}%>
</div>
</body>

</html>
<script src="./js/jquery-1.11.1.min.js"></script>
<script src="./js/detail.js"></script>
<script type="text/javascript">
    //通过
    var userid = "<%=userid%>";
    $(".config_pass").on("click",function(){
        var approveId = $("#approve").attr("approveId");
        var endApprove = 1;
        var title = "<%=Title%>";
        var userids=$("#approve").attr("user");
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
        var endApprove = 2;
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
    //评分
    $(".config_pingfeng").on("click",function(){
        var approveId = $("#approve").attr("approveId");
        var endApprove = $("#approve").attr("end");
        var title = "<%=Title%>";
        var score = $("#approve2").val();
        if(score==""){
            alert("请输入分数");
            return false;
        }
        var param =
            "globalid=<%=GlobalID%>&title="+title+"&action=3&approveId="+approveId+"&endApprove="+endApprove+"&score="+score+"&userid="+userid;

        $.ajax({
            type: 'GET',
            url: "pingfen_submit.jsp?"+param,
            success: function (data) {
                window.location.reload();
            }
        });
    });
    //判断字符串是否存在数组当中
    function in_array(stringToSearch, arrayToSearch) {
        for (s = 0; s < arrayToSearch.length; s++) {
            thisEntry = arrayToSearch[s].toString();
            if (thisEntry == stringToSearch) {
                return true;
            }
        }
        return false;
    }

</script>
