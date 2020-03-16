<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
String Username ="";
String Username2=userinfo_session.getUsername2();
Cookie[] cookies = request.getCookies();
if(cookies!=null)
{
    for(int i=0;i<cookies.length;i++)
    {
        if(cookies[i].getName().equals("Username"))
            Username = cookies[i].getValue();   
    }
}
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
int userId = userinfo_session.getId();

String copyright = CmsCache.getParameter("copyright").getContent();//tcenterMedia访问链接
String background_image = CmsCache.getParameter("background_image").getContent();//背景图片地址
String logo_image = CmsCache.getParameter("logo_image").getContent();//tcenter-Logo封面
TideJson json = CmsCache.getParameter("tcenter_main").getJson();//首页模块
JSONArray arr = new JSONArray();
if(json!=null&&json.getInt("state")==1){
	arr = json.getJSONArray("main");
}

//系统通知
TableUtil tu = new TableUtil("user");
java.util.Date date = new java.util.Date();
String dateStr = "";
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
dateStr = sdf.format(date);
String noticeSql = "select Title from notice where StartDate < '"+dateStr+"' and EndDate > '"+dateStr+"'";
ResultSet noticeRs = tu.executeQuery(noticeSql);
List<String> noticeList = new ArrayList<String>();
while(noticeRs.next()){
    noticeList.add(noticeRs.getString("Title"));
}
tu.closeRs(noticeRs);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="<%=ico%>">
<title><%=title_main%></title>
<!-- vendor css -->
<link href="lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<!-- Bracket CSS -->
<link rel="stylesheet" href="style/2018/bracket.css">
<link rel="stylesheet" href="style/2018/common.css">
<link rel="stylesheet" href="style/2018/login_tcenter.css">
<link rel="stylesheet" href="style/2018/animate.min.css">
<link rel="stylesheet" href="lib/2018/swiper/css/swiper.min.css">
</head>
<style type="text/css">
	.fa {
		font-size: 30px;
	}
