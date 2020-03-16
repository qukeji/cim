<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int id = getIntParameter(request,"id");
int channelid = getIntParameter(request,"channelid");

Channel channel = CmsCache.getChannel(channelid);
if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}
Document doc = new Document(id,channelid);//这里获取到的doc就是当前对象吧？如果是 就直接doc.getValue(""),下面的就不用执行了。
String flv = "";
flv = doc.getValue("videoUrl");
//out.println(flv);
/*int channelid_video = CmsCache.getParameter("channelid_video_url_gqg").getIntValue();
ArrayList docs = doc.listChildItems(channelid_video);
for(int i = 0;i<docs.size();i++)
{
	Document d = (Document)docs.get(i);
	flv = d.getValue("videoUrl");
	if(flv.endsWith("_cug.mp4"))
		break;
}*/
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/tidecms7.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" charset="utf-8">
        $(function () {
            tidecms.videoPlayer("tidecms_player","<%=flv%>",640,480);
        });

</script>
</head>
<body>
<div class="content_t1">
<div class="con_video_content" id="tidecms_player"></div>
</div>
</body>
</html>
