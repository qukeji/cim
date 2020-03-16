<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    int		ChannelID		= getIntParameter(request,"id");
    int		ItemID		= getIntParameter(request,"ItemID");
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
%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../favicon.ico"/>
    <title>Android在线打包</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/common.css">
    <link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
    <link href="../lib/2018/spectrum/spectrum.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/apppack.css">
    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
</head>
<script>
var ChannelID=<%=ChannelID%>;
</script>
<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file overflow-hidden">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">Android在线打包</span>
        </nav>
    </div>
    <!-- 步骤 -->
    <div class="d-flex align-items-center justify-content-between pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30 wd-80p margin-auto  step-info">
        <label class="step-num active"><label class="circle"><i class="icon ion-compose"></i></label><p class="title">基本信息</p></label><span class=""></span>
        <label class="step-num"><label class="circle"><i class="fa fa-camera"></i></label><p class="title">首页样式</p></label><span></span>
        <label class="step-num"><label class="circle"><i class="fa fa-image"></i></label><p class="title">图片信息</p></label><span></span>
        <label class="step-num"><label class="circle"><i class="fa fa-link"></i></label><p class="title">第三方信息</p></label><span></span>
        <label class="step-num"><label class="circle"><i class="fa fa-arrow-up"></i></label><p class="title">完成</p></label>
    </div>
    <!-- 基本信息 -->
     <%


        String sql="select * from "+channel.getTableName()+" where id="+ItemID+" order by CreateDate desc";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        String Photo="";
        int GlobalID=0;
        String packag="";
        String Title="";
        String HOME_URL="";
        String PHP_URL="";
        String version="";
        String SITE=""; 
        while(rs.next()){
            Title=convertNull(rs.getString("Title"));
            packag=convertNull(rs.getString("package"));
            HOME_URL=convertNull(rs.getString("HOME_URL"));
            PHP_URL=convertNull(rs.getString("PHP_URL"));
            SITE=convertNull(rs.getString("SITE"));
          
            GlobalID=rs.getInt("GlobalID");
            ItemID=rs.getInt("id");
            
        }
        tu.closeRs(rs);
    %>
    <form name="myform" action="" method="post" id="form1">
        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-20 step1 step" id="basicInformation">
            <div class="br-content-box pd-20">
                <div class="row flex-row align-items-center mg-b-15">
                    <label class="left-fn-title wd-150 tx-gray-800">标题：</label>
                    <label class="wd-content-lable d-flex wd-sm-table">
                        <input class="form-control" placeholder="单行输入" type="text" name="Title" size="80" value="<%=ItemID%>">
                    </label>
                    <label><span class="mg-l-10"></span></label>
                </div>
                <div class="row flex-row align-items-center mg-b-15">
                    <label class="left-fn-title  wd-150 tx-gray-800">打包版本：</label>
                       <select class="form-control wd-150 ht-40 " data-placeholder="" name="version">
    					   <option value="5" selected>3.2</option> 
    				       <option value="6">3.2.1</option>
    	                   <option value="7" >3.2.2</option>
                           <option value="8">3.2.3</option>
                           <option value="9">3.2.4</option>
                           <option value="10">3.3</option>
                           <option value="11">3.4.0</option>		
                           <option value="12">3.4.1</option>		
					   </select>   
                </div>
                <div class="row flex-row align-items-center mg-b-15">
                    <label class="left-fn-title wd-150 tx-gray-800">包名：</label>
                    <label class="wd-content-lable d-flex wd-sm-table">
                        <input class="form-control" placeholder="tidemedia.app.zsnq" type="text" id="package" name="package" size="80" value="<%=packag%>">
                    </label>
                    <label><span class="mg-l-10"></span></label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        说明：必填，包名请自行修改
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15">
                    <label class="left-fn-title wd-150 tx-gray-800">标准版站点地址：</label>
                    <label class="wd-content-lable d-flex wd-sm-table" id="">
                        <input class="form-control" placeholder="http://123.57.236.215:96/" type="text" name="HOME_URL" id="HOME_URL" size="80" value="<%=HOME_URL%>">
                    </label>
                    <label><span class="mg-l-10"></span></label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        必填，静态接口地址（结尾带/）
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15" id="">
                    <label class="left-fn-title wd-150 tx-gray-800">互动信息管理站点：</label>
                    <label class="wd-content-lable d-flex wd-sm-table" id="">
                        <input class="form-control" placeholder="http://123.57.236.215:96/" type="text" name="PHP_URL" id="PHP_URL" size="80" value="<%=PHP_URL%>">
                    </label>
                    <label><span class="mg-l-10"></span></label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        必填，动态接口地址（结尾带/）
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15">
                    <label class="left-fn-title wd-150 tx-gray-800">标准版站点编号：</label>
                    <label class="wd-content-lable d-flex wd-sm-table" id="">
                        <input class="form-control" placeholder="53" type="text" id="SITE" name="SITE" size="80" value="<%=SITE%>">
                    </label>
                    <label><span class="mg-l-10"></span></label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        必填，标准版站点编号
                    </label>
                </div>

            </div>
        </div>

        <!-- 首页样式 -->
        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-20 hide step2 step" id="indexStyle">
            <div class="br-content-box pd-20">
                <div class="row flex-row mg-b-15 header_style">
                    <label class="left-fn-title wd-150 tx-gray-800">头部样式：</label>
                    <label class="wd-content-ckx d-flex">
                        <label class="rdiobox pd-r-15 pd-t-15 border-label">
                            <input type="radio" value="0" id="packaged_version_0" name="home_style" checked>
                            <span for="packaged_version_0"><img class="pd-t-30" src="../images/apppack/header_style1.png"><p class="pd-b-0 pd-t-10 tx-center">左图标右搜索</p></span>
                        </label>
                        <label class="rdiobox pd-r-15 pd-t-15">
                            <input type="radio" value="1" id="packaged_version_1" name="home_style">
                            <span for="packaged_version_1"><img class="pd-t-30" src="../images/apppack/header_style2.png"><p class="pd-b-0 pd-t-10 tx-center">logo+搜索+个人中心</p></span>
                        </label>
                        <label class="rdiobox pd-r-15 pd-t-15">
                            <input type="radio" value="2" id="packaged_version_2" name="home_style">
                            <span for="packaged_version_2"><img class="pd-t-30" src="../images/apppack/header_style3.png"><p class="pd-b-0 pd-t-10 tx-center">个人中心+logo+搜索</p></span>
                        </label>
                    </label>
                </div>

                <div class="row flex-row mg-b-15 channel-name">
                    <label class="left-fn-title wd-150 tx-gray-800">一级栏目名称：</label>
                    <label class="wd-700 d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="栏目一名称" type="text" name="main_bottom1" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="栏目二名称" type="text" name="main_bottom2" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="栏目三名称" type="text" name="main_bottom3" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="栏目四名称" type="text" name="main_bottom4" size="80" value="">
                        </label>
                    </label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        至少填写1个，最多填写4个
                    </label>
                </div>

                <div class="row flex-row align-items-center mg-b-15">
                    <label class="left-fn-title wd-150 tx-gray-800">主题色：</label>
                    <label class="wd-content-lable d-flex wd-300 position-re">
                        <input class="form-control" placeholder="#0066cc" type="text" id="colorinput" name="THEME_COLOR" size="80" value="">
                        <input type="text" id="colorpicker" style="display: none;">
                    </label>
                    <label class="ckbox mg-r-15 ckbox_right"><input type="checkbox" value="0" name="THEME_COLOR" id="third_option_0"><span for="third_option_0">使用聚视默认颜色</span></label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        首页顶部栏，一级导航栏等颜色
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15">
                    <label class="left-fn-title wd-150 tx-gray-800">顶部主题色：</label>
                    <label class="wd-content-lable d-flex wd-300 position-re" id="">
                        <input class="form-control" placeholder="#0066cc" type="text" id="colorinputtop" name="THEME_TOP_COLOR" size="80" value="">
                        <input type="text" id="colorpickertop" style="display: none;">
                    </label>
                    <label class="ckbox mg-r-15 ckbox_right"><input type="checkbox" value="0" name="THEME_TOP_COLOR" id="third_option_0"><span for="third_option_0">使用聚视默认颜色</span></label>
                    <label class=" pd-l-5 pd-b-5 mg-l-40 border-label">
                        <p class="mg-b-0 pd-t-5 tx-left">示意图片：</p>
                        <img class="" src="../images/apppack/schematic_pic.png">
                    </label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        手机状态栏颜色
                    </label>
                </div>

            </div>
        </div>

        <!-- 图片信息 进行中progress  已完成actives -->
        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-20 hide step3 step" id="picInformation">
            <div class="br-content-box pd-20 ">
                <div class="row flex-row align-items-center justify-content-between mg-b-25 resolution-power">
                    <button class="btn tx-size-xs pd-x-40 pd-y-20 tx-18 position-re progress">分辨率480*800<img src="../images/apppack/mark.png"></button>
                    <button class="btn tx-size-xs pd-x-40 pd-y-20 tx-18 position-re ">分辨率720*1280<img src="../images/apppack/mark.png"></button>
                    <button class="btn tx-size-xs pd-x-40 pd-y-20 tx-18 position-re">分辨率1080*1920<img src="../images/apppack/mark.png"></button>
                </div>
                <div class="step-pic">
                    <div class="row flex-row align-items-center justify-content-start mg-b-25 startup">
                        <span>logo及启动图</span>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 wd-640-hide"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">logo图标：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="hdpi_logo" id="hdpi_logo" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('hdpi_logo','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('hdpi_logo')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row mg-t--10">
                        <label class="wd-100"></label>
                        <label class="wd-640-hide wd-150"></label>
                        <label class="d-flex align-items-center tx-gray-800 tx-12">
                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                            必填，手机桌面logo，建议尺寸：1024*1024，格式png，大小不超过500k
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 wd-640-hide"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">启动图：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="hdpi_launcher_pic" id="hdpi_launcher_pic" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('hdpi_launcher_pic','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('hdpi_launcher_pic')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row mg-t--10">
                        <label class="wd-100"></label>
                        <label class="wd-640-hide wd-150"></label>
                        <label class="d-flex align-items-center tx-gray-800 tx-12">
                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                            必填，App启动时展示的图片，建议尺寸：1242*2208，格式png，大小不超过50k
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 wd-640-hide"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">首页logo：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="hdpi_logo_home" id="hdpi_logo_home" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('hdpi_logo_home','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('hdpi_logo_home')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row mg-t--10">
                        <label class="wd-100"></label>
                        <label class="wd-640-hide wd-150"></label>
                        <label class="d-flex align-items-center tx-gray-800 tx-12">
                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                            必填，首页头部logo，建议尺寸：98*45，格式png，大小不超过50k
                        </label>
                    </div>
                    <div class="row flex-row align-items-center justify-content-start mg-b-25 startup">
                        <span>一级及我的栏目</span>建议尺寸：30*30，格式png
                    </div>
                    <div class="row flex-row align-items-center justify-content-start mg-l-100-force mg-b-25 channel-icon-nav">
                        <button class="btn btn-outline-info active tx-size-xs pd-x-20 pd-y-10 tx-14 mg-r-40 wd-180">使用聚视默认图标</button>
                        <button class="btn btn-outline-info tx-size-xs pd-x-20 pd-y-10 tx-14 wd-180">自定义</button>
                    </div>
                    <div class="channel-info mg-b-15">
                        <div class="channel-icon">
                            <label class="pd-r-20 pd-l-20 pd-b-15 mg-l-100 border-label">
                                <p class="mg-b-10 pd-t-15 tx-left">默认图标，栏目名称仅供参考：</p>
                                <img class="" src="../images/apppack/defaulticon.png">
                            </label>
                        </div>
                        <div class="channel-icon hide">
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目一：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="hdpi_column_default_1" id="hdpi_column_default_1" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('hdpi_column_default_1','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('hdpi_column_default_1')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="hdpi_column_on_1" id="Photo5" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('hdpi_column_on_1')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目二：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo6" id="Photo6" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo7" id="Photo7" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目三：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo8" id="Photo8" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo9" id="Photo9" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目四：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo10" id="Photo10" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo11" id="Photo11" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目五：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo12" id="Photo12" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo13" id="Photo13" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">我的栏目：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo14" id="Photo14" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo15" id="Photo15" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>

                        </div>

                    </div>
                    <div class="row flex-row align-items-center justify-content-start mg-b-25 startup">
                        <span>其他</span>
                    </div>

                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">顶部左上角图标：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="hdpi_ic_mine_home_black" id="hdpi_ic_mine_home_black" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('hdpi_ic_mine_home_black','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('hdpi_ic_mine_home_black')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">顶部右上角图标：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="hdpi_ic_search_home_black" id="hdpi_ic_search_home_black" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('hdpi_ic_search_home_black','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('hdpi_ic_search_home_black')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">列表页文章默认加载图：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="hdpi_default_pic" id="hdpi_default_pic" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('hdpi_default_pic','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('hdpi_default_pic')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                </div>
                  <!-- 图片信息 分辨率720*1280的图片-->
                <div class="step-pic hide">
                    <div class="row flex-row align-items-center justify-content-start mg-b-25 startup">
                        <span>logo及启动图</span>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">logo图标：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xhdpi_logo" id="xhdpi_logo" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xhdpi_logo','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xhdpi_logo')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row mg-t--10">
                        <label class="wd-100"></label>
                        <label class="wd-640-hide wd-150"></label>
                        <label class="d-flex align-items-center tx-gray-800 tx-12">
                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                            必填，手机桌面logo，建议尺寸：720*1280，格式png，大小不超过500k
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">启动图：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xhdpi_launcher_pic" id="xhdpi_launcher_pic" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xhdpi_launcher_pic','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xhdpi_launcher_pic')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row mg-t--10">
                        <label class="wd-100"></label>
                        <label class="wd-640-hide wd-150"></label>
                        <label class="d-flex align-items-center tx-gray-800 tx-12">
                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                            必填，App启动时展示的图片，建议尺寸：1242*2208，格式png，大小不超过50k
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">首页logo：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xhdpi_logo_home" id="xhdpi_logo_home" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xhdpi_logo_home','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xhdpi_logo_home')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row mg-t--10">
                        <label class="wd-100"></label>
                        <label class="wd-640-hide wd-150"></label>
                        <label class="d-flex align-items-center tx-gray-800 tx-12">
                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                            必填，首页头部logo，建议尺寸：98*45，格式png，大小不超过50k
                        </label>
                    </div>
                    <div class="row flex-row align-items-center justify-content-start mg-b-25 startup">
                        <span>一级及我的栏目</span>建议尺寸：30*30，格式png
                    </div>
                    <div class="row flex-row align-items-center justify-content-start mg-l-100-force mg-b-25 channel-icon-nav">
                        <button class="btn btn-outline-info active tx-size-xs pd-x-20 pd-y-10 tx-14 mg-r-40 wd-180">使用聚视默认图标</button>
                        <button class="btn btn-outline-info tx-size-xs pd-x-20 pd-y-10 tx-14 wd-180">自定义</button>
                    </div>
                    <div class="channel-info mg-b-15">
                        <div class="channel-icon">
                            <label class="pd-r-20 pd-l-20 pd-b-15 mg-l-100 border-label">
                                <p class="mg-b-10 pd-t-15 tx-left">默认图标，栏目名称仅供参考：</p>
                                <img class="" src="../images/apppack/defaulticon.png">
                            </label>
                        </div>
                        <div class="channel-icon hide">
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目一：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="hdpi_column_default_1" id="hdpi_column_default_1" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('hdpi_column_default_1','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('hdpi_column_default_1')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo5" id="Photo5" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目二：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo6" id="Photo6" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo7" id="Photo7" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目三：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo8" id="Photo8" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo9" id="Photo9" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目四：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo10" id="Photo10" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo11" id="Photo11" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目五：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo12" id="Photo12" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo13" id="Photo13" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">我的栏目：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo14" id="Photo14" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo15" id="Photo15" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>

                        </div>

                    </div>
                    <div class="row flex-row align-items-center justify-content-start mg-b-25 startup">
                        <span>其他</span>
                    </div>

                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">顶部左上角图标：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xhdpi_ic_mine_home_black" id="xhdpi_ic_mine_home_black" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xhdpi_ic_mine_home_black','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xhdpi_ic_mine_home_black')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">顶部右上角图标：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xhdpi_ic_search_home_black" id="xhdpi_ic_search_home_black" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xhdpi_ic_search_home_black','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xhdpi_ic_search_home_black')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">列表页文章默认加载图：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xhdpi_default_pic" id="xhdpi_default_pic" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xhdpi_default_pic','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xhdpi_default_pic')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                </div>
                 <!-- 图片信息 分辨率1080*1920的图片-->
                <div class="step-pic hide">
                    <div class="row flex-row align-items-center justify-content-start mg-b-25 startup">
                        <span>logo及启动图</span>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">logo图标：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xxhdpi_logo" id="xxhdpi_logo" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xxhdpi_logo','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xxhdpi_logo')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row mg-t--10">
                        <label class="wd-100"></label>
                        <label class="wd-640-hide wd-150"></label>
                        <label class="d-flex align-items-center tx-gray-800 tx-12">
                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                            必填，手机桌面logo，建议尺寸：1024*1024，格式png，大小不超过500k
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">启动图：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xxhdpi_launcher_pic" id="xxhdpi_launcher_pic" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xxhdpi_launcher_pic','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xxhdpi_launcher_pic')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row mg-t--10">
                        <label class="wd-100"></label>
                        <label class="wd-640-hide wd-150"></label>
                        <label class="d-flex align-items-center tx-gray-800 tx-12">
                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                            必填，App启动时展示的图片，建议尺寸：1242*2208，格式png，大小不超过50k
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">首页logo：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xxhdpi_logo_home" id="xxhdpi_logo_home" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xxhdpi_logo_home','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xxhdpi_logo_home')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row mg-t--10">
                        <label class="wd-100"></label>
                        <label class="wd-640-hide wd-150"></label>
                        <label class="d-flex align-items-center tx-gray-800 tx-12">
                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                            必填，首页头部logo，建议尺寸：98*45，格式png，大小不超过50k
                        </label>
                    </div>
                    <div class="row flex-row align-items-center justify-content-start mg-b-25 startup">
                        <span>一级及我的栏目</span>建议尺寸：30*30，格式png
                    </div>
                    <div class="row flex-row align-items-center justify-content-start mg-l-100-force mg-b-25 channel-icon-nav">
                        <button class="btn btn-outline-info active tx-size-xs pd-x-20 pd-y-10 tx-14 mg-r-40 wd-180">使用聚视默认图标</button>
                        <button class="btn btn-outline-info tx-size-xs pd-x-20 pd-y-10 tx-14 wd-180">自定义</button>
                    </div>
                    <div class="channel-info mg-b-15">
                        <div class="channel-icon">
                            <label class="pd-r-20 pd-l-20 pd-b-15 mg-l-100 border-label">
                                <p class="mg-b-10 pd-t-15 tx-left">默认图标，栏目名称仅供参考：</p>
                                <img class="" src="../images/apppack/defaulticon.png">
                            </label>
                        </div>
                        <div class="channel-icon hide">
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目一：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="xxhdpi_column" id="Photo4" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo5" id="Photo5" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目二：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo6" id="Photo6" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo7" id="Photo7" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目三：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo8" id="Photo8" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo9" id="Photo9" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目四：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo10" id="Photo10" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo11" id="Photo11" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">栏目五：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo12" id="Photo12" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo13" id="Photo13" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex pd-b-15">
                                <label class="wd-100 pd-t-10 font-weight-bold tx-black">我的栏目：</label>
                                <div class="row d-flex flex-column mg-b-0">
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">未选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo14" id="Photo14" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                    <div class="row flex-row align-items-center mg-b-0">
                                        <label class="left-fn-title wd-150 tx-gray-800">选中状态图标：</label>
                                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                                            <input type="text" name="Photo15" id="Photo15" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                                        </label>
                                        <label>
                                            <input type="button" value="选择" onclick="selectImage('Photo')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                                        </label>
                                        <label>
                                            <input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-default tx-size-xs mg-l-10">
                                        </label>
                                    </div>
                                </div>
                            </div>

                        </div>

                    </div>
                    <div class="row flex-row align-items-center justify-content-start mg-b-25 startup">
                        <span>其他</span>
                    </div>

                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">顶部左上角图标：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xxhdpi_ic_mine_home_black" id="xxhdpi_ic_mine_home_black" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xxhdpi_ic_mine_home_black','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xxhdpi_ic_mine_home_black')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">顶部右上角图标：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xxhdpi_ic_search_home_black" id="xxhdpi_ic_search_home_black" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xxhdpi_ic_search_home_black','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xxhdpi_ic_search_home_black')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                    <div class="row flex-row align-items-center mg-b-15">
                        <label class="wd-100 pd-t-10 font-weight-bold tx-black"></label>
                        <label class="left-fn-title wd-150 tx-gray-800">列表页文章默认加载图：</label>
                        <label class="wd-content-lable d-flex wd-label-input" id="field_Photo">
                            <input type="text" name="xxhdpi_default_pic" id="xxhdpi_default_pic" placeholder="单行输入" value="" class=" form-control" title="" size="80" data-original-title="">
                        </label>
                        <label>
                            <input type="button" value="选择" onclick="selectImage('xxhdpi_default_pic','Image')" class="btn btn-outline-info active tx-size-xs mg-l-10">
                        </label>
                        <label>
                            <input type="button" value="预览" onclick="previewFile('xxhdpi_default_pic')" class="btn btn-default tx-size-xs mg-l-10">
                        </label>
                    </div>
                </div>


            </div>
        </div>

        <!-- 第三方信息 -->
        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-20 hide step4 step" id="thirdParty">
            <div class="br-content-box pd-20">
                <div class="row flex-row align-items-center mg-b-15 channel-name">
                    <label class="left-fn-title tx-black wd-150">友盟</label>
                    <label class="wd-three d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="key" type="text" name="UMENG_APP" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="secret" type="text" name="UMENG_APP_KEY" size="80" value="" disabled>
                        </label>
                    </label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        不填写则无法正常使用分享功能
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15 channel-name">
                    <label class="left-fn-title tx-black wd-150">微信</label>
                    <label class="wd-label-input d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="key" type="text" name="WECHAT_APP" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="secret" type="text" name="WECHAT" size="80" value="">
                        </label>
                    </label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        不填写则无法正常使用分享功能
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15 channel-name">
                    <label class="left-fn-title tx-black wd-150">腾讯</label>
                    <label class="wd-label-input d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="key" type="text" name="QQ_APP" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="secret" type="text" name="QQ_APP_KEY" size="80" value="">
                        </label>
                    </label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        不填写则无法正常使用分享功能
                    </label>
                </div>
                <div class="row flex-row mg-b-15 channel-name">
                    <label class="left-fn-title tx-black wd-150">新浪</label>
                    <label class="wd-three d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="key" type="text" name="SINA_APP" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="secret" type="text" name="SINA_APP_KEY" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="回调URL" type="text" name="SINA_APP_URL" size="80" value="">
                        </label>
                    </label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        不填写则无法正常使用分享功能
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15 channel-name">
                    <label class="left-fn-title tx-black wd-150">Bugly</label>
                    <label class="wd-label-input d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="ID" type="text" name="BUGLY" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="密钥" type="text" name="BUGLY_KEY" size="80" value="">
                        </label>
                    </label>
                </div>

                <div class="row flex-row mg-b-15 channel-name">
                    <label class="left-fn-title tx-black wd-150">聚现</label>
                    <label class="wd-three d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="ACCESSTOKEN" type="text" name="JUXIAN_TOkEN" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="企业码" type="text" name="JUXIAN_COMPANYID" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="服务协议地址" type="text" name="JUXIAN_ADRESS" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="媒体号命名" type="text" name="JUXIAN_COMPANYNAME" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20 position-re jxcolorselect">
                            <input class="form-control" id="jxcolor" placeholder="创作端按钮主题色" type="text" name="JUXIAN_COLOR" size="80" value="">
                            <input type="text" id="jxcolorpicker" style="display: none;">

                        </label>
                    </label>
                </div>

                <div class="row flex-row align-items-center mg-b-15 channel-name">
                    <label class="left-fn-title tx-black wd-150">百度统计</label>
                    <label class="wd-label-input d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="key" type="text" name="baidu" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="secret" type="text" name="baidu_KEY" size="80" value="">
                        </label>
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15 channel-name">
                    <label class="left-fn-title tx-black wd-150">百度地图</label>
                    <label class="wd-label-input d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="key" type="text" name="baidu_map" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="secret" type="text" name="baidu_map_KEY" size="80" value="">
                        </label>
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15 channel-name">
                    <label class="left-fn-title tx-black wd-150">小米推送</label>
                    <label class="wd-label-input d-flex flex-row align-items-center flex-wrap">
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="key" type="text" name="MIPUSH_APP" size="80" value="">
                        </label>
                        <label class="wd-content-lable d-flex wd-sm-table mg-r-20">
                            <input class="form-control" placeholder="secret" type="text" name="MIPUSH_APP_KEY" size="80" value="">
                        </label>
                    </label>
                </div>
                <div class="row mg-t--10">
                    <label class="wd-640-hide wd-150"></label>
                    <label class="d-flex align-items-center tx-gray-800 tx-12">
                        <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                        不填写则无法正常使用分享功能
                    </label>
                </div>

            </div>
        </div>

        <!-- 信息填写完成 -->

        <div class="br-pagebody border-radius-5 mg-x-20 pd-t-50 mg-t-20 hide step5 step" id="informationComplete">
            <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
            <input type="hidden" name="ItemID" value="">
            <div class="row flex-row align-items-center mg-b-15 justify-content-between wd-50p margin-auto">
                <button name="startButton" type="button"  onclick="subfrom()" class="btn btn-outline-info active tx-size-xs pd-x-50 pd-y-50 tx-18 mg-r-40" id="packNow">直接打包</button>
                <button name="startButton" type="button" onclick="subfrom()" class="btn btn-outline-info bd tx-size-xs pd-x-50 pd-y-50 tx-18">返回列表页</button>
            </div>
        </div>


        <!-- 打包中 -->
        <div class="br-pagebody border-radius-5 mg-x-20 pd-t-50 mg-t-20 hide" id="pack_1">
            <div class="row flex-row align-items-center mg-b-15 justify-content-center margin-auto">
                <div class="pack-pic position-re mg-b-15 ">
                    <img src="../images/apppack/android_pack_pic1.png" class="wd-100p">
                    <div class="wd-100p pack-info">
                        <p class="tx-18 tx-black">打包中......</p>
                        <button type="button" class="btn btn-outline-info active tx-14 mg-t-50">返回列表</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 打包成功 -->
        <div class="br-pagebody border-radius-5 mg-x-20 pd-t-50 mg-t-20 hide" id="pack_2">
            <div class="row flex-row align-items-center mg-b-15 justify-content-center margin-auto">
                <div class="pack-pic position-re mg-b-15 ">
                    <img src="../images/apppack/android_pack_pic2.png" class="wd-100p">
                    <div class="wd-100p pack-infos d-flex flex-column mg-b-15">
                        <img class="wd-30p margin-auto" src="../images/apppack/erweima_pack.png">
                        <a href="" class="tx-12 tx-black mg-t-20">下载链接：www.baidu.com</a>
                        <p class="tx-18 text-info mg-t-30">打包成功</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 打包失败 -->
        <div class="br-pagebody border-radius-5 mg-x-20 pd-t-50 mg-t-20 hide" id="pack_3">
            <div class="row flex-row align-items-center mg-b-15 justify-content-center margin-auto">
                <div class="pack-pic position-re mg-b-15 ">
                    <img src="../images/apppack/android_pack_pic3.png" class="wd-100p">
                    <div class="wd-100p pack-info">
                        <p class="tx-18 tx-black">打包失败</p>
                        <button type="button" class="btn btn-outline-info active tx-14 mg-t-50">返回列表</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <div class="br-pagebody mg-r-20 mg-t-40 step-submit step-submit1">
        <div class="br-content-box pd-20">
            <div class="row flex-row align-items-center mg-b-15 justify-content-center">
                <button type="button" class="btn btn-primary tx-size-xs pd-x-30 nextButton" onclick="javascript:enterNextPage(0);">下一步</button>
            </div>
        </div>
    </div>
    <div class="br-pagebody mg-r-20 mg-t-40 step-submit step-submit2 hide">
        <div class="br-content-box pd-20">
            <div class="row flex-row align-items-center mg-b-15 justify-content-center">
                <button type="button" class="btn btn-default tx-size-xs pd-x-30 disabled prevButton"  onclick="javascript:enterPrevPage(1);">上一步</button>
                <button type="button" class="btn btn-default tx-size-xs pd-x-30 mg-x-30 disabled skipButton"  onclick="javascript:enterNextPage(1);">跳过</button>
                <button type="button" class="btn btn-primary tx-size-xs pd-x-30 nextButton" onclick="javascript:enterNextPage(1);">下一步</button>
            </div>
        </div>
    </div>
    <div class="br-pagebody mg-r-20 mg-t-40 step-submit step-submit3 hide">
        <div class="br-content-box pd-20">
            <div class="row flex-row align-items-center mg-b-15 justify-content-center">
                <button type="button" class="btn btn-default tx-size-xs pd-x-30 disabled prevButton" onclick="javascript:enterPrevPage(2);">上一步</button>
                <button type="button" class="btn btn-default tx-size-xs pd-x-30 mg-x-30 disabled skipButton"  onclick="javascript:enterNextPage(2);">跳过</button>
                <button type="button" class="btn btn-primary tx-size-xs pd-x-30 nextButton" onclick="javascript:enterNextPage(2);">下一步</button>

            </div>
        </div>
    </div>
    <div class="br-pagebody mg-r-20 mg-t-40 step-submit step-submit4 hide">
        <div class="br-content-box pd-20">
            <div class="row flex-row align-items-center mg-b-15 justify-content-center">
                <button type="button" class="btn btn-default tx-size-xs pd-x-30 disabled prevButton" onclick="javascript:enterPrevPage(3);">上一步</button>
                <button type="button" class="btn btn-default tx-size-xs pd-x-30 mg-x-30 disabled skipButton">跳过</button>
                <button type="button" class="btn btn-primary tx-size-xs pd-x-30 nextButton" onclick="javascript:enterNextPage(3);">下一步</button>
            </div>
        </div>
    </div>

</div>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script src="../lib/2018/spectrum/spectrum.js"></script>
<script src="../common/2018/bracket.js"></script>
<script src="../common/2018/apppack.js"></script>

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





    function subfrom() {
        $.ajax({
            url:"android_pack_submit.jsp",
            type: 'post',
            data:  $('#form1').serialize(),
            success:function(data){

              window.location.href=document.referrer;

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
        dialog.setUrl("../content/insertfile.jsp?ChannelID="+ChannelID+"&Type="+type+"&fieldname="+fieldname);
        dialog.setTitle("上传图片");
        dialog.show();
    }



</script>
</body>
</html>

