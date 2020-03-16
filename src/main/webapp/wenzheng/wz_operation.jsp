<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	String	uri						= request.getRequestURI();
	long	begin_time				= System.currentTimeMillis();
	int		ChannelID				= getIntParameter(request,"ChannelID");
	int		ItemID					= getIntParameter(request,"ItemID");
	int		RecommendItemID			= getIntParameter(request,"RecommendItemID");
	int		RecommendChannelID		= getIntParameter(request,"RecommendChannelID");
	String	RecommendTarget			= getParameter(request,"RecommendTarget");
	int		RecommendOutItemID		= getIntParameter(request,"ROutItemID");
	int		RecommendOutChannelID	= getIntParameter(request,"ROutChannelID");
	/*云资源采用*/
	int		CloudItemID				= getIntParameter(request,"CloudItemID");
	int		CloudChannelID			= getIntParameter(request,"CloudChannelID");
	String	ROutTarget				= getParameter(request,"ROutTarget");
	int		parentGlobalID			= getIntParameter(request,"pid");

	int ContinueNewDocument			= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow				= getIntParameter(request,"NoCloseWindow");
	String From						= getParameter(request,"From");
	int IsDialog					= getIntParameter(request,"IsDialog");//如果是弹出窗口，值设为1
	int Parent						= getIntParameter(request,"Parent");//如果设置了Parent,就设置Parent字段的值

	String transfer_article			= getParameter(request,"transfer_article");//一键转载url
	 
	int GlobalID					= 0;
	String QRcode					= "";
	String title = "";
	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}
	
	TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
    int wenzhengchannelid = politics.getInt("politicsid");//问政编号信息
    Channel wenzhengchannel = CmsCache.getChannel(wenzhengchannelid);
    

	Document item = null;
	Channel channel = CmsCache.getChannel(ChannelID);
	if(channel.getDocumentProgram().length()>0 && uri.endsWith("/content/document.jsp") )
		response.sendRedirect(channel.getDocumentProgram()+"?ChannelID="+ChannelID+"&ItemID="+ItemID+"&ROutTarget="+ROutTarget+"&ROutChannelID="+RecommendOutChannelID+"&ROutItemID="+RecommendOutItemID+"&RecommendItemID="+RecommendItemID+"&RecommendChannelID="+RecommendChannelID+"&RecommendTarget="+RecommendTarget);

	if(channel.isVideoChannel())
	{
		response.sendRedirect("../video/document.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID);return;
	}

	if(ItemID>0)
	{
		item = CmsCache.getDocument(ItemID,ChannelID);

		//解决同步问题，2012.09.19
		if(item.getChannel().getId()!=ChannelID)
		{
			ChannelID = item.getChannel().getId();
			item = CmsCache.getDocument(ItemID,ChannelID);
			channel = CmsCache.getChannel(ChannelID);
		}
	}
	
	if(item!=null)
	{
		GlobalID = item.getGlobalID();
		QRcode = item.getQRCode();
		title = item.getTitle();
	}
	ArrayList fieldGroupArray = channel.getFieldGroupInfo();
	String SiteAddress = channel.getSite().getUrl();

	String check2 = "";

	boolean editCategory = false;

	if(channel.isTableChannel() && channel.getType2()==8) editCategory = true;

	String userGroup = "";

	try
	{
		userGroup = new UserGroup(userinfo_session.getGroup()).getName();
	}
	catch(Exception e){}

	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
	String inner_url = "",outer_url="";
	if(photo_config != null)
	{
		int sys_channelid_image = photo_config.getInt("channelid");
		Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
		inner_url = img_site.getUrl();
		outer_url = img_site.getExternalUrl();
	}

	int ApproveScheme = channel.getApproveScheme();//是否配置了审核方案
	int Version = channel.getVersion();//是否开启了版本功能
	
	
	ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
	int id_aa = approve.getId();//审核操作id
	int approveId = approve.getApproveId();//审核环节id
	int action	= approve.getAction();//是否通过
	int end = approve.getEndApprove();//是否终审
	
	int data_approve = 0;//是否显示右侧审核栏
	int data_yl = 0;//是否为审核预览
	
	if(id_aa!=0){//说明已提交审核
	    	data_approve = 1;//是否显示右侧审核栏
        	data_yl = 0;//是否为审核预览
	}
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Meta -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico"/>
    <title><%=channel.getParentChannelPath()%></title></title>
    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>
	.collapsed-menu .br-mainpanel-file{margin-left: 60px;margin-bottom: 30px;}		
	#nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
	#nav-header a{color: #a4aab0;}
	.table-bordered {border: 1px solid #dee2e6;text-align: center;}
	#tabTable td{padding: 0.3rem !important;cursor: pointer;}
	.selTab{border: 1px solid #17A2B8 !important;background-color: #17A2B8;color: #fff;}
    .edui-default .edui-editor-breadcrumb{line-height: 30px;}
	.btn-box a{color:#fff }
    .ui-widget-content{border: 1px solid rgba(0, 0, 0, 0.15) ;}
	.bs-tooltip-bottom .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #f8f9fa;opacity: 1;}
	.tooltip.bs-tooltip-bottom .arrow::before,
	.tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {border-bottom-color: #f8f9fa;	}
	/*.edui-editor {z-index: 0 !important;}*/
    /*tooltip相关样式*/
    .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
	.tooltip.bs-tooltip-right .arrow::before,
	.tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {			
		border-right-color: #00b297;			
	}
    </style>
   
    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../common/2018/common2018.js"></script>
    <script src="../common/document.js"></script>
    <script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
    <script src="../common/tag-it.js"></script>
    <!--百度编辑器-->
    <script type="text/JavaScript" charset="utf-8" src="../ueditor/ueditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="../ueditor/ueditor.all.js"></script>
    <script type="text/javascript" charset="utf-8" src="../ueditor/lang/zh-cn/zh-cn.js"></script>
    <!--<script type="text/javascript" charset="utf-8" src="../ueditor/toupiaoDialog.js"></script>-->
    <script type="text/javascript" charset="utf-8" src="../ueditor/photosDialog.js"></script>
    <script type="text/javascript" charset="utf-8" src="../ueditor/imgeditorDialog.js"></script>
    <script type="text/javascript" charset="utf-8" src="../ueditor/imagesDialog.js"></script>
    <script>
    var webName = "${pageContext.request.contextPath}";

    var Pages=1;
    var curPage = 1;
    var Contents = new Array();
    Contents[Contents.length] = "";
    var userId = <%=userinfo_session.getId()%>;
    var userName = "<%=userinfo_session.getName()%>";
    var userGroupName = "<%=userGroup%>";
    var userGroupId = <%=userinfo_session.getGroup()%>;
    var channelid = <%=ChannelID%>;
    var groupnum = <%=QRcode.equals("")?fieldGroupArray.size():fieldGroupArray.size()+1%>;
    var begin_time=<%=begin_time/1000%>;
    var SiteAddress = "<%=SiteAddress%>";
    var GlobalID = <%=GlobalID%>;
    var inner_url = "<%=inner_url%>";
    var outer_url = "<%=outer_url%>";
    var is_auto_save = false;//自动保存
    var timer = null;//定时器
    var ChannelID = "<%=ChannelID%>";


    var NoCloseWindow = <%=NoCloseWindow%>;//是否关闭页面
    var unload = false ;//关闭页面是否提示
    window.onresize = function(){	
        if(document.getElementsByClassName("content-edit-frame")[0]){		
            if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){ 
                var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.body.scrollHeight ;
            }else{
                var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.documentElement.scrollHeight ;		
            }		
            document.getElementsByClassName("content-edit-frame")[0].style.height = _height
        }
    }
    //调整iframe的高度 
    function changeFrameHeight(_this){   
        if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){     		
            _this.style.height = _this.contentWindow.document.body.scrollHeight +5;				
        }else{		
            _this.style.height = _this.contentWindow.document.documentElement.scrollHeight +5;				
        }
    }
    function SaveApprove(action){
        var user = $("#approve").attr("user");
        var approveId = $("#approve").attr("approveId");
        var endApprove = $("#approve").attr("end");
        var actionMessage = $("#approve").val();
        if(action==1&&actionMessage==""){
            alert("请输入驳回理由");
            return false ;
        }
        var title = $("#Title").val();
        var enTitle= encodeURI(title);
        var url= "../approve/approve_sumbit.jsp?globalid="+GlobalID+"&title="+enTitle+"&action="+action+"&user="+user+"&approveId="+approveId+"&endApprove="+endApprove+"&actionMessage="+actionMessage;
        $.ajax({
            type: "GET",
            url: url,
            success: function(msg){
                if(msg.trim()!=""){
                    alert(msg.trim());
                }else{
                    if(action==0){
                        Save();
                    }else{
                        document.location.reload();
                    }
                }
            }   
        }); 
    }
    
    function wz_forward(){

    var url= "../wenzheng/wenzheng_forword.jsp?ChannelID="+ChannelID+"&ItemID=<%=ItemID%>&operation=3&GlobalID="+GlobalID;

    var	dialog = new top.TideDialog();
    dialog.setWidth(450);
    dialog.setHeight(280);
    dialog.setUrl(url);
    dialog.setTitle("转交");
    dialog.show();
    }
    function wz_forward2(){

    var url= "../wenzheng/wenzheng_forword.jsp?ChannelID="+ChannelID+"&ItemID=<%=ItemID%>&operation=4&GlobalID="+GlobalID;

    var	dialog = new top.TideDialog();
    dialog.setWidth(540);
    dialog.setHeight(380);
    dialog.setUrl(url);
    dialog.setTitle("直接回复");
    dialog.show();
    }
    
    function wz_pass(){

    var url= "../wenzheng/wenzheng_back.jsp?ChannelID="+ChannelID+"&ItemID=<%=ItemID%>&operation=2&GlobalID="+GlobalID;

    var	dialog = new top.TideDialog();
    dialog.setWidth(540);
    dialog.setHeight(380);
    dialog.setUrl(url);
    dialog.setTitle("不通过");
    dialog.show();
    }
    function wz_reply(){

    var url= "../wenzheng/wenzheng_back.jsp?ChannelID="+ChannelID+"&ItemID=<%=ItemID%>&operation=4&GlobalID="+GlobalID;

    var	dialog = new top.TideDialog();
    dialog.setWidth(540);
    dialog.setHeight(380);
    dialog.setUrl(url);
    dialog.setTitle("直接回复");
    dialog.show();
    }
    
    function wz_back(){

    var url= "../wenzheng/wenzheng_back.jsp?ChannelID="+ChannelID+"&ItemID=<%=ItemID%>&operation=5&GlobalID="+GlobalID;

    var	dialog = new top.TideDialog();
    dialog.setWidth(540);
    dialog.setHeight(380);
    dialog.setUrl(url);
    dialog.setTitle("退回");
    dialog.show();
    }
    function wz_reply2(){

    var url= "../wenzheng/wenzheng_back.jsp?ChannelID="+ChannelID+"&ItemID=<%=ItemID%>&operation=7&GlobalID="+GlobalID;

    var	dialog = new top.TideDialog();
    dialog.setWidth(540);
    dialog.setHeight(380);
    dialog.setUrl(url);
    dialog.setTitle("回复");
    dialog.show();
    }
    function wz_over(){

    var url= "../wenzheng/wenzheng_back.jsp?ChannelID="+ChannelID+"&ItemID=<%=ItemID%>&operation=8&GlobalID="+GlobalID;

    var	dialog = new top.TideDialog();
    dialog.setWidth(350);
    dialog.setHeight(220);
    dialog.setUrl(url);
    dialog.setTitle("结束");
    dialog.show();
    }
    //开始办理
    function wz_start(s)
{
	var url="../wenzheng/wenzheng_checkin.jsp?ChannelID=<%=ChannelID%>&ItemID=<%=ItemID%>&probstatus=4";
	$.ajax({
		type: "GET",
		url: url,
		success: function(msg){document.location.href=document.location.href;window.parent.opener.document.location.reload();}   
	});  
}
    </script>

    <script>

    function Save_approve()
    {
        document.form.Approve.value = 1;
        Save();
    }

    function Save()
    { 
       unload = false ;
    <%if(IsDialog==0){%>
        if(window.opener!=null)
        {
            window.opener.document.location.reload();					
        }
        window.close();
    <%}%>

    <%if(IsDialog==1){%>
        top.TideDialogClose({refresh:'right'});
    <%}%>		
    }



    function init()
    {	

        $(".date").datetimepicker({
            timeText: '时间',  
            hourText: '小时',  
            minuteText: '分钟',  
            secondText: '秒',  
            currentText: '现在',  
            closeText: '完成',  
            showSecond: true, //显示秒  
                dateFormat:"yy-mm-dd",
                timeFormat: 'HH:mm:ss',//格式化时间  
                monthNames: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],  
                dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],  
                dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],  
                dayNamesMin: ['日','一','二','三','四','五','六']
        });

        var sampleTags = [];
        $("#Keyword").tagit({availableTags: sampleTags    });
        $("#Tag").tagit({availableTags: sampleTags    });
    <%
        if(item!=null)
        {
            out.println("document.form.Action.value = 'Update';");
        }
        else
        {
            if(RecommendItemID>0 && RecommendChannelID>0)
            {
                out.println("recommendItemJS("+RecommendItemID+","+RecommendChannelID+","+ChannelID+",\""+RecommendTarget+"\");");
            }

            if(RecommendOutItemID>0&&RecommendOutChannelID>0)
            {
                out.println("recommendOutItemJS("+RecommendOutItemID+","+RecommendOutChannelID+","+ChannelID+",\""+ROutTarget+"\");");
            }

            if(CloudChannelID>0 && CloudItemID>0)
            {
                out.println("cloudItemJS("+CloudItemID+","+CloudChannelID+");");
            }
            
            if(transfer_article.length()>0)
            {
                out.println("transferArticleJS(\""+transfer_article+"\");");
            }
        }
    %>
        checkTitle();
        document.body.disabled  = false;
        auto_save();
    }

    //获取当前时间
    function getNowFormatDate()
    {
        var date = new Date();
        var seperator1 = "-";
        var seperator2 = ":";
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = year + seperator1 + month + seperator1 + strDate
                + " " + date.getHours() + seperator2 + date.getMinutes()
                + seperator2 + date.getSeconds();
        return currentdate;
    }

    //自动保存
    function auto_save()
    {
            if($("#auto_save").attr("checked"))//勾选了才自动保存
            {
                        is_auto_save = true;
                        document.form.NoCloseWindow.value = '1';
                        timer = window.setInterval("Save()","30000");
            }
                //自动保存
            $("#auto_save").change(
                    function()
                    {
                        if(this.checked)
                        {//选中 自动保存
                                is_auto_save = true;
                                document.form.NoCloseWindow.value = '1';
                                timer = window.setInterval("Save()","30000");
                        }
                        else
                        {//取消自动保存
                            is_auto_save = false;
                            document.form.NoCloseWindow.value = '0';
                            window.clearInterval(timer); 
                        }
                }
            );

    }

    function initContent1()
    {
        <%if(item!=null){%>
        if(document.getElementById("tabTableRow"))
            try{
            {<%//System.out.println(item.getContent());%>
                <%if(item.getTotalPage()>1){for(int i=2;i<=item.getTotalPage();i++){item.setCurrentPage(i);%>
                    AddPageInit();//alert(content);
                    content = '<%=Util.JSQuote(item.getContent())%>';//alert(content);
                <%if(!SiteAddress.equals("")){%>content = content.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;<%}%>
                    //SetContent(<%=i%>,content);
                var num = <%=i%>;
                if(num<=Contents.length)
                    Contents[num-1] = content;
                else
                    Contents[Contents.length] = content;			
                <%}}%>
            }
            }catch(er){	window.setTimeout("initContent1()",5);}
            document.form.Action.value = "Update";//alert(Contents["t2"]);
        <%}%>
    }

    function initContent()
    {
        window.setTimeout("initContent1()",1);
    }

    var curField = 0;

    function previewFile(fieldname)
    {
        var name = document.getElementById(fieldname).value;
        //图片库采用本地预览
        var reg = new RegExp(outer_url,"g");
        if(name=="") return;

        if(name.indexOf("http://")!=-1 || name.indexOf("https://")!=-1)  window.open(name.replace(reg,inner_url));
        else	window.open("<%=SiteAddress%>/" + name);
    }

    function selectByKeyword()
    {
        var ByKeyword = document.getElementById("ByKeyword");
        var ByTitle = document.getElementById("ByTitle");
        document.getElementById("related_doc_list").src = "related_doc_list.jsp?GlobalID=<%=GlobalID%>&ChannelID=<%=ChannelID%>&ByKeyword="+ByKeyword.checked + "&ByTitle="+ByTitle.checked + "&keyword=" + encodeURIComponent(document.form.ByKeywordText.value);
    }


    </script>
    </head>
    <style>
        html,body{width: 100%;height: 100%;}
        .wd-content-lable{flex: 1;}
        div.wd-content-div {display: block;width: 100%;flex: 1;}
        div.wd-content-div p{line-height: 1.5;}
        div.wd-content-div img{max-width: 100%;;margin: 5px 0;}
        div.wd-content-img {max-width: 300px;display: block;}
        div.wd-content-img img{max-width: 100%;}
        .table-responsive th,.table-responsive td{text-align: center;}
        @media (max-width: 575px) {
            .wd-content-lable{flex: auto;}
            div.wd-content-div {display: block;width: 100%;flex:auto;}
        }
    </style>


  <body class="collapsed-menu email" id="withSecondNav">
    <script type="text/javascript">document.body.disabled  = true;</script>
    <div class="br-logo"><img src="../images/2018/system-logo.png"></div>
    <div class="br-sideleft overflow-y-auto">
        <label class="sidebar-label pd-x-15 mg-t-20"></label>
    <%for (int i = 0; i < fieldGroupArray.size(); i++){
        FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);%>	
        <div class="br-sideleft-menu">
            <a href="javascript:showTab('<%=i+1%>')" <%=(i==0?"class='br-menu-link active'":"class='br-menu-link'")%> id="form<%=i+1%>_td" groupid="<%=fieldGroup.getId()%>" data-toggle="tooltip" data-placement="right" title="<%=fieldGroup.getName()%>">
                <div class="br-menu-item">
                    <i class="menu-item-icon fa fa-edit tx-22"></i>
                    <span class="menu-item-label"><%=fieldGroup.getName()%></span>
                </div><!-- menu-item -->
            </a><!-- br-menu-link -->
        </div><!-- br-sideleft-menu -->
    <%}%>
    </div><!-- br-sideleft -->  
    <div class="br-header">
	<div class="br-header-left">
		<div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
		<div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
		<div id="nav-header" class="hidden-md-down flex-row align-items-center">
			<%=channel.getParentChannelPath().replaceAll(">"," / ")%>
		</div>
	</div><!-- br-header-left -->
	<div class="br-header-right">
		<div class="btn-box" >
		    <%if(wenzhengchannel.hasRight(userinfo_session,1)){%>
		    <%if(item.getIntValue("Status2")==0&&item.getIntValue("probstatus")==1){%>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_forward();">转交</a>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_pass();">驳回</a>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_forward2();">直接回复</a>
            <%}
            if(item.getIntValue("Status2")==1&&item.getIntValue("probstatus")==5){%>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_reply();">回复</a>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_over();">结束</a>
            <%}
		    }else{
		    if(item.getIntValue("Status2")==0&&item.getIntValue("probstatus")==3){%>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_start();" >开始办理</a>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_back();">退回</a>
            <%}
            if(item.getIntValue("Status2")==0&&item.getIntValue("probstatus")==4){%>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_reply2();">回复</a>
            <%}
            if(item.getIntValue("Status2")==1&&item.getIntValue("probstatus")==6){%>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_reply2();">回复</a>
            <a class="btn btn-primary tx-size-xs mg-r-10" href="javascript:wz_over();">结束</a>
            <%}
            }%>
			<a class="btn btn-secondary tx-size-xs mg-r-10" href="javascript:self.close();">关闭</a>	
		</div>
	</div><!-- br-header-right -->
    <%
    int Status2 = item.getIntValue("Status2");
    String Status2Desc = "";
    if(Status2==0){
        Status2Desc = "待办理";
    }else if(Status2==1){
        Status2Desc = "办理中";
    }else if(Status2==2){
        Status2Desc = "已办理";
    }
    
    int probstatus = item.getIntValue("probstatus");
    String probstatusDesc = "";
    if(probstatus==1){
        probstatusDesc="未审核";
    }else if(probstatus==2){
        probstatusDesc="审核未通过";
    }else if(probstatus==3){
        probstatusDesc="未受理";
    }else if(probstatus==4){
        probstatusDesc="已受理";
    }else if(probstatus==5){
        probstatusDesc="平台回复";
    }else if(probstatus==6){
        probstatusDesc="已回复";
    }else if(probstatus==7){
        probstatusDesc="已完结";
    }

    int type = item.getIntValue("type");
    String typeDesc = "";
    if(type!=0){
        if(type==1){
            typeDesc = "投诉";
        }else if(type==2){
            typeDesc = "咨询";
        }else if(type==3){
            typeDesc = "问题";
        }else if(type==4){
            typeDesc = "建议";
        }else if(type==5){
            typeDesc = "反馈";
        }
    }
    
    int evaluation = item.getIntValue("evaluation");
    String evaluationDesc = "";
    if(evaluation!=0){
        if(evaluation==1){
            evaluationDesc = "满意";
        }else if(evaluation==2){
            evaluationDesc = "不满意";
        }
    }
    %>

    </div><!-- br-header -->
    <div class="br-mainpanel br-mainpanel-file overflow-hidden"  url="" id="form1"> 
    <div class="row row-sm mg-t-0">
        <div class="col-sm-8 pd-r-0-force colapprove">
            <div class="br-pagebody bg-white mg-l-20 mg-r-20 ">
                <div class="br-content-box pd-20"> <div class="center"  >
                    <div class="article-title mg-l-15 mg-b-15 pd-r-30" >
                        <div class="row flex-row align-items-center mg-b-15">
                            <label class="left-fn-title wd-120">主题：</label>
                            <label class="wd-content-lable d-flex "><%=item.getTitle()%></label>							
                        </div>
                        <div class="row flex-row align-items-center mg-b-15">
                            <label class="left-fn-title wd-120">姓名：</label>
                            <label class="wd-content-lable d-flex "><%=item.getValue("UserName")%></label>						
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" >
                            <label class="left-fn-title wd-120" >手机号码：</label>
                            <label class="wd-content-lable d-flex " ><%=item.getValue("phone")%></label>						
                        </div>
                        <div class="row flex-row align-items-center mg-b-15">
                            <label class="left-fn-title wd-120">状态：</label>
                            <label class="wd-content-lable d-flex "><%=probstatusDesc%></label>							
                        </div>
                        <div class="row flex-row align-items-center mg-b-15">
                            <label class="left-fn-title wd-120">是否公开：</label>
                            <label class="wd-content-lable d-flex "><%=item.getIntValue("ispublic")==0?"公开":"不公开"%></label>						
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" >
                            <label class="left-fn-title wd-120" >问题类型：</label>
                            <label class="wd-content-lable d-flex " ><%=typeDesc%></label>						
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" >
                            <label class="left-fn-title wd-120" >部门归属：</label>
                            <label class="wd-content-lable d-flex "><%=item.getCategoryID()==0?"":CmsCache.getChannel(item.getCategoryID()).getName()%></label>						
                        </div>
                        <div class="row flex-row align-items-start mg-b-15">
                            <label class="left-fn-title wd-120" id=''>问题描述：</label>
                            <div class="wd-content-div">
                                <p style="white-space: normal;">
    		                        <%=item.getSummary()%>
                                </p>
                            </div>						
                        </div>
                        <%if(evaluation!=0){%>
                        <div class="row flex-row align-items-center mg-b-15" >
                            <label class="left-fn-title wd-120" >用户评价：</label>
                            <label class="wd-content-lable d-flex "><%=evaluationDesc%></label>						
                        </div>
                        <%}%>

                </div><!-- br-mainpanel -->
            </div><!-- br-pagebody -->					
        </div><!-- colapprove -->						
    </div>
