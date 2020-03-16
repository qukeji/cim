<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.report.*,
				tidemedia.cms.util.*,
				java.util.*,tidemedia.cms.base.*,
				java.util.Calendar,
				java.util.GregorianCalendar"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public  long getFromToday(Calendar nowDate,int day)
{
	nowDate.set(Calendar.DAY_OF_MONTH,day);
	return  nowDate.getTimeInMillis()/1000;
}

public   long getToToday(Calendar nowDate,int day)
{
	nowDate.set(Calendar.DAY_OF_MONTH,day);
	nowDate.add(Calendar.DAY_OF_MONTH,1);
	return  nowDate.getTimeInMillis()/1000;
}

public int getDayCount(int userId,int channelId,Calendar nowDate,int day) throws MessageException, SQLException
{
	int num=0;
	String sql="SELECT count(*) as count FROM item_snap where  Active=1 and Status=1 ";
	sql+="and ChannelCode like '%"+channelId+"%' and user="+userId;
	sql+=" and CreateDate>="+getFromToday((Calendar)nowDate.clone(),day);
	sql+=" and CreateDate<"+getToToday((Calendar)nowDate.clone(),day);
	TableUtil tu = new TableUtil();
	ResultSet rs =tu.executeQuery(sql);
	if(rs.next())
	{
		num=rs.getInt(1);
	}
	tu.closeRs(rs);
	return num;
}
%>
<%
long begin_time = System.currentTimeMillis();
String us = userinfo_session.getUsername();
if(!userinfo_session.isAdministrator())
{ 
	response.sendRedirect("../noperm.jsp");
	return;
}

String ChannelID= getParameter(request,"Channel");

int Year = getIntParameter(request,"Year");
int Month = getIntParameter(request,"Month");
int Current = getIntParameter(request,"Current");
int GroupID = getIntParameter(request,"GroupID");

//if(ChannelID.equals(""))
	//ChannelID="4112";  
//int  maxDay=cal.getActualMaximum(Calendar.DAY_OF_MONTH);
Calendar nowDate = new java.util.GregorianCalendar();
if(Year!=0&&Month!=0){
	nowDate = new java.util.GregorianCalendar();
	nowDate.set(Calendar.DAY_OF_MONTH,1);
	nowDate.set(Calendar.MONTH,Month-1);
	nowDate.set(Calendar.YEAR,Year);
	nowDate.set(Calendar.HOUR_OF_DAY,0);
	nowDate.set(Calendar.MINUTE,0);
	nowDate.set(Calendar.SECOND,0);
}else{
	nowDate=Calendar.getInstance();	
}

int  maxDay=nowDate.getActualMaximum(Calendar.DAY_OF_MONTH);
String Username=getParameter(request,"Username");
String StartDate=getParameter(request,"StartDate");
String EndDate=getParameter(request,"EndDate");
String StartTime=getParameter(request,"StartTime");
String EndTime=getParameter(request,"EndTime");

String href="content.jsp?StartDate="+StartDate+"&EndDate="+EndDate+"&StartTime="+StartTime+"&EndTime"+EndTime+"&Status=2";

String []ChannelIDS=ChannelID.split(",");

UserInfo userinfo = new UserInfo();

	Report report=new Report();
	report.setChannelID(ChannelID);
	report.setUserName(Username);
	report.setStartDate(StartDate);
	report.setEndDate(EndDate);
	report.setStartTime(StartTime);
	report.setEndTime(EndTime);
	report.setGroupID(GroupID);
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
<script src="../lib/2018/select2/js/select2.min.js"></script>

