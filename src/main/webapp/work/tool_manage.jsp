<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
//获取分组颜色
public String getGroup(int groupid) throws SQLException,MessageException,JSONException{
	TideJson json = CmsCache.getParameter("tcenter_main").getJson();//首页模块
	JSONArray arr = json.getJSONArray("main");
	for(int i=0;i<arr.length();i++){
		JSONObject json1 = arr.getJSONObject(i);//一级分组
		JSONArray arr1 = json1.getJSONArray("module");
		for(int j=0;j<arr1.length();j++){
			JSONObject json2 = arr1.getJSONObject(j);
			String class_ = json2.getString("class");
			int id = json2.getInt("id");
			if(groupid==id){
				return class_ ;
			}
		}
	}
	return "";
}
%>
<%
    Integer userId = userinfo_session.getId();
   
	String csstype = "yyzc";
   
	String whereSql = "";
	//获取租户的产品权限
	int companyid = userinfo_session.getCompany();
	if(companyid>0){//当前登录用户是租户用户
		String products = new Company(companyid).getProducts();
		if(products.equals("")){products="-1";}
		whereSql += " and tp.id in ("+products+")";
	}

    String sql = "select tp.id pid,up.userid uid,tp.logo,tp.groupId,tp.Name prjname,tp.Url,up.status from tide_products tp left join (select * from user_product where UserId = '"+userId+"') up on tp.id =up.ProductId";
	sql += " where tp.Status = 1 and groupId<5"+whereSql;
	sql += " and tp.Isview = 1";
	sql += " order by tp.OrderNumber asc,tp.id asc";


    TableUtil tu = new TableUtil("user");
    ResultSet Rs = tu.executeQuery(sql);
    
	JSONArray yyzc = new JSONArray();
    JSONArray yyfb = new JSONArray();
    JSONArray zyhj = new JSONArray();
    JSONArray scgj = new JSONArray();
    while(Rs.next()){
        int groupid =0;
        JSONObject obj = new JSONObject();
    	groupid = Rs.getInt("groupId") ;
        obj.put("csstype",csstype);
        obj.put("logo",Rs.getString("logo"));
        obj.put("Name",Rs.getString("prjname"));
        obj.put("Url",Rs.getString("Url"));
        //System.out.println(Rs.getString("status"));
        boolean flag =(("1".equals(Rs.getString("status")))||Rs.getString("status")==null||"".equals(Rs.getString("status")));
        obj.put("flag",flag);
        obj.put("pid",Rs.getString("pid"));
        obj.put("uid",convertNull(Rs.getString("uid")));
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
    
  </head>
  <style>
  	html,body{width: 100%;height: 100%;}  	
	.mg-t--10{margin-top: -10px;}
	.modal-body{top: 0;}

	.fa{font-size: 30px;}
  </style>
  <body class="" id="display-select">
 
    <div class="bg-white modal-box">
      
	    <div class="modal-body pd-20 overflow-y-auto">
	         <div class="config-box yyzc">
			    <div class="pd-x-10 tx-16 pd-y-10">运营支撑</div>
	       	 	<ul>	
				<%for(int i=0;i<yyzc.length();i++){%>
						    	

					<li class="op-9" pid="<%=yyzc.getJSONObject(i).getString("pid")%>"  uid="<%=yyzc.getJSONObject(i).getString("uid")%>">
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
					<li class="op-9" pid="<%=yyfb.getJSONObject(i).getString("pid")%>"  uid="<%=yyfb.getJSONObject(i).getString("uid")%>">
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
					<li class="op-9" pid="<%=zyhj.getJSONObject(i).getString("pid")%>"  uid="<%=zyhj.getJSONObject(i).getString("uid")%>">
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
					<li class="op-9" pid="<%=scgj.getJSONObject(i).getString("pid")%> " uid="<%=scgj.getJSONObject(i).getString("uid")%>">
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
	    
	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

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
   	//开关相关
   	$(function(){
   	    
   	})
   	    function test(){
   	        var myToggle = $('.op-9');
   	        var ids="";
   	        var status="";
   	        for(var i=0;i<myToggle.size();i++){
   	            var s ;
   	            ids = ids + myToggle.eq(i).attr("uid")+"-"+myToggle.eq(i).attr("pid");
                myToggle.eq(i).find('.toggle').data('toggle-active')==true?s=1:s=0;
   	            status =status + s;
   	            
   	            if(i!=myToggle.size()-1){
   	                ids = ids + ",";
   	                status =status +",";
   	            }
   	        }
            var url = "user_product.jsp?status="+status+"&ids="+ids;
    		    $.ajax({
		        	type:"GET",
			        url:url, 
			        success: function(msg){
				        console.log(msg);
				        parent.location.reload();
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
			console.log(myToggle)  //true or false 
		})
        
   </script>
  </body>
</html>
