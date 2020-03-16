<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	String	uri						= request.getRequestURI();
	long	begin_time				= System.currentTimeMillis();
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
	if(channel.getDocumentProgram().length()>0 && uri.endsWith("/content/document.jsp") )
		response.sendRedirect(channel.getDocumentProgram()+"?ChannelID="+ChannelID+"&ItemID="+ItemID+"&ROutTarget="+ROutTarget+"&ROutChannelID="+RecommendOutChannelID+"&ROutItemID="+RecommendOutItemID+"&RecommendItemID="+RecommendItemID+"&RecommendChannelID="+RecommendChannelID+"&RecommendTarget="+RecommendTarget);

	if(channel.isVideoChannel())
	{
		response.sendRedirect("../video/document.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID);return;
	}

	if(ItemID>0)
	{
		item = CmsCache.getDocument(ItemID,ChannelID);

		//解决同步问题，2012.09.19
		if(item.getChannel().getId()!=ChannelID)
		{
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
	String oldTitle="";
	String oldWidth="";
	String oldHeight="";
	String oldScreentype="";
	if(item!=null){
        oldTitle= item.getValue("Title");
    	oldWidth= item.getValue("width");
    	oldHeight= item.getValue("height");
    	oldScreentype = item.getValue("screentype");
    }
%>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico"/>
<title><%=item!=null?"编辑文档 " + item.getTitle():"新建文档"%> <%=channel.getParentChannelPath()%> TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/summernote/summernote-bs4.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">

<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet"  type="text/css" href="../style/jquery.tagit.css" />
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">

<link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
<link rel="stylesheet"  type="text/css" href="../style/timepicker/jquery-ui-timepicker-addon.css" />
<link rel="stylesheet" href="../style/2018/bracket.css"> 

<style>
        	.collapsed-menu .br-mainpanel-file{
			margin-left: 60px;
		}
    	@media (max-width: 991px){
				.email .with-second-nav {
				    margin-left: 230px;
				}
				.collapsed-menu .br-mainpanel-file{
					margin-left: 0;
				}
				
			}
		@media (max-width: 575px){
			.email .with-second-nav {
			    margin-left: 0px;
			}
		}
		
		#nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
		#nav-header a{color: #a4aab0;}
		
		.bs-tooltip-bottom .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #f8f9fa;opacity: 1;}
		.tooltip.bs-tooltip-bottom .arrow::before,
		.tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {border-bottom-color: #f8f9fa;	}
		.edui-editor {z-index: 0 !important;}
	    /*tooltip相关样式*/
	    .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
		.tooltip.bs-tooltip-right .arrow::before,
		.tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {			
			border-right-color: #00b297;			
		}
		
		.min-h-200{min-height: 100px;}
		.screen-row{overflow: hidden;}
		.x16-1{width: 180px;}
		.x16-2{width: 360px;}
		.x16-3{width: 540px;}
		.x16-4{width: 720px;}
		.x16-5{width: 900px;}
		.x16-6{width: 1080px;}
		.x16-7{width: 1260px;}
		
		.y9-1{height: 101px;}
		.y9-2{height: 202px;}
		.y9-3{height: 303px;}
		.y9-4{height: 404px;}
		.y9-5{height: 505px;}
		.y9-6{height: 606px;}
		.y9-7{height: 707px;}
		
		.x4-1{width: 135px;}
		.x4-2{width: 270px;}
		.x4-3{width: 405px;}
		.x4-4{width: 540px;}
		.x4-5{width: 675px;}
		.x4-6{width: 810px;}
		.x4-7{width: 945px;}
		
		.y3-1{height: 101px;}
		.y3-2{height: 202px;}
		.y3-3{height: 303px;}
		.y3-4{height: 404px;}
		.y3-5{height: 505px;}
		.y3-6{height: 606px;}
		.y3-7{height: 707px;}
		
		.border-50{border-radius: 50%;width: 40px;height: 40px;background: rgb(139, 195, 74);text-align: center;line-height: 40px;color: #fff;}
		.screen-item{position: relative;}
		.screen-item .new-screen{position: absolute;right: -31px;top: 0;z-index: 0;}
		
    </style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/document.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<script src="../common/tag-it.js"></script>
<!--百度编辑器-->
<script type="text/JavaScript" charset="utf-8" src="../ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="../ueditor/ueditor.all.js"></script>
<script type="text/javascript" charset="utf-8" src="../ueditor/lang/zh-cn/zh-cn.js"></script>
<!--<script type="text/javascript" charset="utf-8" src="../ueditor/toupiaoDialog.js"></script>-->
<script type="text/javascript" charset="utf-8" src="../ueditor/photosDialog.js"></script>
<script type="text/javascript" charset="utf-8" src="../ueditor/imgeditorDialog.js"></script>
<script type="text/javascript" charset="utf-8" src="../ueditor/imagesDialog.js"></script>

<script>
var webName = "${pageContext.request.contextPath}";

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
var is_auto_save = false;//自动保存
var timer = null;//定时器

var NoCloseWindow = <%=NoCloseWindow%>;//是否关闭页面
var unload = true ;//关闭页面是否提示
window.onresize = function(){	
	if(document.getElementsByClassName("content-edit-frame")[0]){		
		if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){ 
			var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.body.scrollHeight ;
		}else{
			var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.documentElement.scrollHeight ;		
		}		
		document.getElementsByClassName("content-edit-frame")[0].style.height = _height
	}
}
//调整iframe的高度 
function changeFrameHeight(_this){   
	if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){     		
		_this.style.height = _this.contentWindow.document.body.scrollHeight +5;				
	}else{		
		_this.style.height = _this.contentWindow.document.documentElement.scrollHeight +5;				
	}
}

</script>

<script>
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

	if(is_auto_save)
	{
		document.getElementById("Image1Href").href = "javascript:void(0);";
		<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
			document.getElementById("Image2Href").href = "javascript:void(0);";
		<%}%>
	}
	 
	var boxDiv=document.createElement('div');
   	boxDiv.className = "screen-box" ;
	for(var i = 0;i<$(".screen-box").find(".screen-column").size();i++){
		var column = $(".screen-box").find(".screen-column").eq(i);
		var columnDiv = document.createElement('div');
		columnDiv.className="screen-column";
		for(var n=0;n<$(column).find(".screen-row").size();n++){
			var row = $(column).find(".screen-row").eq(n);
			var rowDiv = document.createElement('div');
			rowDiv.className="screen-row";
			for(var l=0;l<$(row).find(".screen-item").size();l++){
				var item = $(row).find(".screen-item").eq(l);
				var itemDiv = document.createElement('div');
				itemDiv.className="screen-item";
				var dw = $(item).attr("data-w");
				var dh = $(item).attr("data-h");
				var dt = $(item).attr("data-type");
				var sourceid = $(item).attr("sourceid");
				if(dt==2){
       			    var wd = "x16-"+dw,
       				ht = "y9-"+dh;
       	    	}else if(dt==1){
       			    var wd = "x4-"+dw,
       			    ht = "y3-"+dh;
       		    }  
				$(itemDiv).addClass(wd).addClass(ht).attr({
       		    	"data-w":dw,
       			    "data-h":dh,
					"data-type":dt
       		    });   		
				if(sourceid!=undefined&&sourceid!=""&&sourceid!=0){
					var ifm = document.createElement('iframe');
					$(ifm).attr('src',$('#'+sourceid).children('td').eq(3).html());
					$(ifm).attr('allowfullscreen','true');
					$(itemDiv).append($(ifm));
				}
				$(rowDiv).append($(itemDiv));
			}
			$(columnDiv).append($(rowDiv));
		}
		$(boxDiv).append($(columnDiv));
	}
	var htmlScreen = $(boxDiv).prop("outerHTML");
	console.log(htmlScreen);
	$("#screenhtml").val(htmlScreen);
	//var boxDiv=document.createElement('box');
	var _form_data = $("#form").serialize();
	if(form_data == _form_data && is_auto_save)// 自动保存 数据没有变化时不进行数据提交
	{  
		// $("#display_auto_save").removeClass("auto_save_hide").addClass("auto_save").text("数据没有变化"+getNowFormatDate());
		return ;
	}
	//如果有数据变化 把新的表单值赋值给form_data
	form_data =_form_data ;
	//编辑互斥
	isSaved();
	$("#display_auto_save").removeClass("auto_save_hide").addClass("auto_save").text("正在保存"+getNowFormatDate());
	$.ajax({
         type: "POST",
         url:"../content/document_submit.jsp",
         data:$('#form').serialize(),
		 dataType:'json',
         success: function(result) 
		 {
			if(!is_auto_save)
			{//非自动保存
				if(result.message=="")
				{	
					unload = false ;
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
					if(result.message=="auto save")
					{
					}
					else
					{
						ddalert(result.message,"(function dd(){getDialog().Close({suffix:'html'});})()");
						//alert(result.message);
					}
					document.getElementById("Image1Href").href = "javascript:Save();";
					<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
					document.getElementById("Image2Href").href = "javascript:Save_Publish();";
					<%}%>
				 } 
			}
			else
			{
				//自动保存刷新页面
				//window.location.href="document.jsp?NoCloseWindow=1&ItemID=" + result.id+ "&ChannelID="+result.channelid
				document.form.NoCloseWindow.value = '1';
				document.form.Action.value='Update';
				document.form.ItemID.value=result.id;

				document.getElementById("Image1Href").href = "javascript:Save();";
				<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
					document.getElementById("Image2Href").href = "javascript:Save_Publish();";
				<%}%>
                            
                         
			}
			$("#display_auto_save") .addClass("auto_save").text("保存完成"+getNowFormatDate());
		  // $("#display_auto_save").removeClass("auto_save").addClass("auto_save_hide");   
	    },
		error: function (XMLHttpRequest, textStatus, errorThrown) 
		{ 
			//alert("保存没有成功，请重新尝试。");
			ddalert("保存没有成功，请重新尝试。","(function dd(){getDialog().Close({suffix:'html'});})()");
			
			document.getElementById("Image1Href").href = "javascript:Save();";
			<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
			document.getElementById("Image2Href").href = "javascript:Save_Publish();";
			<%}%>
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
		    dateFormat:"yy-mm-dd",
		    timeFormat: 'HH:mm:ss',//格式化时间  
		    monthNames: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],  
            dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],  
            dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],  
            dayNamesMin: ['日','一','二','三','四','五','六']
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
	auto_save();
}

