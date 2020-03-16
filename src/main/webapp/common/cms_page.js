var isTideCMSPageEdit = true;

function cms_module(pageid,moduleid,index){
	var myObject = new Object();
    myObject.title = "模块管理";

 	var Feature = "dialogWidth:32em; dialogHeight:26em;center:yes;status:no;help:no;resizable:yes";
	var retu = window.showModalDialog("../modal_dialog.jsp?target=channel/pagemodule_add.jsp&PageID=" + pageid + "&ModuleID=" + moduleid + "&Index=" + index,myObject,Feature);
	if(retu!=null)
		window.location.reload();	
}

function cms_module_content_add(moduleid)
{
  		var width  = Math.floor( screen.width  * .7 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  		var url="module_content_add.jsp?ModuleID=" + moduleid;
  		window.open(url,"",Feature);
}

function cms_module_content_list(moduleid,type)
{
	if(type==1)
	{
  		var width  = Math.floor( screen.width  * .7 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
		url = "module_content_list.jsp?ModuleID=" + moduleid;
 		var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
		window.open(url,"",Feature);
	}
	else
	{
		var myObject = new Object();
		myObject.title = "模块内容编辑";

		var Feature = "dialogWidth:32em; dialogHeight:24em;center:yes;status:no;help:no";
		var retu = window.showModalDialog("../modal_dialog.jsp?target=channel/pagemodule_add_2.jsp&ModuleID=" + moduleid,myObject,Feature);
		if(retu!=null)
			window.location.reload();
	}
}

function cms_module_del(moduleid)
{
	var myObject = new Object();
    myObject.title = "删除模块";

//	if(moduleid>0)
//	{
	var Feature = "dialogWidth:32em; dialogHeight:24em;center:yes;status:no;help:no";
	var retu = window.showModalDialog("../modal_dialog.jsp?target=channel/pagemodule_delete.jsp&ModuleID=" + moduleid,myObject,Feature);
	if(retu!=null)
		window.location.reload();
//	}
//	else if(index>0)
//	{
//		if(confirm("确实要删除这个模块标记吗?")) 
//			this.location = "pagemodule_delete.jsp?Action=Delete&ModuleID=" + moduleid + "&PageID=" + pageid;
//	}
}

function cms_module_add(pageid,moduleid,index)
{
	if(confirm("你确定要在此处下面增加一个模块标记吗?")) 
		this.location = "pagemodule_copy.jsp?PageID=" + pageid + "&ModuleID=" + moduleid + "&Index=" + index;
}

function page_preview(id)
{
	window.open("page_preview.jsp?id="+id);
}

function page_publish(id)
{
	var myObject = new Object();
    myObject.title = "发布页面";

	var Feature = "dialogWidth:22em; dialogHeight:14em;center:yes;status:no;help:no";
	var retu = window.showModalDialog("../modal_dialog.jsp?target=channel/page_publish.jsp&id=" + id,myObject,Feature);
}

var objname = "";
var pX = 0;
var pY = 0;
function   mousemove(layer_id)   
{
	if(objname=='') return;
	var o = document.getElementById(objname);
	o.style.left=window.event.x-pX;
	o.style.top=window.event.y-pY;	
}

function mousedown(obj)
{
	objname = obj;
	var o = document.getElementById(objname);
	o.setCapture()
	pX = window.event.x-o.style.pixelLeft;
	pY = window.event.y-o.style.pixelTop;
}

function mouseup(obj)
{
	objname = obj;
	var o = document.getElementById(objname);
	o.releaseCapture();
	objname = "";
}