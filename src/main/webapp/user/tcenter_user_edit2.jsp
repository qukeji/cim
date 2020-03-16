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

String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{
//	String			=	getParameter(request,"");

	int DisableChangeConfig			= getIntParameter(request,"DisableChangeConfig");
	int DisableChangePublish		= getIntParameter(request,"DisableChangePublish");
	int DisableAddPublishScheme		= getIntParameter(request,"DisableAddPublishScheme");
	//int DisableEditPublishScheme	= getIntParameter(request,"DisableEditPublishScheme");
	int DisableEditPublishScheme	= 0;
	int DisableManageAdminUser		= getIntParameter(request,"DisableManageAdminUser");
	int DisableManageUser			= getIntParameter(request,"DisableManageUser");
	int DisableDeleteChannel		= getIntParameter(request,"DisableDeleteChannel");

	int EnableVblogPreApprove		= getIntParameter(request,"EnableVblogPreApprove");
	int EnableVblogApprove			= getIntParameter(request,"EnableVblogApprove");
	int EnableVblogPigeonhole		= getIntParameter(request,"EnableVblogPigeonhole");
	int EnableAddSpecialChannel		= getIntParameter(request,"EnableAddSpecialChannel");
	int	ManageFile					= getIntParameter(request,"ManageFile");
	int	ManageChannel				= getIntParameter(request,"ManageChannel");
	int	ManageSystem				= getIntParameter(request,"ManageSystem");
	int	OperateSystem				= getIntParameter(request,"OperateSystem");
	if(ManageFile==0){
		ManageFile=1 ;//未勾选，允许
	}else{
		ManageFile=0 ;//勾选，禁止
	}

	if(ManageChannel==0){
		ManageChannel=1 ;//未勾选，允许
	}else{
		ManageChannel=0 ;//勾选，禁止
	}

	if(ManageSystem==0){
		ManageSystem=1 ;//未勾选，允许
	}else{
		ManageSystem=0 ;//勾选，禁止
	}

	if(OperateSystem==0){
		OperateSystem=1 ;//未勾选，允许
	}else{
		OperateSystem=0 ;//勾选，禁止
	}

	String ChannelList				= getParameter(request,"ChannelList");
	String PermList					= getParameter(request,"PermList");
//System.out.println("channellist="+ChannelList+",PermList="+PermList+",EnableAddSpecialChannel="+EnableAddSpecialChannel+"DisableAddPublishScheme:"+DisableAddPublishScheme);
//	u.set();
	if(userinfo.getRole()==1 || userinfo.getRole()==4)
	{
		userinfo.addPermArray("DisableChangeConfig",DisableChangeConfig);
		userinfo.addPermArray("DisableChangePublish",DisableChangePublish);
		userinfo.addPermArray("DisableAddPublishScheme",DisableAddPublishScheme);
		if(DisableAddPublishScheme==1){
           DisableEditPublishScheme=1;
		}
		userinfo.addPermArray("DisableEditPublishScheme",DisableEditPublishScheme);
		userinfo.addPermArray("DisableManageAdminUser",DisableManageAdminUser);
		userinfo.addPermArray("DisableManageUser",DisableManageUser);
		userinfo.addPermArray("DisableDeleteChannel",DisableDeleteChannel);
		userinfo.addPermArray("ManageFile",ManageFile);
		userinfo.addPermArray("ManageChannel",ManageChannel);
		userinfo.addPermArray("ManageSystem",ManageSystem);
		userinfo.addPermArray("OperateSystem",OperateSystem);
	}else if(userinfo.getRole()==5)
	{
		userinfo.addPermArray("EnableVblogPreApprove",EnableVblogPreApprove);
		userinfo.addPermArray("EnableVblogApprove",EnableVblogApprove);
		userinfo.addPermArray("EnableVblogPigeonhole",EnableVblogPigeonhole);
	}
	else
	{
		userinfo.addPermArray("EnableAddSpecialChannel",EnableAddSpecialChannel);

		userinfo.setChannelList(ChannelList);
		userinfo.setPermList(PermList);
		//System.out.println(PermList);
	}
	//long beginTime = System.currentTimeMillis();
	userinfo.setMessageType(2);
	userinfo.setActionUser(userinfo_session.getId());
	userinfo.UpdatePerm();
//out.println("time:"+(System.currentTimeMillis()-beginTime)+"毫秒");
//out.close();
	out.println("<script>top.getDialog().Close();</script>");return;
}

Tree tree = new Tree();
JSONArray arr = tree.listChannel_json(userinfo_session);

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
</style> 

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script type="text/javascript" src="../common/jquery.scrollTo-min.js"></script>

<script language="javascript">
var dir = "";

