<%@ page import="java.sql.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%if(!CmsCache.hasValidLicense())response.sendRedirect("system/license_edit.jsp?flag=1");
String root = (request.getRequestURL()+"").replace("/blank.jsp","/google_button.jsp");%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 泰得方舟</title>
<link href="style/tidecms7.css" rel="stylesheet" />
<link href="style/style.css" rel="stylesheet" />
<link href="style/tidemedia_center.css" rel="stylesheet" />
<script type="text/javascript" src="common/jquery.js"></script>
<script type="text/javascript" src="common/TideDialog.js"></script>
<script type="text/javascript" src="common/common.js"></script>
<script language=javascript>
var myObject = new Object();
myObject.title = "";

function addShortCut()
{
	var url='person/shortcut_add.jsp';
	tidecms.dialog(url,400,360,"新建快捷方式");
}

function addTask()
{
	var url='person/task_add.jsp';
	tidecms.dialog(url,450,300,"新建任务");
}

function showTask(id)
{
    myObject.title = "查看任务";
	var Feature = "dialogWidth:32em; dialogHeight:20em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("modal_dialog.jsp?target=person/task_detail.jsp&id="+id,myObject,Feature);
	if(retu!=null)
		window.location.reload();
}

function addGoogleButton()
{
	this.location = "http://toolbar.google.com/buttons/add?url=<%=root%>";
}

function set_main_class(str){
	jQuery('#header-nav_id  a').removeClass('cur');
	jQuery('#home_'+str+'  a').addClass('cur');
}

function menu(str)
{
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = "myhome=" + str + ";expires=" + expires.toGMTString();
	if(str=="user"){
		//top.main.location="user/index.jsp";
		top.main.location="system/index.jsp?action=user";
	}
	else if(str=="file"){
		set_main_class(str);
		top.main.location="explorer/index.jsp";
	}else if(str=="channel"){
		set_main_class(str);
		top.main.location="channel/index.jsp";
	}
	else if(str=="sns"){
		set_main_class(str);
		top.main.location="sns/index.jsp";
	}else if(str=="content"){
		set_main_class(str);
		top.main.location="content/index.jsp";
	}else if(str=="lib"){
		//set_main_class(str);
		top.main.location="lib/index.jsp";		
	}else if(str=="template")
		top.main.location="system/index.jsp?action=template";
	else if(str=="userinfo")
		top.main.location="user/my_info.jsp";
	else if(str=="system"){
		//set_main_class(str);
		top.main.location="system/index.jsp?showid=7";
	}
	else if(str=="operate_log"){
		//set_main_class(str);
		top.main.location="system/index.jsp?showid=5";
	}else if(str=="user")
		top.main.location="user/index.jsp";
	else if(str=="publish")
		top.main.location="system/index.jsp?action=publish";
	else if(str=="person"){
		set_main_class(str);
		top.main.location="person/index.jsp";
	}else if(str=="application")
		top.main.location="application/index.jsp";
	else if(str=="source"){
		set_main_class(str);
		top.main.location="source/index.jsp";
	}
}
</script>
</head>

<body>
<div class="product_info">
	<div class="p_i_icon" id="p_i_icon_cms"></div>
    <div class="p_i_txt">
    	<h1>内容汇聚系统<span>TideCMS</span></h1>
        <div class="p_i_ver">版本号：9.0  <a href="#">检查系统更新</a></div>
    </div>
</div>
<div class="product_features">
	<div class="p_f_txt">
    	<ul>
        	<li>
            	<div class="p_f_t_icon"><img src="img/main_icon/4.1.png"></div>
                <div class="p_f_t_summary"><h3>多终端业务管理发布</h3><p>基于灵活的应用管理架构，能够轻松实现对网站、手机客户端、IPTV、互联网电视、社区大屏电视的应用管理，实现基于统一内容的多终端输出，大大提高了编辑与分发效率。</p></div>
            </li>
            <li>
            	<div class="p_f_t_icon"><img src="img/main_icon/4.2.png"></div>
                <div class="p_f_t_summary"><h3>支持多种内容形态及汇聚方式</h3><p>能够实现对音视频、图文、图片集等多种媒体资源的汇聚管理，基于系统的数据结构自定义功能能够进一步实现对各行业数据、产品数据的完美支持与管理。支持数据采集、接口同步、内容批量导入、编辑上传等多种数据组织方式，能够快速实现内容的汇聚组织。</p></div>
            </li>
            <li>
            	<div class="p_f_t_icon"><img src="img/main_icon/4.3.png"></div>
                <div class="p_f_t_summary"><h3>与社会化互动应用整合</h3><p>系统内置了与用户中心、SNS、微信、微博等社会化网络应用的数据整合，能够实现交互资源的互通互用。</p></div>
            </li>
			<li>
            	<div class="p_f_t_icon"><img src="img/main_icon/4.4.png"></div>
                <div class="p_f_t_summary"><h3>多站点集群管理应用</h3><p>基于多站点集群管理能够实现对于多级站点的应用支持，能够实现基于全球、全国网络的分布式部署，便于构建统一数据中心、多级应用管理的统分结构。</p></div>
            </li>
			<li>
            	<div class="p_f_t_icon"><img src="img/main_icon/4.5.png"></div>
                <div class="p_f_t_summary"><h3>所见即所得的管理方式</h3><p>系统全面支持可视化管理操作，基于便捷的操作方式可以实现对页面、专题等内容板块的灵活管理和操作。通过可视化的管理方式，建立良好的用户使用体验，让管理变的更轻松。</p></div>
            </li>
        </ul>
    </div>
    <div class="p_f_video"><img src="img/p_f_video.jpg"></div>
</div>
</body>
</html>