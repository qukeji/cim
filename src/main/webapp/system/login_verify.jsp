<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

    //从系统参数中获取
    TideJson loginParameter = CmsCache.getParameter("login_verify_config").getJson();
    int SmsCode = loginParameter.getInt("SmsCode");
    int VerifyCode = loginParameter.getInt("VerifyCode");
    int CA_Certify = loginParameter.getInt("CA_Certify");
    int Dongles = loginParameter.getInt("Dongles");
    String AccessKeyId = loginParameter.getString("AccessKeyId");
    String AccessKeySecret = loginParameter.getString("AccessKeySecret");
    String smsSign = loginParameter.getString("smsSign");
    String TemplateCode = loginParameter .getString("TemplateCode");
    //form再次提交该jsp中，Submit记录是第几次访问
    String Submit = getParameter(request,"Submit");
    if(!"".equals(Submit)){
        String p_SmsCode= getParameter(request,"SmsCode");
        String p_VerifyCode = getParameter(request,"VerifyCode");
        String p_CA_Certify = getParameter(request,"CA_Certify");
        String p_Dongles = getParameter(request,"Dongles");
        String p_AccessKeyId = getParameter(request,"AccessKeyId");
        String p_AccessKeySecret= getParameter(request,"AccessKeySecret");

        if(!"".equals(p_SmsCode) && !"".equals(p_VerifyCode) &&!"".equals(p_CA_Certify) &&!"".equals(p_Dongles) &&!"".equals(p_AccessKeyId) &&!"".equals(p_AccessKeySecret)){
            String login_str = "{"
                + "\n\"SmsCode\":" + p_SmsCode  +   ","
                + "\n\"AccessKeyId\":\"" + p_AccessKeyId+   "\","
                + "\n\"AccessKeySecret\":\"" + p_AccessKeySecret+   "\","
                + "\n\"smsSign\":\"" + smsSign+   "\","
                + "\n\"TemplateCode\":\"" + TemplateCode+   "\","
                + "\n\"VerifyCode\":" + p_VerifyCode  +   ","
                + "\n\"CA_Certify\":" + p_CA_Certify  +   ","
                + "\n\"Dongles\":" + p_Dongles  +   ","
                + "\n}";

            Parameter p = CmsCache.getParameter("login_verify_config");
            p.setContent(login_str);
            p.Update();
            //out.print("<script>location.href(\"login_verify.jsp\");</script>");

        }
    }
    

