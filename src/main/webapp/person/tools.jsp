<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String url = request.getRequestURL()+"";
url = url.replace("person/tools.jsp","");
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
	<div class="content_t1_nav">TideCMS工具栏：</div>
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
TideCMS工具栏可以安装到浏览器的书签栏中，提供快速便捷的内容维护服务。   
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
<b>Firefox安装方法：</b><br><br>
1,确认书签工具栏处于显示状态，如果没有显示，点击firefox菜单栏中的“查看 -> 工具栏 -> 书签工具栏”.<br><br>
2,拖动这个按钮：<a href="javascript:(function(){s=document.createElement(&#34;script&#34;);s.type=&#34;text/javascript&#34;;s.src=&#34;<%=url%>tools.jsp&#34;;document.body.appendChild(s);})();" onclick="return false;" style="background:#e3e3e3;border:1px solid #bbbbbb;padding:4px;">TideCMS <%=CmsCache.getCompany()%></a> 到书签工具栏中。
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
<b>IE8安装方法：</b><br><br>
1,确认收藏夹栏处于显示状态，如果没有显示，点击ie菜单栏中的“查看 -> 工具栏 -> 收藏夹栏”.<br><br>
2,在这个按钮：上点击右键，选择“添加到收藏夹”。<br><br>
3,如果弹出一个安全警报，点击“是”。<br><br>
4,创建位置选择“收藏夹栏”，然后点击“添加”按钮。
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
