<%@page import="tidemedia.cms.user.UserInfo"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="tidemedia.cms.util.*,
				java.io.File,
				java.sql.*,
				java.util.*,
				java.text.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
	if(!userinfo_session.isAdministrator())
	{
		response.sendRedirect("../noperm.jsp");
		return;
	}

	int currPage = getIntParameter(request,"currPage");
	int rowsPerPage = getIntParameter(request,"rowsPerPage");
	if(currPage<1)
		currPage = 1;
	if(rowsPerPage<=0)
		rowsPerPage = 20;
	String querystring="";
    if(rowsPerPage==0)
        rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new",request.getCookies()));
	String Action = getParameter(request,"Action");
	if(Action.equals("Del"))
	{
		String id = getParameter(request,"id");
		String id_[] = id.split(",");
		for(int i=0;i<id_.length;i++){
			int  wid = Integer.parseInt(id_[i]);
			Watermark t= new Watermark(wid);
			String title = t.getName();
			t.Delete(wid);
			new Log().WatermarkLog(LogAction.watermark_delete, title, wid, userinfo_session.getId());
		}
		response.sendRedirect("watermark_list.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage);return;
	}
	//图片及图片库配置
	Channel channel = null;
	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();
	int sys_channelid_image = photo_config.getInt("channelid");
	channel = CmsCache.getChannel(sys_channelid_image);
	Site site = channel.getSite();//
	String Path = channel.getRealImageFolder();//图片库地址
	String SiteUrl = site.getExternalUrl();//图片库预览地址
	String SiteFolder = site.getSiteFolder();//图片库目录

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="Shortcut Icon" href="../favicon.ico">
	<title>水印方案列表</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
	<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
	<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
	<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
	<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	
	<link rel="stylesheet" href="../style/theme/theme.css">
	<style>
	
	/*tooltip相关样式*/
    .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
	.tooltip.bs-tooltip-right .arrow::before,
	.tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {			
		border-right-color: #00b297;			
	}
</style>
	<style>
		.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
	</style>
	<script type="text/javascript">
		var listType = 1;//content.js加载前声明变量
	</script>
	<script src="../lib/2018/jquery/jquery.js"></script>
	<script type="text/javascript" src="../common/2018/common2018.js"></script>
	<script type="text/javascript" src="../common/2018/content.js"></script>
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
	
	<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
	<script src="../lib/2018/select2/js/select2.min.js"></script>
	<script src="../common/2018/bracket.js"></script>
	<script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>
	<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
	<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
	<script>
        function Details(id)
        {
            var	dialog = new top.TideDialog();
            dialog.setWidth(650);
            dialog.setHeight(600);
            dialog.setUrl("../watermark/watermark_edit.jsp?id=" + id);
            dialog.setTitle("修改方案");
            dialog.show();
        }

        function addParameter()
        {
            var url='../watermark/watermark_add.jsp';
            var	dialog = new top.TideDialog();
            dialog.setWidth(650);
            dialog.setHeight(600);
            dialog.setUrl(url);
            dialog.setTitle("添加方案");
            dialog.show();
        }
		function Details_(){
			var obj =getCheckbox();
			if(obj.length==0){
				TideAlert("提示","请先选择要编辑的水印方案！");
				return;
			}else if(obj.length>1){
				TideAlert("提示","一次只能对一个水印方案编辑！");
				return;
			}
			Details(obj.id);
		}

		function deleteWatermark(){
			var obj =getCheckbox();
			if(obj.length==0){
				TideAlert("提示","请先选择要删除的水印方案！");
				return;
			}
			message = "确定要删除这"+obj.length+"个水印方案吗？";
			if(!confirm(message)){
				return;
			}	
            this.location="watermark_list.jsp?Action=Del&id="+obj.id;
        }
		function gopage(currpage) {
			var url = "watermark_list.jsp?currPage=" + currpage ;
			this.location = url;
		}
		
		function jumpPage() {
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
            var href="watermark_list.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%>";
            document.location.href=href;
		}
		function Previeww(watermark) {
			var SiteUrl = '<%=SiteUrl%>';
            var SiteFolder = '<%=SiteFolder%>';
            window.open(watermark.replace(SiteFolder,SiteUrl));
		}
        function sort_select(obj){
            this.location="../file_list2018.jsp?sort="+obj+"<%=querystring%>";
        }
        function change(s){
        	var value=jQuery(s).val();
        	document.cookie = "rowsPerPage_new="+value;
        	document.location.href =" watermark_list.jsp?&rowsPerPage="+value;
        }

	</script>

</head>

<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">

	<div class="br-pageheader pd-y-15 pd-md-l-20">
		<nav class="breadcrumb pd-0 mg-0 tx-12">
			<span class="breadcrumb-item active">系统配置管理 / 水印设置</span>
		</nav>
	</div><!-- br-pageheader -->
<%
					TableUtil tu = new TableUtil();
					String ListSql = "select * from watermark order by id asc";
					String CountSql = "select count(*) from watermark";
					//分租户
                    int companyid = userinfo_session.getCompany();
                    if(companyid!=0){
						ListSql = "select * from watermark where companyid in (0," +companyid+") order by id asc";
						CountSql = "select count(*) from watermark where companyid in (0," +companyid+") order by id asc";
					}
					ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
					int TotalPageNumber = tu.pagecontrol.getMaxPages();
					int TotalNumber = tu.pagecontrol.getRowsCount();
					System.out.println("TotalPageNumber=="+TotalPageNumber+",TotalNumber==="+TotalNumber+",currPage"+currPage);

%>
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
		<div class="btn-group mg-l-auto hidden-sm-down">
			<a class="btn btn-outline-info"  onClick="addParameter();">新建</a>
			<a class="btn btn-outline-info"  onClick="Details_();">编辑</a>
			<a class="btn btn-outline-info"  onClick="deleteWatermark();">删除</a>
		</div><!-- btn-group -->
		<div class="btn-group mg-l-10 hidden-sm-down">
		  <%if(currPage>1){%>
			<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
		  <%}%>
		  <%if(currPage<TotalPageNumber){%>
			<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
		  <%}%>
		</div>
	</div>

	<script>

	</script>


	<!-- 列表页  -->
	<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">

			<table class="table mg-b-0" id="content-table">
				<thead>
				<tr>
					<th class="wd-5p wd-50">选择</th>
					<!-- <th class="tx-12-force tx-mont tx-medium" style="text-align: center;width:50px;" >编号</th> -->
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center"><a >名称</a></th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down  wd-80" style="text-align: center"><a>状态</a></th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center"><a>宽度</a></th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center"><a>高度</a></th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center"><a>水平边距</a></th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center"><a>垂直边距</a></th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center"><a>透明度</a></th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center"><a>租户</a></th>
					<!--<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-160" style="text-align: center"><a>发布日期</a></th>-->
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down" style="text-align: center"><a>操作</a></th>
				</tr>
				</thead>
				<tbody>
				<%
					
					
					if(tu.pagecontrol.getRowsCount()>0)
					{
						int j=0;

						while(Rs.next())
						{

							String Name			= convertNull(Rs.getString("name"));
							String CreateDate = convertNull(Rs.getString("CreateDate"));
							String LogoLeft = convertNull(Rs.getString("LogoLeft"));
							String LogoTop = convertNull(Rs.getString("LogoTop"));
							CreateDate = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date(Long.valueOf(CreateDate+"000")));
							int position = Rs.getInt("position");
							int width = Rs.getInt("width");
							int height = Rs.getInt("height");
							int dissolve = Rs.getInt("dissolve");
							int status = Rs.getInt("status");//启用1
							int id = Rs.getInt("id");
							int watermark_companyid = Rs.getInt("companyid");
							String watermark_name =  "";
							if(watermark_companyid!=0){
								Company cp = new Company(watermark_companyid);
								watermark_name  =cp.getName();
							}else{
								watermark_name = "全局使用";
							}
							
				%>
				<tr>
					<td class="valign-middle">
						  <label class="ckbox mg-b-0">
							<input type="checkbox" name="id" value="<%=id%>"><span></span>
						  </label>
					</td>
					<!-- <td class="v1" width="25" align="center" valign="middle"><%=id%></td> -->
					<td class="v1" align="center" valign="middle"><a href="javascript:window.open('data:image/png;base64,<%=Rs.getString("watermark")%>')"><%=Name%></a></td>
					<td class="hidden-xs-down" align="center" valign="middle">
							<div class='toggle-wrapper'>
								<div class='toggle toggle-light success' data-toggle-on='<%=status%>'  watermark='<%=id%>'></div>
							</div>
					</td>
					<td class="v1" width="100" align="center" valign="middle"><%=width+"px"%></td>
					<td class="v1" width="100" align="center" valign="middle"><%=height+"px"%></td>
					<td class="v1" width="100" align="center" valign="middle"><%=LogoLeft+"px"%></td>
					<td class="v1" width="100" align="center" valign="middle"><%=LogoTop+"px"%></td>
					<td class="v1" width="100" align="center" valign="middle"><%=dissolve+"%"%></td>
					<td class="v1" width="100" align="center" valign="middle"><%=watermark_name%></td>
					<!--<td class="v1" width="100" align="center" valign="middle"><%=CreateDate%></td>-->
					<td class="v9" width="250" align="center">
						<a href="javascript:Previeww('<%=Rs.getString("watermark")%>');" class="btn btn-info btn-sm mg-r-8 mg-b-8 tx-13">预览</a>
						<a href="javascript:Details(<%=id%>);" class="btn btn-info btn-sm mg-r-8 mg-b-8 tx-13">编辑</a>
						<a href="watermark_list.jsp?Action=Del&id=<%=id%>" class="btn btn-info btn-sm mg-r-8 mg-b-8 tx-13" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a>
					</td>
				</tr>
				<%
						}
					}
					tu.closeRs(Rs);
				%>

				</tbody>
			</table>
			<%if(TotalPageNumber>0){%>
			<!--分页-->
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
					<a href="javascript:jumpPage();" class="tx-14">Go</a>
				</div>
				<%}%>
				<div class="each-page-num mg-l-auto d-flex  align-items-center">
					<span class="">每页显示:</span>
					<select name="rowsPerPage" id="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change('#rowsPerPage');" >
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
			</div>
			<!--分页-->
			<%}%>

		</div>
	</div><!--列表-->


</div>
<script>
   var page = {
       currPage: '<%=currPage%>',
       rowsPerPage: '<%=rowsPerPage%>',
       querystring: '<%=querystring%>',
       TotalPageNumber: <%=TotalPageNumber%>
   };
	 //开关相关
	//初始化
	$('.toggle').toggles({        
	  height: 25
	});
	//获取是否开或关
	$(".toggle").click(function(){
		var myToggle = $(this).data('toggle-active');
		var id = $(this).attr('watermark');	
		var field = $(this).attr('field');
	
		var url = "watermark_action.jsp?Action="+myToggle+"&id="+id;
		$.ajax({
			type:"GET",
			url:url, 
			success: function(msg){
				//if(msg.trim()=="true"){
				//	alert("设置成功");
				//}
			}
		});
	})
</script>


</body>
</html>



