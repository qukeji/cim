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
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico"/>
<title><%=item!=null?"编辑文档 " + item.getTitle():"新建文档"%> <%=channel.getParentChannelPath()%> TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/summernote/summernote-bs4.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">

<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet"  type="text/css" href="../style/jquery.tagit.css" />
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">

<link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
<link rel="stylesheet"  type="text/css" href="../style/timepicker/jquery-ui-timepicker-addon.css" />
<link rel="stylesheet" href="../style/2018/bracket.css"> 

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
	
	 /*自定义*/
.overflow-hidden {overflow: inherit;}
.br-pagebody {margin-top: 85px;}
#form{margin-left: 79px;margin-top: 87px;margin-right: 10px;}
/*#edui1_iframeholder {height:310px !important;}*/
.bg-white{background:none !important;}
#edui1_iframeholder {width: 100% !important;}
.item_left{background:#fff}
.collapsed-menu .br-mainpanel-file {margin-left: 10px;}
#form2 {background: rgb(255, 255, 255);padding-left: 55px;padding-top: 17px;margin-left:0;margin-right: 10px;}
.pd-x-0-force {padding-left: 24px!important;padding-right: 34px!important;}
.item_right{background:#fff}
@media (min-width: 992px).br-mainpanel-file {margin-left: 178px !important;}
.props{margin-left:30px !important;}
#form2 .row.row-sm.mg-t-0 {display:none}
.component{margin-left:220px !important;}
/*.con-t {padding:20px;border-left: 20px solid #e9ecef;}*/
.mg-b-15 {margin-left:30px}
.item_right .mg-b-15 {margin-left: 20px;}
.col-sm-4 .pd-x-0-force{background:#fff}
.col-sm-4 {background:#fff}
.pd-x-0-force {padding-left: 8px!important; padding-right: 8px!important;}
.br-pagebody {margin-top: 20px;}
.col-sm-4.pd-x-0-force{border-right: 20px solid #e9ecef;border-left: 20px solid #e9ecef;}
#col-sm-4{overflow-y:auto}
/*滚动条样式美化*/
#col-sm-4::-webkit-scrollbar {width:9px;height:9px;}
#col-sm-4::-webkit-scrollbar-track {width: 6px;background-color:#fff;-webkit-border-radius: 2em;-moz-border-radius: 2em;border-radius:2em;}
#col-sm-4::-webkit-scrollbar-thumb {background-color:#ccc;background-clip:padding-box;min-height:28px;-webkit-border-radius: 2em;-moz-border-radius: 2em;border-radius:2em;}
/*滚动条移上去的背景*/
#col-sm-4::-webkit-scrollbar-thumb:hover {background-color:#e9ecef;}
.ds_tr{display:none}
#form2 .row.row-sm.mg-t-0,#form3 .row.row-sm.mg-t-0,#form4 .row.row-sm.mg-t-0,#form5 .row.row-sm.mg-t-0,#form6 .row.row-sm.mg-t-0,#form7 .row.row-sm.mg-t-0,#form8 .row.row-sm.mg-t-0 {display:none}
.bg-gray-400{background:none}
.con {display: flex;flex-flow:row wrap;justify-content:left;align-items:center;}
.con>div {width: 80px;height: 100px;text-align: left;line-height:40px;}
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
var unload = true ;//关闭页面是否提示
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
</script>

<script>

function Save_approve()
{
	document.form.Approve.value = 1;
	Save();
}

function Save()
{ 
 
	if(check())
	{
	//有内容拦的情况下，保存前先处理内容栏
	if(document.getElementById("tabTableRow"))

      
		Save_Content();
		
	
	document.getElementById("Image1Href").href = "javascript:void(0);";
	<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
		document.getElementById("Image2Href").href = "javascript:void(0);";
	<%}%>

	if(is_auto_save)
	{
		document.getElementById("Image1Href").href = "javascript:void(0);";
		<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
			document.getElementById("Image2Href").href = "javascript:void(0);";
		<%}%>
	}
	 
	var _form_data = $("#form").serialize();
	if(form_data == _form_data && is_auto_save)// 自动保存 数据没有变化时不进行数据提交
	{  
		// $("#display_auto_save").removeClass("auto_save_hide").addClass("auto_save").text("数据没有变化"+getNowFormatDate());
		return ;
	}
	//如果有数据变化 把新的表单值赋值给form_data
	form_data =_form_data ;
	//编辑互斥
	isSaved();
	$("#display_auto_save").removeClass("auto_save_hide").addClass("auto_save").text("正在保存"+getNowFormatDate());
	$.ajax({
         type: "POST",
         url:"../content/document_submit.jsp",
         data:$('#form').serialize(),
		 dataType:'json',
         success: function(result) 
     
		 {
		
			if(!is_auto_save)
			{//非自动保存
				if(result.message=="")
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
				 }else{
					if(result.message=="auto save")
					{
					}
					else
					{
						ddalert(result.message,"(function dd(){getDialog().Close({suffix:'html'});})()");
						//alert(result.message);
					}
					document.getElementById("Image1Href").href = "javascript:Save();";
					<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
					document.getElementById("Image2Href").href = "javascript:Save_Publish();";
					<%}%>
				 } 
			}
			else
			{
				//自动保存刷新页面
				//window.location.href="document.jsp?NoCloseWindow=1&ItemID=" + result.id+ "&ChannelID="+result.channelid
				document.form.NoCloseWindow.value = '1';
				document.form.Action.value='Update';
				document.form.ItemID.value=result.id;

				document.getElementById("Image1Href").href = "javascript:Save();";
				<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
					document.getElementById("Image2Href").href = "javascript:Save_Publish();";
				<%}%>
                            
                         
			}
			$("#display_auto_save") .addClass("auto_save").text("保存完成"+getNowFormatDate());
		  // $("#display_auto_save").removeClass("auto_save").addClass("auto_save_hide");   
	    },
		error: function (XMLHttpRequest, textStatus, errorThrown) 
		{ 
			alert("保存没有成功，请重新尝试。");			
			document.getElementById("Image1Href").href = "javascript:Save();";
			<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
			document.getElementById("Image2Href").href = "javascript:Save_Publish();";
			<%}%>
		} 
     });

	
	}
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

<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="form" action="../content/document_submit.jsp" method="post" id = "form">
<div class="br-logo"><img src="../images/2018/system-logo.png"></div>
<div class="br-sideleft overflow-y-auto ps ps--theme_default">
     
	<label class="sidebar-label pd-x-15 mg-t-20" ></label>
<%
int vercount = (!QRcode.equals(""))?fieldGroupArray.size()+2:fieldGroupArray.size()+1;
if(Version==1){
%>
	<div class="br-sideleft-menu">
		<a href="javascript:showTab('<%=vercount%>')" class="br-menu-link" id="form<%=vercount%>_td" data-toggle="tooltip" data-placement="right" title="历史版本">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-edit tx-22"></i>
				<span class="menu-item-label">历史版本</span>
			</div><!-- menu-item -->
		</a><!-- br-menu-link -->
	</div><!-- br-sideleft-menu -->
<%}%>
</div><!-- br-sideleft -->  
 <div class="br-header">
	<div class="br-header-left">
		<div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href="#"><i class="icon ion-navicon-round"></i></a></div>
		<div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
		<div id="nav-header" class="hidden-md-down flex-row align-items-center">
			<%=channel.getParentChannelPath().replaceAll(">"," / ")%>
		</div>
	</div><!-- br-header-left -->
	<div class="br-header-right">
		<div class="btn-box" >
		<%if(ApproveScheme==0||(action==1||id_aa==0)){%>
			<a class="btn btn-primary tx-size-xs mg-r-5" href="javascript:Save();" id="Image1Href">保存</a>
			<%if(ApproveScheme!=0){%>
				<a class="btn btn-secondary tx-size-xs mg-r-5" id="Image2Href" href="javascript:Save_approve();">提交审核</a>
			<%}else{
				if(cp.hasRight(userinfo_session,ChannelID,3)){%>
					<a class="btn btn-secondary tx-size-xs mg-r-5" id="Image2Href" href="javascript:Save_Publish();">保存并发布</a>
			<%}}}else{%>
			   	<a class="btn btn-secondary tx-size-xs mg-r-5" href="">本地预览</button>
				<a class="btn btn-secondary tx-size-xs mg-r-5" href="javascript:SaveApprove(1);" id="Image1Href">驳回</button>
				<a class="btn btn-secondary tx-size-xs mg-r-5" href="javascript:SaveApprove(0);" id="Image2Href">通过</button>
			<%}%>
			<a class="btn btn-secondary tx-size-xs mg-r-10" href="javascript:self.close();">关闭</a>	
		</div>
	</div><!-- br-header-right -->
</div><!-- br-header -->
<!--	<div class="br-pagebody bg-white mg-l-20 mg-r-20">
		<div class="br-content-box pd-20">   -->
<%
int j = 0;
%>

<%if(!QRcode.equals("")){%>
<div class="br-mainpanel br-mainpanel-file overflow-hidden" <%if(j!=0){%>style="display:none;"<%}%> id="form<%=fieldGroupArray.size()+1%>">
<div class="br-pagebody bg-white mg-l-20 mg-r-20">
		<div class="br-content-box pd-20">
<!--标签组-->
<div class="center" url="">  
	<div class="article-title mg-l-15 mg-b-15 pd-r-30">
		<div class="row flex-row align-items-center">                   		  	  	
		  <label class="left-fn-title wd-150 ">二维码分享功能：</label>
		  <label class="wd-content-lable d-flex">
			<div><img src="<%=QRcode%>"></div>
			<div>二维码标签分享功能</div>
			<div>左侧的二维码是本内容是由移动终端分享地址生成。<br>通过手机、PAD客户端或微信“扫一扫”功能拍摄扫描二维码实现移动设备的内容浏览，并可以通过分享工具分享给移动设备用户。<br>也可以将本二维码发布到网页中，实现基于网页的二维码拍摄分享功能。</div>
		  </label>									            
		</div>
	</div>
	<div class="article-title mg-l-15 mg-b-15 pd-r-30">
		<div class="row flex-row align-items-center">                   		  	  	
		  <label class="left-fn-title wd-150 ">二维码图片地址：</label>
		  <label class="wd-content-lable d-flex"><%=QRcode%></label>									            
		</div>
	</div>
</div> 
<%}%>
</div>
</div>
</div>

