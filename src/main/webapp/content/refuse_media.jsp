<%@ page
import="tidemedia.cms.system.*,tidemedia.cms.base.*,org.json.*,tidemedia.cms.util.*,tidemedia.cms.user.*,java.util.*,java.sql.*,java.text.*"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//媒体号驳回
if(! userinfo_session.isAdministrator())
{response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
int itemid = getIntParameter(request,"itemid");
String Submit = getParameter(request,"Submit");
int actionuser = userinfo_session.getId();
if(Submit.equals("Submit"))
{
	String	remark		=   getParameter(request,"remark");
	 id = getIntParameter(request,"id");
	itemid = getIntParameter(request,"itemid");
	Channel channel = CmsCache.getChannel(id);
	String tablename = channel.getTableName();
	TableUtil tu = new TableUtil();
	JSONObject json = new JSONObject();
	String sql = "";
	try{
		sql = "update "+ tablename+" set Status1=2,remark='" + remark + "' where id =" + itemid + " and Status1=0";
		int result = tu.executeUpdate(sql);
		json.put("status","success");
		json.put("message","修改成功");
		
	}catch(Exception e){
			json.put("status","error");
			json.put("message",e.getMessage());
	}finally {
		out.println(json);
	}
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
    <!-- Meta -->
  <!--  <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">  -->
   <!-- <meta name="author" content="ThemePixels"> -->
     <!-- <link rel="Shortcut Icon" href="../favicon.ico">  -->
    <title>媒体号驳回</title>

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
 <form  name="form" action="refuse_media.jsp" method="POST"  id="jobform">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">	       		 				 
	   		  		<input type="hidden" name="itemid"   value="<%=itemid%>">
                  <input type="hidden" name="id"   value="<%=id%>">
				<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">备注：</label>
		              <label class="wd-150">
		               <textarea name="remark" id="remark" type="textarea" value="" rows="6" cols="38"  class="form-control wd-300" placeholder=""></textarea>
		              </label>									            
	   		  	</div>	
                 				
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		     <input type="hidden" name="CopyMode"  id="CopyMode" value="1">
	         <input type="hidden" name="Submit" value="Submit">
	         <input type="hidden" name="SiteId" value="">
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton" >确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->   
  </body>
               <script src="../common/2018/common2018.js"></script>
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
