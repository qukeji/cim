<%@ page import="tidemedia.cms.system.*,
		 tidemedia.cms.base.*,
		 java.util.*,
		 java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%! 
	/**
	 *		修改人		日期		备注
	 *
	 *		王海龙		20131112	修改排序功能 改Channel类Order方法为Sort方法 添加排序弹出框代码
	 */
public void Sort(int action, int OrderNumber, int Parent, int id,int step) throws Exception{
	TableUtil tu = new TableUtil();
    TableUtil tu2 = new TableUtil();
    String Sql = "";

    String Symbol1 = "";
    String Symbol2 = "";
    if (action == 1)
    {
      Symbol1 = "<";
      Symbol2 = "desc";
    } else if (action == 0)
    {
      Symbol1 = ">";
      Symbol2 = "asc";
    } else {
      return;
    }
    Sql = "select * from channel where OrderNumber" + Symbol1 + OrderNumber +" and Parent=" + Parent + " order by OrderNumber " +Symbol2;
    ResultSet Rs = tu.executeQuery(Sql);
	int total=0;	
   while(Rs.next()) {	  
      int i = Rs.getInt("id");
      int ordernumber = Rs.getInt("OrderNumber");
	  total++;
	  if(total>step) return ;
	
      Sql = "update channel set OrderNumber=" + OrderNumber + " where id=" + i;
      tu2.executeUpdate(Sql);
      Sql = "update channel set OrderNumber=" + ordernumber + " where id=" + id;
      tu2.executeUpdate(Sql);
	  OrderNumber = ordernumber;
      CmsCache.delChannel(Parent);
    }
    tu.closeRs(Rs);

   
} %>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		ChannelID	= getIntParameter(request,"ChannelID");

int   dir = getIntParameter(request,"Direction");
int   num = getIntParameter(request,"Number");
Channel channel = new Channel(ChannelID);
if(num!=0)
{
	Sort(dir,channel.getOrderNumber(),channel.getParent(),channel.getId(), num);
 	out.println("<script>top.TideDialogClose({refresh:'left'});</script>");return;
} 
%>
<!DOCTYPE html>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" rel="stylesheet" type="text/css">
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

<body onload="init();" scroll="no">
<form name="form" action="channel_order.jsp" method="post" onSubmit="return check();">
<div class="form_main">
        <table width="100%" border="0" cellspacing="0" cellpadding="6">
          <tr> 
            <td align="center" style="width:120px;">
			<div class="line">
              <!--<input type="radio" name="Direction" value="2">
              移动到第<br>-->
              <input type="radio" name="Direction" value="1" checked style="margin:3px 0 0;" id="Direction_up"> <label for="Direction_up">向上移动</label><br>
              <input type="radio" name="Direction" value="0" style="margin:3px 0 0;" id="Direction_down"> <label for="Direction_down">向下移动</label>
			  </div>
			</td>
            <td>
			<div class="line">
              <input type="text" name="Number" size="5" maxlength="4" value="1" id="Number"> <label for="Number">行</label>
			</div>
			</td>
          </tr>
        </table>
</div>
<div class="form_button">
<input name="Submit" type="submit" class="tidecms_btn2" value="  确  定  ">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn2" value="  取  消  " onclick="top.TideDialogClose('');">
	  <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	  
</div>
</form>
</body>
</html>
