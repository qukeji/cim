<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.report.*,
				tidemedia.cms.util.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：工作量统计 报表
* 1,李永海 20140101 创建
* 2,曲科籍 20151120  当以时间检索时去掉   今天  昨天 。。。。标签
* 3,
* 4,
* 5,
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

String ChannelID= getParameter(request,"Channel");

int Year = getIntParameter(request,"Year");
int Month = getIntParameter(request,"Month");
int Current = getIntParameter(request,"Current");
int GroupID = getIntParameter(request,"GroupID");

String Username=getParameter(request,"Username");
String StartDate=getParameter(request,"StartDate");
String EndDate=getParameter(request,"EndDate");
//String StartTime=getParameter(request,"StartTime");
//String EndTime=getParameter(request,"EndTime");

String href="content.jsp?StartDate="+StartDate+"&EndDate="+EndDate+"&Status=2";//&StartTime="+StartTime+"&EndTime"+EndTime+;

String []ChannelIDS=ChannelID.split(",");

UserInfo userinfo = new UserInfo();

	Report report=new Report();
	report.setChannelID(ChannelID);
	report.setUserName(Username);
	report.setStartDate(StartDate);
	report.setEndDate(EndDate);
	report.setStartTime("00:00:00");
	report.setEndTime("23:59:59");
	report.setGroupID(GroupID);

long begin_time = System.currentTimeMillis();
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
<script type="text/javascript">
var ChannelID = "<%=ChannelID%>";
var GroupID = "<%=GroupID%>";

function openSearch()
{
	jQuery("#SearchArea").toggle();
}
function check(){
	var StartDate=jQuery("#StartDate").val();
	var EndDate=jQuery("#EndDate").val();
	//var StartTime=jQuery.trim(jQuery("#StartTime").val()); 
	//var EndTime=jQuery.trim(jQuery("#EndTime").val()); 
	//if(StartDate=="" && EndDate==""){
	//	alert("开始时间和结束时间必须选择一个!");
	//	return false;
	//}
	/*
	var reg=/^[0-9]{2}:[0-9]{2}$/g;
	if(!reg.test(StartTime)){
		alert("开始时间格式为:(2009-03-10 12:20)!");
		jQuery("#StartTime").focus();
		return false;
	}
	
	var reg=/^[0-9]{2}:[0-9]{2}$/g;
	if(!reg.test(EndTime)){
		alert("结束时间格式为:(2009-03-10 12:20)!");
		jQuery("#EndTime").focus();
		return false;
	}*/
	return true;
}

$(function(){
	$.ajax({
			url:"site_data.jsp",
			type:"post",
			dataType:"json",
			data:"",
			success:function(data)
			{	var html = "";
				$.each(data,function(index,obj)
				{
					if((ChannelID=="" && index==0) || ChannelID==obj.id)
						html +='<option value="'+obj.id+'" selected="selected">'+obj.name+'</option>';
					else 
						html +='<option value="'+obj.id+'">'+obj.name+'</option>';
				});
				$("#Channel").html(html);
			}
		
	});

	$.ajax({
			url:"user_data.jsp",
			type:"post",
			dataType:"json",
			data:"",
			success:function(data)
			{	var html = "";
				$.each(data,function(index,obj)
				{
					if(GroupID==obj.id)
						html +='<option value="'+obj.id+'" selected="selected">'+obj.name+'</option>';
					else 
						html +='<option value="'+obj.id+'">'+obj.name+'</option>';
				});
				$("#GroupID").html(html);
			}
		
	});
	
});
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav"> </div>
    <div class="content_new_post">
       <div class="tidecms_btn" onClick="openSearch();">
			<div class="t_btn_pic"><img src="../images/icon/preview.png" /></div>
			<div class="t_btn_txt">检索</div>
		</div>
    </div>
</div>
<div class="viewpane_c1" id="SearchArea" style="display:;">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20"> </td>
    <td><form name="search_form"  action="report.jsp" method="post">检索：
		用户名：<input type="text" name="Username" id="Username" value="<%=Username%>" class="textfield" size="8"/>
		用户组：<select name="GroupID" id="GroupID">
                          
        </select>
		 站点：<select name="Channel" id="Channel">
		  </select>
		  </select>
		  开始时间：<input type="text" name="StartDate" id="StartDate" class="CreateDate"value="<%=StartDate%>" readonly class="textfield" size="12"/>
		  结束时间：<input type="text" name="EndDate" id="EndDate" class="textfield" size="12" value="<%=EndDate%>"/>
		  
		  <input type="hidden" name="Current" value="4"/>

	<input name="Submit" type="Submit" class="tidecms_btn2" value="查找" />

	<input type="hidden" name="OpenSearch" id="OpenSearch" value="0"></form></td>
    <td width="20"> </td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
