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
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
request.setCharacterEncoding("utf-8");
int SiteId = Util.getIntParameter(request,"SiteId");

String FolderName = Util.ClearPath(getParameter(request,"FolderName"));

Site site;

if(SiteId==0)
	site = defaultSite;
else
	site = CmsCache.getSite(SiteId);

SiteId = site.getId();

String SiteFolder=site.getSiteFolder();		  //System.out.println(SiteFolder);
String siteName=site.getName();
//String FolderName = getParameter(request,"FolderName");
//System.out.println(FolderName);
//String RealPath = SiteFolder + "/" + FolderName;
String RealPath = CmsCache.getParameterValue("video_folder");
out.println("---"+RealPath);
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
		  rowsPerPage=10;
	} 
	String scurrPage= request.getParameter("currPage");
	if((scurrPage!=null)&&(!scurrPage.equals(""))){
            currPage=Integer.parseInt(scurrPage);
	}else{
	   currPage=1;
	}
  String querystring="&FolderName="+FolderName+"&Title="+S_Title+"&sortid="+sortid+"&OpenSearch="+S_OpenSearch+"&rowsPerPage="+rowsPerPage+"&SiteId="+SiteId;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/explorer.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script type="text/javascript">
	var myObject = new Object();
    myObject.title = "新建文件";
    myObject.FolderName = "<%=FolderName%>";
   	myObject.SiteId="<%=SiteId%>"; 
function deleteFile()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择要删除的文件！");
		return;
	}
		var selectedFile=obj.id;
		var message = "";
		if(obj.length<5)
		{
			message = "确实要删除\""+obj.id+"\"吗？";
		}
		else
		{
			message = "确实要删除这"+obj.length+"项吗？";
		}
		if(confirm(message)) 
		{
			this.location = "file_delete.jsp?Action=Delete&FolderName="+encodeURI(myObject.FolderName)+"&FileName="+encodeURI(selectedFile)+"&SiteId="+myObject.SiteId;
		}

}

function renameFile()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择重命名的文件！");
		return;
	}

	if(obj.length>1){
		alert("请选择一个重命名的文件！");
		return;
	}
	 selectedFile = obj.id;
	var	dialog = new top.TideDialog();
		dialog.setWidth(330);
		dialog.setHeight(215);
		dialog.setUrl("explorer/renamefile.jsp?FolderName=<%=FolderName%>&SiteId=<%=SiteId%>&FileName="+encodeURI(selectedFile));
		dialog.setTitle("重命名");
		dialog.show();		
}

function publishFile()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择要发布的文件！");
		return;
	}
	var selectedFile=obj.id;
	this.location = "file_publish.jsp?FileName="+encodeURI(selectedFile) + "&FolderName="+encodeURI(myObject.FolderName)+"&SiteId="+myObject.SiteId;
}

function newFile()
{
	var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(200);
		dialog.setUrl("explorer/newfile.jsp?FolderName=<%=FolderName%>&SiteId=<%=SiteId%>");
		dialog.setTitle("新建文件");
		dialog.show();
}

function uploadFile()
{
	var	dialog = new top.TideDialog();
		dialog.setWidth(600);
		dialog.setHeight(400);
		dialog.setUrl("explorer/file_upload.jsp?FolderName=<%=FolderName%>&SiteId=<%=SiteId%>");
		dialog.setTitle("上传文件");
		dialog.show();
}

function downloadFile()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择要下载的文件！");
		return;
	}

	if(obj.length>1){
		alert("请选择一个要下载的文件！");
		return;
	}

	var files=(obj.id).split(",");
	for(var i=0;i<files.length;i++){
			 var  selectedFile =files[i];
				if(!jQuery("#Download"+i).length)
				{
				  var frame='<iframe id="Download'+i+'"  name="Download'+i+'" style="display:none;width:0px;height:0px;"></iframe>';
				  jQuery("body").append(frame);
				}
	
				if(window.frames["Download"+i]){
					window.frames["Download"+i].location = "../download.jsp?Type=File&FileName="+encodeURI(selectedFile)+"&FolderName="+encodeURI(myObject.FolderName)+"&SiteId="+myObject.SiteId;
				}

	}

}

