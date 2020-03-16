<%@ page
import="org.json.*,tidemedia.cms.util.*"
%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Date" %>
<%@ page import="it.sauronsoftware.jave.Encoder" %>
<%@ page import="tidemedia.cms.video.VideoUtil" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="tidemedia.cms.system.CmsCache" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//栏目管理计算视频类型视频时长
String url = getParameter(request,"videourl");
String ffmpeg_path = CmsCache.getParameter("ffmpeg_path").getContent();
JSONObject json = new JSONObject();
String ffmpeg[] = {ffmpeg_path,"-i", url};
HashMap mapInfo =  VideoUtil.getVideoInfo(ffmpeg);
int duration = 0;
if(mapInfo.get("Duration")!=null){
    String timeInfo = mapInfo.get("Duration").toString();
    duration = VideoUtil.getTime(timeInfo);
}
json.put("status",200);
json.put("duration",duration);
out.println(json);
%>

