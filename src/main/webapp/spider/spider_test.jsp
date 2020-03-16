<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				java.util.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
%>


<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
Spider  spider = new Spider(id);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>采集测试</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <!--<link href="../style/9/tidecms7.css" rel="stylesheet" />-->
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
    <!--<link href="../../lib/2018/datatables/jquery.dataTables.css" rel="stylesheet">-->
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">  
    <link rel="stylesheet" href="../style/2018/common.css">  
	<script src="../lib/2018/jquery/jquery.js"></script>
    <style>
        #msg{color:#333;line-height:1.5;}
        ul,li{list-style:none;}
        #urls{background:#fff;border-radius:5px;padding:15px 10px;max-width:900px;}
    </style>
    <script>
var spiderid = <%=spider.getId()%>;

function test(i)
{
	$("#msg").html("正在加载...");
	$("#msg").load("spider_test2.jsp?id="+spiderid+"&flag="+i);
}

function spider_start()
{
	$("#urls li").each(function(){
		var o = $(this);
		var oo = o.find(".message");
		oo.html("正在采集...");
		var url="spider_item.jsp?url=" + (o.attr("href")) + "&id=" + spiderid;
			  $.ajax({
				 type: "GET",dataType:"json",url: url,
				 success: function(o){
					 var html = "  <font color='blue'>总数："+o.total;
					 if(o.false>0) html += ",有"+o.false+"个发生错误，请查看日志</font>";
					 oo.html(html);},
				 error:function(){oo.html("  <font color='red'>失败</font>");}
			}); 
	}); 
}

function content_test()
{
	$("#content_test_message").load("spider_test2.jsp?id="+spiderid+"&flag=5&url=" + encodeURIComponent($("#content_url").val()));
}

function content_preview()
{
	window.open($("#content_url").val());
}
</script>
</head>

<body>
<div class="" >
	<div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
        	<span class="breadcrumb-item active">采集测试：<%=spider.getName()%></span>
        </nav>
    </div>
	<div class="br-pagebody pd-x-20 pd-sm-x-30">
	
		<div class="d-flex flex-wrap" id="btn-group">
	        <a href="javascript:" onclick="test(1)" class="btn btn-primary mg-r-10 pd-x-15-force pd-y-10-force mg-r-10">
		        <span>测试采集地址</span>
		    </a>
		    <a href="javascript:" onclick="test(2)" class="btn btn-primary mg-r-10 pd-x-15-force pd-y-10-force mg-r-10">
		        <span>测试列表页</span>
		    </a>
		    <a href="javascript:" onclick="test(3)" class="btn btn-primary mg-r-10 pd-x-15-force pd-y-10-force mg-r-10">
		        <span>测试内容页</span>
		    </a>
		    <a href="javascript:" onclick="test(4)" class="btn btn-primary mg-r-10 pd-x-15-force pd-y-10-force mg-r-10">
		        <span>手工采集</span>
		    </a>
	    </div>
		
		<div class="" id="msg">
			
		</div>
		<div class="viewpane_pages"></div>
</div>
</div>
<!-- <div class="content_bot"> -->
<!-- 	<div class="left"></div> -->
<!--     <div class="right"></div> -->
<!-- </div> -->
</body>
</html>
