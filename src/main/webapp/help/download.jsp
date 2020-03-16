<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	String type = getParameter(request,"type");//下载类型
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script>
function check(){
var password=$("#password").val();
var type_=$('#type').val();
    if(password==""){
		alert("请输入密码……");
        return false;
    }else{
		$.ajax({
         type: "POST",
         url:"http://www.tidecms.com/doc/download.php",
         data:$('#form').serialize(),
		 dataType: 'JSONP',
		 jsonp:'callback', 
         success: function(result) {
			
			 var result_=eval(result);
		     if(result_.status==0){		
				alert(result_.message);		
			 }else if(result_.status==1){
				download_file(password,1,type_);
			 }
	
		 }
     });
       
    }
}
function download_file(password,flag,type){
	$('#download_password').val(password);
	document.getElementById("download").submit();
	//var url="http://www.tidecms.com/doc/download.php?type="+type+"&flag="+flag+"&password="+password+"";
	//window.open(url);
}
</script>

</head>

<body>

<form name="form" id="form">

<input type="hidden" value="<%=type%>" id="type" name="type">
<input type="hidden" value="0" id="flag" name="flag">
<br/>

请输入下载密码：<input type="password" id="password" name="password" >

<div class="form_button">
<input type="button" onclick="javascript:check()"  class="tidecms_btn2" value="确定"/>
<input type="button" onclick="top.TideDialogClose('');" class="tidecms_btn2"  value="取消"/>
</div>
</form>

<form name="download" action="http://www.tidecms.com/doc/download.php" id="download" method="post">
	<input type="hidden" value="<%=type%>"  name="type">
	<input type="hidden" value="1"  name="flag">
	<input type="hidden" name="password" id="download_password" >
</form>

</body>

</html>
