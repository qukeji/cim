/*!
 * Bracket Plus v1.0.0 (https://themetrace.com/bracketplus)
 * Copyright 2017-2018 ThemePixels
 * Licensed under ThemeForest License
 */

 'use strict';

 $(document).ready(function(){

  // This will auto show sub menu using the slideDown()
  // when top level menu have a class of .show-sub
  //$('.show-sub + .br-menu-sub').slideDown();



  // This will collapsed sidebar menu on left into a mini icon menu
  $('#btnLeftMenu').on('click', function(){
    var menuText = $('.menu-item-label,.menu-item-arrow');
    
    if($('body').hasClass('collapsed-menu')) {
      $('body').removeClass('collapsed-menu');
      
      // show current sub menu when reverting back from collapsed menu
      $('.show-sub + .br-menu-sub').slideDown();
      $("#system-menu").slideDown();
      $('.br-sideleft').one('transitionend', function(e) {
        menuText.removeClass('op-lg-0-force');
        menuText.removeClass('d-lg-none');
        menuText.css({
	          "display":"block",
	          "opacity":"1"
	      })
      });			

    } else {
      $('body').addClass('collapsed-menu');

      // hide toggled sub menu
      $('.show-sub + .br-menu-sub').slideUp();
      
      menuText.addClass('op-lg-0-force');
      $('.br-sideleft').one('transitionend', function(e) {
        menuText.addClass('d-lg-none');
      });			
    }
    return false;
  });



  // This will expand the icon menu when mouse cursor points anywhere
  // inside the sidebar menu on left. This will only trigget to left sidebar
  // when it's in collapsed mode (the icon only menu)
//$(document).on('mouseover', function(e){
//  e.stopPropagation();
//  
//  if($('body').hasClass('collapsed-menu') && $('#btnLeftMenu').is(':visible')) {
//    var targ = $(e.target).closest('.br-sideleft').length;
//    if(targ) {
//      $('body').addClass('expand-menu');
//
//      // show current shown sub menu that was hidden from collapsed
//      $('.show-sub + .br-menu-sub').slideDown();
//
//      var menuText = $('.menu-item-label,.menu-item-arrow');
//      menuText.removeClass('d-lg-none');
//      menuText.removeClass('op-lg-0-force');
//
//    } else {
//      $('body').removeClass('expand-menu');
//
//      // hide current shown menu
//      $('.show-sub + .br-menu-sub').slideUp();
//
//      var menuText = $('.menu-item-label,.menu-item-arrow');
//      menuText.addClass('op-lg-0-force');
//      menuText.addClass('d-lg-none');
//    }
//  }
//});



  // This will show sub navigation menu on left sidebar
  // only when that top level menu have a sub menu on it.
  $('.br-menu-link').on('click', function(){
    var nextElem = $(this).next();
    var thisLink = $(this);

    if(nextElem.hasClass('br-menu-sub')) {

      if(nextElem.is(':visible')) {
        thisLink.removeClass('show-sub');
        nextElem.slideUp();
      } else {
        $('.br-menu-link').each(function(){
          $(this).removeClass('show-sub');
        });

        $('.br-menu-sub').each(function(){
        	if(!$(this).prev().hasClass("active")){
        		 $(this).slideUp();
        	}
        });

        thisLink.addClass('show-sub');
        nextElem.slideDown();
      }
      return false;
    }
  });



  // This will trigger only when viewed in small devices
  // #btnLeftMenuMobile element is hidden in desktop but
  // visible in mobile. When clicked the left sidebar menu
  // will appear pushing the main content.
  $('#btnLeftMenuMobile').on('click', function(){
    $('body').addClass('show-left');
    return false;
  });



  // This is the right menu icon when it's clicked, the
  // right sidebar will appear that contains the four tab menu
  $('#btnRightMenu').on('click', function(){
    $('body').addClass('show-right');
    return false;
  });



  // This will hide sidebar when it's clicked outside of it
  $(document).on('click', function(e){
    e.stopPropagation();

    // closing left sidebar
    if($('body').hasClass('show-left')) {
      var targ = $(e.target).closest('.br-sideleft').length;
      if(!targ) {
        $('body').removeClass('show-left');
      }
    }

    // closing right sidebar
    if($('body').hasClass('show-right')) {
      var targ = $(e.target).closest('.br-sideright').length;
      if(!targ) {
        $('body').removeClass('show-right');
      }
    }
  });



  // displaying time and date in right sidebar
//var interval = setInterval(function() {
//  var momentNow = moment();
//  $('#brDate').html(momentNow.format('MMMM DD, YYYY') + ' '
//    + momentNow.format('dddd')
//    .substring(0,3).toUpperCase());
//    $('#brTime').html(momentNow.format('hh:mm:ss A'));
//}, 100);

  // Datepicker
  if($().datepicker) {
    $('.form-control-datepicker').datepicker()
      .on("change", function (e) {
        console.log("Date changed: ", e.target.value);
    });
  }


  // custom scrollbar style
  try{
	 $('.overflow-y-auto').perfectScrollbar();	
  }catch(e){console.log(e)}
  
  // jquery ui datepicker
  try{
	 $('.datepicker').datepicker();	
  }catch(e){console.log(e)}
  
  // switch button
  try{
	 $('.switch-button').switchButton();
  }catch(e){console.log(e)}
  

  // peity charts
 // $('.peity-bar').peity('bar');

  // highlight syntax highlighter
  $('pre code').each(function(i, block) {
    hljs.highlightBlock(block);
  });

  // Initialize tooltip
  //$('[data-toggle="tooltip"]').tooltip();

  // Initialize popover
  $('[data-popover-color="default"]').popover();



  // By default, Bootstrap doesn't auto close popover after appearing in the page
  // resulting other popover overlap each other. Doing this will auto dismiss a popover
  // when clicking anywhere outside of it
  $(document).on('click', function (e) {
    $('[data-toggle="popover"],[data-original-title]').each(function () {
        //the 'is' for buttons that trigger popups
        //the 'has' for icons within a button that triggers a popup
        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
            (($(this).popover('hide').data('bs.popover')||{}).inState||{}).click = false  // fix for BS 3.3.6
        }

    });
  });



  // Select2 Initialize
  // Select2 without the search
  if($().select2) {
    $('.select2').select2({
      minimumResultsForSearch: Infinity
    });

    // Select2 by showing the search
    $('.select2-show-search').select2({
      minimumResultsForSearch: ''
    });

    // Select2 with tagging support
    $('.select2-tag').select2({
      tags: true,
      tokenSeparators: [',', ' ']
    });
  }

});

