<%@ page import="tidemedia.cms.system.Document"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int id = getIntParameter(request,"id");
int ChannelID = getIntParameter(request,"ChannelID");
Document doc = new Document(id,ChannelID);
String txtContent = doc.getValue("txtContent");
%>
<!DOCTYPE HTML>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="robots" content="noindex, nofollow">
		<title>TideCMS</title>
		<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
		<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
		<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
		<link rel="stylesheet" href="../style/2018/bracket.css">
		<link rel="stylesheet" href="../style/2018/common.css">
		<link rel="stylesheet" href="../lib/2018/swiper/css/swiper.min.css">
		<script src="../lib/2018/jquery/jquery.js"></script>
		<script type="text/javascript" src="../common/2018/tidePlayer.js"></script>
		<style>
			html, body { width: 100%; height: 100%; }
			.swiper-container { width: 100%; height: 300px; margin-left: auto; margin-right: auto; }
		    .swiper-slide { background-size: cover; background-position: center; }
		    .gallery-top { height: 80%; width: 100%; }
		    .gallery-thumbs { height: 20%; box-sizing: border-box; padding: 10px 0; }
		    .gallery-thumbs .swiper-slide { height: 100%; opacity: 0.4; }
		    .gallery-thumbs .swiper-slide-thumb-active { opacity: 1; }
		     
		    .config-box.picview{height: 100%;}
			.config-box.picview ul,.config-box.picview ul li{height: 100%;}
			.text-content{padding: 10px 10px 20px 10px ;}
			.pics-content .img-box{ width: 100%;height: 100%;display: flex;justify-content: center;align-items: center; cursor: pointer; }
			.pics-content .img-box img{ max-width: 100%; max-height: 100%; }
			.gallery-thumbs .img-box{ border: 1px solid #868ba1; }
			.swiper-slide-thumb-active .img-box{border: 1px solid #ff3030;}
			.video-content{height: 100%;}
			#videobox{max-height: 100%;overflow: hidden;width: 960px;height: 488px;}
			.swiper-button-next, .swiper-button-prev{ background-color:#e5e5e5 ; }
			.swiper-pagination{ text-align: left; font-size: 20px; color: #000; }
			.swiper-pagination-current{ margin-left: 30px; }
			
		</style>
	</head>

	<body>
		<div class="bg-white modal-box">
			<div class="modal-body modal-body-btn pd-15 overflow-y-auto">
				<div class="config-box picview">
					<ul>
						<!-- 内容区 -->
						<li class="li-item text-content">
							
						</li>
						<!--轮播图区-->
						<li class="li-item pics-content ht-100p">
							<div class="swiper-container gallery-top">
								<div class="swiper-wrapper">
									<!--<div class="swiper-slide">
										<div class="img-box">
											<img src="http://local.huangshannews.cn/images/2019/5/5/2019551557028400053_22.JPG">
										</div>
									</div>-->
									
									
								</div>
								<div class="swiper-pagination"></div>
								<div class="swiper-button-next swiper-button-white"></div>
								<div class="swiper-button-prev swiper-button-white"></div>
							</div>
							<div class="swiper-container gallery-thumbs">
								<div class="swiper-wrapper">
									<!--<div class="swiper-slide">
										<div class="img-box">
											<img src="http://local.huangshannews.cn/images/2019/5/5/2019551557028400053_22.JPG">
										</div>
									</div>-->
									
								</div>
							</div>
						</li>
						<!--视频区-->
						<li class="li-item video-content">
							<div id="videobox">
							
							</div>					
						</li>
					</ul>
				</div>
			</div>
			<!--modal-body-->

			<div class="btn-box">
				<div class="modal-footer">
					<!--<button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>-->
					<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">关闭</button>
				</div>
			</div>
		</div>
		<!-- modal-box -->
	</body>

	
	<script src="../common/2018/common2018.js"></script>

	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
	<script src="../lib/2018/select2/js/select2.min.js"></script>
	<script src="../common/2018/bracket.js"></script>
	<script src="../lib/2018/swiper/js/swiper.min.js"></script>
	
	<script>
		//获取地址栏参数
		function getUrl(name) {
		    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
		    var r = window.location.search.substr(1).match(reg);
		     if(r!=null)return  unescape(r[2]); return null;
		}
		
	    var  sourceType= getUrl("sourceType") ;
	    if( sourceType == 1){
	    	$(".li-item").hide();
			$(".text-content").show();

			//var textcont = getUrl("textcont") ;
			$(".text-content").html('<%=txtContent%>') ;
			
	    }else if( sourceType == 2){  //轮播部分
	    	
			var imgUrl = getUrl("imgUrl") ;
			imgUrl = imgUrl.split(",") ;
			var bigImgHtml = "" ;
			var smImgHtml = "" ;
			for (var i=0 ; i< imgUrl.length;i++) {
				bigImgHtml += '<div class="swiper-slide">' +
									'<div class="img-box">'+
										'<img src="'+imgUrl[i]+'">'+
									'</div>'+
								'</div>';
				smImgHtml += '<div class="swiper-slide">' +
									'<div class="img-box">'+
										'<img src="'+imgUrl[i]+'">'+
									'</div>'+
								'</div>';
			}
			$(".gallery-top .swiper-wrapper").html(bigImgHtml) ;
			$(".gallery-thumbs .swiper-wrapper").html(bigImgHtml) ;
			
			$(".li-item").hide();
			$(".pics-content").show();
			$(".config-box").addClass("picview") ;
			
			var galleryThumbs = new Swiper('.gallery-thumbs', {
				spaceBetween: 10,
				slidesPerView: 9,
				loop: false,
				freeMode: true,
				loopedSlides: 5, //looped slides should be the same
				watchSlidesVisibility: true,
				watchSlidesProgress: true,
			});
			var galleryTop = new Swiper('.gallery-top', {
				spaceBetween: 10,
				loop: false,
				loopedSlides: 5, //looped slides should be the same
				navigation: {
					nextEl: '.swiper-button-next',
					prevEl: '.swiper-button-prev',
				},
				thumbs: {
					swiper: galleryThumbs,
				},
				pagination: {
			  		el: '.swiper-pagination',
			  		type: 'fraction',
			  		renderFraction: function(currentClass, totalClass) {
			  			return '<span class="' + currentClass + '"></span>' + '/' + '<span class="' + totalClass + '"></span>';
			  		},
			  	}
			});
	    }else if(sourceType = 3){ //视频部分
	    	var videoUrl = getUrl("videoUrl") ;
	    	$(".li-item").hide();
			$(".video-content").show();
			tidePlayer({video:videoUrl,divid:"videobox"}) ;
	    }
		
	</script>

</html>