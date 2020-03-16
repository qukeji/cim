<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu</title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<style type="text/css">
html,body {
	margin:0;
	height:100%;
}
</style>
<script languange="javascript">
function init()
{
	window.onresize=reSize;
	reSize();
}

function reSize() 
{
	document.getElementById("div1").style.height = document.getElementById("td1").clientHeight-20;
	//alert(document.getElementById("div1").style.height);
}
</script>
</head>

<body onLoad="init();">
<table width="100%" height="100%" class="box-gray" border="0">
  <tr height="100%" id="a1">
    <td height="100%" valign="top" id="td1">
    	<div class="top"></div>
        <div class="menu-main">
        	<div class="menu-main-box" id="div1">
<iframe frameborder=0 scrolling=auto src="channel_tree.jsp" style=height:100%;visibility:inherit;width:100%;></iframe>
            </div>
        </div>
        <div class="bottom"></div>
    </td>
    <td align="center" valign="middle"><a href="#"><img src="../images/menu_right.png" /></a></td>
  </tr>
</table>
</body>
</html>
