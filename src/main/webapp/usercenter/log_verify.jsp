<%@ page contentType="text/html;charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>账号验证_tidemedia</title>
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
	var email = jQuery('#email').val();
	var veri = false;
	var ver = jQuery('#verify').val();
	if(ver==''){
		jQuery('.r_v_refresh').next().html('<font color="red">　* </font>请填写验证码！');
		jQuery('#verify').focus();
		return false;
	}
	jQuery.ajax({
		url:"__APP__/Home/Login/yan",
		data:"verify="+ver,
		dataType:"html",
		type:"POST",
		async : false,
		success:function(data){
			if(data == "good"){
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
		url:"__APP__/Home/Register/sendemail",
		data:"email="+email+"&verify="+ver+"&type=log",
		dataType:"json",
		type:"POST",
		success:function(data){
			if(data.status == '1'){
				var str = '系统已向您的邮箱 '+email+' 发送了一封验证邮件<br>请您登录邮箱，点击邮件中的链接完成邮箱验证；如果您超过2分钟未收到邮件，您可以<a href="javascript:send('+"'"+jQuery("#email").val()+"'"+','+"'"+jQuery("#verify").val()+"'"+');">重新发送</a>';
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
		url:"__APP__/Home/Register/iflogverify",
		dataType:"json",
		type:"POST",
		success:function(data){
			if(data.status == '1'){
				change(2);
				i = 10;
				intervalid = setInterval("fun()", 1000); 
			}else{
				ifverify();
			}
		}
	});
}

function fun() { 
	if (i == 0) { 
	window.location.href = "__APP__/Home/Feature/page"; 
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
    <h1><a href="">tidemedia 账号验证</a></h1>
</div>
<div class="reg">
    <div class="reg_tip"></div>
    <div class="reg_main">
        <div class="resetpwd">
            <ul class="resetpwd_step">
                <li class="on">
                    <div class="r_s_num">1</div>
                    <div class="r_s_txt">填写验证码</div>
                </li>
                <li>
                    <div class="r_s_num">2</div>
                    <div class="r_s_txt">邮件确认</div>
                </li>
                <li>
                    <div class="r_s_num">3</div>
                    <div class="r_s_txt">验证成功</div>
                </li>
            </ul>
            <div class="resetpwd_main">
				<div class="resetpwd_div">
					<dl>
						<dt><label for="email">邮箱：</label></dt>
						<dd><input type="text" id="email" class="r_email" value="" readonly><font></font></dd>
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
					<h2 class="r_success_title">验证邮件已发送！</h2>
					<p class="r_success_con">系统已向您的邮箱 1037359002@qq.com 发送了一封验证邮件<br>请您登录邮箱，点击邮件中的链接完成邮箱验证；如果您超过2分钟未收到邮件，您可以<a href="#">重新发送</a></p>
				</div>
				<div class="resetpwd_div resetpwd_hidden">
					<h2 class="r_success_title">验证成功</h2>
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