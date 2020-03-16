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

	<link rel="stylesheet" href="${request.contextPath}/static/css/list-config.css">
    <script>
        var path = '${request.contextPath}';
        var channelid = ${channelID};
    </script>
</head>

<body class="">

    <div class="bg-white modal-box">
        <div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
            <ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
                <li class="nav-item"><a class="nav-link active" data-index="1" data-toggle="tab" href="#" role="tab">列表显示</a></li>
                <li class="nav-item"><a class="nav-link" data-index="2" data-toggle="tab" href="#" role="tab">功能菜单</a></li>
                <li class="nav-item"><a class="nav-link" data-index="3" data-toggle="tab" href="#" role="tab">搜索项目</a></li>
                <li class="nav-item"><a class="nav-link" data-index="4" data-toggle="tab" href="#" role="tab">定制化列表</a></li>
            </ul>
        </div>
        <div class="modal-body pd-20 overflow-y-auto">
            <div class="config-box">
                <ul>
                    <!--列表显示-->
                    <li class="block">
                        <!-- 当前列表项目 -->
                        <div class="cur-list">
                            <label class="title">当前列表项目</label>
                            <div class="now-tab-list drag" id="currentList">
                                <!--<span class="tab-item">选择
                                	<span class=" icon-create icon-btn" id="create-btn">
                                        <i class="icon ion-android-create tx-20 icon-color"></i>
                                    </span>
                                    <i class="icon ion-close-circled tx-16  delete-btn"></i>
                                </span>
                                <span class="tab-item" id="operation">操作
                                    <span class=" icon-create icon-btn" id="create-btn">
                                        <i class="icon ion-android-create tx-20 icon-color"></i>
                                    </span>
                                    <i class="icon ion-close-circled tx-16  delete-btn"></i>
                                </span>-->
                            </div>
                        </div>
                        <!-- 剩余可用列表项目 -->
                        <div class="residue-usable mg-t-10">
                            <label class="title">剩余可用列表项目</label>
                            <div class=" d-flex flex-wrap">
                            	<div class="usable-list drag" id="residueList">
	                                <!--<span class="tab-item">PV <i class="icon ion-android-add-circle tx-16 add-btn"></i></span>
	                                <span class="tab-item">发布状态 <i
	                                        class="icon ion-android-add-circle tx-16 add-btn"></i></span>
	                                <span class="tab-item">审核状态 <i class="icon ion-android-add-circle tx-16 add-btn"></i></span>-->
	                            </div>
	                            <span class="tab-item icon-btn" id="newListItem">
	                            	<i class="icon ion-plus tx-20 pd-y-10 pd-x-0 icon-color"></i>
	                            </span>
                            </div>
                        </div>

                        <div class=" mg-t-5 tx-12">
                            <i class="icon ion-information-circled tx-16 mg-r-5 align-middle"></i>拖动进行排序
                        </div>

                        <!-- 默认列表页面视图 -->
                        <div class="default-list mg-t-10" id="default-list">
                            <label class="title">默认列表页面视图</label>
                            <div class="radios">
                                <label class="rdiobox" id="rdiobox">
                                    <input name="rdio" type="radio" value="0"><span>文字列表</span>
                                </label>
                                <label class="rdiobox" id="rdiobox">
                                    <input name="rdio" type="radio" value="2"><span>图片列表</span>
                                </label>
                            </div>
                        </div>

                        <!-- 其他功能 -->
                        <div class="default-list  mg-t-15" id="otherFunc">
                            <label class="title">其他功能</label>
                            <div class="radios d-flex ">
                                <label class="ckbox mg-r-10">
                                    <input type="checkbox" value="1"><span>是否显示子频道内容</span>
                                </label>
                                <label class="ckbox mg-r-10">
                                    <input type="checkbox" value="2"><span>是否显示草稿数</span>
                                </label>
                                <label class="ckbox mg-r-10">
                                    <input type="checkbox" value="3"><span>是否使用权重</span>
                                </label>
                            </div>
                        </div>
                    </li>

                    <!--功能菜单-->
                    <li>
                        <!-- 当前功能菜单 -->
                        <div class="func-menu d-flex">
                        	<div class="left-menu drag" id="curmenu">
                        		<label class="left-fn-title">当前功能菜单：</label>
                        		<div class="curmenu-box">
                        			<!--<div class="left-menu-item clearfix" id="left-menu-item">
		                                <i class="fa fa-plus-square menu-icon" aria-hidden="true"></i>
		                                <span class="menu-text">新建</span>
		                                <span class="list-show float-right">
		                                    <span>列表显示</span>
		                                    <div class="toggle-light">
		                                        <div class="toggle on"></div>
		                                    </div>
		                                    <i class="fa fa-sort" aria-hidden="true"></i>
		                                </span>
		                                <i class="icon ion-close-circled tx-16 menu-delete"></i>
		                            </div>-->

                        		</div>

	                        </div>
	                        <div class="right-menu drag" id="">
	                            <label class="right-fn-title wd-100p d-block">剩余功能菜单：</label>
	                            <div class="restmenu">
	                            	<!--<div class="right-menu-item" id="right-menu-item">
		                                <i class="fa fa-plus-square menu-icon" aria-hidden="true"></i>
		                                <span class="menu-text">导入文档</span>
		                                <i class="icon ion-android-add-circle tx-16 menu-add"></i>
		                            </div>
		                           -->
	                            </div>

	                            <div class="right-menu-item add-function">
	                                <i class="icon ion-plus tx-20 add-function-btn"></i>
	                            </div>
	                        </div>
                        </div>
                    </li>
                    <!--搜索项目-->
                    <li>
                        <!-- 当前过滤项目 -->
                        <div class="cur-fast-search"  id="curFastSearch">
                            <label class="title">当前快捷检索</label>
                            <div class=" drag clearfix">
                            	<div class="cur-search-box">
                            		<!--<span class="tab-item">全部</span>
	                                <span class="tab-item">
	                                	草稿
	                                	<span class="icon-create icon-btn edit-item"><i class="icon ion-android-create tx-20 icon-color"></i></span>
	                                	<i class="icon ion-close-circled tx-16 menu-delete"></i>
	                                </span>
	                                <span class="tab-item">已发<i class="icon ion-close-circled tx-16 menu-delete"></i></span>
	                                <span class="tab-item">已删除<i class="icon ion-close-circled tx-16 menu-delete"></i></span>
	                                <span class="tab-item">搜索</span>-->
                            	</div>
                            </div>
                        </div>
                        <!-- 剩余可用过滤项目 -->
                        <div class="rest-fast-search" id="restFastSearch">
                            <label class="title">剩余可用快捷检索项目</label>
                            <div class=" drag clearfix" >
                            	<div class="rest-search-box">
                            		<!--<span class="tab-item">待审核
	                                    <i class="icon ion-android-add-circle tx-16 menu-add"></i>
	                                </span>
	                                <span class="tab-item">审核通过
	                                    <i class="icon ion-android-add-circle tx-16 menu-add"></i>
	                                </span>
	                                <span class="tab-item">审核驳回
	                                    <i class="icon ion-android-add-circle tx-16 menu-add"></i>
	                                </span>-->
                            	</div>
                                <span class="tab-item icon-btn" id="addFastSearch" >
                                    <i class="icon ion-plus tx-20 pd-y-0 pd-x-10 "></i>
                             	</span>
                            </div>

                        </div>
                        <!-- 分割线 -->
                        <div class="cut-off"></div>
                        <!-- 搜索项目配置 -->
                        <div class="search-config">
                            <label class="title">搜索项目配置</label>
                            <div class="drag clearfix">
                                <div class="search-config-box ">
	                                <!--<span class="tab-item">标题</span>
	                                <span class="tab-item">时间
	                                    <i class="icon ion-close-circled tx-16 menu-delete"></i>
	                                </span>
	                                <span class="tab-item">作者
	                                    <i class="icon ion-close-circled tx-16 menu-delete"></i>
	                                </span>-->
	                            </div>
                            </div>
                        </div>
                        <!-- 剩余可用过滤显示项目 -->
                        <div class="rest-search-config">
                            <label class="title">剩余可用过滤显示项目</label>
                            <div class="drag clearfix" >
                            	<div class="rest-search-config-box">
                            		<!--<span class="tab-item">发布状态 <i class="icon ion-android-add-circle tx-16 menu-add"></i> </span>
	                                <span class="tab-item">审核状态 <i class="icon ion-android-add-circle tx-16 menu-add"></i> </span>-->
                            	</div>
                                <span class="tab-item icon-btn" id="addSearchConfig">
                                    <i class="icon ion-plus tx-20 pd-x-10 pd-y-0" ></i>
                                </span>
                            </div>
                            <div class=" mg-t-5 tx-12">
                                <i class="icon ion-information-circled tx-16 mg-r-5 "></i>
                                	拖动进行排序，部分功能需要对应配置相关项目!
                            </div>
                        </div>
                    </li>
                    <!--列表设置-->
                    <li >
                        <#--<div class="row">
                            <label class="title">定制化列表开通：</label>
                            <div class="toggle-wrapper ">
                                <div class="toggle toggle-light success" ></div>
                            </div>
                            <span class="tx-gray-800 tx-12">
                                <i class="icon ion-information-circled tx-gray-900 tx-16 align-middle">
                                </i>开通后系统列表配置将失效！
                            </span>
                        </div>-->
                        <div class="row">
				            <label class="left-fn-title">列表页程序：</label>
				            <label class="wd-500">
                                <input name="ListProgram" id="ListProgram" size="64" class="form-control textBox" placeholder="" type="text" value="${listProgram}">
                            </label>
                            <input type="hidden" value="${listProgramType}" name="ListProgram_Type" id="ListProgram_Type" class="FieldValueType" value2="ListProgram">

				            <a class="tx-20 mg-l-15 lock-unlock" href="javascript:applySubChannel('ListProgram')">
				             	<i class="fa fa-download" aria-hidden="true" title="应用到子频道"></i>
				             </a>
	       		  	  	</div>
	       		  	  	<div class="row mg-t--10" id="Caption_column_href">
							<label class="left-fn-title"> </label>
							<label class="d-flex align-items-center tx-gray-800 tx-12">
								<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
								示例：../custom/my_document.jsp
							</label>
						</div>
						<div class="row">
				            <label class="left-fn-title">列表页脚本：</label>
				            <div class="col-lg pd-l-0 pd-r-0 wd-500">
                                <textarea name="ListJS" id="ListJS" rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('ListJS')">${listJS}</textarea>
				            </div>
                            <input type="hidden" value="${listJSType}" name="ListJS_Type" id="ListJS_Type" class="FieldValueType" value2="ListJS">
				            <a class="tx-20 mg-l-15 lock-unlock" href="javascript:applySubChannel('ListJS')">
				            	<i class="fa fa-download" aria-hidden="true" title="应用到子频道"></i>
				            </a>
	       		  	    </div>
	       		  	    <div class="row mg-t--10" id="Caption_column_href">
							<label class="left-fn-title"> </label>
							<label class="d-flex align-items-center tx-gray-800 tx-12">
								<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
								注入JS脚本示例：$.getScript("../custom/demo.js");
							</label>
						</div>

                    </li>
                </ul>
            </div>

        </div><!-- modal-body -->
        <div class="btn-box">
            <div class="modal-footer">
                <button type="button" class="btn btn-primary tx-size-xs" id="listconfirm">确认</button>
                <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs"
                    data-dismiss="modal">取消</button>
            </div>
        </div>


    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

    <script src="${request.contextPath}/lib/2018/jquery/jquery.js"></script>
    <script src="${request.contextPath}/common/2018/common2018.js"></script>
    <script src="${request.contextPath}/common/2018/TideDialog2018.js"></script>
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

     <script src="${request.contextPath}/lib/2018/Sortable/Sortable.js"></script>
    <!--列表项配置-->
	<script src="${request.contextPath}/static/js/list-config.js"></script>

    <script>

        //定制化列表--继承锁定
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

        function cT(field)
        {
            if($("#"+field+"_Type").val()==0)
            {
                //继承
                $("#"+field+"_Type").val("1");
                $("#"+field+"_img1").attr("src","../images/icon/14.png");
                //$("#"+field).attr("class","form-control textBox").removeAttr('disabled');

            }
            else
            {
                $("#"+field+"_Type").val("0");
                $("#"+field+"_img1").attr("src","../images/icon/13.png");
                //$("#"+field).attr("class","textinput_disabled form-control textBox disabled").attr('disabled','disabled');
            }
            //alert($("#"+field+"_img1").attr("src"));
        }

        function editListProgram() {
            var listProgram_Type = $("#ListProgram_Type").val();
            var listJS_Type = $("#ListJS_Type").val();
            var listProgram = $("#ListProgram").val();
            var listJS = $("#ListJS").val();
            $.ajax({
                url:path+'/channel/list/config/channel/update',
                type:'POST',
                data:{
                    "channelid":channelid,
                    "ListProgram_Type":listProgram_Type,
                    "ListJS_Type":listJS_Type,
                    "ListProgram":listProgram,
                    "ListJS":listJS
                },
                success:function () {
                    top.TideDialogClose();
                }
            })
        }


        $(function () {

            //开关相关初始化
            $('.toggle').toggles({
                //on: true,
                text: {
                    on: '',
                    off: ''
                },
                height: 25
            });

            $(".FieldValueType").each(function(){
                //追加按钮
                var field = $(this).attr("value2");
                if($(this).val()==1)
                {

                    var html ="<a href=\"javascript:cT('"+field+"');\" class=\"mg-l-25 tx-20 lock-unlock\" onclick=\"lockUnlock(this)\" ><i class=\"fa fa-unlock\" title=\"继承上级\"></i></a>";

                }else{

                    //继承
                    $("#"+field).attr("class","textinput_disabled").attr('disabled','disabled');
                    $("#"+field).addClass("form-control textBox disabled");

                    var html ="<a href=\"javascript:cT('"+field+"');\" class=\"mg-l-25 tx-20 lock-unlock\" onclick=\"lockUnlock(this)\" ><i class=\"fa fa-lock\" title=\"继承上级\"></i></a>";
                }

                //html += " <a class=\"tx-20 mg-l-15 lock-unlock\" href=\"javascript:applySubChannel('"+field+"')\"><i class=\"fa fa-download\" aria-hidden=\"true\" title=\"应用到子频道\"></i></a>";


                $(this).after(html);
            });
        });

        function applySubChannel(field)
        {
            var v = $("#"+field).val();
            if(confirm('当前频道及其所有子频道的对应属性都会被覆盖，请确认要复制该属性到子频道吗？属性内容是：'+v))
            {
                var url="${request.contextPath}/channel/channel_attribute_copy.jsp";
                $.ajax({
                    type: "POST",
                    url: url,
                    data: {id:$("#ChannelID").val(),field:field,value:v},
                    success: function(msg){alert("应用成功.");}});
            }
        }

    </script>
</body>

</html>