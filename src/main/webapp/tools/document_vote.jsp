<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.user.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
	int		ChannelID				= getIntParameter(request,"ChannelID");
	int		ItemID					= getIntParameter(request,"ItemID");
	int		RecommendItemID			= getIntParameter(request,"RecommendItemID");
	int		RecommendChannelID		= getIntParameter(request,"RecommendChannelID");
	String	RecommendTarget			= getParameter(request,"RecommendTarget");
	int		RecommendOutItemID		= getIntParameter(request,"ROutItemID");
	int		RecommendOutChannelID	= getIntParameter(request,"ROutChannelID");
	String	ROutTarget				= getParameter(request,"ROutTarget");
	int		parentGlobalID			= getIntParameter(request,"pid");

	int ContinueNewDocument			= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow				= getIntParameter(request,"NoCloseWindow");
	String From						= getParameter(request,"From");
    int Global_id			        = getIntParameter(request,"Global_id");
	int GlobalID					= 0;
int IsDialog					= getIntParameter(request,"IsDialog");//如果是弹出窗口，值设为1
	 
	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}


	Document item = null;
	Channel channel = CmsCache.getChannel(ChannelID);

	if(channel.getDocumentProgram().length()>0)
		response.sendRedirect(channel.getDocumentProgram()+"?ChannelID="+ChannelID+"&ItemID="+ItemID);

	if(channel.isVideoChannel())
	{
		response.sendRedirect("../video/document.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID);return;
	}

	if(ItemID>0)
	{
		//item = new Document(ItemID,ChannelID);
		item = CmsCache.getDocument(ItemID,ChannelID);

		//解决同步问题，2012.09.19
		if(item.getChannel().getId()!=ChannelID)
		{
			ChannelID = item.getChannel().getId();
			item = CmsCache.getDocument(ItemID,ChannelID);
		}
	}
	
	if(item!=null)
		GlobalID = item.getGlobalID();
	
	ArrayList fieldGroupArray = channel.getFieldGroupInfo();
	String SiteAddress = channel.getSite().getUrl();

	String check2 = "";

	boolean editCategory = false;

	if(channel.isTableChannel() && channel.getType2()==8) editCategory = true;

	String userGroup = "";

	try{
		userGroup = new UserGroup(userinfo_session.getGroup()).getName();
	}
	catch(Exception e){}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="robots" content="noindex, nofollow">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=item!=null?"编辑文档 " + item.getTitle():"新建文档"%> <%=channel.getParentChannelPath()%> TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script>
var Pages=1;
var curPage = 1;
var Contents = new Array();
Contents[Contents.length] = "";
var userId = <%=userinfo_session.getId()%>;
var userName = "<%=userinfo_session.getName()%>";
var userGroupName = "<%=userGroup%>";
var userGroupId = <%=userinfo_session.getGroup()%>;
var channelid = <%=ChannelID%>;
var groupnum = <%=fieldGroupArray.size()%>;
</script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/document.js"></script>
<script type="text/javascript" src="../editor/fckeditor.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script>
<!--

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
			var rows_page = rows[i].getAttribute("page");
			Contents[rows_page-1] = FCK.GetXHTML( FCKConfig.FormatSource );
			//alert((rows_page-1) + ":" + Contents[rows_page-1]);
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

	document.getElementById("Image1Href").href = "javascript:void(0);";
<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
	document.getElementById("Image2Href").href = "javascript:void(0);";
<%}%>
	//alert("ok");
	//document.form.submit();

	//return;

$.ajax({
         type: "POST",
         url:"../content/document_submit.jsp",
         data:$('#form').serialize(),
		 dataType:'json',
         success: function(result) {
		    if(result.message==""){		
				<%if(IsDialog==0){%>
				window.opener.document.location.reload();
				window.close();
				<%}%>

				<%if(IsDialog==1){%>
				top.TideDialogClose({refresh:'right'});
				<%}%>				
			 }else{
				alert(result.message);
				document.getElementById("Image1Href").href = "javascript:Save();";
				<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
				document.getElementById("Image2Href").href = "javascript:Save_Publish();";
				<%}%>
			 } 
	
		 }
     });
	}
}

