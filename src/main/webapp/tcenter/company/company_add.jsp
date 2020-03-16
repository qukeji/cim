<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.util.*,
				java.net.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int renewalsdata = 2;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
java.util.Date now = new java.util.Date();
Calendar calendar = Calendar.getInstance();
calendar.setTime(now);
calendar.add(Calendar.MONTH, renewalsdata);
String duetime = sdf.format(calendar.getTime());

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	//租户基本信息
	String	Name			=	getParameter(request,"companyName");
	String	user			=	getParameter(request,"user");
	String	phone			=	getParameter(request,"phone");
	String	logo			=	getParameter(request,"logo");
	int space				=	getIntParameter(request,"space");
	String	ExpireDate		=	getParameter(request,"ExpireDate");

	//聚现
	int JuxianID			=	getIntParameter(request,"JuxianID");
	String JuxianToken		=	getParameter(request,"JuxianToken");

	//租户管理员
	String	userName		=	getParameter(request,"name");
	String	loginName		=	getParameter(request,"loginName");
	String	Password		=	getParameter(request,"Password");
	String	juxian_phone	=	getParameter(request,"Tel");
	
	//租户站点
	String	siteName		=	getParameter(request,"siteName");
	int app					=	getIntParameter(request,"app");
	int web					=	getIntParameter(request,"web");

	Company company = new Company();
	company.setName(Name);//租户名称
	company.setUser(user);//联系人
	company.setPhone(phone);//联系人电话
	company.setLogo(logo);//
	company.setSpace(space);//空间
	company.setExpireDate(ExpireDate);//到期时间

	company.setUserName(userName);
	company.setLoginName(loginName);
	company.setPassword(Password);
	company.setJuxian_phone(juxian_phone);//聚现登录用户

	company.setJurong(1);//聚融业务
	company.setJuxianID(JuxianID);//云平台企业编号
	company.setJuxianToken(JuxianToken);//聚现企业token
	company.setStatus(1);//是否启动
	company.setUserId(userinfo_session.getId());//操作人	
	company.setRequest(request);
	company.Add();
	int companyId = company.getId();
	
	
	if(companyId!=0){
		String token = CmsCache.addToken("channel_add");
		Name = URLEncoder.encode(Name,"utf-8");
		siteName = URLEncoder.encode(siteName,"utf-8");
		String url = "";

		String scheme = request.getScheme() ;
		String port = ""+request.getLocalPort() ;
		if(scheme.equals("https")) port = "888" ;

		//创建站点，创建频道
		Product product = new Product("TideCMS");
		url = "http://127.0.0.1:"+port+"/"+product.getUrl()+"/system/company_channel_add.jsp?company="+companyId+"&token="+token+"&companyName="+Name+"&app="+app+"&web="+web+"&siteName="+siteName+"&userid="+userinfo_session.getId();
		Util.connectHttpUrl(url,"utf-8");

		product = new Product("TideVMS");
		url = "http://127.0.0.1:"+port+"/"+product.getUrl()+"/system/company_channel_add.jsp?company="+companyId+"&token="+token+"&companyName="+Name+"&userid="+userinfo_session.getId();
		Util.connectHttpUrl(url,"utf-8");
	}

	out.println("<script>window.parent.frames[\"content_frame\"].src =\"company_list.jsp\"; </script>");
	
	return;
}

String system_logo = CmsCache.getParameter("system_logo").getContent();

%>
<!DOCTYPE html>
<html id="green">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../<%=ico%>">
<title><%=title_%></title>
  
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/summernote/summernote-bs4.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet"  type="text/css" href="../style/jquery.tagit.css" />
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
<link rel="stylesheet"  type="text/css" href="../style/timepicker/jquery-ui-timepicker-addon.css" />
<link rel="stylesheet" href="../style/2018/bracket.css"> 