<div class="content_2012">
  	<div class="viewpane">

        <div class="viewpane_tbdoy">
<%if(!ChannelID.equals("")){%>        
<div style="padding:0 0 8px;">

    频道名称：<%for(String c:ChannelIDS){out.print(CmsCache.getChannel(Integer.parseInt(c)).getParentChannel().getName()+" ");}%>
    开始时间：<%=StartDate%>
    结束时间：<%=EndDate%>
</div>      
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
	<%if(!Username.equals("")){%>
		<tr>
    				<th class="v3" style="padding-left:10px;text-align:left;" width="100">姓名</th>
    				<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">频道</th>
					<%if(StartDate==null||StartDate.equals("")){%>
    				<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">今天</th>
    				<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">昨日</th>
    				<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">本周</th>
    				<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">本月</th>
    				<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">本年</th>
					<%}%>
    				<th class="v8" style="padding-left:10px;text-align:left;" valign="middle" width="100" id="releaseId">发稿量</th>
    				<th class="v9"  align="left" valign="middle"></th>
  		</tr>
  	<%}else if(GroupID!=0){%>
  		<tr>
    			<th class="v3" style="padding-left:10px;text-align:left;" width="100">部门</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">姓名</th>
				<%if(StartDate==null||StartDate.equals("")){%>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">今天</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">昨日</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">本周</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">本月</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">本年</th>
				<%}%>
    			<th class="v8" style="padding-left:10px;text-align:left;" valign="middle" width="100" id="releaseId">发稿量</th>
    			<th class="v9"  align="left" valign="middle"></th>
  		</tr>
  	<%}else{%>
  		<tr>
    			<th class="v3" style="padding-left:10px;text-align:left;" width="100">频道</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">姓名</th>
				<%if(StartDate==null||StartDate.equals("")){%>
   				<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">今天</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">昨日</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">本周</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">本月</th>
    			<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="100">本年</th>
				<%}%>
    			<th class="v8" style="padding-left:10px;text-align:left;" valign="middle" width="100" id="releaseId">发稿量</th>
                        <th class="v9"  align="left" valign="middle"></th>
    			
  		</tr>
  	<%}%>			
</thead>
 <tbody> 
<%if(!Username.equals("")){
	ArrayList list=report.listByUserName();
	for(int i=0;i<list.size();i++){
	 ReportList reportList=(ReportList)list.get(i);
	 String h=href+"&id="+reportList.getChannelId()+"&UserId="+reportList.getUserId();
	 String Today=h+"&type=Today";
	 String Yesterday=h+"&type=Yesterday";
	 String Week=h+"&type=Week";
	 String Month1=h+"&type=Month";
	 String Year1=h+"&type=Year";
	 String Total=h+"&type=Total";
	 if(reportList.getCountToday()!=0||reportList.getCountYesterday()!=0||reportList.getCountWeek()!=0||reportList.getCountMonth()!=0||reportList.getCountYear()!=0||reportList.getTotal()!=0){
%>
  <tr>
   		<td class="v3" style="padding-left:10px;text-align:left;"><%=reportList.getUserName()%></td>
    	<td class="v1"	style="padding-left: 10px;"  align="left" valign="middle"><%=reportList.getChannelName()%></td>
		<%if(StartDate==null||StartDate.equals("")){%>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><a href="<%=Today%>" target="_blank"><%=reportList.getCountToday()%></a></td>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><a href="<%=Yesterday%>" target="_blank"><%=reportList.getCountYesterday()%></a></td>
    	<td class="v8" style="padding-left: 10px;"   align="left" valign="middle"><a href="<%=Week%>" target="_blank"><%=reportList.getCountWeek()%></a></td>
    	<td class="v8" style="padding-left: 10px;"   align="left" valign="middle"><a href="<%=Month1%>" target="_blank"><%=reportList.getCountMonth()%></a></td>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><a href="<%=Year1%>" target="_blank"><%=reportList.getCountYear()%></a></td>
		<%}%>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><a href="<%=Total%>" target="_blank"><%=reportList.getTotal()%></a></td>
		<td class="v9"></td>
  </tr>
<%} }
}else if(GroupID!=0){
	ArrayList list=report.listByGroup();
	for(int i=0;i<list.size();i++){
	 ReportList reportList=(ReportList)list.get(i);
%>
  <tr>
   		<td class="v3" style="padding-left:10px;text-align:left;"><%=reportList.getGroupName()%></td>
    	<td class="v1"	style="padding-left: 10px;"  align="left" valign="middle"><%=reportList.getUserName()%></td>
		<%if(StartDate==null||StartDate.equals("")){%>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><%=reportList.getCountToday()%></td>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><%=reportList.getCountYesterday()%></td>
    	<td class="v8" style="padding-left: 10px;"   align="left" valign="middle"><%=reportList.getCountWeek()%></td>
    	<td class="v8" style="padding-left: 10px;"   align="left" valign="middle"><%=reportList.getCountMonth()%></td>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><%=reportList.getCountYear()%></td>
		<%}%>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><%=reportList.getTotal()%></td>
		<td class="v9"></td>
  </tr>
<% }
}else{
	ArrayList list=report.listByUserName();
	for(int i=0;i<list.size();i++){
	 ReportList reportList=(ReportList)list.get(i);
	 String h=href+"&id="+reportList.getChannelId()+"&UserId="+reportList.getUserId();
	 String Today=h+"&type=Today";
	 String Yesterday=h+"&type=Yesterday";
	 String Week=h+"&type=Week";
	 String Month1=h+"&type=Month";
	 String Year1=h+"&type=Year";
	 String Total=h+"&type=Total";
	 if(reportList.getCountToday()!=0||reportList.getCountYesterday()!=0||reportList.getCountWeek()!=0||reportList.getCountMonth()!=0||reportList.getCountYear()!=0||reportList.getTotal()!=0){	 
%>
  <tr>
   		<td class="v3" style="padding-left:10px;text-align:left;"><%=reportList.getChannelName()%></td>
    	<td class="v1"	style="padding-left: 10px;"  align="left" valign="middle"><%=reportList.getUserName()%></td>
		<%if(StartDate==null||StartDate.equals("")){%>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><a href="<%=Today%>" target="_blank"><%=reportList.getCountToday()%></a></td>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><a href="<%=Yesterday%>" target="_blank"><%=reportList.getCountYesterday()%></a></td>
    	<td class="v8" style="padding-left: 10px;"   align="left" valign="middle"><a href="<%=Week%>" target="_blank"><%=reportList.getCountWeek()%></a></td>
    	<td class="v8" style="padding-left: 10px;"   align="left" valign="middle"><a href="<%=Month1%>" target="_blank"><%=reportList.getCountMonth()%></a></td>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><a href="<%=Year1%>" target="_blank"><%=reportList.getCountYear()%></a></td>
		<%}%>
    	<td class="v8"  style="padding-left: 10px;"  align="left" valign="middle"><a href="<%=Total%>" target="_blank"><%=reportList.getTotal()%></a></td>
		<td class="v9"></td>
  </tr>
<%}}
}%>
 <tr >
   		<td class="v3" style="padding-left:10px;text-align:left;"  width="100">合计</td>
    	<td class="v1"	style="padding-left: 10px;" align="left" valign="middle"  width="100"></td>
		<%if(StartDate==null||StartDate.equals("")){%>
    	<td class="v8"  style="padding-left: 10px;" align="left" valign="middle"  width="100"><%=report.getCountToday()%></td>
    	<td class="v8"  style="padding-left: 10px;" align="left" valign="middle"  width="100"><%=report.getCountYesterday()%></td>
    	<td class="v8"  style="padding-left: 10px;" align="left" valign="middle"  width="100"><%=report.getCountWeek()%></td>
    	<td class="v8"  style="padding-left: 10px;" align="left" valign="middle"  width="100"><%=report.getCountMonth()%></td>
    	<td class="v8"  style="padding-left: 10px;" align="left" valign="middle"  width="100"><%=report.getCountYear()%></td>
		<%}%>
    	<td class="v8"  style="padding-left: 10px;" align="left" valign="middle"  width="100"><%=report.getTotal()%></td>
		<td class="v9"></td>
   </tr> 
 </tbody>   
</table>
 
<%}//end if(ChannelID>0)%>
        </div>
        <div class="viewpane_pages">    
          查询用时：<%=(System.currentTimeMillis()-begin_time)%>毫秒
        </div>
    
  </div>
</div>
<script>
 
jQuery(document).ready(function(){
tidecms.setDatePicker("#StartDate");
tidecms.setDatePicker("#EndDate");
//document.search_form.Year.value = <%=Year%>;
//document.search_form.Month.value = <%=Month%>;
jQuery("#oTable").tablesorter();
/*
jQuery("#oTable").tablesorter({ 
            headers: { 
                7: { 
                    sorter:'digit' 
                } 
            },sortList:[[2,1]] 
        });*/
});
</script>

</body>
</html>
