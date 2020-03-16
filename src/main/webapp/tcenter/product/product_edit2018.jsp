<%@ page import="java.sql.*,
				org.json.*,
				tidemedia.cms.util.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(! userinfo_session.isAdministrator())
{response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

Product product = new Product(id);

String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{	
	String name = getParameter(request,"Name");//产品名称
	String logo = getParameter(request,"logo");//图标
	String url = getParameter(request,"Url");//地址
	int status = getIntParameter(request,"Status");//是否启用
	int groupId = getIntParameter(request,"group");//分组
	int newpage = getIntParameter(request,"newpage");//是否弹出
	int isview = getIntParameter(request,"isview");//编辑是否可见
	String summary = getParameter(request,"Summary");//产品描述


	product.setName(name);
	product.setUrl(url);
	product.setStatus(status);
	product.setGroupId(groupId);
	product.setLogo(logo);
	product.setNewpage(newpage);
	product.setUserId(userinfo_session.getId());
	product.setIsview(isview);
	product.setSummary(summary);

	product.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}
TideJson json = CmsCache.getParameter("tcenter_main").getJson();//首页模块
JSONArray arr = new JSONArray();
if(json!=null&&json.getInt("state")==1){
	arr = json.getJSONArray("main");
}

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
	/*tooltip相关样式*/
    .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
	.tooltip.bs-tooltip-right .arrow::before,
	.tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {			
		border-right-color: #00b297;			
	}
</style>  
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script type="text/javascript">
function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
			return false;
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

function showlogo()
{
	var url="icon_index.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(450);
		dialog.setUrl(url);
		dialog.setTitle("选择图标");
		dialog.show();
}
//子弹窗返回值
function setReturnValue(o) {
	if (o.icon != null) {
		$('#icon').html(o.icon);
		$('#logo').attr("value",o.icon);
	}
}
</script>

</head>

<body  onload="">
	<div class="bg-white modal-box">

		<form name="form" method="post" action="product_edit2018.jsp" onSubmit="return check();">

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
			<div class="config-box">	
				<ul>
					<!--基本信息-->
					<li class="block">
						<div class="row">                   		  	  	
							<label class="left-fn-title">产品名称：</label>
							<label class="wd-300">
								<input name="Name" class="form-control" type="text" value="<%=product.getName()%>">
							</label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title">产品图标：</label>
							<label id="icon" style="font-size: 24px;"><%=product.getLogo()%></label>
							<label class="wd-300 mg-l-10">
								<a href="javascript:showlogo();" class="btn btn-outline-info">选择</a>
								<input name="logo" id="logo" type="hidden" value='<%=product.getLogo()%>'>
							</label>									            
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title">产品地址：</label>
							<label class="wd-300">
								<input name="Url" id="Url" class="form-control" type="text" value="<%=product.getUrl()%>">
							</label>									            
						</div>
						<div class="row">
							<label class="left-fn-title">是否启用：</label>
							<label class="wd-300">
								<div class='toggle-wrapper'>
									<div class='toggle toggle-light primary' field='Status'  <%if(product.getStatus()==0){%>data-toggle-on='false'<%}else{%>data-toggle-on='true'<%}%>></div>
								</div>
							</label>
							<input name="Status" id="Status" type="hidden" value="<%=product.getStatus()%>">
						</div>
						<div class="row">
							<label class="left-fn-title">是否弹出：</label>
							<label class="wd-300">
								<div class='toggle-wrapper'>
									<div class='toggle toggle-light primary' field='newpage' <%if(product.getNewpage()==0){%>data-toggle-on='false'<%}else{%>data-toggle-on='true'<%}%>></div>
								</div>
							</label>
							<input name="newpage" id="newpage" type="hidden" value="<%=product.getNewpage()%>">
						</div>
						<div class="row">                   		  	  	
							<label class="left-fn-title">分组：</label>
							<label class="wd-300">
								<select class="form-control wd-230 ht-40 select2" name="group">
									<option value="1" <%if(product.getGroupId()==1){%>selected="selected"<%}%>>运营支撑</option>
									<option value="2" <%if(product.getGroupId()==2){%>selected="selected"<%}%>>应用发布</option>
									<option value="3" <%if(product.getGroupId()==3){%>selected="selected"<%}%>>资源汇聚</option>
									<option value="4" <%if(product.getGroupId()==4){%>selected="selected"<%}%>>生产工具</option>
									<%
									for(int i=0;i<arr.length();i++){
										JSONObject json1 = arr.getJSONObject(i);//一级分组
										JSONArray arr1 = json1.getJSONArray("module");
										for(int j=0;j<arr1.length();j++){
											JSONObject json2 = arr1.getJSONObject(j);
											String title = json2.getString("title");
											int id_ = json2.getInt("id");
									%>
									<option value="<%=id_%>" <%if(product.getGroupId()==id_){%>selected="selected"<%}%>><%=title%></option>	
									<%
										}
									}
									%>
								</select>
							</label>									            
						</div>
						<div class="row">
							<label class="left-fn-title">编辑是否可见：</label>
							<label class="wd-300">
								<div class='toggle-wrapper'>
									<div class='toggle toggle-light primary' field='isview' <%if(product.getIsview()==0){%>data-toggle-on='false'<%}else{%>data-toggle-on='true'<%}%>></div>
								</div>
							</label>
							<input name="isview" id="isview" type="hidden" value="<%=product.getIsview()%>">
						</div>
						<div class="row">
							<label class="left-fn-title">产品简介：</label>
							<label class="wd-300">
								<input name="Summary" class="form-control" type="text" value="<%=product.getSummary()%>">
							</label>
						</div>
					</li>      	    
	       		</ul>             	
			</div>	                   
		</div><!-- modal-body -->

		<div class="btn-box">
      		<div class="modal-footer" >
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		      <input type="hidden" name="Submit" value="Submit">
			  <input type="hidden" name="id" value="<%=id%>">
			</div> 
		</div>
		<div id="ajax_script" style="display:none;"></div> 
	  </form>	     
	</div><!-- br-mainpanel -->
</body>

<script type="text/javascript" src="../common/2018/common2018.js"></script>        
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script>

//获取是否开或关
$(".toggle").click(function(){
	var myToggle = $(this).data('toggle-active');
	var field = $(this).attr('field');

	if(myToggle){
		if(field=="Status")
			document.form.Status.value=1 ;//开
		else if(field=="newpage")
			document.form.newpage.value=1 ;
		else
			document.form.isview.value=1 ;
	}else{
		if(field=="Status")
			document.form.Status.value=0 ;//关
		else if(field=="newpage")
			document.form.newpage.value=0 ;
		else
			document.form.isview.value=0 ;
	}
})
</script>

</html>