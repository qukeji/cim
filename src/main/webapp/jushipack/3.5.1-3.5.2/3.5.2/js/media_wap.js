var dynamic_list2="";
var live_list2="";
var video_list2="";
var textimage_list2="";
var showConfig = {
	time : false ,
	read :false 
} ;
getCompanyInfo() ;
function getCompanyInfo(){ 
    $.ajax({
        url:"/apiv3.4.0/company_home_list.php?company="+companyid,
        dataType:"jsonp",
        success:function(data){
        	$(".company-name,title").text(data.result.title) ;
        	$(".watch-num").text(data.result.watchcount) ;
        	$(".company-logo img ,#shareimg img").attr("src",returnWhole(data.result.photo)) ;
        	//分享相关
        	pImg = returnWhole(data.result.photo) ;
        	Title = Desc=  data.result.title ;
        	
        	dynamic_list = dynamic_list2 =  returnWhole(data.result.dynamic) ;
        	live_list = live_list2 = returnWhole(data.result.live_list) ;
        	video_list = video_list2= returnWhole(data.result.video_list) ;
        	textimage_list = textimage_list2 =  returnWhole(data.result.textimage_list) ;
        	companyLogo  = data.result.photo ;  //媒体号头像
        	companyName = data.result.title ;   //媒体号名称
            getDynamicList();
        }
    });
}
//配置是否显示阅读数和发布时间
listConfig();
function listConfig(){
	$.ajax({
        url:'/config//appconfig.json',
        dataType:"json",
        success:function(data){
            console.log(data.showtime)
        	if(data.showtime==0){
        		showConfig.time = true ;
        	}
        	if(data.showread==0){
        		showConfig.read = true ;
        	}
        }
    });
}
function configShow(){
	if(showConfig.time){
		$(".showtime").show()
	}
	if(showConfig.read){
		$(".read-num").show()
	}
}

