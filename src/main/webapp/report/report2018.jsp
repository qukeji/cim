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
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>
        .collapsed-menu .br-mainpanel-file {
            margin-left: 0;
            margin-top: 0;
        }
    </style>
    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../common/2018/common2018.js"></script>
    <script type="text/javascript">
        var ChannelID = "<%=ChannelID%>";
        var GroupID = "<%=GroupID%>";

        function openSearch() {
            jQuery("#SearchArea").toggle();
        }

        function check() {
            var StartDate = jQuery("#StartDate").val();
            var EndDate = jQuery("#EndDate").val();
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

        $(function() {
            $.ajax({
                url: "site_data.jsp",
                type: "post",
                dataType: "json",
                data: "",
                success: function(data) {
                    var html = "";
                    $.each(data, function(index, obj) {
                        if ((ChannelID == "" && index == 0) || ChannelID == obj.id)
                            html += '<option value="' + obj.id + '" selected="selected">' + obj.name + '</option>';
                        else
                            html += '<option value="' + obj.id + '">' + obj.name + '</option>';
                    });
                    $("#Channel").html(html);
                }

            });

            $.ajax({
                url: "user_data.jsp",
                type: "post",
                dataType: "json",
                data: "",
                success: function(data) {
                    var html = "";
                    $.each(data, function(index, obj) {
                        if (GroupID == obj.id)
                            html += '<option value="' + obj.id + '" selected="selected">' + obj.name + '</option>';
                        else
                            html += '<option value="' + obj.id + '">' + obj.name + '</option>';
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
                <span class="breadcrumb-item active">工作量统计 / 内容工作量统计 / 报表</span>
            </nav>
        </div>
        <!-- br-pageheader -->
        <!--搜索-->
        <div class="search-box pd-x-20 pd-sm-x-30 mg-t-30" id="SearchArea" style="display:;">
            <div class="search-content bg-white">
                <form name="search_form" action="report2018.jsp" method="post">
                    <div class="row">
                        <!--用户信息-->
                        <div class="wd-40 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">检索:</div>
                        <div class="mg-r-20 mg-b-40 search-item">
                            <input class="form-control " placeholder="用户名" type="text" size="8" name="Username" id="Username" value="<%=Username%>">
                        </div>
                        <!--用户组-->
                        <div class="wd-60 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">用户组：</div>
                        <div class="wd-100 mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                            <select class="form-control select2" name="GroupID" id="GroupID"></select>
                        </div>
                        <!--站点-->
                        <div class="wd-60 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">站点：</div>
                        <div class="wd-150 mg-lg-t-0 mg-r-10 mg-b-30  search-item">
                            <select class="form-control select2" name="Channel" id="Channel"></select>
                        </div>
                        <!--日期-->
                        <div class="wd-200 mg-b-30 mg-r-10 search-item">
                            <div class="input-group">
                                <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" value="<%=StartDate%>" name="StartDate" id="StartDate" size="12">
                            </div>
                        </div>
                        <div class="wd-40 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
                        <div class="wd-200 mg-b-30 mg-r-10 search-item">
                            <div class="input-group">
                                <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="EndDate" id="EndDate" size="12" value="<%=EndDate%>" />
                            </div>
                        </div>

                        <div class="search-item mg-b-30">
                            <input name="Submit" type="Submit" value="查找" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14" />
                        </div>
                        <input type="hidden" name="Current" value="4" />
                        <input type="hidden" name="OpenSearch" id="OpenSearch" value="0" />
                    </div>
                    <!-- row -->
                </form>
            </div>
        </div>
        <!--搜索-->

        <div class="br-pagebody pd-x-20 pd-sm-x-30">
            <%if(!ChannelID.equals("")){%>
                <div class="channel-preview">
                    <span class="tx-14 mg-r-10">频道名称：<%for(String c:ChannelIDS){out.print(CmsCache.getChannel(Integer.parseInt(c)).getParentChannel().getName()+" ");}%></span>
                    <span class="tx-14 mg-r-10">开始时间：<%=StartDate%></span>
                    <span class="tx-14 mg-r-10">结束时间：<%=EndDate%></span>
                </div>
                <div class="card bd-0 shadow-base">
                    <table class="table mg-b-0" id="content-table">
                        <thead>
                            <%if(!Username.equals("")){%>
                                <tr>
                                    <th class="tx-12-force tx-mont tx-medium">姓名</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">频道</th>
                                    <%if(StartDate==null||StartDate.equals("")){%>
                                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">今天</th>
                                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">昨日</th>
                                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本周</th>
                                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本月</th>
                                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本年</th>
                                        <%}%>
                                            <th class="tx-12-force tx-mont tx-medium hidden-xs-down" id="releaseId">发稿量</th>
                                            <th class="tx-12-force tx-mont tx-medium hidden-xs-down"></th>
                                </tr>
                                <%}else if(GroupID!=0){%>
                                    <tr>
                                        <th class="tx-12-force tx-mont tx-medium">部门</th>
                                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">姓名</th>
                                        <%if(StartDate==null||StartDate.equals("")){%>
                                            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">今天</th>
                                            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">昨日</th>
                                            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本周</th>
                                            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本月</th>
                                            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本年</th>
                                            <%}%>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down" id="releaseId">发稿量</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down"></th>
                                    </tr>
                                    <%}else{%>
                                        <tr>
                                            <th class="tx-12-force tx-mont tx-medium">频道</th>
                                            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">姓名</th>
                                            <%if(StartDate==null||StartDate.equals("")){%>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">今天</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">昨日</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本周</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本月</th>
                                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down">本年</th>
                                                <%}%>
                                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down" id="releaseId">发稿量</th>
                                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down"></th>
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
        <td class="hidden-xs-down">
            <%=reportList.getUserName()%>
        </td>
        <td class="hidden-xs-down">
            <%=reportList.getChannelName()%>
        </td>
        <%if(StartDate==null||StartDate.equals("")){%>
            <td class="hidden-xs-down">
                <a href="<%=Today%>" target="_blank">
                    <%=reportList.getCountToday()%>
                </a>
            </td>
            <td class="hidden-xs-down">
                <a href="<%=Yesterday%>" target="_blank">
                    <%=reportList.getCountYesterday()%>
                </a>
            </td>
            <td class="hidden-xs-down">
                <a href="<%=Week%>" target="_blank">
                    <%=reportList.getCountWeek()%>
                </a>
            </td>
            <td class="hidden-xs-down">
                <a href="<%=Month1%>" target="_blank">
                    <%=reportList.getCountMonth()%>
                </a>
            </td>
            <td class="hidden-xs-down">
                <a href="<%=Year1%>" target="_blank">
                    <%=reportList.getCountYear()%>
                </a>
            </td>
            <%}%>
                <td class="hidden-xs-down">
                    <a href="<%=Total%>" target="_blank">
                        <%=reportList.getTotal()%>
                    </a>
                </td>
                <td class="hidden-xs-down"></td>
    </tr>
    <%} }
}else if(GroupID!=0){
	ArrayList list=report.listByGroup();
	for(int i=0;i<list.size();i++){
	 ReportList reportList=(ReportList)list.get(i);
%>
        <tr>
            <td class="hidden-xs-down">
                <%=reportList.getGroupName()%>
            </td>
            <td class="hidden-xs-down">
                <%=reportList.getUserName()%>
            </td>
            <%if(StartDate==null||StartDate.equals("")){%>
                <td class="hidden-xs-down">
                    <%=reportList.getCountToday()%>
                </td>
                <td class="hidden-xs-down">
                    <%=reportList.getCountYesterday()%>
                </td>
                <td class="hidden-xs-down">
                    <%=reportList.getCountWeek()%>
                </td>
                <td class="hidden-xs-down">
                    <%=reportList.getCountMonth()%>
                </td>
                <td class="hidden-xs-down">
                    <%=reportList.getCountYear()%>
                </td>
                <%}%>
                    <td class="hidden-xs-down">
                        <%=reportList.getTotal()%>
                    </td>
                    <td class="hidden-xs-down"></td>
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
                <td class="hidden-xs-down">
                    <%=reportList.getChannelName()%>
                </td>
                <td class="hidden-xs-down">
                    <%=reportList.getUserName()%>
                </td>
                <%if(StartDate==null||StartDate.equals("")){%>
                    <td class="hidden-xs-down">
                        <a href="<%=Today%>" target="_blank">
                            <%=reportList.getCountToday()%>
                        </a>
                    </td>
                    <td class="hidden-xs-down">
                        <a href="<%=Yesterday%>" target="_blank">
                            <%=reportList.getCountYesterday()%>
                        </a>
                    </td>
                    <td class="hidden-xs-down">
                        <a href="<%=Week%>" target="_blank">
                            <%=reportList.getCountWeek()%>
                        </a>
                    </td>
                    <td class="hidden-xs-down">
                        <a href="<%=Month1%>" target="_blank">
                            <%=reportList.getCountMonth()%>
                        </a>
                    </td>
                    <td class="hidden-xs-down">
                        <a href="<%=Year1%>" target="_blank">
                            <%=reportList.getCountYear()%>
                        </a>
                    </td>
                    <%}%>
                        <td class="hidden-xs-down">
                            <a href="<%=Total%>" target="_blank">
                                <%=reportList.getTotal()%>
                            </a>
                        </td>
                        <td class="hidden-xs-down"></td>
            </tr>
            <%}}
}%>
                <tr>
                    <td class="hidden-xs-down">合计</td>
                    <td class="hidden-xs-down"></td>
                    <%if(StartDate==null||StartDate.equals("")){%>
                        <td class="hidden-xs-down">
                            <%=report.getCountToday()%>
                        </td>
                        <td class="hidden-xs-down">
                            <%=report.getCountYesterday()%>
                        </td>
                        <td class="hidden-xs-down">
                            <%=report.getCountWeek()%>
                        </td>
                        <td class="hidden-xs-down">
                            <%=report.getCountMonth()%>
                        </td>
                        <td class="hidden-xs-down">
                            <%=report.getCountYear()%>
                        </td>
                        <%}%>
                            <td class="hidden-xs-down">
                                <%=report.getTotal()%>
                            </td>
                            <td class="hidden-xs-down"></td>
                </tr>
</tbody>
</table>
<!--分页-->
<%}//end if(ChannelID>0)%>
<div id="tide_content_tfoot">
<span class="mg-r-20 ">查询用时:<%=(System.currentTimeMillis()-begin_time)%>毫秒</span>
</div>
<!--分页-->
</div>
</div>
<!--列表-->
</div>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.min.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script>
//源程序函数
jQuery(document).ready(function() {
    tidecms.setDatePicker("#StartDate");
tidecms.setDatePicker("#EndDate");
//document.search_form.Year.value = <%=Year%>;
//document.search_form.Month.value = <%=Month%>;
//jQuery("#oTable").tablesorter();
/*
jQuery("#oTable").tablesorter({ 
            headers: { 
                7: { 
                    sorter:'digit' 
                } 
            },sortList:[[2,1]] 
        });*/
});
//搜索日期鼠标移入弹出  
$('.fc-datepicker').datepicker({
showOtherMonths: true,
selectOtherMonths: true,
dateFormat: "yy-mm-dd"
});
</script>
</body>

</html>