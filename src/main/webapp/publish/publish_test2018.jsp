<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.PublishScheme,
				java.io.*,
				org.apache.commons.net.ftp.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%//禁止编辑发布方案
if(userinfo_session.hasPermission("DisableEditPublishScheme"))
{	out.close();return;}

int id = getIntParameter(request,"id");

//PublishScheme publishscheme = new PublishScheme(id);
PublishScheme ps =CmsCache.getPublishScheme(id);
%>
<!DOCTYPE html>
<html>

                <head>
                    <meta charset="utf-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                    <link rel="Shortcut Icon" href="../favicon.ico">
                    <title>TideCMS</title>
                    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
                    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
                    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
                    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
                    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
                    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
                    <link rel="stylesheet" href="../style/2018/bracket.css">
                    <link rel="stylesheet" href="../style/2018/common.css">
<script type="text/javascript">

//$("#start").click(function(){
function startTest(){
	/*
 var file = $("#file").val();
 if(file!=null||file.match("/(^/)\.([a-zA-Z]){1,}")==null){
	alert("输入格式为：/a.zip");
	return false;
 }*/

	$.ajax({
	 type: "POST",
	 url: "publish_test_submit.jsp",
	 data: {'siteId':'<%=id%>','file':$('#file').val()},
	 error:function(XMLHttpRequest, textStatus, errorThrown){
		 $("#result").html("<tr> <td align='left' colspan='2'>"+XMLHttpRequest.responseText+"</td></tr>");
	 },
	 success: function(data){
		var html ="<tr> <td align='left' colspan='2'>"+data+"</td></tr>";
		$("#result").html(html);
	 } 
	});
}
 
 
 
function init()
{
	document.form.Code.focus();
} 

function check()
{
	if(isEmpty(document.form.Code,"请输入代码."))
		return false;

	//document.form.Button2.disabled  = true;

	return true;
}
</script>                  
				  <style>
                          html,
                        body {
                            width: 100%;
                            height: 100%;
                        }
                    </style>
					
                </head>

                <body   class="">
                   <div class="bg-white modal-box">
					<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	                   <div class="config-box">
	       	              <ul>			         
	       		            <li class="block">
							 <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">名称：</label>
			              <label class="wd-230">                                                    
			                  <%=ps.getName()%>
			              </label>									            
	       		       </div>
       		  	        <div class="row">                   		  	  	
   		  	  		      <label class="left-fn-title">FTP服务器：</label>
		                    <div class="col-lg pd-l-0 pd-r-0 wd-350">
			                  <%=ps.getServer()%>
			              </div>									            
       		  	       </div> 
       		  	        <div class="row">                   		  	  	
   		  	  		        <label class="left-fn-title">用户名：</label>
		                      <div class="col-lg pd-l-0 pd-r-0 wd-350">
			                          <%=ps.getUsername()%>
			                  </div>	                           					
       		  	         </div> 
						 <div class="row">                   		  	  	  		  	  		       
		                      <div class="col-lg pd-l-0 pd-r-0 wd-350">
			                          指定文件(比如：/tidecms_test.html):
			                  </div>	                           					
       		  	         </div> 
						 <div class="row">                   		  	  	  		  	  		       
		                      <div class="col-lg pd-l-0 pd-r-0 wd-350">
			                   <input type="text" name="file" id="file" value="/tidecms_test.html" size="40"/>	                                            
			                  </div>	
                             <input type="hidden" name="channelid" value="<%=id%>">   							  
       		  	         </div> 
	                    </li>
					  </ul>
	               </div>	                   
	                                               
							<div class="card bd-0 shadow-base">
                                <table class="table mg-b-0" id="content-table">
                                     <thead>
                                        <tr>
                                            <th class="tx-12-force tx-mont tx-medium" colspan='2'>结果：</th>
                                           
                                        </tr>
                                    </thead>
                                    <tbody id="result">
                                      
                                    </tbody>
                                </table>
                            </div>
                        </div>						
						 <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
      	                    <div class="modal-footer" >
								 	 <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">关闭</button>    
								     <button name="button" type="submit" class="btn btn-primary tx-size-xs"  id="start" onclick="startTest();">开始测试</button>								 
							 </div> 
                         </div>
                        <!--列表-->
                    </div>
                </body>
                </html>