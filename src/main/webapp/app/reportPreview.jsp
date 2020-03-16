<%@page import="tidemedia.cms.user.UserInfo"%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				org.json.JSONArray,
				org.json.JSONObject,
				java.io.*,
				java.sql.*,
				java.text.DecimalFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%
int globalid =  getIntParameter(request, "parentId");
Document doc = CmsCache.getDocument(globalid);
int itemid = doc.getId();
int channelid = doc.getChannelID();

%>
<script>
var itemid = "<%=itemid%>";
var channelid = "<%=channelid%>";
window.location.href = "document.jsp?ItemID="+itemid+"&ChannelID="+channelid;
</script>