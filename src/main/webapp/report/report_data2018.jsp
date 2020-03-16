<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.text.*,
				java.util.*"%>
<%@ page import="org.elasticsearch.search.builder.SearchSourceBuilder" %>
<%@ page import="org.elasticsearch.index.query.QueryBuilders" %>
<%@ page import="org.elasticsearch.index.query.BoolQueryBuilder" %>
<%@ page import="org.elasticsearch.action.search.SearchResponse" %>
<%@ page import="org.elasticsearch.search.sort.SortOrder" %>
<%@ page import="org.elasticsearch.search.SearchHits" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!

	public static  ESUtil2019 eu  = null;

	//初始化
	public static void init1(){
		eu = ESUtil2019.getInstance();
	}

	//查询ES库数据量
	public static long ESQuery(String Index , String parameter,int type,List<String> useridList){
		long num = 0;
    	try{

			if(type==1){
				parameter += " AND Status:1 NOT Active:0";
			}else if(type==2){
				parameter += " AND Status:0 NOT Active:0";
			}else if(type==3){
				parameter += " AND Active:0";
			}

			BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
			boolQuery.must(QueryBuilders.queryStringQuery(parameter));
			boolQuery.must(QueryBuilders.termsQuery("User", useridList));

			//String indexs[] = Index.split(",");

			SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
			searchSourceBuilder.query(boolQuery);
			searchSourceBuilder.sort("GlobalID", SortOrder.ASC);

			SearchResponse response = eu.searchDocument(Index, "document", searchSourceBuilder);

			SearchHits hits = response.getHits();
			num = (int) hits.getTotalHits().value;//ES查询总数

		}catch (Exception e) {
			System.out.println(e.getMessage());
		}
    	return num;
    }

	 //日期转时间戳
    public static long dateToStamp(String date,String pattern,String time) throws ParseException{
        Calendar calendar = Calendar.getInstance();
        long fromtime = 0L;
        if (!(date.equals(""))) {
            String[] s = date.split("-");
            calendar.set(5, Integer.parseInt(s[2]));
            calendar.set(2, Integer.parseInt(s[1]) - 1);
            calendar.set(1, Integer.parseInt(s[0]));

            String[] t = time.split(":");
            calendar.set(11, Integer.parseInt(t[0]));
            calendar.set(12, Integer.parseInt(t[1]));
            calendar.set(13, Integer.parseInt(t[2]));
            fromtime = calendar.getTimeInMillis() / 1000L;
        }
        return fromtime;
    }
%>
<%
/**
* 用途：工作量统计 报表
* 
*/
String us = userinfo_session.getUsername();

String us_ = CmsCache.getParameterValue("report_user")+",";

if(!(userinfo_session.isAdministrator()) && !us_.contains(us+","))
{ 
	response.sendRedirect("../noperm.jsp");
	return;
}

if(!(userinfo_session.isAdministrator()))
{ 
	response.sendRedirect("../noperm.jsp");
	return;
}
long begin_time = System.currentTimeMillis();//页面开始加载时间

String child_channel	= getParameter(request,"child_channel");//频道编号
String ischilde			= getParameter(request,"ischilde");//是否包含子频道
String child			= getParameter(request,"child");//频道
String Usernames		= getParameter(request,"Usernames");//用户名
String userIDs			= getParameter(request,"userIDs");//用户编号
String groupName		= getParameter(request,"groupName");//用户组名
String StartDate		=getParameter(request,"StartDate");//开始时间
String EndDate			=getParameter(request,"EndDate");//结束时间

if(!child_channel.equals("")){//说明是检索操作，初始化ES
	init1();
}

long startTime = 0;
long endTime = 0;
String Index = "";
if(!StartDate.equals("")){

	startTime = dateToStamp(StartDate,"yyyy-MM-dd","00:00:00");
	String index_start = StartDate.substring(0,4);

	endTime = dateToStamp(EndDate,"yyyy-MM-dd","23:59:59");
	String index_end = EndDate.substring(0,4);

	//Index = eu.getIndex(index_start,index_end);
}
System.out.println("Index:"+Index);
String[] userIds = userIDs.split(",");
List<String> useridList = Arrays.asList(userIds);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>工作量统计 TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">
<style>
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>

