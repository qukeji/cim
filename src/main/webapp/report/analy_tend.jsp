<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.report.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
   int id = getIntParameter(request,"id");
   String dateWay = getParameter(request,"dateWay");
   String type_s = getParameter(request,"type");
   String json = ReportUtil.getReportChart(id,dateWay,type_s);  
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<link href="../style/9/tidecms.css" rel="stylesheet" />

<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/highcharts.js"></script>
<script type="text/javascript" src="../common/exporting.js"></script>
<script>
 
function loadChart(aseriesData,xaxis,name){
	 
	var charts ;
	//引用图表插件
	charts = new Highcharts.Chart({
		chart :{
			renderTo:'container',
			defaultSeriesType:'line',
			marginRight:130,
			marginBottom:25
		},
		title:{
			text:name+'工作量统计',
			x:-20
		},
		xAxis:{
			categories:xaxis,
			tickPixeInterval:10,
			labels:{step:1}
		},
		yAxis: {
			title: {
				text: ''
			},
		plotLines: [{
			value: 0,
			width: 1,
			color: '#808080'
		}]
		},
		tooltip: {
			shared: true,
			crosshairs: true
		},
		plotOptions: {
            series: {
				cursor: 'pointer',
				marker: {
					enabled: false,
					symbol: 'circle',
					radius: 2,
					states: {
						hover: {
							enabled: true
						}
					}
				}
			}
		},
		
		legend: {
			layout: 'vertical',
			align: 'right',
			verticalAlign: 'top',
			x: -10,
			y: 100,
			borderWidth: 0
		},
		series: aseriesData
	});
}

$(function(){
	var obj = $.parseJSON('<%=json%>');
	var aseriesData = [];
	var xaxis = obj.xaxis; 
	<%
	    String s ="";
	    if(dateWay.equalsIgnoreCase("today")){
			s ="今天工作量统计";
		}else if(dateWay.equalsIgnoreCase("week")){
			s ="本周工作量统计";
		}else if(dateWay.equalsIgnoreCase("month")){
			s = "本月工作量统计";
		}else if(dateWay.equalsIgnoreCase("year")){
			s ="本年工作量统计";
		}else{
			s = "工作量统计";
		}
	%>
	var ips = {name:'<%=s%>',data:obj.value};
	aseriesData[0]= ips;
	loadChart(aseriesData,xaxis,obj.name);
});
	
 

</script>

</head>
<body >
<div class="content_2012">
    <div class="center">
	<table width="100%" border="0" id="oTable" class="view_table"> 
		<thead>
	</thead>
	<tbody>
		<tr id="analy_data">
		</tr>
		<tr>
			<td colspan="8">
				<div id="container" style="height:300px;">
				</div>
			</td>
		</tr>
	</tbody>
    </table>
    
    </div>

</div>
</body>
</html>
