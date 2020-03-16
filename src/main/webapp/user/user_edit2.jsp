<%@ page import="java.sql.*,org.json.*,
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

Tree tree = new Tree();
JSONArray arr = tree.listChannel_json(userinfo_session);
int currUserId = userinfo_session.getId();

%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">	
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">	
<link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	html,body{width: 100%;height: 100%; background: #E9ECEF;}
	table{margin:0 auto;border: 1px solid #dee2e6;border-collapse: collapse;}
	table th{border: 1px solid #dee2e6;border-collapse: collapse;background: #e9ecef;}
	table td{border-bottom: 1px solid #dee2e6;border-collapse: collapse;}
	table th,table td{padding: 0.4rem;font-weight:bold ;}
	table label{margin-bottom: 0 !important;}

	ul,li{list-style: none;}
	.br-subleft{position: static !important;height: 100%;border: 1px solid #e9ecef; }
	
	.modal-body-btn .config-box .row .left-fn-title{min-width: 80px;text-align: left;}
	.modal-body .config-box label.ckbox{width: 90px;cursor: pointer;margin-right: 50px;}
	.table thead th{vertical-align: middle;}
	.table th{padding: 0.3rem 0.75rem ;}
	.table td{padding: 0.4rem 0.75rem ;}
	.channel-container,.power-containner{ border: 1px solid #e9ecef;}
	.channel-container ul li{justify-content: flex-start;align-items: center;
	background: #f2f2f2;border-bottom: 1px solid #ddd;cursor: pointer;}
	.channel-container ul li.active{background: #17A2B8;color: #fff;}
	.power-containner .row{margin: 0 !important;}
	.lh-30px {line-height: 1.5;padding: 7px 0;}

	.config-box1>ul>li.block {
		display: block !important;
	}

	.config-box1>ul>li {
		display: none !important;
	}
</style> 

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script type="text/javascript" src="../common/jquery.scrollTo-min.js"></script>

<script language="javascript">
var dir = "";

var systemtype = 0 ;
var ChannelArray = new Array();
var ChannelArray_cms = new Array();
var ChannelArray_vms = new Array();
var PermString = "<%=(new ChannelPrivilege()).getPermString(userinfo.getId())%>";//编辑用户频道权限
//初始化编辑用户权限（内容汇聚发布）
function init()
{
	//var ChannelList = document.getElementById("ChannelList");
	//alert(PermString);
	if(PermString=="")
		return;

	var arr = PermString.split(",");

	//10个一组，新增只看自己
	for(var i=0;i<arr.length;i+=10)
	{
		addTr(arr[i],arr[i+1],arr[i+7],0);

		var myObject = new Object();
		myObject.Perm1 = arr[i+2];
		myObject.Perm2 = arr[i+3];	
		myObject.Perm3 = arr[i+4];
		myObject.Perm4 = arr[i+5];	
		myObject.Perm5 = arr[i+6];
		myObject.Perm11 = arr[i+7];
		myObject.Perm12 = arr[i+8];
		myObject.ChannelID = arr[i+0];
		myObject.ChannelType = arr[i+9];
		ChannelArray[ChannelArray.length] = myObject;
	}
	//ChannelArray_cms = ChannelArray;
}
function addTr(id,name,type,system_type)
{
	var img = "<img src='../images/tree/16_channel_icon.png'>";
	if(type==2) img = "<img src='../images/tree/16_page_icon.png'>";

	var html = '<li class="d-flex lh-30px" id="tr_'+id+'"><i class="fa fa-square wd-30 tx-center"></i><span style="cursor:pointer" onClick="selectChannel('+id+')" class="wd-400">'+name+'</span><a href="javascript:delChannel('+id+');" class="a-delete"><i class="fa fa-times tx-danger tx-18 tx-center wd-30"></i></a></li>';
	
	if(system_type==1||systemtype == 1){
		$("#ChannelList_vms").append(html);
	}else{
		$("#ChannelList").append(html);
	}
	
}

//选择左侧频道
function setChannel(this_){
	var $this = $(this_).parent();

	var channelid = $this.attr("channelid");
	var channeltype = $this.attr("channeltype");

	var myObject = new Object();
	myObject.Name = $this.text();
	myObject.ChannelID = channelid;
	myObject.ChannelType = channeltype;
	addChannel2(myObject);
}
//同步右侧频道权限
function addChannel2(retu)
{  
	if(retu==null) return;
/*	if(document.getElementById("tr_"+retu.ChannelID))
	{
		$("#div_table").scrollTo($("#tr_"+retu.ChannelID),800);
		selectChannel(retu.ChannelID);
		return;
	}*/

	var ChannelList = "ChannelList";
	var perm = "PermList ";
	if(systemtype==1){
		ChannelList = "ChannelList_vms";
		perm = "PermList_vms ";
	}
	
	if($("#"+ChannelList+" #tr_"+retu.ChannelID).length>0){
		$("#div_table").scrollTo($("#"+ChannelList+" #tr_"+retu.ChannelID),800);
		selectChannel(retu.ChannelID);
		return;
	}

	//var ChannelList = document.getElementById(ChannelList);		
	var myObject = getObj(retu.ChannelID);
	if(myObject!=null) return;
	addTr(retu.ChannelID,retu.Name,retu.ChannelType);
	var myObject = new Object();
	myObject.ChannelID = retu.ChannelID;
	myObject.ChannelType = retu.ChannelType;

	if(document.form.Role.value==2)
	{
				myObject.Perm1 = 1;
				myObject.Perm2 = 1;	
				myObject.Perm3 = 1;
				myObject.Perm4 = 1;	
				myObject.Perm5 = 1;	
				myObject.Perm12 = 1;
	}
	else if(document.form.Role.value==3)
	{
				myObject.Perm1 = 0;
				myObject.Perm2 = 1;	
				myObject.Perm3 = 1;
				myObject.Perm4 = 1;	
				myObject.Perm5 = 1;	
				myObject.Perm12 = 1;
	}
	else if(document.form.Role.value == 4)
	{
				myObject.Perm1 = 0;
				myObject.Perm2 = 1;	
				myObject.Perm3 = 1;
				myObject.Perm4 = 0;	
				myObject.Perm5 = 0;	
				myObject.Perm12 = 1;
	}

	if(myObject.ChannelType==2)
	{
		myObject.Perm1 = 0;
		myObject.Perm2 = 0;	
		myObject.Perm3 = 0;
		myObject.Perm4 = 0;	
		myObject.Perm5 = 0;	
		myObject.Perm12 = 0;
	}
	myObject.Perm11 = 0;
	ChannelArray[ChannelArray.length] = myObject;
	CurrentChannelID = retu.ChannelID;
	if(document.form.Role.value==2)
	{
		$(perm+"#Perm1").prop("checked", true);
		$(perm+"#Perm6").prop("checked", true);
		$(perm+"#Perm2").prop("checked", true);
		$(perm+"#Perm3").prop("checked", true);
		$(perm+"#Perm4").prop("checked", true);
		$(perm+"#Perm5").prop("checked", true);
		$(perm+"#Perm12").prop("checked", true);
	}
	else if(document.form.Role.value==3)
	{
		$(perm+"#Perm1").prop("checked", false);
		$(perm+"#Perm6").prop("checked", true);
		$(perm+"#Perm2").prop("checked", true);
		$(perm+"#Perm3").prop("checked", true);
		$(perm+"#Perm4").prop("checked", true);
		$(perm+"#Perm5").prop("checked", true);
		$(perm+"#Perm12").prop("checked", true);
	}
	else if(document.form.Role.value==4)
	{
		$(perm+"#Perm1").prop("checked", false);
		$(perm+"#Perm2").prop("checked", true);
		$(perm+"#Perm3").prop("checked", true);
		$(perm+"#Perm4").prop("checked", false);
		$(perm+"#Perm5").prop("checked", false);
		$(perm+"#Perm12").prop("checked", true);
	}
	
	//is page
	if(myObject.ChannelType==2)
	{
		$(perm+"#Perm1").prop("checked", false);
		$(perm+"#Perm2").prop("checked", false);
		$(perm+"#Perm3").prop("checked", false);
		$(perm+"#Perm4").prop("checked", false);
		$(perm+"#Perm5").prop("checked", false);
		$(perm+"#Perm12").prop("checked", false);
	}
	$("#div_table").scrollTo($("#"+ChannelList+" #tr_"+retu.ChannelID),800);
	selectChannel(retu.ChannelID);
}

function selectChannel(channelid)
{
	var perm = "#PermList ";
	if(systemtype==1){
		$("#ChannelList_vms li").removeClass("active");
		$("#ChannelList_vms #tr_"+channelid).addClass("active");
		perm = "#PermList_vms ";
	}else{
		$("#ChannelList li").removeClass("active");
		$("#ChannelList #tr_"+channelid).addClass("active");
	}
	

	var myObject = getObj(channelid);
	if(myObject!=null)
	{
		if(myObject.ChannelType==2)
		{
			$(perm+"#perm001").hide();$(perm+"#perm003").show();$(perm+"#perm002").hide();

			if(myObject.Perm2==1)
				$(perm+"#Perm7").prop("checked", true);
			else
				$(perm+"#Perm7").prop("checked", false);
			if(myObject.Perm3==1)
				$(perm+"#Perm8").prop("checked", true);
			else
				$(perm+"#Perm8").prop("checked", false);
			if(myObject.Perm4==1)
				$(perm+"#Perm9").prop("checked", true);
			else
				$(perm+"#Perm9").prop("checked", false);
			if(myObject.Perm5==1)
				$(perm+"#Perm10").prop("checked", true);
			else
				$(perm+"#Perm10").prop("checked", false);
			if(myObject.Perm11==1)
				$(perm+"#Perm11").prop("checked", true);
			else
				$(perm+"#Perm11").prop("checked", false);
		}
		else
		{
			$(perm+"#perm001").show();$(perm+"#perm002").show();$(perm+"#perm003").hide();

			if(myObject.Perm1==1)
				$(perm+"#Perm1").prop("checked", true);
			else
				$(perm+"#Perm1").prop("checked", false);
			if(myObject.Perm2==1)
				$(perm+"#Perm2").prop("checked", true);
			else
				$(perm+"#Perm2").prop("checked", false);
			if(myObject.Perm3==1)
				$(perm+"#Perm3").prop("checked", true);
			else
				$(perm+"#Perm3").prop("checked", false);
			if(myObject.Perm4==1)
				$(perm+"#Perm4").prop("checked", true);
			else
				$(perm+"#Perm4").prop("checked", false);
			if(myObject.Perm5==1)
				$(perm+"#Perm5").prop("checked", true);
			else
				$(perm+"#Perm5").prop("checked", false);
			if(myObject.Perm12==1)
				$(perm+"#Perm12").prop("checked", true);
			else
				$(perm+"#Perm12").prop("checked", false);
			if(myObject.Perm11==1)
				$(perm+"#Perm11").prop("checked", true);
			else
				$(perm+"#Perm11").prop("checked", false);
		}

		CurrentChannelID = channelid;
	}
	else
	{
		PermList.style.display = "";
		var myObject = new Object();
		myObject.Perm1 = 0;
		myObject.Perm2 = 0;	
		myObject.Perm3 = 0;
		myObject.Perm4 = 0;	
		myObject.Perm5 = 0;
		myObject.Perm12 = 0;
		myObject.Perm11 = 0;
		myObject.ChannelID = channelid;
		ChannelArray[ChannelArray.length] = myObject;
		CurrentChannelID = channelid;
	}	
}

//设置权限
function setPerm(perm,permname)
{
	var permlist = "PermList ";
	if(systemtype==1){
		permlist = "PermList_vms ";
	}
	if(permname=="Perm6")
	{
		var obj = getObj(CurrentChannelID);
		if(obj!=null)
		{
			if(perm.checked)
			{
				//obj.Perm1 = 1;
				obj.Perm2 = 1;
				obj.Perm3 = 1;
				obj.Perm4 = 1;
				obj.Perm5 = 1;
				obj.Perm12 = 1;
				obj.Perm11 = 1;
				//$(perm+"#Perm1").prop("checked", true);
				$("#"+permlist+"#Perm2").prop("checked", true);
				$("#"+permlist+"#Perm3").prop("checked", true);
				$("#"+permlist+"#Perm4").prop("checked", true);
				$("#"+permlist+"#Perm5").prop("checked", true);
				$("#"+permlist+"#Perm12").prop("checked", true);
				$("#"+permlist+"#Perm11").prop("checked", true);
			}
		}
			return;
	}

	if(CurrentChannelID>0)
	{
		var obj = getObj(CurrentChannelID);
		if(obj!=null)
		{
			if(perm.checked)
			{
				if(permname=="Perm1")
					obj.Perm1 = 1;
				if(permname=="Perm2")
					obj.Perm2 = 1;
				if(permname=="Perm3")
					obj.Perm3 = 1;
				if(permname=="Perm4")
					obj.Perm4 = 1;
				if(permname=="Perm5")
					obj.Perm5 = 1;
				if(permname=="Perm12")
					obj.Perm12 = 1;
				if(permname=="Perm11")
					obj.Perm11 = 1;	
			}
			else
			{
				if(permname=="Perm1")
					obj.Perm1 = 0;
				if(permname=="Perm2")
					obj.Perm2 = 0;
				if(permname=="Perm3")
					obj.Perm3 = 0;
				if(permname=="Perm4")
					obj.Perm4 = 0;
				if(permname=="Perm5")
					obj.Perm5 = 0;
				if(permname=="Perm12")
					obj.Perm12 = 0;
				if(permname=="Perm11")
					obj.Perm11 = 0;	
			}
		}
	}
	//alert(perm.checked);
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

//删除频道权限
function delChannel(channelid)
{
	var perm = "PermList ";
	if(systemtype==1){
		perm = "PermList_vms ";
	}
	deleteObj(channelid);
	$("#tr_"+channelid).remove();
	$("#"+perm+"#perm001").hide();$("#"+perm+"#perm002").hide();$("#"+perm+"#perm003").hide();
}

function deleteObj(channelid)
{
	var ChannelArray1 = new Array();
	var j = 0;
	for(var i=0;i<ChannelArray.length; i++)
	{
		var myObject = ChannelArray[i];
		
		if(myObject.ChannelID!=channelid)
			ChannelArray1[j++]  = ChannelArray[i];
	}
	
	ChannelArray = ChannelArray1;

	return null;
}


function createChannelInfo(obj,system_type){
		var Channel_Array;
		if(systemtype==1){
			ChannelArray_vms = ChannelArray;
		}else{
			ChannelArray_cms = ChannelArray;
		}
		if(system_type == 1){
			Channel_Array = ChannelArray_vms;
		}else{
			Channel_Array = ChannelArray_cms;
		}
		var ChannelIDs = "";
		var curr_row;
		for (curr_row = 0; curr_row < obj.childElementCount; curr_row++)
		{
		  ChannelIDs += "," + obj.children[curr_row].id.replace("tr_","");
		}
		
		if(system_type == 0){
			document.form.ChannelList.value = ChannelIDs;
		}else{
			document.form.ChannelList_vms.value = ChannelIDs;
		}
		
		//alert(ChannelIDs);
		var PermList = "";
		for(var i=0;i<Channel_Array.length; i++)
		{
			var myObject = Channel_Array[i];
			PermList += "," + myObject.ChannelID;
			PermList += "," + myObject.Perm1;
			PermList += "," + myObject.Perm2;
			PermList += "," + myObject.Perm3;
			PermList += "," + myObject.Perm4;
			PermList += "," + myObject.Perm5;
			if(system_type == 0){
				PermList += "," + myObject.Perm11;
				PermList += "," + myObject.Perm12;
			}
		}
		if(system_type == 0){
			document.form.PermList.value = PermList;
		}else{
			document.form.PermList_vms.value = PermList;
		}
}

function check()
{
	var ChannelList = document.getElementById("ChannelList");
	var vmsChannelList = document.getElementById("ChannelList_vms");
	if(document.form.Role.value!=1 && document.form.Role.value!=5)
	{
		createChannelInfo(ChannelList,0);
		createChannelInfo(vmsChannelList,1);
	}

	$("#submitButton").attr("disabled",true);

	return true;
}

function cmsSave(){
	$.ajax({
		url:"perm_save.jsp",
		type:'POST',
		data:$('#form').serialize(),
		
		success:function(){
			top.TideDialogClose();
		}
	})
}

function vmsSave(){
	$.ajax({
		url:"/vms/user/perm_save.jsp?currUserId=<%=currUserId%>",
		type:'POST',
		data:$('#form').serialize(),
		success:function(){}
	})
}

/*
function addChannel()
{
	var ChannelList = document.getElementById("ChannelList");
	var myObject = new Object();
    myObject.title = "选择频道或分类";

 	var Feature = "dialogWidth:32em; dialogHeight:22em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=channel/select_channel_category.jsp",myObject,Feature);
	if(retu!=null)
	{
		//document.form.ChannelName.value = retu.Name;
		//document.form.ChannelID.value = retu.ChannelID;
		var curr_row;
		for (curr_row = 0; curr_row < ChannelList.rows.length; curr_row++)
		{
		  if(ChannelList.rows[curr_row].ChannelID==retu.ChannelID)
			{
			 return;
			}
		}
		var oRow = ChannelList.insertRow(-1);
		var oCell = oRow.insertCell(-1);
		oRow.ChannelID = retu.ChannelID;
		oRow.bind("click",selectChannel);
		//oRow.attachEvent ('onclick', selectChannel);
		oCell.innerHTML = retu.Name;
		
		var myObject = getObj(retu.ChannelID);
		if(myObject!=null)
		{		
		}
		else
		{
			PermList.style.display = "";
			var myObject = new Object();
			if(document.form.Role.value==2)
			{
				myObject.Perm1 = 1;
				myObject.Perm2 = 1;	
				myObject.Perm3 = 1;
				myObject.Perm4 = 1;	
				myObject.Perm5 = 1;
			}
			else if(document.form.Role.value==3)
			{
				myObject.Perm1 = 0;
				myObject.Perm2 = 1;	
				myObject.Perm3 = 1;
				myObject.Perm4 = 1;	
				myObject.Perm5 = 1;	
			}
			else if(document.form.Role.value == 4)
			{
				myObject.Perm1 = 0;
				myObject.Perm2 = 1;	
				myObject.Perm3 = 1;
				myObject.Perm4 = 0;	
				myObject.Perm5 = 0;	
			}
			myObject.Perm11 = 0;	
			myObject.ChannelID = retu.ChannelID;
			ChannelArray[ChannelArray.length] = myObject;
			//alert(ChannelArray.length);
			CurrentChannelID = retu.ChannelID;
			if(document.form.Role.value==2)
			{
				document.form.Perm1.checked = true;
				document.form.Perm6.checked = true;
				document.form.Perm2.checked = true;
				document.form.Perm3.checked = true;
				document.form.Perm4.checked = true;
				document.form.Perm5.checked = true;
			}
			else if(document.form.Role.value==3)
			{
				document.form.Perm1.checked = false;
				document.form.Perm6.checked = true;
				document.form.Perm2.checked = true;
				document.form.Perm3.checked = true;
				document.form.Perm4.checked = true;
				document.form.Perm5.checked = true;	
			}
			else if(document.form.Role.value==4)
			{
				document.form.Perm1.checked = false;
				document.form.Perm2.checked = true;
				document.form.Perm3.checked = true;
				document.form.Perm4.checked = false;
				document.form.Perm5.checked = false;	
			}												
		}
	}
}

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

function showTab(i)
{
	if(i==1)
	{
		document.getElementById("permission").style.display = "";
		document.getElementById("otherpermission").style.display = "none";
	}
	else if(i==2)
	{
		document.getElementById("permission").style.display = "none";
		document.getElementById("otherpermission").style.display = "";
	}
}
*/
</script>
</head>

<body class="collapsed-menu email" onLoad="init();">
<div class="bg-white modal-box">
<%if(userinfo.getRole()==3){//编辑角色%>
	<div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
		<ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
			<li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#" role="tab">内容汇聚发布</a></li>
			<li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">全媒体资源管理</a></li>
		</ul>
	</div>
	<form name="form" id="form" method="post" action="" onSubmit="return check();">
		<div class="modal-body pd-20 overflow-y-auto">
<%}else{%>
	<form name="form" id="form" method="post" action="" onSubmit="return check();">
		<div class="modal-body pd-20 overflow-y-auto" style="top: 0px;">
<%}%>


<%if(userinfo.getRole()==1 || userinfo.getRole()==4){%>		
		<div class="table-box">
		<table class="wd-90p-force">
			<thead>
				<tr>
					<th class="tx-center wd-50p-force"><b class="tx-black">权限</b></th>
					<th class="tx-center wd-50p-force"><b class="tx-black">设置</b></th>
				</tr>
			</thead>
			<tbody>
			<%if(userinfo.getCompany()==0){ %>
				<tr>
					<td class="tx-right pd-r-20">禁止修改配置文件</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableChangeConfig" name="DisableChangeConfig" value="1" <%=userinfo.hasPermission("DisableChangeConfig")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止修改发布方式</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableChangePublish" name="DisableChangePublish" value="1" <%=userinfo.hasPermission("DisableChangePublish")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护发布方案</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableAddPublishScheme" name="DisableAddPublishScheme" value="1" <%=userinfo.hasPermission("DisableAddPublishScheme")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
			<%}%>
				
				<tr>
					<td class="tx-right pd-r-20">禁止维护系统管理员用户</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableManageAdminUser" name="DisableManageAdminUser" value="1" <%=userinfo.hasPermission("DisableManageAdminUser")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护用户</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableManageUser" name="DisableManageUser" value="1" <%=userinfo.hasPermission("DisableManageUser")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
				<%if(userinfo.getCompany()==0){ %>
					<tr>
					<td class="tx-right pd-r-20">禁止删除频道</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableDeleteChannel" name="DisableDeleteChannel" value="1" <%=userinfo.hasPermission("DisableDeleteChannel")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护文件管理</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="ManageFile" name="ManageFile" value="1" <%=!userinfo.hasPermission("ManageFile")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护结构管理</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="ManageChannel" name="ManageChannel" value="1" <%=!userinfo.hasPermission("ManageChannel")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护系统管理</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="ManageSystem" name="ManageSystem" value="1" <%=!userinfo.hasPermission("ManageSystem")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止访问运营管理</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="OperateSystem" name="OperateSystem" value="1" <%=!userinfo.hasPermission("OperateSystem")?"checked":""%>><span> </span>
						</label>									
					</td>
				</tr>
				<%}%>
				
			</tbody>
		</table>
		</div>
<%}else if(userinfo.getRole()==5){%>		
		<div id="vblog">
		<div class="table-box">
		<table class="wd-90p-force">
			<tr>
				<td class="tx-right pd-r-20"></td>
				<td class="tx-left pd-l-20">								
					<label class="ckbox mg-r-20">
						<input type="checkbox" name="EnableVblogPreApprove" value="1" <%=userinfo.hasPermission("EnableVblogPreApprove")?"checked":""%>><span> 预审通过</span>
					</label>									
				</td>
			</tr>
			<tr>
				<td class="tx-right pd-r-20"></td>
				<td class="tx-left pd-l-20">								
					<label class="ckbox mg-r-20">
						<input type="checkbox" name="EnableVblogApprove" value="1" <%=userinfo.hasPermission("EnableVblogApprove")?"checked":""%>><span> 审核通过</span>
					</label>									
				</td>
			</tr>
			<tr>
				<td class="tx-right pd-r-20"></td>
				<td class="tx-left pd-l-20">								
					<label class="ckbox mg-r-20">
						<input type="checkbox" name="EnableVblogPigeonhole" value="1" <%=userinfo.hasPermission("EnableVblogPigeonhole")?"checked":""%>><span> 视频归档</span>
					</label>									
				</td>
			</tr>
		</table>
		</div>
		</div>
<%}else{%>
<div class="config-box1">
   <ul>
	 <!--基本信息-->
	 <li class="block">

		<div class="d-flex ht-100p-force justify-content-between">
			<div class="br-subleft br-subleft-file">
				<div class="sidebar-menu-box ht-100p-force overflow-auto">
					<ul class="sidebar-menu sidebar-menu-cms mg-t-0-force" hid>	  
					</ul>
				</div>
			</div><!-- br-subleft -->
			<div class="right-box wd-500">
				<div class="top-channel">
					<div class="block-title mg-t-5 lh-30px"><b>频道或分类名称</b></div>
					<div class="channel-container ht-300 overflow-y-auto" id="div_table">
						<ul class="pd-15 ChannelList" id="ChannelList">
						</ul>
					</div>
				</div>
				<div class="bot-power">
					<div class="block-title mg-t-20 lh-30 lh-30px"><b>权限</b></div>
					<div class="power-containner ht-90 pd-15" id="PermList">
						<div class="row ckbox-row" id="perm001" style="display:none">                  		  	  	   		  	  		  
							<label class="ckbox mg-r-20">
								<input name="Perm6" type="checkbox" id="Perm6" value="1" onClick="setPerm(this,'Perm6');"><span>全部权限</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm1" type="checkbox" id="Perm1" value="1" onClick="setPerm(this,'Perm1');"><span>包括子频道</span>
							</label>	
						</div>
						<div class="row ckbox-row" id="perm002" style="display:none">  
							<label class="ckbox mg-r-20">
								<input name="Perm2" type="checkbox" id="Perm2" value="1" onClick="setPerm(this,'Perm2');"><span>浏览文档</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm12" type="checkbox" id="Perm12" value="1" onClick="setPerm(this,'Perm12');"><span>只看自己</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm3" type="checkbox" id="Perm3" value="1"  onClick="setPerm(this,'Perm3');"><span>新建文档</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm4" type="checkbox" id="Perm4" value="1"  onClick="setPerm(this,'Perm4');"><span>发布文档</span>
							</label>	
							<label class="ckbox mg-r-20">
								<input name="Perm5" type="checkbox" id="Perm5" value="1"  onClick="setPerm(this,'Perm5');"><span>删除文档</span>
							</label>		
							<label class="ckbox mg-r-20">
								<input name="Perm11" type="checkbox" id="Perm11" value="1"  onClick="setPerm(this,'Perm11');"><span>创建分类</span>
							</label>							
						</div>
						<div class="row ckbox-row" id="perm003" style="display:none">  
							<label class="ckbox mg-r-20">
								<input name="Perm7" type="checkbox" id="Perm7" value="1" onClick="setPerm(this,'Perm2');"><span>内容维护</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm8" type="checkbox" id="Perm8" value="1" onClick="setPerm(this,'Perm3');"><span>模块维护</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm9" type="checkbox" id="Perm9" value="1"  onClick="setPerm(this,'Perm4');"><span>框架维护</span>
							</label>	
							<label class="ckbox mg-r-20">
								<input name="Perm10" type="checkbox" id="Perm10" value="1" onClick="setPerm(this,'Perm5');"><span>源代码&属性</span>
							</label>						          	           
						</div>
					</div>
				</div>
			</div>
		</div>
	  </li>

	  <li class="" id="vms">
		<div class="d-flex ht-100p-force justify-content-between">
			<div class="br-subleft br-subleft-file">
				<div class="sidebar-menu-box ht-100p-force overflow-auto">
					<ul class="mg-t-0-force sidebar-menu sidebar-menu-vms" hid>
					</ul>
				</div>
			</div><!-- br-subleft -->
			<div class="right-box wd-500">
				<div class="top-channel">
					<div class="block-title mg-t-5 lh-30px"><b>频道或分类名称</b></div>
					<div class="channel-container ht-300 overflow-y-auto" id="div_table">
						<ul class="pd-15 ChannelList" id="ChannelList_vms">
						</ul>
					</div>
				</div>
				<div class="bot-power">
					<div class="block-title mg-t-20 lh-30 lh-30px"><b>权限</b></div>
					<div class="power-containner ht-90 pd-15" id="PermList_vms">
						<div class="row ckbox-row" id="perm001" style="display:none">                  		  	  	   		  	  		  
							<label class="ckbox mg-r-20">
								<input name="Perm6" type="checkbox" id="Perm6" value="1" onClick="setPerm(this,'Perm6');"><span>全部权限</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm1" type="checkbox" id="Perm1" value="1" onClick="setPerm(this,'Perm1');"><span>包括子频道</span>
							</label>	
						</div>
						<div class="row ckbox-row" id="perm002" style="display:none">  
							<label class="ckbox mg-r-20">
								<input name="Perm2" type="checkbox" id="Perm2" value="1" onClick="setPerm(this,'Perm2');"><span>浏览文档</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm12" type="checkbox" id="Perm12" value="1" onClick="setPerm(this,'Perm12');"><span>只看自己</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm3" type="checkbox" id="Perm3" value="1"  onClick="setPerm(this,'Perm3');"><span>新建文档</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm4" type="checkbox" id="Perm4" value="1"  onClick="setPerm(this,'Perm4');"><span>发布文档</span>
							</label>	
							<label class="ckbox mg-r-20">
								<input name="Perm5" type="checkbox" id="Perm5" value="1"  onClick="setPerm(this,'Perm5');"><span>删除文档</span>
							</label>									
						</div>
						<div class="row ckbox-row" id="perm003" style="display:none">  
							<label class="ckbox mg-r-20">
								<input name="Perm7" type="checkbox" id="Perm7" value="1" onClick="setPerm(this,'Perm2');"><span>内容维护</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm8" type="checkbox" id="Perm8" value="1" onClick="setPerm(this,'Perm3');"><span>模块维护</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm9" type="checkbox" id="Perm9" value="1"  onClick="setPerm(this,'Perm4');"><span>框架维护</span>
							</label>	
							<label class="ckbox mg-r-20">
								<input name="Perm10" type="checkbox" id="Perm10" value="1" onClick="setPerm(this,'Perm5');"><span>源代码&属性</span>
							</label>						          	           
						</div>
					</div>
				</div>
			</div>
		</div>
	  </li>

	</ul>
</div>
<%}%>
		<div id="otherpermission" style="display:none;">
			<table class="wd-90p-force" > 
				<tr>
					<td class="tx-right pd-r-20"></td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" name="EnableAddSpecialChannel" value="1" <%=userinfo.hasPermission("EnableAddSpecialChannel")?"checked":""%>><span> 建立专题</span>
						</label>									
					</td>
				</tr>     
			</table>
		</div>
	</div><!-- modal-body -->

	<div class="btn-box">
      	<div class="modal-footer" >
			<input type="hidden" name="Submit" value="Submit">
            <input type="hidden" name="id" value="<%=id%>">
			<input type="hidden" name="ChannelList" value="">
			<input type="hidden" name="PermList" value="">
			<input type="hidden" name="ChannelList_vms" value="">
			<input type="hidden" name="PermList_vms" value="">
			<input type="hidden" name="Role" value="<%=userinfo.getRole()%>">
		    <button id="submitButton" name="submitButton" type="button" onclick="check();cmsSave();vmsSave()" class="btn btn-primary tx-size-xs">确认</button>
		    <button id="btnCancel1" name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		</div> 
    </div>
 </form>                      
</div>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/sidebar-menu-channel.js"></script>

<script>

	$(function(){
		$('.br-mailbox-list,.br-subleft').perfectScrollbar();	
					
		var menu = $('.sidebar-menu-cms');
		var json = <%=arr%>;

		var html = '<li class="treeview"><a href="#" load="0" channelId="0"><i class="fa fisrtNav fa-home" have="1"></i> <span>站点</span></a><ul class="treeview-menu" style="display: block;">';

		for(var i=0;i<json.length;i++){

			html += '<li><a href="#" load="'+json[i].load+'" channelId="'+json[i].id+'" channeltype="'+json[i].type+'">'
			if(json[i].load==1||(json[i].child && json[i].child.length>0)){
				html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
			}else{
				html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
			} 
			html +='<span onclick="setChannel(this);">'+json[i].name+'</span></a>';

			if(json[i].child && json[i].child.length>0){
				html += '<ul class="treeview-menu">' + get_menu_html(json[i],0) + '</ul>';
			}
			html += '</li>';
		}

		html += '</ul></li>';

		menu.append(html);

		//多级导航自定义
		$.sidebarMenu(menu);
	});

	function get_menu_html(json)
	{
		var html = "";
		if(json.child && json.child.length>0)
		{
			var json_ = json.child;
			for(var i=0;i<json_.length;i++){
				html += '<li><a href="#" load="'+json_[i].load+'" channelId="'+json_[i].id+'" channeltype="'+json_[i].type+'">'
				if(json_[i].load==1||(json_[i].child && json_[i].child.length>0)){
					html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
				}else{
					html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
				} 
				html +='<span onclick="setChannel(this);">'+json_[i].name+'</span></a>';

				if(json_[i].child && json_[i].child.length>0){
					html += '<ul class="treeview-menu">' + get_menu_html(json_[i]) + '</ul>';
				}
				html += '</li>';
			}
		}
		return html;
	 }
//========================================================================
	$.sidebarMenu = function(menu) {
		var animationSpeed = 300;
	  
		$(menu).on('click', 'li a', function(e) {
			var $this = $(this);
			var checkElement = $this.next();

			var load = $this.attr("load");
			var channelid = $this.attr("channelid");
			var channeltype = $this.attr("channeltype");	

			if(load==1) 
			{	
				$this.attr("load",0);//加载完毕改变load属性

				var url="../lib/channel_json.jsp?ChannelID="+channelid;
				if(systemtype==1){
					url = "/vms/index_tcenter.jsp?url=/vms/lib/channel_json.jsp?ChannelID="+channelid;
				}
				$.ajax({
					type:"GET",
					dataType:"json",
					url:url,
					success: function(json){
					var html = '<ul class="treeview-menu">';

					for(var i=0;i<json.length;i++){
						if(json[i].child && json[i].child.length>0)
						{
							html += '<li class="treeview">';
						}
						else
						{
							html += '<li>';
						}
						html += '<a href="#" load="'+json[i].load+'" channelid="'+json[i].id+'" channeltype="'+json[i].type+'">';

						if(json[i].load==1||(json[i].child && json[i].child.length>0)){
							html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
						}else{
							html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
						}
						html += '<span onclick="setChannel(this);">'+json[i].name+'</span></a>';

						if(json[i].child && json[i].child.length>0)
						{
							html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
						}
						html += '</li>';
					}
					html += '</ul>';
					$(".nav-loading").remove();
					$this.after($(html));
					
					checkElement = $this.next();
					sidebarMenu_show(checkElement,animationSpeed,$this);
				}});
			
			}
			else
			{
				sidebarMenu_show(checkElement,animationSpeed,$this);
			}
			
		});
	}	
//=====================================================================
//切换频道树
$(function(){

	$("#form_nav li").click(function(){
		var _index = $(this).index();
		$(".config-box1>ul>li").removeClass("block").eq(_index).addClass("block");
		if(_index == 0){
			ChannelArray_vms = ChannelArray ;
			ChannelArray = ChannelArray_cms ;
			systemtype = 0 ;
			if($("#ChannelList .active").length>0){
				CurrentChannelID = $("#ChannelList .active").attr("id").replace("tr_","");
			}
		}else{
			ChannelArray_cms = ChannelArray ;
			ChannelArray = ChannelArray_vms ;
			systemtype = 1 ;
			if($("#ChannelList_vms .active").length>0){
				CurrentChannelID = $("#ChannelList_vms .active").attr("id").replace("tr_","");
			}
		}
	});
				
	var menu = $('.sidebar-menu-vms');
	var json = [];
	var vmsPermString = '';
	$.ajax({
		url:'/vms/user/perm_tocms.jsp',
		data:{"type":1,"idFc":<%=id%>,"currUserId":<%=currUserId%>},
		async:false,
		dataType:'json',
		success:function(data){
			json = data.arr;
			console.log(json);
			vmsPermString = data.permString;
		}
	});
	var html = '<li class="treeview"><a href="#" load="0" channelId="0"><i class="fa fisrtNav fa-home" have="1"></i> <span>站点</span></a><ul class="treeview-menu" style="display: block;">';

	for(var i=0;i<json.length;i++){

		html += '<li><a href="#" load="'+json[i].load+'" channelId="'+json[i].id+'" channeltype="'+json[i].type+'">'
		if(json[i].load==1||(json[i].child && json[i].child.length>0)){
			html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
		}else{
			html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
		} 
		html +='<span onclick="setChannel(this);">'+json[i].name+'</span></a>';

		if(json[i].child && json[i].child.length>0){
			html += '<ul class="treeview-menu">' + get_menu_html(json[i],1) + '</ul>';
		}
		html += '</li>';
	}

	html += '</ul></li>';
	menu.append(html);

	//多级导航自定义
	$.sidebarMenu(menu);


	//=========================================
	if(vmsPermString!=""){
		var arr = vmsPermString.split(",");
		//8个一组
		for(var i=0;i<arr.length;i+=8)
		{
			addTr(arr[i],arr[i+1],arr[i+7],1,1);

			var myObject = new Object();
			myObject.Perm1 = arr[i+2];
			myObject.Perm2 = arr[i+3];
			myObject.Perm3 = arr[i+4];
			myObject.Perm4 = arr[i+5];
			myObject.Perm5 = arr[i+6];
			myObject.ChannelID = arr[i+0];
			myObject.ChannelType = arr[i+7];
			ChannelArray_vms[ChannelArray_vms.length] = myObject;
		}
	}
});

</script>

</body>
</html>
