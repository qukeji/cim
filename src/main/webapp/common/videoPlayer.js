var b__ua=navigator.userAgent;
var d__i=false;
var d__a=false;
if(/(iPhone|iPad|iPod|iOS)/i.test(b__ua)){
	d__i=true;
}else if(/(Android)/i.test(b__ua)){
	d__a=true;
};
var _playerlightDiv=null;
var _tide_play_num=0;
function showPlayer(obj){
	if(!obj.skin){
		obj.skin="0,0,0,0";
	}
	if(obj.autoplay==undefined){
		obj.autoplay=true;
	}
	var _dom_name=obj.name;
	if(!obj.name){
		_dom_name="TIDE_PLAYER_"+(_tide_play_num++);
	}
	var _path="../common/v.swf";//播放器地址
	var _w=obj.width;
	if(!_w) _w=640;
	var _h=obj.height;
	if(!_h) _h=512;
	var _hs;
	if(d__i){
		_hs=showHtmlVideo(_dom_name,_w,_h,obj);
	}else{
		_hs=showFlash(_path,_dom_name,_w,_h,false,getVarsByObject(obj));
		if(!obj.notool){		
			_hs="<div style='position:relative;z-index:300;'>"+_hs+"</div>";
		}
	}
	if(obj.divid){
		try{
			document.getElementById(obj.divid).innerHTML=_hs;
		}catch(e){};
	}else{
		document.write(_hs);
	};
}
function showFlash(a,b,w,h,c,d){var e='<object id="'+b+'" width="'+w+'" height="'+h+'" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" ><param name="movie" value="'+a+'" /><param name="FlashVars" value="'+d+'" /><param name="wmode" value="'+(c?'transparent':'opaque')+'" /><param name="allowScriptAccess" value="always" /><param name="allowFullScreen" value="true" /><embed name="'+b+'" width="'+w+'" height="'+h+'" src="'+a+'" wmode="'+(c?'transparent':'opaque')+'" allowFullScreen="true" allowScriptAccess="always" FlashVars="'+d+'" type="application/x-shockwave-flash"></embed></object>';return e;}function getFlashDom(a){return document[a]}
function showHtmlVideo(n,w,h,o){
	if(o.video){
		return '<video width="'+w+'" height="'+h+'" controls="controls" autoplay="autoplay" id="'+n+'" src="'+o.video+'"></video>';
	}else{
		return '<div style="width:'+w+'px;height:'+h+'px;background:#000;line-height:'+h+'px;text-align:center;color:#fff;font-size:16px;clear:both;padding:0 20px;">此视频暂时不支持苹果设备播放，请在电脑上浏览观看！</div>';
	}
}
function getVarsByObject(obj){
	var _arr=new Array();
	for(var key in obj){_arr.push(key+"="+encodeURIComponent(obj[key]))}
	return _arr.join("&");
}
function getPlayerPageUrl(){
	return window.location.href;
}
function getPlayerLightDom(){
	var d=document.createElement("div");
	d.style.position="absolute";
	d.style.display="none";
	d.style.width="100%";
	d.style.height=document.documentElement.scrollHeight+"px";
	d.style.zIndex=299;
	d.style.left="0px";
	d.style.top="0px";
	d.style.backgroundColor="#000";
	return d;
}
function controlLight(show){
	if(!_playerlightDiv){
		_playerlightDiv=getPlayerLightDom();
		document.body.appendChild(_playerlightDiv);
	}
	_playerlightDiv.style.display=show?"none":"block";
}