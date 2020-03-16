<%@ page import="java.sql.*,
				 tidemedia.cms.publish.*,
				 tidemedia.cms.util.*,
				 tidemedia.cms.base.TableUtil" %>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="tidemedia.cms.base.RedisUtil" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>

<%
    if (!userinfo_session.isAdministrator()) {
        out.close();
        return;
    }
    long begin_time = System.currentTimeMillis();
    int currPage = getIntParameter(request, "currPage");
    int rowsPerPage = getIntParameter(request, "rowsPerPage");
    int Scheme = getIntParameter(request, "Scheme");
    int SiteId = getIntParameter(request, "SiteId");
    int type = getIntParameter(request, "type");
    String ids = getParameter(request, "ids");
    String S_Title = Util.getParameter(request, "S_Title");
    int Status = getIntParameter(request, "Status");//状态  0:查看待发布文件  1:已发布文件  2:正在发布  3:发布失败
    int Status_publish_item = 0;//数据库publish_item表中实际Status字段
    if (currPage < 1)
        currPage = 1;
    if (rowsPerPage <= 0)
        rowsPerPage = 50;

    switch (Status) {
        case 0:
            Status_publish_item = 0;
            break;
        case 1:
            Status_publish_item = 1;
            break;
        case 2:
            Status_publish_item = 3;
            break;
        case 3:
            Status_publish_item = 4;
            break;

    }


