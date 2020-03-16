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
int level  = getIntParameter(request,"level");

int itemid  = getIntParameter(request,"itemid");
int channelid = getIntParameter(request,"channelid");

Document doc = new Document(itemid,channelid);


String p = doc.getValue("Parent");
int parent = 0;
if(!"".equals(p))
{
	parent = Integer.parseInt(p);
}
if(Submit.equals("Submit"))
{
	Channel channel = CmsCache.getChannel(channelid);
	HashMap map = new HashMap();
	map.put("Title", city_name);
	if(itemid==0)
	{
		map.put("Parent", 0+"");
	}
	else
	{
		map.put("Parent", parent+"");
	}
	if(level==0)
	{
		map.put("Level", 1+"");
	}
	else
	{
		map.put("Level", (level)+"");
	}
	
	map.put("PublishDate",Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
	map.put("Status","1");
	map.put("tidecms_addGlobal", "1");
	ItemUtil util_ = new ItemUtil();
	int globalid = util_.addItem(channelid,map).getGlobalID();
	
	Document doc_ = new Document(globalid);
	int itemid_  = doc_.getId();

	//action=1同级添加
	String json = "{action:1,itemid:\""+itemid_+"\",globalid:\""+globalid+"\",title:\""+city_name+"\",level:\""+(level)+"\"}";
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
<script>
function check(){	
	if($("#city_name").val()=="")
	{
		alert("no kong");
	}
	else
	{
		var cityname = $("#city_name").val();
		//点击确定按钮，并跳转到check_hascity.jsp处理
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
<form name="form" method="post" action="multi_category_add_new.jsp?channelid=<%=channelid%>&itemid=<%=itemid%>&level=<%=level%>&Submit=Submit" id="jobform">
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
<table width="100%" align="center">
  <tr>
    <td>名称：</td>
    <td><input name="city_name" id="city_name" class="textfield" type="text" value="" /></td>
  </tr>
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
	<input name="startButton" type="button" class="button" value="确定" id="startButton" onclick="check()"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>
