function TideDialog(){
	this.width=300;
	this.height=400;
	this.url='';
	this.title='';
	this.type=0;//0 iframe 1 ajsx   2  html
	this.ajaxType='GET';
	this.dataType='html';
	this.suffix='';
	this.ajaxoptions={};
	this.scroll='no';
	this.html='';
	this.layer=0;
	this.msg='';
	this.msgJs='';
	this.zindex = 0;

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
	this.setMsg=function(msg){
		this.msg=msg;
	}
	this.setMsgJs=function(msgJs){
		this.msgJs=msgJs;
	}

	this.show=function(){
		tidecms.dialognumber ++;
		if(this.suffix=="")
			this.suffix = "_"+tidecms.dialognumber;
		var dialogid = "#TideDialog"+this.suffix;
		var $TideDialog=jQuery(dialogid);
		if(!$TideDialog.is('div')){
			var o={suffix:this.suffix,img:'images/openwin_close.png'};
			if(this.layer==2){
				o={suffix:this.suffix,img:'../images/openwin_close.png'};
			}
			TideDialogInit(o);
			$TideDialog=jQuery("#TideDialog"+this.suffix);
		}

		if(this.zindex>0)
		{
			$TideDialog.css("z-index",this.zindex);
		}

		var width=jQuery("body").width();
		var left=(width-this.width)/2;
		left=Math.abs(left);
		left=left+"px";
		var clientHeight=(document.documentElement.clientHeight ? document.documentElement.clientHeight:document.body.clientHeight);
		var top=(clientHeight-this.height)/2;
		top=Math.abs(top);

		var $TideDialogTitle=jQuery(dialogid + " #TideDialogTitle");
		var $TideDialogClose=jQuery(dialogid + " #TideDialogClose");
		var $popmain=jQuery(dialogid + " #popmain");
		var $popDiviframe=jQuery(dialogid + " #popDiviframe");
			//if(window.console)window.console.info(this.suffix);
		var $popiframe=jQuery("#popiframe" + this.suffix);

		$TideDialogTitle.html(this.title);
		var close_href='javascript:getDialog().Close({suffix:"'+this.suffix+'"});';
		$TideDialogClose.attr("href",close_href);
		$popmain.css({width:this.width,left:left,top:top,height:this.height});
		if(this.type==0){
			if($.browser.msie){
				var iframe='<iframe frameborder="0" src="'+this.url+'" id="popiframe'+this.suffix+'" name="popiframe'+this.suffix+'" style="width:'+this.width+'px;height:'+(this.height-25)+'px;" scrolling="'+this.scroll+'" allowTransparency="true"></iframe>';	
				$popDiviframe.html(iframe);
			}else{
				$popiframe.attr('scrolling',this.scroll);
				$popiframe.attr('src',this.url);
				$popiframe.css({width:this.width,height:this.height-25});
			}
			$TideDialog.show();
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
			$TideDialog.show();
		}
	    try{jQuery("#TideDialog"+this.suffix+" #popmain").draggable({handle:'#openwin_nav_id'});}catch(e){}
	}
}

TideDialog.prototype.Close=function(options){
	var o={suffix:'',refresh:'',recall:false,returnValue:{},close: null};
	jQuery.extend(o,options||{}); 
	
	if(o.suffix=="")
		o.suffix = "_" + tidecms.dialognumber;
	tidecms.dialognumber --;
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
		frame=window.frames["main"].frames["right"];
		frame.location=frame.location;
		return;
	}else if(o.refresh=="left"){
		frame=window.frames["main"].frames["left"];
		frame.location=frame.location;
		return;
	}else if(o.refresh=="main"){
		frame=window.frames["main"];
		frame.location=frame.location;
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
	this.html='<div style="text-align: center;"><div class="form_top"><div class="left"></div><div class="right"></div></div>\
<div class="form_main">\
<div class="form_main_m">\
<table  border="0" width="100%" style="text-align: center;">\
  <tr>\
    <td>'+this.msg+'</td>\
    <td valign="middle"></td>\
  </tr>\
	<tr>\
    <td></td>\
    <td valign="middle"></td>\
  </tr>\
</table>\
</div>\
</div>\
<div class="form_bottom">\
    <div class="left"></div>\
    <div class="right"></div>\
</div>\
<div class="form_button">\
	<input name="startButton" type="button" class="button" value="确定" id="startButton" onclick="'+this.msgJs+'"/>\
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="getDialog().Close({suffix:\'html\'});"/>\
</div></div>';
	this.show();
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
	jQuery("#popmain").css({width:nwidth,left:left,top:top,height:nheight});
	jQuery("#popiframe_1").css({width:nwidth,height:nheight-25});
}

