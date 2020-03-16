/*调整高度*/
window.onresize = function(){	
	if(document.getElementById("content_frame")){
		document.getElementById("content_frame").style.height =Math.max(document.documentElement.clientHeight-70,0) + "px";				
	}
}
function changeFrameHeight(_this){
	$(_this).css("height",document.documentElement.clientHeight-70);
}
//改变iframe的src
function changeFrameSrc(obj,url){
	if(obj.src){
		obj.src = url
	}else{
		obj.location = url
	}
}
//获取地址栏参数
function getUrl(name) {
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return null;
}
function getCookie(name) {
	/*
	cookies = document.cookie;
	if (cookies) {
		var start = cookies.indexOf(key + '=');//alert(":"+cookies+":"+' ' + key + '=');
		if (start == -1) { return null; }
		var end = cookies.indexOf(";", start);
		if (end == -1) { end = cookies.length; }
		end -= start;
		var cookie = cookies.substr(start,end);
		return unescape(cookie.substr(cookie.indexOf('=') + 1, cookie.length - cookie.indexOf('=') + 1));
	}
	else { return null; }
	*/
	var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
	if(arr != null) return unescape(arr[2]); return null;
}

function getNodePath(path,node)
{
	//alert(path);
	var parentnode = node.parentNode;
	if(parentnode)
	{
		var thisid = document.getElementById(parentnode.id+"-anchor").getAttribute("ChannelID") + "," + path;//alert(thisid);
		return getNodePath(thisid,parentnode);
	}
	else
	{
		return path;
	}
}

function getEvent(){     //????????ie??ff??????
    if(document.all)    return window.event;        
    func=getEvent.caller;            
     while(func!=null){    
         var arg0=func.arguments[0];
         if(arg0){
           if((arg0.constructor==Event || arg0.constructor ==MouseEvent)|| (typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)){    
                     return arg0;
                 }
             }
             func=func.caller;
         }
         return null;
}

function getObj()
{
	if(document.all)
		return top.Obj;
	else
		return opener.myObject;
}

function getEventSrcElement(evt)
{
	if(document.all)
		return evt.srcElement;
	else
		return evt.target;
}

function getInnerText(obj)
{
	if(document.all)
		return obj.innerText;
	else
		return obj.textContent;
}

function setInnerText(obj,txt)
{
	if(document.all)
		obj.innerText = txt;
	else
		obj.textContent = txt;
}

function showModal(width,height,url1,url2,myObject)
{
	if(document.all)
	{
		var Feature = "dialogWidth:"+width+"px; dialogHeight:"+height+"px;center:yes;status:no;help:no";
		//alert(Feature);
		var retu = window.showModalDialog(url1,myObject,Feature);
		if(retu!=null)
			window.location.reload();
	}
	else
	{
		var x = parseInt(screen.width / 2.0) - (width / 2.0);  
		var y = parseInt(screen.height / 2.0) - (height / 2.0); 
		var feature ="top="+y+",left="+x+",width="+width+",height="+height+",menubar=no,toolbar=no,location=no,scrollbars=no,status=no,dialog=yes,modal=yes";
		window.open(url2,null,feature);
	}
}

function showModal2(width,height,scrollbars,url,myObject)
{
	if(document.all)
	{
		var Feature = "dialogWidth:"+width+"px; dialogHeight:"+height+"px;center:yes;status:no;help:no";
		//alert(Feature);
		var retu = window.showModalDialog(url1,myObject,Feature);
		if(retu!=null)
			window.location.reload();
	}
	else
	{
		var x = parseInt((screen.width-width)/2.0);  
		var y = parseInt((screen.height-height)/2.0); 
		var feature ="top="+y+",left="+x+",width="+width+",height="+height+",menubar=no,toolbar=no,location=no,scrollbars="+scrollbars+",status=no,dialog=yes,modal=yes";
		window.open(url,null,feature);
	}
}