function init()
{	
	//$.datepicker.setDefaults();
	$(".date").datepicker({showOn: 'button',dateFormat:'yy-mm-dd',buttonImage: '../images/icon/26.png',buttonImageOnly: true,closeText: '关闭',
		prevText: '<上月',
		nextText: '下月>',
		currentText: '今天',
		monthNames: ['一月','二月','三月','四月','五月','六月',
		'七月','八月','九月','十月','十一月','十二月'],
		monthNamesShort: ['一','二','三','四','五','六',
		'七','八','九','十','十一','十二'],
		dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
		dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
		dayNamesMin: ['日','一','二','三','四','五','六'],
		weekHeader: '周',
		dateFormat: 'yy-mm-dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: true,
		yearSuffix: '年',setValue: function(o, s) {
		var i = o.val().indexOf(" ");var m = "";if(i!=-1)m=o.val().substring(i);
		o.val(s+m);
		}});
	<%if(item!=null){%>
	document.form.Action.value = "Update";
	<%}else if(RecommendItemID>0 && RecommendChannelID>0){%>
	recommendItemJS(<%=RecommendItemID%>,<%=RecommendChannelID%>,<%=ChannelID%>,"<%=RecommendTarget%>");
	<%}else if(RecommendOutItemID>0&&RecommendOutChannelID>0){%>
	recommendOutItemJS(<%=RecommendOutItemID%>,<%=RecommendOutChannelID%>,<%=ChannelID%>,"<%=ROutTarget%>");
	<%}%>

	checkTitle();
	document.body.disabled  = false;
}

