<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
  *
  *用途：推荐
  *曲科籍 2017-01-17 增加推荐列表功能
  *
  *
  */
int itemid = getIntParameter(request,"ItemID");
int channelid = getIntParameter(request,"ChannelID");

Channel channel = CmsCache.getChannel(channelid);

Document item = new Document(itemid,channelid);
%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 7 列表</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	.collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
	table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
	table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
	border-collapse: collapse !important;}
	.list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;}
	.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/content.js"></script>
<script>
var listType=1;
function double_click()
{
	jQuery("#oTable .tide_item").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		obj.trigger("click");
		editDocument(obj.val(),obj.attr("channel"));
	});
	
}

function editDocument(itemid,ChannelID)
{
  	var url="../content/document.jsp?ItemID="+itemid+"&ChannelID=" + ChannelID;
  	window.open(url);
}
</script>

</head>
<body class="collapsed-menu email">
	<div class="br-mainpanel br-mainpanel-file" id="js-source">

		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active">当前文档：<%=item.getTitle()%></span>
			</nav>
		</div>

		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0" id="content-table">
					<thead>
						<tr>
							<th class="tx-12-force tx-mont tx-medium">标题</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">频道</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">状态</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">日期</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">推荐人</th>
  						</tr>
					</thead>
					<tbody> 
<%
String listSql = "select * from recommend where GlobalID="+item.getGlobalID();

TableUtil tu = new TableUtil();

ResultSet Rs = tu.executeQuery(listSql);
while(Rs.next())
{
	int childGlobalID = Rs.getInt("ChildGlobalID");
	long date = Rs.getLong("CreateDate");
	//System.out.println(date);
	int userid = Rs.getInt("User");
	UserInfo user = (UserInfo)CmsCache.getUser(userid);
	Document item_ = new Document(childGlobalID);
	Channel ch = item_.getChannel();
        int ItemID=item_.getId();
        int ChannelID=ch.getId();
%>
					  <tr >
						<tr No="1" ItemID="<%=ItemID%>" OrderNumber="1"  status="" GlobalID="<%=childGlobalID%>" id="item_<%=ItemID%>" class="tide_item">
						<td>
							<i class="icon ion-clipboard tx-22 tx-warning lh-0 valign-middle"></i>
							<span class="pd-l-5 tx-black"><%=item_.getTitle()%></span>
						</td>
						<td class="hidden-xs-down"><%=ch.getParentChannelPath()%></td>
						<td class="hidden-xs-down"><%=item_.getStatusDesc()%></td>
						<td class="hidden-xs-down"><%=Util.FormatTimeStamp("MM-dd HH:mm",date)%></td>
						<td class="hidden-xs-down"><%=user.getName()%></td>
					  </tr>
  <%}
tu.closeRs(Rs);
%>
					</tbody> 
				</table>
			</div>
		</div>

		<!--
		<div style="position:absolute;right:0;top:120px;display:none;"  id="jTipId">
			<ul class="toolbar2">-->
               <!--<li><a href="#">归档</a></li> -->
                <!--<li  class="first"><a href="javascript:approve();">审核</a></li>
                <li><a href="javascript:Publish();">发布</a></li>
                <li><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:editDocument1();">编辑</a></li>
                <li class="last list" id="otherOperation2">
                	<p>其他<img src="../images/toolbar2_list.gif" /></p>
                    <ul id="ul1" style="display:none;">
                    	<li onclick="deleteFile();">删除</li>
                    	<li onclick="deleteFile2();">撤稿</li>
                        <!--<li class="list_no">内容复制</li>-->
                    <!--</ul>
                </li>
            </ul>
    	</div>
        <div class="select" style="display:none">选择：<span id="selectAll">全部</span><span id="selectNo">无</span></div>          
		-->

		<!--<script src="../lib/2018/popper.js/popper.js"></script>
		<script src="../lib/2018/bootstrap/bootstrap.js"></script>
		<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
		<script src="../lib/2018/moment/moment.js"></script>
		<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
		<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
		<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
		<script src="../lib/2018/select2/js/select2.min.js"></script>
		<script src="../common/2018/bracket.js"></script>-->


	</div>
</body>
</html>
