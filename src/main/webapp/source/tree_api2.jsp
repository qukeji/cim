<%@ page import="tidemedia.cms.util.Util,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%response.setContentType("text/xml");%><%response.setHeader("Pragma","No-cache"); response.setHeader("Cache-Control","no-cache"); response.setDateHeader("Expires", 0);%><%@ include file="../config.jsp"%><%
//从云资源平台加载频道结构信息
String p = CmsCache.getParameterValue("sys_cloud_source") + "channel_xml.jsp";//云资源中心地址
int id = getIntParameter(request,"ChannelID");
p += "?id="+id;
String s = Util.connectHttpUrl(p,"utf-8");
s = s.replace("../channel/channel_xml.jsp","../source/tree_api2.jsp");
s = s.replace("javascript:show","javascript:showsource");

if(s.equals(""))
{
	s = "<tree><tree text=\"无法连接云资源系统\" action=\"javascript:void();&quot; ChannelID=4 ChannelType=;&quot; 0\" icon=\"../images/tree/16_channel_icon.png\" openIcon=\"../images/tree/16_openchannel_icon.png\"/></tree>";
}
out.println(s);
%>