<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.page.*,
				java.io.*,
				java.net.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

Page p = new Page(id);

if(!new ChannelPrivilege().hasRight(userinfo_session,id,ChannelPrivilege.PageSourceEdit))
{
	out.println("没有权限.");return;
}

String content = Util.HTMLEncode(p.getContent());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>

<link href="../style/9/page_source.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script language=javascript>
/*function Save()
{
	var	dialog = new TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(150);
		dialog.setTitle("保存");
		dialog.setLayer(2);
		dialog.setType(2);
		var html='正在保存!';
		dialog.setHtml(html);
		dialog.show();
	var tbContentElement=jQuery("#tbContentElement").val();
//alert(encodeURIComponent(tbContentElement));
	jQuery.ajax({
	 type:"POST",
	 url:"save.jsp",
	 data:"id=<%=id%>&Content="+encodeURIComponent(tbContentElement),
	 success:function(msg){
		 html='保存完成!';
		 dialog.changeHtml(html);
		setTimeout("TideDialogClose()",1000*1);
	 } 
	}); 
}
*/

function fixSize() {
	var clientHeight=(document.documentElement.clientHeight ? document.documentElement.clientHeight:document.body.clientHeight);
	clientHeight-=(jQuery("#top").height()+10);
	var width=jQuery("body").width()-8;
	jQuery("#tbContentElement").height(clientHeight);
	jQuery("#tbContentElement").width(width);
}

function init() {
	fixSize();
}
window.onload = init;
window.onresize = fixSize;
</script>
</head>

<body>
<div class="source_main">
<textarea id="tbContentElement" rows="100" cols="50" name="tbContentElement"><%=content%></textarea>
</div>
</body>
</html>