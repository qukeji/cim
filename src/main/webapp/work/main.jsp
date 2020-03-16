<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.util.*,
                java.util.Date,
                org.json.*"%>
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
	if(CmsCache.getLicenseType().equals("Commercial")) diff = 1000000;//正式许可证不提示

    String system_logo = CmsCache.getParameter("system_logo").getContent();
    int   userinfo_sessionid=userinfo_session.getId();
    TideJson  tidejson = CmsCache.getParameter("personal_workbench").getJson();
    JSONArray jsonarr = tidejson.getJSONArray("urlarr");
    Channel task_doc = ChannelUtil.getApplicationChannel("task_doc");
    int channel_taskid = task_doc.getId() ;//选题id
    Channel channel = ChannelUtil.getApplicationChannel("task_subject");
    int channel_renwuid = channel.getId() ;//任务id
	Channel photoChannel = CmsCache.getChannel("photo");
    int photoId = photoChannel.getId() ;//图片id
	if(userinfo_session.getCompany()!=0){
		channel_taskid = new Tree().getChannelID(channel_taskid,userinfo_session);
		channel_renwuid = new Tree().getChannelID(channel_renwuid,userinfo_session);
	}

    int channel_shipingid=8800;
    int userid=userinfo_session.getId();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
     <link rel="Shortcut Icon" href="../<%=ico%>">
    <title><%=title_%></title>

    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    
    <script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>
   
	<script type="text/javascript" src="../lib/2018/vue/vue.min.js"></script>
	<script type="text/javascript" src="../lib/2018/vue/vue-router-v3.0.1.js"></script>
   
    <script>
        var  userinfo_sessionid=<%=userinfo_sessionid%>;
        var  listType="";
    </script>

    <script>
        function init() {
            window.status = "当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";

            <%if(diff<15*24*3600){%>
            tidecms.dialog("system/license_notify.jsp", 500, 300, "许可证到期提醒", 2);
            <%}%>
        }

        function reSize() {
            document.getElementById("main").style.height = Math.max(document.body.clientHeight - document.getElementById("main").offsetTop, 0) + "px";
        }

        function set_main_class(str) {
            jQuery('.header_menu  li').removeClass('on');
            jQuery('#home_' + str).addClass('on');
        }

        function feed() {
            title = '反馈'
            url = "http://123.125.148.3:888/cms/feedback.jsp";
            var dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(500);
            dialog.setUrl(url);
            dialog.setTitle(title);
            dialog.show();
        };
    </script>
    <style>
    	.br-menu-link.active{background:rgb(11, 148, 213)}
		.sidebar-menu .treeview-menu>li.active>a,#blue .sidebar-menu>li.active>a{background-color:rgb(11, 148, 213)}
		.sidebar-menu .treeview-menu>li.active>a span,#blue .sidebar-menu>li.active>a span{background-color:rgb(11, 148, 213)}
    </style>
   
</head>
<body onLoad="init();" class="email" id="">
<div id="app">
	<div class="br-logo">
		<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
			<img class="ht-100p" src="../img/2019/<%=system_logo%>">
		</a>
	</div>
	<div class="br-sideleft overflow-y-auto">
		<label class="sidebar-label pd-x-15 mg-t-20"></label>
		<div class="br-sideleft-menu">

			<router-link to="/workstate" class="br-menu-link menu-home">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-th-large  tx-22"></i>
					<span class="menu-item-label">工作台</span>
				</div>
			</router-link>
				<%
		if(userinfo_session.getRole()==1){
	%>	
		<router-link to="/workflow" class="br-menu-link menu-article">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-random tx-20"></i>
					<span class="menu-item-label">工作流</span>
				</div>
			</router-link>
	<%	
		}
	%>
			<a href="" class="br-menu-link menu-article">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-file-text-o tx-20"></i>
					<span class="menu-item-label">我的稿件</span>
					<i class="menu-item-arrow fa fa-angle-down"></i>
				</div>
			</a>

			<!-- br-menu-link -->
			<ul class="br-menu-sub nav flex-column" id="system-menu-site" >
				<li class="nav-item"><router-link to="/article" class="nav-link system-menu3">我的稿件库</router-link></li>
				<li class="nav-item"><router-link to="/elsearticle" class="nav-link system-menu3">其他稿件</router-link></li>
			</ul>

			<router-link to="/456" class="br-menu-link menu-shipin">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-youtube-play tx-20"></i>
					<span class="menu-item-label">我的视频</span>
					<i class="menu-item-arrow fa fa-angle-down"></i>
				</div>
			</router-link>

			<!-- br-menu-link -->
			<ul class="br-menu-sub nav flex-column" id="system-menu-site" >
				<li class="nav-item"><router-link to="/video" class="nav-link system-menu3">我的视频库</router-link></li>
				<li class="nav-item"><router-link to="/elsevideo" class="nav-link system-menu3">其他视频</router-link></li>
			</ul>

			<router-link to="/image" class="br-menu-link menu-image">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-hand-lizard-o tx-18"></i>
					<span class="menu-item-label">我的图片</span>
				</div>
			</router-link>

			<router-link to="/check" class="br-menu-link menu-check">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-hand-lizard-o tx-18"></i>
					<span class="menu-item-label">我的审核</span>
				</div>
			</router-link>

			<router-link to="/subject" class="br-menu-link menu-task">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-check-square-o tx-22"></i>
					<span class="menu-item-label">我的选题</span>
				</div>
			</router-link>
			<router-link to="/task" class="br-menu-link menu-renwu">
				<div class="br-menu-item">
					<i class="menu-item-icon fa fa-tasks tx-20"></i>
					<span class="menu-item-label">我的任务</span>
				</div>
			</router-link>
		</div>
		<!-- br-sideleft-menu -->
	</div>
	<!-- br-sideleft -->
	<div class="br-header">
		<div class="br-header-left">
			<div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
			<div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
			<div class="hidden-md-down system-name"><a href="javascript:;"><i class=""></i>个人工作台</a></div>
		</div>
		<!-- br-header-left -->
		<%@include file="../include/header_navigate.jsp"%><!--静态包含-->
		<!-- br-header-right -->
	</div>
		<!-- br-header -->
	<!-- ########## START: MAIN PANEL ########## -->
	<div class="br-mainpanel with-first-nav">
		
		<iframe src="" id="content_frame" style="width: 100%; height: 100%;" frameborder="0" onload="changeFrameHeight(this)"></iframe>

		<router-view></router-view>
	</div>
