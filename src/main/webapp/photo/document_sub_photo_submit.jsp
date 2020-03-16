<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=gb2312" %>
<%@ include file="../config.jsp"%>
<%
String Action = getParameter(request,"Action");
int fieldgroup = getIntParameter(request,"fieldgroup");
//System.out.print("Title:"+Title);
if(!Action.equals(""))
{
	int		ChannelID			= getIntParameter(request,"ChannelID");
	String	RelatedItemsList	= getParameter(request,"RelatedItemsList");

	Document document = new Document();

	HashMap map = new HashMap();
	Enumeration enumeration = request.getParameterNames();
	while(enumeration.hasMoreElements()){
		String name=(String)enumeration.nextElement();
		String values[] = request.getParameterValues(name);
		String values2 = "";
		if(values!=null)
		{
			if(values.length==1)
				values2 = values[0];
			else
				values2 = Util.ArrayToString(values,",");
		}
		map.put(name,values2);
	}

	document.setRelatedItemsList(RelatedItemsList);
	document.setChannelID(ChannelID);
	document.setUser(userinfo_session.getId());

	if(Action.equals("Add"))
	{
		document.AddDocument(map);
	}
	if(Action.equals("Update"))
	{
		document.UpdateDocument(map);
	}

	int ContinueNewDocument	= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow		= getIntParameter(request,"NoCloseWindow");
}
%>
<script>
top.TideDialogClose({refresh:'var url = $("#form<%=fieldgroup%>").attr("url");document.getElementById("iframe<%=fieldgroup%>").src = url;'});
</script>