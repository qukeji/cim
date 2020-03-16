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
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<title>视频上传_tidemedia用户中心</title>
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
function change(type){
	if(type==1){
		$('#picture').show();
		$('#video').hide();
		$('#text').hide();
		$('.stdform').hide();
		$('.u_i_f_menu a').removeClass("on");
		$('.u_i_f_menu a').eq(0).addClass("on");
		$('#u_i_right').height(628);
		$("#u_i_left").height(628);
	}
	if(type==2){
		$('#picture').hide();
		$('#video').show();
		$('#text').hide();
		$('.stdform').hide();
		$('.u_i_f_menu a').removeClass("on");
		$('.u_i_f_menu a').eq(1).addClass("on");
		$('#u_i_right').height(628);
		$("#u_i_left").height(628);
	}
	if(type==3){
		$('#picture').hide();
		$('#video').hide();
		$('#text').show();
		$('.stdform').hide();
		$('.u_i_f_menu a').removeClass("on");
		$('.u_i_f_menu a').eq(2).addClass("on");
		$('#u_i_right').height(628);
		$("#u_i_left").height(628);
	}
	if(type==4){
		$('#picture').hide();
		$('#video').hide();
		$('#text').hide();
		$('.stdform').show();
		$('.u_i_f_menu a').removeClass("on");
		$('#u_i_right').height(749);
		$("#u_i_left").height(749);
	}
	//getHeight();
}
</script>
<script type="text/javascript">
$(function(){ 
	$(".u_i_f_btn").click(function (){
		var title = $("#title").val();
		var keyword = $("#keyword").val();
		var summary = $("#summary").val();
		if(title == ''){
			alert("标题不能为空"); return false;
		}
		if(keyword == ''){
			alert("关键字不能为空"); return false;
		}
		if(summary == ''){
			alert("描述不能为空"); return false;
		}
		$.ajax({
			url:"__CONTROLLER__/videoadd",
			data:"title="+title+"&keyword="+keyword+"&summary="+summary,
			type:"post",
			datatype:"json",
			success:function(data){
				var data = eval("("+data+")");
				if(data.status == 1){
					alert('上传成功');
					window.location.href="__APP__/Home/Feature/responsive";
				}else{
					alert(data.message);
				}
			}
		});
	});
});
function go(i){
	var type = '';
	if($('.u_i_f_menu a').eq(0).is('.on')){
		type = 1;
	}
	if($('.u_i_f_menu a').eq(1).is('.on')){
		type = 2;
	}
	if($('.u_i_f_menu a').eq(2).is('.on')){
		type = 3;
	}
	showpage(type,i,0);
}
function showpage(type,page,v_del){
	$.ajax({
		url:"__APP__/Home/Feature/responsive",
		data:"type="+type+"&page="+page,
		type:"post",
		datatype:"json",
		success:function(data){
			var data = eval("("+data+")");
			if(data.status == 1){
				//window.location.href="__APP__/Home/Feature/shortcode";
				var str = '';
				for(var i=0;i<data.message.num;i++){
					if(data.message[i].Photo !== ''){
						str += '<li><a href="'+data.message[i].filepath+'" class="pic" target="_blank"><img src="'+data.message[i].Photo+'"><span class="txt">'+data.message[i].Title+'</span></a><a href="javascript:del('+data.message[i].id+','+type+')" class="del" title="删除">删除</a></li>';
					}else{
						break;
					}
				}
				//document.write(str);
				$('.u_i_f_pic').eq(type-1).html(str);
				$('.u_i_f_pages').eq(type-1).html(data.message.page);
				if(v_del !== 0){
					showpage(v_del,1,0);
				}
			}else{
				alert('2'+data.message);
			}
		}
	});
}
function del(GlobalID,type){
	var page_del = 0;
	var v_del = 0;
	if(type == 1){
		$("#picture .u_i_f_pages span").each(function(){
			if($(this).is(".on")){
				page_del = $(this).text();
				return false;
			}
		})
	}
	if(type == 2){
		$("#video .u_i_f_pages span").each(function(){
			if($(this).is(".on")){
				page_del = $(this).text();
				return false;
			}
		})
	}
	if(type == 3){
		$("#txt .u_i_f_pages span").each(function(){
			if($(this).is(".on")){
				page_del = $(this).text();
				return false;
			}
		})
	}
	$.ajax({
		url:"__APP__/Home/Feature/video_del",
		data:"GlobalID="+GlobalID+"&type="+type,
		type:"post",
		datatype:"json",
		success:function(data){
			var data = eval("("+data+")");
			if(data.status == 1){
				if(type == 1){
					if(data.type == 0){
						v_del = 2;
					}else{
						v_del = 3;
					}
				}else{
					v_del = 1;
				}
				alert("删除成功");
				showpage(type,page_del,v_del);
				//showpage(type,1);
			}else{
				alert(data.message);
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
    <div class="u_i_left" id="u_i_left">
        <ul class="u_i_menu">
            <li><a href="../usercenter/page.jsp" class="grzl ">个人资料</a></li>
            <li><a href="../usercenter/responsive.jsp" class="spsc on">我的视频</a></li>
            <li><a href="../usercenter/shortcode.jsp" class="tpsc">我的相册</a></li>
            <li><a href="../usercenter/favorites.jsp" class="wdsc">我的收藏</a></li>
            <li><a href="../usercenter/comment.jsp" class="wdpl">我的评论</a></li>
            <li><a href="../usercenter/baoliao.jsp" class="wdbl">我的爆料</a></li>
            <li><a href="../usercenter/order.jsp" class="wddd">我的订单</a></li>
            <li><a href="../usercenter/address.jsp" class="wddz">我的地址</a></li>
            <li><a href="../usercenter/vote.jsp" class="wdtp">我的投票</a></li>
            <li><a href="../usercenter/password.jsp" class="mmxg">密码修改</a></li>
        </ul>
    </div>
    <div class="u_i_right" id="u_i_right">
        <div class="u_i_form" id="u_i_form">
		<div class="u_i_f_menu">
            <ul>
                <li><a href="javascript:change(1)" class="on">我的视频</a></li>
                <li><a href="javascript:change(2)">未审核视频</a></li>
                <li><a href="javascript:change(3)">已审核视频</a></li>
				<li class="upload"><a href="javascript:change(4)">上传视频</a></li>
            </ul>
        </div>
				<div id="picture">
					<ul class="u_i_f_pic" style="height:522px;">
						<foreach name="picture" item="arr">
						<li>
							<a href="{$arr.filepath}" class="pic" target="_blank"><img src="{$arr.Photo}"><span class="txt">{$arr.Title}</span></a>
							<a href="javascript:del('{$arr.id}',1)" class="del" title="删除">删除</a>
						</li>
						</foreach>
					</ul>
					<div class="u_i_f_pages"> {$ppic} </div>
				</div>
				<div id="video" style="display:none;">
					<ul class="u_i_f_pic" style="height:522px;">
						<foreach name="video" item="arr">
						<li>
							<a href="{$arr.filepath}" class="pic" target="_blank"><img src="{$arr.Photo}"><span class="txt">{$arr.Title}</span></a>
							<a href="javascript:del('{$arr.id}',2)" class="del" title="删除">删除</a>
						</li>
						</foreach>
					</ul>
					<div class="u_i_f_pages"> {$pvid} </div>
				</div>
				<div id="text" style="display:none;">
					<ul class="u_i_f_pic" style="height:522px;">
						<foreach name="text" item="arr">
						<li>
							<a href="{$arr.filepath}" class="pic" target="_blank"><img src="{$arr.Photo}"><span class="txt">{$arr.Title}</span></a>
							<a href="javascript:del('{$arr.id}',3)" class="del" title="删除">删除</a>
						</li>
						</foreach>
					</ul>
					<div class="u_i_f_pages"> {$ptxt} </div>
				</div>
		<form class="stdform" name="userinfoform" method="post" enctype="multipart/form-data" style="display:none;">
            <dl>
                <dt><span class="red">*</span>标题：</dt>
                <dd>
                    <input class="u_i_f_text" name="title" type="text" id="title" maxlength="30" placeholder="这里输入标题名">
                </dd>
            </dl>
            <dl>
                <dt><span class="red">*</span>关键词：</dt>
                <dd>
                    <input class="u_i_f_text" name="keyword" type="text" id="keyword" maxlength="20" placeholder=" (多个请用','隔开)">
                </dd>
            </dl>
            <dl>
                <dt><span class="red">*</span>视频文件：</dt>
                <dd><div class="u_i_face">
					<div id="uploader">
					<p>Your browser doesn't have Flash, Silverlight or HTML5 support.</p>
					</div>
					<script type="text/javascript">
					$(function() {
					  $("#uploader").plupload({
						runtimes : 'html5,flash,silverlight,html4',
						url : '{:U("Feature/upload")}',
						max_file_count:1,
						chunk_size: '1mb',
						resize : {
						  width : 200, 
						  height : 200, 
						  quality : 90,
						  crop: true 
						},
						
						filters : {
						  max_file_size : '1000mb',
						  mime_types: [
							{title : "files", extensions : "rm,rmvb,3gp,amv,dmv,flv,avi,asf,mp4,m4v,mpg,mpeg,mov,dat,mkv,vob,ram,qt,divx,cpk,fli,flc,mod"},
						  ]
						},
						rename: true,
						sortable: true,
						dragdrop: true,
						views: {
						  list: true,
						  thumbs: true, 
						  active: 'thumbs'
						},
						flash_swf_url : '__ROOT__/public/uploadvideo/plupload/js/Moxie.swf',
						silverlight_xap_url : '__ROOT__/public/uploadvideo/plupload/js/Moxie.xap',
						complete:function(event,args){
						  $('#uploader').plupload('disable');

						  console.log(args.files[0].name);
						  $("#size").val(args.files[0].size);
						}
					  });
					});
					$(function(){
					  $(".plupload_view_switch").remove();
					})
					</script>

				</div></dd>
            </dl>
            <dl>
                <dt><span class="red">*</span>作品简介：</dt>
                <dd>
                    <textarea name="summary" cols="65" rows="10" id="summary" placeholder="请填写您的作品描述"></textarea>
                </dd>
            </dl>
            <dl>
                <dt></dt>
                <dd><input type="button" class="u_i_f_btn" value="提交"></dd>
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