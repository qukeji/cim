<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.util.*,tidemedia.cms.user.*,tidemedia.cms.publish.*,org.json.*,magick.*,java.util.*,java.sql.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config1.jsp"%><%

String gids = getParameter(request,"gids");
if(gids.length()==0||gids.equals("undefined")){
	return;
}
String html="";
String[] gid_ = gids.split(",");
for(int i=0;i<gid_.length;i++){
	int gid = Util.parseInt(gid_[i]);
	Document doc = new Document(gid);
	String Photo = doc.getValue("Photo");
	if(!Photo.startsWith("http")){
		String sys_config_photo = CmsCache.getParameterValue("sys_config_photo");
		JSONObject jo = new JSONObject(sys_config_photo);
		int photo_channelid = jo.getInt("channelid");
		String http=CmsCache.getChannel(photo_channelid).getSite().getExternalUrl();
		Photo = http+Photo;
	}
	html += "<p style=\"text-align:center\"><img src=\""+Photo+"\" border=\"0\" alt=\"\" /></p>";
}
out.print(html);
%>
