<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.Date,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
String time = CmsCache.getExpiresDateStr();  
long current = System.currentTimeMillis();
time  = time.replaceAll("-","/");
Date date = new Date(time);
long ExpiresDate = date.getTime();
long diff = (ExpiresDate - current)/1000; //秒
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
if(CmsCache.hasValidLicense()) diff = 1000000;

String dir = request.getServletPath().substring(1,request.getServletPath().lastIndexOf("/"));
String system_logo = CmsCache.getParameter("system_logo").getContent();
%>
<!DOCTYPE html>
<html id="appManage">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../<%=ico%>">
<title><%=title_%></title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />

<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/sidebar-menu-channel.css">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/2018/tcenter.css">
<link rel="stylesheet" href="../style/2018/theme.css">

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script language=javascript>

var dir = "explorer";
console.log(dir);
function init()
{	
	window.status="当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
//	window.onresize=reSize;
//	reSize();

//	if (jQuery.browser.msie) {
//		var version=parseInt(jQuery.browser.version);
//		if(version==6){
//			alert("你当前使用的浏览器是IE6,请升级你的浏览器!");
//		}
//	}

	set_main_class("index");
	<%if(diff<10*24*3600){%>
		tidecms.dialog("../system/license_notify.jsp", 500, 300, "许可证到期提醒", 2);
	<%}%>
}

function reSize() {
	document.getElementById("main").style.height = Math.max(document.body.clientHeight - document.getElementById("main").offsetTop, 0) + "px";
}
function set_main_class(str){
	jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+str).addClass('on');
}
 

function feed()
{
	title='反馈'
	url="http://123.125.148.3:888/cms/feedback.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle(title);
		dialog.show();
};
</script>
</head>

<body class="collapsed-menu email" id="withSecondNav" onLoad="init();">

	<div class="br-logo">
	<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
	   <img class="ht-100p" src="../img/2019/<%=system_logo%>">
	</a>
</div>

	<%@include file="include/tree.jsp"%><!--静态包含-->

	<%@include file="header.jsp"%><!--静态包含-->

	<div class="br-subleft br-subleft-file">
		<div class="sidebar-menu-box ht-100p-force">
			<ul class="sidebar-menu">	  	  

			</ul>
		</div>
        
    </div><!-- br-subleft -->

    <!-- ########## START: MAIN PANEL ########## -->
    <div class="br-mainpanel with-second-nav br-mainpanel-file " id="js-source">
        <iframe src="../explorer/file_list2018.jsp" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
    </div><!-- br-mainpanel -->

	<div style="display:none"><iframe id="Download" name="Download" style="width: 0; height: 0;"></iframe></div>


	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.min.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<!--<script src="../lib/2018/select2/js/select2.min.js"></script>-->
	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-file.js"></script>
	<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
	<script>

        $(function(){
			'use strict';
 
			//show only the icons and hide left menu label by default
			$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
        
			$(document).on('mouseover', function(e){
			  e.stopPropagation();
			  if($('body').hasClass('collapsed-menu')) {
				var targ = $(e.target).closest('.br-sideleft').length;
				if(targ) {
				  $('body').addClass('expand-menu');

				  // show current shown sub menu that was hidden from collapsed
				  $('.show-sub + .br-menu-sub').slideDown();

				  var menuText = $('.menu-item-label,.menu-item-arrow');
				  menuText.removeClass('d-lg-none');
				  menuText.removeClass('op-lg-0-force');
                  menuText.css({
                      "display":"block",
                      "opacity":"1"
                  })
				} else {
				  $('body').removeClass('expand-menu');

				  // hide current shown menu
				  $('.show-sub + .br-menu-sub').slideUp();

				  var menuText = $('.menu-item-label,.menu-item-arrow');
				  menuText.addClass('op-lg-0-force');
				  menuText.addClass('d-lg-none');
				}
			  }
			});

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
        
			$("#js-source-table tr:gt(0)").click(function () {     
		        console.log($(this).find(":checkbox").prop("checked"))    
		        if ($(this).find(":checkbox").prop("checked"))//   
		        {    
		            $(this).find(":checkbox").removeAttr("checked");    
		            // $(this).find(":checkbox").attr("checked", 'false');     
		        }    
		        else    
		        {    
		            $(this).find(":checkbox").prop("checked", true);    
		        }     
		    }); 

			//导航初始化
			menu_init(1,null);
		
   		});