//System.out.println(currPage+"*************");
    String queryString = "&SiteId=" + SiteId + "&Scheme=" + Scheme + "&S_Title=" + S_Title + "&Status=" + Status + "";
    String queryString1 = "&SiteId=" + SiteId + "&Scheme=" + Scheme + "&Status=" + Status + "&type=" + type;
    String Action = getParameter(request, "Action");
    String searchTitle = "publish_task_custom2018.jsp?rowsPerPage=" + rowsPerPage + queryString1;
    String endSearch = "publish_task_custom2018.jsp?rowsPerPage=" + rowsPerPage + queryString1;
    if (Action.equals("Del")) {
        int id = getIntParameter(request, "id");
		if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis
			RedisUtil.getInstance().DelRedisQueue(id);//先从Redis队列里删除
		}
        String Sql = "delete from publish_item where  id=" + id;

        if (Status_publish_item != 0) {
            Sql += " and Status=" + Status_publish_item + "";
        } else {
            Sql += " and (Status=0 or Status=2)";
        }

        System.out.println(Sql + "=============del");
        TableUtil tu = new TableUtil();

        tu.executeUpdate(Sql);
        //System.out.println("publish_task_custom.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString+"==========");
        response.sendRedirect("publish_task_custom2018.jsp?currPage=" + currPage + "&rowsPerPage=" + rowsPerPage + queryString);

        return;
    } else if (Action.equals("Clear")) {
        //String Sql = "delete from publish_item where Status=1";
		if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis
            RedisUtil.getInstance().DelAllRedisQueue(Status_publish_item);//先从Redis队列里删除
		}
        String Sql = "DELETE FROM publish_item WHERE id=id ";
        //Sql+=" and publish_item.Status=1";

        if (Status_publish_item != 0) {
            Sql += " and Status=" + Status_publish_item + "";
        } else {
            Sql += " and (Status=0 or Status=2)";
        }


        TableUtil tu = new TableUtil();
        System.out.println(Sql + "=============clear");
        tu.executeUpdate(Sql);

        response.sendRedirect("publish_task_custom2018.jsp?a=a" + queryString);
        return;
    } else if (Action.equals("Publish")) {
        String[] ids_group = ids.split(",");
		if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis
            RedisUtil.getInstance().RestartRedisQueue(4,ids_group);//先将相应任务设置到Redis发布队列
		}
        for (String id : ids_group) {
            TableUtil tu_update = new TableUtil();
            String sql = "update publish_item set status=0 where status=4 and id=" + id + "";
            // System.out.println("sql_mark"+sql);
            tu_update.executeUpdate(sql);
        }
        PublishManager.getInstance().CopyFileNow();
        response.sendRedirect("publish_task_custom2018.jsp?a=a" + queryString);
        return;
    } else if (Action.equals("AgainPublish")) {
		String[] ids_group = ids.split(",");
		if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis
            RedisUtil.getInstance().RestartRedisQueue(3,ids_group);//先将相应任务设置到Redis发布队列
		}
        for (String id : ids_group) {
            TableUtil tu_update = new TableUtil();
            String sql = "update publish_item set status=0 where status=3 and id=" + id + "";
            // System.out.println("sql_mark"+sql);
            tu_update.executeUpdate(sql);
        }
        PublishManager.getInstance().CopyFileNow();
        response.sendRedirect("publish_task_custom2018.jsp?a=a" + queryString);
        return;
    } else if (Action.equals("AllPublish")) {
    	if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis
            RedisUtil.getInstance().RestartRedisQueue(4);//先将相应任务设置到Redis发布队列
		}
        TableUtil tu_update = new TableUtil();
        String sql = "update publish_item set status=0 where status=4 ";
        //out.println(sql+"---发布全部失败文件----");
        tu_update.executeUpdate(sql);
    } else if (Action.equals("AllPublish_running")) {
		if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis
            RedisUtil.getInstance().RestartRedisQueue(3);//先将相应任务设置到Redis发布队列
		}
        TableUtil tu_update = new TableUtil();
        String sql = "update publish_item set status=0 where status=3 ";
        //out.println(sql+"---发布全部待发文件----");
        tu_update.executeUpdate(sql);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS 列表</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!--<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">-->
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
    <!-- <script type="text/javascript" src="../common/jquery.contextmenu.js"></script> -->
    <script language="javascript">

        function gopage(currpage) {
            var url = "publish_task_custom2018.jsp?currPage="+currpage+"&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>";
            this.location = url;
        }


        function change(obj) {
            if (obj != null)
                this.location = "publish_task_custom2018.jsp?rowsPerPage=" + obj.value + "<%=queryString%>&type=<%=type%>";
        }

        function getCheckbox() {
            var id = "";
            jQuery("#oTable input:checked").each(function (i) {
                if (i == 0)
                    id += jQuery(this).val();
                else
                    id += "," + jQuery(this).val();
            });
            var obj = {length: jQuery("#oTable input:checked").length, id: id};
            return obj;
        }

        function again_publishing() {


            var obj = getCheckbox();
            if (obj.length == 0) {
                alert("请先选择要发布文档！");
                return;
            }
            this.location = "../publish/publish_task_custom2018.jsp?Action=AgainPublish&ids=" + obj.id + "<%=queryString%>";

        }

        function again_publishing_all() {


            this.location = "../publish/publish_task_custom2018.jsp?Action=AllPublish_running<%=queryString%>";

        }

        function again_publish() {
            var obj = getCheckbox();
            if (obj.length == 0) {
                alert("请先选择要发布文档！");
                return;
            }
            this.location = "../publish/publish_task_custom2018.jsp?Action=Publish&ids=" + obj.id + "<%=queryString%>";

        }

        function again_publish_all() {
            this.location = "../publish/publish_task_custom2018.jsp?Action=AllPublish<%=queryString%>";

        }

        function ClearItems() {
            if (confirm("确实要清空所有发布记录吗？")) {
                this.location = "publish_task_custom2018.jsp?Action=Clear<%=queryString%>";
            }
        }

        function MM_jumpMenu(obj) { //v3.0
            if (obj != null) {
                if (document.getElementById("rowsPerPage") != null)
                    this.location = "publish_task_custom2018.jsp?Scheme=" + obj.value + "&rowsPerPage=" + document.getElementById("rowsPerPage").value + "&SiteId=<%=SiteId%>";
                else
                    this.location = "publish_task_custom2018.jsp?Scheme=" + obj.value + "&SiteId=<%=SiteId%>";
            }
        }

        function Details(id) {
            var dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(340);
            dialog.setScroll("auto");
            dialog.setUrl("publish/publish_task_custom_details.jsp?id=" + id);
            dialog.setTitle("错误信息");
            dialog.show();
        }


        function openSearch(obj) {
            var SearchArea = document.getElementById("SearchArea");
            if (SearchArea.style.display == "none") {
                SearchArea.style.display = "";
            } else {
                SearchArea.style.display = "none";
                this.location = "<%=endSearch%>";
            }
        }

        function search_submit() {
            var S_Title = document.getElementById("S_Title").value;
            this.location = "<%=searchTitle%>&S_Title=" + S_Title;
        }

        //发布用时排序
        function SortItems(type) {
            if (type == 0) {
                this.location = "publish_task_custom.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=1";
            } else if (type == 1) {
                this.location = "publish_task_custom.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=2";
            } else {
                this.location = "publish_task_custom.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=0";
            }

        }

    </script>

