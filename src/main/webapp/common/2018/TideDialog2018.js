function TideDialog(){
	this.width=300;
	this.height=400;
	this.url='';
	this.channel_name="" ;
	this.title='';
	this.type=0;//0 iframe 1 ajsx   2  html
	this.ajaxType='GET';
	this.dataType='html';
	this.suffix='';
	this.ajaxoptions={};
	this.scroll='no';
	this.html='';
	this.layer=0;//目录层级，默认是0，用来控制右上角图片显示
	this.msg='';
	this.msgJs='';
	this.zindex = 0;
	this._position = "";	

	this.setHeight=function(height){this.height=height;}
	this.setWidth=function(width){this.width=width;}
	this.setUrl=function(url){this.url=url;}
	this.setTitle=function(title){this.title=title;}
	this.setType=function(type){this.type=type;}
	this.setAjaxType=function(ajaxType){this.ajaxType=ajaxType;}
	this.setDataType=function(dataType){this.dataType=dataType;}
	this.setAjaxoptions=function(ajaxoptions){this.ajaxoptions=ajaxoptions;}
	this.setSuffix=function(suffix){this.suffix=suffix;}
	this.setScroll=function(scroll){this.scroll=scroll;}
	this.setImg=function(img){this.img=img;}
	this.setHtml=function(html){this.html=html;}
	this.setLayer=function(layer){this.layer=layer;}
	//设置层的z-index属性
	this.setZindex=function(num){this.zindex=num;}
	this.changeHtml=function(html){
		jQuery("#popDiviframe"+this.suffix).html(html);
	}
	this.setChannelName=function(channel_name){
		return ;
		this.channel_name=channel_name ;
		jQuery("#channel_name"+this.suffix).html(channel_name);
	}
	this.setMsg=function(msg){
		this.msg=msg;
	}
	this.setMsgJs=function(msgJs){
		console.log(msgJs)
		this.msgJs=msgJs;
		console.log(this.msgJs);
	}
	this.setPosition=function(_position){
		
		this._position=_position;
		console.log(this._position);
	}
    
	this.show=function(){
		tidecms.dialognumber ++;
		console.log(tidecms.dialognumber)
		if(this.suffix=="")
			this.suffix = "_"+tidecms.dialognumber;
		var dialogid = "#TideDialog"+this.suffix;
		var $TideDialog=jQuery(dialogid);
		if(!$TideDialog.is('div')){
			var o={suffix:this.suffix,img:'images/openwin_close.png'};
			if(this.layer==2){
				o={suffix:this.suffix,img:'../images/openwin_close.png'};
			}
			console.log(o)
			TideDialogInit(o);
			$TideDialog=jQuery("#TideDialog"+this.suffix);
		}
        tidecms.dialogZindex ++ ;
		if(this.zindex>0){
			$TideDialog.css("z-index",this.zindex);
		}else{
			$TideDialog.css("z-index",tidecms.dialogZindex);
		}

		var width=jQuery("body").width();
		var left=(width-this.width)/2;
		left=Math.abs(left);
		left=left+"px";
		var clientHeight=(document.documentElement.clientHeight ? document.documentElement.clientHeight:document.body.clientHeight);
		var top=(clientHeight-this.height)/2;
		top=Math.abs(top);
        console.log(dialogid)
		var $TideDialogTitle=jQuery(dialogid + " #TideDialogTitle");
		var $TideDialogClose=jQuery(dialogid + " .TideDialogClose");//通过#TideDialogClose读取，会不兼容360浏览器 2015.3.23
		var $popmain=jQuery("#popmain"+this.suffix);
		
		var $popDiviframe=jQuery("#popDiviframe"+ this.suffix);

		var $popiframe=jQuery("#popiframe" + this.suffix);
        var $channelName = jQuery("#channel_name"+this.suffix);
        
		$TideDialogTitle.html(this.title);
		$channelName.html(this.channel_name);
		var close_href='javascript:getDialog().Close({suffix:"'+this.suffix+'"});';
		$TideDialogClose.attr("href",close_href);
		$popmain.css({width:this.width,height:this.height});
		$popDiviframe.css({width:this.width,height:this.height-52}); //iframe外层盒子的宽高
        
		if(this.type==0){			
			if($.support){ 				
				console.log(this.url)
				var iframe='<iframe frameborder="0" src="'+this.url+'" id="popiframe'+this.suffix+'" name="popiframe'+this.suffix+'" style="width:100%;height:100%;" scrolling="'+this.scroll+'" allowTransparency="true"></iframe>';	
				$popDiviframe.html(iframe);
			}else{				
				$popiframe.attr('scrolling',this.scroll);
				$popiframe.attr('src',this.url);
				$popiframe.css({width:this.width,height:this.height-52});				
			}			
			$TideDialog.fadeIn(100);
		}else if(this.type==1){
				var options={
					 type:this.ajaxType,
					 url:this.url,
					 dataType:this.dataType,
					 success: function(data){ 
						 $popDiviframe.html(data);
						 $TideDialog.show();
					} 
				};
			jQuery.extend(options,this.ajaxoptions);  
			jQuery.ajax(options);
		}else if(this.type==2){
			$popDiviframe.html(this.html);
			//jQuery("body").append('<div class="modal-backdrop fade show"></div>');			
		    var _boxH = this.height - 50   ;//减去标题高度
			$("#alert_boy").outerHeight(_boxH);
			$TideDialog.fadeIn(300);
		}
	    try{jQuery("#popmain"+this.suffix).draggable({handle:'#openwin_nav_id'});}catch(e){}
	}
}

