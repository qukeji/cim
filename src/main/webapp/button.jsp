<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript">
function switch_(){
	if (switchbtn.innerText=="3"){
		parent.main1.cols = "0,18,*";
		switchbtn.innerText="4";
		switchbtn.title="打开导航";
	}
	else{
		parent.main1.cols = "104,18,*";
		switchbtn.innerText="3";
		switchbtn.title="关闭导航";
	}
}
</script>
</head>

<body border="none" style="margin:0px;background:buttonface;border:none;"><table height=100%><tr><td valign="middle">
<font face="Marlett"><span id="switchbtn" style="cursor:hand" onclick="switch_();" title="关闭导航">3</span></font>
</td></tr></table>
</body>

</html>
