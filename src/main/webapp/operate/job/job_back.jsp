<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				 java.text.DecimalFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
int		ChannelID	=	ChannelUtil.getApplicationChannel("workorder").getId();
int		ItemID	=	getIntParameter(request,"ItemID");
Document doc=CmsCache.getDocument(ItemID,ChannelID);
String title = doc.getTitle();
int operation_status = doc.getIntValue("operation_status");
%>
<!DOCTYPE HTML>
<html>

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link href="../../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../../style/2018/bracket.css">
<link rel="stylesheet" href="../../style/2018/common.css">
<style>
	html,
	body {
		width: 100%;
		height: 100%;
	}
</style>
<script type="text/javascript" src="../../common/jquery.js"></script>
<script type="text/javascript" src="../../common/common.js"></script>
<script type="text/javascript">

	var parentId = <%=ItemID%>;
	var Title = "<%=title%>";
	var operation_status = <%=operation_status%>;
	function replay(){
		var replySummary = $("#Summary").val();
		if(replySummary==""){
			var dialog = new top.TideDialog();
			dialog.showAlert("请输入回复信息","danger");
			return false ;
		}
		if(operation_status == 0){
			updateState(1);
		}
		var url= "<%=request.getContextPath()%>/workorder/preview/add?parentId="+parentId+"&Title="+Title+"&replySummary="+replySummary;
		$.ajax({
			type: "GET",
			url: url,
			success: function(msg){
				if(msg.trim()!=""){
					alert(msg.trim());
				}else{
					window.parent.location.reload();//刷新父窗口
					window.parent.opener.document.location.reload();
					top.TideDialogClose();//关闭弹出窗口
				}
			}
		});
	}

	function updateState(state){
		var url= "<%=request.getContextPath()%>/workorder/upadteState?id="+parentId+"&operation_status="+state;
		$.ajax({
			type: "GET",
			url: url,
			success: function(msg){
				if(msg.trim()!=""){
					alert(msg.trim());
				}else{
					document.location.reload();
				}
			}
		});
	}
</script>
</head>

<body>
<div class="bg-white modal-box">
        
	<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
		<div class="config-box">
			<ul>
				<li class="block">
					<div class="row">

						<label class="left-fn-title">回复内容：</label>

						<textarea  rows="3" class="form-control" placeholder="" id="Summary" name="Summary" style="width:300px;height:100px"></textarea>
					</div>
				</li>

			</ul>
		</div>
	</div>
        
	<!--modal-body-->

	<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
		<div class="modal-footer">
			<button name="startButton" type="button" class="btn btn-primary tx-size-xs"  id="startButton" onclick="replay();">确定</button>
			<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
			</button>
		</div>
	</div>
</div>
<!-- modal-box -->
</body>

<script src="../../common/2018/common2018.js"></script>
<script src="../../lib/2018/jquery/jquery.js"></script>
<script src="../../lib/2018/popper.js/popper.js"></script>
<script src="../../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../../lib/2018/moment/moment.js"></script>
<script src="../../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<script src="../../lib/2018/select2/js/select2.min.js"></script>
<script src="../../common/2018/bracket.js"></script>

<script language=javascript>
    function init() {
        document.form.Template.focus();
    }

    function check() {
        for(var i=0;i<document.form1.elements.length-1;i++)
        {
         if(document.form1.elements[i].value=="")
         {
           TideAlert("回复内容不能为空");
           document.form1.elements[i].focus();
           return false;
         }
        }
        return true;
        
    }
    
  function beforeSubmit(form){
if(form.operation.value==''){
	TideAlert("提示","内容不能为空！");
form.username.focus();
return false;
}

return true;
}
    
    
</script>

</html>