<!-- br-mainpanel0 -->
<!-- ########## END: MAIN PANEL ########## -->
</div>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>

<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>

    $(function() {
        'use strict'
        //$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
    
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
        $(window).resize(function() {
            minimizeMenu();
        });

        minimizeMenu();

        function minimizeMenu() {
            if (window.matchMedia('(min-width: 992px)').matches && window.matchMedia('(max-width: 1299px)').matches) {
                // show only the icons and hide left menu label by default
                $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
                $('body').addClass('collapsed-menu');
                $('.show-sub + .br-menu-sub').slideUp();
            } else if (window.matchMedia('(min-width: 1300px)').matches && !$('body').hasClass('collapsed-menu')) {
                $('.menu-item-label,.menu-item-arrow').removeClass('op-lg-0-force d-lg-none');
                $('body').removeClass('collapsed-menu');
                $('.show-sub + .br-menu-sub').slideDown();
            }
        }
    })

</script>

<script>
var channel_taskid="<%=channel_taskid%>";
var channel_renwuid="<%=channel_renwuid%>";
var channel_shipingid="<%=channel_shipingid%>";
var userid="<%=userid%>";


// 概览：
var workstate = {
	template: '<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()
	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', 'work_main_content.jsp');
			$(".navicon-right i").removeClass("tx-warning")
			$(".navicon-right .fa-th-large").addClass("tx-warning")
		}
	},
}
//工作流：
var workflow = {
	template:'<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()
	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', 'workflow_content.jsp');
			$(".navicon-right i").removeClass("tx-warning")
			$(".navicon-right .fa-random").addClass("tx-warning")
		}
	},
}
//我的稿件库：
var myarticle = {
	template:'<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()
	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', 'my_articlesContent.jsp')
			$(".navicon-right i").removeClass("tx-warning")
		}
	},
}
//其他稿件：
var elsearticle = {
	template:'<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()
	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', 'elsearticlesContent.jsp')
			$(".navicon-right i").removeClass("tx-warning")
		}
	},
}

// 我的图片：
var myimage = {
	template: '<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()
	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', 'my_imageContent.jsp?id=<%=photoId%>&listtype=2')
			$(".navicon-right i").removeClass("tx-warning")
		}
	},
}
// 我的审核：
var mycheck = {
	template: '<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()
	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', 'my_approveContent.jsp')
			$(".navicon-right i").removeClass("tx-warning")
		}
	},
}
//我的选题：
var mysubject = {
	template: '<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()
	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', '../subject/task_content.jsp?id='+channel_taskid+"&mytopic=1")
			$(".navicon-right i").removeClass("tx-warning")
		}
	},
}
//我的任务：
var mytask = {
	template: '<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()

	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', '../subject/renwu_content.jsp?id='+channel_renwuid+"&me=1");
			$("#mapmut").css({
				'margin-top': '0px',
				'display': 'block'
			})
			$(".navicon-right i").removeClass("tx-warning")

		}
	},
}
//我的视频库：
var myvideo = {
	template: '<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()

	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', '/vms/video/myvideo/my_shipinContent.jsp?id='+channel_shipingid+'&userId='+userid)
			$(".navicon-right i").removeClass("tx-warning")
		}
	},
}
//其他视频：
var elsevideo = {
	template: '<div></div>',
	created: function() {
		this.item()
	},
	mounted: function() {
		this.item()

	},
	methods: {
		item: function() {
			$("#content_frame").attr('src', '/vms/video/myvideo/elseshipinContent.jsp?id='+channel_shipingid+'&userId='+userid)
			$(".navicon-right i").removeClass("tx-warning")
		}
	},
}
var router = new VueRouter({
	routes: [
		{
			path: '/',
			redirect: '/workstate'
		},
		{
			path: '/',
			component: workstate
		},
		{
			path:'/workstate',
			component:workstate,
		},
		{
			path: '/workflow',
			component: workflow
		},
		{
			path: '/elsearticle',
			component: elsearticle,
		},
		{
			path: '/article',
			component: myarticle,
		},
		{
			path: '/check',
			component: mycheck
		},
		{
			path: '/image',
			component: myimage
		},
		{
			path: '/subject',
			component: mysubject
		},
		{
			path: '/task',
			component: mytask
		},
		{
			path: '/video',
			component: myvideo,
		},
		{
			path: '/elsevideo',
			component: elsevideo,
		},
	],
	linkActiveClass: 'active',
})

var vm = new Vue({
	el: '#app',
	data: {
	},
	methods: {
	},
	created: function() {},
	router:router
})

</script>
</body>

</html>