<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.datepicker.js"></script>
<script type="text/javascript">
function openSearch()
{
	jQuery("#SearchArea").toggle();
}
function check(){
	var StartDate=jQuery("#StartDate").val();
	var EndDate=jQuery("#EndDate").val();
	var StartTime=jQuery.trim(jQuery("#StartTime").val()); 
	var EndTime=jQuery.trim(jQuery("#EndTime").val()); 
	//if(StartDate=="" && EndDate==""){
		//alert("开始时间和结束时间必须选择一个!");
		//return false;
	//}
	/****
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
	}
	***/
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
					if(index==0)
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
					if(obj.id==<%=userinfo_session.getGroup()%>)
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
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">  
        <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">系统管理 / 工作量统计 / 月报表 </span>
        </nav>
        </div><!-- br-pageheader -->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
       
        <div class="btn-group mg-l-10 hidden-xs-down">
		  <a href="#" class="btn btn-outline-info btn-search" onClick="openSearch();">检索</a>       
        </div><!-- btn-group -->
     </div>
	  <!--搜索-->
     <div class="search-box pd-x-20 pd-sm-x-30" id="SearchArea" style="display:;">
		<div class="search-content bg-white">
			<form name="search_form"  action="report22018.jsp" method="post">
      		<div class="row">
				<!--用户信息-->
				<div class="wd-40 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">检索:</div>
				<div class="mg-r-20 mg-b-40 search-item">
                        <input class="form-control " placeholder="用户名" type="text" size="8" name="Username" id="Username" value="<%=Username%>" >                                
				</div>	
				<!--用户组-->
				<div class="wd-60 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">用户组：</div>           
				<div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
					<select class="form-control select2" name="GroupID" id="GroupID"></select>
				</div> 
				<!--站点-->
				<div class="wd-60 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">站点：</div>           
				<div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
					<select class="form-control select2" name="Channel" id="Channel"></select>
				</div> 
				<!--日期-->    
               	<div class="wd-40 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">年:</div>
                 <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
					<select class="form-control select2" name="Year" id="Year">
					<%
					  Calendar nowYear = new GregorianCalendar();
					  int year = nowYear.get(1);
					  for(int i=year-5;i<=year+5;i++){
					  %>
						<option value="<%=i%>"><%=i%></option>
					  <%
					  }
					%>
					</select>
				</div>
				 <div class="wd-40 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">月:</div> 				
				 <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
					<select class="form-control select2" name="Month" id="Month">
					 <option value="1">1</option>
					  <option value="2">2</option>
					  <option value="3">3</option>
					  <option value="4">4</option>
					  <option value="5">5</option>
					  <option value="6">6</option>
					  <option value="7">7</option>
					  <option value="8">8</option>
					  <option value="9">9</option>
					  <option value="10">10</option>
					  <option value="11">11</option>
					  <option value="12">12</option>
					</select>
				</div> 	
                  				
				<div class="search-item mg-b-30">
					<input name="Submit" type="Submit" value="查找" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14" />
				</div>
				<input type="hidden" name="OpenSearch" id="OpenSearch" value="0">
			</div><!-- row -->
			</form>
      	</div>
     </div><!--搜索-->	
	 
<div class="br-pagebody pd-x-20 pd-sm-x-30">
 <%if(!ChannelID.equals("")){%>
            <div class="channel-preview">
	  				<span class="tx-14 mg-r-10">频道名称：<%for(String c:ChannelIDS){out.print(CmsCache.getChannel(Integer.parseInt(c)).getParentChannel().getName()+" ");}%></span>	  				
	        </div>
		<div class="card bd-0 shadow-base">		
			<table class="table mg-b-0" id="content-table">
				<thead>
               
				  <tr>				
					<th class="tx-12-force tx-mont tx-medium">用户名</th>
                   <%for(int i=1;i<=maxDay;i++){%>						
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down"><%=i%></th>
                   <%}%>						    
				  </tr>		                         					  
				</thead>
			<tbody>
<%
String ListSql = "select * from userinfo";
String CountSql = "select count(*) from userinfo";
if(!Username.equals("")){
	ListSql += " where Name like '%"+Username+"%'";
	CountSql += " where Name like '%"+Username+"%'";	
}else if(GroupID!=0){
	ListSql += " where GroupID=" + GroupID;
	CountSql +=" where GroupID=" + GroupID;
}
ListSql +=" order by Role,id";
TableUtil tu = new TableUtil("user");
ResultSet Rs=tu.List(ListSql,CountSql,1,1000);
while(Rs.next())
{
	String Name = convertNull(Rs.getString("Name"));
	int userId = Rs.getInt("id");
	
%>
       <tr>
			<td class="hidden-xs-down"><%=Name%></td>	
			<% 
		for(int day=1;day<=maxDay;day++){
			int dayCount=0;
			long from=getFromToday((Calendar)nowDate.clone(),day);
			long to=getToToday((Calendar)nowDate.clone(),day);
			String sql2="";
			for(String c:ChannelIDS){		
				dayCount+=getDayCount(userId,Integer.parseInt(c),nowDate,day);
			}%>
			<td class="hidden-xs-down"><%=dayCount%></td>
		  <% 			
		   }
		   %>
		</tr>
<%}
tu.closeRs(Rs);
%>		
 </tbody> 
</table> 
<%}//end if(ChannelID>0)%>
<script>
 
jQuery(document).ready(function(){
document.search_form.GroupID.value = <%=GroupID%>;
document.search_form.Channel.value = '<%=ChannelID%>';
jQuery("#oTable").tablesorter({ 
            headers: { 
                7: { 
                    sorter:'digit' 
                } 
            }
        });
 jQuery("#Year").val('<%=nowDate.get(Calendar.YEAR)%>');
 jQuery("#Month").val('<%=nowDate.get(Calendar.MONTH)+1%>');
});
</script>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
