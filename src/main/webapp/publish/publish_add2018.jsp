<%@ page import="java.sql.*,
				 tidemedia.cms.util.Util,
				 tidemedia.cms.system.*,
				 tidemedia.cms.publish.PublishScheme,
				 tidemedia.cms.user.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
    //禁止添加发布方案
    if (!(new UserPerm().canAddPublishScheme(userinfo_session))) {
        response.sendRedirect("../noperm.jsp");
        return;
    }

    String Submit = getParameter(request, "Submit");
    int SiteId = Util.getIntParameter(request, "SiteId");
    if (Submit.equals("Submit")) {
//	String			=	getParameter(request,"");

        String Name = getParameter(request, "Name");
        String Server = getParameter(request, "Server");
        String Username = getParameter(request, "Username");
        String Password = getParameter(request, "Password");
        String Port = getParameter(request, "Port");
        String RemoteFolder = getParameter(request, "RemoteFolder");
        String DestFolder = getParameter(request, "DestFolder");
        String IncludeFolders = getParameter(request, "IncludeFolders");
        String ExcludeFolders = getParameter(request, "ExcludeFolders");
        int CopyMode = getIntParameter(request, "CopyMode");
        int FtpMode = getIntParameter(request, "FtpMode");
        String endPoint = getParameter(request, "endPoint");
        String accessKeyID = getParameter(request, "accessKeyID");
        String secretKey = getParameter(request, "secretKey");
        String bucketName = getParameter(request, "bucketName");
        String TenantName = getParameter(request, "TenantName");
        String TokenUrl = getParameter(request, "TokenUrl");
        String videoHttpHead = getParameter(request, "videoHttpHead");
        String CredentialsUserName = getParameter(request, "CredentialsUserName");
        String CredentialsPassword = getParameter(request, "CredentialsPassword");
        //Ossendpoint,OssLocalenpoint,OssaccessKeyId,OssaccessKeySecret,OSSbucketName
        String Ossendpoint = getParameter(request, "Ossendpoint");
        String OssLocalenpoint = getParameter(request, "OssLocalenpoint");
        String OssaccessKeyId = getParameter(request, "OssaccessKeyId");
        String OssaccessKeySecret = getParameter(request, "OssaccessKeySecret");
        String OSSbucketName = getParameter(request, "OSSbucketName");
        String Ossdomain = getParameter(request, "Ossdomain");

        String BosaccessKeyId = getParameter(request, "BosaccessKeyId");
        String BosaccessKeySecret = getParameter(request, "BosaccessKeySecret");
        String BosbucketName = getParameter(request, "BosbucketName");
        //七牛云相关参数
        String QiniuAccessKey = getParameter(request, "QiniuAccessKey");
        String QiniuSecrectKey = getParameter(request, "QiniuSecrectKey");
        String QiniubucketName = getParameter(request, "QiniubucketName");

        //System.out.println("CopyMode="+CopyMode+",name="+Name+",username="+Username);
        PublishScheme publishscheme = new PublishScheme();

//	u.set();
        publishscheme.setName(Name);
        publishscheme.setUserId(userinfo_session.getId());
        publishscheme.setServer(Server);
        publishscheme.setUsername(Username);
        publishscheme.setPassword(Password);
        publishscheme.setPort(Port);
        publishscheme.setRemoteFolder(RemoteFolder);
        publishscheme.setDestFolder(DestFolder);
        publishscheme.setIncludeFolders(IncludeFolders);
        publishscheme.setExcludeFolders(ExcludeFolders);
        publishscheme.setCopyMode(CopyMode);
        publishscheme.setFtpMode(FtpMode);
        publishscheme.setStatus(1);
        publishscheme.setSite(SiteId);
        publishscheme.setEndPoint(endPoint);
        publishscheme.setAccessKeyID(accessKeyID);
        publishscheme.setSecretKey(secretKey);
        publishscheme.setBucketName(bucketName);
        publishscheme.setTenantName(TenantName);
        publishscheme.setTokenUrl(TokenUrl);
        publishscheme.setCredentialsUserName(CredentialsUserName);
        publishscheme.setCredentialsPassword(CredentialsPassword);
        publishscheme.setVideoHttpHead(videoHttpHead);
        publishscheme.setOssendpoint(Ossendpoint);
        publishscheme.setOssLocalenpoint(OssLocalenpoint);
        publishscheme.setOssaccessKeyId(OssaccessKeyId);
        publishscheme.setOssaccessKeySecret(OssaccessKeySecret);
        publishscheme.setOSSbucketName(OSSbucketName);
        publishscheme.setOssdomain(Ossdomain);
        publishscheme.setBosaccessKeyId(BosaccessKeyId);
        publishscheme.setBosaccessKeySecret(BosaccessKeySecret);
        publishscheme.setBosbucketName(BosbucketName);
        publishscheme.setQiniuAccessKey(QiniuAccessKey);
        publishscheme.setQiniuSecrectKey(QiniuSecrectKey);
        publishscheme.setQiniubucketName(QiniubucketName);

        //Ossendpoint,OssLocalenpoint,OssaccessKeyId,OssaccessKeySecret,OSSbucketName
        publishscheme.Add();
        //CmsCache.getSite(SiteId).clearPublishSchemes();
        out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
    <title>TideCMS</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../common/2018/common2018.js"></script>

    <script type="text/javascript">
        function check() {
            if (isEmpty(document.form.Name, "请输入方案名."))
                return false;
            var CopyMode_Checked = "0";
            var CopyMode = jQuery("#CopyMode").val();

            if (CopyMode == 1) {
                if (isEmpty(document.form.Server, "请输入FTP服务器."))
                    return false;
                if (isEmpty(document.form.Port, "请输入端口."))
                    return false;
                if (isEmpty(document.form.Username, "请输入用户名."))
                    return false;
                if (isEmpty(document.form.Password, "请输入密码."))
                    return false;
            }

            if (CopyMode == "2") {
                if (isEmpty(document.form.DestFolder, "请输入目标目录."))
                    return false;
            }


            if (CopyMode == 3) {
                if (isEmpty(document.form.endPoint, "请输入S3服务器"))
                    return false;
                if (isEmpty(document.form.bucketName, "请输入bucketName."))
                    return false;
                if (isEmpty(document.form.accessKeyID, "请输入accessKeyID."))
                    return false;
                if (isEmpty(document.form.secretKey, "请输入secretKey."))
                    return false;
            }
            CopyMode_Checked = "1";

            if (CopyMode_Checked == "0") {
                alert("请选择文件复制方式.");
                return false;
            }

            return true;
        }

        function isEmpty(field, msg) {
            if (field.value == "") {
                alert(msg);
                field.focus();
                return true;
            }
            return false;
        }

        function init() {

        }


        function showTab(form, form_td) {
            var num = 6;
            for (i = 1; i <= num; i++) {
                jQuery("#form" + i).hide();
                jQuery("#form" + i + "_td").removeClass("cur");
            }

            if (form == "form1") {
                jQuery("#CopyMode").val("1");
            } else if (form == "form2") {
                jQuery("#CopyMode").val("2");
            } else if (form == "form3") {
                jQuery("#CopyMode").val("3");
            } else if (form == "form4") {
                jQuery("#CopyMode").val("4");
            } else if (form == "form5") {
                jQuery("#CopyMode").val("5");
            } else if (form == "form6") {
                jQuery("#CopyMode").val("6");
            }

            jQuery("#" + form).show();
            jQuery("#" + form_td).addClass("cur");
        }
    </script>

    <style>
        html, body {
            width: 100%;
            height: 100%;
        }
    </style>

    <!-- <style>
    .edit-main{margin:0;position:Static;}
    .edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
    .edit-con{position:Static;margin:-1px 0 0;}
    .edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
    </style>  -->
</head>
<body class="" onload="init();">

<div class="bg-white modal-box">
    <div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
        <ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">FTP上传</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">文件拷贝</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">S3云存储</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">OpenStack云存储</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">阿里云存储</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">百度云存储</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">七牛云存储</a></li>
        </ul>
    </div>
    <form name="form" action="publish_add2018.jsp" method="post" onSubmit="return check();">
        <div class="modal-body pd-20 overflow-y-auto">
            <div class="config-box">
                <ul>
                    <div class="row">
                        <label class="left-fn-title">发布方案名：</label>
                        <label class="wd-230">
                            <input class="form-control" placeholder="" type="text" name="Name">
                        </label>
                    </div>
                    <li class="block">
                        <div class="row">
                            <label class="left-fn-title">FTP服务器：</label>
                            <label class="wd-230">
                                <input name="Server" class="form-control" placeholder="" type="text">
                            </label>
                        </div>

                        <div class="row">
                            <label class="left-fn-title">端口：</label>
                            <label class="wd-230">
                                <input class="form-control" placeholder="" type="text" name="Port" value="21">
                            </label>
                            <label class="mg-l-5">模式：</label>
                            <label class="rdiobox">
                                <input id="s001" name="FtpMode" value="0" type="radio"><span
                                    class="d-inline-block">主动模式</span>
                            </label>
                            <label class="rdiobox">
                                <input type="radio" id="s002" name="FtpMode" value="1"><span
                                    class="d-inline-block">被动模式</span>
                            </label>
                        </div>

                        <div class="row">
                            <label class="left-fn-title">用户名：</label>
                            <label class="wd-230">
                                <input name="Username" class="form-control" placeholder="" type="text">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">密码：</label>
                            <label class="wd-230">
                                <input class="form-control" placeholder="" name="Password" type="Password">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">远程目录：</label>
                            <label class="wd-230">
                                <input class="form-control" placeholder="" type="text" name="RemoteFolder" value="/">
                            </label>
                        </div>

                        <div class="row">
                            <label class="left-fn-title">允许发布的目录：</label>
                            <div class="col-lg pd-l-0 pd-r-0 wd-350">
                                <textarea rows="3" class="form-control" placeholder="" name="IncludeFolders"></textarea>
                            </div>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">禁止发布的目录：</label>
                            <div class="col-lg pd-l-0 pd-r-0 wd-350">
                                <textarea rows="3" class="form-control" placeholder="" name="ExcludeFolders"
                                          id="textfield"></textarea>
                            </div>
                            <input type="hidden" name="CopyMode" id="CopyMode" value="1">
                        </div>
                    </li>
                    <li>
                        <div class="row">
                            <label class="left-fn-title">目标目录：</label>
                            <label class="wd-230">
                                <input class="form-control" placeholder="" type="text" name="DestFolder">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">允许发布的目录：</label>
                            <div class="col-lg pd-l-0 pd-r-0 wd-350">
                                <textarea rows="3" class="form-control" placeholder="" name="IncludeFolders"></textarea>
                            </div>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">禁止发布的目录：</label>
                            <div class="col-lg pd-l-0 pd-r-0 wd-350">
                                <textarea rows="3" class="form-control" placeholder="" name="ExcludeFolders"></textarea>
                            </div>
                            <input type="hidden" name="CopyMode" id="CopyMode" value="2">
                        </div>
                    </li>
                    <!--推荐设置-->
                    <li>
                        <div class="row">
                            <label class="left-fn-title">S3服务器：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="endPoint">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">accessKeyID：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="accessKeyID">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">secretKey：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="secretKey">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">bucketName：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="bucketName">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">videoHttpHead：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="videoHttpHead">
                            </label>
                            <input type="hidden" name="CopyMode" id="CopyMode" value="3">
                        </div>

                    </li>

                    <li>
                        <div class="row">
                            <label class="left-fn-title">tokenUrl：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="TokenUrl">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">TenantName：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="TenantName">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">UserName：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="Password"
                                       name="CredentialsUserName">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">Password：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="password"
                                       name="CredentialsPassword">
                            </label>
                            <input type="hidden" name="CopyMode" id="CopyMode" value="4">
                        </div>
                    </li>
                    <!--内容设置-->
                    <li>
                        <div class="row">
                            <label class="left-fn-title">endpoint：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="Ossendpoint">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">Localenpoint：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="OssLocalenpoint">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">accessKeyId：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="Password"
                                       name="OssaccessKeyId">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">accessKeySecret：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="Password"
                                       name="OssaccessKeySecret">
                            </label>

                        </div>
                        <div class="row">
                            <label class="left-fn-title">bucketName：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="OSSbucketName">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">Ossdomain：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="Ossdomain">
                            </label>
                            <input type="hidden" name="CopyMode" id="CopyMode" value="5">
                        </div>
                    </li>
                    <li>
                        <div class="row">
                            <label class="left-fn-title">accessKeyId：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="Password"
                                       name="BosaccessKeyId">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">secretAccessKey：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="password"
                                       name="BosaccessKeySecret">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">bucketName：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="Password"
                                       name="BosbucketName">
                            </label>
                            <input type="hidden" name="CopyMode" id="CopyMode" value="6">
                        </div>
                    </li>
                    <!-- 七牛云存储 -->
                    <li>
                        <div class="row">
                            <label class="left-fn-title">AccessKey：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="QiniuAccessKey">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">SecrectKey：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="QiniuSecrectKey">
                            </label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">bucketName：</label>
                            <label class="wd-230">
                                <input class="form-control" size="40" placeholder="" type="text" name="QiniubucketName">
                            </label>
                            <input type="hidden" name="CopyMode" id="CopyMode" value="7">
                        </div>
                    </li>
                </ul>
            </div>

        </div><!-- modal-body -->
        <div class="btn-box">
            <div class="modal-footer">
                <input type="hidden" name="Submit" value="Submit">
                <input type="hidden" name="SiteId" value="<%=SiteId%>">
                <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
                <button name="btnCancel1" type="button" onclick="top.TideDialogClose();"
                        class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
                </button>
            </div>
        </div>
        <div id="ajax_script" style="display:none;"></div>
    </form>
</div>
</body>
<!-- br-mainpanel -->
<!-- ########## END: MAIN PANEL ########## -->


<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

<script src="../lib/2018/select2/js/select2.min.js"></script>

<script src="../common/2018/bracket.js"></script>

<script>

    $(function () {
        $("#form_nav li").click(function () {
            var _index = $(this).index();
            jQuery("#CopyMode").val("" + (_index + 1));
            $(".config-box ul li").removeClass("block").eq(_index).addClass("block");
        })
    });
</script>
</html>
