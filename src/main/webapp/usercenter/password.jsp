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
          String title = (String)session.getAttribute("username");
		  int userid= (Integer)session.getAttribute("userid");	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>密码修改_tidemedia用户中心</title>
<link rel="stylesheet" type="text/css" href="../usercenter/css/user.css">
<script type="text/javascript" src="../usercenter/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="../usercenter/js/common.js"></script>
</head>
<script>
function quit(){
	$.ajax({
		url:"../usercenter/quit.jsp",
		success:function(data){
			var data = eval("("+data+")");
			if(data.status == 1){
				window.location.href="../usercenter/login.jsp";
			}
		}
	});
}
</script>
<script>
function checkform()
{
	var password=jQuery('#beforepwd').val();
	if(password=='')
	{
		jQuery('#beforepwd').next().html('<font color="red">　* </font>请填写原始密码！');
		jQuery('#beforepwd').focus();
		return false;
	}
	jQuery('#beforepwd').next().html('');

	var password_new=jQuery('#afterpwd').val();
	if(password_new=='')
	{
		jQuery('#afterpwd').next().html('<font color="red">　* </font>请填写新密码！');
		jQuery('#afterpwd').focus();
		return false;
	}
	if(password_new.length<6)
	{
		jQuery('#afterpwd').next().html('<font color="red">　* </font>新密码长度不能小于6位！');
		jQuery('#afterpwd').focus();
		return false;
	}
	jQuery('#afterpwd').next().html('');

	var repassword=jQuery('#reafterpwd').val();
	if(repassword=='')
	{
		jQuery('#reafterpwd').next().html('<font color="red">　* </font>请填写确认密码！');
		jQuery('#reafterpwd').focus();
		return false;
	}
	if(repassword!=password_new)
	{
		jQuery('#reafterpwd').next().html('<font color="red">　* </font>两次密码输入不一致！');
		jQuery('#reafterpwd').focus();
		return false;
	}
	jQuery('#reafterpwd').next().html('');	
	$.ajax({
		url:"../usercenter/update_pass.jsp",
		type: 'POST',
		data:'password='+jQuery('#beforepwd').val()+'&password_new='+jQuery('#afterpwd').val()+'&userid='+jQuery('#uid').val(),
		success: function(data){
			var data = eval("("+data+")");
			if(data.status == 1)
			{
				alert("修改成功，请重新登录");
				window.location.href="../usercenter/login.jsp";
				return;
			}else{
				//alert(data['message']);return false;
				alert("修改失败");return false;
			}
		}
	});
}

</script>



<body class="user_bg">
<div class="header">
	<div class="h_main">
		<h1>tidemedia用户中心</h1>
		<div class="h_m_r">欢迎您，<a href="../usercenter/page.jsp"><%=title%></a>！<a href="javascript:quit()">退出</a></div>
	</div>
</div>
<div class="user_info_main">
	<div class="u_i_left" id="u_i_left" style="height:528px;">
		<ul class="u_i_menu">
			<li><a href="../usercenter/page.jsp" class="grzl on">个人资料</a></li>
            <li><a href="../usercenter/responsive.jsp" class="spsc">我的视频</a></li>
            <li><a href="../usercenter/shortcode.jsp" class="tpsc">我的相册</a></li>
            <li><a href="../usercenter/favorites.jsp" class="wdsc">我的收藏</a></li>
            <li><a href="../usercenter/comment.jsp" class="wdpl">我的评论</a></li>
            <li><a href="../usercenter/baoliao.jsp" class="wdbl">我的爆料</a></li>
            <li><a href="../usercenter/order.jsp" class="wddd">我的订单</a></li>
            <li><a href="../usercenter/address.jsp" class="wddz">我的地址</a></li>
            <li><a href="../usercenter/vote.jsp" class="wdtp">我的投票</a></li>
            <li><a href="../usercenter/password.jsp" class="mmxg on">密码修改</a></li>
		</ul>
	</div>
	<div class="u_i_right" id="u_i_right" style="height:528px;">
		<div class="u_i_form">
		<form class="stdform" name="userinfoform" method="post">
			<dl>
				<dt><span class="red">*</span>原始密码：</dt>
				<dd>
					<input class="u_i_f_text" name="beforepwd" type="password" id="beforepwd"><font></font>
					<input type="hidden" id="uid" name="uid" value="<%=userid%>">
				</dd>
			</dl>
			<dl>
				<dt><span class="red">*</span>新密码：</dt>
				<dd>
					<input class="u_i_f_text" name="afterpwd" type="password" id="afterpwd"><font></font>
				</dd>
			</dl>
			<dl>
				<dt><span class="red">*</span>确认密码：</dt>
				<dd>
					<input class="u_i_f_text" name="reafterpwd" type="password" id="reafterpwd"><font></font>
				</dd>
			</dl>
			<dl>
				<dt></dt>
				<dd><input type="button" class="u_i_f_btn" value="提交" onclick="javascript:checkform();"></dd>
			</dl>
		</form>
		</div>
	</div>
</div>
<div class="footer">
	<p>主办单位：泰德网聚（北京）科技有限公司<span>|</span>版权所有：泰德网聚</p>
	<p>Copyright © <a href="http://www.tidemedia.com" target="_blank">tidemedia</a></p>
</div>
</body> 
</html>
