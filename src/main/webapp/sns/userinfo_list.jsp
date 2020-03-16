<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//社区管理->社区用户 列表页 2015.3.9
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
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

Channel channel = CmsCache.getChannel(id);
if(channel==null || channel.getId()==0)
{
	response.sendRedirect("../content/content_nochannel.jsp");
	return;
}

Channel parentchannel = null;
int ChannelID = channel.getId();
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();
String gids = "";
/*
if(channel.getListProgram().length()>0)
{response.sendRedirect(channel.getListProgram()+"?id="+id);return;}
*/
String S_Title			=	getParameter(request,"Title");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list",request.getCookies()));
if(listType==0) listType = 1;
//if(listType==2)//图片列表形式
//	response.sendRedirect("content_image.jsp?id="+id);

boolean listAll = false;

if(channel.isTableChannel() && channel.getType2()==8) listAll = true;
if(channel.getIsListAll()==1) listAll = true;
if(S_IsIncludeSubChannel==1) listAll = true;

if(channel.getType()==2)
{
	response.sendRedirect("../page/content_page.jsp?id="+id);
	return;
}


//如果是“新建应用”；
if(channel.getType()==3)
{
	response.sendRedirect("app.jsp?id="+id);
	return;
}

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}

boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);

String SiteAddress = channel.getSite().getUrl();
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
<script type="text/javascript" src="../common/2018/content.js"></script>

<script>
var listType = <%=listType%>;
var rows = <%=rows%>;
var cols = <%=cols%>;
var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var pageName = "<%=pageName%>";
if(pageName=="") pageName = "content.jsp";

function gopage(currpage)
{
	var url = pageName + "?currPage="+currpage+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
	this.location = url;
}

function list(str)
{
	var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
	if(typeof(str)!='undefined')
		url += "&" + str;
	this.location = url;
}
function double_click()
{
	jQuery("#oTable .tide_item").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		var id = $(this).attr("id_");
		obj.trigger("click");
		window.open("http://sns.tidedemo.com/admincp.php?ac=space&op=manage&uid=" + id);
	});
}
function Preview22(id){
	window.open("http://sns.tidedemo.com/space.php?uid=" + id);
}
</script>
</head>
<body class="collapsed-menu email" id="channel-manage">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
	
	<div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active"><%=channel.getParentChannelPath().replace(">"," / ")%></span>
        </nav>
    </div><!-- br-pageheader -->

<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;
if(IsDelete==1) IsActive=0;

if(!S_User.equals("")){
	TableUtil tu2 = new TableUtil();
	String sql2="select * from userinfo where Name='"+tu2.SQLQuote(S_User)+"'";	
	ResultSet Rs2 = tu2.executeQuery(sql2);
	if(Rs2.next()){
		S_UserID=Rs2.getInt("id");
	}else{
		S_UserID=0;
	}
}

//System.out.println("time:"+weightTime);
String Table = channel.getTableName();
String ListSql = "select A.username,B.email,B.videopic,A.groupid,A.avatar,A.experience,FROM_UNIXTIME(A.updatetime) as updatetimeA,FROM_UNIXTIME(A.dateline) as datelineA,A.credit,A.friendnum,A.name,A.uid,B.sex from uchome_space as A,uchome_spacefield as B where A.uid=B.uid ";
String CountSql = "select count(*) from uchome_member as A,uchome_spacefield as B where A.uid=B.uid";

String WhereSql = "";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and A.username like '%" + channel.SQLQuote(tempTitle) + "%'";
}

ListSql += WhereSql;
CountSql += WhereSql;

int listnum = rowsPerPage;
if(listType==3) listnum = cols*rows;

TableUtil tu = channel.getTableUtil();
ResultSet Rs = null;

try{

Rs = tu.List(ListSql,CountSql,currPage,listnum);


int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
%>

	<!--操作-->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

		<!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
          <div class="dropdown-menu pd-10">
            <nav class="nav nav-style-1 flex-column">
			  <a href="#" class="nav-link">搜索</a>
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <div class="btn-group mg-l-10 hidden-xs-down">
          <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div><!-- btn-group -->
        
        <div class="btn-group mg-l-10 hidden-sm-down">
          <%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a><%}%>
          <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a><%}%>
        </div><!-- btn-group -->

    </div><!--操作-->

	<!--搜索-->
     <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
		<div class="search-content bg-white">
			<form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">
      		<div class="row">
				<!--标题-->
				<div class="mg-r-10 mg-b-30 search-item">
				  <input class="form-control search-title" placeholder="用户名" type="text" name="Title" value="<%=S_Title%>">
				</div>
				<div class="search-item mg-b-30">
					<input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
					<input type="hidden" name="OpenSearch" id="OpenSearch" value="0">
				</div>
			</div><!-- row -->
			</form>
      	</div>
     </div><!--搜索-->

