<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*,java.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public String getParentChannelPath(Channel channel) throws MessageException, SQLException{

    String path = "";
    ArrayList arraylist = channel.getParentTree();

    if ((arraylist != null) && (arraylist.size() > 0))
    {
      for (int i = 0; i < arraylist.size(); ++i)
      {
        Channel ch = (Channel)arraylist.get(i);
		path = path  + ch.getId()  + ((i < arraylist.size() - 1) ? "," : "");  
      }
    }

    arraylist = null;

    return path;
}
%>

<%

	int id = getIntParameter(request,"id");	
	int ChannelID = getIntParameter(request,"ChannelID");
	int RelationID = getIntParameter(request,"RelationID");	
	int Operation = getIntParameter(request,"Operation"); 
	int RelationchannelType = getIntParameter(request,"RelationchannelType");
	String Relationship = getParameter(request,"Relationship");
	int channid = 0;
	int channelType = 0;
	String ship ="";

	ChannelRecommend  cr = new ChannelRecommend();
	List<ChannelRecommend> crlist = cr.getChannelRecommendListByChannelId(ChannelID,Operation);
	List<Integer> rid =  new ArrayList<Integer>();
	for(ChannelRecommend crid : crlist){
		rid.add(crid.getRelationID());
	}
	int len = rid.size();
	String ParentChannelPath = "";
	if(len>0){
		Channel channel=CmsCache.getChannel(rid.get(0));
		ParentChannelPath=getParentChannelPath(channel);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="/cms2018/favicon.ico">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	html,body{height:100%;}
	.sidebar-menu li .treeview-menu.menu-open {display: block;}
	.br-subleft{position: static !important;height: 100%;border: 1px solid #e9ecef;width: 360px;border-top: none; }
	.right-box{flex: 1;}
	.btn-box{position: absolute;bottom: 0;width: 100%;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>


</head>
<body class="collapsed-menu email" >
	<div class="bg-white modal-box">
		<div class="modal-body modal-body-btn pd-0-force overflow-y-auto">
			<div class="d-flex ht-100p-force justify-content-between">
				<div class="br-subleft br-subleft-file" id="leftTd">
					<div class="sidebar-menu-box ht-100p-force overflow-auto">
						<ul class="sidebar-menu mg-t-0-force" hid>	  	  
						</ul>
					</div>
				</div><!-- br-subleft -->
				<div class="right-box">
					<div class=" mg-t-5 lh-30px mg-x-20 tx-black"><b>类型</b></div>
					<div class="row ckbox-row mg-x-20-force">                  		  	  	   		  	  		  
		              <label class="rdiobox mg-r-20 " >
			              <input name="rdio" type="radio" value="0" <%if(channelType == 0){%>checked<%}%> ><span>网站</span>
			          </label>
			          <label class="rdiobox mg-r-20 " >
			              <input name="rdio" type="radio" value="1" <%if(channelType == 1){%>checked<%}%> ><span>APP</span>
			          </label>
			          <label class="rdiobox mg-r-20 " style="display:none">
			              <input name="rdio" type="radio" value="2" <%if(channelType == 2){%>checked<%}%> ><span>两微</span>
			          </label>
			          <label class="rdiobox mg-r-20 " >
			              <input name="rdio" type="radio" value="3" <%if(channelType == 3){%>checked<%}%> ><span>三方媒体</span>
			          </label>
			          <label class="rdiobox mg-r-20 " >
			              <input name="rdio" type="radio" value="4" <%if(channelType == 4){%>checked<%}%> ><span>电视端</span>
			          </label>
			          <label class="rdiobox mg-r-20 " >
			              <input name="rdio" type="radio" value="5" <%if(channelType == 5){%>checked<%}%> ><span>其他</span>
			          </label>
			            
       		  	  	</div> 
       		  	  	<div class=" mg-t-5 lh-30px mg-l-20 tx-black"><b>对应关系</b></div>
       		  	  	<div class="mg-x-20">
       		  	  	<%if(id == 0){%>
                 		<textarea rows="6" class="form-control textBox" placeholder="" id="relationshipContent"></textarea>
               	 	<%}else{%>
                	    <textarea rows="6" class="form-control textBox" placeholder="" id="relationshipContent"><%=ship%></textarea>
               		<%}%> 
       		  	  		<label class="d-flex align-items-center tx-gray-800 tx-12">
							<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>对应关系如不填写则推荐系统默认字段。
						</label>
       		  	  	</div>
       		  	  		
				</div>
			</div>
	
		</div><!-- modal-body -->
	
		<div class="btn-box">
			<div class="modal-footer" >
				<button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton" onclick="next();">确认</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
			</div> 
		</div>	
	</div>

</body>
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<script src="../lib/2018/peity/jquery.peity.js"></script>
	<script src="../lib/2018/select2/js/select2.min.js"></script>
	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-channel.js"></script>

	<script>
	var  Operation = <%=Operation%>;
	var channid = <%=channid%>;
	var rid   = <%=rid%>;
	var dir = "";
        $(function(){
			$('.br-mailbox-list,.br-subleft').perfectScrollbar();	
			var url="tree2018.jsp";
			$.ajax({
				type:"get",
				dataType:"json",
				url:url,
				success:function(rjson){
					var menu = $('.sidebar-menu');
					var json = rjson;
					if(Operation == 1){
						var html = '<li class="treeview"><a href="#" load="0" channelId="0"><i class="fa fisrtNav fa-home" have="1"></i> <span>推荐</span></a><ul class="treeview-menu" style="display: block;">';
					}else{
						var html = '<li class="treeview"><a href="#" load="0" channelId="0"><i class="fa fisrtNav fa-home" have="1"></i> <span>引用</span></a><ul class="treeview-menu" style="display: block;">';
					}
					
			
					for(var i=0;i<json.length;i++){
			
						html += '<li><a href="#" load="'+json[i].load+'" channelId="'+json[i].id+'"  onclick="selectChannel('+json[i].id+')">'
						if(json[i].load==1||(json[i].child && json[i].child.length>0)){
							html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
						}else{
							html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
						} 
						if(rid.length>0){
							var  flag1 = false;//对比频道树给已添加的频道,设置选中
							for(var j=0 ; j< rid.length ;j++){
								if(rid[j] == json[i].id){
									html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'" checked="checked" ><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
									flag1 = true;
									break;
								}
							}
							if(!flag1){
								html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
							}
						}else{
							html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
						}

						if(json[i].child && json[i].child.length>0){
							html += '<ul class="treeview-menu" style="display: none;">' + get_menu_html(json[i]) + '</ul>';
						}
						html += '</li>';
					}
			
					html += '</ul></li>';
			
					menu.append(html);
			
					//多级导航自定义
					$.sidebarMenu(menu);
					backToOriginal();  //频道记忆
			   }
			})
		});
		

		function get_menu_html(json)
		{
			var html = "";
			if(json.child && json.child.length>0)
			{
				var json_ = json.child;
				for(var i=0;i<json_.length;i++){
					html += '<li><a href="#" load="'+json_[i].load+'" channelId="'+json_[i].id+'"  onclick="selectChannel('+json_[i].id+')">'
					if(json_[i].load==1||(json_[i].child && json_[i].child.length>0)){
						html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
					}else{
						html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
					} 
					if(rid.length>0){
						var  flag2 = false;//对比频道树给已添加的频道,设置选中
						for(var j=0 ; j< rid.length ;j++){
							if(rid[j] == json_[i].id){
								html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json_[i].id+'" checked="checked" ><span style="padding:0"></span></label><span>'+json_[i].name+'</span></a>';
								flag2 = true;
								break;
							}
						}
						if(!flag2){
							html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json_[i].id+'"><span style="padding:0"></span></label><span>'+json_[i].name+'</span></a>';
						}
					}else{
						html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json_[i].id+'"><span style="padding:0"></span></label><span>'+json_[i].name+'</span></a>';
					}
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
		
			var current = ids ? ids:_activeChannelid;
			if(current){
				var currentChannel  =  $(".sidebar-menu a[channelid='"+current+"']") ;
				$(".sidebar-menu li").removeClass("active");
				currentChannel.parent("li").addClass("active");

                selectChannel(current);
			}			
		}
		//返回二三四级导航
		function backToOuter(){
			channelStart ++ ;
			if(channelStart == channel_id_array.length-1){		    	
				backToOne(channel_id_array[channel_id_array.length-1]);
				return ;
			}
			backToInner(channel_id_array[channelStart]);
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
							html += '<a href="javascript:;" load="'+json[i].load+'" channelid="'+json[i].id+'" channeltype="'+json[i].type+'" onclick="selectChannel('+json[i].id+')">';
		
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
							if(rid.length>0){
								var  flag3 = false;//对比频道树给已添加的频道,设置选中
								for(var j=0 ; j< rid.length ;j++){
									if(rid[j] == json[i].id){
										html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'" checked="checked" ><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
										flag3 = true;
										break;
									}
								}
								if(!flag3){
									html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'" ><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
								}
							}else{
								html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'" ><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
							}
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
		function backToOriginal(){
            var channel_path = "<%=ParentChannelPath%>";
	        
			if(channel_path){
					channel_id_array = channel_path.split(",");							
			}else{
				activeFn();
				return ;
			}
			if(channel_id_array.length==1){  //站点
				var $this = $(".sidebar-menu a[channelid='"+channel_id_array[0]+"']") ;
				$(".sidebar-menu li").removeClass("active");
				$this.parent("li").addClass("active");
				changeFrameSrc( window.frames["content_frame"] , "../content/content2018.jsp?id=" + channel_id_array[0] )		
				//return ; 
			}else if(channel_id_array.length==2){    //站点下一级导航 
					var $this = $(".sidebar-menu a[channelid='"+channel_id_array[0]+"']") ;
					_activeChannelid = channel_id_array[1] ;
					var checkElement = $this.next() ;			   
				sidebarMenu_show_back(checkElement,$this,backToOne)
			}else if(channel_id_array.length>2){   //二三四级导航
				var $this = $(".sidebar-menu a[channelid='"+channel_id_array[0]+"']") ;
					var checkElement = $this.next() ;			    
				sidebarMenu_show_back(checkElement,$this,backToOuter);

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
				var $this = $(this);
				var checkElement = $this.next();

				var load = $this.attr("load");
				var channelid = $this.attr("channelid");
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
							html += '<a href="#" load="'+json[i].load+'" channelid="'+json[i].id+'" onclick="selectChannel('+json[i].id+')">';

							if(json[i].load==1||(json[i].child && json[i].child.length>0)){
								html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
							}else{
								html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
							}
							if(rid.length>0){
								var  flag4 = false;//对比频道树给已添加的频道,设置选中
								for(var j=0 ; j< rid.length ;j++){
									if(rid[j] == json[i].id){
										html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'" checked="checked" ><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
										flag4 = true;
										break;
									}
								}
								if(!flag4){
									html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
								}
							}else{
								html +='<label class="ckbox mg-b-0 mg-r-10"><input type="checkbox" name="id" value="'+json[i].id+'"><span style="padding:0"></span></label><span>'+json[i].name+'</span></a>';
							}
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
	<script>  

	var dir = "";
	var  ChannelID = <%=ChannelID%>;
	var Type = <%=Operation%>;//类型 1-推荐 2-引用
	var  id  = <%=id%>;//id!=0 编辑  id=0新增
	var channid = <%=channid%>;//(频道树)
	var rurl="",rdata;
	var RecommendArray = new Array();//选过的
	var selRecommendArray = new Array();//选中的
	var count = 0;
	var RelationID = <%=channid%>;//当前选中的频道id(多选) 
	var SRelationID = 0;//设置值专用
	var controller = false;//阻止事件冒泡
	$(function(){//onLoad="init();"
		if(id != 0){//编辑
			var myObject = new Object();
			myObject.RelationchannelType = <%=channelType%>;
			myObject.Relationship ="<%=ship%>";
			myObject.RelationID = <%=channid%>;
			RecommendArray[count] = myObject;
			count++;
		}
	})
	
	function next()
	{    
		var sucflg  = false;//是否放行 添加编辑
		var channelid = "";
		var type = $("input[name='rdio']:checked").val();
		var Relationship = $('#relationshipContent').val();
		jQuery("#leftTd input:checked").each(function(i){
			if(i==0)
				channelid+=jQuery(this).val();
			else
				channelid+=","+jQuery(this).val();
		});
	   if(channelid === ""){
	    	alert("请选择至少一个频道,进行配置");
	    	return;
	    }
	    var arr = [];
	    arr = channelid.split(",");
	    for(var y = 0; y< arr.length; y++){
	    	console.log(arr[y])
	    	for(var i= 0 ; i<RecommendArray.length; i++){
	    		var rid = RecommendArray[i].RelationID;
	    		if(arr[y] == rid){//
	    			var param = rid+","+RecommendArray[i].Relationship+","+RecommendArray[i].RelationchannelType;
	    			selRecommendArray.push(param);
	    		}
	    	}
	    }
	    
    	$.ajax({
    		type:"post",
	    	data:{
	    		id:id,
	    		ChannelID:ChannelID,
	    		Operation:Type,
	    		selRecommendArray : selRecommendArray
	    		},
	    	dataType:"json",
	    	url:"channel_updatecommend.jsp",
	    	success:function(res){
	    		if(res.status == "error"){//失败
	    			alert(res.message);
	    			return;
	    		}else{   //
	    			top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});
	    			alert(res.message);
	    			return;
	    		}
	    	}
    	})
	}
	
	
	
	function selectChannel(RelationID){//选中  or 取消
		console.log("点击了checkbox  id为"+RelationID)
		if(controller){
			return;
		}
		controller = true;
		SRelationID  = RelationID;
		var Relationship = "";
		var RelationchannelType = 0;
		var flag = false;//判断添加当前频道是否已存入相应的值
		console.log("RecommendArray len==="+RecommendArray.length) 
		for(var i= 0 ; i<RecommendArray.length; i++){
			var rid = RecommendArray[i].RelationID;
			console.log("rid==="+rid)
			if(RelationID == rid){//已存在
				flag = true;
			    console.log("sel已存在数据打印Relationship===="+RecommendArray[i].Relationship)
			     console.log("sel已存在数据打印RelationchannelType===="+RecommendArray[i].RelationchannelType)
				Relationship = RecommendArray[i].Relationship;
				RelationchannelType = RecommendArray[i].RelationchannelType;
				break;
			}
		}
		/*if(id != 0){//编辑,需要查询数据*/
		//console.log("edit")
		if(flag){//已存在 ,显示在html
			 $("input[name='rdio'][value='"+RelationchannelType+"']").prop("checked",true); 
			 $("#relationshipContent").val(Relationship);
			 controller = false;
		}else{//不存在,查询数据库,并显示
			$.ajax({
				type:"GET",
				url:"channel_selectrecommend.jsp",
				dataType:"json",
				data:{
					ChannelID:ChannelID,
					RelationID:RelationID,
					Type:Type 
				},
				success:function(res){
					//alert(res.Relationship)
					//alert(res.RelationchannelType)
					setValue(res.RelationchannelType,res.Relationship,RelationID);
					controller = false;
				}
			})
		}
		/*}else{//新增不需要查询数据
			console.log("add")
			if(flag){//将该条数据的值显示在对应的html
				console.log("add  存在")
				 $("input[name='rdio'][value='"+RelationchannelType+"']").prop("checked",true); 
				 $("#relationshipContent").val(Relationship);
				 console.log("add 存在RelationchannelType==="+RelationchannelType);
				 console.log("add 存在Relationship==="+Relationship);
			}else{//不存在,显示默认值
				console.log("add  bu存在")
				setValue(0,"",RelationID);
			}
		}*/
	}
	
	function setValue(RelationchannelType,Relationship,RelationID){//将数据加入RecommendArray
		 $("input[name='rdio'][value='"+RelationchannelType+"']").prop("checked",true); //设置值
		 $("#relationshipContent").val(Relationship);
		 //console.log("input[name='rdio'][value='"+RelationchannelType+"']");
		 //console.log("RelationchannelType==="+RelationchannelType);
		 //console.log("Relationship==="+Relationship);
		 //console.log("RelationID==="+RelationID);
		var myObject = new Object();
		myObject.RelationchannelType = RelationchannelType;
		myObject.Relationship = Relationship;
		myObject.RelationID = RelationID;
		RecommendArray[count] = myObject;
		count++;
	}
	
	//radio 监听
	$("input:radio[name='rdio']").change(function (){//将RelationchannelType值存入对应的对象中
		console.log("监听-radio-RelationID==="+SRelationID)
		console.log("监听radio")
		var RelationchannelType = $(this).val();
			console.log("RelationID==="+SRelationID)
	        console.log("RelationchannelType="+RelationchannelType);
			console.log("RecommendArray len="+RecommendArray.length);
	        //alert($("input:radio[name='ssx']:checked").val())
	        for(var i= 0 ; i<RecommendArray.length; i++){
				var rid = RecommendArray[i].RelationID;
				if(SRelationID == rid){
					console.log("radio 存在 设置值")
					 RecommendArray[i].RelationchannelType = RelationchannelType;
					 return;
				}
			}
	});
	//textarea监听
	$('textarea').bind('input propertychange', function(){ //将Relationship值存入对应的对象中
		console.log("监听-textarea-RelationID==="+SRelationID)
		console.log("监听textarea")
		var Relationship = $("#relationshipContent").val();
		console.log("Relationship="+Relationship)
		for(var i= 0 ; i<RecommendArray.length; i++){
			var rid = RecommendArray[i].RelationID;
			if(SRelationID == rid){
				console.log("textarea 存在 设置值")
				 RecommendArray[i].Relationship = Relationship;
				 return;
			}
		}
	}); 
	</script>
</html>