//========================================

		//导航初始化(第一次加载)
		function menu_init(type,obj){

			var url="../explorer/tree2018.jsp";
			$.ajax({type:"GET",dataType:"json",url:url,success: function(json){
				var menu = $('.sidebar-menu');
				console.log(json);
				for(var i=0;i<json.length;i++){
					var html = '';
					if(json[i].child!=null&&json[i].child.length>0)
					{
						html = '<li class="treeview">';
					}
					else
					{
						html = '<li>';
					}
					//判断加
					if( json[i].load==1 || (json[i].child!=null && json[i].child.length>0) ){					
						html += '<a href="javascript:;" load="'+json[i].load+'" folderName="'+json[i].folderName+'" siteId="'+json[i].siteId+'"><i class="fa fisrtNav fa-home " have="1"></i> <span>'+json[i].name+'</span></a>';
					}else{
						html += '<a href="javascript:;" load="'+json[i].load+'" folderName="'+json[i].folderName+'" siteId="'+json[i].siteId+'"><i class="fa fisrtNav fa-home" have="0"></i> <span>'+json[i].name+'</span></a>';				
					}

					if( json[i].load==1 || (json[i].child!=null && json[i].child.length>0) ){					
						html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
					}
					html += '</li>';
					menu.append(html);
				}
				if(type==1){
					//多级导航自定义
					$.sidebarMenu1(menu);
				}else{

				}
			}});
		}
		function get_menu_html(json)
		{
			var html = "";
				console.log(json);
			if(json.child && json.child.length>0)
			{
				var json_ = json.child;
				for(var i=0;i<json_.length;i++){
					html += '<li><a href="javascript:;" load="'+json_[i].load+'" folderName="'+json_[i].folderName+'" siteId="'+json_[i].siteId+'">';

					if(json_[i].load==1||(json_[i].child && json_[i].child.length>0)){
						html += '<i class="fa fa-folder" have="1"></i>';
					}else{
						html += '<i class="fa fa-folder-o" have="0"></i>';
					}

					html += '<span>'+json_[i].name+'</span></a>';

					if(json_[i].child && json_[i].child.length>0){
						html += '<ul class="treeview-menu">' + get_menu_html(json_[i]) + '</ul>';
					} 

					html += '</li>';
				}
			}
			return html;
		 }

		$.sidebarMenu1 = function(menu) {
		  var animationSpeed = 10;
		  
		  $(menu).on('click', 'li a', function(e) {
//				if($(this).hasClass("clicked")){
//					return;
//				}
//				$(this).addClass("clicked");//设置不可重复点击

			var $this = $(this);
			var checkElement = $this.next();
			var load = $this.attr("load");
			var folderName = $this.attr("folderName");
			var siteId = $this.attr("siteId");
            
			if(load==1){				
				var url="../explorer/folder_json.jsp?Path="+folderName+"&SiteId="+siteId;
				menu_load(url,$this);
			 }
			 else
			 {
				sidebarMenu_show(checkElement,animationSpeed,$this);
			 }

			 if(window.frames["content_frame"]){
				 if(folderName && folderName!="\\")
				    changeFrameSrc(window.frames["content_frame"] , "../explorer/file_list2018.jsp?FolderName=" + encodeURI(folderName)+"&SiteId="+siteId)
				 else
				    changeFrameSrc(window.frames["content_frame"] , "../explorerfile_list2018.jsp?FolderName=&SiteId="+siteId)
			 }
		  });
		}

		//导航点击事件(二次加载)
		function menu_load(url,$this){
			var haveChild = $this.find("i").attr("have");
			var checkElement = $this.next();
      $(".nav-loading").remove();
			$.ajax({
				type:"GET",
				dataType:"json",
				url:url,
				beforeSend:function(){ 
					if(haveChild==1){
						var loadingHtml = '<ul class="treeview-menu nav-loading" style="display: block;"><li><a class="tx-white tx-13-force" href="javascript:;"><i class="fa tx-13-force fa-spinner" aria-hidden="true"></i>loading</a></li></ul>'
						$this.after(loadingHtml)
					}
				}, 
				success: function(json){
				
				if(json.length!=0){
					var html = '<ul class="treeview-menu">';
					for(var i=0;i<json.length;i++){
						if(json[i].child && json[i].child.length>0){							
							html += '<li class="treeview">';
						}
						else
						{
							html += '<li>';
						}
						html += '<a href="#" load="1" folderName="'+json[i].folderName+'" siteId="'+json[i].siteId+'">';
						
						if(json[i].load==1||(json[i].child && json[i].child.length>0)){
							html += '<i class="fa fa-folder" have="1"></i>';
						}else{
							html += '<i class="fa fa-folder-o" have="0"></i>';
						} 
						html += '<span>'+json[i].name+'</span></a>';
						
						if(json[i].child && json[i].child.length>0)
						{
							html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
						}
						html += '</li>';
					}
					html += '</ul>';
					$(".nav-loading").remove();
					$this.nextAll().remove();
					$this.after($(html));					
				}
				checkElement = $this.next();
				$this.attr("load",0);
				sidebarMenu_show(checkElement,10,$this);
				
			}});
		}

		//导航刷新
		function reLoadNav(obj){

			if(obj.parentFolder==""){  //如果是操作站点

				var menu = $('.sidebar-menu').html("");	
				menu_init(2,obj);

				return false;
			}
			
			var $this = $(".sidebar-menu a[foldername='"+obj.parentFolder+"']") ;

			for(var i=0;i<$this.length;i++){

				var siteid = $this[i].getAttribute("siteid");

				if(siteid==obj.siteid){
					$this[i].setAttribute("load",1);//设置点击请求

					$this.next().remove();//清除原节点

					sidebarMenu_show($this.next(),0,$this);

					$this[i].click();//模拟点击事件
				}
			}
		}
		