function notepad()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择文件！");
		return;
	}
	
	if(obj.length>1){
		alert("请选择一个文件！");
		return;
	}
	var selectedFile=obj.id;

  	var url="notepad.jsp?FolderName="+encodeURI(myObject.FolderName)+"&FileName=" + encodeURI(selectedFile)+"&SiteId="+myObject.SiteId;
  	window.open(url);
}

function previewFile()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择要预览的文件！");
		return;
	}
	
	if(obj.length>1){
		alert("请选择一个要预览的文件！");
		return;
	}

    selectedFile =obj.id;
	 window.open("preview.jsp?FolderName="+encodeURI(myObject.FolderName)+"&FileName=" + encodeURI(selectedFile)+"&SiteId="+myObject.SiteId);	
}




function selectItem(obj)
{
	//alert(obj.className);
	if(obj.className!="rows3")
	{
		var curr_row;

		if(window.event.ctrlKey!=true)
		{
			for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
			{
			  if(oTable.rows[curr_row].className=="rows3")
				  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
			}
		}
		obj.className = "rows3";
	}
	else
		obj.className = obj.oldclass;
}

function changeList(i)
{
	if(i==1)
	{
		document.location.href='file_list.jsp?cookie=1&SiteId=<%=SiteId%>&FolderName=<%=FolderName%>';
	}
	else if(i==2)
	{
		document.location.href='file_list_image.jsp?cookie=1&SiteId=<%=SiteId%>&FolderName=<%=FolderName%>';
	}

}

