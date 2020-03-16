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
    String globalid =getParameter(request,"globalid");
    String pglobalid =getParameter(request,"pglobalid");
	TideJson daping_config = CmsCache.getParameter("daping").getJson();
    Channel screenChannel = CmsCache.getChannel(daping_config.getInt("screenchannelid"));
    TableUtil tu  = new TableUtil();
	String sourceid ="";
    if(!"".equals(globalid)){
        String sql = "select * from " + screenChannel.getTableName()+"  where globalid="+globalid+" and Active =1";
    	ResultSet rs = tu.executeQuery(sql);
        while(rs.next()){
            sourceid = rs.getString("sourceid");
        }
        tu.closeRs(rs);
    }
	Channel sourceChannel = CmsCache.getChannel(daping_config.getInt("sourcechannelid"));
	String sql1 = "select * from " + sourceChannel.getTableName()+"  where screenplanid="+pglobalid+" and Active =1";
	 TableUtil tu1  = new TableUtil();
	ResultSet rs1 = tu1.executeQuery(sql1);
    JSONArray array = new JSONArray();
	while(rs1.next()){
		JSONObject sourceData =new JSONObject();
		sourceData.put("globalid",rs1.getInt("globalid"));
		sourceData.put("Title",rs1.getString("Title"));
		array.put(sourceData);
	}
	tu1.closeRs(rs1);
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
	       	 	<ul>
			    	<li class="block">       		  	    
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">内容源选择：</label>               		  	  		 
		  	  		  	  <select class="form-control wd-230 ht-40 select2" data-placeholder="" name="sourceid" id="sourceid" >           
			                	<%  
						    for(int n =0;n<array.length();n++){
						       out.println("<option  value='"+array.getJSONObject(n).getString("globalid")+"'>"+array.getJSONObject(n).getString("Title")+"</option>");
						    }
    						%>
    			               
			              </select>               		  	  		 						            
	       		  	  </div>
	       		  </li>	       		
       	     </ul>
            </div>
             </div><!-- modal-body -->
              <div class="btn-box" >
              	<div class="modal-footer" >
        		      <button type="button" onclick="addOrUpdate()" class="btn btn-primary tx-size-xs">确认</button>
        		      <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
        		    </div> 
              </div>
        	   </div>      
            </div>
            <input id="globalid" type="hidden" name="globalid" value="<%=globalid%>"/>
            <input id="pglobalid" type="hidden" name="pglobalid" value="<%=pglobalid%>"/>
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
    var sourceid = "<%=sourceid%>"
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
        if(sourceid!=""){
              $("#sourceid").val(sourceid).select2();
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
//      	$("#sourceid").select2({
    function formatRepo(results){
        return results.attr_value+results.attr_value_en;
    }
    function formatRepoSelection(results){
        return results.attr_value+results.attr_value_en;
    }

    });
</script>

<script type="text/javascript">
	/*function getSource(){
		if(pglobalid==0){
			return;
		}
		$.ajax({
			type: "GET",
			url: "getSource.jsp?pglobalid="+pglobalid,
			dataType: "json",
			data: {channelid: channelid},
			success: function (json) {
				if (json.code == 500) {
					alert(json.message);
					submit = true;
				} else if (json.code == 200) {
				     console.log(JSON.stringify(json.data));
					 addOption(json.data);
				} else {
					alert(json);
				}
			}
		});
	}
	function addOption(json){
		var sourceList = $("#sourceid");
		for(var i=0;i<sourceList.length;i++){
			var str =  '<option  value="'+sourceList[i].globalid+'">'+sourceList[i].Title+'</option>';
			sourceList.append(str);
		}
	}*/
    var submit = true;
    function addOrUpdate(){
        submit = false;
        var sourceid =$("#sourceid").val();
        $.ajax({
            type: "GET",
            url: "updateScreen.jsp"+'?globalid='+globalid+'&sourceid='+sourceid,
            dataType: "json",
            success: function (json) {
                if (json.code == 500) {
                    alert(json.message);
                    submit = true;
                } else if (json.code == 200) {
                   window.parent.reloadScreen();
                   top.TideDialogClose();
                } else {
                    alert(json);
                }
            }
        });
    }
</script>

</html>
