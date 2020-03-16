<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=gb2312" %>
<%@ include file="../config.jsp"%>
<%
String Action = getParameter(request,"Action");
String ReturnValue = "";
//System.out.print("Title:"+Title);
if(!Action.equals(""))
{
	int		ChannelID		= getIntParameter(request,"ChannelID");

	Document document = new Document();

	document.setChannelID(ChannelID);
	document.setUser(userinfo_session.getId());

	if(Action.equals("Add"))
	{
		document.AddDocument(request);
	}
	if(Action.equals("Update"))
	{
		document.UpdateDocument(request);
	}

	int ContinueNewDocument	= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow		= getIntParameter(request,"NoCloseWindow");	
	ReturnValue = "<SPAN id='tide_photo' photoid="+document.getId()+"><script type=\"text/javascript\" src=\"http://news.vodone.com/photo/photo_"+document.getId()+".js\"></script></SPAN>";
}
%>
<script language=javascript>
top.returnValue = "<%=Util.JSQuote(ReturnValue)%>";
top.close();
</script>