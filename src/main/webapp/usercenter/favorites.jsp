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
	<title>我的收藏_tidemedia用户中心</title>
	<link rel="stylesheet" type="text/css" href="../usercenter/css/user.css">
	<script type="text/javascript" src="../usercenter/js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="../usercenter/js/common.js"></script>
</head>
<script>
 //   $(function load(){
 //       change({$se});
 //   });
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
    function del(item_gid,type){
		if(confirm('确定删除该条记录?')){
        $.ajax({
            url:"../usercenter/del_favorites.jsp",
            data:"item_gid="+item_gid+"&type="+type,
            type:"post",
            datatype:"json",
            success:function(data){
                var data = eval("("+data+")");
                if(data.status == 1){
                    showpage(type,1);
                }
            }
        });
		}
    }
    function showpage(type,page){
        $.ajax({
            url:"../usercenter/query_favorites.jsp",
            data:"type="+type+"&page="+page,
            type:"post",
            datatype:"json",
            success:function(data){
                var data = eval("("+data+")");
                if(data.status == 1){
                    var str = '';
					var page_show ='';
                    if(type == 3){
                        for(var i=0;i<data.message.length;i++){
                            str += '<li><a href="'+data.message[i].Href+'" class="pic" target="_blank"><img src="'+data.message[i].Photo+'"><span class="txt">'+data.message[i].Title+'</span><span class="play">播放</span></a><a href="javascript:del('+data.message[i].id+','+type+')" class="del" title="删除">删除</a></li>';
                        }
						page_show+='<p>当前为：第'+page+'页/共'+data.totalpage+'页<p>';
						if(page<data.totalpage){
							page_show+='<a href="javascript:showpage('+type+','+(page+1)+')" class="del" title="下一页">下一页</a>';
						}
						if(page>1&&page<data.totalpage){
							page_show+='<a href="javascript:showpage('+type+','+(page-1)+')" class="del" title="上一页">上一页</a>';
							page_show+='<a href="javascript:showpage('+type+','+(page+1)+')" class="del" title="下一页">下一页</a>';
						}
						if(page>1&&page==data.totalpage){
							page_show+='<a href="javascript:showpage('+type+','+(page-1)+')" class="del" title="上一页">上一页</a>';
						}
                        $('.vid_content').html(str);
                       // $('.vid_pages').html(data.message.page);
					    $('.vid_pages').html(page_show);
                    }
                    if(type == 2){
                        for(var i=0;i<data.message.length;i++){
                            str += '<li><a href="'+data.message[i].Href+'" class="pic" target="_blank"><img src="'+data.message[i].Photo+'"><span class="txt">'+data.message[i].Title+'</span></a><a href="javascript:del('+data.message[i].id+','+type+')" class="del" title="删除">删除</a></li>';
                        }
						page_show+='<p>当前为：第'+page+'页/共'+data.totalpage+'页<p>';
						if(page<data.totalpage){
							page_show+='<a href="javascript:showpage('+type+','+(page+1)+')" class="del" title="下一页">下一页</a>';
						}
						if(page>1&&page<data.totalpage){
							page_show+='<a href="javascript:showpage('+type+','+(page-1)+')" class="del" title="上一页">上一页</a>';
							page_show+='<a href="javascript:showpage('+type+','+(page+1)+')" class="del" title="下一页">下一页</a>';
						}
						if(page>1&&page==data.totalpage){
							page_show+='<a href="javascript:showpage('+type+','+(page-1)+')" class="del" title="上一页">上一页</a>';
						}
                        $('.pic_content').html(str);
                       // $('.pic_pages').html(data.message.page);
					   $('.pic_pages').html(page_show);
                    }
                    if(type == 1){
                        for(var i=0;i<data.message.length;i++){
                            str += '<li><a href="'+data.message[i].Href+'" target="_blank">'+data.message[i].Title+'</a><span class="date">'+getLocalTime(data.message[i].PublishDate)+'<a href="javascript:del('+data.message[i].id+','+type+')" class="del" title="删除">删除</a></span></li>';
                        }
						page_show+='<p>当前为：第'+page+'页/共'+data.totalpage+'页<p>';
						if(page<data.totalpage){
							page_show+='<a href="javascript:showpage('+type+','+(page+1)+')" class="del" title="下一页">下一页</a>';
						}
						if(page>1&&page<data.totalpage){
							page_show+='<a href="javascript:showpage('+type+','+(page-1)+')" class="del" title="上一页">上一页</a>';
							page_show+='<a href="javascript:showpage('+type+','+(page+1)+')" class="del" title="下一页">下一页</a>';
						}
						if(page>1&&page==data.totalpage){
							page_show+='<a href="javascript:showpage('+type+','+(page-1)+')" class="del" title="上一页">上一页</a>';
						}
                        $('.txt_content').html(str);
                       // $('.txt_pages').html(data.message.page);
					    $('.txt_pages').html(page_show);
                    }
                }else{
                    alert(data.message);
                }
            }
        });
    }
    function getLocalTime(nS) {
        return new Date(parseInt(nS) * 1000).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ");
    }
    function go(i){
        var type = '';
        if($('.u_i_f_menu a').eq(0).is('.on')){
            type = 3;
        }
        if($('.u_i_f_menu a').eq(1).is('.on')){
            type = 2;
        }
        if($('.u_i_f_menu a').eq(2).is('.on')){
            type = 1;
        }
        showpage(type,i);
    }
    function change(type){
        showpage(type,1);
        if(type==3){
            $('#picture').hide();
            $('#video').show();
            $('#text').hide();
            $('.u_i_f_menu a').removeClass("on");
            $('.u_i_f_menu a').eq(0).addClass("on");
        }
        if(type==2){

            $('#picture').show();
            $('#video').hide();
            $('#text').hide();
            $('.u_i_f_menu a').removeClass("on");
            $('.u_i_f_menu a').eq(1).addClass("on");
        }
        if(type==1){
            $('#picture').hide();
            $('#video').hide();
            $('#text').show();
            $('.u_i_f_menu a').removeClass("on");
            $('.u_i_f_menu a').eq(2).addClass("on");
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
	<div class="u_i_left" id="u_i_left" style="height:624px;">
		<ul class="u_i_menu">
			<li><a href="../usercenter/page.jsp" class="grzl ">个人资料</a></li>
            <li><a href="../usercenter/responsive.jsp" class="spsc">我的视频</a></li>
            <li><a href="../usercenter/shortcode.jsp" class="tpsc">我的相册</a></li>
            <li><a href="../usercenter/favorites.jsp" class="wdsc on">我的收藏</a></li>
            <li><a href="../usercenter/comment.jsp" class="wdpl">我的评论</a></li>
            <li><a href="../usercenter/baoliao.jsp" class="wdbl">我的爆料</a></li>
            <li><a href="../usercenter/order.jsp" class="wddd">我的订单</a></li>
            <li><a href="../usercenter/address.jsp" class="wddz">我的地址</a></li>
            <li><a href="../usercenter/vote.jsp" class="wdtp">我的投票</a></li>
            <li><a href="../usercenter/password.jsp" class="mmxg ">密码修改</a></li>
		</ul>
	</div>
	<div class="u_i_right" id="u_i_right">
		<div class="u_i_fav">
			<div class="u_i_f_menu">
				<ul>
					<li><a href="javascript:change(3)" class="on">收藏的视频</a></li>
					<li><a href="javascript:change(2)">收藏的图片</a></li>
					<li><a href="javascript:change(1)">收藏的文章</a></li>
				</ul>
			</div>
			<div class="u_i_f_list">
				<div id="video">
					<ul class="u_i_f_pic vid_content" style="height:522px;">
<%
 	TableUtil tu= new TableUtil();
	int totalsize=0;
    String sql_ = "select id from channel_tidehome_collect  where  Active=1 and userid = " + userid;
	ResultSet rs_ = tu.executeQuery(sql_);	
	if(rs_.next())
	{
	  totalsize ++;
	  int id_ = rs_.getInt("id");
	 }
	tu.closeRs(rs_); 
    String sql = "select * from channel_tidehome_collect  where Active=1 and userid = " + userid + "&type=3 limit 0, 12" ;
    ResultSet rs = tu.executeQuery(sql);	
	if(rs.next())
	{
	  totalsize ++;
	  int id_ = rs.getInt("id");
	  String url	= rs.getString("url"); 
	  String Title	= rs.getString("Title"); 
      String Photo	= rs.getString("Photo"); 	  
%>						
							<li>
								<a href="<%=url%>" class="pic" target="_blank"><img src="<%=Photo%>"><span class="txt"><%=Title%></span><span class="play">播放</span></a>
								<a href="javascript:del(<%=id_%>,3)" class="del" title="删除">删除</a>
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
					page_next="<a href=\"javascript:showpage(3,2)\" class=\"del\" >下一页</a>";		
		}		
%>
					</ul>
					<div class="u_i_f_pages vid_pages"><%=show_page%> <%=page_next%></div>
					
				</div>
				<div id="picture" style="display:none;">
					<ul class="u_i_f_pic pic_content" style="height:522px;"></ul>
					<div class="u_i_f_pages pic_pages">  </div>
				</div>
				<div id="text" style="display:none;">
					<ul class="u_i_f_txt txt_content" style="height:501px;"></ul>
					<div class="u_i_f_pages txt_pages"></div>
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
