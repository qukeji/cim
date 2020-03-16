
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    int		ChannelID				= getIntParameter(request,"id");

    Channel channel = CmsCache.getChannel(ChannelID);
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

//获取json接口地址
String TargetName = "";
ChannelTemplate ct = null;
ArrayList cts = channel.getChannelTemplates(2);
if(cts!=null && cts.size()>0){
	for(int i = 0;i<cts.size();i++){
		ct = (ChannelTemplate)cts.get(i);
		TargetName = ct.getTargetName();
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
    <title>404提示</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/common.css">
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
        .row{margin-left:0;margin-right: 0 }
        .picture-upload-wrap{position: relative}
        .picture-upload-wrap label{margin-bottom: 0}
        .picture-upload-wrap .picture-preview{width: 150px;min-height: 150px;line-height: 150px;overflow: hidden;}
        .picture-upload-wrap .picture-upload-input{display: none}
        .picture-upload-wrap .load-img{width: 150px;height: 100%;min-height: 150px;line-height: 150px;border: 1px dashed #e5e7e4;text-align: center;cursor: pointer;position: absolute;top: 0;}
        @media (max-width: 1200px) {
            .wd-content-lable.wd-sm-table{width: 300px;}
        }
        @media (max-width: 992px) {
            .collapsed-menu .br-mainpanel-file {margin-left: 0;}
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
	    function goJsonUrl(url){
	    	window.open(url);
    	}
	</script>
</head>
<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">
    document.body.disabled  = true;
    var channelid = <%=ChannelID%>;
    var inner_url = "<%=inner_url%>";
    var outer_url = "<%=outer_url%>";
    var SiteAddress = "<%=SiteAddress%>";
</script>
<form name="myform" action="" method="post" id="form1">
    <div class="br-mainpanel br-mainpanel-file overflow-hidden">
        <div class="br-pageheader pd-y-15 pd-md-l-20">
            <nav class="breadcrumb pd-0 mg-0 tx-12">
               	<span class="breadcrumb-item active"><%=parentChannelPath%></span>
            </nav>
        </div>
        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-20">
            <div class="br-content-box pd-20">
                <div class="row mg-0-force">
                    <div class="col-sm-8 pd-0-force mg-t-20">
                        <%


                            String sql="select * from "+channel.getTableName()+" order by CreateDate desc";
                            TableUtil tu = new TableUtil();
                            ResultSet rs = tu.executeQuery(sql);
                            String Photo="";
                            int GlobalID=0;
                            int ItemID=0;
                            String filename="";
                            while(rs.next()){
                                filename=convertNull(rs.getString("filename"));
                                Photo=convertNull(rs.getString("Photo"));
                                GlobalID=rs.getInt("GlobalID");
                                ItemID=rs.getInt("id");
                                
                            }
                            tu.closeRs(rs);
                        %>
                        
                         <div class="row flex-row align-items-center mg-b-15" id="tr_PublishDate">
                            <label class="left-fn-title wd-150 " id="desc_PublishDate">404页面图片：</label>
                            <label class="wd-content-lable wd-sm-table d-flex" >
                                <input type="text" name="Photo"  id="Photo" value="<%=Photo%>" class="textfield
                                upload field_image form-control" title="" size="80" >
                            </label>
                            <label><input type="button" value="选择" onclick="selectImage('Photo','Image')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                            <label><input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                         </div>
                    </div>
                    <div class="col-sm-4 pd-0-force">
                        <div class="tx-18 tx-gray-700">客户端展现示例:</div>
                        <div class="app-img-box">
                            <img src="../images/appconfig/404.png">
                        </div>
                    </div>
                </div>
            </div>
        </div>
		<div class="row flex-row align-items-center mg-b-15 justify-content-center mg-t-50" id="tr_Title">
             <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
             <input type="hidden" name="ItemID" value="<%=ItemID%>">
             <div class="row flex-row align-items-center mg-b-15 justify-content-center" id=>
	             <button name="startButton" type="button" onclick="subfrom()" class="btn btn-primary tx-size-xs pd-x-30 " id="startButton">应用</button>
	             <button style="float:left;margin-left:20px;" onclick="goJsonUrl('<%=SiteAddress+(TargetName.startsWith("/")?"/":channel.getFullPath()+"/")+TargetName%>')" name="startButton" type="button" class="btn btn-primary tx-size-xs pd-x-30 " id="jkyl">预览</button>
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
        'use strict';
        var url=$('#Photo').valueOf();
        $('#small-picture').val(url);

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
            url:"app_404_submit.jsp",
            type: 'post',

            data:  $('#form1').serialize(),
            success:function(data){

                window.location.reload();

            },
            error:function(){
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
</script>



</body>
</html>