//获取当前时间
function getNowFormatDate()
{
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = year + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds();
    return currentdate;
}

//自动保存
function auto_save()
{
		if($("#auto_save").attr("checked"))//勾选了才自动保存
		{
					is_auto_save = true;
					document.form.NoCloseWindow.value = '1';
					timer = window.setInterval("Save()","30000");
		}
			//自动保存
		$("#auto_save").change(
				function()
				{
					if(this.checked)
					{//选中 自动保存
							is_auto_save = true;
							document.form.NoCloseWindow.value = '1';
							timer = window.setInterval("Save()","30000");
					}
					else
					{//取消自动保存
						  is_auto_save = false;
						  document.form.NoCloseWindow.value = '0';
						  window.clearInterval(timer); 
					}
			}
		);

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
var isCreateSubmit = true;
function createSource(){
    var GlobalID = $("#GlobalID").get(0);
    if(GlobalID.value==0){
        if(isCreateSubmit){
           isCreateSubmit = false;
           $.ajax({
                type: "GET",
                url: "createItem.jsp",
                dataType: "json",
                data: {channelid: channelid},
                success: function (json) {
                    if (json.code == 500) {
                        alert(json.message);
                        isCreateSubmit = true;
                    } else if (json.code == 200) {
                        isCreateSubmit = false;
                        GlobalID.value = json.parentGlobalid;
                        var itemId = json.itemId;
                        document.form.ItemID.value = itemId;
                        document.form.Action.value = "Update";
                        var pglobalid = $("#GlobalID").get(0).value;
                        var url ="../daping/daping_sourceDoc.jsp?pglobalid="+pglobalid;
                        var	dialog = new top.TideDialog();
                        dialog.setWidth(500);
                        dialog.setHeight(280);
                        dialog.setUrl(url);
                        dialog.setTitle('定义内容源');
                        dialog.setChannelName('屏幕管理');
                        dialog.show();
                    } else {
                        alert(json);
                    }
                }
            });
        }
    }else{
        var pglobalid = $("#GlobalID").get(0).value;
        var url ="../daping/daping_sourceDoc.jsp?pglobalid="+pglobalid;
        var	dialog = new top.TideDialog();
        dialog.setWidth(500);
        dialog.setHeight(280);
        dialog.setUrl(url);
        dialog.setTitle('定义内容源');
        dialog.setChannelName('屏幕管理');
        dialog.show();
    }
}
function modifySource(){
    var obj=$('input[name=id]:checked');
    var no = obj.val()
    var tr =$('#'+no+'');
    if(obj.length==0){
        TideAlert("提示","请先选择文件！");
        return;
    }else if(obj.length>1){
        TideAlert("提示","请选择一个文件！")
        return;
    }
    var pglobalid = $("#GlobalID").get(0).value;
    var title = tr.children('td').eq(2).html();
    var sourceUrl =tr.children('td').eq(5).html();
    var url ='../daping/daping_sourceDoc.jsp?pglobalid='+pglobalid+'&globalid='+no+'&Title='+title+'&sourceUrl='+encodeURI(sourceUrl) ;
    var	dialog = new top.TideDialog();
    dialog.setWidth(500);
    dialog.setHeight(280);
    dialog.setUrl(url);
    dialog.setTitle('定义内容源');
    dialog.setChannelName('屏幕管理');
    dialog.show();
}
var isDelete = true;
function deleteSource(){
    var obj=$('input[name=id]:checked');
    var globalids = "";
    if(obj.length==0){
        TideAlert("提示","请先选择文件！");
        return;
    }
    var table = $("#sourceTable");
    for(var i=0;i<obj.length;i++){
       if(i==obj.length-1){
           globalids =globalids + obj[i].value;
       }else{
           globalids =globalids + obj[i].value+",";
       }
    }
    if(isDelete){
    isDelete=false;
    $.ajax({
        type: "GET",
        url: "deleteSource.jsp?globalids="+globalids,
        dataType: "json",
        data: {channelid: channelid},
        success: function (json) {
            if (json.code == 500) {
                alert(json.message);
                isDelete = true;
            } else if (json.code == 200) {
                isDelete = true;
                reloadSource();
            } else {
                alert(json);
            }
        }
    });}
    
}

function lookUrl(globalid){
    var tr =$('#'+globalid+'');
    var sourceUrl =tr.children('td').eq(3).html();
    console.log(sourceUrl);
    if(!sourceUrl)return ;
	window.open(sourceUrl);
}



function modifySourceId(globalid){
    var tr =$('#'+globalid+'');
    var pglobalid = $("#GlobalID").get(0).value;
    var title = tr.children('td').eq(1).html();
    var sourceUrl =tr.children('td').eq(3).html();
    var url ='../daping/daping_sourceDoc.jsp?pglobalid='+pglobalid+'&globalid='+globalid+'&Title='+title+'&sourceUrl='+encodeURI(sourceUrl) ;
    var	dialog = new top.TideDialog();
    dialog.setWidth(500);
    dialog.setHeight(280);
    dialog.setUrl(url);
    dialog.setTitle('定义内容源');
    dialog.setChannelName('屏幕管理');
    dialog.show();
}


var isDeleteId = true;
function deleteSourceId(globalid){
    if(isDeleteId){
    isDeleteId=false;
    $.ajax({
        type: "GET",
        url: "deleteSource.jsp?globalids="+globalid,
        dataType: "json",
        data: {channelid: channelid},
        success: function (json) {
            if (json.code == 500) {
                alert(json.message);
                isDeleteId = true;
            } else if (json.code == 200) {
                isDeleteId = true;
                reloadSource();
            } else {
                alert(json);
            }
        }
    });}
    
}






function addTable(i,Title,sourceUrl,globalid,userName,date){
    var sourceTable = $("#sourceTable");
    var sourceTr= '" <tr id="'+globalid+'"  class="tide_item">"';
    //var sourceTdCheck='<td class="valign-middle"><label class="ckbox mg-b-0"><input type="checkbox" name="id" value="'+globalid+'"><span></span></label></td>';
    var sourceTdNo='<td>'+(parseInt(i)+parseInt(1))+'</td>'
    var sourceTdTitle='<td class="hidden-xs-down">'+Title+'</td>'
    var sourceTdAuthor='<td class="hidden-xs-down">'+userName+'</td>'
    var sourceTdSUrl ='<td class="hidden-xs-down">'+sourceUrl+'</td>'
    var sourceTdPushdata='<td class="hidden-xs-down">'+date+'</td>'
    var sourceTdOpt =	'<td class="dropdown hidden-xs-down">'+
                    				'<a href="javascript:lookUrl('+globalid+');" class="btn pd-0 mg-r-8" title="预览"><i class="fa fa-eye  tx-18 handle-icon" aria-hidden="true"></i></a>'+
                    				'<a href="javascript:modifySourceId('+globalid+');" class="btn pd-0 mg-r-8" title="修改"><i class="fa fa-edit tx-18 handle-icon" aria-hidden="true"></i></a>'+
                    				'<a href="javascript:deleteSourceId('+globalid+');" class="btn pd-0 mg-r-5" title="删除"><i class="fa fa-trash tx-18 handle-icon" aria-hidden="true"></i></a>'+
                    			'</td></tr>'
    sourceTable.append(sourceTr+sourceTdNo+sourceTdTitle+sourceTdAuthor+sourceTdSUrl+sourceTdPushdata+sourceTdOpt);
}
function reloadSource(){
    var GlobalID = $("#GlobalID").get(0).value;
    if(GlobalID==0){
        return;
    }
    $.ajax({
        type: "GET",
        url: "getSource.jsp?pglobalid="+GlobalID,
        dataType: "json",
        data: {channelid: channelid},
        success: function (json) {
            if (json.code == 500) {
                alert(json.message);
                submit = true;
            } else if (json.code == 200) {
                 reloadTable(json.data);
            } else {
                alert(json);
            }
        }
    });
}
function reloadTable(json){
    $("#sourceTable").empty();
    for(var i=0;i<json.length;i++){
        addTable(i,json[i].Title,json[i].sourceUrl,json[i].globalid,json[i].UserName,json[i].date);
    }
}
function createScreen(obj){
    var GlobalID = $("#GlobalID").get(0);
    var x = $(obj).attr("x");
    var y = $(obj).attr("y");
    if(GlobalID.value==0){
        if(isCreateSubmit){
           isCreateSubmit = false;
           $.ajax({
                type: "GET",
                url: "createItem.jsp",
                dataType: "json",
                data: {channelid: channelid},
                success: function (json) {
                    if (json.code == 500) {
                        alert(json.message);
                        isCreateSubmit = true;
                    } else if (json.code == 200) {
                        isCreateSubmit = false;
                        GlobalID.value = json.parentGlobalid;
                        var itemId = json.itemId;
                        document.form.ItemID.value = itemId;
                        document.form.Action.value = "Update";
                        var pglobalid = $("#GlobalID").get(0).value;
                        var url ="../daping/daping_screenDoc.jsp?pglobalid="+pglobalid+"&x="+x+"&y="+y;
                        var	dialog = new top.TideDialog();
                        dialog.setWidth(500);
                        dialog.setHeight(350);
                        dialog.setUrl(url);
                        dialog.setTitle('新建屏幕模块');
                        dialog.setChannelName('屏幕管理');
                        dialog.show();
                    } else {
                        alert(json);
                    }
                }
            });
        }
    }else{
        var pglobalid = $("#GlobalID").get(0).value;
        var url ="../daping/daping_screenDoc.jsp?pglobalid="+pglobalid+"&x="+x+"&y="+y;
        var	dialog = new top.TideDialog();
        dialog.setWidth(500);
        dialog.setHeight(350);
        dialog.setUrl(url);
        dialog.setTitle('新建屏幕模块');
        dialog.setChannelName('屏幕管理');
        dialog.show();
    }
}
function  reloadScreen(){
    var GlobalID = $("#GlobalID").get(0).value;
    if(GlobalID==0){
        return;
    }
    $.ajax({
        type: "GET",
        url: "getScreen.jsp?pglobalid="+GlobalID,
        dataType: "json",
        data: {channelid: channelid},
        success: function (json) {
            if (json.code == 500) {
                alert(json.message);
                submit = true;
            } else if (json.code == 200) {
                 reloadBody(json.data);
            } else {
                alert(json);
            }
        }
    });
}
function BindingScreen(globalid){
    var pglobalid = $("#GlobalID").get(0).value;
    var url ='../daping/addScreenSource.jsp?globalid='+globalid+'&pglobalid='+pglobalid;
    var	dialog = new top.TideDialog();
    dialog.setWidth(500);
    dialog.setHeight(360);
    dialog.setUrl(url);
    dialog.setTitle('绑定屏幕资源');
    dialog.setChannelName('屏幕管理');
    dialog.show();
    
}
function modifyScreen(globalid){
    var pglobalid = $("#GlobalID").get(0).value;
    var url ='../daping/daping_screenDoc.jsp?pglobalid='+pglobalid+'&globalid='+globalid;
    var	dialog = new top.TideDialog();
    dialog.setWidth(500);
    dialog.setHeight(350);
    dialog.setUrl(url);
    dialog.setTitle('修改屏幕模板');
    dialog.setChannelName('屏幕管理');
    dialog.show();
}
var isDeleteScreen = true;
function deleteScreen(globalid){
    if(isDeleteScreen){
    isDeleteScreen=false;
    $.ajax({
        type: "GET",
        url: "deleteScreen.jsp?globalids="+globalid,
        dataType: "json",
        data: {channelid: channelid},
        success: function (json) {
            if (json.code == 500) {
                alert(json.message);
                isDeleteScreen = true;
            } else if (json.code == 200) {
                isDeleteScreen = true;
                reloadScreen();
            } else {
                alert(json);
            }
        }
    });}
}
var rightCol = 0;
var rightRow = 0;
function reloadBody(json){
    rightCol = 0;
    $(".screen-box").empty();
    var LineScreen = new Array;
    var jsonObj = {};
    for(var i=0;i<json.length;i++){
       var xattr = json[i].xplace+'DIV';
        if(jsonObj[xattr]==undefined){
            jsonObj[xattr] = new Array;
            jsonObj[xattr].push(json[i]);
        }else{
            jsonObj[xattr].push(json[i]);
        }
    }
    for(var key in jsonObj){  
        addScreen(jsonObj[key]);
    }  
    //if($("#screenBody").html()=="")$("#screenBody").append('<div class="new-screen" onclick="createScreen(this)" x="0" y="0"><i class="fa fa-plus-square tx-primary tx-34"></i></div>');
    var rightBtn = '<div class="new-screen right-add"><i class="fa fa-plus-square tx-primary tx-34"  onclick="createScreen(this)" x="'+(rightCol)+'" y="0" ></i></div> ';
    $(".screen-box").append(rightBtn);
}
function addScreen(json){
      rightRow=0;
      var sDiv=document.createElement('div');
   	  sDiv.className = "screen-column d-flex flex-column " ;
   	  console.log(JSON.stringify(json));
   	  var jsonObj = {};
   	  var xplace =0;
	  for(var i=0;i<json.length;i++){
	    var xattr = json[i].yplace+'Row'+json[i].xplace;
	    var xplace =json[i].xplace;
        if(jsonObj[xattr]==undefined){
            jsonObj[xattr] = new Array;
            jsonObj[xattr].push(json[i]);
        }else{
            jsonObj[xattr].push(json[i]);
        }
	  }
	  for(var key in jsonObj){
	        jsonObject = jsonObj[key];
	         var rowDiv=document.createElement('div');
       		     rowDiv.className = "screen-row d-flex flex-row";
       		     rowDiv.id=key;
	      for(var i=0;i<jsonObject.length;i++){
	        rightRow = jsonObject[i].yplace;
	        //var rowDiv = '<div class="screen-row d-flex flex-row" id="'+rowId+'"></div>' ;
    	    var oDiv=document.createElement('div');
       		    if(jsonObject[i].screenpro==2){
       			    var wd = "x16-"+jsonObject[i].width ,
       				ht = "y9-"+jsonObject[i].height ;
       	    	}else if(jsonObject[i].screenpro==1){
       			    var wd = "x4-"+jsonObject[i].width ,
       			    ht = "y3-"+jsonObject[i].height ;
       		    }  		
       	    	oDiv.className = "screen-item bg-primary d-flex bd-white bd" ;
       		    $(oDiv).addClass(wd).addClass(ht).attr({
       		    	"data-w":jsonObject[i].width,
       			    "data-h":jsonObject[i].height,
					"data-type":jsonObject[i].screenpro,
					"sourceid":jsonObject[i].sourceid
       		    })  ;   		
       		    var html = '<div class="bg-primary rounded overflow-hidden wd-100p">'+
       		                '<div class="pd-10 d-flex align-items-center ht-100p">'+
       							'<div class=" mg-l-0 wd-100p ht-100p d-flex flex-column justify-content-between">'+
       								'<p class="tx-16 tx-monttx-white"><a class="" href="javascript:BindingScreen('+jsonObject[i].globalid+');"><i class="fa tx-white fa-sign-out"></i></a></p>'+
       								'<div class="d-flex justify-content-center">'+
       									'<div class="border-50 screen-order">'+jsonObject[i].number+'</div>'+
       								'</div>'+
       								'<div class="d-flex justify-content-end">'+
       									//'<a class="" href="javascript:lookUrl('+jsonObject[i].sourceid+');"><i class="tx-white fa fa-eye tx-14 "> </i></a>'+
       									'<a class="mg-l-10" href="javascript:modifyScreen('+jsonObject[i].globalid+');"><i class="tx-white fa fa-gear tx-14"> </i></a>'+
       									'<a class="mg-l-10" href="javascript:deleteScreen('+jsonObject[i].globalid+');"><i class="tx-white fa fa-trash tx-14 "> </i></a>'+
       								'</div>'+
       							'</div>'+
       						'</div>'+
       					'</div>'+
       					'<div class="new-screen row-add" ><i class="fa fa-plus-square tx-primary tx-34" onclick="createScreen(this)" x="'+jsonObject[i].xplace+'" y="'+rightRow+'"></i></div>' ;
       		     $(oDiv).html(html);
                 $(rowDiv).append($(oDiv));
       		     //console.log($("#"+rowId).append("123123123"));
        }
        $(sDiv).append($(rowDiv));
     }
     //if(i==json.length-1){
       		    var btnHtml = '<div class="new-screen bot-add"  ><i class="fa fa-plus-square tx-primary tx-34" onclick="createScreen(this)"  x="'+xplace+'" y="'+(parseInt(rightRow)+parseInt(1))+'"></i></div>';
       		    $(sDiv).append(btnHtml);
       		//}
     if(xplace>=rightCol){
       		    rightCol = parseInt(xplace)+1;
       		}
     //rightCol = parseInt(rightCol) + parseInt(maxWidth);
     $(".screen-box").append($(sDiv));
}
</script>
</head>

<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="form" action="../content/document_submit.jsp" method="post" id = "form">
<div class="br-logo"><img src="../images/2018/system-logo.png"></div>
<div class="br-sideleft overflow-y-auto">
	<label class="sidebar-label pd-x-15 mg-t-20"></label>
<%for (int i = 0; i < fieldGroupArray.size(); i++){
	FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);%>	
	<div class="br-sideleft-menu">
		<a href="javascript:showTab('<%=i+1%>')" <%=(i==0?"class='br-menu-link active'":"class='br-menu-link'")%> id="form<%=i+1%>_td" groupid="<%=fieldGroup.getId()%>" data-toggle="tooltip" data-placement="right" title="<%=fieldGroup.getName()%>">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-edit tx-22"></i>
				<span class="menu-item-label"><%=fieldGroup.getName()%></span>
			</div><!-- menu-item -->
		</a><!-- br-menu-link -->
	</div><!-- br-sideleft-menu -->
<%}if(!QRcode.equals("")){%>
	<div class="br-sideleft-menu">
		<a href="javascript:showTab('<%= fieldGroupArray.size()+1%>')" class="br-menu-link" id="form<%= fieldGroupArray.size()+1%>_td" data-toggle="tooltip" data-placement="right" title="二维码">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-edit tx-22"></i>
				<span class="menu-item-label">二维码</span>
			</div><!-- menu-item -->
		</a><!-- br-menu-link -->
	</div><!-- br-sideleft-menu -->
<%}%>
</div><!-- br-sideleft -->  
 <div class="br-header">
	<div class="br-header-left">
		<div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
		<div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
		<div id="nav-header" class="hidden-md-down flex-row align-items-center">
			<%=channel.getParentChannelPath().replaceAll(">"," / ")%>
		</div>
	</div><!-- br-header-left -->
	<div class="br-header-right">
		<div class="btn-box" >	      	
			<button type="button" class="btn btn-primary tx-size-xs mg-r-5" onclick="Save();" id="Image1Href">保存</button>
			<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
				<button type="button" class="btn btn-secondary tx-size-xs mg-r-5" id="Image2Href" onclick="Save_Publish();">保存并发布</button>
			<%}%>
			<button type="button"  class="btn btn-secondary tx-size-xs mg-r-10" onclick="self.close();">关闭</button>			   
		</div>
	</div><!-- br-header-right -->
