<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");

int ChannelID = getIntParameter(request,"ChannelID");

Page p = new Page(ChannelID);

String Name = getParameter(request,"Name");

if(!Name.equals(""))
{
	String	Template		= getParameter(request,"Template");
	String	TargetName		= getParameter(request,"TargetName");
	String	Charset			= getParameter(request,"Charset");

	p.setName(Name);
	p.setTemplate(Template);
	p.setTargetName(TargetName);
	p.setCharset(Charset);
	p.setActionUser(userinfo_session.getId());

	p.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
}
%>
<!DOCTYPE html>
<html >
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
    <!-- Meta -->
  <!--  <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">  -->
   <!-- <meta name="author" content="ThemePixels"> -->
     <!-- <link rel="Shortcut Icon" href="../favicon.ico">  -->
    <title>TideCMS</title>

    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">   
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">	
<script type="text/javascript">
function init()
{
		document.form.Name.focus();
}

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

function selectTemplate(){
  	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(450);
	dialog.setSuffix('_2');
	dialog.setUrl("channel/selecttemplate.jsp");
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

</script>
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  </style>  
  </head>
  <body class="" onload="init();" >
    <div class="bg-white modal-box">
 <form  name="form" action="page_edit22018.jsp" method="POST"  onsubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">上级频道：</label>
			              <label class="wd-230" id="SuperChannelName">
			                <span><%=CmsCache.getChannel(ChannelID).getName()%></span>
			              </label>									            
	       		  	  </div>
				 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">名称：</label>
		              <label class="wd-230">
		                <input name="Name" size="32" class="form-control" placeholder="" type="text" value="<%=p.getName()%>">
		              </label>									            
	   		  	</div>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">页面框架模板：</label>
		              <label class="wd-230">
		                <%=p.getTemplate()%>
		              </label>									            
	   		  	</div>	
                 <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">对应页面文件名：</label>
		              <label class="wd-230">
		                <input name="TargetName" size="32" class="form-control" placeholder="" type="text" value="<%=p.getTargetName()%>">
		              </label>									            
	   		  	</div>	
				
				
				
				 <div class="row">
                                   <label class="left-fn-title">文件编码：</label>
                                   <label class="wd-230">
								    <select class="form-control wd-230 ht-40 select2" name="Charset">
									<option value="">系统默认编码</option>
								    <option value="gb2312">简体中文(GB2312)</option>
									<option value="utf-8">Unicode(UTF-8)</option>
									</select>
			                        </label>
                 </div>				
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		      <input type="hidden" name="SuperChannel" value="<%=ChannelID%>">
              <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	          <input type="hidden" name="Submit" value="Submit">
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->   
  </body>
               <script type="text/javascript" src="../common/common.js"></script>
	           <script src="../lib/2018/jquery/jquery.js"></script>
	            <script src="../lib/2018/popper.js/popper.js"></script>
                <script src="../lib/2018/bootstrap/bootstrap.js"></script>
                <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
                <script src="../lib/2018/moment/moment.js"></script>
                <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
                <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
                <script src="../lib/2018/peity/jquery.peity.js"></script>
                <script src="../lib/2018/select2/js/select2.min.js"></script>
                <script src="../common/2018/bracket.js"></script>
<script language=javascript>
<%if(!p.getCharset().equals("")){%>
document.form.Charset.value = "<%=p.getCharset()%>";
<%}%>
</script>
</html>
