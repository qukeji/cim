<%@ page contentType="text/html; charset=utf-8"  import="tidemedia.cms.util.FileUtil"%>
<%@page import="tidemedia.cms.util.TideJson"%>
<%@page import="tidemedia.cms.system.*"%>
<%@ include file="../config.jsp"%>
<%
	/**
	  *
	  *用途：图片在线编辑
	  *1、王海龙 20150423 创建
	  *
	  */
	 String img = getParameter(request,"img");
	 
 	 TideJson tj = CmsCache.getParameter("sys_config_photo").getJson();
 	 int channelid = tj.getInt("channelid");
	 Channel channel = CmsCache.getChannel(channelid);
	 Site site = channel.getSite();
	 String folder = site.getSiteFolder();
	 String inner_url = site.getUrl();
	 String outer_url = site.getExternalUrl(); 
	 if(img.startsWith(inner_url) || img.startsWith(outer_url))
	 	img = img.replace(inner_url,folder).replace(outer_url,folder);
	
	//String newImg = folder+"/crop_"+img.substring(img.lastIndexOf("/")+1);
	int index = img.lastIndexOf("/");
	String newImg = img.substring(0,index)+"/crop_"+img.substring(img.lastIndexOf("/")+1);
	int size[] = FileUtil.getSizeByIm4java(newImg);
	FileUtil.compressImage2IM(img,newImg,500,400,1);
	newImg =  newImg.replace(folder,inner_url);

	 
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8"/>
<title>图片编辑 - tidemedia center</title>
<link href="../style/tidemedia_center.css" rel="stylesheet"/>
<link href="../style/imgareaselect-default.css" rel="stylesheet"/>
<style>
.pic_editor_area{top:40px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/imgareaselect.js"></script>
<script src="../editor/dialog/common/fck_dialog_common.js" type="text/javascript"></script>
<script type="text/javascript">
	var newImg = "";
        //var oEditor		= dialog.InnerDialogLoaded() 
      // console.log(dialog.document.URL);
	//var oImage = dialog.Selection.GetSelectedElement() ;
	//if ( oImage && oImage.tagName != 'IMG' && !( oImage.tagName == 'INPUT' && oImage.type == 'image' ) )
	//	oImage = null ;
	function preview(img, selection)
    {
		if (!selection.width || !selection.height)
			return;
		/*$('#x1').val(selection.x1);
		$('#y1').val(selection.y1);
		$('#x2').val(selection.x2);
		$('#y2').val(selection.y2);*/
		$('#width').val(selection.width);
		$('#height').val(selection.height);  
		window.selection=selection;
	}
	
	//保存图片
	function save(){
		//判断是否处理
		if(typeof(selection) != 'undefined'){
			var cond="channelid=<%=channelid%>&filepath=<%=newImg%>&width="+selection.width+"&height="+selection.height+"&X1="+selection.x1+"&Y1="+selection.y1;
			jQuery.ajax({
				type:"POST",
				data:cond,
				url:'cropimage.jsp', 
				async:false,   
				success:function(data){
					if(data.success="true"){
						//alert("图片裁剪完成");
						//window.close();
                        //window.opener.location.reload();//关闭子页面同时刷新父页面
                        //裁剪完成，1关闭窗口2保存content内容3刷新content
                        //关闭窗口
                       // parent.getDialog().Close({suffix:"_1"});
                        //content保存   
                         newImg = data.img;                                          
                     }else{
						 alert("裁剪失败！");
					}
				}
			});
		}
	}
	
	//图片显示位置
 	function position()
 	{
 		var img = new Image();
		img.src =$('.pic_e_a_img img').attr("src") ;
		var w = img.width;
		var h = img.height;
		$(".pic_e_a_img ").attr("style","margin:-"+(h/2)+"px 0 0 -"+(w/2)+"px;");
 	}
	
	$(document).ready(function () {
		 
		//position();
		
		//$(".pic_e_a_img ").attr("style","margin:-"+(<%=size[0]%>/2)+"px 0 0 -"+(<%=size[1]%>/2)+"px;");
		$(".pic_e_a_img ").attr("style","margin:-150px 0 0 -300px;");
		$('.pic_e_a_img img').imgAreaSelect({
			x1: 0, 
			y1: 0, 
			x2: 100, 
			y2: 80,
			handles: true,
			onSelectEnd: preview//拖动结束是触发preview函数
		});
	});
	
	
</script>
</head>

<body>
 
<div class="pic_editor_tool">
    <div class="pic_e_t_value">
        <div class="pic_e_t_cut">
            <span class="pic_e_t_c_txt">裁剪工具</span>
            <div class="pic_e_t_c_box"><div class="pic_e_t_c_b1"><div class="pic_e_t_c_b2"><label class="pic_e_t_c_b_txt">宽(px)</label><input type="text"  class="pic_e_t_c_b_input" id="width" value="" /></div></div></div>
            <div class="pic_e_t_c_box"><div class="pic_e_t_c_b1"><div class="pic_e_t_c_b2"><label class="pic_e_t_c_b_txt">高(px)</label><input type="text"  class="pic_e_t_c_b_input" id="height" value="" /></div></div></div>
        </div>
    </div>
    <div class="pic_e_t_btn">
        <div class="pic_e_t_btn1"></div>
        <div class="pic_e_t_btn1"></div>
    </div>
</div>
<div class="pic_editor_area">
    <div class="pic_e_a_img"><img src="<%=newImg %>"></div>
    <!-- pic_e_a_img的magin值算法:-140px(图片高度/2) 0 0 -260px(图片宽度/2);  两个值都是负值 -->
</div>
</body>
 
</html>
