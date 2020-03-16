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
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>工作量统计 TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">
<style>
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/jquery.ztree.core.js"></script>
<script type="text/javascript" src="../common/jquery.ztree.excheck.js"></script>
<script type="text/javascript">
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
</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
        <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">系统管理 / 工作量统计 / 频道发稿量 </a></span>
        </nav>
        </div><!-- br-pageheader -->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
       
        <div class="btn-group mg-l-10 hidden-xs-down">
		  <a href="#" class="btn btn-outline-info btn-search" onClick="downexcle();">导出</a>       
        </div><!-- btn-group -->
     </div>
	  <!--搜索-->
     <div class="search-box pd-x-20 pd-sm-x-30" id="SearchArea">
		<div class="search-content bg-white">
			<form <form name="search_form"  action="report_column2018.jsp" method="post">
      		<div class="row">
				<!--用户信息-->
				<div class="wd-80 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">站点:</div>
				<div class="mg-r-20 mg-b-40 search-item">
                        <select class="form-control select2" name="site_data" id="site_data">
						</select>                                
				</div>
				<div class="mg-r-20 mg-b-40 search-item">
                       <input class="form-control select2" name="child" id="child" type="text" value="<%=child%>" readonly="true"  onclick="showMenu(); return false;"></input>                              
				</div>
				<input name="child_channel" id="child_channel" type="hidden" value="<%=child_channel%>"/>
                <div class="mg-r-20 mg-b-40 search-item">
				       <label class="ckbox mg-b-20">
                        <input  type="checkbox" size="8" name="ischilde" id="ischilde" value="<%=ischilde%>"  <%if("1".equals(ischilde)) out.print("checked");%> /> <span>包含子频道</span>                             
				       </label>
				</div>	
			   <div class="search-item mg-b-30">
					<input name="Submit" type="Submit" value="查找" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14" />
			    </div>				
			</div><!-- row -->			
			</form>
      	</div>
     </div><!--搜索-->	
	 
<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">		
			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>				
					<th class="tx-12-force tx-mont tx-medium">频道名称:</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">所属站点</th>						
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">本天</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本周</th>	
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">本月</th>	
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">本年</th>				
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
			<td class="hidden-xs-down"><%=ch.getName()%></td>				
			<td class="hidden-xs-down" ><%=ch.getSite().getName()%></td>	
            <td class="hidden-xs-down" <%if(today>0){%> onClick="showDetails('today',<%=Rs.getString("ChannelID")%>)"<%}%>><%=today%></td>		
            <td class="hidden-xs-down" <%if(week>0){%>  onClick="showDetails('week',<%=Rs.getString("ChannelID")%>)"<%}%>><%=week%></td>
            <td class="hidden-xs-down" <%if(month>0){%> onClick="showDetails('month',<%=Rs.getString("ChannelID")%>)"<%}%>><%=month%></td>
			<td class="hidden-xs-down" <%if(year>0){%>  onClick="showDetails('year',<%=Rs.getString("ChannelID")%>)"<%}%>><%=year%></td>
		</tr>
<%
}
tu.closeRs(Rs);
%>
 </tbody> 
</table> 
			<div id="tide_content_tfoot">	
          		<span class="mg-r-20 ">查询用时:<%=(System.currentTimeMillis()-begin_time)%>毫秒</span>         		       
			</div>
			
			</div>
	 </div>
	 <div id="menuContent" class="menuContent" style="display:none; position: absolute;">
	    <ul id="treeDemo" class="ztree" style="margin-top:0; width:120px;"></ul>
     </div>
	 </div>
</body>
</html>
