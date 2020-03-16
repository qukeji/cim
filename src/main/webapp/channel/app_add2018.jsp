<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

String	ChannelID		=	Util.getParameter(request,"ChannelID");
String Type			=	Util.getParameter(request,"Type");
String ChannelName	=	Util.getParameter(request,"ChannelName");

String Name = getParameter(request,"Name");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

		int UserId = userinfo_session.getId();
		UserInfo userinfo = new UserInfo(UserId);
		//String Websiteid = userinfo.getSite();

	if(!Name.equals(""))
	{
		String	FolderName		= getParameter(request,"FolderName");
		String	SerialNo		= getParameter(request,"SerialNo");
		String	Href			= getParameter(request,"Href");
		int		Parent			= getIntParameter(request,"Parent");
		int		IsDisplay		= getIntParameter(request,"IsDisplay");
		int		ChannelType		= 3;
		int		TemplateInherit	= getIntParameter(request,"TemplateInherit");
		int     IsReviewDisplay = getIntParameter(request,"IsReviewDisplay");

		Channel channel = new Channel();
	    Channel parentChannel=CmsCache.getChannel(Parent);
	    channel.setSiteID(parentChannel.getSiteID());
		channel.setName(Name);
		channel.setParent(Parent);
		channel.setFolderName(FolderName);
		channel.setSerialNo(SerialNo);
		channel.setIsDisplay(IsDisplay);
		channel.setType(ChannelType);
		channel.setHref(Href);
		channel.setTemplateInherit(TemplateInherit);
		//channel.setCanComment(IsReviewDisplay);
		
		//channel.Add(Websiteid);
		channel.Add();
		int id = channel.getSiteBySerialNo(SerialNo);
		//session.removeAttribute("channel_tree_string");
		
		int		ParentName	= getIntParameter(request,"ParentName");
		String	Template	= getParameter(request,"Template");
		String	TargetName	= getParameter(request,"TargetName");
		String	Charset		= getParameter(request,"Charset");

		App p = new App(id);
		
		p.setName(Name);
		p.setParent(ParentName);
		p.setType(3);
		p.setTemplate(Template);
		p.setTargetName(TargetName);
		p.setCharset(Charset);

		p.Add(id);
		//leener edit 2007-04-03
		
			p.GenerateFormFile(userinfo_session);
		
		//end;
	 //	if(ContinueAdd==0)
	//		{out.println("<script>top.TideDialogClose({refresh:'left'});</script>");return;}
     		
	System.out.println("进入排序-------------=");
	System.out.println("进入排序-------------当前频道父="+parentChannel.getParent());
    Channel channelParent = new Channel(parentChannel.getParent());
    if(parentChannel.getParent()==-1){
	out.println("<script>top.TideDialogClose({refresh:'left',returnValue:{close:2},returnNavValue:{currentid:"+Parent+",parentid:-1,type:1,site:true}});</script>");return;
	}else if(channelParent.getParent()==-1){
	out.println("<script>top.TideDialogClose({refresh:'left',returnValue:{close:2},returnNavValue:{currentid:"+Parent+",parentid:"+parentChannel.getParent()+",type:1,site:true}});</script>");return;
	}else{
     out.println("<script>top.TideDialogClose({refresh:'left',returnValue:{close:2},returnNavValue:{currentid:"+Parent+",parentid:"+parentChannel.getParent()+",type:1,site:false}});</script>");return;
	} 	
		
	}
%>
<!DOCTYPE html>
<html>
 <head>
 <meta charset="utf-8">
 <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
 <meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="/cms2018/favicon.ico">
    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
<title>TideCMS</title>
    <!--   <link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />  -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
	<script type="text/javascript" src="../common/common.js"></script>
	<script src="../lib/2018/jquery/jquery.js"></script>
   <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	
  </style>	

