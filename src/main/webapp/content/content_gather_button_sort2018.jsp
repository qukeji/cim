<%@ page import="tidemedia.cms.base.*,tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String ids = getParameter(request,"ids");
String order_numbers = getParameter(request,"order_numbers");
int channelid = getIntParameter(request,"channelid");
int LinkChannelID = getIntParameter(request,"LinkChannelID");
int globalid = getIntParameter(request,"globalid");
int Globalid = getIntParameter(request,"Globalid");
String iframe = getParameter(request,"iframe");
String table =  "relation_button";//+channelid+"_"+LinkChannelID;
String Submit = getParameter(request,"Submit");
//System.out.println("ids: "+ids+" orderNumbers: "+ order_numbers+" channelID: "+ channelid+" globalid:"+globalid);
if(channelid>0 && order_numbers.length()>0&&!Submit.equals(""))
{
	int  flag=0;
	List<Integer> list = new ArrayList<Integer>();	  
	int[] ids_ = Util.StringToIntArray(ids,",");           
	for(int i = ids_.length-1;i >= 0;i--){
		//System.out.println("ids元素--------"+ids_[i]);
		list.add(ids_[i]);			 
	}		 
    int Direction = getIntParameter(request,"Direction");
	int Number = getIntParameter(request,"Number");
	if(Direction>0){
		for(int i=0;i<list.size();i++){
			if(Globalid==list.get(i)){
				flag=i;
				list.remove(i);
			}
		}
		if(Number>=(list.size()-flag)){
			list.add(list.size()-1,Globalid);  
		}else if(Number<(list.size()-flag)&&Number>0){
			int chanageNum=flag+Number;
			list.add(chanageNum,Globalid);
		}else{
			out.println("<script>top.TideDialogClose({refresh:'right',frameid:'"+iframe+"'});</script>");
			return;
		}
		 
	}else{
		for(int i=0;i<list.size();i++){
			if(Globalid==list.get(i)){
				flag=i;
				list.remove(i);
			}
		}
		if(Number>=flag){
			list.add(0,Globalid);  
		}else if(Number<flag&&Number>0){
			int chanageNum=flag-Number;
			list.add(chanageNum,Globalid);
		}else{
			out.println("<script>top.TideDialogClose({refresh:'right',frameid:'"+iframe+"'});</script>");
			return;
		}
	}
       	   
	//int[] order_numbers_ = Util.StringToIntArray(order_numbers,",");
	//System.out.println(ids_.length+"="+order_numbers_.length);
	
	Channel channel = CmsCache.getChannel(channelid);
	TableUtil tu = new TableUtil();
	for(int i = 0;i<list.size();i++)
	{
		   
		//String sql = "update " + channel.getTableName()+" set OrderNumber="+order_numbers_[i]+" where id=" + ids_[i];
		String sql = "update " + table +" set OrderNumber="+(i+1) +" where ChildGlobalID=" + list.get(i) +" and GlobalID= "+globalid;
		
		//System.out.println("sql::"+sql);
		int temp = tu.executeUpdate(sql);
		//System.out.println("temp:"+temp);
	}
	

	Document doc = CmsCache.getDocument(globalid);
	PublishManager publishmanager = PublishManager.getInstance();
	if (doc.getStatus()==1) {//状态发生变化或审核通过
		publishmanager.DocumentPublish(doc.getChannel().getId(),doc.getId(),userinfo_session.getId());
	}else{
		publishmanager.OnlyDocumentPublish(doc.getChannel().getId(), doc.getId(),userinfo_session.getId());
	}
	 out.println("<script>top.TideDialogClose({refresh:'right',frameid:'"+iframe+"'});</script>");
	 return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
<meta name="author" content="ThemePixels">
<link rel="Shortcut Icon" href="../favicon.ico">

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
.modal-body-btn .config-box .row .left-fn-title{
	min-width: 70px;
}
</style>  

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

	return true;
}

function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		ddalert(msg,"(function dd(){getDialog().Close({suffix:'html'});})()");
		field.focus();
		return true;
	}
	return false;
}
//alert定制
function ddalert(message,confirm_){
	var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(250);
		dialog.setTitle('提示');
		dialog.setMsg(message);
		dialog.setMsgJs(confirm_);
		dialog.ShowMsg();
}
</script>
</head>

<body onload="init();" scroll="no">
	<div class="bg-white modal-box" >
		<form name="form" action="content_gather_button_sort2018.jsp" method="post" onSubmit="return check();">

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

			<div class="btn-box">
				<div class="modal-footer" >	
				    <input type="hidden" name="Submit" value="Submit">
					<input type="hidden" name="ids" value="<%=ids%>">
					<input type="hidden" name="order_numbers" value="<%=order_numbers%>">
					<input type="hidden" name="Globalid" value="<%=Globalid%>">
					<input type="hidden" name="channelid" value="<%=channelid%>">
					<input type="hidden" name="LinkChannelID" value="<%=LinkChannelID%>">		
					<input type="hidden" name="globalid" value="<%=globalid%>">
					<input type="hidden" name="iframe" value="<%=iframe%>">
					<button type="submit" class="btn btn-primary tx-size-xs" >确定</button>
					<button name="Submit2" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
				</div> 
			</div>
		</form>
	</div>
</body>
</html>
