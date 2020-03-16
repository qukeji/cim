<%@ page import="java.io.*,tidemedia.cms.util.Util,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
* 最后修改人		修改时间					备注    
*  王海龙				2016/6/1				    禁止任意读取文件，
*/
String	FileName	= getParameter(request,"FileName");
String	FolderName	= getParameter(request,"FolderName");
String	Charset		= getParameter(request,"Charset");
String	Charset_	= getParameter(request,"Charset");

int	SiteId		= Util.getIntParameter(request,"SiteId");

if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}

Site site=CmsCache.getSite(SiteId);
String SiteFolder=site.getSiteFolder();
    
if(Charset.equals(""))
	Charset		= CmsCache.getDefaultSite().getCharset();

 if(FileName.startsWith(".") || FileName.contains(".."))//过滤特殊文件 禁止任意读取文件
	return ;

 String LineString;
String TotalString = "";
String Path	= SiteFolder + "/" + FolderName + "/" + FileName;
if(!Path.equals("")){
	String RealPath = Path;
	BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(RealPath),Charset));
	while ((LineString = in .readLine())!=null)
	{
		TotalString += LineString+"\r\n";
	}
	in.close();
}
//TotalString.contains();
TotalString = Util.HTMLEncode(TotalString);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title><%=FolderName%>/<%=FileName%></title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	html,body{width:100%;height: 100%;overflow: hidden;position: relative;}
	#ace_editor {margin: 0;position: absolute;top: 50px;bottom: 0;left: 0;right: 0;}
	button{padding: 5px 10px;margin:10px 20px;}
	.br-pageheader{background: #fff;}
	.select-box{position: relative;}
	.dropdown-menu{top: 27px;}
	.dropdown-menu .nav-link{padding: 0.4rem 0.8rem;}
	.dropdown-menu nav a i{margin-right: 0;width: 16px;}
	.br-pageheader .text-box a{margin:0 5px;color: #333333;font-size: 12px;}
	.br-pageheader .text-box a:hover{text-decoration: underline;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>

<script>
	var startTime,endTime;
	var d=new Date();
	startTime=d.getTime(); 
</script>

<script type="text/javascript" src="../common/2018/common2018.js"></script>
<!--<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xmlhttp.js"></script>-->

<script>
	var editor_mode = 0;//getCookie("file_editor_mode");
//	if(editor_mode==null || editor_mode=="" || editor_mode=="0") editor_mode = "0"; else editor_mode = "1";
</script>

<!--<script language="javascript" type="text/javascript" src="../common/edit_area_full2.js"></script> -->
<script type="text/javascript" src="../common/codearea2.js"></script>

<script ID="clientEventHandlersJS" LANGUAGE="javascript">
	var oldContent;
	function onDownloadDone(s)
	{
		tbContentElement.value=s;
		oldContent = s;
	}

	function Template_Define(){
		var Feature = "dialogWidth:20em; dialogHeight:12em;center:yes;status:no;help:no";
		var field=window.showModalDialog("definefield.asp",null,Feature);
		if (field==null) {
			return;
		}

		var name = field[0];
		tbContentElement.focus();
		var range = document.selection.createRange();
		define = "<!--%\r\nResponse.Output Document(\"" + name + "\")\r";
		define = define + "%-->\r";
		range.text = define + range.text;
	}

	function Template_Script(){
		tbContentElement.focus();
		var range = document.selection.createRange();
		var script = "<!--%\r\n%-->" + range.text;
		range.text = script;
	}

	function MENU_FILE_EXIT_onclick(){
		var text=tbContentElement.value;
		if (oldContent!=text) {
			if (confirm("文件内容已经被修改，要保存吗？"))
				MENU_FILE_SAVE_onclick();
		}
		window.close();
	}

	function OnMenuShow(QueryStatusArray, menu) {
	}

	function ChangeCharset(obj)
	{
		if(obj!=null)
		{
			this.location = "notepad.jsp?FolderName=<%=java.net.URLEncoder.encode(FolderName,"utf-8")%>&FileName=<%=java.net.URLEncoder.encode(FileName,"utf-8")%>&Charset=" + obj.value+"&SiteId=<%=SiteId%>";
		}
	}

	function ChangeCharset_(charset)
	{
		this.location = "notepad.jsp?FolderName=<%=java.net.URLEncoder.encode(FolderName,"utf-8")%>&FileName=<%=java.net.URLEncoder.encode(FileName,"utf-8")%>&Charset=" + charset +"&SiteId=<%=SiteId%>";
	}

	function insert_file()
	{
		var myObject = new Object();
		myObject.title = "插入文件";

		var Feature = "dialogWidth:32em; dialogHeight:22em;center:yes;status:no;help:no";
		var retu = window.showModalDialog
		("../modal_dialog.jsp?target=channel/select_publish_file.jsp",myObject,Feature);
		if(retu!=null)
		{
			tbContentElement.focus();
			var range = document.selection.createRange();
			range.text = retu;
			tbContentElement.focus();
		}
	}

	function insert_flag()
	{
		var text= "<!-- TideCMS Module -->";
		editAreaLoader.setSelectedText("ace_editor", text);
		/*
		if(jQuery.browser.msie){
			jQuery("#tbContentElement").focus();
			var range = document.selection.createRange();
			range.text =text;
		}else{
			jQuery("#tbContentElement").val(text+jQuery("#tbContentElement").val());
		}

		jQuery("#tbContentElement").focus();*/
	}

	function insert_edit_module()
	{
		var url = "../channel/pagemodule_add_ajax.jsp?FolderName=<%=java.net.URLEncoder.encode(FolderName,"utf-8")%>&FileName=<%=java.net.URLEncoder.encode(FileName,"utf-8")%>&Type=File&Charset=<%=Charset%>&SiteId=<%=SiteId%>";
		var http = new HTTPRequest();
		http.open("GET",url,true);
		http.onreadystatechange = function (){
			if (http.readyState == 4) {	
				result = http.responseText;
				if ( -1 != result.search("null") ) {
					tbContentElement.focus();
					var range = document.selection.createRange();
					range.text = "<!-- TideCMS Module " + result + " begin -->" + range.text + "<!-- TideCMS Module " + result + " end   -->";
					tbContentElement.focus();
				}
			}
		};
		http.send(null);
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

	function preview()
	{
		window.open("preview.jsp?FolderName="+encodeURI('<%=FolderName%>')+"&FileName=" + encodeURI('<%=FileName%>')+"&SiteId="+<%=SiteId%>);
	}
</script>

</head>

<body oncontextmenu="return false;">
	
	<div class="br-pageheader pd-y-10 pd-md-l-30">
        <div class="">
            <a href="javascript:save();" class="btn btn-primary mg-r-20 pd-x-15 pd-y-5">保存</a>
            <a href="javascript:preview();" class="btn btn-primary pd-x-15 pd-y-5">预览</a>
		</div>
		<div class="mg-l-30 select-box">
			<a href="javascript:;" class="btn-fn btn btn-outline-secondary active mg-r-20 pd-x-15 pd-y-5">
				编码
				<i class="fa fa-caret-down mg-l-5"></i>				
			</a>
			<div class="dropdown-menu">
							<nav class="nav nav-style-1 flex-column">
								<a href="javascript:ChangeCharset_('gb2312');" class="nav-link"><i class="fa fa-caret-right"></i>GB2312</a>
								<a href="javascript:ChangeCharset_('utf-8');" class="nav-link"><i class="fa fa-caret-right"></i>UTF-8</a>
							</nav>
			</div><!-- dropdown-menu -->
		</div>
		<div class="text-box">
			<a href="javascript:insert_flag();" class="">插入模块标记</a>,<a href="javascript:;" id="message"></a>
		</div>
		<!--  <div class="mg-l-10" id="message"></div>  -->
        <div class="mg-l-auto">
        	<!--<a href="javascript:;" class="btn btn-primary mg-r-20 pd-x-15 pd-y-5" onclick="changeToHtml()">切换html</a>
        	<a href="javascript:;" class="btn btn-primary mg-r-20 pd-x-15 pd-y-5" onclick="changeToCss()">切换css</a>
        	<a href="javascript:;" class="btn btn-primary mg-r-20 pd-x-15 pd-y-5" onclick="changeToJsp()">切换jsp</a>
        	<a href="javascript:;" class="btn btn-primary mg-r-20 pd-x-15 pd-y-5" onclick="changeToJs()">切换javascript</a>-->
            <a href="javascript:;" class="btn btn-primary mg-r-20 pd-x-15 pd-y-5" onclick="searchWord()">查找</a>
        </div>
    </div>

	<div id="ace_editor"><%=TotalString%></div>

	<script src="../lib/2018/ace/build/src-min/ace.js"></script>
	<script src="../lib/2018/ace/build/src-min/ext-language_tools.js"></script>


<script language=javascript>

	var editor = ace.edit("ace_editor");
		editor.setShowPrintMargin(false); //设置打印边距可见度:
	    editor.setOptions({
	    	enableBasicAutocompletion: true,
	        enableSnippets: true, //启用代码块提示
	        enableLiveAutocompletion: true
	        
	    });
	    editor.setFontSize(15); //设置字体大小
	    editor.getSession().setUseWrapMode(true);   //设置代码折叠
	    //editor.resize();
	    editor.setHighlightActiveLine(true);  //设置高亮
	    //editor.setTheme("ace/theme/chrome");//monokai模式是自动显示补全提示
	    editor.setTheme("ace/theme/idle_fingers");//monokai模式是自动显示补全提示	     
	    //editor.getSession().setMode("ace/mode/javascript");//语言
	    //editor.getSession().setMode("ace/mode/css");//语言
	    editor.setOption("wrap", "free") ;//自动换行
	    function searchWord(){
   			editor.execCommand('find')
   		}
//	    function changeToHtml(){
//	    	editor.getSession().setMode("ace/mode/html");//语言
//	    }
//	    function changeToCss(){
//	    	editor.getSession().setMode("ace/mode/css");//语言
//	    }
//	    function changeToJsp(){
//	    	editor.getSession().setMode("ace/mode/jsp");//语言
//	    }
//	    function changeToJs(){
//	    	editor.getSession().setMode("ace/mode/javascript");//语言
//	    }
	    
	    $(function(){	    	
	    	var fileFormat = "" ;
	    	var fileName = getUrlParam("FileName");
	    	fileFormat= fileName.substr(fileName.lastIndexOf(".")).toLowerCase().substring(1); //获得文件后缀名
	    	if(fileFormat=="css"){
	    		editor.getSession().setMode("ace/mode/css");
	    	}else if(fileFormat=="js"){
	    		editor.getSession().setMode("ace/mode/javascript");
	    	}else if(fileFormat=="html"){
	    		editor.getSession().setMode("ace/mode/html");
	    	}else if(fileFormat=="shtml"){
	    		editor.getSession().setMode("ace/mode/html");
	    	}else if(fileFormat=="jsp"){
	    		editor.getSession().setMode("ace/mode/jsp");
	    	}else if(fileFormat=="json"){
	    		editor.getSession().setMode("ace/mode/json");
	    	}else if(fileFormat=="php"){
	    		editor.getSession().setMode("ace/mode/php");
	    	}else{
	    		editor.getSession().setMode("ace/mode/");//语言
	    	}

			$(".select-box").mouseover(function(){			
				$(this).find(".dropdown-menu").slideDown(0) ;
			}).mouseleave(function(){
				$(this).find(".dropdown-menu").slideUp(0) ;					
			})
	    })
  	//})
    
    function getUrlParam(name){
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); 
        var r = window.location.search.substr(1).match(reg);  
        if (r != null) return decodeURI(r[2]); return null; 
    }

	function save() {
		var text = editor.getValue();

		if (text.replace(/\s/g,"") == "") {
			alert("当前文件内容为空。");
			return;
		}
		
		$("#message").html("<font color='red'><b>正在保存...</b></font>");
		jQuery.ajax({
			type:"POST",
			url:"save.jsp",
			data:"Charset=<%=Charset%>&SiteId=<%=SiteId%>&FileName=<%=FileName%>&FolderName=<%=FolderName%>&filecontent="+encodeURIComponent(text),
			success:function(msg){
				if(msg!="")
					$("#message").html("<font color='red'><b>保存完成.</b></font>");
				else
					$("#message").html(msg);
				setTimeout("$('#message').html('');",2000*1);
			} 
		}); 
	}
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
   </script>

</body>
</html>