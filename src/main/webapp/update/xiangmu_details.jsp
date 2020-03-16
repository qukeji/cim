<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 tidemedia.cms.user.*,
                 java.util.*,
                 java.sql.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
    /**
     * 用途：文档列表页
     * 1,李永海 20140101 创建
     * 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
     * 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
     */
    int cid = getIntParameter(request, "cid");
    TideJson update_api = CmsCache.getParameter("update_api").getJson();
    String url = "";
    String token = "";
    if (update_api != null) {
        url = update_api.getString("url");
        token = update_api.getString("token");
    } else {
        url = "http://jushi.tidemedia.com/cms/update_api/";
        token = "tidemedia";
    }
    String result = Util.connectHttpUrl(url+"action_details.jsp?token="+token+"&cid=" + cid,"UTF-8");
    JSONObject json = new JSONObject(result);
    String channelName = json.getString("channelName");
    JSONArray jsonArray = json.getJSONArray("arr");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS 列表</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <link href="../style/contextMenu.css" type="text/css" rel="stylesheet"/>
    <style>
        .collapsed-menu .br-mainpanel-file {
            margin-left: 0;
            margin-top: 0;
        }

        table.table-fixed {
            table-layout: fixed;
            word-break: break-all;
            word-wrap: break-word
        }

        table.table-fixed, table.table-fixed th, table.table-fixed td {
            border: 1px solid #dee2e6;
            border-collapse: collapse !important;
        }

        .list-pic-box {
            width: 100%;
            height: 0;
            padding-bottom: 56.25%;
            overflow: hidden;
            text-align: center;
            position: relative;
        }

        /*.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}*/
        .list-pic-box .list-img-contanier {
            width: 100%;
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .list-pic-box .list-img-contanier img {
            width: auto;
            max-height: 100%;
            max-width: 100%;
        }

        @media (max-width: 575px) {
            #content-table .hidden-xs-down {
                word-break: normal;
            }
        }
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>
</head>

<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active"><%=channelName%></span>
        </nav>
    </div>
    <!-- br-pageheader -->
    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0id= content-table" style="text-align: center">
                <thead>
                <tr>
                    <th class="tx-12-force tx-mont tx-medium wd-250" style="text-align: center">标题</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center">执行方式</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center">状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150" style="text-align: center">日期</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120 wd-author"
                        style="text-align: center">作者
                    </th>
                    <th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down wd-100" style="text-align: center">
                        操作
                    </th>
                </tr>
                </thead>
                <tbody>
                <%

                    int j = 0;
                    int m = 0;
                    int temp_gid = 0;
                    String doc_typeString = "";
                    for (int i = 0; i < jsonArray.length(); i++) {
                        JSONObject jsonObject = jsonArray.getJSONObject(i);
                        int id_ = jsonObject.getInt("itemId");
                        String Title = jsonObject.getString("title");
                        int Status = jsonObject.getInt("Status");
                        String StatusDesc = "";
                        if (Status == 0) {
                            StatusDesc = "<span class='tx-orange'>草稿</span>";
                        } else if (Status == 1) {
                            StatusDesc = "<span class='tx-success'>已发</span>";
                        } else {
                            StatusDesc = "<span class='tx-danger'>已删除</span>";
                        }
                        String ModifiedDate = jsonObject.getString("ModifiedDate");
                        String execute_type = jsonObject.getString("execute_type");
                        ModifiedDate = Util.FormatDate("yyyy-MM-dd HH:mm", (Long.parseLong(ModifiedDate) + 28800) * 1000);
                        String UserName = jsonObject.getString("userName");
                %>
                <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="" status="<%=Status%>" GlobalID="" id="item_<%=id_%>"
                    class="tide_item">
                    <td ondragstart="OnDragStart(event)">
                        <span class="pd-l-5 tx-black"><%=Title%></span>
                    </td>
                    <td class="hidden-xs-down">
                        <%=execute_type%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=StatusDesc%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=ModifiedDate%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=UserName%>
                    </td>
                    <td class="dropdown hidden-xs-down">
                        <a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"
                           onclick="show(<%=id_%>,'<%=Title%>','<%=execute_type%>')">查看</a>
                        <!-- dropdown-menu -->
                    </td>
                </tr>
                <%}%>
                </tbody>
            </table>

            <div class="table-page-info" style="display: none;">
                <div class="ckbox-parent">
                    <label class="ckbox mg-b-0">
                        <input type="checkbox" id="checkAll"><span></span>
                    </label>
                </div>
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

    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>
    <script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>
    <script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
	<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
    <script>
		var listType = 1;
        function show(id, title, execute_type) {
            var dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(550);
            dialog.setUrl("/tcenter/update/xiangmu_details1.jsp?itemId=" + id);
            dialog.setTitle(title);
            dialog.show();
        }
    </script>
</div>
</body>

</html>