</div><!-- br-header -->
<!--	<div class="br-pagebody bg-white mg-l-20 mg-r-20">
		<div class="br-content-box pd-20">  -->
	<!-- 屏幕管理-->
 <div class="br-mainpanel br-mainpanel-file overflow-hidden bd-b "> 
    <div class="br-pagebody bg-white mg-t-0">
		<div class="br-content-box pd-x-20 pd-y-30 d-flex align-items-center justify-content-center  min-h-200"> 
		    <div class="d-flex align-items-start justify-content-center min-h-200">
		        <div class="screen-box d-flex flex-lg-row">
		            <div class="new-screen right-add"><i class="fa fa-plus-square tx-primary tx-34"  onclick="createScreen(this)" x="0" y="0" ></i></div> 
		        </div>
		    </div>
		</div>
	</div>
</div>
	<!--<div class="br-mainpanel br-mainpanel-file overflow-hidden bd-b"> 
        <div class="br-pagebody bg-white pd-0 mg-0">
        	<div class="br-content-box pd-20 d-flex align-items-center justify-content-center  min-h-200" id="screenBody">
        	<div class="new-screen" onclick="createScreen()"><i class="fa fa-plus-square tx-primary tx-34"></i></div>       		
        		
        	</div>
        </div>
    </div>--><!-- br-mainpanel -->
	<!-- 内容资源管理-->
	<div class="br-mainpanel br-mainpanel-file overflow-hidden mg-t-0 pd-b-40 bd-b"> 
	  <!-- 内容资源header-->
        <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
	        <div class=" tx-16">内容源配置</div>        
	        <div class="btn-group mg-l-auto hidden-sm-down">
	          <a href="#" class="btn btn-outline-info" onclick="createSource();">新建</a>
	          <!--<a href="#" class="btn btn-outline-info" onclick="modifySource();">修改内容源</a>
	          <a href="#" class="btn btn-outline-info" onclick="deleteSource();">删除内容源</a>--> 
	        </div><!-- btn-group -->
	        
	        <!--<div class="btn-group mg-l-10 hidden-sm-down">
	          <a href="#" class="btn btn-outline-info"><i class="fa fa-chevron-left"></i></a>
	          <a href="#" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
	          
	        </div>-->
	        <!-- btn-group -->
	        <!-- START: 只显示在移动端 -->
	        <div class="dropdown mg-l-auto hidden-md-up">
	          <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
	          <div class="dropdown-menu dropdown-menu-right pd-10">
	            <nav class="nav nav-style-1 flex-column">
	              <a href="#" class="nav-link">发布</a>
			          <a href="javascript:;" class="nav-link" onclick="createSource();">新建</a>
			          <!--<a href="javascript:;" class="nav-link" onclick="modifySource();">修改内容源</a>
			          <a href="javascript:;" class="nav-link" onclick="deleteSource();">删除内容源</a>-->
			        
	            </nav>
	          </div><!-- dropdown-menu -->
	        </div><!-- dropdown -->
	        <!-- END: 只显示在移动端 -->
      	</div>
        <!-- 内容资源table-->
        <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
          <table class="table mg-b-0" id="content-table">
            <thead>
              <tr>
                <!--<th class="wd-50 header">
                  <label class="ckbox mg-b-0">
                    <input type="checkbox" id="checkAll"><span></span>
                  </label>
                  选择
                </th>-->
                <th class="tx-12-force tx-mont tx-medium header wd-80">编号</th>
                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-160">内容源名称</th>
                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-200">创建作者</th>
                <th class="tx-12-force tx-mont tx-medium hidden-xs-down header wd-900">目标地址</th>
                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-180">创建时间</th>
                <th class="tx-12-force wd-180 tx-mont tx-medium hidden-xs-down header">操作</th>
               <!-- <th class="wd-5p">操作</th>-->
              </tr>
            </thead>
            <tbody id="sourceTable">
             
              </tbody>
          	</table>
          	<div id="tide_content_tfoot">
          	
    			</div>
    		</div>
		</div>
		<!-- 内容资源table-->
	</div>
	<!-- 内容资源管理-->

