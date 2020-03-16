<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int ChannelID = getIntParameter(request,"ChannelID");

Channel channel = CmsCache.getChannel(ChannelID);

String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{
//	String			=	getParameter(request,"");

	String UserList				= getParameter(request,"UserList");
	String PermList					= getParameter(request,"PermList");

//	u.set();

	ChannelPrivilege cp = new ChannelPrivilege(); 
		//userinfo.setChannelList(ChannelList);
	//cp.setPermList(PermList);
	//System.out.println(PermList);

	//cp.setMessageType(2);
	cp.setChannelPerm(ChannelID,UserList,PermList);

	out.println("<script>top.TideDialogClose();</script>");
}

%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script language="javascript">
function check()
{

	var UserIDs = "";
	var curr_row;
	for (curr_row = 0; curr_row < ChannelList.rows.length; curr_row++)
	{
	  UserIDs += "," + ChannelList.rows[curr_row].UserID;
	}

	document.form.UserList.value = UserIDs;

	var PermList = "";
	for(var i=0;i<ChannelArray.length; i++)
	{
		var myObject = ChannelArray[i];
		PermList += "," + myObject.UserID;
		PermList += "," + myObject.Perm1;
		PermList += "," + myObject.Perm2;
		PermList += "," + myObject.Perm3;
		PermList += "," + myObject.Perm4;
		PermList += "," + myObject.Perm5;
	}

	document.form.PermList.value = PermList;

	document.form.Button2.disabled  = true;

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
	if(permname=="Perm6")
	{
		var obj = getObj(CurrentUserID);
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

	if(CurrentUserID>0)
	{
		var obj = getObj(CurrentUserID);
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

function addUser()
{
	var myObject = new Object();
    myObject.title = "选择用户";

 	var Feature = "dialogWidth:32em; dialogHeight:22em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=user/channel_privilege_index.jsp",myObject,Feature);
	if(retu!=null)
	{
		//document.form.ChannelName.value = retu.Name;
		//document.form.ChannelID.value = retu.ChannelID;
		var curr_row;
		for (curr_row = 0; curr_row < ChannelList.rows.length; curr_row++)
		{
		  if(ChannelList.rows[curr_row].UserID==retu.UserID)
			{
			 return;
			}
		}
		var oRow = ChannelList.insertRow();
		var oCell = oRow.insertCell();
		oRow.UserID = retu.UserID;
		oRow.attachEvent ('onclick', selectUser);
		oCell.innerHTML = retu.Name;
		
		var myObject = getObj(retu.UserID);
		if(myObject!=null)
		{		
		}
		else
		{
			PermList.style.display = "";
			myObject = new Object();
			if(retu.Role==2)
			{
				myObject.Perm1 = 1;
				myObject.Perm2 = 1;	
				myObject.Perm3 = 1;
				myObject.Perm4 = 1;	
				myObject.Perm5 = 1;	
			}
			else if(retu.Role==3)
			{
				myObject.Perm1 = 0;
				myObject.Perm2 = 1;	
				myObject.Perm3 = 1;
				myObject.Perm4 = 1;	
				myObject.Perm5 = 1;	
			}
			else if(retu.Role == 4)
			{
				myObject.Perm1 = 0;
				myObject.Perm2 = 1;	
				myObject.Perm3 = 1;
				myObject.Perm4 = 0;	
				myObject.Perm5 = 0;	
			}
			myObject.UserID = retu.UserID;
			ChannelArray[ChannelArray.length] = myObject;
			//alert(ChannelArray.length);
			CurrentUserID = retu.UserID;
			if(retu.Role==2)
			{
				document.form.Perm1.checked = true;
				document.form.Perm6.checked = true;
				document.form.Perm2.checked = true;
				document.form.Perm3.checked = true;
				document.form.Perm4.checked = true;
				document.form.Perm5.checked = true;
			}
			else if(retu.Role==3)
			{
				document.form.Perm1.checked = false;
				document.form.Perm6.checked = true;
				document.form.Perm2.checked = true;
				document.form.Perm3.checked = true;
				document.form.Perm4.checked = true;
				document.form.Perm5.checked = true;	
			}
			else if(retu.Role==4)
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

function selectUser()
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
		var myObject = getObj(oSource.UserID);
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

			CurrentUserID = oSource.UserID;
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
			myObject.UserID = oSource.UserID;
			ChannelArray[ChannelArray.length] = myObject;
			CurrentUserID = oSource.UserID;
		}	
}

function delUser()
{
	var userid = -1;
	var rowindex = -1;
	for (var curr_row = 0; curr_row < ChannelList.rows.length; curr_row++)
	{//alert(ChannelList.rows[curr_row].bgColor);
		if(ChannelList.rows[curr_row].bgColor == "#999999")
		{
			rowindex = curr_row;
			userid = ChannelList.rows[curr_row].UserID;
		}
	}

	if(userid == -1)
		return;

	//alert(rowindex);
	deleteObj(userid);
	ChannelList.deleteRow(rowindex);

	if(ChannelList.rows.length==0)
	{
		PermList.style.display = "none";
	}

	for (var curr_row = 0; curr_row < ChannelList.rows.length; curr_row++)
	{//alert(curr_row + ":" + rowindex);
		if(curr_row == rowindex)
		{
			ChannelList.rows[curr_row].bgColor = "#999999";
			var myObject = getObj(ChannelList.rows[curr_row].UserID);
			if(myObject!=null)
			{
				PermList.style.display = "";
				document.form.Perm1.checked = myObject.Perm1;
				document.form.Perm2.checked = myObject.Perm2;
				document.form.Perm3.checked = myObject.Perm3;
				document.form.Perm4.checked = myObject.Perm4;
				document.form.Perm5.checked = myObject.Perm5;
				CurrentUserID = ChannelList.rows[curr_row].UserID;
			}
		}		
	}
}

function getObj(userid)
{
	for(var i=0;i<ChannelArray.length; i++)
	{
		var myObject = ChannelArray[i];

		if(myObject.UserID==userid)
			return ChannelArray[i];
	}
	
	return null;
}

function deleteObj(userid)
{
	var ChannelArray1 = new Array();
	var j = 0;
	for(var i=0;i<ChannelArray.length; i++)
	{
		var myObject = ChannelArray[i];
		
		if(myObject.UserID!=userid)
			ChannelArray1[j++]  = ChannelArray[i];
	}
	
	ChannelArray = ChannelArray1;

	return null;
}

var ChannelArray = new Array();

var PermString = "<%=(new ChannelPrivilege()).getPermStringByChannel(ChannelID)%>";

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
		oRow.UserID = arr[i+0];
		oRow.attachEvent ('onclick', selectUser);
		oCell.innerHTML = arr[i+1];

		myObject = new Object();
		myObject.Perm1 = arr[i+2];
		myObject.Perm2 = arr[i+3];	
		myObject.Perm3 = arr[i+4];
		myObject.Perm4 = arr[i+5];	
		myObject.Perm5 = arr[i+6];	
		myObject.UserID = arr[i+0];
		ChannelArray[ChannelArray.length] = myObject;
	}
}
</script>
</head>

<body leftmargin="1" topmargin="1" marginwidth="1" marginheight="1" scroll="no" onLoad="init();">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
<form name="form" method="post" action="channel_privilege.jsp" onSubmit="return check();">
  <tr> 
    <td valign="top" class="box-tint">
      <table width="100%" height="24"  border="0" cellpadding="0" cellspacing="0" class="box-gray">
        <tr>
          <td ><span >&nbsp;&nbsp;权限</span></td>
        </tr>
      </table>
<div id="permission" style="display:;">
<table width="100%" border="0" cellpadding="10" cellspacing="0">
    <tr>
      <td height="100" valign="top">用户:
        <div style="overflow:scroll;height:100px;">
		<table width="100%" border="0" id="ChannelList">
        </table>
		</div></td>
      <td valign="top"><p>
		  <input name="Submit" type="button" class="tidecms_btn3" value="添加"  onClick="addUser();"/>
          <br>
          <br>
			<input name="Submit" type="button" class="tidecms_btn3" value="删除" onClick="delUser();"/>
        </p>
        </td>
    </tr>
    <tr>
      <td colspan="2">
		权限: 
        <div style="overflow:auto;height:140px;">
		<table width="100%" border="0" id="PermList" style="display:none; ">
		<tr>
		<td width="62%">包括子频道</td>
		<td width="38%"><input name="Perm1" type="checkbox" id="Perm1" value="1" onClick="setPerm(this,'Perm1');"></td>
		</tr>
		<tr>
          <td>全部权限</td>
          <td><input name="Perm6" type="checkbox" id="Perm6" value="1" onClick="setPerm(this,'Perm6');"></td>
		  </tr>
		<tr>
          <td>浏览文档</td>
          <td><input name="Perm2" type="checkbox" id="Perm2" value="1" onClick="setPerm(this,'Perm2');"></td>
		  </tr>
		<tr>
          <td>发表文档</td>
          <td><input name="Perm3" type="checkbox" id="Perm3" value="1"  onClick="setPerm(this,'Perm3');"></td>
		  </tr>
		<tr>
          <td>审批文档</td>
          <td><input name="Perm4" type="checkbox" id="Perm4" value="1"  onClick="setPerm(this,'Perm4');"></td>
		  </tr>
		<tr>
          <td>删除文档</td>
          <td><input name="Perm5" type="checkbox" id="Perm5" value="1"  onClick="setPerm(this,'Perm5');"></td>
		  </tr>
        </table>
		</div>	  
	  &nbsp;</td>
      </tr>
  </table>
</div>

    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray">
<input name="Button2" type="submit" class="tidecms_btn2" value="  确  定  " />
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn2" value="  取  消  " onClick="top.TideDialogClose();"/>

<input type="hidden" name="Submit" value="Submit">
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
<input type="hidden" name="UserList" value="">
<input type="hidden" name="PermList" value="">
	</td>
  </tr>
</form>
</table>
</body>
</html>
