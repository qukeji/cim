
var xansuoUrl = "/tcenter/collect/getitems.jsp";   //线索
var xuantiUrl = "/tcenter/work/my_taskInfo.jsp" ;  //选题
var taskUrl = "/tcenter/work/my_renwuInfo.jsp" ;  //任务
var produceUrl = "/tcenter/work/workflow_product.jsp" ;   //生产
var publishUrl = "/tcenter/work/my_articlesInfo.jsp" ;   //发布(我的稿件)
var statisticUrl = "/tcenter/work/workflow_statistic.jsp" ;   //效果

var xiansuoObj = [] ; 
var xuantiObj = [] ; 
var taskObj = [] ; 
var productObj = [] ; 
var publishObj = [] ; 

const options = {
  startSockets: [
  'top',
  'bottom',
  'right',
  'bottom',
  'left',
  'right'],

  endSockets: [
  'top',
  'bottom',
  'top',
  'top',
  'top',
  'top'] 
};

var chartColors = {
	red: 'rgb(255, 99, 132)',
	orange: 'rgb(255, 159, 64)',
	yellow: 'rgb(255, 205, 86)',
	green: 'rgb(75, 192, 192)',
	blue: 'rgb(54, 162, 235)',
	purple: 'rgb(153, 102, 255)',
	grey: 'rgb(201, 203, 207)'
};

function itemLine1(){
	
	var arr0=[xiansuoObj[2],xiansuoObj[4],xiansuoObj[5],xiansuoObj[6]] ;
	
	var arr1=[xuantiObj[0],xuantiObj[1],xuantiObj[2]] ;
	var arr2=[xuantiObj[4],xuantiObj[5],xuantiObj[6]] ;
	var arr3=[taskObj[0],taskObj[1],taskObj[2]] ;
	var arr4=[taskObj[4],taskObj[5],taskObj[6]] ;
	var arr5=[productObj[0],productObj[2],productObj[3]] ;
	var arr6=[productObj[5],productObj[6]] ;
	var arr7=[productObj[1],productObj[2],productObj[4]] ;
	var arr8=[publishObj[1],publishObj[2]] ;
	
	for (var i=0;i<arr0.length;i++) {
		new LeaderLine(arr0[i], xuantiObj[2], {
		    dash:  {animation: true},
		    size: 1,
		    color: "#3f51b5",
		    endPlug: "behind",
		    //endPlug: 'behind',
		    startSocket: "right",
				endSocket: "left",
				startSocketGravity : 50,
				endSocketGravity:50
			//endPlug: 'arrow1',
		});
	}
	for (var i=0;i<arr1.length;i++) {
		new LeaderLine(arr1[i], taskObj[3], {
		    dash:  {animation: true},
		    size: 1,
		    color: chartColors.orange,
		    endPlug: 'behind',
		    startSocket: "right",
			endSocket: "left",
			startSocketGravity : 50,
				endSocketGravity:50
			//endPlug: 'arrow1',
		});
	}
	
	for (var i=0;i<arr1.length;i++) {
		new LeaderLine(arr1[i], taskObj[3], {
		    dash:  {animation: true},
		    size: 1,
		    color: chartColors.orange,
		    endPlug: 'behind',
		    startSocket: "right",
			endSocket: "left",
			startSocketGravity : 50,
				endSocketGravity:50
			//endPlug: 'arrow1',
		});
	}
	
	for (var i=0;i<arr2.length;i++) {
		new LeaderLine(arr2[i], taskObj[4], {
		    dash:  {animation: true},
		    size: 1,
		    color: chartColors.red,
		    endPlug: 'behind',
		    startSocket: "right",
			endSocket: "left",
			startSocketGravity : 50,
				endSocketGravity:50
			//endPlug: 'arrow1',
		});
	}
	
	for (var i=0;i<arr5.length;i++) {
		new LeaderLine(taskObj[4], arr5[i], {
		    dash:  {animation: true},
		    size: 1,
		    color: chartColors.blue,
		    endPlug: 'behind',
		    startSocket: "right",
				endSocket: "left",
				startSocketGravity : 50,
				endSocketGravity:50
			//endPlug: 'arrow1',
		});
	}
	
	for (var i=0;i<arr3.length;i++) {
		new LeaderLine(arr3[i], productObj[1], {
		    dash:  {animation: true},
		    size: 1,
		    color: chartColors.purple,
		    endPlug: 'behind',
		    startSocket: "right",
				endSocket: "left",
				startSocketGravity : 50,
				endSocketGravity:50
			//endPlug: 'arrow1',
		});
	}
	
	for (var i=0;i<arr7.length;i++) {
		new LeaderLine(arr7[i], publishObj[6], {
		    dash:  {animation: true},
		    size: 1,
		    color: chartColors.green,
		    endPlug: 'behind',
		    startSocket: "right",
				endSocket: "left",
				startSocketGravity : 50,
				endSocketGravity:50
			//endPlug: 'arrow1',
		});
	}
	
}

