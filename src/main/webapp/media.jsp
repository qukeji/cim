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
String copyright = CmsCache.getParameter("copyright").getContent();
String background_image = CmsCache.getParameter("background_image").getContent();
String system_logo = CmsCache.getParameter("system_logo").getContent();
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
Integer userId = userinfo_session.getId();
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");

String whereSql = "";
//获取租户的产品权限
int companyid = userinfo_session.getCompany();
if(companyid>0){//当前登录用户是租户用户
	String products = new Company(companyid).getProducts();
	if(products.equals("")){products="-1";}
	whereSql += " and tp.id in ("+products+")";
}

TableUtil tu = new TableUtil("user");
/*
//获取用户的产品权限
String sql = "select ProductId from user_product where UserId = "+userId+" and status=1";
ResultSet Rs_ = tu.executeQuery(sql);
String ProductIds ="";
while(Rs_.next()){
	if(!ProductIds.equals("")){
		ProductIds += ",";
	}
	ProductIds += Rs_.getInt("ProductId");
}
tu.closeRs(Rs_);
if(!ProductIds.equals("")){
	whereSql += " and id in ("+ProductIds+")";
}
*/

String sql = "select tp.logo,tp.code,tp.Name prjname,tp.Url,tp.groupId,up.status,tp.newpage from tide_products tp left join (select * from user_product where UserId = "+userId+") up on tp.id =up.ProductId";
sql += " where tp.Status=1"+whereSql;
sql += " order by tp.OrderNumber asc,tp.id asc";

ResultSet Rs = tu.executeQuery(sql);
JSONArray yyzc = new JSONArray();
JSONArray yyfb = new JSONArray();
JSONArray zyhj = new JSONArray();
JSONArray scgj = new JSONArray();
while(Rs.next()){
	if("company".equals(tu.convertNull(Rs.getString("code")))){
		continue;
	}
	if("operate".equals(tu.convertNull(Rs.getString("code")))){
		if(!userinfo_session.hasPermission("OperateSystem")){
			continue;
		}
	}
    JSONObject obj = new JSONObject();
    obj.put("logo",Rs.getString("logo"));
//	obj.put("prjname",Rs.getString("Name"));
    obj.put("prjname",Rs.getString("prjname"));
    obj.put("Url",Rs.getString("Url"));
    obj.put("groupId",Rs.getString("groupId"));
    obj.put("newpage",Rs.getInt("newpage"));
    boolean flag =(("1".equals(Rs.getString("status")))||Rs.getString("status")==null||"".equals(Rs.getString("status")));
    obj.put("status",flag);
    if("1".equals(Rs.getString("groupId"))){
		yyzc.put(obj);
    }else if("2".equals(Rs.getString("groupId"))){
        yyfb.put(obj);
    }else if("3".equals(Rs.getString("groupId"))){
        zyhj.put(obj);
    }else if("4".equals(Rs.getString("groupId"))){
        scgj.put(obj);
    }
}
tu.closeRs(Rs);