function resizeTo_and_moveTo(width,height){
	resizeTo(width,height);
	var screenwidth=screen.width;
	var screenheight=screen.height;
	var w=parseInt((screenwidth-width)/2);
	var h=parseInt((screenheight-height)/2);
	if(w>0&&h>0){
	moveTo(w,h);
	}
}

function refresh_iframe(parent,frame){
	if(parent){
	parent.frames[frame].location.reload();
	}
}

//判断表单值是否为空
function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		alert(msg);
		field.focus();
		return true;
	}
	return false;
}

function setValue(field,value)
{
//	if(field=='PublishDate'){
//		value = timestampToTime(value);
//	}
	var o = document.getElementById(field);

	if(o)
	{
		if(o.type=="radio")
		{
			setRadioValue(field,value);
		}
		else if(o.type=="checkbox")
		{
			setCheckboxValue(field,value);
		}
		else
			o.value = value;
	}
	else
	{
		o = document.getElementsByName(field);
		if(o)
		{
			if(o.length>0 && o[0].type=="radio")
			{
				setRadioValue(field,value);
			}
			else if(o.length>0 && o[0].type=="checkbox")
			{
				setCheckboxValue(field,value);
			}
			else
				o.value = value;
		}
	}

	if(field=="Keyword"){
        $('#Keyword').tagit('addTags', value);
	}
	
	if(field=="doc_type"||field=="item_type"||field=="juxian_type"){

	    try {
			if(typeof controlField == "function") { //是函数
				 controlField();
			} else { //不是函数
			}
		} catch(e) {}
	   
	}
}

function initRecommendContent()
{
	try{
		setContent(RecommendContent,false);
	}catch(er){	
		window.setTimeout("initRecommendContent()",5);
	}
}

function timestampToTime(timestamp) {
	var date = new Date(timestamp * 1000);//时间戳为10位需*1000，时间戳为13位的话不需乘1000
	Y = date.getFullYear() + '-';
	M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
	D = (date.getDate() < 10 ? '0'+(date.getDate()) : date.getDate()) + ' ';
	h = (date.getHours() < 10 ? '0'+(date.getHours()) : date.getHours()) + ':';
	m = (date.getMinutes() < 10 ? '0'+(date.getMinutes()) : date.getMinutes()) + ':';
	s = (date.getSeconds() < 10 ? '0'+(date.getSeconds()) : date.getSeconds());
	return Y+M+D+h+m+s;
}
	
function setRadioValue(field,value)
{
	o = document.getElementsByName(field);
	var len = o.length;
	for(var i=0;i<len;i++)
	{
		if(value==o[i].value)
		{
				o[i].checked=true
		}
	}
}

function setCheckboxValue(field,value)
{
	value = "," + value + ",";
	o = document.getElementsByName(field);
	var len = o.length;//alert(len);
	for(var i=0;i<len;i++)
	{//alert(value+"|"+o[i].value);
		//alert(value.indexOf(","+o[i].value+","));
		if(value.indexOf(","+o[i].value+",")!=-1)
		{
			o[i].checked=true;
		}
	}
}

//去除前后空格
function trim(s)
{
	return s.replace(/(^\s*)|(\s*$)/g, ""); 
} 

//用脚本加载图片
function autoLoadImage(scaling,width,height,loadpic,t)
{
		//var t=$(this);
		var src=t.attr("src")
		var img=new Image();
		//alert("Loading...")
		img.src=src;
		//自动缩放图片
		var autoScaling=function(){
			if(scaling){
			
				if(img.width>0 && img.height>0){ 
			        if(img.width/img.height>=width/height){ 
			            if(img.width>width){ 
			                t.width(width); 
			                t.height((img.height*width)/img.width); 
			            }else{ 
			                t.width(img.width); 
			                t.height(img.height); 
			            } 
			        } 
			        else{ 
			            if(img.height>height){ 
			                t.height(height); 
			                t.width((img.width*height)/img.height); 
			            }else{ 
			                t.width(img.width); 
			                t.height(img.height); 
			            } 
			        } 
			    } 
			}	
		}
		//处理ff下会自动读取缓存图片
		if(img.complete){
		    //alert("getToCache!");
			autoScaling();
		    return;
		}
		t.attr("src","");
		var loading=$("<img alt=\"加载中...\" title=\"图片加载中...\" src=\""+loadpic+"\" />");
		
		t.hide();
		t.after(loading);
		$(img).load(function(){
			autoScaling();
			loading.remove();
			t.attr("src",this.src);
			t.show();
			//alert("finally!")
		});
}

