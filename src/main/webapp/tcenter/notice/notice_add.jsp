<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.text.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int renewalsdata = 2;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
java.util.Date now = new java.util.Date();
Calendar calendar = Calendar.getInstance();
calendar.setTime(now);
calendar.add(Calendar.MONTH, renewalsdata);
String duetime = sdf.format(calendar.getTime());

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Title		= getParameter(request,"Title");
	String	StartDate	= getParameter(request,"StartDate");
	String	EndDate	= getParameter(request,"EndDate");

	Notice notice = new Notice();
	notice.setTitle(Title);//标题
	notice.setEndDate(EndDate);//结束时间
	notice.setStartDate(StartDate);//开始时间
	notice.setUserId(userinfo_session.getId());//操作人
	notice.Add();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}
%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
<link rel="stylesheet"  type="text/css" href="../style/timepicker/jquery-ui-timepicker-addon.css" />  
<link rel="stylesheet" href="../style/2018/common.css">	
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/theme/theme.css">
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
</style>  
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script type="text/javascript" src="../common/jquery-ui-timepicker-addon.js"></script><script type="text/javascript">
	
	$(document).ready(function() {
		$(".date").datetimepicker({
			timeText: '时间',  
			hourText: '小时',  
			minuteText: '分钟',  
			secondText: '秒',  
			currentText: '现在',  
			closeText: '完成',  
			showSecond: true, //显示秒  
			dateFormat:"yy-mm-dd",
			timeFormat: 'HH:mm:ss',//格式化时间  
			monthNames: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],  
			dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],  
			dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],  
			dayNamesMin: ['日','一','二','三','四','五','六']
		});
	});

	function check()
	{
		if(isEmpty(document.form.Title,"标题不能为空."))
			return false;
		if(isEmpty(document.form.StartDate,"开始时间不能为空."))
			return false;
		if(isEmpty(document.form.EndDate,"结束时间不能为空."))
			return false;
		if(tab(document.form.StartDate.value,document.form.EndDate.value))
			return false;
		return true;
	}

	function tab(date1,date2){
		var oDate1 = new Date(date1);
		var oDate2 = new Date(date2);
		if(oDate1.getTime() >= oDate2.getTime()){
			alert("开始时间应小于结束时间");
			return true ;
		} 
		return false ;
	}

</script>
  
</head>

<body class="" >
    <div class="bg-white modal-box">
	  <form name="form" action="notice_add.jsp" method="POST" onSubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	  <!--基本信息-->
	       		  <li class="block">
				 
					<div class="row">                   		  	  	
						<label class="left-fn-title">标题：</label>
						<label class="wd-300">
							<input name="Title" class="form-control" placeholder="" type="text">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">开始时间：</label>
						<label class="wd-300" >
							<input value="<%=duetime%>" id="StartDate" name="StartDate" class="date form-control" placeholder="" type="text" >
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">结束时间：</label>
						<label class="wd-300" >
							<input value="<%=duetime%>" id="EndDate" name="EndDate" class="date form-control" placeholder="" type="text" >
						</label>									            
					</div>

				  </li>      	    
	       	  </ul>             	
	        </div>	                   
		</div><!-- modal-body -->
		<div class="btn-box">
      		<div class="modal-footer" >
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		      <input type="hidden" name="Submit" value="Submit">
			</div> 
		</div>
		<div id="ajax_script" style="display:none;"></div> 
	  </form>	     
	</div><!-- br-mainpanel -->
</body>
</html>