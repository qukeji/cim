<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.net.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

int		ChannelID				= getIntParameter(request,"ChannelID");
int		ItemID					= getIntParameter(request,"ItemID");


Channel channel = CmsCache.getChannel(ChannelID);
Document item = CmsCache.getDocument(ItemID,ChannelID);
int globalid = item.getGlobalID();
String title = item.getTitle();
title = URLEncoder.encode(title,"utf-8");
String SiteAddress = channel.getSite().getUrl();
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
String inner_url = "",outer_url="";
if(photo_config != null)
{
	int sys_channelid_image = photo_config.getInt("channelid");
	Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
	inner_url = img_site.getUrl();
	outer_url = img_site.getExternalUrl();
}


int GlobalID = item.getGlobalID();
ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
int id_aa = approve.getId();//审核操作id
int approveId = approve.getApproveId();//审核环节id
int action	= approve.getAction();//是否通过
int end = approve.getEndApprove();//是否终审


int data_approve = 1;//是否显示右侧审核栏
int data_yl = 1;//是否为审核预览
/*if(id_aa!=0){//说明已提交审核
	if(approveId==0){//审核环节编号为0，此文章状态为提交审核
		data_approve= 1;
		data_yl = 1;//是否为审核预览
	}else{
		if(action==1){//未通过
			data_approve = 1;
			data_yl =1 ;
		}
		if(action==0&&end==1){
			data_approve= 1;
			data_yl = 1;
		}
	}

}*/

int Version = channel.getVersion();//是否开启了版本功能
%>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico"/>
<title>审核预览 <%=channel.getParentChannelPath()%> TideCMS</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
<link href="../lib/2018/summernote/summernote-bs4.css" rel="stylesheet">
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

	/*审核预览相关*/
	.wd-content-lable{flex: 1;}
	div.wd-content-div {display: block;width: 100%;flex: 1;}
	div.wd-content-div p{line-height: 1.5;}
	div.wd-content-div img{max-width: 100%;;margin: 5px 0;}
	div.wd-content-img {max-width: 300px;display: block;}
	div.wd-content-img img{max-width: 100%;}
	.pd-l-20.tx-14{margin:5px 0}
	.pc-video-box{width:480px;height:320px;}
	img{max-width: 300px !important;}
	.hide{display: none;}
	@media (max-width: 575px) {
	    .email .with-second-nav {margin-left: 0px;}
		.wd-content-lable{flex: auto;}
		div.wd-content-div {display: block;width: 100%;flex:auto;}
		video {height: auto !important;}
		.left-page-body{margin-left:10px;margin-right:10px;}
	}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<script type="text/javascript" src="../common/2018/videoPlayer.js"></script>
<script>
var channelid = <%=ChannelID%>
var GlobalID = <%=globalid%>;
var title = "<%=title%>";
function Save(action){
	var user = $("#approve").attr("user");
	var approveId = $("#approve").attr("approveId");
	var endApprove = $("#approve").attr("end");
	var actionMessage = $("#approve").val();
	if(action==1&&actionMessage==""){
		alert("请输入驳回理由");
		return false ;
	}
	var url= "task_approve_submit.jsp?globalid="+GlobalID+"&title="+title+"&action="+action+"&user="+user+"&approveId="+approveId+"&endApprove="+endApprove+"&actionMessage="+actionMessage;
	$.ajax({
		 type: "GET",
		 url: url,
		 success: function(msg){
			 if(msg.trim()!=""){
				alert(msg.trim());
			 }else{
				document.location.reload();
			 }
		 }   
	}); 
}


