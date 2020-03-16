
//主播秀首页轮播图初始化
if ($("#banner").length) {
	$.ajax({
		type: 'GET',
		url: lunboUrl ,
		dataType: 'json',
		success: function (lunboData) {
			if(lunboData.length){
				var lunboHtml = ""
            	for (var i=0;i<lunboData.length;i++) {
            		lunboHtml +='<li>'+
            						'<a href="'+lunboData[i].live_url+'" target="_blank"><img src="'+lunboData[i].photo+'" alt="" title=""/></a>'+
            						'<h4><a href="" title="" target="_blank">'+lunboData[i].title+'</a></h4>'+
            					'</li>';
            	}
            	$("#banner-1>ul").html(lunboHtml);
            	var lunbo = new TouchSlide({ 
            		slideCell:"#banner",
            		titCell:".circle ul", //开启自动分页 autoPage:true ，此时设置 titCell 为导航元素包裹层
            		mainCell:".banner-1 ul", 
            		effect:"leftLoop", 
            		autoPlay:true,//自动播放
            		autoPage:true, //自动分页
            		interTime : 2000
            	});
			}else{
			    $("#banner-1").hide();
			}	
		},
		error: function () {
			// alert("接口请求失败！");
		}
	});
}
window.eventDefault= function(e) {
    e.preventDefault();
};

//绑定浏览器禁止滑动事件

//$("#banner").get(0).addEventListener('touchmove',eventDefault,false);


var id = getUrl("id") ;
var site = getUrl("site") ;
var session = getUrl("session") ;


//请求正在直播数据
if($(".live-box .onlive").length){
	getOnliveData();
}
function getOnliveData(){
	$.ajax({
		type: 'GET',
		data: {id:id,islive:1},
		url: jxlivelistUrl ,
		dataType: 'jsonp',
		success: function (data) {
			if(data.result.length){
				var liveHtml = "" ;
				if(data.result.length<=2){
					var len = data.result.length ;
				}else{
					var len = 2 ;  //限制只要良哥
				}	
				
				for(var i=0;i<len;i++){
					liveHtml += '<div class="live-item-half" data-url="'+data.result[i].live+'" data-liveid="'+data.result[i].id+'">'+
									'<div class="img-box">'+
										'<img src="'+data.result[i].coverpicture+'" />'+
										'<div class="live-state">'+
											'<i>•</i><span>'+data.result[i].state+'</span>	'+
										'</div>'+
										'<div class="live-focus-date">'+
											'<span class="live-focus"><i>'+data.result[i].online_number+'</i>关注</span>'+
											'<span class="live-date">06-16</span>'+
										'</div>'+
									'</div>'+
									'<p class="live-title">'+data.result[i].Title+'</p>'+
								'</div>';
				}	
				$(".onlive").show().find(".live-item").html(liveHtml);
			}else{
			    $(".onlive").hide();
			}
			if(data.status==500){
			    $(".onlive").hide();
			}
		},
		error: function () {
			// alert("接口请求失败！");
		}
	});
}
//请求其他直播数据
if($(".live-box .other-live").length){
	getOtherliveData();
}
function getOtherliveData(){
	$.ajax({
		type: 'GET',
		data: {id:id,islive:2},
		url: jxlivelistUrl ,
		dataType: 'jsonp',
		success: function (data) {
			if(data.result.length){
				var liveHtml = "" ;
				if(data.result.length<=2){
					var len = data.result.length ;
				}else{
					var len = 2 ;  //限制只要两条
				}	
				for(var i=0;i<len;i++){
					liveHtml += '<div class="live-item-half" data-url="'+data.result[i].live+'" data-liveid="'+data.result[i].id+'">'+
									'<div class="img-box">'+
										'<img src="'+data.result[i].coverpicture+'" />'+
										'<div class="live-state end">'+
											'<i>•</i><span>'+data.result[i].state+'</span>	'+
										'</div>'+
										'<div class="live-focus-date">'+
											'<span class="live-focus"><i>'+data.result[i].online_number+'</i> 关注</span>'+
											'<span class="live-date">06-16</span>'+
										'</div>'+
									'</div>'+
									'<p class="live-title">'+data.result[i].Title+'</p>'+
								'</div>';
				}	
				$(".other-live").show().find(".live-item").html(liveHtml);
			}	
		},
		error: function () {
			// alert("接口请求失败！");
		}
	});
}

