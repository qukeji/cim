<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");
int GroupID = getIntParameter(request,"GroupID");

if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");
	UserInfo userinfo = new UserInfo(id);

	if(userinfo.getRole()==1)
	{
		if(!(new UserPerm().canManageAdminUser(userinfo_session)))
		{response.sendRedirect("../noperm.jsp");return;}
	}
	//userinfo.setMessageType();
	userinfo.setActionUser(userinfo_session.getId());
	userinfo.Delete(id);

	out.println("success");return;
}
String parentChannelPath ="";
if(GroupID==-1){
	parentChannelPath="系统管理 / 所有用户 ";
}else if(GroupID==4){
	parentChannelPath="系统管理 / Tide ";
}else if(GroupID==5){
	parentChannelPath="系统管理 / api ";
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

<script>

var myObject = new Object();
	myObject.title = "";
    myObject.GroupID = "<%=GroupID%>";
	 

function addUser()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(600);
	dialog.setUrl("user_add2018.jsp?GroupID="+myObject.GroupID);
	dialog.setTitle("新建用户");
	dialog.show();
}

function editUser(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(600);
	dialog.setUrl("user_edit2018.jsp?id=" + id);
	dialog.setTitle("编辑用户");
	dialog.show();
}

function showUser(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(560);
	dialog.setHeight(480);
	dialog.setUrl("user_detail.jsp?id=" + id);
	dialog.setTitle("用户信息");
	dialog.show();
}

function setPerm(id,role)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(800);
	dialog.setHeight(650);

	if(role==1)
	{
		dialog.setWidth(550);
		dialog.setHeight(480);
	}
	else if(role==5)
	{
		dialog.setWidth(340);
		dialog.setHeight(280);
	}
	dialog.setUrl("user_edit22018.jsp?id=" + id);
	dialog.setTitle("设置权限");
	dialog.show();
}

function fresh(id)
{
    myObject.title = "编辑用户";
	var Feature = "dialogWidth:40em; dialogHeight:28em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=test/user_test.jsp&id=" + id,myObject,Feature);
}

function user_enable(id,flag)
{
	
	var	dialog = new top.TideDialog();
	dialog.setWidth(320);
	dialog.setHeight(240);
	dialog.setUrl("user_enable2018.jsp?id=" + id +"&flag=" + flag);
	dialog.setTitle("权限设置");
	dialog.show();
		
/*	
var msg = "确实要";
	var src = "";
	if(flag==1)
	{
		msg += "允许";

		src = '<button class="btn btn-info btn-sm mg-r-8 tx-13" onclick="user_enable('+id+',2);">禁止用户登录</button>';
	}
	else if(flag==2)
	{
		msg += "禁止";
		src = '<button class="btn btn-info btn-sm mg-r-8 tx-13" onclick="user_enable('+id+',1);">允许用户登录</button>';
	}
	else return;
	msg += "该用户登录吗?";

	if(confirm(msg))
	{
		var url="user_enable.jsp?id="+id+"&flag="+flag;
		$.ajax({type: "GET",url: url,success: function(msg){
			if(msg.indexOf("success")!=-1)
			{
				$("#jTip"+id+"_id td:last button:last").replaceWith(src);
			}
			else
			{
				tidecms.showmessage("操作失败.");
			}
			
			//document.location.href=document.location.href;
		}});
	}
      */	
}

function user_delete(id,name)
{
	

	var url="user_del2018.jsp?id="+id+"&name="+name;
	var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(260);
		dialog.setUrl(url);
		dialog.setTitle("删除用户");
		dialog.show();
	
  /* var msg = "你确认要删除用户："+name+" 吗?";
	if(confirm(msg))
	{
		var url="user_list.jsp?Action=Del&id="+id;
		$.ajax({type: "GET",url: url,success: function(msg){
			if(msg.indexOf("success")!=-1)
			{
				$("#jTip"+id+"_id").remove();
			}
			else
			{
				tidecms.showmessage("删除失败.");
			}
		}});
	}
	*/
}