function log(msg)
{
	alert(msg);
	//if(window.console) console.log(msg);
	//else alert(msg);
}

var tools = tidecms_tools = tidecms = {
	dialogZindex:1050,
	dialognumber:0,
	notify:function(msg)
	{
		var o = $("#tidecms_notify");
		o.find(".tct").html(msg);o.show();
		clearTimeout(o[0].timerId);
        o[0].timerId = setTimeout(function () {
            o.fadeOut("slow")
          }, 3500);
	},
	message:function(msg)
	{
		//2013.12.06 以后作废
		var o = $("#tidecms_notify");
		if(o.size()==1){
			o.find(".tct").html(msg);o.show();
			clearTimeout(o[0].timerId);
		}
	},
	message2:function(msg,id)
	{
		var o = $("#"+id);
		if(o.size()==1){
			if(msg=="") 
				o.find(".tct").html("").hide();
			else
				o.find(".tct").html(msg).show();
			//clearTimeout(o[0].timerId);
		}
	},	
	//显示提示信息窗口
	showmessage:function(msg)
	{
		alert(msg);
		//new top.TideDialog().ShowMsg("ok");
	},

	//设置cookie
	setCookie:function(key,value,days){
		if(days==null || days==""){
			days=100;
		}
		var exp = new Date(); 
		exp.setTime(exp.getTime()+ days*24*60*60*1000); 
		//document.cookie=key+"="+escape(value)+";path=/;expires="+exp.toUTCString();
		document.cookie=key+"="+escape(value)+";expires="+exp.toUTCString();
	},

	//取cookie
	getCookie:function(name){
	var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
	if(arr != null) return unescape(arr[2]); return null;
	},

	//控制台打印调试信息
	log:function(msg)
	{
		if(window.console) console.log(msg);
	},
	//设置日历选择功能,可以是 setDatePicker(".date") 或 setDatePicker("#date01")
	setDatePicker:function(id)
	{
		if($(id).length==0) return;
		$(id).datepicker({
//		showOn: 'button',dateFormat:'yy-mm-dd',buttonImage: '../images/icon/26.png',buttonImageOnly: true,closeText: '关闭',
		prevText: '<上月',
		nextText: '下月>',
		currentText: '今天',
		monthNames: ['一月','二月','三月','四月','五月','六月',
		'七月','八月','九月','十月','十一月','十二月'],
		monthNamesShort: ['一','二','三','四','五','六',
		'七','八','九','十','十一','十二'],
		dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
		dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
		dayNamesMin: ['日','一','二','三','四','五','六'],
		weekHeader: '周',
		dateFormat: 'yy-mm-dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: true,
		yearSuffix: '年',setValue: function(o, s) {
		var i = o.val().indexOf(" ");var m = "";if(i!=-1)m=o.val().substring(i);
		o.val(s+m);
		}});
	},
	//视频播放器
	videoPlayer:function(divid,flv,width,height)
	{
		/*var html = '<object height="'+height+'" width="'+width+'" type="application/x-shockwave-flash" data="../images/video_player.swf">';
		html += '<PARAM NAME="Play" VALUE="0"><PARAM NAME="Loop" VALUE="-1"><PARAM NAME="Quality" VALUE="High">';
		html += '<param name="wmode" value="transparent"><PARAM NAME="AllowScriptAccess" VALUE="sameDomain">';
		html += '<param name="allowFullScreen" value="true">';
		html += '<param name="flashvars" value="v='+flv+'&volume=0.1&autoPlay=true">';
		html += '<param name="bgcolor" value="#000000">';
		html += '</object>';
		*/

		var html = '<embed src="../images/video_player.swf?v='+encodeURIComponent(flv)+'&volume=0.1&autoPlay=true" allowFullScreen="true" quality="high" width="'+width+'" height="'+height+'" wmode="transparent" align="middle" allowScriptAccess="always" type="application/x-shockwave-flash"></embed>';
	
		$("#"+divid).html(html);
	},
	//弹出窗口
	dialog:function(url,width,height,title,layer)
	{
		var	dialog = new top.TideDialog();
		if(width) dialog.setWidth(width);
		if(height) dialog.setHeight(height);
		if (typeof(layer)!='undefined') dialog.setLayer(layer);
		dialog.setUrl(url);
		dialog.setTitle(title);
		dialog.show();
	},
	//得到左侧窗口对象
	getLeftIfm:function()
	{
		return top.frames["main"].frames["ifm_left"];
	},
	//得到右侧窗口对象
	getRightIfm:function()
	{
		return top.frames["main"].frames["ifm_right"];
	},
	//html5拖动上传，o是jquery 对象
	uploadHtml5:function(o,url,data)
	{
		o.bind("dragenter", function(event) { 
			$("#output").css("borderColor","red");
			$("#output-listing01").html("请把文件拖到这里");
			return false; }); 

		o.bind("dragover", function(event) {
			//$("#output").css("borderColor","silver");
			//$("#output-listing01").html("");
			event.stopPropagation(); event.preventDefault();
			return true; }); 
		o.bind("drop", function(e) { 
		//tidecms.log(e.originalEvent.dataTransfer.getData("text/uri-list"));
		try{
		var files=e.originalEvent.dataTransfer.files;
		var xhr = new XMLHttpRequest();
		xhr.open("POST",url);
		var file = files.item(0);
		var fileName = file.name;  
		var fileSize = file.size;  
		//var fileData = file.getAsBinary();

		//tidecms.log(fileName);
		var f = new FormData();
		f.append("Client","1");
		//tidecms.log(data);
		for(i in data){
			if(typeof(data[i])!="function")
				f.append(i,data[i]);
		}
		f.append("file1", file);

		var boundary = "xxxxxxxxx";
		//tidecms.log("ok");
		//xhr.setRequestHeader("Content-Type", "multipart/form-data, boundary="+boundary); // simulate a file MIME POST request.  
		//xhr.setRequestHeader("Content-Length", fileSize);  
		
		var p = '<div class="upload_jdt" style="z-index:999;position:absolute;width:200px"><div id="upload_progress" class="upload_jdt_box" style="width: 0%;"></div></div>';
		$(p).css({top:o.offset().top+o.height()+10,left:o.offset().left}).appendTo($('body'));

		var fileUpload = xhr.upload;
		fileUpload.onprogress=function(e){
			//tidecms.log(e.loaded);
			var percentage = Math.round((e.loaded * 100) / e.total);
			$("#upload_progress").css("width",percentage+"%");
		};

		fileUpload.onload=function(e){
			$("#upload_progress").css("width","100%").parent().remove();
		};
		
		var body = '';
		

		xhr.onreadystatechange = function (e) {
			if (xhr.readyState == 4) {
			if(xhr.status == 200)
			{
				if(data.success) data.success(o,xhr.responseText);
			}
			}
		};
		//xhr.sendAsBinary(body);
		xhr.send(f);

		//tidecms.log(files.length);
		e.stopPropagation(); e.preventDefault();
		}catch(err){e.stopPropagation(); e.preventDefault();}
		return true; }); 
	}
}

