<%@ page import="java.sql.*,
				java.text.*,
				java.util.*,
				tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");
int	GroupID = getIntParameter(request,"GroupID");
int	company = getIntParameter(request,"company");

int renewalsdata = 2;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
java.util.Date now = new java.util.Date();
Calendar calendar = Calendar.getInstance();
calendar.setTime(now);
//System.out.println(sdf.format(calendar.getTime()));
calendar.add(Calendar.MONTH, renewalsdata);
//System.out.println(sdf.format(calendar.getTime()));
String duetime = sdf.format(calendar.getTime());

if(Submit.equals("Submit"))
{
	String	Name		=	getParameter(request,"Name");
	String	Username	=	getParameter(request,"Username");
	String	Password	=	getParameter(request,"Password");
	String	Email		=	getParameter(request,"Email");
	String	Tel			=	getParameter(request,"Tel");
	String	Comment		=	getParameter(request,"Comment");
	String	ExpireDate	=	getParameter(request,"ExpireDate");
	String	token	=	getParameter(request,"token");
	String	Sites[]		=	request.getParameterValues("Site");
	String Site = Util.ArrayToString(Sites,",");

	int		Role		=	getIntParameter(request,"Role");

	int DisableChangeConfig			= getIntParameter(request,"DisableChangeConfig");
	int DisableChangePublish		= getIntParameter(request,"DisableChangePublish");
	int DisableAddPublishScheme		= getIntParameter(request,"DisableAddPublishScheme");
	//int DisableEditPublishScheme	= getIntParameter(request,"DisableEditPublishScheme");
	int DisableEditPublishScheme    = 0;
	int DisableManageAdminUser		= getIntParameter(request,"DisableManageAdminUser");
	int DisableManageUser			= getIntParameter(request,"DisableManageUser");
	int DisableDeleteChannel		= getIntParameter(request,"DisableDeleteChannel");

	int EnableVblogPreApprove		= getIntParameter(request,"EnableVblogPreApprove");
	int EnableVblogApprove			= getIntParameter(request,"EnableVblogApprove");
	int EnableVblogPigeonhole		= getIntParameter(request,"EnableVblogPigeonhole");

	String ChannelList				= getParameter(request,"ChannelList");
	String PermList					= getParameter(request,"PermList");

	UserInfo userinfo = new UserInfo();

//	u.set();
	userinfo.setName(Name);
	userinfo.setUsername(Username);
	userinfo.setPassword(Password);
	userinfo.setEmail(Email);
	userinfo.setTel(Tel);
	userinfo.setComment(Comment);
	userinfo.setExpireDate(ExpireDate);
	userinfo.setRole(Role);
	userinfo.setSite(Site);
	userinfo.setGroup(GroupID);
	userinfo.setCompany(company);
	userinfo.setToken(token);

	if(Role==1)
	{
		userinfo.addPermArray("DisableChangeConfig",DisableChangeConfig);
		userinfo.addPermArray("DisableChangePublish",DisableChangePublish);
		userinfo.addPermArray("DisableAddPublishScheme",DisableAddPublishScheme);
		if(DisableAddPublishScheme==1){
           DisableEditPublishScheme=1;
		}
		userinfo.addPermArray("DisableEditPublishScheme",DisableEditPublishScheme);
		userinfo.addPermArray("DisableManageAdminUser",DisableManageAdminUser);
		userinfo.addPermArray("DisableManageUser",DisableManageUser);
		userinfo.addPermArray("DisableDeleteChannel",DisableDeleteChannel);
		userinfo.addPermArray("OperateSystem",1);//系统管理员默认有运营中心权限
	}else if(Role==5)
	{
		userinfo.addPermArray("EnableVblogPreApprove",EnableVblogPreApprove);
		userinfo.addPermArray("EnableVblogApprove",EnableVblogApprove);
		userinfo.addPermArray("EnableVblogPigeonhole",EnableVblogPigeonhole);
	}
	else
	{
		System.out.println("ChannelList:"+ChannelList);
		userinfo.setChannelList(ChannelList);
		userinfo.setPermList(PermList);
	}

	userinfo.setActionUser(userinfo_session.getId());
	userinfo.Add();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}

