<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%String contextPath=request.getContextPath();%>
<%
String us = userinfo_session.getUsername();
if(!(userinfo_session.isAdministrator()||us.equals("zhaodanyang")||us.equals("peiliying")||us.equals("zhangge")||us.equals("zhangce")||us.equals("liuchuan")||us.equals("caohai")))
{ response.sendRedirect("../noperm.jsp");return;}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/index.js"></script>
<script>
function menu(str)
{
var box;
var l;
var r;
var path='<%=contextPath%>';
var left=window.frames["left"];
var right=window.frames["right"];
	if(str=="user"){
		box='<img src="../images/manage_user.gif" />用户管理';
		l=path+"/user/user_tree.jsp";
		r=path+"/user/user_list.jsp?GroupID=-1";
	}else if(str=="template"){
		box='<img src="../images/manage_user.gif" />模板管理';
		l=path+"/template/template_tree.jsp";
		r=path+"/template/template_list.jsp";
	}else if(str=="userinfo"){
		box='<img src="../images/manage_user.gif" />模板管理';
		l=path+"/template/template_tree.jsp";
		r=path+"/template/template_list.jsp";
	}else if(str=="system"){
		box='<img src="../images/manage_user.gif" />网站配置';
		l=path+"/system/tree.jsp";
		r=path+"/system/site.jsp?id=<%=CmsCache.getDefaultSite().getId()%>";
	}else if(str=="publish"){
		box='<img src="../images/manage_course.gif" />发布进程管理';
		l=path+"/publish/menu.jsp";
		r=path+"/publish/setup.jsp?SiteId=<%=CmsCache.getDefaultSite().getId()%>";
	}else if(str=="person"){

	}else if(str=="report"){
		box='<img src="../images/manage_stat.gif" />工作量统计';
		l=path+"/report/tree.jsp";
		r=path+"/report/report.jsp";
	}
	else if(str=="dict")
	{
		box='<img src="../images/manage_stat.gif" />数据字典';
		l=path+"/dict/tree.jsp";
		r=path+"/dict/list.jsp";
	}

	left.location=l;
	right.location=r;
	jQuery("#manage_boxm_title_id").html(box);
}

function otherOperation(o){
	jQuery(o.id).click(function(evt){
		jQuery(o.showid).toggle();
		if (!evt)
			window.event.cancelBubble = true;
		else
			evt.stopPropagation();
	});
}

jQuery(document).ready(function(){
	otherOperation({id:'#otherId',showid:'#otherListId'});
	jQuery(document).bind('click',function(){jQuery("#otherListId").hide();});
});
</script>
</head>
<body>
<table width="100%" border="0" height="100%">

  <tr height="100%">
    <td width="194" valign="top" id="leftTd">
	<div class="manage">
        <div class="manage_box">
            	<div class="manage_boxr">
                	<div class="manage_boxm">
                    	<div class="manage_boxm_title" id="manage_boxm_title_id"><img src="../images/manage_user.gif" />工作量统计</div>
			</div>
		 </div>
	</div>
</div>
	<iframe frameborder="0" src="tree.jsp" style="width:100%;height:100%;" name="ifm_left" id="ifm_left"></iframe></td>
    <td width="14" align="center" valign="middle"><a onmousedown="did('split')" id="split" style="cursor:e-resize"><img src="../images/menu_right.png" /></a></td>
    <td valign="top" id="rightTd"><iframe frameborder="0" src="report.jsp" style="width:100%;height:100%;" name="ifm_right" id="ifm_right"></iframe></td>
  </tr>
<!--
  <tr height="100%">
    <td width="194" valign="top" id="leftTd"><iframe frameborder="0" src="../template/template_tree.jsp" style="width:100%;height:100%;" name="right" id="right"></iframe></td>
    <td width="14" align="center" valign="middle"><a onmousedown="did('split')" id="split" style="cursor:e-resize"><img src="../images/menu_right.png" /></a></td>
    <td valign="top" id="rightTd"><iframe frameborder="0" src="../template/template_list.jsp" style="width:100%;height:100%;" name="right" id="right"></iframe></td>
  </tr>
-->
</table>
</body>
</html>