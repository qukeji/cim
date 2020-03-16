<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				java.util.*,
				tidemedia.cms.util.*,tidemedia.cms.publish.*,java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int role = userinfo_session.getRole();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>系统监控</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script>
var role = <%=role%>;
//稿件删除
function clear(){
	if(role==1){
		var url="./system/clear_index.jsp";
		var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(300);
		dialog.setUrl(url);
		dialog.setScroll('auto');
		dialog.setTitle("稿件删除");
		dialog.show();
	}else{
		alert("对不起，你没有访问权限.");
	}
}
//URL撤稿
function deleteFile(){
	var url="./system/deleteFile_index.jsp";
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(150);
	dialog.setUrl(url);
	dialog.setScroll('auto');
	dialog.setTitle("URL撤稿");
	dialog.show();
}
</script>
</head>
<body onload="">
<div class="content_t1">
	<div class="content_t1_nav">数据清理：</div>
</div>

<div class="content_2012">
	<div class="viewpane">
        <div class="viewpane_tbdoy">
			<div class="toolbar" style="margin:14px 0 0;">
				
				<div class="tidecms_btn">
					<div class="t_btn_txt"><a href="show_page_data.jsp">页面数据</a></div>
				</div>

				 <div class="tidecms_btn">
					<div class="t_btn_txt"><a href="clear_channel.jsp">频道数据</a></div>
				</div>

				<div class="tidecms_btn">
					<div class="t_btn_txt"><a href="javascript:clear();">稿件批量删除</a>
						<div class="tips-box">
							<div class="tips-content">						
								<p>批量删除频道下某时间段的所有稿件</p>
							</div>
							<div class="tips-triangle"></div>					
						</div>
					</div>
				</div>

				<div class="tidecms_btn">
					<div class="t_btn_txt"><a href="javascript:deleteFile();">URL快速撤稿</a>
						<div class="tips-box">
							<div class="tips-content">						
								<p>根据文章预览地址对文章进行撤稿</p>
							</div>
							<div class="tips-triangle"></div>					
						</div>
					</div>
				</div>

				<div class="tidecms_btn">
					<div class="t_btn_txt"><a href="manager.jsp">返回</a></div>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
	$(function(){
		var tipsTimer = null ;
		$(".t_btn_txt").mouseover(function(){
			//clearTimeout(tipsTimer);
			$(this).find(".tips-box").fadeIn(50);
		}).mouseleave(function(){
			var _this = this ;
			tipsTimer = setTimeout(function(){
				$(_this).find(".tips-box").fadeOut(50);
				clearTimeout(tipsTimer);
			},50)   		
		})	
	})
</script>
</body>
</html>