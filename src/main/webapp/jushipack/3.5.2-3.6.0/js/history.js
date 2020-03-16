/* querystring -> obj */
function getUserQuery () {
    var search = window.location.search.slice(1);
    var query = {}
    search.split("&").map(function(i){
        var q = i.split("=");
        query[q[0]] = q[1];
    })
    return query;
}

function getUrl(name) {
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if(r!=null)return  unescape(r[2]); return null;
};

function uploadHistory (sid, gid, url, siteid) {
    $.ajax({
        url : "/apiv3.6.0/history.php",
        method : "GET",
        data : {session:sid, globalid:gid, url:url , site:siteid},
        dataType : 'jsonp',
        success : function (data) {
            if( data.status == 1 ){
                console.log("阅读历史入库成功");
            }else if( data.status == 0 ){
                console.log("阅读历史入库失败");
            }
        }
    });
}

    function generateComment(data){
        var res = '';
        $(data.list).map(function(ind, val){
             var pic = val.avatar.trim() ? val.avatar: '/images/pinglun_07.png';
             res += '<li class="list_li" data-id="'+ val.GlobalID +'" data-uid="'+ val.userid +'" ><div class="pubHouse"><a href="javascript:;" class="left"><img src="'+ pic +'"></a>';
             res += '<span class="right" style="display:inline"><div class="fs">';
             res += '<p class="pubName"><span>' + val.username + ':</span><a href="javascript:;"><img src="/images/pinglun-37.png" onclick="javascript:pushComment('+ val.userid +','+ val.GlobalID +",\'"+ val.username +"\');\"></a></p>";
             res += '<p></p><p class="pubTime">' + val.date+ '</p><p class="p3">' + val.content + '</p></div>';
             if( val.reply != '' ){
                 $(val.reply).map(function(ind2, val2){
                      res += '<div class="critic"><div id="" class="criticName"><div class="erjishow" id="0">'+ val2.username +'：' + val2.content +'</div><div class="chakancon" id="c0"></div></div></div>';
                 });
             }
             res += '</span></div></li>';
        });
        return res;
    }

function isIOS(){
    return /(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent);
}

function pushComment(uid, gid, uname){
    if( isIOS() ) {
	window.location.href='comment://tide?uid='+uid+'&gid='+gid+'&uname='+uname;
    }else{
	window.comment.pushCommentAndroid(gid, GlobalID, uname);
    }
}

$(function(){
   
    /* 提交浏览历史入库 */
    console.log(getUserQuery())
    uploadHistory( getUserQuery()['session'], GlobalID, window.location.href,siteId );
  
/* 加载评论区域 */
/* var COMMENT_HTML = '<div class="comment" style="width:100%;"><h3><span class="title">精彩评论</span><span class="line"></span></h3><ul id="pingluncon"><li><div class="pubHouse"><span class="right" style="display:inline"></span></div></li></ul></div>';
$(COMMENT_HTML).insertAfter(".content"); */  

    //获取企业信息	
    companyInfo();
    function companyInfo(){
       if("undefined" == typeof(companyid) || companyid == 0 ){
          $(".data").show()  //如果企业号为空为0就显示发布日期
          return false;        
       }else{
          $.ajax({
            url:"/apiv3.6.0/company_watch_status.php",
            type:"get",
            data:{
        	session : getUserQuery()['session'],
        	bewatchuserid : companyid ,
        	site : siteId
             },
            dataType:"jsonp",
            success:function(data){
                if(data.status==1){
                    if(data.photo){
                        $(".company-logo").attr("src",data.photo);
                    }else{
                        $(".company-logo").remove();  //如果没有传过来企业logo,移除可能出现样式问题的img标签
                    }
                    $(".company-name").html(data.title);
                    $(".concern-num i").html(data.watchcount);
                    if(data.watchstatus==1){
                	$(".info-btn").removeClass("notyet").addClass("yes").html("已关注")
                    }else{
                	$(".info-btn").removeClass("yes").addClass("notyet").html("关注")
                    }
                    $(".company-box").show();            
                }
             }
         });
        }
    }
	    
    //点击关注按钮
    $(".company-box .info-btn").on("touchstart",function(){
    	   var that =this ;
           $.ajax({	       
	        url:"/apiv3.6.0/company_watch.php",
	        type:"get",
	        data:{
	        	session : getUserQuery()['session'],
	        	bewatchuserid : companyid ,
	        	site : siteId
	        },
	        dataType:"jsonp",
	        success:function(data){                        
                    if(data.status==1){
	                companyInfo();			                	                
	            }else if(data.status==300){
                        if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)){
			            window.location.href=' tidelogin://tide';
			        }  else {
			            event.preventDefault(); 
			            window.TideApp.login();
			        }
	            }
	        },error:function(data){
                  
                }
	    });	        	   	
    })
    //进企业号主页
    $(".company-img-box ,.company-text").on("touchstart",function(event){
    	 if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)){
            window.location.href='tidecompany://tide?companyid='+companyid;
         } else {
            event.preventDefault(); 
            window.TideApp.company(companyid);
        }
    })
   
});
//more_data();
function more_data(){
  $.ajax({
        method : "GET",
        url : "/api/comment_list.php",
        data : {globalid:GlobalID},
        dataType : "json",
        success : function(data){
            if( data.status == 0 ){
                 $("#pingluncon li").eq(0).find('span').text('暂无评论~');
            }else{
               //  $("#pingluncon").html( $("#pingluncon").html() + generateComment(data.result) );   
                     $("#pingluncon").html( generateComment(data.result) );                     
            }
        }
    });  
}


