<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%String url = request.getRequestURL()+"";
url = url.replace("tools.jsp","");%>

var tidecms_url = "<%=url%>";

if(window.felttip&&window.felttip.loaded)
{
	window.felttip.show();
}
else
{
	setTimeout(function(){var f="tidecmsDivLoading";var o=document.getElementById(f)||document.createElement("div");
	o.id=f;
	o.innerHTML="加载TideCMS工具栏...";
	o.style.cssText="width:250px;top:0;left:0;background-color:#CC4444;color:#fff;font:normal 14px arial;padding:2px;padding-left:6px;z-index:99999;position:absolute;";
	document.body.appendChild(o);

	var o4 = document.getElementById("felttip_jquery");
	if(o4)
		o4.parentNode.removeChild(o4);		
	var o5 = document.createElement("script");o5.type="text/javascript";o5.id="felttip_jquery";
	o5.src = tidecms_url + "common/jquery.js";
	document.body.appendChild(o5);

	var o3 = document.getElementById("felttip_main");
	if(o3)
		o3.parentNode.removeChild(o3);		
	var o2 = document.createElement("script");o2.type="text/javascript";o2.id="felttip_main";o2.charset="utf-8";
	o2.src = tidecms_url + "common/tools.js";
	document.body.appendChild(o2);
	},100);
}