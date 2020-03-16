<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*,java.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public String getParentChannelPath(List<Integer> cpidlist) throws MessageException, SQLException{

    String path = "";
    if ((cpidlist != null) && (cpidlist.size() > 0))
    {
      for (int i = 0; i < cpidlist.size(); ++i)
      {
		path = path  +  cpidlist.get(i) + ((i < cpidlist.size() - 1) ? "," : "");  
      }
    }

    return path;
}
%>
<%!
public String getShowPath(Channel channel) throws Exception{//显示站点发布节点

    String path = "";
    ArrayList arraylist = channel.getParentTree();

    if ((arraylist != null) && (arraylist.size() > 0))
    {
      for (int i = 0; i < arraylist.size(); ++i)
      {
        Channel ch = (Channel)arraylist.get(i);

		if((i+1)==arraylist.size()){//当前频道名
			path = path  + ch.getName() ;// + ((i < arraylist.size() - 1) ? ">" : "");
		}else{
			path = path  + ch.getName() + " > ";// + ((i < arraylist.size() - 1) ? ">" : "");
		}        
      }
    }

    arraylist = null;

    return path;
}
%>
<%
	int	 ChannelID	=	getIntParameter(request,"ChannelID");
	int	 ItemID	=	getIntParameter(request,"ItemID");
	Channel channel = CmsCache.getChannel(ChannelID);
	Document doc = CmsCache.getDocument(ItemID, ChannelID);
	int globalid = doc.getGlobalID();
	ChannelRecommend cr = new	ChannelRecommend();
	Tree2019 tree =new Tree2019();
	JSONArray    Array = tree.listTreeByChannelRecommendOut_json1(userinfo_session,ChannelID,0);
	JSONArray    Array1 = tree.listTreeByChannelRecommendOut_json1(userinfo_session,ChannelID,1);
	//JSONArray    Array2 = tree.listTreeByChannelRecommendOut_json1(userinfo_session,ChannelID,2);
	//=2时为两微,需要查询
	JSONArray    Array2  =	cr.findWeiXinAccount(userinfo_session.getId());
	JSONArray    Array3 = tree.listTreeByChannelRecommendOut_json1(userinfo_session,ChannelID,3);
	JSONArray    Array4 = tree.listTreeByChannelRecommendOut_json1(userinfo_session,ChannelID,4);
	JSONArray    Array5 = tree.listTreeByChannelRecommendOut_json1(userinfo_session,ChannelID,5);
	int  arrlen  = Array.length();
	int  arrlen1 = Array1.length();
	int  arrlen2 = Array2.length();
	int  arrlen3 = Array3.length();
	int  arrlen4 = Array4.length();
	int  arrlen5 = Array5.length();
	int  mflag = -1;//banner选中标记
	if(arrlen > 0){
		mflag = 0;
	}else if(arrlen1 > 0 ){
		mflag = 1;
	}else if(arrlen2 > 0){
		mflag = 2;
	}else if(arrlen3 > 0){
		mflag = 3;
	}else if(arrlen4 > 0){
		mflag = 4;
	}else if(arrlen5 > 0){
		mflag = 5;
	}else{
		mflag = -1;
	}
	
	String sql = "select * from recommend where GlobalID="+globalid +" order by CreateDate desc";
	TableUtil tu = new TableUtil();
	ResultSet rs = tu.executeQuery(sql);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS 列表</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