<input type="hidden" name="From" value="<%=From%>">
<input type="hidden" name="Action" value="Add">
<input type="hidden" name="Content" value="">
<input type="hidden" id="ItemID" name="ItemID" value="<%=ItemID%>">
<%if(!editCategory){%><input type="hidden" name="ChannelID" value="<%=ChannelID%>"><%}%>
<input type="hidden" name="Status" value="0">
<input type="hidden" name="Approve" value="0">
<input type="hidden" id="GlobalID" name="GlobalID" value="<%=GlobalID%>">
<input type="hidden" name="ParentGlobalID" value="<%=parentGlobalID%>">
<input type="hidden" name="RelatedItemsList" value="">
<input type="hidden" name="Page" value="1">
<input type="hidden" id="RecommendGlobalID" name="RecommendGlobalID" value="0">
<input type="hidden" name="RecommendChannelID" value="0">
<input type="hidden" name="RecommendItemID" value="0">
<input type="hidden" name="NoCloseWindow" id="NoCloseWindow" value="0">
<input type="hidden" name="ContinueNewDocument" value="<%=ContinueNewDocument%>">
<input type="hidden" id="RecommendType" name="RecommendType" value="0"><div id="ajax_script" style="display:none;"></div>
</form>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<%if(channel.getDocumentJS().length()>0){out.println("<script>");out.println(channel.getDocumentJS());out.println("</script>");}%>
<script type="text/javascript">
var form_data = $("#form").serialize();//获取表单数据
<%if(Parent>0){
out.println("setValue('Parent',"+Parent+");");
}%>
</script>

<!--兼容性提示弹窗-->
<div class="editorTipsModal modal" id="editorTipsModal" >
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close">×</button>
				<h4 class="modal-title" id="myModalLabel">系统提示</h4>
			</div>
			<div class="modal-body">
				<p>系统检测到您正在使用低版本浏览器，为保证您的正常使用，请升级浏览器到最新版本。</p>
				<p>推荐使用浏览器：谷歌浏览器，其他浏览器及版本：360浏览器最新版、IE9及以上版本。</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default btn-close" data-dismiss="modal">关闭</button>				
			</div>
		</div>
	</div>
