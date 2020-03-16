<%@ page import="tidemedia.cms.system.*,
		 tidemedia.cms.base.*,
		 java.util.*,
		 java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int	  ChannelID	= getIntParameter(request,"ChannelID");
int   ItemID   = getIntParameter(request,"ItemID");
int   classNum   = getIntParameter(request,"classNum");
int   GroupID   = getIntParameter(request,"GroupID");
int   GroupNum   = getIntParameter(request,"GroupNum");
int		Direction		=	getIntParameter(request,"Direction");
int		FieldSortNumber		=	getIntParameter(request,"FieldSortNumber");
String SubmitFieldSort		=	getParameter(request,"SubmitFieldSort");

if(!SubmitFieldSort.equals("") && ChannelID>0 && ItemID>0)
{	
    Channel channel = CmsCache.getChannel(ChannelID);
	ArrayList fieldGroupArray = channel.getFieldGroupInfo();
	ArrayList arraylist = channel.getFieldsByGroup(GroupID ,GroupNum );
	int fieldSort=0;
	if(Direction==1){
         fieldSort=classNum-1-FieldSortNumber;
		 if(fieldSort<0){
			 fieldSort=0;
		 }
		Field field = (Field) arraylist.get(fieldSort);		
		int fid = field.getId();
		Field field_ = new Field(ItemID);//System.out.println(id);
	     field_.Order(fid);
	}
	if(Direction==0){
         fieldSort=classNum+FieldSortNumber;
		 if(fieldSort>=arraylist.size()){
			 fieldSort=arraylist.size()-1;
		 }
		Field field = (Field) arraylist.get(fieldSort);		
		int fid = field.getId();
		Field field_ = new Field(ItemID);//System.out.println(id);
	     field_.Order(fid);
	}                  
	out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});</script>");return;
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
//	
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
     <form name="form" action="field_order2018.jsp" method="post" onSubmit="return check();">     
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
							<input class="form-control" placeholder="" type="text" name="FieldSortNumber" size="5" maxlength="4" value="1" id="Number">
						</label>
						<label class="mg-l-5">行</label>	
					</div>
				</div>
			</div>	  
		  <div class="btn-box">
			<div class="modal-footer" >
				    <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
					<input type="hidden" name="ItemID" value="<%=ItemID%>">	
                    <input type="hidden" name="classNum" value="<%=classNum%>">
                    <input type="hidden" name="GroupID" value="<%=GroupID%>">	
                     <input type="hidden" name="GroupNum" value="<%=GroupNum%>">						
				    <input type="hidden" name="SubmitFieldSort" value="SubmitFieldSort">
				  <button name="Submit" type="submit" class="btn btn-primary tx-size-xs" >确定</button>
				  <button name="Submit2" type="button" onclick="top.TideDialogClose('_2');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
			 </div> 
		  </div>	   
    </form>	
    </div>  
  </body>
</html>