%>
<!DOCTYPE html>
<html >
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>

<!-- vendor css -->
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">   
<!-- Bracket CSS -->
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">	

<style type="text/css">
html,body{width: 100%;height: 100%;}
.modal-body .config-box label.ckbox {width: auto !important;margin-right: 20px;}
/* 密码样式*/
#tips {float:left;margin-top:10px;}
#tips span {float:left;width:50px;height:20px;color:#fff;overflow:hidden;background:#ccc;margin-right:2px;line-height:20px;text-align:center;}
#tips.s1 .active{background:#f30;}
#tips.s2 .active{background:#fc0;}
#tips.s3  .active{background:#cc0;}
#tips.s4 .active{background:#090;}
#password{border:0;display: block;width: 100%;padding: .65rem .75rem;font-size: .875rem;line-height: 1.25;color: #495057;background-color: #fff;background-image: none;background-clip: padding-box;border: 1px solid rgba(0,0,0,.15);border-radius: 3px;transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;}
.left-fn-password{margin-top:-30px}
#username1, #telphohenum{display: none;}
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
	           
<script type="text/javascript">
var uname;
var phonenumner ;

$(document).ready(function() {
	tidecms.setDatePicker("#ExpireDate");
	
	$("#username").focus();
	
	$("#username").blur(function(){
		uname =  $("#username").val();
		if(uname!==''){
			checkName(uname) ;
		}
	});

	$("input[name='Role']").click(function(){
		var $svalue = $(this).val();
		if ($svalue == 4) { 
			$("#Site").show();
		}else {
			$("#Site").hide();
		}
	});
	
	$("#phone").blur(function(){
		phonenumner =  $("#phone").val();
		if(phonenumner==""){
			return ;
		}
		if (testphone(phonenumner) == false) {
			console.log("请核对您的手机号码");
			$("#telphohenum").text("请输入正确的手机号码!").show();
			//return false;
		}else{
			
			checkPhone(phonenumner)
			//$("#telphohenum").hide();
		}
	});
	
});



function testphone(tel) {
	var strTemp = /^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (strTemp.test(tel)) {
		return true;
	}
	return false;
}
var ischeckphone = false ;  //是否检测符合要求
var ischeckname = false ;

//检查用户名
function checkName(_uname){
	$.ajax({
		type:"get",
		url:"checkuser.jsp",
		data:"username="+_uname,
		async : false ,
		success: function(msg){
			if(msg==1){
				$("#username1").text("用户名重复!").show();
				ischeckname = false ;
		    }else{
				$("#username1").hide();   
			    ischeckname = true ;
			}	
		}
	});
}

//检查手机号
function checkPhone(phonenumner){
	$.ajax({
		type : "get",
		url : "checkPhone.jsp?phone="+phonenumner+"&type=1",
		async : false ,
		success : function(data){
			var result = data.trim();
			if(result!=""){
				$("#telphohenum").text("手机号已被绑定!").show();
				ischeckphone = false ;
			}else{
				$("#telphohenum").hide();
				ischeckphone = true ;
			}
		}
	});
}