%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../favicon.ico"/>
    <title>验证配置</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/common.css">
    <link rel="stylesheet"  type="text/css" href="../style/jquery.tagit.css" />
    <link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
    <link rel="stylesheet" href="../style/2018/bracket.css">

    <style>
        .collapsed-menu .br-mainpanel-file{margin:0px;margin-bottom: 30px;}
        #nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
        #nav-header a{color: #a4aab0;}

        .wd-content-lable.wd-sm-table{width: 400px;}
        .app-img-box{max-width: 800px;}
        .app-img-box img{max-width: 100%}

        @media (max-width: 992px) {
            .collapsed-menu .br-mainpanel-file {
                margin-left: 0;
            }
        }
        .bs-tooltip-bottom .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #f8f9fa;opacity: 1;}
        .tooltip.bs-tooltip-bottom .arrow::before,
        .tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {border-bottom-color: #f8f9fa;	}
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>

</head>

<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="myform" action="login_verify.jsp" method="post" id="form1">


    <div class="br-mainpanel br-mainpanel-file overflow-hidden">
        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-10">
            <div class="br-content-box pd-20 d-flex">
                <div class="br-content-box-left">
                    <div class="row flex-row align-items-center mg-b-15" id="tr_SmsCode" style="margin-bottom:2px;">
                        <label class="left-fn-title  wd-200" id="desc_SmsCode">短信验证：</label>
                        <input type='hidden' name='SmsCode' id='SmsCode'  value="<%=SmsCode%>" >
                        <div class="toggle-wrapper">
                            <div class='subSwitch toggle toggle-light success' <%if(SmsCode==1){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='SmsCode'></div>
                        </div>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15" style="margin-top:0;">
                            <span class="icon svg-icon-wrap svg-md svg-md-info-wrap utils__StyledSvgIcon-sc-199ue8j-0 dhvPiG" color="rgba(104, 104, 104, 1)" size="20">
                                <svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" class="svg-icon fa-svg-icon svg-fa-info" width="20" height="20" viewBox="0 0 24 24">
                                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z">
                                    </path>
                                </svg>
                            </span>
                        <label style="font-weight:bold;margin-bottom:0px;font-size:12px;">
                            短信验证接口调用阿里云，详细内容参考https://help.aliyun.com/document_detail/101414.html?spm=a2c4g.11174283.4.4.1ca82c42rXnM0D
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15 start_type_item  show" id="">
                        <label class="left-fn-title wd-250 " id="AccessKeyId_">AccessKeyId：</label>
                        <label class="wd-content-lable wd-sm-table d-flex position-re "  >
                            <input type="text" name="AccessKeyId"   id="AccessKeyId" value="<%=AccessKeyId%>" class="textfield  form-control" title="" size="80" >
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15 start_type_item " id="">
                        <label class="left-fn-title wd-250 " id="AccessKeySecret_">AccessKeySecret：</label>
                        <label class="wd-content-lable wd-sm-table d-flex position-re "  >
                            <input type="text" name="AccessKeySecret"   id="AccessKeySecret" value="<%=AccessKeySecret%>" class="textfield  form-control" title="" size="80" >
                        </label>
                    </div>


                </div>
            </div>
        </div>


        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-10">
            <div class="br-content-box pd-20">
                <div class="row mg-0-force">
                    <div class="col-sm-6 pd-0-force mg-t-20">

                        <div class="row flex-row align-items-center mg-b-15" id="tr_VerifyCode" style="margin-bottom:2px;">
                            <label class="left-fn-title  wd-200" id="desc_VerifyCode">图形认证：</label>
                            <input type='hidden' name='VerifyCode' id='VerifyCode'  value="<%=VerifyCode%>" >
                            <div class="toggle-wrapper">
                                <div class='subSwitch toggle toggle-light success' <%if(VerifyCode==1){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='VerifyCode'></div>
                            </div>
                        </div>

                        
                         <div class="row flex-row align-items-center mg-b-15" id="tr_CA_Certify" style="margin-bottom:2px;">
                            <label class="left-fn-title  wd-200" id="desc_CA_Certify">CA认证：</label>
                            <input type='hidden' name='CA_Certify' id='CA_Certify'  value="<%=CA_Certify%>" >
                            <div class="toggle-wrapper">
                                <div class='masterSwitch  masterSwitch1  toggle toggle-light success' <%if(CA_Certify==1){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='CA_Certify'></div>
                            </div>
                        </div>

                        
                         <div class="row flex-row align-items-center mg-b-15" id="tr_Dongles" style="margin-bottom:2px;">
                            <label class="left-fn-title  wd-200" id="desc_Dongles">加密狗：</label>
                            <input type='hidden' name='Dongles' id='Dongles'  value="<%=Dongles%>" >
                            <div class="toggle-wrapper">
                                <div class='masterSwitch masterSwitch2  toggle toggle-light success' <%if(Dongles==1){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='Dongles'></div>
                            </div>
                        </div>

                    </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="br-content-box pd-20">
            <input type="hidden" name="Submit" value="Submit">
            <div class="row flex-row align-items-center mg-b-15 justify-content-center">

                <button id="applButton" name="applButton" type="submit" class="btn btn-primary tx-size-xs pd-x-30 ">应用</button>
            </div>
        </div>
    </div>

</form>
<!--6ms-->
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/document.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<script src="../common/tag-it.js"></script>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>

<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>

	//开关相关
    //初始化
    $('.toggle').toggles({
        height: 25
    });

    //总开关
    $(".masterSwitch").click(function(){
        var masterSwitch = $(this).data('toggle-active');
        if(masterSwitch){
            $('.subSwitch').toggles(false);
            if($(this).hasClass("masterSwitch1")){
                $('.masterSwitch2').toggles(false);
            }
            if($(this).hasClass("masterSwitch2")){
                $('.masterSwitch1').toggles(false);
            }
        }
        var myToggle = $(this).data('toggle-active');
        var id = $(this).attr('field');
        if(myToggle){
            $("#"+id).val("1");//开
            if(id=="CA_Certify"){
                $("#Dongles").val("0");//关
            }
            if(id=="CA_Certify"){
                $("#Dongles").val("0");//关
            }
            $("#SmsCode").val("0");//关
            $("#VerifyCode").val("0");//关
        }else{
            $("#"+id).val("0");//关
        }
    })
    //子开关
    $(".subSwitch").click(function(){
        var masterSwitch = $(".masterSwitch").data('toggle-active');
        if(masterSwitch){
            //alert("请先开启AI视频分析");
            var dialog = new top.TideDialog();
            dialog.showAlert("请先确认已关闭CA认证和加密狗","danger");
            var id = $(this).attr('field');
            $("#"+id).val("0");//关
            $(this).toggles(false);
            return false;
        }else{
            var myToggle = $(this).data('toggle-active');
            var id = $(this).attr('field');
            if(myToggle){
                $("#"+id).val("1");//开
            }else{
                $("#"+id).val("0");//关
            }
        }
    })




    function init(){}
function initContent(){}

</script>
</body>
</html>