function check()
{
	var ChannelList = document.getElementById("ChannelList");
	if(document.form.Role.value!=1 && document.form.Role.value!=5)
	{
		var ChannelIDs = "";
		var curr_row;
		for (curr_row = 0; curr_row < ChannelList.childElementCount; curr_row++)
		{
		  ChannelIDs += "," + ChannelList.children[curr_row].id.replace("tr_","");
		}
		document.form.ChannelList.value = ChannelIDs;
//alert(ChannelIDs);
		var PermList = "";
		for(var i=0;i<ChannelArray.length; i++)
		{
			var myObject = ChannelArray[i];
			PermList += "," + myObject.ChannelID;
			PermList += "," + myObject.Perm1;
			PermList += "," + myObject.Perm2;
			PermList += "," + myObject.Perm3;
			PermList += "," + myObject.Perm4;
			PermList += "," + myObject.Perm5;
			PermList += "," + myObject.Perm11;
		}
		document.form.PermList.value = PermList;
	}

	$("#submitButton").attr("disabled",true);

	return true;
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

function setPerm(perm,permname)
{
	var ChannelList = document.getElementById("ChannelList");
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
				obj.Perm11 = 1;	
				//document.form.Perm1.checked = true;
				document.form.Perm2.checked = true;
				document.form.Perm3.checked = true;
				document.form.Perm4.checked = true;
				document.form.Perm5.checked = true;
				document.form.Perm11.checked = true;
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
				if(permname=="Perm11")
					obj.Perm11 = 0;	
			}
		}
	}
	//alert(perm.checked);
}

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

function addChannel2(retu)
{  
	if(retu==null) return;
	if(document.getElementById("tr_"+retu.ChannelID))
	{
		$("#div_table").scrollTo($("#tr_"+retu.ChannelID),800);
		selectChannel(retu.ChannelID);
		return;
	}
	//alert(retu.ChannelID);
	var ChannelList = document.getElementById("ChannelList");		
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

	if(myObject.ChannelType==2)
	{
		myObject.Perm1 = 0;
		myObject.Perm2 = 0;	
		myObject.Perm3 = 0;
		myObject.Perm4 = 0;	
		myObject.Perm5 = 0;	
	}
	myObject.Perm11 = 0;	
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
	
	//is page
	if(myObject.ChannelType==2)
	{
		document.form.Perm1.checked = false;
		document.form.Perm2.checked = false;
		document.form.Perm3.checked = false;
		document.form.Perm4.checked = false;
		document.form.Perm5.checked = false;
	}
	$("#div_table").scrollTo($("#tr_"+retu.ChannelID),800);
	selectChannel(retu.ChannelID);
}