function getDynamicList(){	
	if(!haveNext.dynamic){
		return false;
	}
	$.ajax({
        url:dynamic_list2,
        dataType:"json",
        beforeSend:function(XMLHttpRequest){ 
        	if(startpage.dynamic>1){
        		$(".loading").show();
        	}			
		}, 
        success:function(data){
        	if(!data.list.length&&startpage.dynamic==1){
        		$(".container .item-box-li:first-of-type").find(".no-info").remove();
        		$(".container .item-box-li:first-of-type").append('<div class="no-info">没有内容哦</div>');
        		haveNext.dynamic = false ;
        		return false;
        	}
        	clearArrData();
        	startpage.dynamic ++ ;
        	dynamic_list2 = dynamic_list.replace(/1_0/, "1_0_"+startpage.dynamic) ;
        	var listHtml = "" ;        	
        	for (var i=0;i<data.list.length;i++) {        		
        		articleInfo.globalids.push(data.list[i].contentID);
        		articleInfo.parents.push(data.list[i].parent);
        		articleInfo.juxian_liveid.push(data.list[i].juxian_liveid);
        		articleInfo.juxian_companyid.push(data.list[i].juxian_companyid);       		
        	   	if(data.list[i].doc_type==4){
        	   		listHtml+='<div class="live-item juxian_live" data-url="'+data.list[i].shareliveurl+'" ids="contentID'+data.list[i].contentID+'">' +           	   				  
								'<p class="live-info"></p>'+
								'<p class="live-intro">'+data.list[i].title+'</p>'+
								'<div class="live-preview">'+
								   '<img src="'+returnWhole(data.list[i].photo)+'" class="live-preview-img">'+
								'</div>'+
								'<p class="tv-name"><span>聚现</span></p>'+
							   '</div>'
        	   		           	   		
        	   	}else{
        	   		listHtml += '<div class="live-item" data-url="'+data.list[i].sharewapurl+'" ids="contentID'+data.list[i].contentID+'">' ;
		            	   		if(data.list[i].docfrom){
		            	   			listHtml += '<div class="company-box">'+
													'<div class="img-box">'+
														'<img src="'+returnWhole(companyLogo)+'" />' +
													'</div>'+
													'<p class="text-box">'+
														'<span class="com">'+companyName+'</span>'+
														'<span class="tm"></span>'+
													'</p>'+
												'</div>'
											
        	   		}
        	   		if(data.list[i].item_type==0){
        	   		   listHtml	+='<div class="not-big-pic">'+
            	   		              '<div class="v-img-box">'+
            	   		                  '<img src="'+returnWhole(data.list[i].photo)+'" >'+
            	   		              '</div>'+
            	   		              '<div class="v-text-box">'+
            	   		              	'<p class="v-title">'+data.list[i].title+'</p>'+
            	   		              	'<div class="v-about">'+
									      '<p>'										      										      
									        if(data.list[i].content_type){
									        	listHtml+='<span class="self-type">'+data.list[i].content_type+'</span>'										        	
									        }else if(data.list[i].docfrom){
									        	listHtml+= '<span class="c-name">'+data.list[i].docfrom+'</span>' 
									        }
									      	listHtml+='<span class="read-num"><i>'+0+'</i>阅读</span>'+										      	         
									      '</p>'+	
									       '<span class="publish-time">07-06 00:26</span>'+
									  	'</div>'+
									  '</div>'+
						            '</div>'+
							'</div>'		
        	   		}else if(data.list[i].item_type==1){
        	   			listHtml+='<p class="live-intro">'+data.list[i].title+'</p>' +           	   			
						          '<div class="multiple-pics">';
						          if(data.list[i].photo){
						              listHtml+='<p><img src="'+returnWhole(data.list[i].photo)+'"></p>';
						          }
						          if(data.list[i].photo2){
						              listHtml+='<p><img src="'+returnWhole(data.list[i].photo2)+'"></p>';
						          }
						          if(data.list[i].photo3){
						              listHtml+='<p><img src="'+returnWhole(data.list[i].photo3)+'"></p>';
						          }
						          listHtml+='</div>'+
								  '<div class="v-about mg-b-7">'+
								  	'<p>' 
								  	    if(data.list[i].content_type){
								        	listHtml+='<span class="self-type">'+data.list[i].content_type+'</span>'										        	
								        }else if(data.list[i].docfrom){
								        	listHtml+= '<span class="c-name">'+data.list[i].docfrom+'</span>'
								        }
								  	listHtml+= '</p>'	+				
						          '</div>'+
							'</div>'									          
        	   		}else if(data.list[i].item_type==2){
        	   			listHtml+= '<p class="live-intro">'+data.list[i].title+'</p>' +
        	   						'<div class="live-preview">'+
        	   							'<img src="'+returnWhole(data.list[i].photo)+'" class="live-preview-img">' 
						                if(data.list[i].doc_type==1){
						                	listHtml+='<div class="play-btn"></div>'
						                }
						listHtml+='</div>'+	
									'<div class="v-about mg-y-7">'	+
									'<p>'	
									    if(data.list[i].content_type){
								        	listHtml+='<span class="self-type">'+data.list[i].content_type+'</span>'										        	
								        }else if(data.list[i].docfrom){
								        	listHtml+= '<span class="c-name">'+data.list[i].docfrom+'</span>'
								        }
								        listHtml+= '<span class="read-num"><i>11</i>阅读</span>'+								                   						        
								    '</p>'+	
								    '<span class="publish-time">07-06 00:26</span>'+		
								  '</div>'+
							'</div>'		
        	   		}
        	   		
        	   	}
        	} 
        	$(".loading").fadeOut("slow");
        	$(".container .item-box-li:first-of-type").append(listHtml);
        	if(data.list.length){
        	    getArticleInfo();
        	}
        },
        error:function(){
        	haveNext.dynamic = false ;
        	$(".loading").fadeOut("slow");
        	$(".container .item-box-li:first-of-type").find(".no-more-info").remove();
        	$(".container .item-box-li:first-of-type").append('<div class="no-more-info">没有更多内容了</div>');
        }
    });
}

