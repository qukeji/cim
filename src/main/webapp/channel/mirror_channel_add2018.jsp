<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

String	ChannelID	=	Util.getParameter(request,"ChannelID");
String Type			=	Util.getParameter(request,"Type");
String ChannelName	=	Util.getParameter(request,"ChannelName");

String Name = getParameter(request,"Name");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

if(!Name.equals(""))
{
	String	FolderName		= getParameter(request,"FolderName");
	String	ImageFolderName	= getParameter(request,"ImageFolderName");
	String	SerialNo		= getParameter(request,"SerialNo");
	String	Href			= getParameter(request,"Href");
	String	Attribute1		= getParameter(request,"Attribute1");
	String	Attribute2		= getParameter(request,"Attribute2");
	int		Parent			= getIntParameter(request,"Parent");
	int		IsDisplay		= getIntParameter(request,"IsDisplay");
	int		ChannelType		= getIntParameter(request,"ChannelType");
	int		TemplateInherit	= getIntParameter(request,"TemplateInherit");
	int		LinkChannelID	= getIntParameter(request,"LinkChannelID");

	Channel channel = new Channel();
	
	channel.setName(Name);
	channel.setParent(Parent);
	channel.setFolderName(FolderName);
	channel.setImageFolderName(ImageFolderName);
	channel.setSerialNo(SerialNo);
	channel.setIsDisplay(IsDisplay);
	channel.setType(Channel.MirrorChannel_Type);
	channel.setHref(Href);
	channel.setAttribute1(Attribute1);
	channel.setAttribute2(Attribute2);
	channel.setTemplateInherit(TemplateInherit);
	channel.setLinkChannelID(LinkChannelID);

	channel.setActionUser(userinfo_session.getId());
	channel.Add();

	session.removeAttribute("channel_tree_string");

	  //if(ContinueAdd==0)
	  //		{out.println("<script>top.TideDialogClose({refresh:'left'});</script>");return;}
  
  Channel parentChannel = new Channel(Parent);
  	Channel channelParentParent = new Channel(parentChannel.getParent());
    if(parentChannel.getParent()==-1){
	out.println("<script>top.TideDialogClose({refresh:'left',returnValue:{close:2},returnNavValue:{currentid:"+Parent+",parentid:-1,type:1,site:true}});</script>");return;
	}else if(channelParentParent.getParent()==-1){
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
  <!--  <link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" /> 
        <script type="text/javascript" src="../common/jquery.js"></script> -->
<!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <!--<link href="../../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">-->
    <!--<link href="../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">-->
    
    <!--<link href="../lib/highlightjs/github.css" rel="stylesheet">-->
    
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
	 <script src="../lib/2018/jquery/jquery.js"></script>
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	
  </style>	
</head>
 
   <body class="" onload="init();">
    <div class="bg-white modal-box">
      <form name="form" action="mirror_channel_add2018.jsp" method="post" onSubmit="return check();">
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">
	       	  <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">上级频道：</label>
			              <label class="wd-230" id="ParentName"><%=ChannelName%></label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">名称：</label>
			              <label class="wd-230">
			                <input name="Name" id="Name" class="form-control" placeholder="" type="text">
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">镜像到的频道：</label>
			              <label class="wd-230">
			                <input class="form-control" placeholder="" type="text" name="LinkChannelName" value="">
			              </label>
                          <input type="hidden" name="LinkChannelID" value="0">						  
			              <input class="tidecms_btn3" href="javascript:;" type="button" class="block" value="..." onclick="selectChannel();">
	       		  	  </div>
	       		  	  <div class="row">                  		  	  	
	   		  	  		  <label class="left-fn-title">模板方式：</label>
			              <label class="rdiobox">
			                <input name="TemplateInherit" id="s003" type="radio" value="1" class="textfield" checked><span>继承上级表单</span>
			              </label>
				            <label class="rdiobox">
			                <input id="s004" name="TemplateInherit" value="0" type="radio" class="textfield"><span>独立表单</span>
			              </label>
	       		  	  </div>
	       		  	 
	       		  	  <!--标识名-->
	       		  	   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">标识名：</label>
			              <label class="wd-230">                                                   
			                <input class="form-control" placeholder="" type="text" name="SerialNo"  onBlur="initOther()" value="">
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">目录名：</label>
			              <label class="wd-230">                                                    
			                <input class="form-control" placeholder="" type="text" name="FolderName" >
			              </label>									            
	       		  	  </div>
	       		  	  <!---->
	       		  	  <div class="row">                   		  	  	
	   		  	      <label class="left-fn-title">图片上传目录：</label>
			              <label class="wd-230">
			                <input  name="ImageFolderName" class="form-control" placeholder="" type="text">
			              </label>
			              <!--<label class="mg-l-5"> *为空使用站点默认目录</label>-->
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">链接：</label>
			              <label class="wd-230">
			                <input name="Href" class="form-control" placeholder="" type="text">
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">标题字数：</label>
			              <label class="wd-230">
			                <input name="Attribute1" class="form-control" placeholder="" type="text">
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">推荐栏目：</label>
			              <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="Attribute2" rows="3" class="form-control" placeholder=""></textarea>
				            </div>									            
	       		  	  </div> 
	       		  	  <!--是否在导航出现-->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">是否在导航出现：</label>
			              <label class="ckbox">
			                <input type="checkbox" checked="checked" name="IsDisplay" value="1" class="textfield"><span></span>
			              </label>								             
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
		      <button  name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
		      <button  name="btnCancel1" id="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消 
                     </button>
        </div> 
      </div>
   </form>     
    </div>	
	<!-- br-mainpanel -->
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
var TideDialog;
function init()
{
		document.form.Name.focus();
		var	scr = document.createElement('script')
		scr.src = 'getserialno.jsp?Parent=<%=ChannelID%>&random=' + Math.random();
		document.getElementById('ParentName').appendChild(scr);
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
	if(isEmpty(document.form.SerialNo,"请输入标识名."))
		return false;

	var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"; 

	//if (document.form.ChannelType[1].checked){
	if(isEmpty(document.form.FolderName,"请输入目录名."))
		return false;
	for(var i=0;i<document.form.SerialNo.value.length;i++)
	{
		var exist = false;
		for(var j=0;j<smallch.length;j++)
		{
			if(document.form.SerialNo.value.charAt(i)==smallch.charAt(j))
			{
				exist = true;
			}
		}

		if(!exist)
		{
			alert("具有独立表单的频道的标识名必须由英文字母或下划线组成.");
			document.form.SerialNo.focus();
			return false;
		}

	}
	//}

	document.form.Button2.disabled  = true;

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

function selectChannel()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(450);
	dialog.setSuffix('_2');
	dialog.setUrl("../channel/select_channel_category_tree.jsp");
	dialog.setTitle("选择频道");
	//dialog.setScroll('auto');
	dialog.show();
}

function setReturnValue(o){
		document.form.LinkChannelName.value = o.Name;
		document.form.LinkChannelID.value = o.ChannelID;
}

function initOther()
{
	if(document.form.SerialNo.value!="")
	{
		if(document.form.FolderName.value=="") 
		{
			var index = document.form.SerialNo.value.lastIndexOf("_");
			var folder = "";
			if(index!=-1)
				folder = document.form.SerialNo.value.substring(index+1);
			else
				folder = document.form.SerialNo.value;
			document.form.FolderName.value = folder;
			document.form.ImageFolderName.value = folder + "/images";
		}

		var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789";

		for(var i=0;i<document.form.SerialNo.value.length;i++)
		{
			var exist = false;
			for(var j=0;j<smallch.length;j++)
			{
				if(document.form.SerialNo.value.charAt(i)==smallch.charAt(j))
				{
					exist = true;
				}
			}

			if(!exist)
			{
				alert("具有独立表单的频道的标识名必须由英文字母或下划线组成.");
				document.form.SerialNo.focus();
				return false;
			}
		}
		scr = document.createElement('script')
		scr.src = 'checkserialno.jsp?SerialNo=' + document.form.SerialNo.value + '&random=' + Math.random();
		document.getElementById('ParentName').appendChild(scr);
	}
}
</script>
  </body>
</html>