function selectChannel(channelid)
{
//	$("#ChannelList tr").css("background-color","#F5F5F5");
//	$("#tr_"+channelid).css("background-color","#999999");

	$("#ChannelList li").removeClass("active");
	$("#tr_"+channelid).addClass("active");

	var myObject = getObj(channelid);
		if(myObject!=null)
		{//alert(myObject);
			
			if(myObject.ChannelType==2)
			{
				$("#perm001").hide();$("#perm003").show();$("#perm002").hide();

				if(myObject.Perm2==1)
					document.form.Perm7.checked = true;
				else
					document.form.Perm7.checked = false;
				if(myObject.Perm3==1)
					document.form.Perm8.checked = true;
				else
					document.form.Perm8.checked = false;
				if(myObject.Perm4==1)
					document.form.Perm9.checked = true;
				else
					document.form.Perm9.checked = false;
				if(myObject.Perm5==1)
					document.form.Perm10.checked = true;
				else
					document.form.Perm10.checked = false;

				if(myObject.Perm11==1)
					document.form.Perm11.checked = true;
				else
					document.form.Perm11.checked = false;
			}
			else
			{
				$("#perm001").show();$("#perm002").show();$("#perm003").hide();

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
				if(myObject.Perm11==1)
					document.form.Perm11.checked = true;
				else
					document.form.Perm11.checked = false;
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
			myObject.Perm11 = 0;	
			myObject.ChannelID = channelid;
			ChannelArray[ChannelArray.length] = myObject;
			CurrentChannelID = channelid;
		}	
}

function delChannel(channelid)
{
	deleteObj(channelid);
	$("#tr_"+channelid).remove();
//	$("#ChannelList tr").css("background-color","#F5F5F5");
	$("#perm001").hide();$("#perm002").hide();$("#perm003").hide();
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

var ChannelArray = new Array();

var PermString = "<%=(new ChannelPrivilege()).getPermString(userinfo.getId())%>";

function addTr(id,name,type)
{
		var img = "<img src='../images/tree/16_channel_icon.png'>";
		if(type==2) img = "<img src='../images/tree/16_page_icon.png'>";

		var html = '<li class="d-flex lh-30px" id="tr_'+id+'"><i class="fa fa-square wd-30 tx-center"></i><span style="cursor:pointer" onClick="selectChannel('+id+')" class="wd-400">'+name+'</span><a href="javascript:delChannel('+id+');" class="a-delete"><i class="fa fa-times tx-danger tx-18 tx-center wd-30"></i></a></li>';

		$("#ChannelList").append(html);
}

function init()
{
	var ChannelList = document.getElementById("ChannelList");
	//alert(PermString);
	if(PermString=="")
		return;

	var arr = PermString.split(",");

	//9个一组
	for(var i=0;i<arr.length;i+=9)
	{
		addTr(arr[i],arr[i+1],arr[i+7]);

		var myObject = new Object();
		myObject.Perm1 = arr[i+2];
		myObject.Perm2 = arr[i+3];	
		myObject.Perm3 = arr[i+4];
		myObject.Perm4 = arr[i+5];	
		myObject.Perm5 = arr[i+6];
		myObject.Perm11 = arr[i+7];
		myObject.ChannelID = arr[i+0];
		myObject.ChannelType = arr[i+7];
		ChannelArray[ChannelArray.length] = myObject;
	}
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
</script>
</head>

<body class="collapsed-menu email" onLoad="init();">
<div class="bg-white modal-box">

	<form name="form" method="post" action="tcenter_user_edit2.jsp" onSubmit="return check();">
		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">

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
							<input type="checkbox" id="DisableChangeConfig" name="DisableChangeConfig" value="1" <%=userinfo.hasPermission("DisableChangeConfig")?"checked":""%>><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止修改发布方式</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableChangePublish" name="DisableChangePublish" value="1" <%=userinfo.hasPermission("DisableChangePublish")?"checked":""%>><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护发布方案</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableAddPublishScheme" name="DisableAddPublishScheme" value="1" <%=userinfo.hasPermission("DisableAddPublishScheme")?"checked":""%>><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止删除频道</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableDeleteChannel" name="DisableDeleteChannel" value="1" <%=userinfo.hasPermission("DisableDeleteChannel")?"checked":""%>><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护文件管理</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="ManageFile" name="ManageFile" value="1" <%=!userinfo.hasPermission("ManageFile")?"checked":""%>><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护结构管理</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="ManageChannel" name="ManageChannel" value="1" <%=!userinfo.hasPermission("ManageChannel")?"checked":""%>><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护系统管理</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="ManageSystem" name="ManageSystem" value="1" <%=!userinfo.hasPermission("ManageSystem")?"checked":""%>><span>&nbsp;</span>
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
				
				<tr>
					<td class="tx-right pd-r-20">禁止维护系统管理员用户</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableManageAdminUser" name="DisableManageAdminUser" value="1" <%=userinfo.hasPermission("DisableManageAdminUser")?"checked":""%>><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护用户</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableManageUser" name="DisableManageUser" value="1" <%=userinfo.hasPermission("DisableManageUser")?"checked":""%>><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				
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
						<input type="checkbox" name="EnableVblogPreApprove" value="1" <%=userinfo.hasPermission("EnableVblogPreApprove")?"checked":""%>><span>&nbsp;预审通过</span>
					</label>									
				</td>
			</tr>
			<tr>
				<td class="tx-right pd-r-20"></td>
				<td class="tx-left pd-l-20">								
					<label class="ckbox mg-r-20">
						<input type="checkbox" name="EnableVblogApprove" value="1" <%=userinfo.hasPermission("EnableVblogApprove")?"checked":""%>><span>&nbsp;审核通过</span>
					</label>									
				</td>
			</tr>
			<tr>
				<td class="tx-right pd-r-20"></td>
				<td class="tx-left pd-l-20">								
					<label class="ckbox mg-r-20">
						<input type="checkbox" name="EnableVblogPigeonhole" value="1" <%=userinfo.hasPermission("EnableVblogPigeonhole")?"checked":""%>><span>&nbsp;视频归档</span>
					</label>									
				</td>
			</tr>
		</table>
		</div>
		</div>
<%}else{%>
		<div class="d-flex ht-100p-force justify-content-between">
			<div class="br-subleft br-subleft-file">
				<div class="sidebar-menu-box ht-100p-force overflow-auto">
					<ul class="sidebar-menu mg-t-0-force">	  	  
					</ul>
				</div>
			</div><!-- br-subleft -->
			<div class="right-box wd-500">
				<div class="top-channel">
					<div class="block-title mg-t-5 lh-30px"><b>频道或分类名称</b></div>
					<div class="channel-container ht-300 overflow-y-auto" id="div_table">
						<ul class="pd-15" id="ChannelList">
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
<%}%>
		<div id="otherpermission" style="display:none;">
			<table class="wd-90p-force" > 
				<tr>
					<td class="tx-right pd-r-20"></td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" name="EnableAddSpecialChannel" value="1" <%=userinfo.hasPermission("EnableAddSpecialChannel")?"checked":""%>><span>&nbsp;建立专题</span>
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
			<input type="hidden" name="Role" value="<%=userinfo.getRole()%>">
		    <button id="submitButton" name="submitButton" type="submit" class="btn btn-primary tx-size-xs">确认</button>
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
					
		var menu = $('.sidebar-menu');
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
				html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
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
</script>

</body>
</html>