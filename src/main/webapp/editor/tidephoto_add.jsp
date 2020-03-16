<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.util.StringUtils,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	int		ChannelID		= getIntParameter(request,"ChannelID");
	int		ItemID			= 0;
	
	try{ItemID=getIntParameter(request,"ItemID");}catch(Exception e){}

	ChannelID =15;

	Document item = null;
	Channel channel = CmsCache.getChannel("photo");

	ChannelID = channel.getId();

	int ContinueNewDocument	= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow		= getIntParameter(request,"NoCloseWindow");

	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}


	if(ItemID>0)
		item = new Document(ItemID,ChannelID);
	
	ArrayList fieldGroupArray = channel.getFieldGroupInfo();
	String SiteAddress = channel.getSite().getUrl();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=item!=null?item.getTitle():"新建文档"%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<STYLE>
.tab	{	border-top:1px solid buttonshadow;
			border-right:1px solid buttonshadow;
			border-left:1px solid buttonhighlight;
			border-bottom:1px solid buttonshadow;
			font-family:宋体;
			font-size:9pt;
			text-align:center;
			font-weight:normal}

.selTab	{	border-left:1px solid buttonhighhight;
			border-top:none;
			border-right:1px solid black;
			border-bottom:1px solid buttonshadow;
			text-align:center;
			font-family:宋体;
			font-size:9pt;}
</STYLE>
<script type="text/javascript" src="../common/document.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../editor/fckeditor.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script>
<!--
var Pages=1;
var curPage = 1;
var Contents = new Array();
Contents[Contents.length] = "";

function Save_Content()
{
	//保存正文,内容
	//document.ContentEditor.preparesubmit();
	var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
	var FCK			= editor.getFCK() ;
	var FCKConfig	= editor.getFCKConfig();
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++){//alert(rows[i].className);
		if (rows[i].className=="selTab"){
			rows[i].className = "tab";
			Contents[rows[i].page-1] = FCK.GetXHTML( FCKConfig.FormatSource );
			}
		}
	var localhost = document.location.protocol+ "//" + document.location.hostname;
	if (document.location.port!="80")
  		localhost = localhost + ":" + document.location.port;
<%if(!SiteAddress.equals("")){%>localhost = "<%=SiteAddress%>";<%}%>
	var reg = new RegExp(localhost,"g");
	if(Pages<=1)
	{
		var str = Contents[0];
		str = str.replace(reg, ""); //alert(str);

		document.form.Content.value = str;
		document.form.Page.value = "1";
	}
	else
	{
		for(var i=1;i<=Pages;i++)
		{
			var str = Contents[i-1];//document.all.ContentEditor.GetContent(i);
			//alert(i+":"+str);
			str = str.replace(reg, "");

			if(i==1)
				document.form.Content.value = str;
			else
			{
				var oInput = document.createElement("input");//document.createElement("<input type='hidden' name='Content"+i+"' value=''>");
				oInput.setAttribute("type","hidden");
				oInput.setAttribute("name","Content"+i);
				oInput.setAttribute("value",str);
				document.form.appendChild(oInput);
				//oInput.value = str;
			}
		}
		
		document.form.Page.value = Pages + "";
	}
}

function Save()
{
	if(check())
	{
	//有内容拦的情况下，保存前先处理内容栏
	if(document.getElementById("tabTableRow"))
		Save_Content();

	Image1Href.href = "javascript:void(0);";
<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
	Image2Href.href = "javascript:void(0);";
<%}%>
	//alert("ok");
	document.form.submit();

	return;
	}
}

function init()
{		
	<%if(item!=null){%>
document.form.Action.value = "Update";
	<%}%>
	document.body.disabled  = false;
}

