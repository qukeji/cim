<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
int video_type = CmsCache.getParameter("sys_editor_video_type").getIntValue();

TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
String inner_url = "",outer_url="";
if(photo_config != null)
{
	int sys_channelid_image = photo_config.getInt("channelid");
	Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
	inner_url = img_site.getUrl();
	outer_url = img_site.getExternalUrl();
}
%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <script type="text/javascript" src="../internal.js"></script>

    <link rel="stylesheet" href="../../../style/2018/common.css">
    <link rel="stylesheet" href="../../../style/2018/bracket.css">

    <link rel="stylesheet" type="text/css" href="video.css" />


    <style>
        /*tooltip相关样式*/
        .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
        .tooltip.bs-tooltip-right .arrow::before,
        .tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {border-right-color: #00b297;}
    </style>

</head>
<body>
<div class="wrapper">
    <div id="videoTab">
        <div id="tabHeads" class="tabhead">
            <span tabSrc="video" class="focus" data-content-id="video">插入视频地址</span>
			<span tabSrc="local" class="" data-content-id="local">本地上传</span>
			
            <span tabSrc="upload" data-content-id="upload"><var id="lang_tab_uploadV"></var></span>
        </div>
        <div id="tabBodys" class="tabbody">
            <div id="video" class="panel focus">
                <table>
                    <tr>
                        <td><label for="videoUrl" class="url">视频地址</label></td><td><input id="videoUrl" type="text"></td>
                    </tr>  
                    <tr>
                       <td class="align-center"><label for="photoUrl" class="url">封面图地址</label></td>
                        <td style="width:650px">
                            <label style="display:block;float:left;width:515px;">
                                <input id="photoUrl" type="text"  name="Photo">
                            </label>
                            <label style="margin-top: 12px;">
                                <input type="button" value="选择" onClick="selectImage('Photo')" class="btn btn-primary tx-size-xs mg-l-10">
                            </label>
                            <label style="margin-top: 12px;">
                                <input type="button" value="预览" onClick="previewFile('Photo')" class="btn btn-primary tx-size-xs mg-l-10">
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td><label for="videoWidth" class="url">宽度</label></td><td><input id="videoWidth" type="text"></td>
                    </tr>
                    <tr>
                        <td><label for="videoHeight" class="url">高度</label></td><td><input id="videoHeight" type="text"></td>
                    </tr>
                </table>
				
            </div>
		    <div id="local" class="panel">
				<iframe id="localvideo" src="ueditor_video.jsp" name="localvideo" frameborder="0" width="100%" height="100%" scrolling="no" style="" allowtransparency="true"></iframe>		
			</div>
			        
            <div id="upload" class="panel">
				<iframe id="uploadvideo" src="../../../video/video_list_select.jsp" name="video" frameborder="0" width="100%" height="100%" scrolling="no" style="" allowtransparency="true"></iframe>
            </div>
		 </div>
     </div>
 </div>
<!-- jquery -->
<script type="text/javascript" src="../../third-party/jquery-1.10.2.min.js"></script>

<!-- webuploader -->
<script type="text/javascript" src="../../third-party/webuploader/webuploader.min.js"></script>
<link rel="stylesheet" type="text/css" href="../../third-party/webuploader/webuploader.css">

<!-- video -->
<script type="text/javascript" src="video.js"></script>
<!--<script src="../../../common/document.js"></script>-->
<script src="../../../common/2018/common2018.js"></script>
<script type="text/javascript" src="../../../common/2018/TideDialog2018.js"></script>

<script>

var video_type = <%=video_type%>;
var inner_url = "<%=inner_url%>";
var outer_url = "<%=outer_url%>";

function previewFile()
{
	var name = document.getElementById("photoUrl").value;
	//图片库采用本地预览
	var reg = new RegExp(outer_url,"g");
	if(name=="") return;

	if(name.indexOf("http://")!=-1)  window.open(name.replace(reg,inner_url));
	else	window.open("/" + name);
}

function setPath(path){
	$("#photoUrl").val(path);
}
var channelid = 0;
function selectImage(fieldname)
{
	var	dialog = new TideDialog();
		dialog.setWidth(730);
		dialog.setHeight(450);
		//dialog.setLayer(2);
		dialog.setZindex(9999);
		dialog.setUrl("../../../ueditor/dialogs/video/insertfile_video.jsp?ChannelID="+channelid+"&Type=Image&fieldname="+fieldname);
		dialog.setTitle("上传图片");
		dialog.show();
}

var parentcID = window.parent.ChannelID ;
$("#localvideo")[0].src = "ueditor_video.jsp?ChannelID="+parentcID


</script>
</body>
</html>