<link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	html,body{width: 100%;height: 100%;}
	.br-mainpanel{height: 100%;}
	.br-mainpanel>.row{
		height: calc(100% - 20px);
		padding-top: 20pxs;
	}
	.pagebody-left .br-content-box , .pagebody-right{min-height: 500px;height: 100%;}
	.td-handle{display: flex;}
	ul,li{list-style: none;}
	.dpnone{display: none;}
	.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
	.push-col-row #push-nav{display:flex;height:42px;padding:0;margin:0;background:#e8ecef;line-height:40px;padding:0 20px;border-radius:3px;justify-content:flex-start;}
	.push-col-row #push-nav li{border-bottom:2px solid transparent;display:inline-block;margin:0 20px 0 0;position:relative;top:1px;cursor:pointer;color:#9b9ea0;font-size:14px;white-space:nowrap}
	.push-col-row #push-nav li.ac{color:#333;border-bottom:2px solid #000}
	.push-col-row #push-body{min-height:200px}
    .push-item{display: none;}
    .push-item:nth-child(1){display: block;}
    .tx-warning{color: #f49917 !important;}
    .table td, .table th{vertical-align: middle;}
    .sidebar-menu-box{margin-top: 10px;}
    @media only screen and (max-width: 640px) {
    	.td-handle{display: block;}
    	.pagebody-right{margin-left: 10px;}
    }
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script>
	var dir = "" ;
	var channelidList = "";
	var wid="";
	function getAllCheck(){
		jQuery("#push-body input:checked[name='id']").each(function(i){
			if(i==0)
				channelidList+=jQuery(this).val();
			else
				channelidList+=","+jQuery(this).val();
		});
		return channelidList;
	}
	function getWxCheck(){
		jQuery("#push-body input:checked[name='wid']").each(function(i){
			if(i==0)
				wid+=jQuery(this).val();
			else
				wid+=","+jQuery(this).val();
		});
		return wid;
	}
</script>
</head>
<body class="collapsed-menu email"> 	
	<div class="br-mainpanel br-mainpanel-file">      
		<div class="row row-sm mg-t-0 mg-x-0-force pd-t-30">
			<div class="col-sm-8 pd-x-0-force">
				<div class="br-pagebody ht-100p pd-x-20 pagebody-left mg-t-0-force">
			  		<div class="br-content-box ht-100p pd-20 bg-white">
						<div class="bd">
							<table class="table mg-b-0">
								<thead>
									<tr>	               
										<th class="tx-12-force tx-mont tx-medium wd-7p">类型</th>
										<th class="tx-12-force tx-mont tx-medium wd-20p">发布节点</th>
										<th class="tx-12-force tx-mont tx-medium wd-45p">标题</th>  
										<th class="tx-12-force tx-mont tx-medium wd-8p">状态</th>  
										<th class="tx-12-force tx-mont tx-medium wd-20p">操作</th>	               
									</tr>
								</thead>
								<tbody class="tx-12" id="showlist">
								<% 
								 while(rs.next()){
									int ChannelType = rs.getInt("ChannelType");//0：网站 1：APP 2：两微  3：三方媒体 4：电视端 5：其他
									String type = "网站";
									switch (ChannelType) {
									case 1:
										type = "APP";
										break;
									case 2:
										type = "两微";
										break;
									case 3:
										type = "三方媒体";
										break;
									case 4:
										type = "电视端";
										break;
									case 5:
										type = "其他";
										break;
									default:
										type = "网站";
										break;
									}
									int  channlid;
									int  ChildGlobalID = 0;
									 Document docu1;
									Channel  channel1;
									 Document docu2;
									 int  channelId;
									 int  id;
									 String  sitePath;
									 Channel  channel2;
									 String title = "";
									 int status = 0;
								 if(ChannelType != 2){
									channlid = rs.getInt("ChannelID");
									ChildGlobalID = rs.getInt("ChildGlobalID");
									 channel1 =CmsCache.getChannel(channlid);
									 docu1 = CmsCache.getDocument(globalid);
									 docu2 = CmsCache.getDocument(ChildGlobalID);
									 channelId = docu2.getChannelID();
									 id = docu2.getId();
									 channel2 =CmsCache.getChannel(channelId);
									 sitePath = getShowPath(channel2);
									title = docu2.getTitle();
									status = docu2.getStatus();//0-草稿  1-已发
								 }else{
									 channlid = rs.getInt("ChannelID");
									 //int  ChildGlobalID = rs.getInt("ChildGlobalID");
								     channel1 =CmsCache.getChannel(channlid);
									 docu1 = CmsCache.getDocument(globalid);
									// Document docu2 = CmsCache.getDocument(ChildGlobalID);
									  docu2 = docu1;
									  channelId = docu2.getChannelID();
									  id = docu2.getId();
									  channel2 =CmsCache.getChannel(channelId);
									 //sitePath = getShowPath(channel2);
									String  wid =  rs.getString("weixinItemID");
									JSONArray array =  new ChannelRecommend().findWeiXinAccount(userinfo_session.getId());
									if(array.isNull(0)){
										sitePath = "";
										status = 1;
										title = "";
									}else{
										   sitePath = array.getJSONObject(0).get("accountname").toString();
											String sql1 = "select title from weixin_newsitem where ID = '" + wid+"'";
											TableUtil tu1  = new TableUtil();
											ResultSet  rs1 =   tu1.executeQuery(sql1);
											if(rs1.next()){
												title = rs1.getString("title");
											}
											//title = docu2.getTitle();
											//status = docu2.getStatus();//0-草稿  1-已发
											status = 1;
									}
								 }
								 /*
								  int  channlid = rs.getInt("ChannelID");
									 int  ChildGlobalID = rs.getInt("ChildGlobalID");
									 Channel  channel1 =CmsCache.getChannel(channlid);
									 Document docu1 = CmsCache.getDocument(globalid);
									 Document docu2 = CmsCache.getDocument(ChildGlobalID);
									 int  channelId = docu2.getChannelID();
									 int  id = docu2.getId();
									 Channel  channel2 =CmsCache.getChannel(channelId);
									 String  sitePath = getShowPath(channel2);
									 String title = docu2.getTitle();
									 int status = docu2.getStatus();//0-草稿  1-已发
								 */
								%>
								<tr  <%if(sitePath == ""){%> style="display:none" <%}%>>
									<td><%=type%></td>
									<td><a href="javascript:;" class="pd-l-5"><%=sitePath%></span></td>
									<td><%=title%></td>
									<td>
									<%if(status == 0){%>
										草稿
									<%}else{%>
										已发布
									<%}%>
									</td>
									<%if(ChannelType!=2){%>	                												
									<td class="td-handle">
										<button class="btn btn-info btn-sm mg-r-5 tx-13" onclick="edit(<%=id%>,<%=channelId%>)">编辑</button>
										<button class="btn btn-info btn-sm mg-r-5 tx-13" onclick="delete3(<%=id%>,<%=channelId%>)">撤稿</button>
										<button class="btn btn-info btn-sm tx-13" onclick="delete1(<%=id%>,<%=channelId%>,<%=ChildGlobalID%>)">删除</button>
									</td>
									<%}else{%>
									<td class="td-handle">
									</td>
									<%}%>
								</tr>
								<!--<tr>
									<td>网站</td>
									<td><a href="javascript:;" class="pd-l-5">网站>本地>一周质量报告网站>本地></span></td>
									<td>标题plus标题plus标题plus标题plus标题plus标题plus标题plus标题plus标题plus</td>
									<td>已发布</td>	                												
									<td class="td-handle">
										<button class="btn btn-info btn-sm mg-r-5 tx-13" onclick="">编辑</button>
										<button class="btn btn-info btn-sm mg-r-5 tx-13" onclick="">撤稿</button>
										<button class="btn btn-info btn-sm tx-13" onclick="">删除</button>
									</td>
								</tr>
								  <tr>
									<td>网站</td>
									<td><a href="javascript:;" class="pd-l-5">网站>本地>一周质量报告网站>本地></span></td>
									<td>标题plus标题plus标题plus标题plus标题plus标题plus标题plus标题plus标题plus</td>
									<td>已发布</td>	                												
									<td class="td-handle">
										<button class="btn btn-info btn-sm mg-r-5 tx-13" onclick="">编辑</button>
										<button class="btn btn-info btn-sm mg-r-5 tx-13" onclick="">撤稿</button>
										<button class="btn btn-info btn-sm tx-13" onclick="">删除</button>
									</td>
								</tr>-->
								<%} %>
								</tbody>
							</table>								
						</div>
				  	</div>
				</div>		
			</div>
			<div class="col-sm-4 pd-x-0-force push-col-row">
				<div class="br-pagebody bg-white mg-l-0 mg-r-20 pd-x-0-force pagebody-right mg-t-0-force">
					<div class="br-content-box pd-20"> 
						<div class="push-container">
							<ul id="push-nav" class="">
					          <li data-nav="" 
					          <%if(mflag == 0){%>
					         	 class="ac"
					          <%}%>
					          <%if(arrlen == 0){%>
					              style = "display:none"
					          <%}%>
					          >网站</li> 
					          <li data-nav="" 
					           <%if(mflag == 1){%>
					         	 class="ac"
					          <%}%>
					          <%if(arrlen1 == 0){%>
					              style = "display:none"
					          <%}%>
					          >APP</li> 
					          <li data-nav="" 
					           <%if(mflag == 2){%>
					         	 class="ac"
					          <%}%>
					          <%if(arrlen2 == 0){%>
					              style = "display:none"
					          <%}%>
					          >两微</li> 
					          <li data-nav="" 
					           <%if(mflag == 3){%>
					         	 class="ac"
					          <%}%>
					          <%if(arrlen3 == 0){%>
					              style = "display:none"
					          <%}%>
					          >三方媒体</li> 
					          <li data-nav="" 
					           <%if(mflag == 4){%>
					         	 class="ac"
					          <%}%>
					          <%if(arrlen4 == 0){%>
					              style = "display:none"
					          <%}%>
					          >电视端</li> 
					          <li data-nav="" 
					           <%if(mflag == 5){%>
					         	 class="ac"
					          <%}%>
					          <%if(arrlen5 == 0){%>
					              style = "display:none"
					          <%}%>
					          >其他</li> 
					        </ul>
					        <ul id="push-body">
					        	<li class="push-item"
					        	<%if(arrlen == 0){%>
					              style = "display:none"
					          	<%}%>
					        	>
					        		<div class="sidebar-menu-box ht-100p-force overflow-auto">
										<ul class="sidebar-menu mg-t-0-force">
											<li class="treeview">
												<ul class="treeview-menu" style="display: block;" id="menu0">
												</ul>
											</li>
										</ul>
									</div>
					        	</li>
					        	<li class="push-item"
					        	<%if(arrlen1 == 0){%>
					              style = "display:none"
					          <%}%>
					        	>
					        		<div class="sidebar-menu-box ht-100p-force overflow-auto">
						        	<ul class="sidebar-menu mg-t-0-force" >
						        		<li class="treeview">
												<ul class="treeview-menu" style="display: block;" id="menu1">
												</ul>
										</li>
									</ul>
									</div>
					        	</li>
					        	<li class="push-item" 
					        	<%if(arrlen2 == 0){%>
					              style = "display:none"
					          <%}%>
					          >
					        		<div class="sidebar-menu-box ht-100p-force overflow-auto">
										<ul class="sidebar-menu mg-t-0-force">
											<li class="treeview">
												<a href="#" load="0" channelid="0"><i class="fa fisrtNav fa-wechat tx-info" have="1"></i> <span>微信</span></a>
												<ul class="treeview-menu" style="display: block;" id="menu2">
												</ul>
											</li>
										</ul>
									</div>
									<!-- <div class="sidebar-menu-box ht-100p-force overflow-auto">
										<ul class="sidebar-menu mg-t-0-force">
											<li class="treeview">
												<a href="#" load="0" channelid="0"><i class="fa fisrtNav fa-weibo tx-warning" have="1"></i> <span>微博</span></a>
												<ul class="treeview-menu" style="display: block;" id="menu2">
												</ul>
											</li>
										</ul>
									</div> -->
								</li>
								<li class="push-item"
								<%if(arrlen3 == 0){%>
					              style = "display:none"
					          <%}%>
								>
					        		<div class="sidebar-menu-box ht-100p-force overflow-auto">
										<ul class="sidebar-menu mg-t-0-force">
											<li class="treeview">
												<ul class="treeview-menu" style="display: block;" id="menu3">
												</ul>
											</li>
										</ul>
									</div>
								</li>
								<li class="push-item"
								<%if(arrlen4 == 0){%>
					              style = "display:none"
					          <%}%>
								>
					        		<div class="sidebar-menu-box ht-100p-force overflow-auto">
										<ul class="sidebar-menu mg-t-0-force">
											<li class="treeview">
												<ul class="treeview-menu" style="display: block;" id="menu4">
												</ul>
											</li>
										</ul>
									</div>
								</li>
								<li class="push-item"
								<%if(arrlen5 == 0){%>
					              style = "display:none"
					          <%}%>
								>
					        		<div class="sidebar-menu-box ht-100p-force overflow-auto">
										<ul class="sidebar-menu mg-t-0-force">
											<li class="treeview">
												<ul class="treeview-menu" style="display: block;" id="menu5">
												</ul>
											</li>
										</ul>
									</div>
								</li>
					        </ul>
						</div>
					</div>
				</div>
			</div>
		</div>	
	</div>
 
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
	<script src="../common/2018/common2018.js"></script>
	
    <script src="../common/2018/bracket.js"></script>  
    <script src="../common/2018/sidebar-menu-channel.js"></script>
	<!-- <script type="text/javascript" src="../common/2018/content.js"></script> -->
    <script>
      $(function(){
        'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
        
        $(document).on('mouseover', function(e){
          e.stopPropagation();
          if($('body').hasClass('collapsed-menu')) {
            var targ = $(e.target).closest('.br-sideleft').length;
            if(targ) {
              $('body').addClass('expand-menu');

              // show current shown sub menu that was hidden from collapsed
              $('.show-sub + .br-menu-sub').slideDown();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.removeClass('d-lg-none');
              menuText.removeClass('op-lg-0-force');

            } else {
              $('body').removeClass('expand-menu');

              // hide current shown menu
              $('.show-sub + .br-menu-sub').slideUp();

              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.addClass('op-lg-0-force');
              menuText.addClass('d-lg-none');
            }
          }
        });

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function(e){
          e.preventDefault();
          if($('body').hasClass('show-mb-left')) {
            $('body').removeClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
          } else {
            $('body').addClass('show-mb-left');
            $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
          }
        });
         
  
      });
    </script>
    
    <!--自定义函数-->
    <script>
	    /*$(function(){	    	
		    $.sidebarMenu('.sidebar-menu');
		    
			$.sidebarMenu = function(menu) {
				var animationSpeed = 300;
			  
				$(menu).on('click', 'li a', function(e) {
					var $this = $(this);
					var checkElement = $this.next();
	
					checkElement = $this.next();
					sidebarMenu_show(checkElement,animationSpeed,$this);
					
				});
			}	
	    })*/
	    
	    
	    
	    //切换
	    $("#push-nav li").click(function(){
	    	var _index = $(this).index();
	    	$("#push-nav li").removeClass("ac");
	    	$(this).addClass("ac")
	    	$(".push-item").hide().eq(_index).show() ;
	    })
	    
	  </script>
		<script>
        $(function(){
			$('.br-mailbox-list,.br-subleft').perfectScrollbar();	
			var menu = $('.sidebar-menu');
			for(var m = 0; m < 6 ;m++){
				var json = [];
				if(m == 0){
					json = <%=Array%>;
				}
				if(m == 1){
					json = <%=Array1%>;
				}
				if(m == 2){
					json = <%=Array2%>;
				}
				if(m == 3){
					json = <%=Array3%>;
				}
				if(m == 4){
					json = <%=Array4%>;
				}
				if(m == 5){
					json = <%=Array5%>;
				};
				//if(json.length == 0){
				//	continue;
				//}
				//var html = '<li class="treeview"><a href="#" load="0" channelId="0"><i class="fa fisrtNav fa-home" have="1"></i> <span>推荐</span></a><ul class="treeview-menu" style="display: block;">';
				var html = "";
				if(m != 2){
					for(var i=0;i<json.length;i++){
		
						html += '<li><a href="#" load="'+json[i].load+'" channelId="'+json[i].id+'">'
						if(json[i].load==1||(json[i].child && json[i].child.length>0)){
							html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
						}else{
							html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
						} 
						//html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
						html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'" onchange="showMessage('+m+","+json[i].id+')" id="cb_'+m+json[i].id+'" ><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
						if(json[i].child && json[i].child.length>0){
							//html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json[i]) + '</ul>';
							html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json[i],m) + '</ul>';
						}
						html += '</li>';
					}
				}else{//两微
					for(var i=0;i<json.length;i++){
						
						html += '<li><a href="#" load="1" channelId="'+json[i].id+'"><i class="fa fa-angle-right op-5" hava="0"></i>'
						//html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
						html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="wid" value="'+json[i].id+'" onchange="showMessage('+m+",\'"+json[i].id+'\')" id="cb_'+m+json[i].id+'" ><span style="padding:0"></span></label><span>'+json[i].accountname+'</span></a></li>';
					}
				}
				html += '</ul></li>';
				//menu.append(html);
				$("#menu"+m).append(html);
			}
			//多级导航自定义
			$.sidebarMenu(menu);
			backToOriginal(json);  //频道记忆
		});
		

		function get_menu_html(json,m)
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
					html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json_[i].id+'" onchange="showMessage('+m+","+json_[i].id+')" id="cb_'+m+json_[i].id+'"><span style="padding:0"></span></label><span>'+json_[i].name+'</span></a>';
					if(json_[i].child && json_[i].child.length>0){
						html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json_[i],m) + '</ul>';
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
			var  type = $(".ac").text();
			var m = 0;
			if(type == "网站"){
				 m = 0;
			}
			if(type == "APP"){
				 m = 1;
			}
			if(type == "两微"){
				 m = 2;
			}
			if(type == "三方媒体"){
				 m = 3;
			}
			if(type == "电视端"){
				 m = 4;
			}
			if(type == "其他"){
				 m = 5;
			}
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
							html += '<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'" onchange="showMessage('+m+","+json[i].id+')" id="cb_'+m+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
							if(json[i].child && json[i].child.length>0)
							{
								html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json[i],m) + '</ul>';
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
		function backToOriginal(){
	        var channel_path = "";
			if(channel_path){
				if(channel_path.indexOf(",") != -1){
					channel_id_array = channel_path.split(",");	
				}else{
					channel_id_array = channel_path;
				}
											
			}else{
				activeFn();
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
		
		function activeFn(){
        	var timer = setInterval(function(){
        		if($(".sidebar-menu li.active a:first")){
        			var activeChannel = $(".sidebar-menu li.active a:first");
					try {
						activeChannel[0].click();
					}catch(err) {
					}
					clearInterval(timer)
        		}
        	},20)       	
        }
//========================================================================
		$.sidebarMenu = function(menu) {
	
			
			var animationSpeed = 300;
		  
			$(menu).on('click', 'li a', function(e) {
				var  type = $(".ac").text();
				var m = 0;
				if(type == "网站"){
					 m = 0;
				}
				if(type == "APP"){
					 m = 1;
				}
				if(type == "两微"){
					 m = 2;
				}
				if(type == "三方媒体"){
					 m = 3;
				}
				if(type == "电视端"){
					 m = 4;
				}
				if(type == "其他"){
					 m = 5;
				}
				if(m == 2){
					return;
				}
				var $this = $(this);
				var checkElement = $this.next();

				var load = $this.attr("load");
				var channelid = $this.attr("channelid");
				//setChannelCookie(channelid);
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
							html += '<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'" onchange="showMessage('+m+","+json[i].id+')" id="cb_'+m+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
							if(json[i].child && json[i].child.length>0)
							{
								html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json[i],m) + '</ul>';
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
						//调整父页面iframe高度
						try{
							top.childAdjustFrameH("#oneDocManySend")
						}catch(e){
							console.log("顶层页面未找到该函数",e)
						}
						
					}});
				
				}else{
					sidebarMenu_show(checkElement,animationSpeed,$this);
					//调整父页面iframe高度
					try{
						top.childAdjustFrameH("#oneDocManySend")
					}catch(e){
						console.log("顶层页面未找到该函数",e)
					}
				}
				
			});
		}	
	</script>
	<script>
		var  ChannelID = <%=ChannelID%>;
		var  ItemID = <%=ItemID%>;
		var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+20+"&currPage="+1;
		function showMessage(m,changeId){
			var  type = $(".ac").text();
			if($("#cb_"+m+changeId).is(':checked')){//选中
				$.ajax({
					type: "GET",
					url:"showlist_multiple.jsp",
					dataType:"json",
					data:{
						ChannelID:ChannelID,
						ItemID:ItemID,
						channeliD:changeId,
						weixinId:changeId,
						type:type
					},
					success:function(res){
						$("#showlist").prepend(res.showMessage);
					}
				})
			}else{//取消选中
				$("#"+changeId+m).remove();
			}
		}
		function fedit(){
			alert("请先进行保存");
		}
		function fcancel(){
			alert("请先进行保存");
		}
		function fdel(m,id){
			$("#"+id+m).remove();
			$("#cb_"+m+id).prop("checked",false);
		}
		//deleteFile1(id)-删除  deleteFile3(id)-撤稿
		function edit(id,channelid){
			var url = "../content/document.jsp?ItemID="+id+"&ChannelID="+channelid;
			window.open(url);
		}
		function delete1(id,channelid,ChildGlobalID){//删除
			var message = "确实要删除这1项吗？";
			if(confirm(message)){
				var url="../content/document_delete.jsp?check=1&ItemID=" + id + "&ChannelID="+channelid;
				$.ajax({
					type: "GET",
					url: url,
					dataType:"json",
					success: function(msg){
						if(msg.status==0)
						{
							var msg2 = "文章已被推荐，是否删除？";
							if(length>1) msg2 = "选中的文章有被推荐，是否删除？";
							
							if(confirm(msg2)){
								deleteFile_(id,channelid);
							}
						}
						else
						{  //删除成功 需要删除推荐关系
							delDultiple(id,channelid,ChildGlobalID);
						}
					}   
				});  
			}
		}
		
		function delDultiple(id,channelid,ChildGlobalID){
			var  url = "../content/document_dultiple_delete.jsp?ChildGlobalID="+ChildGlobalID; 
			$.ajax({
				type: "GET",
				url: url,
				dataType:"json",
				success: function(res){
					alert(res.message)
					document.location.href=document.location.href;
				}
			}); 
		}
		
		function deleteFile_(s,channelid)
		{
			var url="../content/document_delete.jsp?ItemID=" + s + "&ChannelID="+channelid;
			$.ajax({
				type: "GET",
				url: url,
				success: function(msg){document.location.href=document.location.href;}   
			});  
		}
		function delete3(id,channelid){//撤稿
			var message = "确实要撤稿这1项吗？";
			if(confirm(message)){
				var url="../content/document_delete2.jsp?check=1&ItemID=" + id + "&ChannelID="+channelid;
				$.ajax({
					type: "GET",
					url: url,
					dataType:"json",
					success: function(msg){
						if(msg.status==0)
						{
							var msg2 = "文章已被推荐，是否撤稿？";
							if(length>1) msg2 = "选中的文章有被推荐，是否撤稿？";
							
							if(confirm(msg2)){
								deleteFile2_(id,channelid);
							}
							
						}
						else
						{	
							alert("撤稿成功")
							document.location.href=document.location.href;
						}
					}
				}); 
			}
		}
		function deleteFile2_(s,channelid)
		{
			var url="../content/document_delete2.jsp?ItemID=" + s +"&ChannelID="+channelid;
			$.ajax({
				type: "GET",
				url: url,
				success: function(msg){document.location.href=document.location.href;}   
			}); 
		}
	</script>
<!--16ms-->
</body>
</html>
