<%@ page import="java.io.File,java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.util.HashMap,
				org.json.JSONObject,
				java.util.*"
%>
<%@ page contentType="text/html; charset=utf-8"  %>
<%@ include file="../config.jsp"%>
<%
    /**
      *
      *用途：图片在线编辑
      *1、王海龙 20150423 创建
      *
      */
     String img = getParameter(request,"img");
     int ChannelID = getIntParameter(request,"ChannelID");
     String fieldname = getParameter(request,"fieldname");
     int Watermark = -1;
     int IsCompress = -1;
     String Height = "";
     String Width = "";
     if(!"".equals(fieldname)){
          Field field = new Field(fieldname, ChannelID);
     	 JSONObject photo_other =new  JSONObject();
     	 if(field.getOther()!=null&&!"".equals(field.getOther())&&!"null".equals(field.getOther())){
     	     photo_other =new  JSONObject(field.getOther());
     	 }
     	 
     	 if(photo_other.has("Watermark")){
     		Watermark = photo_other.getInt("Watermark");
     		IsCompress = photo_other.getInt("IsCompress");
     		if(IsCompress==1){
     			Height = photo_other.getString("Height");
     			Width = photo_other.getString("Width");
     		}
     	 }
     }
    //System.out.println("Watermark=="+Watermark+"  IsCompress=="+IsCompress);
		//图片及图片库配置
	Channel channel = null;
	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();
	int sys_channelid_image = photo_config.getInt("channelid");
	channel = CmsCache.getChannel(sys_channelid_image);
	Site site = channel.getSite();//
	String Path = channel.getRealImageFolder();//图片库地址
	String SiteUrl = site.getExternalUrl();//图片库预览地址
	String SiteFolder = site.getSiteFolder();//图片库目录

	int index = img.lastIndexOf(".");
	String filetext = img.substring(index+1);
	String img_original = img.replace("."+filetext, "_original."+filetext);
	String img_original_path = img_original.replace(SiteUrl, SiteFolder);//原图路径
	System.out.println("img_original_path==="+img_original_path);
	File  img_original_file = new File(img_original_path);
	System.out.println("result==="+img_original_file.exists());
	if(img_original_file.exists()){
		img = img_original;
	}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8"/>
<title>图片编辑 - tidemedia center</title>
<!-- vendor css -->
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

<link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
   
