<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.io.*,
				java.net.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    public  String HttpUrl(String url,String charset,String token)
    {
        String content = "";
        String sCurrentLine = "";
        java.net.URL l_url;
        try {
            if(charset.length()==0) charset = "utf-8";
            l_url = new java.net.URL(url);
            java.net.HttpURLConnection con = (java.net.HttpURLConnection) l_url.openConnection();
            HttpURLConnection.setFollowRedirects(true);
            con.setConnectTimeout(60000);//连接超时,1分钟,防止网络异常，程序僵死
            con.setReadTimeout(60000);//读操作超时,1分钟
            con.setInstanceFollowRedirects(true);//支持重定向
            con.setRequestProperty("token",token);
            con.connect();
            java.io.InputStream l_urlStream = con.getInputStream();
            java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream,charset));
            while ((sCurrentLine = l_reader.readLine()) != null)
            {
                content+=sCurrentLine + "\r\n";
            }
        } catch (MalformedURLException e) {
            System.out.println("cann't connect " + url);
            //e.printStackTrace(System.out);
        } catch (IOException e) {
            System.out.println("cann't connect " + url);
            //e.printStackTrace(System.out);
        }

        return content;
    }
%>
<%

int companyid = getIntParameter(request,"companyid");
Company company = new Company(companyid);
int company_id = company.getJuxianID();//企业id
if(company_id==0){
	//out.println("<script>var dialog = new top.TideDialog();dialog.showAlert(\"请先开通聚现功能\",\"danger\");top.TideDialogClose({refresh:'right'});</script>");
	out.println("<script>var dialog = new top.TideDialog();dialog.showAlert(\"请先开通聚现功能\",\"danger\");top.TideDialogClose();</script>");
	return;
}
TideJson tidejson = CmsCache.getParameter("juxian_api").getJson();
String url = tidejson.getString("company_toolList_url")+"?company_id="+company_id;//移动工具列表接口
int userid = 	userinfo_session.getId();
UserInfo userInfo = new UserInfo(userid);
String phone = userInfo.getTel();
if("".equals(phone)){
	out.println("<script>var dialog = new top.TideDialog();dialog.showAlert(\"请先填写用户手机号\",\"danger\");top.TideDialogClose();</script>");
	return;
}
String token =Util.createToken(0,phone,"",company_id,1);
    //String token =Util.createToken(0,"19953313232","",4,1);
String result=HttpUrl(url,"utf-8",token);
/*    System.out.println("phone==============="+phone);
    System.out.println("company_id==============="+company_id);
    System.out.println("url==============="+url);
System.out.println("result==============="+result);
    System.out.println("token==============="+token);*/
JSONObject resultJson = new JSONObject();
JSONArray array = new JSONArray();
if(!"".equals(result)){
    resultJson = new JSONObject(result);
    if(resultJson.has("status") && resultJson.getInt("status")==200){
        array = resultJson.getJSONArray("data");
    }else{
        String msg = resultJson.getString("msg");
        out.println("<script>var dialog = new top.TideDialog();dialog.showAlert(\""+msg+"\",\"danger\");top.TideDialogClose();</script>");
        return;
    }
}else{
    out.println("<script>var dialog = new top.TideDialog();dialog.showAlert(\"token为空\",\"danger\");top.TideDialogClose();</script>");
    return;
}

%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">

    <title>tideCms</title>

    <!-- vendor css -->
    <link href="../../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    
    <link href="../../lib/2018/highlightjs/github.css" rel="stylesheet"> 
    <link href="../../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../../style/2018/bracket.css">    
    <link rel="stylesheet" href="../../style/2018/common.css">
	  <link rel="stylesheet" href="../../style/2018/login_tcenter.css">
    
  </head>
  <style>
  	html,body{width: 100%;height: 100%;}  	
	.mg-t--10{margin-top: -10px;}
	.modal-body{top: 0;}

	.fa{font-size: 30px;}
	.config-box ul li a img{width:100%;height:100%}
	.mg-t--10{margin-top:-10px !important;}
	.config-box ul li{height:150px !important;}
	.config-box ul li a{background-color: #fff !important;}
  </style>
 
   
  <body class="" id="display-select">
 
    <div class="bg-white modal-box">
      
	    <div class="modal-body pd-20 overflow-y-auto">
	        <div class="config-box ">
	       	 	<ul id="toolList">
	       	 	   <%for(int i = 0;i<array.length();i++){ %>
                       <li class="op-9" id="<%=array.getJSONObject(i).getInt("id")%>" code="<%=array.getJSONObject(i).getString("code")%>">
                           <a href="javascript:;">
                               <img src="<%=array.getJSONObject(i).getString("icon")%>" >
                               </a>
                           <p class="mg-t--10 mg-b-0-force"><%=array.getJSONObject(i).getString("name")%></p>
                           <div class="toggle-wrapper">
                               <div class="toggle toggle-light success" style="height: 25px;" data-toggle-on="<%=array.getJSONObject(i).getInt("status")==0?"true":"false"%>"></div>
                           </div>
                        </li>
                    <%}%>

		    	</ul>
	    	</div>
	    </div><!-- modal-body -->
	     <!-- <div class="btn-box" >
	      	<div class="modal-footer" >
			      <button type="button" class="btn btn-primary tx-size-xs" onclick="top.TideDialogClose();">确认</button>
			    </div> 
	      </div> -->
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->
       <script src="../../lib/2018/jquery/jquery.js"></script>
    <script src="../../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../../lib/2018/popper.js/popper.js"></script>
    <script src="../../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../../lib/2018/moment/moment.js"></script>
    
    <script src="../../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../../lib/2018/peity/jquery.peity.js"></script>
    
	  <script src="../../lib/2018/highlightjs/highlight.pack.js"></script>
    
    <script src="../../lib/2018/select2/js/select2.min.js"></script>
    <script src="../../lib/2018/jquery-toggles/toggles.min.js"></script>
    <script src="../../common/2018/bracket.js"></script>  
  
<script>
   	//开关相关
   	$(function(){
        //初始化
        $('.toggle').toggles({
            height: 25
        });
		//获取是否开或关
		$("#toolList").on("click",".toggle",function(){
			var myToggle = $(this).data('toggle-active');
			var code = $(this).parent().parent().attr("code");
			var action = 0;
			if(myToggle){
				action=1;
			}
			$.ajax({
				type : "get",
				url : "company_open_tool.jsp"+"?code="+code+"&action="+action+"&company_id=<%=company_id%>",
				dataType:"json",
				success : function(data) {
					var	dialog = new top.TideDialog();
					if(data.status==200){
						dialog.showAlert(data.msg);
					}else{
						dialog.showAlert(data.msg,"danger");
					}
						location.reload() 
				}
			})
		
		});
   	});
   </script>
  </body>
</html>















