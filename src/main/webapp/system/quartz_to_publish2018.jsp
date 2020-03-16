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

String Action=getParameter(request,"Action");
if(Action.equals("jobinit")){
 CmsCacheL cmsCacheL=new CmsCacheL();
        if(cmsCacheL.getConfig().getStartQuartz().equals("false")) return;
        TableUtil tu = new TableUtil();
        String sql = "select * from quartz_manager where status=1";
        ResultSet rs = tu.executeQuery(sql);
        while(rs.next())
        {
            int qid = rs.getInt("id");
            try{
                new QuartzUtil().closeJob(qid);
                new QuartzUtil().startJob(qid);

            }catch(Exception e)
            {
                e.printStackTrace(System.out);
            }
        }
        tu.closeRs(rs);
}



%>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 7 列表</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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

<script language="javascript">
function joblist(id)
{
	var url = "../system/quartz_to_publish2018.jsp";
	this.location.href = url;
}
function back()
{
	var url = "../system/content_quartz2018.jsp";
	this.location.href = url;
}
function jobinit()
{
	var url = "quartz_to_publish2018.jsp?Action=jobinit";
	this.location.href = url;
}

</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">  
        <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">系统管理 / 调度管理</span>
        </nav>
        </div><!-- br-pageheader -->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <div class="btn-group mg-l-10 hidden-xs-down">
           <a href="javascript:;" class="btn btn-outline-info list_draft" onclick="jobinit();">重启调度</a>
		   <a href="javascript:;" class="btn btn-outline-info list_draft" onclick="joblist();">刷新</a>
		   <a href="javascript:;" class="btn btn-outline-info list_draft" onclick="back();">返回</a>
        </div><!-- btn-group -->
     </div>	 
<div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>				
					<th class="tx-12-force tx-mont tx-medium">选择</th>								
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">编号</th>                    					
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">任务名称</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">任务组名</th>	
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">启动时间</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">上次时间</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">下次时间</th>							
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
				
				
				List< ? extends Trigger> triggers =  sched.getTriggersOfJob(jobKey);
				java.util.Date nextFireTime = triggers.get(0).getNextFireTime();
				java.util.Date StartTime = triggers.get(0).getStartTime();
				java.util.Date PreviousFireTime = triggers.get(0).getPreviousFireTime();
				//System.out.println(triggers.get(0).getDescription());
				//System.out.println(triggers.get(0).getStartTime());
				String date = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(nextFireTime); 
				String StartTime_ = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(StartTime);
				String PreviousFireTime_ = "";
				if(PreviousFireTime!=null)
					PreviousFireTime_ = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(PreviousFireTime);
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
       <tr id="<%=jobName%>">
                        <td class="valign-middle">
			  <label class="ckbox mg-b-0">
				<input type="checkbox" name="id" value="<%=jobName%>"><span></span>
			  </label>
			</td>	
			<td class="hidden-xs-down"><%=k%></td>				
			<td class="hidden-xs-down"><%=jobName%></td>
			<td class="hidden-xs-down"><%=groupName%></td>	
			<td class="hidden-xs-down"><%=StartTime_%></td>
			<td class="hidden-xs-down"><%=PreviousFireTime_%></td>
		    <td class="hidden-xs-down"><%=date%></td>
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
