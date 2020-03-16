<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int ChannelID = getIntParameter(request,"ChannelID");
%>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">

<script language=javascript>
function preview()
{
	if(document.form.Thumbnail.checked)
	{
		var htmlstr = "";
		for(var i = 1;i<7;i++)
		{
			var obj = eval("document.form.file"+i);
			if(obj.value!="")
			{
				htmlstr += "<a href=\"" + obj.value + "\" target='_blank'>";
				htmlstr += "<img border=0 width=" + document.form.ThumbnailWidth.value+" height="+ document.form.ThumbnailHeight.value
				htmlstr += " src='" + obj.value + "'></a><br>"+getExtname(obj.value) + "<br><br>";
			}
		}
		document.all.Preview.innerHTML = htmlstr;
	}
	else
	{
		var htmlstr = "";
		for(var i = 1;i<7;i++)
		{
			var obj = eval("document.form.file"+i);
			if(obj.value!="")
			{
				htmlstr += "<img src='" + obj.value + "'><br>"+getExtname(obj.value) + "<br><br>";
			}
		}
		document.all.Preview.innerHTML = htmlstr;
	}
}

function thumb(){
	if (document.form.Thumbnail.checked){
		ThumbnailProperty.style.display="block";
	}
	else{
		ThumbnailProperty.style.display="none";
	}
	preview();
}
function more(){
	if (document.form.MoreUpload.checked){
		Morefile.style.display="block";
	}
	else{
		Morefile.style.display="none";
	}
}

function getExtname(filename){
	var pos = filename.lastIndexOf("\\");
	return (filename.substr(pos+1));
}

function check()
{
	document.form.Button2.disabled = true;
	Message.style.display = "";

	return true;
}

function toEnd()
{
var e = event.srcElement;
var r =e.createTextRange();
r.moveStart("character",e.value.length);
r.collapse(true);
r.select();
}
</script>
<body topmargin="0" leftmargin="0">
<form action="insertimage_submit.jsp" enctype="multipart/form-data" method="post"  name="form" onSubmit="return check();">
<br>
<br>

<table width="500" border=0 align="center">
<tr><td width="60%" valign="top">请选择文件：<br>
<input type=file name="file1" size="30" onchange="preview();" class="textfield" onfocus="toEnd()"><br>
<div id="Morefile" style="display:none">
<input type=file name="file2" size="30" onchange="preview();" class="textfield" onfocus="toEnd()"><br>
<input type=file name="file3" size="30" onchange="preview();" class="textfield" onfocus="toEnd()"><br>
<input type=file name="file4" size="30" onchange="preview();" class="textfield" onfocus="toEnd()"><br>
<input type=file name="file5" size="30" onchange="preview();" class="textfield" onfocus="toEnd()"><br>
<input type=file name="file6" size="30" onchange="preview();" class="textfield" onfocus="toEnd()"><br>
</div>
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
<input type="hidden" name="Submit" value="Submit">
<br>
<input type=checkbox name="Thumbnail" onclick="thumb();" value="Yes">生成缩略图
<input type=checkbox name="MoreUpload" onclick="more();" value="Yes">多图上传
<br>
<div id=ThumbnailProperty style="display:none;">
宽度：<input type=text name=ThumbnailWidth value="140" onchange="preview();"><br>
高度：<input type=text name=ThumbnailHeight value="100" onchange="preview();"><br>
文本：<input type=text name=ThumbnailAlt value="点击看大图"><br>
目标：<input type=text name=ThumbnailTarget value="_blank">
</div>
		  <div id="Message" style="display:none"><font color=red>正在上传....</font></div>
</td><td valign="top" width="40%" style="border-left:1 solid buttonshadow;border-top:1 solid buttonshadow;border-right:1 solid buttonhilight;border-bottom:1 solid buttonhilight;height:300px">
预览:<br>
<div style="width:100%;overflow: auto;height:290"><div id=Preview style="overflow: visible;"></div></div>
</td></tr>
</table>
<center>
<input name="Button2" type="submit" class="tidecms_btn3" value="  确  定  ">
&nbsp; <input type="button" value=" 取 消 " name="B1" class="tidecms_btn3" onclick="top.close();">
</center>
</FORM> 
</body> 
