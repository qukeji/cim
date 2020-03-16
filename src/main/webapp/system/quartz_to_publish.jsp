<%@ page import="java.sql.*,
				java.util.*,
				org.quartz.*,
				org.quartz.impl.StdSchedulerFactory,
                org.quartz.impl.matchers.GroupMatcher,
				tidemedia.cms.publish.PublishScheme,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.spider.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
 *	姓名		日期		备注
 *
 *	王海龙		20131231	监控所有的调度进程
 */
if(!userinfo_session.isAdministrator())
{
 response.sendRedirect("../noperm.jsp");
 return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>

<script language="javascript">

function joblist(id)
{
	var url = "../system/quartz_to_publish.jsp";
	this.location.href = url;
}
function back()
{
	var url = "../system/content_quartz.jsp";
	this.location.href = url;
}
function jobinit()
{
	var url = "quartz_to_publish.jsp?Action=jobinit";
	this.location.href = url;
}

</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">调度管理：</div>
    <div class="content_new_post">
		 <div class="tidecms_btn" onclick="jobinit();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">定时初始化</div>
		</div>
 		<div class="tidecms_btn" onclick="joblist();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">刷新</div>
		</div>
		 <div class="tidecms_btn" onclick="back();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">返回</div>
		</div>

    </div>
</div>
 
<div class="content_2012">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr id="oTable1_th">
					<th class="v1" width="15" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v1" width="25" align="center" valign="middle">编号</th>
    				<th class="v1"	align="center" valign="middle">任务名称</th>
					<th class="v1"	align="center" valign="middle">任务组名</th>
					<th class="v1"	align="center" valign="middle">下次执行时间</th>
					
  				</tr>
</thead>
 <tbody> 
<%
	SchedulerFactory sf = new StdSchedulerFactory();
		Scheduler sched = sf.getScheduler();  
		int k=0;
	   for (String groupName : sched.getJobGroupNames()) 
	   {
		   
		 if(!groupName.equals("group_tidecms"))
		 {
			 for (JobKey jobKey : sched.getJobKeys(GroupMatcher
						.jobGroupEquals(groupName)))
			  {
				String jobName = jobKey.getName();
				String jobGroup = jobKey.getGroup();
				
				
				List<? extends Trigger> triggers =  sched
						.getTriggersOfJob(jobKey);
				java.util.Date nextFireTime = triggers.get(0).getNextFireTime(); 
				String date = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(nextFireTime); 
				long time = nextFireTime.getTime(); 
				//int pubstatus=time-System.currentTimeMillis()>0?1:0;
				k++;

				if(jobName.startsWith("job_spider_"))
				{
					//采集
					int spiderid = Util.parseInt(jobName.replace("job_spider_",""));
					Spider spider = new Spider(spiderid);
					jobName += " ("+spider.getName() + ")";
				}
%>
	<tr id="<%=jobName%>" class="tide_item">
	<td class="v1" align="center" valign="middle"><input name="id" value="<%=jobName%>" type="checkbox"/></td>
    <td class="v1" width="25" align="center" valign="middle"><%=k%></td>
	<td class="v1" align="center" valign="middle"><%=jobName%></td>
	<td class="v1" align="center" valign="middle"><%=groupName%></td>
    <td class="v4" align="center" style="color:#666666;"><%=date%></td>
	
  </tr>
<%
		}
	}
}
%>
  
 </tbody> 
</table> 
        </div>
  </div> 
</div> 
</body>
</html>