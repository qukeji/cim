<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id=Util.getIntParameter(request,"id");

Site site = new Site();

if(id!=0)
     site=CmsCache.getSite(id);

String code1desc = "";
String code2desc = "";

if(id>0)
{
String code1 = site.getUrlCode(site.getUrl());
String code2 = site.getUrlCode(site.getExternalUrl());
if(code1.endsWith("(200)"))
	code1desc = "<img title='"+code1+"' src='../images/icon/03_02.png'>";
else
	code1desc = "<img title='"+code1+"' src='../images/icon/50.png'>";

if(code2.endsWith("(200)"))
	code2desc = "<img title='"+code2+"' src='../images/icon/03_02.png'>";
else
	code2desc = "<img title='"+code2+"' src='../images/icon/50.png'>";
}
org.json.JSONObject jo = new org.json.JSONObject();
jo.put("code1",code1desc);
jo.put("code2",code2desc);
out.println(jo);
%>