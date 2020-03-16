<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
String Name = getParameter(request,"Name");
int SiteType = getIntParameter(request,"SiteType");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

if(!Name.equals(""))
{
	/*out.println("<script>var dialog = new top.TideDialog();dialog.showAlert(\"站点新建中，请耐心等待...\",\"info\",10000);</script>");*/
	Site site = new Site();
	site.setName(Name);
	site.setSiteType(SiteType);
    site.setActionUser(userinfo_session.getId());
	site.setCompany(userinfo_session.getCompany());
	site.Add();

	out.println("<script>top.TideDialogClose({refresh:'left',returnValue:{close:2},returnNavValue:{currentid:0,parentid:-1,type:1,site:true}});</script>");
	//out.println("<script>top.TideDialogClose({refresh:'left'});</script>");
	return;
}
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS 7 列表</title>
    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <!--<link href="../../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">-->
    <!--<link href="../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">-->   
    <!--<link href="../lib/highlightjs/github.css" rel="stylesheet">-->   
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">   
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
	<script type="text/javascript" src="../common/common.js"></script>
	<script src="../lib/2018/jquery/jquery.js"></script>
<script language=javascript>
function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;

	document.form.submitButton.disabled  = true;
	var dialog = new top.TideDialog();dialog.showAlert("站点新建中，请耐心等待...","info");
	return true;
}
$(function () {

	$("input[type=radio][name=SiteType]").click(function () {
		var value1 = $(this).val();
		if(value1==0){
			$("#desc1").css("display","");
			$("#desc2").css("display","none");
			$("#desc3").css("display","none");
		}else if(value1==1){
			$("#desc1").css("display","none");
			$("#desc2").css("display","");
			$("#desc3").css("display","none");
		}else if(value1==2){
			$("#desc1").css("display","none");
			$("#desc2").css("display","none");
			$("#desc3").css("display","");
		}
	})
})
</script>
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	.modal-body-btn .config-box .row .left-fn-title{
  		min-width: 70px;
  	}
</style>
 </head>
  <body class="">
    <div class="bg-white modal-box">
    <form name="form" action="site_add2018.jsp" method="post" onSubmit="return check();">
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box mg-t-15">	       	  
	   		  	<div class="row">                   		  	  	
		  	  		<label class="left-fn-title">站点名称：</label>
					<label class="wd-230">
		                <input class="form-control" placeholder="" type="text" name="Name" size="20">
					</label>									            
	   		  	</div>
				<div class="row">                  		  	  	
					<label class="left-fn-title"></label>
					<label class="rdiobox">
						<input type="radio" name="SiteType" value="0" checked=""><span class="d-inline-block">其他</span>
					</label>
					<label class="rdiobox">
						<input type="radio" name="SiteType" value="1"><span class="d-inline-block">APP</span>
					</label>
					<label class="rdiobox">
						<input type="radio" name="SiteType" value="2"><span class="d-inline-block">网站</span>
					</label>
				</div>
				<div class="row"  id="desc1">
					<label class="left-fn-title"></label>
					<label>
						<span class="d-inline-block">说明：其他站点为普通站点。</span>
					</label>
				</div>
				<div class="row" style="display: none" id="desc2">
					<label class="left-fn-title"></label>
					<label>
						<span class="d-inline-block">说明：新建app站点后，可在app管理系统中查看和维护相关站点数据。</span>
					</label>
				</div>
				<div class="row" style="display: none" id="desc3">
					<label class="left-fn-title"></label>
					<label>
						<span class="d-inline-block">说明：新建网站站点后，可在网站管理系统中查看和维护相关站点数据。</span>
					</label>
				</div>
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		      <button type="submit" class="btn btn-primary tx-size-xs" name="submitButton" id="submitButton">确认</button>
		      <button type="button" onclick="top.TideDialogClose('');"  name="btnCancel1"  id="btnCancel1"  class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		 </div> 
      </div>
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->    
  </body>
</html>
