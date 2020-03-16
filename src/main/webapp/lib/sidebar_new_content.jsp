<%@ page import="tidemedia.cms.system.*,org.json.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
    int CloudChannelID = getIntParameter(request, "CloudChannelID");//稿件频道id
    int CloudItemID = getIntParameter(request, "CloudItemID");//文章id
    int isxuanti = getIntParameter(request, "isxuanti");//1:生成选题


    String msg = "新建内容";

    Tree2019 tree = new Tree2019();
    JSONArray arr = new JSONArray();
    if (isxuanti == 1) {
        Channel task_doc = ChannelUtil.getApplicationChannel("task_doc");
        int childChannel = task_doc.getId();
        arr = tree.listChannel_json(childChannel, "", userinfo_session, 1000);
    } else {
        arr = tree.listChannel_json(userinfo_session);
    }

    Channel channel = ChannelUtil.getApplicationChannel("shengao");
    int channelId = channel.getId();
    if(userinfo_session.getCompany()!=0){
        channelId = new Tree().getChannelID(channelId, userinfo_session);
    }

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>

    <style>
        html, body {
            height: 100%;
        }

        .br-mainpanel {
            margin-top: 0px;
            margin-left: 230px;
        }

        .br-subleft {
            left: 0 !important;
            top: 0 !important;
        }
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../common/2018/common2018.js"></script>

    <script language="javascript">

        function setChannelCookie(_id) {
            $.ajax({
                type: "GET",
                url: "../channel/getChannelPath.jsp?ChannelID=" + _id,
                success: function (data) {
                    tidecms.setCookie("content_manage_path", data.trim());
                }
            });
        }

        var dir = "";
        var CloudChannelID = <%=CloudChannelID%>;
        var CloudItemID = <%=CloudItemID%>;

        function openWin(url, text, winInfo) {
            var winObj = window.open(url, text, winInfo);
            var loop = setInterval(function () {
                if (winObj.closed) {
                    clearInterval(loop);
                    //alert('closed');
                    parent.location.reload();
                }
            }, 1);
        }

        function next(type) {
            var channelid = "";
            jQuery("#leftTd input:checked").each(function (i) {
                if (i == 0)
                    channelid += jQuery(this).val();
                else
                    channelid += "," + jQuery(this).val();
            });

            if (channelid != "" && (channelid.indexOf(",") < 0)) {
                if (type == 1) {
                    setChannelCookie(channelid);
                    var channel_path = getCookie("content_manage_path");
                    openWin("../lib/webIndex.jsp");
                } else {
                    if (CloudChannelID != 0 && CloudItemID != 0) {
                        openWin("../content/document.jsp?ChannelID=" + channelid + "&CloudItemID=" + CloudItemID + "&CloudChannelID=" + CloudChannelID);
                    } else {
                        openWin("../content/document.jsp?ChannelID=" + channelid + "", '', '')

                    }
                }
            } else {
                TideAlert("提示", "请选择一个频道");
                return false;
            }
        }

    </script>
