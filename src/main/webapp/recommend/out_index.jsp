<%@ page import="tidemedia.cms.system.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
  *
  *用途：推荐
  *王海龙 2015-05-26 添加确定按钮禁止二次点击功能
  *曲科籍 2017-01-17 增加推荐列表功能
  *
  *
  */
int		channelid	=	getIntParameter(request,"ChannelID");
String	itemid		=	getParameter(request,"ItemID");
String	target		=	getParameter(request,"Target");

Tree2019 tree = new Tree2019();
JSONArray arr = tree.listTreeByChannelRecommendOut_json(userinfo_session,channelid);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	html,body{height:100%;}
	.br-mainpanel{margin-top: 0px;margin-left: 230px;}
	.br-subleft{left: 0 !important;top: 0 !important;}
	.sidebar-menu li .treeview-menu.menu-open {
		display: block;
	}
	.sidebar-menu{margin-top:0px;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>

<script language="javascript">  
var dir = "";
var ChannelID_Source_ = <%=channelid%>;
var itemid = "<%=itemid%>";
function next()
{
	var channelid = "";
	var flag = 0;
	jQuery("#leftTd input:checked").each(function(i){
		if(i==0)
			channelid+=jQuery(this).val();
		else
			channelid+=","+jQuery(this).val();
	});
	if(flag==1){
		var	dialog = new top.TideDialog();
		dialog.showAlert("请勿推荐到当前频道","danger");
		return false;
	}
	if (channelid!="")
	{
		/*
		var channelid = window.frames["treeFrame"].getChannelID();
		var channeltype = window.frames["treeFrame"].getChannelType();
		//alert(channeltype);
		if(channelid=="" || (channeltype!=1 && channeltype!=0))
		{
			alert("请选择频道.");
			return false;
		}*/

		$("#submitButton").attr("disabled",true);
		var url="../content/document_move_check.jsp?ItemID="+itemid+"&SourceChannel="+ChannelID_Source_+"&DestChannel="+channelid;
		$.ajax({
			 type: "GET",
			 url: url,
			 dataType:'json',
			 success: function(msg){
				 var result = msg.msg;
				 if(result=="false"){
						var	dialog = new top.TideDialog();
						dialog.showAlert("请勿推荐到当前文章所在频道","danger");
						$("#submitButton").attr("disabled",false);
						return false;
				 }else{
					 if(itemid.indexOf(",")!=-1 || channelid.indexOf(",")!=-1)
						{
							var IsApprove = "0";
							if($("#IsApprove").attr("checked")) IsApprove = "1";
							var url = "out_submit_items.jsp?ChannelID=" + channelid +"&RecommendChannelID="+<%=channelid%>+"&RecommendItemID="+itemid;
							url += "&IsApprove="+IsApprove;
							//alert(url);return;
							document.location = url;
						}
						else
						{
							var url="../content/document.jsp?ItemID=0&ChannelID=" + channelid+ "&ROutTarget=<%=target%>&ROutChannelID="+<%=channelid%>+"&ROutItemID="+itemid;
							window.open(url);
							top.TideDialogClose('');
						}
				}
			 }   
		}); 
	}
	else
	{
		alert("请选择频道.");
		//list();
		return false;
	}
	
}

function lists()
{
  	var url="../recommend/recommend_out.jsp?ItemID=<%=itemid%>&ChannelID=" + <%=channelid%>;
  	window.open(url);
        // alert("-------");
}

 
</script>
</head>

<body class="collapsed-menu email">

	<div class="bg-white modal-box">

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto pd-t-10-force">

			<div class="br-subleft-file" id="leftTd">
				<ul class="sidebar-menu">	  	  

				</ul>
			</div><!-- br-subleft -->

		</div>

		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
			<div class="modal-footer" >
				<input type="checkbox" value="1" name="IsApprove" id="IsApprove" checked><span>是否发布</span>
				<button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton" onclick="next();">确认</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
				<button type="button" class="btn btn-primary tx-size-xs"  id="submitButton" onclick="lists();">推荐列表</button>
			</div> 
		</div>	

	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-channel.js"></script>

	<script>
        $(function(){
			//$('.br-mailbox-list,.br-subleft').perfectScrollbar();	
			            
			var menu = $('.sidebar-menu');
			var json = <%=arr%>;

			//var html = '<li class="treeview"><a href="#" load="0" channelId="0"><i class="fa fisrtNav fa-home" have="1"></i> <span>推荐</span></a><ul class="treeview-menu" style="display: block;">';
			var html = '<li class="treeview"><ul class="treeview-menu" style="display: block;">';

			for(var i=0;i<json.length;i++){

				html += '<li><a href="#" load="'+json[i].load+'" channelId="'+json[i].id+'">'
				if(json[i].load==1||(json[i].child && json[i].child.length>0)){
					html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
				}else{
					html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
				} 
				html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';

				if(json[i].child && json[i].child.length>0){
					html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json[i]) + '</ul>';
				}
				html += '</li>';
			}

			html += '</ul></li>';

			menu.append(html);

			//多级导航自定义
			$.sidebarMenu(menu);
			backToOriginal(json);  //频道记忆
		});

		function get_menu_html(json)
		{
			var html = "";
			if(json.child && json.child.length>0)
			{
				var json_ = json.child;
				for(var i=0;i<json_.length;i++){
					html += '<li><a href="#" load="'+json_[i].load+'" channelId="'+json_[i].id+'">'
					if(json_[i].load==1||(json_[i].child && json_[i].child.length>0)){
						html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
					}else{
						html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
					} 
					html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json_[i].id+'"><span style="padding:0"></span></label><span>'+json_[i].name+'</span></a>';

					if(json_[i].child && json_[i].child.length>0){
						html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json_[i]) + '</ul>';
					}
					html += '</li>';
				}
			}
			return html;
		 }

		 function setChannelCookie(_id){
			$.ajax({
				type:"GET",
				url:"../channel/getChannelPath.jsp?ChannelID="+_id,
				success: function(data){
					tidecms.setCookie("recommend_channel_path",data.trim());
				}
			});		
		}
		//返回最后一级导航
		function backToOne(ids){
		
			var current = ids ? ids:_activeChannelid
			if(current){
				var currentChannel  =  $(".sidebar-menu a[channelid='"+current+"']") ;
				$(".sidebar-menu li").removeClass("active");
				currentChannel.parent("li").addClass("active");
			}			
		}
		//返回二三四级导航
		function backToOuter(){
			channelStart ++ ;
			if(channelStart == channel_id_array.length-1){		    	
				backToOne(channel_id_array[channel_id_array.length-1]);
				return ;
			}
			backToInner(channel_id_array[channelStart])
		}		
		//二三四级导航
		function backToInner(_id){	
			var url="../lib/channel_json.jsp?ChannelID="+_id;
			var $this = $(".sidebar-menu a[channelid='"+_id+"']")			
			var checkElement = $this.next();
			var load = $this.attr("load");
			if(load==1) 
			{
				$.ajax({
					type:"GET",
					dataType:"json",
					url:url,			
					success: function(json){
						var html = '<ul class="treeview-menu" style="display: none;">';
			
						for(var i=0;i<json.length;i++){
							if(json[i].child && json[i].child.length>0)
							{
								html += '<li class="treeview">';
							}
							else
							{
								html += '<li>';
							}
							html += '<a href="javascript:;" load="'+json[i].load+'" channelid="'+json[i].id+'" channeltype="'+json[i].type+'">';
		
							if(json[i].load==1||(json[i].child && json[i].child.length>0)){
								if(json[i].type==0){
									html += '<i class="fa fa-angle-double-right" hava="1"></i>';
								}else{
									html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>';
								}
								
							}else{
								
								if(json[i].type==0){
									html += '<i class="fa fa-angle-right" hava="0"></i>';
								}else{
									html += '<i class="fa fa-angle-right op-5" hava="0"></i>';
								}
							}
							html += '<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
		
							if(json[i].child && json[i].child.length>0)
							{
								html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json[i]) + '</ul>';
							}
							html += '</li>';
						}
						html += '</ul>';
						$this.nextAll().remove();
						$this.after($(html));
						$this.attr("load",0);//加载完毕改变load属性
						checkElement = $this.next();
						sidebarMenu_show_back(checkElement,$this,backToOuter);
					}
				});	
			}
			else
			{
				sidebarMenu_show_back(checkElement,$this,backToOuter);
			}
		}
		var _activeChannelid = 0 ;  //记忆的频道号
		var channelStart = 0 ; //起始频道id
		var channel_id_array = null ;  
		function backToOriginal(arr){
			var channel_path = getCookie("recommend_channel_path");
			if(channel_path){
				
				channel_id_array = channel_path.split(",");
				//判断记忆频道其实
				var n = -1 ;
				for(var i=0;i<arr.length;i++){
					var channelStart_id = arr[i].id+"";
					n = channel_id_array.indexOf(channelStart_id);
					if(n!=-1){break;}
				}
				channel_id_array = channel_id_array.slice(n);
				
				
			}else{
				return ;
			}

			if(channel_id_array.length==1){  //站点
				var $this = $(".sidebar-menu a[channelid='"+channel_id_array[0]+"']") ;
				$(".sidebar-menu li").removeClass("active");
				$this.parent("li").addClass("active");
			}else if(channel_id_array.length==2){    //站点下一级导航 
				var $this = $(".sidebar-menu a[channelid='"+channel_id_array[0]+"']") ;
				_activeChannelid = channel_id_array[1] ;
				var checkElement = $this.next() ;			   
				sidebarMenu_show_back(checkElement,$this,backToOne)
			}else if(channel_id_array.length>2){   //二三四级导航
				var $this = $(".sidebar-menu a[channelid='"+channel_id_array[0]+"']") ;
				var checkElement = $this.next() ;			    
				sidebarMenu_show_back(checkElement,$this,backToOuter)
			}		    
		}
