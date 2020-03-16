<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
*	修改者		修改日期		备注	
*	郭庆光		20130902		确定、取消按钮样式修改  button-->tidecms_btn3
*
*/
if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

int userId = userinfo_session.getId();

int id = getIntParameter(request,"id");
UserInfo userinfo = new UserInfo(id);
String Site = userinfo.getSite();

if(userinfo.getRole()==1)
{
	if(!(new UserPerm().canManageAdminUser(userinfo_session)))
	{response.sendRedirect("../noperm.jsp");return;}
}

String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{
//	String			=	getParameter(request,"");
	String	Name		=	getParameter(request,"Name");
	String	Password	=	getParameter(request,"Password");
	String	Email		=	getParameter(request,"Email");
	String	Tel			=	getParameter(request,"Tel");
	String	Comment		=	getParameter(request,"Comment");
	String	ExpireDate	=	getParameter(request,"ExpireDate");
    int GroupID = getIntParameter(request,"GroupID");
	String	token	=	getParameter(request,"token");

	String	Sites[]		=	request.getParameterValues("Site");
	Site = Util.ArrayToString(Sites,",");
	System.out.println("Site:"+Site);
    
	int DisableChangeConfig			= getIntParameter(request,"DisableChangeConfig");
	int DisableChangePublish		= getIntParameter(request,"DisableChangePublish");
	int DisableAddPublishScheme		= getIntParameter(request,"DisableAddPublishScheme");
	int DisableEditPublishScheme	= getIntParameter(request,"DisableEditPublishScheme");
	int DisableManageAdminUser		= getIntParameter(request,"DisableManageAdminUser");
	int DisableManageUser			= getIntParameter(request,"DisableManageUser");
	userinfo.setToken(token);
	userinfo.setSite(Site);
	out.println("token="+token+",name="+Name);
//	u.set();
	userinfo.setName(Name);
	userinfo.setPassword(Password);
	userinfo.setEmail(Email);
	userinfo.setTel(Tel);
	userinfo.setComment(Comment);
    userinfo.setGroup(GroupID);
	userinfo.setExpireDate(ExpireDate);
	userinfo.addPermArray("DisableChangeConfig",DisableChangeConfig);
	userinfo.addPermArray("DisableChangePublish",DisableChangePublish);
	userinfo.addPermArray("DisableAddPublishScheme",DisableAddPublishScheme);
	userinfo.addPermArray("DisableEditPublishScheme",DisableEditPublishScheme);
	userinfo.addPermArray("DisableManageAdminUser",DisableManageAdminUser);
	userinfo.addPermArray("DisableManageUser",DisableManageUser);

	userinfo.setMessageType(2);
	userinfo.setActionUser(userinfo_session.getId());
	userinfo.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}

%>
<!DOCTYPE html>
<html >
<head>
<!-- Required meta tags -->
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
.modal-body .config-box label.ckbox {
    width: auto !important;
    margin-right: 20px;
}
/* 密码样式*/
#tips {float:left;margin-top:10px;}
#tips span {float:left;width:50px;height:20px;color:#fff;overflow:hidden;background:#ccc;margin-right:2px;line-height:20px;text-align:center;}
#tips.s1 .active{background:#f30;}
#tips.s2 .active{background:#fc0;}
#tips.s3  .active{background:#cc0;}
#tips.s4 .active{background:#090;}
#password{border:0;display: block;width: 100%;padding: .65rem .75rem;font-size: .875rem;line-height: 1.25;color: #495057;background-color: #fff;background-image: none;background-clip: padding-box;border: 1px solid rgba(0,0,0,.15);border-radius: 3px;transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;}
.left-fn-password{margin-top:-30px}
#telphohenum{display: none;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
	           
<script type="text/javascript">
var phonenumner ;	
var ischeckphone = true ;  //是否检测符合要求
	
$(document).ready(function() {
	tidecms.setDatePicker("#ExpireDate");
	
	$("#phone").blur(function(){
		phonenumner =  $("#phone").val();
		if(phonenumner==""){
			return ;
		}
		if (testphone(phonenumner) == false) {
			console.log("请核对您的手机号码");
			$("#telphohenum").text("请输入正确的手机号码!").show();
			//return false;
			ischeckphone = false;
		}else{
			checkPhone(phonenumner)
			//$("#telphohenum").hide();
		}
	});
	
});

//验证手机号格式
function testphone(tel) {
	var strTemp = /^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (strTemp.test(tel)) {
		return true;
	}
	return false;
}

