<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
int childGroup =  getIntParameter(request,"childGroup");
String time = CmsCache.getExpiresDateStr();  
long current = System.currentTimeMillis();
time  = time.replaceAll("-","/");
Date date = new Date(time);
long ExpiresDate = date.getTime();
long diff = (ExpiresDate - current)/1000; //秒
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
if(CmsCache.hasValidLicense()) diff = 1000000;

String system_logo = CmsCache.getParameter("system_logo").getContent();



int		ChannelID	=	getIntParameter(request,"ChannelID");
int		ItemID		=	getIntParameter(request,"ItemID");
int		type		=	getIntParameter(request,"type");

Document item = new Document(ItemID,ChannelID);
String title = item.getTitle();

%>

<!DOCTYPE html>
<html id="wxMain">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../<%=ico%>">
<title><%=title%></title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../style/2018/bracket.css" rel="stylesheet" >
<link href="../style/2018/common.css" rel="stylesheet" >
<link href="../style/2018/preview.css" rel="stylesheet" >
<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>

<style>	 
	body{background: #fff;}   
    body .menu-item-label,body .menu-item-arrow{display: none; 	opacity: 0;}        
    .br-logo>a span{color:#ffffff}
	.br-mainpanel {margin-left: 0px;}
	.br-header>.nav{align-items:center;}   
    .collapsed-menu .with-first-nav{margin-left: 0;}
    .br-header1 {
    	height: 60px; position: fixed; top: 0; right: 0; left: 0; z-index: 1030; background-color: #fff;
    	box-shadow: 0 1px 4px 0 rgba(0,0,0,.16); display: flex; align-items: center; justify-content: space-between; transition: all .2s ease-in-out;
	} 
    .br-mainpanel{display: flex;align-items: center;justify-content: center;}
	@media (min-width: 992px){
	    .br-header {left: 0px; }
	}
	#preview_nav{margin-left:-136px;}
</style>
<script language=javascript>
    function init()
	{	
		window.status="当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
		set_main_class("index");
		<%if(diff<10*24*3600){%>
			tidecms.dialog("./system/license_notify.jsp",500,300,"许可证到期提醒",2);
		<%}%>
	}


    function set_main_class(str){
        jQuery('.header_menu  li').removeClass('on');
        jQuery('#home_'+str).addClass('on');
    }
    
    //定制减去60
    function changeFrameHeight(_this){
    	$(_this).css("height",document.documentElement.clientHeight-70);
    }
    window.onresize = function(){	
    	if(document.getElementById("content_frame")){
    		document.getElementById("content_frame").style.height =Math.max(document.documentElement.clientHeight-60,0) + "px";				
    	}
    }
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<%
if(ChannelID!=0 && ItemID!=0)
{
	Channel ch = CmsCache.getChannel(ChannelID);

	String SiteAddress = ch.getSite().getUrl();
	if(type==1){//正式地址
		SiteAddress = ch.getSite().getExternalUrl();
	}
	if(!(SiteAddress.endsWith("/") || SiteAddress.endsWith("\\"))){
		SiteAddress += "/";
	}

	ArrayList<ChannelTemplate> cts = ch.getChannelTemplates(2);
%>
	<div class="br-header1">
        <div class="d-flex">
            <div class="d-flex align-items-center tx-center ht-100p wd-100p">
			   <img class="ht-100p" src="../img/2019/<%=system_logo%>">
			</div>
        </div>
		<ul id="preview_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
<%
	int i = 0 ;
	String urlPlace = "";
	String urlPlace1 = "";
	for (ChannelTemplate ct : cts) {
		String label = ct.getLabel();
		int preview = ct.getAllowPreview();
		String template_name = ct.getTemplateFile().getName();//模板名称

		String Address = "../content/document_preview.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID+"&Label="+label;
		if(type==1){
			Address = "../content/document_preview2.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID+"&Label="+label;
		}
     
		String TargetName = ct.getTargetName();
		String Address1 = SiteAddress+(TargetName.startsWith("/")?"":item.getFullPath()+"/")+item.getHref(ct,ItemID);//TargetName;


		if(label!=null&&preview==1){
			i++ ;
			if(i==1){
				urlPlace = Address ;
				urlPlace1 = Address1 ;
			}

			String href_ = "";
			if(label.equals("tv")){
				href_ = "#tv-preview-box";
			}else if(label.equals("wap")){
				href_ = "#app-preview-box";
			}else{
			    href_ = "#pc-preview-box"+i;
			}
%>
			<li class="nav-item">
				<a class="nav-link <%if(i==1){%>active<%}%>" data-url="<%=Address%>" data-html-url="<%=Address1%>" data-toggle="tab" href="<%=href_%>" role="tab" aria-expanded="false"><%=template_name%></a>
			</li>
<%
		}
	}
%>
		</ul>
        <div class="d-flex">
            <a href="javascript:;" id="copyurl" class="btn btn-info mg-r-20 btn-sm" data-clipboard-action="cut" data-clipboard-target="#urlPlace">复制地址</a>
        </div>
    </div>
	<!-- br-header -->
	<!-- ########## START: MAIN PANEL ########## -->

	<div class="br-mainpanel with-first-nav">
<%		
	int j=0 ;
	for (ChannelTemplate ct : cts) {
	    
		String label = ct.getLabel();
		int preview = ct.getAllowPreview();

		if(label!=null&&preview==1){
			j++ ;
			 if(label.equals("tv")){
%>
			<div class="tv-preview-box preview-box noscrollbar <%if(j==1){%>block<%}%>" id="tv-preview-box">
				<div class="iframe-box noscrollbar">
					<iframe class="preview-iframe  noscrollbar" src="<%if(j==1){%><%=urlPlace%><%}%>" width="100%" height="100%" id="tv_content_frame" style="width: 100%;" frameborder="0" onload=""></iframe>
				</div>
			</div>
<%
			}else if(label.equals("wap")){
%>
			<div class="app-preview-box preview-box <%if(j==1){%>block<%}%>" id="app-preview-box">
				<div class="iframe-box">
					<iframe class="preview-iframe  noscrollbar" src="<%if(j==1){%><%=urlPlace%><%}%>" width="100%" height="100%" id="app_content_frame" style="width: 100%;" frameborder="0" onload=""></iframe>
				</div>
			</div>
<%
			}else{
%>		
            	<div class="pc-preview-box preview-box noscrollbar <%if(j==1){%>block<%}%>" id="pc-preview-box<%=j%>">
				<iframe class="preview-iframe  noscrollbar" src="<%if(j==1){%><%=urlPlace%><%}%>" width="100%" height="100%" id="pc_content_frame" style="width: 100%;" frameborder="0" onload="changeFrameHeight(this)"></iframe>		
			</div>
<%
			}
		}
	}
%>		
	</div>

	<!--  urlPlace用来放待复制的地址 -->
	<input type="text" style="position: absolute;left: -500px;" id="urlPlace" value="<%=urlPlace1%>"/>
	<!-- br-mainpanel -->
	<!-- ########## END: MAIN PANEL ########## -->

<%
}
%>
</body>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>

<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../common/2018/bracket.js"></script>
<!--复制插件-->
<script type="text/javascript" src="../common/2018/clipboard.min.js"></script>
	

<script>
	
$(function() {
	'use strict'

	$(window).resize(function() {
		minimizeMenu();
	});

	minimizeMenu();

	function minimizeMenu() {
		if (window.matchMedia('(min-width: 992px)').matches && window.matchMedia('(max-width: 1299px)').matches) {
			// show only the icons and hide left menu label by default
			$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
			$('body').addClass('collapsed-menu');
			$('.show-sub + .br-menu-sub').slideUp();
		} else if (window.matchMedia('(min-width: 1300px)').matches && !$('body').hasClass('collapsed-menu')) {
			$('.menu-item-label,.menu-item-arrow').removeClass('op-lg-0-force d-lg-none');
			$('body').removeClass('collapsed-menu');
			$('.show-sub + .br-menu-sub').slideDown();
		}
	}
	
	
});
    
//默认地址
var previewUrl = "" ;
var previewUrl1 = "";
$("#preview_nav li a").click(function(){

	previewUrl = $(this).attr("data-url") ;
	var _id = $(this).attr("href")
	$(".preview-box").hide();
	$(_id).show();
	_id = _id + " .preview-iframe";
	if($(_id).attr("src")==""){
		$(_id).attr("src",previewUrl);
	}
	
	//复制地址
	previewUrl1 = $(this).attr("data-html-url") ;
	$("#urlPlace").val(previewUrl1);
	
})

//复制相关 
var tdclipboard = new ClipboardJS('#copyurl');
tdclipboard.on('success', function(e) {	    
	var dialog = new top.TideDialog();	   
		dialog.setWidth(260);
		dialog.setHeight(180);		
		dialog.setTitle("提示");
		if (e.text == null || ''==e.text)
			dialog.setMsg("请先配置模板");
		else 
			dialog.setMsg("复制成功！");
		dialog.ShowMsg();
});

</script>

</html>
