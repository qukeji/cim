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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="Shortcut Icon" href="../favicon.ico">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=tf.getGroupTree() + tf.getFileName() + "(" + tf.getName() + ")"%></title>
<link href="../style/9/style.css" type="text/css" rel="stylesheet" />
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<link href="../style/9/tidecms7.css" type="text/css" rel="stylesheet" />
<link href="../style/9/page_source.css" type="text/css" rel="stylesheet" />
<style>
.code {
	font-size:14px;
	font-family:"Consolas", "Courier New", "宋体";
	line-height:22px;
	background: none repeat scroll 0 0 #F9F9F9;
	border: none;
	padding: 0;
}
</style>
<script>
var startTime,endTime;
var d=new Date();
startTime=d.getTime(); 
</script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script>var editor_mode = getCookie("editor_mode");
if(editor_mode==null || editor_mode=="" || editor_mode=="0") editor_mode = "0"; else editor_mode = "1";</script>
<script language="javascript" type="text/javascript" src="../common/edit_area_full2.js"></script>
<script type="text/javascript" src="../common/codearea2.js"></script>
</head>
<body oncontextmenu="return false;" topmargin="0" leftmargin="0" style="background: buttonface;border: 0px;" onLoad="init();">
<div class="source_top">
	<div class="editor_save">
		<div class="editer_button"><a href="javascript:save();"><span>保存</span></a></div>
	</div>
	<div class="templates_app">
		<span class="title" id="t_html">模版应用</span>
		<a href="#" class="app_links">应用频道</a>
		<a href="#" class="app_links">模板参考</a>
		<a href="javascript:showcomment()" class="app_links">查看备注</a>
		<span id="message" class="app_links"></span>
		<!--<textarea id="message2" name="message2"></textarea>-->
	</div>
	<div class="editor_tools">
		<span class="title">编辑工具</span>
		<div class="tools_main">
			<div class="tools_l">
				<ul>
					<li><a href="#" onClick="changeEditor();" title="切换编辑模式"><img src="../images/icon/30.png" id="editor_mode_img"></a></li>
					<li><a href="javascript:exec('show_search')" title="查找"><img src="../images/icon/49.png"></a></li>
					<li><a href="javascript:exec('go_to_line')" title="转到行"><img id="go_to_line" src="../common/images/go_to_line.gif" title="转到行" /></a></li>
					<li id="undo"><a href="javascript:exec('undo');" title="恢复">恢复</a></li>
					<li id="redo"><a href="javascript:exec('redo');" title="重做">重做</a></li>
					<li id="word_wrap"><a href="javascript:exec('toggle_word_wrap');" title="切换自动换行模式">切换自动换行模式</a></li>
					<li id="highlight"><a href="javascript:exec('change_highlight');" title="启用/禁止语法高亮">启用/禁止语法高亮</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>

<!--
<table><tr>
<td><span onClick="Help();" >模板参考</span>&nbsp;&nbsp;<span onClick="showUseIt()">应用频道</span>
&nbsp;&nbsp;<span onClick="showtools()">工具箱</span>
</td>
</tr></table>-->
<iframe frameborder="0" name="frame_CodeArea" id="frame_CodeArea" style="border-width: 0px; overflow: hidden; display: none; height:550px;width: 100%;" src=""></iframe>
<textarea class="code" id="CodeArea" style="width:100%;display:none;" rows="1" cols="20"><%=Util.HTMLEncode(tf.getContent()).replace("&nbsp;","&amp;nbsp;")%></textarea>
<div id="message3" onDBLClick="$(this).hide();" style= 'display:none;font-size:14px;position:fixed;bottom:100px;right:0px;height:100px;width:600px;word-wrap:break-word;filter:alpha(opacity=50);background:#F5F5F5;'></div>
<div id="message2" onDBLClick="$(this).hide();" style= 'display:none;font-size:14px;position:fixed;bottom:0px;right:0px;height:100px;width:600px;word-wrap:break-word;filter:alpha(opacity=50);background:#F5F5F5;'></div>

