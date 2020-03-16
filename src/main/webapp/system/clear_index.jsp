<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<!DOCTYPE html>  
<html lang="en">  
<head>  
<meta charset="UTF-8">  
<title>Login</title>  
<link href="../style/9/tidecms.css" rel="stylesheet" type="text/css">
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>

<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script type="text/javascript" src="../common/jquery-ui-timepicker-addon.js"></script>

<script>	
	function submit_(type){
		var channelid = $('#channelid').val();
		var channelname = $('#channelname').val();
		var Status =$("input[name='Status']:checked").val();
		var start = $('#start').val();
		var end = $('#end').val();

		if(end==""||start==""){
			alert("开始时间以及结束时间必须填写");
			return;
		}
		if(channelid==0||channelname==""){
			alert("请填写对应的频道id和频道名");
			return;
		}
		if(Status==undefined){
			alert("请选择文件状态");
			return;
		}
		if(Status==-1&&type==2){
			alert("请选择已发状态进行撤稿");
		}else{
			$.ajax({
				type: "GET",
				url: "./clear_document.jsp?channelid="+channelid +"&channelname="+channelname+"&start="+start+"&end="+end+"&type="+type+"&Status="+Status,
				success: function(msg){
					var data = msg.trim();
					if(data=="没有这个频道"){
						alert(data);
					}else if(data=="该频道名字与频道id不符"){
							alert(data);
					}else{
						if(confirm(data))
						{
							window.open("./clear_document.jsp?channelid="+channelid +"&start="+start+"&end="+end+"&confirm=true&type="+type+"&Status="+Status);
						}
					}
				 }   
			}); 
		}		
	}
</script>
</head>  
<body>  
	<form name="form" action="" method="post">
		<div class="form_main">
			<table width="100%" border="0" cellspacing="0" cellpadding="6">
				<tr>
					<td style="text-align: right;">频道名:</td>
					<td><input type="text" required="required" name="channelname" id="channelname"></input></td>
				</tr>
				<tr>
					<td style="text-align: right;">频道id:</td>
					<td><input type="text" required="required" name="channelid" id="channelid"></input></td>
				</tr>
				<tr>
					<td style="text-align: right;">文章状态:</td>
					<td><input type="radio" name="Status" value="-1"> <label>草稿</label>
						<input type="radio" name="Status" value="1"> <label>已发</label>
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">开始时间:</td>
					<td></div><input type="text" id="start" name="start" ></input></td>
				</tr>
				<tr>
					<td style="text-align: right;">结束时间:</td>
					<td><input type="text" id="end" name="end" ></input></td>
				</tr>
			</table>
		</div>
		<div class="form_button">
			<input name="startButton" type="button" class="tidecms_btn2" value="  删  除  " onclick="submit_(1);">
			&nbsp; 
			<input name="startButton" type="button" class="tidecms_btn2" value="  撤  稿  " onclick="submit_(2);">
			&nbsp; 
			<input name="Submit2" type="button" class="tidecms_btn2" value="  取  消  " onclick="top.TideDialogClose('');">
		</div>
	</form>  
</body>  
 <script>
	$('#start').datetimepicker({
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
	$('#end').datetimepicker({
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
</script>
</html>