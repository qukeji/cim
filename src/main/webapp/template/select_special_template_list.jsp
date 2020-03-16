<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int GroupID = getIntParameter(request,"GroupID");

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));
if(rowsPerPage<=0)
	rowsPerPage = 20;

String S_Title			=	getParameter(request,"Title");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script language="javascript">
function openSearch()
{
	jQuery("#SearchArea").toggle();
}

function getCheckbox(){
	var id="";
	var fileName="";
	jQuery("#oTable input:checked").each(function(i){
		if(i==0){
			id+=jQuery(this).val();
			fileName+=jQuery(this).attr("fileName");
		}else{
			id+=","+jQuery(this).val();
			fileName+=","+jQuery(this).attr("fileName");
		}
	});
	var obj={length:jQuery("#oTable input:checked").length,id:id,fileName:fileName};
	return obj;
}



function double_click()
{
	jQuery("#oTable tr:gt(0)").dblclick(function(){
			var tid=jQuery(this).attr("tid");
			top.TideDialogClose({suffix:'_2',recall:true,returnValue:{TemplateID:tid}});
	});

	jQuery("#oTable tr:gt(0)").click(function(){
			jQuery("#oTable tr:gt(0)").removeClass("cur");
			jQuery(this).addClass("cur");
	});
}


var myObject = new Object();
 myObject.title = "新建文件";

function deleteFile()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择要删除的文件！");
		return;
	}
		
		var selectedItem=obj.id;
		var message = "";
		if(obj.length<5)
		{
			message = "确实要删除\""+obj.fileName+"\"吗？";
		}
		else
		{
			message = "确实要删除这"+obj.length+"项吗？";
		}

		if(confirm(message)) 
		{
			this.location = "deletefile.jsp?Action=Delete&ItemID="+selectedItem;
		}
}

function renameFile()
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

	var	dialog = new top.TideDialog();
		dialog.setWidth(330);
		dialog.setHeight(215);
		dialog.setUrl("template/renamefile.jsp?GroupID=<%=GroupID%>&ItemID="+obj.id);
		dialog.setTitle("重命名");
		dialog.show();	
}

function newFile()
{
	var	dialog = new top.TideDialog();
		dialog.setWidth(450);
		dialog.setHeight(400);
		dialog.setSuffix("_3");
		dialog.setLayer(2);
		dialog.setUrl("../template/newfile.jsp?GroupID=<%=GroupID%>&suffix=_3");
		dialog.setTitle("新建模板");
		dialog.show();
}

function viewInfo()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择文件!");
		return;
	}

	if(obj.length>1){
		alert("请选择一个文件!");
		return;
	}
	var	dialog = new top.TideDialog();
		dialog.setWidth(450);
		dialog.setHeight(400);
		dialog.setUrl("template/viewinfo.jsp?id="+obj.id);
		dialog.setTitle("查看属性");
		dialog.show();	
}

function editInfo()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择文件！");
		return;
	}

	if(obj.length>1){
			alert("请选择一个文件!");
		return;
	}

	var	dialog = new top.TideDialog();
		dialog.setWidth(450);
		dialog.setHeight(400);
		dialog.setUrl("template/newfile.jsp?GroupID=<%=GroupID%>&ItemID="+obj.id);
		dialog.setTitle("查看属性");
		dialog.show();	
}

function uploadFile()
{
    myObject.title = "上传文件";
	var Feature = "dialogWidth:32em; dialogHeight:23em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=template/file_upload.jsp",myObject,Feature);
	if(retu!=null)
		window.location.reload();
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
			 var  ItemID =files[i];
				if(document.all("Download"+i)==null)
				{
				  var tempIFrame=document.createElement('iframe');
				  tempIFrame.setAttribute('id','Download'+i);
				  tempIFrame.style.border='0px';
				  tempIFrame.style.width='0px';
				  tempIFrame.style.height='0px';
				  document.body.appendChild(tempIFrame);
				}
				//alert(window.window.frames["Download"+i].location);
				if(window.frames["Download"+i])
					//window.frames["Download"+i].location = "../download.jsp?Template=True&Type=File&FileName="+encodeURI(selectedFile)+"&FolderName="+encodeURI(myObject.FolderName);
				window.frames["Download"+i].location = "template_download.jsp?Type=File&id="+ItemID;

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
		var ItemID=obj.id; 
  		var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  		var url="notepad.jsp?TemplateID="+ItemID;
  		window.open(url,"",Feature);
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<style>
body,html{height:100%;overflow:hidden;}
</style>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%if(GroupID!=0){
		TemplateFile tf=new TemplateFile();
		tf.setGroup(GroupID);
		out.println(tf.getGroupTree());
	}%></div>
    <div class="content_new_post">
    	<a href="javascript:openSearch();" class="first">检索</a>
        <a href="javascript:newFile();" class="second">新建</a>
    </div>