</script>
</head>
<body class="collapsed-menu email">
	<div class="br-logo">
		<div class="br-logo"><img src="../images/2018/system-logo.png"></div>
	</div>
	
	<div class="br-sideleft overflow-y-auto">
		<label class="sidebar-label pd-x-15 mg-t-20"></label>
		<div class="br-sideleft-menu">
			<a href="javascript:showTab('1')" class='br-menu-link active' id="form1_td" data-toggle="tooltip" data-placement="right" title="内容编辑">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-edit tx-22"></i>
					<span class="menu-item-label">内容编辑</span>
				</div><!-- menu-item -->
			</a><!-- br-menu-link -->
		</div><!-- br-sideleft-menu -->

		<%if(Version==1){%>
		<div class="br-sideleft-menu">
			<a href="javascript:showTab('2')" class="br-menu-link" id="form2_td" data-toggle="tooltip" data-placement="right" title="历史版本">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-history tx-22"></i>
					<span class="menu-item-label">历史版本</span>
				</div><!-- menu-item -->
			</a><!-- br-menu-link -->
		</div><!-- br-sideleft-menu -->
		<%}%>
	</div>

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
			    <button type="button" class="btn btn-secondary tx-size-xs mg-r-5" onclick="Save(2);">完成</button>
				<%if(end!=1){%>
				<button type="button" class="btn btn-secondary tx-size-xs mg-r-5" onclick="Save(1);">驳回</button>
				<button type="button" class="btn btn-secondary tx-size-xs mg-r-5" onclick="Save(0);">通过</button>
				<%}%>
				
				<button type="button"  class="btn btn-secondary tx-size-xs mg-r-10" onclick="self.close();window.opener.document.location.reload();">关闭</button>			   
			</div>
		</div><!-- br-header-right -->
	</div><!-- br-header -->

	<div class="br-mainpanel br-mainpanel-file overflow-hidden" data-approve="<%=data_approve%>" data-yl="<%=data_yl%>" id="form1">  
		<div class="br-pagebody left-page-body bg-white mg-l-30 mg-r-20">
			<div class="br-content-box pd-20">
				<div class="mg-l-15 mg-b-15 pd-r-30">  
					<%
					Field field_title = channel.getFieldByFieldName("Title");
					%>
					<div class="row flex-row align-items-center mg-b-15" id="">
						<label class="left-fn-title wd-120" id=''><%=field_title.getDescription()%>：</label>
						<label class="wd-content-lable d-flex " id="">
							<%=item!=null?Util.HTMLEncode(item.getValue("Title")):""%>
						</label>							
					</div>
					<%
					Field field_PublishDate = channel.getFieldByFieldName("PublishDate");
					%>
					<div class="row flex-row align-items-center mg-b-15" id="">
						<label class="left-fn-title wd-120" id=''><%=field_PublishDate.getDescription()%>：</label>
						<label class="wd-content-lable d-flex " id="">
							<%=item!=null?item.getPublishDate():Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")%>
						</label>							
					</div>
					<div class="row flex-row align-items-center mg-b-15" id="">
						<label class="left-fn-title wd-120" id=''>作者：</label>
						<label class="wd-content-lable d-flex " id="">
							<%=item!=null?CmsCache.getUser(item.getUser()).getName():""%>
						</label>							
					</div>
					<%
					Field field_Content = channel.getFieldByFieldName("Content");
					%>
					<div class="row flex-row align-items-top mg-b-15" id="">
						<label class="left-fn-title wd-120" id=''><%=field_Content.getDescription()%>：</label>
						<div class="wd-content-div" id="">
							<%if(item!=null){
								String content = item.getContent().replaceAll(outer_url,inner_url);
								content = content.replace("src=\"", "src=\""+SiteAddress) ;
								out.print(content);
							}%>
						</div>							
					</div>
					<%
					ArrayList<Field> fields = channel.getFieldInfo();
					for (int i = 0; i < fields.size(); i++) 
					{
						Field field = (Field) fields.get(i);
						if(field.getName().equals("Title")||field.getName().equals("PublishDate")||field.getName().equals("Content")||field.getIsHide()==1){
							continue;
						}
					%>
					<div class="row flex-row align-items-top mg-b-15" id="">
						<label class="left-fn-title wd-120" id=''><%=field.getDescription()%>：</label>
						<%
						String videourl = "";
						if(field.getName().equals("videourl")&&!item.getValue("videourl").equals("")){
							videourl = item.getValue("videourl");
						%>
						<div class="wd-content-div" id="">
							<script>tide_player.showPlayer({video:"<%=videourl%>",width:"100%",height:"100%"});</script>
						</div>
						<%
						}else if(field.getName().equals("videoid")&&!item.getValue("videoid").equals("")&&item.getIntValue("videoid")!=0){
							ArrayList<Document> doc_list = item.getItemUtil().listChildItems(item.getIntValue("videoid"),4," limit 1");
							for(int j=0;j<doc_list.size();j++){
								videourl = doc_list.get(j).getValue("Url");
							}
						%>
						<div class="wd-content-div" id="">
							<script>tide_player.showPlayer({video:"<%=videourl%>",width:"100%",height:"100%"});</script>
						</div>
						<%
						}else if(field.getName().equals("Photo")&&!item.getValue("Photo").equals("")){
							String photoUrl = item.getValue("Photo").replaceAll(outer_url,inner_url);
							if(!photoUrl.contains("http")){
								photoUrl=SiteAddress+"/"+photoUrl;
							}
						%>
						<div class="wd-content-img" id="">								
							<p style="white-space: normal;">
								<img src="<%=photoUrl%>" alt=""/>
							</p>
						</div>
						<% 
						}else{
						%>
						<label class="wd-content-lable d-flex " id="">
							<%=item!=null?item.getValue(field.getName()):""%>
						</label>
					<%}%>
					</div>
					<%}%>
				</div>
			</div>
		</div>
	</div>

	<div class="br-mainpanel br-mainpanel-file overflow-hidden" style="display:none;" url="" id="form2"> 
		<iframe id="content_historical_version" class="content-edit-frame" style="width:100%;min-height:960px;height:100%;" frameborder="0" marginheight="0" marginwidth="0" scrolling="auto" src="../content/content_historical_version.jsp?GlobalID=<%=GlobalID%>&type=1"></iframe>
	</div>
	
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/summernote/summernote-bs4.min.js"></script>
	<script src="../lib/2018/summernote/summernote-zh-CN.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<script src="../lib/2018/peity/jquery.peity.js"></script>
	<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
	<script src="../lib/2018/medium-editor/medium-editor.js"></script>
	<script src="../common/2018/bracket.js"></script>

	<script>
		$(function() {
			'use strict';

			$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

			$('.br-mailbox-list,.br-subleft').perfectScrollbar();

			$('#showMailBoxLeft').on('click', function(e) {
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
				shadowColor: "#ffffff",
				textColor: "000000",
				trigger: "hover"
			});

			//自定义部分
			var height = document.documentElement.clientHeight - 300;
			$('#summernote').summernote({
				height: height,
				lang: "zh-CN",
				focus: true,
				tooltip: false,
				callback: {

				}
			})
		});
		
		//本地预览
		function Preview2()
		{
			window.open("../content/document_preview.jsp?ItemID=<%=ItemID%>&ChannelID=<%=ChannelID%>");
		}
		//审核预览
		function approve_preview(versionid)
		{
			window.open("../content/preview_version.jsp?vid="+versionid+"&ItemID=<%=ItemID%>&ChannelID=<%=ChannelID%>");
		}

		//refresh为true，刷新url
		function showTab(n,refresh)
		{
			if(document.body.disabled) return;

			for(i=1;i<=2;i++)
			{
				$("#form"+i).hide();
				$("#form"+i+"_td").removeClass('active');
			}
			$("#form"+n+"_td").addClass('active');
			$("#form"+n).show();
			var url = $("#form"+n).attr("url")+"";//alert(url);
			url = url.replace("itemid=0","itemid="+$("#ItemID").val());
			url = url.replace("globalid=0","globalid="+$("#GlobalID").val());
			if(url!="")
			{
				if($("#iframe"+n).attr("src")=="../null.jsp" || refresh) $("#iframe"+n).attr("src",url);//document.getElementById("iframe"+n).src = url;
			}
			if($("#iframe"+n).length>0){
				$("#form"+n).find(".br-content-box").css("background-color","#e9ecef")
				if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
					$("#iframe"+n).get(0).style.height = $("#iframe"+n).get(0).contentWindow.document.body.scrollHeight+40+"px";
				}else{
					$("#iframe"+n).get(0).style.height = $("#iframe"+n).get(0).contentWindow.document.documentElement.scrollHeight+40+"px";
				}
			}
			
		}
	</script>
</body>
</html>