<!--
<div id="tools" class="openwin_main" style="display:none;width: 300px; left: 840px; top: 100px; height: 450px;">
    	<div id="openwin_nav_id" class="openwin_nav">
        	<div id="TideDialogTitle" class="nav">工具箱</div>
            <div style="background:url(images/openwin_close.png) no-repeat 0 0;" class="close"><a id="TideDialogClose" title="关闭" href="javascript:getDialog().Close({suffix:&quot;&quot;});"></a></div>
        </div>
        <div name="popDiviframe" id="popDiviframe" class="openwin_iframe">

		<div class="edit-main">
	<div class="edit-nav">
    	<ul>
        	<li><a id="form1_td" class="cur" href="javascript:showTab('form1','form1_td');" onmouseover="showTab('form1','form1_td')"><span>文档</span></a></li>
            <li><a id="form2_td" href="javascript:showTab('form2','form2_td');" onmouseover="showTab('form2','form2_td')"><span>频道</span></a></li>
            <li><a id="form3_td" href="javascript:showTab('form3','form3_td');" onmouseover="showTab('form3','form3_td')"><span>其他</span></a></li>
        </ul>
        <div class="clear"></div>
    </div>
    <div class="edit-con">
    	<div class="top">
        	<div class="left"></div>
            <div class="right"></div>
        </div>
		<div class="center_main">
        <div id="form1" class="center">
<table width="100%" border="0">
  <tbody><tr>
<td onClick="InsertCode(20)">全局编号</td></tr><tr>
<td onClick="InsertCode(11)">完整标题</td></tr><tr>
<td onClick="InsertCode(19)">可限制标题</td></tr><tr>
<td onClick="InsertCode(12)">内容</td></tr><tr>
<td onClick="InsertCode(13)">链接(相对路径)</td></tr><tr>
<td onClick="InsertCode(18)">链接(绝对路径)</td></tr><tr>
<td onClick="InsertCode(14)">发布日期</td></tr><tr>
<td onClick="InsertCode(15)">图片</td></tr><tr>
<td onClick="InsertCode(16)">来源</td></tr><tr>
<td onClick="InsertCode(17)">其他属性</td></tr>

</tbody></table>
        </div>
        
       <div style="display:none;" id="form2" class="center">
<table width="100%" border="0">
  <tbody><tr>
    <td>附加属性一：</td>
  </tr>
  <tr>
    <td>附加属性二：</td>
  </tr>
</tbody></table>
	</div>
        
         <div style="display:none;" id="form3" class="center">
<table width="100%" border="0">
  <tbody><tr>
    <td>引用栏目：</td>
  </tr>
  <tr>
    <td>对应关系：</td>
  </tr>

</tbody></table>
        </div>
        
        </div>
        <div class="bot">
        	<div class="left"></div>
            <div class="right"></div>
        </div>
    </div>
</div>

		
		</div></div>
-->
<script language="javascript" type="text/javascript">
//$("#frame_CodeArea").attr("src","codearea.html");

