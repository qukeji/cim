<%@ page import="tidemedia.cms.system.*,
		 tidemedia.cms.base.*,
		 java.util.*,
		 java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%! 
	 
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
    Sql = "select * from template_group where OrderNumber" + Symbol1 + OrderNumber +" and Parent=" + Parent + " order by OrderNumber " +Symbol2;
    ResultSet Rs = tu.executeQuery(Sql);
	System.out.println(Sql+"==sql");
	int total=0;	
   while(Rs.next()) {	  
      int i = Rs.getInt("id");
      int ordernumber = Rs.getInt("OrderNumber");
	  total++;
	  System.out.println(total+">"+step+"=="+i);
	  if(total>step) return ;
	
      Sql = "update template_group set OrderNumber=" + OrderNumber + " where id=" + i;
      int tt = tu2.executeUpdate(Sql);
	 	System.out.println(Sql+"==sqlt"+tt);
      Sql = "update template_group set OrderNumber=" + ordernumber + " where id=" + id;

      int ttt = tu2.executeUpdate(Sql);
	   	System.out.println(Sql+"==sqltt"+ttt);
	  OrderNumber = ordernumber;
      CmsCache.delChannel(Parent);
    }
    tu.closeRs(Rs);

   
} %>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int		GroupID	= getIntParameter(request,"GroupID");

int   dir = getIntParameter(request,"Direction");
int   num = getIntParameter(request,"Number");
TemplateGroup Group  = new TemplateGroup(GroupID);
if(num!=0)
{
	Sort(dir,Group.getOrderNumber(),Group.getParent(),Group.getId(), num);

 	out.println("<script>top.TideDialogClose({refresh:'left',returnNavValue:{group:'"+GroupID+"',SuperGroup:"+Group.getParent()+"}});</script>");
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

<body onload="init();">
	
	<div class="bg-white modal-box">
		<form name="form" action="group_order.jsp" method="post" onSubmit="return check();">
			<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
				<div class="config-box">
					<div class="row"> 
						<label>
							<label class="rdiobox">
								<input type="radio"name="Direction" value="1" checked id="Direction_up" ><span>向上移动</span>
							</label>
							<label class="rdiobox">
								<input type="radio" name="Direction" value="0" id="Direction_down" ><span>向下移动</span>
							</label>
						</label>
						<label class="wd-100 mg-l-5">
							<input class="form-control" placeholder="" type="text" name="Number" size="5" maxlength="4" value="1" id="Number">
						</label>
						<label class="mg-l-5">行</label>	
					</div>
				</div>
			</div>
			<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
				<div class="modal-footer" >
					<input type="hidden" name="GroupID" value="<%=GroupID%>">
					<button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确认</button>
					<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
				</div> 
			</div>	
		</form>
	</div>
</body>
</html>