function getLiveList(){ 
	if(!haveNext.live){
		return false;
	} 	
	$.ajax({
		type:"get",
		url:live_list2,
		dataType:"json",
		beforeSend:function(XMLHttpRequest){ 
        	if(startpage.live>1){
        		$(".loading").show();
        	}			
		}, 
		success:function(data){
			if(!data.list.length&&startpage.live==1){
        		$(".container .item-box-li:nth-child(2)").find(".no-info").remove();
        		$(".container .item-box-li:nth-child(2)").append('<div class="no-info">没有内容哦</div>');
        		haveNext.live = false ;
        		return false;
        	}
			startpage.live ++ ;
        	live_list2 = live_list.replace(/1_0/, "1_0_"+startpage.live) ;
        	var listHtml = "" ;
        	clearArrData();
        	for (var i=0;i<data.list.length;i++) {
        		articleInfo.globalids.push(data.list[i].contentID);
        		articleInfo.parents.push(data.list[i].parent);
        		articleInfo.juxian_liveid.push(data.list[i].juxian_liveid);
        		articleInfo.juxian_companyid.push(data.list[i].juxian_companyid); 
        		console.log(articleInfo)
        	   	if(data.list[i].doc_type==4){
        	   		listHtml+='<div class="live-item juxian_live" data-url="'+data.list[i].shareliveurl+'" ids="contentID'+data.list[i].contentID+'">' +           	   				  
								'<p class="live-info"></p>'+
								'<p class="live-intro">'+data.list[i].title+'</p>'+
								'<div class="live-preview">'+
								   '<img src="'+returnWhole(data.list[i].photo)+'" class="live-preview-img">'+
								'</div>'+
								'<p class="tv-name"><span>聚现</span></p>'+
							   '</div>'
        	   		           	   		
        	   	}
        	}
        	$(".loading").fadeOut("slow");
        	$(".container .item-box-li:nth-child(2)").append(listHtml);
        	if(data.list.length){
        	    getArticleInfo();
        	}
        	
		},
        error:function(){
        	haveNext.live = false ;
        	$(".loading").fadeOut("slow");
        	$(".container .item-box-li:nth-child(2)").find(".no-more-info").remove();
        	$(".container .item-box-li:nth-child(2)").append('<div class="no-more-info">没有更多内容了</div>');
        }
	});
}

