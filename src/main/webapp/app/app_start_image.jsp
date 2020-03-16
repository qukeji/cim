
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
    int		ItemID					= 0;
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
ArrayList cts = channel.getChannelTemplates(3);
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
    <title>启动页面</title>
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
        .wd-content-ckx label{margin-bottom: 0}
        .start_type_item{display:none;}
        .start_type_item.show{display:flex;}
        #start_label .rdiobox{cursor:pointer;}
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
</head>
<body class="collapsed-menu email" id="withSecondNav">
<script>
    var channelid = <%=ChannelID%>;
    var inner_url = "<%=inner_url%>";
    var outer_url = "<%=outer_url%>";
    var SiteAddress = "<%=SiteAddress%>";
    
    function goJsonUrl(url){
    	window.open(url);
    }
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
                    <%
                        String sql="select * from "+channel.getTableName()+" where Active = 1 order by CreateDate desc";
                        System.out.println("sql=="+sql);
                        TableUtil tu = new TableUtil();
                        ResultSet rs = tu.executeQuery(sql);
                        String Title="";
                        int GlobalID=0;
                        String Photo="";
                        String gif="";
                        String video="";
                        String href="";
                        int type=0;
                        int  residencetime=0;
                        String countdown="";
                        String countdown1="";
                        String countdown2="";
                        String captionimage="";
                        String captionvideo="";
                        String captiongif="";
                        String captionesidencetime="";
                        String	skip="";
                        int status=0;
                        String preloadPhoto="";
                        while(rs.next()){
                            ItemID=(rs.getInt("id"));
                            type=(rs.getInt("type"));
                            status=(rs.getInt("Status"));
                            Title=convertNull(rs.getString("Title"));
                            GlobalID=rs.getInt("GlobalID");
                            Photo=convertNull((rs.getString("Photo")));
                            gif=convertNull(rs.getString("gif"));
                            video=convertNull(rs.getString("video"));
                            href=convertNull(rs.getString("href"));
                            residencetime=rs.getInt("residencetime");
                            countdown=convertNull(rs.getString("countdown"));
                        	skip=convertNull(rs.getString("skip"));
                            Field field1 = new Field("Photo",ChannelID);
                            captionimage=field1.getCaption();
                            Field field2 = new Field("gif",ChannelID);
                            captiongif=field2.getCaption();
                            Field field3 = new Field("video",ChannelID);
                            preloadPhoto=convertNull((rs.getString("preloadPhoto")));
                            captionvideo=field3.getCaption();
                             Field field4 = new Field("residencetime",ChannelID);
                            captionesidencetime=field4.getCaption();
                            String[] strarray=countdown.split(",");
                            if (strarray.length>=2) {
                                countdown1=strarray[0];
                                countdown2=strarray[1];
                            }
                            if (strarray.length>=1&&strarray.length<2) {
                               String countdown3=strarray[0];
                               if (countdown3.equals("0")){
                                   countdown1=countdown3;
                               }else if (countdown3.equals("1")){
                                   countdown2=countdown3;
                               }
                                
                            }

                        }
                        tu.closeRs(rs);
                    %>
                    <div class="col-sm-8 pd-0-force mg-t-20">
                        <div class="row flex-row align-items-center mg-b-15" id="">
                            <label class="left-fn-title  wd-150" id="">启动页面样式：</label>
                            <label class="wd-content-ckx d-flex" id="start_label">

                                <label class="rdiobox mg-r-15">
                                    <input type="radio" value="1" id="start_type_1" name="start_type" <% if(type==1){%> checked="checked"<%}%>>
                                    <span for="start_type_0">图片</span>
                                </label>
                                <label class="rdiobox mg-r-20">
                                    <input type="radio" value="2" id="start_type_2" name="start_type"  <% if(type==2){%> checked="checked"<%}%>>
                                    <span for="start_type_2">动画</span>
                                </label>
                                <label class="rdiobox mg-r-20">
                                    <input type="radio" value="3" id="start_type_3" name="start_type" <% if(type==3){%> checked="checked"<%}%>>
                                    <span for="start_type_1">视频</span>
                                </label>

                            </label>
                        </div>

                            <div class="row flex-row align-items-center mg-b-15 start_type_item start_type_item_1 show" id="start_type_item_1">
                                <label class="left-fn-title wd-150 " id="">图片：</label>
                                <label class="wd-content-lable wd-sm-table d-flex" >
                                    <input type="text" name="Photo"  id="Photo" value="<%=Photo%>" class="textfield upload field_image form-control" title="" size="80" >
                                </label>
                                <label><input type="button" value="选择" onclick="selectImage('Photo','Image')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                                <label><input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                            </div>
                            <div class="row mg-t--10 start_type_item start_type_item_1">
                                 <label class="left-fn-title wd-150"></label>
                                <label class="d-flex align-items-center tx-gray-800 tx-12">
                                    <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                                    说明：<%=captionimage%>
                                </label>
                            </div>
                        
                            <div class="row flex-row align-items-center mg-b-15 start_type_item  start_type_item_2" id="start_type_item_2">
                                <label class="left-fn-title wd-150 " id="decs_gif">动画：</label>
                                <label class="wd-content-lable wd-sm-table d-flex" >
                                    <input type="text" name="gif"  id="gif" value="<%=gif%>" class="textfield upload field_image form-control" title="" size="80" >
                                </label>
                                <label><input type="button" value="选择" onClick="selectImage('gif','gif')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                                <label><input type="button" value="预览" onclick="previewFile('gif')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                            </div>
                            <div class="row mg-t--10 start_type_item start_type_item_2">
                                <label class="left-fn-title wd-150"></label>
                                <label class="d-flex align-items-center tx-gray-800 tx-12">
                                    <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                                    说明：<%=captiongif%>
                                </label>
                            </div>
                       
                        <div class="row flex-row align-items-center mg-b-15 start_type_item start_type_item_3" id="start_type_item_3">
                            <label class="left-fn-title wd-150 " id="">视频：</label>
                            <label class="wd-content-lable wd-sm-table d-flex" >
                                <input type="text" name="video"  id="video" value="<%=video%>" class="textfield upload field_image form-control" title="" size="80" >
                            </label>
                            <label><input type="button" value="选择" onClick="selectImage('video','video')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                            <label><input type="button" value="预览" onclick="previewFile('video')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                        </div>
                        <div class="row mg-t--10 start_type_item start_type_item_3">
                            <label class="left-fn-title wd-150"></label>
                            <label class="d-flex align-items-center tx-gray-800 tx-12">
                                <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                                说明：<%=captionvideo%>
                            </label>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15 start_type_item start_type_item_3" id="start_type_item_3">
                            <label class="left-fn-title wd-150 " id="">预加载图片：</label>
                            <label class="wd-content-lable wd-sm-table d-flex" >
                                <input type="text" name="preloadPhoto"  id="preloadPhoto" value="<%=preloadPhoto%>" class="textfield upload field_image form-control" title="" size="80" >
                            </label>
                            <label><input type="button" value="选择" onClick="selectImage('preloadPhoto','Image')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                            <label><input type="button" value="预览" onclick="previewFile('preloadPhoto')" class="btn btn-primary tx-size-xs mg-l-10"></label>
                        </div>
                        <div class="row mg-t--10 start_type_item start_type_item_3">
                            <label class="left-fn-title wd-150"></label>
                            <label class="d-flex align-items-center tx-gray-800 tx-12">
                                <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                                说明：<%=captionvideo%>
                            </label>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_href">
                            <label class="left-fn-title wd-150 " id=desc_href"">链接地址：</label>
                            <label class="wd-content-lable d-flex wd-sm-table" id="">
                                <input class="form-control" placeholder="" type="text" id="href" name="href" size="80" value="<%=href%>">
                            </label>
                            <label><span id="" class="mg-l-10"></span></label>
                        </div>

                        <div class="row flex-row align-items-center mg-b-15 start_type_item  start_type_item_4" id="tr_countdown1" >
                            <label class="left-fn-title  wd-150" id="desc_countdown1">倒计时：</label>
                            <input  type='hidden' name='countdown1' id='countdown1' value="<%=countdown%>" >

                            <div class="toggle-wrapper">
                                <div id="toggle_countdown1" class='toggle toggle-light success'
                                     <%if(countdown.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='countdown1'> </div>
                            </div>
                         
                        </div>
                        <div class="row flex-row align-items-center mg-b-15 start_type_item start_type_item_5" id="tr_skip">
                            <label class="left-fn-title  wd-150" id="desc_skip">跳过：</label>
                            <input type='hidden' name='skip' id='skip'  value="<%=skip%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(skip.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='skip'></div>
                            </div>
                           
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_residencetime">
                            <label class="left-fn-title wd-150 " id="desc_residencetime">启动图停留时长：</label>
                            <label class="wd-content-lable d-flex wd-sm-table" id="">
                                <input class="form-control" placeholder="" type="text" id="residencetime" name="residencetime" size="80" value="<%=residencetime%>">
                            </label>
                            <label><span id="" class="mg-l-10"></span></label>
                        </div>
                        <div class="row mg-t--10">
                            <label class="left-fn-title wd-150"></label>
                            <label class="d-flex align-items-center tx-gray-800 tx-12">
                                <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                                说明：<%=captionesidencetime%>
                            </label>
                        </div>
                    </div>

                    <div class="col-sm-4 pd-0-force">
                        <div class="tx-18 tx-gray-700">客户端展现示例:</div>
                        <div class="app-img-box">
                            <img src="../images/appconfig/appstart.png">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="br-pagebody mg-r-20 mg-t-40" url="" id="">
            <div class="br-content-box pd-20">
                <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
                <input type="hidden" name="ItemID" value="<%=ItemID%>">
                <input type="hidden" name="GlobalID" value="<%=GlobalID%>">
                <div class="row flex-row align-items-center mg-b-15 justify-content-center" id="tr_Title">
                    <button name="startButton" type="button" onclick="subfrom()" class="btn btn-primary tx-size-xs pd-x-30 " id="startButton">应用</button>
                	<button style="float:left;margin-left:20px;" onclick="goJsonUrl('<%=SiteAddress+(TargetName.startsWith("/")?"/":channel.getFullPath()+"/")+TargetName%>')" name="startButton" type="button" class="btn btn-primary tx-size-xs pd-x-30 " id="jkyl">预览</button>
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
        if ($('#toggle_countdown1 div div div ').attr("class")=="toggle-on active") {
            $('#countdown1 ').attr("value","1")
            $('#countdown1 ').attr("value","1")
        }else {
            $('#countdown1 ').attr("value","0")
            $('#countdown1 ').attr("value","0")
        }
        var val=$('input:radio[id="start_type_1"]:checked').val();
        if(val!=null){

            $(".start_type_item").removeClass("show");
            $(".start_type_item_1").addClass("show");
            $(".start_type_item_4").addClass("show");
            $(".start_type_item_5").addClass("show");

        }
        var val2=$('input:radio[id="start_type_2"]:checked').val();
        if(val2!=null){

            $(".start_type_item").removeClass("show");
            $(".start_type_item_2").addClass("show");
            $(".start_type_item_4").addClass("show");
            $(".start_type_item_5").addClass("show");
            
        }
        var val3=$('input:radio[id="start_type_3"]:checked').val();
        if(val3!=null){
            style="display: none;"
            $(".start_type_item").removeClass("show");
            $(".start_type_item_4").removeClass("show");
            $(".start_type_item_3").addClass("show");
            $(".start_type_item_5").addClass("show");
             
        }

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

        //切换
        $('#start_label input[type="radio"]').click(function(){
            var value =parseInt( $(this).attr("value") ) ;
            console.log(value)
            switch (value){
                case 1:
                    $(".start_type_item").removeClass("show");
                    $(".start_type_item_1").addClass("show");
                     $(".start_type_item_4").addClass("show");
                    $(".start_type_item_5").addClass("show");
                    break;
                case 2:
                    $(".start_type_item").removeClass("show");
                    $(".start_type_item_2").addClass("show");
                     $(".start_type_item_4").addClass("show");
                       $(".start_type_item_5").addClass("show");
                    break;
                case 3:
                    $(".start_type_item").removeClass("show");
                    $(".start_type_item_3").addClass("show");
                    $(".start_type_item_4").removeClass("show");
                    $(".start_type_item_5").addClass("show");

                   
                default:
                    break;
            }
        })

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
        var info = $('#form1').serialize();
        $.ajax({
            url:"app_start_image_submit.jsp",
            type: 'post',
            data:  info,
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
        dialog.setTitle("上传文件");
        dialog.show();
    }
</script>



</body>
</html>

