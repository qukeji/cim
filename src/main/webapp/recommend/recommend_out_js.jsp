<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ItemID		=	getIntParameter(request,"ItemID");
int		ChannelID	=	getIntParameter(request,"ChannelID");
int		toChannelID	=	getIntParameter(request,"sourceChannelID");//推荐到的频道

String js = "";
if(ChannelID!=0 && ItemID!=0 && toChannelID>0)
{

	/*if(ch.getListProgram().length()>0)
	{
		response.sendRedirect(ch.getListProgram()+"?ItemID="+ItemID+"&ChannelID="+ChannelID+"&sourceChannelID="+SChannelID+"&Type=recommend_out_js.jsp");return;
	}*/
	js = new Recommend().RecommendOut(ItemID,ChannelID,toChannelID);
}
//System.out.println(js);
%><%=js%>
function initRecommendContent()
{
	try{
	setContent(RecommendContent,false);
/*	var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
	var FCK			= editor.getFCK() ;
	FCK.SetHTML(RecommendContent);*/
	}catch(er){	window.setTimeout("initRecommendContent()",5);}
}