function check(){
	// if(isEmpty(document.form.Username,"请输入登录名."))
	// 	return false;
	uname = $("#username").val();
	if(uname==""){
		$("#username1").text("请输入登录名！").show();
		$("#username").focus()
		return false;
	}else if(uname!="" && !ischeckname){
		$("#username1").show();
		$("#username").focus()
		return false;
	}	
	
	if(isEmpty(document.form.Name,"请输入姓名!"))
		return false;
	
	if(isEmpty(document.form.Password,"请输入密码!"))
		return false;
   
	phonenumner =  $("#phone").val();
	
	if(phonenumner!="" && !ischeckphone){
		$("#telphohenum").show();
		$("#phone").focus();
		return false;
	}	
	
	var Role_Checked = "0";
	var pwd =  $("#password").val();
	for(var i = 0;i<document.form.Role.length;i++){
		if(document.form.Role[i].checked=="1")
			Role_Checked = "1";
	}
	if(Role_Checked=="0"){
		alert("请选择角色.");
		return false;
	}
	var rolevalue =  $('input:radio:checked').val();//value=1 为系统管理员 密码不能少于6位  其它 不能少于6位

	if(rolevalue==1 && pwd.length<6){
		alert("系统管理员的密码长度不能少于6位");
		return false;
	}else if((rolevalue==2 || rolevalue==3) && pwd.length<6 ){
		alert("频道管理员或编辑的密码长度不能少于6位");
		return false;
	}
	
	if(uname!="" && pwd!="" && uname==pwd){
		alert("用户名密码不能相同");
		$("#password").val("");
		$("#password").focus();
		return false;
	}

	
	return true;
}

function isEmpty(field,msg){	
	if(field.value == ""){
		alert(msg);
		field.focus();
		return true;
	}
	return false;
}

function init(){
	var Obj = top.Obj;

}

function show(i){
	if(i==0){
		info.style.display="";
		permission.style.display = "none";
	}
	if(i==1){
		info.style.display="none";
		permission.style.display = "";
	}
}
function getToken(){
	$.ajax({
		type:"post",
		async:false,
		url:"user_gettoken.jsp",
		success:function(msg){
			//alert(msg);
			$("#token").val(msg);
		}
	});
}
 

</script>
</head>
<body class="" onload="init();">
	<div class="bg-white modal-box">

	<form  name="form" action="user_add2018.jsp" method="POST" onSubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		<li class="block"> 		  	  
	   		  	<div class="row">                   		  	  	
					<label class="left-fn-title">登录账户名：</label>
					<label class="wd-300">
						<input name="Username" id="username" class="form-control" placeholder="" type="text">
					</label>	
					<font color="red" class="mg-l-10" id="username1">登录名重复</font>					  
	   		  	</div>
				<div class="row">                   		  	  	
					<label class="left-fn-title">姓名：</label>
					<label class="wd-300" >
						<input name="Name" class="form-control" placeholder="" type="text">
					</label>									            
	       		</div>
				<div class="row">                   		  	  	
					<label class="left-fn-title left-fn-password">密码：</label>
					<label class="wd-300" >
						<input name="Password" class="form-control" placeholder="" type="Password" id="password" >
					   	<div id="tips"> <span></span> <span></span> <span></span> <span></span> </div>
					</label>
					</label>
				
	       		</div>
	       		
	   		  	<div class="row">                   		  	  	
	   		  		<label class="left-fn-title">电子邮件：</label>
			        <label class="wd-300" >
			            <input name="Email" class="form-control" placeholder="" type="text" >
			        </label>									            
	       		</div>	
                <div class="row">                   		  	  	
					<label class="left-fn-title">电话：</label>
					<label class="wd-300" >
						<input name="Tel" class="form-control" placeholder="" type="text" id="phone">
					</label>
					<font color="red" class="mg-l-10" id="telphohenum">请输入正确的手机号码</font>
	       		</div>		
                <div class="row">                   		  	  	
					<label class="left-fn-title">备注：</label>
					<label class="wd-300" >
						<input name="Comment" class="form-control" placeholder="" type="text" >
					</label>									            
	       		</div>	
                <div class="row">                   		  	  	
					<label class="left-fn-title">令牌：</label>
					<label class="wd-300" >
						<input id="token"name="token" class="form-control" placeholder="" type="text" >
					</label>	
					<input class="tidecms_btn3" href="javascript:;" type="button" class="block" value="生成令牌" onclick="getToken();">						  
	       		</div>

				<div class="row "> 
					<label class="left-fn-title">角色：</label>
					<label class="rdiobox">
						<input type="radio" id="s001" name="Role" value="1" ><span class="d-inline-block">系统管理员</span>
					</label>
					<label class="rdiobox" style="display:none;">
						<input type="radio" id="s002" name="Role" value="4" ><span class="d-inline-block">站点管理员</span>
					</label>
					<label class="rdiobox" style="display:none;">
						<input type="radio" id="s003" name="Role" value="2"><span class="d-inline-block">频道管理员</span>
					</label>
					<label class="rdiobox">
						<input type="radio" id="s004" name="Role" value="3" checked><span class="d-inline-block">编辑</span>
					</label>						  
       		  	</div>
				<div class="row" id="Site" style="display:none"  hidden="hidden">                   		  	  	
