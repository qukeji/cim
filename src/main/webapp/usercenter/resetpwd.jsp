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

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>找回密码_tidemedia</title>
<link rel="stylesheet" type="text/css" href="../usercenter/css/user.css">
<script type="text/javascript" src="../usercenter/js/jquery-1.7.2.min.js"></script>

<script>
$(function(){ 
	$(document).keydown(function(event){ 
		if(event.keyCode == 13){
			if(!$('.resetpwd_div').eq(0).hasClass('resetpwd_hidden')){
				$("#btn-one").click();
			}else{
				$("#btn-two").click();
			}
		}
	});
});
function sendemail(){
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
		data:'email='+email,
		success: function(data){
			if(data['status']=='success')
			{
					useremailcheck=true;
			}
			else if(data['status']=='failes')
			{
				jQuery('#email').next().html('<font color="red">　* </font>邮箱不存在');
				jQuery('#email').focus();
			}
		}
	});
	if(!useremailcheck)
	{ 
		return false;
	}

	jQuery('#email').next().html('');

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
		dataType:"html",
		type:"POST",
		async : false,
		success:function(data){
			var data = eval("("+data+")");
			if(data.message == "good"){
				veri = true;
			}else{
				jQuery('.r_v_refresh').next().html('<font color="red">　* </font>验证码不正确');
				$('#verify_img').attr('src','http://123.56.71.230:889/cms2018/usercenter/security_code_url.jsp?number='+Math.random());
				jQuery('#verify').focus();
			}
		}
	});
	if(!veri){
		return false;
	}

	jQuery('.r_v_refresh').next().html('');

	send(email,ver);
}

function send(email,ver){
	jQuery.ajax({
		url:"../usercenter/sendemail.jsp",
		data:"email="+email+"&verify="+ver,
		dataType:"json",
		type:"POST",
		success:function(data){
			if(data['status'] == 1){
				var str = '系统已向您的邮箱 '+email+' 发送了一封验证邮件<br>请您在30分钟内登录邮箱，点击邮件中的链接完成邮箱验证；如果您超过2分钟未收到邮件，您可以<a href="javascript:send('+"'"+jQuery("#email").val()+"'"+','+"'"+jQuery("#verify").val()+"'"+');">重新发送</a>,超过30分钟请从新进行找回密码流程。';
				$('.r_success_con').html(str);
				change(1);
				ifverify();
			}else{
				alert(data.message);
			}
		}
	});
}

function ifverify(){
	jQuery.ajax({
		//url:"__APP__/Home/Login/ifverify",
		url:"../usercenter/ifverify.jsp",
		dataType:"json",
		type:"POST",
		success:function(data){
			if(data['status'] == 1){
				change(2);
			}else{
				ifverify();
			}
		}
	});
}

function modify(){
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

	jQuery.ajax({
		url:"../usercenter/resetpass.jsp",
		type: 'POST',
		dataType: "json",
		data:'password='+password+"&email="+jQuery('#email').val(),
		success: function(data){
			if(data['status'] == 1){
				change(3);
				i = 5;
				intervalid = setInterval("fun()", 1000); 
			}else{
				alert("修改失败");return false;
			}
		}
	});
}
function fun() { 
	if (i == 0) { 
	window.location.href = "../usercenter/page.jsp"; 
	clearInterval(intervalid); 
	} 
	$("#mes").html(i); 
	i--; 
}


function change(num){
	$('.resetpwd_step li').eq(num).addClass("on");
	$('.resetpwd_step li').eq(num-1).removeClass("on");
	$('.resetpwd_step li').eq(num-1).addClass("done");

	$('.resetpwd_div').addClass("resetpwd_hidden");
	$('.resetpwd_div').eq(num).removeClass("resetpwd_hidden");
}

</script>

</head>

<body>
<div class="login_header r_header">
    <h1><a href="">tidemedia 找回密码</a></h1>
</div>
<div class="reg">
    <div class="reg_tip"></div>
    <div class="reg_main">
        <div class="resetpwd">
            <ul class="resetpwd_step">
                <li class="on">
                    <div class="r_s_num">1</div>
                    <div class="r_s_txt">填写邮箱</div>
                </li>
                <li>
                    <div class="r_s_num">2</div>
                    <div class="r_s_txt">邮件确认</div>
                </li>
                <li>
                    <div class="r_s_num">3</div>
                    <div class="r_s_txt">设置新密码</div>
                </li>
                <li>
                    <div class="r_s_num">4</div>
                    <div class="r_s_txt">设置成功</div>
                </li>
            </ul>
            <div class="resetpwd_main">
				<div class="resetpwd_div">
					<dl>
						<dt><label for="email">邮箱：</label></dt>
						<dd><input type="text" id="email" class="r_email"><font></font></dd>
					</dl>
					<dl>
						<dt><label for="verify">验证码：</label></dt>
						<dd><input type="text" id="verify" class="r_verify"><div class="r_verify_img"><img src="../usercenter/security_code_url.jsp" id="verify_img"></div><a href="javascript:show()" class="r_v_refresh">换一张</a><font></font></dd>
						<script>
							function show(){
							$('#verify_img').attr('src','http://123.56.71.230:889/cms2018/usercenter/security_code_url.jsp?number='+Math.random());
							}
						</script>
					</dl>
					<dl>
						<dt></dt>
						<dd><input type="button" value="下一步" class="reg_btn" id="btn-one" onclick="javascript:sendemail();"></dd>
					</dl>
				</div>
				<div class="resetpwd_div resetpwd_hidden">
					<h2 class="r_success_title">密码找回邮件已发送！</h2>
					<p class="r_success_con">系统已向您的邮箱 1037359002@qq.com 发送了一封验证邮件<br>请您登录邮箱，点击邮件中的链接完成邮箱验证；如果您超过2分钟未收到邮件，您可以<a href="#">重新发送</a></p>
				</div>
				<div class="resetpwd_div resetpwd_hidden">
					<dl>
						<dt><label for="password">新密码：</label></dt>
						<dd><input type="password" id="password" class="r_password"><font></font></dd>
					</dl>
					<dl>
						<dt><label for="repassword">确认密码：</label></dt>
						<dd><input type="password" id="repassword" class="r_confirm_password"><font></font></dd>
					</dl>
					<dl>
						<dt></dt>
						<dd><input type="button" value="下一步" class="reg_btn" id="btn-two" onclick="javascript:modify();"></dd>
					</dl>
				</div>
				<div class="resetpwd_div resetpwd_hidden">
					<h2 class="r_success_title">密码设置成功</h2><br>
					<p>将在 <span id="mes">10</span> 秒钟后返回个人中心！</p>
				</div>
            </div>
        </div>
    </div>
</div>
<div class="footer">
    <p>主办单位：泰德网聚（北京）科技有限公司<span>|</span>版权所有：泰德网聚</p>
    <p>Copyright © <a href="http://www.tidemedia.com" target="_blank">tidemedia</a></p>
</div>
</body> 
</html>