<%if(channel.hasRight(userinfo_session,1)){%>

		<!--列表-->
	 <div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0 <%=listType==2?"table-fixed":""%>" id="content-table">
<%if(listType==1){%>
				<thead>
					<tr id="oTable_th">
						<th class="wd-5p">
						  <label class="ckbox mg-b-0">
							<input type="checkbox" id="checkAll"><span></span>
						  </label>
						</th>
						<th class="tx-12-force tx-mont tx-medium">头像/用户名/姓名</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">性别</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">用户组</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">经验值/好友/积分</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">注册时间/更新时间</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">邮箱</th>
    					<th class="tx-12-force wd-150 tx-mont tx-medium hidden-xs-down">操作</th>
  					</tr>
				</thead>
<%}%>
				<tbody> 

<%
int j = 0;
int m = 0;

while(Rs!=null && Rs.next())
{
	int id_ = Rs.getInt("A.uid");

	String updatetime = convertNull(Rs.getString("updatetimeA"));
	updatetime=Util.FormatDate("yyyy-MM-dd HH:mm:ss",updatetime);

	String dateline	= convertNull(Rs.getString("datelineA"));
	dateline=Util.FormatDate("yyyy-MM-dd HH:mm:ss",dateline);
    int avatar	= Rs.getInt("A.avatar");
	System.out.println(avatar+"avatar");
	String username	= convertNull(Rs.getString("A.username"));
	String name	= convertNull(Rs.getString("A.name"));
	String videopic = convertNull(Rs.getString("B.videopic"));
	int experience	= Rs.getInt("A.experience");
    int friendnum	= Rs.getInt("A.friendnum");
	int credit	= Rs.getInt("A.credit");
    int groupid	= Rs.getInt("A.groupid");
	String groupid_ = "";
    if(groupid==0){
		groupid_="无限制";
	}else if(groupid==1){
		groupid_="站点管理员";
	}else if(groupid==2){
		groupid_="信息管理员";
	}else if(groupid==3){
		groupid_="贵宾VIP";
	}else if(groupid==4){
		groupid_="受限会员";
	}else if(groupid==5){
		groupid_="普通会员";
	}else if(groupid==6){
		groupid_="中级会员";
	}else if(groupid==7){
		groupid_="高级会员";
	}else if(groupid==8){
		groupid_="禁止发言";
	}else if(groupid==9){
		groupid_="禁止访问";
	}else {
		groupid_="普通用户";
	}
	int sex	= Rs.getInt("B.sex");
	String email	= convertNull(Rs.getString("B.email"));
	String sex_ = "";
	if(sex==1){
		sex_="男";
	}else if(sex==2){
		sex_="女";
	}else{
		sex_="";
	}
	j++;
	if(listType==1)
	{
%>
		  <tr No="<%=j%>" ItemID="<%=id_%>"  id="item_<%=id_%>" id_="<%=id_%>" class="tide_item">
			<td class="valign-middle">
			  <label class="ckbox mg-b-0">
				<input type="checkbox" name="id" value="<%=id_%>"><span></span>
			  </label>
			</td>
			<%if(avatar==1){%>
			<td class="hidden-xs-down" ondragstart="OnDragStart (event)">
			<img id="img_1" src="http://sns.tidedemo.com/data/avatar/000/00/00/<%=id_%>_avatar_small.jpg">,<%=username%>,<%=name%></td>
			<%}else{%>
			<td class="hidden-xs-down" ondragstart="OnDragStart (event)">
			<img id="img_1" src=" http://sns.tidedemo.com/images/noavatar_small.gif">,<%=username%>,<%=name%></td>
			<%}%>
			<td class="hidden-xs-down"><%=sex_%></td>
			<td class="hidden-xs-down"><%=groupid_%></td>
			<td class="hidden-xs-down"><%=experience%>/<%=friendnum%>/<%=credit%></td>
			<td class="hidden-xs-down"><%=dateline%>/<%=updatetime%></td>
			<td class="hidden-xs-down"><%=email%></td>
			<td class="dropdown hidden-xs-down">
				<a href="javascript:Preview22(<%=id_%>);" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
			</td>
		  </tr>
  <%}	
}

if(listType==2 && m<cols) out.println("</tr>");

tu.closeRs(Rs);
%>
				</tbody> 
			</table>

			<script>
			var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
			</script>  
			
<%if(TotalPageNumber>0){%> 
		
			<!--分页-->
			<div id="tide_content_tfoot">
				<label class="ckbox mg-b-0 mg-r-30 ">
					<input type="checkbox" id="checkAll_1"><span></span>
				</label> 
          		<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
          		<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

				<%if(TotalPageNumber>1){%><%}%>
				<div class="jump_page ">
          			<span class="">跳至:</span>
          			<label class="wd-60 mg-b-0">
						<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
					</label>
					<span class="">页</span>
					<a href="javascript:jumpPage();" class="tx-14">Go</a>
				</div>
          		<%if(listType==1){%>
          		<div class="each-page-num mg-l-20 ">
          			<span class="">每页显示:</span>
          			<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="状态" onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
						<option value="10">10</option>
						<option value="15">15</option>
						<option value="20">20</option>
						<option value="25">25</option>
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="80">80</option>
						<option value="100">100</option>             
					</select>
					<span class="">条</span>
          		</div>

				<%}
				if(listType==2){%>
				<%}%>

			</div><!--分页-->
  <%}%>      
			<div class="table-page-info" style="display: none;">
          		<div class="ckbox-parent">
          			<label class="ckbox mg-b-0">
						<input type="checkbox" id="checkAll"><span></span>
					</label>
          		</div>
			</div>
		</div>
	</div><!--列表-->

	<!--操作-->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

		<!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
          <div class="dropdown-menu pd-10">
            <nav class="nav nav-style-1 flex-column">
			  <a href="#" class="nav-link">搜索</a>
            </nav>
          </div><!-- dropdown-menu -->
        </div><!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <div class="btn-group mg-l-10 hidden-xs-down">
          <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div><!-- btn-group -->
        
        <div class="btn-group mg-l-10 hidden-sm-down">
          <%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a><%}%>
          <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a><%}%>
        </div><!-- btn-group -->

    </div><!--操作-->

