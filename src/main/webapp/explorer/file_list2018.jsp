<%@ page import="tidemedia.cms.util.*,
				java.io.File,java.math.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int currPage=-1;
int rowsPerPage=-1;
int TotalPageNumber=-1;
int S_OpenSearch=0;
String sortid="0";
int SiteId = Util.getIntParameter(request,"SiteId");
if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}
/*
if(!(userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()))
{ response.sendRedirect("../noperm.jsp");return;}

if(userinfo_session.isSiteAdministrator())
{
	if(!userinfo_session.getSite().equals(SiteId+""))
	{response.sendRedirect("../noperm.jsp");return;}
}*/
request.setCharacterEncoding("utf-8");
System.out.println("SiteId111="+SiteId);
String FolderName = Util.ClearPath(getParameter(request,"FolderName"));

Site site;

if(SiteId==0)
	site = defaultSite;
else
	site = CmsCache.getSite(SiteId);

SiteId = site.getId();

String SiteFolder=site.getSiteFolder();		  //System.out.println(SiteFolder);
String siteName=site.getName();
if(SiteFolder.length()==0){
	out.println("站点目录没有配置，请在系统管理中对应站点下配置");
	return;
}else{
	File file_ = new File(SiteFolder);
	if(!file_.exists()){
		out.println("站点目录不存在!");
		return;
	}else if(file_.isFile()){
		out.println("站点目录不能为文件");
		return ;
	}
}


//System.out.println("sitefloder22="+sitefloder);
//String FolderName = getParameter(request,"FolderName");
//System.out.println(FolderName);
String RealPath = SiteFolder + "/" + FolderName;
File file = new File(RealPath);

