<%@ page contentType="text/html;charset=utf-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script>
win = "on";
function switchSysBar() {
	if (win == "on") {
		win = "off";
		parent.mainFrm.cols= "16,*"
		arrowheadfont.innerText="4";
		document.all("leftFrm").style.display = "none";
	} else {
		win = "on";
		parent.mainFrm.cols= "180,*"
		arrowheadfont.innerText="3";
		document.all("leftFrm").style.display = "";
	}
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="box-gray">
  <tr> 
    <td height="36" align="center" class="font-14"><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="6" align="center"></td>
          <td align="left">个人设置</td>
          <td width="8"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="center" valign="top"><table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="6" align="center" valign="top"></td>
          <td align="center" valign="top" class="box-white" id="leftFrm"><iframe frameborder=0 scrolling=no src="tree.jsp" style="height:100%;visibility:inherit;width:100%;"></iframe></td>
          <td width="8" align="center" valign="middle">
		    <table width="100%" height="56" border="0" cellpadding="0" cellspacing="0" bgcolor="#C4C8D2">
              <tr>
                <td align="center" id="switchLeft"  onMouseOver="style.background='#00ccff';style.cursor='hand'" onMouseOut="style.background='#C4C8D2'" onClick=switchSysBar()><font face="Marlett"  color="#ffffff" size="1"><span id="arrowheadfont">3</span></font></td>
              </tr>
            </table>
          </td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="8" align="center" valign="top"></td>
  </tr>
</table>
</body>
</html>
