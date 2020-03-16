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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>工作量统计 TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
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
<body>
<div class="content_t1">
	<div class="content_t1_nav">&nbsp;</div>
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
    <td width="20">&nbsp;</td>
    <td><form name="search_form"  action="report2.jsp" method="post" onsubmit="return check();">检索：
		用户名：<input type="text" name="Username" id="Username" value="<%=Username%>" class="textfield" size="8"/>
		用户组：<select name="GroupID" id="GroupID">
                         
             </select>
		  站点：<select name="Channel" id="Channel">
		  
		  </select>
		
		查询 年：<select name="Year" id="Year">
		  <%
		  Calendar nowYear = new GregorianCalendar();
		  int year = nowYear.get(1);
		  for(int i=year-5;i<=year+5;i++){
		  %>
		    <option value="<%=i%>"><%=i%></option>
		  <%
		  }
		  %>
		  <!--<option value="2007">2007</option>
		  <option value="2008">2008</option>
		  <option value="2009">2009</option>
		  <option value="2010">2010</option>
		  <option value="2011">2011</option>
		  <option value="2012">2012</option>
		  <option value="2013">2013</option>
		  <option value="2014">2014</option>
		  <option value="2015">2015</option>
		  <option value="2016">2016</option>
		  <option value="2017">2017</option>
		  <option value="2018">2018</option>
		  <option value="2019">2019</option>
		  <option value="2020">2020</option>-->

		  </select>
		  月：<select name="Month" id="Month">
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
		<!-- 开始时间：<input type="text" name="StartDate" id="StartDate" value="<%=StartDate%>" readonly class="textfield" size="12"/>
		  <input type="text" name="StartTime" id="StartTime"  class="textfield" size="8" value="<%=StartTime.equals("")?"00:00":StartTime%>"/>
		  结束时间：<input type="text" name="EndDate" id="EndDate" class="textfield" size="12" value="<%=EndDate%>"/>
		  <input type="text" name="EndTime" id="EndTime"  value="<%=EndTime.equals("")?"00:00":EndTime%>" class="textfield" size="8"/>
		  <input type="hidden" name="Current" value="4"/> -->  

   <input name="Submit" type="Submit" class="tidecms_btn2" value="查找" /><input type="hidden" name="OpenSearch" id="OpenSearch" value="0"></form></td>
    <td width="20">&nbsp;</td>
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
</div>      
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v3" style="padding-left:10px;text-align:left;" width="100"></th>
    			<%for(int i=1;i<=maxDay;i++){%>	
    				<th class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="20"><%=i%></th>
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
   		<td class="v3" style="padding-left:10px;text-align:left;"><%=Name%></td>
		<% 
		for(int day=1;day<=maxDay;day++){
			int dayCount=0;
			long from=getFromToday((Calendar)nowDate.clone(),day);
			long to=getToToday((Calendar)nowDate.clone(),day);
			String sql2="";
			for(String c:ChannelIDS){		
				dayCount+=getDayCount(userId,Integer.parseInt(c),nowDate,day);
			}%>
			<td class="v1" style="padding-left:10px;text-align:left;" valign="middle"  width="20"><%=dayCount%></td>
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
        </div>
        <div class="viewpane_pages">    
                   
        </div>
    
  </div>
</div>

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