//系统通知
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
    <link href="lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="style/2018/bracket.css">
    <link rel="stylesheet" href="style/2018/common.css">
    <link rel="stylesheet" href="style/2018/login.css">
    <link rel="stylesheet" href="style/2018/animate.min.css">
    <link rel="stylesheet" href="lib/2018/swiper/css/swiper.min.css">
  </head>
    <style>
        .fa{ font-size: 30px;}        
        .br-sideright{z-index:1000 !important;}
    </style>
  <body class="bg-br-primary">
    <div class="br-logo">
    	<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="javascript:;">
    	   <img class="ht-100p" src="img/2019/<%=system_logo%>">
    	</a>
    </div>
	<div class="br-header">
        <div class="br-header-left">
            <div class="hidden-md-down system-name"><a href="javascript:;"><i class=""></i>管理门户</a></div>
        </div>
        <!-- br-header-left -->

		<%@include file="include/header_navigate.jsp"%><!--静态包含-->
        <!-- br-header-right -->
    </div>
    <!-- br-header -->
	
	
  	<div class="login">
	    <div class="login-mid d-flex   ">
	    	<div class="wd-lg-1000">
	    		<div class="d-flex flex-column justify-content-start">
		    		<div class="system-info tx-14 tx-white lh-40px">
		    		    <% if(noticeList.size()!=0){ %>
		    		        <div class="tx-bold">系统通知</div>
		    		        <div class="info-box swiper-container">
		    		        <div class="swiper-wrapper">
		    		        <%for(int i= 0;i<noticeList.size();i++){%>
		    		            <div class="swiper-slide"><%=noticeList.get(i)%></div>
				    	<%}%>
		    		         </div>
		    		         </div>
		    		        <%}%>
				    </div>
		    	</div>
		    	<div class="login_in_menu_box wd-lg-1000 mg-t-30">
				<div class="row  tx-white">
		    			<div class="col-sm-6 yyzc">
		    				<h6 class="tx-white tx-14 tx-bolder lh-40px"> 运营支撑</h6>
		    				<ul>
		    				    <%for(int i=0;i<yyzc.length();i++){
		    				        if(!yyzc.getJSONObject(i).getBoolean("status")){
		    				            continue;
		    				        }
		    				        String href = yyzc.getJSONObject(i).getString("Url");
		    					    if("/".equals(href.indexOf(0))){
		    					        href = base + href;
		    					    }
		    					    String target = "";
		    					    if(yyzc.getJSONObject(i).getInt("newpage")==1){
		    					        target = "target='_blank'";
		    					    }
		    				    %>
		    				        <li class="op-9">
		    						<a href="<%=href%>" <%=target%>>
		    							<%=yyzc.getJSONObject(i).getString("logo")%>
		    							<span><%=yyzc.getJSONObject(i).getString("prjname")%></span>
		    						</a>
		    					</li>
		    				    <%}%>
		    					<!--添加按钮样式区别对待-->
		    					<li class="op-4 add-li">
		    						<a href="javascript:controlDisplay(1);">
		    							<i class="fa fa-plus tx-30"></i>		    						
		    						</a>		    						
		    					</li>
		    					<!--添加按钮end-->
		    				</ul>
		    			</div>
						<div class="col-sm-6 yyfb">
		    				<h6 class="tx-white tx-14 lh-40px tx-bolder">应用发布</h6>
		    				<ul>
		    					<%for(int i=0;i<yyfb.length();i++){
		    					    if(!yyfb.getJSONObject(i).getBoolean("status")){
		    				            continue;
		    				        }
		    					    String href = yyfb.getJSONObject(i).getString("Url");
		    					    if("/".equals(href.indexOf(0))){
		    					        href = base + href;
		    					    }
		    					    String target = "";
		    					    if(yyfb.getJSONObject(i).getInt("newpage")==1){
		    					        target = "target='_blank'";
		    					    }
		    					%>
		    				        <li class="op-9">
		    						<a href="<%=href%>" <%=target%>>
		    							<%=yyfb.getJSONObject(i).getString("logo")%>
		    							<span><%=yyfb.getJSONObject(i).getString("prjname")%></span>
		    						</a>
		    					</li>
		    				    <%}%>
		    					<!--添加按钮样式区别对待-->
		    					<li class="op-4 add-li">
		    						<a href="javascript:controlDisplay(2);">
		    							<i class="fa fa-plus tx-30"></i>		    						
		    						</a>		    						
		    					</li>
		    					<!--添加按钮end-->
		    				</ul>
		    			</div>
		    		</div>

		    		<div class="row  tx-white mg-t-20">
		    			<div class="col-sm-6 zyhj">
		    				<h6 class="tx-white tx-14 tx-bolder lh-40px">资源汇聚</h6>
		    				<ul>
		    					<%for(int i=0;i<zyhj.length();i++){
		    					    if(!zyhj.getJSONObject(i).getBoolean("status")){
		    				            continue;
		    				        }
		    					    String href = zyhj.getJSONObject(i).getString("Url");
		    					    if("/".equals(href.indexOf(0))){
		    					        href = base + href;
		    					    }
		    					    String target = "";
		    					    if(zyhj.getJSONObject(i).getInt("newpage")==1){
		    					        target = "target='_blank'";
		    					    }
		    					%>
		    				        <li class="op-9">
		    						<a href="<%=href%>" <%=target%>>
		    							<%=zyhj.getJSONObject(i).getString("logo")%>
		    							<span><%=zyhj.getJSONObject(i).getString("prjname")%></span>
		    						</a>
		    					</li>
		    				    <%}%>
		    					<!--添加按钮样式区别对待-->
		    					<li class="op-4 add-li">
		    						<a href="javascript:controlDisplay(3);">
		    							<i class="fa fa-plus tx-30"></i>		    						
		    						</a>		    						
		    					</li>
		    				</ul>
		    			</div>

		    			<div class="col-sm-6 scgj">
		    				<h6 class="tx-white tx-14 lh-40px tx-bolder">生产工具</h6>
		    				<ul>
		    					<%for(int i=0;i<scgj.length();i++){
		    					    if(!scgj.getJSONObject(i).getBoolean("status")){
		    				            continue;
		    				        }
		    				        String href = scgj.getJSONObject(i).getString("Url");
		    					    if("/".equals(href.indexOf(0))){
		    					        href = base + href;
		    					    }
		    					    String target = "";
		    					    if(scgj.getJSONObject(i).getInt("newpage")==1){
		    					        target = "target='_blank'";
		    					    }
		    					%>
		    				        <li class="op-9">
		    						<a href="<%=href%>" <%=target%>>
		    							<%=scgj.getJSONObject(i).getString("logo")%>
		    							<span><%=scgj.getJSONObject(i).getString("prjname")%></span>
		    						</a>
		    					</li>
		    				    <%}%>
		    					<!--添加按钮样式区别对待-->
		    					<li class="op-4 add-li">
		    						<a href="javascript:controlDisplay(4);">
		    							<i class="fa fa-plus tx-30">	</i>		    						
		    						</a>		    						
		    					</li>
		    					<!--添加按钮end-->
		    					
		    				</ul>
		    			</div>
		    		</div>
		    	
		    	</div>
	    	</div>


			</div><!-- d-flex -->
	    <div class="login_footer index-login_footer tx-14 tx-white">
	    	<%=copyright%>
	    </div>
	    
    </div>
    
    <script src="lib/2018/jquery/jquery.js"></script>   
    <script src="lib/2018/popper.js/popper.js"></script>
    <script src="lib/2018/bootstrap/bootstrap.js"></script>
    <script src="lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="lib/2018/swiper/js/swiper.min.js"></script>
    <script src="common/jquery.anystretch.min.js"></script>
     <script src="common/2018/common2018.js"></script>
     <script src="common/2018/TideDialog2018.js"></script>
     <script>
        $(".login").anystretch("<%=background_image%>");
     </script>
      <script src="common/2018/bracket.js"></script>

  </body>
	<script >
		
		
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
	    try{
			if(mySwiper.slides.length<=3){
    		    mySwiper.destroy();
    		}	
		}catch(e){}
	    
		if(typeof IEVersion()=="number" && IEVersion() <=11 && IEVersion() >0 ) {
			
			$(".login").css("display","block")
			$(".login-mid").css({
				"margin-top":"0px",
				"padding-top":"75px"
			})
		}	
	</script>
</html>
