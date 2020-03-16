<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.report.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：工作量统计 报表
* 1,蒋泽银 20160325 创建
*/
String us = userinfo_session.getUsername();

String us_ = CmsCache.getParameterValue("report_user")+",";

if(!(userinfo_session.isAdministrator()) && !us_.contains(us+","))
{ 
	response.sendRedirect("../noperm.jsp");
	return;
}

if(!(userinfo_session.isAdministrator()))
{ 
	response.sendRedirect("../noperm.jsp");
	return;
}
String uri = request.getRequestURI();
long begin_time = System.currentTimeMillis();
String child_channel   = getParameter(request,"child_channel");
String ischilde        = getParameter(request,"ischilde");
String child           = getParameter(request,"child");
String site_data       = getParameter(request,"site_data");
if("".equals(site_data)){
	site_data="-1";
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>工作量统计 TideCMS</title>
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<link href="../style/zTreeStyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script type="text/javascript" src="../common/jquery.ztree.core.js"></script>
<script type="text/javascript" src="../common/jquery.ztree.excheck.js"></script>
<style>
div.content_wrap {width: 600px;height:380px;}
div.content_wrap div.left{float: left;width: 250px;}
div.content_wrap div.right{float: right;width: 340px;}
div.zTreeDemoBackground {width:250px;height:362px;text-align:left;}

ul.ztree {margin-top: 10px;border: 1px solid #617775;background: #FFFFFF;width:200px;height:200px;overflow-y:scroll;overflow-x:auto;}
</style>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：工作量统计 > 频道发稿量 </div>
    <div class="content_new_post">
		<div class="tidecms_btn" onClick="downexcle();">
			<div class="t_btn_pic"><img src="../images/icon/43.png" /></div>
			<div class="t_btn_txt">导出</div>
		</div>
    </div>
</div>
<div class="viewpane_c1" id="SearchArea">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20"> </td>
    <td><form name="search_form"  action="report_column.jsp" method="post">
	站点：<select name="site_data" id="site_data"></select>
	频道：<input name="child" id="child" type="text" value="<%=child%>" readonly="true" style="width:120px;" onclick="showMenu(); return false;"></input>
	<input name="child_channel" id="child_channel" type="hidden" value="<%=child_channel%>"/>
	<input name="ischilde" id="ischilde" type="checkbox" value="<%=ischilde%>"  <%if("1".equals(ischilde)) out.print("checked");%>/>包含子频道
	<input name="Submit" type="Submit" class="tidecms_btn2" value="查找" />
	</form></td>
    <td width="20"> </td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content_2012">
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table id="oTable" class="view_table" width="100%" border="0">
<thead>
		<tr>
			<th class="v3" style="padding-left:10px;text-align:left;">频道名称</th>
			<th class="v1" valign="middle" align="center">所属站点</th>
			<th class="v8" valign="middle" align="center">本天</th>
			<th class="v8" valign="middle" align="center">本周</th>
			<th class="v8" valign="middle" align="center">本月</th>
			<th class="v8" valign="middle" align="center">本年</th>
  	    </tr>
</thead>
 <tbody id="content_data"> 
 
<%
TableUtil tu = new TableUtil();
String channelCode ="";
if("".equals(child_channel)){
	child_channel="-1";
}
if("1".equals(ischilde)){
	String sql ="select ChannelCode from item_snap where ChannelID in("+child_channel+")";
	// 'c%'  ChannelCode like 'dsf%' or 
	ResultSet Rs = tu.executeQuery(sql);
	while(Rs.next()){
		channelCode+=" ChannelCode like '"+Rs.getString(1)+"%' or";
	}
	if(channelCode.length()-1==channelCode.lastIndexOf("r") && channelCode.lastIndexOf("or") != -1){
		channelCode = channelCode.substring(0,channelCode.lastIndexOf("or"));
	}
}
String ListSql ="select distinct * from item_snap where ChannelID in("+child_channel+")";
if("1".equals(ischilde) && channelCode.length()>0){
	ListSql += " or "+channelCode;
}
//System.out.println(ListSql);
//out.print(ListSql);
ListSql += " group by ChannelID";
ResultSet Rs = tu.executeQuery(ListSql);
while(Rs.next()){
	int today = ReportUtil.getReport(Rs.getInt("ChannelID"),"today","column");
	int week = ReportUtil.getReport(Rs.getInt("ChannelID"),"week","column");
	int month = ReportUtil.getReport(Rs.getInt("ChannelID"),"month","column");
	int year = ReportUtil.getReport(Rs.getInt("ChannelID"),"year","column");
	Channel ch = new Channel(Rs.getInt("ChannelID"));
%>
	<tr id="item_<%=Rs.getString("ChannelID")%>">
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png"><%=ch.getName()%></td>
	<td class="v1" valign="middle" align="center"><%=ch.getSite().getName()%></td>
    <td class="v8" valign="middle" align="center" <%if(today>0){%> onClick="showDetails('today',<%=Rs.getString("ChannelID")%>)"<%}%>><%=today%></td>
	<td class="v8" valign="middle" align="center" <%if(week>0){%>  onClick="showDetails('week',<%=Rs.getString("ChannelID")%>)"<%}%>><%=week%></td>
	<td class="v8" valign="middle" align="center" <%if(month>0){%> onClick="showDetails('month',<%=Rs.getString("ChannelID")%>)"<%}%>><%=month%></td>
	<td class="v8" valign="middle" align="center" <%if(year>0){%>  onClick="showDetails('year',<%=Rs.getString("ChannelID")%>)"<%}%>><%=year%></td>
  </tr>
<%
}
tu.closeRs(Rs);
%>
 
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
		    <div class="left" style="left:10px;">查询用时：<%=(System.currentTimeMillis()-begin_time)%>毫秒</div>
        </div>
  </div>
</div>
<div id="menuContent" class="menuContent" style="display:none; position: absolute;">
	<ul id="treeDemo" class="ztree" style="margin-top:0; width:120px;"></ul>
</div>
</body>
<script>
var setting = {
check: {
		enable: true,
		chkboxType: {"Y":"", "N":""}
	},

	view: 
	{
		dblClickExpand: false
	},
	data:
	 {
		simpleData:
		{
			enable: true
		}
	},
	callback:
	 {
		beforeClick: beforeClick,
		onCheck: onClick
	}
};
function beforeClick(treeId, treeNode){
    onClick(null, treeId, treeNode);        
}
function onClick(e, treeId, treeNode){
	var zTree = $.fn.zTree.getZTreeObj("treeDemo");
	var nodes = zTree.getCheckedNodes(true);
	nodes.sort(function compare(a,b){return a.id-b.id;});
	 var v = "",id="";
	for (var i=0, l=nodes.length; i<l; i++) 
	{
		v += nodes[i].name + ",";
		id += nodes[i].id + ",";
	}
	
	if (v.length > 0 )
	{
		v = v.substring(0, v.length-1); 
		id = id.substring(0, id.length-1); 
	}
	
	var Obj = $("#child");
	Obj.attr("value",v);
	$("#child_channel").val(id);
}
function showDetails(way,id){
	var dialog = new top.TideDialog();
	dialog.setWidth(800);
	dialog.setHeight(400);
	dialog.setLayer(2);
	dialog.setUrl("./report/analy_tend.jsp?type=column&id="+id+"&dateWay="+way);
	dialog.setTitle("查看发稿量统计详情");
	dialog.show();
}
function downexcle(){
	var data = $("#child_channel").val();
	if(data=="")
	{
		alert("请选择对应频道");
		return;
	}
	if($("#ischilde").val()=="")
	{
		data +=":0";
	}else
	{
		data +=":"+$("#ischilde").val();
	}
	location.href="./down_report.jsp?type=column&where="+data;
}
$(function(){
	$.ajax({
		url:"site_data.jsp",
		type:"post",
		dataType:"json",
		data:"",
		success:function(data)
		{	var html = "";
			$.each(data,function(index,obj)
			{
				if(<%=site_data%>==obj.id)
					html +='<option value="'+obj.id+'" selected="selected">'+obj.name+'</option>';
				else 
					html +='<option value="'+obj.id+'">'+obj.name+'</option>';
			});
			$("#site_data").html(html);
			$("#site_data").change();
		}
	});
});
$("#site_data").change(function(){
	changeChannel($(this).val());
});

function changeChannel(site){
	$.ajax({
		url:"channel.jsp",
		type:"post",
		dataType:"json",
		data:"site="+site,
		success:function(data){	 
			$.fn.zTree.init($("#treeDemo"), setting, data);
		}
	});
}
$("#ischilde").click(function(){
	if(this.checked){
		$(this).val("1");
	}else{
		$(this).val("0");
	}
});

function showMenu(){
			var cityObj = $("#child");
			var cityOffset = $("#child").offset();
			$("#menuContent").css({left:cityOffset.left + "px", top:cityOffset.top + cityObj.outerHeight() + "px"}).slideDown("fast");

			$("body").bind("mousedown", onBodyDown);
		}
function hideMenu() {
	$("#menuContent").fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}
function onBodyDown(event) {
	if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0)) {
		hideMenu();
	}
}
</script>
</html>
