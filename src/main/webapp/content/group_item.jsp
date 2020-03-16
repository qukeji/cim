<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		FieldID		=	getIntParameter(request,"FieldID");
int		ChannelID	=	getIntParameter(request,"ChannelID");
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript">
var FieldID = <%=FieldID%>;

function addDocument(r_itemid,r_channelid)
{
	if(FieldID>0)
	{
		opener.groupItemJS(r_itemid,r_channelid,0);
		top.close();
	}
	else
	{
		this.location = "document.jsp?ItemID=0&ChannelID=" + <%=ChannelID%> + "&RecommendItemID=" + r_itemid + "&RecommendChannelID=" + r_channelid;
	}
}
</script>
</head>

<frameset id="mainFrm" cols="180,*"  frameborder="0" framespacing="0">
  <frame name="menu" src="group_left.jsp?FieldID=<%=FieldID%>&ChannelID=<%=ChannelID%>" scrolling="NO">
  <frame name="main" src="group_content.jsp">
<noframes><body bgcolor="#FFFFFF" text="#000000">

</body></noframes>
</frameset>

</html>
