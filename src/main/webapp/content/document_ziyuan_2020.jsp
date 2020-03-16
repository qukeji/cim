<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.JSONObject,
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

	int item_type=0;
	String Extra = "";


	int GlobalID					= 0;
	String QRcode					= "";
	String title = "";
	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}

	int eci = CmsCache.getParameter("editor_content_images").getIntValue();//图片自动本地化 0否1是

	Document item = null;
	Channel channel = CmsCache.getChannel(ChannelID);
	if(channel.getDocumentProgram().length()>0 && uri.endsWith("/content/document.jsp") )
		response.sendRedirect(channel.getDocumentProgram()+"?ChannelID="+ChannelID+"&ItemID="+ItemID+"&ROutTarget="+ROutTarget+"&ROutChannelID="+RecommendOutChannelID+"&ROutItemID="+RecommendOutItemID);

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
		QRcode = "";//item.getQRCode();
		item_type = item.getIntValue("item_type");
		title = item.getTitle();
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
	int  parent_channel=channel.getParent();

	String media_extra2 = "0";
	if(item!=null){
		media_extra2 = item.getValue("juxian_companyid");
	}else{
		if(channel.getExtra2().startsWith("{\"company\":")){
			JSONObject obj = new JSONObject(channel.getExtra2());

			media_extra2= obj.getString("company");//channel.getExtra2().substring(11, channel.getExtra2().length()-1);
		}
	}

	String SerialNo = channel.getSerialNo();
	int ApproveScheme = channel.getApproveScheme();//是否配置了审核方案
	ApproveScheme approveScheme = new ApproveScheme(ApproveScheme);
	int editable = approveScheme.getEditable();
	int Version = channel.getVersion();//是否开启了版本功能



	ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
	int id_aa = approve.getId();//审核操作id
	int approveId = approve.getApproveId();//审核环节id
	int action	= approve.getAction();//是否通过
	int end = approve.getEndApprove();//是否终审

	int data_approve = 0;//是否显示右侧审核栏
	int data_yl = 0;//是否为审核预览
	System.out.println("审核ID："+id_aa);
	if(id_aa!=0){//说明已配置审核环节
		data_approve=1;
        data_yl=0;
	}
	boolean   isChannelRecommend    =  false; //显示一稿多发内容的开关,默认关闭
	ChannelRecommend cr = new ChannelRecommend();
	List<ChannelRecommend> crlist = cr.getChannelRecommendListByChannelId(ChannelID,1);//获取推荐列表  1为推荐
	if(crlist.size() > 0){
		isChannelRecommend = true;
	}

	Field f_content = channel.getFieldByFieldName("Content");
	boolean has_content = false;//是否有编辑器
	if(f_content!=null&&f_content.getIsHide()==0) has_content = true;
