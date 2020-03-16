<%@ page import="tidemedia.cms.system.*,org.json.*" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
    String contextPath = request.getContextPath();
    String AssessIndicators = getParameter(request, "AssessIndicator");
    String calculateType = getParameter(request, "calculateType");
    String docData = getParameter(request, "docData");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <title>计算方式</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">

    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">

</head>
<style>
    html, body {
        width: 100%;
        height: 100%;
    }

    .modal-body {
        top: 0;
    }

    .table td, .table th {
        vertical-align: middle;
    }

    .wd-120 {
        width: 120px;
    }
</style>
<body class="">
<div class="bg-white modal-box">
    <div class="modal-body pd-20 overflow-y-auto">
        <div class="config-box">
            <div class="bd bd-gray-300 rounded table-responsive">
                <table class="table mg-b-0">
                    <thead>
                    <tr>
                        <th class="wd-120">指标</th>
                        <th class="wd-100">数据/PV</th>
                        <th class="wd-10"></th>
                        <th class="wd-100">分值</th>
                    </tr>
                    </thead>
                    <tbody id="test">
                    <%if (AssessIndicators.contains("网站发稿量")) {%>
                    <tr>
                        <th>网站发稿量</th>
                        <td>
                            <input class="form-control noreadonly noreadonly_pc" placeholder="" num="1" type="text">
                        </td>
                        <td>=</td>
                        <td>
                            <input class="form-control readonly" placeholder="" type="text" value="1">
                        </td>
                    </tr>
                    <%}%>
                    <%if (AssessIndicators.contains("网站稿件PV")) {%>
                    <tr>
                        <th>网站稿件PV</th>
                        <td>
                            <input class="form-control noreadonly searchbox1" placeholder="" num="2" type="text">
                        </td>
                        <td>=</td>
                        <td>
                            <input class="form-control readonly" placeholder="" type="text" value="1">
                        </td>
                    </tr>
                    <%}%>
                    <%if (AssessIndicators.contains("客户端发稿量")) {%>
                    <tr>
                        <th>客户端发稿量</th>
                        <td>
                            <input class="form-control noreadonly" placeholder="" num="3" type="text">
                        </td>
                        <td>=</td>
                        <td>
                            <input class="form-control readonly" placeholder="" type="text" value="1">
                        </td>
                    </tr>
                    <%}%>
                    <%if (AssessIndicators.contains("客户端稿件PV")) {%>
                    <tr>
                        <th>客户端稿件PV</th>
                        <td>
                            <input class="form-control noreadonly" placeholder="" num="4" type="text">
                        </td>
                        <td>=</td>
                        <td>
                            <input class="form-control readonly" placeholder="" type="text" value="1">
                        </td>
                    </tr>
                    <%}%>
                    <%if (AssessIndicators.contains("微信发稿量")) {%>
                    <tr>
                        <th>微信发稿量</th>
                        <td>
                            <input class="form-control noreadonly" placeholder="" num="5" type="text">
                        </td>
                        <td>=</td>
                        <td>
                            <input class="form-control readonly" placeholder="" type="text" value="1">
                        </td>
                    </tr>
                    <%}%>
                    <%if (AssessIndicators.contains("微信稿件PV")) {%>
                    <tr>
                        <th>微信稿件PV</th>
                        <td>
                            <input class="form-control noreadonly" placeholder="" num="6" type="text">
                        </td>
                        <td>=</td>
                        <td>
                            <input class="form-control readonly" placeholder="" type="text" value="1">
                        </td>
                    </tr>
                    <%}%>
                    <%if (AssessIndicators.contains("选题采用量")) {%>
                    <tr>
                        <th>选题采用量</th>
                        <td>
                            <input class="form-control noreadonly" placeholder="" num="7" type="text">
                        </td>
                        <td>=</td>
                        <td>
                            <input class="form-control readonly" placeholder="" type="text" value="1">
                        </td>
                    </tr>
                    <%}%><%if (AssessIndicators.contains("视频上传量")) {%>
                    <tr>
                        <th>视频上传量</th>
                        <td>
                            <input class="form-control noreadonly" placeholder="" num="8" type="text">
                        </td>
                        <td>=</td>
                        <td>
                            <input class="form-control readonly" placeholder="" type="text" value="1">
                        </td>
                    </tr>
                    <%}%>
                    </tbody>
                </table>
            </div>
        </div>

    </div><!-- modal-body -->
    <div class="btn-box">
        <div class="modal-footer">
            <button type="button" type="submit" class="btn btn-primary tx-size-xs" onclick="save()">确认</button>
            <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs"
                    data-dismiss="modal">取消
            </button>
        </div>
    </div>