function getVideoList(){ 
	if(!haveNext.video){
		return false;
	} 
	$.ajax({
		type:"get",
		url:video_list2,
		dataType:"json",
		beforeSend:function(XMLHttpRequest){ 
        	if(startpage.video>1){
        		$(".loading").show();
        	}			
		}, 
		success:function(data){
			if(!data.list.length&&startpage.video==1){
        		$(".container .item-box-li:nth-child(3)").find(".no-info").remove();
        		$(".container .item-box-li:nth-child(3)").append('<div class="no-info">没有内容哦</div>');
        		haveNext.video = false ;
        		return false;
        	}
			startpage.video ++ ;
        	video_list2 = video_list.replace(/1_0/, "1_0_"+startpage.video) ;
        	var listHtml = "" ; 
        	clearArrData();
        	for (var i=0;i<data.list.length;i++) {
        		articleInfo.globalids.push(data.list[i].contentID);
        		articleInfo.parents.push(data.list[i].parent);
        		articleInfo.juxian_liveid.push(data.list[i].juxian_liveid);
        		articleInfo.juxian_companyid.push(data.list[i].juxian_companyid);      
        	   	if(data.list[i].doc_type==1){
        	   		listHtml += '<div class="live-item" data-url="'+data.list[i].sharewapurl+'" ids="contentID'+data.list[i].contentID+'">' ;
		            	   		if(data.list[i].docfrom){
		            	   			listHtml += '<div class="company-box">'+
													'<div class="img-box">'+
														'<img src="'+returnWhole(companyLogo)+'" />' +
													'</div>'+
													'<p class="text-box">'+
														'<span class="com">'+companyName+'</span>'+
														'<span class="tm"></span>'+
													'</p>'+
												'</div>'											
        	   		}
        	   		if(data.list[i].item_type==0){
        	   		    listHtml +='<div class="not-big-pic">'+
            	   		              '<div class="v-img-box">'+
            	   		                  '<img src="'+returnWhole(data.list[i].photo)+'" >'+
            	   		              '</div>'+
            	   		              '<div class="v-text-box">'+
            	   		              	'<p class="v-title">'+data.list[i].title+'</p>'+
            	   		              	'<div class="v-about">'+
									      '<p>'										      										      
									        if(data.list[i].content_type){
									        	listHtml+='<span class="self-type">'+data.list[i].content_type+'</span>'										        	
									        }else if(data.list[i].docfrom){
									        	listHtml+= '<span class="c-name">'+data.list[i].docfrom+'</span>' 
									        }
									      	listHtml+='<span class="read-num"><i>'+0+'</i>阅读</span>'+										      	         
									      '</p>'+	
									       '<span class="publish-time">07-06 00:26</span>'+
									  	'</div>'+
									  '</div>'+
						            '</div>'+
							'</div>'		
        	   		}else if(data.list[i].item_type==1){
        	   			listHtml+='<p class="live-intro">'+data.list[i].title+'</p>' +           	   			
						          '<div class="multiple-pics">' ;
							           if(data.list[i].photo){
    						              listHtml+='<p><img src="'+returnWhole(data.list[i].photo)+'"></p>';
    						          }
    						          if(data.list[i].photo2){
    						              listHtml+='<p><img src="'+returnWhole(data.list[i].photo2)+'"></p>';
    						          }
    						          if(data.list[i].photo3){
    						              listHtml+='<p><img src="'+returnWhole(data.list[i].photo3)+'"></p>';
    						          }	
						           listHtml+= '</div>'+
								  '<div class="v-about mg-b-7">'+
								  	'<p>' 
								  	    if(data.list[i].content_type){
								        	listHtml+='<span class="self-type">'+data.list[i].content_type+'</span>'										        	
								        }else if(data.list[i].docfrom){
								        	listHtml+= '<span class="c-name">'+data.list[i].docfrom+'</span>'
								        }
								  	listHtml+= '</p>'	+				
						          '</div>'+
							'</div>'									          
        	   		}else if(data.list[i].item_type==2){
        	   			listHtml+= '<p class="live-intro">'+data.list[i].title+'</p>' +
        	   						'<div class="live-preview">'+
        	   							'<img src="'+returnWhole(data.list[i].photo)+'" class="live-preview-img">' 
						                if(data.list[i].doc_type==1){
						                	listHtml+='<div class="play-btn"></div>'
						                }
						listHtml+='</div>'+	
									'<div class="v-about mg-y-7">'	+
									'<p>'	
									    if(data.list[i].content_type){
								        	listHtml+='<span class="self-type">'+data.list[i].content_type+'</span>'										        	
								        }else if(data.list[i].docfrom){
								        	listHtml+= '<span class="c-name">'+data.list[i].docfrom+'</span>'
								        }
								        listHtml+= '<span class="read-num"><i>11</i>阅读</span>'+								                   						        
								    '</p>'+	
								    '<span class="publish-time">07-06 00:26</span>'+		
								  '</div>'+
							'</div>'		
        	   		}            	   		           	   		
        	   	}
        	}
        	$(".loading").fadeOut("slow");
        	$(".container .item-box .item-box-li:nth-child(3)").append(listHtml);
        	if(data.list.length){
        	    getArticleInfo();
        	}
		},
        error:function(){
        	haveNext.video = false ;
        	$(".loading").fadeOut("slow");
        	$(".container .item-box-li:nth-child(3)").find(".no-more-info").remove();
        	$(".container .item-box-li:nth-child(3)").append('<div class="no-more-info">没有更多内容了</div>');
        }
	});
}
function getTextImgList(){ 
	if(!haveNext.textImg){
		return false;
	} 
	$.ajax({
		type:"get",
		url:textimage_list2,
		dataType:"json",
		beforeSend:function(XMLHttpRequest){ 
        	if(startpage.textImg>1){
        		$(".loading").show();
        	}			
		}, 
		success:function(data){
			if(!data.list.length&&startpage.textImg==1){
        		$(".container .item-box-li:nth-child(4)").find(".no-info").remove();
        		$(".container .item-box-li:nth-child(4)").append('<div class="no-info">没有内容哦</div>');
        		haveNext.textImg = false ;
        		return false;
        	}
			startpage.textImg ++ ;
        	textimage_list2 = textimage_list.replace(/1_0/, "1_0_"+startpage.textImg) ;
        	var listHtml = "" ;
        	clearArrData();
        	for (var i=0;i<data.list.length;i++) {
        		articleInfo.globalids.push(data.list[i].contentID);
        		articleInfo.parents.push(data.list[i].parent);
        		articleInfo.juxian_liveid.push(data.list[i].juxian_liveid);
        		articleInfo.juxian_companyid.push(data.list[i].juxian_companyid);      
        	   	if(data.list[i].doc_type==0){
        	   		listHtml += '<div class="live-item" data-url="'+data.list[i].sharewapurl+'" ids="contentID'+data.list[i].contentID+'">' ;
		            	   		if(data.list[i].docfrom){
		            	   			listHtml += '<div class="company-box">'+
													'<div class="img-box">'+
														'<img src="'+returnWhole(companyLogo)+'" />' +
													'</div>'+
													'<p class="text-box">'+
														'<span class="com">'+companyName+'</span>'+
														'<span class="tm"></span>'+
													'</p>'+
												'</div>'											
        	   		}
        	   		if(data.list[i].item_type==0){
        	   		   listHtml	+='<div class="not-big-pic">'+
            	   		              '<div class="v-img-box">'+
            	   		                  '<img src="'+returnWhole(data.list[i].photo)+'" >'+
            	   		              '</div>'+
            	   		              '<div class="v-text-box">'+
            	   		              	'<p class="v-title">'+data.list[i].title+'</p>'+
            	   		              	'<div class="v-about">'+
									      '<p>'										      										      
									        if(data.list[i].content_type){
									        	listHtml+='<span class="self-type">'+data.list[i].content_type+'</span>'										        	
									        }else if(data.list[i].docfrom){
									        	listHtml+= '<span class="c-name">'+data.list[i].docfrom+'</span>' 
									        }
									      	listHtml+='<span class="read-num"><i>'+0+'</i>阅读</span>'+										      	         
									      '</p>'+	
									       '<span class="publish-time">07-06 00:26</span>'+
									  	'</div>'+
									  '</div>'+
						            '</div>'+
							'</div>'		
        	   		}else if(data.list[i].item_type==1){
        	   			listHtml+='<p class="live-intro">'+data.list[i].title+'</p>' +           	   			
						          '<div class="multiple-pics">' ;
							          if(data.list[i].photo){
    						              listHtml+='<p><img src="'+returnWhole(data.list[i].photo)+'"></p>';
    						          }
    						          if(data.list[i].photo2){
    						              listHtml+='<p><img src="'+returnWhole(data.list[i].photo2)+'"></p>';
    						          }
    						          if(data.list[i].photo3){
    						              listHtml+='<p><img src="'+returnWhole(data.list[i].photo3)+'"></p>';
    						          }				
						          listHtml+='</div>'+
								  '<div class="v-about mg-b-7">'+
								  	'<p>' 
								  	    if(data.list[i].content_type){
								        	listHtml+='<span class="self-type">'+data.list[i].content_type+'</span>'										        	
								        }else if(data.list[i].docfrom){
								        	listHtml+= '<span class="c-name">'+data.list[i].docfrom+'</span>'
								        }
								  	listHtml+= '</p>'	+				
						          '</div>'+
							'</div>'									          
        	   		}else if(data.list[i].item_type==2){
        	   			listHtml+= '<p class="live-intro">'+data.list[i].title+'</p>' +
        	   						'<div class="live-preview">'+
        	   							'<img src="'+returnWhole(data.list[i].photo)+'" class="live-preview-img">' 
						                if(data.list[i].doc_type==1){
						                	listHtml+='<div class="play-btn"></div>'
						                }
						listHtml+='</div>'+	
									'<div class="v-about mg-y-7">'	+
									'<p>'	
									    if(data.list[i].content_type){
								        	listHtml+='<span class="self-type">'+data.list[i].content_type+'</span>'										        	
								        }else if(data.list[i].docfrom){
								        	listHtml+= '<span class="c-name">'+data.list[i].docfrom+'</span>'
								        }
								        listHtml+= '<span class="read-num"><i>11</i>阅读</span>'+								                   						        
								    '</p>'+	
								    '<span class="publish-time">07-06 00:26</span>'+		
								  '</div>'+
							'</div>'		
        	   		}            	   		           	   		
        	   	}
        	}
        	$(".loading").fadeOut("slow");
        	$(".container .item-box-li:nth-child(4)").append(listHtml);
        	if(data.list.length){
        	    getArticleInfo();
        	}
		},
        error:function(){
        	haveNext.textImg = false ;
        	$(".loading").fadeOut("slow");
        	$(".container .item-box-li:nth-child(4)").find(".no-more-info").remove();
        	$(".container .item-box-li:nth-child(4)").append('<div class="no-more-info">没有更多内容了</div>');
        }
	});
}

