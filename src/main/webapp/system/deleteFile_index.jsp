<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<!DOCTYPE html>  
<html lang="en">  
<head>  
<meta charset="UTF-8">  
<title>Login</title>  
<link href="../style/9/tidecms.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../common/jquery.js"></script>

<script>	
	function submit_(){
		var url = $('#url').val();

		if(url==""){
			alert("URL不能为空");
		}else{
			$.ajax({
				type: "GET",
				dataType:"json",
				url: "./deleteFile_document.jsp?url="+url,
				success: function(obj){
					if(obj.status==0){
						alert(obj.message);
					}else{
						if(confirm(obj.message)){
							deleteFile(obj.itemId,obj.channelid,obj.CategoryID);
						}
					}
				}   
			}); 
		}		
	}
	function deleteFile(id,channelId,CategoryID){
		var url="../content/document_delete2.jsp?ItemID="+id+"&ChannelID="+channelId+"&CategoryID="+CategoryID;
		$.ajax({
			type: "GET",
			dataType:"json",
			url: url,
			success: function(obj){
				if(obj.status==1){
					alert("撤稿成功");
					document.location.href=document.location.href;
				}	
			}   
		}); 
	}
</script>
</head>  
<body>  
	<form name="form" action="" method="post">
		<div class="form_main">
			<table width="100%" border="0" cellspacing="0" cellpadding="6">
				<tr>
					<td style="text-align: right;">URL:</td>
					<td><input type="text" required="required" name="url" id="url" style="width:310px"></input></td>
				</tr>
			</table>
		</div>
		<div class="form_button">
			<input name="startButton" type="button" class="tidecms_btn2" value="  撤  稿  " onclick="submit_();">
			&nbsp; 
			<input name="Submit2" type="button" class="tidecms_btn2" value="  取  消  " onclick="top.TideDialogClose('');">
		</div>
	</form>  
</body>  
</html>