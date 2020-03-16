<%@ include file="../config.jsp"%>
<%
int gid_ =getIntParameter(request,"globalid");
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Highcharts Example</title>
<script type="text/javascript" src="../ums/js/jquery.js"></script>
<script type="text/javascript"> 
	var gid=<%=gid_%>;
	sHref = window.location.href;
	//alert(sHref);
	var args = sHref.split("?");
	//alert(args[1]);
	var args=args[1].split("=");
	//alert(args[1]);
         gid=args[1];
</script>
<script type="text/javascript">
   //定义全局的options,并将其初始化
 
   var options={
            chart: {
                renderTo: 'container',
                type: 'line',
                spacingBottom: 30
            },
            title: {
                text: ''
            },

            legend: {
              enabled:false
            },
            xAxis: {
				categories:[]
                //categories: ['Apples', 'Pears', 'Oranges', 'Bananas', 'Grapes', 'Plums', 'Strawberries',"silly"]
            },
            yAxis: {
                title:""
            },
            tooltip: {
                formatter: function() {
                    return '<b>'+this.y +'</b>'+'<br/>'+ this.x;
                }
            },
            plotOptions: {
                area: {
                    fillOpacity: 0.5
                }
            },
            credits: {
                enabled: false
            },
            series: []
        }
    var  series=[{
               // name: 'John',
			   name : null,
			   
               data : []
    }];
	//图表全局变量
    var chart;
	//定义全局接受变量x,y;
	var x;
	var y;
	//
   $(function () {
		var url_ = "../ums/visitchart.jsp?gid="+gid;
//		alert(url_);
        if(gid!=0){
		$.ajax({
				type:"GET", 
				url:url_,
				dataType : "json",
				//jsonp: 'callback',
				success:function(json){
//					alert(json);
					x=json.x;
					//alert(x);
					y=json.y;
					var yy = new Array();
					for(var i=0;i<y.length;i++){
					   yy.push(parseInt(y[i]));
					}
					//alert(y);							
		            series[0].name=" ";//赋值给series
		            series[0].data=yy;
					//window.console.info(series);
					//options.xAxis.categories.push('success');
		            options.series = series;//指定y
		            options.xAxis.categories=x;//指定x
					//window.console.info(options)
				    chart = new Highcharts.Chart(options); 
				}
		});
		}
			
	});
</script>
	</head>
	<body>
	<div style="width:100 height:200"></div>
<script src="../ums/js/highcharts.js"></script>

<div id="container" style="min-width: 100px; height: 400px; margin: 0 auto"></div>

	</body>
</html>
