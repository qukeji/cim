<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.JSONArray,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    String sourceUrl = getParameter(request,"sourceUrl");
    String Title = getParameter(request,"Title");
    String globalid =getParameter(request,"globalid");
    String pglobalid =getParameter(request,"pglobalid");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="/cms2018/favicon.ico">
    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
    <title>TideCMS</title>

    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
    <style>
        html,body{width: 100%;height: 100%;}  	
		.modal-body{top: 0;}
		.modal-body .config-box .row .left-fn-title{min-width: 60px;}
    </style>

    <!-- <style>
    .edit-main{margin:0;position:Static;}
    .edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
    .edit-con{position:Static;margin:-1px 0 0;}
    .edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
    </style>  -->
</head>
<body class="" >

<div class="bg-white modal-box">     
	    <div class="modal-body pd-20 overflow-y-auto">
	        <div class="config-box">
	            <input id="globalid" type="hidden" name="globalid" value="<%=globalid%>"/>
                <input id="pglobalid" type="hidden" name="pglobalid" value="<%=pglobalid%>"/>
	       	 	<ul>
	       	  	<!--基本信息-->
                    <li class="block">       		  	    
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title wd-60">名称：</label>
			              <label class="wd-230">
			                <input class="form-control wd-120" placeholder=""不超过5个字符"" type="text" name="Title"  id="Title" value="<%=Title%>">
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">  
	       		  	  	<label class="left-fn-title wd-60">地址：</label>
	       		  	  	<label class="d-flex ">	   		  	  		  
		   		  	  		  <input class="form-control wd-300 mg-r-20" placeholder="" type="text" name="sourceUrl" id="sourceUrl" value="<%=sourceUrl%>">
				              <input class="btn btn-primary tx-size-xs btn-sm " href="javascript:;" name="" type="button" value="预览" onclick="lookUrl()">                         
	       		  	  	</label>	
	       		  	  </div>
	       		  </li>	     
              </ul>
	          </div>
            	</div><!-- modal-body -->
                  <div class="btn-box" >
                  	<div class="modal-footer" >
            		      <button type="button" class="btn btn-primary tx-size-xs" onclick="addOrUpdate()">确认</button>
            		      <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
            		    </div> 
                  </div>
                </div>
</body>
<!-- br-mainpanel -->
<!-- ########## END: MAIN PANEL ########## -->
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

<script src="../lib/2018/select2/js/select2.min.js"></script>

<script src="../common/2018/bracket.js"></script>


<script>
    
    var globalid = "<%=globalid%>";
    var pglobalid = "<%=pglobalid%>";
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
    function lookUrl(){
    var sourceUrl =$('#sourceUrl').val();

    if(!sourceUrl)return ;
	window.open(sourceUrl);
    }
    $(function(){
        $("#form_nav li").click(function(){
            var _index = $(this).index();
            console.log(_index)
            $(".config-box ul li").removeClass("block").eq(_index).addClass("block");
        })
        //推荐设置锁定图片切换
//    $(".lock-unlock").click(function(){
//     	var textBox = $(this).parent(".row").find(".textBox") ;
//     	if($(this).find("i").hasClass("fa-lock")){
//     	 	$(this).find("i").removeClass("fa-lock").addClass("fa-unlock");
//     	 	textBox.removeAttr("disabled","").removeClass("disabled")
//     	}else{
//     	 	$(this).find("i").removeClass("fa-unlock").addClass("fa-lock");
//     	 	textBox.attr("disabled",true).addClass("disabled")
//     	}
//    })
//


    });
</script>

<script type="text/javascript">

    var submit = true;
    function addOrUpdate(){
        submit = false;
        var Title =$("#Title").val();
        if(Title.trim()==""){
            var dialog = new top.TideDialog();
            dialog.showAlert("请输入名称","danger");
            return false;
        }
        var sourceUrl =$("#sourceUrl").val();
        $.ajax({
            type: "GET",
            url: "createSource.jsp"+'?globalid='+globalid+'&pglobalid='+pglobalid+'&sourceUrl='+encodeURI(sourceUrl) +'&Title='+Title,
            dataType: "json",
            success: function (json) {
                if (json.code == 500) {
                    alert(json.message);
                    submit = true;
                } else if (json.code == 200) {
                   parent.reloadSource();
                   top.TideDialogClose();
                } else {
                    alert(json);
                }
            }
        });
    }
</script>

</html>