function initContent1()
{
	<%if(item!=null){%>
	if(document.getElementById("tabTableRow"))
		try{
		{<%//System.out.println(item.getContent());%>
			var content = '<%=Util.JSQuote(item.getContent())%>';
			<%if(!SiteAddress.equals("")){%>content = content.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;<%}%>
			SetContent(1,content);

			<%if(item.getTotalPage()>1){for(int i=2;i<=item.getTotalPage();i++){item.setCurrentPage(i);%>
				AddPageInit();//alert(content);
				content = '<%=Util.JSQuote(item.getContent())%>';//alert(content);
			<%if(!SiteAddress.equals("")){%>content = content.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;<%}%>
				SetContent(<%=i%>,content);
			<%}}%>
		}
		}catch(er){	window.setTimeout("initContent1()",5);}
		document.form.Action.value = "Update";//alert(Contents["t2"]);
	<%}%>
}

function initContent()
{
	window.setTimeout("initContent1()",1);
}

function selectFile(fieldname)
{
	var	dialog = new TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(250);
	dialog.setLayer(2);
	dialog.setUrl("../content/insertfile.jsp?ChannelID=<%=ChannelID%>&Type=Image&fieldname="+fieldname);
	dialog.setTitle("上传图片");
	dialog.show();
}

function previewFile(fieldname)
{
	var name = document.all(fieldname).value;

	if(name=="") return;

	if(name.indexOf("http://")!=-1)  window.open(name);
	else	window.open("<%=SiteAddress%>/" + name);
}

function showTab(form)
{
	if(document.body.disabled) return;

	var num = <%=fieldGroupArray.size()%>;
	for(i=1;i<=num;i++)
	{
		var divobj = document.getElementById("form"+i);
		if(divobj)	divobj.style.display = "none";
		eval("form"+i+"_td").bgColor="";
	}

	eval(form+"_td").bgColor="#F2F3F5";
	eval(form).style.display = "";
}


 function set_checkbox(name,value){
        jQuery("input[@type=checkbox]").each(
        function(i){
          if(jQuery(this).attr("name")==name){
          if(jQuery(this).attr("value")==value){
            jQuery(this).attr("checked","checked")
          }
         }
      });
     }
     
 function set_radio(name,value){
        jQuery("input[@type=radio]").each(
        function(i){
          if(jQuery(this).attr("name")==name){
          if(jQuery(this).attr("value")==value){
            jQuery(this).attr("checked","checked")
          }
         }
      });
     }     
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init();">
<script type="text/javascript">document.body.disabled  = true;</script>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<form name="form" action="tidephoto_submit.jsp" method="post">
  <tr height="50"> 
    <td  align="center" class="box-gray"><div align="left"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="10">&nbsp;</td>
            <td width="65"><a id="Image1Href" href="javascript:Save_Publish();" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image1','','../images/icon_save_s.gif',1)"><img src="../images/icon_save_n.gif" width="32" height="32" border="0" align="absmiddle" id="Image1"> 
              保存</a></td>
            <td width="10">&nbsp;</td>
            <%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
			<td width="100">
			<a id="Image2Href" href="javascript:Save_Publish();" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image2','','../images/icon_publish_s.gif',1)">
			<img src="../images/icon_publish_n.gif" width="0" height="0" align="absmiddle" id="Image2" border="0"></a>
			</td>
			<%}%>
            <td></td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </div></td>
  </tr>
