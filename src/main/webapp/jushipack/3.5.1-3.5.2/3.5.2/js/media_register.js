var Global={
	init:function() {
		this.htmlFontSize();
	},
	//设置根元素的font-size
	htmlFontSize:function(){
		var doc = document;
		var win = window;
		function initFontSize(){
			var docEl = doc.documentElement,
				resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
				recalc = function(){
					var clientWidth = docEl.clientWidth;
					if(!clientWidth) return;
					if(clientWidth>750){
						clientWidth=750;
					}
					fontSizeRate = (clientWidth / 375);
					var baseFontSize = 50*fontSizeRate;
					docEl.style.fontSize =  baseFontSize + 'px';
				}
			recalc();
			if(!doc.addEventListener) return;
			win.addEventListener(resizeEvt, recalc, false);
			doc.addEventListener('DOMContentLoaded', recalc,false);
		}
		initFontSize();
	}

};
Global.init();
//读取地址栏参数
function getUrl(name) {
	 var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
	 var r = window.location.search.substr(1).match(reg);
	 if(r!=null)return  unescape(r[2]); return null;
};
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
//写cookies
function setCookie(name,value){
	var Days = 30;
	var exp = new Date();
	exp.setTime(exp.getTime() + Days*24*60*60*1000);
	document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}
function getCookie(name){
	var cookies = {};
	document.cookie.split(";").map(function(i){
		var cookie = i.trim().split('=');
		cookies[cookie[0]] = cookie[1];
	});
	return cookies[name];
}
function getCookies(name) {
	var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
	if (arr != null) return unescape(arr[2]); return null;
};
			
function delCookie(name){
	var exp = new Date();
	exp.setTime(exp.getTime() - 1);
	var cval=getCookie(name);
	if(cval!=null)
	document.cookie= name + "="+cval+";expires="+exp.toGMTString();
}				