</style>
<body class="bg-br-primary">
  	<div class="login">

		<div class="login-top clearfix">
  			<div class="logo">
  			    <img src="img/2019/<%=logo_image%>">
  			</div>
			<div class="system-info tx-14 tx-white  d-flex">
				<% if(noticeList.size()!=0){ %>
		      	<span class="tx-bold mg-r-10">系统通知：</span>
		      	<div class="info-box swiper-container">		      		
		      		<div class="swiper-wrapper">
						<%for(int i= 0;i<noticeList.size();i++){%>
						<div class="swiper-slide"><%=noticeList.get(i)%></div>
						<%}%>				      		
			      	</div>				      	
			    </div>
				<%}%>
			</div>
			<div class="login_out tx-white">
  				<i class="fa fa-user-circle-o tx-26 mg-r-10"></i>
  				<span><%=userinfo_session.getName()%>，你好</span> 	
  				<a href="media_help.html" target="_blank" title="帮助中心" class="valign-middle tx-gray-900 mg-l-10"><i class="icon ion-help-circled tx-18 tx-white"></i></a>
  				<span class="mg-x-8">|</span>
  				<a href="logout.jsp" class="tx-white">退出</a>
  			</div>
		</div>
		
		<div class="login-mid d-flex">
	    	<div class="wd-lg-1000">

	    		<!--此通知显示在手机端-->
	    		<div class="system-info system-info-wap  tx-14 tx-white d-flex">
			      	<% if(noticeList.size()!=0){ %>
					<span class="tx-bold mg-r-10">系统通知：</span>
					<div class="info-box swiper-container">		      		
						<div class="swiper-wrapper">
							<%for(int i= 0;i<noticeList.size();i++){%>
							<div class="swiper-slide"><%=noticeList.get(i)%></div>
							<%}%>				      		
						</div>				      	
					</div>
					<%}%>
				</div>

				<div class="d-flex justify-content-center index-nav">
		    		<ul class="d-flex">
						<%
						for(int i=0;i<arr.length();i++){
							JSONObject json1 = arr.getJSONObject(i);//一级分组
							String menu = json1.getString("menu");
						%>
						<li <%if(i==0){%>class="ac"<%}%>><a href="javascript:;"><%=menu%></a></li>
						<%}%>		    			
		    		</ul>
		    	</div>

				<div class="conten-box">
					<%
					for(int i=0;i<arr.length();i++){
						JSONObject json1 = arr.getJSONObject(i);//一级分组
						String menu = json1.getString("menu");
						if(menu.equals("media")){continue;}
						JSONArray arr1 = json1.getJSONArray("module");
					%>						
					<div class="login_in_menu_box wd-lg-1000 mg-t-30">
						<div class="row tx-white">
							<%
							for(int j=0;j<arr1.length();j++){
								JSONObject json2 = arr1.getJSONObject(j);
								String title = json2.getString("title");
								String class_ = json2.getString("class");
								int id = json2.getInt("id");
							%>
							<div class="col-sm-6 <%=class_%>">
								<h6 class="tx-white tx-14 tx-bolder lh-40px"><%=title%></h6>
								<ul>
<%
//首页模块
String sql = "select  tp.logo,tp.Name prjname,tp.Url,tp.groupId,up.status,tp.newpage from "+
             "tide_products tp left join (select * from user_product where UserId = "+userId+") up on tp.id =up.ProductId  where tp.Status=1 and tp.groupId="+id;
ResultSet Rs = tu.executeQuery(sql);
while(Rs.next()){
	boolean flag =(Rs.getString("status")==null||("1".equals(Rs.getString("status")))||"".equals(Rs.getString("status")));
	if(!flag){
		continue;
	}

	String href = convertNull(Rs.getString("Url"));
	if("/".equals(href.indexOf(0))){
		href = base + href;
	}
	String target = "";
	if(Rs.getInt("newpage")==1){
		target = "target='_blank'";
	}
	String logo = convertNull(Rs.getString("logo"));
	String prjname = convertNull(Rs.getString("prjname"));
%>
									<li class="op-9">
										<a href="<%=href%>" <%=target%>>
											<%=logo%>
											<span><%=prjname%></span>
										</a>
									</li>

<%	
}
tu.closeRs(Rs);
%>
									<!--添加按钮样式区别对待-->
									<li class="op-4 add-li">
										<a href="javascript:controlDisplay(<%=id%>);">
											<i class="fa fa-plus tx-30"></i>		    						
										</a>		    						
									</li>
									<!--添加按钮end-->
								</ul>
							</div>
								<%if((j+1)%2==0){%>
						</div>
						<div class="row  tx-white mg-t-20">
								<%}%>	
							<%}%>
						</div>
					</div>
					<%}%>
				</div>

			</div>
		</div><!--d-flex-->

		<div class="login_footer index-login_footer tx-14 tx-white"><%=copyright%></div>
	    
    </div><!--login-->
    
    <script src="lib/2018/jquery/jquery.js"></script> 
    <script src="lib/2018/popper.js/popper.js"></script>
    <script src="lib/2018/bootstrap/bootstrap.js"></script>
    <script src="lib/2018/swiper/js/swiper.min.js"></script>
    <script src="common/jquery.anystretch.min.js"></script>
    <script src="common/2018/common2018.js"></script>
    <script src="common/2018/TideDialog2018.js"></script>
    <script>
		$(".login").anystretch("<%=background_image%>");

		/*切换*/
		$(".index-nav ul li").click(function(){
			if( $(this).hasClass("ac") ){
				return 
			}
			var index  = $(this).index() ;
			$(this).addClass("ac").siblings().removeClass("ac") ;
			$(".login_in_menu_box").slideUp().eq(index).slideDown()
		})
		
		function controlDisplay(type){
			var url = "zidingyi.jsp?type="+type;
	    	var	dialog = new top.TideDialog();
				dialog.setWidth(545);
				dialog.setHeight(480);
				dialog.setUrl(url);
				dialog.setTitle('自定义显示模块');
				//dialog.setChannelName('资源栏目');
				dialog.show();
		}
		
		var mySwiper = new Swiper('.swiper-container', {
	        direction: 'vertical',
	        autoplay: {
		        delay: 60000,
		    },
		    loop : true,
	        slidesPerView: 1,
	        spaceBetween: 30,
	        mousewheel: true,
	        pagination: {
	          el: '.swiper-pagination',
	          clickable: true,
	        },
	    });
	    if(mySwiper.slides.length<=3){
		    mySwiper.destroy();
		}
	</script>

  </body>	
</html>