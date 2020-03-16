<%@ page import="java.sql.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}
long begin_time = System.currentTimeMillis();
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int Scheme = getIntParameter(request,"Scheme");
int SiteId=getIntParameter(request,"SiteId");
String S_Title=Util.getParameter(request,"S_Title");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 50;
	
String queryString="&SiteId="+SiteId+"&Scheme="+Scheme+"&S_Title="+S_Title;
String queryString1="&SiteId="+SiteId+"&Scheme="+Scheme;
String Action = getParameter(request,"Action");
String searchTitle="published2018.jsp?rowsPerPage="+rowsPerPage+queryString1;
String endSearch="published2018.jsp?rowsPerPage="+rowsPerPage+queryString1;
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	String Sql = "delete from publish_item where Status=1 and id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("published2018.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString);return;
}
else if(Action.equals("Clear"))
{
	//String Sql = "delete from publish_item where Status=1";
	String Sql ="DELETE FROM publish_item USING publish_item,publish_scheme WHERE publish_item.PublishScheme=publish_scheme.id ";
	Sql+=" and publish_item.Status=1";
	if(SiteId>0){
	Sql+=" and publish_scheme.site="+SiteId;
	}
	if(Scheme>0){
	Sql+=" and publish_item.PublishScheme="+Scheme;
	}
	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("published2018.jsp?a=a"+queryString);return;
}
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
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script language="javascript">
function change(obj)
{
if(obj!=null)
		this.location = "published2018.jsp?rowsPerPage="+obj.value+"<%=queryString%>";

	}

function ClearItems()
{
	var url="published_clear2018.jsp?queryString=<%=queryString%>&SiteId=<%=SiteId%>&Scheme=<%=Scheme%>";
	var	dialog = new top.TideDialog();
		dialog.setWidth(320);
		dialog.setHeight(260);
		dialog.setUrl(url);
		dialog.setTitle("清空待发布记录");
		dialog.show();
  /*	 if(confirm("确实要清空所有待发布记录吗？")) 
	{
		this.location = "published2018.jsp?Action=Clear+queryString";
	}
	*/
}

function MM_jumpMenu(obj){ //v3.0
	if(obj!=null)
	{
		if(document.getElementById("rowsPerPage")!=null)
			this.location = "published2018.jsp?Scheme=" + obj.value+"&rowsPerPage="+document.getElementById("rowsPerPage").value+"&SiteId=<%=SiteId%>";
		else
			this.location = "published2018.jsp?Scheme=" + obj.value+"&SiteId=<%=SiteId%>";
	}
}