var ipurl="/apiv3.5.2";
var session= getUrl("session");
var site=53;
$(function(){
    //var _phone=getUrl("phone");
    $(".submit").click(function(){
        setCookie("action",1);
        $(".media-container").hide();
        $(".application").show();
        //window.location.href="application.html";
    });
    //个人认证显示
    $(".media-personal").click(function(){
    	$(".media-container").hide();
    	$(".personalAuthentication").show();
    });
    //组织认证显示
    $(".media-org").click(function(){
    	$(".media-container").hide();
    	$(".organization").show();
    });
    // 页面初始化
    $.ajax({
    	type:"get",
    	url:ipurl+"/company_register_check.php",
    	data:{"session":session,"site":site},
    	dataType :"jsonp",
    	jsonp:"callback",
    	success:function(data){
    		console.log(data)
    		if(data.code==200){
    			if(data.mediaIdState==1){
    				$(".media-container").hide();
    				$(".organizationIn").show();
    			}else if(data.mediaIdState==3){
    				if(getCookie("action") && getCookie("action")==1){
    					$(".media-container").hide();
    					$(".application").show();
    				}else{
    				    $(".media-container").hide();
    				    $(".organizationSubmittedFail .p2").html(data.msg);
    				    $(".organizationSubmittedFail").show();
    				}
    			}else{
    			   $(".media-container").hide();
    			   $(".application").show();
    			}
    		  //  if(data.mediaIdState==1){
    		  //      commonPop("审核中"); 
    		  //  }else if(data.mediaIdState==2){
    		  //      commonPop("审核成功"); 
    		  //  }else if(data.mediaIdState==3){
    		  //      commonPop("审核失败"); 
    		  //  }else{
    				
    		  //  }
    		}else{
    			commonPop(data.message); 
    		}
    	},
    	error:function(){
    	}
    });
    
    //个人认证提交
    
    $("#submit_personal").click(function(){
        var type=0;
    	var name=$("#personal-name").val();
    	var email=$("#personal-email").val();
    	var summary=$(".personalAuthentication textarea").val();
    	var callback="callback";
    	if(!name){
    		commonPop("请输入个人名称"); 
    		return false;
    	}
    	if(!email){
    		commonPop("请输入邮箱"); 
    		return false;
    	}
    	var reg = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
        if (!reg.test(email)) {
            commonPop("邮箱格式不正确，请重新输入！");
            return false;
        }
    	if(!summary){
    		commonPop("请输入简介"); 
    		return false;
    	}
    	var _data={};
    	if(getCookie("action")){
    	    _data={"session":session,"site":site,"type":type,"name":name,"email":email,"summary":summary,"action":getCookie("action")}
    	}else{
    	    _data={"session":session,"site":site,"type":type,"name":name,"email":email,"summary":summary,"action":0}
    	    
    	}
    	$.ajax({
    		type:"get",
    		url:ipurl+"/company_register.php",
    		data:_data,
    		dataType :"jsonp",
    		jsonp:"callback",
    		success:function(data){
    			console.log(data)
    			if(data.code==200){
    			   	commonPop(data.message); 
    			   	delCookie("action");
    			   	//setTimeout(function(){window.location.href="application.html";},500);
    				$(".media-container").hide();
    				$(".organizationSubmitted").show();
    			}else{
    			    commonPop(data.message); 
    			}
    		},
    		error:function(){
    		}
    	});
    })
    
    // 组织认证选择
    $(".organization .media-items").click(function(){
    	var _text=$(this).attr("data-text");
    	$(".company_type").html(_text);
    	$(".media-container").hide();
    	$(".organizationalCertification").show();
    	
    });
    
    // 组织提交
    
    //企业默认封面图
    $("#avatar").change( function(){
    	if( doUpload( this ) ){
    		uploadImg( $(".upload-avatars") )
    	}	
    } )	
    $("#upload").change( function(){
    	if( doUpload( this ) ){
    		uploadImgs( $(".upload-form") )
    	}	
    } )	
    $(".close").click(function(){
    	$(this).hide();
    	$("#upload-img").attr({"src":""});
    	$("#upload-img,.picture-preview").hide();
    });
    //提交
    
    $("#submit_btn").click(function(){
        //alert(session);
        var type=1;
    	var company_type=$(".organizationalCertification .company_type").html();
    	var name=$("#organizational-name").val();
    	var email=$("#email").val();
    	var avatar=$("#avatar-img").attr("src");
    	var photo=$("#upload-img").attr("src");
    	
    	var summary=$(".organizationalCertification textarea").val();
    	var callback="callback";
    	if(!name){
    		commonPop("请输入组织名称"); 
    		return false;
    	}
    	if(!photo){
    		commonPop("请上传图片"); 
    		return false;
    	}
    	if(!email){
    		commonPop("请输入邮箱"); 
    		return false;
    	}
    	var reg = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
        if (!reg.test(email)) {
            commonPop("邮箱格式不正确，请重新输入！");
            return false;
        }
    	if(!summary){
    		commonPop("请输入简介"); 
    		return false;
    	}
		var _company_type=1;
		if(company_type=="群媒体"){
		    _company_type=1;
		}else if(company_type=="新闻媒体"){
		    _company_type=2;
		}else if(company_type=="国家机构"){
		    _company_type=3;
		}else if(company_type=="企业"){
		    _company_type=4;
		}else if(company_type=="其他组织"){
		    _company_type=5;
		}
    	var _data={};
    	if(getCookie("action")){
    	    _data={"session":session,"site":site,"type":type,"company_type":_company_type,"name":name,"email":email,"summary":summary,"avatar":avatar,"photo":photo,"action":getCookie("action")}
    	}else{
    	    _data={"session":session,"site":site,"type":type,"company_type":_company_type,"name":name,"email":email,"summary":summary,"avatar":avatar,"photo":photo,"action":0}
    	    
    	}
    	$.ajax({
    		type:"get",
    		url:ipurl+"/company_register.php",
    		data:_data,
    		dataType :"jsonp",
    		jsonp:"callback",
    		success:function(data){
    			console.log(data)
    			if(data.code==200){
    			   	commonPop(data.message); 
    			   	delCookie("action");
    			   	$(".media-container").hide();
    			   	$(".organizationSubmitted").show();
    			}else{
    			    commonPop(data.message); 
    			}
    		},
    		error:function(){
    		}
    	});
    })
    
})
    
    function doUpload(that){
    var file=that.files[0];
    if(!/image\/\w+/.test(file.type)){
    	commonPop("文件必须为图片！");
    	return false;
    }else{
    	return true;
    }
    }	
    //图片上传函数
    function uploadImgs(ele){	
    var formData = new FormData(ele[0]);
    $.ajax({   
    	 url:ipurl+"/file_upload.php",     
    	 data:formData,   
    	 type:"post",
    	 dataType:"json",
    	 async:false,
    	 cache:false,
    	 contentType:false,
    	 processData:false,
    	 success:function(data){   
    		if(data.status==1){				                	
    			$(".picture-preview img").attr("src",data.result.url);
    			$(".picture-preview img,.picture-preview,.picture-preview span").css("display","block");
    		 }else{
    			commonPop("上传图片失败");			                   
    		 }
    	 }
    	 
    })
    }
    function uploadImg(ele){	
    var formData = new FormData(ele[0]);
    $.ajax({   
    	 url:ipurl+"/file_upload.php",     
    	 data:formData,   
    	 type:"post",
    	 dataType:"json",
    	 async:false,
    	 cache:false,
    	 contentType:false,
    	 processData:false,
    	 success:function(data){   
    		if(data.status==1){				                	
    			$(".avatar-preview img").attr("src",data.result.url);
    		 }else{
    			commonPop("上传图片失败");			                   
    		 }
    	 }
    	 
    })
    }
