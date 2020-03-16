<%@ page import="java.sql.*,org.json.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");

String	Name		=	getParameter(request,"Name");
String	Username	=	getParameter(request,"Username");
String	Password	=	getParameter(request,"Password");
String	Email		=	getParameter(request,"Email");
String	Tel			=	getParameter(request,"Tel");
String	Comment		=	getParameter(request,"Comment");
int		GroupID		=	getIntParameter(request,"GroupID");
String	ExpireDate	=	getParameter(request,"ExpireDate");
String	token		=	getParameter(request,"token");


int		Role		=	getIntParameter(request,"Role");
String	Sites[]		=	request.getParameterValues("Site");
String Site = Util.ArrayToString(Sites,",");

String RoleName = "";

if(Role==1)
{
	if(!(new UserPerm().canManageAdminUser(userinfo_session)))
	{response.sendRedirect("../noperm.jsp");return;}
}
//out.println("submit="+Submit+",token="+token);
if(Submit.equals("Submit2"))
{
//	String			=	getParameter(request,"");

//	int		Role2		=	getIntParameter(request,"Role2");
//	int		Role3		=	getIntParameter(request,"Role3");

	int DisableChangeConfig			= getIntParameter(request,"DisableChangeConfig");
	int DisableChangePublish		= getIntParameter(request,"DisableChangePublish");
	int DisableAddPublishScheme		= getIntParameter(request,"DisableAddPublishScheme");
	//int DisableEditPublishScheme	= getIntParameter(request,"DisableEditPublishScheme");
	int DisableEditPublishScheme    = 0;
	int DisableManageAdminUser		= getIntParameter(request,"DisableManageAdminUser");
	int DisableManageUser			= getIntParameter(request,"DisableManageUser");
	int DisableDeleteChannel		= getIntParameter(request,"DisableDeleteChannel");

	int EnableVblogPreApprove		= getIntParameter(request,"EnableVblogPreApprove");
	int EnableVblogApprove			= getIntParameter(request,"EnableVblogApprove");
	int EnableVblogPigeonhole		= getIntParameter(request,"EnableVblogPigeonhole");

	String ChannelList				= getParameter(request,"ChannelList");
	String PermList					= getParameter(request,"PermList");

	UserInfo userinfo = new UserInfo();

//	u.set();
	userinfo.setName(Name);
	userinfo.setUsername(Username);
	userinfo.setPassword(Password);
	userinfo.setEmail(Email);
	userinfo.setTel(Tel);
	userinfo.setComment(Comment);
	userinfo.setExpireDate(ExpireDate);
	userinfo.setRole(Role);
	userinfo.setSite(Site);
	userinfo.setGroup(GroupID);
	userinfo.setToken(token);

	if(Role==1)
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
	}else if(Role==5)
	{
		userinfo.addPermArray("EnableVblogPreApprove",EnableVblogPreApprove);
		userinfo.addPermArray("EnableVblogApprove",EnableVblogApprove);
		userinfo.addPermArray("EnableVblogPigeonhole",EnableVblogPigeonhole);
	}
	else
	{
		System.out.println("ChannelList:"+ChannelList);
		userinfo.setChannelList(ChannelList);
		userinfo.setPermList(PermList);
	}

	userinfo.setActionUser(userinfo_session.getId());
	userinfo.Add();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}

	Tree tree = new Tree();
	JSONArray arr = tree.listChannel_json(userinfo_session);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
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

</style> 
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script type="text/javascript" src="../common/jquery.scrollTo-min.js"></script>
<script language="javascript">
var dir = "";

function init()
{
<%if(Role==1){%>
	top.TideDialogResize(500,400);
<%}else if(Role==3 || Role==2){%>
	top.TideDialogResize(800,650);
<%}%>
}


function check()
{//alert($("#Role").val());return false;
	if(isEmpty(document.form.Username,"请输入登录名."))
		return false;
	if(isEmpty(document.form.Password,"请输入密码."))
		return false;
	if(isEmpty(document.form.Name,"请输入姓名."))
		return false;

	var role = $("#Role").val();

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
		}
//alert(PermList);
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

function addTr(id,name,type)
{
	var img = "<img src='../images/tree/16_channel_icon.png'>";
	if(type==2) img = "<img src='../images/tree/16_page_icon.png'>";

	var html = '<li class="d-flex ht-30 lh-30px" id="tr_'+id+'"><i class="fa fa-square wd-30 tx-center"></i><span style="cursor:pointer" onClick="selectChannel('+id+')" class="wd-400">'+name+'</span><a href="javascript:delChannel('+id+');" class="a-delete"><i class="fa fa-times tx-danger tx-18 tx-center wd-30"></i></a></li>';

	$("#ChannelList").append(html);
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

function addChannel()
{
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
		var oRow = ChannelList.insertRow();
		var oCell = oRow.insertCell();
		oRow.ChannelID = retu.ChannelID;
		oRow.attachEvent ('onclick', selectChannel);
		oCell.innerHTML = retu.Name;
		
		var myObject = getObj(retu.ChannelID);
		if(myObject!=null)
		{		
		}
		else
		{
			PermList.style.display = "";
			myObject = new Object();
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

function setPerm(perm,permname)
{
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
				//document.form.Perm1.checked = true;
				document.form.Perm2.checked = true;
				document.form.Perm3.checked = true;
				document.form.Perm4.checked = true;
				document.form.Perm5.checked = true;
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
			}
		}
	}
	//alert(perm.checked);
}

