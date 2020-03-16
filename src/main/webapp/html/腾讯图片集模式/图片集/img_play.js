jQuery.cookie = function(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        var path = options.path ? '; path=' + options.path : '';
        var domain = options.domain ? '; domain=' + options.domain : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};

//var arrayList=[];
//arrayList.push({title:'test1',summary:'summary1',photo:'./images/s1.jpg',photo_b:'./images/b1.jpg',href:'index.shtml',pg:arrayList.length+1});
//arrayList.push({title:'test2',summary:'summary2',photo:'./images/s2.jpg',photo_b:'./images/b2.jpg',href:'index.shtml',pg:arrayList.length+1});

/*******
图片的滚动  cmy 2009-08-19
btnPrev:上一页
btnNext:下一页
play:播放
play_list:显示列表
groupPrev:上一组
groupNext:下一组
*****/
function img_play(o){
		o=$.extend({
			btnPrev: null,
			btnNext: null,
			groupPrev:'#groupPrev',
			groupNext:'#groupNext',
			play_list:'#tide_simg_box a,#tide_pages a',
			play:null,
			pause:null,
			perpage:6,
			interval:2,
			img_click_next:'#img_click_next',
			refresh:true,//是否刷新页面
			arrayList:[]
		},o||{});
	var interval;
	var img_play=$.cookie('img_play');
	var length=arrayList.length;
	var cur=getpg();
	/****当前****/
	cur=cur>length?1:cur;
	cur=cur<1?length:cur;
	//计算页数
	var page=Math.ceil(cur/o.perpage);

	page=cur<=o.perpage?1:page;

	var total_page=Math.ceil(length/o.perpage);
	var begin=(page-1)*o.perpage;
	var end=page*o.perpage;
	
	make_html(arrayList.slice(begin,end),arrayList[cur-1],cur,length,page,total_page);
	 onclick();

   function goTo(c){
		cur=c;
			/****当前****/
		cur=cur>length?1:cur;
		cur=cur<1?length:cur;
		page=Math.ceil(cur/o.perpage);
		page=cur<=o.perpage?1:page;
		begin=(page-1)*o.perpage;
		end=page*o.perpage;
		make_html(arrayList.slice(begin,end),arrayList[cur-1],cur,length,page,total_page);
		 onclick();
   }
        
    function onclick(){//挂click事件
		if(o.btnPrev)
            $(o.btnPrev).click(function() {
				var pre=cur<=1?length:cur-1;
                return topage(pre);
            });
		
		if(o.btnNext)
            $(o.btnNext).click(function() {
				var next=cur>=length?1:cur+1;
                return topage(next);
            });
		/*****上一组******/
		if(o.groupPrev)
            $(o.groupPrev).click(function() {
				if(page!=1){
					var pre=(page-1)*o.perpage-(o.perpage-1);
					return topage(pre);
				}
            });
		/*****下一组******/
		if(o.groupNext)
            $(o.groupNext).click(function() {
				if(page!=total_page){
					var next=(page+1)*o.perpage-(o.perpage-1);
					return topage(next);
				}
            });
		
		if(o.play_list){
			 $(o.play_list).click(function() {
				var c_pg=jQuery(this).attr("pg");
				c_pg=parseInt(c_pg);
				if(cur!=c_pg){
					topage(c_pg);
				}
            });
		}

		if(o.play)
			 $(o.play).click(function(){
				$(o.play).hide();
				$(o.pause).show();
				 $.cookie('img_play', 'play');
				 interval=setInterval(function(){$(o.btnNext).trigger('click');},o.interval*1000);
            });

		if(o.pause)
			 $(o.pause).click(function(){
				 $.cookie('img_play', 'pause');
				 clearInterval(interval);
				$(o.pause).hide();
				$(o.play).show();
            });

		if(o.img_click_next){
			 $(o.img_click_next).click(function(){
				 $(o.btnNext).trigger('click');
            });
		}

		if(img_play=="play"){
				$(o.play).hide();
				$(o.pause).show();
		}else{
				$(o.play).show();
				$(o.pause).hide();
		}
			
	}

	/********cookie 判断状态*******/
	if(img_play=="play"){
				$(o.pause).show();
				$(o.play).trigger('click');
	}else{
				 $(o.play).show();
	}
	
	

	function getpg(){
		if(o.refresh){
			var href=document.location.href;
			var begin=href.indexOf("pg=");
			var pg=href.substring(begin+3);
			reg=/^(\d+)$/g;
			if(!reg.test(pg)){
			   pg=1;
			}
			return parseInt(pg);
		}else{
			return 1;
		}
	}

	function topage(pg){
		if(o.refresh){
			var href=document.location.href;
			var reg=/^(.+)\?(.+)$/g;
			href=href.replace(reg,"$1");
			document.location.href=href+"?pg="+pg;
		}else{
			goTo(pg);
		}
	}
	
	function make_html(arrayList,curItem,cur,length,page,total_page){
			var html='';
			if(o.refresh){
				html+='<div id="tide_photos">';
			}
			html+='<div id="tide_tool">\
				<div class="tool_play">\
					<input type="image" src="img/photos_play.gif" title="播放" id="play" style="display:none;"/>\
					<input type="image" style="display:none;" src="img/photos_pause.gif" title="暂停" id="pause"/>\
				</div>\
				<div class="tool_prev">';
			
				if(cur!=1){
					html+='<a style="cursor:pointer;" id="btnPrev"><img alt="上一张" src="img/photos_prev.gif"/></a>';
				}else{
					html+='<img src="img/photos_prev.gif" class="ss"/>';
				}
			html+='</div>\
				<div id="tide_pages">';
				 var per=7;
				 var begin=0;
				 var end=0;
					if(length<=per){
						 for(i=1;i<=per;i++){
							if(cur==i){
								html+='<span title="第'+i+'页" class="cur"><a style="cursor:pointer;color:red;" pg="'+i+'">'+i+'</a></span>';
							}else{
								html+='<span title="第'+i+'页"><a style="cursor:pointer;" pg="'+i+'">'+i+'</a></span>';
							}
						}
					}else if(cur<per-2){
						 begin=1;
						 end=cur+2;
						for(i=begin;i<=end;i++){
							if(cur==i){
								html+='<span title="第'+i+'页" class="cur"><a style="cursor:pointer;color:red;" pg="'+i+'">'+i+'</a></span>';
							}else{
								html+='<span title="第'+i+'页"><a style="cursor:pointer;" pg="'+i+'">'+i+'</a></span>';
							}
						}
						html+='<span>...</span>';
						html+='<span title="第'+length+'页"><a style="cursor:pointer;" pg="'+length+'">'+length+'</a></span>';
					}else if(cur<length-3){
						html+='<span title="第1页"><a style="cursor:pointer;" pg="1">1</a></span>';
						html+='<span>...</span>';
						begin=cur-2;
						end=cur+2;
						for(i=begin;i<=end;i++){
							if(cur==i){
								html+='<span title="第'+i+'页" class="cur"><a style="cursor:pointer;color:red;" pg="'+i+'">'+i+'</a></span>';
							}else{
								html+='<span title="第'+i+'页"><a style="cursor:pointer;" pg="'+i+'">'+i+'</a></span>';
							}
						}
						html+='<span>...</span>';
						html+='<span title="第'+length+'页"><a style="cursor:pointer;" pg="'+length+'">'+length+'</a></span>';
					}else{
						html+='<span title="第1页"><a style="cursor:pointer;" pg="1">1</a></span>';
						html+='<span>...</span>';
						
						if(length-cur<2){
						 begin=length-2;
						}else{
						 begin=cur-(length-cur-1);
						}
						end=length;
				
						for(i=begin;i<=end;i++){
							if(cur==i){
								html+='<span title="第'+i+'页" class="cur"><a style="cursor:pointer;color:red;" pg="'+i+'">'+i+'</a></span>';
							}else{
								html+='<span title="第'+i+'页"><a style="cursor:pointer;" pg="'+i+'">'+i+'</a></span>';
							}
						}
						
					}
					
				html+='</div>\
				<div class="tool_next">';
				if(cur!=length){
					html+='<a style="cursor:pointer;" id="btnNext"><img alt="下一张" src="img/photos_next.gif"/></a>';
				}else{
					html+='<span  id="btnNext" display:none;></span><img  src="img/photos_next.gif" class="ss"/>';
				}

				html+='</div>\
				<div class="tool_pristine"><a href="index.shtml?pic='+curItem.photo_b+'" target="_blank"><img src="img/photos_pristine.gif"/></a></div>\
			</div>\
			<div id="tide_bimg">\
				<div class="tide_bimg_box">\
					<a style="cursor:pointer;" title="点击浏览下一张" id="img_click_next"><img alt="点击浏览下一张" src="'+curItem.photo_b+'" /></a>\
					<div class="txt">'+curItem.summary+'</div>\
				</div>\
				<div class="tide_bimg_box" style="display:none;">\
					<a href="#"><img alt="点击浏览下一张" src="http://img1.gtimg.com/ent/pics/20314/20314565.jpg" /></a>\
					<div class="txt">这是本张图片说明</div>\
				</div>\
			</div>\
			<div id="tide_simg">\
				<div class="simg_prev">';
				if(page!=1){
					html+='<a  style="cursor:pointer;" id="groupPrev" title="上一组"><img alt="上一组" src="img/photos_prev_group.gif"/></a>';
				}else{
					html+='	<img src="img/photos_prev_group.gif" class="ss"/>';
				}
			html+='</div>\
				<div id="tide_simg_box">';
		for(var i=0;i<arrayList.length;i++){
			if(curItem.pg==arrayList[i].pg){
				html+='<div><a style="cursor:pointer;display:block;" title="'+arrayList[i].title+'" pg="'+arrayList[i].pg+'"><img alt="点击浏览大图" src="'+arrayList[i].photo+'" class="cur"/></a></div>';
			}else{
				html+='<div><a style="cursor:pointer;display:block;" title="'+arrayList[i].title+'" pg="'+arrayList[i].pg+'"><img alt="点击浏览大图" src="'+arrayList[i].photo+'"/></a></div>';
			}		
		}
				html+='</div>\
			<div class="simg_next">';
			
			if(page!=total_page){
				html+='<a  style="cursor:pointer;" id="groupNext" title="下一组"><img alt="下一组" src="img/photos_next_group.gif"/></a>';
			}else{
				html+='<img src="img/photos_next_group.gif" class="ss"/>';
			}
			
			html+='</div>\
			</div>';
		if(o.refresh){
				html+='</div>';
		}

		if(o.refresh){
					document.write(html);
		}else{
				if(!jQuery("#tide_photos").is("div")){
					var h='<div id="tide_photos"></div>';
					document.write(h);
				}
				jQuery("#tide_photos").html(html);
		}
	}
		
}

//img_play({play:'#play',pause:'#pause',btnPrev:'#btnPrev',btnNext:'#btnNext',arrayList:arrayList,refresh:true});