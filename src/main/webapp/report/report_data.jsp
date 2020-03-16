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
    public static long dateToStamp(String s,String pattern) throws ParseException{
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        java.util.Date date = simpleDateFormat.parse(s);
        long ts = date.getTime()/1000;
        return ts;
    }
	//获取时间段内索引
	public static String getIndex(String start,String end) throws ParseException{
        String Index = "";

        java.util.Date d1 = new SimpleDateFormat("yyyy-MM").parse(start);
        java.util.Date d2 = new SimpleDateFormat("yyyy-MM").parse(end);//定义结束日期

        Calendar dd = Calendar.getInstance();//定义日期实例

        dd.setTime(d1);//设置日期起始时间

        while(dd.getTime().before(d2)){//判断是否到结束日期

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM");

            String str = sdf.format(dd.getTime());
			
			if(eu.indexExists("api_tidemedia_"+str)){//索引存在，拼接索引数组

				if(!Index.equals("")){
					Index += ",";
				}
				Index += "api_tidemedia_"+str;
			}
            dd.add(Calendar.MONTH, 1);//进行当前日期月份加1
        }

		if(eu.indexExists("api_tidemedia_"+end.replace("-","_"))){//索引存在，拼接索引数组

			if(!Index.equals("")){
				Index += ",";
			}
			Index += "api_tidemedia_"+end.replace("-","_");
		}

        return Index;
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

	startTime = dateToStamp(StartDate,"yyyy-MM-dd");
	String index_start = StartDate.substring(0,7);

	endTime = dateToStamp(EndDate,"yyyy-MM-dd");
	String index_end = EndDate.substring(0,7);

	Index = getIndex(index_start,index_end); 
}
String[] userIds = userIDs.split(",");
List<String> useridList = Arrays.asList(userIds);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>工作量统计 TideCMS</title>
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<style>
div.content_wrap {width: 600px;height:380px;}
div.content_wrap div.left{float: left;width: 250px;}
div.content_wrap div.right{float: right;width: 340px;}
div.zTreeDemoBackground {width:250px;height:362px;text-align:left;}
ul.ztree {margin-top: 10px;border: 1px solid #617775;background: #FFFFFF;width:200px;height:200px;overflow-y:scroll;overflow-x:auto;}
</style>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：工作量统计 > 工作量统计 </div>
</div>

<div class="viewpane_c1" id="SearchArea">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>

    <div class="center">
		<table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
		  <tr>
			<td width="20"> </td>
			<td><form name="search_form"  action="report_data.jsp" method="post" onsubmit="return check()">
			姓名：<input type="text" name="Usernames" id="Usernames" value="<%=Usernames%>" class="textfield" size="8" onclick="showUser();" readonly="true"/>
			<input name="userIDs" id="userIDs" type="hidden" value="<%=userIDs%>"/>
			<input name="groupName" id="groupName" type="hidden" value="<%=groupName%>"/>
			频道：<input name="child" id="child" type="text" value="<%=child%>" readonly="true" style="width:120px;" onclick="showMenu(); return false;"></input>
			<input name="child_channel" id="child_channel" type="hidden" value="<%=child_channel%>"/>
			<input name="ischilde" id="ischilde" type="checkbox" value="<%=ischilde%>"  <%if("1".equals(ischilde)) out.print("checked");%>/>包含子频道
			开始时间：<input type="text" name="StartDate" id="StartDate" class="CreateDate"value="<%=StartDate%>" readonly class="textfield" size="12"/>
			结束时间：<input type="text" name="EndDate" id="EndDate" class="textfield" size="12" value="<%=EndDate%>"/>
			<input name="Submit" type="Submit" class="tidecms_btn2" value="查找"/>
			</form></td>
			<td width="20"> </td>
		  </tr>
		</table>
    </div>

    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>

<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>

<div class="content_2012">
	开始时间：<%=StartDate%> &nbsp;&nbsp;&nbsp;&nbsp; 结束时间：<%=EndDate%>
  	<div class="viewpane">
       <div class="viewpane_tbdoy">
		<table id="oTable" class="view_table" width="100%" border="0">
			<thead>
				<tr>
					<th class="v3" style="padding-left:10px;text-align:left;">频道名称</th>
					<th class="v1" valign="middle" align="center">新增数</th>
					<th class="v8" valign="middle" align="center">发布数</th>
					<th class="v8" valign="middle" align="center">草稿数</th>
					<th class="v8" valign="middle" align="center">删除数</th>
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
					<td class="v3" style="font-weight:700;"><img src="../images/tree6.png"><%=channelName%></td>
					<td class="v1" valign="middle" align="center"><%=num%></td>
					<td class="v1" valign="middle" align="center"><%=num1%></td>
					<td class="v1" valign="middle" align="center"><%=num2%></td>
					<td class="v1" valign="middle" align="center"><%=num3%></td>
				</tr>
	<%
			}
			
		}	
	%>
			</tbody> 
		</table> 
       </div>
       <!--<div class="viewpane_pages">
			<div class="left" style="left:10px;">查询用时：<%=(System.currentTimeMillis()-begin_time)%>毫秒</div>
       </div>-->
  </div>
</div>

<div class="content_2012">
	所属用户组：<%=groupName%>
  	<div class="viewpane">
       <div class="viewpane_tbdoy">
		<table id="oTable" class="view_table" width="100%" border="0">
			<thead>
				<tr>
					<th class="v3" style="padding-left:10px;text-align:left;">用户</th>
					<th class="v1" valign="middle" align="center">新增数</th>
					<th class="v8" valign="middle" align="center">发布数</th>
					<th class="v8" valign="middle" align="center">草稿数</th>
					<th class="v8" valign="middle" align="center">删除数</th>
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
					<td class="v3" style="font-weight:700;"><img src="../images/tree6.png"><%=username%></td>
					<td class="v1" valign="middle" align="center"><%=num%></td>
					<td class="v1" valign="middle" align="center"><%=num1%></td>
					<td class="v1" valign="middle" align="center"><%=num2%></td>
					<td class="v1" valign="middle" align="center"><%=num3%></td>
				</tr>
	<%
			}
		}
	%>
			</tbody> 
		</table> 
       </div>
	   <!--<div class="viewpane_pages">
			<div class="left" style="left:10px;">查询用时：<%=(System.currentTimeMillis()-begin_time)%>毫秒</div>
       </div>-->
  </div>
</div>
</body>

<script>

jQuery(document).ready(function(){
	tidecms.setDatePicker("#StartDate");
	tidecms.setDatePicker("#EndDate");
	jQuery("#oTable").tablesorter();
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

	if(!(StartDate < EndDate)){//开始时间不小于结束时间
		alert("开始时间需小于结束时间");
		return false;
	}

	return true;
}

$("#ischilde").click(function(){
	if(this.checked){
		$(this).val("1");
	}else{
		$(this).val("0");
	}
});


function showUser(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(800);
	dialog.setHeight(500);
	dialog.setUrl("report/user_index.jsp");
	dialog.setTitle("选择用户");
	dialog.show();
}

function showMenu(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(450);
	dialog.setUrl("report/channel_report_index.jsp");
	dialog.setTitle("选择频道");
	dialog.show();
}
</script>
</html>