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
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int		ChannelID	= getIntParameter(request,"ChannelID");

int   dir = getIntParameter(request,"Direction");
int   num = getIntParameter(request,"Number");
Channel channel = new Channel(ChannelID);
if(num!=0)
{
	Sort(dir,channel.getOrderNumber(),channel.getParent(),channel.getId(), num);
	Channel channelParent = new Channel(channel.getParent());
	if(channel.getParent()==-1){
		out.println("<script>top.TideDialogClose({refresh:'left',returnNavValue:{currentid:"+channel.getId()+",parentid:-1,type:3,site:true}});</script>");return;
	}else if(channelParent.getParent()==-1){
		out.println("<script>top.TideDialogClose({refresh:'left',returnNavValue:{currentid:"+channel.getId()+",parentid:"+channel.getParent()+",type:3,site:true}});</script>");return;
	}else{
 	out.println("<script>top.TideDialogClose({refresh:'left',returnNavValue:{currentid:"+channel.getId()+",parentid:"+channel.getParent()+",type:3,site:false}});</script>");return;

	} 
}
%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
	 <script src="../lib/2018/jquery/jquery.js"></script>
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
  <body class="" onload="init();" scroll="no" >
    <div class="bg-white modal-box" >
     <form name="form" action="channel_order2018.jsp" method="post" onSubmit="return check();">     
      <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
				<div class="config-box">
					<div class="row"> 
						<label>
							<label class="rdiobox">
								<input type="radio"name="Direction" value="1" checked id="Direction_up" ><span class="d-inline-block">向上移动</span>
							</label>
							<label class="rdiobox">
								<input type="radio" name="Direction" value="0" id="Direction_down" ><span class="d-inline-block">向下移动</span>
							</label>
						</label>
						<label class="wd-100 mg-l-5">
							<input class="form-control" placeholder="" type="text" name="Number" size="5" maxlength="4" value="1" id="Number">
						</label>
						<label class="mg-l-5">行</label>	
					</div>
				</div>
			</div>	  
		  <div class="btn-box">
			<div class="modal-footer" >
				   <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
				  <input type="hidden" name="Submit" value="Submit">
				  <button name="Submit" type="submit" class="btn btn-primary tx-size-xs" >确定</button>
				  <button name="Submit2" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
			 </div> 
		  </div>	   
</form>
</div>
</body>
<html>   