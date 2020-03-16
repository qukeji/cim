<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%String contextPath=request.getContextPath();%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script>
function menu(str)
{
var box;
var l;
var r;
var path='<%=contextPath%>';
var left=window.frames["ifm_left"];
var right=window.frames["ifm_right"];
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
	else if(str=="spider")
	{
		box='<img src="../images/manage_stat.gif" />采集系统';
		l=path+"/spider/tree.jsp";
		r=path+"/spider/list.jsp";
	}
	left.location=l;
	right.location=r;
	jQuery("#manage_boxm_title_id").html(box);
}

$(document).ready(function(){
	$("#otherId").mousemove(function(evt){$("#otherListId").show();}).mouseout(function(evt){
		$("#otherListId")[0].timer = setTimeout('$("#otherListId").hide()',200);
		});
	jQuery(document).bind('click',function(){jQuery("#otherListId").hide();});

	var h = ($("#leftTd").height())-($("#submenu").height())-10;
	//alert(h);
	$("#ifm_left").height(h+"px");
});
$(window).resize(function() {
	var h = ($("#leftTd").height())-($("#submenu").height())-20 ;
    $("#ifm_left").height(h+"px");
});
</script>
<script> 
	function toggle_left(){
		$("#leftTd").toggle();
	}
 
</script>

<style>.column_nav iframe{top:35px;}</style><!-- 新增css -->
</head>
<body >

<div class="column_nav" id="leftTd">
	<div class="manage" id="submenu">
        <div class="manage_box">
            	<div class="manage_boxr">
                	<div class="manage_boxm">
                    	<div class="manage_boxm_title" id="manage_boxm_title_id"><img src="../images/system.png" />系统管理</div>
                        <div class="manage_boxm_other" id="otherId">其他</div>
			</div>
		 </div>
	</div>
            <ul class="manage_list" style="display:none;" onmouseover="$('#otherListId').show();clearTimeout($('#otherListId')[0].timer)" onmouseout="$('#otherListId').hide();" id="otherListId">
				<li onclick="menu('system');"><img src="../images/manage_user.gif" />系统管理</li>
				<li onclick="menu('template');"><img src="../images/manage_user.gif" />模板管理</li>
            	<li onclick="menu('user');"><img src="../images/manage_user.gif" />用户管理</li>
                <li onclick="menu('publish');"><img src="../images/manage_course.gif" />发布进程管理</li>
				<li onclick="menu('report');"><img src="../images/manage_stat.gif" />工作量统计</li>
				<!--<li onClick="menu('dict');"><img src="../images/manage_stat.gif" />数据字典</li>-->
				<li onClick="menu('spider');"><img src="../images/manage_stat.gif" />采集系统</li>
               <!-- <li><img src="../images/manage_stat.gif" />统计分析</li>
                <li><img src="../images/manage_log.gif" />操作日志</li>
                <li><img src="../images/manage_backup.gif" />系统内容备份</li>-->
            </ul>
</div>
<iframe frameborder="0" src="tree.jsp" style="width:100%;height:100%;" name="ifm_left" id="ifm_left"></iframe></div>
<div class="column_toggle" id="centerTd">
<div id="div001"><a id="split" class="menu_resize"></a>
<a class="menu_chick" onclick="toggle_left();">
</a><a  id="split2" class="menu_resize"></a></div></div>
<div class="column_viewer" id="rightTd"><iframe frameborder="0" src="site.jsp?id=<%=CmsCache.getDefaultSite().getId()%>" style="width:100%;height:100%;" name="ifm_right" id="ifm_right"></iframe></div>
    
</body>
</html>