;(function () {
	
    $.MsgBox = { 
    	kk : 22 ,
        Alert: function (title, msg) {  
            GenerateHtml("alert", title, msg); 
            $("#alertModal").show();
            $("#alertModal .modal-dialog").slideDown();
            btnOk();  // 
            btnNo();  
        },  
        Confirm: function (title, msg, callback) {  
            GenerateHtml("confirm", title, msg);
            $("#alertModal").show();
            $("#alertModal .modal-dialog").slideDown();
            btnOk(callback);  
            btnNo();  
        }  
    }  
    
    //生成Html  
    var GenerateHtml = function (type, title, msg) {  
        var _html = "";
        
	    _html+= '<div id="alertModal" class="modal show" style="display: none;background: rgba(0,0,0,.2)">'+
	            	'<div class="modal-dialog modal-dialog-vertical-center" style="display:none;" role="document">'+
		              '<div class="modal-content bd-0 tx-14">'+
		                '<div class="modal-header pd-y-20 pd-x-25">'+
		                  '<h6 class="tx-14 mg-b-0 tx-uppercase tx-inverse tx-bold">'+title+'</h6>'+
		                  '<button type="button" class="alert_close close" data-dismiss="modal" aria-label="Close">'+
		                    '<span aria-hidden="true">×</span>'+
		                  '</button>'+
		                '</div>'+
		                '<div class="modal-body pd-25">'+                 
		                  '<p class="mg-b-5">'+ msg +'</p>'+
		                '</div>'+
		                '<div class="modal-footer">'+
		                  '<button id="alert_ok" type="button" class="btn btn-primary tx-11 tx-uppercase pd-y-12 pd-x-25 tx-mont tx-medium">确认</button>'+
		                  '<button id="alert_no" type="button" class="btn btn-secondary tx-11 tx-uppercase pd-y-12 pd-x-25 tx-mont tx-medium" data-dismiss="modal">取消</button>'+
		                '</div>'+
		              '</div>'+
		            '</div> ' + 
				'</div>'
        //必须先将_html添加到body，再设置Css样式  
        $("body").append(_html);   
        //生成Css  
        GenerateCss();  
    }  
     //生成Css  
    var GenerateCss = function () {  
//	    $("#alertModal").css({  background: 'transparent'}); 
        $(".modal-body").css({  position: 'static',  top: '0', left: '0','min-width':"300px"});  
    
    }
  
    //确定按钮事件  
    var btnOk = function (callback) {  
        $("#alert_ok").click(function () {  
            $("#alertModal .modal-dialog").slideUp(100,function(){
            	$("#alertModal").remove();
            });
            if (typeof (callback) == 'function') {  
                callback();  
            }  
        });  
    }  
    //取消按钮事件  
    var btnNo = function () {  
        $("#alert_no,.alert_close").click(function () {  
            //$("#alertModal").remove();
            $("#alertModal .modal-dialog").slideUp(100,function(){
            	$("#alertModal").remove();
            });
            
            
        });  
    }  
})();  

