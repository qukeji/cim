<%@ page import="java.io.File,tidemedia.cms.util.Util,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String	FileName		= getParameter(request,"FileName");
int SiteId=Util.getIntParameter(request,"SiteId");
if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}

String FolderName		= "";
int index = FileName.lastIndexOf("/");
if(index!=-1)
{
	FolderName = FileName.substring(0,index);
	FileName = FileName.substring(index+1);
}

String NewFileName = getParameter(request,"NewFileName");
if(!NewFileName.equals(""))
{

	Site site=CmsCache.getSite(SiteId);
	String SiteFolder=site.getSiteFolder();
	
	FolderName				= getParameter(request,"FolderName");
	FileName				= getParameter(request,"FileName");
	String  Path			= SiteFolder + "/" + FolderName + "/" + FileName;
	String  NewPath			= SiteFolder + "/" + FolderName + "/" + NewFileName;

	File file = new File(Path);

	File newfile = new File(NewPath);

	file.renameTo(newfile);
	new Log().FileLog(LogAction.folder_edit,"/" + FolderName + "/" + NewFileName,userinfo_session.getId(),SiteId);

	out.println("<script>top.TideDialogClose({refresh:'left',returnNavValue:{foldername:'"+FolderName+ "/" + NewFileName+"',parentFolder:'"+FolderName+"',siteid:"+SiteId+",type:1,site:false}});</script>");
	return;
}
%>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<style>
html,body{
	width: 100%;
	height: 100%;
}
</style>

<script type="text/javascript" src="../common/2018/common2018.js"></script>

<script type="text/javascript">
function init()
{

	document.form.NewFileName.select();
}

function check()
{
	if(isEmpty(document.form.NewFileName,"请输入目录名."))
		return false;

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
</script>
</head>
<body  onload="init();">

	<div class="bg-white modal-box">

		<form name="form" action="renamefolder.jsp" method="post" onSubmit="return check();">

			<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
				<div class="config-box">
					<ul>
						<li class="block">
							<div class="row" style="min-width:80% !important">                   		  	  	
							  <label class="left-fn-title">原目录名：</label>
							  <label class="wd-230"><span><%=FileName%></span></label>									            
							</div>
							<div class="row" style="min-width:80% !important">                   		  	  	
							  <label class="left-fn-title">新目录名：</label>
							  <label class="wd-230">
								<input class="form-control" placeholder="" type="text" name="NewFileName" id="NewFileName"  value="<%=FileName%>" style="width:90%">
							  </label>									            
							</div>
						</li>
					</ul>
				</div>
			</div>

			<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
				<div class="modal-footer" >
					<input type="hidden" name="FolderName" value="<%=FolderName%>">
					<input type="hidden" name="FileName" value="<%=FileName%>">
					<input type="hidden" name="SiteId" value="<%=SiteId%>">
					<button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确认</button>
					<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
				</div> 
			</div>	

			<div id="ajax_script" style="display:none;"></div>
		</form>
	</div>	
</body>
</html>