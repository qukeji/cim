var siteUrl =  "//123.56.71.230:889/tcenter/wenzheng/web" ;

//公共弹窗函数
function commonPop(tips){
    $("#commonpop").stop().hide();
    $("#commonpop span").html(tips);		 
    $("#commonpop").fadeIn(1);
    var popInterval = setTimeout(function() {		    	
        $("#commonpop").fadeOut(300);
        clearTimeout(popInterval);
    }, 3000);  
}

//获取地址栏参数
function getUrl(name) {
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return null;
};

//sessionStorage
function sSs(key,value){
    if(value==undefined || value===undefined ){
        return sessionStorage.getItem(key);//获取指定key本地存储的值
    }
    if(value==null){
        sessionStorage.removeItem(key);//删除指定key本地存储的值
        return true;
    }
    sessionStorage.setItem(key,value);//将value存储到key字段
    return true;
};	

function isIOS(){
    return /(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent);
}

// 返回顶部
$(function(){
    $(window).scroll(function(){
    	$('.top').show();
    	if($(window).scrollTop() <= 200){
    		$('.top').hide();
    	}
    });


    $('.top').click(function(){
        console.log(111)
    	$(window).scrollTop(0);
    });
    
     $('.backpage').click(function(){
       history.back(-1)
    });
})

