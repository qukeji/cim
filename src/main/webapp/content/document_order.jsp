<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID		=	getIntParameter(request,"ChannelID");
int		ItemID			=	getIntParameter(request,"ItemID");
int		Direction		=	getIntParameter(request,"Direction");
int		OrderNumber		=	getIntParameter(request,"OrderNumber");

String Submit		=	getParameter(request,"Submit");

if(!Submit.equals("") && ChannelID!=0 && ItemID!=0)
{
	if(Direction==2)
	{
		int	CurrentOrderNumber = getIntParameter(request,"CurrentOrderNumber");
		int Number2 = getIntParameter(request,"Number");
		if(Number2>CurrentOrderNumber)
		{
			OrderNumber = Number2 - CurrentOrderNumber;
			Direction = 1;//向上
		}
		else
		{
			OrderNumber = CurrentOrderNumber - Number2;
			Direction = 0;//向下
		}
	}
	else
		OrderNumber = getIntParameter(request,"Number");
//System.out.println(Direction+":"+OrderNumber);
	Document item = new Document();
	item.Order(ItemID,ChannelID,Direction,OrderNumber);

	response.sendRedirect("../close_pop.jsp");return;
}

Document document = new Document(ItemID,ChannelID);
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language=javascript>
function init()
{
	document.form.Number.focus();
}

function check()
{
	if(isEmpty(document.form.Number,"请输入要移动的行数."))
		return false;
//	if(isEmpty(document.form.FolderName,"请输入目录名."))
//		return false;
//	if(isEmpty(document.form.SerialNo,"请输入唯一标识编码."))
//		return false;

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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<form name="form" action="document_order.jsp" method="post" onSubmit="return check();">
  <tr> 
    <td class="box-tint">
        <table width="100%" border="0" cellspacing="0" cellpadding="6">
          <tr> 
            <td align="right" width="45%">标题：</td>
            <td class="lin28" width="55%"><%=document.getTitle()%> (第<%=OrderNumber%>行)</td>
          </tr>
          <tr> 
            <td align="right" width="45%"> 
              <!--<input type="radio" name="Direction" value="2">
              移动到第<br>-->
              <input type="radio" name="Direction" value="1" checked>
              向上移动<br>
              <input type="radio" name="Direction" value="0">
              向下移动</td>
            <td class="lin28" width="55%"> 
              <input type="text" name="Number" size="5" maxlength="4" value="1">
              行 </td>
          </tr>
        </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray"><input name="Submit" type="submit" class="tidecms_btn3" value="  确  定  ">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn3" value="  取  消  " onclick="self.close();">
	  <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	  <input type="hidden" name="ItemID" value="<%=ItemID%>">
	  <input type="hidden" name="CurrentOrderNumber" value="<%=OrderNumber%>">
	</td>
  </tr>
</form>
</table>
</body>
</html>
