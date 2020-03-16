<%@ page
import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.user.*,java.util.*,java.sql.*"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(! userinfo_session.isAdministrator())
{
	response.sendRedirect("../noperm.jsp");
	return;
}

String Submit = getParameter(request,"Submit");
String city_name = getParameter(request,"city_name");
int level  = getIntParameter(request,"level");

int itemid  = getIntParameter(request,"itemid");
int channelid = getIntParameter(request,"channelid");

Document doc = new Document(itemid,channelid);


String p = doc.getValue("Parent");
int parent = 0;
if(!"".equals(p))
{
	parent = Integer.parseInt(p);
}
if(Submit.equals("Submit"))
{
	Channel channel = CmsCache.getChannel(channelid);
	HashMap map = new HashMap();
	map.put("Title", city_name);
	if(itemid==0)
	{
		map.put("Parent", 0+"");
	}
	else
	{
		map.put("Parent", parent+"");
	}
	if(level==0)
	{
		map.put("Level", 1+"");
	}
	else
	{
		map.put("Level", (level)+"");
	}
	
	map.put("PublishDate",Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
	map.put("Status","1");
	map.put("tidecms_addGlobal", "1");
	ItemUtil util_ = new ItemUtil();
	int globalid = util_.addItem(channelid,map).getGlobalID();
	
	Document doc_ = new Document(globalid);
	int itemid_  = doc_.getId();

	//action=1同级添加
	// String json = "{action:1,itemid:\""+itemid_+"\",globalid:\""+globalid+"\",title:\""+city_name+"\",level:\""+(level)+"\"}";
	 out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	//out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true,json:"+json+"}});</script>");
    //out.println("<script>top.TideDialogClose({refresh:'right.update("+json+");'});</script>");  老版文件原型
	return;

	
}

java.util.Date thedate = new java.util.Date();

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
	<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript">
function check(){	
	if($("#city_name").val()=="")
	{
		alert("no kong");
	}
	else
	{
		var cityname = $("#city_name").val();
		//点击确定按钮，并跳转到check_hascity.jsp处理
		var url="check_hascity.jsp?itemid="+<%=itemid%>+"&channelid="+<%=channelid%>+"&cityname="+encodeURIComponent(cityname);
		$.ajax({
					type: "get",
					url: url,
					success: function(msg){
						if(msg==1){
							alert("该记录已在本级存在！");
						}else{
							$("#jobform").submit();
						}
					}
				});
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
 <form  name="form" action="multi_category_add_new2018.jsp?channelid=<%=channelid%>&itemid=<%=itemid%>&level=<%=level%>&Submit=Submit" id="jobform" method="POST" >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto" id="form1">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">	       		 				 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">名称：</label>
		              <label class="wd-200">
		                <input name="city_name" id="city_name" size="32"  class="form-control" placeholder="" type="text"  value="">
		              </label>									            
	   		  	</div>              				
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
				<input type="hidden" name="CopyMode"  id="CopyMode" value="1">
				<input type="hidden" name="SiteId" value="">
				<button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="startButton" onclick="check()">确定</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose({suffix:'_2'});" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->   
  </body>
              <script src="../lib/2018/jquery/jquery.js"></script>
                  <script src="../common/2018/common2018.js"></script>
	            <script src="../lib/2018/popper.js/popper.js"></script>
                <script src="../lib/2018/bootstrap/bootstrap.js"></script>
                <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
                <script src="../lib/2018/moment/moment.js"></script>
                <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
                <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
                <script src="../lib/2018/peity/jquery.peity.js"></script>
                <script src="../lib/2018/select2/js/select2.min.js"></script>
                <script src="../common/2018/bracket.js"></script>
</html>
