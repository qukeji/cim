<%@ page contentType="text/html;charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>欢迎注册_tidemedia</title>
<link rel="stylesheet" type="text/css" href="../usercenter/css/user.css">
<script type="text/javascript" src="../usercenter/js/jquery-1.7.2.min.js"></script>

<script>

$(function(){ 
	$(document).keydown(function(event){ 
		if(event.keyCode == 13){
			$(".reg_btn").click();
		}
	});
});

function checkform()
{
		
	var email=jQuery('#email').val();
	if(email=='')
	{
		jQuery('#email').next().html('<font color="red">　* </font>请填写邮箱！');
		jQuery('#email').focus();
		return false;
	} 
	var pattern = /^[a-z0-9]\w+@\w+.com(.cn)?$/;
	if(!pattern.test(email)){
		jQuery('#email').next().html('<font color="red">　* </font>邮箱格式不正确');
		jQuery("#email").focus();
		return false;
	}
	
	
	var useremailcheck=false;
	jQuery.ajax({
		url:"../usercenter/email_query.jsp",
		type: 'POST',
		async : false,
		dataType: "json",
		data:'email='+jQuery('#email').val(),
		success: function(data){
			if(data['status']=='failes')
			{
					useremailcheck=true;
			}
			else if(data['status']=='success')
			{
				jQuery('#email').next().html('<font color="red">　* </font>邮件重复');
				jQuery('#email').focus();
			}
		}
	});
	if(!useremailcheck)
	{ 
		return false;
	}

	jQuery('#email').next().html('');
	var username=jQuery('#username').val();
	if(username=='')
	{
		jQuery('#username').next().html('<font color="red">　* </font>请填写用户名！');
		jQuery('#username').focus();
		return false;
	}
	
	if(!/^\w+$/.test(username))
	{
		jQuery('#username').next().html('<font color="red">　* </font>用户名为字母数字下划线混合');
		jQuery('#username').focus();
		return false;
	}
	var usernamecheck=false;
	jQuery.ajax({
		url:"../usercenter/username_query.jsp",
		type: 'POST',
		async : false,
		dataType: "json",
		data:'username='+jQuery('#username').val(),
		success: function(data){
			if(data['status']=='failes')
			{
					usernamecheck=true;
			}
			else if(data['status']=='success')
			{
				jQuery('#username').next().html('<font color="red">　* </font>用户名重复');
				jQuery('#username').focus();
			}
		}
	});
	if(!usernamecheck)
	{ 
		return false;
	}
		
	jQuery('#username').next().html('');
	var password=jQuery('#password').val();
	if(password=='')
	{
		jQuery('#password').next().html('<font color="red">　* </font>请填写密码！');
		jQuery('#password').focus();
		return false;
	}
	if(password.length<6)
	{
		jQuery('#password').next().html('<font color="red">　* </font>密码长度不能小于6位！');
		jQuery('#password').focus();
		return false;
	}
		
	jQuery('#password').next().html('');
	var repassword=jQuery('#repassword').val();
	if(repassword=='')
	{
		jQuery('#repassword').next().html('<font color="red">　* </font>请填写密码确认！');
		jQuery('#repassword').focus();
		return false;
	}
	if(repassword!=password)
	{
		jQuery('#repassword').next().html('<font color="red">　* </font>两次密码输入不一致！');
		jQuery('#repassword').focus();
		return false;
	}
		
	jQuery('#repassword').next().html('');
	var veri = false;
	var ver = jQuery('#verify').val();
	if(ver==''){
		jQuery('.r_v_refresh').next().html('<font color="red">　* </font>请填写验证码！');
		jQuery('#verify').focus();
		return false;
	}
	jQuery.ajax({
		url:"../usercenter/security_code.jsp",
		data:"verify="+ver,
		//dataType:"html",
		dataType:'json',
		type:"POST",
		async : false,
		success:function(data){
			if(data.message == "good"){
				veri = true;
			}else{
				jQuery('.r_v_refresh').next().html('<font color="red">　* </font>验证码不正确');
				//jQuery('#verify_img').attr('src','{:U("Home/Register/verify_v","","")}/rand/'+Math.random());
				//jQuery('#verify').focus();
			}
		}
	});
	if(!veri){
		return false;
	}

	jQuery('.r_v_refresh').next().html('');
	var reg_xy=jQuery('#reg_xy').attr("checked");
	if(reg_xy!=='checked')
	{
		jQuery('#reg_xy').next().next().html('<font color="red">　* </font>未同意相关服务条款！');
		jQuery('#reg_xy').focus();
		return false;
	}
	jQuery('#reg_xy').next().next().html('');

	jQuery.ajax({
		url:"../usercenter/useradd.jsp",
		data:"email="+email+"&username="+username+"&password="+password+"&verify="+ver,
		dataType:"json",
		type:"POST",
		success:function(data){
			if(data.status == 1){
				//jQuery.ajax({
				//	url:"__APP__/Home/Login/get_email_switch_ajax",
				//	datatype:"html",
				//	success:function(data){
				//		if(data == '1'){
				//			window.location.href="__APP__/Home/Register/reg_success";
				//		}else{
				//			//alert("注册成功，请登录");
				//			window.location.href="__APP__/Home/Feature/page";
				//		}
				//	}
				//});
				window.location.href=data.msg;
			}else{
				alert(data.msg);
			}
		}
	});
}

