<%@ page import="tidemedia.cms.util.*,
				java.io.File,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
/**
* 用途 ：下载模板备份或者数据库备份
*	1，丁文豪       20150402      增加操作记录日志
* 2， 丁文豪      20150416      获取备份文件列表的路径改为由参数获取
* 3. 丁文豪     20150417     删除没有用到的function html_backup()、backup_config() 及其相关带代码
*/
public  File[] getFiles(File []files,int start,int end,String title)
{
	if(files==null) return null;
	File[]files2=new File[files.length];
	int num=0;
	if(title.trim().equals(""))
	{
		for(File file:files)
		{
			if(!file.isDirectory())
			{
				files2[num++]=file;
			}
		}
	}
	else
	{	
		for(File file:files)
		{
			if(!file.isDirectory()&&file.getName().contains(title))
			{
				files2[num++]=file;
			}
		}

	}
	
	File[]files3=new File[num];	
	for(int j=0;j<num;j++)
	{
	  files3[j]=files2[j];
	}
	
	File []fileNew=new File[num];
	num=0;
	for(int i=start;start>=0&&i<end&&i<files3.length;i++)
	{
		fileNew[num++]=files3[i];
	}
	
	File []fileNew2=new File[num];
	
	for(int i=0;i<num;i++)
	{
		fileNew2[i]=fileNew[i];
	}
	
	return fileNew2;
}
	
 public  int getFileslength(File []files,String title )
{
	if(files==null) return 0;
 	if(title.trim().equals(""))
 	{
 		return files.length;
 	}
 	else
 	{
 		int num=0;
 		for(File file:files)
 		{
			if(!file.isDirectory()&&file.getName().contains(title))
			{
				num++;
			}
		}
 		return num;
 	}
	
}
public void Order(File[] files,final String content){
	 java.util.Arrays.sort(files,new java.util.Comparator(){   
	  public int compare(Object o1,   Object o2)   {   
	  File f1 = (File)o1;File   f2   =   (File)o2;
	  long diff = 0;
	  if(content.equals("date"))
		 diff = f2.lastModified() - f1.lastModified();
	  else if (content.equals("size"))
		 diff = f1.length() - f2.length();
	   if (diff > 0)
		  return 1;
	   else if (diff == 0)
		  return 0;
	   else
		  return -1;  
  }});
}
 %>
<%
if(!userinfo_session.isAdministrator())
{
	response.sendRedirect("../noperm.jsp");
	return;
}
TideJson tj=CmsCache.getParameter("sys_backup_cfg").getJson();
String   backuppath  =tj.getString("db_path")+"";
if(backuppath.equals(""))
	backuppath="/web/backup/";
//request.setCharacterEncoding("iso-8859-1");

 String sort=Util.getParameter(request,"sort");
 int currPage=Util.getIntParameter(request,"currPage");
 int rowsPerPage=Util.getIntParameter(request,"rowsPerPage");
 int TotalPageNumber=-1;
 int S_OpenSearch=Util.getIntParameter(request,"S_OpenSearch");;
 String S_Title=Util.getParameter(request,"S_Title");
 if(rowsPerPage==0)
 {
	rowsPerPage=50;
  }
 if(currPage==0||currPage<1)
 {
	currPage=1;
 }
File[] files = null;
File file = new File(backuppath);

if(file.exists())
	files = file.listFiles();

if(files!=null)
	Order(files,"date");

double PageNumbe=Math.ceil((double)getFileslength(files,S_Title)/(double)rowsPerPage);
TotalPageNumber=(int)PageNumbe;

int startPage=(currPage-1)*rowsPerPage;
int endPage=currPage*rowsPerPage;

files=getFiles(files,startPage,endPage,S_Title);

String querystring="&FolderName="+backuppath+"&sort="+sort+"&rowsPerPage="+rowsPerPage+"&S_Title="+S_Title+"&S_OpenSearch="+S_OpenSearch;
String querystring2="&FolderName="+backuppath+"&sort="+sort+"&S_OpenSearch="+S_OpenSearch;
String pagePre="file_list2018.jsp?currPage="+(currPage-1)+querystring;
String pageNext="file_list2018.jsp?currPage="+(currPage+1)+querystring;
String pageStart="file_list2018.jsp?currPage=1"+querystring;
String pageEnd="file_list2018.jsp?currPage="+TotalPageNumber+querystring;
String changerowsPerPage="file_list2018.jsp?currPage=1"+querystring2;
String searchTitle="file_list2018.jsp?currPage=1"+querystring2+"&rowsPerPage="+rowsPerPage;
String endSearch="file_list2018.jsp?currPage=1&rowsPerPage="+rowsPerPage+"&FolderName="+backuppath+"&sort="+sort;
if(files!=null)	
if(sort.equals("date")){
   Order(files,"date");
}else if(sort.equals("size")){
   Order(files,"size");
}else
   Order(files,"date");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/content.js"></script>
