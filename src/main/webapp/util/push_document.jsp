<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.util.TideJson,
				tidemedia.cms.user.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	/**
	* 用途：文档内容页
	* 1,李永海 20140101 创建
	* 2,王海龙 20150408 修改 save_content方法，编辑互斥方法移到document.js
	* 3,王海龙 20150408 修改	 定制内容页无需再删除重定向代码
	* 4,王海龙 20150707 修改 定制列表页重定向时带上推荐参数
	* 5,王海龙 20150919 修改 图片字段预览改为内网地址，数据库保存为外网地址
	*/
	String uri = request.getRequestURI();
	long begin_time = System.currentTimeMillis();
	int		ChannelID				= getIntParameter(request,"ChannelID");
	int		ItemID					= getIntParameter(request,"ItemID");
	int		RecommendItemID			= getIntParameter(request,"RecommendItemID");
	int		RecommendChannelID		= getIntParameter(request,"RecommendChannelID");
	String	RecommendTarget			= getParameter(request,"RecommendTarget");
	int		RecommendOutItemID		= getIntParameter(request,"ROutItemID");
	int		RecommendOutChannelID	= getIntParameter(request,"ROutChannelID");
	/*云资源采用*/
	int		CloudItemID				= getIntParameter(request,"CloudItemID");
	int		CloudChannelID			= getIntParameter(request,"CloudChannelID");
	String	ROutTarget				= getParameter(request,"ROutTarget");
	int		parentGlobalID			= getIntParameter(request,"pid");

	int ContinueNewDocument			= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow				= getIntParameter(request,"NoCloseWindow");
	String From						= getParameter(request,"From");
	int IsDialog					= getIntParameter(request,"IsDialog");//如果是弹出窗口，值设为1
	int Parent						= getIntParameter(request,"Parent");//如果设置了Parent,就设置Parent字段的值

	String transfer_article			= getParameter(request,"transfer_article");//一键转载url
	 
	int GlobalID					= 0;
	String QRcode					= "";
	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}


	Document item = null;
	Channel channel = CmsCache.getChannel(ChannelID);
//var url="../content/document.jsp?ItemID=0&ChannelID=" + channelid+ "&ROutTarget=&ROutChannelID="+14257+"&ROutItemID="+itemid;
	if(channel.getDocumentProgram().length()>0 && uri.endsWith("/content/document.jsp") )
		response.sendRedirect(channel.getDocumentProgram()+"?ChannelID="+ChannelID+"&ItemID="+ItemID+"&ROutTarget="+ROutTarget+"&ROutChannelID="+RecommendOutChannelID+"&ROutItemID="+RecommendOutItemID);
		// response.sendRedirect(channel.getDocumentProgram()+"?ChannelID="+ChannelID+"&ItemID="+ItemID);

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
			//out.println(item.getChannel().getId()+","+ChannelID);
			ChannelID = item.getChannel().getId();
			item = CmsCache.getDocument(ItemID,ChannelID);
			channel = CmsCache.getChannel(ChannelID);
		}
	}
	
	if(item!=null)
	{
		GlobalID = item.getGlobalID();
		QRcode = item.getQRCode();
	}
	ArrayList fieldGroupArray = channel.getFieldGroupInfo();
	String SiteAddress = channel.getSite().getUrl();

	String check2 = "";

	boolean editCategory = false;

	if(channel.isTableChannel() && channel.getType2()==8) editCategory = true;

	String userGroup = "";

	try
	{
		userGroup = new UserGroup(userinfo_session.getGroup()).getName();
	}
	catch(Exception e){}

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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="robots" content="noindex, nofollow"/>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10" /> 
<link rel="Shortcut Icon" href="../favicon.ico"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=item!=null?"编辑文档 " + item.getTitle():"新建文档"%> <%=channel.getParentChannelPath()%> TideCMS</title>
<link rel="stylesheet" type="text/css" href="../style/9/tidecms.css" />
<link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
<link rel="stylesheet"  type="text/css" href="../style/timepicker/jquery-ui-timepicker-addon.css" />
<link rel="stylesheet"  type="text/css" href="../style/jquery.tagit.css" />
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
var groupnum = <%=QRcode.equals("")?fieldGroupArray.size():fieldGroupArray.size()+1%>;
var begin_time=<%=begin_time/1000%>;
var SiteAddress = "<%=SiteAddress%>";
var GlobalID = <%=GlobalID%>;
var inner_url = "<%=inner_url%>";
var outer_url = "<%=outer_url%>";
</script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/document.js"></script>
<script type="text/javascript" src="../editor/fckeditor.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>