// 设置app内容页字体  ------------- start
function setFontSize(size){
    var _size  =  parseInt(size) ;
    if(_size==3){
        var styleSheet = '<style>' +
        'div{font-size: 17px; } [data-dpr="2"] div{font-size:34px;} [data-dpr="3"] div{font-size:51px;}'+
        '</style>';
        $(styleSheet).appendTo('head');
    }else if(_size==4){
        var styleSheet = '<style>' +
        'div {font-size: 18px; } [data-dpr="2"] div{font-size:36px;} [data-dpr="3"] div{font-size:54px;}'+
        '</style>';
        $(styleSheet).appendTo('head');
    }else if(_size==5){
        var styleSheet = '<style>' +
        'div{font-size: 20px; } [data-dpr="2"] div{font-size:40px;} [data-dpr="3"] div{font-size:60px;}'+
        '</style>';
        $(styleSheet).appendTo('head');
    }else if(_size==1){
        var styleSheet = '<style>' +
        'div{font-size: 14px; } [data-dpr="2"] div{font-size:28px;} [data-dpr="3"] div{font-size:42px;}'+
        '</style>';
        $(styleSheet).appendTo('head');
    }else if(_size==2){
        var styleSheet = '<style>' +
        'div{font-size: 16px; } [data-dpr="2"] div{font-size:32px;}[data-dpr="3"] div{font-size:48px;}'+
        '</style>';
        $(styleSheet).appendTo('head');
    }
}
articleFont();
function articleFont(){
    var url = window.location.href ;
    if(url.indexOf("content_wap") == -1){
        if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)){
           // window.location.href='tidegetConfig://tide';
           window.webkit.messageHandlers.tideGetConfig.postMessage([]);
         } else {
           // event.preventDefault(); 
            try{
                //alert(33)
				window.TideApp.getConfig();
			}catch(e){}
           
        }
    }
}

//设置字体app回调函数
function getConfig(json){
    //alert(json)
    var size = 3 ;
    var font = 0 ;
    if(typeof(json) == "object" && Object.prototype.toString.call(json).toLowerCase() == "[object object]" && !json.length){
        size = json.size;
        font = json.font;
    }else{
        var _json = JSON.parse(json) ;
        size = _json.size;
        font = _json.font;
    }
    if(size==0){
        size = 3 ;
    }
    setFontSize(size.toString());
    if(font==1){
        
        if( isIOS() ) {
            var styleSheet = '<style>' +
            //"@font-face{font-family: 'Songti SC';src: local('Songti SC'),url('songti.ttf') format('opentype');}"+
            '*{font-family:"SimSun","Microsoft YaHei",simsun,Arial !important;}'+
            '</style>';
        }else{
    	    var styleSheet = '<style>' +
            "@font-face {font-family: 'Songti';src: url('file:///android_asset/font/jiansong.ttf') format('truetype');font-weight: normal;font-style: normal;}"+
            '*{font-family:"Songti","Microsoft YaHei",simsun,Arial !important;}'+
            '</style>';
        }
       // alert(styleSheet)
        $(styleSheet).appendTo('head');
       
    }
}
//设置app内容页字体  ------------- end

//返回完整链接

function returnWhole(_url){ 
    var siteUrl = "//"+window.location.host ;
	if(_url.substr(0,4)!="http"){
       _url  = ""+siteUrl + _url  ;
    } 
    return _url ;
}


