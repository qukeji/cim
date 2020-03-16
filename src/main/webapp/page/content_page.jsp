<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.page.*,
				tidemedia.cms.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int id = getIntParameter(request,"id");

Channel channel = CmsCache.getChannel(id);

Page p = new Page(id);

String CategoryName = "";
String CategorySerialNo = "";

//if(channel.getType()==2)
//{
//	response.sendRedirect("page.jsp?id="+id);return;
//}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>

<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
</style>

<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>

<script language=javascript>

function Page()
{
	  	var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		//var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;

  		var url="../page/page.jsp?id=<%=id%>&Type=1";
		//window.open(url,"",Feature);
		window.open(url,"");
}

function Content()
{
	  	var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		//var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;

  		var url="../page/page.jsp?id=<%=id%>";
		//window.open(url,"",Feature);
		window.open(url,"");
}


</script>
</head>

<body class="collapsed-menu email">
<div class="content_t1">
	<div class="br-mainpanel br-mainpanel-file" id="channel-manage">   
		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active"><%=channel.getParentChannelPath().replace(">"," / ")%></span>
			</nav>
		</div><!-- br-pageheader -->
		<div class="channel-name mg-l-30 mg-r-30">
				<div class="channel-name-box">
					<div class="set-img-box">
						<img src="../images/2018/channel-setting.png" />
					</div>
					<div class="right-info">
						<h5 class="tx-22"><%=channel.getName()%></h5>
						<p class="tx-12">您可以进一步进行页面中模块的内容维护或页面属性的编辑。</p>
					</div>
				</div>      	
		  </div>
		<div class="br-pagebody">
	  		<div class="br-section-wrapper">
			 <%if (channel.getType()!=3){%>
	  			<div class="channel-preview">
				    <span class="tx-14 mg-r-10">页面属性：</span>
	  				<span class="tx-14 mg-r-10">[ 名称：<%=channel.getName()%></span>
	  				<span class="tx-14 mg-r-10">页面地址：<a href="<%=Util.ClearPath(p.getSite().getUrl()+"/"+p.getFullTargetName())%>" target="_blank"><span class="font-blue"><%=p.getTargetName()%> ]</span></a></span>
	  			</div>
			
	  			<div class="channel-handle mg-t-20 mg-b-20">
	  				<div class="">
					  <a name="Publish" href="javascript:;" class="btn btn-info mg-r-5 mg-b-10" onClick="Content()">维护页面</a>
					  <%if(new ChannelPrivilege().hasRight(userinfo_session,id,ChannelPrivilege.PageModuleEdit)){%>
					  <a name="Publish" href="javascript:;" class="btn btn-info mg-r-5 mg-b-10" onClick="Page()">编辑页面</a>
					  <%}%>					 
					</div>
	  			</div>
			<%}%>	
	  		</div>
	  	</div>			
	</div>
</div>
</body>
</html>