function getCheckbox(){
	var obj={length:500,id:'id'};
	return obj;
};

//获得活跃导航节点
function getActiveNav(){
	var activeLi = $(".sidebar-menu li.active") ;
	var activeA = null ;
	if(activeLi && activeLi.length==1){
		activeA = activeLi.find("a:first") ;
		return activeA[0] ;  //传的是js对象
	}else{
		return activeA ;
	}
}

   
//弹窗alert封装
function TideAlert(title,msg){
	var dialog = new top.TideDialog();	   
		dialog.setWidth(320);
		dialog.setHeight(230);		
		dialog.setTitle(title);
		dialog.setMsg(msg);
		dialog.ShowMsg();
}
//弹窗confirm封装
function TideConfirm(title,msg,msgJs,position){
   var	dialog = new top.TideDialog();      
		dialog.setWidth(320);
		dialog.setHeight(230);
		dialog.setTitle(title);
		dialog.setMsg(msg);
		dialog.setMsgJs(msgJs);   //这个函数就写在你创建alert弹窗函数的页面
		if(position){
			dialog.setPosition(position);
		}
		dialog.ShowMsg();
}    		
//频道字段名，标题，目标文件名，父频道id，选择类型
var SelectChannel  = function(fieldname,fieldname1,TargetName,cid,type){
	var field = "#field_"+fieldname+"_id";
	if(TargetName!=""){
		field = "#field_"+fieldname+"_href";
	}
	if(fieldname1!=""){
		field = "#field_"+fieldname1;
	}
	$(field).after("\r\n<label><input type=\"button\" value=\"选择\" onclick=\"getListHref('"+fieldname+"','"+fieldname1+"','"+TargetName+"',"+cid+","+type+")\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>");
}
function getListHref(fieldname,fieldname1,TargetName,cid,type){
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(400);
		dialog.setUrl("/tcenter/content/selectChannel.jsp?ChannelID="+cid+"&fieldName="+fieldname+"&fieldName1="+fieldname1+"&TargetName="+TargetName+"&type="+type);
		dialog.setTitle('选择');
		dialog.show();
}

