<%@ page import="tidemedia.cms.system.*,
				java.sql.*,
				java.io.*,
				java.util.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%

int channelid = getIntParameter(request,"channelid");//频道ID
String TargetName = getParameter(request,"TargetName");//目标文件名

Channel channel = new Channel(channelid);
String SiteAddress = channel.getSite().getUrl();

//System.out.println("SiteAddress:"+SiteAddress);

String filePath = Util.ClearPath((TargetName.startsWith("/")?"":channel.getFullPath()+"/")+TargetName) ;

out.println(filePath);
%>