<script type="text/javascript">

jQuery(document).ready(function(){
	
});

function check(){
	var Usernames = $("input[id='Usernames']").val();//姓名
	var child = $("input[id='child']").val();//频道
	var StartDate = $("input[id='StartDate']").val();//开始时间
	var EndDate = $("input[id='EndDate']").val();//结束时间

	if(Usernames==""||child==""||StartDate==""||EndDate==""){
		alert("姓名，频道，开始时间，结束时间不能为空");
		return false;
	}

	if(StartDate>EndDate){//开始时间能大于结束时间
		alert("开始时间不能大于结束时间");
		return false;
	}

	return true;
}


function getIschilde(this_){
	if(this_.checked){
		$(this_).val("1");
	}else{
		$(this_).val("0");
	}
}


function showUser(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(800);
	dialog.setHeight(500);
	dialog.setUrl("user_index.jsp");
	dialog.setTitle("选择用户");
	dialog.show();
}

function showMenu(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(450);
	dialog.setUrl("channel_report_index.jsp");
	dialog.setTitle("选择频道");
	dialog.show();
}
</script>
</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  

	<div class="br-pageheader pd-y-15 pd-md-l-20">
		<nav class="breadcrumb pd-0 mg-0 tx-12">
		  <span class="breadcrumb-item active">系统管理 / 工作量统计 / 工作量统计</span>
		</nav>
	</div><!-- br-pageheader -->

	 <!--搜索-->
     <div class="search-box pd-x-20 pd-sm-x-30" >
		<div class="search-content bg-white">
			<form name="search_form"  action="report_data2018.jsp" method="post" onsubmit="return check()">
      		<div class="row">
				<!--用户信息-->
				<div class="mg-r-10 mg-b-30 search-item">
					<input class="form-control" placeholder="姓名" type="text" name="Usernames" id="Usernames" size="8" value="<%=Usernames%>" onClick="showUser()" readonly="true"/>
					<input name="userIDs" id="userIDs" type="hidden" value="<%=userIDs%>"/>
					<input name="groupName" id="groupName" type="hidden" value="<%=groupName%>"/>
				</div>
                <!--频道名称-->				
				<div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
					<input class="form-control" placeholder="频道" name="child" id="child" type="text" value="<%=child%>" readonly="true" onclick="showMenu(); return false;"/>
					<input name="child_channel" id="child_channel" type="hidden" value="<%=child_channel%>"/>
				</div> 
				<!--包含子频道-->
				<div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item d-flex align-items-center justify-content-start ht-40">
					 <label class="ckbox mg-b-0">
                        <input  type="checkbox" size="8" name="ischilde" id="ischilde" value="<%=ischilde%>" <%if("1".equals(ischilde)) out.print("checked");%>  onclick="getIschilde(this)"/> <span>包含子频道</span>                             
				     </label>
				</div> 
				<!--日期-->    
                <div class="wd-200 mg-b-30 mg-r-10 search-item">
					<div class="input-group">
						<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
						<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="StartDate" id="StartDate" value="<%=StartDate%>" size="12">
					</div>
				</div>		
                <div class="wd-40 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div> 				
				<div class="wd-200 mg-b-30 mg-r-10 search-item">
					<div class="input-group">
						<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
						<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="EndDate" id="EndDate" size="12" value="<%=EndDate%>"/>
					</div>
				</div>	
				<div class="search-item mg-b-30">
					<input name="Submit" type="Submit" value="查找" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14" />
				</div>
			</div><!-- row -->
			</form>
      	</div>
     </div><!--搜索-->	
	 
	<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="channel-preview">	  				
				<span class="tx-14 mg-r-10">开始时间：<%=StartDate%></span>
				<span class="tx-14 mg-r-10">结束时间：<%=EndDate%></span>
		</div>
		<div class="card bd-0 shadow-base">		
			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>				
					<th class="tx-12-force tx-mont tx-medium">频道名称</th>						
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">新增数</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布数</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">草稿数</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">删除数</th>	
				  </tr>		            				  
				</thead>
				<tbody id="content_data">
