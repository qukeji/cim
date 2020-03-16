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
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	.collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
	table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
	table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
	border-collapse: collapse !important;}
	.list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;}
	.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>

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
	$(":checkbox").prop("checked", false); 
} 
function checkAll() 
{ 
	$(":checkbox").prop("checked", true); 
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
				html += ' <tr><td class="valign-middle"><label class="ckbox mg-b-0"><input type="checkbox" name="dbname" value="'+temp+'"><span></span></label></td><td class="hidden-xs-down">'+obj.name+'</td></tr>';
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

<body class="collapsed-menu email">
	<div class="br-mainpanel br-mainpanel-file" >
<form action="database_backup_submit.jsp" method="post"  name="form" >
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0"  id="database" >			
					<thead>
						<tr id="oTable_th">
							<th class="tx-12-force tx-mont tx-medium">
								
							</th>
							<th class="tx-12-force tx-mont tx-medium">数据库名</th>														
						</tr>
					</thead>                
					<tbody>
					</tbody>										   					
				</table>
				 <div id="tide_content_tfoot">
					      <label class="ckbox mg-b-0 mg-r-30 ">
						     <a onClick="checkAll()">全选</a>
			              </label>
                          <label class="ckbox mg-b-0 mg-r-30 ">
						     <a onClick="uncheckAll()">反选</a>
			              </label> 						  
				 </div>
			</div>
		</div>
        <div class="btn-box">
      	  <div class="modal-footer" >	
              <input type="hidden" name="Submit" value="Submit">    		    
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs"  id="startButton" onclick="return checkbox();">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		   </div> 
        </div>

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
	//===========================================
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
				}else{
					_tr.find(":checkbox").prop("checked", true);
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
			} else {
				checkboxAll.removeAttr("checked");
			}
			return;
		})
		$(".btn-search").click(function() {
			$(".search-box").toggle(100);
		})
	});
</script>
</form>
</div>
</body>

</html>