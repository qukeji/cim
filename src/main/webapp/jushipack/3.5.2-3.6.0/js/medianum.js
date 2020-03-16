;function getUrl(name) {
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if(r!=null)return  unescape(r[2]); return null;
};

var site = getUrl("site") ;
var session = getUrl("session") ;
var everGetRecommend = false ; //是否请求过推荐列表
var everClickGz = false ; //是否点过关注按钮
;$(function(){
	$(".r-f-nav ul li").click(function(){
		var index = $(this).index();
		$(".r-f-content-item").hide().eq(index).show();
		$(this).addClass("ac").siblings().removeClass("ac");
		$(".r-f-content").scrollTop(0)
		if(index==1){
		    RecommendIdArr = [] ;
		    if(!everClickGz){
		        getRecommendList();
		    }
		}
		
	})
	//更改多优质媒体号
	goodMedia()
	function goodMedia(){
	    $.ajax({
            url : "/d/c/company_recommend.json",
            method : "GET",
            data : "",
            dataType : 'json',
            success : function (data) {
                var goodMediaHtml ="" ;
        		for (var i= 0 ;i<data.length ; i++) {
        			goodMediaHtml +='<li class="dpnone" >\
        				<div class="goodmedia-top">\
        					<a href="javascript:;" target="_blank">\
        						<img src="'+data[i].photo+'" />\
        					</a>\
        				</div>\
        				<div class="goodmedia-middle">\
        					<h5><a href="javascript:;" target="_blank">'+data[i].title+'</a></h5>\
        					<p>'+data[i].summary+'</p>\
        				</div>\
        				<div class="goodmedia-bottom">\
        					<a href="javascript:;" id="goodbtn'+data[i].company_id+'" data-id="'+data[i].company_id+'" class="recommend not-recommend">关注</a>\
        				</div></li>'
        				
        		}
        		$(".goodmedia-box ul").html(goodMediaHtml);
        		getTjList();
        		
            }
        });
    }
    
    function MediaBtn(arr){
		if(session){
		    for (var i= 0 ;i<arr.length ; i++) {
                $("#mediaitemA"+arr[i]).addClass("have-recommend").removeClass("not-recommend").text("已关注");
    			$("#goodbtn"+arr[i]).addClass("have-recommend").removeClass("not-recommend").text("已关注");
    		}
		}
		$(".recommend").parents(".dpnone").removeClass("dpnone") ;
		if(!$(".r-f-r .media-item").length){
            noRecommendTips();
        }
	    $(".goodmedia-bottom a,.media-item .recommend").css({"display":"block"});
	    resizeHeight();
	}
	
	
    //请求关注列表
	var RecommendIdArr = [] ;
    function getRecommendList(){
		var goodMediaHtml ="" ;
		$.ajax({
            url : "/apiv3.6.0/topic_watch_company.php",
            method : "GET",
            data :{session:session},
            dataType : 'json',
            success : function (data) {
            	console.log(data)
                var gzMediaHtml ="" ;
                var gzIdArr = [] ;
                RecommendIdArr = [] ;
                if(data.result.list.length>0){
                    if(data.result.list.length>0){
                    	for (var i= 0 ;i < data.result.list.length ; i++) {
                    		RecommendIdArr.push(data.result.list[i].companyid) ;
                    		gzMediaHtml+='<div class="media-item" id="mediaitemgz'+data.result.list[i].companyid+'" data-id="'+data.result.list[i].companyid+'">\
                				<div class="media-info">\
                    				<div class="info-img-box">\
                    					<img src="'+data.result.list[i].avatar+'" />\
                    				</div>\
                    				<div class="info-text-box">\
                    				    <h5>'+data.result.list[i].username+'</h5>\
                    				    <p>'+data.result.list[i].summary+'</p>\
                    				</div>\
                				    </div>\
                				<div class="media-article-list">\
                				</div>\
                			</div>' ;
                			gzIdArr.push(data.result.list[i].companyid) ;
                    	}
                    	
                    } 
                    $(".r-f-f").html(gzMediaHtml);
                    if(gzIdArr.length){
            		  getMediaArticle(gzIdArr,2)
            		}
                }else{
                    var nogzHtml = '<div class="no-gz">\
                                        <div class="no-gz-content">\
                                            <img src="/images/nogz.png" />\
                                            <p>您还没有关注媒体号，快来关注一波吧！</p>\
                                        </div>\
                                    </div>' ;
                    $(".r-f-f").html(nogzHtml);
                }
                MediaBtn(RecommendIdArr) ;
                everClickGz = true ;
            }
        });
	
	}
	
	//请求推荐列表

    var recommendUrl = "/d/c/company_recommend.json" ;
	function getTjList(){
	    if(everGetRecommend){
	        getRecommendList();
	        return ;
	    }
	    var tjIdArr = [] ;
	    $.ajax({
            url : recommendUrl,
            method : "GET",
            data : "",
            dataType : 'json',
            success : function (data) {
                var tjMediaHtml ="" ;
                
                if(data.length>0){
                    for (var i= 0 ;i<data.length ; i++) {
            			tjMediaHtml +='<div class="media-item dpnone" id="mediaitemtj'+data[i].company_id+'" data-id="'+data[i].company_id+'">\
            				<div class="media-info">\
                				<div class="info-img-box">\
                					<img src="'+data[i].photo+'" />\
                				</div>\
                				<div class="info-text-box">\
                				    <h5>'+data[i].title+'</h5>\
                				    <p>'+data[i].summary+'</p>\
                				</div>\
            				    <a href="javascript:;" data-id="'+data[i].company_id+'" id="mediaitemA'+data[i].company_id+'" class="recommend not-recommend">关注</a>\
            				    </div>\
            				<div class="media-article-list">\
            				</div>\
            			</div>';
            			tjIdArr.push(data[i].company_id)
            		}
            		
    	            $(".r-f-r").html(tjMediaHtml);
    	        	
            		if(tjIdArr.length){
            		    getMediaArticle(tjIdArr,1)
            		}
                }else{
                    noRecommendTips();
    
                }
        		getRecommendList();
            },
	        error:function(){
	        	noRecommendTips()
	        }
        });
    }
    
    function noRecommendTips(){
        var notjHtml = '<div class="no-tj">\
                            <div class="no-tj-content">\
                                <img src="/images/notj.png" />\
                                <p>暂无推荐，去右侧“关注”看看吧</p>\
                            </div>\
                        </div>' ;
        $(".r-f-r").html(notjHtml);
    }
	//推荐接口 滚动的上拉刷新
	$(".r-f-content").scroll(function(){  	
		
		$('.top').show();
		if($(".r-f-content").scrollTop() <= 200){
			$('.top').hide();
		}
	});
	
	
	
	//请求媒体号下文章
	function getMediaArticle(arr,type){
	    var companyid = arr.join(',')
	    $.ajax({
            url : "/apiv3.6.0/company_list.php",
            method : "GET",
            data :{companyid:companyid,siteid:site,num:2},
            dataType : 'json',
            success : function (data) {
            	
                var gzIdArr = [] ;
                if(data.list.length>0){
                	for (var i= 0 ;i < data.list.length ; i++) {
                	    var articleHtml ="" ;
                		for(var j= 0 ;j < data.list[i].data.length ; j++){
                		    articleHtml+='<div class="media-article-item single-pic" data-url="'+data.list[i].data[j].contentUrl+'">\
                		                <div class="article-item-left">\
                		                    <h6 class="article-item-title">'+data.list[i].data[j].Title+'</h6>\
                		                    <div class="article-item-about">\
                		                        <span class="article-from" style="display:none;">'+data.list[i].data[j].Title+'</span>\
											    <span class="article-time">'+data.list[i].data[j].PublishDate+'</span>\
                		                    </div>\
                		                </div>\
                		                <div class="article-item-right">\
    										<img src="'+data.list[i].data[j].Photo+'" />\
    									</div>\
    								</div>'
                		}
                		if(type==1){ //type=1推荐   type=2关注
                		    $("#mediaitemtj"+data.list[i].CompanyId).find(".media-article-list").html(articleHtml)
                		}else{
                		    $("#mediaitemgz"+data.list[i].CompanyId).find(".media-article-list").html(articleHtml)
                		}
                	}
                } 
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
            url : "/apiv3.6.0/company_watch.php",
            method : "GET",
            data :{bewatchuserid:cid,site:site,session:session},
            dataType : 'jsonp',
            success : function (data) {
                if(data.status==1){
                    if(_that.text()=="关注"){
                        $("#goodbtn"+cid).addClass("have-recommend").removeClass("not-recommend").text("已关注");
			            $("#mediaitemA"+cid).addClass("have-recommend").removeClass("not-recommend").text("已关注");
            	      
            	       if(!$(".r-f-r .media-item").length){
            	           noRecommendTips();
            	       }
            	    }else{
            	        $("#goodbtn"+cid).removeClass("have-recommend").addClass("not-recommend").text("关注");
			            $("#mediaitemA"+cid).removeClass("have-recommend").addClass("not-recommend").text("关注");
            	        //_that.addClass("not-recommend").removeClass("have-recommend").text("关注");
            	    }
                }
                
                everGetRecommend = true ;
            	//goodMedia();
            	RecommendIdArr = [] ;
            	getRecommendList()
            	
            }
        });
        return false;
    })
    
    //媒体号文章跳转内容页
    $(".r-f-content").delegate(".media-article-item","click",function(){
        var _url = $(this).attr("data-url");
        window.open(_url,"_blank") ;
        return ;
    })
    //媒体号跳转媒体号详情页
    $(".r-f-content").delegate(".info-img-box,.info-text-box","click",function(){
        var _id = $(this).parents(".media-item").attr("data-id")
        jumpCompany(_id)
    })
    $(".goodmedia-box").delegate(".goodmedia-top","click",function(){
        var _li = $(this).parents("li")
        var _id = _li.find(".recommend").attr("data-id") ;
        jumpCompany(_id)
        
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
    
    //更多优质媒体号
    $("body").delegate("#moreMedia,.no-gz-content img","click",function(){
	//$("#moreMedia").click(function(){
	    if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)){
    	    try{
    		     window.location.href='tidecompanylist://tide';
        	}catch(e){}
           
        }  else {
                        
            try{
    		     window.TideApp.androidCompanyList("company") ;  //参数自定义
        	}catch(e){ console.log(e)}
           
        }
	})
	
	
    function resizeHeight(){
    	var windowHeight = $("body").height(),
    	    navHeight = $(".r-f-nav").outerHeight(true),
    		goodMediaH = $(".goodmedia").outerHeight(true),
    		listbox = $('.r-f-content') ;
    		listboxH = windowHeight - navHeight - goodMediaH -3;
    		listbox.css("height",listboxH);				
    }
    $(window).resize(function () {
    	
    	resizeHeight();
    	
    })
})

