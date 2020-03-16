<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
int		PageID		= getIntParameter(request,"pageID");
int		ModuleID	= getIntParameter(request,"moduleID");
int		Index		= getIntParameter(request,"Index");

String Param = "pageID=" + PageID + "&moduleID=" + ModuleID;

if(!new ChannelPrivilege().hasRight(userinfo_session,PageID,ChannelPrivilege.PageModuleEdit))
{
	response.sendRedirect("../noperm.jsp");return;
}

if(ModuleID>0)
{
	PageModule pm = new PageModule(ModuleID);

	if(pm.getType()==1)
		{response.sendRedirect("pagemodule_add_1.jsp?" + Param);return;}
	else if(pm.getType()==2)
		{response.sendRedirect("pagemodule_add_2.jsp?" + Param);return;}
	else if(pm.getType()==3)
		{response.sendRedirect("pagemodule_add_3.jsp?" + Param);return;}
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<style>
.form_bottom{bottom:0;}
.form_main{bottom:18px;}
</style>
<script language=javascript>
function show(id)
{
	if(id==1)
		this.location = "pagemodule_add_1.jsp?<%=Param%>";
	else if(id==2)
		this.location = "pagemodule_add_2.jsp?<%=Param%>";
	else if(id==4)
		this.location = "pagemodule_add_4.jsp?<%=Param%>";
	else if(id==5)
		this.location = "pagemodule_add_5.jsp?<%=Param%>";
}
</script>
</head>

<body>
<div class="form_top"><div class="left"></div><div class="right"></div></div>
<div class="form_main">
	<div class="form_main_m">
<table width="100%" border="0">
  <tr>
    <td>
    	<div class="openwin_box" onClick="show(1);">
        	<span class="pic"><img src="../images/openwin_icon_01.jpg"></span>
            <span class="txt">从已有内容结构中获取数据<em class="openwin_help"><img src="../images/openwin_box_help.gif"></em></span>        </div>    </td>
    <td>
    	<div class="openwin_box" onClick="show(5);">
        	<span class="pic"><img src="../images/openwin_icon_04.jpg"></span>
            <span class="txt">新建内容结构并自动获取数据<em class="openwin_help"><img src="../images/openwin_box_help.gif"></em></span>        </div>    </td>
  </tr>
  <tr>
    <td>
    	<div class="openwin_box" onClick="show(2)">
        	<span class="pic"><img src="../images/openwin_icon_02.jpg"></span>
            <span class="txt">直接在编辑器中编辑内容<em class="openwin_help"><img src="../images/openwin_box_help.gif"></em></span>        </div>    </td>
    <td>
    	<div class="openwin_box">
        	<span class="pic"><img src="../images/openwin_icon_05.jpg"></span>
            <span class="txt">通过搜索获取内容数据<em class="openwin_help"><img src="../images/openwin_box_help.gif"></em></span>        </div>    </td>
  </tr>
  <tr>
    <td>
    	<div class="openwin_box">
        	<span class="pic"><img src="../images/openwin_icon_03.jpg"></span>
            <span class="txt">定义关键字自动获取数据<em class="openwin_help"><img src="../images/openwin_box_help.gif"></em></span>        </div>    </td>
    <td>
    	<div class="openwin_box" onClick="show(4)">
        	<span class="pic"><img src="../images/openwin_icon_06.jpg"></span>
            <span class="txt">引入子系统功能内容模块<em class="openwin_help"><img src="../images/openwin_box_help.gif"></em></span>        </div>    </td>
  </tr>
</table>
	</div>
</div>
<div class="form_bottom"><div class="left"></div><div class="right"></div></div>
<div id="ajax_script" style="display:none;"></div>
</body>
</html>