</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">

    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <div class="btn-group hidden-xs-down">
            <a href="../system/manager2018.jsp" class="btn btn-outline-info list_all">返回</a>
            <a href="javascript:openSearch();" class="btn btn-outline-info list_draft">检索</a>
            <a href="../publish/publish_task_custom2018.jsp?Status=0" class="btn btn-outline-info">待发布文件</a>
            <a href="../publish/publish_task_custom2018.jsp?Status=1" class="btn btn-outline-info">已发布文件</a>
            <a href="../publish/publish_task_custom2018.jsp?Status=2" class="btn btn-outline-info">正在发布</a>
            <a href="../publish/publish_task_custom2018.jsp?Status=3" class="btn btn-outline-info">发布失败</a>
        </div><!-- btn-group -->
        <div class="btn-group mg-l-auto hidden-xs-down">
            <a href="javascript:ClearItems();" class="btn btn-outline-info">清空日志</a>
        </div><!-- btn-group -->
        <%if (Status_publish_item == 4) {%>
        <div class="wd-40 mg-r-5 mg-l-30">操作:</div>
        <div class="btn-group hidden-xs-down">
            <a href="javascript:again_publish();" class="btn btn-outline-info">重新发布</a>
            <a href="javascript:again_publish_all();" class="btn btn-outline-info">全部重发</a>
        </div>
        <%}%>
        <%if (Status_publish_item == 3) {%>
        <div class="wd-40  mg-r-5 mg-l-30">操作:</div>
        <div class="btn-group hidden-xs-down">
            <a href="javascript:again_publishing();" class="btn btn-outline-info">重新发布</a>
            <a href="javascript:again_publishing_all();" class="btn btn-outline-info">全部重发</a>
        </div>
        <%}%>
        <% //System.out.println("list begin....");
            PublishScheme pt = new PublishScheme();
//String ListSql = "select publish_item.FileName,publish_item.CreateDate,publish_item.id,publish_item.ErrorNumber,publish_scheme.Name from publish_item left join publish_scheme on publish_item.PublishScheme=publish_scheme.id  where publish_item.Status=1 ";

//String ListSql = "select * from publish_item where Status=1 ";
//String ListSql = "select publish_item.FileName,publish_item.CreateDate,publish_item.id,publish_item.PublishScheme,publish_item.ErrorNumber,publish_scheme.Name from publish_item left join publish_scheme on publish_item.PublishScheme=publish_scheme.id  where publish_item.Status=1 ";
//String CountSql = "select count(*) from publish_item left join publish_scheme on publish_item.PublishScheme=publish_scheme.id where publish_item.Status=1";

//使用上面的SQL 性能提高一倍 2007 09 19


            String ListSql = "select site,UsedTime ,FileName,CreateDate,id,PublishScheme,FROM_UNIXTIME(AddTime,'%m-%d %H:%i:%s') as AddTime,FROM_UNIXTIME(CanCopyTime,'%m-%d %H:%i:%s') as CanCopyTime,FROM_UNIXTIME(CopyedTime,'%m-%d %H:%i:%s') as CopyedTime,Message from publish_item  ";

            if (Status_publish_item != 0) {
                ListSql += " where Status=" + Status_publish_item + "";
            } else {
                ListSql += " where Status=0 or Status=2";
            }
            String CountSql = "select count(*) from publish_item  ";

            if (Status_publish_item != 0) {
                CountSql += " where Status=" + Status_publish_item + "";
            } else {
                CountSql += " where Status=0 or Status=2";
            }
            if (Scheme > 0) {
                ListSql += " and PublishScheme=" + Scheme;
                CountSql += " and PublishScheme=" + Scheme;
            }
            if (SiteId > 0) {
                ListSql += " and Site=" + SiteId;
                CountSql += " and Site=" + SiteId;
            }

            if (!S_Title.trim().equals("")) {
                ListSql += " and FileName like '%" + S_Title + "%'";
                CountSql += " and FileName like '%" + S_Title + "%'";
            }

            if (type == 2) {
                ListSql += " order by UsedTime asc ";
            } else if (type == 1) {
                ListSql += " order by UsedTime desc ";
            } else {
                ListSql += " order by id desc ";
            }

