<%@ page import="tidemedia.cms.system.*,
                 java.sql.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
    /**
     *   名字            日期             备注
     *
     *  1.wanghailong      20140424         判断是否包含子频道
     *  2.huxiang          20190806 		  刷新左侧菜单
     *
     */
    int ChannelID = getIntParameter(request, "ChannelID");
    String Submit = getParameter(request, "Submit");
    String Name = getParameter(request, "Name");
    Channel parentChannel = CmsCache.getChannel(ChannelID);

    System.out.println("12-12");

    if (!Submit.equals("") && ChannelID != 0) {
        Channel channel = CmsCache.getChannel(ChannelID);
        boolean CreateCategory = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CreateCategory);
        if (CreateCategory) {
            Channel c = new Channel();

            c.setSerialNo(channel.getAutoSerialNo());
            c.setType(1);
            c.setName(Name);
            c.setParent(ChannelID);
            c.Add();

            session.removeAttribute("channel_tree_string");
        }
        out.println("<script>top.TideDialogClose({refresh:'right'});parent.location.reload();</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
    <link rel="Shortcut Icon" href="../favicon.ico">

    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">

    <style>
        html, body {
            width: 100%;
            height: 100%;
        }

        .modal-body-btn .config-box .row .left-fn-title {
            min-width: 70px;
        }
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>

    <script language=javascript>
        function init() {
            document.form.Name.focus();
        }

        function check() {
            if (isEmpty(document.form.Name, "请输入分类名称"))
                return false;
            $("#subtun").hide();
            return true;
        }

        function isEmpty(field, msg) {
            if (field.value == "") {
                ddalert(msg, "(function dd(){getDialog().Close({suffix:'html'});})()");
                field.focus();
                return true;
            }
            return false;
        }

        //alert定制
        function ddalert(message, confirm_) {
            var dialog = new top.TideDialog();
            dialog.setWidth(300);
            dialog.setHeight(250);
            dialog.setTitle('提示');
            dialog.setMsg(message);
            dialog.setMsgJs(confirm_);
            dialog.ShowMsg();
        }
    </script>


</head>

<body onload="init();" scroll="no">
<div class="bg-white modal-box">
    <form name="form" id="form" action="document_create_category.jsp" method="post" onSubmit="return check();">

        <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
            <div class="config-box">
                <div class="row">
                    <label>
                        分类名称：
                    </label>
                    <label class="wd-100 mg-l-5">
                        <input class="form-control" placeholder="" type="text" name="Name" size="10" maxlength="10"
                               value="" id="Name">
                    </label>
                </div>
            </div>
        </div>

        <div class="btn-box">
            <div class="modal-footer">
                <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
                <button name="Submit" type="submit" class="btn btn-primary tx-size-xs" value="Submit" id="subtun">确定
                </button>
                <button name="Submit2" type="button" onclick="top.TideDialogClose('');"
                        class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消
                </button>
            </div>
        </div>
    </form>
</div>
</body>
<script>
    $(function () {
        /*$("#subtun").on("click", function () {
            parent.location.reload();
        })*/
    })
</script>
</html>
