<%@ page import="org.apache.axis.client.*,tidemedia.cms.base.*,java.sql.*,tidemedia.cms.system.*,net.sf.ehcache.*,tidemedia.cms.util.*,java.text.*,java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int flag = getIntParameter(request,"flag");

if(flag==1)
{
CacheManager cm = CacheManager.create();
Cache cc = cm.getCache("sampleCache1");
String key = "getchannel_" + Util.getCurrentDate("yyyy_MM_dd_HH");
int n = CacheUtil.getIntValue(key);
out.println(key+":"+n+"    "+(n/3600)+"/秒<br>");
key = "executeupdate_" + Util.getCurrentDate("yyyy_MM_dd_HH");
n = CacheUtil.getIntValue(key);
out.println(key+":"+n+"    "+(n/3600)+"/秒<br>");
key = "executequery_" + Util.getCurrentDate("yyyy_MM_dd_HH");
n = CacheUtil.getIntValue(key);
out.println(key+":"+n+"    "+(n/3600)+"/秒<br>");
key = "createconnnection_" + Util.getCurrentDate("yyyy_MM_dd_HH");
n = CacheUtil.getIntValue(key);
out.println(key+":"+n+"    "+(n/3600)+"/秒<br>");
}
else if(flag==2)
{
	CmsCache.ehcache = true;
	response.sendRedirect("show_ehcache.jsp");
	return;
}
else if(flag==3)
{
	CmsCache.ehcache = false;
	response.sendRedirect("show_ehcache.jsp");
	return;
}
else
{

String data = "";
String categories = "";

String pattern = "yyyy_MM_dd_HH";
java.util.Calendar nowDate = new java.util.GregorianCalendar();
DateFormat df = new SimpleDateFormat(pattern);

nowDate.add(Calendar.HOUR_OF_DAY,-50);

for(int i = 0;i<50;i++)
{
	nowDate.add(Calendar.HOUR_OF_DAY,1);
	String ss = df.format(nowDate.getTime());
	
	String s = "getchannel_" + ss;
	int n = CacheUtil.getIntValue(s);

	ss = nowDate.get(Calendar.HOUR_OF_DAY)+"";
	if(ss.equals("0"))
		ss = (nowDate.get(Calendar.MONTH)+1)+"."+nowDate.get(Calendar.DAY_OF_MONTH)+"";
	categories += ((categories.length()>0)?",":"") + "'" + ss + "'";
	data += ((data.length()>0)?",":"") + n;
	//out.println(s+":"+n+"    "+(n/3600)+"/秒<br>");
}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="../common/jquery.js"></script>

<script type="text/javascript" src="../common/highcharts.js"></script>
<script type="text/javascript">
		
			var chart;
			$(document).ready(function() {
				chart = new Highcharts.Chart({
					chart: {
						renderTo: 'container',
						defaultSeriesType: 'line',
						marginRight: 130,
						marginBottom: 25
					},
					title: {
						text: 'Monthly Average Temperature',
						x: -20 //center
					},
					subtitle: {
						text: 'Source: WorldClimate.com',
						x: -20
					},
					xAxis: {
						categories: [<%=categories%>]
					},
					yAxis: {
						title: {
							text: 'Temperature (°C)'
						},
						plotLines: [{
							value: 0,
							width: 1,
							color: '#808080'
						}]
					},
					tooltip: {
						formatter: function() {
				                return '<b>'+ this.series.name +'</b><br/>'+
								this.x +': '+ this.y +'';
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
					series: [{
						name: 'getchannel',
						data: [<%=data%>]
					}]
				});
				
				
			});
				
		</script>

</head>
<body>
cache状态：<%=CmsCache.ehcache%> <%if(!CmsCache.ehcache){%><a href="show_ehcache.jsp?flag=2">打开</a><%}else{%><a href="show_ehcache.jsp?flag=3">关闭</a><%}%>
<div id="msg"></div>
<%=CacheUtil.getCache().getStatistics()%>
<script>
function load()
	{
		$("#msg").load("show_ehcache.jsp?flag=1"); 
	}
setInterval(load, 500);
</script>

<div id="container" style="width: 1200px; height: 500px; margin: 0 auto"></div>
<div id="showtable">
<%
	nowDate.add(Calendar.HOUR_OF_DAY,-120);
	out.print("<table id='showinfo' cellpadding='0' cellspacing='0' align='center' style='background:#d3e5fd;text-align:center;'><tr><td>日期</td><td>getchannel</td><td>executeupdate</td><td>executequery</td><td>createconnnection</td></tr>");
	for(int i = 0;i<120;i++)
	{
		out.print("<tr>");
		nowDate.add(Calendar.HOUR_OF_DAY,1);
		String ss2 = df.format(nowDate.getTime());
		String s2 = "getchannel_" + ss2;
		int n2 = CacheUtil.getIntValue(s2);
		String datetime = nowDate.get(Calendar.YEAR)+"-"+(nowDate.get(Calendar.MONTH)+1)+"-"+(nowDate.get(Calendar.DATE))+" "+nowDate.get(Calendar.HOUR_OF_DAY)+"";

		//if(ss2.equals("0"))
		//	ss2 = (nowDate.get(Calendar.MONTH)+1)+"."+nowDate.get(Calendar.DAY_OF_MONTH)+"";
		
		out.print("<td style='border:1px solid #FFF'>"+datetime+"</td>"+"<td style='border:1px solid #FFF'>"+n2+" "+"("+(n2/3600)+"/秒)"+"</td>");

		s2= "executeupdate_"+ss2;
		n2 = CacheUtil.getIntValue(s2);
//		out.println(n2);
		out.print("<td style='border:1px solid #FFF'>"+n2+" "+"("+(n2/3600)+"/秒)"+"</td>");

		s2 = "executequery_"+ss2;
		n2 = CacheUtil.getIntValue(s2);
		out.print("<td style='border:1px solid #FFF'>"+n2+" "+"("+(n2/3600)+"/秒)"+"</td>");

		s2 = "createconnnection_"+ss2;
		n2 = CacheUtil.getIntValue(s2);
		out.print("<td style='border:1px solid #FFF'>"+n2+" "+"("+(n2/3600)+"/秒)"+"</td>");

		
		//out.println("===="+s2+":"+n2+"    "+(n2/3600)+"/秒<br>");
		out.print("</tr>");
	}
	out.print("</table>");
%>
</div>

</body>

</html>
<%
}
%>
