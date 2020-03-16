<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
/**
*		修改人		修改时间		备注
*		李青松		20130722		修改模板管理不能多选bug
**/
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int GroupID = getIntParameter(request,"GroupID");

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
	rows = 10;
if(cols==0)
	cols = 5;

String S_Title				=	getParameter(request,"Title");
String S_CreateDate			=	getParameter(request,"CreateDate");
String S_CreateDate1		=	getParameter(request,"CreateDate1");
String S_User				=	getParameter(request,"User");
int S_IsIncludeSubChannel	=	getIntParameter(request,"IsIncludeSubChannel");
int S_Status				=	getIntParameter(request,"Status");
int S_IsPhotoNews			=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch			=	getIntParameter(request,"OpenSearch");
int IsDelete				=	getIntParameter(request,"IsDelete");

int listType = 1;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(GroupID+"_list",request.getCookies()));
if(listType==0) listType = 1;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete;

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
.search-box {display: none;}
.border-radius-5{border-radius: 5px;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>

<script>
var listType = <%=listType%>;
var rows = <%=rows%>;
var cols = <%=cols%>;
var currRowsPerPage = <%=rowsPerPage%>;
var GroupID = <%=GroupID%>;
var currPage = <%=currPage%>;
var Parameter = "&GroupID="+GroupID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var pageName = "<%=pageName%>";

$(document).ready(function() {
	
	$("#rowsPerPage").val('<%=rowsPerPage%>');
	
	double_click();
});

//多选
function getCheckbox(){
	var id="";
	var fileName="";
	jQuery("#content-table input:checked").each(function(i){
		if(i==0){
			id+=jQuery(this).val();
			fileName+=jQuery(this).attr("fileName");
		}else{
			id+=","+jQuery(this).val();
			fileName+=","+jQuery(this).attr("fileName");
		}
	});
	var obj={length:jQuery("#content-table input:checked").length,id:id,fileName:fileName};
	return obj;
}
//双击

function double_click(type)
{
	if(type==1){
		jQuery("#content-table td:gt(0)").dblclick(function(){
				var tid=jQuery(this).attr("tid");
				
				top.TideDialogClose({suffix:'_2',recall:true,returnValue:{TemplateID:tid}});
		});

		/*jQuery("#oTable td:gt(0)").click(function(){
				jQuery("#oTable td:gt(0)").removeClass("cur");
			
				jQuery(this).addClass("cur");
		});*/
		jQuery("#content-table td[class*='tide_item']").click(function(){
				$(".tide_item").removeClass("cur");
				jQuery(this).addClass("cur");
		});
	}else{
		jQuery("#content-table tr:gt(0)").dblclick(function(){
				var tid=jQuery(this).attr("tid");
				top.TideDialogClose({suffix:'_2',recall:true,returnValue:{TemplateID:tid}});
		});

		jQuery("#content-table tr:gt(0)").click(function(){
				jQuery("#content-table tr:gt(0)").removeClass("cur");
				jQuery(this).addClass("cur");
		});
	}
	
}

 //function double_click(type)
//{	
//	if(type==1){
//		jQuery("#content-table tr:gt(0)").dblclick(function(){
//			notepad();
//		});
//	}
//	if(type==3){
//		jQuery("#content-table .tide_item").dblclick(function(){
//			notepad();
//		});
//	}
//}
//编辑
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
			 var url="deletefile.jsp?Action=Delete&ItemID="+selectedItem;
			  $.ajax({
				 type: "GET",dataType:"json",url: url,
				 success: function(o){
					 if(o.status==0)
					 {
						 alert(o.message);
					 }					 
					 document.location.href=document.location.href;
				}
			});
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
		dialog.setUrl("renamefile.jsp?GroupID=<%=GroupID%>&ItemID="+obj.id);
		dialog.setTitle("重命名");
		dialog.show();	
}

