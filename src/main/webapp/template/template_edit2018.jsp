<%@ page import="java.io.File,
				tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int TemplateID = getIntParameter(request,"TemplateID");

TemplateFile tf = CmsCache.getTemplate(TemplateID);

String syntax = "html";
String fileExt = Util.getFileExt(tf.getFileName());
if(fileExt.equals("xml"))
	syntax = "xml";
else if(fileExt.equals("js"))
	syntax = "js";
//System.out.println("content:"+tf.getContent());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
    <title><%=tf.getGroupTree() + tf.getFileName() + "(" + tf.getName() + ")"%></title>   
     <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
       
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
    <!-- vendor css -->
    <script src="../lib/2018/jquery/jquery.js"></script>
	<script type="text/javascript" src="../common/2018/common2018.js"></script>
	<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<script>
var startTime,endTime;
var d=new Date();
startTime=d.getTime(); 

function showm(s)
{
	d=new Date();endTime=d.getTime();
	tools.log(s+((endTime-startTime)/1000));
	//$("#message3").html($("#message3").html()+","+s+((endTime-startTime)/1000)+"");
}
function showm2(s)
{
	$("#message2").html($("#message2").html()+" "+s);
}
function editAreaLoaded(id){
			d=new Date();endTime=d.getTime();
			//$("#message").html(((endTime-startTime)/1000)+"秒");
			$("#message").html($("#message").html()+","+((endTime-startTime)/1000)+"");
		}

</script>	
<script ID="clientEventHandlersJS" LANGUAGE="javascript">
//editor.getSession().setMode("ace/mode/jsp");
var pattern = "";
var oldContent;
function onDownloadDone(s)
{
  ace_editor.value=s;
  oldContent = s;
}

function insertText(text)
{
	editor.insert(text);
}