$(function(){
    
    /*语音识别*/
    var textAll ="" ;
  	var _span = $(".conmm p") ;
    // textAll += $("h2").text() + "。" ;
    // textAll += $(".data").text() + "。" ;
	$.each(_span, function(vi,va) {
		textAll += $(va).text() ;
	});
	try{
		JSInterface.toAndroidTTS(textAll) ;	
	}catch(e){
		
	}
    
    //图片放大
    $(".content img").click(function(){
        var imgSrc =returnWhole( $(this).attr("src") ) ;
        //console.log(imgSrc);
        JSInterface.toAndroidPreviewImageSingle(imgSrc) ;
    })

    /*app埋点相关*/
    var spmData = {} ;
    spmData.targetId = GlobalID ;   //String	是	稿件ID
    spmData.num = "无" ;            //String	是	总版次
    spmData.articleType = "图文" ;  //String	是	文章类型
    spmData.sourceUrl = "无" ;     //String	是	源url，同一家媒体机构如果重复上传同一个url（"无"除外），会覆盖之前版本
    spmData.isFrontPage = false ;  //Boolean	是	是否头版
    
    spmData.frontPageState = "无" ;  //String	否	头版位置（报头、报眉、报眼、头条、头版提要）
    spmData.site = "无" ;  //String	否	站点名
    
   
    var pDate = $(".data").text().replace("发布日期：","").replace(/\年|\月/g,"/").replace(/\日/g,"")  ;
    spmData.pubTime = parseInt(  (new Date(pDate) ).getTime() )  ;        //Long	是	出版时间（时间戳，单位毫秒）
    spmData.editionName = "无" ;    //String	否	所属版面
    spmData.isTransfer = "无" ;     //Boolean	是	是否转版
    spmData.language = "zh" ;       //String	是	语种，符合ISO 639-1 规范，参考
    spmData.title = $("title").text() ;   //String	是	标题
    spmData.preTitle = "无" ;      //String	否	副标题
    spmData.subTitle = "无" ;      //String	否	子标题
    spmData.lead = "无" ;          //String	否	导语
    spmData.keywords = "无" ;       //String	否	关键词，多个关键词用逗号分隔
    spmData.author = "无" ;         //String	是	作者
    spmData.newsIntro = $(".content").text() ;  //String	是	正文(不带html标签)
    spmData.content = $(".content").html() ;   //String	是	正文（带html标签）
    
    if($(".content img").length>0){
        spmData.hasImages = true ;   //Boolean	是	是否配图
    }else{
        spmData.hasImages = false ; 
    }
    if(spmData.hasImages){
        var imgS = $(".content img") ;
        spmData.newsImages = [] ;  //String[]	依赖hasImages	配图链接，数组传递
    	for (var i = 0; i < imgS.length; i++) {
    		spmData.newsImages.push(imgS.eq(i).attr("src"))
    	}
    }
    spmData.newsImagesDesc = "无" ;   // String	否	图片描述
    spmData.contentWordsCount = "无" ;  //Integer	否	字数统计
    spmData.isNewsRelease = false ;  //Boolean	是	是否通稿
    spmData.isExtra = false ;  //Boolean	是	是否号外
    
    console.log(JSON.stringify(spmData));
    
    
    //内容页广告start
    try{
		if(allowadvert==1){pushAd()}  //allowadvert=1广告开，allowadvert=0广告关
	}catch(e){
		console.log("allowadvert is not defined")
	}
    function pushAd(){
        $.ajax({
            method : "GET",
            url : "/interaction/a//advert.json",
            dataType : "json",
            success : function(data){
                if(data.length>0){
                    var advertList = new Array();
                    for(var i=0;i<data.length;i++){
                        if(data[i].dropchannel_id.indexOf(channelid) != -1 && data[i].position==1){
                            advertList.push(data[i]) ;
                        }
                    }
                    if(advertList.length>0){
                        selectAd(advertList);
                    }
                }
            }
        });  
    }
    
    //格式化时间以比较早晚
	function formatTime(time){
		return new Date(time.replace("-", "/").replace("-", "/"));
	}
    
    function selectAd(arr){
        var currentTime = new Date() ;
        var articleAdArr = new Array();
        for(var i=0;i<arr.length;i++){
            if(formatTime(arr[i].onlinetime)<=currentTime && formatTime(arr[i].Revoketime)> currentTime ){
                articleAdArr.push(arr[i]) ;
            }
        }
        console.log(articleAdArr)
        if(articleAdArr.length>0){
            var len = articleAdArr.length ;
            var i = Math.ceil(Math.random() * (len ))%len;
            console.log(i)
            adhtml(articleAdArr[i])
        }
        function adhtml(obj){
            var adhtml = "" ;
            adhtml += '<div class="advert-box" data-id="'+obj.id+'">\
                        <div class="advert-content">\
                        <a href="'+obj.href+'" class="advert-a"><img src="'+obj.Photo+'" /></a>\
                        <div class="advert-tip">广告</div>\
                        <p class="advert-title">'+obj.Title+'</p>\
                        </div>\
                    </div>'    ;
            $(".keywords-box").after(adhtml);
        }
        
        $(".advert-a").click(function(){
            var _href = $(this).attr("href") ;
            var _id = $(".advert-box").attr("data-id") ;
            if(_href!=""){
                var _url = "/apiv3.6.0/add_advert_click.php?id="+_id+"&site="+siteId ;
                window.location.href = _url
            }
            return false ;
        })
    }
    //内容页广告 end
    
})