//直播跳转
$(".other-live,.onlive").delegate(".live-item-half","click",function(){
	var _url = $(this).attr("data-url");
	window.open(_url,"_blank");
})

// 网红榜
anchorList();
function anchorList(){
	$.ajax({
		url : anchorListUrl,
		method : "GET",
		data : "",
		dataType : 'json',
		success : function (data1) {
			var anchorHtml ="" ;
			if(data1.length){
				var data = data1.sort(mySort);
				function mySort(a,b) {
					return b.hot-a.hot;
				}
				console.log(data)
				if(data.length<=9){
					var len = data.length ;
				}else{
					var len = 9 ;  //限制只要良哥
				}	
				for (var i= 0 ;i<data.length ; i++) {
					anchorHtml +='<div class="anchor-item">\
										<div class="img-box">\
											<div class="anchor-photo">\
												<img src="'+data[i].photo+'" onerror="nofind(this);">\
											</div>\
											<div class="rank-bg"></div>\
										</div>\
										<div class="anchor-name">'+data[i].title+'</div>\
										<div class="anchor-hot">'+data[i].hot+'</div>\
										<div class="anchor-belong">'+data[i].summary+' </div>\
										<a href="javascript:;" id="gzbtn'+data[i].company_id+'" data-id="'+data[i].company_id+'" class="recommend not-recommend"> 关注</a>\
									</div>' ;					
				}
				$(".anchor-rank .anchor-list").html(anchorHtml);
				getRecommendList();
			}
			
					
		},error:function(err){
			console.log(err)
		}
	});
}

function MediaBtn(arr){
	if(session){
		for (var i= 0 ;i<arr.length ; i++) {
			console.log($("#gzbtn"+arr[i]))
			$("#gzbtn"+arr[i]).addClass("have-recommend").removeClass("not-recommend").text("已关注");
		}
	}
	$(".recommend").parents(".dpnone").removeClass("dpnone") ;
	$(".anchor-item .recommend").css({"display":"block"});
}

//请求关注列表
var RecommendIdArr = [] ;
function getRecommendList(){
	$.ajax({
		url : "/apiv3.5.2/topic_watch_company.php",
		method : "GET",
		data :{session:session},
		dataType : 'json',
		success : function (data) {
			console.log(data)
			var gzMediaHtml ="" ;
			var gzIdArr = [] ;
			RecommendIdArr = [] ;
			if(data.result.list.length>0){
				for (var i= 0 ;i < data.result.list.length ; i++) {
				    RecommendIdArr.push(data.result.list[i].companyid) ;
					gzIdArr.push(data.result.list[i].companyid) ;
				}					
			} 
			MediaBtn(RecommendIdArr) ;
		}
	});
}

//关注按钮事件
$("body").delegate("a.recommend","click",function(){
	if(!session){
		if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)){
		   try{
				window.location.href='tidelogin://tide';
			}catch(e){} 
		}  else {
			try{ 
				 event.preventDefault(); 
				 window.TideApp.login();
			}catch(e){}
		}
		return false ;
	}
	var cid = $(this).attr("data-id") ;
	var _that = $(this)
	$.ajax({
		url : "/apiv3.5.2/company_watch.php",
		method : "GET",
		data :{bewatchuserid:cid,site:site,session:session},
		dataType : 'jsonp',
		success : function (data) {
			if(data.status==1){
				if(_that.text()=="关注"){
					$("#gzbtn"+cid).addClass("have-recommend").removeClass("not-recommend").text("已关注");
					
				}else{
					$("#gzbtn"+cid).removeClass("have-recommend").addClass("not-recommend").text("关注");
				}
			}
			RecommendIdArr = [] ;
			getRecommendList()
		}
	});
	return false;
})	

//主持人号跳转主持人号个人详情页
$(".anchor-list").delegate(".img-box","click",function(){
    var anchorItem = $(this).parents(".anchor-item")
    var _id = anchorItem.find(".recommend").attr("data-id") ;
    jumpCompany(_id)
    return false ;
})
function jumpCompany(id){
    if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)){
	    try{
		     window.location.href='tidecompany://tide?companyid='+id;
    	}catch(e){}
    }  else {
        try{
		     window.TideApp.company(""+id) ;  //参数自定义
    	}catch(e){ console.log(e)}
       
    }
}



