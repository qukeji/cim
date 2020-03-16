<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="renderer" content="webkit">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
	<meta name="author" content="ThemePixels">

	<title></title>
	<!-- vendor css -->
	<link href="${request.contextPath}/lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="${request.contextPath}/lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="${request.contextPath}/lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
	<link href="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

	<link href="${request.contextPath}/lib/2018/highlightjs/github.css" rel="stylesheet">
	<link href="${request.contextPath}/lib/2018/select2/css/select2.min.css" rel="stylesheet">

	<!-- Bracket CSS -->
	<link rel="stylesheet" href="${request.contextPath}/style/2018/bracket.css">
	<link rel="stylesheet" href="${request.contextPath}/style/2018/common.css">
	<style>
		html,body { width: 100%; height: 100%; }
		.mg-t--10 { margin-top: -10px; }
		#deleteItem{display: none;}
	</style>
</head>
<body class="">
	<div class="bg-white modal-box">
		<div class="modal-body pd-20 overflow-y-auto" style="top:0;">
			<div class="config-box">
				<ul>
					<!--列表项目名称-->
					<li class="block">
						<div class="row">
							<label class="left-fn-title">列表项目名称：</label>
							<label class="wd-500">
								<input class="form-control" placeholder="" type="text" id="itemname" >
							</label>
						</div>
						<!--显示宽度-->
						<div class="row">
							<label class="left-fn-title">显示宽度：</label>
							<select id="itemWidth" class="form-control wd-120 ht-40 select2" data-placeholder="0">
								<option value="0">不设置宽度</option>
								<option value="40" >40</option>
								<option value="50">50</option>
								<option value="60">60</option>
								<option value="70">70</option>
								<option value="80">80</option>
								<option value="100">100</option>
								<option value="120">120</option>
								<option value="150">150</option>
								<option value="180">180</option>
								<option value="200">200</option>
								<option value="250">250</option>
								<option value="300">300</option>
							</select>
							<span class="mg-l-10">px</span>
						</div>

						<!--关联表单-->
						<div class="row">
							<label class="left-fn-title">关联表单：</label>
							<label class="wd-120 mg-r-10">
								<input class="form-control" placeholder="" disabled="disabled" type="text" id="fieldName">
							</label>
							<input type="button" class="btn btn-primary  mg-r-8 tx-13" id="chooseField" value="选择">
						</div>

						<!--列表项目脚本-->
						<div class="row">
							<label class="left-fn-title">列表项目脚本：</label>
							<div class="col-lg pd-l-0 pd-r-0 wd-500">
								<textarea rows="6" class="form-control" placeholder="" id="itemScript"></textarea>
							</div>
						</div>

						<div class="row mg-t--10">
							<label class="left-fn-title"> </label>
							<label class="d-flex align-items-center tx-gray-800 tx-12">
								<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>使用方法说明
							</label>
						</div>
					</li>
				</ul>
			</div>

		</div><!-- modal-body -->
		<div class="btn-box">
			<div class="modal-footer">
				<button type="button" class="btn btn-danger tx-size-xs" id="deleteItem" onclick="deleteItem()">删除本项目</button>
				<button type="button" class="btn btn-primary tx-size-xs mg-x-15-force" onclick="confirmItem()">确认</button>
				<button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
			</div>
		</div>
		<input type="hidden" id="curItemId" value="" />

	</div><!-- br-mainpanel -->
	<!-- ########## END: MAIN PANEL ########## -->

	<script src="${request.contextPath}/lib/2018/jquery/jquery.js"></script>
	<script src="${request.contextPath}/common/2018/common2018.js"></script>
	<script src="${request.contextPath}/lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="${request.contextPath}/lib/2018/popper.js/popper.js"></script>
	<script src="${request.contextPath}/lib/2018/bootstrap/bootstrap.js"></script>
	<script src="${request.contextPath}/lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="${request.contextPath}/lib/2018/moment/moment.js"></script>
	<script src="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<script src="${request.contextPath}/lib/2018/peity/jquery.peity.js"></script>
	<script src="${request.contextPath}/lib/2018/highlightjs/highlight.pack.js"></script>
	<script src="${request.contextPath}/lib/2018/select2/js/select2.min.js"></script>
	<script src="${request.contextPath}/common/2018/bracket.js"></script>
	<script>
		var	dialog = new top.TideDialog();  //弹窗公共变量
		var itemid =  ${id};
		var status =  ${status};
		var isadd = ${isadd};
		var channelid = ${channelid};
		var isDefault = ${isDefault};
		
		if(itemid  && isDefault==0){
			$("#deleteItem").show();  //如果是已经存在的，显示删除按钮
		}
		
		;$(function () {
			
			if(itemid && isadd == 0 ){
				//编辑项目的数据回显
				$.ajax({   
					type: "GET",
					url: "${request.contextPath}//channel/list/header/get",
					data: {"id":itemid},
					success: function(d){
						console.log(d)
						if(d.code==200){
							//width
							$("#itemname").val(d.data.title);
							$("#fieldName").val(d.data.fieldName)
							
							if(d.data.width !=0 || d.data.width != ""){
								var itemW = $("#itemWidth").select2();  
								itemW.val(d.data.width).trigger("change");   
							}else{
								var itemW = $("#itemWidth").select2();  
								itemW.val(0).trigger("change");  
							}
							$("#itemScript").val(d.data.script)						
						}
					},
					error:function(err){
						console.log(err)
					}
				});
			}
		});
		
		function confirmItem(){
			var title = $.trim( $("#itemname").val() )  ;  //
			if( !title ){
				dialog.showAlert("请输入列表项目名称!","danger") ;
				return false ;
			}
			var _width = $("#itemWidth option:selected").val() ;
			
			var fieldName = $("#fieldName").val(); 
			if( fieldName == "" ){
				dialog.showAlert("请选择关联表单!","danger") ;
				return false ;
			}
			var script = $("#itemScript").val() ;
			
			if( isadd == 1 ){  //新增项目
				
				$.ajax({
					type: "post",
					url: "${request.contextPath}//channel/list/header/add",
					data: {
						"title" : title , "width" : _width , "channel" : channelid , "fieldName" : fieldName , "script" : script , "status" : 0
					},
					success: function(d){
						console.log(d)
						if(d.code==200){
							dialog.showAlert("新增成功！") ;
							top.TideDialogClose({suffix:'_2',recall:true,returnValue:{status:0}});			
						}else{
							dialog.showAlert("新增失败！") ;
						}
					},
					error:function(err){
						console.log(err)
					}
				});
			}else if( isadd == 0 ){  //修改项目
				$.ajax({
					type: "post",
					url: "${request.contextPath}//channel/list/header/update",
					data: {
						"id" : itemid , "title" : title , "width" : _width , "fieldName" : fieldName , "script" : script
					},
					success: function(d){
						console.log(d)
						if(d.code==200){
							dialog.showAlert("修改成功！") ;
							top.TideDialogClose({suffix:'_2',recall:true,returnValue:{status:0}});				
						}else{
							dialog.showAlert("修改失败！") ;
						}
					},
					error:function(err){
						console.log(err)
					}
				});
			}
		}
		
		//删除项目
		function deleteItem(){
			var c = confirm("确定要删除本项目吗？")
  			if ( c == true ){
  				$.ajax({
					type: "post",
					url: "${request.contextPath}//channel/list/header/delete",
					data: {
						"id" : itemid 
					},
					success: function(d){
						console.log(d)
						if(d.code==200){
							dialog.showAlert("删除成功!","") ;
							top.TideDialogClose({suffix:'_2',recall:true,returnValue:{status:0}});	
						}else{
							dialog.showAlert("删除失败！","danger") ;
						}
					},
					error:function(err){
						console.log(err)
					}
				});
  			}
  			return false ;
		}
		
		//选择 关联表单
		$("#chooseField").click(function(){
			var url = "${request.contextPath}/channel/list/config/relatedfield?channelid="+channelid+"&type=header" ;
		    var dialog = new top.TideDialog();
		    dialog.setWidth(600);
		    dialog.setHeight(450);
		    dialog.setUrl(url);
		    dialog.setTitle('关联表单');
		    dialog.show();
		})
		
		function setReturnValue(obj){
			console.log(obj) ;
			$("#fieldName").val( $.trim( obj.fieldName ) ) ;
		}
	</script>
</body>

</html>
