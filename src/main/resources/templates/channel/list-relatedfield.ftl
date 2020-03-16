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
    <link rel="stylesheet" href="${request.contextPath}/style/2018/bracket.css">
    <link rel="stylesheet" href="${request.contextPath}/style/2018/common.css">
	<style>
	    html, body { width: 100%; height: 100%; }
	    
	</style>
</head>

<body class="">
    <div class="bg-white modal-box">
        <div class="modal-body pd-20 overflow-y-auto" style="top:0;">
            <div class="config-box">
                <div class="bd">	       		  		
	       		  	<table class="table mg-b-0">
			            <thead>
			              <tr>	               
			                <th class="tx-12-force tx-mont tx-medium wd-40"><span class="pd-l-10">选择</span></th>
			                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">描述</th>
			                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">字段名称</th>	               
			              </tr>
			            </thead>
			            <tbody class="">
			              <!--<tr>	                
			                <td>
			                	<label class="rdiobox mg-l-10"><input type="radio" value="0" id="item_type_0" name="item_type" checked=""><span for="item_type_0"> </span></label>
			                </td>
			                <td class="">发布日期 </td>
			                <td class=""> PublishDate</td>
			              </tr>-->
                        </tbody>
			          </table>				          
       		  	</div>	       	
            </div>
        </div><!-- modal-body -->
        <div class="btn-box">
            <div class="modal-footer">
                <button type="button" class="btn btn-primary tx-size-xs" onclick="fieldconfirm()">确认</button>
                <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
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
    <script src="${request.contextPath}/common/2018/bracket.js"></script>

    <script>
    	var channelid = ${channelid};
    	var type = '${type}';
    	var url = "";
    	if(type=="header"){
    	    url="${request.contextPath}/channel/list/header/field/list";
        }else if(type=="search"){
    	    url="${request.contextPath}/channel/list/search/field/list";
        }
    	var	dialog = new top.TideDialog();  //弹窗公共变量
        ;$(function () {
			if( channelid ){
				
				$.ajax({
					type: "GET",
					url: url,
					data: {
						"channel":channelid
					},
					success: function(d){
						console.log(d)
						if(d.code==200 && d.data.length > 0){
							var tableHtml = "" ;
							for(var i = 0 ; i<d.data.length ;i ++ ){
								if( !( d.data[i].Title=="Content" || d.data[i].Title=="Photo" ) ){
									tableHtml += '<tr data-id="'+d.data[i].id+'">'+
											'<td>' +
											    '<label class="rdiobox mg-l-10 cursor-pointer">'+
												    '<input type="radio" value="'+i+'" id="item_type_'+i+'" name="item_type" >'+
												    '<span for="item_type_'+i+'"> </span>'+
											    '</label>'+
											'</td>'+
										    '<td class="fieldDescription">'+d.data[i].Description+' </td>'+
										    '<td class="fieldName" data-value="'+d.data[i].filedValue+'"> '+d.data[i].Title+'</td>'+
										'</tr>' ;
								}				    
							}
							$("tbody").html(tableHtml) ;
						}else{
							dialog.showAlert("未请求到相关数据！","danger")
						}
					},
					error:function(err){
						console.log(err)
					}
				});
			}else{
				dialog.showAlert( "频道id丢失！","danger")
			}

        });
        
        function fieldconfirm(){
        	var checkedRadio = $('td input:radio:checked') ;
        	if(checkedRadio.length == 0 ){
        		dialog.showAlert("请选择表单字段！","danger");
        		return false;
        	}else{
        		var tr = checkedRadio.parents("tr") ;
        		var fieldName = tr.find(".fieldName").text() ;
        		var filedValue = tr.find(".fieldName").attr("data-value") ;
        		top.TideDialogClose({suffix:'_3',recall:true,returnValue:{fieldName:fieldName,filedValue:filedValue}});
        	}
        }
    </script>
</body>

</html>