//线索
var xiansuoType = 1 ;
function xiansuoData(type){
	if(!type){
		type = 0 ;
	}
	xiansuoType ++ ;
	if(xiansuoType>2){
		xiansuoType = 0
	}
	$.ajax({
		url:xansuoUrl,
		dataType:'json',
		data:{pagesize:10,type:type},
		type:'GET',
		success:function(data){
			var html = "" ;
			$("#xiansuo .flow-list").hide(300)
			for (var i = 0; i < data.result.length; i++) {
				html +='<div class="flow-item bg-white xiansuoitem xiansuoitem'+i+'" >'+
							'<div class="item-title">'+data.result[i].title+'</div>'+
							'<div class="item-normal"><span class="mg-r-10">类型：'+data.result[i].type_desc+'</span>  <span>来源：'+data.result[i].from+'</span></div>'+
							'<div class="item-date">'+returnTime(data.result[i].date)+'</div>';
						if(data.result[i].type==1){
							html += '<div class="item-icon weixin">'+
									'<i class="fa fa-weixin"></i>';
						}else if(data.result[i].type==2){
							html += '<div class="item-icon weibo">'+
									'<i class="fa fa-weibo"></i>';
						}else{
							html += '<div class="item-icon internet">'+
									'<i class="fa fa-internet-explorer"></i>';
						}
						html += '</div>'+
						'</div>';
			}
			$("#xiansuo .flow-list").show(0).html(html);
			var xiansuoitem = $(".xiansuoitem");
			xiansuoObj = [] ;
			$.each(xiansuoitem, function(vi,va) {
				xiansuoObj.push($(va).get(0))
			});
 			console.log(xiansuoObj);
		}
	})
}
xiansuoData(xiansuoType);
var xiansuoInterval = setInterval( function(){
	//xiansuoData(xiansuoType)
} , 8000)
	

//选题
xuantiData();
function xuantiData(){
	$.ajax({
		url:xuantiUrl,
		dataType:'json',
		data:{type:1},
		type:'GET',
		success:function(data){
			var html = "" ;
			for (var i = 0; i < data.result.length; i++) {
				html +='<div class="flow-item bg-white xuantiitem xuantiitem'+i+'">'+
							'<div class="item-title">'+data.result[i].title+'</div>'+
							'<div class="item-normal"><span class="mg-r-10">状态：'+data.result[i].StatusDesc+'</span>  <span>报题人：'+data.result[i].user+'</span></div>'+
							'<div class="item-date">'+returnTime(data.result[i].date)+'</div>'+
							'<div class="item-icon headicon">'+
								'<img src="" onerror="checkImg(this)">'+
							'</div>'+
						'</div>';
			}
			$("#xuanti .flow-list").html(html);
			var xuantiitem = $(".xuantiitem");
			$.each(xuantiitem, function(vi,va) {
				xuantiObj.push($(va).get(0))
			});
 			console.log(xuantiObj);
 			
 			
		}
	})
}