/* 
$(document).ready(function() {
	$("#oTable").tablesorter({headers: { 0: { sorter: false}}});
});
*/
</script>
</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
	
	<div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active"><%=parentChannelPath%></span>
        </nav>
    </div><!-- br-pageheader -->
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
                 <div class="btn-group hidden-xs-down mg-l-auto">
                    <a href="javascript:addUser();" class="btn btn-outline-info" >新建</a>
                  </div>
                               
    </div>
	<!--列表-->
	 <div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>
					<th class="wd-5p">
					 编号
					</th>
					<th class="tx-12-force tx-mont tx-medium">角色</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">姓名</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">电子邮件</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">最近登录时间</th>
					<th class="tx-12-force wd-300 tx-mont tx-medium hidden-xs-down">操作</th>
				  </tr>
				</thead>
				<tbody>
<%

TableUtil tu_user = new TableUtil("user");
String ListSql = "select id,Role,company,Status,LastLoginDate,Name,Email,Username,UNIX_TIMESTAMP(ExpireDate) as ExpireDate from userinfo";
String CountSql = "select count(*) from userinfo";

if(GroupID==0)
{
	ListSql += " where GroupID=0 or GroupID is null order by Role,id";
	CountSql += " where GroupID=0 or GroupID is null";
}
else if(GroupID==-1)
{
	ListSql += " order by Role,id";
	CountSql += "";
}
else
{
	ListSql += " where GroupID=" + GroupID + " order by Role,id";
	CountSql += " where GroupID=" + GroupID;
}

long nowdate = System.currentTimeMillis()/1000;
	
ResultSet Rs = tu_user.List(ListSql,CountSql,1,1000);

if(tu_user.pagecontrol.getRowsCount()>0){

	int j=0;

	while(Rs.next()){

		String Username = convertNull(Rs.getString("Username"));
		String Name = convertNull(Rs.getString("Name"));
		String Email = convertNull(Rs.getString("Email"));
		String loginDate = convertNull(Rs.getString("LastLoginDate")).replace(".0","");
		int Status = Rs.getInt("Status");
		int Role = Rs.getInt("Role");
		int id = Rs.getInt("id");
		int ExpireDate = Rs.getInt("ExpireDate");
		int company = Rs.getInt("company");

		String RoleName = "";

		if(Role==1){
			RoleName = "系统管理员";
			if(company!=0){
				RoleName = "租户管理员";
			}
		}else if(Role==2)
			RoleName = "频道管理员";
		else if(Role==3)
			RoleName = "编辑";
		else if(Role==4)
			RoleName = "站点管理员";
		else if(Role==5)
			RoleName = "视客管理员";
		j++;
%>
		<tr id="jTip<%=id%>_id">
			<td class="hidden-xs-down"><%=j%></td>
			<td class="hidden-xs-down"><%=RoleName%></td>
			<td class="hidden-xs-down"><a href="javascript:showUser(<%=id%>);" style="color: #868ba1;"><%=Name%></a></td>
			<td class="hidden-xs-down"><%=Email%></td>
			<td class="hidden-xs-down"><%=loginDate%></td>
			<td class="dropdown hidden-xs-down">
				<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="editUser(<%=id%>);">编辑</button>
				<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="setPerm(<%=id%>,<%=Role%>);">权限</button>
				<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="user_delete(<%=id%>,'<%=Name%>');">删除</button>
				<%if(Status==1){%>
					<button class="btn btn-info btn-sm mg-r-8 tx-13" onclick="user_enable(<%=id%>,2);">禁止用户登录</button>
				<%}else if(Status==0){%>
					<button class="btn btn-info btn-sm mg-r-8 tx-13" onclick="user_enable(<%=id%>,1);">允许用户登录</button>
				<%}%>
				<%if(ExpireDate>0 && nowdate>ExpireDate){%>
					<!-- <img src="../images/icon/01.png">  -->
				<%}%>
			</td>
		</tr>
<%  }
	tu_user.closeRs(Rs);
}

%>
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
        
    
		$("#content-table tr:gt(0)").click(function () {     
			if ($(this).find(":checkbox").prop("checked"))// 此处要用prop不能用attr，至于为什么你测试一下就知道了。    
			{    
				$(this).find(":checkbox").removeAttr("checked");    
			}else{    
				$(this).find(":checkbox").prop("checked", true);    
			}     
		}); 
		$("#checkAll,#checkAll_1").click(function(){
			var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
			var existChecked = false ;
			for (var i=0;i<checkboxAll.length;i++) {
				if(!checkboxAll.eq(i).prop("checked")){
					existChecked = true ;
				}
			}
			if(existChecked){
				checkboxAll.prop("checked",true);
			}else{
				checkboxAll.removeAttr("checked");
			}
			return;
		})
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
