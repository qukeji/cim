<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

int		ChannelID				= getIntParameter(request,"ChannelID");
int		ItemID					= getIntParameter(request,"ItemID");
int     versionId               = getIntParameter(request,"vid");
Channel channel = CmsCache.getChannel(ChannelID);
Document item = CmsCache.getDocument(ItemID,ChannelID);
int globalid = item.getGlobalID();
String versionSql = "select * from article_replica where id="+versionId;
TableUtil verTu = new TableUtil();
ResultSet verRs = verTu.executeQuery(versionSql);
int countNumber =0 ;
while(verRs.next()){
	item.setTitle(verRs.getString("Title"));
	item.setSummary(verRs.getString("Summery"));
	item.setContent(verRs.getString("Content"));
}
verTu.closeRs(verRs);
	
String title = item.getTitle();
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
%>
<!DOCTYPE HTML>
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
	.collapsed-menu .br-mainpanel-file {margin-left: 0px; }
	@media (max-width: 991px) {
		.email .with-second-nav {margin-left: 230px;}
		.collapsed-menu .br-mainpanel-file {margin-left: 0;}
	}
	#nav-header {line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}			
	#nav-header a {color: #a4aab0;}

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
<script type="text/javascript" src="../common/2018/videoPlayer.js"></script>
<script>

var globalid = <%=globalid%>;
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

	var url= "../approve/approve_sumbit.jsp?globalid="+globalid+"&title="+title+"&action="+action+"&user="+user+"&approveId="+approveId+"&endApprove="+endApprove+"&actionMessage="+actionMessage;
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
		<a href="index.html"><img src="../images/2018/system-logo.png"></a>
	</div>

	<div class="br-header">
		<div class="br-header-left">
			<div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
			<div id="nav-header" class="hidden-md-down flex-row align-items-center">
				<%=channel.getParentChannelPath().replaceAll(">"," / ")%>
			</div>
		</div><!-- br-header-left -->
		<div class="br-header-right">
			<div class="btn-box" >	      	
				<button type="button"  class="btn btn-secondary tx-size-xs mg-r-10" onclick="self.close();">关闭</button>			   
			</div>
		</div><!-- br-header-right -->
	</div><!-- br-header -->

	<div class="br-mainpanel br-mainpanel-file overflow-hidden mg-x-30-force">  
		<div class="row row-sm ">
			<div class="col-sm-12 ">
				<div class="br-pagebody left-page-body bg-white">
					<div class="br-content-box pd-20">
						<div class="mg-l-15 mg-b-15 pd-r-30">  
							<%
							Field field_title = channel.getFieldByFieldName("Title");
							%>
							<div class="row flex-row align-items-center mg-b-15" id="">
								<label class="left-fn-title wd-120" id=''><%=field_title.getDescription()%>：</label>
								<label class="wd-content-lable d-flex " id="">
									<%=item!=null?Util.HTMLEncode(item.getTitle()):""%>
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
								%>
									<div class="wd-content-img" id="">								
										<p style="white-space: normal;">
										    <img src="<%=SiteAddress%>/<%=item.getValue("Photo")%>" alt=""/>
										</p>
									</div>
								<%
								}else if(field.getName().equals("Summary")&&!item.getValue("Summary").equals("")){
								%>
									<label class="wd-content-lable d-flex " id="">						
										<%=item!=null?item.getSummary():""%>
									</label>
								<%
								}else{
								%>
									<label class="wd-content-lable d-flex " id="">
										<%=item!=null?item.getValue(field.getName()):""%>
									</label>
								<%}%>
								</div>
							<%
							}
							%>


						</div>
					</div>
				</div>
			</div><!--col-sm-8-->
		</div>
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

			$.ajax({
				type: "get",
				url: "approve_info.jsp?globalid="+globalid+"&channelid=<%=ChannelID%>",
				success: function(msg){
					
					$(".approve_body").html(msg.trim());
					dispalyCardBody();
					
				} 
			});

		});

		
		function dispalyCardBody(){
			var cardBody = $(".approve_body .card-body") ;
			$.each(cardBody, function(va,vi) {
				if($(this).find("div").length>0){
					$(this).removeClass("hide") ;   //hide是你隐藏的类 ，可以随便取
				}
			});
		}

	</script>
</body>
</html>