</script>


</head>

<body>
<div class="login_header r_header">
    <h1><a href="">tidemedia 欢迎注册</a></h1>
</div>
<div class="reg">
    <div class="reg_tip">已有帐号，请<a href="../usercenter/login.jsp">登录</a></div>
    <div class="reg_main">
	<form class="stdform" name="userinfoform" method="post">
        <dl>
            <dt><label for="email">邮箱：</label></dt>
            <dd><input type="text" name="email" id="email" class="r_email"><font></font></dd>
        </dl>
		<dl>
            <dt><label for="username">用户名：</label></dt>
            <dd><input type="text" name="username" id="username" class="r_username" maxlength="30"><font></font></dd>
        </dl>
        <dl>
            <dt><label for="password">密码：</label></dt>
            <dd><input type="password" name="password" id="password" class="r_password" maxlength="20"><font></font></dd>
        </dl>
        <dl>
            <dt><label for="repassword">确认密码：</label></dt>
            <dd><input type="password" name="repassword" id="repassword" class="r_confirm_password" maxlength="20"><font></font></dd>
        </dl>
        <dl>
            <dt><label for="verify">验证码：</label></dt>
            <dd><input type="text" name="verify" id="verify" class="r_verify"><div class="r_verify_img"><img src="../usercenter/security_code_url.jsp" id="verify_img"></div><a href="javascript:show()" class="r_v_refresh">换一张</a><font></font></dd>
			<script>
				function show(){
				$('#verify_img').attr('src','http://123.56.71.230:889/cms2018/usercenter/security_code_url.jsp?number='+Math.random());
				}
			</script>
        </dl>
        <dl style="margin:25px 0 0">
            <dt></dt>
            <dd><label for="reg_xy"><input type="checkbox" id="reg_xy" class="r_xy"><a href="#" href="#">我已阅读并同意相关服务条款</a><font></font></label></dd>
        </dl>
        <dl style="margin:0;">
            <dt></dt>
            <dd><input type="button" value="立即注册" onclick="javascript:checkform();" class="reg_btn"></dd>
        </dl>
	</form>
    </div>
</div>
<div class="footer">
    <p>主办单位：泰德网聚（北京）科技有限公司<span>|</span>版权所有：泰德网聚</p>
    <p>Copyright © <a href="http://www.tidemedia.com" target="_blank">tidemedia</a></p>
</div>
</body> 
</html>