<!-- Bracket CSS -->
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<link href="../style/photo/cropper_v1.5.6.css" rel="stylesheet">
<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>	
<script src="../common/2018/TideDialog2018.js"></script>
 <style>
 	label{ margin-bottom: 0; }
 	html,body{ width: 100%; height: 100%; position: relative; }
 	#cutimg-box{ width: 100%; height: 498px; display: flex; flex-direction: column; }
 	#cutimg-box-header{ height: 40px; flex: 0 0 40px; background: #e8ecef; justify-content: flex-start;padding-left: 20px;}
 	.pic_editor_area{ flex: 0 0 458px;  }
 	.img-container{ width: 100%; height: 458px; }
 	.sr-only{display:none;}
 	input.form-control{ padding: 0.3rem; }
 	.cutimg-box label{ margin-bottom: 0; }
 	.btn-group-item{ color: #868ba1; border: 1px solid #0866c6; padding:3px 10px; display: inline-block; border-radius: 5px; margin-right: 5px; }
 	.btn-group-item.ac{ color: #fff; background: #0866c6; }
 	.btn-group-item:hover{ color: #868ba1; }
 	.btn-group-item.ac:hover{ color: #fff; }
 	.select2-container--default .select2-selection--single{ height: 29px; }
 	.select2-container--default .select2-selection--single .select2-selection__rendered{ height: 29px; padding: 0 0px 0 6px; }
 	.select2-container--default .select2-selection--single .select2-selection__arrow{ height: 29px; line-height: 29px; }
 	.wd-180{ width: 180px; }
 	.previewBtn-cut{ line-height: 1.2; }
 </style> 
</head>
<body>
	<div class="bg-white modal-box" >
	    <div class="modal-body modal-body-btn pd-0 ">
			<div class="config-box ht-100p">
				<div id="cutimg-box">
			        <div class="d-flex align-items-center" id="cutimg-box-header">
			            <div class="d-flex align-items-center mg-r-10">
			                <label class=" mg-r-2">宽(px)</label>
			                <input type="text" class="form-control wd-60" size="5" name="dataWidth" id="dataWidth" value="">
			            </div>
			            <div class="d-flex align-items-center mg-r-10">
			                <label class="mg-r-2">高(px)</label>
			                <input type="text" class="form-control wd-60" size="5" name="dataHeight" id="dataHeight" value="">
			            </div>
			
			            <input type="hidden"  id="dataY" value="" />
			            <input type="hidden"  id="dataX" value="" />
			            
			            <% if(IsCompress!=1){%>
			            <div class="d-flex align-items-center">
			                <label class=" mg-r-2">比例：</label>
			                <div class="btn-group">
			                	<a class="btn-group-item pic_btn" data-method="setAspectRatio" data-option="1.7777777777777777" href="javascript:;">
			                		16:9
			                	</a>
			                	<a class="btn-group-item pic_btn" href="javascript:;" data-method="setAspectRatio" data-option="1.3333333333333333">
			                		4:3
			                	</a>
			                	<a class="btn-group-item pic_btn" href="javascript:;" data-method="setAspectRatio" data-option="NaN">
			                		自定义
			                	</a>
			                </div>
			            </div>
			            <%}%>
			            <div class="d-flex align-items-center mg-x-10">
				            <label class="ckbox mg-b-0-force mg-r-5">
								<input type="checkbox" name="Watermark" id="Watermark" value="1"><span class="pd-l-0-force" for="Watermark">水印</span>
							</label>
							<label class="mg-r-8">
								<select id="mask_location" class="form-control wd-80 ht-40 select2">
									<option value="rightbottom">右下方</option>
									<option value="righttop">右上方</option>
									<option value="middle">居中</option>
									<option value="leftbottom">左下方</option>
									<option value="lefttop">左上方</option>
								</select>
							</label>
							<label>
								<select id="mask_scheme" class="form-control wd-180 ht-40 select2">
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
						</div>
						<a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 previewBtn-cut" onclick="Previeww();">预览</a>
			        </div>
			    	<div class="pic_editor_area">
				        <div class="img-container">
				          <img src="<%=img%>" id="imgtide" alt="Picture">
				          <input type="hidden" id="image_src" value="<%=img%>">
				        </div>
					</div>
			    </div>
			</div>
	    </div>	  
		<div class="btn-box">
			<div class="modal-footer" >
				
			    <button name="Submit" type="button" class="btn btn-primary tx-size-xs" onclick="dothis();">确定</button>
				<button name="Submit2" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
			</div> 
		</div>	   
	</div>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

<script src="../lib/2018/select2/js/select2.min.js"></script>

<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script src="../common/2018/bracket.js"></script>

<!-- cropper JS -->
<script src="../common/cropper_v1.5.6.js"></script>
      
      <script>
		  function dothis(){
			  var fieldname = '<%=fieldname%>';
			  save();

			  var url = document.getElementById("image_src").value;
			  //2.拿到父框口对象
			  var w=window.parent;
			  //3.拿到父窗口中的文本框对象
			  w.document.getElementById(fieldname).value=url;
			  //4.将内容赋值给父窗口中的文本框对象的value属性

			  //top.TideDialogClose({suffix:'_1'});
			  top.TideDialogClose();
		  }
	  function Previeww() {
			var watermark = $('#mask_scheme option:selected').prop("id");
			var SiteUrl = '<%=SiteUrl%>';
            var SiteFolder = '<%=SiteFolder%>';
            window.open(watermark.replace(SiteFolder,SiteUrl));
		}
      //保存图片
    function save(){
        //判断是否处理
            var X = $('#dataX').val();
            var Y = $('#dataY').val();
            var H = $('#dataHeight').val();
            var W = $('#dataWidth').val();
            var water_mark = 0;
            if($('#Watermark').is(':checked')){
                 water_mark = $('#Watermark').val();
            }
            var mask_location = $('#mask_location').val();
			var mask_scheme = $('#mask_scheme').val();
            var cond="filepath=<%=img%>&width="+W+"&height="+H+"&X1="+X+"&Y1="+Y+"&water_mark="+water_mark+"&mask_location="+mask_location+"&mask_scheme="+mask_scheme+"&ChannelID="+<%=ChannelID%>;
            jQuery.ajax({
                type:"GET",
                data:cond,
                async:false,
                dataType:"jsonp",
                url:'cropimage.jsp',    
                success:function(data){
                    //var data=eval('(' + datas + ')');
                    if(data.success="true"){
                    	var	dialog = new top.TideDialog();
	    				dialog.showAlert( "图片裁剪完成！" );
                        //alert("图片裁剪完成");
                        window.close();
                        //alert(data.url);
                        try{
							$("#image_src").val(data.url);
                            //window.opener.updatephoto(data.url);//关闭子页面同时刷新父页面                                              
                        }catch(e){
                            
                        }
                     }else{
                        location.reload();
                    }
                }
            });
        
    }
       $(function () {
	        var IsCompress = <%=IsCompress%>;
	        var $image = document.querySelector('#imgtide');
	        $dataX = $('#dataX'),
	        $dataY = $('#dataY'),
	        $dataHeight = $('#dataHeight'),
	        $dataWidth = $('#dataWidth'),
	        $dataRotate = $('#dataRotate');
	        if(IsCompress==1){
	            $dataHeight.attr("disabled",true);
	            $dataWidth.attr("disabled",true);
	        }
	        var options = {
	          aspectRatio: <%if(IsCompress==1&&(!"".equals(Height))&&(!"".equals(Width))){
	              out.println(Width+"/"+Height+",");
	          }else{
					out.println("NaN,");
			  }
			  if(IsCompress==1){
	              out.println("cropBoxResizable:false,");
	          }%>
	          //dragMode:'none',
				  viewMode:1,
	          preview: '.img-preview',
	          crop: function (data) {
	                var data = cropper.getData();
	                //console.log(result);
	                $dataX.val(Math.round(data.x));
	                $dataY.val(Math.round(data.y));
	                $dataHeight.val(Math.round(data.height));
	                $dataWidth.val(Math.round(data.width));
	                $dataRotate.val(Math.round(data.rotate));
	          }
	        };
	        var cropper = new Cropper($image, options);
	        
	        $(".pic_btn").click(function(){
	            var ratio = $(this).data('option');
	            cropper.setAspectRatio(ratio);
	        });
	        $(".maxmin").click(function(){
	            var maxmin = $(this).data('option');
	            cropper.zoom(maxmin);
				
	        });
	        
	        $(".btn-group-item").click(function(){
	        	$(this).siblings().removeClass("ac").end().addClass("ac") ;
	        })
	        
        });
          
      </script>
</body>
</html>
