<!DOCTYPE html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">

    <title>聚视后台</title>

    <!-- vendor css -->
    <link href="${request.contextPath}/lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

    <link href="${request.contextPath}/lib/2018/highlightjs/github.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/select2/css/select2.min.css" rel="stylesheet">

    <!-- Bracket CSS -->
    <link rel="stylesheet" href="${request.contextPath}/style/2018/bracket.css">
    <link rel="stylesheet" href="${request.contextPath}/style/2018/common.css">

</head>
<style>
    html, body { width: 100%; height: 100%; }
    textarea{width: 400px;min-height: 200px;}
    #icon-box{width: 34px;}
    #icon-box i{color: #0070d0;font-size: 24px;margin-right: 10px;}
    #deleteItem{display: none;}
</style>

<body class="">

    <div class="bg-white modal-box">
        <div class="modal-body pd-20 overflow-y-auto" style="top:0;">
            <div class="config-box">
                <ul>
                    <!--功能项目名称-->
                    <li class="block">
                        <div class="row">
                            <label class="left-fn-title">功能项目名称：</label>
                            <label class="wd-400">
                                <input class="form-control" id="funcname" placeholder="" type="text">
                            </label>
                        </div>

                        <!--选择图标-->
                        <div class="row">
                            <label class="left-fn-title">选择图标：</label>
                            <label class="d-flex align-items-center tx-gray-800 tx-12 mg-r-10 tx-" id="icon-box">
                                <i class="fa fa-search mg-r-5"></i>
                            </label>
                            <input type="button" class="btn btn-primary btn-sm mg-r-8 tx-13" id="chooseIcon" value="选择">
                        </div>

                        <!--列表项目脚本-->
                        <div class="row">
                            <label class="left-fn-title">列表项目脚本：</label>
                            <div class="col-lg pd-l-0 pd-r-0 wd-400">
                                <textarea rows="6" class="form-control" id="itemScript" placeholder="" ></textarea>
                            </div>
                        </div>

                        <div class="row mg-t--10">
                            <label class="left-fn-title"> </label>
                            <label class="d-flex align-items-center tx-gray-800 tx-12">
                                <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>功能菜单按钮js<br>列表页操作列js
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
                <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs"
                    data-dismiss="modal">取消</button>
            </div>
        </div>


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

    <script src="${request.contextPath}/lib/2018/jquery-toggles/toggles.min.js"></script>
    <script src="${request.contextPath}/common/2018/bracket.js"></script>

    <script>

    	var	dialog = new top.TideDialog();  //弹窗公共变量

        var itemid =  ${itemid};
        var status =  ${isview};
        var isadd = ${isadd};
        var channelid = ${channelid};
        var isDefault = ${isDefault};

		console.log(itemid,isDefault)
		if( itemid && isDefault == 0  && isadd == 0 ){
			$("#deleteItem").show();  //如果是已经存在的，显示删除按钮
		}
		
		;$(function () {
			if(itemid && isadd == 0 ){
				//编辑项目的数据回显
				$.ajax({   
					type: "GET",
					url: "${request.contextPath}/channel/list/menu/get",
					data: {"id":itemid},
					success: function(d){
						console.log(d)
						if(d.code==200){
							$("#funcname").val(d.data.title);
							$("#icon-box").html(d.data.icon)
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
			var title = $.trim( $("#funcname").val() )  ;  //
			if( !title ){
				dialog.showAlert("请输入菜单项名称!","danger") ;
				return false ;
			}
			var icon = $.trim( $("#icon-box").html().toString() ); 
			if( !icon ){
				dialog.showAlert("请选择图标!","danger") ;
				return false ;
			}
			
			var script = $("#itemScript").val() ;
			
			if( isadd == 1 ){  //新增项目
				$.ajax({
					type: "post",
					url: "${request.contextPath}/channel/list/menu/add",
					data: {
						"title" : title , "channel" : channelid , "icon" : icon , "script" : script , "status" : 0
					},
					success: function(d){
						console.log(d)
						if(d.code==200){
							dialog.showAlert("新增成功！") ;
							top.TideDialogClose({suffix:'_2',recall:true,returnValue:{status:1}});			
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
					url: "${request.contextPath}/channel/list/menu/update2",
					data: {
						"id" : itemid , "title" : title ,"icon" : icon  , "script" : script
					},
					success: function(d){
						console.log(d)
						if(d.code==200){
							dialog.showAlert("修改成功！") ;
							top.TideDialogClose({suffix:'_2',recall:true,returnValue:{status:1}});				
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
					url: "${request.contextPath}/channel/list/menu/delete",
					data: {
						"id" : itemid 
					},
					success: function(d){
						console.log(d)
						if(d.code==200){
							dialog.showAlert("删除成功!","") ;
							top.TideDialogClose({suffix:'_2',recall:true,returnValue:{status:1}});	
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
		$("#chooseIcon").click(function(){
			var url = "${request.contextPath}/channel/list/config/menuicon";
		    var dialog = new top.TideDialog();
		    dialog.setWidth(800);
		    dialog.setHeight(600);
		    dialog.setUrl(url);
		    dialog.setTitle('关联表单');
		    dialog.show();
		})
		
		function setReturnValue(obj){
			$("#icon-box").html( $.trim( obj.icon ) ) ;
		}
    </script>
</body>

</html>