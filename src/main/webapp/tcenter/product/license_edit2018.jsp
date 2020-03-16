<%@ page import="java.sql.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(! userinfo_session.isAdministrator())
{response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

Product product = new Product(id);


//获取机器码
String serverCode = CmsCache.getServerCode();

%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">	
<link rel="stylesheet" href="../style/theme/theme.css">
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script type="text/javascript">
var product_url = "<%=product.getUrl()%>";

function check()
{
	return true;
}

function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		alert(msg);
		field.focus();
		return true;
	}
	return false;
}

function update()
{
	var code = $("#code").val();
	var license = $("#license").val();
	var notify = $("#notify");
	var productid = $("#productid").val();
	notify.html("");
	if(code=="" && license==""){alert("请输入许可代码或代码编号");return false;}

	$("#submit_btn").attr("disabled","true").val("正在提交");
	var url= "license_update.jsp?code=" + code + "&license="+license+"&productid="+productid;
	$.ajax({
		type: "post",dataType:"json",url: url,
		success: function(msg){
			if(msg.status>0)
			{
				//window.console.info("a");
				//window.location = "license.jsp";
				top.TideDialogClose({refresh:'right'});
				return;				
			}
			else
			{
				alert(msg.message);
				//notify.html("<font color=red>"+msg.message+"</font>");
				//$("#submit_btn").attr("disabled","false").val("提交");
				return;	
			}
			//this.location = "license.jsp";
		},
		error: function() {
			alert("许可证提交失败");
		}
	});
}

</script>

</head>

<body  onload="">
<div class="bg-white modal-box">

	<form name="form" method="post" action="" onSubmit="return check();">

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
			<div class="config-box">	
				<ul>
					<!--基本信息-->
					<li class="block">
						<div class="row">                   		  	  	
							<label class="left-fn-title">产品名称：</label>
							<label class="wd-300">
								<%=product.getName()%>
							</label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title">代码证编号：</label>
							<label class="wd-300">
								<input name="code" class="form-control" type="text" id="code" value="">
							</label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title">许可证代码：</label>
							<label class="wd-300">
								<textarea name="license" id="license" rows="3" class="form-control textBox"></textarea>
							</label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title">机器码：</label>
							<label class="wd-300">
								<%=serverCode%>
							</label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title">注意事项：</label>
							<label class="wd-350">
								<font color=red><b>使用许可证编号更新要求后台服务器必须能够访问外网</b></font>
							</label>									            
						</div>
					</li>      	    
	       		</ul>             	
			</div>	                   
		</div><!-- modal-body -->
		
		<div class="btn-box">
      		<div class="modal-footer" >
				<input type="hidden" name="Submit" value="Submit">
				<input type="hidden" name="id" id="productid" value="<%=id%>">
				<button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="startButton" onClick="update()">确定</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
			</div> 
		</div>
		<div id="ajax_script" style="display:none;"></div> 
	  </form>	     
	</div><!-- br-mainpanel -->
</body>
</html>