<%		
		String channelcodes = "";

		if(!child_channel.equals("")){

			String channels[] = child_channel.split(",");
			String channelNames[] = child.split(",");

			for(int i=0;i<channels.length;i++){

				String channelName = channelNames[i] ;
				int channelId = Integer.parseInt(channels[i]);
				Channel channel = new Channel(channelId);
				String channelcode = channel.getChannelCode();
				if(ischilde.equals("1")){
					channelcode += "*";
				}

				if(channelcodes!=""){
					channelcodes += " OR ";
				}
				channelcodes += channelcode;
				
				String parameter = "ChannelCode:"+channelcode+" AND CreateDate:["+startTime+" TO "+endTime+"]";
				long num  = ESQuery(Index,parameter,0,useridList);
				long num1 = ESQuery(Index,parameter,1,useridList);
				long num2 = ESQuery(Index,parameter,2,useridList);
				long num3 = ESQuery(Index,parameter,3,useridList);
	%>
		<tr id="item_">
			<td class="hidden-xs-down"><%=channelName%></td>	
			<td class="hidden-xs-down"><%=num%></td>			
            <td class="hidden-xs-down"><%=num1%></td> 		  
			<td class="hidden-xs-down"><%=num2%></td>
			<td class="hidden-xs-down"><%=num3%></td>
		</tr>
<%
			}
			
		}	
%>
         </tbody> 
        </table> 			
		</div>
	 </div>
	 <!---第二个分组-->
	 <div class="br-pagebody pd-x-20 pd-sm-x-30">
	   <div class="channel-preview">	  				
	  				<span class="tx-14 mg-r-10">所属用户组：<%=groupName%></span>	  				
	    </div>
		<div class="card bd-0 shadow-base">		
			<table class="table mg-b-0" id="content-table">
				<thead>             
				  <tr>				
					<th class="tx-12-force tx-mont tx-medium">用户</th>						
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">新增数</th>                				
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布数</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">草稿数</th>	
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">删除数</th>	
				  </tr>		            				  
				</thead>
				<tbody id="content_data">
<%
		if(!userIDs.equals("")){

			String usernames[] = Usernames.split(",");

			for(int i=0;i<userIds.length;i++){

				String username = usernames[i] ;
				String[] userIds_ = userIds[i].split(",");
				List<String> useridList_ = Arrays.asList(userIds_);

				String parameter = "ChannelCode:(" + channelcodes + ") AND CreateDate:["+startTime+" TO "+endTime+"]";
				long num  = ESQuery(Index,parameter,0,useridList_);
				long num1 = ESQuery(Index,parameter,1,useridList_);
				long num2 = ESQuery(Index,parameter,2,useridList_);
				long num3 = ESQuery(Index,parameter,3,useridList_);
	%>
<tr id="item_">
			<td class="hidden-xs-down"><%=username%></td>	
			<td class="hidden-xs-down"><%=num%></td>			
            <td class="hidden-xs-down"><%=num1%></td> 		  
			<td class="hidden-xs-down"><%=num2%></td>
			<td class="hidden-xs-down"><%=num3%></td>
		</tr>
<%
			}
		}
	%>
 </tbody> 
</table> 
	  </div>
	 </div>
	 </div>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>
    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>	
    <script src="../common/2018/bracket.js"></script> 
	<script src="../lib/2018/select2/js/select2.min.js"></script>
<script>
	//搜索日期鼠标移入弹出  
	tidecms.setDatePicker(".fc-datepicker");
</script>
</body>
</html>