TideDialog.prototype.Close=function(options){
	var o={suffix:'',refresh:'',recall:false,returnValue:{},close: null};
	jQuery.extend(o,options||{}); 
	
	if(o.suffix=="")
		o.suffix = "_" + tidecms.dialognumber;
	tidecms.dialognumber --;
	console.log(tidecms.dialognumber);
	var dialogid = "#TideDialog"+o.suffix;
	jQuery(dialogid).hide();

	if(jQuery("#popiframe"+o.suffix).length){
		jQuery("#popiframe"+o.suffix).attr('src','about:blank');
	}
	
	if(o.recall){
			window.frames["popiframe"+o.suffix].setReturnValue(o.returnValue);
	}

	var frame;
	if(o.refresh=="right"){
		if(o.frameid){
			frame = window.frames[o.frameid]	;
		}else{
			frame = window.frames["content_frame"]	;
		}	
		if(frame.src){
			changeFrameSrc(frame , frame.src)
		}else{
			changeFrameSrc(frame , frame.location)
		}
		return;
	}else if(o.refresh=="left"){
		frame=window.frames["content_frame"]
		if(frame.src){
			changeFrameSrc(frame , frame.src)
		}else{
			changeFrameSrc(frame , frame.location)
		}
		return;
	}else if(o.refresh=="content_frame"){
		frame=window.frames["content_frame"];
		if(frame.src){
			changeFrameSrc(frame , frame.src)
		}else{
			changeFrameSrc(frame , frame.location)
		}
		return;
	}
	if(o.close){
		o.close.call(this);
	}
}

TideDialog.prototype.Resize=function(nwidth,nheight){
	var suffix=this.suffix;
	var width=jQuery("body").width();
	var left=(width-nwidth)/2;
		left=Math.abs(left);
		left=left+"px";
	var clientHeight=(document.documentElement.clientHeight ? document.documentElement.clientHeight:document.body.clientHeight);
	var top=(clientHeight-nheight)/2;
		top=Math.abs(top);
	jQuery("#popmain"+suffix).css({width:nwidth,left:left,top:top,height:nheight});
	jQuery("#popiframe"+suffix).css({width:nwidth,height:nheight-25});
}

TideDialog.prototype.ShowMsg=function(){	
	this.type=2;
	this.suffix="html";
    this.html= '<div class="modal-body pd-x-20  pd-y-15" id="alert_boy" style="position:static;top:0;bottom:0;height:100%;overflow-y:auto">'+                 
	              '<p class="mg-b-5" style="word-break: break-all;">'+ this.msg +'</p>'+
	            '</div>' ;
	//            '<div class="modal-footer justify-content-end">' ;	
	//this.html +='<button id="startButton" type="button" class="btn btn-primary tx-11 tx-uppercase pd-y-12 pd-x-25 tx-mont tx-medium" onclick="getDialog().Close({suffix:\'html\'});">确认</button>';
	//this.html += '<button id="btnCancel1" type="button" class="btn btn-secondary tx-11 tx-uppercase pd-y-12 pd-x-25 tx-mont tx-medium mg-r-10" data-dismiss="modal" onclick="getDialog().Close({suffix:\'html\'});">关闭</button>'+
	//            '</div>'	
	this.show();
}


// 创建提示框并显示
TideDialog.prototype.showAlert = function (content,type,time) {
	if ($('#tide_alert_box').length !== 0) {
		$('#tide_alert_box').stop().remove();
	}
	var _time = time ? time : 5000 ;
	if(!type || type=="success"){
		var _type = "success" ;
		var icon = "fa fa-check-circle tx-16 mg-r-5 " ;		
	}else if(type=="danger"){
		var _type = "danger" ;
		var icon = "fa fa-exclamation-triangle mg-r-5" ;		
	}else{
		var _type = type;
		var icon = " " ;		
	}
	var alertbox = '<div id="tide_alert_box"><div id="tide_alert">'+
				'<span><div class="tide_alert_content">' +
				'<div class="alert alert-'+_type+' alert-box" role="alert">' +
					' <span class="alert-text"><i class="'+icon+'"></i>' + content + '</span>' +
				'</div>'+
			'</span></div>'+
		'</div></div>' ;
	$(top.document.body).append(alertbox);
	$('#tide_alert_box').fadeIn().fadeOut(_time);
}


function getDialog(o){
	var op={suffix:''};
	jQuery.extend(op,o||{});  
	var d=new TideDialog(op);
	d.setSuffix(op.suffix);
	return d; 
}