//初始化开关
try{
	if($('.toggle').length){
		$('.toggle').toggles({        
		  height: 25
		});
	}
}catch(e){
}

//获取是否开或关
$(".toggle").click(function(){
	var myToggle = $(this).data('toggle-active');
	var field = $(this).attr("field");

	if(myToggle){
		$("#"+field).val("1") ;//开
	}else{
		$("#"+field).val("0") ;//关
	}
})


//侧边栏封装
;(function($) {
	var ms = {
		addMessageIcon:function(obj){
			return(function() {
				var iconHtml = '<div class="navicon-right"> \
					<a id="btnRightMenu" href="javascript:;" class="pos-relative"> \
						<i class="icon fa fa-comments-o tx-28"></i> \
			            <span class="square-8 bg-danger pos-absolute t-10 r--5 rounded-circle"></span> \
			            </a> \
			        </div>' ;
				obj.find(".br-header-right").append(iconHtml)	;
			})();
		},
		addTabs : function(){
			return(function() {
				var siderRightHtml =  '<div class="br-sideright"> \
			      <ul class="nav nav-tabs sidebar-tabs" role="tablist">\
			        <li class="nav-item"> \
			          <a class="nav-link active" data-index="0" data-toggle="tab" role="tab" href="#contacts"><i class="fa fa-star-o tx-24"></i></a>\
			        </li>\
			        <li class="nav-item">\
			          <a class="nav-link " data-index="1" data-toggle="tab" role="tab" href="#attachments"><i class="fa fa-user-o tx-22"></i></a>\
			        </li>\
			        <li class="nav-item">\
			          <a class="nav-link" data-index="2" data-toggle="tab" role="tab" href="#calendar"><i class="fa fa-bell-o tx-22"></i></a>\
			        </li>\
			        <li class="nav-item">\
			          <a class="nav-link" data-index="3" data-toggle="tab" role="tab" href="#settings"><i class="fa fa-file-o tx-22"></i></a>\
			        </li>\
			      </ul>\
			      <div class="tab-content">\
			      	<div class="tab-pane pos-absolute a-0 mg-t-60 overflow-y-auto active" id="contacts" role="tabpanel">\
			      		<div class="d-flex justify-content-center">\
			      			<a href="javascript:;" class="wd-180 btn btn-primary mg-y-10" onclick="siderightNewContent();">新建内容</a>\
			      		</div>\
			      		<div class="item-yyzc">\
				        	<label class="sidebar-label pd-x-25 mg-t-15 opacity-1">运营支撑</label>\
				            <div class="contact-list pd-x-10">\
				          	</div>\
				        </div>\
				        <div class="item-yyfb">\
							<label class="sidebar-label pd-x-25 mg-t-15 opacity-1">应用发布</label>\
				            <div class="contact-list pd-x-10">\
				          	</div>\
				        </div>\
				        <div class="item-zyhj">\
				          	<label class="sidebar-label pd-x-25 mg-t-15 opacity-1">资源汇聚</label>\
				            <div class="contact-list pd-x-10">\
				          	</div>\
				        </div>\
			          	<div class="item-scgj">\
				          	<label class="sidebar-label pd-x-25 mg-t-15 opacity-1">生产工具</label>\
				            <div class="contact-list pd-x-10">\
				          	</div>\
			        	</div>\
			        </div>\
			        <div class="tab-pane pos-absolute a-0 mg-t-60 overflow-y-auto" id="attachments" role="tabpanel">\
			          <div class="item-online">\
				          <label class="sidebar-label pd-x-25 mg-t-25 tx-white opacity-1 line-num">在线人员（0）</label>\
				          <div class="contact-list pd-x-10">\
				          </div>\
				       </div>\
				       <div class="item-outline">\
				          <label class="sidebar-label pd-x-25 mg-t-25 tx-white opacity-1 line-num">离线人员（0）</label>\
				          <div class="contact-list pd-x-10">\
				          </div>\
				        </div>  \
			        </div>\
			        <div class="tab-pane pos-absolute a-0 mg-t-60 overflow-y-auto" id="calendar" role="tabpanel">\
					  <audio style="dispaly:none;"><source id="shsource" src="" type="audio/mp3"></audio>\
			          <label class="sidebar-label pd-x-25 mg-t-25 tx-white opacity-1">待审核（<span class="dsh-num"></span>）</label>\
			          <div class="media-file-list dsh-container">\
			          </div>\
			        </div>\
			        <div class="tab-pane pos-absolute a-0 mg-t-60 overflow-y-auto" id="settings" role="tabpanel">\
			          <label class="sidebar-label pd-x-25 mg-t-25 tx-white opacity-1">最近编辑内容</label>\
			          <div class="media-file-list recentEdit">	\
			          </div>\
			        </div>\
			      </div>\
			    </div>';			    
			    $("body").append(siderRightHtml);
			    ms.fillHtmlOne();
			    //ms.fillHtmlThree(); //第一次检测
			    ms.bindEvent(".sidebar-tabs")
			    
			})();
		},
		//填充html
		fillHtmlOne: function() {
			return(function() {				
				$.ajax({
					url:"/tcenter/content/media_list.jsp",	
					type:"get",
			        dataType : 'jsonp',
					success :function(data){				
						if(data[0].yyzc.length){
							var yyzcHtml = splitHtml(data[0].yyzc);
							$(".item-yyzc .contact-list").html(yyzcHtml);
						}
						if(data[0].yyfb.length){
							var yyfbHtml = splitHtml(data[0].yyfb);
							$(".item-yyfb .contact-list").html(yyfbHtml);
						}
						if(data[0].zyhj.length){
							var zyhjHtml = splitHtml(data[0].zyhj);
							$(".item-zyhj .contact-list").html(zyhjHtml);
						}
						if(data[0].scgj.length){
							var scgjHtml = splitHtml(data[0].scgj);
							$(".item-scgj .contact-list").html(scgjHtml);
						}
					},
					error:function(e){
						console.log(e)						
					}
				});				
			})();
				
			function splitHtml(data){
				var _html  = "" ;
				for (var i=0 ;i<data.length;i++) {
					_html += '<a href="'+data[i].Url+'" class="contact-list-link" target="_blank">'+
						'<div class="d-flex">'+
							'<div class="pos-relative bg-item bg-yyzc"> '+data[i].logo+
							'</div>'   +
							'<span class="tx-white tx-14 mg-l-10"> '+data[i].prjname+'</span>'+
						'</div>'+
					'</a>'
				}
				return _html ;
			}
		},
		fillHtmlTwo: function() {
			$.ajax({
					url:"/tcenter/content/company_for_user.jsp",	
					type:"get",
			        dataType : 'json',
					success :function(data){									
						console.log(data)
						if(data.JuxianID){
							getJxData(data.JuxianID)
						}else{
							return false;
						}
					},
					error:function(e){
						console.log(e)						
					}
				});			
			function getJxData(companyid){			
				$.ajax({
					url:"http://api.juyun.tv/api/user_list.php?id="+companyid,	
					type:"get",
			        dataType : 'jsonp',
					success :function(data){									
						var d = data.result.list ,
						online = 0,
						outline = 0 ,
						onlineHtml  = "" ,
						outlineHtml = "" ;
						if(d.length>0){
							for (var i =0 ; i<d.length ;i++) {
								if(d[i].online==1){
									onlineHtml += '<a href="javascript:;" class="contact-list-link new">\
										<div class="d-flex">\
							                <div class="pos-relative">\
							                  <img src="'+d[i].photo+'" class="wd-40 rounded-circle" alt="">\
							                  <div class="contact-status-indicator bg-success"></div>\
							                </div>\
							                <div class="contact-person">\
							                  <p class="mg-b-0">'+d[i].title+'</p>\
							                  <span class="tx-12 op-5 d-inline-block">系统用户</span>\
							                </div>\
							                <span class="tx-info tx-12" style="display:none"><span class="square-8 bg-info rounded-circle"></span> 1 new</span>\
							            </div>\
							        </a>' ;
							        online ++ ;
							     
								}else{
									outlineHtml += '<a href="javascript:;" class="contact-list-link new">\
										<div class="d-flex">\
							                <div class="pos-relative">\
							                  <img src="'+d[i].photo+'" class="wd-40 rounded-circle" alt="">\
							                  <div class="contact-status-indicator  bg-gray-500"></div>\
							                </div>\
							                <div class="contact-person">\
							                  <p class="mg-b-0">'+d[i].title+'</p>\
							                  <span class="tx-12 op-5 d-inline-block">系统用户</span>\
							                </div>\
							                <span class="tx-info tx-12" style="display:none"><span class="square-8 bg-info rounded-circle"></span> 1 new</span>\
							            </div>\
							        </a>' ;
							        outline ++ ;
								}
							}				
						}
						$(".item-online .contact-list").html(onlineHtml);
						$(".item-online .line-num").html("在线人员（"+online+"）");
						$(".item-outline .contact-list").html(outlineHtml);
						$(".item-outline .line-num").html("离线人员（"+outline+"）");
						
					},
					error:function(e){
						console.log(e)						
					}
				});				
			}			
		},
		fillHtmlThree: function() {
			return(function() {				
				$.ajax({
					url:"/tcenter/content/review_list.jsp?status=1",	
					type:"get",
			        dataType : 'json',
					success :function(data){				
						var dshHtml = "" ;						
						if(data.result.length>0){
							for (var i =0 ; i<data.result.length ;i++) {
								dshHtml += '<a href="'+data.result[i].path+'" target="_blank">\
					          		<div class="media bg-file mg-t-20">\
						              <div class="pd-10  dsh-box wd-50  tx-ht-48 tx-center d-flex align-items-center justify-content-center">\
						                <i class="fa fa-file-image-o tx-28 tx-white"></i>\
						              </div>\
						              <div class="media-body d-flex flex-column tx-ht-48 justify-content-between">\
						                <p class="mg-b-0 tx-14 tx-ellipsis">'+data.result[i].title+'</p>\
						                <p class="mg-b-0 tx-12">\
						                	<span class="tx-type" style="display:none;">图文</span>\
						                	<span class="tx-white op-8"><span class="mg-r-10">'+data.result[i].user+'</span>'+ data.result[i].date+'</span>\
						                </p>\
						              </div>\
						            </div>\
					          	</a>' 
							}	
							$(".dsh-container").html(dshHtml);
							$(".dsh-num").html(data.result.length);	
							//$("#btnRightMenu span.bg-danger").show();  //显示提醒
						
							if(sSs("shVoice")!="true"){
							    ms.shTips();
							}
							sSs("shVoice",true) ; 
						}else{
							$("#btnRightMenu span.bg-danger").hide();
						}
										
					},
					error:function(e){
						console.log(e)						
					}
				});				
			})();
			
		},
		fillHtmlFour: function() {
			return(function() {	
				$.ajax({
					url:"/tcenter/content/editor_log.jsp",	
					type:"get",
			        dataType : 'jsonp',
					success :function(data){				
						var recentHtml = "" ;
						if(data.length>0){
							for (var i =0 ; i<data.length ;i++) {
								recentHtml += '<a href="'+data[i].address+'" target="_blank">\
							  		<div class="media  mg-t-20 bg-tx-img">\
							          <div class="pd-10  dsh-box wd-50  tx-ht-48 tx-center d-flex align-items-center justify-content-center">\
							            <i class="fa fa-file-word-o tx-28 tx-white"></i>\
							          </div>\
							          <div class="media-body d-flex flex-column tx-ht-48 justify-content-between">\
							            <p class="mg-b-0 tx-14 tx-ellipsis">'+data[i].Title+'</p>\
							            <p class="mg-b-0 tx-12">\
							            	<span class="tx-type" style="display:none;">图文</span>\
							            	<span class="tx-white op-8"><span class="mg-r-10">'+data[i].name+'</span>'+ data[i].CreateDate+'</span>\
							            </p>\
							          </div>\
							        </div>\
							  	</a>' 
							}				
						}
						$(".recentEdit").html(recentHtml);						
					},
					error:function(e){
						console.log(e)						
					}
				});				
			})();
		},
		//绑定事件
		bindEvent: function(obj) {		
			return(function() {			
				$(obj).on("click","a", function() {
					var index = parseInt( $(this).attr("data-index") );
					console.log(index)
					switch (index){
						case 0:
						    ms.fillHtmlOne();
							break;
						case 1:
						    ms.fillHtmlTwo();
							break;
						case 2:
						    ms.fillHtmlThree();
							break;
						case 3:
						    ms.fillHtmlFour();
							break;
						default:
							break;
					}																
				});
								
			})();
		},
		shTips : function (){
			var modalHtml = '<div id="dsh-modal">\
		    	<div class="modal-dialog modal-sm" role="document">\
					  <div class="modal-content bd-0 tx-14">\
					    <div class="modal-header pd-x-20">\
					      <h6 class="tx-14 mg-b-0 tx-uppercase tx-inverse tx-bold">提示</h6>\
					      <button type="button" class="close closesh" data-dismiss="modal" aria-label="Close">\
					        <span aria-hidden="true">×</span>\
					      </button>\
					    </div>\
					    <div class="modal-body pd-20">\
					      <p class="mg-b-5">您有待审核内容，请查收！ </p>\
					    </div>\
					    <div class="modal-footer justify-content-end">\
					      <button type="button" class="btn btn-primary tx-11 tx-uppercase pd-y-12 pd-x-25 tx-mont tx-medium checksh">立即查看</button>\
					      <button type="button" class="btn btn-secondary tx-11 tx-uppercase pd-y-12 pd-x-25 tx-mont closesh tx-medium" data-dismiss="modal">关闭</button>\
					    </div>\
					  </div>\
					</div>\
		    	</div>' ;
		    $("body").append(modalHtml) ;
		    $("#dsh-modal").show().animate({bottom:'30px'});			
			$("#dsh-modal").on("click",".closesh", function() {
				$("#dsh-modal").animate({bottom:'-300px'},function(){
					$("#dsh-modal").remove()
				});
				return false;
			})
			$("#dsh-modal").on("click",".checksh", function() {
				$('body').addClass('show-right');
				$(".br-sideright .nav-item:nth-child(3) a").get(0).click();
				$("#dsh-modal").remove()
				return false;
			})
		}
		
	}
	$.fn.sideRight = function() {
        if($(this).length>0){
	        ms.addMessageIcon(this);
            ms.addTabs()
	    }
	}
})(jQuery);

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

