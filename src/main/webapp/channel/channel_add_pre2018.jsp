<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String ChannelID			=Util.getParameter(request,"ChannelID");
String Type					=Util.getParameter(request,"Type");
String ChannelName			=Util.getParameter(request,"ChannelName");
String QueryString	="&ChannelID="+ChannelID+"&Type="+Type+"&ChannelName="+ChannelName;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- Meta -->
<meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
<meta name="author" content="ThemePixels">
<title>TideCMS</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">

<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	.channel-all{
  		display: flex;
  		flex-direction: row;
  		flex-wrap: wrap;
  		justify-content: space-between;
  		margin:5px 0 20px 0;
  	}
  	.channel-all a{
  		background: #639ad7;
  		color: #FFFFFF;
  		width: 45%;  		
  	}
  	.fa-question-circle{
  		color: #639ad7;
  	}
  	
</style>
</head>
<body class="" >
 
    <div class="bg-white modal-box">      
	    <div class="modal-body-nomal pd-20 overflow-y-auto">	        
	   	  <div  class="channel-all">
	   	  	<a href="javascript:;" class="btn mg-r-5 mg-b-10" onclick="show('channel')">普通频道</a>
	   	  	<a href="javascript:;" class="btn mg-r-5 mg-b-10" onclick="show('Page')">页面管理</a>
	   	  	<a href="javascript:;" class="btn mg-r-5 mg-b-10" onclick="show('App')">应用程序</a>
	   	  	<a href="javascript:;" class="btn mg-r-5 mg-b-10" onclick="show('Special')">专题频道</a>
			<a href="javascript:;" class="btn mg-r-5 mg-b-10" onclick="show('Photo')">图片频道</a>
	   	  	<a href="javascript:;" class="btn mg-r-5 mg-b-10" onclick="show('PhotoCollect')">图片集频道</a>
	   	  	<a href="javascript:;" class="btn mg-r-5 mg-b-10" onclick="show('MirrorChannel')">镜像频道</a>
			<a href="javascript:;" class="btn mg-r-5 mg-b-10" onclick="show('channel2')">数据源频道</a>
	   	  </div>	
	   	  <div class="hr_line mg-t-25 mg-b-25"></div>
	   	  <div class="mg-t-15"><a href="javascript:;"><i class="fa fa-question-circle mg-r-3"></a></i><span>关于此部分的说明</span></div>
	    </div>

    </div><!-- br-mainpanel -->
 
    <script src="../lib/2018/jquery/jquery.js"></script>
    
    <script>  
		var ChannelName = '<%=java.net.URLDecoder.decode(ChannelName,"UTF-8")%>';

		function show(type){
			var	dialog = new top.TideDialog();

			switch(type){
			case "channel":
				dialog.setWidth(750);
				dialog.setHeight(600);
				dialog.setUrl('channel_add2018.jsp?<%=QueryString%>');
				dialog.setChannelName(ChannelName);
				dialog.setTitle('普通频道');
				dialog.show();
				break;
			case "MirrorChannel":
				dialog.setWidth(600);
				dialog.setHeight(600);
				dialog.setUrl('mirror_channel_add2018.jsp?<%=QueryString%>');
				dialog.setTitle('镜像频道');
				dialog.setChannelName(ChannelName);
				dialog.show();
				break;	
			case "Page":
                                dialog.setWidth(600);
				dialog.setHeight(500);
				dialog.setUrl('page_add2018.jsp?<%=QueryString%>');
				dialog.setTitle('页面管理');
				dialog.setChannelName(ChannelName);
				dialog.show();
				break;
			case "App":
                dialog.setWidth(600);
				dialog.setHeight(500);
				dialog.setUrl('app_add2018.jsp?<%=QueryString%>');
				dialog.setTitle('应用程序');
				dialog.setChannelName(ChannelName);
				dialog.show();
				break;
			case "Photo":
				dialog.setWidth(750);
				dialog.setHeight(600);
				dialog.setUrl('channel_add2018.jsp?Type2=1<%=QueryString%>');
				dialog.setChannelName(ChannelName);
				dialog.setTitle('图片频道');
				dialog.show();
				break;
			case "PhotoCollect":
				dialog.setWidth(750);
				dialog.setHeight(600);
				dialog.setUrl("channel_add2018.jsp?Type2=2<%=QueryString%>");
				dialog.setChannelName(ChannelName);
				dialog.setTitle("图片集频道");
				dialog.show();
				break;
			case "Special":
				dialog.setWidth(600);
				dialog.setHeight(500);
				dialog.setUrl('channel_special_add2018.jsp?Type2=2<%=QueryString%>');
				dialog.setTitle('专题频道');
				dialog.setChannelName(ChannelName);
				dialog.show();
				break;
			case "channel2":
				dialog.setWidth(750);
				dialog.setHeight(600);
				dialog.setUrl("channel_add2018.jsp?<%=QueryString%>&Type2=2");
				dialog.setChannelName(ChannelName);
				dialog.setTitle("数据源频道");
				dialog.show();
				break;
			}
		}
		function setReturnValue(o){
	if(o.close==1){
		top.TideDialogClose({refresh:'left'});
	}

	if(o.close==2){
		top.TideDialogClose({});
	}
}
    </script>
  </body>
</html>
