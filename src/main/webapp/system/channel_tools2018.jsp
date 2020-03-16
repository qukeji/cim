<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.*,
				tidemedia.cms.base.*,
				java.sql.*,
				java.util.concurrent.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
     /**
	  * 用途 ：频道迁移
	  * 
	  */
	if(!userinfo_session.isAdministrator())
	{response.sendRedirect("../noperm.jsp");return;}
	
	int channelid=0;
	int parentid=0;
	String Submit="";
	channelid=getIntParameter(request,"channelid");
	parentid=getIntParameter(request,"parentid");
	Submit = getParameter(request,"Submit");
	if(channelid!=0&&parentid!=0&&Submit.length()>0){
		//out.println("在迁移");
		Channel channel = CmsCache.getChannel(parentid);
		int siteid = channel.getSiteID();
		String sql = "update channel set Parent="+parentid+",Site="+siteid+" where id="+channelid;
		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);
		ConcurrentHashMap channels = CmsCache.getChannels();
		channels.clear();

		//20130306 修改迁移后的channelcode.必须放在clear后，否则channelcode修改不过来
		CmsCache.getChannel(parentid).UpdateChannelCode(parentid);
		//update channel set Site=27 where ChannelCode like '15445%';
		Channel pch = new Channel(parentid);
		sql="update channel set Site="+siteid+" where ChannelCode like '"+pch.getChannelCode()+"%'";
		TableUtil tu2 = new TableUtil();
		tu2.executeUpdate(sql);
		
		ConcurrentHashMap channels_ = CmsCache.getChannels();
		channels_.clear();

		//处理文档中的ChannelCode
		Channel ch = CmsCache.getChannel(channelid);
		tu2.executeUpdate("update "+ch.getTableName()+" as a,channel as b set a.ChannelCode=b.ChannelCode where a.Category=b.id");
		ArrayList array = ch.listAllSubChannels();
		for(int i = 0;i<array.size();i++)
		{
			Channel ch_ = (Channel)array.get(i);
			out.println(ch_.getName());
			if(ch_.getType()==Channel.Channel_Type)
			{
				//独立表单
				//out.println(":"+ch_.getName());
				tu2.executeUpdate("update "+ch_.getTableName()+" as a,channel as b set a.ChannelCode=b.ChannelCode where a.Category=b.id");
			}
		}

		out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
		return;

	}else {
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
function check(){
	//alert("check");
	var channelid=$("#channelid").val();
	var parentid = $("#parentid").val();
	var msg = "确认要迁移频道吗?";
	if(channelid==0){
		alert("输入要迁移的频道编号");
	}else if(parentid==0){
		alert("输入迁移到的频道编号");
	}else if(parentid==channelid){
		alert("两个频道编号不能相同");
		return false;
	}else{
		if(confirm(msg)){
			return true;
		}else{
			return false;
		}
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
  <body class="" >
    <div class="bg-white modal-box">
<form name="form" action="channel_tools2018.jsp" method="post" onSubmit="return check();">
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">		 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">要迁移的频道编号：</label>
		              <label class="wd-180">
		                <input name="channelid" id="channelid"  class="form-control" placeholder="" type="text">
		              </label>									            
	   		  	</div>
	   		  	
                 <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">迁移到的频道编号：</label>
		              <label class="wd-180">
		                <input name="parentid" id="parentid" class="form-control" placeholder="" type="text" >
		              </label>									            
	   		  	</div>							
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
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
                <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
                <script src="../lib/2018/select2/js/select2.min.js"></script>
                <script src="../common/2018/bracket.js"></script>

</html>
<%}%>