var	upload_dialog = new top.TideDialog();
var TCNDDU = TCNDDU || {};
var files = null;
var uploaded_count = 0;
$.browser.chrome = /chrome/.test(navigator.userAgent.toLowerCase());
var dropContainer;
			
		TCNDDU.setup = function () {
				$(document).bind("dragenter", function(event) { 
					$("#output").css("borderColor","red");
					$("#output-listing01").html("请把文件拖到这里");
					return false; }); 

				$(document).bind("dragover", function(event) {
					//$("#output").css("borderColor","silver");
					//$("#output-listing01").html("");
					event.stopPropagation(); event.preventDefault();
					return true; }); 

				$(document).bind("drop", function(event) { 
					//$("#output").css("borderColor","silver");
					$("#output-listing01").html("");
					TCNDDU.handleDrop(event);
					window.console.info("1");
					event.stopPropagation(); event.preventDefault();
					return true; }); 
					
				dropContainer = document.getElementsByTagName('body')[0];
				
				dropContainer.addEventListener("dragenter", function(event){
				event.stopPropagation();event.preventDefault();}, false);
				dropContainer.addEventListener("dragover", function(event){event.stopPropagation(); event.preventDefault();}, false);
				dropContainer.addEventListener("drop", TCNDDU.handleDrop, false);
				
			};
			
			TCNDDU.uploadProgressXHR = function (event) {
				if (event.lengthComputable) {
					var percentage = Math.round((event.loaded * 100) / event.total);
					//alert(event.target.log);
					//console.info(percentage);
					var o = upload_dialog.getObject("uploadfile2_"+event.target.log);
					//console.info(o.size());
					o.css("width",percentage+"%");
					//this.fileProgressElement.childNodes[0].style.width = percentage + "%";
					/*
					if (percentage < 100) {
						event.target.log.firstChild.nextSibling.firstChild.style.width = (percentage*2) + "px";
						event.target.log.firstChild.nextSibling.firstChild.textContent = percentage + "%";
					}*/
				}
			};
			
			TCNDDU.loadedXHR = function (event) {
				var currentImageItem = event.target.log;
				var o = upload_dialog.getObject("uploadfile2_"+event.target.log);
				o.css("width","100%");
				//count = files.length;
				//for (var i = 0; i < count; i++)
				//{
				//	var o = upload_dialog.getObject("uploadfile2_"+event.target.log);
				//	if(o.css("width")!="100%")
				//		return;
				//}
				uploaded_count ++;
				if(uploaded_count==files.length)
				{
					top.TideDialogClose({suffix:'_upload',refresh:'right'});
					//alert("end");
				}
				//currentImageItem.className = "loaded";
				//console.log("xhr upload of "+event.target.log.id+" complete");
			};
			
			TCNDDU.uploadError = function (error) {
				//console.log("error: " + error);
			};
			
			TCNDDU.processXHR = function (file, index) {
				var xhr = new XMLHttpRequest(),
				
				container = document.getElementById("item"+index),
					fileUpload = xhr.upload,
					progressDomElements = [
						document.createElement('div'),
						document.createElement('p')
					];

				progressDomElements[0].className = "progressBar";
				progressDomElements[1].textContent = "0%";
				progressDomElements[0].appendChild(progressDomElements[1]);
				
				//container.appendChild(progressDomElements[0]);
				
				fileUpload.log = index;
				fileUpload.addEventListener("progress", TCNDDU.uploadProgressXHR, false);
				fileUpload.addEventListener("load", TCNDDU.loadedXHR, false);
				fileUpload.addEventListener("error", TCNDDU.uploadError, false);

				
				xhr.open("POST", "file_upload_submit.jsp");
				//xhr.overrideMimeType('text/plain; charset=x-user-defined-binary');
				//xhr.sendAsBinary(file.getAsBinary());
			
				var f = new FormData();
				f.append("FolderName",myObject.FolderName);
				f.append("ReWrite",(top.$("#ReWrite").attr("checked")?"Yes":""));
				f.append("SiteId",<%=SiteId%>);
				f.append("file1", file);
				xhr.send(f);
				/*
				var fileName = file.name;  
				var fileSize = file.size;  
				var fileData = file.getAsBinary();
				var boundary = "xxxxxxxxx";
				xhr.setRequestHeader("Content-Type", "multipart/form-data, boundary="+boundary); // simulate a file MIME POST request.  
				xhr.setRequestHeader("Content-Length", fileSize);  
				  
				var body = '';  
				body += "--" + boundary + "\r\n";  
				body += "Content-Disposition: form-data; name=\"FolderName\"\r\n\r\n";
				body += myObject.FolderName;
				body += "\r\n"; 
				body += "--" + boundary + "\r\n";  
				body += "Content-Disposition: form-data; name=\"ReWrite\"\r\n\r\n";				
				body += (top.$("#ReWrite").attr("checked")?"Yes":"");
				body += "\r\n"; 
				body += "--" + boundary + "\r\n";  
				body += "Content-Disposition: form-data; name=\"UnZip\"\r\n\r\n";				
				body += (top.$("#UnZip").attr("checked")?"Yes":"");
				body += "\r\n"; 
				//alert(body);UnZip
				//内容
				body += "--" + boundary + "\r\n";  
				body += "Content-Disposition: form-data; name=\""+""+"\"; filename=\"" + encodeURIComponent(fileName) + "\"\r\n";  
				body += "Content-Type: application/octet-stream\r\n\r\n";  
				body += fileData + "\r\n";  
				body += "--" + boundary + "--\r\n";
				//alert(body);
				xhr.sendAsBinary(body); 
				*/
			};
			
			TCNDDU.handleDrop = function (event) {
				//alert("ok");
				window.console.info(event);
				if($.browser.mozilla) var files = event.dataTransfer.files;
				if($.browser.chrome) var files = event.originalEvent.dataTransfer.files;

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
					//top.$("ok").appendTo("#popmain_upload");

					var showunzip = false;
					for (var i = 0; i < count; i++) {
							var j = files[i].name.lastIndexOf(".");
							if(j!=-1){
								var ext = files[i].name.substring(j);
								//alert(ext);
								if(ext==".rar" || ext==".zip")
									showunzip = true;
							}
							var html = "<tr id='uploadfile_"+i+"'><td>"+files[i].name+"</td>";
							html += '<td><div id="uploadfile2_'+i+'" style="width: 0%;" class="upload_jdt_box"></div></td>';
							html += "<td>"+Math.round(files[i].size/1024)+" KB</td>";
							html += "<td><a href='javascript:cancelFile(\""+i+"\");'><img src='./images/inner_menu_del.gif'></a></td>";
							html += "</tr>";
							o.append(html);
					}
					if(showunzip) top.$("#unzip_span").show();

			};
			
			if($.browser.mozilla || $.browser.chrome)
			{
				window.addEventListener("load", TCNDDU.setup, false);
			}

