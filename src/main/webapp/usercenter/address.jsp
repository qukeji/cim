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
          int channelid=14203;
		  String title = (String)session.getAttribute("username");          
          Channel channel = CmsCache.getChannel("channel_address");		
	      String Action  =	getParameter(request,"Action");	  
		  if(Action.equals("Del")){
			   int id = getIntParameter(request,"id");
			   TableUtil tu_ = new TableUtil();			 
			   String sql_ = "update " + channel.getTableName() + " set Active=0 where id=" + id ;
			   tu_.executeUpdate(sql_);	
			   response.sendRedirect("../usercenter/address.jsp");return;
			   //out.println("<script>window.location.reload();</script>");
		  }		  
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>我的地址_tidemedia用户中心</title>
<link rel="stylesheet" type="text/css" href="../usercenter/css/user.css">
<script type="text/javascript" src="../usercenter/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../usercenter/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="../usercenter/js/common.js"></script>

<link rel="stylesheet" href="../usercenter/uploadvideo/plupload/jquery-ui.css" type="text/css" />
<link rel="stylesheet" href="../usercenter/uploadvideo/plupload/js/jquery.ui.plupload/css/jquery.ui.plupload.css" type="text/css" />
<script type="text/javascript" src="../usercenter/uploadvideo/plupload/jquery-ui.min.js"></script>
<script type="text/javascript" src="../usercenter/uploadvideo/plupload/js/plupload.full.min.js"></script>
<script type="text/javascript" src="../usercenter/uploadvideo/plupload/js/jquery.ui.plupload/jquery.ui.plupload.js"></script>
<script src="../usercenter/uploadvideo/plupload/js/i18n/zh_CN.js"></script>
</head>
<script>
/*$(function load(){
	change({$se});
});*/
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
function del(id){
	$.ajax({
		url:"__APP__/Home/Feature/address_del",
		data:"id="+id,
		type:"post",
		datatype:"json",
		success:function(data){
			var data = eval("("+data+")");
			if(data.status == 1){
				var page = $('.u_i_f_pages .on').html();
				if(page){
					go(page);
				}else{
					go(1);
				}
			}
		}
	});
}
function go(page){
	$.ajax({
		url:"__APP__/Home/Feature/address",
		data:"type=1&page="+page,
		type:"get",
		datatype:"json",
		success:function(data){
			var data = eval("("+data+")");
			if(data.status == 1){
				var str = '<li class="table_head"><span class="s1">收件人</span><span class="s2">手机号</span><span class="s3">详细地址</span><span class="date">删除</span></li>';
				var arr = data.message;
				for(var i=0;i<arr.length;i++){
					str += '<li><span class="s1">'+arr[i].Title+'</span><span class="s2">'+arr[i].phone+'</span><span class="s3">'+arr[i].province+arr[i].city+arr[i].area+arr[i].street+'</span><span class="date"><a href="javascript:del('+arr[i].id+')" class="del" title="删除">删除</a></span></li>';
				}
				$('.u_i_f_txt').html(str);
				$('.u_i_f_pages').html(data.multi);
			}
		}
	});
}

function pad(str){
	var str = str.toString();
	if(str.length==1){
		return '0'+str;
	}else{
		return str;
	}
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
    <div class="u_i_left" id="u_i_left" style="height:628px;">
         <ul class="u_i_menu">
            <li><a href="../usercenter/page.jsp" class="grzl">个人资料</a></li>
            <li><a href="../usercenter/responsive.jsp" class="spsc">我的视频</a></li>
            <li><a href="../usercenter/shortcode.jsp" class="tpsc">我的相册</a></li>
            <li><a href="../usercenter/favorites.jsp" class="wdsc">我的收藏</a></li>
            <li><a href="../usercenter/comment.jsp" class="wdpl">我的评论</a></li>
            <li><a href="../usercenter/baoliao.jsp" class="wdbl">我的爆料</a></li>
            <li><a href="../usercenter/order.jsp" class="wddd">我的订单</a></li>
            <li><a href="../usercenter/address.jsp" class="wddz on">我的地址</a></li>
            <li><a href="../usercenter/vote.jsp" class="wdtp">我的投票</a></li>
            <li><a href="../usercenter/password.jsp" class="mmxg">密码修改</a></li>
        </ul>
    </div>
    <div class="u_i_right" id="u_i_right">
        <div class="u_i_form" id="u_i_form">

			<div id="text">
				<ul class="u_i_f_txt" style="height:549px;">
					<li class="table_head">
						<span class="s1">收件人</span><span class="s2">手机号</span><span class="s3">详细地址</span>
						<span class="date">删除</span>
					</li>
<%
 	TableUtil tu= new TableUtil();
    String sql = "select * from " + channel.getTableName() + " where Title = '" + title +"'";
    ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		int id_ = rs.getInt("id");
	  String city	= rs.getString("City");    
	  String truename	= rs.getString("Truename");
	  String phone	= rs.getString("Phone");    
	  String address	= rs.getString("Address");    
	  String summary	= rs.getString("Summary");  
%>					
					<li>
						<span class="s1"></span><span class="s2"><%=phone%></span><span class="s3">{$arr.province}{$arr.city}{$arr.area}{$arr.street}</span>
						<span class="date"><a href="../usercenter/address.jsp?Action=Del&id=<%=id_%>" class="del" title="删除" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></span>
					</li>
<%}
tu.closeRs(rs);
%>					
				</ul>
				<div class="u_i_f_pages">{$multi}</div>
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
