<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				org.json.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
*1、编辑器上传图片，从图片库选择
*2、图片字段上传图片，从图片库选择
*3. 图集上传图片，从图片库选择
*/
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
String flag = getParameter(request,"flag");
int currPage = getIntParameter(request,"currPage");
if(currPage<1)
	currPage = 1;

int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
if(rows==0)
	rows = Util.parseInt(Util.getCookieValue("rows_new",request.getCookies()));
if(cols==0)
	cols = Util.parseInt(Util.getCookieValue("cols_new",request.getCookies()));
if(rows==0)
	rows = 4;
if(cols==0)
	cols = 6;

String sys_config_photo = CmsCache.getParameterValue("sys_config_photo");
JSONObject jo = new JSONObject(sys_config_photo);
int photo_channelid = jo.getInt("channelid");
if(id==0){
	id=photo_channelid;
}

Channel channel = CmsCache.getChannel(id);
if(channel==null || channel.getId()==0)
{
	response.sendRedirect("../content/content_nochannel.jsp");
	return;
}

int ChannelID = channel.getId();

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}
//回传图片频道
String serialNo = "photo_back";
Channel channel2 = CmsCache.getChannel(serialNo);
int back_photoId = 0;
if(channel2!=null){
	back_photoId = channel2.getId();
}

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
<link href="../style/2018/bracket.css" rel="stylesheet" >
<link href="../style/2018/common.css" rel="stylesheet" >
<link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />
<style>
	.collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
	table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
	table.table-fixed,table.table-fixed th,table.table-fixed td{border:none;
	border-collapse: collapse !important;}
	table td{padding: 5px !important;vertical-align: middle;background: #fff;}
	table td .card{padding: 5px;cursor: pointer;border: 2px solid transparent;background-color: rgba(0,0,0,0.01);}
	table td:hover .card{border: 2px solid rgb(69, 152, 225);}
	table td.ac .card{border: 2px solid rgb(69, 152, 225);background: rgba(69, 152, 225, 0.1);}
	.list-pic-box{width: 100%;height: 0;padding-bottom: 75%;overflow: hidden;text-align: center;position: relative;}
	/*.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}*/
	.list-pic-box .list-img-contanier{width: 100%;position: absolute;left: 0;top: 0;height: 100%;display: flex;justify-content: center;align-items: center;}
    .list-pic-box .list-img-contanier img{width: auto;max-height: 100%;max-width: 100%;}
    #tide_content_tfoot1 {padding: .75rem;display: flex;border-top: none;align-items: center;color: #000;}
    .pic-tl{overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 1;-webkit-box-orient: vertical;margin: 5px 0;}

	@media (max-width: 575px){
		#content-table .hidden-xs-down {word-break: normal;	}
	}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/content.js"></script>

<script>
var listType=2 ;
var rows = <%=rows%>;
var cols = <%=cols%>;
var ChannelID = <%=ChannelID%>;
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&currPage="+currPage;
var pageName = "<%=pageName%>";
if(pageName=="") pageName = "content.jsp";

function gopage(currpage)
{
	var url = pageName + "?currPage="+currpage+"&id=<%=id%>";
	this.location = url;
}
function getCheckbox(){
	var id="";
	$(".ac").each(function(i) {
		if(i==0)
			id+=jQuery(this).attr("GlobalID");
		else
			id+=","+jQuery(this).attr("GlobalID");
	});

	var obj={length:jQuery(".ac").length,id:id};
	return obj;
}

</script>
</head>

<body class="collapsed-menu email bg-white">
	<div class="br-mainpanel br-mainpanel-file" id="js-source">

	<!--列表-->
	<div class="br-pagebody pd-x-15 pd-sm-x-20 mg-t-15">
		<div class="card bd-0">
			<table class="table mg-b-0 table-fixed" id="content-table">
				<tbody>
<%
int IsActive = 1 ;
boolean listAll = false ;

String Table = channel.getTableName();
String ListSql = "select id,Title,Photo,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews";
ListSql += " from " + Table;
String CountSql = "select count(*) from "+Table;

if(channel.getType()==Channel.Category_Type)
{
	ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
	CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
}
else if(channel.getType()==Channel.MirrorChannel_Type)
{
	Channel linkChannel = channel.getLinkChannel();
	if(linkChannel.getType()==Channel.Category_Type)
	{
		ListSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
		CountSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
	}
	else
	{
		ListSql += " where Category=0 and Active=" + IsActive;
		CountSql += " where Category=0 and Active=" + IsActive;
	}
}
/*else
{
	ListSql += " where "+ (!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
	CountSql += " where "+(!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
}*/

String WhereSql = " where active = 1";

int company = userinfo_session.getCompany();
if(company!=0)
{
    WhereSql += " and companyid=" + company;
}
if("2".equals(flag)&&back_photoId!=0)
{
    WhereSql += " and Category="+ back_photoId;
}
ListSql += WhereSql;
CountSql += WhereSql;

if(channel.getIsWeight()==1)
{
	ListSql += " order by newtime desc,id desc";
}
else
{
	ListSql += " order by OrderNumber desc";
}
//out.println(ListSql);
int listnum = cols*rows;
    System.out.println("listsql=="+ListSql);
TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();

int j = 0;
int m = 0;
int temp_gid=0;
boolean hasData = false;
while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int category = Rs.getInt("Category");
	int user = Rs.getInt("User");
	int active = Rs.getInt("Active");
	String Title	= convertNull(Rs.getString("Title"));
	int IsPhotoNews = Rs.getInt("IsPhotoNews");
	if(listAll)
	{
		if(category>0)
			Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
	}
	int Weight=Rs.getInt("Weight");
	int GlobalID=Rs.getInt("GlobalID");

	temp_gid++;


	String ModifiedDate	= convertNull(Rs.getString("ModifiedDate"));
	ModifiedDate=Util.FormatDate("MM-dd HH:mm",ModifiedDate);
	String UserName	= CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
	String StatusDesc = "";
	if(Status==0)
		StatusDesc = "<font color=red>草稿</font>";
	else if(Status==1)
		StatusDesc = "<font color=blue>已发</font>";


	j++;

	String Photo	= convertNull(Rs.getString("Photo"));
	String photoAddr = "";
	GlobalID=Rs.getInt("GlobalID");
	if(Photo.startsWith("http://")||Photo.startsWith("https"))
		photoAddr = Photo;
	else
		photoAddr = SiteAddress + Photo;

	if(m==0) out.println("<tr>");
	m++;
%>
		<td GlobalID="<%=GlobalID%>" >
			<div class="card bd-0">
				<div class="list-pic-box">
					<div class="list-img-contanier">
						<img class="card-img-top" src="<%=photoAddr%>" alt="Image" onerror="" >
					</div>
				</div>
			</div>
			<div class="pic-tl"><%=Title%></div>
		</td>
<%
	if(m==cols){ out.println("</tr>");m=0;}
	hasData = true;
}

