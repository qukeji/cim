<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
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
    Integer type= getIntParameter(request,"type");
	String csstype = "yyzc";

	String whereSql = "";
	//获取租户的产品权限
	int companyid = userinfo_session.getCompany();
    int role1 = userinfo_session.getRole();
    boolean yunying1 = userinfo_session.hasPermission("OperateSystem");
	if(companyid>0){//当前登录用户是租户用户
		String products = new Company(companyid).getProducts();
		if(products.equals("")){products="-1";}
		whereSql += " and tp.id in ("+products+")";
	}

    String sql = "select tp.id pid,up.userid uid,tp.logo,tp.Name prjname,tp.Url,up.status from tide_products tp left join (select * from user_product where UserId = '"+userId+"') up on tp.id =up.ProductId";
	sql += " where tp.Status = 1 and groupId="+type+whereSql;
	sql += " order by tp.OrderNumber asc,tp.id asc";


    TableUtil tu = new TableUtil("user");
    ResultSet Rs = tu.executeQuery(sql);
    JSONArray array = new JSONArray();
	if(type==1){
        csstype = "yyzc";
    }else if(type==2){
        csstype = "yyfb";
    }else if(type==3){
        csstype = "zyhj";
    }else if(type==4){
        csstype = "scgj";
    }else{
		csstype = getGroup(type);
	}
    while(Rs.next()){
        if("租户运营中心".equals(Rs.getString("prjname"))||"平台管理中心".equals(Rs.getString("prjname"))){
            if(role1!=1){
                continue;
            }
            if(role1==1&&companyid!=0){
                continue;
            }
            if("租户运营中心".equals(Rs.getString("prjname"))){
                if(!yunying1){
                    continue;
                }
            }
        }
        if("租户运营首页".equals(Rs.getString("prjname"))){
            if(!(role1==1&&companyid!=0)){
                continue;
            }
        }
        JSONObject obj = new JSONObject();
        obj.put("logo",Rs.getString("logo"));
        obj.put("prjname",Rs.getString("prjname"));
        obj.put("Url",Rs.getString("Url"));
        //System.out.println(Rs.getString("status"));
        boolean flag =(("1".equals(Rs.getString("status")))||Rs.getString("status")==null||"".equals(Rs.getString("status")));
        obj.put("status",flag);
        obj.put("pid",Rs.getString("pid"));
        obj.put("uid",convertNull(Rs.getString("uid")));
        array.put(obj);
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
    <link href="lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    
    <link href="lib/2018/highlightjs/github.css" rel="stylesheet"> 
    <link href="lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="style/2018/bracket.css">    
    <link rel="stylesheet" href="style/2018/common.css">
	<link rel="stylesheet" href="style/2018/login_tcenter.css">
    
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
	        <div class="config-box <%=csstype%>">
	       	 	<ul>
	       	 	    <%for(int i=0;i<array.length();i++){%>
		    		<li class="op-9"  pid="<%=array.getJSONObject(i).getString("pid")%>" uid="<%=array.getJSONObject(i).getString("uid")%>">
		    			<a href="javascript:;">
		    			    <%=array.getJSONObject(i).getString("logo")%>
		    				<span><%=array.getJSONObject(i).getString("prjname")%></span>
		    			</a>
						<div class="toggle-wrapper">
							<div class="toggle toggle-light success" data-toggle-on="<%=array.getJSONObject(i).getBoolean("status")%>"></div>
						</div>
		    		</li>
		    		<%}%>
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

    <script src="lib/2018/jquery/jquery.js"></script>
    <script src="lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="lib/2018/popper.js/popper.js"></script>
    <script src="lib/2018/bootstrap/bootstrap.js"></script>
    <script src="lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="lib/2018/moment/moment.js"></script>
    
    <script src="lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="lib/2018/peity/jquery.peity.js"></script>
    
	  <script src="lib/2018/highlightjs/highlight.pack.js"></script>
    
    <script src="lib/2018/select2/js/select2.min.js"></script>
    <script src="lib/2018/jquery-toggles/toggles.min.js"></script>
    <script src="common/2018/bracket.js"></script>    
    
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
