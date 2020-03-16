<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
int	approveId = getIntParameter(request,"id");

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 20;
String pageName = "";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	
	html,body{
  		width: 100%;
  		height: 100%;
  	}
	.modal-body-btn{bottom:10px;}
	.br-pagebody {
		margin-top: 10px;
	}

</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script src="../common/2018/content.js"></script>
<script> 
	var pageName = "";
	var listType = 1 ;
	var currRowsPerPage = <%=rowsPerPage%>;
	var currPage = <%=currPage%>;
</script>
</head>

<body>
<div class="modal-box">
<div class="modal-body modal-body-btn pd-20 overflow-y-auto">       
	<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">

		<table class="table mg-b-0" id="oTable">
			<thead>
				<tr>
					<th class="tx-12-force tx-mont tx-medium">应用频道</th>
					<th class="tx-12-force tx-mont tx-medium">操作</th>
				</tr>
			</thead>
			<tbody>
<%
	TableUtil tu = new TableUtil();
	String ListSql = "select id from channel where ApproveScheme="+approveId+" order by id desc";
	String CountSql = "select count(*) from channel where ApproveScheme="+approveId;
	int listnum = rowsPerPage;
	ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
	int TotalPageNumber = tu.pagecontrol.getMaxPages();
	int TotalNumber = tu.pagecontrol.getRowsCount();
	int j = 0;
	while(Rs.next()){
		int id_ = Rs.getInt("id");
		
		String path = CmsCache.getChannel(id_).getParentChannelPath();

		int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
		j++;

%>
			<tr>					
				<td class="hidden-xs-down"><%=path%></td>
				<td class="hidden-xs-down">
					<a href="#" class="btn btn-info btn-sm tx-13" onclick="del(<%=id_%>)">删除</a>
				</td>
			</tr>
<%	
	}
	tu.closeRs(Rs);
%>
			</tbody>
		</table>
	<%if(TotalPageNumber>0){%> 
		<div id="tide_content_tfoot">	
			<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
			<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>
			<%if(TotalPageNumber>1){%>
			<div class="jump_page ">
				<span class="">跳至:</span>
				<label class="wd-60 mg-b-0">
					<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
				</label>
				<span class="">页</span>
				<a id="goToId" href="javascript:;" class="tx-14">Go</a>
			</div>
			<%}%>
			<div class="each-page-num mg-l-auto">
				<span class="">每页显示:</span>
				<label class="wd-80 mg-b-0">
				<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change('#rowsPerPage','<%=approveId%>');" id="rowsPerPage">
					<option value="10" >10</option>
					<option value="15" >15</option>
					<option value="20" >20</option>
					<option value="25" >25</option>
					<option value="30" >30</option>
					<option value="50" >50</option>
					<option value="80" >80</option>
					<option value="100">100</option>						
				</select>
				</label> 条
			</div>
		</div>
	<%}%>

		</div>
	</div>
</div>

</div>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#rowsPerPage").val('<%=rowsPerPage%>');

	jQuery("#goToId").click(function(){
		var num=jQuery("#jumpNum").val();
		if(num==""){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;}
		 var reg=/^[0-9]+$/;
		 if(!reg.test(num)){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;
		 }
		if(num<1)
			num=1;

		var href="../approve/approve_channel_index.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%>&id=<%=approveId%>";
		document.location.href=href;
	});
});

function del(channelId){

	if(!confirm("解除频道审核方案，会清空频道下所有未审核通过的操作记录，确认解除吗？")){
		return;
	}

	var url = "../approve/channel_approveScheme_edit.jsp?id=0&ChannelID="+channelId;
	$.ajax({
		 type: "GET",
		 url: url,
		 success: function(msg){
			 var href="../approve/approve_channel_index.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%>&id=<%=approveId%>";
			 document.location.href=href;
		 }   
	});
}
</script>
</body>
</html>