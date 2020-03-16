<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

UserInfo userinfo = new UserInfo(id);

if(userinfo.getRole()==1)
{
	if(!(new UserPerm().canManageAdminUser(userinfo_session)))
	{response.sendRedirect("../noperm.jsp");return;}
}

String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{
//	String			=	getParameter(request,"");
	String	Name		=	getParameter(request,"Name");
	String	Password	=	getParameter(request,"Password");
	String	Email		=	getParameter(request,"Email");
	String	Tel			=	getParameter(request,"Tel");
	String	Comment		=	getParameter(request,"Comment");

	int DisableChangeConfig			= getIntParameter(request,"DisableChangeConfig");
	int DisableChangePublish		= getIntParameter(request,"DisableChangePublish");
	int DisableAddPublishScheme		= getIntParameter(request,"DisableAddPublishScheme");
	int DisableEditPublishScheme	= getIntParameter(request,"DisableEditPublishScheme");
	int DisableManageAdminUser		= getIntParameter(request,"DisableManageAdminUser");
	int DisableManageUser			= getIntParameter(request,"DisableManageUser");

//	u.set();
	userinfo.setName(Name);
	userinfo.setPassword(Password);
	userinfo.setEmail(Email);
	userinfo.setTel(Tel);
	userinfo.setComment(Comment);

	userinfo.addPermArray("DisableChangeConfig",DisableChangeConfig);
	userinfo.addPermArray("DisableChangePublish",DisableChangePublish);
	userinfo.addPermArray("DisableAddPublishScheme",DisableAddPublishScheme);
	userinfo.addPermArray("DisableEditPublishScheme",DisableEditPublishScheme);
	userinfo.addPermArray("DisableManageAdminUser",DisableManageAdminUser);
	userinfo.addPermArray("DisableManageUser",DisableManageUser);

	userinfo.setMessageType(2);
	userinfo.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="/cms2018/favicon.ico">
<!-- Meta -->
<meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
<meta name="author" content="ThemePixels">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">   
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<!-- Bracket CSS -->
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<style>
html,body{
	width: 100%;
	height: 100%;
}
.modal-body.pd-20.overflow-y-auto {
    top: 30px !important;
}

</style>

<script type="text/javascript" src="../common/common.js"></script>
<script src="../lib/2018/jquery/jquery.js"></script>	
<script language="javascript">
	function isEmpty(field,msg)
	{	
		if(field.value == "")
		{
			alert(msg);
			field.focus();
			return true;
		}
		return false;
	}

	function show(i)
	{
		if(i==0)
		{
			info.style.display="";
			permission.style.display = "none";
		}

		if(i==1)
		{
			info.style.display="none";
			permission.style.display = "";
		}
	}

	function selectChannel()
	{
		var oSource = window.event.srcElement ;
		if(oSource.tagName=="TD")
			oSource = oSource.parentElement;
		//alert(oSource.ChannelID);
			var curr_row;
			for (curr_row = 0; curr_row < ChannelList.rows.length; curr_row++)
			{
			  ChannelList.rows[curr_row].bgColor = "#F5F5F5";
			}

			oSource.bgColor = "#999999";
			var myObject = getObj(oSource.ChannelID);
			if(myObject!=null)
			{//alert(myObject);
				PermList.style.display = "";
				if(myObject.Perm1==1)
					document.form.Perm1.checked = true;
				else
					document.form.Perm1.checked = false;
				if(myObject.Perm2==1)
					document.form.Perm2.checked = true;
				else
					document.form.Perm2.checked = false;
				if(myObject.Perm3==1)
					document.form.Perm3.checked = true;
				else
					document.form.Perm3.checked = false;
				if(myObject.Perm4==1)
					document.form.Perm4.checked = true;
				else
					document.form.Perm4.checked = false;
				if(myObject.Perm5==1)
					document.form.Perm5.checked = true;
				else
					document.form.Perm5.checked = false;

				CurrentChannelID = oSource.ChannelID;
			}
			else
			{
				PermList.style.display = "";
				myObject = new Object();
				myObject.Perm1 = 0;
				myObject.Perm2 = 0;	
				myObject.Perm3 = 0;
				myObject.Perm4 = 0;	
				myObject.Perm5 = 0;	
				myObject.ChannelID = oSource.ChannelID;
				ChannelArray[ChannelArray.length] = myObject;
				CurrentChannelID = oSource.ChannelID;
			}	
	}

	function getObj(channelid)
	{
		for(var i=0;i<ChannelArray.length; i++)
		{
			var myObject = ChannelArray[i];
			
			if(myObject.ChannelID==channelid)
				return ChannelArray[i];
		}
		
		return null;
	}

	var ChannelArray = new Array();

	var PermString = "<%=(new ChannelPrivilege()).getPermString(userinfo.getId())%>";

	function init()
	{
		//alert(PermString);
		if(PermString=="")
			return;

		var arr = PermString.split(",");

		for(var i=0;i<arr.length;i+=7)
		{
			var oRow = ChannelList.insertRow();
			var oCell = oRow.insertCell();
			oRow.ChannelID = arr[i+0];
			oRow.attachEvent ('onclick', selectChannel);
			oCell.innerHTML = arr[i+1];

			myObject = new Object();
			myObject.Perm1 = arr[i+2];
			myObject.Perm2 = arr[i+3];	
			myObject.Perm3 = arr[i+4];
			myObject.Perm4 = arr[i+5];	
			myObject.Perm5 = arr[i+6];	
			myObject.ChannelID = arr[i+0];
			ChannelArray[ChannelArray.length] = myObject;
		}
	}

	function showTab(form,form_td){
		var num =2;
		for(i=1;i<=num;i++)
		{
			jQuery("#form"+i).hide();
			jQuery("#form"+i+"_td").removeClass("cur");
		}
		
		jQuery("#"+form).show();
		jQuery("#"+form_td).addClass("cur");
	}
</script>
</head>

<body  onload="init();">
<div class="bg-white modal-box">

	<div class="ht-30 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
		<ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
			<li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#" role="tab" id="form1_td">基本信息</a></li>
			<li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab" id="form2_td">权限</a></li>
		</ul>
	</div>

	<form name="form" method="post" action="user_edit.jsp" onSubmit="return check();">
		<div class="modal-body pd-20 overflow-y-auto">
	        <div class="config-box">
				<ul>
	       	  		<li class="block"><!--基本信息-->
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">登录名：</label>
							<label class=""><%=userinfo.getUsername()%></label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">姓名：</label>
							<label class=""><%=userinfo.getName()%></label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">电子邮件：</label>
							<label class=""><%=userinfo.getEmail()%></label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">电话：</label>
							<label class=""><%=userinfo.getTel()%></label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">备注：</label>
							<label class=""><%=userinfo.getComment()%></label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">命令：</label>
							<label class=""><%=userinfo.getToken()%></label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">角色：</label>
							<label class=""><%=userinfo.getRoleName()%></label>									            
						</div>
					</li>
					<li><!--权限-->
					<%if(userinfo.getRole()==1){%>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">禁止修改配置文件：</label>
							<label class="ckbox">
								<input type="checkbox" name="DisableChangeConfig" value="1" <%=userinfo.hasPermission("DisableChangeConfig")?"checked":""%>>
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">禁止修改发布方式：</label>
							<label class="ckbox">
								<input type="checkbox" name="DisableChangePublish" value="1" <%=userinfo.hasPermission("DisableChangePublish")?"checked":""%>>
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">禁止添加发布方案：</label>
							<label class="ckbox">
								<input type="checkbox" name="DisableAddPublishScheme" value="1" <%=userinfo.hasPermission("DisableAddPublishScheme")?"checked":""%>>
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">禁止修改发布方案：</label>
							<label class="ckbox">
								<input type="checkbox" name="DisableEditPublishScheme" value="1" <%=userinfo.hasPermission("DisableEditPublishScheme")?"checked":""%>>
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">禁止维护系统管理员用户：</label>
							<label class="ckbox">
								<input type="checkbox" name="DisableManageAdminUser" value="1" <%=userinfo.hasPermission("DisableManageAdminUser")?"checked":""%>>
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">禁止维护用户：</label>
							<label class="ckbox">
								<input type="checkbox" name="DisableManageUser" value="1" <%=userinfo.hasPermission("DisableManageUser")?"checked":""%>>
								<span></span>
							</label>								            
						</div>
					<%}else{%>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">频道或分类名称</label>
							<label class="ckbox">权限</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">包括子频道：</label>
							<label class="ckbox">
								<input type="checkbox" name="Perm1" value="1" id="Perm1">
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">浏览文档：</label>
							<label class="ckbox">
								<input type="checkbox" name="Perm2" value="1" id="Perm2">
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">发表文档：</label>
							<label class="ckbox">
								<input type="checkbox" name="Perm3" value="1" id="Perm3">
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">审批文档：</label>
							<label class="ckbox">
								<input type="checkbox" name="Perm3" value="1" id="Perm3">
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">发表文档：</label>
							<label class="ckbox">
								<input type="checkbox" name="Perm4" value="1" id="Perm4">
								<span></span>
							</label>								            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title wd-200">删除文档：</label>
							<label class="ckbox">
								<input type="checkbox" name="Perm5" value="1" id="Perm5">
								<span></span>
							</label>								            
						</div>
					<%}%>
					</li>
				</ul>
	        </div>
		</div><!-- modal-body -->

		<div class="btn-box" >
      		<div class="modal-footer" >
				<input type="hidden" name="Submit" value="Submit">
				<input type="hidden" name="id" value="<%=id%>">
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-primary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
			</div> 
		</div>

		<div id="ajax_script" style="display:none;"></div>
	</form>
</div>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script>
	$(function(){
      	$("#form_nav li").click(function(){
      		var _index = $(this).index();
      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
      	})
	});
</script>
</body>
</html>