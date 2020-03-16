<%@ page import="tidemedia.cms.util.*,
				 tidemedia.cms.system.*,
				 org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	 /**
	  * 用途 ：数据库列表
	  *	1，丁文豪   201504017    优化function checkbox()方法
	  * 
	  * 
	  */

	if(!userinfo_session.isAdministrator())
	{ 
		response.sendRedirect("../noperm.jsp");
		return;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/tidecms7.css" rel="stylesheet" />
<style>
body{background:none;}
.file_upload_dir,.file_upload_over,.file_upload_choose,.file_upload_choose_txt{float:left;}
.file_upload_over{margin:0 15px;*margin:-4px 15px 0;}
.file_upload_over label{vertical-align:middle;cursor:pointer;margin:0 0 0 2px;*margin:0;}
.file_upload_choose .swfupload{margin:-5px 0 0;}
</style>

<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript">

function checkbox()
{
	var chestr="";
    $("input[name='dbname']:checked").each(function(){
      chestr+=$(this).val();
    });
    if(chestr == "")
	{
	  alert("请先选择一个数据库！");
	  return false;
	}
	else
	{
	  return true;
	}
}
function uncheckAll() 
{ 
	$(":checkbox").attr("checked", false); 
} 
function checkAll() 
{ 
	$(":checkbox").attr("checked", true); 
}
$(function(){
	$.ajax({
		url:"db_config.jsp",
		type:"post",
		dataType:"json",
		success:function(json){
			var html = "";
			$.each(json.databases,function(index,obj){
				var temp = "-u"+obj.username+" -p"+obj.password+" -h"+obj.url+" "+obj.name;
				html += ' <tr><td align="center"><input type="checkbox" name="dbname" value="'+temp+'" /></td><td>'+obj.name+'</td></tr>';
			});
			$("#database>tbody").html(html);
		}
	});
});
/*
function closewindow(){
	this.close();
}
function selectthis(obj)
{
	if(obj.checked==true)
	{
		document.getElementById('backuppath').value+=obj.value+",";
	}
	else if(obj.checked==false)
	{
		document.getElementById('backuppath').value=document.getElementById('backuppath').value.replace( obj.value+",","");
	}
}
*/
</script>
</head>

<body>
<form action="database_backup_submit.jsp" method="post"  name="form" >
<div class="iframe_form">
	<div class="form_top">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="form_main">
    	<div class="form_main_m" style="height:290px;">
<table  border="0">
   <tr>
    <td align="left" valign="middle">
	<div class="file_upload_choose">
		<span class="file_upload_choose_txt"></span>
		
	</div>
	</td>
  </tr>
  <tr>
    <td valign="middle" width="600">
	<div class="viewpane_tbdoy">
		<table width="100%" border="0" id="database" class="view_table">
		<thead>
				<tr id="oTable_th">
					<th width="10%"></th>
					<th>数据库名</th>
				</tr>
		</thead>
		<tbody>
		</tbody>
		<tfoot>
		 <tr>
			<td align="center">
				<!--<input type="checkbox" name="all" value="" onClick="return checkAll()"/>-->
			</td>
			<td><a onClick="return checkAll()">全选</a>    <a onClick="return uncheckAll()">反选</a></td>
		 </tr>
		</tfoot>
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
<div class="form_button">
	<input name="startButton" type="submit" class="button" value="确定" id="startButton"  onclick="return checkbox();"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1" onclick="top.TideDialogClose({suffix:'_1'});" />
</div>
</form>
</body>
</html>
