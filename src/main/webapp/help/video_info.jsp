<%@ page import="tidemedia.cms.system.*,java.io.*,
				tidemedia.cms.user.*,java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>主页_帮助中心_tidemedia center</title>
<!--<link rel="stylesheet" href="../style/bootstrap.min.css">-->
<link rel="stylesheet" href="../style/2018/bracket.css">
<style type="text/css">
	.col-lg-6 {
		margin: 10px 20%;
		width:60%;
	}
</style>
<script src="../common/jquery.js"></script>
<script src="../common/jquery.min.js"></script>
<script src="../common/bootstrap.min.js"></script>
<script language="JavaScript"> 
	function ok(){
        var video_url = document.getElementById("video_url").value;
		if(video_url==""){
			alert("请输入视频地址");
		}else{
			var url = "../../vms/api/video_info_.jsp?video_url="+video_url;
			$.ajax({  
				type : "get",  
				async : false,  //同步请求  
				url : url,  
				success:function(data){  
					$("#message").html(data.trim());
				}
			});
		}
	}
</script> 
</head> 

<body>
	<div style="padding: 20px 100px 10px;">
		<form class="bs-example bs-example-form" role="form">
			<div class="row">
				<div class="col-lg-6">
					<div class="input-group">
						<input type="text" class="form-control" id="video_url" placeholder="视频地址">
						<span class="input-group-btn">
							<button class="btn btn-default" type="button" onclick="ok()">查看信息!</button>
						</span>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-6">
					<textarea class="form-control" rows="25" id="message"></textarea>
				</div>
            </div>
		</form>
	</div>
	</script>
</body>
</html>