//检查手机号
function checkPhone(phonenumner){
	$.ajax({
		type : "get",
		url : "checkPhone.jsp?phone="+phonenumner+"&userId=<%=id%>",
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
	var name = $("#name").val();
	if(name==""){
		alert("姓名不能为空");
		return false;
	}
    //手机号绑定验证
    phonenumner =  $("#phone").val();
    if(phonenumner!="" && !ischeckphone){
    	$("#telphohenum").show();
    	$("#phone").focus();
    	return false;
    }	
	
	if(document.form.Password.value == "******")
		document.form.Password.value = "";
	else{
		var uname = "<%=userinfo.getUsername()%>";
		var role = "<%=userinfo.getRoleName()%>";
		var pwd = $('#password').val();
		if(uname==pwd){
			alert("用户名密码不能相同");
			$("#password").val("");
			$("#password").focus();
			return false;
		}else{
		    if(!pwd.equals("")){
    			if(role=="系统管理员" && pwd.length<8){
    				alert("系统管理员的密码长度不能小于8位");
    				$("#password").focus();
    				return false;
    			}else if((role=="频道管理员" || role=="编辑" )&& pwd.length<6){
    				alert("频道管理员或编辑的密码长度不能少于6位");
    				$("#password").focus();
    				return false;
    			}else{
    				return true;
    			}
			}
		}
	}
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

function show(i)
{
	if(i==0)
	{
		info.style.display="";
		permission.style.display = "none";
	}

	if(i==1)
	{
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
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  </style>  
  </head>
  <body class="">
    <div class="bg-white modal-box">
 <form  name="form" action="user_edit2018.jsp" method="POST" onSubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block"> 		  	  
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">登录名：</label>
		              <label class="wd-300">
		                 <span><%=userinfo.getUsername()%></span>
		              </label>	
                     				  
	   		  	</div>
				<div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title left-fn-password">密码：</label>
			              <label class="wd-300" >
			                <input name="Password" class="form-control" placeholder="" value="" type="Password" id="password">
			                <div id="tips"> <span id="pas_1"></span> <span id="pas_2"></span> <span id="pas_3"></span> <span id="pas_4"></span> </div>
			              </label>									            
	       		 </div>
				 <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">姓名：</label>
			              <label class="wd-300" >
			                <input name="Name" value="<%=userinfo.getName()%>" id="name" class="form-control" placeholder="" type="text">
			              </label>									            
	       		 </div>				 
	   		  	 <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">电子邮件：</label>
			              <label class="wd-300" >
			                <input name="Email" class="form-control" placeholder="" type="text" value="<%=userinfo.getEmail()%>" >
			              </label>									            
	       		 </div>	
                   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">电话：</label>
			              <label class="wd-300" >
			                <input name="Tel" class="form-control" placeholder="" type="text" value="<%=userinfo.getTel()%>" id="phone">
						  </label>	
						  <font color="red" class="mg-l-10" id="telphohenum" style="">请输入正确的手机号码</font>								            
	       		 </div>		
                  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">备注：</label>
			              <label class="wd-300" >
			                <input name="Comment" class="form-control" placeholder="" type="text" value="<%=userinfo.getComment()%>" >
			              </label>									            
	       		 </div>	
                 <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">令牌：</label>
			              <label class="wd-300" >
			                <input id="token"name="token" class="form-control" placeholder="" type="text" value="<%=userinfo.getToken()%>" >
			              </label>	
                           <input class="tidecms_btn3" href="javascript:;" type="button" class="block" value="生成令牌" onclick="getToken();">						  
	       		 </div>		
				<div class="row "> 
	       		  	  	 <label class="left-fn-title">角色：</label>
			              <label class="wd-300">
			               <span><%=userinfo.getRoleName()%></span>
			              </label>
			             					  
       		  	  	  </div>
					  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">账号到期时间：</label>
			              <label class="wd-300" >
			                <input value="<%=userinfo.getExpireDate()%>" id="ExpireDate" name="ExpireDate" class="form-control" placeholder="" type="text" >
			              </label>									            
	       		      </div>
					  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">组名：</label>			    
							   <label class="wd-230">
								<select class="form-control wd-230 ht-40 select2"  name="GroupID">
									<option name="function" value="0">请选择</option>
									 <%
										UserGroup userGroup=new UserGroup();
										List groups=userGroup.getGroups();
										Iterator iter=groups.iterator();
										while(iter.hasNext()){
										UserGroup  groupOne=(UserGroup)iter.next();
										if(groupOne.getId()!=userinfo.getGroup()){
													out.println("<option value=\""+groupOne.getId()+"\">"+groupOne.getName()+"</option>");
										}else{
										out.println("<option value=\""+groupOne.getId()+"\"  selected>"+groupOne.getName()+"</option>");
										}
										}
										 %> 
								</select>
							</label>						            
	       		     </div>
					 <div class="row" id="Site" hidden="hidden">
<label class="left-fn-title">站点：</label><label class="wd-content-ckx d-flex" id="field_ctype">
<%
Map sites = CmsCache.getSites();
Iterator iter2 = sites.entrySet().iterator();
while (iter2.hasNext()) {
	//Site  site =(Site)iter2.next();
	Map.Entry entry = (Map.Entry) iter2.next();
	Object key = entry.getKey();
	Site  site = (Site)entry.getValue();
	String site1 = ","+userinfo.getSite()+",";
	String site2 = ","+site.getId()+",";
	
	out.println("<label class=\"rdiobox\">");//+site1+"_"+site2);
	if(userinfo.getSite().equals(site.getId()+"")){
	out.println("<input type=\"radio\" name=\"Site\" class=\"textfield\" checked value=\""+site.getId()+"\">");
	}else{
	out.println("<input type=\"radio\" name=\"Site\" class=\"textfield\" value=\""+site.getId()+"\">");
	}
	out.println("<span class=\"d-inline-block\">"+site.getName()+"</span></label>");
}
%> 					
	       			 </div>
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		      <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		      <input type="hidden" name="Submit" value="Submit">
	          <input type="hidden" name="id" value="<%=id%>">
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
