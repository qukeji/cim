<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				tidemedia.cms.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

Channel channel = CmsCache.getChannel(id);

Page p = new Page(id);

String CategoryName = "";
String CategorySerialNo = "";

//if(channel.getType()==2)
//{
//	response.sendRedirect("page.jsp?id="+id);return;
//}

String Action = getParameter(request,"Action");

if(Action.equals("ChangeCanCategory"))
{
	int Status = getIntParameter(request,"Status");
	channel.setCanCategory(Status);

	channel.UpdateCanCategory();

	response.sendRedirect("channel.jsp?id="+id);return;
}

String PublishModeDesc = "";
PublishModeDesc = "静态发布";
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language=javascript>

function Page()
{
	  	var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		//var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;

  		var url="../content/page.jsp?id=<%=id%>";
		//window.open(url,"",Feature);
		window.open(url,"");
}

function editPage()
{
	var myObject = new Object();
    myObject.title = "编辑频道";
	myObject.Type = 0;
	myObject.ChannelID = <%=id%>;
	myObject.ChannelName = "<%=channel.getParentChannel().getName()%>";

 	var Feature = "dialogWidth:32em; dialogHeight:20em;center:yes;status:no;help:no";
	var retu ;

	retu = window.showModalDialog
	("../modal_dialog.jsp?target=channel/page_edit.jsp&ChannelID="+myObject.ChannelID,myObject,Feature);

	if(retu!=null)
		window.location.reload();
}

function deletePage()
{
	var ChannelID = <%=id%>;
	var ChannelName = "<%=channel.getName()%>";

	if(confirm("确实要删除\"" + ChannelName + "\"吗?\r\n注意：频道被删除后不能恢复，而且其下面的子频道将一并删除!")) 
	{
		this.location = "channel_delete.jsp?Action=Delete&id="+ChannelID;
	}
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top">
<table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
        <tr> 
          <td align="right">  </td>
          <td width="20" align="right"></td>
        </tr>
      </table>
      <br>
      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="10">
        <tr> 
          <td>页面属性：</td>
          <td>[名称：<span class="font-blue"><%=channel.getName()%></span> 　　页面地址：<a href="<%=Util.ClearPath(p.getSite().getUrl()+"/"+p.getFullTargetName())%>" target="_blank"><span class="font-blue"><%=p.getTargetName()%>　　</span></a>　　]</td>
        </tr>
        <tr> 
          <td></td>
          <td>&nbsp;
		  <input type=button class="tidecms_btn3" name="Publish" value="编辑页面" onClick="Page()">

		  </td>
        </tr>

        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td height="13">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>
	</td>
  </tr>
</table>
</body>
</html>