</div>
<!-- 操作栏 -->    
<div class="col-sm-4 pd-x-0-force">						
	<div class="br-pagebody mg-l-0 mg-r-30 pd-x-0-force">							
		<div class="bg-white">								
			<div class="card-header bg-transparent d-flex justify-content-between align-items-center">									
				<h6 class="card-title tx-uppercase tx-12 mg-b-0">处理结果</h6>								
			</div>							
		</div>

		<div class="approve_body">
            <div class="card-body bg-white">
<%
TableUtil tu = new TableUtil();
//回复表
String tablename = CmsCache.getChannel(16123).getTableName();

String sql = "select Title,handler,operation,reason,parent,FROM_UNIXTIME(ModifiedDate) as ModifiedDate from "+tablename+" where parent = "+GlobalID+" and active = 1;";
ResultSet rs = tu.executeQuery(sql);
System.out.println("===================================sql2=="+sql);
int i = 0;
while (rs.next()) {
    String Title = convertNull(rs.getString("Title"));
    String handler = convertNull(rs.getString("handler"));
    int operation = rs.getInt("operation");
    String reason = convertNull(rs.getString("reason"));
    String ModifiedDate	= convertNull(rs.getString("ModifiedDate"));
    ModifiedDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",ModifiedDate);
    String operationDesc = "";
    if(operation==1){
        operationDesc="<span>提交</span>";
    }else if(operation==2){
        operationDesc="<span class='tx-danger'>审核未通过</span>";
    }else if(operation==3){
        operationDesc="<span class='tx-success'>转交</span>";
    }else if(operation==4){
        operationDesc="<span class='tx-success'>平台回复</span>";
    }else if(operation==5){
        operationDesc="<span class='tx-danger'>退回</span>";
    }else if(operation==6){
        operationDesc="<span class='tx-success'>开始办理</span>";
    }else if(operation==7){
        operationDesc="<span class='tx-success'>回复</span>";
    }else if(operation==8){
        operationDesc="<span class='tx-success'>结束</span>";
    }else if(operation==9){
        operationDesc="<span>用户回复</span>";
    }
    if(i!=0){
        
%>
                <div class="mg-y-8 pd-l-20 tx-14">
                    <i class="fa fa-ellipsis-v"></i> 
                </div>
    <%}%>
                <div class="mg-y-5 sh-item d-flex justify-content-between align-items-center">
                    <p class="mg-b-0 tx-inverse tx-lato">
                        <span class="mg-r-7"><%=handler%></span><%=operationDesc%>
                    </p>
                    <p class="mg-b-0 tx-sm"><%=ModifiedDate%></p>
                </div>
                
                <%if(reason!=""){%>
                
                <div class="widget rounded_rect hcenter vmiddle" style="left: 930px; top: 509px; z-index: 67; background-color: rgb(222, 226, 230); font-size: 14px; padding: 10px; border-width: 1px; border-style: solid; text-align: left; line-height: 20px; font-weight: normal; font-style: normal; opacity: 1;"><span class="--mb--rich-text" style="font-family:SourceHanSansSC; font-weight:400; font-size:14px; color:rgb(16, 16, 16); font-style:normal; letter-spacing:0px; line-height:20px; text-decoration:none;"><%=reason%></span></div>
                
<%}
i++;
}tu.closeRs(rs);

if(probstatus==1||probstatus==3){
%>
                <!-- <textarea id="approve" class="form-control ht-100 mg-t-10" cols="5" placeholder="驳回理由，如审核通过则不需要输入" user="10" end="0" approveid="30"></textarea> -->
<%}%>                
            </div>
        </div>						
    </div>
</div>
<!-- 操作栏 --> 
</div>
</div>
    <!-- ########## END: MAIN PANEL ########## -->

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>
		<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
 
    <script src="../common/2018/bracket.js"></script>    
  </body>
</html>
