<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
//获取用户名
public String getUserName(String users) {
	String userName = "";
	try{
		TableUtil tu = new TableUtil("user");
		String Sql = "select * from userinfo where id in("+users+")";
		ResultSet Rs = tu.executeQuery(Sql);
		while(Rs.next())
		{
			String Name = convertNull(Rs.getString("Name"));
			if(!userName.equals("")&&!Name.equals("")){
				userName += ",";
			}
			userName += Name;
		}
		tu.closeRs(Rs);
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
	return userName;
}
%>
<%
int	ChannelID = getIntParameter(request,"ChannelID");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 20;

if(rows==0)
	rows = Util.parseInt(Util.getCookieValue("rows",request.getCookies()));
if(cols==0)
	cols = Util.parseInt(Util.getCookieValue("cols",request.getCookies()));

if(rows==0)
	rows = 10;
if(cols==0)
	cols = 5;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

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

</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script src="../common/2018/content.js"></script>
<script> 
	var listType = 1 ;
	var ChannelID = <%=ChannelID%>;
	var rows = <%=rows%>;
	var cols = <%=cols%>;
	var currRowsPerPage = <%=rowsPerPage%>;
	var currPage = <%=currPage%>;
	var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
	var pageName = "<%=pageName%>";

	function ok(){
		var result = "";
		var len = $("#oTable input:checked").length;
		if(len!=1)
		{
			alert("请选择一篇文章！");
			return "false";	
		}
		var id = $("#oTable input:checked").val();

		var url = "channel_approveScheme_edit.jsp?id="+id+"&ChannelID="+ChannelID;
		$.ajax({
			 type: "GET",
			 url: url,
			 success: function(msg){
				 top.TideDialogClose({refresh:'right'});
			 }   
		});

	}

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
					<th class="tx-12-force tx-mont tx-medium">选择</th>
					<th class="tx-12-force tx-mont tx-medium">方案名称</th>
				</tr>
			</thead>
			<tbody>
<%
	TableUtil tu = new TableUtil();
	String ListSql = "select * from approve_scheme where Status=0";
	String CountSql = "select count(*) from approve_scheme where Status=0";
	int company = userinfo_session.getCompany();//当前登录用户的租户ID

	//当租户ID不为0的时候，才根据company去查方案表
	if(company!=0)
	{
		ListSql += " and company=" + company;
		CountSql += " and company=" + company;
	}

	 ListSql += " order by id desc";
System.out.println("ListSql:"+ListSql);
	int listnum = rowsPerPage;
	ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
	int TotalPageNumber = tu.pagecontrol.getMaxPages();
	int TotalNumber = tu.pagecontrol.getRowsCount();
	int j = 0;
	while(Rs.next()){
		int id_ = Rs.getInt("id");
		int Status = Rs.getInt("Status");
		String title	= convertNull(Rs.getString("Title"));

		int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
		j++;

%>
			<tr ItemID="<%=id_%>" class="tide_item">					
				<td class="valign-middle">
				  <label class="rdiobox mg-b-0">
					<input name="id" value="<%=id_%>" type="radio"/><span></span>
				  </label>
				</td>
				<td class="hidden-xs-down"><%=title%></td>
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
				<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change('#rowsPerPage','<%=ChannelID%>');" id="rowsPerPage">
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

<div class="btn-box bg-white">
	<div class="modal-footer" >
	  <button name="startButton" type="Submit" class="btn btn-primary tx-size-xs" id="startButton" onclick="ok()">确定</button>
	  <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
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

		var href="channel_approve_scheme.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%>&ChannelID=<%=ChannelID%>";
		document.location.href=href;
	});
});
</script>
</body>
</html>