</head>
<body class="collapsed-menu email">
<div class="bg-white modal-box">
    <div class="modal-body modal-body-btn pd-x-20 pd-y-0 overflow-y-auto">
        <div class="br-subleft-file" id="leftTd">
            <ul class="sidebar-menu">

            </ul>
        </div><!-- br-subleft -->

    </div>
    <div class="btn-box">
        <div class="modal-footer">
            <button type="button" class="btn btn-primary tx-size-xs" onclick="next(1)">进入管理页面</button>
            <button type="button" class="btn btn-primary tx-size-xs" onclick="next(2)">新建内容</button>
            <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs"
                    data-dismiss="modal">取消
            </button>
        </div>
    </div>

    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>
    <script src="../lib/2018/datatables/jquery.dataTables.js"></script>
    <script src="../lib/2018/datatables-responsive/dataTables.responsive.js"></script>
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>
    <script src="../common/2018/sidebar-menu-channel.js"></script>

    <script>
        $(function () {
            $('.br-mailbox-list,.br-subleft').perfectScrollbar();
            var menu = $('.sidebar-menu');
            var json = <%=arr%>;
            var html = '<li class="treeview"><ul class="treeview-menu" id="treeview-menu" style="display: block;">';
            //var html = '<li class="treeview"><a href="#" load="0" channelId="0"><i class="fa fisrtNav fa-home" have="1"></i> <span>新建内容</span></a><ul class="treeview-menu" style="display: block;">';
            for (var i = 0; i < json.length; i++) {
                html += '<li><a href="#" load="' + json[i].load + '" channelId="' + json[i].id + '">'
                if (json[i].load == 1 || (json[i].child && json[i].child.length > 0)) {
                    html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>'
                } else {
                    html += '<i class="fa fa-angle-right op-5" hava="0"></i>'
                }
                html += '<label class="rdiobox mg-b-0 mg-r-10"><input type="radio" name="id" value="' + json[i].id + '"><span style="padding:0"></span></label><span>' + json[i].name + '</span></a>';

                if (json[i].child && json[i].child.length > 0) {
                    html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
                }
                html += '</li>';
            }
            html += '</ul></li>';
            menu.append(html);
            //多级导航自定义
            $.sidebarMenu(menu);

            var html1 = "<li><a href='#' load='undefined' channelid=<%=channelId%>><i class='fa fa-angle-right op-5' hava='0'></i><label class='rdiobox mg-b-0 mg-r-10'><input type='radio' name='id' value='<%=channelId%>'><span style='padding:0'></span></label><span>我的文稿</span></a></li>";
            $("#treeview-menu").append(html1);
        });

        function get_menu_html(json) {
            var html = "";
            if (json.child && json.child.length > 0) {
                var json_ = json.child;
                for (var i = 0; i < json_.length; i++) {
                    html += '<li><a href="#" load="' + json_[i].load + '" channelId="' + json_[i].id + '">'
                    if (json_[i].load == 1 || (json_[i].child && json_[i].child.length > 0)) {
                        html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>'
                    } else {
                        html += '<i class="fa fa-angle-right op-5" hava="0"></i>'
                    }
                    html += '<label class="rdiobox mg-b-0 mg-r-10"><input type="radio" name="id" value="' + json_[i].id + '"><span style="padding:0"></span></label><span>' + json_[i].name + '</span></a>';

                    if (json_[i].child && json_[i].child.length > 0) {
                        html += '<ul class="treeview-menu">' + get_menu_html(json_[i]) + '</ul>';
                    }
                    html += '</li>';
                }
            }
            return html;
        }

        //========================================================================
        $.sidebarMenu = function (menu) {
            var animationSpeed = 300;

            $(menu).on('click', 'li a', function (e) {
                var $this = $(this);
                var checkElement = $this.next();

                var load = $this.attr("load");
                var channelid = $this.attr("channelid");
                if (load == 1) {
                    $this.attr("load", 0);//加载完毕改变load属性
                    var url = "../lib/channel_json.jsp?ChannelID=" + channelid;
                    $.ajax({
                        type: "GET",
                        dataType: "json",
                        url: url,
                        success: function (json) {
                            var html = '<ul class="treeview-menu">';

                            for (var i = 0; i < json.length; i++) {
                                if (json[i].child && json[i].child.length > 0) {
                                    html += '<li class="treeview">';
                                } else {
                                    html += '<li>';
                                }
                                html += '<a href="#" load="' + json[i].load + '" channelid="' + json[i].id + '">';

                                if (json[i].load == 1 || (json[i].child && json[i].child.length > 0)) {
                                    html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>'
                                } else {
                                    html += '<i class="fa fa-angle-right op-5" hava="0"></i>'
                                }
                                html += '<label class="rdiobox mg-b-0 mg-r-10"><input type="radio" name="id" value="' + json[i].id + '"><span style="padding:0"></span></label><span>' + json[i].name + '</span></a>';

                                if (json[i].child && json[i].child.length > 0) {
                                    html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
                                }
                                html += '</li>';
                            }
                            html += '</ul>';
                            $(".nav-loading").remove();
                            $this.after($(html));
                            checkElement = $this.next();
                            sidebarMenu_show(checkElement, animationSpeed, $this);
                        }
                    });
                } else {
                    sidebarMenu_show(checkElement, animationSpeed, $this);
                }
            });
        }
    </script>
</div>
</body>
</html>