</div>
<div class="viewpane_c1" id="SearchArea"  style="display:<%=(!S_Title.trim().equals("")?"":"none")%>">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20">&nbsp;</td>
    <td><form name="search_form" action="select_template_list.jsp?GroupID=<%=GroupID%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：文件名
		  <input name="Title" type="text" id="Title" size="18" class="textfield" value="<%=S_Title%>"> 
    <input type="hidden" name="OpenSearch" id="OpenSearch" value="0">
    <input type="submit" name="Submit" class="tidecms_btn3" value="查找">
	</form></td>
    <td width="20">&nbsp;</td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content" style="overflow:hidden;">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy" style="height:340px;overflow-y:auto;">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v3" style="padding-left:10px;text-align:left;">名称</th>
    				<th class="v1"	align="center" valign="middle">文件名</th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;">最后修改时间</th>
  				</tr>
</thead>
 <tbody> 
<%
TableUtil tu = new TableUtil();
String ListSql = "select * from template_files";
String CountSql = "select count(*) from template_files";

if(GroupID==0)
{
	ListSql += " where GroupID=0 or GroupID is null";
	CountSql += " where GroupID=0 or GroupID is null";
}
else
{
	ListSql += " where GroupID=" + GroupID;
	CountSql += " where GroupID=" + GroupID;
}

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	ListSql +=" and FileName like '%" + tu.SQLQuote(tempTitle) + "%'";
	CountSql +=" and FileName like '%" + tu.SQLQuote(tempTitle) + "%'";
}

ListSql += " order by id";

ResultSet Rs = tu.List(ListSql,CountSql,1,1000);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
if(tu.pagecontrol.getRowsCount()>0)
{
	int j = 0;
	FileUtil fileutil = new FileUtil();
	//TemplateFile tf = null;

	while(Rs.next())
	{
			j++;
			int tid = Rs.getInt("id");
			TemplateFile tf = new TemplateFile(tid);

			String FileSize = "";//fileutil.getSize(files[i]) + "KB";
			String FileExt  = "";//fileutil.getExt(files[i]);
			String lastModified = tf.getModifiedDate();//fileutil.lastModified(files[i]);
			
			//System.out.println((FolderName.startsWith("/")?FolderName:"/"+FolderName) + files[i].getName());
			//tf = new TemplateFile((FolderName.startsWith("/")?FolderName:"/"+FolderName) + "/" + files[i].getName());
	%>

	<tr id="jTip<%=j%>_id"  tid="<%=tid%>">
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png"/><%=tf.getName()%></td>
	<td class="v1" align="center" valign="middle"><%=tf.getFileName()%></td>
     <td class="v4"  style="color:#666666;"><%=lastModified%></td>
  </tr>
<%
		}
}

tu.closeRs(Rs);
%>
  
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
        	<div class="select">选择：<span id="selectAll">全部</span><span id="selectNo">无</span>			</div>
        	<div class="left">共 条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="select_template_list.jsp?currPage=1&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="select_template_list.jsp?currPage=<%=currPage-1%>&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="select_template_list.jsp?currPage=<%=currPage+1%>&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="select_template_list.jsp?currPage=<%=TotalPageNumber%>&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
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
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
 
<script type="text/javascript"> 	
	function change(obj)
	{
		if(obj!=null)		this.location="select_template_list.jsp?currPage=1&GroupID=<%=GroupID%>&rowsPerPage="+obj.value+"<%=querystring%>";
	}

	function sort_select(obj){	

	}

jQuery(document).ready(function(){
	jQuery("#rowsPerPage").val('<%=rowsPerPage%>');
	 double_click();

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
		var href="select_template_list.jsp?currPage="+num+"&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		document.location.href=href;
	});

	 jQuery("#oTable").tablesorter({ 
            headers: {2: { 
                    sorter:'text' 
                } 
            },sortList:[[2,1]] 
        });
});
</script>
</body></html>