<script>
     
	var myObject = new Object();
    myObject.title = "新建文件";
    myObject.FolderName = "<%=backuppath%>";
	var listType=1;

	function deleteFile()
	{
		var curr_row;
		var selectedNumber = 0;
		var selectedFile = "";

		for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
		{
		  if(oTable.rows[curr_row].className=="rows3")
			{
//			  alert(document.getElementById("FileName"+oTable.rows[curr_row].No).innerText);
			  if(selectedFile=="")
				  selectedFile += document.getElementById("FileName"+oTable.rows[curr_row].No).innerText;
			  else
				  selectedFile += ","+document.getElementById("FileName"+oTable.rows[curr_row].No).innerText;
			  selectedNumber ++;
			}
		}
//		alert(selectedFile);
		if (selectedNumber>0) 
			{ 
			var message = "";
			if(selectedNumber<5)
			{
				message = "删除此后将无法进行数据恢复,确实要删除\""+selectedFile+"\"吗？";
			}
			else
			{
				message = "删除此后将无法进行数据恢复，确实要删除这"+selectedNumber+"项吗？";
			}
			if(confirm(message)) 
			{
				this.location = "file_delete.jsp?Action=Delete&FolderName="+myObject.FolderName+"&FileName="+selectedFile;
			}
		}
		else
		{
				var action="delNull";
				alertDialog(action);				
			//alert("请先选择要删除的文件！");
				return;
		}
	} 
	//alert改弹窗
	function alertDialog(action)
	{
	
		var	dialog = new top.TideDialog();
		dialog.setWidth(320);
		dialog.setHeight(240);
		dialog.setUrl("../backup/alertDialog2018.jsp?action="+action);
		dialog.setTitle("提示");
		dialog.show();	
	}	

	function selectItem(obj)
	{
		//alert(obj.className);
		if(obj.className!="rows3")
		{
			var curr_row;

			//if(window.event.ctrlKey!=true)
			//{
				for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
				{
				  if(oTable.rows[curr_row].className=="rows3")
					  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
				}
			//}
			obj.className = "rows3";
		}
		else
			obj.className = obj.oldclass;
	}

	function selectItem_key(flag)
	{

		var curr_row;
		var hasSelectedItem = 0;

		if(flag==1)
		{

			for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
			{
			  if(oTable.rows[curr_row].className=="rows3")
				{
				  if(flag==1)
					{
					  if(curr_row>1)
						{
						  if(window.event.shiftKey!=true)
							  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
						  oTable.rows[curr_row-1].className = "rows3";
						}
					}
					break;
				}
			}
		}
		else if(flag==2)
		{
			for (curr_row = oTable.rows.length-1; curr_row > 0; curr_row--)
			{
			  if(oTable.rows[curr_row].className=="rows3")
				{
				  if((curr_row+1)<oTable.rows.length)
					{
					  if(window.event.shiftKey!=true)
						  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
					  oTable.rows[curr_row+1].className = "rows3";
					}
					hasSelectedItem = 1;
					break;
				}
			}
			if(hasSelectedItem==0)
			{
				oTable.rows[1].className = "rows3";
			}
		}
	}

	function double_click(obj)
	{

	}

	function onkeyboard()
	{
		key = event.keyCode
		if(key == 'd'.charCodeAt() || key == 'D'.charCodeAt())
			deleteFile();
		else if(key == 13)
			notepad();
		//alert(key);
	}

	function onkeyboard1()
	{
		key = event.keyCode
		if(key==38)
		{
			selectItem_key(1);
		}
		else if(key==40)
			selectItem_key(2);
		else if(key==46)
			deleteFile();
		//alert(key);
	}

	function SelectStart()
	{
		if(event.srcElement.tagName.toLowerCase()=="body" && event.ctrlKey && event.button==0)
		{
			//全选,第1行是Table Title
			for (curr_row = 1; curr_row < oTable.rows.length; curr_row++)
			{
				  oTable.rows[curr_row].className = "rows3";
			}
		}

		return false;
	}


	function openSearch(obj)
	{
	var SearchArea=document.getElementById("SearchArea");
		if(SearchArea.style.display == "none")
		{
			document.search_form.OpenSearch.value="1";
			SearchArea.style.display = "";
		}
		else
		{
			document.search_form.OpenSearch.value="0";
		   SearchArea.style.display = "none";
		   this.location="<%=endSearch%>";
		}
	}

	 
	function sort_select(obj){
	this.location="file_list2018.jsp?sort="+obj+"<%=querystring%>";
	}

	//20140208添加
	function backupDatabase()
	{
		var url="../backup/backup_database2018.jsp";
		var	dialog = new top.TideDialog();
			dialog.setWidth(600);
			dialog.setHeight(450);
			dialog.setUrl(url);
			dialog.setTitle("数据库备份");
			dialog.setScroll("yes");
			dialog.show();
	}
