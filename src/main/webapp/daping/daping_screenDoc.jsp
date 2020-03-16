<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    String Title = getParameter(request,"Title");
    String globalid =getParameter(request,"globalid");
    String pglobalid =getParameter(request,"pglobalid");
	TideJson daping_config = CmsCache.getParameter("daping").getJson();
    Channel screenChannel = CmsCache.getChannel(daping_config.getInt("screenchannelid"));
	TableUtil tu  = new TableUtil();
    String x =getParameter(request,"x");
    String y =getParameter(request,"y");
	String screen_pro = "";
	String width ="";
    String height="";
    if(!"".equals(globalid)){
        String sql = "select * from " + screenChannel.getTableName()+"  where globalid="+globalid+" and Active =1";
    	ResultSet rs = tu.executeQuery(sql);
        while(rs.next()){
            screen_pro = rs.getString("screen_pro");
            width = rs.getString("width");
            height = rs.getString("height");
            Title = rs.getString("Title");
            x = rs.getString("xplace");
            y = rs.getString("yplace");
        }
        tu.closeRs(rs);
    }
    
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
                        <input id="x" type="hidden" name="x" value="<%=x%>"/>
                        <input id="y" type="hidden" name="y" value="<%=y%>"/>
	       	 	<ul>
            	       	  	
	       		 	<li class="block"> 
	       		 		<div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title wd-100">名称：</label>
			              <label class="wd-230">
			                <input class="form-control wd-120" placeholder="不超过5个字符" type="text" name="Title"  id="Title" value="<%=Title%>">
			              </label>									            
	       		  	  	</div>
	       		  	  	<div class="row" id="bili">                  		  	  	
		   		  	  		  <label class="left-fn-title wd-100">屏幕比例：</label>
				              <label class="rdiobox">
				                <input name="screen_pro" value="2" type="radio" checked="checked"><span>16:9</span>
				              </label>
					            <label class="rdiobox">
				                <input name="screen_pro" value="1" type="radio"><span>4:3</span>
				              </label>
		       		  	 </div>
	       		  	  	<div class="row">                   		  	  	
	   		  	  		  	<label class="left-fn-title wd-100">内容源选择：</label>  
	   		  	  		  	<div class="d-flex">
	   		  	  		  		<label class="mg-r-20">宽
		   		  	  		  		<select class="form-control wd-80 ht-40 select2" name="width" id="width"  data-placeholder="">           
						                <option value="1" selected="selected">1</option> 
						                <option value="2">2</option>	
						                <option value="3">3</option>
						                <option  value="4">4</option>
						                <option  value="5">5</option>
						                <option  value="6">6</option>
						                <option  value="7">7</option>
				                	</select> 
			                	</label>
			                	<label>高			                					                	
				                	<select class="form-control wd-80 ht-40 select2" name="height" id="height" data-placeholder="">           
						                <option value="1" selected="selected">1</option> 
						                <option value="2">2</option>	
						                <option value="3">3</option> 	
						                <option  value="4">4</option>
						                <option  value="5">5</option>
						                <option  value="6">6</option>
						                <option  value="7">7</option>
				                	</select>
			                	</label>
	   		  	  		  	</div>
	       		  	  	</div>
	       		  	  	<div class="row mg-t--10">
	       		  	  		<label class="left-fn-title wd-100"></label>
	       		  	  		<label class="d-flex align-items-center tx-gray-800 tx-12">
	       		  	  			<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>提示：最终展示会根据屏幕比例自适应。
	       		  	  		</label>
	       		  	  	</div>
	       		  </li>	       		
       	    </ul>
	        </div>
	    </div><!-- modal-body -->
      <div class="btn-box" >
      	<div class="modal-footer" >
		      <button type="button" class="btn btn-primary tx-size-xs" onclick="addOrUpdate();"> 确认</button>
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
<script src="../common/2018/TideDialog2018.js"></script>

<script>
    
    var globalid = "<%=globalid%>";
    var pglobalid = "<%=pglobalid%>";
    var x = "<%=x%>";
    var y = "<%=y%>";
    var rsScreen_pro =  "<%=screen_pro%>";
    var rsWidth =  "<%=width%>";
    var rsHeight =  "<%=height%>";
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

    $(function(){
        if(rsScreen_pro!=""){
            $(":radio[name='screen_pro'][value='" + rsScreen_pro + "']").prop("checked", "checked");
        }
        if(rsWidth!=""){
              $("#width").val(rsWidth).select2();
        }
        if(rsHeight!=""){
              $("#height").val(rsHeight).select2();
        }
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
        var screen_pro = $("input[name=screen_pro]:checked").val();
        var width = $("#width").val();
        var height = $("#height").val();
        $.ajax({
            type: "GET",
            url: "createScreen.jsp"+'?globalid='+globalid+'&pglobalid='+pglobalid+'&Title='+Title+'&x='+x+'&y='+y+'&screen_pro='+screen_pro+'&width='+width+'&height='+height,
            dataType: "json",
            success: function (json) {
                if (json.code == 500) {
                    alert(json.message);
                    submit = true;
                } else if (json.code == 200) {
                    parent.reloadScreen();
                    top.TideDialogClose();
                } else {
                    alert(json);
                }
            }
        });
    }
</script>

</html>