<%}else{%>
	<script>
	var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
	</script> 
<%}%>

	<script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>

    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
	<script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script> 


<script>

//==========================================
//设置高亮
var Status1_ = <%=Status1%>;
var IsDelete_ = <%=IsDelete%>;
$(function(){

	if(Status1_==-1){

		$(".list_draft").addClass("active");

	}else if(Status1_==1){

		$(".list_publish").addClass("active");
	
	}else if(IsDelete_==1){

		$(".list_delete").addClass("active");

	}else{
		$(".list_all").addClass("active");
	}
});



//===========================================
      $(function(){
        'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
        
        $(document).on('mouseover', function(e){
          e.stopPropagation();
          if($('body').hasClass('collapsed-menu')) {
            var targ = $(e.target).closest('.br-sideleft').length;
            if(targ) {
              $('body').addClass('expand-menu');

              // show current shown sub menu that was hidden from collapsed
              $('.show-sub + .br-menu-sub').slideDown();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.removeClass('d-lg-none');
              menuText.removeClass('op-lg-0-force');

            } else {
              $('body').removeClass('expand-menu');

              // hide current shown menu
              $('.show-sub + .br-menu-sub').slideUp();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.addClass('op-lg-0-force');
              menuText.addClass('d-lg-none');
            }
          }
        });

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function(e){
          e.preventDefault();
          if($('body').hasClass('show-mb-left')) {
            $('body').removeClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
          } else {
            $('body').addClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
          }
        });
        
    
		$("#content-table tr:gt(0)").click(function () {     
			if ($(this).find(":checkbox").prop("checked"))// 此处要用prop不能用attr，至于为什么你测试一下就知道了。    
			{    
				$(this).find(":checkbox").removeAttr("checked");    
			}else{    
				$(this).find(":checkbox").prop("checked", true);    
			}     
		}); 
		$("#checkAll,#checkAll_1").click(function(){
			var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
			var existChecked = false ;
			for (var i=0;i<checkboxAll.length;i++) {
				if(!checkboxAll.eq(i).prop("checked")){
					existChecked = true ;
				}
			}
			if(existChecked){
				checkboxAll.prop("checked",true);
			}else{
				checkboxAll.removeAttr("checked");
			}
			return;
		})
		$(".btn-search").click(function(){
			$(".search-box").toggle(100);
		})
		     
		    // Datepicker
        $('.fc-datepicker').datepicker({
          showOtherMonths: true,
          selectOtherMonths: true
        });
  
      });
    </script>

<%}catch(Exception e){
	//System.out.println("::"+e.getMessage());
	if(e.getMessage().contains("连接数据库失败"))
	{
		
		out.println("<div class=\"channel-name mg-l-30 mg-r-30\"><div class=\"channel-name-box\"><div class=\"set-img-box\"><i class=\"fa fa-exclamation-triangle tx-50 lh-72\" aria-hidden=\"true\"></i></div><div class=\"right-info\"><h5 class=\"tx-22\">不能获取数据</h5><p class=\"tx-12\">请联系系统管理员确定配置是否正确，或拨打400-0873-128寻求技术支持。</p></div></div></div>");
	}
}%>

</div>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