var ChannelArray = new Array();
var CurrentChannelID = 0;

</script>
</head>

<body onLoad="init()" class="collapsed-menu email">
<div class="bg-white modal-box"> 

	<form name="form" method="post" action="user_add_2.jsp" onSubmit="return check();">
		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">

<%if(Role==1){%>
		<div class="table-box">
		<table class="wd-90p-force">
			<thead>
				<tr>
					<th class="tx-center wd-50p-force"><b class="tx-black">权限</b></th>
					<th class="tx-center wd-50p-force"><b class="tx-black">设置</b></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="tx-right pd-r-20">禁止修改配置文件</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableChangeConfig" name="DisableChangeConfig" value="1" checked><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止修改发布方式</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableChangePublish" name="DisableChangePublish" value="1" checked><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护发布方案</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableAddPublishScheme" name="DisableAddPublishScheme" value="1" checked><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<!--<tr>
					<td class="tx-right pd-r-20">禁止修改发布方案</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableEditPublishScheme" name="DisableEditPublishScheme" value="1" checked><span>&nbsp;</span>
						</label>									
					</td>
				</tr>-->
				<tr>
					<td class="tx-right pd-r-20">禁止维护系统管理员用户</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableManageAdminUser" name="DisableManageAdminUser" value="1" checked><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止维护用户</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableManageUser" name="DisableManageUser" value="1" checked><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
				<tr>
					<td class="tx-right pd-r-20">禁止删除频道</td>
					<td class="tx-left pd-l-20">								
						<label class="ckbox mg-r-20">
							<input type="checkbox" id="DisableDeleteChannel" name="DisableDeleteChannel" value="1" checked><span>&nbsp;</span>
						</label>									
					</td>
				</tr>
			</tbody>
		</table>
		</div>
<%}else if(Role==5){%>
		<div id="vblog">
		<div class="table-box">
		<table class="wd-90p-force">
			<tr>
				<td class="tx-right pd-r-20"></td>
				<td class="tx-left pd-l-20">								
					<label class="ckbox mg-r-20">
						<input type="checkbox" name="EnableVblogPreApprove" value="1" checked><span>&nbsp;预审通过</span>
					</label>									
				</td>
			</tr>
			<tr>
				<td class="tx-right pd-r-20"></td>
				<td class="tx-left pd-l-20">								
					<label class="ckbox mg-r-20">
						<input type="checkbox" name="EnableVblogApprove" value="1" checked><span>&nbsp;审核通过</span>
					</label>									
				</td>
			</tr>
			<tr>
				<td class="tx-right pd-r-20"></td>
				<td class="tx-left pd-l-20">								
					<label class="ckbox mg-r-20">
						<input type="checkbox" name="EnableVblogPigeonhole" value="1" checked><span>&nbsp;视频归档</span>
					</label>									
				</td>
			</tr>
		</table>
		</div>
		</div>
<%}else if(Role==2 || Role==3 || Role==4){%>
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
								<input name="Perm3" type="checkbox" id="Perm3" value="1"  onClick="setPerm(this,'Perm3');"><span>发表文档</span>
							</label>
							<label class="ckbox mg-r-20">
								<input name="Perm4" type="checkbox" id="Perm4" value="1"  onClick="setPerm(this,'Perm4');"><span>审批文档</span>
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
<%}%>
	</div><!-- modal-body -->

	<div class="btn-box">
      	<div class="modal-footer" >
		     <button id="submitButton" name="submitButton" type="submit" class="btn btn-primary tx-size-xs">确认</button>
		     <button id="btnCancel1" name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		</div> 
    </div>

	<input type="hidden" name="Submit" value="Submit2">
	<input type="hidden" id="Role" name="Role" value="<%=Role%>">
	<input type="hidden" name="Name" value="<%=Name%>">
	<input type="hidden" name="token" value="<%=token%>">
	<input type="hidden" name="Site" value="<%=Site%>">
	<input type="hidden" name="Username" value="<%=Username%>">
	<input type="hidden" name="Password" value="<%=Password%>">
	<input type="hidden" name="Email" value="<%=Email%>">
	<input type="hidden" name="Tel" value="<%=Tel%>">
	<input type="hidden" name="Comment" value="<%=Comment%>">
	<input type="hidden" name="GroupID" value="<%=GroupID%>">
	<input type="hidden" name="ExpireDate" value="<%=ExpireDate%>">
	<input type="hidden" name="ChannelList" value="">
	<input type="hidden" name="PermList" value="">
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