%>
<!DOCTYPE html>
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
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet"  type="text/css" href="../style/jquery.tagit.css" />
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
<link rel="stylesheet"  type="text/css" href="../style/timepicker/jquery-ui-timepicker-addon.css" />
<link rel="stylesheet" href="../style/2018/bracket.css">
<!-- <link rel="stylesheet" href="../static/css/iconfont.css"> -->
<!-- <link rel="stylesheet" href="//at.alicdn.com/t/font_1541250_fnakkmzeb89.css"> -->
<link rel="stylesheet" href="../h5/css/app.d4f1d.css">
<link rel="stylesheet" href="../static/css/document_2020.css">
<style type="text/css">
.wxb-editor-popup-tool span{padding:0 5px;cursor:pointer}
._wxbEditor {position: relative;}
._wxbEditor >.tool-border {position: absolute;top: -5px;left: -5px;width: calc(100% + 10px);height: calc(100% + 10px);border: 1px dashed red;max-width: none!important;z-index: -1;}
.edui-popup .number{position:relative;display:inline-block;padding:0 20px;height:15px}
.edui-popup .number input{position:absolute;top:0;left:0;border:1px solid #fff;background-color:transparent;color:#fff;display:block;width:40px;padding:3px 15px 3px 5px;line-height:14px;border-radius:2px;outline:0;-moz-appearance:textfield}
.edui-popup .number input::-webkit-inner-spin-button,.edui-popup .number input::-webkit-outer-spin-button{-webkit-appearance:none}
.edui-popup .number .next,.edui-popup .number .prev{position:absolute;right:0;display:block;width:15px;height:11px;border:0 solid #fff}
.edui-popup .number .next:after,.edui-popup .number .prev:after{left:4px;width:5px;height:5px;position:absolute;content:"";display:block}
.edui-popup .number .prev{top:0;border-width:0 0 1px 1px}
.edui-popup .number .prev:after{top:4px;border:0 solid #fff;border-width:1px 1px 0 0;transform:rotate(315deg)}
.edui-popup .number .next{bottom:-6px;border-width:0 0 0 1px}
.edui-popup .number .next:after{top:2px;border:0 solid #fff;border-width:1px 1px 0 0;transform:rotate(135deg)}

.editor-icon-list{position:static;bottom:-81px;right:0!important}
.editor-icon-list:after{content:"";display:block;height:0;clear:both;visibility:hidden}
.editor-icon-list>span{float:left;width:43px;height:44px;box-sizing:border-box}
.editor-icon-list>.line{display:flex;width:100%;border-top:1px solid #444;padding:8px 6px}
.editor-icon-list>.line .item{flex:1}
.editor-icon-list>.line .item .text{display:inline-block;margin-right:5px}
.editor-icon-list>.line .item .color-box{display:inline-block;margin-left:5px;width:15px;height:15px;position:relative;top:3px;border:1px solid #444}

/* .edui-default .edui-toolbar .edui-for-icon-swap .edui-default .edui-icon,.wxb-editor-icon-swap{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -390px;width:20px;height:20px}
.edui-default .edui-toolbar .edui-for-justifyleft .edui-default .edui-icon,.wxb-editor-justifyleft{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -750px;width:20px;height:20px}
.edui-default .edui-toolbar .edui-for-justifycenter .edui-default .edui-icon,.wxb-editor-justifycenter{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -690px;width:20px;height:20px}
.edui-default .edui-toolbar .edui-for-justifyright .edui-default .edui-icon,.wxb-editor-justifyright{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -780px;width:20px;height:20px}
.edui-default .edui-toolbar .edui-for-justifyright .edui-default .edui-icon,.wxb-editor-icon-cut{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -360px;width:20px;height:20px}
 */
.wxb-editor-icon-swap{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -390px;width:20px;height:20px}
.wxb-editor-justifyleft{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -750px;width:20px;height:20px}
.wxb-editor-justifycenter{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -690px;width:20px;height:20px}
.wxb-editor-justifyright{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -780px;width:20px;height:20px}
.wxb-editor-icon-cut{background-image:url(../h5/ueditor/utf8-php/themes-custom/default/icon/tool-0201.png);background-position:0 -360px;width:20px;height:20px}

.range-slider{width:100%}.range-slider__max,.range-slider__min{position:absolute;top:25px;width:25px;height:25px;text-align:center;padding:0!important}.range-slider__min{left:0}.range-slider__max{right:0}.range-slider__minus,.range-slider__plus{position:absolute;top:10px;width:12px;height:12px;border:1px solid #aaa;line-height:6px;padding:0!important;font-size:15px}.range-slider__minus{left:6px}.range-slider__plus{right:6px}.range-slider__value{line-height:1;margin-top:8px}

.range-slider__range{-webkit-appearance:none;width:calc(100% - (73px));height:6px;border-radius:3px;background:#fff;outline:0;padding:0;margin:0}
.range-slider__range::-webkit-slider-thumb{-webkit-appearance:none;appearance:none;width:10px;height:10px;border-radius:50%;background:#9fd2f6;cursor:pointer;-webkit-transition:background .15s ease-in-out;transition:background .15s ease-in-out}
.range-slider__range::-webkit-slider-thumb:hover{background:#49a9ee}
.range-slider__range:active::-webkit-slider-thumb{background:#49a9ee}
.range-slider__range::-moz-range-thumb{width:10px;height:10px;border:0;border-radius:50%;background:#49a9ee;cursor:pointer;-webkit-transition:background .15s ease-in-out;transition:background .15s ease-in-out}
.range-slider__range::-moz-range-thumb:hover{background:#49a9ee}
.range-slider__range:active::-moz-range-thumb{background:#49a9ee}
</style>
	<script>
		var eci = <%=eci%>;//图片自动本地化 0否1是
	</script>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<script src="../static/js/document_2020.js"></script>
<script src="../static/js/document_lsh.js"></script>

<script src="../common/tag-it.js"></script>
<%if(has_content){%>
<!--百度编辑器-->
<script type="text/JavaScript" charset="utf-8" src="../ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="../ueditor/ueditor.all.2020.js"></script>
<script type="text/javascript" charset="utf-8" src="../ueditor/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript" charset="utf-8" src="../ueditor/imgeditorDialog.js"></script>
<script type="text/javascript" charset="utf-8" src="../ueditor/imagesDialog.js"></script>
<%}%>
<script>
var ChannelID = "<%=ChannelID%>";
var SerialNo = '<%=SerialNo%>';
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
var editable = <%=editable%>;
//var title = '<%=title%>';
var NoCloseWindow = <%=NoCloseWindow%>;//是否关闭页面
var unload = true ;//关闭页面是否提示

window.onresize = function(){
	if(document.getElementsByClassName("content-edit-frame")[0]){
		if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
			var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.body.scrollHeight ;
		}else{
			var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.documentElement.scrollHeight ;
		}
		document.getElementsByClassName("content-edit-frame")[0].style.height = _height+"px" ;
	}
}
//调整iframe的高度
function changeFrameHeight(_this){
	if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
		_this.style.height = _this.contentWindow.document.body.scrollHeight +40+"px";
	}else{
		_this.style.height = _this.contentWindow.document.documentElement.scrollHeight +40 +"px";
	}
}


</script>

<script>

function Save_approve()
{
	document.form.Approve.value = 1;
	Save();
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

	if(is_auto_save)
	{
		document.getElementById("Image1Href").href = "javascript:void(0);";
		<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
			document.getElementById("Image2Href").href = "javascript:void(0);";
		<%}%>
	}

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

	if(<%=isChannelRecommend%>){  //一稿多发
        var framsId  =  $("iframe[name='oneDocManySend']").attr('id');
        var RecommendChannelIDs = $('#'+framsId)[0].contentWindow.getAllCheck();//选中要一稿多发的channelIdList(a,b,c)
        document.form.RecommendChannelIDs.value = RecommendChannelIDs;
        var WeixinIds = $('#'+framsId)[0].contentWindow.getWxCheck();// 选中的微信公众号id
        document.form.WeixinIds.value = WeixinIds;
	}
	
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
					{	var	dialog = new top.TideDialog();
						dialog.showAlert(result.message,"danger");
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
			dialog.showAlert("保存没有成功，请重新尝试!","danger");

			document.getElementById("Image1Href").href = "javascript:Save();";
			<%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
			document.getElementById("Image2Href").href = "javascript:Save_Publish();";
			<%}%>
		}
     });


	}
}
var Parameter = "&ChannelID=" + channelid;
//本地预览
function Preview2()
{
	window.open("../content/document_preview.jsp?ItemID=<%=ItemID%>" + Parameter);
}
//审核预览
function approve_preview(versionid)
{
	window.open("../content/preview_version.jsp?vid="+versionid+"&ItemID=" + <%=ItemID%> + Parameter);
}
function returnVersion(id){
	    $.ajax({
	        url:"version_data.jsp?id="+id,
	        dataType:"json",
	        success:function(data){
	            $("#Title").val(data.Title);
	            var currcontent = (data.Content).replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;
	            setContent(currcontent,"");
	            $("#Summary").val(data.Summary);
	            tipVersion(data.Title);
	        }
	    });
	}
function tipVersion(title){
	window.alert(title+"版本内容已恢复，请返回内容编辑");
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

//上传图片
function selectImage(fieldname)
{
	var item_type = $("input[name='item_type']:checked").val();
	if(item_type==undefined){
		item_type = 0;
		//alert("请选择列表展现形式");
		ddalert("请选择列表展现形式","(function dd(){getDialog().Close({suffix:'html'});})()");
	}

	var	dialog = new TideDialog();
	dialog.setWidth(900);
	dialog.setHeight(650);
	dialog.setLayer(2);
	dialog.setUrl("../content/insertfile.jsp?photoType="+item_type+"&ChannelID="+channelid+"&Type=Image&fieldname="+fieldname);
	dialog.setTitle("上传图片");
	dialog.show();

}


var curField = 0;


function selectByKeyword()
{
	var ByKeyword = document.getElementById("ByKeyword");
	var ByTitle = document.getElementById("ByTitle");
	document.getElementById("related_doc_list").src = "related_doc_list.jsp?GlobalID=<%=GlobalID%>&ChannelID=<%=ChannelID%>&ByKeyword="+ByKeyword.checked + "&ByTitle="+ByTitle.checked + "&keyword=" + encodeURIComponent(document.form.ByKeywordText.value);
}
function save_(){
    var users   = $("#approve").attr("user");
    var user    = <%=userinfo_session.getId()%>+"";
    var arr     =new Array();
    arr         = users.split(',');

    var result = $.inArray(user, arr);
    if(result == -1){
        tips("当前用户没有权限");
    }else{
        Save();
    }
}
//提示信息
function tips(obj){
    var dialog = new top.TideDialog();
		dialog.setWidth(320);
		dialog.setHeight(280);
		dialog.setTitle("提示");
		dialog.setMsg(obj);
		dialog.ShowMsg();
}

</script>
</head>

<body class="collapsed-menu <%if(!has_content){%>no-content-body<%}%>" id="">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="form" action="../content/document_submit.jsp" method="post" id = "form">

<div class="br-header" id="doc_header">

	 <div id="header_nav">
		
		 <%for (int i = 0; i < fieldGroupArray.size(); i++){
			 FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
			 Extra = fieldGroup.getExtra();
			 //System.out.println("Extra:"+Extra);
		 %>

			 <%if(item_type==6){%>
			 <a href="javascript:showTab('<%=i+1%>')" <%=(Extra.equals("button")?"class='br-menu-link active "+Extra+"'":"class='br-menu-link  "+Extra+"'")%> id="form<%=i+1%>_td" groupid="<%=fieldGroup.getId()%>"  title="<%=fieldGroup.getName()%>">
					 <%} else{%>
			<a href="javascript:showTab('<%=i+1%>')" <%=(i==0?"class='br-menu-link active "+Extra+"'":"class='br-menu-link  "+Extra+"'")%> id="form<%=i+1%>_td" groupid="<%=fieldGroup.getId()%>" title="<%=fieldGroup.getName()%>">
					 <%}%>
				 <div class="br-menu-item">
					 <span class="menu-item-label"><%=fieldGroup.getName()%></span>
				 </div><!-- menu-item -->
			 </a><!-- br-menu-link -->
		 <%}%>

		 <%
			 int vercount = (!QRcode.equals(""))?fieldGroupArray.size()+1:fieldGroupArray.size();
			 if(Version==1){
				 vercount = vercount+1 ;
		 %>
			 <a href="javascript:showTab('<%=vercount%>')" class="br-menu-link" id="form<%=vercount%>_td"  title="历史版本">
				 <div class="br-menu-item">
					 <span class="menu-item-label">历史版本</span>
				 </div><!-- menu-item -->
			 </a><!-- br-menu-link -->
		 <%
			 }
			 if(isChannelRecommend){
				 vercount = vercount+1 ;
		 %>
			 <a href="javascript:showTab('<%=vercount%>')" class="br-menu-link" id="form<%=vercount%>_td"  title="一稿多发">
				 <div class="br-menu-item">
					 <span class="menu-item-label">一稿多发</span>
				 </div><!-- menu-item -->
			 </a><!-- br-menu-link -->
		 <%
			 }
		 %>
	 </div>

	<div class="br-header-right">
		<div class="btn-box" >
				<%if(ApproveScheme==0||(action==1||id_aa==0)||ItemID==0){%>
			<a class="btn btn-primary btn-sm  mg-r-5" href="javascript:Save();" id="Image1Href">保存</a>
			<%if(ApproveScheme!=0){%>
				<a class="btn btn-primary btn-sm mg-r-5" id="Image2Href" href="javascript:Save_approve();">提交审核</a>
			<%}else{
				if(cp.hasRight(userinfo_session,ChannelID,3)){%>
					<a class="btn btn-primary btn-sm mg-r-5" id="Image2Href" href="javascript:Save_Publish();">保存并发布</a>
			<%}}}else{%>
				<a class="btn btn-primary btn-sm mg-r-5" href="javascript:save_();" id="imageHrefJurisdiction">保存</a>
			   	<%if(channel.getChannelTemplates(2).size()!=0){%>
				<a class="btn btn-primary btn-sm  mg-r-5" href="javascript:Preview2()">本地预览</a>
				<%}%>
				<%if(end!=1){%>
				<a class="btn btn-primary btn-sm mg-r-5" href="javascript:SaveApprove(1);"  id="Image1Href">驳回</a>
				<a class="btn btn-primary btn-sm mg-r-5" href="javascript:SaveApprove(0);"  id="Image2Href">通过</a>
				<%}%>
			<%}%>
			<a class="btn btn-primary btn-sm" href="javascript:self.close();window.opener.document.location.reload();">关闭</a>
		</div>
	</div><!-- br-header-right -->
</div><!-- br-header -->

<div class="" id="doc_main">
<%
int j = 0;

//String url_button="";
do{
	String  padding="";
	FieldGroup fieldGroup = null;//字段分组
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
	if(fieldGroupID>0 && !fieldGroup.getUrl().equals(""))
	{
		padding="clear-padding";
	}else{
		padding="";
	}
//	if(j==2){
//		url_button=url;
//	}
	Extra = fieldGroup.getExtra();
	String src = "../null.jsp";
    String form_other = (j!=0?"style=\"display:none;\"":"")+(j==0?"data-approve="+data_approve+" data-yl="+data_yl:"");

	if(item_type==6){
		out.println("<div class=\"br-mainpanel\" url=\""+url+"\" id=\"form"+(j+1)+"\""+(!Extra.equals("button")?" style=\"display:none;\">":">"));
		if(Extra.equals("button")){
			src = url ;
		}
	}else{
		out.println("<div class=\"br-mainpanel\" url=\""+url+"\" id=\"form"+(j+1)+"\" "+form_other+">");
	}

	if(fieldGroupID>0 && !fieldGroup.getUrl().equals(""))
	{
		out.println("<iframe id=\"iframe"+(j+1)+"\" class=\"content-edit-frame\" frameborder=\"0\" style=\"width:100%;min-height:500px;height:100%;\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"auto\" src=\""+src+"\" onload=\"changeFrameHeight(this)\" ></iframe>");
	}
	else
	{
		//has_content 是否有编辑器
%>

	<%if(j==0){%>

		<%if(has_content){%>

		<div id="main_left"> </div>

		<div id="main_content" class="edit">
			<div class="editor-about">
				<input type="hidden" id="baiduEditor1" name="baiduEditor1" value="" style="display:none" />
				<script id="editor" type="text/plain" style="width:100%;"></script>
				<script type="text/javascript">
					var currcontent = "";
					<%if(item!=null){
						item.setCurrentPage(1);%>
					currcontent = '<%=Util.JSQuote(item.getContent().replaceAll(outer_url,inner_url))%>';
					<%if(!SiteAddress.equals("")){%>
					currcontent = currcontent.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;
					<%}%>
					$("#baiduEditor1").val(currcontent);
					<%}%>
					var ChannelID=<%=ChannelID%>;
				
					var ue = UE.getEditor('editor',{
						autoHeightEnabled:false
					});
					ue.ready(function() {
						ue_ready();
					});
				</script>
			</div>
			<div class="editor-page">
				<table id="tabTable" CELLPADDING=0 CELLSPACING=0 class="table table-bordered mg-b-0">
					<tr id="tabTableRow" onclick="changeTabs()">
						<td id="t1" class="selTab" page="1" height="20">第1页</td>
					</tr>
				</table>
				<input type="button" value="删除当前页" onclick="DeletePage();" class="btn btn-primary btn-sm tx-size-xs mg-x-10 mg-t-10">
				<input type="button" value="插入一页" onclick="AddPage();" class="btn btn-primary btn-sm tx-size-xs mg-r-10 mg-t-10">
			</div>
		</div>
		<%}%>
	<%}%>
		<div id="<%if(j==0){%>main_right<%}%>" class="<%=padding%> <%if(!has_content||j!=0){%>no-content<%}%> <%if(j==0){%>main_right<%}else{%>others-group<%}%>">
			<div class="main_right_box">
				<div class="r-container">


			<%
				Field field_title = channel.getFieldByFieldName("Title");
			%>
				<div class="article-title" >
			<%if(j==0){%>
				<div class="row flex-row align-items-center mg-b-15" id="tr_<%=field_title.getName()%>">
					  <label class="left-fn-title wd-150 " id="tr_Title"><%=field_title.getDescription()%>：</label>
					  <label class="wd-content-lable d-flex" id="field_Title">
						<input class="form-control" placeholder="" type="text" id="Title" name="Title" size="80" value="<%=item!=null?Util.HTMLEncode(item.getValue("Title")):""%>" onkeyup="checkTitle();">
					  </label>
					  <label><span id="TitleCount" class="mg-l-10"></span></label>
					<%
						if(field_title.getJS().length()>0)
						{
							out.println("<script>"+field_title.getJS()+"</script>");
						}
					%>
					<%if(editCategory){%>
						<label class="left-fn-title wd-60 ">分类：</label>
						<select class="form-control wd-230 ht-40 select2" name="ChannelID" id="ChannelID">
						<%ArrayList categorys = channel.listAllSubChannels(Channel.Category_Type);
						if(categorys!=null && categorys.size()>0){
							for(int i = 0;i<categorys.size();i++){
								Channel subcategory = (Channel)categorys.get(i);%>
							<option value="<%=subcategory.getId()%>" <%=(item!=null&&subcategory.getId()==item.getCategoryID())?"selected":""%>><%=subcategory.getName()%></option>
							<%}
						}%>
						</select>
					<%}%>
		   		</div>
		   <%if(!field_title.getCaption().equals("")){%>
				<div class="row mg-t--10">
					<label class="left-fn-title wd-150"> </label>
					<label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
						</i><%=field_title.getCaption()%>
					</label>
				</div>
			<%}%>
			<%}%>

<%
ArrayList arraylist = channel.getFieldsByGroup(fieldGroupID,j);
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

<%}else if(field.getFieldType().equals("label")){%>

		<div class="row flex-row align-items-center mg-b-15" id="tr_<%=field.getName()%>">
			<%if(!field.getFieldType().equals("label")){%>
			<label class="left-fn-title wd-150 "><%=field.getDescription()%>：</label>
			<%}%>
			<label class="wd-content-lable d-flex"><%=field.getOther()%></label>
		</div>
		<%if(!field.getCaption().equals("")){%>
		<div class="row mg-t--10">
			<label class="left-fn-title wd-150"> </label>
			<label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
				</i><%=field.getCaption()%>
			</label>
		</div>
		<%}%>
<%}else{%>
	<%if(field.getName().equals("PublishDate")){%>
		<div class="row flex-row align-items-center mg-b-15" id="tr_<%=field.getName()%>">
			<label class="left-fn-title wd-150 "><%=field.getDescription()%>：</label>
			<label class=""><%=field.getDisplayHtml_(item!=null?item.getPublishDate():Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"))%>  <%=channel.getFieldByFieldName("Weight").getDisplayHtml_(item!=null?item.getWeight()+"":"")%></label>
		</div>
		<%if(!field.getCaption().equals("")){%>
		<div class="row mg-t--10">
			<label class="left-fn-title wd-150"> </label>
			<label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
				</i><%=field.getCaption()%>
			</label>
		</div>
		<%}%>
	<%}else if(field.getName().equals("Keyword2")){%>
		<div class="row flex-row align-items-center mg-b-15" id="tr_<%=field.getName()%>">
			<label class="left-fn-title wd-150 "><%=field.getDescription()%>：</label>
			<label class="wd-content-lable d-flex">
				<%=field.getDisplayHtml_(item!=null?item.getValue(field.getName()):"")%>
				<input name="kewwordselect" type="button" class="btn btn-primary tx-size-xs mg-r-5" value="按关键词选择" onclick="selectByKeyword2()">
			</label>
		</div>
		<%if(!field.getCaption().equals("")){%>
		<div class="row mg-t--10">
			<label class="left-fn-title wd-150"> </label>
			<label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
				</i><%=field.getCaption()%>
			</label>
		</div>
		<%}%>
		<div class="row flex-row align-items-center mg-b-15">
			<label class="left-fn-title wd-150 ">相关视频：</label>
			<label class="wd-content-lable d-flex">
				<iframe id="related_video_list" frameborder="0" height="400" width="650" marginheight="0" marginwidth="0" scrolling="auto" src="../video/related_video_list.jsp?id=<%=ItemID%>&ChannelID=<%=ChannelID%>"></iframe>
			</label>
		</div>
		<%}else{
			out.println(field.getDisplayHtml2018(item));
		}%>
	<%}%>
			<%}
		}%>
		
				</div> <!--对应article-title -->
				<%if(j==0){%>
				<div class="r-c-others">
				</div>
				<%}%>
				</div> <!--对应r-container -->
			</div> <!--对应main_right_box -->
		</div><!--对应main_right-->
<%}%>

<%
		out.println("</div>");//对应form1 div
		j++;
}while(j < fieldGroupArray.size());%>


<%
int vercount1 = (!QRcode.equals(""))?fieldGroupArray.size()+1:fieldGroupArray.size();
if(Version==1){
	vercount1 = vercount1+1 ;
%>
	<div class="br-mainpanel br-mainpanel-file overflow-hidden" <%if(j!=0){%>style="display:none;"<%}%> url="" id="form<%=vercount1%>">
		<iframe id="content_historical_version" class="content-edit-frame" style="width:100%;min-height:960px;height:100%;"
				frameborder="0" marginheight="0" marginwidth="0" scrolling="auto" src="content_historical_version.jsp?GlobalID=<%=GlobalID%>">
		</iframe>
	</div>
<%
}
if(isChannelRecommend) {
	vercount1 = vercount1 + 1;
%>
	<div class="br-mainpanel br-mainpanel-file overflow-hidden"   <%if(j!=0){%>style="display:none;"<%}%> url="" id="form<%=vercount1%>">
		<iframe id="oneDocManySend" name ="oneDocManySend" class="content-edit-frame" style="width:100%;min-height:600px;"
				frameborder="0" marginheight="0" marginwidth="0" scrolling="auto"
				src="../recommend/content_multiple.jsp?GlobalID=<%=GlobalID%>&ChannelID=<%=ChannelID%>&ItemID=<%=ItemID%>" onload="changeFrameHeight(this)"></iframe>
	</div>
<%
}
%>
</div><!--对应doc_main div -->

<input type="hidden" name="From" value="<%=From%>">
<input type="hidden" name="Action" value="Add">
<input type="hidden" name="Content" value="">
<input type="hidden" id="ItemID" name="ItemID" value="<%=ItemID%>">
<%if(!editCategory){%><input type="hidden" name="ChannelID" value="<%=ChannelID%>"><%}%>
<input type="hidden" name="Status" value="0">
<input type="hidden" name="Approve" value="0">
<input type="hidden" id="GlobalID" name="GlobalID" value="<%=GlobalID%>">
<input type="hidden" name="ParentGlobalID" value="<%=parentGlobalID%>">
<input type="hidden" name="RelatedItemsList" value="">
<input type="hidden" name="Page" value="1">
<input type="hidden" id="RecommendGlobalID" name="RecommendGlobalID" value="0">
<input type="hidden" name="RecommendChannelID" value="0">
<input type="hidden" name="RecommendItemID" value="0">
<input type="hidden" name="NoCloseWindow" id="NoCloseWindow" value="0">
<input type="hidden" name="ContinueNewDocument" value="<%=ContinueNewDocument%>">
<input type="hidden" id="RecommendType" name="RecommendType" value="0">
<input type="hidden" id="RecommendChannelIDs" name="RecommendChannelIDs" value="">
<input type="hidden" id="WeixinIds" name="WeixinIds" value="">
<div id="ajax_script" style="display:none;"></div>
</form>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<%if(channel.getDocumentJS().length()>0){out.println("<script>");out.println(channel.getDocumentJS());out.println("</script>");}%>
<script type="text/javascript">
var form_data = $("#form").serialize();//获取表单数据
<%if(Parent>0){
out.println("setValue('Parent',"+Parent+");");
}%>
</script>


<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>

<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script type="text/javascript" src="../common/jquery-ui-timepicker-addon.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>
	var groupnum=<%=vercount%>;
  $(function(){
 	    'use strict';
		
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

$(function() {
	
    //加帮助指南的问号
    var helpHtml = '<a href="../help/content.html" target="_blank" class="list-type-explain valign-middle tx-gray-900 mg-l-10" data-toggle="tooltip" data-placement="top">'+
          	     '<i class="icon ion-help-circled tx-18"></i></a>'
    $("#desc_item_type").append(helpHtml);
	//初始化赋值聚现企业编号
    var media_extra2= "<%=media_extra2%>";
    $('#juxian_companyid').val(media_extra2);

    if($('#mediatype_1').attr('checked') == 'checked'){
		document.getElementById("tr_td_liveid").style.display="none";
	}
	$('#tr_mediatype input[type=radio]').change(function() {
        if($("#mediatype_1").is(":checked")){
			document.getElementById("tr_td_liveid").style.display="none";
		}else{
			document.getElementById("tr_td_liveid").style.display="";
		}
	})
});



$.getScript("../static/js/controlfield.js");

function getSecondcategoryList(ChannelID,fieldName){
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(400);
		dialog.setUrl("../content/secondcategoryList.jsp?ChannelID="+ChannelID+"&fieldName="+fieldName);
		dialog.setTitle('选择');
		dialog.show();
}
function getListHref(ChannelID,fieldName,TargetName){
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(400);
		dialog.setUrl("../content/listHref.jsp?ChannelID="+ChannelID+"&fieldName="+fieldName+"&TargetName="+TargetName);
		dialog.setTitle('选择');
		dialog.show();
}

</script>
<!--<%="执行时间:"+(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
