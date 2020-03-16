ContextMenu.intializeContextMenu=function()
{
	if(document.all)
	{
		document.body.insertAdjacentHTML("BeforeEnd", '<iframe scrolling="no" class="WebFX-ContextMenu" marginwidth="0" marginheight="0" frameborder="0" style="position:absolute;display:none;z-index:50000000;" id="WebFX_PopUp"></iframe>');
		WebFX_PopUp    = self.frames["WebFX_PopUp"]
		WebFX_PopUpcss = document.getElementById("WebFX_PopUp")
	}
	else
	{
		var ifrm = document.createElement("iframe");
		ifrm.style.display = "none";
		ifrm.style.position = "absolute";
		ifrm.style.zIndex = "500";
		ifrm.scrolling = "no";
		ifrm.marginwidth = "0";
		ifrm.marginheight = "0";
		ifrm.className = "WebFX-ContextMenu";
		ifrm.frameborder = "0";


		document.body.appendChild(ifrm);

		WebFX_PopUp    = ifrm;//self.frames["WebFX_PopUp"]; 
		WebFX_PopUpcss = ifrm;//document.getElementById("WebFX_PopUp");	alert(WebFX_PopUpcss);
	}

	document.body.attachEvent("onmousedown",function(){WebFX_PopUpcss.style.display="none"})
	//WebFX_PopUpcss.onfocus  = function(){WebFX_PopUpcss.style.display="inline";};
	WebFX_PopUpcss.onblur  = function(){WebFX_PopUpcss.style.display="none"}; //alert(self);
	document.body.attachEvent("onblur",function(){WebFX_PopUpcss.style.display="none"})
}

function InsertHtmlEnd( html, element )
{
	if (element.insertAdjacentHTML)	// IE
		element.insertAdjacentHTML('BeforeEnd', html) ;
	else								// Gecko
	{ alert(element);
		var oRange = document.createRange() ;
		oRange.setStartBefore(element) ;
		var oFragment = oRange.createContextualFragment(html);
		element.appendChild(oFragment);
	}
}

function ContextSeperator(){}

function ContextMenu(){}

ContextMenu.showPopup=function(x,y)
{
	WebFX_PopUpcss.style.display = "block"
}

