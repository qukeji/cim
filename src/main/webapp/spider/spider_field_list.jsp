<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");
int Parent = getIntParameter(request,"Parent");

if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");
	SpiderField s = new SpiderField(id);

	s.Delete(id);

	response.sendRedirect("spider_field_list.jsp?Parent=" + Parent);return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script language=javascript>
function addField()
{
	var	dialog = new top.TideDialog();
	dialog.setSuffix('_2');
	dialog.setWidth(500);
	dialog.setHeight(460);
	dialog.setUrl("spider/spider_field_add.jsp?Parent=<%=Parent%>");
	dialog.setTitle("新建字段配置");
	dialog.show();
}

function editField(id)
{
	var	dialog = new top.TideDialog();
	dialog.setSuffix('_2');
	dialog.setWidth(500);
	dialog.setHeight(460);
	dialog.setUrl("spider/spider_field_edit.jsp?id=" + id);
	dialog.setTitle("编辑字段配置");
	dialog.show();
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav"></div>
    <div class="content_new_post">
        <a href="javascript:addField();" class="second">添加</a>
    </div>
</div>

<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;">名称</th>
    				<th class="v1"	align="center" valign="middle">字段</th>
    				<th class="v9" width="120" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody> 
<%
UserInfo userinfo = new UserInfo();
String ListSql = "select * from spider_field";
String CountSql = "select count(*) from spider_field";

ListSql += " where Parent=" + Parent;
CountSql += " where Parent=" + Parent;

ResultSet Rs = userinfo.List(ListSql,CountSql,1,1000);
%><!--<%=(System.currentTimeMillis()-begin_time)%>ms--><%
if(userinfo.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				String Name = convertNull(Rs.getString("Name"));
				String Field = convertNull(Rs.getString("Field"));
				int id = Rs.getInt("id");

				j++;
				%><!--<%=(System.currentTimeMillis()-begin_time)%>ms--><%
%>

	<tr id="jTip<%=j%>_id">
    <td class="v1" width="30" align="center" valign="middle"><%=j%></td>
    <td class="v3" align="center" valign="middle"><%=Name%></td>
	<td class="v1" align="center" valign="middle"><%=Field%></td>
	<td class="v9"><a href="javascript:editField(<%=id%>);" class="operate">编辑</a>&nbsp;<a href="spider_field_list.jsp?Action=Del&id=<%=id%>&Parent=<%=Parent%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a>
	</td>
  </tr>
<%
			}			
%>
<%
}
userinfo.closeRs(Rs);
%>
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
        	<div class="select"></div>
        	<div class="left"></div>
            <div class="center"></div>
        </div>
  </div>
 
</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
</body></html>