//快捷导航
;$(function(){
	$("#fast-nav .dropdown-menu a.nav-link").click(function(){
		var navUrl = $(this).attr("data-url") ;
		var jump = $(this).attr("data-newpage") ;
		if(navUrl && jump==1){
			window.open(navUrl,"_blank");
		}else if(navUrl && jump!=1){
		    location.href = navUrl ;
		}		
		//return false;
	})
	$("#fast-nav .nav-parent-a").click(function(){
		if($(this).next(".dropdovar wn-menu").length == 0){
			var navUrl = $(this).attr("data-url") ;
			var jump = $(this).attr("data-newpage") ;
			if(navUrl && jump==1){
				window.open(navUrl,"_blank");
			}else if(navUrl && jump!=1){
			    location.href = navUrl ;
			}	
		}
	})
	try{
		if(navi_menu){
			var navA = $("#fast-nav>li>a") ;
			navA.each(function(vi,va){
				if($.trim($(va).text()) == navi_menu ){ 
					$(va).addClass("active") ;
				}
			})
		}
	}catch(e){}
	try{
		if(navi_work=="工作台"){
		    $("#workstate").find("i.fa").addClass("tx-warning");
		}else if(navi_work=="工作流"){
		    $("#workflow").find("i.fa").addClass("tx-warning");
		}
	}catch(e){}
	
    //去掉非首页左边框
	if($(".br-header-right>.nav>.dropdown").length===0){
		$(".br-header-right").css({
			"border-left":"none"
		})
	}
	
	
	//定时发布，定时撤稿选择日期
	if($('#SetPublishDate').length>0){
		$('#SetPublishDate').datetimepicker({
			   timeText: '时间',  
			   hourText: '小时',  
			   minuteText: '分钟',  
			   secondText: '秒',  
			   currentText: '现在',  
			   closeText: '完成',  
			   showSecond: true, //显示秒  
			    dateFormat:"yy-mm-dd",
			    timeFormat: 'HH:mm:ss',//格式化时间  
			    monthNames: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],  
		        dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],  
		        dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],  
		        dayNamesMin: ['日','一','二','三','四','五','六']
		});
	}
	if($('#Revoketime').length>0){
		$('#Revoketime').datetimepicker({
			   timeText: '时间',  
			   hourText: '小时',  
			   minuteText: '分钟',  
			   secondText: '秒',  
			   currentText: '现在',  
			   closeText: '完成',  
			   showSecond: true, //显示秒  
			    dateFormat:"yy-mm-dd",
			    timeFormat: 'HH:mm:ss',//格式化时间  
			    monthNames: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],  
		        dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],  
		        dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],  
		        dayNamesMin: ['日','一','二','三','四','五','六']
		});
	}
	
})

// 获取IE版本
function IEVersion() {
    var userAgent = navigator.userAgent;
    // 判断是否为小于IE11的浏览器
    var isLessIE11 = userAgent.indexOf('compatible') > -1 && userAgent.indexOf('MSIE') > -1;
    // 判断是否为IE的Edge浏览器
    var isEdge = userAgent.indexOf('Edge') > -1 && !isLessIE11;
    // 判断是否为IE11浏览器
    var isIE11 = userAgent.indexOf('Trident') > -1 && userAgent.indexOf('rv:11.0') > -1;
    if (isLessIE11) {
        var IEReg = new RegExp('MSIE (\\d+\\.\\d+);');
        // 正则表达式匹配浏览器的userAgent字符串中MSIE后的数字部分，，这一步不可省略！！！
        IEReg.test(userAgent);
        // 取正则表达式中第一个小括号里匹配到的值
        var IEVersionNum = parseFloat(RegExp['$1']);
        if (IEVersionNum === 7) {
        	return 7    // IE7
        } else if (IEVersionNum === 8) {
        	return 8   // IE8
        } else if (IEVersionNum === 9) { 
        	return 9  // IE9
        } else if (IEVersionNum === 10) {
        	return 10  // IE10
        } else {
        	return 6   // IE版本<7
        }
    } else if (isEdge) {
        return 'edge'    // edge
    } else if (isIE11) {
        return 11    // IE11
    } else {
        return -1  // 不是ie浏览器
    }
}
	