ContextMenu.getEvent=function()
{
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

ContextMenu.display=function(popupoptions)
{
    var eobj,x,y;
	eobj = getEvent();

	if(document.all)
	{
		x = eobj.x;
		y = eobj.y;
	}
	else
	{
		x = eobj.pageX;
		y = eobj.pageY;
	}

	ContextMenu.populatePopup(popupoptions,window)
	
	ContextMenu.showPopup(x,y);
	ContextMenu.fixSize();
	ContextMenu.fixPos(x,y)
    eobj.cancelBubble = true;
    eobj.returnValue  = false;
}

//TODO
 ContextMenu.getScrollTop=function()
 {
 	return document.body.scrollTop;
	//window.pageXOffset and window.pageYOffset for moz
 }
 
 ContextMenu.getScrollLeft=function()
 {
 	return document.body.scrollLeft;
 }
 

ContextMenu.fixPos=function(x,y)
{
	var docheight,docwidth,dh,dw;	
	docheight = document.body.clientHeight;	
	docwidth  = document.body.clientWidth;

	
	if(document.all)
	{
		popup = WebFX_PopUpcss;
	}
	else
	{
		popup = WebFX_PopUpcss.contentDocument.body;
	}

	dh = (popup.offsetHeight+y) - docheight;
	dw = (popup.offsetWidth+x)  - docwidth; 


	//alert(dh);
	if(dw>0)
	{
		WebFX_PopUpcss.style.left = (x - dw) + ContextMenu.getScrollLeft() + "px";		
	}
	else
	{
		WebFX_PopUpcss.style.left = x + ContextMenu.getScrollLeft();
	}
	if(dh>0)
	{
		WebFX_PopUpcss.style.top = (y - dh) + ContextMenu.getScrollTop() + "px"
	}
	else
	{
		WebFX_PopUpcss.style.top  = y + ContextMenu.getScrollTop();
	}
}

ContextMenu.fixSize=function()
{
	var body,h,w;

//	WebFX_PopUpcss.style.width = "10px";
	WebFX_PopUpcss.style.width = "60px";
	WebFX_PopUpcss.style.height = "100px";

	if(document.all)
		body = WebFX_PopUp.document.body; 
	else
		body = WebFX_PopUp.contentWindow.document.body;
	// check offsetHeight twice... fixes a bug where scrollHeight is not valid because the visual state is undefined
	var dummy = WebFX_PopUpcss.offsetHeight + " dummy";

	if(document.all)
	{
		//alert(WebFX_PopUp.document.body.innerHTML);
		h = body.scrollHeight + WebFX_PopUpcss.offsetHeight - body.clientHeight; 
		w = body.scrollWidth + WebFX_PopUpcss.offsetWidth - body.clientWidth;
	}
	else
	{
		h = body.scrollHeight + WebFX_PopUpcss.offsetHeight - body.clientHeight;
		w = body.scrollWidth + WebFX_PopUpcss.offsetWidth - body.clientWidth;
	}
	
	if(w<=100)
		w = 100;
	WebFX_PopUpcss.style.height = h + "px";
	WebFX_PopUpcss.style.width = w + "px";

	//WebFX_PopUpcss.style.width = "100px";
	//use document.height for moz
}

ContextMenu.populatePopup=function(arr,win)
{
	var alen,i,tmpobj,doc,height,htmstr;
	alen = arr.length;

	if(document.all)
		doc  = WebFX_PopUp.document;
	else
		doc =  WebFX_PopUp.contentWindow.document;

	doc.body.innerHTML  = ""
	if (doc.getElementsByTagName("LINK").length == 0) {
		doc.open();
		doc.write('<html><head><link rel="StyleSheet" type="text/css" href="../common/WebFX-ContextMenu.css"></head><body></body></html>');
		doc.close();
	}
	for(i=0;i<alen;i++)
	{
		if(arr[i].constructor==ContextItem)
		{
			tmpobj=doc.createElement("DIV");
			tmpobj.noWrap = true;
			tmpobj.className = "WebFX-ContextMenu-Item";

			if(arr[i].disabled)
			{
				htmstr  = '<span class="WebFX-ContextMenu-DisabledContainer"><span class="WebFX-ContextMenu-DisabledContainer">'
				htmstr += arr[i].text+'</span></span>'
				tmpobj.innerHTML = htmstr
				tmpobj.className = "WebFX-ContextMenu-Disabled";
				tmpobj.onmouseover = function(){this.className="WebFX-ContextMenu-Disabled-Over"}
				tmpobj.onmouseout  = function(){this.className="WebFX-ContextMenu-Disabled"}
			}
			else
			{
				tmpobj.innerHTML = arr[i].text;
				tmpobj.onclick = (function (f)
								{
				   					 return function () {
			    			     							win.WebFX_PopUpcss.style.display='none';
															
										    			    if (typeof(f)=="function"){ f(); }
                										 };
								})(arr[i].action);
					
				tmpobj.onmouseover = function(){this.className="WebFX-ContextMenu-Over"}
				tmpobj.onmouseout  = function(){this.className="WebFX-ContextMenu-Item"}
			}
			doc.body.appendChild(tmpobj);
		}
		else
		{
			doc.body.appendChild(doc.createElement("DIV")).className = "WebFX-ContextMenu-Separator";
		}
	}
	doc.body.className  = "WebFX-ContextMenu-Body" ;
	doc.body.onselectstart = function(){return false;}
}

function ContextItem(str,fnc,disabled)
{
	this.text     = str;
	this.action   = fnc; 
	this.disabled = disabled || false;
}