function newFile()
{
	var	dialog = new top.TideDialog();
		dialog.setWidth(600);
		dialog.setHeight(450);
		dialog.setUrl("newfile.jsp?GroupID=<%=GroupID%>");
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
		dialog.setUrl("viewinfo.jsp?id="+obj.id);
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
		dialog.setWidth(600);
		dialog.setHeight(450);
		dialog.setUrl("newfile.jsp?GroupID=<%=GroupID%>&ItemID="+obj.id);
		dialog.setTitle("编辑属性");
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
		if(!jQuery("#Download"+i).length)
		{
			var frame='<iframe id="Download'+i+'"  name="Download'+i+'" style="display:none;width:0px;height:0px;"></iframe>';
			jQuery("body").append(frame);
		}
		//alert(window.window.frames["Download"+i].location);
		if(window.frames["Download"+i])
		{
			window.frames["Download"+i].location = "template_download.jsp?Type=File&id="+ItemID;
		}				

	}
}

function changeList(i)
{
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = GroupID+"_list=" + i + ";path=/;expires=" + expires.toGMTString();
	document.location.href = pageName + '?listtype=' + i + '&cookie=1&id='+GroupID+Parameter;
}

</script>
</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
	
	<div class="br-pageheader pd-y-10 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">
			系统管理 <%if(GroupID!=0){
				TemplateFile tf=new TemplateFile();
				tf.setGroup(GroupID);
				 String GroupIdName = tf.getGroupTree().replace("/"," / ");
				GroupIdName = GroupIdName.substring(0,GroupIdName.length() - 2);
				out.println(GroupIdName);
			}%>
		  </span>
        </nav>
       
    </div><!-- br-pageheader -->

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


int listnum = rowsPerPage;
if(listType==3) listnum = cols*rows;
ResultSet Rs = tu.List(ListSql,CountSql,currPage,100);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();

%>
	<!--操作-->
	<div class="d-flex align-items-center justify-content-start pd-x-20">

		
        <div class="btn-group mg-l-auto hidden-sm-down">
          <%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a><%}%>
          <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a><%}%>
        </div><!-- btn-group -->

     </div><!--操作-->
    

	<!--列表-->
	 <div class="br-pagebody pd-x-20 mg-t-15">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
<%if(listType==1){%>
				<thead>
				  <tr>
					<th class="tx-12-force tx-mont tx-medium">名称</th>
		              <th class="tx-12-force tx-mont tx-medium">文件名</th>
		              <th class="tx-12-force tx-mont tx-medium">最后修改时间</th> 
				  </tr>
				</thead>
<%}%>
				<tbody>
<%
if(TotalNumber>0){
	int j = 0;
	int m=0;
	FileUtil fileutil = new FileUtil();


	while(Rs.next()){
		j++;
		int tid = Rs.getInt("id");
		TemplateFile tf = new TemplateFile(tid);
		if(listType==1){
			String FileSize = "";//fileutil.getSize(files[i]) + "KB";
			String FileExt  = "";//fileutil.getExt(files[i]);
			String lastModified = tf.getModifiedDate();//fileutil.lastModified(files[i]);
%>
				<tr id="jTip<%=j%>_id" tid=<%=tid%> class="tide_item">					
					<td class="hidden-xs-down"><img src="../images/tree6.png"/><%=tf.getName()%></td>
					<td class="hidden-xs-down"><%=tf.getFileName()%></td>
					<td class="hidden-xs-down"><%=lastModified%></td>					
				</tr>
<%		}
	}
	tu.closeRs(Rs);
}
%>
<script>
	function Preview(Photopath){
		window.open(Photopath);
	}
</script>
				</tbody>
			</table>

			
		</div>
	 </div><!--列表-->

	   
	

	
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

	<script>

//==========================================

function change(obj){
	if(obj!=null)		this.location="template_list2018.jsp?currPage=1&GroupID=<%=GroupID%>&rowsPerPage="+obj.value+"<%=querystring%>";
}

//跳页
function jumpPage(){
	var num=jQuery("#jumpNum").val();
	if(num==""){
		alert("请输入数字!");
		jQuery("#jumpNum").focus();
		return;
	}
	var reg=/^[0-9]+$/;
	if(!reg.test(num)){
		alert("请输入数字!");
		jQuery("#jumpNum").focus();
		return;
	}

	if(num<1)
		num=1;

	gopage(num);

//	var href="template_list2018.jsp?currPage="+num+"&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
//	document.location.href=href;
}
function gopage(currpage)
{
	var url = "template_list2018.jsp?currPage="+currpage+"&GroupID=<%=GroupID%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
	this.location = url;
}
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
</div>
</body>
</html>
