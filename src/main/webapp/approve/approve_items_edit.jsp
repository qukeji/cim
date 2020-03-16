<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
//获取用户名
public String getUserName(String users) {
	String userName = "";
	try{
		TableUtil tu = new TableUtil("user");
		String Sql = "select * from userinfo where id in("+users+")";
		ResultSet Rs = tu.executeQuery(Sql);
		while(Rs.next())
		{
			String Name = convertNull(Rs.getString("Name"));
			if(!userName.equals("")&&!Name.equals("")){
				userName += ",";
			}
			userName += Name;
		}
		tu.closeRs(Rs);
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
	return userName;
}
%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
int parent = getIntParameter(request,"parent");
int suffix = getIntParameter(request,"suffix");
if(suffix==0) suffix = 2 ;

ApproveItems ai = new ApproveItems(id);
String users = ai.getUsers();
String UserNames = getUserName(users);
boolean flag =(1==ai.getEditable());
//boolean flag = true;


String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Title = getParameter(request,"Title");
	String	url = getParameter(request,"url");
	int editable = getIntParameter(request,"switch");
	users = getParameter(request,"users");
	int	Type = getIntParameter(request,"Type");

	ai.setTitle(Title);
	ai.setUsers(users);
	ai.setType(Type);
	ai.setEditable(editable);
	ai.setUrl(url);
	ai.Update();
	
	if(suffix==1){//频道页面展示
		out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	}else{
		out.println("<script>top.TideDialogClose({suffix:'_"+suffix+"',recall:true,returnValue:{refresh:true,id:"+parent+"}});</script>");
	}
	return;
}
%>
<!DOCTYPE html>
<html >
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">   
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">	
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
</style>  

<script type="text/javascript">

	function check()
	{
		if(isEmpty(document.form.Title,"请输入名称."))
			return false;
		return true;
	}
	//选择用户
	function showUser(){
		var users = $('#users').val();
		var	dialog = new top.TideDialog();
		dialog.setWidth(800);
		dialog.setHeight(500);
		dialog.setUrl("../approve/user_index.jsp?users="+users);
		dialog.setTitle("选择用户");
		dialog.setSuffix("_3");
		dialog.show();
	}
	//子弹窗返回值
	function setReturnValue(o) {
		if (o.users != null) {
			$('#users').val(o.users);
			$('#Usernames').attr("value",o.Usernames);
		}
	}

</script>
  
</head>

<body class="" >
    <div class="bg-white modal-box">
	  <form name="form" action="../approve/approve_items_edit.jsp" method="POST" onSubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	  <!--基本信息-->
	       		  <li class="block">
				 
					<div class="row">                   		  	  	
						<label class="left-fn-title">名称：</label>
						<label class="wd-300">
							<input name="Title" class="form-control" placeholder="" type="text" value="<%=ai.getTitle()%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">用户：</label>
						<label class="wd-300">
							<input name="Usernames" id="Usernames" class="form-control" placeholder="" type="text" onclick="showUser()" readonly="true" value="<%=UserNames%>">
							<input name="users" id="users" type="hidden" value="<%=users%>">
						</label>									            
					</div>
					<div class="row">                   		  	  	
						<label class="left-fn-title">第几步：</label>
						<label class="wd-100">
							<input name="step" class="form-control" placeholder="" type="text" value="<%=ai.getStep()%>" readonly="true">
						</label>									            
					</div>
					<div class="row">                  		  	  	
					  <label class="left-fn-title">审核模式：</label>
					  <label class="rdiobox">
						<input type="radio" name="Type" value="0" <%=ai.getType()==0?"checked":""%>><span class="d-inline-block">或签</span>
					  </label>
						<label class="rdiobox">
						<input type="radio" name="Type" value="1" <%=ai.getType()==1?"checked":""%>><span class="d-inline-block">并签</span>
					  </label>
				    </div>
                    <div class="row"> 
					    <label class="left-fn-title">允许编辑内容：</label>
					    <label class="wd-300">
							<div class="toggle-wrapper">
    							<div class="toggle toggle-light success" data-toggle-on="<%=flag%>"></div>
    					    </div>
						</label>
						<input type="hidden" id="switch" name="switch" value="<%=ai.getEditable()%>"> 
					</div>
					<div class="row">                		  	  	
						<label class="left-fn-title">回调地址：</label>
						<label class="wd-300">
							<textarea name="url" cols="40" rows="5"><%=ai.getUrl()%></textarea>
							<p style="font-size: 12px;font-weight: normal;">本地接口使用127.0.0.1地址，服务器内网互通的使用内网地址，接口示例：http://127.0.0.1:889/cms/api/approve_api.jsp</p>
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
			  <input type="hidden" name="parent" value="<%=parent%>">
			  <input type="hidden" name="id" value="<%=id%>">
			  <input type="hidden" name="suffix" value="<%=suffix%>">
			</div> 
		</div>
		<div id="ajax_script" style="display:none;"></div> 
	  </form>	     
	</div><!-- br-mainpanel -->
</body>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>        
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script type="text/javascript">
    	//初始化
		$('.toggle').toggles({
              text: {
                on: '', // text for the ON position
                off: '' // and off
              },
              width: 60, // width used if not set in css
              height: 25, // height if not set in css
        });
		//获取是否开或关
		$(".toggle").click(function(){
			var myToggle = $('.toggle').data('toggle-active');
			if(myToggle){
			    $("#switch").val(1);
			}else{
			    $("#switch").val(0);
			}
			console.log(myToggle)  //true or false 
		})

</script>
</html>