</script>
</head>

<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  

    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">备份管理 / 内容备份管理</span>
        </nav>
    </div><!-- br-pageheader -->

	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <div class="btn-group mg-l-auto hidden-sm-down">
	  		<a href="#" class="btn btn-outline-info list_all" onClick="file_backup();">模板文件备份</a>
		  	<a href="#" class="btn btn-outline-info list_draft" onClick="backupDatabase();">数据库备份</a>
		  	<a href="javascript:downloadFile2();" class="btn btn-outline-info">下载</a>
          	<a href="javascript:deleteFile2_backup();" class="btn btn-outline-info">删除</a>  
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
	function downloadFile2()
	{
		var obj=getCheckbox();
		if(obj.length==0 || obj.length>1){
			
		var url="../backup/file_down2018.jsp?length="+obj.length;
		var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(230);
		//dialog.setSuffix('_2');
		dialog.setUrl(url);
		dialog.setTitle("下载文件");
		//dialog.setScroll('auto');
		dialog.show(); 
		
		//alert("请选择要下载的文件！");
		return false;
		}
		//if(obj.length>1){
		//	alert("请选择一个要下载的文件！");
		//	return;
		//}
		var files=(obj.id).split(",");
		for(var i=0;i<files.length;i++){
			var  selectedFile =files[i];
			if(!jQuery("#Download"+i).length)
			{
			  var frame='<iframe id="Download'+i+'"  name="Download'+i+'" style="display:none;width:0px;height:0px;"></iframe>';
			  jQuery("body").append(frame);
			}

			if(window.frames["Download"+i]){
				window.frames["Download"+i].location = "download.jsp?Type=File&Template=backup&FileName="+selectedFile+"&FolderName=/";
			}

		}

	}

	function deleteFile2_backup()
	{
		var obj=getCheckbox();
		var curr_row;
		var selectedNumber = obj.length;
		var selectedFile = "";
		
		if (selectedNumber>0) 
			{ 
			var message = "";
			if(selectedNumber<5)
			{
				message = "确实要删除\""+obj.id+"\"吗？";
			}
			else
			{
				message = "确实要删除这"+selectedNumber+"项吗？";
			}
			if(confirm(message)) 
			{
				//this.location = "file_delete.jsp?Action=Delete&filename="+obj.id;
				$.ajax({
					type:"get",
					url:"file_delete.jsp?files="+obj.id,
					sync:true,
					success: function(msg){
						document.location.reload();
						//alert(msg);
						//self.close();
						//alert("下载完成");
					}
				});
			}
		}
		else
		{
			var action="delNull";
				 alertDialog(action);
			//alert("请先选择要删除的文件！");
			  return;
		}
	}
	function file_backup()
	{
			$.ajax({
				type:"get",
				url:"template_backup.jsp",
				sync:true,
				success: function(msg){
					var dialog = new top.TideDialog();
					dialog.showAlert("备份成功");
					document.location.reload();
				},
				error:function(xhr){
					var dialog = new top.TideDialog();
					dialog.showAlert("备份失败","danger");
					document.location.reload();
				}
			});


	}
	</script>
	
	
	<!-- 列表页  -->
	<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">

			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>				
					<th class="tx-12-force tx-mont tx-medium">选择</th>				
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down"><a href="javascript:sort_select('');">名称</a></th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down"><a href="javascript:sort_select('size');">大小</a></th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down"><a href="javascript:sort_select('');">类型</a></th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down"><a href="javascript:sort_select('date');">最后修改时间</a></th>
				  </tr>
				</thead>
