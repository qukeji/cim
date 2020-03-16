<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,				 
				java.util.*,
				java.net.URLEncoder,
				java.security.*,
				java.sql.*,
				org.apache.commons.lang.StringEscapeUtils,
				java.sql.Connection,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
        String Username = "";
        String Password = "";
        Cookie[] cks = request.getCookies();
        if(cks!=null)
        {
            for(int i=0;i<cks.length;i++){
                if("user".equals(cks[i].getName())){					
                    Username = cks[i].getValue();        
                  			
                }
				 if("pass".equals(cks[i].getName())){
                    Password = cks[i].getValue();    					
                }				
            }
        }

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>欢迎登录_tidemedia</title>
<link rel="stylesheet" type="text/css" href="../usercenter/css/user.css">
<script src="../usercenter/js/jquery-1.7.2.min.js"></script>
<script>
$(function(){ 
	/* $.ajax({
		url:"__CONTROLLER__/get_switch",
		datatype:"json",
		success:function(data){
			var data = eval("("+data+")");
			if(data.status==1){
				$(".login_social").html('<span>用社交帐号直接登录：</span><ul class="third_party"></ul>');
				if(data.result['qq']==1){
					$(".third_party").append('<li class="qq"><a href="__MODULE__/Qq/Login" title="QQ登录">QQ登录</a></li>');
				}
				if(data.result['sina']==1){
					$(".third_party").append('<li class="weibo"><a href="__MODULE__/Xinlang/Login" title="微博登录">微博登录</a></li>');
				}
				if(data.result['weixin']==1){
					$(".third_party").append('<li class="weixin"><a href="__MODULE__/Weixin/Login" title="微信登录">微信登录</a></li>');
				}
			}
		}
	});*/

	$(document).keydown(function(event){ 
		if(event.keyCode == 13){
			$(".i_login").click();
		}
	});
	$(".i_login").click(function login(){
		var username = $("#username").val();
		var password = $("#password").val();
		var ver = $("#verify").val();
		var remember;
		if($("#login_form_savestate").attr("checked")=="checked"){
			remember = 1;
		}else{
			remember = 0;
		}
		if(!username){
			alert("用户名不能为空");
			$('#verify_img').attr('src','http://123.56.71.230:889/cms2018/usercenter/security_code_url.jsp?number='+Math.random());
			return false;
		}
		if(!password){
			alert("密码不能为空");
			$('#verify_img').attr('src','http://123.56.71.230:889/cms2018/usercenter/security_code_url.jsp?number='+Math.random());
			return false;
		}
		if(!ver){
			alert("验证码不能为空");
			$('#verify_img').attr('src','http://123.56.71.230:889/cms2018/usercenter/security_code_url.jsp?number='+Math.random());
			return false;
		}
		var veri = false;
		var url_code="../usercenter/security_code.jsp?verify=" + ver;
		$.ajax({			
			url:url_code,
			//data:"verify="+ver,
			//dataType:"html",
			dataType:'json',
			type:"POST",
			success:function(data){
				//alert(data);
				if(data.message == "good"){
					var url= "../usercenter/dologin2018.jsp?username="+username+"&password="+password+"&remember="+remember;
					$.ajax({
			                    url:url,
			                   // data:"username="+username+"&password="+password+"&remember="+remember,
			                    type:"post",
			                    datatype:"json",
			                    success:function(data){
				                    var data = eval("("+data+")");
				                      if(data.status == 1){
					                  window.location.href="../usercenter/"+data.msg;
				                      }else if(data.status == 0){
					                     alert(data.msg);
										$('#verify_img').attr('src','http://123.56.71.230:889/cms2018/usercenter/security_code_url.jsp?number='+Math.random()); 
				                      }else{
					                      alert("对不起，请您进行账号验证");
					                 window.location.href="../usercenter/resetpwd.jsp";
				                     }
			                          }
		                            });
				}else{
					alert("验证码有误");
					$('#verify_img').attr('src','http://123.56.71.230:889/cms2018/usercenter/security_code_url.jsp?number='+Math.random());
					$('#verify').focus();
				}
			}
		});

	});
});
</script>
</head>
<body>
<div class="login_header">
	<h1><a href="">tidemedia 欢迎登录</a></h1>
</div>
<div class="login_main">
	<div class="login_m_box">
		<div class="login_m_form">
		<form method="post">
			<div class="info_list"><label for="username">用户名：</label><input type="text" value="" class="i_username" id="username" name="username" value="<%=Username%>"></div>
			<div class="info_list"><label for="password">密码：</label><input type="password" value="" class="i_password" id="password" name="password" value="<%=Password%>" ></div>
			<div class="info_list"><label for="verify">验证码：</label><input type="text" value="" class="r_verify" id="verify" name="verify">
			<div class="r_verify_img"><img src="../usercenter/security_code_url.jsp" id="verify_img"></div><a href="javaScript:show();" class="r_v_refresh">换一张</a></div>
			<script>
				function show(){
					$('#verify_img').attr('src','http://123.56.71.230:889/cms2018/usercenter/security_code_url.jsp?number='+Math.random());
				}
			</script>
			<!--div class="login_error"><span style="display:none;">邮箱或密码不正确，请重新输入</span></div-->
			<div class="info_list auto_login">
				<div class="a_l_left"><label for="login_form_savestate"><input type="checkbox" id="login_form_savestate">记住密码</label></div>
				<div class="a_l_right"><a href="../usercenter/resetpwd.jsp" target="_blank">忘记密码</a><span>|</span><a href="../usercenter/reg.jsp" class="red" target="_blank">马上注册</a></div>
			</div>
			<div class="info_list login_btn"><input type="button" value="登录" class="i_login" name="login"></div>
			<div class="login_social">
				<span>用社交帐号直接登录：</span>
				<ul class="third_party">
					<li class="qq"><a href="#" title="QQ登录">QQ登录</a></li>
					<li class="weibo"><a href="#" title="微博登录">微博登录</a></li>
					<!-- <li class="weixin"><a href="{:U('Weixin/login')}" title="微信登录">微信登录</a></li> -->
					 <li class="weixin"><a href="#" title="微信登录">微信登录</a></li>
				</ul>
			</div>
		</form>
		</div>
	</div>
</div>
<div class="footer">
	<p>主办单位：泰德网聚（北京）科技有限公司<span>|</span>版权所有：泰德网聚</p>
	<p>Copyright © <a href="http://www.tidemedia.com" target="_blank">tidemedia</a></p>
</div>
</body> 
<script>
$(function() {
	var username="<%=Username%>";
    var passsword="<%=Password%>";  
	$('#username').val(username);
	$('#password').val(passsword);	
});	
</script>
</html>