</div><!-- br-mainpanel -->
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>

<script src="../lib/2018/highlightjs/highlight.pack.js"></script>

<script src="../common/2018/bracket.js"></script>
<script>

    var calculateType = '<%=docData%>';
    var calculateTypes = calculateType.split(",");

    $(function () {

        $(".form-control").blur(function () {
            var a = $(this).val();
            $(this).attr("double", a);
            if (!checkInteger(a) && a != "") {
                $(this).val("");
                $(this).attr("placeholder", "请输入大于0的整数!");
                $(this).focus();
            }
        })
        $(".readonly").attr("disabled", "disabled");
        $(".readonly").css("background-color", "white");
        var i = 0;
        var obj = $(".form-control.noreadonly");

        obj.each(function () {
            var num = $(this).attr("num");
            var calculateTypeInt = calculateTypes[num - 1];
            $(this).attr("double", calculateTypeInt);
            if (calculateTypeInt > 0) {
                calculateTypeInt = parseInt(calculateTypeInt);
                $(this).val(calculateTypeInt);
            } else {
                $(this).val('');
            }
        });
    })

    function save() {
        var b = false;
        calculateTypes = '0,0,0,0,0,0,0,0'.split(',');
        $(".noreadonly").each(function () {
            if ($(this).attr("double") == "") {
                $(this).attr("placeholder","分值不能为空!");
                $(this).focus();
                b=true;
                return false;
            }
            if (!checkInteger($(this).val())) {
                $(this).val("");
                $(this).attr("placeholder", "请输入大于0的整数!");
                $(this).focus();
                b=true;
                return false;
            }
            var num = $(this).attr("num") - 1;
            var a = $(this).attr("double");
            calculateTypes[num] = a;
        });
        if(b){
            return;
        }
        parent.$("#CalculateType").attr("value", calculateTypes);
        var html = '<label class="left-fn-title wd-150"> </label><label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>';
        var a = 0;
        if (calculateTypes[0] != 0) {
            html += '网站发稿量(' + calculateTypes[0] + '=1)';
            a++;
        }
        if (calculateTypes[1] != 0) {
            if(a==0){
                html += '网站稿件PV(' + calculateTypes[1] + '=1)';
            }else{
                html += '+网站稿件PV(' + calculateTypes[1] + '=1)';
            }
            a++;
        }
        if (calculateTypes[2] != 0) {
            if(a==0){
                html += '客户端发稿量(' + calculateTypes[2] + '=1)';
            }else{
                html += '+客户端发稿量(' + calculateTypes[2] + '=1)';
            }
            a++;
        }
        if (calculateTypes[3] != 0) {
            if(a==0){
                html += '客户端稿件PV(' + calculateTypes[3] + '=1)';
            }else{
                html += '+客户端稿件PV(' + calculateTypes[3] + '=1)';
            }
            a++;
        }
        if (calculateTypes[4] != 0) {
            if(a==0){
                html += '微信发稿量(' + calculateTypes[4] + '=1)';
            }else{
                html += '+微信发稿量(' + calculateTypes[4] + '=1)';
            }
            a++;
        }
        if (calculateTypes[5] != 0) {
            if(a==0){
                html += '微信稿件PV(' + calculateTypes[5] + '=1)';
            }else{
                html += '+微信稿件PV(' + calculateTypes[5] + '=1)';
            }
            a++;
        }
        if (calculateTypes[6] != 0) {
            if(a==0){
                html += '选题采用量(' + calculateTypes[6] + '=1)';
            }else{
                html += '+选题采用量(' + calculateTypes[6] + '=1)';
            }
            a++;
        }
        if (calculateTypes[7] != 0) {
            if(a==0){
                html += '视频上传量(' + calculateTypes[7] + '=1)';
            }else{
                html += '+视频上传量(' + calculateTypes[7] + '=1)';
            }
            a++;
        }
        if(a!=0){
            html+=' = 总分值';
        }
        html += '</label>';
        parent.$("#Caption_CalculateType").html('');
        parent.$("#Caption_CalculateType").append(html);
        top.TideDialogClose();
    }

    function checkInteger(num) {
        if (!isNaN(num) && num % 1 === 0 && num > 0) {
            return true;
        } else {
            return false;
        }
    }

    function toDecimal(val, len) {
        var f = parseFloat(val);
        if (isNaN(f)) {
            return false;
        }
        var f = Math.round(val * Math.pow(10, len)) / Math.pow(10, len);
        var s = f.toString();
        var rs = s.indexOf('.');
        if (rs < 0) {
            rs = s.length;
            s += '.';
        }
        while (s.length <= rs + len) {
            s += '0';
        }
        return s;
    }
</script>

</body>
</html>