<%if(fieldGroupArray.size()>0){%>
  <tr>
  <td height="30" valign="bottom" bgcolor="#BABBC2"><table width="99%" height="25" border="0" align="center" cellpadding="1" cellspacing="0">
    <tr>
<%for (int i = 0; i < fieldGroupArray.size(); i++) 
{
	FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
%>
<td width="80" align="center" id="form<%=i+1%>_td" groupid="<%=fieldGroup.getId()%>" <%=(i==0?"bgColor='#F2F3F5'":"")%> ><a href="javascript:showTab('form<%=i+1%>')"><%=fieldGroup.getName()%></a></td>
<%}%>
      <td align="center">&nbsp;</td>
    </tr>
  </table></td>
  </tr>
<%}%>
  <tr> 
    <td valign="top" class="box-tint"><br> 
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="6">
<%
if(fieldGroupArray.size()>0)
{
for (int j = 0; j < fieldGroupArray.size(); j++) 
{
	FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(j);
%>
<tbody id="form<%=j+1%>" <%=(j!=0?"style=\"display:none;\"":"")%>>
<%if(j==0){%>
<tr>
	<td width="70" align="right"><%=channel.getFieldByFieldName("Title").getDescription()%>：</td>
	<td>
	<input type="text" class="textfield" size="100" name="Title" value="<%=item!=null?StringUtils.HTMLEncode(item.getValue("Title")):"test"%>">
	</td>
</tr>
<tr>
	<td width="70" align="right"></td>
	<td>
	<%=channel.getFieldByFieldName("DocFrom").getDescription()%>：<input type="text" class="textfield" size="20" name="DocFrom" value="<%=item!=null?StringUtils.HTMLEncode(item.getValue("DocFrom")):""%>">
	<%=channel.getFieldByFieldName("PublishDate").getDescription()%>：<input type="text" class="textfield" size="21" name="PublishDate" value="<%=item!=null?item.getPublishDate():Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")%>"><img align="absmiddle" src="../images/calendar.gif" onclick="selectdate('PublishDate');">
	图片新闻：<input type="checkbox" name="IsPhotoNews" value="1" <%=item!=null&&item.getIsPhotoNews()==1?"checked":""%>>
	</td>
</tr>
<%
}
ArrayList arraylist = channel.getFieldsByGroup(fieldGroup.getId(),j);
//System.out.println(j+":"+arraylist.size());
int jj = 0;
for (int i = 0; i < arraylist.size(); i++) 
{
	Field field = (Field)arraylist.get(i);
	if(channel.isShowField(field.getName()) && !field.getName().equals("PublishDate") && !field.getName().equals("IsPhotoNews"))
	{
		String FieldType = field.getFieldType();
		int IsHide = field.getIsHide();
		String FieldName = field.getName();
		String Description = field.getDescription();

		if(FieldType.equalsIgnoreCase("textarea")&&IsHide==0)
		{
			if(FieldName.equalsIgnoreCase("Content"))
			{
%>
<tr>
<td width="70" align="right" valign="top"><%=Description%>：</td>
	<td>

		<script type="text/javascript">
<!--
// Automatically calculates the editor base path based on the _samples directory.
// This is usefull only for these samples. A real application should use something like this:
// oFCKeditor.BasePath = '/fckeditor/' ;	// '/fckeditor/' is the default value.
//var sBasePath = document.location.pathname.substring(0,document.location.pathname.lastIndexOf('_samples')) ;

var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath	= '../editor/' ;
oFCKeditor.Height	= 300 ;
//oFCKeditor.Config['FullPage'] = true ;
oFCKeditor.Value	= '' ;
oFCKeditor.Create() ;
var ChannelID=<%=ChannelID%>;
//-->
		</script>
<table id="tabTable" STYLE="width:100%;height:20px;" CELLPADDING=0 CELLSPACING=0>
	<tr id="tabTableRow" onclick="changeTabs()">
		<td id="t1" class="selTab" page="1" height="20">第1页</td>
	</tr>
</table>
	</td>
</tr>
<tr>
	<td width="70" align="right" valign="top">&nbsp;</td>
	<td align="left">
	<input type="button" value="删除当前页" onclick="DeletePage();" class="textfield">
	<input type="button" value="插入一页" onclick="AddPage();" class="textfield">&nbsp;&nbsp;&nbsp;
	</td>
</tr>
<%
			}
			else
			{
%>
<tr >
	<td width="70" align="right" valign="top"><%=Description%>：</td>
	<td>
	<textarea cols="100" class="textfield" rows=5 name="<%=FieldName%>"><%=item!=null?item.getValue(FieldName):""%></textarea>
	</td>
</tr>
<%
			}
		}
		else if(FieldType.equalsIgnoreCase("datetime")&&IsHide==0)
		{
%>
<tr>
	<td width="70" align="right" valign="top"><%=Description%>：</td>
	<td><input type="text" name="<%=FieldName%>" id="<%=FieldName%>" value="<%=item!=null?item.getValue(FieldName):""%>" class="textfield" size="100">
	<img src="../images/calendar.gif" onclick="selectdate('<%=FieldName%>');"></td>
</tr>
<%
		}
		else if((FieldType.equalsIgnoreCase("file")&&IsHide==0) || (FieldType.equalsIgnoreCase("image")&&IsHide==0))
		{
%>
<tr>
	<td width="70" align="right" valign="top"><%=Description%>：</td>
	<td>
	<input type="text" name="<%=FieldName%>" id="<%=FieldName%>"  value="<%=item!=null?item.getValue(FieldName):""%>" class="textfield" size="80">
	<input type="button" value="选择" onClick="selectFile('<%=FieldName%>')" class="tidecms_btn3"> <input type="button" value="预览" onClick="previewFile('<%=FieldName%>')" class="tidecms_btn3">
	</td>
</tr>
<%
		}
		else if(FieldType.equalsIgnoreCase("select")&&IsHide==0)
		{
			ArrayList fieldoptions = new ArrayList();
			if(field!=null)
				fieldoptions = field.getFieldOptions();
%>
<tr >
	<td width="70" align="right" valign="top"><%=Description%>：</td>
	<td>
	<select name="<%=FieldName%>">
<%for(int k=0;k<fieldoptions.size();k++){%>
<option value="<%=(String)fieldoptions.get(k)%>"><%=(String)fieldoptions.get(k)%></option>
<%}%>
	</select>
<%if(item!=null){%>
<script>
document.all.<%=FieldName%>.value = "<%=item.getValue(FieldName)%>";
</script>
<%}%>
	</td>
</tr>
<%
		}else if(FieldType.equalsIgnoreCase("checkbox")&&IsHide==0){
		 ArrayList fieldoptions = new ArrayList();
			if(field!=null)
				fieldoptions = field.getFieldOptions();
%>
<tr>
  <td width="70" align="right" valign="top"><%=Description%>：</td>
  <td>
  <%for(int k=0;k<fieldoptions.size();k++){%>
<input type="checkbox" value="<%=(String)fieldoptions.get(k)%>" name="<%=FieldName%>"><%=(String)fieldoptions.get(k)%>
<%}%>
  </td>
</tr>
<%if(item!=null){
  String []checkboxArray=Util.StringToArray(item.getValue(FieldName),",");
    out.print("<script>");
  for(int count=0;count<checkboxArray.length;count++){
%>

set_checkbox("<%=FieldName%>","<%=checkboxArray[count]%>");

<%}
  out.print("</script>");
}%>

<%		
		}else if(FieldType.equalsIgnoreCase("radio")&&IsHide==0){
		  ArrayList fieldoptions = new ArrayList();
			if(field!=null)
				fieldoptions = field.getFieldOptions();				
%>
<tr>
  <td width="70" align="right" valign="top"><%=Description%>：</td>
  <td>
  <%for(int k=0;k<fieldoptions.size();k++){%>
<input type="radio" value="<%=(String)fieldoptions.get(k)%>" name="<%=FieldName%>"  id="<%=FieldName%>" ><%=(String)fieldoptions.get(k)%>
<%}%>
  </td>
</tr>
<%if(item!=null){%>
<script>
set_radio("<%=FieldName%>","<%=item.getValue(FieldName)%>");
</script>
<%}%>
<%			
		}
		else if(FieldType.equalsIgnoreCase("label")&&IsHide==0)
		{
%>
<tr >
	<td width="70" align="right" valign="top"></td>
	<td><%=Description%>：</td>
</tr>
<%
		}
		else if(FieldType.equalsIgnoreCase("text")&&IsHide==0)
		{
%>
<tr>
<td width="70" align="right"><%=Description%></td>
<td><input type="text" class="textfield" size="80" name="<%=FieldName%>" value="<%=item!=null?item.getValue(FieldName):""%>"> <%if(FieldName.toLowerCase().indexOf("href")!=-1){%><input type="button" value="预览" onClick="previewFile('<%=FieldName%>')" class="tidecms_btn3"><%}%>
</td>
</tr>
<%
		}
	}
}%>
</tbody>
<%}
}else{
//在没有分组的情况下
%>
<tr>
	<td width="70" align="right"><%=channel.getFieldByFieldName("Title").getDescription()%>：</td>
	<td>
	<input type="text" class="textfield" size="100" name="Title" value="<%=item!=null?StringUtils.HTMLEncode(item.getValue("Title")):"test"%>">
	</td>
</tr>
<tr>
	<td width="70" align="right"></td>
	<td>
	<%=channel.getFieldByFieldName("DocFrom").getDescription()%>：<input type="text" class="textfield" size="20" name="DocFrom" value="<%=item!=null?StringUtils.HTMLEncode(item.getValue("DocFrom")):""%>">
	<%=channel.getFieldByFieldName("PublishDate").getDescription()%>：<input type="text" class="textfield" size="21" name="PublishDate" value="<%=item!=null?item.getValue("PublishDate"):Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")%>"><img align="absmiddle" src="../images/calendar.gif" onclick="selectdate('PublishDate');">
	图片新闻：<input type="checkbox" name="IsPhotoNews" value="1" <%=item!=null&&item.getIsPhotoNews()==1?"checked":""%>>
	</td>