function InsertCode(i)
{    
      selectedText =editor.session.getTextRange(editor.getSelectionRange());
	//selectedText = editAreaLoader.getSelectedText("CodeArea");
	//alert(selectedText);
	/*
	if(document.selection)
	{
		var range = document.selection.createRange();
		selectedText = range.text;
	}
	else
	{
		
	}*/
	
	if(i==126)
		insertText("$channel.getName()");
	else if(i==127)
		insertText("$channel.getSerialNo()");
	else if(i==31)
		insertText("$category.getName()");
	else if(i==32)
		insertText("$category.getSerialNo()");


	else if(i==211)
		insertText("$item.getTitle()");
	else if(i==212)
		insertText("$item.getContent()");
	else if(i==213)
		insertText("$item.getHref()");
	else if(i==214)
		insertText("$item.FormatDate(\"yyyy年MM月dd日\",$item.getPublishDate())");
	else if(i==215)
		insertText("$item.getValue(\"Photo\")");
	else if(i==216)
		insertText("$item.getValue(\"DocFrom\")");
	else if(i==217)
		insertText("$item.getValue(\"\")");
	else if(i==218)
		insertText("$item.getFullHref()");
	else if(i==219)
		insertText("$item.getTitle($TitleWord)");
	else if(i==220)
		insertText("$item.getGlobalID()");
	else if(i==201)
		insertText("$item.getId()");
	else if(i==202)
		insertText("\r\n<script type=\"text/javascript\">item_info = window.item_info || {\r\n	title:\"$util.JSQuote($item.getTitle())\",\r\n	url:\"$util.JSQuote($item.getHttpHref())\",		\r\n	photo:\"$util.JSQuote($item.getValue('Photo'))\",		\r\n	summary:\"$util.JSQuote($item.getSummary())\",\r\n	channelcode:\"$item.getChannel().getChannelCode()\"\r\n}<\/script>");
	else if(i==203)
		insertText("\r\n备注：根据文档的globalid关联子频道的Parent字段，14184是子频道编号\r\n#foreach($subitem in $item.listChildItems(14184))\r\n$subitem.getTitle()\r\n#end");


	else if(i==441)
		insertText("#if()\r\n"+selectedText+"\r\n#end");
	else if(i==442)
		insertText("#if()\r\n#else\r\n#end");
	else if(i==143)
		insertText("#foreach( $item in $Controller.listItems())\r\n"+selectedText+"\r\n#end");
	else if(i==44)
		insertText("#foreach( $item in $Controller.listCategoryItems())\r\n"+selectedText+"\r\n#end");
	else if(i==445)
		insertText("#if($Controller.hasPrevious())\r\n<a href=\"$Controller.getPrevPageHref()\">上一页</a>\r\n#end");
	else if(i==446)
		insertText("#if($Controller.hasNext())\r\n<a href=\"$Controller.getNextPageHref()\">下一页</a>\r\n#end");
	else if(i==147)
		insertText("#foreach( $item in $Controller.listTopItems(5))\r\n"+selectedText+"\r\n#end");
	else if(i==48)
		insertText("#foreach( $item in $Controller.listTopCategoryItems($category.getId(),5))\r\n"+selectedText+"\r\n#end");
	else if(i==149)
		insertText("#foreach( $item in $Controller.listTopItems($rows))\r\n"+selectedText+"\r\n#end");
	else if(i==401)
		insertText("#foreach( $item in $Controller.listTopCategoryItems($category.getId(),$rows))\r\n"+selectedText+"\r\n#end");

	else if(i==501)
		insertText("<!--#Include virtual=\"\" -->");
	else if(i==502)
		ace_editor.value = ace_editor.value.replace(/<!--#include/g,"<!--#Include");
	else if(i==503)
		insertText("<!-- TideCMS Module -->");
	else if(i==454)
		insertText('\r\n#set($total=$Controller.getPageNumber())\r\n#if($total>1)\r\n<a href="$Controller.getPageHref(1)">首页</a>\r\n#if($Controller.hasPrevious())\r\n<a href="$Controller.getPrevPageHref()">上一页</a>\r\n#end\r\n#set($page_sum=5)\r\n#set($page=$page_sum/2)\r\n#set($begin=$Controller.getCurrentPage()-$page)\r\n#set($end=$Controller.getCurrentPage()+$page)\r\n#if($begin<1)#set($begin=1)#end\r\n#set($temp=$end - $begin)\r\n#if($temp<($page_sum - 1))\r\n#set($temp=$page_sum - $temp - 1)\r\n#set($end=$end+$temp)\r\n#end\r\n#if($end>$total)\r\n#set($temp=$end - $total)\r\n#set($begin=$begin - $temp)\r\n#set($end=$total)\r\n#if($begin<1)\r\n#set($begin=1)\r\n#end\r\n#end\r\n#if($total<=$page_sum)\r\n#set($begin=1)\r\n#set($end=$total)\r\n#end\r\n#foreach($foo in [$begin..$end])\r\n#if($foo==$Controller.getCurrentPage())\r\n<a style="color:red;">$foo</a>\r\n#else<a href="$Controller.getPageHref($foo)">$foo</a>\r\n#end\r\n#end\r\n#if($Controller.hasNext())<a href="$Controller.getNextPageHref()">下一页</a>\r\n#end\r\n<a href="$Controller.getPageHref($total)">末页</a>\r\n#end');
	else if(i==455)
		insertText('\r\n#set($total=$item.getTotalPage())\r\n#if($total>1)\r\n#set($cur=$item.getCurrentPage())#if($cur>1)\r\n<a href="$item.getPrevDocPageHref()">上一页</a>\r\n#else\r\n<a>上一页</a>\r\n#end\r\n#set($page_sum=5)\r\n#set($page=$page_sum/2)\r\n#set($begin=$cur - $page)\r\n#set($end=$cur+$page)\r\n#if($begin<1)\r\n#set($begin=1)\r\n#end\r\n#set($temp=$end - $begin)\r\n#if($temp<($page_sum - 1))\r\n#set($temp=$page_sum - $temp - 1)\r\n#set($end=$end+$temp)\r\n#end\r\n#if($end>$total)\r\n#set($temp=$end - $total)\r\n#set($begin=$begin - $temp)\r\n#set($end=$total)\r\n#if($begin<1)\r\n#set($begin=1)\r\n#end\r\n#end\r\n#if($total<=$page_sum)\r\n#set($begin=1)\r\n#set($end=$total)\r\n#end\r\n#foreach($foo in [$begin..$end])\r\n#if($foo==$cur)\r\n<a>$foo</a>\r\n#else\r\n<a href="$item.getDocPageHref($foo)">$foo</a>\r\n#end\r\n#end\r\n#if($cur<$total)\r\n<a href="$item.getNextDocPageHref()">下一页</a>\r\n#else\r\n<a>下一页</a>\r\n#end\r\n#end');
	else if(i==456)
		insertText('<a href="$item.getValue(\'Href\')" title="$item.getHtmlTitle()" target="_blank"><img src="$item.getValue(\'Photo\')" alt="$item.getHtmlTitle()" title="$item.getHtmlTitle()"/></a>');
	else if(i==457)
		insertText('<a href="$item.getFullHref()" title="$item.getHtmlTitle()" target="_blank"><img src="$item.getValue(\'Photo\')" alt="$item.getHtmlTitle()" title="$item.getHtmlTitle()"/></a>');
	else if(i==458)
		insertText('<a href="$item.getValue(\'Href\')" title="$item.getHtmlTitle()" target="_blank">$item.getTitle()</a>');
	else if(i==459)
		insertText('<a href="$item.getFullHref()" title="$item.getHtmlTitle()" target="_blank">$item.getTitle()</a>');
	else if(i==160)
		insertText('#foreach( $item in $Controller.listTopPhotoItems($rows))\r\n#end');
	else if(i==161)
		insertText('#foreach( $item in $Controller.listTopItems($rows,true))\r\n#end');
	else if(i==162)
		insertText('\r\n#set($items= $Controller.listTopItems(10))\r\n#foreach( $item in $util.getArray($items,1,2))\r\n#end');
	else if(i==163)
		insertText('$channel.getExtra1()');
	else if(i==164)
		insertText('$channel.getExtra2()');
	else if(i==465)
		insertText('\r\n#set($i=1)\r\n#foreach( $subchannel in $channel.getParentTree() )\r\n#if($i>1)<a href="$subchannel.getFullPath()/">$subchannel.getName()</a> &gt;#end\r\n#set($i=$i+1)\r\n#end');
	else if(i==466)
		insertText('\r\n#set($allchannels=$channel.listSubChannels())\r\n#foreach($subchannel in $allchannels)\r\n#set($name=$subchannel.getName())\r\n$Controller.setChannel($subchannel)\r\n#foreach( $item in $Controller.listTopItems(6))\r\n<a href="$item.getValue(\'Href\')" title="$item.getHtmlTitle()" target="_blank">$item.getTitle()</a>\r\n#end\r\n#end');
	else if(i==504)
		insertText('#if($item.getPrevItemID()>0)\r\n#set($previtem=$item.getPrevDocument())\r\n>上一篇<a href="$previtem.getFullHref()" title="$previtem.getHtmlTitle()" target="_blank">$previtem.getTitle()</a>\r\n#end\r\n\r\n#if($item.getNextItemID()>0)\r\n#set($nextitem=$item.getNextDocument())\r\n>下一篇<a href="$nextitem.getFullHref()" title="$nextitem.getHtmlTitle()" target="_blank">$nextitem.getTitle()</a>\r\n#end\r\n\r\n$Controller.publishPrevNextDoc($PublishPrevNextDoc)\r\n');
	else if(i==505)
		insertText('{"id":"$item.getId()","title":"$util.JSONQuote($item.getTitle())","datetime":"$item.FormatDate("yyyy-MM-dd HH:mm:ss",$item.getPublishDate())","pics":[\r\n#set($i=0)\r\n#foreach($subitem in $item.listChildItems(14184))\r\n#if($i>0),#end\r\n#set($i=$i+1)\r\n{"title":"$subitem.getTitle()","summary":"$subitem.getValue("Summary")","photo":"$subitem.getValue("Photo")","photo_m":"$subitem.getValue("Photo_m")","photo_s":"$subitem.getValue("Photo_s")"}\r\n#end\r\n]}');
//	else if(i==6)
//		insertText("#if\r\n"+range.text+"\r\n#end";
	//code.focus();
}


function Template_Script(){
  ace_editor.focus();
  var range = document.selection.createRange();
  var script = "<!--%\r\n%-->" + range.text;
  insertText(script);
}

function save() {
  var text = editor.getValue();

// if(editor_mode=="0")
//	  text = $("#CodeArea").val();
//  else
//	  text = editAreaLoader.getValue("CodeArea");

  if (text.replace(/\s/g,"") == "") {
    alert("当前文件内容为空。");
    return;
    }
	
	$("#message").html("<font color='red'><b>正在保存...</b></font>");
	jQuery.ajax({
	 type:"POST",
	 url:"save.jsp",
	 data:"TemplateID=<%=TemplateID%>&filecontent="+encodeURIComponent(text),
	 success:function(msg){
		 $("#message").html("<font color='red'><b>保存完成.</b></font>");
		 setTimeout("$('#message').html('');",2000*1);
	 } 
	}); 

}

function ChangeCharset(obj)
{
	if(obj!=null)
	{
		this.location = "notepad.jsp?FolderName=&FileName=&Charset=" + obj.value;
	}
}

function InsertItem(obj)
{
	if(obj!=null)
	{
		var i = obj.value;
		obj.value = "0";
		InsertCode(i);
	}
}

function init() {
	fixSize();
	window.onresize = fixSize;
	init2();
}

function init2()
{
//	if(top.editor_mode=="1")
//	{
		showm("starta");
		top.eAL.start(area_id);
		eA.init();
//	}
}

function fixSize() {
//	if(editor_mode=="0")
//	{
		var o = $("#CodeArea");
		var h = Math.max(document.body.clientHeight - 35, 0);
		//window.console.info(h);
		o.css("height",h);
//	}
//	if(editor_mode=="1")
//	{
		o = $("#frame_CodeArea");
		h = Math.max(document.body.clientHeight - 35, 0);
		o.css("height",h);
//	}
	//CodeArea.style.height = 600;
}

function Help()
{
	window.open("../docs/controller.html");
}

function editTab()
{
	var code, sel, tmp, r
	var tabs=""
	event.returnValue = false
	sel =event.srcElement.document.selection.createRange()
	r = event.srcElement.createTextRange()

	switch (event.keyCode)
	{
		case (9)	:				
			if (sel.getClientRects().length > 1)
			{
				code = sel.text
				tmp = sel.duplicate()
				tmp.moveToPoint(r.getBoundingClientRect().left, sel.getClientRects()[0].top)
				sel.setEndPoint("startToStart", tmp)
				sel.text = "\t"+sel.text.replace(/\r\n/g, "\r\t")
				code = code.replace(/\r\n/g, "\r\t")
				r.findText(code)
				r.select()
			}
			else
			{
				sel.text = "\t"
				sel.select()
			}
			break
		case (13)	:
			tmp = sel.duplicate()
			tmp.moveToPoint(r.getBoundingClientRect().left, sel.getClientRects()[0].top)
			tmp.setEndPoint("endToEnd", sel)

			for (var i=0; tmp.text.match(/^[\t]+/g) && i<tmp.text.match(/^[\t]+/g)[0].length; i++)	tabs += "\t"
			sel.text = "\r\n"+tabs
			sel.select()
			break
		default		:
			event.returnValue = true
			break
	}
}

function getEditArea()
{
	f=window.frames["frame_CodeArea"];
	if(f)
		return f.editArea;
	else
		return null;
}

function exec(c)
{
	//if(editor_mode=="1")
	//{
		if(editArea)
		{
			editArea.execCommand(c)
		}
	//}
}

function showUseIt()
{
	var  url='show_useit.jsp?templateid=<%=TemplateID%>';
	var	dialog = new TideDialog();
		dialog.setWidth(600);
		dialog.setHeight(450);
		dialog.setLayer(2);
		dialog.setUrl(url);
		dialog.setTitle('查看使用该模板的频道');
		dialog.show();
}

function showcomment()
{
	var  url='showcomment.jsp?id=<%=TemplateID%>';
	var	dialog = new TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(300);
		dialog.setLayer(2);
		dialog.setUrl(url);
		dialog.setTitle('查看使用该模板的频道');
		dialog.show();
}

function changeEditor()
{
/*	if(editor_mode=="0")
	{		
		$("#CodeArea").hide();
		$("#frame_CodeArea").show();
		tools.setCookie("editor_mode","1");
		editor_mode = "1";
		$("#editor_mode_img").attr("src","../images/icon/30.png");
		init2();
		$(".tools_l li").not(":first").removeClass("on");
	}
	else
	{
		top.eAL.delete_instance("CodeArea");		
		$("#frame_CodeArea").hide();
		$("#CodeArea").show();
		tools.setCookie("editor_mode","0");
		editor_mode = "0";
		$("#editor_mode_img").attr("src","../images/icon/21.png");
		$(".tools_l li").not(":first").addClass("on");
	}
	*/
}

function showTab(form,form_td)
{
	var num = 3;
	for(i=1;i<=num;i++)
	{
		jQuery("#form"+i).hide();
		jQuery("#form"+i+"_td").removeClass("cur");
	}
	
	jQuery("#"+form).show();
	jQuery("#"+form_td).addClass("cur");
}




function insertAtCursor(obj, txt) {
  obj.focus();
  //IE support
  if (document.selection) {
    sel = document.selection.createRange();
    sel.text = txt;
  }
  //MOZILLA/NETSCAPE support
  else {
    var startPos = obj.selectionStart;
    var endPos = obj.selectionEnd;
    obj.value = obj.value.substring(0, startPos) + txt + obj.value.substring(endPos, obj.value.length);
    startPos += txt.length;
    obj.setSelectionRange(startPos, startPos);
  }
}

	showm("la");
/*	if(editor_mode=="0")
	{
		$("#CodeArea").show();
		editAreaLoaded("");
		$("#editor_mode_img").attr("src","../images/icon/21.png");
		$(".tools_l li").not(":first").addClass("on");

		$("#CodeArea").keydown(function(eve){
		  if (eve.keyCode == 9 && this == eve.target) {
			eve.preventDefault();
			insertAtCursor(this, "  ");
			this.returnValue = false;
		  }
		});
	}
	*/
</script>
	
    <style>
    	html,body{width:100%;height: 100%;overflow: hidden;position: relative;}
    	#ace_editor {margin: 0;position: absolute;top: 50px;bottom: 0;left: 0;right: 0;}
        button{padding: 5px 10px;margin:10px 20px;}
        .br-pageheader{background: #fff;}
		.select-box{position: relative;}
		.dropdown-menu{top: 27px;}
		.dropdown-menu .nav-link{padding: 0.4rem 0.8rem;}
		.dropdown-menu nav a i{margin-right: 0;width: 16px;}
		.br-pageheader .text-box1 a{margin:0 5px;color: #333333;}
		.br-pageheader .text-box a{margin:0 5px;color: #333333;}
		.br-pageheader .text-box a:hover{text-decoration: underline;}
    </style>
  </head>
 
  <body>  	
  	<div class="br-pageheader pd-y-10 pd-md-l-30">
        <div class="">
            <a href="javascript:save();" class="btn btn-primary mg-r-20 pd-x-15 pd-y-5" onclick="">保存</a>
        </div>
		<div class="text-box1 mg-l-10">
			<a href="javascript:;" id="t_html" class="title">模板应用：</a>
		</div>
		<div class="mg-l-0 select-box">
			<a href="javascript:;" class="btn-fn btn btn-outline-secondary active mg-r-10 pd-x-15 pd-y-5">频道<i class="fa fa-caret-down mg-l-5"></i></a>
			<div class="dropdown-menu">
				<nav class="nav nav-style-1 flex-column">
					<a href="javascript:InsertCode(126);" class="nav-link"><i class="fa fa-caret-right"></i>频道名称</a>
					<a href="javascript:InsertCode(127);" class="nav-link"><i class="fa fa-caret-right"></i>频道标识</a>
					<a href="javascript:InsertCode(163);" class="nav-link"><i class="fa fa-caret-right"></i>频道附加属性1</a>
					<a href="javascript:InsertCode(164);" class="nav-link"><i class="fa fa-caret-right"></i>频道附加属性2</a>
					<a href="javascript:InsertCode(143);" class="nav-link"><i class="fa fa-caret-right"></i>分页列表</a>
					<a href="javascript:InsertCode(147);" class="nav-link"><i class="fa fa-caret-right"></i>最新文章1</a>
					<a href="javascript:InsertCode(149);" class="nav-link"><i class="fa fa-caret-right"></i>最新文章2</a>
					<a href="javascript:InsertCode(160);" class="nav-link"><i class="fa fa-caret-right"></i>图片新闻</a>
					<a href="javascript:InsertCode(161);" class="nav-link"><i class="fa fa-caret-right"></i>非图片新闻</a>
					<a href="javascript:InsertCode(162);" class="nav-link"><i class="fa fa-caret-right"></i>数组</a>
				</nav>
			</div><!-- dropdown-menu -->
		</div>
		<div class="mg-l-10 select-box">
			<a href="javascript:;" class="btn-fn btn btn-outline-secondary active mg-r-10 pd-x-15 pd-y-5">文档<i class="fa fa-caret-down mg-l-5"></i></a>
			<div class="dropdown-menu">
				<nav class="nav nav-style-1 flex-column">
					<a href="javascript:InsertCode(201);" class="nav-link"><i class="fa fa-caret-right"></i>文档编号</a>
					<a href="javascript:InsertCode(220);" class="nav-link"><i class="fa fa-caret-right"></i>全局编号</a>
					<a href="javascript:InsertCode(211);" class="nav-link"><i class="fa fa-caret-right"></i>完整标题</a>
					<a href="javascript:InsertCode(219);" class="nav-link"><i class="fa fa-caret-right"></i>可限制标题</a>
					<a href="javascript:InsertCode(212);" class="nav-link"><i class="fa fa-caret-right"></i>内容</a>
					<a href="javascript:InsertCode(213);" class="nav-link"><i class="fa fa-caret-right"></i>链接(相对路径)</a>
					<a href="javascript:InsertCode(218);" class="nav-link"><i class="fa fa-caret-right"></i>链接(绝对路径)</a>
					<a href="javascript:InsertCode(214);" class="nav-link"><i class="fa fa-caret-right"></i>发布日期</a>
					<a href="javascript:InsertCode(215);" class="nav-link"><i class="fa fa-caret-right"></i>图片</a>
					<a href="javascript:InsertCode(216);" class="nav-link"><i class="fa fa-caret-right"></i>来源</a>
					<a href="javascript:InsertCode(217);" class="nav-link"><i class="fa fa-caret-right"></i>其他属性</a>
					<a href="javascript:InsertCode(202);" class="nav-link"><i class="fa fa-caret-right"></i>文档信息</a>
					<a href="javascript:InsertCode(203);" class="nav-link"><i class="fa fa-caret-right"></i>列子集数据(如图片集)</a>
				</nav>
			</div><!-- dropdown-menu -->
		</div>
		<div class="mg-l-10 select-box">
			<a href="javascript:;" class="btn-fn btn btn-outline-secondary active mg-r-10 pd-x-15 pd-y-5">控制器<i class="fa fa-caret-down mg-l-5"></i></a>
			<div class="dropdown-menu">
				<nav class="nav nav-style-1 flex-column">
					<a href="javascript:InsertCode(441);" class="nav-link"><i class="fa fa-caret-right"></i>IF语句</a>
					<a href="javascript:InsertCode(442);" class="nav-link"><i class="fa fa-caret-right"></i>IF-ELSE语句</a>
					<a href="javascript:InsertCode(445);" class="nav-link"><i class="fa fa-caret-right"></i>文档列表上一页</a>
					<a href="javascript:InsertCode(446);" class="nav-link"><i class="fa fa-caret-right"></i>文档列表下一页</a>
					<a href="javascript:InsertCode(454);" class="nav-link"><i class="fa fa-caret-right"></i>列表页翻页</a>
					<a href="javascript:InsertCode(455);" class="nav-link"><i class="fa fa-caret-right"></i>内容页翻页</a>
					<a href="javascript:InsertCode(456);" class="nav-link"><i class="fa fa-caret-right"></i>图片Href链接</a>
					<a href="javascript:InsertCode(457);" class="nav-link"><i class="fa fa-caret-right"></i>图片内容页链接</a>
					<a href="javascript:InsertCode(458);" class="nav-link"><i class="fa fa-caret-right"></i>标题Href链接</a>
					<a href="javascript:InsertCode(459);" class="nav-link"><i class="fa fa-caret-right"></i>标题内容页链接</a>
					<a href="javascript:InsertCode(465);" class="nav-link"><i class="fa fa-caret-right"></i>显示频道导航</a>
					<a href="javascript:InsertCode(466);" class="nav-link"><i class="fa fa-caret-right"></i>取子频道内容</a>
				</nav>
			</div><!-- dropdown-menu -->
		</div>
		<div class="mg-l-10 select-box">
			<a href="javascript:;" class="btn-fn btn btn-outline-secondary active mg-r-20 pd-x-15 pd-y-5">
				其他
				<i class="fa fa-caret-down mg-l-5"></i>				
			</a>
			<div class="dropdown-menu">
				<nav class="nav nav-style-1 flex-column">
					<a href="javascript:InsertCode(501);" class="nav-link"><i class="fa fa-caret-right"></i>Include语句</a>
					<a href="javascript:InsertCode(502);" class="nav-link"><i class="fa fa-caret-right"></i>替换include</a>
					<a href="javascript:InsertCode(503);" class="nav-link"><i class="fa fa-caret-right"></i>插入模块标记</a>
					<a href="javascript:InsertCode(504);" class="nav-link"><i class="fa fa-caret-right"></i>上一篇 下一篇</a>
					<a href="javascript:InsertCode(505);" class="nav-link"><i class="fa fa-caret-right"></i>图片集json</a>										
				</nav>
			</div><!-- dropdown-menu -->
		</div>
		<div class="text-box">
			<span id="message"></span>
		</div>
       
    </div>
  
  
  <div id="ace_editor"><%=Util.HTMLEncode(tf.getContent()).replace("&nbsp;","&amp;nbsp;")%></div>
  <script src="../lib/2018/ace/build/src-min/ace.js"></script>
  <script src="../lib/2018/ace/build/src-min/ext-language_tools.js"></script>
  <script>
	//$(function(){
  		//	ace.require("ace/ext/language_tools");
	    var editor = ace.edit("ace_editor");
	    editor.setShowPrintMargin(false); //设置打印边距可见度:
	    editor.setOptions({
	    	enableBasicAutocompletion: true,
	        enableSnippets: true, //启用代码块提示
	        enableLiveAutocompletion: true	        
	    });
	   
	    
	    editor.setFontSize(13);
	    editor.getSession().setUseWrapMode(true);   //设置代码折叠
	    //editor.resize();
	    editor.setHighlightActiveLine(true);  //设置高亮
	    //editor.setTheme("ace/theme/chrome");//monokai模式是自动显示补全提示
	    editor.setTheme("ace/theme/idle_fingers");//monokai模式是自动显示补全提示	     
	    //editor.getSession().setMode("ace/mode/javascript");//语言
	    editor.getSession().setMode("ace/mode/java");//语言
	    editor.setOption("wrap", "free") ;   //自动换行
	    
	    $(function(){	
	    	
	    	$(".select-box").mouseover(function(){					
				$(this).find(".dropdown-menu").slideDown(0) ;
	    	}).mouseleave(function(){
				$(this).find(".dropdown-menu").slideUp(0) ;					
			})
	    })
  	//})

   </script>
  </body>
</html>