</head>
<body class="" >
 <div class="bg-white modal-box">
      <form name="form" action="app_add2018.jsp" method="post" onSubmit="return check();">
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">
	       	  <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">上级频道：</label>
			              <label class="wd-230" id="ParentName">
			                <span><%=ChannelName%></span>
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">名称：</label>
			              <label class="wd-230">
			                <input class="form-control" placeholder="" type="text" name="Name">
			              </label>									            
	       		  	  </div>
					   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">标识名：</label>
			              <label class="wd-230">                                                    
			                <input class="form-control" placeholder="" type="text" name="SerialNo"   onBlur="initOther()">
			              </label>									            
	       		  	  </div>
					  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">目录名：</label>
			              <label class="wd-230">                                                     
			                <input class="form-control" placeholder="" type="text" name="FolderName"  >
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">页面框架模板：</label>
			              <label class="wd-230">
			                <input class="form-control" placeholder="" type="text" name="Template" size="32">
			              </label>	
			              <input type="hidden" name="TemplateID" value="">						  
			              <input class="tidecms_btn3" href="javascript:;" type="button" class="block" value="..." onclick="selectTemplate();">
	       		  	  </div>  	 
	       		  	  
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">对应页面文件名：</label>
			              <label class="wd-230">
			                <input class="form-control"  placeholder="" name="TargetName"  type="text">
			              </label>									            
	       		  	  </div>
					  	      
                      <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">文件编码：</label>               		  	  		 
		  	  		  	  <select name="Charset" class="form-control wd-230 ht-40 select2" data-placeholder="系统默认编码">
						                        
						                <option value="">系统默认编码</option> 
						                <option value="gb2312">简体中文(GB2312)</option>
				                        <option value="utf-8">Unicode(UTF-8)</option>							                           
						  </select>               		  	  		 						            
	       		  	  </div>
							  
	       		  	  <!--是否继续新建-->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">继续新建：</label>
			              <label class="ckbox">
			                <input type="checkbox" id="s1" name="ContinueAdd" value="1" class="textfield" <%=ContinueAdd==1?"checked":""%>><span></span>
			              </label>								             
	       		  	  </div>
	       		  </li>
       	    
	       	  </ul>
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
      	<div class="modal-footer" >
		      <input type="hidden" name="Parent" value="<%=ChannelID%>">
	          <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
		      <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确认</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		    </div> 
      </div>
      <div id="ajax_script" style="display:none;"></div>	    
	  </form>   
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## --> 
    <script>
      $(function(){
      	$("#form_nav li").click(function(){
      		var _index = $(this).index();
      		console.log(_index)
      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
      	})
       
       //推荐设置锁定图片切换
      $(".lock-unlock").click(function(){    
       	var textBox = $(this).parent(".row").find(".textBox") ;       	
       	if($(this).find("i").hasClass("fa-lock")){      	 
       	 	$(this).find("i").removeClass("fa-lock").addClass("fa-unlock");       	 	
       	 	textBox.removeAttr("disabled","").removeClass("disabled")
       	}else{      	 	
       	 	$(this).find("i").removeClass("fa-unlock").addClass("fa-lock");
       	 	textBox.attr("disabled",true).addClass("disabled")
       	}
      })
		   
      });
    </script>
<script type="text/javascript">
function init()
{
		document.form.Name.focus();
}

function selectTemplate(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(650);
	dialog.setHeight(470);
	dialog.setSuffix('_2');
	dialog.setUrl("../channel/selecttemplate.jsp");
	dialog.setTitle("页面框架模板");
	dialog.setScroll('auto');
	dialog.show();
}

function setReturnValue(o){
	if(o.TemplateID!=null){
		document.form.TemplateID.value =o.TemplateID;
		var scr = document.createElement('script')
		scr.src = '../channel/template_add_js.jsp?id=' + o.TemplateID;
		document.getElementById('ajax_script').appendChild(scr);
	}
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
	if(isEmpty(document.form.SerialNo,"请输入标识名."))
		return false;

	//var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"; 

	//if (document.form.ChannelType[1].checked){
	//if(isEmpty(document.form.FolderName,"请输入目录名."))
		//return false;
	//for(var i=0;i<document.form.SerialNo.value.length;i++)
	//{
		//var exist = false;
		//for(var j=0;j<smallch.length;j++)
		//{
			//if(document.form.SerialNo.value.charAt(i)==smallch.charAt(j))
			//{
				//exist = true;
			//}
		//}

		//if(!exist)
		//{
			//alert("具有独立表单的频道的标识名必须由英文字母或下划线组成.");
			//document.form.SerialNo.focus();
			//return false;
		//}

	//}
	//}

	//document.form.Button2.disabled  = true;

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

function initOther()
{
	if(document.form.SerialNo.value!="" && document.form.FolderName.value=="")
	{
		document.form.FolderName.value = document.form.SerialNo.value;
	}
}
</script>
  </body>
</html>
