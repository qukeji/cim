<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*	修改者		修改日期		备注
*	郭庆光		20130606		修改系统参数sys_video,增加节点video_url,如果系统参数中有此节点，那么预览时用的地址就是此url中地址。否则默认
*								是视频库站点地址。
**/
int id = getIntParameter(request,"id");
int transcode_channelid =4;// CmsCache.getParameter("sys_channelid_transcode").getIntValue();
Document doc = new Document(id,transcode_channelid); 
String flv = doc.getValue("Url");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms7.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/2018/tidePlayer.js"></script>
<style>
	body{background: #000;}
</style>
</head>
<body>
<div class="content_t1">
<div class="con_video_content" id="tidecms_player">
	<script>
		tidePlayer({video:'<%=flv%>',divid:"tidecms_player",width:640,height:458}) 
	</script>
</div>
</div>
</body>
</html>
