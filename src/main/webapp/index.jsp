<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
public String getParameter(HttpServletRequest request,String str)
	{
	if(request.getParameter(str)==null)
		return "";
	else
		return request.getParameter(str);
	}
%>
<%
	if(1==1) {
		response.sendRedirect("index");
		return;
	}

String Username = "";
String Username2 = "";

Cookie[] cookies = request.getCookies();
if(cookies!=null)
{
	for(int i=0;i<cookies.length;i++)
	{
		if(cookies[i].getName().equals("Username"))
			Username = cookies[i].getValue();	
		if(cookies[i].getName().equals("Username2"))
			Username2 = cookies[i].getValue();	
	}
}

String Url = getParameter(request,"Url");
System.out.println("url="+Url);
if(!Username2.equals(""))
{
		UserInfo userinfo = new UserInfo();

		if(userinfo.Authorization(request,response,Username,Username2,true)==1)
		{
			if(Url.equals(""))
				response.sendRedirect("main.jsp");
			else 
				response.sendRedirect(Url);
			return;
		}
}

String copyright = CmsCache.getParameter("copyright").getContent();//底部
String background_image = CmsCache.getParameter("background_image").getContent();//背景图片
String logo_image = CmsCache.getParameter("logo_image").getContent();

String ico = "favicon.ico";
String title_ = tidemedia.cms.system.CmsCache.getCompany();
tidemedia.cms.util.TideJson system_ico = tidemedia.cms.system.CmsCache.getParameter("system_ico").getJson();
if(system_ico!=null){
	if(!system_ico.getString("ico").equals("")){
		ico = system_ico.getString("ico");
	}
	if(!system_ico.getString("title").equals("")){
		title_ = system_ico.getString("title_main");
	}
}

%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title><%=title_%></title>
<link rel="Shortcut Icon" href="<%=ico%>"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<!-- vendor css -->
<link href="lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<!-- Bracket CSS -->
<link rel="stylesheet" href="style/2018/bracket.css">
<link rel="stylesheet" href="style/2018/login.css">
</head>

<body  class="bg-br-primary" onload="init();" >
	<div class="login">

		<div class="login-top">
  		    <div class="logo">
  			    <img src="img/2019/<%=logo_image%>">
  			</div> 	
  		</div>

		<div class="d-flex login-mid align-items-center justify-content-center  ">
			<div class="login-wrapper wd-300 wd-xs-350 pd-25 pd-x-40 bg-white rounded shadow-base">
				<div class="signin-logo tx-center tx-30 tx-bold tx-inverse mg-b-20">
					<span class="tx-normal"></span> <i class="fa fa-user-circle-o"></i> <span class="tx-normal"></span>
				</div>
				<form name="form" action="" method="post" id="form" onSubmit="return check();">
					<div class="form-group">
					  <input type="text" class="form-control" placeholder="用户名" name="Username" id="Username">
					</div><!-- form-group -->
					<div class="form-group">
					  <input type="password" class="form-control" placeholder="密码" name="Password" id="Password">
					  <!--<a href="" class="tx-info tx-12 d-block mg-t-10">Forgot password?</a>-->
					</div><!-- form-group -->
					<div class="row flex-row align-items-center justify-content-left mg-t-20 mg-b-10 mg-l-0" id="">
						<label class="d-flex " id="">
							<label class="ckbox cursor-pointer" for="login_remember">
							<input type="checkbox" value="0"  name="CookieLogin" id="login_remember">
								<span for="login_remember" class="pd-l-0-force">保持登录</span>
							</label>
						</label>
					</div>
					<button type="button" class="btn btn-info btn-block" onClick="loginUser()" id="login_button">登录</button>
					    <input name="Url" type="hidden" id="Url" value="<%=Url%>">
				</form>
			</div><!-- login-wrapper -->
	    </div><!-- d-flex -->

		<div class="login_footer index-login_footer tx-14 tx-white">
	    	<%=copyright%>
	    </div>
    </div>

	<script src="lib/2018/jquery/jquery.js"></script> 
	<script src="common/2018/common2018.js"></script>
	<script src="common/jquery.base64.js" type="text/javascript"></script>  
    <script src="lib/2018/popper.js/popper.js"></script>
    <script src="lib/2018/bootstrap/bootstrap.js"></script>
    <script src="common/jquery.anystretch.min.js"></script>
	<script>
		$(".login").anystretch("<%=background_image%>");
		
		$(function (){
		    $("#Username").val("<%=Username%>");
		    
		    
		    $("#login_remember").on("click",function(){
                if($(this).val()==0){
                    $(this).val(1);
                }else{
                    $(this).val(0);
                }
            })
		})
		
		function init()
		{
			if (top.location != self.location)top.location=self.location;
			document.form.Username.focus();
			document.form.Username.value = "<%=Username%>";
			
			if(document.form.Username.value=="")
				document.form.Username.focus();
			else
				document.form.Password.focus();

			//$.anystretch("./images/login_bg/default.jpg",{speed: 150});
		}

		function check()
		{
			if(document.form.Username.value=="")
			{
				alert("请输入用户名!");
				document.form.Username.focus();
				return false;
			}
			if(document.form.Password.value=="")
			{
				alert("请输入密码!");
				document.form.Password.focus();
				return false;
			}

			return true;
		}
		
	function loginUser(){
		var data="Username="+$("#Username").val()+"&Password="+$.base64.encode($("#Password").val())+"&Url="+$("#Url").val()+"&CookieLogin="+$("#login_remember").val();
	    var url=$("#Url").val();
	     var options={
			url:"login.jsp",
			type:'post',
			data:data,
			success: function(result)
			{
				if(1==result)
				{
				   if(url=="")
				   {
					   window.location.href = "main.jsp";
				   }
				   else
				   {
					 var suffix = "/index.jsp";
					 if(url.indexOf(suffix, url.length-suffix.length)!==-1)
					 {
						 window.location.href = "main.jsp";
					 }else 
					 {
						 window.location.href = url;
					 }
				   }
				}
				else if(result==3)
				{
					alert("尝试次数太多，稍后再试!");	
				}
				else if(result==4)
				{
					alert("请输入密码!");	
				}
				else if(result==5)
				{
					alert("请输入用户名!");	
				}
				else
				{
					alert("用户名或密码错误")
				}
			}
		};
		$.ajax(options);
	}
	
	$(document).keydown(function(event){ 
		if(event.keyCode==13){ 
			$("#login_button").click(); 
		} 
	}); 
	
	if(typeof IEVersion()=="number" && IEVersion() <=11 && IEVersion() >0 ) {
		$(".login").css("display","block")
		$(".login-mid").css({
			"margin-top":"0px",
			"padding-top":"75px"
		})
	}	
	</script>
</body>
</html>