</div>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../lib/2018/medium-editor/medium-editor.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script type="text/javascript" src="../common/jquery-ui-timepicker-addon.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>
var groupnum=<%=vercount%>;
  $(function(){
	'use strict';

		//show only the icons and hide left menu label by default
		$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
		
		$('.br-mailbox-list,.br-subleft').perfectScrollbar();

		$('#showMailBoxLeft').on('click', function(e){
			e.preventDefault();
			if($('body').hasClass('show-mb-left')) {
			$('body').removeClass('show-mb-left');
			$(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
			} else {
			$('body').addClass('show-mb-left');
			$(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
			}
		});
		
		$('.br-sideleft [data-toggle="tooltip"]').tooltip({
			shadowColor:"#ffffff",
			textColor:"000000",
			trigger:"hover"
		});
  });

</script>

<script>
	//h5编辑器相关
	var everLoadH5 = false ;
	$("#tr_changeEditor input[name='editortype']").click(function(){
		var val = $(this).val();
		if(val==0){
			$("#tr_h5Editor").hide();
			$("#tr_Content").show();
			setContent(h5_getContent());
			h5_setContent("");
		}else{
			if(!everLoadH5){
				var _html = '<iframe id="h5editor1_Frame" src="../h5/index.html?webname=${pageContext.request.contextPath}" width="100%" height="800" frameborder="0" scrolling="no" onload="inserBdContent()" ></iframe>' ;
				$("#tr_Content").hide();
				$("#tr_h5Editor").html(_html).show();				
				everLoadH5 = true ;
			}else{
				$("#tr_h5Editor").show();
				$("#tr_Content").hide();
				h5_setContent(getContent());
				setContent("");
			}
//			var h5ue = document.getElementById("h5editor1_Frame").contentWindow.WXBEditor
//			h5ue.ready(function() {
//			   h5_insertContent(getContent());
//			});
		}
	})
	var Parameter = "&ChannelID=" + ChannelID;
		//审核预览
	function approve_preview(versionid)
	{
		window.open("../content/preview_version.jsp?vid="+versionid+"&ItemID=" + <%=ItemID%> + Parameter);
	}
	function returnVersion(id){
	    $.ajax({
	        url:"version_data.jsp?id="+id,
	        dataType:"json",
	        success:function(data){
	            $("#Title").val(data.Title);
	            var currcontent = (data.Content).replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;
	            setContent(currcontent,"");
	            $("#Summary").val(data.Summary);
	            tipVersion(data.Title);
	        }
	    });
	}
	function tipVersion(title){
	    window.alert(title+"版本内容已恢复，请返回内容编辑");
	}
	function inserBdContent(){
		var _interval = setInterval(function(){
			try
			   {
			     var h5ue = document.getElementById("h5editor1_Frame").contentWindow.WXBEditor ;
			     if(h5ue){
			     	h5ue.ready(function() {
				   		h5_setContent(getContent());
						setContent("");
	 			    });
	 			    clearInterval(_interval)
			     }else{
			     	return ;
			     }
			   }
			 catch(err)
			   {			  
			   }
		},50)
	}
	//获得h5编辑器内容
	function h5_getContent(){
		var content = document.getElementById("h5editor1_Frame").contentWindow.getUecontent();
		return content;		
	}	
	//h5编辑器写入内容
	function h5_setContent(insertContent,b){
		document.getElementById("h5editor1_Frame").contentWindow.setCurrentContent(insertContent,true);
	}
	//h5编辑器插入内容
	function h5_insertContent(insertContent,b){
		document.getElementById("h5editor1_Frame").contentWindow.setInsertContent(insertContent,true);
	}
$(function() {
	//判断是否为ie8及以下浏览器
	var DEFAULT_VERSION = 8.0;
	var _ua = navigator.userAgent.toLowerCase();
	var _isIE = _ua.indexOf("msie")>-1;
	var browserVersion;
	if(_isIE){
		browserVersion =  _ua.match(/msie ([\d.]+)/)[1];
	}
	if(browserVersion <= DEFAULT_VERSION ){
		$('#editorTipsModal').show().css("opacity",1)
	};   
    $(".editorTipsModal .btn-close,.editorTipsModal button.close").click(function(){
    	$('#editorTipsModal').hide().css("opacity",0)
    })
});
</script>
</body>
</html>
<script>
 
 

       
   //tab栏目的折叠方法:
    $('#btnLeftMenu').on('click', function(){
   
    var menuText = $('.menu-item-label,.menu-item-arrow');
    
    if($('body').hasClass('collapsed-menu')) {
      $('body').removeClass('collapsed-menu');
      // show current sub menu when reverting back from collapsed menu
      $("#form").addClass('props')
      $("#form2").addClass('component')
      $('.show-sub + .br-menu-sub').slideDown();
      $("#system-menu").slideDown();
      $('.br-sideleft').one('transitionend', function(e) {
        menuText.removeClass('op-lg-0-force');
        menuText.removeClass('d-lg-none');
        menuText.css({
	          "display":"block",
	          "opacity":"1"
	      })
      });			

    } else {
      $('body').addClass('collapsed-menu');
        $("#form").removeClass('props')
         $("#form2").removeClass('component')
      $('.show-sub + .br-menu-sub').slideUp();
      
      menuText.addClass('op-lg-0-force');
      $('.br-sideleft').one('transitionend', function(e) {
        menuText.addClass('d-lg-none');
      });			
    }
    return false;
  });  
  
 
 //点击当前的高亮显示其他的不高亮
     $("body").on('click','.br-sideleft-menu',function(){
     $(this).children("a").addClass("active")
     $(this).siblings().children("a").removeClass("active")
 })
  

 
   login()
  
     
        
    function login(){
    const   ItemID =  $("#ItemID").val()
     console.log(GlobalID)
 
    //发送请求数据：
            $.ajax({  
                    type : 'get',  
                    url:'/cms/content/field_json.jsp?ItemID='+ItemID+'&ChannelID='+ChannelID,
                    dataType:"jsonp", 
                    jsonp:"callback",
                    success :function(data) {
                              console.log(data)
                            //生成tab栏和主体结构：
                          for(var i = 0;i < data.form.length;i++){
                              tabSection(data.form[i].id,data.form[i].name,data.form[i].name,'.sidebar-label.pd-x-15.mg-t-20',i+1)
                          }
                          //内容返回判断：
                          $.each(data, function(i, item){
                             //内容编辑:
                             for(var i = 0; i<item[0].fields.length; i++){
                                  //标题：
                                   if(item[0].fields[i].name == 'Content'){
                                           //页面内容：
                                          showEditer1.init('#form1 .row.row-sm.mg-t-0 .item_left',data.form[0].fields[i].value,data.form[0].fields[i].channelID)
                                  }else  if(item[0].fields[i].name == 'Title'){ 
                                        //标题
                                          conetntTitle(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right',data.form[0].fields[i].fieldTypeDesc)
                                  }else if(item[0].fields[i].name == 'SubTitle'){
                                          //副标题：
                                         propsTitel(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                  }else if(item[0].fields[i].name=='PublishDate'){
                                         //时间日期：
                                       PublishDate(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right') 
                                  }else if(item[0].fields[i].name=='DocFrom'){
                                         //来源
                                      DocFrom(item[0].fields[i].description,item[0].fields[i].value,data.form[0].fields[i].fieldTypeDesc,'#form1 .item_right')
                                  }else if(item[0].fields[i].name=='Weight'){
                                          //权重：
                                      Weight(item[0].fields[i].description,item[0].fields[i].value,data.form[0].fields[i].fieldTypeDesc,'#form1 .item_right')
                                  }else if(item[0].fields[i].name=='Summary'){
                                        //摘要：
                                       Summary(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                  }else if(item[0].fields[i].name=='SetPublishDate'){
                                   //定时发布：
                                   SetPublishDate(item[0].fields[i].description,item[0].fields[i].value,data.form[0].fields[i].fieldTypeDesc,'#form1 .item_right')
                                 }else if(item[0].fields[i].name=='IsPhotoNews'){
                                  //图片新闻:
                                   IsPhotoNews(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                 }else if(item[0].fields[i].name=='Photo'){
                                  //图片:
                                  Photo(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right',item[0].fields[i].name)
                                  //关键字
                                 }else if(item[0].fields[i].name =='Keyword'){
                                   Keyword(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right',item[0].fields[i].name)
                                   $("ul.tagit").css('width','350px')
                                 }else if(item[0].fields[i].name=='item_type'){
                                  //列表展现形式
                                   list(item[0].fields[i].description,item[0].fields[i].fieldOptions,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='content_type'){
                                    //自定义内容标识:
                                    content_type(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='doc_type'){
                                    //客户端标识
                                    doc_type(item[0].fields[i].description,item[0].fields[i].fieldOptions,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='showbuttontitle'){
                                    //是否隐藏按钮组标题:
                                    showbuttontitle(item[0].fields[i].description,item[0].fields[i].fieldOptions,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='anuor'){
                                    //是否隐藏按钮组标题:
                                     anuor(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='isAudio'){
                                    //是否保存为音频：
                                    isAudio(item[0].fields[i].description,item[0].fields[i].fieldOptions,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name== 'videoid'){
                                    //视频编号：
                                    videoid(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name== 'mediatype'){
                                    //视频类型:
                                    mediatype(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name== 'epgchannelid'){
                                    //节目单频道编号:
                                   epgchannelid(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name ==  'href_app'){
                                  //链接地址：
                                    href_app(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'Photo4'){
                                    //大图轮播：
                                    Photo4(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'Photo2'){
                                    //列表封面图2：
                                    Photo2(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'Photo3'){
                                     //列表封面图3：
                                     Photo3(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'videourl'){
                                    //直播点播地址：
                                     videourl(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'td_liveid'){
                                    //泰德直播后台编号：
                                    td_liveid(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'juxian_liveid'){
                                    //聚现企业id
                                    juxian_liveid(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'secondcategory'){
                                    //二级栏目编号：
                                   secondcategory(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'jumptype'){
                                    //跳转类型显示：
                                     jumptype(item[0].fields[i].description,item[0].fields[i].fieldOptions,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'frame'){
                                    //客户端一级栏目：
                                    frame(item[0].fields[i].description,item[0].fields[i].fieldOptions,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'pv_virtual'){
                                    //虚拟浏览量
                                     pv_virtual(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'pv'){
                                    //实际文章浏览量：
                                     pv(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'allowcomment'){
                                    //评论开关：
                                  allowcomment(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'showread'){
                                    //阅读量开关：
                                   showread(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'allowadvert'){
                                    //广告开关
                                   allowadvert(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'zan_virtual_num'){
                                    //虚拟点赞量
                                   zanvirtualnum(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name == 'baoliaostatus'){
                                    //爆料审核状态:
                                    baoliaostatus(item[0].fields[i].description,item[0].fields[i].fieldOptions,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='baoliao_ispublic'){
                                    //爆料是否公开：
                                      baoliao_ispublic(item[0].fields[i].description,item[0].fields[i].fieldOptions,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='baoliao_localtion'){
                                    //爆料人位置：
                                    baoliao_localtion(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='jd'){
                                    //经度：
                                    jd(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='wd'){
                                    //纬度：
                                   wd(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }else if(item[0].fields[i].name=='baoliao_userid'){
                                    //爆料提交用户编号：
                                     baoliao_userid(item[0].fields[i].description,item[0].fields[i].value,'#form1 .item_right')
                                }
                             }
                             //基本属性：
                             for(var i = 0; i<item[1].fields.length; i++){
                              console.log(item[1].fields[i].name)
                                   //时间日期：
                              if(item[1].fields[i].name=='PublishDate'){
                            
                                  PublishDate(item[1].fields[i].description,item[1].fields[i].value,'#form2') 
                              }else if(item[1].fields[i].name=='Weight'){
                                  //权重：
                                  Weight(item[1].fields[i].description,item[1].fields[i].value,data.form[1].fields[i].fieldTypeDesc,'#form2')
                              }else if(item[1].fields[i].name=='DocFrom'){
                                  //来源：
                                   DocFrom(item[1].fields[i].description,item[1].fields[i].value,data.form[1].fields[i].fieldTypeDesc,'#form2')
                              }else if(item[1].fields[i].name=='Summary'){
                                   //摘要：
                                   Summary(item[1].fields[i].description,item[1].fields[i].value,'#form2')
                              }else if(item[1].fields[i].name=='SetPublishDate'){
                                   //定时发布：
                                   SetPublishDate(item[1].fields[i].description,item[1].fields[i].value,'#form2')
                              }else if(item[1].fields[i].name=='IsPhotoNews'){
                                  //图片新闻:
                                   IsPhotoNews(item[1].fields[i].description,item[1].fields[i].value,'#form2')
                              }else if(item[1].fields[i].name=='Photo'){
                                  //图片:
                                  Photo(item[1].fields[i].description,item[1].fields[i].value,'#form2',item[1].fields[i].name)
                              }else if(item[1].fields[i].name =='Keyword'){
                                 // 关键字
                                   Keyword(item[1].fields[i].description,item[1].fields[i].value,'#form2',item[1].fields[i].name)
                              }else if(item[1].fields[i].name=='item_type'){
                                  //列表展现形式
                                   list(item[1].fields[i].description,item[1].fields[i].fieldOptions,'#form2')
                              }else if(item[1].fields[i].name=='content_type'){
                                    //自定义内容标识:
                                    content_type(item[1].fields[i].description,item[1].fields[i].value,'#form2')
                                }
                             }
                             
                          });
                        
                       }
                             
                     })
  
  
  
  
  
  
  
 //生成结构 和 页面内容
 function tabSection(groupid,originalTitle,tabCon,main,i){
 //tab栏：
      str = ''
	  str+='<div class="br-sideleft-menu">'
	     +'<a href="#" class="br-menu-link " id="form'+(i)+'_td" groupid="'+groupid+'" data-toggle="tooltip" data-placement="right" title="" data-original-title="'+originalTitle+'" >'
	     +'<div class="br-menu-item">'
	     +'<i class="menu-item-icon fa fa-edit tx-22">'+'</i>'
		 +'<span class="menu-item-label op-lg-0-force d-lg-none">'+tabCon+'</span>'
		 +'</div>'
	     +'</div>'
	    $(main).before(str)
	    $("#form1_td").addClass('active')
	    $("#form1_td").addClass('mg-t-20')
  
 //结构栏:
      Html = ''
       +'<div class="br-mainpanel br-mainpanel-file overflow-hidden" id="form'+(i)+'"  data-approve="0" data-yl="0" style="">'
       +'<div class="row row-sm mg-t-0" style="">'
       +'<div  class="col-sm-8 pd-r-0-force colapprove item_left" id="item_left">'
       +'</div>'
       +'<div class="col-sm-4 pd-x-0-force" id="col-sm-4">'
       +'<div class="br-pagebody mg-l-0 mg-r-30 pd-x-0-force">'
       +'<div class="item_right">'
       +'</div>'
       +'</div>'
       +'</div>'
       +'</div>'
       +'</div>'
      
    
		      $('body form').append(Html)
		      //获取当前窗口大小:
              document.getElementById('item_left').style.height= (window.screen.availHeight/1-190)+"px";
              document.getElementById('col-sm-4').style.height= (window.screen.availHeight/1-190)+"px";
              $(".item_right").addClass('con-t')
              
		    //tab栏点击和内容结构对应:
		     $('#form1').show()
		     $('#form2').hide()
             $("body").on('click','.br-sideleft-menu',function() {
             $("body  .br-sideleft-menu").eq($(this).index()).addClass("cur").siblings().removeClass('cur');
             $("body .br-mainpanel.br-mainpanel-file.overflow-hidden").hide().eq($(this).index()).show();
           
        
     });
         
 }


 
 // 标题:
function conetntTitle(list,org,main,holder){
        var   s = ""
              s+='<div class="row flex-row align-items-center mg-b-15" id="tr_Title" style>' 
              +'<div class="d-flex">'
              +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="tr_Title">'+list+'</div>'
			  +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20" id="field_Title">'
			  +'<input class="form-control" placeholder="'+holder+'" type="text" id="Title" name="Title"  value="'+org+'" onkeyup="checkTitle();" >'
			  +'</div>'
			 +'<div class="d-flex align-items-center justify-content-center wd-5 ht-70 bg-gray-400 mg-l-20">'
			  +'<span id="TitleCount" class="mg-l-10">'+'</span>'
			  +'</div>'
             +'</div>'
              +'</div>'
        
        $(main).append(s)
        //监测当前字符长度并且实时监测字符长度
        var txt = document.getElementById("Title");
        var txtNum = document.getElementById("TitleCount");
        txtNum.textContent = txt.value.length; 
        txt.addEventListener("keyup", function(){
        txtNum.textContent = txt.value.length; 
    })
         
}
//副标题
function propsTitel(list,value,main){
        var  s = ""
           s+='<div class="row flex-row align-items-center mg-b-15" id="tr_SubTitle">'
          +'<div class="d-flex">'
           +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="tr_Title">'+list+'</div>'
           +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_SubTitle" >'
           +'<input type="text" class="textfield form-control"  name="SubTitle" id="SubTitle" value="'+value+'">' 
           +'</div>'
           +'</div>'
           +'</div>'
       $(main).append(s)
         
}
  //生成内容编辑器showEditer结构
function showEditer(main,content,id) {

        var s = ""
          s+='<div class="row flex-row align-items-center mg-b-15 edit" id="tr_Content"  style="margin-left:-24px !important">'  
           +'<input type="hidden" id="baiduEditor1" name="baiduEditor1" value="" style="display:none" />'
           +'<scrip"+"t id="editor" type="text/plain" style="width: 100%;position: relative;top: 22px;left: -25px;border: 10px solid rgb(255, 255, 255)";>'+'</scrip+"t"+>'
           +'<table id="tabTable" CELLPADDING=0 CELLSPACING=0 class="table table-bordered mg-b-0" style="width: 100%;position: absolute;bottom: -33px;z-index: 99999;">'
           +'<tr id="tabTableRow" onclick="changeTabs()">'
           +'<td id="t1" class="selTab" page="1" height="20">'+'第一页'+'</td>'
           +'</tr>'
           +'</table>'
           +'<input type="button" value="删除当前页" onclick="DeletePage();" class="btn btn-primary tx-size-xs mg-r-10 mg-t-10" style="position: absolute;bottom: -77px;z-index: 9999;left: 0;">'
           +'<input type="button" value="插入一页" onclick="AddPage();" class="btn btn-primary tx-size-xs mg-r-10 mg-t-10" style="position: absolute;bottom: -77px;z-index: 9999;left: 100px;">'
           +'</div>'
        
          $(main).append(s)
        
      var content =  content 
      console.info('写入内容')
      console.info(content)
      var str = ""
        str+='<scr' + 'ipt>'
        var currcontent = "";
        currcontent = content
        currcontent = currcontent.replace(/src=\"\//g, 'src=\"http://jushi-yanshi.tidemedia.com\/' ) ;
        $("#baiduEditor1").val(currcontent);
        var ChannelID=id;
        var ue = UE.getEditor('editor');
        ue.ready(function() {
        UE.getEditor('editor').setHeight(300)
        setContent(currcontent,false);
         
      });
    //获得内容
       function getContent() {
        var content = ue.getContent() ;
        content = content.replace(/(<img class="tide_video_fake".*?)>/gi,"");
        content = content.replace(/(<img class="tide_photo_fake".*?)>/gi,"");
        return content;
    }  
   
    //写入内容
    function setContent(content,isAppendTo){
        var img = "<img class=\"tide_video_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
        var img1 = "<img class=\"tide_photo_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
        
        content = content.replace(/(<span id="tide_video">(.+?)<\/span>)/gi,"$1"+img);
        content = content.replace(/(<span id="tide_photo">(.+?)<\/span>)/gi,"$1"+img1);
        ue.setContent(content,isAppendTo);
    }
    //获得纯文本
    function getContentTxt(){
        return ue.getContentTxt();
    }
    //返回当前编辑器对象
    function getUE(){
        return ue;
    }
    
    
    
    
   // +'</scr' + 'ipt>'
}

 
}

 //生成内容编辑器结构
var showEditer1 = {
    init : function(main,content,id){
        var s = "" ;
          s+='<div class="row flex-row align-items-center mg-b-15 edit" id="tr_Content"  style="margin-left:24px !important">'  
           +'<input type="hidden" id="baiduEditor1" name="baiduEditor1"  style="display:none" />'
           +'<scrip"+"t id="editor" type="text/plain" style="width: 100%;position: relative;top: 22px;left: -25px;border: 10px solid #fff>'+'</scrip+"t"+>'
           +'<table id="tabTable" CELLPADDING=0 CELLSPACING=0 class="table table-bordered mg-b-0" style="width: 100%;position: absolute;bottom: -33px;z-index: 999;">'
           +'<tr id="tabTableRow" onclick="changeTabs()">'
           +'<td id="t1" class="selTab" page="1" height="20">'+'第一页'+'</td>'
           +'</tr>'
           +'</table>'
           +'<input type="button" value="删除当前页" onclick="DeletePage();" class="btn btn-primary tx-size-xs mg-r-10 mg-t-10" style="position: absolute;bottom: -77px;z-index: 999;left: 0;">'
           +'<input type="button" value="插入一页" onclick="AddPage();" class="btn btn-primary tx-size-xs mg-r-10 mg-t-10" style="position: absolute;bottom: -77px;z-index: 999;left: 100px;">'
           +'</div>'
        
        $(main).append(s)
        
          var content =  content 
          console.info('写入内容')
          console.info(content)
          var str = ""
            str+='<scr' + 'ipt>'
            var currcontent = "";
            currcontent = content
            currcontent = currcontent.replace(/src=\"\//g, 'src=\"http://jushi-yanshi.tidemedia.com\/' ) ;
            $("#baiduEditor1").val(currcontent);
            
            var ChannelID=id;
            window.ue = UE.getEditor('editor');
            ue.ready(function() {
                UE.getEditor('editor').setHeight(600)
                showEditer1.setContent(currcontent,false);
            });
            
    },
    setContent : function(content,isAppendTo){
        var img = "<img class=\"tide_video_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
        var img1 = "<img class=\"tide_photo_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
        
        content = content.replace(/(<span id="tide_video">(.+?)<\/span>)/gi,"$1"+img);
        content = content.replace(/(<span id="tide_photo">(.+?)<\/span>)/gi,"$1"+img1);
        //当前编辑器高度自适应
        document.getElementById('edui1_iframeholder').style.height= (window.screen.availHeight/1-420)+"px";
        ue.setContent(content,isAppendTo);
    },
    getContent: function(){
        var content = ue.getContent() ;
        content = content.replace(/(<img class="tide_video_fake".*?)>/gi,"");
        content = content.replace(/(<img class="tide_photo_fake".*?)>/gi,"");
        return content;
    },
    getContentTxt : function(){
        return ue.getContentTxt();
    },
    getUE : function(){
        return ue; 
    }
    
    
}
function showEditer(main,content,id) {

        
    //获得内容
       function getContent() {
        var content = ue.getContent() ;
        content = content.replace(/(<img class="tide_video_fake".*?)>/gi,"");
        content = content.replace(/(<img class="tide_photo_fake".*?)>/gi,"");
        return content;
    }  
   
    //写入内容
    function setContent(content,isAppendTo){
        var img = "<img class=\"tide_video_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
        var img1 = "<img class=\"tide_photo_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
        
        content = content.replace(/(<span id="tide_video">(.+?)<\/span>)/gi,"$1"+img);
        content = content.replace(/(<span id="tide_photo">(.+?)<\/span>)/gi,"$1"+img1);
        ue.setContent(content,isAppendTo);
    }
    //获得纯文本
    function getContentTxt(){
        return ue.getContentTxt();
    }
    //返回当前编辑器对象
    function getUE(){
        return ue;
    }
 
    +'</scr' + 'ipt>'
}

 



//时间日期格式
function  PublishDate(description,value,main){
       //时间戳日期转换：
     //时间戳转换
   //function timestampToTime(timestamp) {
      //  var date = new Date(timestamp * 1000);
       // var Y = date.getFullYear() + '-';
      //  var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
      //  var D = date.getDate() + ' ';
       // var h = date.getHours() + ':';
       // var m = date.getMinutes() + ':';
       // var s = date.getSeconds();
       // return Y+M+D+h+m+s;
    //}
 //var  time =    timestampToTime(value);

    var str = ''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_PublishDate">'
	    +'<label class="left-fn-title wd-150 ">'+description+'</label>'
	    +'<label class="">'
	    +'<input type="text" name="PublishDate" id="PublishDate" value="'+getNowFormatDate()+'"    class="textfield date form-control hasDatepicker" size="24">'
        +'</label>'
	    +'</div>'
	    $(main).append(str)
}

//权重
function Weight(description,value,holder,main){
   var str = ''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_PublishDate">'
	    +'<label class="left-fn-title wd-150 ">'+description+'</label>'
	    +'<label class="">'
	    +'<input type="text" name="Weight" id="Weight" value="'+value+'"  placeholder="'+holder+'"   class="textfield date form-control hasDatepicker" size="24">'
        +'</label>'
	    +'</div>'
	    $(main).append(str) 
}
//文章来源
function   DocFrom(description,value,holder,main){
      var str = ''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_PublishDate">'
	    +'<label class="left-fn-title wd-150 ">'+description+'</label>'
	    +'<label class="">'
	    +'<input type="text" name="DocFrom" id="DocFrom" value="'+value+'"  placeholder="'+holder+'"   class="textfield date form-control hasDatepicker" size="92">'
        +'</label>'
	    +'</div>'
	    $(main).append(str) 

}
//摘要：
function Summary(description,value,main){
   var str = ''
       str+='<div class="row flex-row align-items-center mg-b-15" id="tr_Summary">'
       +'<label class="left-fn-title wd-150" id="desc_Summary">'+description+'</label>'
       +'<label class="wd-content-lable d-flex " id="field_Summary">'
       +'<textarea cols="92" class="textfield form-control" rows="5" name="Summary"  id="Summary"   >'+value+'</textarea>'
       +'</label>'
       +'</div>'
       $(main).append(str) 
}
//定时发布：
function  SetPublishDate(list,value,main){
    var str = ''
            
       str+='<div class="row flex-row align-items-center mg-b-15" id="tr_SetPublishDate">'
        +'<label class="left-fn-title wd-150" id="desc_SetPublishDate">'+list+'</label>'
        +'<label class="wd-content-lable d-flex " id="field_SetPublishDate">'
        +'<input type="text" class="textfield form-control" size="80" name="SetPublishDate" id="SetPublishDate" value="'+value+'">'
        +'</label>'+'</div>'
	    $(main).append(str)  
 }
//图片新闻
function IsPhotoNews(description,value,main){
    var str =''
    str+='<div class="row flex-row align-items-center mg-b-15" id="tr_IsPhotoNews" >'
       +'<label class="left-fn-title wd-150" id="desc_IsPhotoNews">'+description+'</label>'+'<label class="wd-content-ckx d-flex " id="field_IsPhotoNews">'+'<label class="ckbox">'
       +'<input type="checkbox"  value="'+value+'" name="IsPhotoNews" id="IsPhotoNews">'+'<span>'+'</span>'+'</label>'
       +'</label>'+'</div>'
        $(main).append(str)  
        var  val =  $("#IsPhotoNews").val()
        if(val == 1){
           $("#IsPhotoNews").attr("checked","")
        }else{ }
        //点击改变是否是新闻:
        $("#IsPhotoNews").click(function () {
        if ($(this).prop("checked")) {         
           $("#IsPhotoNews").val(1)   } 
        else {
         $("#IsPhotoNews").val(0)  
        }
           });
}
//图片
function Photo(description,value,main,list){

    var str =''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_Photo"   >'
         +'<label class="left-fn-title wd-150" id="desc_Photo">'+description+'</label>'
         +'<label class="wd-content-lable d-flex " id="field_Photo">'+'<input type="text" name="Photo" id="Photo" value="'+value+'" class="textfield upload field_image form-control" title="" size="80" data-original-title="">'
         +'</label>'+'<label>'+'<input type="button" value="选择"   class="btn btn-primary tx-size-xs mg-l-10 xz">'
         +'</label>'+'<label>'
         +'<input type="button" value="预览" onclick="" class="btn btn-primary tx-size-xs mg-l-10 "  id="demo_yl">'+'</label>'+'</div>'
  $(main).append(str) 
  //预览方法
  $("#demo_yl").on('click',function(){
   previewFile(list) 
  })
  //传图片方法
  $(".btn.btn-primary.tx-size-xs.mg-l-10.xz").on('click',function(){
    selectImage(list)
  })
    
}
//关键词
function Keyword(description,value,main,list){
    var str =''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_Keyword">'
        +'<label class="left-fn-title wd-150" id="desc_Keyword">'+description+'</label>'
        +'<label class="wd-content-lable d-flex " id="field_Keyword">'
        //tagit-hidden-field
        +'<input type="text" class="textfield form-control " size="80" name="Keyword" id="Keyword" value="'+value+'">'
        +'</label>'
        +'<label>'
        +'<input type="button" value="自动提取"  class="btn btn-primary tx-size-xs mg-l-10" id="zdtq">'
        +'</label>'
        +'</div>'
     $(main).append(str) 
     $("body").on('click','#zdtq',function(){
           getAutoKeyword("Keyword")
     })
   
}

//列表页展现形式:
function list(description,lists,values,main){
  var str =""
      str+='<div class="row flex-row align-items-center mg-b-15" id="tr_item_type">'
          +'<label class="left-fn-title wd-150" id="desc_item_type">'+description
          +'<a href="../help/content.html" target="_blank" class="valign-middle tx-gray-900 mg-l-10" data-toggle="tooltip" data-placement="top">'
          +'<i class="icon ion-help-circled tx-18">'
          +'</i>'
          +'</a>'
          +'<input type="text"   value="'+values+'" id="td_desc_item_type"  class="ds_tr">'
          +'</label>'
          +'<label class="wd-content-ckx d-flex " id="field_item_type">'
   for(var j = 0;j<lists.length;j++){
         str+='<label class="rdiobox mg-r-15">'
         +'<input type="radio" value="'+(j)+'" id="item_type_'+(j)+'" name="item_type" class="tr_item_type">'
         +'<span for="item_type_'+(j)+'">'+lists[j][0]+'</span>'
         +'</label>'
               }
          str+='</label>'
          +'</div>'
    $(main).append(str) 
     //当前根据接口获取列表页识选中值：
      var obj = $(".tr_item_type")
      for(var i = 0;i < obj.length; i++){
          if(values == values){
          var name = "#item_type_"+values; 
          $(name).attr("checked","");
        }
      }
     //如果是当前选中列表页内容标识栏目提交
      change_value(".tr_item_type","#td_desc_item_type")
}
//自定义内容标识:
function content_type(description,value,main){
      var str =''
          str+='<div class="row flex-row align-items-center mg-b-15" id="tr_content_type">'
            +'<div class="d-flex">'
            +'<label  class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400" id="desc_content_type">'+description+'</div>'
            +'<div  class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_content_type">'
            +'<input type="text" class="textfield form-control" size="80" name="content_type" id="content_type" value="'+value+'">'
            +'</div>'
            +'</div>'
            +'</div>'
         $(main).append(str) 
}

//客户端内容标识：
function doc_type(description,lists,values,main){
    var str =""
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_doc_type">'
           +'<label class="left-fn-title wd-150" id="desc_doc_type">'+description+'</label>'
           +'<input type="text"   value="'+values+'" id="td_doc_type"  class="ds_tr">'
           +'<label class="wd-content-ckx d-flex ="field_doc_type">'
   for(var j = 0;j<lists.length;j++){
   var name = lists[j][0]
   var reg = /[\u4e00-\u9fa5]/g;
var names = name.match(reg);
name = names.join("");
        str+='<label class="rdiobox mg-r-15">'
           +'<input type="radio" value="'+(j)+'" id="doc_type_'+(j)+'" name="doc_type" class="doc_type">'
           +'<span for="doc_type_'+(j)+'">'+name
           +'</span>'
           +'</label>'
           }
        str+='</label>'
             +'</div>'
        $(main).append(str) 
         //当前根据接口获取客户端内容标识选中值：
      var obj = $(".doc_type")
      for(var i = 0;i < obj.length; i++){
          if(values == values){
          var name = "#doc_type_"+values; 
          $(name).attr("checked","");
        }
      }
     //如果是当前选中客户端内容标识栏目提交
      change_value(".doc_type","#td_doc_type")
    }
    
//按钮组标题:
function showbuttontitle(description,lists,values,main){
   var str =''
       str+='<div class="row flex-row align-items-center mg-b-15" id="tr_showbuttontitle">'
       +'<label class="left-fn-title wd-150" id="desc_showbuttontitle">'+description+'</label>'
       +'<input type="text"   value="'+values+'" id="td_tontitle" class="ds_tr">'
       +'<label class="wd-content-ckx d-flex " id="field_showbuttontitle">'
       for(var j = 0;j<lists.length;j++){
       console.log(lists[j][0])
       str+='<label class="rdiobox mg-r-15">'
          +'<input type="radio" value="'+(j)+'" id="showbuttontitle_'+(j)+'" name="showbuttontitle"  class="showbuttontitle">'
          +'<span for="showbuttontitle_'+(j)+'">'+lists[j][0]
          +'</span>'+'</label>'
          }
       str+='</label>'+'</div>'
         $(main).append(str) 
        //当前根据接口获取音频状态值：
       var obj = $(".showbuttontitle")
       for(var i = 0;i < obj.length; i++){
          if(values == values){
          var name = "#showbuttontitle_"+values; 
          $(name).attr("checked","");
        }
      }
     //如果是当前选中状态音频状态值提交:
      change_value(".showbuttontitle","#td_tontitle")
         
}
//作者:
function anuor(description,value,main){
  var str =""
      str+='<div class="row flex-row align-items-center mg-b-15" id="tr_anuor">'
         +'<div class="d-flex">'
         +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400" id="desc_anuor">'+description+'</div>'
         +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20" id="field_anuor">'
         +'<input type="text" class="textfield form-control" size="80" name="anuor" id="anuor" value="'+value+'">'
         +'</div>'
         +'</div>'
         +'</div>'
        $(main).append(str) 
}
//是否保存为音频：
function isAudio(description,lists,values,main){
   var str =''
       str+='<div class="row flex-row align-items-center mg-b-15" id="tr_isAudio">'
           +'<label class="left-fn-title wd-150" id="desc_isAudio">'+description+'</label>'+'<label class="wd-content-ckx d-flex " id="field_isAudio">'
           +'<input type="text"   value="'+values+'" id="tr_Audio"  class="ds_tr">'
        for(var j = 0;j<lists.length;j++){
          console.log(lists[j][0])
          str+='<label class="rdiobox mg-r-15">'
          +'<input type="radio" value="'+(j)+'" id="isAudio_'+(j)+'" name="isAudio" class="isAudio">'
          +'<span for="isAudio_'+(j)+'">'+lists[j][0]+'</span>'+'</label>'
          }
         str+='</label>'+'</div>'
          $(main).append(str) 
        //当前根据接口获取音频状态值：
       var obj = $(".isAudio")
       for(var i = 0;i < obj.length; i++){
          if(values == values){
          var name = "#isAudio_"+values; 
          $(name).attr("checked","");
        }
      }
     //如果是当前选中状态音频状态值提交:
      change_value(".isAudio","#tr_Audio")

       }

//视频编号:
function videoid(description,value,main){
    var str=""
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_videoid">'
        +'<div class="d-flex">'
        +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400" id="desc_videoid">'+description+'</div>'
        +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20" id="field_videoid">'
        +'<input type="text" class="textfield form-control" size="10" name="videoid" id="videoid" value="'+value+'">'
        +'</div>'
        +'</div>'
        +'</div>'
         $(main).append(str) 
  }
//视频类型:
      function  mediatype(description,value,main){
          var str =''
              str+='<div class="row flex-row align-items-center mg-b-15" id="tr_mediatype">'
              +'<div class="d-flex">'
              +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_mediatype">'+description+'</div>'
              +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_mediatype">'
              +'<input type="text" class="textfield form-control"  name="mediatype" id="mediatype" value="'+value+'">'
              +'</div>'+'</div>'+'</div>'
            $(main).append(str) 
      }
//节目单频道编号
function epgchannelid(description,value,main){
    var str =''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_epgchannelid">'
          +'<div class="d-flex">'
          +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_epgchannelid">'+description+'</div>'
          +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_epgchannelid">'
          +'<input type="text" class="textfield form-control" size="80" name="epgchannelid" id="epgchannelid" value="'+value+'">'
          +'</div>'+'</div>'+'</div>'
           $(main).append(str) 
}
//链接地址:
function href_app(description,value,main){
    var str = ''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_href_app">'
            +'<div class="d-flex">'
            +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400" id="desc_href_app">'+description+'</div>'
            +'<div class="d-flex align-items-center justify-content-center wd-120 ht-70 bg-gray-400 mg-l-20" id="field_href_app">'
            +'<input type="text" class="textfield form-control" size="80" name="href_app" id="href_app"  value="'+value+'">'
           +'</div>'
           +'<div class="d-flex align-items-center justify-content-right wd-100 ht-70 bg-gray-400 mg-l-20">'
           +'<input type="button" value="预览" onclick="" class="btn btn-primary tx-size-xs mg-l-10 app_list" >'
           +'</div>'
           +'</div>'
            +'</div>'
           $(main).append(str)  
            //传图片方法
  $("#tr_href_app .app_list").on('click',function(){
   previewFile('href_app')
  })
       
}
//大图/轮播图
function Photo4(description,value,main){
    var str = ""
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_Photo4">'
          +'<div class="d-flex">'
           +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_Photo4">'+description+'</div>'
           +'<div class="d-flex align-items-center justify-content-center wd-70 ht-70 bg-gray-400 mg-l-20" id="field_Photo4">'
           +'<input type="text" name="Photo4" id="Photo4" value="'+value+'" class="textfield upload field_image form-control" title="" size="80" data-original-title="">'
           +'</div>'+'<div  class="d-flex align-items-center justify-content-center wd-100 ht-70 bg-gray-400 mg-l-20">'
           +'<input type="button" value="选择" onclick="" class="btn btn-primary tx-size-xs mg-l-10 Photo4_xz">'
           +'<input type="button" value="预览" onclick="" class="btn btn-primary tx-size-xs mg-l-10 Photo4_yl">'
           +'</div>'+'</div>'+'</div>'
         $(main).append(str)
         //选择:
         $("#tr_Photo4 .Photo4_xz").on('click',function(){
          selectImage('Photo4')
         })
          //预览:
         $("#tr_Photo4 .Photo4_yl").on('click',function(){
          previewFile('Photo4')
         })
         
}
//列表封面图2：
function Photo2(description,value,main){
    var str = ''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_Photo2">'
          +'<div class="d-flex">'
          +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400" id="desc_Photo2">'+description+'</div>'
          +'<div class="d-flex align-items-center justify-content-center wd-70 ht-70 bg-gray-400 mg-l-20" id="field_Photo2">'
          +'<input type="text" name="Photo2" id="Photo2" value="'+value+'" class="textfield upload field_image form-control" title="" size="80" data-original-title="">'
          +'</div>'+'<div  class="d-flex align-items-center justify-content-center wd-100 ht-70 bg-gray-400 mg-l-20">'+'<input type="button" value="选择" onclick="" class="btn btn-primary tx-size-xs mg-l-10 Photo2_xz">'+'<input type="button" value="预览" onclick="" class="btn btn-primary tx-size-xs mg-l-10 Photo2_yl">'
          +'</div>'+'</div>'+'</div>'
           $(main).append(str)
         //选择:
         $("#tr_Photo2 .Photo2_xz").on('click',function(){
          selectImage('Photo2')
         })
          //预览:
         $("#tr_Photo2 .Photo2_yl").on('click',function(){
          previewFile('Photo2')
         })
 }
 
 //列表封面图3：
function Photo3(description,value,main){
      var str = ''
          str+='<div class="row flex-row align-items-center mg-b-15" id="tr_Photo3">'
             +'<div class="d-flex">'
             +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_Photo3">'+description+'</div>'+'<div class="d-flex align-items-center justify-content-center wd-70 ht-70 bg-gray-400 mg-l-20"  id="field_Photo3">'
             +'<input type="text" name="Photo3" id="Photo3" value="'+value+'" class="textfield upload field_image form-control" title="" size="80" data-original-title="">'
             +'</div>'+'<div  class="d-flex align-items-center justify-content-center wd-100 ht-70 bg-gray-400 mg-l-20">'+'<input type="button" value="选择" onclick="" class="btn btn-primary tx-size-xs mg-l-10  Photo3_xz">'+'<input type="button" value="预览" onclick="" class="btn btn-primary tx-size-xs mg-l-10  Photo3_yl">'
             +'</div>'+'</div>'+'</div>'
        $(main).append(str)
         //选择:
         $("#tr_Photo3 .Photo3_xz").on('click',function(){
          selectImage('Photo3')
         })
          //预览:
         $("#tr_Photo3 .Photo3_yl").on('click',function(){
          previewFile('Photo3')
         })
}
//直播点播地址：
function videourl(description,value,main){
      var str = ''
          str+='<div class="row flex-row align-items-center mg-b-15" id="tr_videourl">'
            +'<div class="d-flex">'
             +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_videourl">'+description+'</div>'
             +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_videourl">'
             +'<input type="text" class="textfield form-control" size="80" name="videourl" id="videourl" value="'+value+'">'
             +'</div>'+'</div>'+'</div>'
              $(main).append(str)
}

//泰德直播后台编号：
function td_liveid(description,value,main){
    var str =""
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_td_liveid">'
          +'<div class="d-flex">'
        +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_td_liveid">'+description+'</div>'
        +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_td_liveid">'
        +'<input type="text" class="textfield form-control" size="80" name="td_liveid" id="td_liveid" value="'+value+'">'
        +'</div>'+'</div>'+'</div>'
         $(main).append(str)
}
//聚现活动ID
function juxian_liveid(description,value,main){
     var str =''
         str+='<div class="row flex-row align-items-center mg-b-15" id="tr_juxian_liveid">'
            +'<div class="d-flex">'
            +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_juxian_liveid">'+description+'</div>'
            +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_juxian_liveid">'+'<input type="text" class="textfield form-control" size="10" name="juxian_liveid" id="juxian_liveid" value="'+value+'">'
            +'</div>'+'</div>'
            +'</div>'
           $(main).append(str)

}
//二级栏目编号：
function secondcategory(description,value,main){
     var str =''
         str+='<div class="row flex-row align-items-center mg-b-15" id="tr_secondcategory">'
             +'<div class="d-flex">'
            +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_secondcategory">'+description+'</div>'
            +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_secondcategory">'
            +'<input type="text" class="textfield form-control" size="10" name="secondcategory" id="secondcategory" value="'+value+'">'
            +'</div>'+'</div>'
             +'</div>'
             $(main).append(str)
}
//跳转类型显示：
function jumptype(description,lists,values,main){
    var str = ''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_jumptype">'
           +'<label class="left-fn-title wd-150" id="desc_jumptype">'+description+'</label>'
           +'<label class="wd-content-ckx d-flex " id="field_jumptype">'
        for(var j = 0;j<lists.length;j++){
          console.log(lists[j][0])
         var name = lists[j][0]
         var reg = /[\u4e00-\u9fa5]/g;
        var names = name.match(reg);
         name = names.join("");
           str+='<label class="rdiobox mg-r-15">'
           +'<input type="radio" value="'+(j)+'" id="jumptype_'+(j)+'" name="jumptype" checked="">'
           +'<span for="jumptype_'+(j)+'">'+name+'</span>'
           +'</label>'
              }
         str+='</label>'+'</div>'
          $(main).append(str) 
}
//客户端一级栏目：
function frame(description,lists,values,main){
    var str = ''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_frame"><label class="left-fn-title wd-150" id="desc_frame">'+description+'</label>'
          +'<input type="text"   value="'+values+'" id="tr_frame"  class="ds_tr">'
          +'<label class="wd-content-ckx d-flex " id="field_frame">'
    for(var j = 0;j<lists.length;j++){
          console.log(lists[j][0])
          var name = lists[j][0]
          var reg = /[\u4e00-\u9fa5]/g;
          var names = name.match(reg);
          name = names.join("");
       str+='<label class="rdiobox mg-r-15">'+'<input type="radio" value="'+(j)+'" id="frame_'+(j)+'" name="frame" class="field_frame">'
           +'<span for="frame_0">'+name+'</span>'+'</label>'
           }
         str+='</label>'+'</div>'
          $(main).append(str) 
    //当前根据接口获取默认的一级栏目选中值：
      var obj = $(".field_frame")
      for(var i = 0;i < obj.length; i++){
          if(values == values){
          var name = "#frame_"+values; 
          $(name).attr("checked","");
        }
      }
     //如果是当前选中状态改变一级栏目提交
      change_value(".field_frame","#tr_frame")
          
          
}
//虚拟浏览量
function pv_virtual(description,value,main){
    var str =''
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_pv_virtual">'
        +'<div class="d-flex">'
        +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400" id="desc_pv_virtual">'+description+'</div>'
        +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20" id="field_pv_virtual">'
        +'<input type="text" class="textfield form-control" size="10" name="pv_virtual" id="pv_virtual" value="'+value+'">'
        +'</div>'+'</div>'+'</div>'
        $(main).append(str) 
}
//实际文章浏览量：
function pv(description,value,main){
    var str=""
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_pv">'
          +'<div class="d-flex">'
           +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_pv">'+description+'</div>'
           +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_pv">'
           +'<input type="text" class="textfield form-control" size="10" name="pv" id="pv" value="'+value+'">'
           +'</div>'
           +'</div>'
           +'</div>'
           $(main).append(str) 
}
//评论开关：
function allowcomment(description,value,main){
    var str = ''
       str+='<div class="row flex-row align-items-center mg-b-15" id="tr_allowcomment">'
           +'<label class="left-fn-title wd-150" id="desc_allowcomment">'+description+'</label>'
           +'<label class="wd-content-lable d-flex " id="field_allowcomment">'
           +'<input type="hidden" name="allowcomment" id="allowcomment" value="'+value+'">'
          +'<div class="toggle-wrapper">'
          +'<div class="toggle toggle-modern primary" data-toggle-on="true" field="allowcomment" style="height: 25px; width: 60px;">'
          +'<div class="toggle-slide">'+'<div class="toggle-inner" style="width: 95px; ">'
          +'<div class="toggle-on" style="height: 25px; width: 47.5px; text-indent: -8.33333px; line-height: 25px;">'+'ON'+'</div>'
         +'<div class="toggle-blob" style="height: 25px; width: 25px; margin-left: -12.5px;">'+'</div>'
          +'<div class="toggle-off" style="height: 25px; width: 47.5px; margin-left: -12.5px; text-indent: 8.33333px; line-height: 25px;">'+'OFF'+'</div>'
          +'</div>'+'</div>'+'</div>'
          +'</div>'
           +'</label>'
           +'</div>'
            $(main).append(str) 
            var  val =  $("#field_allowcomment input").val()
            if(val == 1){
           $("#tr_allowcomment .toggle-on").addClass('active')
            }else if(val == 0){
              $("#tr_allowcomment .toggle-on").removeClass('active')
            }
              $("#tr_allowcomment .toggle-on").on('click',function(){
                $("#tr_allowcomment .toggle-on").removeClass('active')
                $("#tr_allowcomment .toggle-inner").css({'margin-left': '-35px'})
                $("#tr_allowcomment .toggle-off").removeClass('active')
                $("#field_allowcomment input").val(0)
                  })
             $("#tr_allowcomment .toggle-off").on('click',function(){
                $("#tr_allowcomment .toggle-on").addClass('active')
                $("#tr_allowcomment .toggle-off").removeClass('active')
                $("#tr_allowcomment .toggle-inner").css({'margin-left': '0px'})
                var  val =  $("#field_allowcomment input").val()
                $("#field_allowcomment input").val(1)
                 
            })
}

//阅读量开关：
function showread(description,value,main){
   var str =''
       str+='<div class="row flex-row align-items-center mg-b-15" id="tr_showread">'
           +'<label class="left-fn-title wd-150" id="desc_showread">'+description+'</label>'
           +'<label class="wd-content-lable d-flex " id="field_showread">'
           +'<input type="hidden" name="showread" id="showread" value="'+value+'">'
           +'<div class="toggle-wrapper">'
           +'<div class="toggle toggle-modern primary" data-toggle-on="true" field="showread" style="height: 25px; width: 60px;">'
           +'<div class="toggle-slide">'
           +'<div class="toggle-inner" style="width: 95px; margin-left: 0px;">'
           +'<div class="toggle-on" style="height: 25px; width: 47.5px; text-indent: -8.33333px; line-height: 25px;">'+'ON'+'</div>'
           +'<div class="toggle-blob" style="height: 25px; width: 25px; margin-left: -12.5px;">'
           +'</div>'
           +'<div class="toggle-off" style="height: 25px; width: 47.5px; margin-left: -12.5px; text-indent: 8.33333px; line-height: 25px;">'+'OFF'+'</div>'
           +'</div>'+'</div>'+'</div>'
           +'</div>'+'</label>'+'</div>'
          $(main).append(str) 
            var  val =  $("#tr_showread input").val()
            if(val == 1){
           $("#tr_showread .toggle-on").addClass('active')
            }else if(val == 0){
              $("#tr_showread .toggle-on").removeClass('active')
            }
              $("#tr_showread .toggle-on").on('click',function(){
                $("#tr_showread .toggle-on").removeClass('active')
                $("#tr_showread .toggle-inner").css({'margin-left': '-35px'})
                $("#tr_showread .toggle-off").removeClass('active')
                $("#tr_showread input").val(0)
                  })
             $("#tr_showread .toggle-off").on('click',function(){
                $("#tr_showread .toggle-on").addClass('active')
                $("#tr_showread .toggle-off").removeClass('active')
                $("#tr_showread .toggle-inner").css({'margin-left': '0px'})
                var  val =  $("#tr_showread input").val()
                $("#tr_showread input").val(1)
                 
            })

}
//广告开关
function allowadvert(description,value,main){ 
             var str =''
                 str+='<div class="row flex-row align-items-center mg-b-15" id="tr_allowadvert">'
                    +'<label class="left-fn-title wd-150" id="desc_allowadvert">'+description+'</label>'
                    +'<label class="wd-content-lable d-flex " id="field_allowadvert">'
                    +'<input type="hidden" name="allowadvert" id="allowadvert" value="'+value+'">'
                    +'<div class="toggle-wrapper">'
                    +'<div class="toggle toggle-modern primary" data-toggle-on="true" field="allowadvert" style="height: 25px; width: 60px;">'
                    +'<div class="toggle-slide">'
                    +'<div class="toggle-inner" style="width: 95px; margin-left: 0px;">'
                    +'<div class="toggle-on" style="height: 25px; width: 47.5px; text-indent: -8.33333px; line-height: 25px;">'+'ON'+'</div>'
                    +'<div class="toggle-blob" style="height: 25px; width: 25px; margin-left: -12.5px;">'
                    +'</div>'
                    +'<div class="toggle-off" style="height: 25px; width: 47.5px; margin-left: -12.5px; text-indent: 8.33333px; line-height: 25px;">'+'OFF'+'</div>'
                    +'</div>'+'</div>'+'</div>'+'</div>'
                    +'</label>'+'</div>'
             $(main).append(str) 
            var  val =  $("#tr_allowadvert input").val()
            if(val == 1){
           $("#tr_allowadvert .toggle-on").addClass('active')
            }else if(val == 0){
              $("#tr_allowadvert .toggle-on").removeClass('active')
            }
              $("#tr_allowadvert .toggle-on").on('click',function(){
                $("#tr_allowadvert .toggle-on").removeClass('active')
                $("#tr_allowadvert .toggle-inner").css({'margin-left': '-35px'})
                $("#tr_allowadvert .toggle-off").removeClass('active')
                $("#tr_allowadvert input").val(0)
                  })
             $("#tr_allowadvert .toggle-off").on('click',function(){
                $("#tr_allowadvert .toggle-on").addClass('active')
                $("#tr_allowadvert .toggle-off").removeClass('active')
                $("#tr_allowadvert .toggle-inner").css({'margin-left': '0px'})
                var  val =  $("#tr_allowadvert input").val()
                $("#tr_allowadvert input").val(1)
                 
            })
}
//虚拟点赞量
function zanvirtualnum(description,value,main){
    var str = ''
           str+='<div class="row flex-row align-items-center mg-b-15" id="tr_zan_virtual_num">'
            +'<div class="d-flex">'
            +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400" id="desc_zan_virtual_num">'+description+'</div>'
            +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20" id="field_zan_virtual_num">'
            +'<input type="text" class="textfield form-control" size="10" name="zan_virtual_num" id="zan_virtual_num" value="'+value+'">'
            +'</div>'+'</div>'+'</div>'
             $(main).append(str) 
}
//爆料审核状态:
function  baoliaostatus(description,lists,values,main){
      var str = ''
       str+='<div class="row flex-row align-items-center mg-b-15" id="tr_baoliaostatus">'
        +'<label class="left-fn-title wd-150" id="desc_baoliaostatus">'+description+'</label>'
        +'<input type="text"   value="'+values+'" id="tr_atus"  class="ds_tr">'
        +'<label class="wd-content-ckx d-flex " id="field_baoliaostatus">'
         for(var j = 0;j<lists.length;j++){
          console.log(lists[j][0])
         var name = lists[j][0]
         var reg = /[\u4e00-\u9fa5]/g;
        var names = name.match(reg);
         name = names.join("");
         str+='<label class="rdiobox mg-r-15">'
             +'<input type="radio" value="'+(j)+'" id="baoliaostatus_'+(j)+'" name="baoliaostatus"   class="baoliaostatus">'
             +'<span for="baoliaostatus_'+(j)+'">'+name+'</span>'+'</label>'
         }
       str+='</label>'+'</div>'
       $(main).append(str)  
        //当前根据接口获取审核状态值：
      var obj = $(".baoliaostatus")
      for(var i = 0;i < obj.length; i++){
          if(values == values){
          var name = "#baoliaostatus_"+values; 
          $(name).attr("checked","");
        }
      }
     //如果是当前选中状态审核状态值提交:
      change_value(".baoliaostatus","#tr_atus")
}
//爆料是否公开：
function  baoliao_ispublic(description,lists,values,main){
 var str = ''
     str+='<div class="row flex-row align-items-center mg-b-15" id="tr_baoliao_ispublic">'
        +'<label class="left-fn-title wd-150" id="desc_baoliao_ispublic">'+description+'</label>'
        +'<input type="text"   value="'+values+'" id="baoliao"  class="ds_tr">'
        +'<label class="wd-content-ckx d-flex " id="field_baoliao_ispublic">'
            for(var j = 0;j<lists.length;j++){
         console.log(lists[j][0])
         var name = lists[j][0]
         var reg = /[\u4e00-\u9fa5]/g;
         var names = name.match(reg);
         name = names.join("");
         str+='<label class="rdiobox mg-r-15">'
        +'<input type="radio"  value="'+(j)+'" id="baoliao_ispublic_'+(j)+'" name="baoliao_ispublic"  class="baoliao_ispublic"  defaultValue=>'
        +'<span for="baoliao_ispublic_'+(j)+'">'+name+'</span>'+'</label>'
       }
      str+='</label>'+'</div>'
       $(main).append(str)  
      //当前根据接口获取默认的选中值：
      var obj = $(".baoliao_ispublic")
      for(var i = 0;i < obj.length; i++){
          if(values == values){
          var name = "#baoliao_ispublic_"+values; 
          $(name).attr("checked","");
        }
      }
     //如果是当前选中状态改变val值提交
      change_value(".baoliao_ispublic","#baoliao")
   
}
//爆料人位置：
function baoliao_localtion(description,value,main){
    var str=""
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_baoliao_localtion">'
            +'<div class="d-flex">'
            +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400" id="desc_baoliao_localtion">'+description+'</div>'
            +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_baoliao_localtion">'
            +'<input type="text" class="textfield form-control" size="80" name="baoliao_localtion" id="baoliao_localtion"  value="'+value+'">'
            +'</div>'+'</div>'+'</div>'
            $(main).append(str)  
}
//经度：
function jd(description,value,main){
    var str=""
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_jd">'
          +'<div class="d-flex">'
          +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_jd">'+description+'</div>'
          +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_jd">'
          +'<input type="text" class="textfield form-control" size="80" name="jd" id="jd" value="'+value+'">'
          +'</label>'+'</div>'+'</div>'
 $(main).append(str)  
}

//纬度：
function wd(description,value,main){
    var str=""
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_wd">'
          +'<div class="d-flex">'
            +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400"  id="desc_wd">'+description+'</div>'
            +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"   id="field_wd">'
            +'<input type="text" class="textfield form-control" size="80" name="wd" id="wd" value="'+value+'">'
            +'</div>'+'</div>'+'</div>'
    $(main).append(str) 
  }
//爆料提交用户编号：
function baoliao_userid(description,value,main){
     var str=""
        str+='<div class="row flex-row align-items-center mg-b-15" id="tr_baoliao_userid">'
           +'<div class="d-flex">'
           +'<div class="d-flex align-items-center justify-content-left wd-60 ht-70 bg-gray-400" id="desc_baoliao_userid">'+description+'</div>'
           +'<div class="d-flex align-items-center justify-content-center wd-200 ht-70 bg-gray-400 mg-l-20"  id="field_baoliao_userid">'
           +'<input type="text" class="textfield form-control" size="10" name="baoliao_userid" id="baoliao_userid" value="'+value+'">'
          +'</div>'+'</div>'+'</div>'
    $(main).append(str) 
}





//重新定义保存方法
  function Save_Content_1()
{
	//保存正文,内容
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++){//alert(rows[i].className);
		if (rows[i].className=="selTab"){
			//rows[i].className = "tab";
			var rows_page = rows[i].getAttribute("page");
			Contents[rows_page-1] = showEditer1.getContent();//获取编辑器内容  FCK.GetXHTML( FCKConfig.FormatSource );
			//处理分页符
			var symbol = '<div style="page-break-after: always;"><span style="DISPLAY:none"> </span></div>';
			//当前内容中含有分页符的话，在Contens[rows_page-1]元素后插入一页，把当前内容分为两部分，把最后一部分内容插入到新的内容页
			if(Contents[rows_page-1].indexOf(symbol)>-1)
			{
				var temp=Contents[rows_page-1].split(symbol);
				Pages +=(temp.length-1);
				Contents[rows_page-1] = temp[0];
				for(var j=0;j<temp.length-1;j++)
				{
					// 拼接函数(索引位置, 要删除元素的数量, 元素)  
					if(j==0)
						Contents[rows_page-1]=temp[0];//更改当前页的内容
					 Contents.splice(i+j+1, 0, temp[j+1]);  //在当前页面后面追加一页，后面的向后顺延
				} 
			}
			}
		}
	var localhost = document.location.protocol+ "//" + document.location.hostname;
	if (document.location.port!="80")
  		localhost = localhost + ":" + document.location.port;
 	if(SiteAddress!="")localhost=SiteAddress+"/";
	var reg = new RegExp(localhost,"g");
	//保存时把内容中图片地址替换为外网地址
	var url_reg = new RegExp(inner_url+"/","g");
	if(Pages<=1)
	{
		var str = Contents[0];
		str = str.replace(reg, "/").replace(url_reg,outer_url+"/"); //alert(str);

		document.form.Content.value = str;
		document.form.Page.value = "1";
	}
	else
	{
		for(var i=1;i<=Pages;i++)
		{
			var str = Contents[i-1];//document.all.ContentEditor.GetContent(i);
			str = str.replace(reg, "/").replace(url_reg,outer_url+"/");;

			if(i==1)
				document.form.Content.value = str;
			else
			{
				var o = $("#Content"+i);
				if(o.size()>0) 
					o.val(str);
				else 
					$('<input>').attr({type: 'hidden',id:"Content"+i,name:"Content"+i,value:str}).appendTo($(form));
			}
		}
		
		document.form.Page.value = Pages + "";
	}
}
//提取数据关键词方法;
function getAutoKeyword(name){

	var title = $("#Title").val();
	var Keyword = $("#Keyword").val();
	var Tag = $("#Tag").val();
	Save_Content();
	var content = "";
	for(var i=1;i<=Pages;i++)
	{
		content = content + Contents[i-1];
	}
	jQuery.ajax({
			type : "POST",
			url : "../content/get_auto_keyword.jsp",
			dataType : "html",
			data: {title:title,content:content},
            success : function(data){
            console.log('_关键字_')
            console.log(data)
				if(name=="Keyword"){
			       data = Keyword + " " + data;
			     
			      
			      var str = ''
			          str+='<ul class="tagit ui-widget ui-widget-content ui-corner-all">'
                           +'<li class="tagit-new">'
                           +'<input type="text" class="ui-widget-content ui-autocomplete-input" autocomplete="off"  value="'+data+'">'
                           +'</li>'
                           +'</ul>' 
				$('#Keyword').html(str);
					 
				
					
				}else{
					data = Tag + " " + data;
					$('.tagit-new').html(data);
				}
				
            }
    });
}

//单选框形式表单当前高亮显示；以及选中状态方法：
function  change_value(docu,id_docu){
   $(docu).click(function(){
         for (var i = 0; i < obj.length; i++) {
         if (obj[i].checked) {
              if(obj[i].value == obj[i].value){
                   $(id_docu).val(obj[i].value)
              }
         }
        } 
       })  
}



//打开侧边栏：
$('#btnRightMenu').on('click', function(){
    $('body').addClass('show-right');
    return false;
  });



  $('#btnLeftMenuMobile').on('click', function(){
    $('body').addClass('show-left');
    return false;
  });



//关闭侧边栏
$(document).on('click', function(e){
    e.stopPropagation();

    // closing left sidebar
    if($('body').hasClass('show-left')) {
      var targ = $(e.target).closest('.br-sideleft').length;
      if(!targ) {
        $('body').removeClass('show-left');
      }
    }

    // closing right sidebar
    if($('body').hasClass('show-right')) {
      var targ = $(e.target).closest('.br-sideright').length;
      if(!targ) {
        $('body').removeClass('show-right');
      }
    }
  });



if($().datepicker) {
    $('.form-control-datepicker').datepicker()
      .on("change", function (e) {
        console.log("Date changed: ", e.target.value);
    });
  }



  // custom scrollbar style
  $('.overflow-y-auto').perfectScrollbar();

  // jquery ui datepicker
  $('.datepicker').datepicker();

  // switch button
  $('.switch-button').switchButton();

  // peity charts
 // $('.peity-bar').peity('bar');

  // highlight syntax highlighter
  $('pre code').each(function(i, block) {
    hljs.highlightBlock(block);
  });

  // Initialize tooltip
  //$('[data-toggle="tooltip"]').tooltip();

  // Initialize popover
  $('[data-popover-color="default"]').popover();



  // By default, Bootstrap doesn't auto close popover after appearing in the page
  // resulting other popover overlap each other. Doing this will auto dismiss a popover
  // when clicking anywhere outside of it
  $(document).on('click', function (e) {
    $('[data-toggle="popover"],[data-original-title]').each(function () {
        //the 'is' for buttons that trigger popups
        //the 'has' for icons within a button that triggers a popup
        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
            (($(this).popover('hide').data('bs.popover')||{}).inState||{}).click = false  // fix for BS 3.3.6
        }

    });
  });



  // Select2 Initialize
  // Select2 without the search
  if($().select2) {
    $('.select2').select2({
      minimumResultsForSearch: Infinity
    });

    // Select2 by showing the search
    $('.select2-show-search').select2({
      minimumResultsForSearch: ''
    });

    // Select2 with tagging support
    $('.select2-tag').select2({
      tags: true,
      tokenSeparators: [',', ' ']
    });
  }


//按钮组集合判断：




















</script>



