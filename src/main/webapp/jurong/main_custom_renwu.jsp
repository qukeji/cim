<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.Date,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);
 
String basePath = request.getScheme()+"://"+request.getServerName();
int port = request.getServerPort();
if(port>0)
	basePath +=":"+port;
basePath +="/";
 int Flag = getIntParameter(request,"Flag");
    int childGroup =  getIntParameter(request,"childGroup");
    String time = CmsCache.getExpiresDateStr();
    long current = System.currentTimeMillis();
    time  = time.replaceAll("-","/");
    Date date = new Date(time);
    long ExpiresDate = date.getTime();
    long diff = (ExpiresDate - current)/1000; //秒
    String url = request.getRequestURL()+"";
    String base = url.replace(request.getRequestURI(),"");
    if(CmsCache.hasValidLicense()) diff = 1000000;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<title>任务管理 - Tide Media Center 融合媒体业务平台</title>
<link rel="Shortcut Icon" href="<%=ico%>">

    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/sidebar-menu-channel.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<style type="text/css">
html,body {
	margin:0;

}
.active1 {
            color: #0d86c4;
        }

</style>


</head>
<script language=javascript>

function menu(str)
{
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = "myhome=" + str + ";expires=" + expires.toGMTString();
	if(str=="index"){
		setClass(str);
		main.location="blank_resource.jsp";
	}else if(str=="system"){
		set_main_class(str);
		main.location="system/index.jsp";}
	else
	{
		setClass(str);
		var href = $("#home_"+str).attr("href");
		if(href) main.location = href;
	}
}
function set_main_class(str){
	jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+str).addClass('on');
}

function setClass(id){
	 jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+id).addClass('on');
 
}
</script>

<body onLoad="">
<div class="br-logo"><a href="<%=base%>/tcenter/main.jsp"><img src="../images/2018/system-logo.png"></a></a></div>
    <%
    int channelId1 = CmsCache.getParameter("daping").getJson().getInt("renwu");
    int	id	   = getIntParameter(request,"id");
    
    %>
	<div class="br-sideleft ">
		<label class="sidebar-label pd-x-15 mg-t-20"></label>
			<div class="br-sideleft-menu" >
			<a href="javascript:show(id=<%=channelId1%>);" class="br-menu-link active menu-home">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-home tx-22"></i>
							<span class="menu-item-label">任务管理</span>
					</div>
					<!-- menu-item -->
			</a>
			
			</div>
			 <div class=" sidebar-menu-box ht-100p-force">
    		    <ul class="tid_item3 sidebar-menu">
    
                </ul>
			 </div>
			<!-- br-sideleft-menu -->
		</div>
        <!-- br-sideleft -->

<div class="br-header" style="margin-bottom: 200px">
    <div class="br-header-left">
        <div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
        <div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
        <div class="hidden-md-down system-name"><a href="javascript:;"><i class=""></i>任务管理</a></div>
    </div>
    <div class="br-header-right">
        <nav class="nav">
            <div class="dropdown">
                <a href="" class="nav-link nav-link-profile" data-toggle="dropdown">
                    <i class="icon fa fa-user-circle-o  tx-26-force"></i>
                </a>
                <div class="dropdown-menu dropdown-menu-header wd-200">
                	<span class="logged-name mg-l-15 pd-y-5">你好，<%=userinfo_session.getName()%></span>
                    <ul class="list-unstyled user-profile-nav">
                        <li><a href="../person/index2018.jsp"><i class="icon ion-ios-person"></i> 个人信息</a></li>
                        <li><a href="../logout.jsp"><i class="icon ion-power"></i> 退出</a></li>
                    </ul>
                </div>
                <!-- dropdown-menu -->
            </div>
            <!-- dropdown -->
        </nav>
    </div>
</div>


<div class="br-mainpanel with-second-nav br-mainpanel-file " id="js-source">
    <iframe name="ifm_right" id="content_frame" src="content_custom_rwgl.jsp?id=<%=channelId1%>" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
</div><!-- br-mainpanel -->

<script type="text/javascript">
    $(function() {
        var $this = $(this);
        var checkElement = $this.next();
        var load = $this.attr("load");
        var channelid = $this.attr("channelid");
        var haveChild = $this.find("i").attr("have");
        var url="channel_json.jsp?ChannelID="+<%=channelId1%>;
        $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            beforeSend:function(){
                if(haveChild==1){
                    var loadingHtml = '<ul class="treeview-menu nav-loading" style="display: block;"><li><a class="tx-white tx-13-force" href="javascript:;"><i class="fa tx-13-force fa-spinner" aria-hidden="true"></i>loading</a></li></ul>'
                    $this.after(loadingHtml)
                }
            },
            success: function(res){
                res1=res;
                console.log(res1);
                var html = '';
                for(var i in res1)
                {
                     if(res1[i].child && res1[i].child.length>0)
                            {
                                html += '<li class="treeview ">';
                            }
                            else
                            {
                                html += '<li class="active1">';
                            }
                            html += '<a  href="javascript:show(id='+res1[i].id+');">';

                            if(res1[i].load==1||(res1[i].child && res1[i].child.length>0)){
                                if(res1[i].type==0){   //判断是独立非独立表单
                                    html += '<i class="fa fa-angle-double-right" hava="1"></i>';
                                }else{
                                    html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>';
                                }
                                //html += '<i class="fa fa-television"></i>';
                            }else{
                                if(res1[i].type==0){
                                    html += '<i class="fa fa-angle-right" hava="0"></i>';
                                }else{
                                    html += '<i class="fa fa-angle-right op-5" hava="0"></i>';
                                }
                            }
                            html += '<span class="nav-link1 system-menu1'+res1[i].id+'" >'+res1[i].name+'</span></a>';

                            if(res1[i].child && res1[i].child.length>0)
                            {
                                html += '<ul class="treeview-menu">' + get_menu_html(res1[i]) + '</ul>';
                            }
                            html += '</li>';
                            
                        
                }
                 html += '</ul>';
                html += '</ul>';
					$(".nav-loading").remove();
					$this.nextAll().remove();
				
					$this.attr("load",0);//加载完毕改变load属性
					
               
              
                
                var oContent = $('.tid_item3');
                oContent.html(html);
                
            }
        });
    });
 function show(id){
     $(".nav-link1").removeClass("active1");
	    $(".system-menu1"+id).addClass("active1");
     var loc = "";
     loc = "content_custom_rwgl.jsp?id="+id;
      changeFrameSrc( window.frames["content_frame"] , loc )

 }

</script>
</body>
</html>
