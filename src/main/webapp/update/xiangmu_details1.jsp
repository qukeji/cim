<%@ page import="org.json.JSONArray,org.json.JSONObject" %>
<%@ page import="tidemedia.cms.system.CmsCache" %>
<%@ page import="tidemedia.cms.util.TideJson" %>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
    int itemId = getIntParameter(request, "itemId");
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
    String result = Util.connectHttpUrl(url + "action_details.jsp?token=" + token + "&itemId=" + itemId, "UTF-8");
    System.out.println("result="+result);
    JSONObject jsonObject = new JSONObject(result);
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>编辑字段</title>
    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <script src="../lib/2018/jquery/jquery.js"></script>
    <style>
        html,
        body {
            width: 100%;
            height: 100%;
        }

        .modal-body .config-box .row {
            margin-bottom: 10px;
        }

        .modal-body .config-box label.ckbox {
            width: auto;
            margin-right: 10px;
        }

        .modal-body .config-box label.ckbox input {
            margin-right: 2px;
        }

        .wd-100 {
            width: 100px;
        }
        #checkResult{
            color: red;
            font-weight: bold;
        }
    </style>
</head>

<body class="bg-white">
<div class="bg-white modal-box">
    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
        <div class="config-box">
            <%
                    String Title = jsonObject.getString("title");
                    String PublishDate = jsonObject.getString("PublishDate");
                    PublishDate = Util.FormatDate("yyyy-MM-dd HH:mm:ss", (Long.parseLong(PublishDate) + 28800) * 1000);
                    String Summary = jsonObject.getString("Summary");
                    String Photo = jsonObject.getString("Photo");
                    String checkSql = jsonObject.getString("checkSql");
                    String db = jsonObject.getString("db");
                    int selectSite = jsonObject.getInt("selectSite");
                    String update_type = jsonObject.getString("update_type");//操作类型
                    String execute_type = jsonObject.getString("execute_type");//执行方式
                    int type = 0;
                    String resultString = "";
                    if (update_type.equals("频道调整")) {
                        type = 2;
                        resultString = jsonObject.getString("channel_json");
                    } else if (update_type.equals("执行SQL")) {
                        type = 1;
                        resultString = jsonObject.getString("executeSql");
                    }
            %>
            <!--基本信息-->
            <div>
                <%
                    if (selectSite == 1) {
                %>
                <div class="row">
                    <label class="wd-100">站点选择：</label>
                    <select class="form-control wd-230 ht-40 select2" data-placeholder="" id="site">
                        <option value="0">--请选择--</option>
                    </select>
                </div>
                <%}%>
                <div class="row">
                    <label class="wd-100">发布日期：</label>
                    <label class="wd-230"><%=PublishDate%>
                    </label>
                </div>
                <div class="row">
                    <label class="wd-100">说明：</label>
                    <label class="wd-230"><%=Summary%>
                    </label>
                </div>
                <div class="row">
                    <label class="wd-100">图片：</label>
                    <label class="wd-230"><%=Photo%>
                    </label>
                </div>
                <div class="row">
                    <label class="wd-100">操作类型：</label>
                    <label class="wd-230"><%=update_type%>
                    </label>
                </div>
                <div class="row">
                    <label class="wd-100">检测语句：</label>
                    <label class="wd-230"><%=checkSql%>
                    </label>
                </div>
                <div class="row">
                    <label class="wd-100">检测结果：</label>
                    <label class="wd-230" id="checkResult"></label>
                </div>
                <%if (type == 1) {%>
                <div class="row">
                    <label class="wd-100">执行sql：</label>
                    <label class="wd-230" id="executesql"><%=resultString%>
                    </label>
                </div>
                <%} else if (type == 2) {%>
                <div class="row">
                    <label class="wd-100">频道调整：</label>
                    <label class="wd-230" id="channeladjust"><%=resultString%>
                    </label>
                </div>
                <%}%>
            </div>
            <script>
                $(function () {
                    $.ajax({
                        url: "../api/company/site_list.jsp",
                        type: 'GET',
                        dataType: 'json',
                        success: function (res) {
                            var arr = res.sites;
                            var html = '';
                            for (var i = 0; i < arr.length; i++) {
                                html += '<option value="' + arr[i].siteId + '">' + arr[i].siteName + '</option>';
                            }
                            $('#site').append(html);
                        }
                    });

                    $('iframe').parent().css("overflow-y", "auto");
                })

                function check() {
					var siteId = $('#site').val();
					//alert(siteId);
                    $.ajax({
                        url: "action_check.jsp",
						data: {"itemid":'<%=itemId%>',"siteid":siteId},
                        type: 'GET',
                        success: function (res) {
                            $('#checkResult').html(res);
                        }
                    });
                }

                function execute() {
					var siteId = 0;
					if($('#site'))
					{
						siteId = $("#site").val();
						if(siteId==0)
						{
							alert("请先选择站点");
							return;
						}
					}
                    var str = confirm("确认要执行吗？");
                    if (str == true) {
                        var siteId = $('#site').val();
                            $.ajax({
                                url: "action_do.jsp",
                                data: {"itemid":'<%=itemId%>',"siteid":siteId},
                                type: 'POST',
                                success: function (res) {
                                    var dialog = new top.TideDialog();
                                    dialog.setWidth(500);
                                    dialog.setHeight(400);
                                    dialog.setMsg(res);
                                    dialog.setTitle('执行结果');
                                    dialog.ShowMsg();
                                },
                                error:function (data) {
                                    var dialog = new top.TideDialog();
                                    dialog.setWidth(500);
                                    dialog.setHeight(400);
                                    dialog.setMsg(data.responseText);
                                    dialog.setTitle('执行结果');
                                    dialog.ShowMsg();
                                }
                            })
                        
                    }
                }
            </script>
        </div>
    </div>
    <div class="btn-box">
        <div class="modal-footer">
            <button type="button" class="btn btn-primary tx-size-xs" onclick="check()">检测</button>
            <%if (execute_type.equals("程序执行")) {%>
            <button type="button" class="btn btn-primary tx-size-xs" onclick="execute()">执行</button>
            <%} else {%>
            <button type="button" class="btn btn-primary tx-size-xs" disabled="disabled" onclick="">请手工执行</button>
            <%}%>
        </div>

    </div>
</div>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<!--<script src="../../lib/2018/moment/moment.js"></script>-->
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
</body>

</html>