</div>
</div>

<div class="br-mainpanel br-mainpanel-file overflow-hidden mg-t-0 pd-b-40 pd-sm-x-30">        
        <div class="br-pagebody bg-white ">
        	<div class="br-content-box pd-20">
        		<div class="article-title mg-l-15 mg-b-15 pd-r-30">
				  	<div class="row flex-row align-items-center mg-b-15" id="">                   		  	  	
					    <label class="left-fn-title wd-100 " id="">方案标题：</label>
					    <label class="wd-content-lable d-flex" id="">
						    <input class="form-control wd-300" placeholder="" type="text" id="Title" name="Title" size="80" value="" onkeyup="">
					    </label>
					    <label><span class="mg-l-10"></span></label>		
				   </div>
				   <div class="row flex-row align-items-center mg-b-15" id="">                   		  	  	
					    <label class="left-fn-title wd-100 " id="">总分辨率：</label>
					    <label class="wd-content-lable d-flex" id="">
						    <input class="form-control wd-100 mg-r-20" placeholder="宽" type="text" id="width" name="width" size="80" value="" onkeyup="">
						    <input class="form-control wd-100" placeholder="高" type="text" id="height" name="height" size="80" value="" onkeyup="">
					    </label>
					    <label><span class="mg-l-10"></span></label>		
				   </div>
				   <div class="row flex-row align-items-center mg-b-15" id="">
					   	<label class="left-fn-title wd-100" id="">屏幕类型：</label>
					   	<label class="wd-content-ckx d-flex " id="">
					   		<label class="ckbox mg-r-15">
					   			<input type="checkbox" value="1" id="rr1" name="screentype">
					   			<span for="rr1">平板电视拼接</span>
					   		</label>
							<label class="ckbox mg-r-15">
								<input type="checkbox" value="2" id="rr2" name="screentype">
								<span for="rr2">LED拼接屏</span>
							</label>
							<label class="ckbox mg-r-15">
								<input type="checkbox" value="3" id="rr3" name="screentype">
								<span for="rr3">投影</span>
							</label>
						</label>
				   </div>
		        </div>
        	</div>
        </div>
    </div><!-- br-mainpanel -->
    
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
<input type="hidden" name="screenhtml" id="screenhtml" value="">
<input type="hidden" id="RecommendGlobalID" name="RecommendGlobalID" value="0">
<input type="hidden" name="RecommendChannelID" value="0">
<input type="hidden" name="RecommendItemID" value="0">
<input type="hidden" name="NoCloseWindow" id="NoCloseWindow" value="0">
<input type="hidden" name="ContinueNewDocument" value="<%=ContinueNewDocument%>">
<input type="hidden" id="RecommendType" name="RecommendType" value="0"><div id="ajax_script" style="display:none;"></div>
</form>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<%if(channel.getDocumentJS().length()>0){out.println("<script>");out.println(channel.getDocumentJS());out.println("</script>");}%>
<script type="text/javascript">
var form_data = $("#form").serialize();//获取表单数据
<%if(Parent>0){
out.println("setValue('Parent',"+Parent+");");
}%>
</script>

