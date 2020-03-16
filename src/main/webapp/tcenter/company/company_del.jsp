<%@ page import="tidemedia.cms.system.*,
				org.json.*,
                java.sql.*,
				java.net.URL,
				java.util.ArrayList,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

String	Submit	= getParameter(request,"Submit");
if(!Submit.equals("")){
	
	//String cms_api = CmsCache.getParameter("cms_api").getContent();
	String cms_api = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/tcenter";
	String url = cms_api+"/api/company/site_list.jsp?company="+id+"&type=3";
	
	String result = Util.connectHttpUrl(url);
	JSONObject json = new JSONObject(result);
	JSONArray arr = json.getJSONArray("sites");

	if(arr.length()>0){
		throw new MessageException("请先解绑相关站点!",4);
	}else{

		String scheme = request.getScheme() ;
		String port = ""+request.getLocalPort() ;
		if(scheme.equals("https")) port = "888" ;

		//判断租户是否有正在使用的频道
		Product product = new Product("TideCMS");
		url = "http://127.0.0.1:"+port+"/"+product.getUrl()+"/system/company_channel_check.jsp?company="+id;
		result = Util.connectHttpUrl(url);
		JSONObject json1 = new JSONObject(result);
		
		product = new Product("TideVMS");
		url = "http://127.0.0.1:"+port+"/"+product.getUrl()+"/system/company_channel_check.jsp?company="+id;
		result = Util.connectHttpUrl(url);
		JSONObject json2 = new JSONObject(result);

		if(json1.getInt("code")==200&&json2.getInt("code")==200){


			Company c = new Company(id);
			c.setUserId(userinfo_session.getId());
			c.setRequest(request);
			c.Delete(id);

		}else{
			throw new MessageException("请先删除此租户的相关频道",4);
		}

	}
	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
<meta name="author" content="ThemePixels">
<title>TideCMS</title>
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<style>
html,body{
	width: 100%;
	height: 100%;
}
.modal-body-btn .config-box .row .left-fn-title{
	min-width: 70px;
}
</style>  

</head>
<body class="">
    <div class="bg-white modal-box">
	<form name="form" method="post" action="company_del.jsp" >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box mg-t-15">
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">你确定要删除此租户?</label>							            
	   		  	</div>	
                <div class="row">                              				
		  	  		  <label class="left-fn-title" >删除以后无法恢复!</label>							            
	   		  	</div>								
	        </div>
	    </div><!-- modal-body -->
		<div class="btn-box">
      		<div class="modal-footer" >
		      <input type="hidden" name="id" value="<%=id%>">   
              <input type="hidden" name="Submit" value="Submit">    		    
		      <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
			</div> 
       </div>
	   <div id="ajax_script" style="display:none;"></div> 
	</form>	     
    </div><!-- br-mainpanel -->
</body>
</html>