if(m<cols) out.println("</tr>");

tu.closeRs(Rs);
%>
				</tbody>
			</table>
            <%if(back_photoId==0){%>
            <h4>回调图片频道不存在</h4>
            <%}else if(!hasData){%>
            <h4>没有数据</h4>
            <%}%>
			<script>
				var page={id:'<%=id%>',currPage:'<%=currPage%>',TotalPageNumber:<%=TotalPageNumber%>};
			</script>

<%if(TotalPageNumber>0){%>
			<!--分页-->
			<div id="tide_content_tfoot1">
				<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
				<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>
			<%if(TotalPageNumber>1){%>
				<div class="jump_page ">
					<span class="">跳至:</span>
					<label class="wd-60 mg-b-0">
						<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
					</label>
					<span class="">页</span>
					<a href="javascript:jumpPage();" class="tx-14">Go</a>
				</div>
			<%}%>
				<div class="btn-group mg-l-auto">
					<%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-left"></i></a><%}%>
					<%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a><%}%>
				</div>

			</div>
			<!--分页-->
<%}%>
        </div>
    </div>
	<!--列表-->

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
	$(function() {
		'use strict';

		//show only the icons and hide left menu label by default
		$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

		$(document).on('mouseover', function(e) {
			e.stopPropagation();
			if ($('body').hasClass('collapsed-menu')) {
				var targ = $(e.target).closest('.br-sideleft').length;
				if (targ) {
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

		$('#showMailBoxLeft').on('click', function(e) {
			e.preventDefault();
			if ($('body').hasClass('show-mb-left')) {
				$('body').removeClass('show-mb-left');
				$(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
			} else {
				$('body').addClass('show-mb-left');
				$(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
			}
		});

		//切换选中
		$("#content-table td").click(function() {
			//$("#content-table td").toggleClass("ac");
			$(this).toggleClass("ac")
		});


	});
	</script>

<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->

	</div>
</body>
</html>