function TideDialogSetTitle(title)
{
		var $TideDialogTitle=jQuery("#TideDialogTitle");

		$TideDialogTitle.html(title);
}

function TideDialogClose(options){
	var o={suffix:'',refresh:'',returnValue:null,close: null};
	jQuery.extend(o,options||{}); 
	if(o.suffix=="")
		o.suffix = "_" + tidecms.dialognumber;
	tidecms.dialognumber --;

	jQuery("#TideDialog"+o.suffix).hide();

	//if(jQuery("#popiframe"+o.suffix).length){
		jQuery("#popiframe"+o.suffix).attr('src','about:blank');
	//}
	//alert("src:"+jQuery("#popiframe"+o.suffix).attr('src'));

	if(o.returnValue && tidecms.dialognumber>0){//调用上一级弹出窗口的setReturnValue函数
			window.frames["popiframe_"+tidecms.dialognumber].setReturnValue(o.returnValue);
	}

	var frame;
	if(o.refresh=="right"){
		frame=window.frames["main"].frames["ifm_right"];
		frame.location=frame.location;
		return;
	}else if(o.refresh=="left"){
		frame=window.frames["main"].frames["ifm_left"];
		frame.location=frame.location;
		return;
	}else if(o.refresh=="main"){
		frame=window.frames["main"];
		frame.location=frame.location;
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
		frame=window.frames["main"].frames["right"];
		frame.history.go(-1);
		return;
	}else if(o.refresh=="left"){
		frame=window.frames["main"].frames["left"];
		frame.history.go(-1);
		return;
	}else if(o.refresh=="main"){
		frame=window.frames["main"];
		frame.history.go(-1);
		return;
	}
	if(o.close){
		o.close.call(this);
	}
}

function TideDialogInit(o)
{
	/*
	var style='<style id="TideDialogStyle">.openwin{font-size:12px;position:fixed;z-index:1000;}\
	.openwin_bg{filter:alpha(opacity=50);-moz-opacity:0.5;opacity:0.5;z-index:1001;background:#79726C;position:fixed;left:0;top:0;right:0;bottom:0;}\
	.openwin_main{background:#efefef;position:fixed;z-index:1002;left:50%;top:50%;width:628px;height:408px;border:1px solid #cccccc;padding:8px;}\
	.openwin_nav{height:25px;line-height:25px;font-family:"宋体"}\
	.openwin_nav .nav{float:left;color:#555555;padding-left:5px;}\
	.openwin_nav .nav a{color:#555555;}\
	.openwin_nav .close{float:right;}\
	.openwin_nav .close a{display:block;height:19px;width:19px;}</style>';
	if(jQuery("#TideDialogStyle").is('style')){
		style='';	
	}	
	*/
	var html='<div class="openwin tidedialog" id="TideDialog'+o.suffix+'" style="display:none;">\
	<div class="openwin_bg"></div>\
	<div class="openwin_main" id="popmain">\
		<div class="openwin_nav" id="openwin_nav_id">\
			<div class="nav" id="TideDialogTitle"></div>\
			<div class="tidecms_common_tips" style="display:none;"><div class="tct"></div></div>\
			<div class="close" style="background:url('+o.img+') no-repeat 0 0;"><a style="cursor:pointer;" title="关闭" id="TideDialogClose"></a></div>\
		</div>\
		<div class="openwin_iframe" id="popDiviframe"><iframe frameborder="0" src="about:blank" id="popiframe'+o.suffix+'"  name="popiframe'+o.suffix+'" style="width:100%;height:100%;" scrolling="no" allowTransparency="true">\
	</div>\
	</div>\
	</div>';	
	jQuery("body").append(html);
    try{jQuery("#TideDialog"+o.suffix+" #popmain").draggable({handle:'#openwin_nav_id'});}catch(e){}
}