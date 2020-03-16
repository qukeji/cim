<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.page.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
request.setCharacterEncoding("utf-8");
String info="";
int	ChannelID		=	getIntParameter(request,"ChannelID");
//out.println("ChannelID"+ChannelID);
int	pagenum		=	getIntParameter(request,"pagenum");
String Type			=	getParameter(request,"Type");
String ChannelName	=	getParameter(request,"ChannelName");
String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1){
	pageName = pageName.substring(pindex+1);
}
int		SpecialTemplate			= getIntParameter(request,"SpecialTemplate");

ChannelPrivilege cp = new ChannelPrivilege();
if(!cp.hasRight(userinfo_session,ChannelID,ChannelPrivilege.AddItem))
{
	out.println("<script>top.getDialog().Close();</script>");return;
}

if(SpecialTemplate>0)
{
	String	NewChannelName			= getParameter(request,"NewChannelName");
	String	NewFolder				= getParameter(request,"NewFolder");
	String	keyword					= getParameter(request,"keyword");
	String	description				= getParameter(request,"description");

	int		Parent					= getIntParameter(request,"Parent");

	SpecialChannelUtil special = new SpecialChannelUtil();
	
	special.setSourceChannelID(SpecialTemplate);
	special.setNewChannelName(NewChannelName);
	special.setNewFolder(NewFolder);
	special.setNewChannelParentID(Parent);
	special.setActionUser(userinfo_session.getId());
	special.setKeyword(keyword);
	special.setDescription(description);
	special.generateSpecial();

	userinfo_session.initChannelPermArray();

	//Page pageitem = new Page();
	//pageitem.updatePageSeo(keyword, description);

	out.println("<script>top.TideDialogClose({refresh:'left'});</script>");return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script language=javascript>
function init()
{

}

function check()
{
	if(isEmpty(document.form.NewChannelName,"请输入专题名称"))
	return false;

	if(isEmpty(document.form.NewFolder,"请输入专题路径，比如:guoqing."))
	return false;

	var smallch="abcdefghijklmnopqrstuvwxyz_0123456789"; 

	for(var i=0;i<document.form.NewFolder.value.length;i++)
	{
		var exist = false;
		for(var j=0;j<smallch.length;j++)
		if(document.form.NewFolder.value.charAt(i)==smallch.charAt(j))
			{
				exist = true;
			}
		

		if(!exist)
		{
			alert("路径名称必须由以下字母组成："+smallch);
			document.form.NewFolder.focus();
			return false;
		}

	}
			
	return true;
}

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

function showStep(step)
{	
	$("#pages").remove();
	if(step==2)
	{
		document.getElementById("step1").style.display = "none";
		document.getElementById("step2").style.display = "";
		
		document.getElementById("stepButton2").style.display = "none";
		document.getElementById("submitButton").style.display = "";		
	}

	if(step==3)
	{
		if(check())
		{
			$.get("channel_special_checkfolder.jsp?id="+$("#ChannelID").val()+"&Folder="+$("#NewFolder").val(), function(o){
			  if(o==1)
				{
				  if(confirm("目录已经存在，新的专题可能会覆盖原有的文件，请问是否继续？")){
					  document.getElementById("submitButton").disabled=true;
					  document.getElementById("submitButton").style.cursor="default";
					  document.getElementById("submitButton").style.color="#cccccc";
					  document.getElementById("tishi").innerHTML="正在生成专题...";
					  document.form.submit();
				  }
				}
			  if(o==0){
				  document.getElementById("submitButton").disabled=true;
				  document.getElementById("submitButton").style.cursor="default";
				  document.getElementById("submitButton").style.color="#cccccc";
				  document.getElementById("tishi").innerHTML="正在生成专题...";
				  document.form.submit();
				  }
			}); 
		}
	}	
}
function Preview(id)
{
	 window.open("special_preview.jsp?id=" + id);
}

function select(o)
{
	$(o).find(".radio").attr("checked", "checked");
}
</script>

<style>
body{background:none;}
.content-top,.content,.content_bot{margin:0;}
</style>
</head>
<body onLoad="init();" scroll="no">
<form name="form" action="channel_special_add.jsp" method="post" onSubmit="return check();">
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>

<!-- content -->
<div class="content" id="step1">
<div class="viewpane">
<div class="viewpane_tbdoy">
<table width="100%" border="0" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle">选择</th>
    				<th class="v3" style="padding-left:10px;text-align:left;">模板名称</th>
    				<th class="v1"	align="center" valign="middle">描述</th>
    				<th class="v8"  align="center" valign="middle">预览</th>
  				</tr>
</thead>
 <tbody> 

<%
String special_id="";
String special_name="";
String special_template = CmsCache.getParameterValue("sys_special_template_json");
JSONArray o1;
int count=0;
int max=9;
int count_page=0;
try {
o1 = new JSONArray(special_template);
count = o1.length();
if(count%max==0){
	count_page = count/max;
}else{
	count_page = (count/max)+1;
}
%>
<script>
function gopage(pagenum){
	
	/*if(parseInt(count/max)+1==pagenum){
		pages();
	}*/
	window.location="<%=request.getContextPath()%>/special/channel_special_add.jsp?pagenum="+pagenum+"&ChannelID="+$("#ChannelID").val();	
	
}
</script>
<%
if(pagenum==0){
	pagenum=1;
}
int count_1=max*pagenum;
if(count_1>count-1)
{
	count_1=count;
}

for(int i =max*(pagenum-1);i<=count_1-1;i++)
{
	
	JSONObject oo = o1.getJSONObject(i);
	special_id = oo.getString("id");
	special_name = oo.getString("name");
	
	%>
	 <tr class="tide_item" id="num_<%=i%>" style="" onClick="select(this)">
		<td class="v1" width="25" align="center" valign="middle"><input class="radio" type="radio" name="SpecialTemplate" value="<%=special_id%>"></td>
		<td class="v3" style="font-weight:700;"><%=special_name%></td>
		<td class="v1" align="center" valign="middle"><%=special_name%></td>
		<td class="v9">
		<div class="v9_button" onClick="Preview(<%=special_id%>);"><img src="../images/v9_button_2.gif" title="预览" /></div>
		</td>
	  </tr>
<%}
	
}catch (JSONException e1) {
ErrorLog.Log("专题", "配置json读取错误", "");
} 
%>
</tbody> 
</table>
</div>
<%
if(count_page>0){%> 
	
			<div class="viewpane_pages">
				<div class="left" style="left:8px;">共<%=count%>条 <%=pagenum%>/<%=count_page%>页 
				</div>
				<%if(count_page>1){%> 	
				<div class="center"><a href="javascript:gopage(1);" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(pagenum>1){%><a href="javascript:gopage(<%=pagenum-1%>);" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(pagenum<count_page){%><a href="javascript:gopage(<%=pagenum+1%>);" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="javascript:gopage(<%=count_page%>);" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}
	}
%>
</div>
</div>



    </div>
    <div class="content" id="step2" style="display:none;">
<div style="border:none;" class="form_main">
<table  width="90%" border="0">
	<tr><td></td><td><span id="tishi"></span></td></tr>
    <tr>
    <td align="right" valign="middle">专题名称：</td>
    <td valign="middle"><input type="text" name="NewChannelName" id="NewChannelName" style="width:200px" class="textfield"/></td>
  </tr>

  <tr>
    <td align="right" valign="middle">专题路径：</td>
    <td valign="middle"><input type="text" name="NewFolder" id="NewFolder" style="width:200px" class="textfield"/></td>
  </tr>

  <tr>
    <td align="right" valign="middle">关键词：</td>
    <td valign="middle"><input type="text" name="keyword" id="keyword" style="width:200px" class="textfield"/></td>
  </tr>

  <tr>
    <td align="right" valign="middle">描述：</td>
    <td valign="middle"><textarea type="text" name="description" id="description" style="width:400px;height:125px" class="textfield"/></textarea></td>
  </tr>

</table>
</div>
</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
<input name="startButton" type="button" class="tidecms_btn2" value=" 下一步 " id="stepButton2" onClick="showStep(2)"/>
<input name="startButton" type="button" class="tidecms_btn2" value=" 确定 " id="submitButton" onClick="showStep(3)" style="display:none" />
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn2" value="  取  消  " onClick="top.TideDialogClose();">
	  
<input type="hidden" name="Parent" value="<%=ChannelID%>">
<input type="hidden" name="ChannelID" id="ChannelID" value="<%=ChannelID%>">
</div>

</form>
<script>
//	var infos='<%=info%>';

	function pages(){
		var infos='<%=info%>';
		$("#stepButton2").before(infos);
	}

	$(function(){
pages();	
})
</script>
</body>
</html>