<!--兼容性提示弹窗-->
<div class="editorTipsModal modal" id="editorTipsModal" >
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close">×</button>
				<h4 class="modal-title" id="myModalLabel">系统提示</h4>
			</div>
			<div class="modal-body">
				<p>系统检测到您正在使用低版本浏览器，为保证您的正常使用，请升级浏览器到最新版本。</p>
				<p>推荐使用浏览器：谷歌浏览器，其他浏览器及版本：360浏览器最新版、IE9及以上版本。</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default btn-close" data-dismiss="modal">关闭</button>				
			</div>
		</div>
	</div>
</div>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../lib/2018/medium-editor/medium-editor.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script type="text/javascript" src="../common/jquery-ui-timepicker-addon.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>
    var oldTitle = "<%=oldTitle%>";
    var oldWidth = "<%=oldWidth%>";
    var oldHeight = "<%=oldHeight%>";
    var oldScreentype = "<%=oldScreentype%>";

  $(function(){
        reloadSource();
        reloadScreen();
        $("#Title").val(oldTitle);
        $("#width").val(oldWidth);
        $("#height").val(oldHeight);
        if(oldScreentype!=""){
            var arr = oldScreentype.split(",");
            var checkBoxAll = $("input[name='screentype']");
            for(var i =0;i<arr.length;i++){
                for(var n=0;n<checkBoxAll.size();n++){
                    if(arr[i]==$(checkBoxAll.get(n)).val()){
                        $(checkBoxAll.get(n)).attr("checked",true);
                    }
                }
            }
        }
     'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function(e){
          e.preventDefault();
          if($('body').hasClass('show-mb-left')) {
            $('body').removeClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
          } else {
            $('body').addClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
          }
        });
 
        $('.br-sideleft [data-toggle="tooltip"]').tooltip({
       	  shadowColor:"#ffffff",
       	  textColor:"000000",
       	  trigger:"hover"
       	});
           
             	
  });