//任务
mytask();
function mytask(){
	$.ajax({
		url:taskUrl,
		dataType:'json',
		data:{type:1},
		type:'GET',
		success:function(data){
			var html = "" ;
			for (var i = 0; i < data.result.length; i++) {
				html +='<div class="flow-item bg-white taskitem taskitem'+i+'">'+
							'<div class="item-title">'+data.result[i].title+'</div>'+
							'<div class="item-normal"><span class="mg-r-10">状态：'+data.result[i].StatusDesc+'</span>  <span>报题人：'+data.result[i].user+'</span></div>'+
							'<div class="item-date">'+returnTime(data.result[i].date)+'</div>'+
							'<div class="item-icon headicon">'+
								'<img src="" onerror="checkImg(this)">'+
							'</div>'+
						'</div>';
			}
			$("#mytask .flow-list").html(html)
			var taskitem = $(".taskitem");
			$.each(taskitem, function(vi,va) {
				taskObj.push($(va).get(0))
			});
 			console.log(taskObj);
 			
		}
	})
}

var interval = setInterval(function(){
	if(taskObj.length>0 && xuantiObj.length>0 && xiansuoObj.length>0 && productObj.length>0 && publishObj.length>0){
		clearInterval(interval);
		setTimeout(itemLine1,1000)
	}
},500)


//生产
produce();
function produce(){
	$.ajax({
		url:produceUrl,
		dataType:'json',
		data:{},
		type:'GET',
		success:function(data){
			var html = "" ;
			var len = data.result.length <=10 ? data.result.length : 10 ;
			
			for (var i = 0; i < len; i++) {
				html += '<div class="flow-item bg-white productitem productitem'+i+'">'+
							'<div class="item-normal"><span class="mg-r-10">'+data.result[i].User+'</span><span>'+returnTime(data.result[i].date)+'</span> 上传  ';
							if(data.result[i].type==1){ 
								html += '图文 </div>' ;
								if(data.result[i].Photo.length>0){
									html += '<div class="item-pics">' ;
									for (var j = 0; j < data.result[i].Photo.length; j++) {
										html+='<div class="img-box">'+
													'<div class="img-box-inner">'+
														'<img src="'+data.result[i].Photo[j]+'"  onerror="removeImg(this)">'+
													'</div>'+
												'</div>';
									}
									html +='</div>' ;
								}
							}else if(data.result[i].type==2){
								html += '视频 </div>' ;
								if(data.result[i].video_source!=""){
									html += '<div class="item-video">'+
												'<video  controls="controls" src="'+data.result[i].video_source+'"></video>'+
											'</div>';
								}
							}
							html += '<div class="item-title">'+data.result[i].Title+'</div>'+
							'<div class="item-icon headicon">'+
								'<img src="'+data.result[i].avatar+'" onerror="checkImg(this)">'+
							'</div>'+
						'</div>'
			}
			$("#produce .flow-list").html(html);
			var productitem = $(".productitem");
			$.each(productitem, function(vi,va) {
				productObj.push($(va).get(0))
			});
 			console.log(productObj);
		}
	})
}

//发布
publish()
function publish(){
	$.ajax({
		url:publishUrl,
		dataType:'json',
		data:{type:1},
		type:'GET',
		success:function(data){
			var html = "" ;
			var len = data.result.length <=10 ? data.result.length : 10 ;
			for (var i = 0; i < len; i++) {
				if(data.result[i].doc_type==0 || data.result[i].doc_type==1){
					html += '<div class="flow-item bg-white publishitem publishitem'+i+'">'+
								'<div class="item-normal"><span class="mg-r-10">'+data.result[i].user+'</span><span>'+returnTime(data.result[i].date)+'</span> 上传  ';
								if(data.result[i].doc_type==0){
									html += '图文 </div>' ;
									if(data.result[i].Photo.length>0){
										html += '<div class="item-pics">' ;
										for (var j = 0; j < data.result[i].Photo.length; j++) {
											html+='<div class="img-box">'+
														'<div class="img-box-inner">'+
															'<img src="'+data.result[i].Photo[j]+'">'+
														'</div>'+
													'</div>';
										}
										html +='</div>' ;
									}
								}else if(data.result[i].doc_type==1){
									html += '视频 </div>' ;
									if(data.result[i].videourl!=""){
										html += '<div class="item-video">'+
													'<video  controls="controls" src="'+data.result[i].videourl+'"></video>'+
												'</div>';
									}
								}
								html += '<div class="item-title">'+data.result[i].title+'</div>'+
								'<div class="item-icon headicon">'+
									'<img src=""  onerror="checkImg(this)">'+
								'</div>'+
							'</div>'
				}
			}
			$("#publish .flow-list").html(html);
			var publishitem = $(".publishitem");
			$.each(publishitem, function(vi,va) {
				publishObj.push($(va).get(0))
			});
		}
	})
}