function openSearch(obj)
{
var SearchArea=document.getElementById("SearchArea");
	if(SearchArea.style.display == "none")
	{
		SearchArea.style.display = "";
	}
	else
	{
	   SearchArea.style.display = "none";
       this.location="<%=endSearch%>";
	}
}
function search_submit(){
var S_Title=document.getElementById("S_Title").value;
this.location="<%=searchTitle%>&S_Title="+S_Title;
}
function gopage(currpage) 
{
	var url = "published2018.jsp?currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%><%=queryString%>";
	this.location = url;
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
        <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0">
          <span class="breadcrumb-item active">发布方案：
			<label class="wd-100 mg-b-0">
			<%=(new PublishItem()).getSelect("Scheme\" onChange=\"MM_jumpMenu(this)\" class=\"form-control select2 wd-100","publish_scheme","id","Name",Scheme+"","<option value='0'>全部方案</option>",SiteId)%>
			</label>
			已经发布文件：
		  </span>
        </nav>
        </div><!-- br-pageheader -->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
<%			
PublishScheme pt = new PublishScheme();
//String ListSql = "select publish_item.FileName,publish_item.CreateDate,publish_item.id,publish_item.ErrorNumber,publish_scheme.Name from publish_item left join publish_scheme on publish_item.PublishScheme=publish_scheme.id  where publish_item.Status=1 ";

//String ListSql = "select * from publish_item where Status=1 ";
//String ListSql = "select publish_item.FileName,publish_item.CreateDate,publish_item.id,publish_item.PublishScheme,publish_item.ErrorNumber,publish_scheme.Name from publish_item left join publish_scheme on publish_item.PublishScheme=publish_scheme.id  where publish_item.Status=1 ";
//String CountSql = "select count(*) from publish_item left join publish_scheme on publish_item.PublishScheme=publish_scheme.id where publish_item.Status=1";

//使用上面的SQL 性能提高一倍 2007 09 19


String ListSql = "select UsedTime ,FileName,CreateDate,id,PublishScheme,FROM_UNIXTIME(AddTime,'%m-%d %H:%i:%s') as AddTime,FROM_UNIXTIME(CanCopyTime,'%m-%d %H:%i:%s') as CanCopyTime,FROM_UNIXTIME(CopyedTime,'%m-%d %H:%i:%s') as CopyedTime from publish_item where Status=1 ";
String CountSql = "select count(*) from publish_item  where Status=1";

if(Scheme>0){
	ListSql += " and PublishScheme=" + Scheme;
	CountSql += " and PublishScheme=" + Scheme;
}
if(SiteId>0){
	ListSql+=" and Site="+SiteId;
	CountSql += " and Site="+SiteId;
}

if(!S_Title.trim().equals("")){
	ListSql+=" and FileName like '%"+S_Title+"%'";
	CountSql += " and FileName like '%"+S_Title+"%'";
}	
ListSql += " order by id desc ";

//String CountSql = "select count(*) from publish_item where Status=1";


ResultSet Rs = pt.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = pt.pagecontrol.getMaxPages();
%>       
        <div class="btn-group mg-l-10 hidden-xs-down">
		  <a href="javascript:openSearch();" class="btn btn-outline-info list_draft" >检索</a>       
        </div><!-- btn-group -->
		<div class="btn-group mg-l-10 hidden-xs-down">
		  <a href="javascript:ClearItems();" class="btn btn-outline-info list_draft" >清空</a>       
        </div><!-- btn-group -->
		
		<div class="btn-group mg-l-auto hidden-sm-down">
				<%if(currPage>1){%>
				<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
				<%}%>
				<%if(currPage<TotalPageNumber){%>
				<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
				<%}%>
		   </div>
     </div>
	  <!--搜索-->
     <div class="search-box pd-x-20 pd-sm-x-30" id="SearchArea" style="display:<%=(!S_Title.trim().equals("")?"":"none")%>">
		<div class="search-content bg-white">			
      		<div class="row">
				<!--用户信息-->
				<div class="wd-40 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">检索:</div>
				<div class="mg-r-20 mg-b-40 search-item">
                     <input class="form-control search-title" placeholder="文件名" type="text" name="S_Title"  id="S_Title" size="18" value="<%=S_Title%>">                                
				</div>									
				<div class="search-item mg-b-30">
					<input type="button" name="button" value="查找" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14" onclick="search_submit()">
				</div>
			</div><!-- row -->			
      	</div>
     </div><!--搜索-->	
	 
<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">

				<thead>
				  <tr>				
					<th class="tx-12-force tx-mont tx-medium">编号</th>						
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布方案</th>     				
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">文件名</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">入队列时间</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">可发布时间</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布时间</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布用时</th>
                    <th class="v9" width="55" align="center" valign="middle">操作</th>					
				  </tr>
				</thead>
				<tbody>
<%
int TotalNumber = pt.pagecontrol.getRowsCount();
if(pt.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				int psid = Rs.getInt("PublishScheme");
				PublishScheme ps = tidemedia.cms.system.CmsCache.getPublishScheme(psid);
				String Name = ps.getName();
				String FileName = convertNull(Rs.getString("FileName"));
				String time1 = convertNull(Rs.getString("AddTime"));
				String time2 = convertNull(Rs.getString("CanCopyTime"));
				String time3 = convertNull(Rs.getString("CopyedTime"));
				int time4 = Rs.getInt("UsedTime");
				int second = time4/1000;
				String usedTime = "";
				if(second<=0)
					usedTime = time4 + "毫秒";
				else if(second>0&&second<60) 

					usedTime = second +"秒";
				else if(second>=60&&second<3600) 
					usedTime = second/60+"分钟";
				else 
					usedTime = second/3600+"小时";
				int id = Rs.getInt("id");

				j++;
%>
<tr>
			<td class="valign-middle">
			  <label class="ckbox mg-b-0">
				<%=j%>
			  </label>
			</td>
			<td class="hidden-xs-down"><%=Name%></td>
			<td class="hidden-xs-down"><%=FileName%></td>	
            <td class="hidden-xs-down"><%=time1%></td>		
            <td class="hidden-xs-down"><%=time2%></td>
			<td class="hidden-xs-down"><%=time3%></td>
			<td class="hidden-xs-down"><%=usedTime%></td>
 			<td class="hidden-xs-down"><a href="published2018.jsp?Action=Del&id=<%=id%><%=queryString%>" class="btn btn-danger  btn-sm mg-r-8 tx-13" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td>
		</tr>
<%
			}
}
			//System.out.println("pt.close begin...");
			pt.closeRs(Rs);
			//System.out.println("pt.close end...");
			//System.out.println("list end....");
%>
 </tbody> 
</table> 
<!--分页-->
			<div id="tide_content_tfoot">	
          		<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
          		<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

				<%if(TotalPageNumber>1){%><%}%>
				<div class="jump_page ">
          			<span class="">跳至:</span>
          			<label class="wd-60 mg-b-0">
						<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
					</label>
					<span class="">页</span>
					<a id="goToId" href="javascript:;" class="tx-14">Go</a>
				</div>
          		<div class="each-page-num mg-l-auto ">
          			<span class="">每页显示:</span>
                                 <label class="wd-80 mg-b-0">
          			<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="状态" onChange="change(this);" id="rowsPerPage">
						<option value="10" >10</option>
						<option value="15">15</option>
						<option value="20" >20</option>
						<option value="25" >25</option>
						<option value="30" >30</option>
						<option value="50" >50</option>
						<option value="80" >80</option>
						<option value="100" >100</option>						
					</select>
                    </label>条
				
          		</div>
			</div><!--分页-->
			</div>
	 </div><!--列表-->
	 <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
       
		<div class="btn-group mg-l-10 hidden-xs-down">
		  <a href="javascript:ClearItems();" class="btn btn-outline-info list_draft" >清空</a>       
        </div><!-- btn-group -->
		
		<div class="btn-group mg-l-auto hidden-sm-down">
				<%if(currPage>1){%>
				<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
				<%}%>
				<%if(currPage<TotalPageNumber){%>
				<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
				<%}%>
		   </div>
     </div>
	 </div>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
	<script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>	
    <script src="../common/2018/bracket.js"></script> 

<script type="text/javascript"> 	
	function change(obj)
	{
		if(obj!=null)		this.location="published2018.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
	}

	function sort_select(obj){	

	}

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
		var href="published2018.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=queryString%>";
		document.location.href=href;
	});

});
</script>
</body></html>
