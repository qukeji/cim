<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String content = getParameter(request,"content");

JSONObject juxian = UserInfoUtil.getJuxianInfo(userinfo_session);
String JuxianToken = (String)juxian.get("JuxianToken");
int JuxianID = (int)juxian.get("JuxianID");
%>
<!DOCTYPE HTML>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
	<title>选择</title>
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<script type="text/javascript" src="../common/jquery.js"></script>
	<script type="text/javascript" src="../common/common.js"></script>

	<style>
		html,
		body {
			width: 100%;
			height: 100%;
		}
	</style>

	<script type="text/javascript">


function getDataList(page){
    var page = page;
    $.ajax({
        type: "get",
        dataType:"jsonp",
        url: "http://console.juyun.tv/v1/users",
        //jsonpCallback:"callback",
        data:{
            access_token:"<%=JuxianToken%>",
            page:page
        },
        success: function (res) {
        console.log(res);
            var datalistHtml = "";
            var data = res.result;
            if(res.code==200){
                data.map(function(val,index){
				datalistHtml += '<tr No="'+(index+1)+'" ItemID="'+val.id+'"   id="item_'+val.id+'" >'
						+'<td class="valign-middle">'
						+'<label class="ckbox mg-b-0">'
						+'<input type="checkbox" name="id" value="'+val.id+'"><span></span>'
						+'</label>'
						+'</td>'
						+'<td ondragstart="OnDragStart (event)">'
						+'<span class="pd-l-5 tx-black" id="name_'+val.id+'">'+val.nick+'</span>'
						+'</td>'	
						+'<td class="hidden-xs-down"><span class="pd-l-5 tx-black">'+val.id+'</span></td>'
						+'</tr>';
                });
                $("#datalist").append(datalistHtml);
                 
                if(data.length===10){
                    getDataList(res.page);
                }else{
                    setpitch();
                }
            }
            
           
        }
    });
}
getDataList(1);


function addioscode(){
     var s = document.getElementsByName("id");
     var s2 = "";
     var s3 = "";
     for( var i = 0; i < s.length; i++ )
     {
       if ( s[i].checked ){
         //s2 += s[i].value+",";
         s2 += s[i].value+",";
         s3 += $("#name_"+s[i].value).html()+",";
         console.log(s3);
         }
    			}
    			if(s2!==""){
    				s2 = s2.substr(0,s2.length-1)
    			}
    			if(s3!==""){
    				s3 = s3.substr(0,s3.length-1)
    			}
      //s2 = s2.substr(0,s2.length-1);
    				alert("添加完成");
                               
    			parent.$("#users_id").attr("value",s2);
    			parent.$("#users").attr("value",s3);
    			top.TideDialogClose();                                      
}
	</script>
</head>

<body>
<div class="bg-white modal-box">

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0 table-fixed" id="content-table">
					<thead>
						<tr>
							<th class="wd-5.5p">
								选择
							</th>
							<th class="tx-12-force tx-mont tx-medium">姓名</th>
                            <th class="tx-12-force tx-mont tx-medium">id</th>
						</tr>
					</thead>
					<tbody id="datalist">

					</tbody>
				</table>
                </div>
		</div>
		</div>
		<!--modal-body-->

		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
			<div class="modal-footer">
				<input type="hidden" name="startButton" value="14211">
                <button name="startButton" type="button" class="btn btn-primary tx-size-xs"  id="startButton" onclick="addioscode();">确定</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
				</button>
				<input type="hidden" name="Submit" value="Submit">
			</div>
		</div>
		<div id="ajax_script" style="display:none;"></div>
</div>
<!-- modal-box -->
</body>

<script src="../common/2018/common2018.js"></script>
<script src="../lib/2018/jquery/jquery.js"></script>
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
function setpitch(){
    var content_ = "<%=content%>";
    var val = content_.split(",");
    var boxes = document.getElementsByName("id");
    for(i=0;i<boxes.length;i++){
        for(j=0;j<val.length;j++){
            if(boxes[i].value == val[j]){
                boxes[i].checked = true;
                break;
            }
        }
    }
    
}
</script>


</html>
