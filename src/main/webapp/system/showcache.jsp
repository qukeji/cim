<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.util.concurrent.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int type = Util.getIntParameter(request,"type");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
</head>
<body>

<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
	<div class="toolbar">
    	<div class="toolbar_l">
        	<span class="toolbar1">显示：</span>
            <ul class="toolbar2">
            	<li class="first"><a href="showcache.jsp?type=0">频道</a></li>
                <li><a href="showcache.jsp?type=0">草稿</a></li>
                <li><a href="showcache.jsp?type=0">已发</a></li>
                <li class="last"><a href="showcache.jsp?type=0">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
                <li  class="first"><a href="javascript:approve();">移除</a></li>
            </ul>
        </div>
    </div>
  	<div class="viewpane">
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v1"	align="center" valign="middle">编号</th>
    				<th class="v8"  align="center" valign="middle">名称</th>
    				<th class="v9" width="55" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody> 
<%
int j = 0;
ConcurrentHashMap channels = CmsCache.getChannels();
java.util.Iterator it = channels.entrySet().iterator();
while(it.hasNext())
{
	java.util.Map.Entry entry = (java.util.Map.Entry)it.next();
	Channel channel = (Channel)entry.getValue();
	j++;
%>
  <tr>
    <td class="v1" width="25" align="center" valign="middle"><input name="id" value="<%//=id_%>" type="checkbox"/><%=j%></td>
    <td class="v3" style="font-weight:700;"><%=channel.getId()%></td>
	<td class="v1" align="center" valign="middle"><%=channel.getName()%></td>
    <td class="v8" > <%//=ModifiedDate%></td>
	<td class="v9">
	</td>
  </tr>
<%}%>
 </tbody> 
</table>

        </div> 
  </div>
</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
</script>
</body>
</html>