//====================================================================
		//新建目录
		function newFolder()
		{
			var FolderName;
			var SiteId ;
			if (getActiveNav()){ 
				var this_ = getActiveNav();
				FolderName = $(this_).attr("foldername");
				SiteId = $(this_).attr("siteid");
			}

			if(FolderName=="")
				return;

			var	dialog = new top.TideDialog();
				dialog.setWidth(500);
				dialog.setHeight(300);
				dialog.setUrl("../explorer/newfolder.jsp?SiteId="+SiteId+"&FolderName="+encodeURI(FolderName));
				dialog.setTitle("新建目录");
				dialog.show();
			
		}
		//发布
		function publishFolder()
		{
			if (getActiveNav()){
				var this_ = getActiveNav();
				var SiteId = $(this_).attr("siteid");
				var	FolderName = $(this_).attr("foldername");
				if(confirm("确实要发布\"" + FolderName + "\"吗?\r\n提示：发布目录有可能需要较长时间!")) 
				{
					$.ajax({
						type:"GET",
						dataType:"json",
						url:"folder_publish.jsp?Action=Publish&FolderName="+encodeURI(FolderName)+"&SiteId="+SiteId,
						async : false,
						success: function(json){
							reLoadNav(json);
						}
					});
				}
			}else{
				return false;
			}
		}
		//下载
		function downloadFolder()
		{
			if (getActiveNav()){

				var this_ = getActiveNav();
				var SiteId = $(this_).attr("siteid");
				var	FolderName = $(this_).attr("foldername");

				window.frames["Download"].location = "../download.jsp?Type=Folder&FolderName="+encodeURI(FolderName)+"&SiteId="+SiteId;
			}else{
				return false;
			}
		}
		//重命名
		function renameFolder()
		{
			if (getActiveNav()){
				var this_ = getActiveNav();
				var FolderName = $(this_).attr("foldername");
				var SiteId = $(this_).attr("siteid");

				if(FolderName=="/"){
					alert("\"站点根目录\"不能重命名!");
					return false;
				}

				var dialog = new top.TideDialog();
					dialog.setWidth(500);
					dialog.setHeight(300);
					dialog.setUrl("../explorer/renamefolder.jsp?SiteId="+SiteId+"&FileName="+encodeURI(FolderName));
					dialog.setTitle("重命名");
					dialog.show();
			}else{
				return false;
			}
		}

		function deleteFolder()
		{
			if (getActiveNav()){

				var this_ = getActiveNav();
				var FolderName = $(this_).attr("foldername");
				var SiteId = $(this_).attr("siteid");
				if(FolderName=="/")
				{
					alert("\"站点根目录\"不能删除!");
					return false;
				}

				if(confirm("确实要删除\"" + FolderName + "\"吗?\r\n注意：目录被删除后不能恢复，而且其下面的文件和子目录将一并删除!")) 
				{
					$.ajax({
						type:"GET",
						dataType:"json",
						url:"folder_delete.jsp?Action=Delete&FolderName="+encodeURI(FolderName)+"&SiteId="+SiteId,
						async : false,
						success: function(json){
							reLoadNav(json);
						}
					});

	//				var nodeDel=getDelNode(tree.getSelected());
	//				var	str = document.getElementById(nodeDel.id + '-anchor').FolderName;
	//				document.cookie = "folder_path=" + str;
				}
			}else{
				return false;
			}
		}
		function getDelNode(selectDel){
			var nodeDel="";
			var parentDel=selectDel.parentNode;
			if(selectDel.getPreviousSibling()&& selectDel.getPreviousSibling().parentNode==parentDel){
				nodeDel=selectDel.getPreviousSibling();
			}else{
				if(selectDel.getNextSibling()&&selectDel.getNextSibling().parentNode==parentDel){
					nodeDel=selectDel.getNextSibling();
				}else{
					nodeDel=parentDel;
				}
			} 
			return nodeDel; 
    		//var	str = document.getElementById(nodeDel.id + '-anchor').FolderName;
		}


    </script>
    
    <script>
    	$(function(){
    		$('.sidebar-menu').on('mousedown','li a',function(e){   
    			$(".sidebar-menu li").removeClass("active");
    			$(this).parent("li").addClass("active") ;  			
    		});
    		var beforeShowFunc = function() {
    			
    		};
			var menu = [
			    {'<i class="fa fa-pencil mg-r-5"></i>新建':function(menuItem,menu){newFolder();}},
				{'<i class="fa fa-search mg-r-5"></i>发布':function(menuItem,menu){publishFolder();}},
				{'<i class="fa fa-download mg-r-5"></i>下载':function(menuItem,menu) {downloadFolder();}},	
			    {'<i class="fa fa-edit mg-r-5"></i>编辑':function(menuItem,menu) {renameFolder();}},	
			    {'<i class="fa fa-trash mg-r-5"></i>删除</font>':function(menuItem,menu) {deleteFolder();} }
			];
			$('.br-subleft').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});		
    	})
    </script>
</body>
</html>