</script>

<script>
	//h5编辑器相关
	var everLoadH5 = false ;
	$("#tr_changeEditor input[name='editortype']").click(function(){
		var val = $(this).val();
		if(val==0){
			$("#tr_h5Editor").hide();
			$("#tr_Content").show();
			setContent(h5_getContent());
			h5_setContent("");
		}else{
			if(!everLoadH5){
				var _html = '<iframe id="h5editor1_Frame" src="../h5/index.html?webname=${pageContext.request.contextPath}" width="100%" height="800" frameborder="0" scrolling="no" onload="inserBdContent()" ></iframe>' ;
				$("#tr_Content").hide();
				$("#tr_h5Editor").html(_html).show();				
				everLoadH5 = true ;
			}else{
				$("#tr_h5Editor").show();
				$("#tr_Content").hide();
				h5_setContent(getContent());
				setContent("");
			}
//			var h5ue = document.getElementById("h5editor1_Frame").contentWindow.WXBEditor
//			h5ue.ready(function() {
//			   h5_insertContent(getContent());
//			});
		}
	})
	
	
	function inserBdContent(){
		var _interval = setInterval(function(){
			try
			   {
			     var h5ue = document.getElementById("h5editor1_Frame").contentWindow.WXBEditor ;
			     if(h5ue){
			     	h5ue.ready(function() {
				   		h5_setContent(getContent());
						setContent("");
	 			    });
	 			    clearInterval(_interval)
			     }else{
			     	return ;
			     }
			   }
			 catch(err)
			   {			  
			   }
		},50)
	}
	//获得h5编辑器内容
	function h5_getContent(){
		var content = document.getElementById("h5editor1_Frame").contentWindow.getUecontent();
		return content;		
	}	
	//h5编辑器写入内容
	function h5_setContent(insertContent,b){
		document.getElementById("h5editor1_Frame").contentWindow.setCurrentContent(insertContent,true);
	}
	//h5编辑器插入内容
	function h5_insertContent(insertContent,b){
		document.getElementById("h5editor1_Frame").contentWindow.setInsertContent(insertContent,true);
	}
$(function() {
	//判断是否为ie8及以下浏览器
	var DEFAULT_VERSION = 8.0;
	var _ua = navigator.userAgent.toLowerCase();
	var _isIE = _ua.indexOf("msie")>-1;
	var browserVersion;
	if(_isIE){
		browserVersion =  _ua.match(/msie ([\d.]+)/)[1];
	}
	if(browserVersion <= DEFAULT_VERSION ){
		$('#editorTipsModal').show().css("opacity",1)
	};   
    $(".editorTipsModal .btn-close,.editorTipsModal button.close").click(function(){
    	$('#editorTipsModal').hide().css("opacity",0)
    })
});
</script>
</body>
</html>

