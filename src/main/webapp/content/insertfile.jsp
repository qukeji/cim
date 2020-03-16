<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,org.json.*,java.util.*,java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String Type			= getParameter(request,"Type");
String fieldname	= getParameter(request,"fieldname");
int ChannelID		= getIntParameter(request,"ChannelID");
int photoType		= getIntParameter(request,"photoType");
int chooseIndex = getIntParameter(request,"chooseIndex");
String CompressWidth = "";
String CompressHeight = "";
String UseCompressCheck = "";
String PhotoScheme = "<option value='0'>尺寸方案</option>";
int IsCompress = 0;
int Watermark = 0;
String file_types = "*.*";
String file_types_description = "所有文件";
if(Type.equalsIgnoreCase("Image"))
{
	file_types = "*.gif;*.jpg;*.png;*.jpeg";
	file_types_description = "图片文件";

	Field field = new Field(fieldname,ChannelID);
	System.out.println("field:"+field.getName()+","+fieldname+","+ChannelID);
	String Other = field.getOther();
	if(Other!=null && Other.length()>0)
	{
		TideJson json = Util.getMyJson(Other);
		IsCompress = json.getInt("IsCompress");
		Watermark = json.getInt("Watermark");
		CompressWidth = json.getString("Width");
		CompressHeight = json.getString("Height");

		if(CompressWidth.length()>0 || CompressHeight.length()>0)
			UseCompressCheck = "checked";
	}

	TableUtil tu = new TableUtil();
	String sql = "select * from photo_scheme";
	ResultSet rs = tu.executeQuery(sql);
	while(rs.next())
	{
		String name = tu.convertNull(rs.getString("Name"));
		PhotoScheme += "<option value='' width='"+rs.getInt("Width")+"' height='"+rs.getInt("Height")+"'>"+name+"</option>";
	}
	tu.closeRs(rs);

}
String sys_config_photo = CmsCache.getParameterValue("sys_config_photo");

JSONObject jo = new JSONObject(sys_config_photo);
int photo_channelid = jo.getInt("channelid");

//图片及图片库配置
Channel channel = null;
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();
int sys_channelid_image = photo_config.getInt("channelid");
channel = CmsCache.getChannel(sys_channelid_image);
Site site = channel.getSite();//
String Path = channel.getRealImageFolder();//图片库地址
String SiteUrl = site.getExternalUrl();//图片库预览地址
String SiteFolder = site.getSiteFolder();//图片库目录

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">
 <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
 <link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
 <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
 <!-- Bracket CSS -->
