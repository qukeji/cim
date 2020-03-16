<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.dict.*,
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

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script language="javascript">

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
		notepad();
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

function addDict()
{
	var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(200);
		dialog.setUrl("dict/dict_add.jsp?GroupID=<%=GroupID%>");
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

  		var url="template_edit.jsp?TemplateID="+ItemID;
  		window.open(url);
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%if(GroupID!=0){
		DictGroup group=new DictGroup(GroupID);
		out.println(group.getName()+"("+group.getCode()+")");
	}%></div>
    <div class="content_new_post">
		<div class="tidecms_btn" onClick="addDict();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">新建</div>
		</div>
		<div class="tidecms_btn" onClick="deleteDict();">
			<div class="t_btn_pic"><img src="../images/icon/del.png" /></div>
			<div class="t_btn_txt">删除</div>
		</div>
    </div>
</div>

 
<div class="content_2012">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;">名称</th>
    				<th class="v1"	align="center" valign="middle">文件名</th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;">最后修改时间</th>
    				<th class="v9" width="55" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody> 
<%
TableUtil tu = new TableUtil();
String ListSql = "select * from dict";
String CountSql = "select count(*) from dict";

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
			String Name = Rs.getString("Name");
	%>

	<tr id="jTip<%=j%>_id">
    <td class="v1" width="25" align="center" valign="middle"><input name="id" value="<%=tid%>" type="checkbox"/></td>
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png"/><%=Name%></td>
	<td class="v1" align="center" valign="middle"></td>
     <td class="v4"  style="color:#666666;"></td>
	<td class="v9">
	</td>
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
            <div class="center"><a href="template_list.jsp?currPage=1&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="template_list.jsp?currPage=<%=currPage-1%>&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="template_list.jsp?currPage=<%=currPage+1%>&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="template_list.jsp?currPage=<%=TotalPageNumber%>&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
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
		if(obj!=null)		this.location="template_list.jsp?currPage=1&GroupID=<%=GroupID%>&rowsPerPage="+obj.value+"";
	}

	function sort_select(obj){	

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
		var href="template_list.jsp?currPage="+num+"&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%>";
		document.location.href=href;
	});

	 var beforeShowFunc = function() {}
	 var menu = [
	  {'<img src="../images/inner_menu_edit.gif" title="新建模板"/>新建模板':function(menuItem,menu){newFile();}},
	  {'<img src="../images/inner_menu_edit.gif" title="编辑模板"/>编辑模板':function(menuItem,menu){notepad();}},
	  {'<img src="../images/inner_menu_edit.gif" title="编辑属性"/>编辑属性':function(menuItem,menu){editInfo();}},
	  {'<img src="../images/inner_menu_edit.gif" title="查看属性"/>查看属性':function(menuItem,menu){viewInfo();}},
	  {'<img src="../images/inner_menu_edit.gif" title="下载文件"/>下载文件':function(menuItem,menu) {downloadFile();}},
	  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile();}},
	  {'<img src="../images/inner_menu_edit.gif" title="重命名"/>重命名':function(menuItem,menu) {renameFile();}},
	  {'<img src="../images/inner_menu_cache.gif" title="刷新"/>刷新':function(menuItem,menu) {window.location.reload();}}
	  
	];

});
</script>
</body></html>