<script type="text/javascript" src="../common/jquery-ui.min.js"></script>
<script type="text/javascript" src="../common/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="../common/tag-it.js"></script>
<script>
<!--
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
	//编辑互斥
	isSaved();
	
	$.ajax({
         type: "POST",
         url:"../util/push_document_submit.jsp",
         data:$('#form').serialize(),
		 dataType:'json',
         success: function(result) {
		    if(result.message==""){		
				<%if(IsDialog==0){%>
				if(window.opener!=null)
				{
					window.opener.document.location.reload();					
				}
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
	$(".date").datetimepicker({
		   timeText: '时间',  
		   hourText: '小时',  
		   minuteText: '分钟',  
		   secondText: '秒',  
		   currentText: '现在',  
		   closeText: '完成',  
		   showSecond: true, //显示秒  
		   timeFormat: 'HH:mm:ss'//格式化时间  
	});

    var sampleTags = [];
    $("#Keyword").tagit({availableTags: sampleTags    });
    $("#Tag").tagit({availableTags: sampleTags    });
<%
	if(item!=null)
	{
		out.println("document.form.Action.value = 'Update';");
	}
	else
	{
		if(RecommendItemID>0 && RecommendChannelID>0)
		{
			out.println("recommendItemJS("+RecommendItemID+","+RecommendChannelID+","+ChannelID+",\""+RecommendTarget+"\");");
		}

		if(RecommendOutItemID>0&&RecommendOutChannelID>0)
		{
			out.println("recommendOutItemJS("+RecommendOutItemID+","+RecommendOutChannelID+","+ChannelID+",\""+ROutTarget+"\");");
		}

		if(CloudChannelID>0 && CloudItemID>0)
		{
			out.println("cloudItemJS("+CloudItemID+","+CloudChannelID+");");
		}
		
		if(transfer_article.length()>0)
		{
			out.println("transferArticleJS(\""+transfer_article+"\");");
		}
	}
%>
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

function previewFile(fieldname)
{
	var name = document.getElementById(fieldname).value;
	//图片库采用本地预览
	var reg = new RegExp(outer_url,"g");
	if(name=="") return;

	if(name.indexOf("http://")!=-1)  window.open(name.replace(reg,inner_url));
	else	window.open("<%=SiteAddress%>/" + name);
}

function selectByKeyword()
{
	var ByKeyword = document.getElementById("ByKeyword");
	var ByTitle = document.getElementById("ByTitle");
	document.getElementById("related_doc_list").src = "related_doc_list.jsp?GlobalID=<%=GlobalID%>&ChannelID=<%=ChannelID%>&ByKeyword="+ByKeyword.checked + "&ByTitle="+ByTitle.checked + "&keyword=" + encodeURIComponent(document.form.ByKeywordText.value);
}


function change()
{
	var value = $("input[name='audience_type']:checked").val();
	if(value==1)
	{
		$("#tr_device_tag").attr("style","display:none");
		$("#tr_device_alias").attr("style","display:none");
		$("#tr_registration").attr("style","display:none");

	}
	else if(value==2)
	{
		$("#tr_device_tag").attr("style","");
		$("#tr_device_alias").attr("style","display:none");
		$("#tr_registration").attr("style","display:none");
	}
	else if(value==3)
	{
		$("#tr_device_tag").attr("style","display:none");
		$("#tr_device_alias").attr("style","");
		$("#tr_registration").attr("style","display:none");
	}
	else if(value==4)
	{
		$("#tr_device_tag").attr("style","display:none");
		$("#tr_device_alias").attr("style","display:none");
		$("#tr_registration").attr("style","");
	}
}
$(function(){
	change();
	$("input[name='audience_type']").change(function(){
	change();
	});
});


//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="form" action="../util/push_document_submit.jsp" method="post" id = "form">
<div class="header">
	<%if(IsDialog==0){%><div class="logo"><a href="#" title="TideCMS"><img src="../images/logo.png" alt="TideCMS" /></a></div><%}%>
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
<%}
if(!QRcode.equals("")){%>
			<li>
			<a href="javascript:showTab('<%= fieldGroupArray.size()+1%>')" class="" id="form<%= fieldGroupArray.size()+1%>_td" >
			<span >二维码</span></a></li>		
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
	Field field_title = channel.getFieldByFieldName("Title");
%>
        
<table width="100%">
<%if(j==0){%>
<tr><td><div class="line" id="tr_Title"><%=field_title.getDescription()%>：</div></td><td><div class="line" id="field_Title">
<input type="text" class="textfield" size="80" id="Title" name="Title" value="<%=item!=null?Util.HTMLEncode(item.getValue("Title")):""%>" onkeyup="checkTitle();">	
<span id="TitleCount"></span>
<%
if(field_title.getJS().length()>0)
{
	out.println("<script>"+field_title.getJS()+"</script>");
}
%>
    
<%if(editCategory){%>分类：<select name="ChannelID" id="ChannelID">
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
<%if(item!=null){item.setCurrentPage(1);%>var currcontent = '<%=Util.JSQuote(item.getContent().replaceAll(outer_url,inner_url))%>';//Oracle not need JsQuote;
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
	<tr><td><div class="line"><%=field.getDescription()%>：</div></td><td><div class="line"><%=field.getDisplayHtml_(item!=null?item.getValue(field.getName()):"")%><input name="kewwordselect" type="button" class="tidecms_btn3" value="按关键词选择" onclick="selectByKeyword2()"></div></td></tr>
	<tr><td>相关视频：</td><td><iframe id="related_video_list" frameborder="0" height="400" width="650" marginheight="0" marginwidth="0" scrolling="auto" src="../video/related_video_list.jsp?id=<%=ItemID%>&ChannelID=<%=ChannelID%>"></iframe></td></tr>
	<%}else{
		out.println(field.getDisplayHtml2018(item));
	}%>
	<%}%>
<%}}%></table>
<%}out.println("</div>");j++;}while(j < fieldGroupArray.size());%>

<div class="center" url="" <%if(j!=0){%>style="display:none;"<%}%> id="form<%=fieldGroupArray.size()+1%>">        
<table width="100%">
	<tbody><tr id="tr_Wapsemacode">
		<td width="140"><div class="line">二维码分享功能：</div></td>
		<td>
			<div class="line">
				<div class="qr_code_img"><img src="<%=QRcode%>"></div>
				<div class="qr_code_txt">
					<div class="q_c_t_title">二维码标签分享功能</div>
					<div class="q_c_t_con">左侧的二维码是本内容是由移动终端分享地址生成。<br>通过手机、PAD客户端或微信“扫一扫”功能拍摄扫描二维码实现移动设备的内容浏览，并可以通过分享工具分享给移动设备用户。<br>也可以将本二维码发布到网页中，实现基于网页的二维码拍摄分享功能。</div>
				</div>
				<div class="clear"></div>
			</div>
		</td>
	</tr>
	
	<tr id="tr_Wapsemacode">
		<td><div class="line">二维码图片地址：</div></td>
		<td><div class="line"><%=QRcode%></td>
	</tr>
	<!--
	<tr id="tr_Wapsemacode">
		<td><div class="line">二维码终端分享地址：</div></td>
		<td><div class="line"><%=QRcode%></div></td>
	</tr>
   -->
</tbody></table>
</div>
 

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
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<%if(channel.getDocumentJS().length()>0){out.println("<script>");out.println(channel.getDocumentJS());out.println("</script>");}%>
<script type="text/javascript">
$('#SetPublishDate').datetimepicker();
$('#Revoketime').datetimepicker();
<%if(Parent>0){
out.println("setValue('Parent',"+Parent+");");
}%>

function change()
{
	var value = $("input[name='audience_type']:checked").val();
	if(value==1)
	{
		$("#tr_device_tag").attr("style","display:none");
		$("#tr_device_alias").attr("style","display:none");
		$("#tr_registration").attr("style","display:none");

	}
	else if(value==2)
	{
		$("#tr_device_tag").attr("style","");
		$("#tr_device_alias").attr("style","display:none");
		$("#tr_registration").attr("style","display:none");
	}
	else if(value==3)
	{
		$("#tr_device_tag").attr("style","display:none");
		$("#tr_device_alias").attr("style","");
		$("#tr_registration").attr("style","display:none");
	}
	else if(value==4)
	{
		$("#tr_device_tag").attr("style","display:none");
		$("#tr_device_alias").attr("style","display:none");
		$("#tr_registration").attr("style","");
	}
	else
	{
		$("#tr_device_tag").attr("style","display:none");
		$("#tr_device_alias").attr("style","display:none");
		$("#tr_registration").attr("style","display:none");
	}
}
$(function(){
	change();
	$("input[name='audience_type']").change(function(){
	change();
	});
});
</script>
</body>
</html>