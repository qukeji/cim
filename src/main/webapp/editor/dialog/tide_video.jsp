 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
/**
 *		修改人		日期		备注
 *		王海龙		20131203	添加上传视频不转码
 *								视频地址进行base64编码
 *								插入视频代码在编辑器中直接预览
 */
int ChannelID = getIntParameter(request,"ChannelID");
Channel channel = CmsCache.getChannel(ChannelID );
//int  globalid = getIntParameter(request,"GlobalID");
//int itemid = getIntParameter(request,"ItemID");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<!--
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2008 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * Special Chars Selector dialog window.
-->
<html>
	<head>
		<meta name="robots" content="noindex, nofollow">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style type="text/css">
				.Hand
				{
					cursor: pointer ;
					cursor: hand ;
				}
				.Sample { font-size: 24px; }
		</style>
<link href="../../style/9/tidecms7.css" type="text/css" rel="stylesheet" />
<script src="common/fck_dialog_common.js" type="text/javascript"></script>
<script src="../../common/common.js" type="text/javascript"></script>
<script type="text/javascript" src="../../common/jquery.js"></script>

<script type="text/javascript">

var swfu;
var returnData = "";





var oEditor = window.parent.InnerDialogLoaded() ;
var dialog		= window.parent ;
var oSample ;

//dialog.AddTab( 'Upload', "上传视频") ;
dialog.AddTab( 'Code', "插入视频代码或地址") ;
dialog.AddTab( 'SelectVideo', "从视频库选择") ;

function OnDialogTabChange( tabCode )
{
	//ShowE('divUpload'		, ( tabCode == 'Upload' ) ) ;
	ShowE('divCode'		, ( tabCode == 'Code' ) ) ;
	ShowE('divSelectVideo'		, ( tabCode == 'SelectVideo' ) ) ;
}

function setDefaults()
{
	 
	oSample = document.getElementById("SampleTD") ;
	// First of all, translates the dialog box texts.
	oEditor.FCKLanguageManager.TranslatePage(document) ;
	window.parent.SetOkButton( true ) ;
	window.parent.SetAutoSize( true ) ;

	//swfu = new SWFUpload(settings);
 
}

function unicodeToByte(str) //将Unicode字符串转换为UCS-16编码的字节数组  
{  
    var result=[];  
    for(var i=0;i<str.length;i++)  
        result.push(str.charCodeAt(i)>>8,str.charCodeAt(i)&0xff);  
    return result;  
} 
//base64编码
/*
function encodeBase64(str)  
{  
	var map="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; //Base64从0到63的对应编码字符集  
    var buffer=0,result="";  
    var arr=unicodeToByte(str);  
    for(var i=0;i<arr.length;i++)  
    {  
        buffer=(buffer<<8)+arr[i];  
        if(i%3==2) //每3个字节处理1次  
        {  
            result+=map.charAt(buffer>>18)+map.charAt(buffer>>12&0x3f)+map.charAt(buffer>>6&0x3f)+map.charAt(buffer&0x3f);  
            buffer=0;  
        }  
    } 
	//3的整数倍的字节已处理完成，剩余的字节仍存放于buffer中  
    if(arr.length%3==1) //剩余1个字节  
        result+=map.charAt(buffer>>2)+map.charAt(buffer<<4&0x3f)+"==";  
    else if(arr.length%3==2) //剩余2个字节  
        result+=map.charAt(buffer>>10)+map.charAt(buffer>>4&0x3f)+map.charAt(buffer<<2&0x3f)+"=";  
    return result;  
}*/
var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
 var base64DecodeChars = new Array(
	 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
	 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
	 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
	 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
	 -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
	-1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1);
//编码的方法
function encodeBase64(str) {
	var out, i, len;
	var c1, c2, c3;
	len = str.length;
	i = 0;
	out = "";
	while(i < len) {
	c1 = str.charCodeAt(i++) & 0xff;
	if(i == len)
	{
		out += base64EncodeChars.charAt(c1 >> 2);
		out += base64EncodeChars.charAt((c1 & 0x3) << 4);
		out += "==";
		break;
	}
	c2 = str.charCodeAt(i++);
	if(i == len)
	{
		out += base64EncodeChars.charAt(c1 >> 2);
		out += base64EncodeChars.charAt(((c1 & 0x3)<< 4) | ((c2 & 0xF0) >> 4));
		out += base64EncodeChars.charAt((c2 & 0xF) << 2);
		out += "=";
		break;
	}
	c3 = str.charCodeAt(i++);
	out += base64EncodeChars.charAt(c1 >> 2);
	out += base64EncodeChars.charAt(((c1 & 0x3)<< 4) | ((c2 & 0xF0) >> 4));
	out += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >>6));
	out += base64EncodeChars.charAt(c3 & 0x3F);
	}
	return out;
}

function Ok()
{
	
	var html;
	var isCode = false ;
	var codeValue = GetE('code').value;
	if(document.getElementById("divSelectVideo").style.display!="none"){
		var obj=window.frames["video"].getRadio();
        if(obj) html=obj.html;
	}

	if(codeValue.toLowerCase().indexOf("embed")!=-1||codeValue.toLowerCase().indexOf("object")!=-1){//插入视频代码
		isCode = true;
		html = codeValue;
	}else if(codeValue!=""){//插入视频地址
	    isCode  = true;
	    html = "<div style=\"width:480px; height:360px;margin:0 auto;\" align=\"center\"><span id=\"tide_video\" photoid=\"\">"  
	    html +='<script>tide_player.showPlayer({video:"'+encodeBase64(codeValue)+'"});<\/script><\/span><\/div>';;
	}

    if(!isCode&&html!== undefined)
		html = "<div style=\"width:480px; height:360px;margin:0 auto;\" align=\"center\"><span id=\"tide_video\" photoid=\"\">" + html + "<\/span><\/div>";

	if(html!=""&&html!== undefined)
	{
		oEditor.FCKUndo.SaveUndoStep() ;
		oEditor.FCK.InsertHtml(html) ;//alert(html);
	}
	
	return true ;
}


</script>
	</head>
	<body onload="setDefaults()" style="overflow: hidden">

	<div id="divCode">
		<table cellpadding="0" cellspacing="0" width="100%" height="100%">
			<tr>
				<td width="100%">
					<table cellpadding="1" cellspacing="1" align="center" border="0" width="100%" height="100%">
					<tbody id="tbody1">
					<tr><td><textarea cols="100" class="textfield" rows="18" name="code" id="code"></textarea></td><td></td></tr>
					</tbody>
					</table>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="divSelectVideo" style="display: none">
		<table cellpadding="0" cellspacing="0" width="100%" height="100%">
			<tr>
				<td width="100%">
					<table cellpadding="1" cellspacing="1" align="center" border="0" width="100%" height="100%">
					<tbody >
					<tr><td><iframe  marginheight="0" frameborder="no"  id="video" name="video" marginwidth="0" scrolling="auto" height="420" width="750" src="../../video/video_list_select.jsp"></iframe></td><td></td></tr>
					</tbody>
					</table>
				</td>
			</tr>
		</table>
	</div>
	</body>
</html>
