<%@ page import="tidemedia.cms.system.*,
				org.apache.tools.zip.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.io.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

if(! userinfo_session.isAdministrator())
{
	response.sendRedirect("../noperm.jsp");
	return;
}

int itemid  = getIntParameter(request,"itemid");
Navigation n = new Navigation(itemid);
String Title	= n.getTitle();//标题
String Href		= n.getHref();//地址
int level		= n.getLevel();//层级
int Parent		= n.getParent();//父导航
int newpage		= n.getNewpage();

String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{	
	Title	= getParameter(request,"Title");//标题
	Href	= getParameter(request,"Href");//地址
	newpage = getIntParameter(request,"newpage");
	n.setTitle(Title);
	n.setHref(Href);
	n.setNewpage(newpage);
	n.setUserId(userinfo_session.getId());
	n.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}

%>
<!DOCTYPE html>
<html  id="green">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<!-- Meta -->
<title>TideCMS</title>

<!-- vendor css -->
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet"> 
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">

<!-- Bracket CSS -->
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
	/*tooltip相关样式*/
	#green .toggle-light.primary .toggle-on.active {
		background-color: #00e266;
	}
	#green .toggle-light.primary .toggle-on.active+.toggle-blob {
		border: 3px solid #00e266;
	}
    .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
	.tooltip.bs-tooltip-right .arrow::before,
	.tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {			
		border-right-color: #00b297;			
	}
</style>  

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
				
<script>

function check()
{	
	if($("#Title").val()=="")
	{
		TideAlert("提示","导航标题不能为空！");
	}
	else
	{
		var Title = $("#Title").val();
		//跳转处理确定按钮的jsp
		var url="check_hasnavigation.jsp?itemid="+<%=itemid%>+"&Parent=<%=Parent%>"+"&Title="+encodeURIComponent(encodeURIComponent(Title));
		$.ajax({
			type: "get",
			url: url,
			success: function(msg){
			 
				if(msg==1){
					TideAlert("提示","该记录已在本级存在！");
				}else{
					$("#jobform").submit();
				}
			}
		});
	}
}


</script>                   

</head>
<body>
<div class="bg-white modal-box">
     <form name="form" action="navigation_edit.jsp?itemid=<%=itemid%>&Submit=Submit" method="post" id="jobform">
		<div class="modal-body modal-body-btn pd-20 overflow-y-auto" id="form1">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">	       		 				 
	   		  		<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">名称：</label>
		              <label class="wd-300">
		                <input name="Title" id="Title" size="32"  class="form-control" placeholder="" type="text"  value="<%=Title%>">
		              </label>									            
	   		  		</div>   
					<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">地址：</label>
		              <label class="wd-300">
		                <input name="Href" id="Href" size="32"  class="form-control" placeholder="" type="text"  value="<%=Href%>">
		              </label>									            
	   		  		</div>
					<div class="row">
						<label class="left-fn-title">是否弹出：</label>
						<label class="wd-300">
							<div class='toggle-wrapper'>
								<div class='toggle toggle-light primary' <%if(n.getNewpage()==0){%>data-toggle-on='false'<%}else{%>data-toggle-on='true'<%}%> field='newpage'></div>
							</div>
						</label>
						<input name="newpage" id="newpage" type="hidden" value="<%=n.getNewpage()%>">
					</div>
				  </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->

		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
			<div class="modal-footer">
			   <input type="hidden" name="CopyMode"  id="CopyMode" value="1">
				<input type="hidden" name="Submit" value="Submit">
				<input type="hidden" name="SiteId" value="">
				<button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="startButton" onclick="check()">确认</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
				</button>
			</div>
		</div>
		<div id="ajax_script" style="display:none;"></div>
	</form>
</div>
<!-- modal-box -->
</body>
                     
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>

//获取是否开或关
$(".toggle").click(function(){
	var myToggle = $(this).data('toggle-active');

	if(myToggle){
		document.form.newpage.value=1 ;
	}else{
		document.form.newpage.value=0 ;
	}
})
</script>
</html>