<style>
	.collapsed-menu .br-mainpanel-file{margin-left: 0px;margin-bottom: 30px;margin-top:0;}		
	#nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
	#nav-header a{color: #a4aab0;}
	.table-bordered {border: 1px solid #dee2e6;text-align: center;}
	#tabTable td{padding: 0.3rem !important;cursor: pointer;}
	.selTab{border: 1px solid #17A2B8 !important;background-color: #17A2B8;color: #fff;}
    .edui-default .edui-editor-breadcrumb{line-height: 30px;}
    .ui-widget-content{border: 1px solid rgba(0, 0, 0, 0.15) ;}
	.bs-tooltip-bottom .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #f8f9fa;opacity: 1;}
	.tooltip.bs-tooltip-bottom .arrow::before,
	.tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {border-bottom-color: #f8f9fa;	}
	/*.edui-editor {z-index: 0 !important;}*/
	.btn-box a{color:#fff }
	/*tooltip相关样式*/
	.bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
	.tooltip.bs-tooltip-right .arrow::before,
	.tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {	border-right-color: #00b297;}
	
	/*左上角*/
	.br-pagebody{position: relative;}
	.br-pagebody .alert{padding: 10px 20px;}
	.pagebody-corner{position: absolute;display: flex;flex-direction: row;justify-content: flex-start;align-items: center;top: -22px;left: 60px;background: #fffff;color: #000;font-size: 16px;}
	.wd-content-lable.wd-sm-table{width: 220px;}
	@media (max-width: 992px) {
		.collapsed-menu .br-mainpanel-file {
	    	margin-left: 0;
		}
	}
	
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>

<script type="text/javascript">
	window.onresize = function(){	
		if(document.getElementsByClassName("content-edit-frame")[0]){		
			if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){ 
				var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.body.scrollHeight ;
			}else{
				var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.documentElement.scrollHeight ;		
			}
			document.getElementsByClassName("content-edit-frame")[0].style.height = _height
		}
	}
	//调整iframe的高度 
	function changeFrameHeight(_this){   
		if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){     		
			_this.style.height = _this.contentWindow.document.body.scrollHeight +5;				
		}else{		
			_this.style.height = _this.contentWindow.document.documentElement.scrollHeight +5;				
		}
	}

//=================================================================
	var uname;
	$(document).ready(function() {
		tidecms.setDatePicker("#ExpireDate");
		$("#loginName").blur(function(){
			uname =  $("#loginName").val();
			$.ajax({
				type:"get",
				url:"../../user/checkuser.jsp",
				data:"username="+uname,
				success: function(msg){
					//window.console.info(msg);
					if(msg==1){
						$("#username1").css("display","");
						$("#loginName").focus();
					}else{
						$("#username1").css("display","none");        
					}	
				}
			});
		  });
	});

	function check()
	{
		if(isEmpty(document.form.companyName,"请输入租户名称."))
			return false;
		if(isEmpty(document.form.loginName,"请输入登录名."))
			return false;
		if(isEmpty(document.form.Password,"请输入密码."))
			return false;

		var pwd =  $("#password").val();
		if(pwd.length<6){
			alert("密码长度不能少于6位");
			return false;
		}
		if(uname!="" && pwd!="" && uname==pwd){
			alert("用户名密码不能相同");
			$("#password").val("");
			$("#password").focus();
			return false;
		}
	
		if(isEmpty(document.form.name,"请输入姓名."))
			return false;

		var result = "";
		//手机号绑定验证
		var phone = $("#Tel").val();
		if(phone!=""){
			$.ajax({
				type : "get",
				url : "../../user/checkPhone.jsp?phone="+phone+"&type=1",
				async:false,
				success : function(data){
					result = data.trim();
				}
			});
		}
		if(result!=""){
			alert(result);
			$("#Tel").val("");
			$("#Tel").focus();
			return false;
		}

		//站点相关验证
		var siteName = document.form.siteName.value;
		var app = document.form.app.value;
		var web = document.form.web.value;
		if(app==1&&siteName==""){
			alert("开通客户端必须填写站点名称");
			return false;
		}
		if(web==1&&siteName==""){
			alert("开通网站必须填写站点名称");
			return false;
		}

		$("#startButton").attr('disabled',true);  
		return true;
	}
</script>
  
</head>

<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled  = true;</script>

<form name="form" action="company_add.jsp" method="post" id="form" onSubmit="return check();">

	<div class="br-mainpanel br-mainpanel-file overflow-hidden">
	    <div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active">多租户管理 / 所有租户/ 开通租户</span>
			</nav>
		</div>
		<div class="br-pagebody bg-white mg-l-20 mg-r-20  mg-t-40">	
			<!--<div class="pagebody-corner bd rounded"><i class="fa fa-edit mg-l-20"></i>基本信息</div>-->
			<div class="pagebody-corner">
				<div class="alert alert-info" role="alert">					
				  <div class="d-flex align-items-center justify-content-start">
				    <i class="fa fa-edit alert-icon tx-18 mg-t-5 mg-xs-t-0"></i>
				    <span class=" tx-16">基本信息</span>
				  </div><!-- d-flex -->
				</div><!-- alert -->
			</div>
			<div class="br-content-box pd-20 pd-t-40">
				<div class="center">		
					<div class="article-title mg-l-15 mg-b-15 pd-r-30">
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >租户名称：</label>
							<label class="wd-content-lable d-flex" >
								<input class="form-control" placeholder="" type="text"  name="companyName" size="80" value="">
							 </label>
							<label><span  class="mg-l-10"></span></label>
						</div>
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >联系人：</label>
							<label class="wd-content-lable wd-sm-table d-flex" >
								<input class="form-control" placeholder="" type="text"  name="user" size="80" value="">
							 </label>
							<label><span  class="mg-l-10"></span></label>
						</div>
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >联系人电话：</label>
							<label class="wd-content-lable wd-sm-table d-flex" >
								<input class="form-control" placeholder="" type="text"  name="phone" size="80" value="">
							 </label>
							<label><span  class="mg-l-10"></span></label>
						</div>
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >LOGO：</label>
							<label class="wd-content-lable d-flex" >
								<input class="form-control" placeholder="请输入文件名" type="text"  name="logo" size="80" value="">
							 </label>
							<label><span  class="mg-l-10"></span></label>
						</div>
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >空间：</label>
							<label class="wd-content-lable wd-sm-table d-flex" >
								<input class="form-control" placeholder="" type="text"  name="space" size="80" value="">
							 </label>
							<label><span  class="mg-l-10"></span></label>
						</div>
						<div class="row mg-t--10">
							<label class="left-fn-title wd-150"> </label>
							<label class="d-flex align-items-center tx-gray-800 tx-12">
								<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
								给租户分配的空间大小。单位：G
							</label>
						</div>
						<div class="row flex-row align-items-center mg-b-15" id="tr_PublishDate">
							<label class="left-fn-title wd-150 ">授权日期：</label>
							<label class="">
								<input type="text" value="<%=duetime%>" id="ExpireDate" name="ExpireDate" class="textfield date form-control" size="24">
					  		</label>
						</div>											
					</div>
				</div>
			</div>						
		</div>

		<div class="br-pagebody bg-white mg-l-20 mg-r-20  mg-t-40">	
			<!--<div class="pagebody-corner bd rounded"><i class="fa fa-edit mg-l-20"></i>基本信息</div>-->
			<div class="pagebody-corner">
				<div class="alert alert-info" role="alert">					
				  <div class="d-flex align-items-center justify-content-start">
				    <i class="fa fa-user alert-icon tx-18 mg-t-5 mg-xs-t-0"></i>
				    <span class=" tx-16">管理员信息</span>
				  </div><!-- d-flex -->
				</div><!-- alert -->
			</div>
			<div class="br-content-box pd-20 pd-l-100 pd-t-60">
				<div class="center">		
					<div class="article-title mg-l-15 mg-b-15 pd-r-30">						
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >登录名：</label>
							<label class="wd-content-lable wd-sm-table d-flex" >
								<input class="form-control" placeholder="" type="text" id="loginName" name="loginName" size="80" value="">
							 </label>
							<label><span  class="mg-l-10"></span><font color="red" id="username1" style="display: none;">登录名重复</font></label>
						</div>
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >姓名：</label>
							<label class="wd-content-lable wd-sm-table d-flex" >
								<input class="form-control" placeholder="" type="text" name="name" size="80" value="">
							 </label>
							<label><span class="mg-l-10"></span></label>
						</div>
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >密码：</label>
							<label class="wd-content-lable wd-sm-table d-flex" >
								<input class="form-control" placeholder="" type="Password" id="password" name="Password" size="80" value="">
							 </label>
							<label><span class="mg-l-10"></span></label>
						</div>
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >手机号：</label>
							<label class="wd-content-lable wd-sm-table d-flex">
								<input class="form-control" placeholder="" type="text" name="Tel" id="Tel" size="80" value="">
							 </label>
							<label><span  class="mg-l-10"></span></label>
						</div>	
					</div>
				</div>
			</div>			
		</div>

		<div class="br-pagebody bg-white mg-l-20 mg-r-20  mg-t-40">	
			<!--<div class="pagebody-corner bd rounded"><i class="fa fa-edit mg-l-20"></i>基本信息</div>-->
			<div class="pagebody-corner">
				<div class="alert alert-info" role="alert">					
				  <div class="d-flex align-items-center justify-content-start">
				    <i class="fa fa-file-text  alert-icon tx-18 mg-t-5 mg-xs-t-0"></i>
				    <span class=" tx-16">业务开通信息</span>
				  </div><!-- d-flex -->
				</div><!-- alert -->
			</div>
			<div class="br-content-box pd-20 pd-l-100 pd-t-60">
				<div class="center">		
					<div class="article-title mg-l-15 mg-b-15 pd-r-30">						
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >开通客户端：</label>
							<div class="sheng-switch d-flex align-items-center flex-wrap float-left">
								<div class="toggle-wrapper">
								  <div class="toggle toggle-light success" data-toggle-on="true" field="app"></div>											  
								</div>
							</div>
							<input name="app" id="app" type="hidden" value="1">
						</div>						
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >开通网站：</label>
							<div class="sheng-switch d-flex align-items-center flex-wrap float-left">
								<div class="toggle-wrapper">
								  <div class="toggle toggle-light success" data-toggle-on="true" field="web"></div>											  
								</div>
							</div>
							<input name="web" id="web" type="hidden" value="1">
						</div>
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >站点名称：</label>
							<label class="wd-content-lable d-flex" >
								<input class="form-control" placeholder="" type="text"  name="siteName" id="siteName" size="80" value="">
							 </label>
							<label><span  class="mg-l-10"></span></label>
						</div>
						<div class="row flex-row align-items-center mg-b-15" >
							<label class="left-fn-title wd-150 " >开通聚现：
								<a href="javascript:;" target="_blank" class="valign-middle tx-gray-900 mg-l-10" data-toggle="tooltip" data-placement="top"><i class="icon ion-help-circled tx-18"></i></a>
							</label>
							<div class="sheng-switch d-flex align-items-center flex-wrap float-left">
								<div class="toggle-wrapper">
								  <div class="toggle toggle-light success" field="JuxianID"></div>											  
								</div>
							</div>
							<input name="JuxianID" id="JuxianID" type="hidden" value="0">
							<input name="JuxianToken" id="JuxianToken" type="hidden" value="">
						</div>	
					</div>
				</div>
			</div>						
		</div>

		<div class="br-pagebody mg-l-20 mg-r-20 mg-t-40" url="" >		
			<div class="br-content-box pd-20 pd-l-100">
				<div class="center">							
					<div class="row flex-row align-items-center mg-b-15 justify-content-center" id="tr_Title">							
					     <button name="startButton" type="submit" class="btn btn-primary tx-size-xs mg-r-50" id="startButton">提交</button>
					     <button name="btnCancel1" type="button" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消 </button>
						 <input type="hidden" name="Submit" value="Submit">
					</div>						
				</div>
			</div>
		</div>		
	</div>
</form>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../lib/2018/medium-editor/medium-editor.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script type="text/javascript" src="../common/jquery-ui-timepicker-addon.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>

$(function(){
	'use strict';

	//show only the icons and hide left menu label by default
	$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
	
	
	$('.br-mailbox-list,.br-subleft').perfectScrollbar();
	
	$('.br-sideleft [data-toggle="tooltip"]').tooltip({
		shadowColor:"#ffffff",
		textColor:"000000",
		trigger:"hover"
	});
	
});

$("#btnCancel1").click(function(){
	window.parent.frames["content_frame"].src ="company_list.jsp" ;
	return false ;
})

//开关相关
//初始化
$('.toggle').toggles({        
  height: 25
});
//获取是否开或关
$(".toggle").click(function(){
	var myToggle = $(this).data('toggle-active');
	var id = $(this).attr('field');

	if(myToggle){

		if(id=="JuxianID"){//开通聚现
			var name = document.form.companyName.value;
			var Tel = document.form.Tel.value;
			if(name!=""&&Tel!=""){
				var url = "juxian_register.jsp?Name="+name+"&phone="+Tel;
				$.ajax({
					type:"GET",
					dataType:"json",
					url:url, 
					success: function(data){
						if(data.code==200){
							$("#"+id).val(data.juxianId);
							$("#JuxianToken").val(data.access_token);
						}else{
							alert(data.message);
							return false;
						}
					}
				});
			}else{
				alert("请先填写租户名称和管理员手机号");
				return false;
			}
		}else{
			$("#"+id).val("1");//开
		}

	}else{
		$("#"+id).val("0");//关
	}
})
</script>

</html>
