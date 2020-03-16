<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.util.StringUtils,
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
	int		RecommendOutItemID		= getIntParameter(request,"ROutItemID");
	int		RecommendOutChannelID	= getIntParameter(request,"ROutChannelID");
	int		parentGlobalID			= getIntParameter(request,"globalid");

	int ContinueNewDocument			= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow				= getIntParameter(request,"NoCloseWindow");
	String From						= getParameter(request,"From");

	int GlobalID					= 0;

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
		item = new Document(ItemID,ChannelID);
	
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

	String title = item!=null?StringUtils.HTMLEncode(item.getValue("Title")):"";
	if(title.length()==0) title = " ";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="/cms2018/favicon.ico">
 <!-- Meta -->
<meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
<meta name="author" content="ThemePixels">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">   
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<!-- Bracket CSS -->
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<style>
html,body{
	width: 100%;
	height: 100%;
}
.lock-unlock{
	min-width: 20px;
}
label.left-fn-title {
    min-width: 70px !important;
}
</style>

<script src="../common/2018/common2018.js"></script>
<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/document.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>

<script>
<!--
var Pages=1;
var curPage = 1;
var Contents = new Array();
Contents[Contents.length] = "";
var userId = <%=userinfo_session.getId()%>;
var userName = "<%=userinfo_session.getName()%>";
var userGroupName = "<%=userGroup%>";
var userGroupId = <%=userinfo_session.getGroup()%>;

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
	document.form.submit();

	return;
	}
}

function init()
{		
	<%if(item!=null){%>
	document.form.Action.value = "Update";
	<%}else if(RecommendItemID>0 && RecommendChannelID>0){%>
	recommendItemJS(<%=RecommendItemID%>,<%=RecommendChannelID%>,<%=ChannelID%>);
	<%}else if(RecommendOutItemID>0&&RecommendOutChannelID>0){%>
	recommendOutItemJS(<%=RecommendOutItemID%>,<%=RecommendOutChannelID%>,<%=ChannelID%>);
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
	var myObject = new Object();
    myObject.title = "上传文件";

 	var Feature = "dialogWidth:24em; dialogHeight:12em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=content/insertfile.jsp&ChannelID=<%=ChannelID%>",myObject,Feature);
	if(retu!=null)
		document.getElementById(fieldname).value = retu;
}

function selectImage(fieldname)
{
	var	dialog = new TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(400);
	dialog.setLayer(2);
	dialog.setUrl("../content/insertfile2019.jsp?ChannelID=<%=ChannelID%>&Type=Image&fieldname="+fieldname);
	dialog.setTitle("上传图片");
	dialog.setScroll("yes");
	dialog.show();
}


function previewFile(fieldname)
{
	var name = document.getElementById(fieldname).value;

	if(name=="") return;

	if(name.indexOf("http://")!=-1)  window.open(name);
	else	window.open("<%=SiteAddress%>/" + name);
}

function showTab(n)
{
	if(document.body.disabled) return;

	var num = <%=fieldGroupArray.size()%>;
	for(i=1;i<=num;i++)
	{
		var divobj = document.getElementById("form"+i);
		if(divobj)	divobj.style.display = "none";
		document.getElementById("form"+i+"_td").className="";
	}

	document.getElementById("form"+n+"_td").className="cur";
	document.getElementById("form"+n).style.display = "";
	var url = $("#form"+n).attr("url");//alert(url);
	if(url!="")
		document.getElementById("iframe"+n).src = url;
}

function selectByKeyword()
{
	var ByKeyword = document.getElementById("ByKeyword");
	var ByTitle = document.getElementById("ByTitle");
	related_doc_list.location = "related_doc_list.jsp?GlobalID=<%=GlobalID%>&ChannelID=<%=ChannelID%>&ByKeyword="+ByKeyword.checked + "&ByTitle="+ByTitle.checked + "&keyword=" + encodeURIComponent(document.form.ByKeywordText.value);
}

