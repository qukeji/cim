<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="javax.print.Doc" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	/**
	 *   名字            日期             备注
	 *
	 *  wanghailong      20140424         判断是否包含子频道
	 *
	 */
	int		ChannelID		=	getIntParameter(request,"ChannelID");
	int		ItemID			=	getIntParameter(request,"ItemID");
	int		Direction		=	getIntParameter(request,"Direction");
	int		OrderNumber		=	getIntParameter(request,"OrderNumber");

	String Submit		=	getParameter(request,"Submit");
	String url="document_sort.jsp";
	int DocTop=0;
	if(!Submit.equals("") && ChannelID!=0 && ItemID!=0)
	{
		Channel channel = CmsCache.getChannel(ChannelID);
		//包含子频道
		boolean includesub = true;
		int IsListAll = channel.getIsListAll();
		if(IsListAll==0)
			includesub = false;

		if(Direction==2)
		
		{
		    System.out.println("这里没有执行");
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
		}else
			OrderNumber = getIntParameter(request,"Number");
         System.out.println("果然没有");
		Document item = new Document();
		item.setUser(userinfo_session.getId());
		item.Order(ItemID,ChannelID,Direction,OrderNumber,includesub);

    
	Document document = new Document(ItemID,ChannelID);

	
		out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}
	Channel channel = CmsCache.getChannel(ChannelID);

	String doc_sql="select Title,DocTop from "+channel.getTableName();
	String wheresql_now=" where Active=1 ";
	if(channel.getType()==channel.Category_Type){
		wheresql_now +=" and Category=" + channel.getId();
	}
	wheresql_now+=" and id="+ItemID;
	TableUtil tu_doc=new TableUtil();
	System.out.println("DocTopvalue:"+doc_sql+wheresql_now);
	ResultSet rs_doc=tu_doc.executeQuery(doc_sql+wheresql_now);
	String title="";
	if (rs_doc.next()){
		DocTop=rs_doc.getInt("DocTop");
		title=rs_doc.getString("Title");
	}
	if (DocTop>0){
		url="top_sort.jsp";
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
		var doc=<%=DocTop%>;
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
	<form name="form" action="<%=url%>" method="post" onSubmit="return check();">

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
				<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
				<input type="hidden" name="ItemID" value="<%=ItemID%>">
				<input type="hidden" name="CurrentOrderNumber" value="<%=OrderNumber%>">
				<button name="Submit" type="submit" class="btn btn-primary tx-size-xs" value="Submit">确定</button>
				<button name="Submit2" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
			</div>
		</div>
	</form>
</div>
</body>
</html>