//
;$(function(){
	
	function checkIEBrowser(){
		if(typeof IEVersion()=="number" && IEVersion() <11 && IEVersion() >0 ) {
			tidecms.dialog("/tcenter/system/browser_notify.jsp", 500, 300, "浏览器版本提醒", 2);
		}		
	}
	checkIEBrowser();  //浏览器检测
   
})


var gid =  6666;   
//内容列表快速预览

var openFastPreview = false ;    //是否开启过快速预览
var PreviewUrl = "/tcenter/html/fastpreview/fastpreview.html" ;
function fastpreview(gid){   //传参我预留的id,后台开发请自行修改，删掉此注释
	var ckbox = getCurrentCheckbox() ;
	if(ckbox.length==0){
		alert("请选择一个快速预览的稿件") ;
		return false ;
	}
	var parentBrmain = $('.br-mainpanel',window.parent.document);
	var iframe = parentBrmain.find("#content_frame") ;
	var checkedFrame = parentBrmain.find("#fast_preview_frame") ;
	var fastpreviewHide  = $('.fastpreview-hide');
	var fastpreviewShow  = $('.fastpreview-show');
	//var fastpreviewHide = $(top.parent["content_frame"].document).find(".fastpreview-hide") ;
	console.log(fastpreviewHide.length)
	var _url = PreviewUrl +"?id="+gid;  //页面地址
	
	var brsubleft = $('.br-subleft',window.parent.document);
	parentBrmain.css({
		"display":"flex"
	});
	var previewBtnHtml = '<div class="previewBtn"><i class="fa fa-chevron-right" aria-hidden="true"></i></div>';
	console.log(checkedFrame.length,_url)
	if(checkedFrame.length>0){    //如果已经存在快速预览侧边窗口只切换路径
		changeFrameSrc( checkedFrame.get(0) , _url )
	}else{
		var previewIframeHtml = '<iframe class="scrollbar-none" src="'+_url+'" id="fast_preview_frame" style="width: 0%; height: 100%;overflow-x:hidden" frameborder="0" onload="changeFrameHeight(this)"></iframe>' ;
		iframe.after(previewIframeHtml);
		
		var previewBtn = null ;
		var previewIframe = parentBrmain.find("#fast_preview_frame");
		brsubleft.animate({left:'-120px'},200,function(){
			brsubleft.append(previewBtnHtml);
			previewBtn = brsubleft.find(".previewBtn");
			
			previewBtn.on("click",function(e){
				brsubleft.animate({left:'60px'},200).find("ul.sidebar-menu").show(200);;
				parentBrmain.animate({"margin-left":'290px'},200);
				previewIframe.animate({width:'0px'},300,function(){
					previewIframe.remove()
				});
				//brsubleft
				fastpreviewHide.show();
				fastpreviewShow.hide();
				$(this).remove() ;
				openFastPreview = false ;
			})
		});
		parentBrmain.animate({"margin-left":'110px'},200);
		previewIframe.animate({width:'650px'},400);
		brsubleft.find("ul.sidebar-menu").hide(200);
		fastpreviewHide.hide();
		fastpreviewShow.show();
	}
	openFastPreview = true ;
}

//切换快速预览
function changePreview(url){
	var parentBrmain = $('.br-mainpanel',window.parent.document);
	var previewFrame = parentBrmain.find("#fast_preview_frame") ;
	changeFrameSrc( previewFrame.get(0) , url )
}
    	