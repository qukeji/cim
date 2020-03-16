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
<title>我的评论_tidemedia用户中心</title>
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
    var message = "确实要删除这1项吗？";
	if(confirm(message)){
	$.ajax({
		url:"../usercenter/comment_del.jsp",
		data:"id="+id,
		type:"post",
		datatype:"json",
		success:function(data){
			//var data = eval("("+data+")");
			if(data['status'] == 1){
				window.location.reload();
			//	var page = $('.u_i_f_pages .on').html();
			//	if(page){
			//		go(page);
			//	}else{
			//		go(1);
			//	}
			}else{
				alert("删除失败！");
			}
		}
	});
   }
}
function go(page){
	$.ajax({
		//url:"__APP__/Home/Feature/comment",
		url:"../usercenter/query_comment.jsp",
		data:"type=1&page="+page,
		type:"get",
		datatype:"json",
		success:function(data){
			var data = eval("("+data+")");
			if(data.status == 1){
				var str = '';
				var page_show ='';
				var arr = data.message;
				for(var i=0;i<arr.length;i++){
					var state = '未审核　';
					if(arr[i].Status==1){
						state = '<font color=red>已审核　</font>';
					}
					var dateStr = new Date(parseInt(arr[i].CreateDate) * 1000);
					var month = dateStr.getMonth()+1;
					var date = dateStr.getFullYear() + '-' + pad(month) +'-' + pad(dateStr.getDate()) + ' ' + pad(dateStr.getHours()) + ':' + pad(dateStr.getMinutes()) + ':' + pad(dateStr.getSeconds());
					str += '<li><a href="'+arr[i].url+'" target="_blank">'+arr[i].Content.substring(0,40)+'</a><span class="date">'+state+date+'<a href="javascript:del('+arr[i].id+')" class="del" title="删除">删除</a></span></li>';
				}
				        page_show+='<p>当前为：第'+page+'页/共'+data.totalpage+'页<p>';
						if(page<data.totalpage){
							page_show+='<a href="javascript:go('+(page+1)+')" class="del" title="下一页">下一页</a>';
						}
						if(page>1&&page<data.totalpage){
							page_show+='<a href="javascript:go('+(page-1)+')" class="del" title="上一页">上一页</a>';
							page_show+='<a href="javascript:go('+(page+1)+')" class="del" title="下一页">下一页</a>';
						}
						if(page>1&&page==data.totalpage){
							page_show+='<a href="javascript:go('+(page-1)+')" class="del" title="上一页">上一页</a>';
						}
				$('.u_i_f_txt').html(str);
				$('.u_i_f_pages').html(page_show);
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
            <li><a href="../usercenter/page.jsp" class="grzl ">个人资料</a></li>
            <li><a href="../usercenter/responsive.jsp" class="spsc">我的视频</a></li>
            <li><a href="../usercenter/shortcode.jsp" class="tpsc">我的相册</a></li>
            <li><a href="../usercenter/favorites.jsp" class="wdsc">我的收藏</a></li>
            <li><a href="../usercenter/comment.jsp" class="wdpl on">我的评论</a></li>
            <li><a href="../usercenter/baoliao.jsp" class="wdbl">我的爆料</a></li>
            <li><a href="../usercenter/order.jsp" class="wddd">我的订单</a></li>
            <li><a href="../usercenter/address.jsp" class="wddz">我的地址</a></li>
            <li><a href="../usercenter/vote.jsp" class="wdtp">我的投票</a></li>
            <li><a href="../usercenter/password.jsp" class="mmxg">密码修改</a></li>
        </ul>
    </div>
    <div class="u_i_right" id="u_i_right">
        <div class="u_i_form" id="u_i_form">

			<div id="text">
				<ul class="u_i_f_txt" style="height:501px;">
<%
 	TableUtil tu= new TableUtil();
	int totalsize=0;
    String sql_ = "select id from channel_tidehome_comment  where  Active=1 and userid =" + userid;
	ResultSet rs_ = tu.executeQuery(sql_);	
	if(rs_.next())
	{
	  totalsize ++;
	  int id_ = rs_.getInt("id");
	 }
	tu.closeRs(rs_); 
	String sql = "select id,Status,url,Content,CreateDate from channel_tidehome_comment where userid ="+ userid + " and Active=1  order by id desc  limit 0,12";
    ResultSet rs = tu.executeQuery(sql);		
	if(rs.next())
	{
	  int id_ = rs.getInt("id");
	  String url	= rs.getString("url"); 
	  String Content	= rs.getString("Content");    
	  int Status = rs.getInt("Status");  
	  String StatusDesc = "";
	  if(Status==0){
		StatusDesc = "<font color=red>未审核</font>";
	 }else{
		StatusDesc = "<font color=blue>已审核</font>";
	 }
	String CreateDate	= rs.getString("CreateDate");
	System.out.println(CreateDate);
	if(CreateDate!=null){
		CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",CreateDate);
	}	
%>	
					<li>
						<a href="<%=url%>" target="_blank"><%=Content%></a>
						<span class="date"><%=StatusDesc%><%=CreateDate%><a href="javascript:del(<%=id_%>)" class="del" title="删除">删除</a></span>
					</li>
<%}
tu.closeRs(rs);
int count=1;
                   if(totalsize>12){				
					     count=totalsize/12;
					 int count_=count*12;
					 if(count_<totalsize){
						 count=count+1;
					 }
				   }
			String show_page="<p>当前为：第1页/共"+count+"页";		
			String page_next="";
		if(1<count){
					page_next="<a href=\"javascript:go(2)\" class=\"del\">下一页</a>";		
		}		
%>
				</ul>
				<div class="u_i_f_pages"><%=show_page%><%=page_next%></div>
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