<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>	
<style>
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
html,body{width: 100%;height: 100%;}
.modal-body .config-box .row{margin-bottom:20px;height: 40px;margin-left:0;}
.modal-body-btn .config-box .row .left-fn-title{min-width:80px;text-align: left;}
.modal-body .config-box label.ckbox{width:80px;cursor:pointer;margin-right:10px;}
.table thead th{vertical-align: middle;}
.table th{padding: 0.3rem 0.75rem ;}
.table td{padding: 0.4rem 0.75rem ;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/webuploader.js"></script>

<script>
var fileType = "<%=Type%>";
$(function() {
	var Watermark = '<%=Watermark%>';
	$("#PhotoScheme").change(function(){
	   if($("#PhotoScheme").val()!="0")
		{
			$("#CompressWidth").val($("#PhotoScheme").find("option:selected").attr("width"));
			$("#CompressHeight").val($("#PhotoScheme").find("option:selected").attr("height"));
		}
		else
		{
			$("#CompressWidth").val(0);
			$("#CompressHeight").val(0);
		}
	});
	if(Watermark=="1"){
		$("#f_1").show();
		$("#f_2").show();
		$("#f_3").show();
	}
});
function checkIsWatermark(){
    if($("#Watermark").prop("checked")){
		$("#f_1").show();
		$("#f_2").show();
		$("#f_3").show();
	}else{
		$("#f_1").hide();
		$("#f_2").hide();
		$("#f_3").hide();
	}
}
function checkPhotoResource(){
	if(fileType.toLowerCase()!="image"){
		return true;
	}
	//是否为图片库选择图片
	if($("#form_nav li a").eq(1).attr("class").indexOf("active")!=-1){
		var obj=window.frames["photo"].getCheckbox();
		var gids=obj.id;
		var gids_=gids.split(",");
		 if(gids_.length==0){
			alert("请先选择图片");
			return;
		}else if(gids_.length>1){
			alert("只能选择一张图片");
			return;
		}
		 $("#picid").val(gids);
		 $("#source").val("1");
		 var compress = 0;
		if($('#IsCompress').is(':checked')){
			compress = $('#IsCompress').val();
		}
		var formObject = {};
        var formArray =$("#form1").serializeArray();
        $.each(formArray,function(i,item){
            formObject[item.name] = item.value;
        });
		$.ajax({
			type:"POST", 
			url:"../content/insertfile_from_photosource2019.jsp",
			data:formObject,
			async:false,
			dataType:"json",
			success:function(data){
				if(data.filename!=""){
					parent.getDialog().Close({close:function(){parent.$("#<%=fieldname%>").val(data.filename)}});
				}else{
					alert("插入失败！");
				}
			},
			error:function(msg)
			{
			   alert("选择失败");
			}
		});
	}
	//是否为回传图片库选择图片
	if($("#form_nav li a").eq(2).attr("class").indexOf("active")!=-1){

		var obj=window.frames["backphoto"].getCheckbox();
		var gids=obj.id;
		var gids_=gids.split(",");
		 if(gids_.length==0){
			alert("请先选择图片");
			return;
		}else if(gids_.length>1){
			alert("只能选择一张图片");
			return;
		}
		 $("#picid").val(gids);
		 $("#source").val("1");
		 var compress = 0;
		if($('#IsCompress').is(':checked')){
			compress = $('#IsCompress').val();
		}
		var formObject = {};
	    var formArray =$("#form1").serializeArray();
	    $.each(formArray,function(i,item){
	        formObject[item.name] = item.value;
	    });
		$.ajax({
			type:"POST", 
			url:"../content/insertfile_from_photosource2019.jsp",
			data:formObject,
			async:false,
			dataType:"json",
			success:function(data){
				if(data.filename!=""){

			        //3.拿到父窗口中的文本框对象

						parent.getDialog().Close({close:function(){parent.$("#<%=fieldname%>").val(data.filename)}});

				}else{
					alert("插入失败！");
				}
			},
			error:function(msg)
			{
			   alert("选择失败");
			}
		});
	}
	return true;
}
</script>

</head>
<body class="" >

    <div class="bg-white modal-box">
	<%if(Type.equalsIgnoreCase("Image")){%>
      <div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
        <ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
          	<li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">本地图片</a></li>
			  <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">文稿图片库</a></li>
			  <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">回传图片库</a></li>
        </ul>
      </div>
	<%}%>
      <form name="form" id="form1" action="insertfile_submit.jsp" enctype="multipart/form-data" method="post" >
		    <div class="modal-body pd-20 overflow-y-auto">
		        <div class="config-box">
		       	  <ul>
		       	  	<!--本地图片-->
		       		  <li>
		       		  	 	<div class="config-box">
								<%if(Type.equalsIgnoreCase("Flash") || Type.equals("Video")){%>
									<div class="row"> 
										<label class="left-fn-title">尺寸：</label>
										
										<label class="ckbox mg-b-0-force mg-l-20">
											宽度<input name="Width" type="text" class="textfield" id="Width">
											高度<input name="Height" type="text" class="textfield" id="Height">
										</label>
									</div>
								<%}%>
								<%if(Type.equalsIgnoreCase("Image")){%>
									<div class="row">
										<div class="btn-group hidden-xs-down file_upload_choose" id="uploader">         
											<label id="picker">图片上传</label>                             			                  		              	                  
										</div>
										<label class="mg-r-20"></label>
										<label class="ckbox mg-b-0-force">
											<input type="checkbox" name="Watermark" id="Watermark" value="Yes" <%=Watermark==1?"checked":""%>  onclick="checkIsWatermark();"><span for="Watermark">水印</span>
										</label>
										
										
										<label id="f_2" style="display:none">
											<select id="mask_location" name = "mask_location" class="form-control wd-82 ht-40 select2">
												<option value="rightbottom">右下方</option>
												<option value="righttop">右上方</option>
												<option value="middle">居中</option>
												<option value="leftbottom">左下方</option>
												<option value="lefttop">左上方</option>
											</select>
										</label>
										<label class="mg-r-40"></label>
										<label id="f_1" style="display:none">
											<select id="mask_scheme" name = "mask_scheme" class="form-control wd-82 ht-40 select2">
												<%
													List<Watermark> watermarks= new  Watermark().listAllWaterMark(userinfo_session.getCompany());
													for(int i=0;i<watermarks.size();i++)
													{
														Watermark watermark = watermarks.get(i);
														int  waterid = watermark.getId();
														%>
												<option value="<%=waterid%>" id="<%=watermark.getWaterMark()%>"><%=watermark.getName()%></option>
												<%} %>
											</select>
										</label>
										<label id="f_3" style="display:none">
											<input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="预览" onclick="preview_watermark();">
											</label>
									</div>
									
									<div class="row" id="compress">
									    	
										    <label class="ckbox mg-b-0-force">
											<input type="checkbox" name="IsCompress" id="IsCompress" value="1" <%=IsCompress==1?"checked":""%> ><span for="IsCompress">压缩尺寸</span>
										</label>
										<label class="mg-r-20">
                            				<select name="PhotoScheme" id="PhotoScheme" class="form-control wd-82 ht-40 select2">
                            					<%=PhotoScheme%>
                            				</select>
                            			</label>
										<label>宽度：</label>
										<label class="mg-r-10"><input type="text" value="<%=CompressWidth%>" name="CompressWidth" size=5 id="CompressWidth" class="form-control"></label>
										<label>高度：</label>
										<label><input type="text" value="<%=CompressHeight%>" name="CompressHeight" id="CompressHeight" size=5 class="form-control"></label>
										
										<label><input type="hidden" value="<%=photoType%>" name="photoType" id="photoType"></label>
										<label><input type="hidden" value="" name="picid" id="picid"></label>
									</div>
									
								<%}else if(Type.equalsIgnoreCase("file")||Type.equals("video")||Type.equals("gif")){%>
									<div class="row">
										<div class="btn-group hidden-xs-down file_upload_choose" id="uploader">         
											<label id="picker">文件上传</label>                             			                  		              	                  
										</div>
									</div>
								<%}%>
									<div class="bd rounded table-responsive">
										<table class="table table-bordered mg-b-0">
											<thead>
												<tr>
													<th class="wd-220">名称</th>
													<th class="text-center">进度</th>
													<th class="wd-100-force">大小</th>
													<th class="wd-50 text-center"><a class="tx-18" href="javascript:;"><i class="fa fa-angle-double-right" aria-hidden="true"></i></a></th>
												</tr>
											</thead>
											<tbody id="thelist">
											</tbody>
										</table>
									</div>
								</div> 
	       		  </li>
		  <%if(Type.equalsIgnoreCase("Image")){%>
       	      <!--图片库-->
       	      <li>
       	       	<div id="divSelectPhoto" >
				<table cellpadding="0" cellspacing="0" width="100%" height="100%">
					<tr>
						<td width="100%">
					<table cellpadding="1" cellspacing="1" align="center" border="0" width="100%" height="100%">
						<tbody >
							<tr><td><iframe  marginheight="0" frameborder="no"  id="photo" name="photo" marginwidth="0" scrolling="auto" height="400" width="100%" src=""></iframe></td><td></td></tr>
						</tbody>
				</table>
						</td>
					</tr>
				</table>
				</div>
	       	</li>
	      
	           <!--回传图片-->
       	      <li>
	       	      <div id="divSelectBackPhoto" >
					<table cellpadding="0" cellspacing="0" width="100%" height="100%">
						<tr>
						<td width="100%">
								<table cellpadding="1" cellspacing="1" align="center" border="0" width="100%" height="100%">
								<tbody >
							<tr><td><iframe  marginheight="0" frameborder="no"  id="backphoto" name="backphoto" marginwidth="0" scrolling="auto" height="400" width="100%" src=""></iframe></td><td></td></tr>
								</tbody>
					</table>
						</td>
					</tr>
				</table>
				</div>
	       	</li>
		  <%}%>
	       	  </ul>
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box" >
      	<div class="modal-footer" >
		     <button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="startButton" onclick="return checkPhotoResource();">确认</button>
		     <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消 
                      </button>
       </div> 
      </div>
    </form>
   </div>
   
    <script>
    	
     function lockUnlock(_this){
      	var textBox = $(_this).parent(".row").find(".textBox") ;       	
       	if($(_this).find("i").hasClass("fa-lock")){      	 
       	 	$(_this).find("i").removeClass("fa-lock").addClass("fa-unlock");       	 	
       	 	textBox.removeAttr("disabled","").removeClass("disabled")
       	}else{      	 	
       	 	$(_this).find("i").removeClass("fa-unlock").addClass("fa-lock");
       	 	textBox.attr("disabled",true).addClass("disabled")
       	}
      }
     
         /*function setReturnValue(o){
    	var ChannelID = $("#ChannelID").val();
    	
   		if(o.refresh){
   			var s = "channel_edit2018.jsp?ChannelID="+ChannelID+"&chooseIndex=2";
   			//if(o.field) s += "&show_fieldid="+o.field;
   			document.location.href=s;
   		}
   	}*/

	var  chooseIndex = <%=chooseIndex%>;
	var imcompress = <%=IsCompress%>;
      $(function(){
		if(imcompress==1){
			$("#compress").hide();
		}

	   	 if(chooseIndex != 2){
	   		$(".config-box ul li").removeClass("block").eq(0).addClass("block");
	   		$("#form_nav li a").removeClass("active").eq(0).addClass("active");
	   		$("#form_nav li").click(function(){
	      		var _index = $(this).index();
	      		if(_index==1){
	      				$('#photo').attr("src","../photo/editor_photo_select2019.jsp?flag=1&id=<%=photo_channelid%>");
	      		}if(_index==2){
	      			  $('#backphoto').attr("src","../photo/editor_photo_select2019.jsp?flag=2&id=<%=photo_channelid%>");
		      	}
	      		console.log(_index)
	      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
	      		$("#form_nav li a").removeClass("active").eq(_index).addClass("active");
	      	})
	   	 }else{//刷新推荐设置
	   		$(".config-box ul li").removeClass("block").eq(2).addClass("block");
      		$("#form_nav li a").removeClass("active").eq(2).addClass("active");
      		$("#form_nav li").click(function(){
	      		var _index = $(this).index();
	      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
	      		$("#form_nav li a").removeClass("active").eq(_index).addClass("active");
	      	})
	   	 }

       /* $('.toggle').toggles({        
          height: 25,
          width:60
        });*/
      });
    </script>
<script type="text/javascript">
	//h5上传
	var isImage = <%=Type.equalsIgnoreCase("Image")%>;
	var video = <%=Type.equals("video")%>;
	var gif = <%=Type.equals("gif")%>;

	function preview_watermark() {
		var watermark = $('#mask_scheme option:selected').prop("id");
		var SiteUrl = '<%=SiteUrl%>';
        var SiteFolder = '<%=SiteFolder%>';
        window.open(watermark.replace(SiteFolder,SiteUrl));
	}
	var acceptType = {};
	if(isImage){
	   acceptType = {title: 'Images',extensions: 'gif,jpg,jpeg,png',mimeTypes: 'image/gif,image/jpg,image/jpeg,image/png'};
	}
	if(video){
		acceptType = {title: 'Video',extensions: 'mp4',mimeTypes: 'video/*'};
	}
	if(gif){
		acceptType = {title: 'Images',extensions: 'gif',mimeTypes: 'image/gif'};
	}

	var returnData = "";//接口返回
	// 图片上传
	jQuery(function() {
		var $ = jQuery,
			$list = $('#thelist'),//上传文件列表
			$btn = $('#startButton'),//开始上传
			state = 'pending',
			uploader;
		//初始化
		uploader = WebUploader.create({

			accept: acceptType ,// 只允许选择图片文件。
			
			swf: '../common/Uploader.swf',// swf文件路径
			
			server: '../content/insertfile_submit.jsp',// 文件接收服务端。

			pick: '#picker',// 选择文件的按钮。可选。
			
			fileNumLimit: 1,//文件数量

			compress: false,//不启用压缩

			resize: false//尺寸不改变

		});
		// 当有文件添加进来的时候
		uploader.on( 'fileQueued', function( file ) {
			$list.append( '<tr id="' + file.id + '">' +
				'<td>' + file.name + '<\/td>' +
				'<td id= "'+file.id+"_schedule"+'"><\/td>' +
				'<td>' + Math.floor((file.size)/1024) + 'KB<\/td>' +
				'<td id="'+file.id+"_del"+'" class="tx-center"><\/td>' +
			'<\/tr>' );

			var $btns = $("#"+file.id+"_del").html('<a class="file_del">' +
				'<i class="fa fa-times tx-danger tx-18" aria-hidden="true"></i></a>');
			//删除文件		
			$btns.on( 'click', function() {
				uploader.removeFile( file,true );
				$("#"+file.id+"").remove();
			});
		});
		//创建上传事件
		$btn.on( 'click', function() {
			if (state === 'uploading' ) {
				uploader.stop();
			} else {
				var option;
				var ReWrite;
				var browser;

				if(jQuery.support){
					browser="msie";
					option={"browser":browser,"ChannelID":"<%=ChannelID%>","Type":"<%=Type%>","fieldname":"<%=fieldname%>"};
				}else{
					browser="mozilla";
					option={"browser":browser,"ChannelID":"<%=ChannelID%>","Type":"<%=Type%>","fieldname":"<%=fieldname%>","Username":"<%=userinfo_session.getUsername()%>","Password":"<%=userinfo_session.getMd5Password()%>"};
				}
				<%if(Type.equalsIgnoreCase("Flash") || Type.equalsIgnoreCase("Video")){%>
					var Width=jQuery("#Width").val();
					var Height=jQuery("#Height").val();
					jQuery.extend(option,{"Width":Width,"Height":Height});  
				<%}else if(Type.equalsIgnoreCase("Image")){%>
					var Watermark="";
					var IsCompress = "";
//					var UseCompress = "";
					var mask_location="";
					var scheme = "";
					var mask_scheme = "";
					if(jQuery("#Watermark").is(':checked'))
					{
						Watermark="Yes";
						mask_location = $("#mask_location").val();
						mask_scheme = jQuery("#mask_scheme option:selected").val();
					}
					if(jQuery("#IsCompress").is(':checked')){
						IsCompress="1";
					}
					
						
					
//					if(jQuery("#UseCompress").is(':checked')){
//						UseCompress="1";
//					}
					jQuery.extend(option,{"mask_scheme":mask_scheme,"Watermark":Watermark,"IsCompress":IsCompress,"CompressHeight":$("#CompressHeight").val(),"CompressWidth":$("#CompressWidth").val(),"mask_location":mask_location,"photoType":$("#photoType").val()});//"UseCompress":UseCompress,
				<%}%>
				uploader.options.formData= option;
				uploader.upload();		
			}
		});
		 // 文件上传过程中创建进度条实时显示。
		uploader.on( 'uploadProgress', function( file, percentage ) {

			var $li = $( '#'+file.id+"_schedule" ),
				$percent = $li.find('.progress .progress-bar');

			// 避免重复创建
			if (!$percent.length) {
				$percent = $('<div class="progress progress-striped active upload_jdt">' +
								'<div class="progress-bar upload_jdt_box" role="progressbar" style="width: 0%">' +
								'</div>' +
							'</div>').appendTo( $li ).find('.progress-bar');
			}
			$li.find('p.state').text('上传中');

			$percent.css( 'width', percentage * 100 + '%' );
			$percent.html(parseInt(percentage * 100)+'%');
			
		});
		//上传成功
		uploader.on( 'uploadSuccess', function( file , response) {
			$( '#'+file.id ).find('p.state').text('已上传');
			eval(response._raw);
		});
		//上传出错
		uploader.on( 'uploadError', function( file ) {
			$( '#'+file.id ).find('p.state').text('上传出错');
		});
		//上传结束
		uploader.on( 'uploadFinished', function() {
			state = 'done';
		});
	});
</script>
	</body>
</html>
