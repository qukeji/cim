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
		document.cookie=key+"="+escape(value)+";path=/;expires="+exp.toUTCString();
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
		$(id).datepicker({showOn: 'button',dateFormat:'yy-mm-dd',buttonImage: '../images/icon/26.png',buttonImageOnly: true,closeText: '关闭',
		prevText: '&#x3c;上月',
		nextText: '下月&#x3e;',
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
		html += '<param name="flashvars" value="v='+flv+'&amp;volume=0.1&amp;autoPlay=true">';
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