//========================================================================
		$.sidebarMenu = function(menu) {
			var animationSpeed = 300;
		  
			$(menu).on('click', 'li a', function(e) {
				var $this = $(this);
				var checkElement = $this.next();

				var load = $this.attr("load");
				var channelid = $this.attr("channelid");
				setChannelCookie(channelid);
				if(load==1) 
				{		
					var url="../lib/channel_json.jsp?ChannelID="+channelid;
					$.ajax({
						type:"GET",
						dataType:"json",
						url:url,
						success: function(json){
						var html = '<ul class="treeview-menu" style="display: none;">';

						for(var i=0;i<json.length;i++){
							if(json[i].child && json[i].child.length>0)
							{
								html += '<li class="treeview">';
							}
							else
							{
								html += '<li>';
							}
							html += '<a href="#" load="'+json[i].load+'" channelid="'+json[i].id+'">';

							if(json[i].load==1||(json[i].child && json[i].child.length>0)){
								html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
							}else{
								html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
							}
							html += '<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';

							if(json[i].child && json[i].child.length>0)
							{
								html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json[i]) + '</ul>';
							}
							html += '</li>';
						}
						html += '</ul>';
						$(".nav-loading").remove();
						$this.nextAll().remove();
						$this.after($(html));
						$this.attr("load",0);//加载完毕改变load属性
						checkElement = $this.next();
						sidebarMenu_show(checkElement,animationSpeed,$this);
					}});
				
				}
				else
				{
					sidebarMenu_show(checkElement,animationSpeed,$this);
				}
				
			});
		}	
	</script>

	</div>
</body>
</html>
