<%@ page import="java.sql.*,tidemedia.cms.util.Util,
				tidemedia.cms.system.*,
				tidemedia.cms.publish.PublishScheme,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%//禁止添加发布方案
if(!(new UserPerm().canAddPublishScheme(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");
int SiteId=Util.getIntParameter(request,"SiteId");
if(Submit.equals("Submit"))
{
//	String			=	getParameter(request,"");

	String	Name			=	getParameter(request,"Name");
	String	Server			=	getParameter(request,"Server");
	String	Username		=	getParameter(request,"Username");
	String	Password		=	getParameter(request,"Password");
	String	Port			=	getParameter(request,"Port");
	String	RemoteFolder	=	getParameter(request,"RemoteFolder");
	String	DestFolder		=	getParameter(request,"DestFolder");
	String	IncludeFolders	=	getParameter(request,"IncludeFolders");
	String	ExcludeFolders	=	getParameter(request,"ExcludeFolders");
	int		CopyMode		=	getIntParameter(request,"CopyMode");
	int		FtpMode			=	getIntParameter(request,"FtpMode");
	String	endPoint		=	getParameter(request,"endPoint");
	String	accessKeyID		=	getParameter(request,"accessKeyID");
	String	secretKey		=	getParameter(request,"secretKey");
	String	bucketName		=	getParameter(request,"bucketName");
	String	TenantName		=	getParameter(request,"TenantName");
	String	TokenUrl		=	getParameter(request,"TokenUrl");
	String videoHttpHead	=	getParameter(request,"videoHttpHead");
	String	CredentialsUserName		=	getParameter(request,"CredentialsUserName");
	String	CredentialsPassword		=	getParameter(request,"CredentialsPassword");
	//Ossendpoint,OssLocalenpoint,OssaccessKeyId,OssaccessKeySecret,OSSbucketName
	String  Ossendpoint		=	getParameter(request,"Ossendpoint");
	String  OssLocalenpoint	=	getParameter(request,"OssLocalenpoint");
	String  OssaccessKeyId	=	getParameter(request,"OssaccessKeyId");
	String  OssaccessKeySecret	=	getParameter(request,"OssaccessKeySecret");
	String  OSSbucketName		=	getParameter(request,"OSSbucketName");
	String  Ossdomain		=	getParameter(request,"Ossdomain");
	
	String  BosaccessKeyId	=	getParameter(request,"BosaccessKeyId");
	String  BosaccessKeySecret	=	getParameter(request,"BosaccessKeySecret");
	String  BosbucketName		=	getParameter(request,"BosbucketName");
	//System.out.println("CopyMode="+CopyMode+",name="+Name+",username="+Username);
	PublishScheme publishscheme = new PublishScheme();

//	u.set();
	publishscheme.setName(Name);
	publishscheme.setUserId(userinfo_session.getId());
	publishscheme.setServer(Server);
	publishscheme.setUsername(Username);
	publishscheme.setPassword(Password);
	publishscheme.setPort(Port);
	publishscheme.setRemoteFolder(RemoteFolder);
	publishscheme.setDestFolder(DestFolder);
	publishscheme.setIncludeFolders(IncludeFolders);
	publishscheme.setExcludeFolders(ExcludeFolders);
	publishscheme.setCopyMode(CopyMode);
	publishscheme.setFtpMode(FtpMode);
	publishscheme.setStatus(1);
    publishscheme.setSite(SiteId);
    publishscheme.setEndPoint(endPoint);
    publishscheme.setAccessKeyID(accessKeyID);
    publishscheme.setSecretKey(secretKey);
    publishscheme.setBucketName(bucketName);
    publishscheme.setTenantName(TenantName);
    publishscheme.setTokenUrl(TokenUrl);
    publishscheme.setCredentialsUserName(CredentialsUserName);
    publishscheme.setCredentialsPassword(CredentialsPassword);
    publishscheme.setVideoHttpHead(videoHttpHead);
	publishscheme.setOssendpoint(Ossendpoint);
	publishscheme.setOssLocalenpoint(OssLocalenpoint);
	publishscheme.setOssaccessKeyId(OssaccessKeyId);
	publishscheme.setOssaccessKeySecret(OssaccessKeySecret);
	publishscheme.setOSSbucketName(OSSbucketName);
	publishscheme.setOssdomain(Ossdomain);
    publishscheme.setBosaccessKeyId(BosaccessKeyId);
	publishscheme.setBosaccessKeySecret(BosaccessKeySecret);
	publishscheme.setBosbucketName(BosbucketName);

	//Ossendpoint,OssLocalenpoint,OssaccessKeyId,OssaccessKeySecret,OSSbucketName
	publishscheme.Add();
    //CmsCache.getSite(SiteId).clearPublishSchemes();
	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript">
function check()
{
	if(isEmpty(document.form.Name,"请输入方案名."))
			return false;
	var CopyMode_Checked = "0";
	var CopyMode=jQuery("#CopyMode").val();

		if(CopyMode==1)
			{
			if(isEmpty(document.form.Server,"请输入FTP服务器."))
				return false;
			if(isEmpty(document.form.Port,"请输入端口."))
				return false;
			if(isEmpty(document.form.Username,"请输入用户名."))
				return false;
			if(isEmpty(document.form.Password,"请输入密码."))
				return false;
			}

			if(CopyMode=="2")
			{
			if(isEmpty(document.form.DestFolder,"请输入目标目录."))
				return false;
			}
			
			
			if(CopyMode==3)
			{
			if(isEmpty(document.form.endPoint,"请输入S3服务器"))
				return false;
			if(isEmpty(document.form.bucketName,"请输入bucketName."))
				return false;
			if(isEmpty(document.form.accessKeyID,"请输入accessKeyID."))
				return false;
			if(isEmpty(document.form.secretKey,"请输入secretKey."))
				return false;
			}
			CopyMode_Checked = "1";

	if(CopyMode_Checked=="0")
	{
		alert("请选择文件复制方式.");
		return false;
	}

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

function init()
{

}


function showTab(form,form_td)
{
	var num = 6;
	for(i=1;i<=num;i++)
	{
		jQuery("#form"+i).hide();
		jQuery("#form"+i+"_td").removeClass("cur");
	}
	
	if(form=="form1"){
		jQuery("#CopyMode").val("1");
	}else if(form=="form2"){
		jQuery("#CopyMode").val("2");
	}else if(form=="form3"){
		jQuery("#CopyMode").val("3");
	}else if(form=="form4"){
		jQuery("#CopyMode").val("4");
	}else if(form=="form5"){
		jQuery("#CopyMode").val("5");
	}else if(form=="form6"){
		jQuery("#CopyMode").val("6");
	}
	
	jQuery("#"+form).show();
	jQuery("#"+form_td).addClass("cur");
}
</script>
<style> 
.edit-main{margin:0;position:Static;}
.edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
.edit-con{position:Static;margin:-1px 0 0;}
.edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
</style>
</head>

<body  onload="init();">
<form name="form" method="post" action="publish_add.jsp" onSubmit="return check();">
<!-- start-->
<div class="edit_main dialog_editChannel">
	<div class="edit_nav">
    	<ul>
        	<li><a href="javascript:showTab('form1','form1_td');" class="cur" id="form1_td"><span>FTP上传</span></a></li>
            <li><a href="javascript:showTab('form2','form2_td');" id="form2_td"><span>文件拷贝</span></a></li>
            <li><a href="javascript:showTab('form3','form3_td');" id="form3_td"><span>S3云存储</span></a></li>
            <li><a href="javascript:showTab('form4','form4_td');" id="form4_td"><span>OpenStack云存储</span></a></li>
			<li><a href="javascript:showTab('form5','form5_td');" id="form5_td"><span>阿里云存储</span></a></li>
            <li><a href="javascript:showTab('form6','form6_td');" id="form6_td"><span>百度云存储</span></a></li>
        </ul>
        <div class="clear"></div>
    </div>
    <div class="edit_con">
    	 
<div class="center_main">
<div  class="center">
<table width="100%" border="0">
  <tr>
    <td width="100">发布方案名:</td>
	<td><input name="Name" type="text" class="textfield"></td>
  </tr>
</table>
</div>
<div class="center" id="form1">
<table width="100%" border="0">
  <tr>
    <td width="100">FTP服务器：</td>
    <td><input name="Server" type="text" class="textfield"></td>
  </tr>

  <tr>
    <td>端口：</td>
    <td><input name="Port" type="text" class="textfield" value="21">模式：<input type="radio" id="s001" name="FtpMode" value="0"><label for="s001">主动模式</label><input type="radio" id="s002" name="FtpMode" value="1"><label for="s002">被动模式</label></td>
  </tr>
  <tr>
    <td>用户名：</td>
    <td><input name="Username" type="text" class="textfield"></td>
  </tr>
  <tr>
    <td>密码：</td>
    <td><input name="Password" type="Password" class="textfield"></td>
  </tr>
  <tr>
    <td>远程目录：</td>
    <td><input name="RemoteFolder" type="text" class="textfield" value="/"></td>
  </tr>
  <tr>
    <td width="100">允许发布的目录：</td>
    <td><textarea name="IncludeFolders" rows="4" cols="25"></textarea></td>
  </tr>
  <tr>
    <td>禁止发布的目录：</td>
    <td><textarea name="ExcludeFolders" rows="4" cols="25"></textarea></td>
  </tr>
    <tr>
    <td><input type="hidden" name="CopyMode"  id="CopyMode" value="1"></td>
  </tr>
</table>
</div>
        
<div class="center" id="form2" style="display:none;">
<table width="100%" border="0">
  <tr>
    <td width="100">目标目录：</td>
    <td><input name="DestFolder" type="text" class="textfield"></td>
  </tr>
  <tr>
    <tr>
    <td width="100">允许发布的目录：</td>
    <td><textarea name="IncludeFolders" rows="4" cols="25"></textarea></td>
  </tr>
  <tr>
    <td>禁止发布的目录：</td>
    <td><textarea name="ExcludeFolders" rows="4" cols="25"></textarea></td>
  </tr>
  <tr>
    <td><input type="hidden" name="CopyMode"  id="CopyMode" value="2"></td>
  </tr>
</table>
</div>


  
<div class="center" id="form3" style="display:none;">
<table width="100%" border="0">
  <tr>
    <td width="100">S3服务器：</td>
    <td><input name="endPoint" type="text" class="textfield" size="40"></td>
  </tr>

  <tr>
    <td>accessKeyID：</td>
    <td><input name="accessKeyID" type="text" class="textfield" size="40"></td>
  </tr>
  <tr>
    <td>secretKey：</td>
    <td><input name="secretKey" type="text" type="Password" class="textfield" size="40"></td>
  </tr>
  <tr>
    <td>bucketName：</td>
    <td><input name="bucketName" type="text" class="textfield" value="" size="40"></td>
  </tr>
   <tr>
    <td>videoHttpHead：</td>
    <td><input name="videoHttpHead" type="text" class="textfield" value="" size="40"></td>
  </tr>
   <tr>
    <td><input type="hidden" name="CopyMode"  id="CopyMode" value="3"></td>
  </tr>
</table>
</div>

<div class="center" id="form4" style="display:none;">
<table width="100%" border="0">
  <tr>
    <td width="100">tokenUrl：</td>
    <td><input name="TokenUrl" type="text" class="textfield" size="40"></td>
  </tr>

  <tr>
    <td>TenantName：</td>
    <td><input name="TenantName" type="text" class="textfield" size="40"></td>
  </tr>
  <tr>
    <td>UserName：</td>
    <td><input name="CredentialsUserName" type="text" type="Password" class="textfield" size="40"></td>
  </tr>
  <tr>
    <td>Password：</td>
    <td><input name="CredentialsPassword" type="text" class="textfield" value="" type="password" size="40"></td>
  </tr>
   <tr>
    <td><input type="hidden" name="CopyMode"  id="CopyMode" value="4"></td>
  </tr>
</table>
</div>


<div class="center" id="form5" style="display:none;">
<table width="100%" border="0">
  <tr>
    <td width="100">endpoint：</td>
    <td><input name="Ossendpoint" type="text" class="textfield" size="40"></td>
  </tr>

  <tr>
    <td>Localenpoint：</td>
    <td><input name="OssLocalenpoint" type="text" class="textfield" size="40"></td>
  </tr>
  <tr>
    <td>accessKeyId：</td>
    <td><input name="OssaccessKeyId" type="text" type="Password" class="textfield" size="40"></td>
  </tr>
  <tr>
    <td>accessKeySecret：</td>
    <td><input name="OssaccessKeySecret" type="text" class="textfield" value="" type="password" size="40"></td>
  </tr>
  <tr>
    <td>bucketName：</td>
    <td><input name="OSSbucketName" type="text" class="textfield" value="" type="text" size="40"></td>
  </tr>
  <tr>
    <td>Ossdomain：</td>
    <td><input name="Ossdomain" type="text" class="textfield" value="" type="text" size="40"></td>
  </tr>
   <tr>
    <td><input type="hidden" name="CopyMode"  id="CopyMode" value="5" ></td>
  </tr>
</table>
</div>

<div class="center" id="form6" style="display:none;">
<table width="100%" border="0">
  
  <tr>
    <td width="100">accessKeyId：</td>
    <td><input name="BosaccessKeyId" type="text" type="Password" class="textfield" size="40"></td>
  </tr>
  <tr>
    <td>secretAccessKey：</td>
    <td><input name="BosaccessKeySecret" type="text" class="textfield" value="" type="password" size="40"></td>
  </tr>
  <tr>
    <td>bucketName：</td>
    <td><input name="BosbucketName" type="text" class="textfield" value="" type="text" size="40"></td>
  </tr>
   <tr>
    <td><input type="hidden" name="CopyMode"  id="CopyMode" value="6"></td>
  </tr>
</table>
</div>

</div>
       
    </div>
</div>
<!-- end-->
<div class="form_button">
	
	<input type="hidden" name="Submit" value="Submit">
	<input type="hidden" name="SiteId" value="<%=SiteId%>">
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>

</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>