if(file.exists()){

File[] files2 = file.listFiles();
if(files2!=null){
	if(request.getParameter("sortid")!=null){
	  sortid=request.getParameter("sortid");
	}
   if(sortid.equals("1")){
	    	java.util.Arrays.sort(files2,new java.util.Comparator(){   
      public int compare(Object o1,   Object o2)   {   
          File f1 = (File)o1;File   f2   =   (File)o2;
           long diff = f2.lastModified() - f1.lastModified();
           if (diff > 0)
              return 1;
           else if (diff == 0)
              return 0;
           else
              return -1;  
      }});
   }else{
	   if(sortid.equals("2")){
		       	java.util.Arrays.sort(files2,new java.util.Comparator(){   
      public int compare(Object o1,   Object o2)   {   
          File f1 = (File)o1;File   f2   =   (File)o2;
          long diff = f1.length() - f2.length();
           if (diff > 0)
              return 1;
           else if (diff == 0)
              return 0;
           else
              return -1;  
      }});
	   }else{
	java.util.Arrays.sort(files2);}
	}
}
int f2=0;
for(int i = 0;i<files2.length;i++){
  if(!files2[i].isDirectory()){
    f2++;
  }
}
File[] files=new File[f2];
File[] files_find=new File[f2];
f2=0;
for(int i = 0;i<files2.length;i++){
  if(!files2[i].isDirectory()){
    files[f2]=files2[i];
	f2++;
  }
}
f2=0;

String OpenSearch=request.getParameter("OpenSearch")+"";
String S_Title=request.getParameter("Title");
String srowsPerPage= request.getParameter("rowsPerPage");
if(OpenSearch.equals("1")){
	S_OpenSearch=1;
}else{
 S_OpenSearch=0;
//S_Title="";
}

if((S_Title!=null)&&(!S_Title.equals(""))){   //实现查找
  S_OpenSearch=1;
  for(int i=0;i<files.length;i++){
    if(files[i].getName().contains(S_Title) ){
    files_find[f2]=files[i];
	 f2++;
	}
  }
 files=new File[f2];
 for(int i=0;i<f2;i++){
 files[i]=files_find[i];
 }
}else{
S_Title="";
  //S_OpenSearch=0;
}

if((srowsPerPage!=null)&&(!srowsPerPage.equals(""))){
	  rowsPerPage=Integer.parseInt(srowsPerPage);
}else{
	  rowsPerPage=50;
} 
String scurrPage= request.getParameter("currPage");
if((scurrPage!=null)&&(!scurrPage.equals(""))){
		currPage=Integer.parseInt(scurrPage);
}else{
   currPage=1;
}
String querystring="&FolderName="+FolderName+"&Title="+S_Title+"&sortid="+sortid+"&OpenSearch="+S_OpenSearch+"&rowsPerPage="+rowsPerPage+"&SiteId="+SiteId;

String folName = "";
if(FolderName.contains("/")){
	folName = FolderName.substring(FolderName.lastIndexOf("/")+1);
}
if(folName.equals("")){
	folName = siteName ;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 列表</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<!--<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">-->
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">

<style>
	.collapsed-menu .br-mainpanel-file {
		margin-left: 0;
		margin-top: 0;
	}
	@media (max-width: 575px){
		#content-table .hidden-xs-down {word-break: normal;	}
	}
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<!--<script type="text/javascript" src="../common/jquery.js"></script>-->
<script type="text/javascript" src="../common/explorer.js"></script>
<!--<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>-->

<script type="text/javascript">
	var myObject = new Object();
	myObject.title = "新建文件";
	myObject.FolderName = "<%=FolderName%>";
	myObject.SiteId = "<%=SiteId%>";

	function getCheckbox() {
		var id = "";
		jQuery("#content-table input:checked").each(function(i) {
			if (i == 0)
				id += jQuery(this).val();
			else
				id += "," + jQuery(this).val();
		});
		var obj = {
			length: jQuery("#content-table input:checked").length,
			id: id
		};
		return obj;
	}

	function openSearch() {
		jQuery("#SearchArea").toggle();
	}
	$(document).ready(function() {
		$("#rowsPerPage").val('<%=rowsPerPage%>');
		double_click();
	});
	//双击
	function double_click() {
		jQuery("#content-table tr:gt(0)").dblclick(function() {
			var id  = jQuery(this).find(":checkbox").val();
			//notepad();
			var url = "notepad.jsp?FolderName=" + encodeURI(myObject.FolderName) + "&FileName=" + encodeURI(id) + "&SiteId=" + myObject.SiteId;
			window.open(url);
		});
	}

	function notepad() {
		var obj = getCheckbox();
		if (obj.length == 0) {
		var action="fileNull";
		    alertDialog(action);	
			//alert("请选择文件！");
			return;
		}

		if (obj.length > 1) {
			
			var action="fileMore";
		    alertDialog(action);
			//alert("请选择一个文件！");
			return;
		}
		var selectedFile = obj.id;

		var url = "notepad.jsp?FolderName=" + encodeURI(myObject.FolderName) + "&FileName=" + encodeURI(selectedFile) + "&SiteId=" + myObject.SiteId;
		window.open(url);
	}

	function notepad1(id) {
		var url = "notepad.jsp?FolderName=" + encodeURI(myObject.FolderName) + "&FileName=" + encodeURI(id) + "&SiteId=" + myObject.SiteId;
		window.open(url);
	}
	//翻页
	function gopage(currpage) {
		var url = "file_list2018.jsp?currPage=" + currpage + "<%=querystring%>";
		this.location = url;
	}
	//跳页
	function jumpPage() {
		var num = jQuery("#jumpNum").val();
		if (num == "") {
			var action="numberNull";
		    alertDialog(action);	
			//alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;
		}
		var reg = /^[0-9]+$/;
		if (!reg.test(num)) {
			var action="numberNull";
		    alertDialog(action);	
			//alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;
		}

		if (num < 1)
			num = 1;

		gopage(num);
	}

	function change(obj) {
		if (obj != null) this.location = "file_list2018.jsp?currPage=1&FolderName=<%=FolderName%>&Title=<%=S_Title%>&sortid=<%=sortid%>&OpenSearch=<%=S_OpenSearch%>&rowsPerPage="+obj.value+"&SiteId=<%=SiteId%>";;
	}
	//发布
	function publishFile() {
		var obj = getCheckbox();
		if (obj.length == 0) {
	        var action="publishFileNull";
		    alertDialog(action);	
			return;
		}
		var selectedFile = obj.id;
		this.location = "file_publish2018.jsp?FileName=" + encodeURI(selectedFile) + "&FolderName=" + encodeURI(myObject.FolderName) + "&SiteId=" + myObject.SiteId;
	}

	function publishFile1(id) {
		this.location = "file_publish2018.jsp?FileName=" + encodeURI(id) + "&FolderName=" + encodeURI(myObject.FolderName) + "&SiteId=" + myObject.SiteId;
	}
	//新建
	function newFile() {
		var dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(300);
		dialog.setUrl("../explorer/newfile2018.jsp?FolderName=<%=FolderName%>&SiteId=<%=SiteId%>");
		dialog.setTitle("新建文件");
		dialog.setChannelName("<%=folName%>");
		dialog.show();
	}
	//预览
	function previewFile() {
		var obj = getCheckbox();
		if (obj.length == 0) {
			var action="previewFileNull";
		     alertDialog(action);
			 //alert("请选择要预览的文件！");
			return;
		}

		if (obj.length > 1) {
			var action="previewFileMore";
		    alertDialog(action);	
			//alert("请选择一个要预览的文件！");
			return;
		}

		selectedFile = obj.id;
		window.open("preview.jsp?FolderName=" + encodeURI(myObject.FolderName) + "&FileName=" + encodeURI(selectedFile) + "&SiteId=" + myObject.SiteId);
	}

	function previewFile1(id) {
		window.open("preview.jsp?FolderName=" + encodeURI(myObject.FolderName) + "&FileName=" + encodeURI(id) + "&SiteId=" + myObject.SiteId);
	}
//alert改弹窗
function alertDialog(action)
{
	
		var	dialog = new top.TideDialog();
		dialog.setWidth(320);
		dialog.setHeight(240);
		dialog.setUrl("alertDialog2018.jsp?action="+action);
		dialog.setTitle("提示");
		dialog.show();	
}	
	//删除	
	function deleteFile() {
		var obj = getCheckbox();
		if (obj.length == 0) {
			var action="delNull";
		     alertDialog(action);
		  //	alert("请选择要删除的文件！");
			return;
		}
		 var selectedFile = obj.id;
		 if(obj.length<5)
		{
		 var url="file_delete2018.jsp?FolderName="+ encodeURI(myObject.FolderName) +"&fileLength="+obj.length +"&FileName=" + encodeURI(selectedFile) +"&SiteId=" + myObject.SiteId;
		 var	dialog = new top.TideDialog();
		  dialog.setWidth(320);
		  dialog.setHeight(280);
		  dialog.setUrl(url);
		  dialog.setTitle("删除文件");
		  dialog.show();	
		}else{
		var url="file_delete2018.jsp?FolderName=" + encodeURI(myObject.FolderName) +"&fileLength="+obj.length +"&FileName="+ encodeURI(selectedFile) +"&SiteId=" + myObject.SiteId ;
		var	dialog = new top.TideDialog();
		dialog.setWidth(320);
		dialog.setHeight(240);
		dialog.setUrl(url);
		dialog.setTitle("删除文件");
		dialog.show();	
		}	
/*		var selectedFile = obj.id;
		var message = "";
		if (obj.length < 5) {
			message = "确实要删除\"" + obj.id + "\"吗？";
		} else {
			message = "确实要删除这" + obj.length + "项吗？";
		}
		if (confirm(message)) {
			this.location = "file_delete2018.jsp?Action=Delete&FolderName=" + encodeURI(myObject.FolderName) + "&FileName=" + encodeURI(selectedFile) + "&SiteId=" + myObject.SiteId;
		}
*/
	}

	function deleteFile1(id) 
{
 var url="file_delete2018.jsp?FolderName="+ encodeURI(myObject.FolderName) +"&fileLength=1&FileName=" + encodeURI(id) +"&SiteId=" + myObject.SiteId;
		 var	dialog = new top.TideDialog();
		  dialog.setWidth(320);
		  dialog.setHeight(280);
		  dialog.setUrl(url);
		  dialog.setTitle("删除文件");
		  dialog.show();	   
/*		var message = "确实要删除这1项吗？";
		if (confirm(message)) {
			this.location = "file_delete2018.jsp?Action=Delete&FolderName=" + encodeURI(myObject.FolderName) + "&FileName=" + encodeURI(id) + "&SiteId=" + myObject.SiteId;
		}
*/
	}

	function uploadFile() {
		var dialog = new top.TideDialog();
		dialog.setWidth(700);
		dialog.setHeight(550);
		dialog.setUrl("../explorer/file_upload2018.jsp?FolderName=<%=FolderName%>&SiteId=<%=SiteId%>");
		dialog.setTitle("上传文件");
		dialog.setChannelName("<%=folName%>");
		dialog.show();
	}
	//排序
	function sort_select(obj) {
		this.location = "file_list2018.jsp?currPage=1&FolderName=<%=FolderName%>&Title=<%=S_Title%>&rowsPerPage=<%=rowsPerPage%>&OpenSearch=<%=S_OpenSearch%>&sortid=" + obj + "&SiteId=<%=SiteId%>";
	}
	//重命名
	function renameFile(id) {
		/*	var obj=getCheckbox();
			if(obj.length==0){
				alert("请选择重命名的文件！");
				return;
			}

			if(obj.length>1){
				alert("请选择一个重命名的文件！");
				return;
			}
			
			 selectedFile = obj.id;*/
		var dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(350);
		dialog.setUrl("../explorer/renamefile2018.jsp?FolderName=<%=FolderName%>&SiteId=<%=SiteId%>&FileName=" + encodeURI(id));
		dialog.setTitle("重命名");
		dialog.setChannelName("<%=folName%>");
		dialog.show();
	}
	//下载
	function downloadFile(id) {
		/*	var obj=getCheckbox();
			if(obj.length==0){
				alert("请选择要下载的文件！");
				return;
			}

			if(obj.length>1){
				alert("请选择一个要下载的文件！");
				return;
			}
		*/
		var files = id.split(","); //(obj.id).split(",");
		for (var i = 0; i < files.length; i++) {
			var selectedFile = files[i];
			if (!jQuery("#Download" + i).length) {
				var frame = '<iframe id="Download' + i + '"  name="Download' + i + '" style="display:none;width:0px;height:0px;"></iframe>';
				jQuery("body").append(frame);
			}

			if (window.frames["Download" + i]) {
				window.frames["Download" + i].location = "../download.jsp?Type=File&FileName=" + encodeURI(selectedFile) + "&FolderName=" + encodeURI(myObject.FolderName) + "&SiteId=" + myObject.SiteId;
			}

		}

	}

	function selectItem(obj) {
		//alert(obj.className);
		if (obj.className != "rows3") {
			var curr_row;

			if (window.event.ctrlKey != true) {
				for (curr_row = 0; curr_row < oTable.rows.length; curr_row++) {
					if (oTable.rows[curr_row].className == "rows3")
						oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
				}
			}
			obj.className = "rows3";
		} else
			obj.className = obj.oldclass;
	}

	function changeList(i) {
		if (i == 1) {
			changeFrameSrc(parent.window.document.getElementById("content_frame"),'file_list2018.jsp?cookie=1&SiteId=<%=SiteId%>&FolderName=<%=FolderName%>')
			
			//document.location.href = 'file_list2018.jsp?cookie=1&SiteId=<%=SiteId%>&FolderName=<%=FolderName%>';
		} else if (i == 2) {
			changeFrameSrc(parent.window.document.getElementById("content_frame"),'file_list_image.jsp?cookie=1&SiteId=<%=SiteId%>&FolderName=<%=FolderName%>')
			
			//document.location.href = 'file_list_image.jsp?cookie=1&SiteId=<%=SiteId%>&FolderName=<%=FolderName%>';
		}

	}


	function start_upload() {
		count = files.length;
		for (var i = 0; i < count; i++) {
			TCNDDU.processXHR(files.item(i), i);
		}
	}
</script>
</head>

<body class="collapsed-menu email">

	<div class="br-mainpanel br-mainpanel-file" id="js-source">

<%
	double PageNumbe=Math.ceil((double)files.length/(double)rowsPerPage);
	TotalPageNumber=(int)PageNumbe;
	int startPage=(currPage-1)*rowsPerPage;
	int endPage=currPage*rowsPerPage;						
	String FolderName1 = FolderName.replace("/"," / ");
%>

		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active"><%=siteName%>
			   <%if(FolderName1!=null && !"".equals(FolderName1) &&!FolderName1.equals(" / ") ){
				   String FolderName_ = FolderName1.startsWith(" / ")?FolderName1:" / "+FolderName1;
				   out.println(FolderName_);
			   }%></span>
			</nav>
		</div>
		<!-- br-pageheader -->

        <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

			<!-- START: 只显示在移动端 -->
			<div class="dropdown hidden-sm-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="#" class="nav-link">搜索</a>
						<a href="javascript:newFile();" class="nav-link">新建</a>
						<a href="javascript:previewFile();" class="nav-link">预览</a>
						<a href="javascript:notepad();" class="nav-link">编辑</a>
						<a href="javascript:publishFile();" class="nav-link">发布</a>
						<a href="javascript:uploadFile()" class="nav-link">上传</a>
						<a href="javascript:deleteFile();" class="nav-link">删除</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端 -->
			<div class="btn-group hidden-xs-down">
				<a href="javascript:changeList(2);" class="btn btn-outline-info"><i class="fa fa-th"></i></a>
				<a href="javascript:changeList(1);" class="btn btn-outline-info active"><i class="fa fa-th-list"></i></a>
			</div>
			<div class="btn-group hidden-xs-down mg-l-10">
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<div class="btn-group hidden-xs-down mg-l-auto">
				<a href="javascript:newFile();" class="btn btn-outline-info">新建</a>
				<a href="javascript:previewFile();" class="btn btn-outline-info">预览</a>
				<a href="javascript:notepad();" class="btn btn-outline-info">编辑</a>
				<a href="javascript:publishFile();" class="btn btn-outline-info">发布</a>
				<a href="javascript:uploadFile()" class="btn btn-outline-info">上传</a>
				<a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>
			</div>
			<!-- btn-group -->
								
			<div class="btn-group mg-l-10 hidden-sm-down">
				<%if(currPage>1){%>
					<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
				<%}%>
				<%if(currPage<TotalPageNumber){%>
					<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
				<%}%>
			</div>
			
			<!-- btn-group -->
		</div>
		<!--操作-->

		<!--搜索-->
		<div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
			<div class="search-content bg-white">
				<form name="search_form" action="file_list2018.jsp?currPage=1&FolderName=<%=FolderName%>&sortid=<%=sortid%>&rowsPerPage=<%=rowsPerPage%>&SiteId=<%=SiteId%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">
					<div class="row">
						<!--文件名-->
						<div class="mg-r-10 mg-b-30 search-item">
							<input class="form-control search-title" placeholder="文件名" type="text" name="Title" value="<%=S_Title%>">
						</div>
						<div class="search-item mg-b-30">
							<input type="Submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
							<input type="hidden" name="OpenSearch" value="<%=S_OpenSearch%>">
						</div>
					</div>
					<!-- row -->
				</form>
			</div>
		</div>
		<!--搜索-->

		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0" id="content-table">
					<thead>
						<tr>
							<th class="wd-5p">
								<label class="ckbox mg-b-0">
									<input type="checkbox" id="checkAll"><span></span>
								</label>
                            </th>
							<th class="tx-12-force tx-mont tx-medium" onclick="sort_select('0')" style="cursor:pointer">名称</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down" onclick="sort_select('2')" style="cursor:pointer">大小</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down" onclick="sort_select('0')" style="cursor:pointer">类型</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down" onclick="sort_select('1')" style="cursor:pointer">最后修改时间</th>
							<th class="tx-12-force wd-150 tx-mont tx-medium hidden-xs-down">操作</th>
						</tr>
					</thead>
					<tbody>
<%
if(files==null || files.length==0)
{
%>
						<tr>
							<td colspan=6 align="center">暂无文件</td>
						</tr>
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
	 if((i>=startPage)&&(i<endPage))
	 {
		if(!files[i].isDirectory())
		{
			j++;
			String FileSize = fileutil.getSize(files[i]) + "KB";
			String FileExt  = fileutil.getExt(files[i]);
			String lastModified = fileutil.lastModified(files[i]);
%>
						<tr id="jTip<%=j%>_id">
							<td class="valign-middle">
								<label class="ckbox mg-b-0">
									<input type="checkbox" name="id" value="<%=files[i].getName()%>"><span></span>
								</label>
                            </td>
							<td><i class="fa fa-file-o tx-18 tx-warning lh-0 valign-middle"></i><span class="pd-l-5"><%=files[i].getName()%></span></td>
							<td class="hidden-xs-down"><%=FileSize%></td>
							<td class="hidden-xs-down"><%=FileExt%></td>
							<td class="hidden-xs-down"><%=lastModified%></td>
							<td class="dropdown hidden-xs-down">
								<a href="javascript:publishFile1('<%=files[i].getName()%>');" class="btn pd-0 mg-r-5" title="发布"><i class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
								<a href="javascript:previewFile1('<%=files[i].getName()%>');" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
								<a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"><i class="icon ion-more"></i></a>
								<div class="dropdown-menu dropdown-menu-right pd-10">
									<nav class="nav nav-style-1 flex-column">
										<a href="javascript:newFile();" class="nav-link">新建</a>
										<a href="javascript:notepad1('<%=files[i].getName()%>');" class="nav-link">编辑</a>
										<!-- <a href="javascript:publishFile1('<%=files[i].getName()%>');" class="nav-link">发布</a> -->
										<a href="javascript:uploadFile();" class="nav-link">上传</a>
										<a href="javascript:downloadFile('<%=files[i].getName()%>');" class="nav-link">下载</a>
										<!-- <a href="javascript:previewFile1('<%=files[i].getName()%>');" class="nav-link">预览</a> -->
										<a href="javascript:deleteFile1('<%=files[i].getName()%>');" class="nav-link">删除</a>
										<a href="javascript:renameFile('<%=files[i].getName()%>');" class="nav-link">重命名</a>
										<a href="javascript:window.location.reload();" class="nav-link">刷新</a>
									</nav>
								</div>
								<!-- dropdown-menu -->
							</td>
						</tr>
<%
		}
	 }
	}
}
%>
					</tbody>
                 </table>
<%if(TotalPageNumber>0){%>
				 <!--分页-->
				<div id="tide_content_tfoot">
					<label class="ckbox mg-b-0 mg-r-30"><input type="checkbox" id="checkAll_1"><span></span></label>
					<span class="mg-r-20 ">共<%=files.length%>条</span>
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
					<div class="each-page-num mg-l-auto">
						<span class="">每页显示:</span>
						<select name="rowsPerPage" class="form-control select2 wd-80" onChange="change(this);" id="rowsPerPage">
							<option value="10">10</option>
							<option value="15">15</option>
							<option value="20">20</option>
							<option value="25">25</option>
							<option value="30">30</option>
							<option value="50">50</option>
							<option value="80">80</option>
							<option value="100">100</option>              
						</select>
						<span>条</span>
					</div>
				</div>
				<!--分页-->
<%}%>
			</div>
		</div>
		<!--列表-->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

			<!-- START: 只显示在移动端 -->
			<div class="dropdown hidden-sm-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="#" class="nav-link">搜索</a>
						<a href="javascript:newFile();" class="nav-link">新建</a>
						<a href="javascript:previewFile();" class="nav-link">预览</a>
						<a href="javascript:notepad();" class="nav-link">编辑</a>
						<a href="javascript:publishFile();" class="nav-link">发布</a>
						<a href="javascript:uploadFile()" class="nav-link">上传</a>
						<a href="javascript:deleteFile();" class="nav-link">删除</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端 -->
			<div class="btn-group hidden-xs-down">
				<a href="#" class="btn btn-outline-info"><i class="fa fa-th"></i></a>
				<a href="#" class="btn btn-outline-info active"><i class="fa fa-th-list"></i></a>
			</div>
			<div class="btn-group hidden-xs-down mg-l-10">
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<div class="btn-group hidden-xs-down mg-l-auto">
				<a href="javascript:newFile();" class="btn btn-outline-info">新建</a>
				<a href="javascript:previewFile();" class="btn btn-outline-info">预览</a>
				<a href="javascript:notepad();" class="btn btn-outline-info">编辑</a>
				<a href="javascript:publishFile();" class="btn btn-outline-info">发布</a>
				<a href="javascript:uploadFile()" class="btn btn-outline-info">上传</a>
				<a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>
			</div>
			<!-- btn-group -->
									
			<div class="btn-group mg-l-10 hidden-sm-down">
				<%if(currPage>1){%>
					<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
				<%}%>
				<%if(currPage<TotalPageNumber){%>
					<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
				<%}%>
			</div>
			
			<!-- btn-group -->
		</div>


		<script src="../lib/2018/popper.js/popper.js"></script>
		<script src="../lib/2018/bootstrap/bootstrap.js"></script>
		<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
		<script src="../lib/2018/moment/moment.js"></script>
		<script src="../lib/2018/jquery-ui/jquery-ui.min.js"></script>
		<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
		<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

		<!--<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>-->
		<script src="../lib/2018/select2/js/select2.min.js"></script>
		<script src="../common/2018/bracket.js"></script>

		<script>
			//==========================================
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


				$("#content-table tr:gt(0)").click(function () {      
			        //var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
			        if ($(this).find("input[type='checkbox']").prop("checked")){  		        
			        	 
			            $(this).find(":checkbox").prop("checked", false);
			            $(this).removeClass("bg-gray-100");
			        }else{  
			           
			            $(this).find("input[type='checkbox']").prop("checked", true);
			            $(this).addClass("bg-gray-100");
			        } 
			        checkAllCheckbox()			       
			    }); 
			    
    		    function checkAllCheckbox(){
    		    	var _checkboxAll = $("#content-table tr:gt(0)").find("td:first-child").find("input[type='checkbox']") ;
    		    	var _all =  false ;
    		    	for (var i=0;i<_checkboxAll.length;i++) {
    		    		if(!_checkboxAll.eq(i).prop("checked")){
    		    			_all = true ;
    		    		}
    		    	}
    		    	if(_all){
    		    		$("#checkAll,#checkAll_1").removeAttr("checked");
    		    	}
    		    	return;
    		    }
    		    
				$("#checkAll,#checkAll_1").click(function() {
					var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox");
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

				// Datepicker
				$('.fc-datepicker').datepicker({
					showOtherMonths: true,
					selectOtherMonths: true
				});

			});


			var upload_dialog = new top.TideDialog();
			var TCNDDU = TCNDDU || {};
			var files = null;
			var uploaded_count = 0;
		   // $.browser.chrome = /chrome/.test(navigator.userAgent.toLowerCase());
			var dropContainer;

			TCNDDU.setup = function() {
				$(document).bind("dragenter", function(event) {
					$("#output").css("borderColor", "red");
					$("#output-listing01").html("请把文件拖到这里");
					return false;
				});

				$(document).bind("dragover", function(event) {
					//$("#output").css("borderColor","silver");
					//$("#output-listing01").html("");
					event.stopPropagation();
					event.preventDefault();
					return true;
				});

				$(document).bind("drop", function(event) {
					//$("#output").css("borderColor","silver");
					$("#output-listing01").html("");
					TCNDDU.handleDrop(event);
					window.console.info("1");
					event.stopPropagation();
					event.preventDefault();
					return true;
				});

				dropContainer = document.getElementsByTagName('body')[0];

				dropContainer.addEventListener("dragenter", function(event) {
					event.stopPropagation();
					event.preventDefault();
				}, false);
				dropContainer.addEventListener("dragover", function(event) {
					event.stopPropagation();
					event.preventDefault();
				}, false);
				dropContainer.addEventListener("drop", TCNDDU.handleDrop, false);

			};

			TCNDDU.uploadProgressXHR = function(event) {
				if (event.lengthComputable) {
					var percentage = Math.round((event.loaded * 100) / event.total);
					//alert(event.target.log);
					//console.info(percentage);
					var o = upload_dialog.getObject("uploadfile2_" + event.target.log);
					//console.info(o.size());
					o.css("width", percentage + "%");
				}
			};

			TCNDDU.loadedXHR = function(event) {
				var currentImageItem = event.target.log;
				var o = upload_dialog.getObject("uploadfile2_" + event.target.log);
				o.css("width", "100%");
				uploaded_count++;
				if (uploaded_count == files.length) {
					top.TideDialogClose({
						suffix: '_upload',
						refresh: 'right'
					});
					//alert("end");
				}
			};

			TCNDDU.uploadError = function(error) {
				//console.log("error: " + error);
			};

			TCNDDU.processXHR = function(file, index) {
				var xhr = new XMLHttpRequest(),

					container = document.getElementById("item" + index),
					fileUpload = xhr.upload,
					progressDomElements = [
						document.createElement('div'),
						document.createElement('p')
					];

				progressDomElements[0].className = "progressBar";
				progressDomElements[1].textContent = "0%";
				progressDomElements[0].appendChild(progressDomElements[1]);

				fileUpload.log = index;
				fileUpload.addEventListener("progress", TCNDDU.uploadProgressXHR, false);
				fileUpload.addEventListener("load", TCNDDU.loadedXHR, false);
				fileUpload.addEventListener("error", TCNDDU.uploadError, false);


				xhr.open("POST", "file_upload_submit.jsp");

				var f = new FormData();
				f.append("FolderName", myObject.FolderName);
				f.append("ReWrite", (top.$("#ReWrite").attr("checked") ? "Yes" : ""));
				f.append("SiteId", <%=SiteId%>);
				f.append("file1", file);
				xhr.send(f);
			};

			TCNDDU.handleDrop = function(event) {
				window.console.info(event);
				if ($.browser.mozilla) var files = event.dataTransfer.files;
				if ($.browser.chrome) var files = event.originalEvent.dataTransfer.files;

				var imgPreviewFragment = document.createDocumentFragment(),
					count = files.length,
					domElements;
				//alert("count:"+count);
				event.stopPropagation();
				event.preventDefault();

				upload_dialog.setWidth(600);
				upload_dialog.setHeight(400);
				upload_dialog.setSuffix("_upload");
				//dialog.setUrl();
				upload_dialog.setTitle("上传文件");
				var html = $("#dialog_html").text();
				upload_dialog.setHtml(html);
				upload_dialog.setType(2);
				upload_dialog.show();

				var o = upload_dialog.getObject("fsUploadProgress");

				var showunzip = false;
				for (var i = 0; i < count; i++) {
					var j = files[i].name.lastIndexOf(".");
					if (j != -1) {
						var ext = files[i].name.substring(j);
						//alert(ext);
						if (ext == ".rar" || ext == ".zip")
							showunzip = true;
					}
					var html = "<tr id='uploadfile_" + i + "'><td>" + files[i].name + "</td>";
					html += '<td><div id="uploadfile2_' + i + '" style="width: 0%;" class="upload_jdt_box"></div></td>';
					html += "<td>" + Math.round(files[i].size / 1024) + " KB</td>";
					html += "<td><a href='javascript:cancelFile(\"" + i + "\");'><img src='./images/inner_menu_del.gif'></a></td>";
					html += "</tr>";
					o.append(html);
				}
				if (showunzip) top.$("#unzip_span").show();

			};

		  //  if ($.browser.mozilla || $.browser.chrome) {
		   //     window.addEventListener("load", TCNDDU.setup, false);
		   // }
		</script>
	</div>
</body>

</html>
<%}%>