//获得文章详情
function getArticleInfo(){
	var gid = articleInfo.globalids.toString() ;
	var parents = articleInfo.parents.toString() ;
	var liveid = articleInfo.juxian_liveid.toString() ;
	var companyid = articleInfo.juxian_companyid.toString() ;
	$.ajax({
		type:"get",
		url:"/apiv3.4.0/get_article_info.php",
		dataType:"json",
		data:{
			globalids:gid , parents:parents , juxian_liveid:liveid , juxian_companyid:companyid
		},
		success:function(data){			
			var _obj = null ;
			for (var i=0;i<data.result.length;i++) {
				   
				_obj=$(".live-item[ids='contentID"+data.result[i].globalid+"']")
				//console.log(_obj)
				_obj.find(".tm").addClass("showtime").text(data.result[i].date);
				_obj.find(".read-num i").text(data.result[i].readcount);
				//_obj.find(".read-num").show();
				_obj.find(".publish-time").text(data.result[i].date);
				if(!_obj.find(".tm").length){
					_obj.find(".publish-time").addClass("showtime");
				}
				if(_obj.find(".live-info").length){				
					var _html = "" ;
					if(data.result[i].livestatus==0){
						_html = '<span class="live-state live-state-wait"><i>•</i>未直播</span><span class="onlookers"><code>'+data.result[i].views+'</code>人关注</span>'
					}else if(data.result[i].livestatus==1){
						_html = '<span class="live-state live-state-live"><i>•</i>正在直播</span><span class="onlookers"><code>'+data.result[i].views+'</code>人关注</span>'
					}else if(data.result[i].livestatus==2){
						_html = '<span class="live-state live-state-review"><i>•</i>已结束</span><span class="onlookers"><code>'+data.result[i].views+'</code>人关注</span>'
					}					
					//console.log(123,_obj.find(".live-info"))
					_obj.find(".live-info").html(_html).css("display","flex");
				}
				
			}
			configShow();
		},
        error:function(){
        	
        }
	});

}