</tr>
<%
ArrayList arraylist = channel.getFieldInfo();
//System.out.println(j+":"+arraylist.size());
int jj = 0;
for (int i = 0; i < arraylist.size(); i++) 
{
	Field field = (Field)arraylist.get(i);
	if(channel.isShowField(field.getName()) && !field.getName().equals("PublishDate"))
	{
		String FieldType = field.getFieldType();
		int IsHide = field.getIsHide();
		String FieldName = field.getName();
		String Description = field.getDescription();

		if(FieldType.equalsIgnoreCase("textarea")&&IsHide==0)
		{
			if(FieldName.equalsIgnoreCase("Content"))
			{
%>
<tr>
<td width="70" align="right" valign="top"><%=Description%>：</td>
	<td>
		<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath	= '../editor/' ;
oFCKeditor.Height	= 300 ;
//oFCKeditor.Config['FullPage'] = true ;
oFCKeditor.Value	= '' ;
var ChannelID=<%=ChannelID%>;
oFCKeditor.Create() ;
//-->
		</script>
<table id="tabTable" STYLE="width:100%;height:20px;" CELLPADDING=0 CELLSPACING=0>
	<tr id="tabTableRow" onclick="changeTabs()">
		<td id="t1" class="selTab" page="1" height="20">第1页</td>
	</tr>
</table>
	</td>
</tr>
<tr>
	<td width="70" align="right" valign="top">&nbsp;</td>
	<td align="left">
	<input type="button" value="删除当前页" onclick="DeletePage();" class="textfield">
	<input type="button" value="插入一页" onclick="AddPage();" class="textfield">&nbsp;&nbsp;&nbsp;
	</td>
</tr>
<%
			}
			else
			{
%>
<tr >
	<td width="70" align="right" valign="top"><%=Description%>：</td>
	<td>
	<textarea cols="100" class="textfield" rows=5 name="<%=FieldName%>"><%=item!=null?item.getValue(FieldName):""%></textarea>
	</td>
</tr>
<%
			}
		}
		else if(FieldType.equalsIgnoreCase("datetime")&&IsHide==0)
		{
%>
<tr>
	<td width="70" align="right" valign="top"><%=Description%></td>
	<td><input type="text" name="<%=FieldName%>" value="<%=item!=null?item.getValue(FieldName):""%>" class="textfield" size="100">
	<img src="../images/calendar.gif" onclick="selectdate('<%=FieldName%>');"></td>
</tr>
<%
		}
		else if((FieldType.equalsIgnoreCase("file")&&IsHide==0) || (FieldType.equalsIgnoreCase("image")&&IsHide==0))
		{
%>
<tr>
	<td width="70" align="right" valign="top"><%=Description%>：</td>
	<td>
	<input type="text" name="<%=FieldName%>" value="<%=item!=null?item.getValue(FieldName):""%>" class="textfield" size="80">
	<input type="button" value="选择" onClick="selectFile('<%=FieldName%>')" class="tidecms_btn3"> <input type="button" value="预览" onClick="previewFile('<%=FieldName%>')" class="tidecms_btn3">
	</td>
</tr>
<%
		}
		else if(FieldType.equalsIgnoreCase("select")&&IsHide==0)
		{
			ArrayList fieldoptions = new ArrayList();
			if(field!=null)
				fieldoptions = field.getFieldOptions();
%>
<tr >
	<td width="70" align="right" valign="top"><%=Description%>：</td>
	<td>
	<select name="<%=FieldName%>">
<%for(int k=0;k<fieldoptions.size();k++){%>
<option value="<%=(String)fieldoptions.get(k)%>"><%=(String)fieldoptions.get(k)%></option>
<%}%>
	</select>
<%if(item!=null){%>
<script>
document.all.<%=FieldName%>.value = "<%=item.getValue(FieldName)%>";
</script>
<%}%>
	</td>
</tr>
<%
		}
		else if(FieldType.equalsIgnoreCase("checkbox")&&IsHide==0){
				 ArrayList fieldoptions = new ArrayList();
			if(field!=null)
				fieldoptions = field.getFieldOptions();
%>
<tr>
  <td width="70" align="right" valign="top"><%=Description%>：</td>
  <td>
  <%for(int k=0;k<fieldoptions.size();k++){%>
<input type="checkbox" value="<%=(String)fieldoptions.get(k)%>" name="<%=FieldName%>"><%=(String)fieldoptions.get(k)%>
<%}%>
  </td>
</tr>
<%if(item!=null){
  String []checkboxArray=Util.StringToArray(item.getValue(FieldName),",");
  out.print("<script>");
  for(int count=0;count<checkboxArray.length;count++){
%>

set_checkbox("<%=FieldName%>","<%=checkboxArray[count]%>");

<%}
  out.print("</script>");
}%>
<%	
		}else if(FieldType.equalsIgnoreCase("radio")&&IsHide==0){
		  ArrayList fieldoptions = new ArrayList();
			if(field!=null)
				fieldoptions = field.getFieldOptions();				
%>
<tr>
  <td width="70" align="right" valign="top"><%=Description%>：</td>
  <td>
  <%for(int k=0;k<fieldoptions.size();k++){%>
<input type="radio" value="<%=(String)fieldoptions.get(k)%>" name="<%=FieldName%>"  id="<%=FieldName%>" ><%=(String)fieldoptions.get(k)%>
<%}%>
  </td>
</tr>
<%if(item!=null){%>
<script>
set_radio("<%=FieldName%>","<%=item.getValue(FieldName)%>");
</script>
<%}%>
<%			
		}
		else if(FieldType.equalsIgnoreCase("label")&&IsHide==0)
		{
%>
<tr >
	<td width="70" align="right" valign="top"></td>
	<td><%=Description%>：</td>
</tr>
<%
		}
		else if(FieldType.equalsIgnoreCase("text")&&IsHide==0)
		{
%>
<tr>
<td width="70" align="right"><%=Description%>：</td>
<td><input type="text" class="textfield" size="80" name="<%=FieldName%>" id="<%=FieldName%>" value="<%=item!=null?item.getValue(FieldName):""%>"> <%if(FieldName.toLowerCase().indexOf("href")!=-1){%><input type="button" value="预览" onClick="previewFile('<%=FieldName%>')" class="tidecms_btn3"><%}%>
</td>
</tr>
<%
		}
	}
}%>
<%}%>
<tr >
<td width="70" align="right" valign="top"></td>
<td>
<input type="hidden" name="Action" value="Add">
<input type="hidden" name="Content" value="">
<input type="hidden" name="ItemID" value="<%=ItemID%>">
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
<input type="hidden" name="Status" value="0">
<input type="hidden" name="Page" value="1">
</td>
</tr>
</form>
      </table></td>
  </tr>
</table>
</body>
</html>
