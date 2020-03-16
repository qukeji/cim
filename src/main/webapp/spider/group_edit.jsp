<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.spider.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
String Name =getParameter(request,"Name");
 int GroupID = getIntParameter(request,"GroupID");
	SpiderGroup group = new SpiderGroup();
if(GroupID!=0){
	 group = new SpiderGroup(GroupID);
}
if(!Name.equals(""))
{
	group.setName(Name);
	group.Update();

	out.println("<script>top.TideDialogClose({refresh:'left'});</script>");return;
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
document.form.Name.focus();
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
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

		<form name="form" action="group_edit.jsp" method="post" onSubmit="return check();">

			<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
				<div class="config-box">
					<ul>
						<li class="block">
							<div class="row" style="min-width:80% !important">                   		  	  	
							  <label class="left-fn-title">上级组：</label>
							  <label class="wd-230"><span><%=group.getParentName()%></span></label>									            
							</div>
							<div class="row" style="min-width:80% !important">                   		  	  	
							  <label class="left-fn-title">名称：</label>
							  <label class="wd-230">
								<input class="form-control" placeholder="" type="text" id="Name" name="Name" value="<%=group.getName()%>" style="width:90%">
							  </label>									            
							</div>
						</li>
					</ul>
				</div>
			</div>

			<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
				<div class="modal-footer" >
					<input type="hidden" name="GroupID" value="<%=GroupID%>">
					<button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确认</button>
					<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
				</div> 
			</div>	

			<div id="ajax_script" style="display:none;"></div>
			
		</form>
	</div>	
</body>
</html>