function start_upload()
{
	count = files.length;
	for (var i = 0; i < count; i++)
	{
		TCNDDU.processXHR(files.item(i), i);
	}
}
</script>
</head>
<body>
  	<div class="viewpane">

        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;"><a href="javascript:sort_select('0')">名称</a></th>
    				<th class="v1"	align="center" valign="middle"><a href="javascript:sort_select('2')">大小</a</th>
    				<th class="v8"  align="center" valign="middle"><a href="javascript:sort_select('0')">类型</a</th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;"><a href="javascript:sort_select('1')">最后修改时间</a</th>
    				<th class="v9" width="55" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody> 
 <%
if(files==null || files.length==0)
{
%>
<tr><td colspan=6 align=center><br><br>没有文件。</td></tr>
<%
}
else
{
%>
<%
	//TotalPageNumber=files.length/rowsPerPage+1;
	 // double PageNumbe=Math.round(files.length/rowsPerPage+0.5);
	 double PageNumbe=Math.ceil((double)files.length/(double)rowsPerPage);
TotalPageNumber=(int)PageNumbe;
	int startPage=(currPage-1)*rowsPerPage;
	int endPage=currPage*rowsPerPage;
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
    <td class="v1" width="25" align="center" valign="middle"><input name="id" value="<%=files[i].getName()%>" type="checkbox"/></td>
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png"/><span id=""><%=files[i].getName()%></span></td>
    
	<td class="v1" align="center" valign="middle"><%=FileSize%></td>
    <td class="v8" ><%=FileExt%></td>
     <td class="v4"  style="color:#666666;"><%=lastModified%></td>
	<td class="v9">
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
        </div>
        <div class="viewpane_pages">
        	<div class="select"><!--选择：<span id="selectAll">全部</span><span id="selectNo">无</span>			--></div>
        	<div class="left">共<%=files.length%>条 <%=currPage%>/<%=TotalPageNumber%>页</div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="file_list_choose.jsp?currPage=1<%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="file_list_choose.jsp?currPage=<%=currPage-1%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="file_list_choose.jsp?currPage=<%=currPage+1%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="file_list_choose.jsp?currPage=<%=TotalPageNumber%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
            <div class="right">
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="rowsPerPage" onChange="change(this);" id="rowsPerPage">
                    <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="25">25</option>
                    <option value="30">30</option>
                    <option value="50">50</option>
                    <option value="80">80</option>
                    <option value="100">100</option>
                  </select>
                </div>
                </div>
            	<div style="float:left;">条</div>
            </div>
        </div>
  </div>
 
</div>

 
<script type="text/javascript"> 
	function change(obj)
	{
		if(obj!=null)		this.location="file_list.jsp?currPage=1&FolderName=<%=FolderName%>&Title=<%=S_Title%>&sortid=<%=sortid%>&OpenSearch=<%=S_OpenSearch%>&rowsPerPage="+obj.value+"&SiteId=<%=SiteId%>";
	}

	function sort_select(obj){	this.location="file_list.jsp?currPage=1&FolderName=<%=FolderName%>&Title=<%=S_Title%>&rowsPerPage=<%=rowsPerPage%>&OpenSearch=<%=S_OpenSearch%>&sortid="+obj+"&SiteId=<%=SiteId%>";
	}

jQuery(document).ready(function(){
	jQuery("#rowsPerPage").val('<%=rowsPerPage%>');
	 double_click();
	jQuery(":checkbox",jQuery("#oTable")).click(function(){
		var obj=jQuery(this).parent().parent();
		obj.toggleClass("cur");
	 });
	jQuery("#selectAll").click(function(){
		jQuery("#oTable tr").addClass("cur");
		var obj=jQuery(":checkbox",jQuery("#oTable"));
		obj.attr("checked","checked");
	});

	jQuery("#selectNo").click(function(){
		jQuery("#oTable tr").removeClass("cur");
		var obj=jQuery(":checkbox",jQuery("#oTable"));
		obj.removeAttr("checked","checked");

	});
	
	jQuery("#oTable td:has(img)").click(function(){
		jQuery("#selectNo").trigger("click");
		var obj=jQuery(this).parent();
		var obj2=jQuery(":checkbox",jQuery(obj));
		obj2.trigger("click");
	});

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
		var href="file_list.jsp?currPage="+num+"<%=querystring%>";
		document.location.href=href;
	});

	 var beforeShowFunc = function() {}
	 var menu = [
	  {'<img src="../images/inner_menu_edit.gif" title="新建文件"/>新建文件':function(menuItem,menu){newFile();}},
	  {'<img src="../images/inner_menu_edit.gif" title="记事本"/>记事本':function(menuItem,menu) {notepad();}},
	  {'<img src="../images/inner_menu_edit.gif" title="发布文件"/>发布文件':function(menuItem,menu) {publishFile();}},
	  {'<img src="../images/inner_menu_edit.gif" title="上传文件"/>上传文件':function(menuItem,menu) {uploadFile();}},
	  {'<img src="../images/inner_menu_edit.gif" title="下载文件"/>下载文件':function(menuItem,menu) {downloadFile();}},
	  {'<img src="../images/inner_menu_preview.gif" title="预览"/>预览':function(menuItem,menu){previewFile();}},
	  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile();}},
	  {'<img src="../images/inner_menu_edit.gif" title="重命名"/>重命名':function(menuItem,menu) {renameFile();}},
	  {'<img src="../images/inner_menu_cache.gif" title="刷新"/>刷新':function(menuItem,menu) {window.location.reload();}}
	  
	];
	 jQuery('#oTable tr:gt(0)').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
