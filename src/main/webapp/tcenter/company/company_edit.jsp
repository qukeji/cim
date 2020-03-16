<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.text.*,
				java.net.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");//租户编号
//获取租户关联的站点
//String cms_api = CmsCache.getParameter("cms_api").getContent();
//String cms_api = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/tcenter";
String url = "http://127.0.0.1:888/tcenter/api/company/site_list.jsp?company="+id+"&type=3";

String result = Util.connectHttpUrl(url);
JSONObject json = new JSONObject(result);
JSONArray arr = json.getJSONArray("sites");
String sites = "";
String siteNames = "";
for(int i=0;i<arr.length();i++){
	JSONObject job = arr.getJSONObject(i); 
	if(!sites.equals("")){
		sites += ",";
		siteNames += ",";
	}
	sites += job.get("siteId");
	siteNames += job.get("siteName");
}
//获取租户关联的系统管理员
String userNames = "";
String users = "";
ArrayList<UserInfo> userList = new Company().getUserList(id);//租户管理员
for(int i=0;i<userList.size();i++){
	UserInfo userinfo = userList.get(i);
	if(!userNames.equals("")){
		userNames += ",";
		users += ",";
	}
	userNames += userinfo.getName();
	users += userinfo.getId();
}

Company company = new Company(id);
String	Name = company.getName();
String	ExpireDate = company.getExpireDate();
int jurong = company.getJurong();
int JuxianID = company.getJuxianID();
String JuxianToken = company.getJuxianToken();
String jurong_ = "false";
if(jurong==1){
	jurong_ = "true";
}
String	user = company.getUser();
String	phone = company.getPhone();
String	logo = company.getLogo();
int space =	company.getSpace();

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	Name		= getParameter(request,"Name");
	ExpireDate	= getParameter(request,"ExpireDate");
	jurong		= getIntParameter(request,"jurong");
	JuxianID	= getIntParameter(request,"JuxianID");
	JuxianToken = getParameter(request,"JuxianToken");
	sites		= getParameter(request,"sites");
	users		= getParameter(request,"users");

	user		= getParameter(request,"user");
	phone		= getParameter(request,"phone");
	logo		= getParameter(request,"logo");
	space		= getIntParameter(request,"space");
	
	company.setName(Name);//租户名称
	company.setExpireDate(ExpireDate);//到期时间
	company.setJurong(jurong);//聚融业务
	company.setJuxianID(JuxianID);//云平台企业编号
	company.setJuxianToken(JuxianToken);//聚现云企业token
	company.setUserId(userinfo_session.getId());//操作人
	company.setCompanyUser(users);
	company.setUser(user);//联系人
	company.setPhone(phone);//联系人电话
	company.setLogo(logo);//
	company.setSpace(space);//空间
	company.setRequest(request);
	company.Update();

	
	if(id!=0){
		String token = CmsCache.addToken("channel_edit");
		Name = URLEncoder.encode(Name,"utf-8");
		Product product = new Product("TideCMS");
		
		String scheme = request.getScheme() ;
		String port = ""+request.getLocalPort() ;
		if(scheme.equals("https")) port = "888" ;

		//关联站点，创建频道
		url = "http://127.0.0.1:"+port+"/"+product.getUrl()+"/system/company_channel_update.jsp?company="+id+"&token="+token+"&companyName="+Name+"&sites="+sites+"&userid="+userinfo_session.getId();
		Util.connectHttpUrl(url,"utf-8");

		//开启聚融创建频道
		product = new Product("TideVMS");
		url = "http://127.0.0.1:"+port+"/"+product.getUrl()+"/system/company_channel_update.jsp?company="+id+"&token="+token+"&companyName="+Name+"&userid="+userinfo_session.getId();
		Util.connectHttpUrl(url,"utf-8");
	}
	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}