function siderightNewContent(){

	var url = "/tcenter/lib/sidebar_new_content.jsp ";
	var	dialog = new TideDialog();
		dialog.setWidth(700);
		dialog.setHeight(550);
		dialog.setUrl(url);
		dialog.setTitle('选择数据节点');
		dialog.setZindex('9999');
		dialog.show();
}
$(".br-header").sideRight();  //侧边栏

;(function($) {
	var ms = {		
		dispalyCardBody: function() {
			var cardBody = $(".approve_body .card-body") ;
			$.each(cardBody, function(va,vi) {
				if($(this).find("div").length>0){
					$(this).removeClass("hide") ; 
				}
			});
		},
		addApprove:function(obj){
			$.ajax({
				url:"/tcenter/approve/approve_info.jsp",
				data:{globalid:GlobalID,channelid:channelid},
				type:"get",
		        //dataType : 'json',
				success :function(data){
					var brbody = obj.find('.br-pagebody') ;
					if(!brbody.length){					    
						return false;
					}
					var isyl = obj.attr("data-yl") ;
					if(isyl==1){
						brbody.wrap('<div class="row row-sm mg-t-0" style=""><div class="col-sm-8 pd-r-0-force colapprove" style=""></div></div>')
					}else{
						brbody.wrap('<div class="row row-sm mg-t-0" style=""><div class="col-sm-8 pd-r-0-force colapprove" style=""></div></div>')
					}
					
					var approveHtml = '<div class="col-sm-4 pd-x-0-force">\
						<div class="br-pagebody mg-l-0 mg-r-30 pd-x-0-force">\
							<div class="bg-white">\
								<div class="card-header bg-transparent d-flex justify-content-between align-items-center">\
									<h6 class="card-title tx-uppercase tx-12 mg-b-0">审核结果</h6>\
								</div>\
							</div>\
							<div class="approve_body"><div class="card-body bg-white"></div></div>\
						</div>\
					</div>' ;
					$(approveHtml).insertAfter('.colapprove');
					obj.find(".approve_body").html(data.trim());
					ms.dispalyCardBody();					
				},
				error:function(e){
					console.log(e)						
				}
			});		
		}
	}
	$.fn.approveSider = function() {
       	try{      	   
       		if( ! (channelid && GlobalID ) ){
       			return false;	       		
	       	}else{
	       		ms.addApprove(this) ;
	       	}
       	}catch(e){
       		//console.log(e)
       		return false;
       	}      				
	}
})(jQuery);

$(function(){
   
   $("div[data-approve='1']").approveSider();   //审核预览
})
