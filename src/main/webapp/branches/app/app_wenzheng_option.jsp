
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
    Channel channel = CmsCache.getChannel("s53_config");
    int		ChannelID				= channel.getId();


    ArrayList fieldGroupArray = channel.getFieldGroupInfo();
    String SiteAddress = channel.getSite().getUrl();
    TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
    String inner_url = "";String outer_url="";
    if(photo_config != null)
    {
        int sys_channelid_image = photo_config.getInt("channelid");
        Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
        inner_url = img_site.getUrl();
        outer_url = img_site.getExternalUrl();
    }
//获取频道路径
    String parentChannelPath = channel.getParentChannelPath().replaceAll(">"," / ");
%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../favicon.ico"/>
    <title>基本信息</title>
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
    <script>
        var channelid = <%=ChannelID%>;
        var inner_url = "<%=inner_url%>";
        var outer_url = "<%=outer_url%>";
        var SiteAddress = "<%=SiteAddress%>";
    </script>


</head>

<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="myform" action="" method="post" id="form1">


    <div class="br-mainpanel br-mainpanel-file overflow-hidden">


        <div class="channel-name d-flex align-items-center mg-x-30	mg-t-30 tx-gray-700 mg-b-20">
            <i class="fa fa-cog tx-26 mg-r-5"></i>
            <h5 class="tx-20 mg-b-0">问政配置</h5>
        </div>
        <%
            String sql="select * from "+channel.getTableName()+" order by CreateDate desc";
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(sql);
            String Title="";
            int GlobalID=0;
            int  mandatoryLogin=0;
            int selectionDepartment=0;
            int		ItemID= 0;
            while(rs.next()){
               
                GlobalID=rs.getInt("GlobalID");
                ItemID=rs.getInt("id");
                mandatoryLogin=rs.getInt("mandatoryLogin");
                selectionDepartment=rs.getInt("selectionDepartment");
                
            }
            tu.closeRs(rs);

        %>



        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-10">
            <div class="br-content-box pd-20">
                <div class="row mg-0-force">
                    <div class="col-sm-4 pd-0-force mg-t-20">

                        <div class="row flex-row align-items-center mg-b-15" id="tr_mandatoryLogin">
                            <label class="left-fn-title  wd-200" id="desc_mandatoryLogin">仅允许登陆后提问：</label>
                            <input type='hidden' name='mandatoryLogin' id='mandatoryLogin'  value="<%=mandatoryLogin%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(mandatoryLogin==1){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='mandatoryLogin'></div>
                            </div>
                           
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_selectionDepartment">
                            <label class="left-fn-title  wd-200" id="desc_selectionDepartment">用户提问是允许选择部门：</label>
                            <input type='hidden' name='selectionDepartment' id='selectionDepartment'  value="<%=selectionDepartment%>"  >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(selectionDepartment==1){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='selectionDepartment'></div>
                            </div>
                            
                        </div>

                        <div class="br-content-box pd-20">
                            <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
                            <input type="hidden" name="ItemID" value="<%=ItemID%>">
                            
                            <div class="row flex-row align-items-center mg-b-15 justify-content-center" id=>
                                <button name="startButton" type="button" onclick="subfrom()" class="btn btn-primary tx-size-xs pd-x-30 " id="startButton">应用</button>
                            </div>
                        </div>

                    </div>
                    </div>
                </div>
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
    function init()
    {
    }
    function initContent()
    {
    }


    $(function(){
        $("input").each(function(){
            var value = $(this).val(); //这里的value就是每一个input的value值~
        });
    });
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

        $(".date").datetimepicker({
            timeText: '时间',
            hourText: '小时',
            minuteText: '分钟',
            secondText: '秒',
            currentText: '现在',
            closeText: '完成',
            showSecond: true, //显示秒
            dateFormat:"yy-mm-dd",
            timeFormat: 'HH:mm:ss',//格式化时间
            monthNames: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
            dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
            dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
            dayNamesMin: ['日','一','二','三','四','五','六']
        });

    });



    function previewFile(fieldname)
    {
        var name = document.getElementById(fieldname).value;
        //图片库采用本地预览
        var reg = new RegExp(outer_url,"g");
        if(name=="") return;

        if(name.indexOf("http://")!=-1 || name.indexOf("https://")!=-1)  window.open(name.replace(reg,inner_url));
        else	window.open("<%=SiteAddress%>/" + name);
    }

    function subfrom() {
        $.ajax({
            url:"app_wenzheng_option_submit.jsp",
            type: 'post',
            data:  $('#form1').serialize(),
            success:function(data){

                window.location.reload();

            },
            error:function(){
                window.location.reload();
                alert('失败');

            },
            async:true,
        });
    }
    //上传图片
    function selectImage(fieldname,type)
    {
        var	dialog = new TideDialog();
        dialog.setWidth(730);
        dialog.setHeight(550);
        dialog.setLayer(2);
        dialog.setUrl("../content/insertfile.jsp?ChannelID="+channelid+"&Type="+type+"&fieldname="+fieldname);
        dialog.setTitle("上传图片");
        dialog.show();
    }


    //开关相关
    //初始化
    $('.toggle').toggles({
        height: 25
    });
    //获取是否开或关
    $(".toggle").click(function(){
        var myToggle = $(this).data('toggle-active');
        var id = $(this).attr('field');

        if(myToggle){

            $("#"+id).val("1");//开
            
        }else{
            $("#"+id).val("0");//关
           

        }

    })

</script>



</body>
</html>

