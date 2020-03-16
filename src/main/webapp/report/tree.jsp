<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String us = userinfo_session.getUsername();
if(!(userinfo_session.isAdministrator()||us.equals("zhaodanyang")||us.equals("peiliying")||us.equals("zhangge")||us.equals("zhangce")||us.equals("liuchuan")||us.equals("caohai")))
{ response.sendRedirect("../noperm.jsp");return;}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>menu</title>
<link  type="text/css" rel="stylesheet" href="../style/9/tidecms.css"  />

<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>



<style>.menu_main_2012{top:0;}</style>

</head>
<body>
<div class="menu_main_2012" id="div1">

<script language="javascript"> 
function show(type)
{
	var href;
	if(type==5)
		href='report.jsp';
	else if(type==6)
		href='report2.jsp';
	else if(type==1)
		href='report_person.jsp';
	else if(type==2)
		href='report_depart.jsp';              
	else if(type==3)
		href='report_column.jsp';
	else if(type==4)
		href='report_site.jsp';
	else if(type==7)
		href='report_data.jsp';
	else
		   href='report_all.jsp?type='+type;
	if(parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location =href;
	}
}

var tree = new WebFXTree('','javascript:show(-1)" ChannelID="0');
tree.setBehavior('classic');
var lsh_3620 = new WebFXTreeItem('个人发稿量','javascript:show(1);\" ChannelID=3625 ChannelType=\"5','','../images/report_1.png','../report_1.png');
tree.add(lsh_3620);
lsh_3620 = new WebFXTreeItem('部门发稿量','javascript:show(2);\" ChannelID=3625 ChannelType=\"5','','../images/report_2.png','../images/report_2.png');
tree.add(lsh_3620);
lsh_3620 = new WebFXTreeItem('频道发稿量','javascript:show(3);\" ChannelID=3625 ChannelType=\"5','','../images/report_3.png','../images/report_3.png');
tree.add(lsh_3620);
lsh_3620 = new WebFXTreeItem('站点发稿量','javascript:show(4);\" ChannelID=3625 ChannelType=\"5','','../images/report_4.png','../images/report_4.png');
tree.add(lsh_3620);
var lsh_3620 = new WebFXTreeItem('工作量统计','javascript:show(7);\" ChannelID=3625 ChannelType=\"5','','../images/report_4.png','../images/report_4.png');
tree.add(lsh_3620);
var lsh_3625 = new WebFXTreeItem('报表','javascript:show(5);\" ChannelID=3625 ChannelType=\"5','','../images/report_5.png','../images/report_5.png');
tree.add(lsh_3625);
var lsh_3626 = new WebFXTreeItem('月报表','javascript:show(6);\" ChannelID=3625 ChannelType=\"5','','../images/report_6.png','../images/report_6.png');
tree.add(lsh_3626);



 
	tree.setType('noroot');
	document.write(tree);
	try{
	
	}catch(e){}

//alert($("a[onclick='webFXTreeHandler.focus(this);']").first().attr("onclick"));
$("a[onclick='webFXTreeHandler.focus(this);']").first().click();
show(1);
</script>
</div>


</body>
</html>
