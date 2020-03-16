<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String url = request.getRequestURL()+"";
url = url.replace("person/transfer_tools.jsp",""); 
url = url+"transfer/channel_tree.jsp";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />

<script language=javascript>

var myObject = new Object();
myObject.title = "";

function change(obj)
{
	if(obj!=null)
		this.location = "login_log.jsp?rowsPerPage="+obj.value;
}

function Add()
{
    myObject.title = "新建工作任务";
	var Feature = "dialogWidth:32em; dialogHeight:25em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=person/task_add.jsp",myObject,Feature);
	if(retu!=null)
		window.location.reload();
}

function check()
{
	if(document.form.Description.value=="")
	{
		alert("请输入描述!");
		document.form.Description.focus();
		return false;
	}
	if(document.form.Href.value=="")
	{
		alert("请输入链接!");
		document.form.Href.focus();
		return false;
	}

	return true;
}
</script>
</head>

<body leftmargin="1" topmargin="1" marginwidth="1" marginheight="1" scroll="no">
<div class="content_t1">
	<div class="content_t1_nav">Tide一键转载：</div>
	<div class="content_new_post">


    </div>
</div>


 
<div class="content_2012">

<div class="viewpane_c1" id="SearchArea" >
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
Tide一键转载可以安装到浏览器的书签栏中，提供快速便捷的一键转载服务。   
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>

<div class="viewpane_c1" id="SearchArea" >
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
<b>FireFox浏览器安装方法：</b><br><br>
 拖动这个按钮：<a href="javascript:(function(){href = document.location.href;window.open('<%=url%>?transfer_article='+href);})()" onclick="return false;" style="background:#e3e3e3;border:1px solid #bbbbbb;padding:4px;">Tide一键转载</a> 到firefox地址栏右侧的“显示您的书签”
 
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>

<div class="viewpane_c1" id="SearchArea" >
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
<b>Chrome浏览器安装方法：</b><br><br>
1,确认书签工具栏处于显示状态，如果没有显示，点击Chrome地址栏右侧“自定义及控制”图标(三条横线)->书签->显示书签。快捷键：Ctrl+Shift+B.<br><br>
2,拖动这个按钮：<a href="javascript:(function(){href = document.location.href;window.open('<%=url%>?transfer_article='+href);})()" onclick="return false;" style="background:#e3e3e3;border:1px solid #bbbbbb;padding:4px;">Tide一键转载</a> 到书签栏<br><br>
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>

<div class="viewpane_c1" id="SearchArea" >
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
<b>IE安装方法：</b><br><br>
1,确认收藏夹栏处于显示状态，如果没有显示，IE浏览器顶部右键->勾选 收藏夹栏.<br><br>
2,拖动这个按钮：<a href="javascript:(function(){href = document.location.href;window.open('<%=url%>?transfer_article='+href);})()" onclick="return false;" style="background:#e3e3e3;border:1px solid #bbbbbb;padding:4px;">Tide一键转载</a> 到收藏夹栏<br><br>
3,如果弹出一个安全警报，点击“是”。<br><br>
4,对于ie8等版本，拖动如果不起作用，请点击右键，在弹出的菜单中选择“添加到收藏夹"<br><br>
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>

  	<div class="viewpane">
        <div class="viewpane_tbdoy">


</div>
</div>

</div>
 
</body>
</html>