function TideDialogResize(nwidth,nheight)
{
		var width=jQuery("body").width();
		var left=(width-nwidth)/2;
		left=Math.abs(left);
			left=left+"px";
			var clientHeight=(document.documentElement.clientHeight ? document.documentElement.clientHeight:document.body.clientHeight);
			var top=(clientHeight-nheight)/2;
			top=Math.abs(top);
//	jQuery("#popmain").css({width:nwidth,left:left,top:top,height:nheight});
	
	jQuery("#popmain_1").css({width:nwidth,height:nheight});
	jQuery("#popiframe_1").css({width:nwidth,height:nheight-50});
}

function TideDialogSetTitle(title)
{
		var $TideDialogTitle=jQuery("#TideDialogTitle");

		$TideDialogTitle.html(title);
}

function TideDialogClose(options){
	console.log(options)
	var o={suffix:'',refresh:'',returnValue:null,close: null};
	jQuery.extend(o,options||{}); 
	if(o.suffix=="")
		o.suffix = "_" + tidecms.dialognumber;
	tidecms.dialognumber --;

	jQuery("#TideDialog"+o.suffix).fadeOut(200);
	//if(jQuery("#popiframe"+o.suffix).length){
		jQuery("#popiframe"+o.suffix).attr('src','about:blank');
	//}
	//alert("src:"+jQuery("#popiframe"+o.suffix).attr('src'));

	if(o.returnValue && tidecms.dialognumber>0){//调用上一级弹出窗口的setReturnValue函数
			window.frames["popiframe_"+tidecms.dialognumber].setReturnValue(o.returnValue);
	}
    
	var frame;
	if(o.refresh=="right"){
		if(o.frameid){
			frame = window.frames[o.frameid]	;
		}else{
			frame = window.frames["content_frame"]	;
		}	
		if(frame.src){
			changeFrameSrc(frame , frame.src)
		}else{
			changeFrameSrc(frame , frame.location)
		}
		return;
	}else if(o.refresh=="left"){
		console.log(o)
		window.reLoadNav(o.returnNavValue);
		return;
	}else if(o.refresh=="content_frame"){
		frame=window.frames["content_frame"];
		if(frame.src){
			changeFrameSrc(frame , frame.src)
		}else{
			changeFrameSrc(frame , frame.location)
		}
		return;
	}
	else
	{
		o.refresh = o.refresh.replace(/left./g, "tidecms.getLeftIfm().");
		o.refresh = o.refresh.replace(/right./g, "tidecms.getRightIfm().");
		eval(o.refresh);
	}
	if(o.close){
		o.close.call(this);
	}
}


function TideDialogClose2(options){
	var o={suffix:'',refresh:'',recall:false,returnValue:{},close: null};
	jQuery.extend(o,options||{});  

	if(o.suffix=="")
		o.suffix = "_" + tidecms.dialognumber;
	tidecms.dialognumber --;
	jQuery("#TideDialog"+o.suffix).hide();

	//if(jQuery("#popiframe"+o.suffix).length){
		jQuery("#popiframe"+o.suffix).attr('src','about:blank');
	//}
	
	if(o.recall){
			window.frames["popiframe"+o.suffix].setReturnValue(o.returnValue);
	}

	var frame;
	if(o.refresh=="right"){
		frame=window.frames["content_frame"]
		frame.history.go(-1);
		return;
	}else if(o.refresh=="left"){
		console.log(o,2)
		frame=window.frames["content_frame"]
		frame.history.go(-1);
		return;
	}else if(o.refresh=="content_frame"){
		frame=window.frames["content_frame"];
		frame.history.go(-1);
		return;
	}
	if(o.close){
		o.close.call(this);
	}
}

function TideDialogInit(o)
{	
	var html='<div id="TideDialog'+o.suffix+'" class="modal">'+
		'<div class="modal-backdrop show" style="z-index:auto;"></div>'+
	    '<div class="modal-dialog modal-lg" role="document">'+
	      '<div class="modal-content tx-size-sm overflow-hidden" id="popmain'+o.suffix+'" style="">'+
	        '<div class="modal-header pd-x-20" id="openwin_nav_id">'+
	          '<h6 class="tx-14 mg-b-0 tx-uppercase tx-inverse tx-bold">'+
//	             '<span class="font-weight-normal" id="channel_name'+o.suffix+'">首页管理</span><span class="pd-l-2 pd-r-2 font-weight-normal">></span><span id="TideDialogTitle">新建独立数据频道</span></h6>'+	          
	             '<span id="TideDialogTitle"></span></h6>'+
	          '<a href="" class="close TideDialogClose">'+
	            '<span aria-hidden="true">×</span>'+
	          '</a>'+
	        '</div>'+
	        '<div class="iframe_content openwin_iframe" id="popDiviframe'+o.suffix+'" style="">'+
	        	'<iframe src="about:blank" id="popiframe'+o.suffix+'" name="popiframe'+o.suffix+'" style="width:100%;height:100%;" scrolling="no" allowTransparency="true"></iframe>'+ 
	        '</div>'+
	      '</div>'+
	    '</div>'+
	  '</div>' ;

	jQuery("body").append(jQuery(html));
	
    try{jQuery("#TideDialog"+o.suffix+" #popmain").draggable({handle:'#openwin_nav_id'});}catch(e){}
}
