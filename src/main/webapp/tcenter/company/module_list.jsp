<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String system_logo = CmsCache.getParameter("system_logo").getContent();

//获取租户的产品权限
int companyid = getIntParameter(request,"id");//租户编号
String products = new Company(companyid).getProducts();
String productIds[] = products.split(",");
		
String sql = "select id,logo,Name,groupId,code from tide_products where Status=1 and groupid<5";
TableUtil tu = new TableUtil("user");
ResultSet Rs = tu.executeQuery(sql);
JSONArray yyzc = new JSONArray();
JSONArray yyfb = new JSONArray();
JSONArray zyhj = new JSONArray();
JSONArray scgj = new JSONArray();
while(Rs.next()){
	int groupid = Rs.getInt("groupId") ;
	int id = Rs.getInt("id") ;
	boolean flag = Arrays.asList(productIds).contains(id+"");//租户是否已有此产品权限
	if("tcenter".equals(tu.convertNull(Rs.getString("code")))||"operate".equals(tu.convertNull(Rs.getString("code")))){
		continue;
	}
    JSONObject obj = new JSONObject();
    obj.put("logo",tu.convertNull(Rs.getString("logo")));
    obj.put("Name",tu.convertNull(Rs.getString("Name")));
    obj.put("groupId",groupid);
	obj.put("flag",flag);
	obj.put("pid",id);
	
    if(groupid==1){
        yyzc.put(obj);
    }else if(groupid==2){
        yyfb.put(obj);
    }else if(groupid==3){
        zyhj.put(obj);
    }else if(groupid==4){
        scgj.put(obj);
    }
}
tu.closeRs(Rs);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">  
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../<%=ico%>">
<title><%=title_%></title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/highlightjs/github.css" rel="stylesheet"> 
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<!-- Bracket CSS -->
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/2018/login_tcenter.css">

<style>
  	html,body{width: 100%;height: 100%;}  	
	.mg-t--10{margin-top: -10px;}
	.modal-body{top: 0;}
	ul li .fa{font-size: 30px;}
</style>

</head>

<body class="" id="display-select">
	<div class="bg-white modal-box">
		<div class="modal-body pd-20 overflow-y-auto">

	        <div class="config-box yyzc">
				<div class="pd-x-10 tx-16 pd-y-10">运营支撑</div>
	       	 	<ul>	
				<%for(int i=0;i<yyzc.length();i++){%>
					<li class="op-9" pid="<%=yyzc.getJSONObject(i).getString("pid")%>">
						<a href="javascript:;">
							<%=yyzc.getJSONObject(i).getString("logo")%>
							<span><%=yyzc.getJSONObject(i).getString("Name")%></span>
						</a>
						<div class="toggle-wrapper">
							<div class="toggle toggle-light success" data-toggle-on="<%=yyzc.getJSONObject(i).getBoolean("flag")%>"></div>
						</div>
					</li>
				<%}%>
				</ul>	
			</div>

			<div class="config-box yyfb">
	    		<div class="pd-x-10 tx-16 pd-y-10">应用发布</div>
 				<ul>
				<%for(int i=0;i<yyfb.length();i++){%>
					<li class="op-9" pid="<%=yyfb.getJSONObject(i).getString("pid")%>">
						<a href="javascript:;">
							<%=yyfb.getJSONObject(i).getString("logo")%>
							<span><%=yyfb.getJSONObject(i).getString("Name")%></span>
						</a>
						<div class="toggle-wrapper">
							<div class="toggle toggle-light success" data-toggle-on="<%=yyfb.getJSONObject(i).getBoolean("flag")%>"></div>
						</div>
					</li>
				<%}%>
				</ul>	
			</div>
			
			<div class="config-box zyhj">
	       	 	<div class="pd-x-10 tx-16 pd-y-10">资源汇聚</div>
				<ul>	
				<%for(int i=0;i<zyhj.length();i++){%>
					<li class="op-9" pid="<%=zyhj.getJSONObject(i).getString("pid")%>">
						<a href="javascript:;">
							<%=zyhj.getJSONObject(i).getString("logo")%>
							<span><%=zyhj.getJSONObject(i).getString("Name")%></span>
						</a>
						<div class="toggle-wrapper">
							<div class="toggle toggle-light success" data-toggle-on="<%=zyhj.getJSONObject(i).getBoolean("flag")%>"></div>
						</div>
					</li>
				<%}%>
				</ul>	
			</div>

			<div class="config-box scgj">
				<div class="pd-x-10 tx-16 pd-y-10">生产工具</div>
	       	 	<ul>			
				<%for(int i=0;i<scgj.length();i++){%>
					<li class="op-9" pid="<%=scgj.getJSONObject(i).getString("pid")%>">
						<a href="javascript:;">
							<%=scgj.getJSONObject(i).getString("logo")%>
							<span><%=scgj.getJSONObject(i).getString("Name")%></span>
						</a>
						<div class="toggle-wrapper">
							<div class="toggle toggle-light success" data-toggle-on="<%=scgj.getJSONObject(i).getBoolean("flag")%>"></div>
						</div>
					</li>
				<%}%>
				</ul>	
			</div>

		</div><!-- modal-body -->
		<div class="btn-box" >
      		<div class="modal-footer" >
				<button type="button" class="btn btn-primary tx-size-xs" onclick="test();">确认</button>
				<button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		    </div> 
		</div>
	</div>
    
	<script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>
    
	<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
    
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
    <script src="../common/2018/bracket.js"></script>  

	<script>
   	    function test(){
   	        
   	        var ids="";
			var myToggle = $('.op-9');
   	        for(var i=0;i<myToggle.size();i++){

				if(myToggle.eq(i).find('.toggle').data('toggle-active')==true){//开启产品权限
					if(ids!=""){
						ids += ",";
					}
					ids += myToggle.eq(i).attr("pid");
				}
   	        }
            var url = "company_product_sumbit.jsp?ids="+ids+"&cid=<%=companyid%>";
			$.ajax({
				type:"GET",
				url:url, 
				success: function(msg){
					if(msg.trim()==1){
						top.TideDialogClose('');
					}
					
				}
			});
   	    }
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
		})
        
   </script>
</body>
</html>