<%@ page import="tidemedia.cms.system.*,
				org.json.*,
				java.sql.*,
				tidemedia.cms.base.*,
				java.io.*,
				tidemedia.cms.util.*,
				org.jsoup.nodes.Element,
				org.jsoup.select.Elements,
				org.jsoup.*,
				java.util.*,
				java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%

String p = CmsCache.getParameterValue("sys_cloud_source") + "channel_xml.jsp";
int id = getIntParameter(request,"ChannelID");
p += "?id="+id;

String s = Util.connectHttpUrl(p,"utf-8");
s = s.replace("../channel/channel_xml.jsp","../source/tree_api2.jsp");
s = s.replace("javascript:show","javascript:showsource");


JSONArray array = new JSONArray();
if(s.equals(""))
{
	JSONObject o = new JSONObject();
	o.put("name", "无法连接云资源系统");
	o.put("id", 4);
	o.put("type", "");
	o.put("icon", "../images/tree/16_channel_icon.png");
	o.put("cloud", 1);
	o.put("load", 0);
	array.put(o);

}else{

	Element tree = Jsoup.parse(s);

	Elements trees = tree.getElementsByTag("tree").get(0).children();



	for(Element element:trees){

		JSONObject o = new JSONObject();

		String text = element.attr("text");
		String action = element.attr("action");
		String ChannelID = action.substring(action.indexOf("ChannelID=")+10);
		ChannelID = ChannelID.substring(0,ChannelID.indexOf(" "));
		String type = action.substring(action.indexOf("ChannelType=\"")+13);
		String icon = element.attr("icon");
		String src = element.attr("src");
		if(src.equals("")){
			o.put("load", 0);
		}else{
			o.put("load", 1);
		}
		o.put("name", text);
		o.put("id", ChannelID);
		o.put("type", type);
		o.put("icon", icon);
		o.put("cloud", 1);
		

		array.put(o);
	}
}
out.println(array);
%>