%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
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
	
	$(document).ready(function() {
		tidecms.setDatePicker("#ExpireDate");
	});

	function check()
	{
		if(isEmpty(document.form.Name,"请输入名称."))
			return false;

		$("#startButton").attr('disabled',true);
		return true;
	}
	//选择站点
	function showSite(){
		var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(450);
		dialog.setUrl("site_index.jsp?id=<%=id%>");
		dialog.setTitle("选择站点");
		dialog.show();
	}
	//选择管理员
	function showUser(){
		var companyid = <%=userinfo_session.getCompany()%>;//当前用户的租户
		if(companyid!=0){//说明是租户管理员，不可编辑用户
			alert("无权限!");
			return ;
		}
		var users = $('#users').val();
		var	dialog = new top.TideDialog();
		dialog.setWidth(800);
		dialog.setHeight(500);
		dialog.setUrl("../../user/user_index.jsp?users="+users+"&company=<%=id%>");
		dialog.setTitle("选择用户");
		dialog.show();
	}
	//子弹窗返回值
	function setReturnValue(o) {
		if (o.sites != null) {
			$('#sites').val(o.sites);
			$('#sitenames').attr("value",o.sitenames);
		}
		if(o.users != null){
			$('#users').val(o.users);
			$('#Usernames').attr("value",o.Usernames);
		}
	}

</script>
  
</head>

<body class="" >
    <div class="bg-white modal-box">
	  <form name="form" action="company_edit.jsp" method="POST" onSubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	  <!--基本信息-->
	       		  <li class="block">
				 
					<div class="row">                   		  	  	
						<label class="left-fn-title">租户名称：</label>
						<label class="wd-300">
							<input name="Name" class="form-control" placeholder="" type="text" value="<%=Name%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">站点：</label>
						<label class="wd-300">
							<input name="sitenames" id="sitenames" class="form-control" placeholder="" type="text" value="<%=siteNames%>" onclick="showSite()" readonly="true">
							<input name="sites" id="sites" type="hidden" value="<%=sites%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">管理员：</label>
						<label class="wd-300">
							<input name="Usernames" id="Usernames" class="form-control" placeholder="" type="text" value="<%=userNames%>" onclick="showUser()" readonly="true">
							<input name="users" id="users" type="hidden" value="<%=users%>">
						</label>									            
					</div>
					<div class="row">
						<label class="left-fn-title">是否开启聚融：</label>
						<label class="wd-300">
							<div class='toggle-wrapper'>
								<div class='toggle toggle-light primary' data-toggle-on='<%=jurong_%>'></div>
							</div>
						</label>
						<input name="jurong" id="jurong" type="hidden" value="<%=jurong%>">
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">云平台企业编号：</label>
						<label class="wd-300">
							<input name="JuxianID" class="form-control" placeholder="" type="text" value="<%=JuxianID%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">云平台企业Token：</label>
						<label class="wd-300">
							<input name="JuxianToken" class="form-control" placeholder="" type="text" value="<%=JuxianToken%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">联系人：</label>
						<label class="wd-300">
							<input name="user" class="form-control" placeholder="" type="text" value="<%=user%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">联系人电话：</label>
						<label class="wd-300">
							<input name="phone" class="form-control" placeholder="" type="text" value="<%=phone%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">LOGO：</label>
						<label class="wd-300">
							<input name="logo" class="form-control" placeholder="" type="text" value="<%=logo%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">空间：</label>
						<label class="wd-300">
							<input name="space" class="form-control" placeholder="" type="text" value="<%=space%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">授权到期时间：</label>
						<label class="wd-300" >
							<input value="<%=ExpireDate%>" id="ExpireDate" name="ExpireDate" class="form-control" placeholder="" type="text" >
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
<script>
//开关相关
//初始化
$('.toggle').toggles({        
  height: 25
});
//获取是否开或关
$(".toggle").click(function(){
	var myToggle = $(this).data('toggle-active');

	if(myToggle){
		document.form.jurong.value=1 ;//开
	}else{
		document.form.jurong.value=0 ;//关
	}
})
</script>
</html>
