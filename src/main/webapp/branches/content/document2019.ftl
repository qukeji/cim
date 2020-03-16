<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="${request.contextPath}/favicon.ico"/>
<title>${(item??)?string("编辑文档 " + (item.getTitle())!"",'"新建文档"')} ${channelParentChannelPath} TideCMS</title>
<link href="${request.contextPath}/lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="${request.contextPath}/lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="${request.contextPath}/lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="${request.contextPath}/lib/2018/summernote/summernote-bs4.css" rel="stylesheet">
<link href="${request.contextPath}/lib/2018/select2/css/select2.min.css" rel="stylesheet">

<link rel="stylesheet" href="${request.contextPath}/style/2018/common.css">
<link rel="stylesheet"  type="text/css" href="${request.contextPath}/style/jquery.tagit.css" />
<link href="${request.contextPath}/lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">

<link rel="stylesheet" type="text/css" href="${request.contextPath}/style/timepicker/jquery-ui.css" />
<link rel="stylesheet"  type="text/css" href="${request.contextPath}/style/timepicker/jquery-ui-timepicker-addon.css" />
<link rel="stylesheet" href="${request.contextPath}/style/2018/bracket.css">

<style>
    <style>
    .collapsed-menu .br-mainpanel-file{margin-left: 60px;margin-bottom: 30px;}
    #nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
    #nav-header a{color: #a4aab0;}
    .table-bordered {border: 1px solid #dee2e6;text-align: center;}
    #tabTable td{padding: 0.3rem !important;cursor: pointer;}
    .selTab{border: 1px solid #17A2B8 !important;background-color: #17A2B8;color: #fff;}
    .edui-default .edui-editor-breadcrumb{line-height: 30px;}
    .btn-box a{color:#fff }
    .ui-widget-content{border: 1px solid rgba(0, 0, 0, 0.15) ;}
    .bs-tooltip-bottom .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #f8f9fa;opacity: 1;}
    .tooltip.bs-tooltip-bottom .arrow::before,
    .tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {border-bottom-color: #f8f9fa;	}
    /*.edui-editor {z-index: 0 !important;}*/
    /*tooltip相关样式*/
    .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
    .tooltip.bs-tooltip-right .arrow::before,
    .tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {
        border-right-color: #00b297;
    }
    .collapsed-menu .br-mainpanel-file {
        margin-left: 60px;
        margin-bottom: 30px;
    }

    /*@media (min-width: 992px)*/
        /*.collapsed-menu .br-mainpanel-file {*/
             /*margin-left: 0px;*/
        /*}*/
        /*@media (min-width: 992px)*/
            /*.br-mainpanel-file {*/
                 /*margin-left: 0px;*/
            /*}*/
            /*@media (min-width: 992px)*/
                /*.br-mainpanel {*/
                    /*margin-left: 59px;*/
                /*}*/
</style>

<script src="${request.contextPath}/lib/2018/jquery/jquery.js"></script>
<script src="${request.contextPath}/lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="${request.contextPath}/common/2018/common2018.js"></script>
<script src="${request.contextPath}/common/document.js"></script>
<script type="text/javascript" src="${request.contextPath}/common/2018/TideDialog2018.js"></script>
<script src="${request.contextPath}/common/tag-it.js"></script>
<!--百度编辑器-->
<script type="text/JavaScript" charset="utf-8" src="${request.contextPath}/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="${request.contextPath}/ueditor/ueditor.all.js"></script>
<script type="text/javascript" charset="utf-8" src="${request.contextPath}/ueditor/lang/zh-cn/zh-cn.js"></script>
<!--<script type="text/javascript" charset="utf-8" src="../ueditor/toupiaoDialog.js"></script>-->
<script type="text/javascript" charset="utf-8" src="${request.contextPath}/ueditor/photosDialog.js"></script>
<script type="text/javascript" charset="utf-8" src="${request.contextPath}/ueditor/imgeditorDialog.js"></script>
<script type="text/javascript" charset="utf-8" src="${request.contextPath}/ueditor/imagesDialog.js"></script>

<script>
    var webName = "${request.contextPath}";

    var Pages=1;
    var curPage = 1;
    var Contents = new Array();
    Contents[Contents.length] = "";
    var userId = ${userinfo_session.id};
    var userName = "${userinfo_session.getName()}";
    var userGroupName = "${userGroup}";
    var userGroupId = ${userinfo_session.getGroup()};
    var channelid = ${ChannelID};
    var groupnum = ${(QRcode=="")?string(fieldGroupArray_size,fieldGroupArray_size + 1)};
    var begin_time = ${begin_time};
    var SiteAddress = "${SiteAddress}";
    var GlobalID = ${GlobalID};
    var inner_url = "${inner_url}";
    var outer_url = "${outer_url}";
    var ChannelID = "${ChannelID}";
    var is_auto_save = false;//自动保存
    var timer = null;//定时器
    var NoCloseWindow = ${NoCloseWindow};//是否关闭页面
    var unload = true ;//关闭页面是否提示
    window.onresize = function(){
        if(document.getElementsByClassName("content-edit-frame")[0]){
            if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
                var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.body.scrollHeight ;
            }else{
                var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.documentElement.scrollHeight ;
            }
            document.getElementsByClassName("content-edit-frame")[0].style.height = _height
        }
    }
    //调整iframe的高度
    function changeFrameHeight(_this){
        if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
            _this.style.height = _this.contentWindow.document.body.scrollHeight +5;
        }else{
            _this.style.height = _this.contentWindow.document.documentElement.scrollHeight +5;
        }
    }
    function save_(){
        var users   = $("#approve").attr("user");
        var user    = ${userinfo_session.id}+"";
        var arr     =new Array();
        arr         = users.split(',');

        var result = $.inArray(user, arr);
        if(result == -1){
            tips("当前用户没有权限");
        }else{
            Save();
        }
    }
    //提示信息
    function tips(obj){
        var dialog = new top.TideDialog();
        dialog.setWidth(320);
        dialog.setHeight(280);
        dialog.setTitle("提示");
        dialog.setMsg(obj);
        dialog.ShowMsg();
    }
</script>

<script>
    function Save_approve()
    {
        document.form.Approve.value = 1;
        Save();
    }

    function Save()
    {
        if(check())
        {
            //有内容拦的情况下，保存前先处理内容栏
            if(document.getElementById("tabTableRow"))
                Save_Content();
            document.getElementById("Image1Href").href = "javascript:void(0);";
            <#if hasRight == true>
                document.getElementById("Image2Href").href = "javascript:void(0);";
            </#if>

            if(is_auto_save)
            {
                document.getElementById("Image1Href").href = "javascript:void(0);";
            <#if hasRight == true>
                document.getElementById("Image2Href").href = "javascript:void(0);";
            </#if>
            }

            var _form_data = $("#form").serialize();
            if(form_data == _form_data && is_auto_save)// 自动保存 数据没有变化时不进行数据提交
            {
                // $("#display_auto_save").removeClass("auto_save_hide").addClass("auto_save").text("数据没有变化"+getNowFormatDate());
                return ;
            }
            //如果有数据变化 把新的表单值赋值给form_data
            form_data =_form_data ;
            //编辑互斥
            isSaved();
            $("#display_auto_save").removeClass("auto_save_hide").addClass("auto_save").text("正在保存"+getNowFormatDate());
            $.ajax({
                type: "POST",
                url:"${request.contextPath}/content/document_submit.jsp",
                data:$('#form').serialize(),
                dataType:'json',
                success: function(result)
                {
                    if(!is_auto_save)
                    {//非自动保存
                        if(result.message=="")
                        {
                            unload = false ;
                        <#if IsDialog == 0 >
                            if(window.opener!=null)
                            {
                                window.opener.document.location.reload();
                            }

                            // window.location.href="about:blank";
                            // window.close();
                            // update
                            // open(location, '_self').close();
                            window.close();
                        </#if>

                        <#if IsDialog == 1 >
                            top.TideDialogClose({refresh:'right'});
                        </#if>
                        }else{
                            if(result.message=="auto save")
                            {
                            }
                            else
                            {
                                ddalert(result.message,"(function dd(){getDialog().Close({suffix:'html'});})()");
                                //alert(result.message);
                            }
                            document.getElementById("Image1Href").href = "javascript:Save();";
                        <#if hasRight == true>
                                document.getElementById("Image2Href").href = "javascript:Save_Publish();";
                        </#if>
                        }
                    }
                    else
                    {
                        //自动保存刷新页面
                        //window.location.href="document.jsp?NoCloseWindow=1&ItemID=" + result.id+ "&ChannelID="+result.channelid
                        document.form.NoCloseWindow.value = '1';
                        document.form.Action.value='Update';
                        document.form.ItemID.value=result.id;

                        document.getElementById("Image1Href").href = "javascript:Save();";
                    <#if hasRight == true>
                        document.getElementById("Image2Href").href = "javascript:Save_Publish();";
                    </#if>


                    }
                    $("#display_auto_save") .addClass("auto_save").text("保存完成"+getNowFormatDate());
                    // $("#display_auto_save").removeClass("auto_save").addClass("auto_save_hide");
                },
                error: function (XMLHttpRequest, textStatus, errorThrown)
                {
                    alert("保存没有成功，请重新尝试。");
                    document.getElementById("Image1Href").href = "javascript:Save();";
                <#if hasRight == true>
                    document.getElementById("Image2Href").href = "javascript:Save_Publish();";
                </#if>
                }
            });


        }
    }
    function init() {

        $('#SetPublishDate').datetimepicker({
            timeText: '时间',
            hourText: '小时',
            minuteText: '分钟',
            secondText: '秒',
            currentText: '现在',
            closeText: '完成',
            showSecond: true, //显示秒
            dateFormat: "yy-mm-dd",
            timeFormat: 'HH:mm:ss',//格式化时间
            monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
            dayNames: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
            dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
            dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']
        });
        $('#Revoketime').datetimepicker({
            timeText: '时间',
            hourText: '小时',
            minuteText: '分钟',
            secondText: '秒',
            currentText: '现在',
            closeText: '完成',
            showSecond: true, //显示秒
            dateFormat: "yy-mm-dd",
            timeFormat: 'HH:mm:ss',//格式化时间
            monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
            dayNames: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
            dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
            dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']
        });

        $(".date").datetimepicker({
            timeText: '时间',
            hourText: '小时',
            minuteText: '分钟',
            secondText: '秒',
            currentText: '现在',
            closeText: '完成',
            showSecond: true, //显示秒
            dateFormat: "yy-mm-dd",
            timeFormat: 'HH:mm:ss',//格式化时间
            monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
            dayNames: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
            dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
            dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']
        });

        var sampleTags = [];
        $("#Keyword").tagit({availableTags: sampleTags});
        $("#Tag").tagit({availableTags: sampleTags});
        <#if item??>
            document.form.Action.value = 'Update';
        <#else>
            <#if (RecommendItemID>0) && (RecommendChannelID>0)>
                "recommendItemJS(" + "${RecommendItemID}," + "${RecommendChannelID}," + "${ChannelID},\"" + "${RecommendTarget}" + "\);";
            </#if>
            <#if (RecommendOutItemID>0) && (RecommendChannelID>0)>
                "recommendItemJS(" + "${RecommendOutItemID}," + "${RecommendOutChannelID}," + "${ChannelID},\"" + "${ROutTarget}" + "\);";
            </#if>
            <#if (CloudChannelID>0) && (CloudItemID>0)>
                "cloudItemJS(" + "${CloudItemID}," + "${CloudChannelID}," + "${ChannelID}" + ");";
            </#if>
            <#if (transfer_article_length>0)>
                "transferArticleJS(\"" + ${transfer_article} +"\");";
            </#if>
        </#if>
        checkTitle();
        document.body.disabled = false;
        auto_save();
    }
    //获取当前时间
    function getNowFormatDate()
    {
        var date = new Date();
        var seperator1 = "-";
        var seperator2 = ":";
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = year + seperator1 + month + seperator1 + strDate
                + " " + date.getHours() + seperator2 + date.getMinutes()
                + seperator2 + date.getSeconds();
        return currentdate;
    }
    //自动保存
    function auto_save()
    {
        if($("#auto_save").attr("checked"))//勾选了才自动保存
        {
            is_auto_save = true;
            document.form.NoCloseWindow.value = '1';
            timer = window.setInterval("Save()","30000");
        }
        //自动保存
        $("#auto_save").change(
                function()
                {
                    if(this.checked)
                    {//选中 自动保存
                        is_auto_save = true;
                        document.form.NoCloseWindow.value = '1';
                        timer = window.setInterval("Save()","30000");
                    }
                    else
                    {//取消自动保存
                        is_auto_save = false;
                        document.form.NoCloseWindow.value = '0';
                        window.clearInterval(timer);
                    }
                }
        );
    }
    function initContent1()
    {
    <#if item??>
        if(document.getElementById("tabTableRow"))
            try{
                {// <%//System.out.println(item.getContent());%>
                <#if (item.getTotalPage()>1)>
                <#list list as key>
                    AddPageInit();//alert(content);
                    content = '${key.content}';//alert(content);
                <#if SiteAddress != "">
                    content = content.replace(/src=\"\//g, 'src=\"${SiteAddress}\/' ) ;
                </#if>
                    //SetContent(${key.i},content);
                    var num = ${key.i};
                    if(num<=Contents.length)
                        Contents[num-1] = content;
                    else
                        Contents[Contents.length] = content;
                </#list>
                </#if>
                }
            }catch(er){	window.setTimeout("initContent1()",5);}
        document.form.Action.value = "Update";//alert(Contents["t2"]);
    </#if>
    }
    function initContent()
    {
        window.setTimeout("initContent1()",1);
    }

    var curField = 0;

    function previewFile(fieldname)
    {
        var name = document.getElementById(fieldname).value;
        //图片库采用本地预览
        var reg = new RegExp(outer_url,"g");
        if(name=="") return;

        if(name.indexOf("http://")!=-1 || name.indexOf("https://")!=-1)  window.open(name.replace(reg,inner_url));
        else	window.open("${SiteAddress}/" + name);
    }

    function selectByKeyword()
    {
        var ByKeyword = document.getElementById("ByKeyword");
        var ByTitle = document.getElementById("ByTitle");
        document.getElementById("related_doc_list").src = "related_doc_list.jsp?GlobalID=${GlobalID}&ChannelID=${ChannelID}&ByKeyword="+ByKeyword.checked + "&ByTitle="+ByTitle.checked + "&keyword=" + encodeURIComponent(document.form.ByKeywordText.value);
    }


</script>
</head>
<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="form" action="${request.contextPath}/content/document_submit.jsp" method="post" id = "form">
    <div class="br-logo"><img src="${request.contextPath}/images/2018/system-logo.png"></div>
    <div class="br-sideleft overflow-y-auto">
        <label class="sidebar-label pd-x-15 mg-t-20"></label>
        <#list list1 as key>
        <div class="br-sideleft-menu">
            <a href="javascript:showTab('${key.i + 1}')"  ${(key.i == 0)?string("class='br-menu-link active'","class='br-menu-link'")} id="form${key.i +1}_td" groupid="${key.fieldGroup.getId()}" data-toggle="tooltip" data-placement="right" title="${key.fieldGroup.getName()}">
            <div class="br-menu-item">
                <#if key.fieldGroup.getIcon()!="">
                    ${key.fieldGroup.getIcon()}
                <#else >
                <i class="menu-item-icon fa fa-edit tx-22"></i>
                </#if>
                <span class="menu-item-label"><${key.fieldGroup.getName()}></span>
            </div><!-- menu-item -->
            </a><!-- br-menu-link -->
        </div><!-- br-sideleft-menu -->
        </#list>
        <#if QRcode != "">
        <div class="br-sideleft-menu">
            <a href="javascript:showTab('${fieldGroupArray_size}+1')" class="br-menu-link" id="form(${fieldGroupArray_size}+1)_td" data-toggle="tooltip" data-placement="right" title="二维码">
                <div class="br-menu-item">
                    <i class="menu-item-icon fa fa-edit tx-22"></i>
                    <span class="menu-item-label">二维码</span>
                </div><!-- menu-item -->
            </a><!-- br-menu-link -->
        </div><!-- br-sideleft-menu -->
        </#if>
        <#if Version?? && Version == 1>
            <div class="br-sideleft-menu">
                <a href="javascript:showTab('${vercount}')" class="br-menu-link" id="form${vercount}_td" data-toggle="tooltip" data-placement="right" title="历史版本">
                    <div class="br-menu-item">
                        <i class="menu-item-icon fa fa-history tx-22"></i>
                        <span class="menu-item-label">历史版本</span>
                    </div><!-- menu-item -->
                </a><!-- br-menu-link -->
            </div><!-- br-sideleft-menu -->
        </#if>
    </div><!-- br-sideleft -->
    <div class="br-header">
        <div class="br-header-left">
            <div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
            <div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
            <div id="nav-header" class="hidden-md-down flex-row align-items-center">
                ${ParentChannelPath}
            </div>
        </div><!-- br-header-left -->
        <div class="br-header-right">
            <div class="btn-box" >
                <#if (ApproveScheme==0||(action==1||id_aa==0)||ItemID==0) >
                <a class="btn btn-primary tx-size-xs mg-r-5" href="javascript:Save();" id="Image1Href">保存</a>
                <#if ApproveScheme != 0>
                <a class="btn btn-secondary tx-size-xs mg-r-5" id="Image2Href" href="javascript:Save_approve();">提交审核</a>
                <#else>
                    <#if hasRight == true>
                <a class="btn btn-secondary tx-size-xs mg-r-5" id="Image2Href" href="javascript:Save_Publish();">保存并发布</a>
                    </#if>
                </#if>
                <#else>
                <a class="btn btn-primary tx-size-xs mg-r-5" href="javascript:save_();"  id="imageHrefJurisdiction">保存</a>
                <#if size != 0 >
                <a class="btn btn-secondary tx-size-xs mg-r-5" href="javascript:Preview2()">本地预览</a>
                </#if>

                <#if end != 1>
                <a class="btn btn-secondary tx-size-xs mg-r-5" href="javascript:SaveApprove(1);" id="Image1Href">驳回</a>
                <a class="btn btn-secondary tx-size-xs mg-r-5" href="javascript:SaveApprove(0);" id="Image2Href">通过</a>
                </#if>
                </#if>
                <a class="btn btn-secondary tx-size-xs mg-r-10" href="javascript:self.close();">关闭</a>
            </div>
        </div><!-- br-header-right -->
    </div><!-- br-header -->
    <#list list2 as key>

        <div class="br-mainpanel br-mainpanel-file overflow-hidden" url="${key.url}" id="from${key.j+1}" <#if key.j != 0> style=\"display:none;\"";</#if> <#if key.j == 0> data-approve="${data_approve}" data-yl="${data_yl}"</#if>>

        <div class="br-pagebody bg-white mg-l-20 mg-r-20 "${key.padding}   url="${key.url}"><div class="br-content-box pd-20"> <div class="center" >

        <#if (key.fieldGroupID>0) && (key.fieldGroup.getUrl() != "")>
            <iframe id=iframe${key.j+1} frameborder=0 style="width:100%;height:100%" marginheight=0 marginwidth=0 scrolling="auto" src="${key.url}" <!--onload=\"changeFrameHeight(this)\"--> ></iframe>"
        <#else >
            <div class="article-title mg-l-15 mg-b-15 pd-r-30" >
            <#if key.j == 0>
              <div class="row flex-row align-items-center mg-b-15" id="tr_${(key.field_title.getName())!''}">
                  <label class="left-fn-title wd-150 " id="tr_Title"> ${(key.field_title.getDescription())!''}：</label>
			  <label class="wd-content-lable d-flex" id="field_Title">
                  <input class="form-control" placeholder="" type="text" id="Title" name="Title" size="80" value="${title1}" onkeyup="checkTitle();">
              </label>
              <#--update   -->
			  <#--<label><span id="TitleCount" class="mg-l-10"></span></label>-->
              <#if (key.length>0)>
                   "<script>"+${key.JS}+"</script>"
              </#if>

              <#if editCategory>
                    <label class="left-fn-title wd-60 ">分类：</label>
			        <select class="form-control wd-230 ht-40 select2" name="ChannelID" id="ChannelID">
                    <#if categorys_isExist == true>
                        <#list list as key>
                            <option value="${key.subcategory.id}" ${key.bol}>${key.subcategory.name}</option>
                        </#list>
                    </#if>
                    </select>
              </#if>
              </div>
                    <#if key.field_title.getCaption() != "">
                        <div class="row mg-t--10">
                            <label class="left-fn-title wd-150"> </label>
                            <label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
                            </i>${key.field_title.Caption}
                            </label>
                        </div>
                    </#if>
            </#if> <#--493-->
                <#list list4 as key_>
                    <#--&lt;#&ndash;glp&ndash;&gt;-->
                    <#--<#if editCategory_bol == true>-->
                    <#--&lt;#&ndash;glp &ndash;&gt;-->
                        <#if key_.nameEqualsContent==true>
                            <div class="row flex-row align-items-center mg-b-15" id="tr_changeEditor">
                                <label class="left-fn-title wd-150" id="">编辑器选择：</label>
                                <label class="wd-content-ckx d-flex" id="">
                                    <label class="rdiobox mg-r-15">
                                        <input type="radio" value="0" checked="checked" id="default_editor" name="editortype">
                                        <span for="default_editor">默认编辑器</span>
                                    </label>
                                    <label class="rdiobox mg-r-15">
                                        <input type="radio" value="1" id="h5_editor" name="editortype">
                                        <span for="h5_editor">微信编辑器</span>
                                    </label>
                            </div>
                    <#--</#if>-->
                            <#if key_.field.getCaption() != "">
                                <div class="row mg-t--10">
                                    <label class="left-fn-title wd-150"> </label>
                                    <label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
                                    </i>${key_.field.getCaption()}
                                    </label>
                                </div>
                            </#if>
                            <div class="row flex-row align-items-center mg-b-15 edit" id="tr_${key_.field.getName()}">
                                <input type="hidden" id="baiduEditor1" name="baiduEditor1" value="" style="display:none" />
                                <script id="editor" type="text/plain" style="width:100%;height:600px;"></script>
                                <script type="text/javascript">
                                var currcontent = "";
                                <#if item??>
                                    currcontent = '${key_.currcontent}';
                                <#if SiteAddress != "">
                                        currcontent = currcontent.replace(/src=\"\//g, 'src=\"${SiteAddress}/' ) ;

                                </#if>
                                $("#baiduEditor1").val(currcontent);
                                </#if>
                                var ChannelID=${ChannelID};

                                var ue = UE.getEditor('editor');
                                ue.ready(function() {
                                    UE.getEditor('editor').setHeight(600) ;//设置高度600
                                    setContent(currcontent,false);
                                });
                                //获得内容
                                function getContent() {
                                    var content = ue.getContent() ;
                                    if(content==""){
                                        try{
                                            if(document.getElementById("h5editor1_Frame").contentWindow.WXBEditor){
                                                content = h5_getContent();
                                            }
                                        }catch(e){

                                        }
                                    }
                                    content = content.replace(/(<img class="tide_video_fake".*?)>/gi,"");
                                    content = content.replace(/(<img class="tide_photo_fake".*?)>/gi,"");
                                    return content;
                                }
                                //写入内容
                                function setContent(content,isAppendTo){
                                    var img = "<img class=\"tide_video_fake\" src=\"${request.contextPath}/editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
                                    var img1 = "<img class=\"tide_photo_fake\" src=\"${request.contextPath}/editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";

                                    content = content.replace(/(<span id="tide_video">(.+?)<\/span>)/gi,"$1"+img);
                                    content = content.replace(/(<span id="tide_photo">(.+?)<\/span>)/gi,"$1"+img1);
                                    ue.setContent(content,isAppendTo);
                                }
                                //获得纯文本
                                function getContentTxt(){
                                    return ue.getContentTxt();
                                }
                                //返回当前编辑器对象
                                function getUE(){
                                    return ue;
                                }
                                </script>
                                <table id="tabTable" CELLPADDING=0 CELLSPACING=0 class="table table-bordered mg-b-0">
                                    <tr id="tabTableRow" onclick="changeTabs()">
                                        <td id="t1" class="selTab" page="1" height="20">第1页</td>
                                    </tr>
                                </table>
                                <input type="button" value="删除当前页" onclick="DeletePage();" class="btn btn-primary tx-size-xs mg-r-10 mg-t-10">
                                <input type="button" value="插入一页" onclick="AddPage();" class="btn btn-primary tx-size-xs mg-r-10 mg-t-10">
                            </div>

                        <#elseif (key_.field.FieldType)!"" == "label">
                            <div class="row flex-row align-items-center mg-b-15" id="tr_${key_.field.Name}">
                                <#if key_.field.FieldType == "label">
                                <label class="left-fn-title wd-150 ">${key_.field.Description}：</label>
                                </#if>
                                <label class="wd-content-lable d-flex">${key_.field.Other}</label>
                            </div>
                            <#if key_.field.Caption != "">
                            <div class="row mg-t--10">
                                <label class="left-fn-title wd-150"> </label>
                                <label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
                                </i>${key_.field.Caption}
                                </label>
                            </div>
                            </#if>
                        <#else>
                            <#if ((key_.field.Name)!"") == "PublishDate">
                                <div class="row flex-row align-items-center mg-b-15" id="tr_${key_.field.Name}">
                                    <label class="left-fn-title wd-150 ">${key_.field.getDescription()}：</label>
                                    <label class="">=${key_.displayHtml_}  =${key_.displayHtml_1}</label>
                                </div>
                                <#if key_.field.Caption != "">
                                <div class="row mg-t--10">
                                    <label class="left-fn-title wd-150"> </label>
                                    <label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
                                    </i>${key_.field.Caption}
                                    </label>
                                </div>
                                </#if>
                            <#elseif key_.field.getName() == "Keyword2">
                                <div class="row flex-row align-items-center mg-b-15" id="tr_${key_.field.Name}">
                                    <label class="left-fn-title wd-150 ">${key_.field.Description}：</label>
                                    <label class="wd-content-lable d-flex">
                                        ${key_.displayHtml_2}
                                        <input name="kewwordselect" type="button" class="btn btn-primary tx-size-xs mg-r-5" value="按关键词选择" onclick="selectByKeyword2()">
                                    </label>
                                </div>
                                <#if key_.field.Caption != "">
                                <div class="row mg-t--10">
                                    <label class="left-fn-title wd-150"> </label>
                                    <label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
                                    </i>${key_.field.Caption}
                                    </label>
                                </div>
                                </#if>
                                <div class="row flex-row align-items-center mg-b-15">
                                    <label class="left-fn-title wd-150 ">相关视频：</label>
                                    <label class="wd-content-lable d-flex">
                                        <iframe id="related_video_list" frameborder="0" height="400" width="650" marginheight="0" marginwidth="0" scrolling="auto" src="${request.contextPath}/video/related_video_list.jsp?${ItemID}&ChannelID=${ChannelID}"></iframe>
                                    </label>
                                </div>
                            <#else >
                                ${key_.displayHtml2018!""}
                            </#if>
                        </#if>

                </#list>
            </div>
        </#if> <#--491-->
        </div></div></div></div>
    </#list>

    <div class="br-mainpanel br-mainpanel-file overflow-hidden"
    <#if j != 0> style="display:none;" </#if> url="" id="form${vercount}">
    <iframe id="content_historical_version" class="content-edit-frame" style="width:100%;min-height:960px;height:100%;" frameborder="0" marginheight="0" marginwidth="0" scrolling="auto"
            src="${request.contextPath}/content/content_historical_version.jsp?GlobalID=${GlobalID}"></iframe>
    </div>

    <#if QRcode != "">
    <div class="br-mainpanel br-mainpanel-file overflow-hidden" <#if j != 0> style="display:none;" </#if> id="form${fieldGroupArraySize}">
    <div class="br-pagebody bg-white mg-l-20 mg-r-20">
        <div class="br-content-box pd-20">
    <!--标签组-->
        <div class="center" url="">
            <div class="article-title mg-l-15 mg-b-15 pd-r-30">
                <div class="row flex-row align-items-center">
                    <label class="left-fn-title wd-150 ">二维码分享功能：</label>
                    <label class="wd-content-lable d-flex">
                        <div><img src="${QRcode}"></div>
                        <div>二维码标签分享功能</div>
                        <div>左侧的二维码是本内容是由移动终端分享地址生成。<br>通过手机、PAD客户端或微信“扫一扫”功能拍摄扫描二维码实现移动设备的内容浏览，并可以通过分享工具分享给移动设备用户。<br>也可以将本二维码发布到网页中，实现基于网页的二维码拍摄分享功能。</div>
                    </label>
                </div>
            </div>
            <div class="article-title mg-l-15 mg-b-15 pd-r-30">
                <div class="row flex-row align-items-center">
                    <label class="left-fn-title wd-150 ">二维码图片地址：</label>
                    <label class="wd-content-lable d-flex">${QRcode}</label>
                </div>
            </div>
        </div>
    </#if>
</div>
</div>
</div>
    <input type="hidden" name="From" value="${From!""}">
    <input type="hidden" name="Action" value="Add">
    <input type="hidden" name="Content" value="">
    <input type="hidden" id="ItemID" name="ItemID" value="${ItemID}">
    <#if editCategory == false>
    <input type="hidden" name="ChannelID" value="${ChannelID}">
    </#if>
    <input type="hidden" name="Status" value="0">
    <input type="hidden" name="Approve" value="0">
    <input type="hidden" id="GlobalID" name="GlobalID" value=">${GlobalID}">
    <input type="hidden" name="ParentGlobalID" value="${parentGlobalID!""}">
    <input type="hidden" name="RelatedItemsList" value="">
    <input type="hidden" name="Page" value="1">
    <input type="hidden" id="RecommendGlobalID" name="RecommendGlobalID" value="0">
    <input type="hidden" name="RecommendChannelID" value="0">
    <input type="hidden" name="RecommendItemID" value="0">
    <input type="hidden" name="NoCloseWindow" id="NoCloseWindow" value="0">
    <input type="hidden" name="ContinueNewDocument" value="${ContinueNewDocument!""}">
    <input type="hidden" id="RecommendType" name="RecommendType" value="0"><div id="ajax_script" style="display:none;"></div>
</form>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<#if jsLength == true>
    <script> ${documentJS} </script>
</#if>
<script type="text/javascript">
    var form_data = $("#form").serialize();//获取表单数据
    <#if (Parent > 0)>
        setValue('Parent',"+Parent+");
    </#if>
</script>

<!--兼容性提示弹窗-->
<div class="editorTipsModal modal" id="editorTipsModal" >
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close">×</button>
                <h4 class="modal-title" id="myModalLabel">系统提示</h4>
            </div>
            <div class="modal-body">
                <p>系统检测到您正在使用低版本浏览器，为保证您的正常使用，请升级浏览器到最新版本。</p>
                <p>推荐使用浏览器：谷歌浏览器，其他浏览器及版本：360浏览器最新版、IE9及以上版本。</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-close" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<script src="${request.contextPath}/lib/2018/popper.js/popper.js"></script>
<script src="${request.contextPath}/lib/2018/bootstrap/bootstrap.js"></script>
<script src="${request.contextPath}/lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="${request.contextPath}/lib/2018/moment/moment.js"></script>
<script src="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="${request.contextPath}/lib/2018/peity/jquery.peity.js"></script>
<script src="${request.contextPath}/lib/2018/highlightjs/highlight.pack.js"></script>
<script src="${request.contextPath}/lib/2018/medium-editor/medium-editor.js"></script>
<script src="${request.contextPath}/lib/2018/select2/js/select2.min.js"></script>
<script src="${request.contextPath}/lib/2018/jquery-toggles/toggles.min.js"></script>
<script type="text/javascript" src="${request.contextPath}/common/jquery-ui-timepicker-addon.js"></script>
<script src="${request.contextPath}/common/2018/bracket.js"></script>

<script>
    var groupnum=${vercount};
    $(function(){
        'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function(e){
            e.preventDefault();
            if($('body').hasClass('show-mb-left')) {
                $('body').removeClass('show-mb-left');
                $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
            } else {
                $('body').addClass('show-mb-left');
                $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
            }
        });

        $('.br-sideleft [data-toggle="tooltip"]').tooltip({
            shadowColor:"#ffffff",
            textColor:"000000",
            trigger:"hover"
        });
    });

</script>

<script>
    //h5编辑器相关
    var everLoadH5 = false ;
    $("#tr_changeEditor input[name='editortype']").click(function(){
        var val = $(this).val();
        if(val==0){
            $("#tr_h5Editor").hide();
            $("#tr_Content").show();
            setContent(h5_getContent());
            h5_setContent("");
        }else{
            if(!everLoadH5){
                var _html = '<iframe id="h5editor1_Frame" src="${request.contextPath}/h5/index.html?webname=${request.contextPath}" width="100%" height="800" frameborder="0" scrolling="no" onload="inserBdContent()" ></iframe>' ;
                $("#tr_Content").hide();
                $("#tr_h5Editor").html(_html).show();
                everLoadH5 = true ;
            }else{
                $("#tr_h5Editor").show();
                $("#tr_Content").hide();
                h5_setContent(getContent());
                setContent("");
            }
//			var h5ue = document.getElementById("h5editor1_Frame").contentWindow.WXBEditor
//			h5ue.ready(function() {
//			   h5_insertContent(getContent());
//			});
        }
    })
    var Parameter = "&ChannelID=" + ChannelID;
    //本地预览
    function Preview2()
    {
        window.open("${request.contextPath}/content/document_preview.jsp?ItemID=${ItemID}" + Parameter);
    }
    //审核预览
    function approve_preview(versionid)
    {
        window.open("${request.contextPath}/content/preview_version.jsp?vid="+versionid+"&ItemID=" + ${ItemID} + Parameter);
    }
    function returnVersion(id){
        $.ajax({
            url:"version_data.jsp?id="+id,
            dataType:"json",
            success:function(data){
                $("#Title").val(data.Title);
                // update
                var currcontent = (data.Content).replace(/src=\"\//g, 'src=${SiteAddress}' ) ;
                setContent(currcontent,"");
                $("#Summary").val(data.Summary);
                tipVersion(data.Title);
            }
        });
    }
    function tipVersion(title){
        window.alert(title+"版本内容已恢复，请返回内容编辑");
    }
    function inserBdContent(){
        var _interval = setInterval(function(){
            try
            {
                var h5ue = document.getElementById("h5editor1_Frame").contentWindow.WXBEditor ;
                if(h5ue){
                    h5ue.ready(function() {
                        h5_setContent(getContent());
                        setContent("");
                    });
                    clearInterval(_interval)
                }else{
                    return ;
                }
            }
            catch(err)
            {
            }
        },50)
    }
    //获得h5编辑器内容
    function h5_getContent(){
        var content = document.getElementById("h5editor1_Frame").contentWindow.getUecontent();
        return content;
    }
    //h5编辑器写入内容
    function h5_setContent(insertContent,b){
        document.getElementById("h5editor1_Frame").contentWindow.setCurrentContent(insertContent,true);
    }
    //h5编辑器插入内容
    function h5_insertContent(insertContent,b){
        document.getElementById("h5editor1_Frame").contentWindow.setInsertContent(insertContent,true);
    }
    $(function() {
        //判断是否为ie8及以下浏览器
        var DEFAULT_VERSION = 8.0;
        var _ua = navigator.userAgent.toLowerCase();
        var _isIE = _ua.indexOf("msie")>-1;
        var browserVersion;
        if(_isIE){
            browserVersion =  _ua.match(/msie ([\d.]+)/)[1];
        }
        if(browserVersion <= DEFAULT_VERSION ){
            $('#editorTipsModal').show().css("opacity",1)
        };
        $(".editorTipsModal .btn-close,.editorTipsModal button.close").click(function(){
            $('#editorTipsModal').hide().css("opacity",0)
        })
    });
</script>
</body>
</html>