var iframe=window.frames["frame_CodeArea"];
iframe.document.open();
iframe.document.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\"> <html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" > <head> <title>EditArea</title> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> <style>body,html{margin:0;padding:0;height:100%;border:none;overflow:hidden;background-color:#FFF;}#editor{border:solid #888 1px;overflow:hidden;font-family:\"Consolas\", \"Courier New\", \"宋体\";font-size:14px;}#result{z-index:4;overflow-x:auto;overflow-y:scroll;border-top:solid #888 1px;border-bottom:solid #888 1px;position:relative;clear:both;}#result.empty{overflow:hidden;}#container{line-height:22px;overflow:hidden;border:solid blue 0;position:relative;z-index:10;padding:0 5px 0 45px;}#textarea{font-family:\"Consolas\", \"Courier New\", \"宋体\";font-size:14px;position:relative;top:0;left:0;margin:0;padding:0;width:100%;height:100%;overflow:hidden;z-index:7;border-width:0;background-color:transparent;resize:none;}#textarea,#textarea:hover{outline:none;}#content_highlight{white-space:pre;margin:0;padding:0;position:absolute;z-index:4;overflow:visible;}#selection_field,#selection_field_text{margin:0;background-color:#E1F2F9;position:absolute;z-index:5;top:-100px;padding:0;white-space:pre;overflow:hidden;}#selection_field.show_colors {z-index:3;background-color:#EDF9FC;}#selection_field strong{font-weight:normal;}#selection_field.show_colors *,#selection_field_text * {visibility:hidden;}#selection_field_text{background-color:transparent;}#selection_field_text strong{font-weight:normal;background-color:#3399FE;color:#FFF;visibility:visible;}#container.word_wrap #content_highlight,#container.word_wrap #selection_field,#container.word_wrap #selection_field_text,#container.word_wrap #test_font_size{white-space:pre-wrap;white-space:-moz-pre-wrap !important;white-space:-pre-wrap;white-space:-o-pre-wrap;word-wrap:break-word;width:99%;}#line_number{position:absolute;overflow:hidden;border-right:solid black 1px;z-index:8;width:38px;padding:0 5px 0 0;margin:0 0 0 -45px;text-align:right;color:#AAAAAA;}#test_font_size{padding:0;margin:0;visibility:hidden;position:absolute;white-space:pre;}pre{margin:0;padding:0;}.hidden{opacity:0.2;filter:alpha(opacity=20);}#result .edit_area_cursor{position:absolute;z-index:6;background-color:#FF6633;top:-100px;margin:0;}#result .edit_area_selection_field .overline{background-color:#996600;}.editarea_popup{border:solid 1px #888888;background-color:#ECE9D8;width:250px;padding:4px;position:absolute;visibility:hidden;z-index:15;top:-500px;}.editarea_popup,.editarea_popup table{font-family:sans-serif;font-size:12px;}.editarea_popup img{border:0;}.editarea_popup .close_popup{float:right;line-height:16px;border:0;padding:0;}.editarea_popup h1,.editarea_popup h2,.editarea_popup h3,.editarea_popup h4,.editarea_popup h5,.editarea_popup h6{margin:0;padding:0;}.editarea_popup .copyright{text-align:right;}div#area_search_replace{}div#area_search_replace img{border:0;}div#area_search_replace div.button{text-align:center;line-height:1.7em;}div#area_search_replace .button a{cursor:pointer;border:solid 1px #888888;background-color:#DEDEDE;text-decoration:none;padding:0 2px;color:#000000;white-space:nowrap;}div#area_search_replace a:hover{background-color:#EDEDED;}div#area_search_replace  #move_area_search_replace{cursor:move;border:solid 1px #888;}div#area_search_replace  #close_area_search_replace{text-align:right;vertical-align:top;white-space:nowrap;}div#area_search_replace  #area_search_msg{height:18px;overflow:hidden;border-top:solid 1px #888;margin-top:3px;}#edit_area_help{width:350px;}#edit_area_help div.close_popup{float:right;}.area_toolbar{width:100%;margin:0;padding:0;background-color:#ECE9D8;text-align:left;}.area_toolbar,.area_toolbar table{font:11px sans-serif;}.area_toolbar img{border:0;vertical-align:middle;}.area_toolbar input{margin:0;padding:0;}.area_toolbar select{font-family:\'MS Sans Serif\',sans-serif,Verdana,Arial;font-size:7pt;font-weight:normal;margin:2px 0 0 0 ;padding:0;vertical-align:top;background-color:#F0F0EE;}table.statusbar{width:100%;}.area_toolbar td.infos{text-align:center;width:130px;border-right:solid 1px #888;border-width:0 1px 0 0;padding:0;}.area_toolbar td.total{text-align:right;width:50px;padding:0;}.area_toolbar td.resize{text-align:right;}.area_toolbar span#resize_area{cursor:nw-resize;visibility:hidden;}.editAreaButtonNormal,.editAreaButtonOver,.editAreaButtonDown,.editAreaSeparator,.editAreaSeparatorLine,.editAreaButtonDisabled,.editAreaButtonSelected {border:0; margin:0; padding:0; background:transparent;margin-top:0;margin-left:1px;padding:0;}.editAreaButtonNormal {border:1px solid #ECE9D8 !important;cursor:pointer;}.editAreaButtonOver {border:1px solid #0A246A !important;cursor:pointer;background-color:#B6BDD2;}.editAreaButtonDown {cursor:pointer;border:1px solid #0A246A !important;background-color:#8592B5;}.editAreaButtonSelected {border:1px solid #C0C0BB !important;cursor:pointer;background-color:#F4F2E8;}.editAreaButtonDisabled {filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);-moz-opacity:0.3;opacity:0.3;border:1px solid #F0F0EE !important;cursor:pointer;}.editAreaSeparatorLine {margin:1px 2px;background-color:#C0C0BB;width:2px;height:18px;}#processing{display:none;background-color:#ECE9D8;border:solid #888 1px;position:absolute;top:0;left:0;width:100%;height:100%;z-index:100;text-align:center;}#processing_text{position:absolute;left:50%;top:50%;width:200px;height:20px;margin-left:-100px;margin-top:-10px;text-align:center;}#no_file_selected{height:100%;width:150%;background:#CCC;display:none;z-index:20;position:absolute;}.non_editable #editor{border-width:0 1px;}.non_editable .area_toolbar{display:none;}#auto_completion_area{background:#FFF;border:solid 1px #888;position:absolute;z-index:15;width:280px;height:180px;overflow:auto;display:none;}#auto_completion_area a,#auto_completion_area a:visited{display:block;padding:0 2px 1px;color:#000;text-decoration:none;}#auto_completion_area a:hover,#auto_completion_area a:focus,#auto_completion_area a.focus{background:#D6E1FE;text-decoration:none;}#auto_completion_area ul{margin:0;padding:0;list-style:none inside;}#auto_completion_area li{padding:0;}#auto_completion_area .prefix{font-style:italic;padding:0 3px;}</style><script>top.showm(\"iframe\");<\/script><\/script><script>top.showm(\"iframe3\");<\/script><script><\/script><\/head> <body> <div id=\'editor\'><div id=\'result\'> <div id=\'no_file_selected\'></div> <div id=\'container\'> <div id=\'cursor_pos\' class=\'edit_area_cursor\'>&nbsp;</div> <div id=\'end_bracket\' class=\'edit_area_cursor\'>&nbsp;</div> <div id=\'selection_field\'></div> <div id=\'line_number\' selec=\'none\'></div> <div id=\'content_highlight\'></div> <div id=\'test_font_size\'></div> <div id=\'selection_field_text\'></div> <textarea id=\'textarea\' wrap=\'off\' onchange=\'top.editArea.execCommand(\"onchange\");\' onfocus=\'javascript:top.editArea.textareaFocused=true;\' onblur=\'javascript:top.editArea.textareaFocused=false;\'> </textarea> </div> </div> </div> <div id=\'processing\'> <div id=\'processing_text\'> 正在处理中... </div> </div> <div id=\'area_search_replace\' class=\'editarea_popup\'> <table cellspacing=\'2\' cellpadding=\'0\' style=\'width: 100%\'> <tr> <td selec=\'none\'>查找</td> <td><input type=\'text\' id=\'area_search\' /></td> <td id=\'close_area_search_replace\'> <a onclick=\'Javascript:editArea.execCommand(\"hidden_search\")\'><img selec=\'none\' src=\'../common/images/close.gif\' alt=\'关闭对话框\' title=\'关闭对话框\' /></a><br /> </tr><tr> <td selec=\'none\'>替换</td> <td><input type=\'text\' id=\'area_replace\' /></td> <td><img id=\'move_area_search_replace\' onmousedown=\'return parent.start_move_element(event,\"area_search_replace\", parent.frames[\"frame_\"+editArea.id]);\'  src=\'../common/images/move.gif\' alt=\'移动查找对话框\' title=\'移动查找对话框\' /></td> </tr> </table> <div class=\'button\'><input type=\'checkbox\' id=\'area_search_match_case\' /><label for=\'area_search_match_case\' selec=\'none\'>匹配大小写</label> <input type=\'checkbox\' id=\'area_search_reg_exp\' /><label for=\'area_search_reg_exp\' selec=\'none\'>正则表达式</label> <br /> <a onclick=\'Javascript:editArea.execCommand(\"area_search\")\' selec=\'none\'>查找下一个</a> <a onclick=\'Javascript:editArea.execCommand(\"area_replace\")\' selec=\'none\'>替换</a> <a onclick=\'Javascript:editArea.execCommand(\"area_replace_all\")\' selec=\'none\'>全部替换</a><br /> </div> <div id=\'area_search_msg\' selec=\'none\'></div> </div> <div id=\'edit_area_help\' class=\'editarea_popup\'> <div class=\'close_popup\'> <a onclick=\'Javascript:editArea.execCommand(\"close_all_inline_popup\")\'><img src=\'../common/images/close.gif\' alt=\'关闭对话框\' title=\'关闭对话框\' /></a> </div> <div><h2>Editarea 0.8.2</h2><br /> <h3>快捷键:</h3> Tab: 添加制表符(Tab)<br /> Shift+Tab: 移除制表符(Tab)<br /> Ctrl+f: 查找下一个 / 打开查找框<br /> Ctrl+r: 替换 / 打开查找框<br /> Ctrl+h: 启用/禁止语法高亮<br /> Ctrl+g: 转到行<br /> Ctrl+z: 恢复<br /> Ctrl+y: 重做<br /> Ctrl+e: 关于<br /> Ctrl+q, Esc: 关闭对话框<br /> 快捷键 E: 切换编辑器<br /> <br /> <em>注意：语法高亮功能仅用于较少内容的文本(文件内容太大会导致浏览器反应慢)</em> <br /><div class=\'copyright\'>&copy; Christophe Dolivet 2007-2010</div> </div> </div> </body> </html>");
iframe.document.close();

function editAreaLoaded(id){
			d=new Date();endTime=d.getTime();
			//$("#message").html(((endTime-startTime)/1000)+"秒");
			$("#message").html($("#message").html()+","+((endTime-startTime)/1000)+"");
		}

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
</script>

<script>
var pattern = "";
var oldContent;
function onDownloadDone(s)
{
  CodeArea.value=s;
  oldContent = s;
}

function insertText(text)
{
	editAreaLoader.setSelectedText("CodeArea", text);
	/*
	if(document.selection)
	{
		var range = document.selection.createRange();
		range.text = text;
	}
	else
	{
		var code = document.getElementById("CodeArea");
		var codelength = code.value.length;
		//alert(code.selectionStart+","+code.selectionEnd);
		//alert(code.value.substring(code.selectionEnd,codelength));
		code.value=code.value.substring(0,code.selectionStart)+text+code.value.substring(code.selectionEnd,codelength);
	}
	*/
}

function InsertCode(i)
{
	selectedText = editAreaLoader.getSelectedText("CodeArea");
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
		CodeArea.value = CodeArea.value.replace(/<!--#include/g,"<!--#Include");
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
  CodeArea.focus();
  var range = document.selection.createRange();
  var script = "<!--%\r\n%-->" + range.text;
  insertText(script);
}

function save() {
  var text;

  if(editor_mode=="0")
	  text = $("#CodeArea").val();
  else
	  text = editAreaLoader.getValue("CodeArea");

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
	if(top.editor_mode=="1")
	{
		showm("starta");
		top.eAL.start(area_id);
		eA.init();
	}
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
	if(editor_mode=="1")
	{
		if(editArea)
		{
			editArea.execCommand(c)
		}
	}
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
	if(editor_mode=="0")
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

var json = [{"name":"channel","name2":"频道", "items":[{"id":"126","name":"频道名称"},{"id":"127","name":"频道标识"},{"id":"163","name":"频道附加属性1"},{"id":"164","name":"频道附加属性2"},{"id":"143","name":"分页列表"},{"id":"147","name":"最新文章1"},{"id":"149","name":"最新文章2"},{"id":"160","name":"图片新闻"},{"id":"161","name":"非图片新闻"},{"id":"162","name":"数组"}]},

{"name":"document","name2":"文档","items":[{"id":"201","name":"文档编号"},{"id":"220","name":"全局编号"},{"id":"211","name":"完整标题"},{"id":"219","name":"可限制标题"},{"id":"212","name":"内容"},{"id":"213","name":"链接(相对路径)"},{"id":"218","name":"链接(绝对路径)"},{"id":"214","name":"发布日期"},{"id":"215","name":"图片"},{"id":"216","name":"来源"},{"id":"217","name":"其他属性"},{"id":"202","name":"文档信息"},{"id":"203","name":"列子集数据(如图片集)"}]},

{"name":"controller","name2":"控制器","items":[{"id":"441","name":"IF语句"},{"id:":"442","name":"IF-ELSE语句"},{"id":"445","name":"文档列表上一页"},{"id":"446","name":"文档列表下一页"},{"id":"454","name":"列表页翻页"},{"id":"455","name":"内容页翻页"},{"id":"456","name":"图片Href链接"},{"id":"457","name":"图片内容页链接"},{"id":"458","name":"标题Href链接"},{"id":"459","name":"标题内容页链接"},{"id":"465","name":"显示频道导航"},{"id":"466","name":"取子频道内容"}]},

{"name":"other","name2":"其他","items":[{"id":"501","name":"Include语句"},{"id":"502","name":"替换include"},{"id":"503","name":"插入模块标记"},{"id":"504","name":"上一篇 下一篇"},{"id":"505","name":"图片集json"}]}];

function hidemenu()
{
	$(".app_box").removeClass("on");
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
	var html = "";
	for(var i = 0;i<json.length;i++)
	{
	  html += '<div class="app_box" ><div class="app_button"><div class="app_button_l"><span>'+json[i].name2+'</span></div><span class="app_list_top"></span></div><i class="arrow"></i><div class="app_list"><ul id="channel_li">';
	  var o = json[i].items;
	  for(var j = 0;j<o.length;j++)
		{
		  html += "<li><a href='javascript:InsertCode("+o[j].id+")'>"+o[j].name+"</a></li>";
		}
	  html += '</ul><span class="app_list_bot"></span></div></div>';
	}
	$("#t_html").after($(html));
	var menu = $(".app_box");
	menu.mouseover( function () {menu.removeClass("on"); $(this).addClass("on"); }).mouseout( function () {$(this).removeClass("on"); }).click( function () {$(this).removeClass("on"); }); 
	showm("lb");

	if(editor_mode=="0")
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
	//eAL.start(area_id);

</script>
</body>                                                                          
</html>