;$(function(){	
	$(".media-type ul li").click(function(){
		var _index = $(this).index();
		$(this).siblings().removeClass("ac").end().addClass("ac");
		tabOn = _index ;  
		console.log(_index);
		$(".container .item-box .item-box-li").hide().eq(_index).show();
		switch (_index){
			case 0:
		    if(!everFirstClick.dynamic){
	    		return
	    	}
		    getDynamicList();
	    	everFirstClick.dynamic = false ;      				
				break;
			case 1:
		    if(!everFirstClick.live){
	    		return
	    	}
		    getLiveList();
	    	everFirstClick.live = false ;      				
				break;
			case 2:
			if(!everFirstClick.video){
	    		return
	    	}
		    getVideoList();
	    	everFirstClick.video = false ;      		
				break;
			case 3:
		    if(!everFirstClick.textImg){
	    		return
	    	}
		    getTextImgList();
	    	everFirstClick.textImg = false ;     				
				break;
			default:
				break;
		}
    })
	
	//滚动的上拉刷新
    $(window).scroll(function(){  	
    			    
        if($(document).scrollTop() >= $(document).height()-$(window).height()) {
	        switch (tabOn){
	        	case 0:
	        	getDynamicList();
	        		break;
	        	case 1:
	        	getLiveList();
	        		break;
	        	case 2:
	        	getVideoList();
	        		break;
	        	case 3:
	        	getTextImgList();
	        		break;
	        	default:
	        		break;
	        }	        
	        return false;
    	}
    });
    
    //点击跳转
    $(".container").delegate(".live-item", "click", function(){ 
    	var _url = returnWhole( $(this).attr('data-url') ) ;
		window.open( _url ,"_blank");  //_blank在新的窗口打开页面
    });
})

//获得完整地址
function returnWhole(_url){
	if(_url.substr(0,4)!="http"){
       _url  = ""+siteUrl + _url  ;
    } 
    return _url ;
}
//清空参数数组
function clearArrData(){
	articleInfo.globalids.splice( 0 , articleInfo.globalids.length );//
	articleInfo.parents.splice( 0 , articleInfo.parents.length );//
	articleInfo.juxian_liveid.splice( 0 , articleInfo.juxian_liveid.length );//
	articleInfo.juxian_companyid.splice( 0 , articleInfo.juxian_companyid.length );//	
}

// 返回顶部
$(window).scroll(function(){
	$('.top').show();
	if($(window).scrollTop() <= 200){
		$('.top').hide();
	}
});
$('.top').click(function(){
	$(window).scrollTop(0);
});
		    