<%
if(files==null || files.length==0)
{
%>
			
<tr><td colspan=5 align=center>暂无文件</td></tr>				

<%
}
else
{
%>
<%
	int j = 0;
	FileUtil fileutil = new FileUtil();

	for(int i = 0;i<files.length;i++)
	{
		if(!files[i].isDirectory())
		{
			j++;
			String FileSize = fileutil.getSize(files[i]) + "KB";
			String FileExt  = fileutil.getExt(files[i]);
			String lastModified = fileutil.lastModified(files[i]);
%>	
	<tbody>
		<tr No="<%=j%>">
			<td class="valign-middle">
			  <label class="ckbox mg-b-0">
				<input name="id" value="<%=files[i].getName()%>" type="checkbox"/><span></span>
			  </label>
			</td>			
			<td class="hidden-xs-down">
				<i class="fa fa-file-o tx-18 tx-warning lh-0 valign-middle mg-r-2"></i>
				<span id="FileName<%=j%>"><%=files[i].getName()%></span>
			</td>	
			<td class="hidden-xs-down"><%=FileSize%></td>
			<td class="hidden-xs-down"><%=FileExt%></td>						
		    <td class="hidden-xs-down"><%=lastModified%></td>
		</tr>
<%
		}
	}
}
%>	
				</tbody>
			</table>	

			<script>
				var page = {
					currPage: '<%=currPage%>',
					rowsPerPage: '<%=rowsPerPage%>',
					querystring: '<%=querystring%>',
					TotalPageNumber: <%=TotalPageNumber%>
				};
			</script>

			<!--分页-->
			<%if(TotalPageNumber>0){%> 
			<div id="tide_content_tfoot">	
                <label class="ckbox mg-b-0 mg-r-30 ">
					<input type="checkbox" id="checkAll_1"><span></span>
				</label>

          		<span class="mg-r-20 ">共<%=files.length%>条</span>
          		<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

				<%if(TotalPageNumber>1){%>
				<div class="jump_page ">
          			<span class="">跳至:</span>
          			<label class="wd-60 mg-b-0">
						<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
					</label>
					<span class="">页</span>
					<a id="goToId" href="#" class="tx-14">Go</a>
				</div>
				<%}%>

          		<div class="each-page-num mg-l-auto ">
          			<span class="">每页显示:</span>
          			<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change(this);" id="rowsPerPage">
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
			</div><!--分页-->
            <%}%> 
		</div>
	</div><!--列表-->

	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <div class="btn-group mg-l-auto hidden-sm-down">
	  		<a href="#" class="btn btn-outline-info list_all" onClick="document.location='../backup/template_backup.jsp'">模板文件备份</a>
		  	<a href="#" class="btn btn-outline-info list_draft" onClick="backupDatabase();">数据库备份</a>
		  	<a href="javascript:downloadFile2();" class="btn btn-outline-info" onClick="openSearch();">下载</a>
          	<a href="javascript:deleteFile2_backup();" class="btn btn-outline-info">删除</a>  
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
</div>
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

<script type="text/javascript">

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


		$("#content-table tr:gt(0) td").click(function() {
			var _tr = $(this).parent("tr")
			if(!$("#content-table").hasClass("table-fixed")){
				if( _tr.find(":checkbox").prop("checked") ){
					_tr.find(":checkbox").removeAttr("checked");
					$(this).parent("tr").removeClass("bg-gray-100");
				}else{
					_tr.find(":checkbox").prop("checked", true);
					$(this).parent("tr").addClass("bg-gray-100");
				}
			}
		});

		$("#checkAll,#checkAll_1").click(function() {
			if($("#content-table").hasClass("table-fixed")){
	    		var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
	    	}else{
	    		var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
	    	}	
			var existChecked = false;
			for (var i = 0; i < checkboxAll.length; i++) {
				if (!checkboxAll.eq(i).prop("checked")) {
					existChecked = true;
				}
			}
			if (existChecked) {
				checkboxAll.prop("checked", true);
				checkboxAll.parents("tr").addClass("bg-gray-100");
				$(this).prop("checked", true);
			} else {
				checkboxAll.removeAttr("checked");
				checkboxAll.parents("tr").removeClass("bg-gray-100");
				$(this).prop("checked", false);
			}
			return;
		})
		$(".btn-search").click(function() {
			$(".search-box").toggle(100);
		})

	});



function change(obj)
{
		if(obj!=null)		this.location="file_list2018.jsp?rowsPerPage="+obj.value+"<%=querystring%>";
}

function gopage(currpage) {
	var url = "file_list2018.jsp?currPage=" + currpage + "<%=querystring%>";
	this.location = url;
}

jQuery(document).ready(function(){
	jQuery("#goToId").click(function(){
		var num=jQuery("#jumpNum").val();
		if(num==""){
			var action="numberNull";
		    alertDialog(action);	
			//alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;}
		 var reg=/^[0-9]+$/;
		 if(!reg.test(num)){
			//alert("请输入数字!");
			var action="numberNull";
		    alertDialog(action);	
			jQuery("#jumpNum").focus();
			return;
		 }

		if(num<1)
			num=1;
		var href="file_list2018.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		document.location.href=href;
	});

});
</script>
</body>
</html>
	
	
	