function checkTitle()
{
	var title = document.form.Title.value;
	var message = document.getElementById("TitleCount");//alert(title.length);
	if(title!="")
	{
		var l=title.length;
		var n=0;
		for (var i=0;i<l;i++)
		{
			if (title.charCodeAt(i)<0||title.charCodeAt(i)>255)
				n++;
			else
				n = n + 0.5;
		}
		message.innerText = Math.ceil(n);
	}
	else
		message.innerText = "";
}
//-->
</script>
</head>
<body  onload="init();">
	<div class="bg-white modal-box">
		<form name="form" action="document_sub_photo_submit.jsp" method="post" onSubmit="return check();">

			<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
				<div class="config-box">
					<div class="row">                   		  	  	
	   		  	  		 <label class="left-fn-title" id="tr_Title">标题：</label>
			             <label class="wd-300" id="field_Title">
			                 <input class="form-control" placeholder="" type="text" id="Title" name="Title" value="<%=title%>" onkeyup="checkTitle();">
			             </label>
						 <label class="mg-l-5"><span id="TitleCount"></span></label>
	       		  	</div>
					<div class="row">                   		  	  	
	   		  	  		 <label class="left-fn-title" id="">发布日期：</label>
			             <label class="wd-160" id="field_PublishDate">
			                 <input class="form-control" placeholder="" type="text" id="PublishDate" name="PublishDate" value='<%=item!=null?item.getPublishDate():Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")%>'>
							 <span id="" onclick="selectdate('PublishDate');"></span>
			             </label>									            
	       		  	</div>
					<div class="row" style="display:none">                   		  	  	
	   		  	  		 <label class="left-fn-title" id="">文章来源：</label>
			             <label class="wd-300" id="field_DocFrom">
			                 <input class="form-control" placeholder="" type="text" id="DocFrom" name="DocFrom" value="">
			             </label>									            
	       		  	</div>
					<div class="row" style="display:none">                   		  	  	
	   		  	  		 <label class="left-fn-title" id="">图片新闻：</label>
			             <label class="wd-300" id="field_IsPhotoNews">
			                 <input class="form-control" placeholder="" type="text" id="IsPhotoNews" name="IsPhotoNews" value="">
			             </label>									            
	       		  	</div>
					<div class="row">                   		  	  	
	   		  	  		 <label class="left-fn-title" id="">摘要：</label>
			             <label class="wd-300" id="field_Summary">
			                 <textarea rows="3" class="form-control" placeholder="" name="Summary" id="Summary"><%=item!=null?item.getSummary():""%></textarea>
			             </label>									            
	       		  	</div>
					<div class="row" id="tr_Photo">                   		  	  	
	   		  	  		 <label class="left-fn-title" id="">图片：</label>
			             <label class="wd-300" id="field_Photo">
			                 <input class="form-control" placeholder="" type="text" id="Photo" name="Photo" value="<%=item!=null?item.getValue("Photo"):""%>">
			             </label>
						 <label><input name="" type="button" class="btn btn-primary tx-size-xs mg-l-10" value="选择" onClick="selectImage('Photo')" /> </label>
						 <label><input name="" type="button" class="btn btn-primary tx-size-xs mg-l-10" value="预览" onClick="previewFile('Photo')"/></label>
	       		  	</div>
					<div class="row" id="tr_Photo_s">                   		  	  	
	   		  	  		 <label class="left-fn-title" id="">小图：</label>
			             <label class="wd-300" id="field_Photo_s">
			                 <input class="form-control" placeholder="" type="text" id="Photo_s" name="Photo_s" value="<%=item!=null?item.getValue("Photo_s"):""%>">
			             </label>
						 <label><input name="" type="button" class="btn btn-primary tx-size-xs mg-l-10" value="选择" onClick="selectImage('Photo_s')"/></label>
						 <label><input name="" type="button" class="btn btn-primary tx-size-xs mg-l-10" value="预览" onClick="previewFile('Photo_s')"/></label>
	       		  	</div>
					<div class="row" id="tr_Photo_m">                   		  	  	
	   		  	  		 <label class="left-fn-title" id="">中图：</label>
			             <label class="wd-300" id="field_Photo_m">
			                 <input class="form-control" placeholder="" type="text" id="Photo_m" name="Photo_m" value="<%=item!=null?item.getValue("Photo_m"):""%>">
			             </label>
						 <label><input name="" type="button" class="btn btn-primary tx-size-xs mg-l-10" value="选择" onClick="selectImage('Photo_m')"/></label>
						 <label><input name="" type="button" class="btn btn-primary tx-size-xs mg-l-10" value="预览" onClick="previewFile('Photo_m')"/></label>
	       		  	</div>
				</div>
			</div><!-- modal-body -->

			<div class="btn-box" >
      			<div class="modal-footer" >
					<input type="hidden" name="From" value="">
					<input type="hidden" name="Action" value="Add">
					<input type="hidden" name="Content" value="">
					<input type="hidden" name="ItemID" value="<%=ItemID%>">
					<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
					<input type="hidden" name="Status" value="1">
					<input type="hidden" name="GlobalID" value="<%=GlobalID%>">
					<input type="hidden" name="Parent" value="<%=parentGlobalID%>">
					<input type="hidden" name="RelatedItemsList" value="">
					<input type="hidden" name="Page" value="1">
					<input type="hidden" name="fieldgroup" value="<%=getIntParameter(request,"fieldgroup")%>">
					<input type="hidden" name="RecommendGlobalID" value="0">
					<input type="hidden" name="RecommendChannelID" value="0">
					<input type="hidden" name="RecommendItemID" value="0">
					<input type="hidden" name="RecommendType" value="0">
					<button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
					<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
				</div> 
			</div>

			<div id="ajax_script" style="display:none;"></div>
		</form>
	</div>

</body>
</html>