</script>

<textarea id="dialog_html" style="display:none">
<div class="iframe_form">
	<div class="form_top">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="form_main">
    	<div class="form_main_m"  style="height:290px;">
<table  border="0">
   <tr>
    <td align="left" valign="middle"><span class="file_upload_dir">上级目录：<%=FolderName%></span>&nbsp;&nbsp;<span class="file_upload_over"><label for="ReWrite"> 重名覆盖</label><input type="checkbox" name="ReWrite" id="ReWrite" value="Yes">&nbsp;&nbsp;<span id="unzip_span" style="display:none"><label for="ReWrite"> 解压缩</label><input type="checkbox" name="UnZip" id="UnZip" value="Yes"></span><div class="file_upload_choose"><span class="file_upload_choose_txt"> </span><span id="spanButtonPlaceHolder"></span></div>
	</td>

  </tr>
  <tr>
    <td valign="middle" width="600">
	<div class="viewpane_tbdoy">
		<table width="100%" border="0" id="fsUploadProgress" class="view_table">
		<thead>
				<tr id="oTable_th">
							<th class="v3" width="200">名称</th>
							<th class="v8" >进度</th>
							<th class="v8" width="60">大小</th>
							<th class="v9" width="20" align="center" valign="middle">>></th>
				</tr>
		</thead>
		</table>   
	</div>
    </td>
  </tr>
</table>
		</div>
    </div>
    <div class="form_bottom">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
</div>
</textarea>
<script>
function getCheckbox(){
var id="";
jQuery("#oTable input:checked").each(function(i){
if(i==0)
id+=jQuery(this).val();
else
id+=","+jQuery(this).val();
});
var obj={length:jQuery("#oTable input:checked").length,id:id};
return obj;
} 
function insertVideo(){
	var filename = "";
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择一个文件！");
	}else if(obj.length>1){
		alert("请先选择一个文件！");
	}else{
		//Preview2(obj.id);
		filename = obj.id;
	}
	$(window.parent.frames["popiframe_1"].document).find("#videoname").html(filename)
	top.TideDialogClose('');
}
</script>

<div class="form_button">
	<input name="startButton" type="button" class="button" value="确定" id="startButton"  onclick="insertVideo()"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>

</body></html><%}%>