//效果（统计）
statistic();
function statistic(){
	$.ajax({
		url:statisticUrl,
		dataType:'json',
		data:{},
		type:'GET',
		success:function(data){
			var html = "" ;
			var pv = false ;
			var user = false ;
			if(data.main_data_object.xaxis.length){
				pv = true ;
				html += '<div class="flow-item bg-white">'+
							'<div class="item-normal">浏览量统计 </div>'+
								'<div class="charts-box" style="">'+
									'<canvas id="canvasPv" height="200"></canvas>'+
								'</div>'+
								'<div class="item-icon hand">'+
									'<i class="fa fa-hand-o-up"></i>'+
								'</div>' +
							'</div>'+
						'</div>' ;
			}
			if(data.user_main_chart.xaxis.length){
				user = true ;
				html += '<div class="flow-item bg-white">'+
							'<div class="item-normal">用户量统计 </div>'+
								'<div class="charts-box" style="">'+
									'<canvas id="canvasUser" height="200"></canvas>'+
								'</div>'+
								'<div class="item-icon hand">'+
									'<i class="fa fa-hand-o-up"></i>'+
								'</div>' +
							'</div>'+
						'</div>' ;
			}
		  
			$("#effect .flow-list").html(html)
			initChart(pv,data.main_data_object,1);
			initChart(user,data.user_main_chart,2);
		}
	})
}

function initChart(isinit,data,type){
	chartConfig.data.labels  = data.xaxis ;
	if(type==1){
		chartConfig.data.datasets[0].data  = data.pv ;
		var ctx = document.getElementById('canvasPv').getContext('2d');
		window.myLine1 = new Chart(ctx, chartConfig);
	}else{
		chartConfig.data.datasets[0].data  = data.appuser ;
		var ctx = document.getElementById('canvasUser').getContext('2d');
		window.myLine2 = new Chart(ctx, chartConfig);
	}
}


//返回需要的时间格式 
function returnTime(str,type) {
	var date = str ? new Date(str) : new Date() ;   
    var seperator1 = "-";
    var seperator2 = ":";
    function addZero(m){
    	return m<10 ? '0'+m : m  ;
    }
	var currentMD = addZero( date.getMonth()+1 ) +seperator1 +addZero( date.getDate() )  ;
	var currentHM = addZero( date.getHours() ) + seperator2 + addZero(date.getMinutes()) ; 
	if(type==1){
		return '<span>'+currentMD+'</span><span>'+currentHM+'</span>';
	}else{
		return currentMD+" "+currentHM;
	}
} 

function checkImg(_this){
	$(_this).attr("src","../img/2019/tide_user.png")
}

function removeImg(_this){
	$(_this).remove();
}


function refresh(_index){
	switch (_index){
		case 0:
			xiansuoType++ ;
		    xiansuoData(xiansuoType);
			break;
		case 1:
		    xuantiData();
			break;
		case 2:
		    mytask();
			break;
		case 3:
		    produce();
			break;
		case 4:
		   publish()
			break;
		case 5:
		    statistic();
			break;
		
		default:
			break;
	}
}

//图表初始化

var chartConfig = {
	type: 'line',
	data: {
		labels: ['01', '02', '03', '04', '05', '06', '07'],
		datasets: [{
				label: '9999',
				backgroundColor: chartColors.red,
				borderColor: chartColors.red,
				data: [
					800,900,1500,2960,5550,330,9999
				],
				fill: false,
			}]
		},
		options: {
			legend: {
		        display: false,
		          labels: {
		            display: false
		          }
		      },
		      scales: {
		        yAxes: [{
		          ticks: {
		            beginAtZero:true,
		            fontSize: 10
		          }
		        }],
		        xAxes: [{
		          ticks: {
		            beginAtZero:true,
		            fontSize: 11
		          }
		        }]
		      }
		}
	};