<label class="left-fn-title">站点：</label><label class="wd-content-ckx d-flex" id="field_ctype">
<%
Map sites = CmsCache.getSites();
Iterator iter2 = sites.entrySet().iterator();
while (iter2.hasNext()) {
	Map.Entry entry = (Map.Entry) iter2.next();
	Object key = entry.getKey();
	Site  site = (Site)entry.getValue();
	
	out.println("<label class=\"rdiobox\">");//+site1+"_"+site2);

	out.println("<input type=\"radio\" name=\"Site\" value=\""+site.getId()+"\">");
	
	out.println("<span class=\"d-inline-block\">"+site.getName()+"</span></label>");
}
%> 					
	       		</div>
				<div class="row">                   		  	  	
					<label class="left-fn-title">账号到期时间：</label>
					<label class="wd-300" >
						<input value="<%=duetime%>" id="ExpireDate" name="ExpireDate" class="form-control" placeholder="" type="text" >
					</label>									            
				</div>
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->

		<div class="btn-box">
      		<div class="modal-footer" >
			  <input type="hidden" name="Submit" value="Submit">
	          <input type="hidden" name="GroupID" value="<%=GroupID%>">
	          <input type="hidden" name="company" value="<%=company%>">
		      <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
			</div> 
		</div>
		<div id="ajax_script" style="display:none;"></div> 
	</form>	
	
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->   
</body>
               
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
</html>
<script type="text/javascript">
//检测密码强度
 $("#password").val('');
 $(function(){
	 var oTips = document.getElementById("tips");
	 var oInput =document.getElementById("password")
	 var aSpan = oTips.getElementsByTagName("span");
	 var aStr = ["弱", "中", "强", "很强"];
	 var i = 0;
	 oInput.onkeyup = oInput.onfocus = oInput.onblur = function() {
	   var index = checkStrong(this.value);
	   this.className = index ? "correct": "error";
	   oTips.className = "s" + index;
	   for (i = 0; i < aSpan.length; i++) aSpan[i].className = aSpan[i].innerHTML = "";
	   index && (aSpan[index - 1].className = "active", aSpan[index - 1].innerHTML = aStr[index - 1])
	 }
	 $("#password").val('')
 })

function checkStrong(sValue) {
   var modes = 0;
   if (sValue.length == 2) return 1;
   if (sValue.length == 3) return 1;
   if (sValue.length == 4) return 1;
   if (sValue.length == 5) return 1;
   if (sValue.length == 6) return 1;
   if (/\d/.test(sValue)) modes++; //数字
   if (/[a-z]/.test(sValue)) modes++; //小写
   if (/[A-Z]/.test(sValue)) modes++; //大写  
   //if (/\W/.test(sValue)) modes++; //特殊字符
   if ( /[`~!@#$%^&*()_\-+=<>?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、]/im.test(sValue)) modes++; //特殊字符
   switch (modes) {
    case 1:
      return 1;
      break;
    case 2:
      return 2;
    case 3:
    case 4:
      return sValue.length < 12 ? 3 : 4
      break;
   }
  
 }

</script>