function initContent1()
{
	<%if(item!=null){%>
	if(document.getElementById("tabTableRow"))
		try{
		{<%//System.out.println(item.getContent());%>
			<%if(item.getTotalPage()>1){for(int i=2;i<=item.getTotalPage();i++){item.setCurrentPage(i);%>
				AddPageInit();//alert(content);
				content = '<%=Util.JSQuote(item.getContent())%>';//alert(content);
			<%if(!SiteAddress.equals("")){%>content = content.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;<%}%>
				//SetContent(<%=i%>,content);
			var num = <%=i%>;
			if(num<=Contents.length)
				Contents[num-1] = content;
			else
				Contents[Contents.length] = content;			
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



var curField = 0;

function selectFile(fieldname)
{
	var	dialog = new TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(250);
	dialog.setLayer(2);
	dialog.setUrl("../content/insertfile.jsp?ChannelID=<%=ChannelID%>&fieldname="+fieldname);
	dialog.setTitle("上传文件");
	dialog.show();
}

function selectImage(fieldname)
{
	var	dialog = new TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(240);
	dialog.setLayer(2);
	dialog.setUrl("../content/insertfile.jsp?ChannelID=<%=ChannelID%>&Type=Image&fieldname="+fieldname);
	dialog.setTitle("上传图片");
	dialog.show();
}


function previewFile(fieldname)
{
	var name = document.getElementById(fieldname).value;

	if(name=="") return;

	if(name.indexOf("http://")!=-1)  window.open(name);
	else	window.open("<%=SiteAddress%>/" + name);
}

function selectByKeyword()
{
	var ByKeyword = document.getElementById("ByKeyword");
	var ByTitle = document.getElementById("ByTitle");
	document.getElementById("related_doc_list").src = "related_doc_list.jsp?GlobalID=<%=GlobalID%>&ChannelID=<%=ChannelID%>&ByKeyword="+ByKeyword.checked + "&ByTitle="+ByTitle.checked + "&keyword=" + encodeURIComponent(document.form.ByKeywordText.value);
}


//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="form" action="../content/document_submit.jsp" method="post" id="form">
<div class="header">
	<div class="logo"><a href="#" title="TideCMS"><img src="../images/logo.png" alt="TideCMS" /></a></div>
    <div class="edit-info">
        <ul class="button">
        	<li><a id="Image1Href" href="javascript:Save();">保存</a></li>
            <%if(cp.hasRight(userinfo_session,ChannelID,3)){%><li><a id="Image2Href" href="javascript:Save_Publish();">保存并发布</a></li><%}%>
            <!--<li><a href="#"><span>预览</span></a></li>-->
            <li><a href="javascript:self.close();">关闭</a></li>
        </ul>
    </div>
    <div class="clear"></div>
</div>
<div class="edit_main content_form">
	<div class="edit_nav">
    	<ul>
<%for (int i = 0; i < fieldGroupArray.size(); i++) 
{
	FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
%>
        	<li>
			<a href="javascript:showTab('<%=i+1%>')" <%=(i==0?"class='cur'":"")%> id="form<%=i+1%>_td" groupid="<%=fieldGroup.getId()%>">
			<span ><%=fieldGroup.getName()%></span></a></li>
<%}%>
        </ul>
        <div class="clear"></div>
    </div>

    <div class="edit_con">
    	
<%
int j = 0;
do
//for (int j = 0; j < fieldGroupArray.size(); j++) 
{
FieldGroup fieldGroup = null;
int fieldGroupID = 0;
if(fieldGroupArray.size()>0) 
{
	fieldGroup = (FieldGroup) fieldGroupArray.get(j);
	fieldGroupID = fieldGroup.getId();
}

String url = "";
if(fieldGroupArray.size()>0 && fieldGroup.getUrl().length()>0) 
{
	url = fieldGroup.getUrl();
	url = url.replace("$globalid",GlobalID+"");
	url = url.replace("$itemid",ItemID+"");
	url = url.replace("$channelid",ChannelID+"");
	boolean b = url.contains("?");
	String c = "";
	if(!url.contains("itemid="))
		c += "&itemid=" + ItemID;
	if(!url.contains("globalid="))
		c += "&globalid=" + GlobalID;
	c += "&channelid=" + ChannelID+"&fieldgroup="+(j+1);
	url += ((b)?"":"?") + c;
}
out.println("<div class=\"center\" url=\""+url+"\" id=\"form"+(j+1)+"\" "+(j!=0?"style=\"display:none;\"":"")+">");

if(fieldGroupID>0 && !fieldGroup.getUrl().equals(""))
	{
out.println("<iframe id=\"iframe"+(j+1)+"\" frameborder=\"0\" style=\"width:100%;height:500px\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"auto\" src=\"../null.jsp\"></iframe>");
	}
else
	{
%>
        
		<table width="100%">
<%if(j==0){%>
<tr><td><div class="line" id="tr_Title"><%=channel.getFieldByFieldName("Title").getDescription()%>：</div></td><td><div class="line" id="field_Title"><input type="text" class="textfield" size="80" id="Title" name="Title" value="<%=item!=null?Util.HTMLEncode(item.getValue("Title")):""%>" onkeyup="checkTitle();">	<span id="TitleCount"></span>    <%if(editCategory){%>分类：<select name="ChannelID" id="ChannelID">
<%ArrayList categorys = channel.listAllSubChannels(Channel.Category_Type);if(categorys!=null && categorys.size()>0){for(int i = 0;i<categorys.size();i++){Channel subcategory = (Channel)categorys.get(i);%>
                    <option value="<%=subcategory.getId()%>" <%=(item!=null&&subcategory.getId()==item.getCategoryID())?"selected":""%>><%=subcategory.getName()%></option>
<%}}%>
                  </select><%}%></div></td></tr>
<%}%>
<%

//FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(j);
ArrayList arraylist = channel.getFieldsByGroup(fieldGroupID,j);
//System.out.println(j+":"+arraylist.size());
int jj = 0;
for (int i = 0; i < arraylist.size(); i++) 
{
	Field field = (Field)arraylist.get(i);
	if(channel.isShowField(field.getName()) && field.getIsHide()==0)
	{
		if(field.getDisableBlank()==1)
		{
			check2 += "	if(isEmpty(document.form." + field.getName() + ",'请输入" + field.getDescription() + ".'))";
			check2 += "	return false;";
		}
%>
			<%if(field.getName().equalsIgnoreCase("Content")){%>
<tr><td colspan="2">
<div class="edit">
<input type="hidden" id="FCKeditor1" name="FCKeditor1" value="" style="display:none" />
					<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath	= '../editor/' ;
oFCKeditor.Height	= 600 ;
//oFCKeditor.Config['FullPage'] = true ;
<%if(item!=null){item.setCurrentPage(1);%>var currcontent = '<%=Util.JSQuote(item.getContent())%>';//Oracle not need JsQuote;
<%if(!SiteAddress.equals("")){%>currcontent = currcontent.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;<%}%>
//oFCKeditor.Value	= currcontent ;
$("#FCKeditor1").val(currcontent);
<%}%>
var ChannelID=<%=ChannelID%>;
//oFCKeditor.Create() ;
//-->
		</script>
<input type="hidden" id="FCKeditor1___Config" value="" style="display:none" /><iframe id="FCKeditor1___Frame" src="../editor/fckeditor.html?InstanceName=FCKeditor1&Toolbar=Default" width="100%" height="600" frameborder="0" scrolling="no"></iframe>
<table id="tabTable" STYLE="width:100%;height:20px;" CELLPADDING=0 CELLSPACING=0>
	<tr id="tabTableRow" onclick="changeTabs()">
		<td id="t1" class="selTab" page="1" height="20">第1页</td>
	</tr>
</table>
	<input type="button" value="删除当前页" onclick="DeletePage();" class="tidecms_btn3">
	<input type="button" value="插入一页" onclick="AddPage();" class="tidecms_btn3">   
</div>
</td></tr>
<%}else if(field.getFieldType().equals("label")){%>
	<tr><td><div class="line"><%if(!field.getFieldType().equals("label")){%><%=field.getDescription()%>：<%}%></div></td><td><div class="line"><%=field.getOther()%></div></td></tr>
	<%}else{%>
	<%if(field.getName().equals("PublishDate")){%>
	<tr><td><div class="line"><%=field.getDescription()%>：</div></td><td><div class="line"><%=field.getDisplayHtml_(item!=null?item.getPublishDate():Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"))%>  <%=channel.getFieldByFieldName("Weight").getDisplayHtml_(item!=null?item.getWeight()+"":"")%></div></td></tr>
	<%}else if(field.getName().equals("Keyword2")){%>
	<tr><td><div class="line"><%=field.getDescription()%>：</div></td><td><div class="line"><%=field.getDisplayHtml_(item!=null?item.getValue(field.getName()):"")%><input name="kewwordselect" type="button" class="submit" value="按关键词选择" onclick="selectByKeyword2()"></div></td></tr>
	<tr><td>相关视频：</td><td><iframe id="related_video_list" frameborder="0" height="400" width="650" marginheight="0" marginwidth="0" scrolling="auto" src="../video/related_video_list.jsp?id=<%=ItemID%>&ChannelID=<%=ChannelID%>"></iframe></td></tr>
	<%}else{
		out.println(field.getDisplayHtml2018(item));
	}%>
	<%}%>
<%}}%></table>
<%}out.println("</div>");j++;}while(j < fieldGroupArray.size());%>
    </div>
</div>
<input type="hidden" name="From" value="<%=From%>">
<input type="hidden" name="Action" value="Add">
<input type="hidden" name="Content" value="">
<input type="hidden" id="ItemID" name="ItemID" value="<%=ItemID%>">
<%if(!editCategory){%><input type="hidden" name="ChannelID" value="<%=ChannelID%>"><%}%>
<input type="hidden" name="Status" value="0">
<input type="hidden" id="GlobalID" name="GlobalID" value="<%=GlobalID%>">
<input type="hidden" name="ParentGlobalID" value="<%=parentGlobalID%>">
<input type="hidden" name="RelatedItemsList" value="">
<input type="hidden" name="Page" value="1">
<input type="hidden" id="RecommendGlobalID" name="RecommendGlobalID" value="0">
<input type="hidden" name="RecommendChannelID" value="0">
<input type="hidden" name="RecommendItemID" value="0">
<input type="hidden" name="ContinueNewDocument" value="<%=ContinueNewDocument%>">
<input type="hidden" id="RecommendType" name="RecommendType" value="0"><div id="ajax_script" style="display:none;"></div>
</form>
<script>
	 $('#Parent').val(<%=Global_id%>);		
</script>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<%if(channel.getDocumentJS().length()>0){out.println("<script>");out.println(channel.getDocumentJS());out.println("</script>");}%>
</body>
</html>