//String CountSql = "select count(*) from publish_item where Status=1";


            ResultSet Rs = pt.List(ListSql, CountSql, currPage, rowsPerPage);
            int TotalPageNumber = pt.pagecontrol.getMaxPages();
        %>
        <div class="btn-group mg-l-10 hidden-sm-down">
            <%if (currPage > 1) {%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i
                    class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if (currPage < TotalPageNumber) {%>
            <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i
                    class="fa fa-chevron-right"></i></a>
            <%}%>
        </div>
    </div>
    <!--搜索-->
    <div class="search-box pd-x-20 pd-sm-x-30" id="SearchArea" style="display:none;">
        <div class="search-content bg-white">
            <div class="row">
                <!--标题-->
                <div class="mg-r-20 mg-b-40 search-item">
                    <input class="form-control search-title" size="18" placeholder="文件名" type="text" name="S_Title"
                           id="S_Title" value="<%=S_Title%>">
                </div>
                <div class="search-item mg-b-30">
                    <input type="button" name="button" value="查找" onclick="search_submit()"
                           class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                </div>
            </div><!-- row -->
        </div>
    </div><!--搜索-->

    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <%--<div class="d-flex align-items-center justify-content-start pd-t-25 mg-b-20 mg-sm-b-30">
            <div class="btn-group hidden-xs-down">
                <a href="../publish/publish_task_custom2018.jsp?Status=0" class="btn btn-outline-info">待发布文件</a>
                <a href="../publish/publish_task_custom2018.jsp?Status=1" class="btn btn-outline-info">已发布文件</a>
                <a href="../publish/publish_task_custom2018.jsp?Status=2" class="btn btn-outline-info">正在发布</a>
                <a href="../publish/publish_task_custom2018.jsp?Status=3" class="btn btn-outline-info">发布失败</a>
            </div>
            <%if (Status_publish_item == 4) {%>
            <div class="wd-40 mg-r-5 mg-l-30">操作:</div>
            <div class="btn-group hidden-xs-down">
                <a href="javascript:again_publish();" class="btn btn-outline-info">重新发布</a>
                <a href="javascript:again_publish_all();" class="btn btn-outline-info">全部重发</a>
            </div>
            <%}%>
           <%if (Status_publish_item == 3) {%>
            <div class="wd-40  mg-r-5 mg-l-30">操作:</div>
            <div class="btn-group hidden-xs-down">
                <a href="javascript:again_publishing();" class="btn btn-outline-info">重新发布</a>
                <a href="javascript:again_publishing_all();" class="btn btn-outline-info">全部重发</a>
            </div>
            <%}%>
        </div>--%>
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0" id="content-table">
                <thead>
                <tr>
                    <%if (Status_publish_item == 4 || Status_publish_item == 3) {%>
                    <th class="tx-12-force tx-mont tx-medium">选择</th>
                    <%}%>
                    <th class="tx-12-force tx-mont tx-medium">编号</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">站点</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布方案</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">文件名</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">入队列时间</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">可发布时间</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布时间</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">发布用时</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">信息</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int TotalNumber = pt.pagecontrol.getRowsCount();
                    if (pt.pagecontrol.getRowsCount() > 0) {
                        int j = 0;

                        while (Rs.next()) {
                            int siteId = Rs.getInt("site");
                            tidemedia.cms.system.Site site = new tidemedia.cms.system.Site(siteId);
                            String siteName = site.getName();
                            int psid = Rs.getInt("PublishScheme");
                            PublishScheme ps = tidemedia.cms.system.CmsCache.getPublishScheme(psid);
                            String Name = ps.getName();
                            String FileName = convertNull(Rs.getString("FileName"));
                            String time1 = convertNull(Rs.getString("AddTime"));
                            String time2 = convertNull(Rs.getString("CanCopyTime"));
                            String time3 = convertNull(Rs.getString("CopyedTime"));
                            String Message = convertNull(Rs.getString("Message"));
                            int time4 = Rs.getInt("UsedTime");
                            int second = time4 / 1000;
                            String usedTime = "";
                            if (second <= 0)
                                usedTime = time4 + "毫秒";
                            else if (second > 0 && second < 60)

                                usedTime = second + "秒";
                            else if (second >= 60 && second < 3600)
                                usedTime = second / 60 + "分钟";
                            else
                                usedTime = second / 3600 + "小时";
                            int id = Rs.getInt("id");

                            j++;
                %>
                <tr>
                    <%if (Status_publish_item == 4 || Status_publish_item == 3) {%>
                    <td class="valign-middle">
                        <label class="ckbox mg-b-0">
                            <input type="checkbox" name="id" value="<%=id%>"><span></span>
                        </label>
                    </td>
                    <%}%>
                    <td class="hidden-xs-down"><%=j%>
                    </td>
                    <td class="hidden-xs-down"><%=siteName%>
                    </td>
                    <td class="hidden-xs-down"><%=Name%>
                    </td>
                    <td class="hidden-xs-down"><%=FileName%>
                    </td>
                    <td class="hidden-xs-down"><%=time1%>
                    </td>
                    <td class="hidden-xs-down"><%=time2%>
                    </td>
                    <%if (Status == 1) {%>
                    <td class="hidden-xs-down"><%=time3%>
                    </td>
                    <%} else {%>
                    <td class="hidden-xs-down"><%=time3%>
                    </td>
                    <%}%>
                    <%if (Status == 1) {%>
                    <td class="hidden-xs-down"><%=usedTime%>
                    </td>
                    <%} else {%>
                    <td class="hidden-xs-down"></td>
                    <%}%>
                    <td class="hidden-xs-down"><%=Message%>
                    </td>
                    <td class="hidden-xs-down"><%if (Status == 3 || Status == 2) {%><a href="#"
                                                                                       class="btn btn-info btn-sm tx-13"
                                                                                       onclick="Details(<%=id%>);">查看错误</a><%}%>
                        <a href="#" class="btn btn-danger btn-sm tx-13" onclick="del(<%=id%>,'<%=queryString%>')">删除</a>
                    </td>
                    <!--  <td class="hidden-xs-down"><a href="system_log2018.jsp?Action=Del&id=<%=id%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td> -->
                </tr>
                <%
                        }
                    }
                    //System.out.println("pt.close begin...");
                    pt.closeRs(Rs);
                    //System.out.println("pt.close end...");
                    //System.out.println("list end....");
                %>
                </tbody>
            </table>
            <!--分页-->
            <div id="tide_content_tfoot">
                <%if (Status_publish_item == 4 || Status_publish_item == 3) {%>
                <label class="ckbox mg-b-0 mg-r-30 ">
                    <input type="checkbox" id="checkAll_1"><span></span>
                </label>
                <%}%>
                <span class="mg-r-20 ">共<%=TotalNumber%>条</span>
                <span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

                <%if (TotalPageNumber > 1) {%><%}%>
                <div class="jump_page ">
                    <span class="">跳至:</span>
                    <label class="wd-60 mg-b-0">
                        <input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
                    </label>
                    <span class="">页</span>
                    <a id="goToId" href="javascript:;" class="tx-14">Go</a>
                </div>
                <div class="each-page-num mg-l-auto ">
                    <span class="">每页显示:</span>

                    <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="状态"
                            onChange="change(this);" id="rowsPerPage">
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="20">20</option>
                        <option value="25">25</option>
                        <option value="30">30</option>
                        <option value="50">50</option>
                        <option value="80">80</option>
                        <option value="100">100</option>
                    </select>
                    <span class="">条</span>
                </div>
            </div><!--分页-->
        </div>
    </div><!--列表-->
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <div class="btn-group mg-l-auto hidden-xs-down">
            <a href="javascript:;" class="btn btn-outline-info" onClick="clearItems();">清空日志</a>
        </div><!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-sm-down">
            <%if (currPage > 1) {%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i
                    class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if (currPage < TotalPageNumber) {%>
            <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i
                    class="fa fa-chevron-right"></i></a>
            <%}%>
        </div>
    </div>
</div>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<!--<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>-->
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>

<script type="text/javascript">
    $("#checkAll,#checkAll_1").click(function () {
        var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox");
        var existChecked = false;
        for (var i = 0; i < checkboxAll.length; i++) {
            if (!checkboxAll.eq(i).prop("checked")) {
                existChecked = true;
            }
        }
        if (existChecked) {
            checkboxAll.prop("checked", true);
        } else {
            checkboxAll.removeAttr("checked");
        }
        return;
    })

    function change(obj) {
        if (obj != null) this.location = "publish_task_custom2018.jsp?rowsPerPage=" + obj.value + "<%=queryString%>";
    }


    jQuery(document).ready(function () {
        jQuery("#rowsPerPage").val('<%=rowsPerPage%>');

        jQuery("#goToId").click(function () {
            var num = jQuery("#jumpNum").val();
            if (num == "") {
                alert("请输入数字!");
                jQuery("#jumpNum").focus();
                return;
            }
            var reg = /^[0-9]+$/;
            if (!reg.test(num)) {
                alert("请输入数字!");
                jQuery("#jumpNum").focus();
                return;
            }

            if (num < 1)
                num = 1;
            var href = "publish_task_custom2018.jsp?currPage=" + num + "&rowsPerPage=<%=rowsPerPage%><%=queryString%>";
            document.location.href = href;
        });

    });
</script>
</body>
</html>
