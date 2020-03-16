<%@ page
import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.user.*,java.util.*,java.sql.*"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

if(! userinfo_session.isAdministrator())
{
	response.sendRedirect("../noperm.jsp");
	return;
}

String Submit = getParameter(request,"Submit");
String city_name = getParameter(request,"city_name");
String photo_request=getParameter(request,"Photo");
String phototop_request=getParameter(request,"PhotoTop");
int level  = getIntParameter(request,"level");
int itemid  = getIntParameter(request,"itemid");
int channelid = getIntParameter(request,"channelid");
Document doc = new Document(itemid,channelid);
String Title = doc.getValue("Title");
String Photo = doc.getValue("Photo");
String Parent= doc.getValue("Parent");
String PhotoTop=doc.getValue("PhotoTop");
int thislevel=doc.getIntValue("Level");
int globalid = doc.getGlobalID();

if(Submit.equals("Submit"))
{	
	Channel channel = CmsCache.getChannel(channelid);
	String channel_name = channel.getTableName();
	TableUtil tu = new TableUtil();
	String updatesql = "update "+channel_name+" set Title='"+city_name+"' ,Photo='"+photo_request+"' ,PhotoTop='"+phototop_request+"' where Status=1 and id="+itemid;
	tu.executeUpdate(updatesql);
	//action=3更新操作
	String json = "{action:3,itemid:\""+itemid+"\",globalid:\""+globalid+"\",title:\""+city_name+"\",level:\""+(level)+"\"}";
	out.println("<script>top.TideDialogClose({refresh:'right.update("+json+");'});</script>");
	return;
}

java.util.Date thedate = new java.util.Date();

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title>TideCMS</title>
<link href="../style/form-common.css" rel="stylesheet" />
<link href="../style/dialog.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script>
function selectImage(fieldname)
{
	var	dialog = new TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(400);
	dialog.setLayer(3);
        dialog.setZindex(10000);
	dialog.setUrl("../content/insertfile.jsp?ChannelID=<%=channelid%>&Type=Image&fieldname="+fieldname);
	dialog.setTitle("图片上传");
	dialog.show();
}
function previewFile(fieldname)
{
	var name = document.getElementById(fieldname).value;
	if(name.indexOf("http://")!=-1)  window.open(name);
	
}
function check()
{	
	if($("#city_name").val()=="")
	{
		alert("no kong");
	}
	else
	{
		var cityname = $("#city_name").val();
		//跳转处理确定按钮的jsp
		var url="check_hascity.jsp?itemid="+<%=itemid%>+"&channelid="+<%=channelid%>+"&cityname="+encodeURIComponent(cityname);
		$.ajax({
					type: "get",
					url: url,
					success: function(msg){
					 
						if(msg==1){
							alert("该记录已在本级存在！");
						}else{
							$("#jobform").submit();
						}
					}
				});
	}
}

</script>
<style> 
.edit-main{margin:0;position:Static;}
.edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
.edit-con{position:Static;margin:-1px 0 0;}
.edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
</style>
</head>

<body>
<form name="form" method="post" action="multi_category_edit.jsp?channelid=<%=channelid%>&itemid=<%=itemid%>&level=<%=level%>&Submit=Submit" id="jobform">
<!-- start-->
<div class="edit-main">
	<div class="edit-nav">
    	
        <div class="clear"></div>
    </div>
    <div class="edit-con">
    	<div class="top">
        	<div class="left"></div>
            <div class="right"></div>
        </div>
		<div class="center_main">

<div class="center" id="form1">
<table width="100%" border="0" align="center">
  <tr>
    <td>名称：</td>
    <td><input name="city_name" id="city_name" type="text"  value="<%=Title%>" class="textfield"/></td>
  </tr>
<tr id="tr_Photo"><td><div class="line" id="desc_Photo">图片：</div></td><td><div class="line " id="field_Photo"><input type="text" name="Photo" id="Photo" value="<%=Photo%>" class="textfield upload field_image" title="" size="80">
<input type="button" value="选择" onclick="selectImage('Photo')" class="tidecms_btn3"> <input type="button" value="预览" onclick="previewFile('Photo')" class="tidecms_btn3">
</div></td></tr>
<%if(thislevel==1){%>
<tr id="tr_Photo"><td><div class="line" id="desc_PhotoTop">模块主题图片：</div></td><td><div class="line " id="field_PhotoTop"><input type="text" name="PhotoTop" id="PhotoTop" value="<%=PhotoTop%>" class="textfield upload field_image" title="" size="80">
<input type="button" value="选择" onclick="selectImage('PhotoTop')" class="tidecms_btn3"> <input type="button" value="预览" onclick="previewFile('PhotoTop')" class="tidecms_btn3">
</div></td></tr>
<%}%>
</table>
</div>     

        </div>
        <div class="bot">
        	<div class="left"></div>
            <div class="right"></div>
        </div>
    </div>
</div>
<!-- end-->
<div class="form_button">
	<input type="hidden" name="CopyMode"  id="CopyMode" value="1">
	<input type="hidden" name="Submit" value="Submit">
	<input type="hidden" name="SiteId" value="">
        <input type="hidden" name="pparent" value="<%=Parent%>">
	<input name="startButton" type="button" class="button" value="确定" id="startButton" onclick="check()"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>
