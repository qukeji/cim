
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
    <title>基本信息</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/common.css">
    <link rel="stylesheet"  type="text/css" href="../style/jquery.tagit.css" />
    <link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
    <link href="../lib/2018/spectrum/spectrum.css" rel="stylesheet">
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
    .sp-replacer{
        width:20px;
        height:20px;
        position: absolute;
        top:10px;
        right:15px;
        background: url(../images/apppack/color_icon.png) no-repeat 0 0;
        border:none;
    }
		.position-re {
			position: relative;
		}
		.sp-preview {
			width: 0;
		}
		ul,li{list-style: none;}
        .pics-ul{max-height: 400px;margin-bottom: 5px;max-width:320px}
        .slide-pics img{width: 100%;}
        .pics-ul li{display: none;}
        .pics-ul li{display: none;}
        .pic-btn{background-color: #ccc;border-color: #ccc;}
        .pics-ul li:first-of-type{display: block;}
        .pics-btn .btn{padding: 0.3rem 0.75rem;}
        .wd-content-ckx{width: 400px;}
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
        
        function goJsonUrl(url){
        	window.open(url);
        }
    </script>


</head>

<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="myform" action="" method="post" id="form1">


    <div class="br-mainpanel br-mainpanel-file overflow-hidden">
        <div class="br-pageheader pd-y-15 pd-md-l-20">
            <nav class="breadcrumb pd-0 mg-0 tx-12">
             	<span class="breadcrumb-item active"></span>
            </nav>
        </div>

        <div class="channel-name d-flex align-items-center mg-x-30	mg-t-30 tx-gray-700 mg-b-20">
            <i class="fa fa-cog tx-26 mg-r-5"></i>
            <h5 class="tx-20 mg-b-0">基本信息</h5>
        </div>
        <%
        String sql="select * from "+channel.getTableName()+" order by CreateDate desc";
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(sql);
            String Title="";
            int GlobalID=0;
            int siteflag=0;
            String Photo="";
            String tv_background_photo="";
            int allowcomment=0;
            int showtype=0;
            int showcomment=0;
            int showtime=0;
            int showread=0;
            int showcommunity=0;
            int customcategory=0;
            int juxiancreate=0;
            int background=0;
            int listType=0;
            int background_area=0;
            String background_color="";
            String background_photo="";
            String third_option="";
            String third_option1="";
            String third_option2="";
            String third_option3="";
            String function_switch="0";
            String function_switch1="0";
            String function_switch2="0";
            String bugly="";
            String tongji="";
            String baidu_tongji="";
			//添加全局禁言与禁止交互按钮
			String globalBanned = "";
			String BanInteract = "";
			//添加敏感词按钮
			String sensitive_word = "";
			//添加昵称审核与头像审核按钮
			String Audit_avator = "";
			String Audit_nickname = "";
			//增加内容页爆料和问政开关
			String baoliao = "";
			String wenzheng = "";
			//增加相关推荐和首页扫一扫
			String recommend = "";
			String scan = "";
			String audit_summary = "";
			String WordColor = "";
            int		ItemID= 0;
            while(rs.next()){
            	int i = 1;
            	System.out.println(i++);
                Title=convertNull(rs.getString("Title"));
                background_color=convertNull(rs.getString("background_color"));
                background_photo=convertNull(rs.getString("background_photo"));
                tv_background_photo=convertNull(rs.getString("tv_background_photo"));
                background=rs.getInt("background");
                GlobalID=rs.getInt("GlobalID");
                ItemID=rs.getInt("id");
                listType=rs.getInt("listType");
                siteflag=rs.getInt("siteflag");
                Photo=convertNull(rs.getString("Photo"));
                allowcomment=rs.getInt("allowcomment");
                showtype=(rs.getInt("showtype"));
                showcomment=(rs.getInt("showcomment"));
                showtime=(rs.getInt("showtime"));
                showread=(rs.getInt("showread"));
                background_area =(rs.getInt("background_area")) ;
                bugly=(rs.getString("bugly"));
                tongji=(rs.getString("tongji"));
                baidu_tongji=(rs.getString("baidu_tongji"));
                showcommunity=(rs.getInt("showcommunity"));
                customcategory=(rs.getInt("customcategory"));
                juxiancreate=(rs.getInt("juxiancreate"));
				//获得数据库中全局禁言与禁止交互的数据
				globalBanned = (rs.getString("globalBanned"));
				BanInteract = (rs.getString("BanInteract"));
				//获得数据库中敏感词数据
				sensitive_word = (rs.getString("sensitive_word"));
				Audit_avator = convertNull(rs.getString("Audit_avator"));
				Audit_nickname = convertNull(rs.getString("Audit_nickname"));
				baoliao = convertNull(rs.getString("baoliao"));
				wenzheng = convertNull(rs.getString("wenzheng"));
				recommend = convertNull(rs.getString("recommend"));
				scan = convertNull(rs.getString("scan"));
				audit_summary =  convertNull(rs.getString("audit_summary"));
                third_option=convertNull(rs.getString("third_option"));

                WordColor=convertNull(rs.getString("WordColor"));


                String[] strarray=third_option.split(",");
                if (strarray.length>=3){
                third_option1=strarray[0];
                third_option2=strarray[1];
                third_option3=strarray[2];
                }
                
                function_switch=convertNull(rs.getString("function_switch"));
                String[] strarray2=function_switch.split(",");
                if (strarray2.length>=2) {
                    function_switch1 = strarray2[0];
                    function_switch2 = strarray2[1];
                }
            }
            tu.closeRs(rs);

        %>

        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-10">
            <div class="br-content-box pd-20 d-flex">
                <div class="br-content-box-left">
					<div class="row flex-row align-items-center mg-b-15" id="tr_Title">
						<label class="left-fn-title  wd-250  " id="desc_Title">客户端名称：</label>
						<label class="wd-content-lable d-flex wd-sm-table" >
							<input class="form-control" placeholder="" type="text" id="Title" name="Title" size="80" value="<%=Title%>" onkeyup="checkTitle();">
						</label>
						<label><span class="mg-l-10"></span></label>
					</div>
					<%--<div class="row flex-row align-items-center mg-b-15" id="tr_PublishDate">
						<label class="left-fn-title wd-250 " id="desc_PublishDate">媒体号，个人主页及我的背景图：</label>
						<label class="wd-content-lable wd-sm-table d-flex" >
							<input type="text" name="Photo"  id="Photo" value="<%=Photo%>" class="textfield
							upload field_image form-control" title="" size="80" >
						</label>
						<label><input type="button" value="选择" onclick="selectImage('Photo','Image')" class="btn btn-primary tx-size-xs mg-l-10"></label>
						<label><input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-primary tx-size-xs mg-l-10"></label>
					</div>--%>
					
					<div class="row flex-row align-items-center mg-b-15" id="tr_PublishDate">
						<label class="left-fn-title wd-250 " id="desc_PublishDate">媒体号，个人主页及我的背景图：</label>
						<label class="wd-content-lable wd-sm-table d-flex" >
							<input type="text" name="Photo"  id="Photo" value="<%=Photo%>" class="textfield
							upload field_image form-control" title="" size="80" >
						</label>
						<label><input type="button" value="选择" onclick="selectImage('Photo','Image')" class="btn btn-primary tx-size-xs mg-l-10"></label>
						<label><input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-primary tx-size-xs mg-l-10"></label>
					</div>
					<div class="row flex-row align-items-center mg-b-15" id="">
						<label class="left-fn-title  wd-250" id="">客户端背景设置：</label>
						<label class="wd-content-ckx d-flex" id="start_label">

							<label class="rdiobox mg-r-15">
								<input type="radio" value="1" id="start_type_1" name="background" <% if(background==1){%> checked="checked"<%}%>>
								<span for="start_type_0">背景颜色</span>
							</label>
							<label class="rdiobox mg-r-20">
								<input type="radio" value="2" id="start_type_2" name="background"  <% if(background==2){%> checked="checked"<%}%>>
								<span for="start_type_2">背景图片</span>
                            </label>
							
						</label>
					</div>
					
					<div class="row flex-row align-items-center mg-b-15 start_type_item start_type_item_1 show" id="start_type_item_1">
						<label class="left-fn-title wd-250 " id="">背景颜色：</label>
						<label class="wd-content-lable wd-sm-table d-flex position-re "  >
							<input type="text" name="background_color"   id="colorinput" value="<%=background_color%>" class="textfield  form-control" title="" size="80" >
							<input type="text" id="colorpicker" style="display: none;">
						</label>
						
					</div>
					
					<div class="row flex-row align-items-center mg-b-15 start_type_item  start_type_item_2" id="start_type_item_2">
						<label class="left-fn-title wd-250 " id="decs_gif">背景图片：</label>
						<label class="wd-content-lable wd-sm-table d-flex" >
							<input type="text" name="background_photo"  id="background_photo" value="<%=background_photo%>" class="textfield upload field_image form-control" title="" size="80" >
						</label>
						<label><input type="button" value="选择" onClick="selectImage('background_photo','Image')" class="btn btn-primary tx-size-xs mg-l-10"></label>
						<label><input type="button" value="预览" onclick="previewFile('background_photo')" class="btn btn-primary tx-size-xs mg-l-10"></label>
					</div>
                    <div class="row flex-row align-items-center mg-b-15" id="start_type_item_6" style="display:none;">
                        <label class="left-fn-title  wd-250" id="">背景图片区域：</label>
                        <label class="wd-content-ckx d-flex" id="">
                            <label class="rdiobox mg-r-15">
                                <input type="radio" value="0" id="" name="background_area" <% if(background_area==0){%> checked="checked"<%}%>>
                                <span for="start_type_0">顶部到轮播图底</span>
                            </label>
                            <label class="rdiobox mg-r-20">
                                <input type="radio" value="1" id="" name="background_area"  <% if(background_area==1){%> checked="checked"<%}%>>
                                <span for="start_type_2">顶部到搜索框</span>
                            </label>
                        </label>
                    </div>
				  
					
					  <div class="row flex-row align-items-center mg-b-15" id="tr_tv_background_photo">
						<label class="left-fn-title wd-250 " id="desc_PublishDate">直播/广播背景图：</label>
					 
						<label class="wd-content-lable wd-sm-table d-flex" >
							<input type="text" name="tv_background_photo"  id="tv_background_photo" value="<%=tv_background_photo%>" class="textfield upload field_image form-control" title="" size="80" >
						</label>
						<label><input type="button" value="选择" onClick="selectImage('tv_background_photo','Image')" class="btn btn-primary tx-size-xs mg-l-10"></label>
						<label><input type="button" value="预览" onclick="previewFile('tv_background_photo')" class="btn btn-primary tx-size-xs mg-l-10"></label>
					</div>
					
					<div class="row flex-row align-items-center mg-b-15" id="">
						<label class="left-fn-title  wd-250" id="">列表展现形式：</label>
						<label class="wd-content-ckx d-flex" id="desc_listType">

							<label class="rdiobox mg-r-15">
								<input type="radio" value="0" id="" name="listType" <% if(listType==0){%> checked="checked"<%}%>>
								<span for="">左文右图</span>
							</label>
							<label class="rdiobox mg-r-20">
								<input type="radio" value="1" id="" name="listType"  <% if(listType==1){%> checked="checked"<%}%>>
								<span for="">左图右文</span>
                            </label>
						</label>
					</div>
                    <div class="row flex-row align-items-center mg-b-15 " id="">
                        <label class="left-fn-title wd-250 " id="">订阅栏目文字颜色设置：</label>
                        <label class="wd-content-lable wd-sm-table d-flex position-re "  >
                            <input type="text" name="WordColor"   id="WordColor" value="<%=WordColor%>" class="textfield  form-control" title="" size="80" >
                            <input type="text" id="colorpicker1" >
                        </label>

                    </div>
				</div>
				<div class="br-content-box-right mg-l-50">
					<div class="slide-pics" id ="start_type_item_8" style="display:none;">
						<ul class="pics-ul">
							<li><img src="../images/appconfig/appindex.png"></li>
							<li><img src="../images/appconfig/applive.png"></li>
							<li><img src="../images/appconfig/app_person_center.png"></li>
						</ul>
						<div class="pics-btn d-flex justify-content-center">
							<a href="javascript:;" class="btn btn-primary pic-btn active">1</a>
							<a href="javascript:;" class="btn btn-primary pic-btn  mg-x-15">2</a>
							<a href="javascript:;" class="btn btn-primary pic-btn  ">3</a>
						</div>
					</div>
                    <div class="slide-pics" id ="start_type_item_7" style="display:none;">
                        <ul class="pics-ul">
                            <li >
                                <img  src="../images/appconfig/background_area1.png">
                            </li>
                            <li >
                                <img  src="../images/appconfig/background_area2.png">
                            </li>
                        </ul>
                        <div class="pics-btn d-flex justify-content-center">
                            <a href="javascript:;" class="btn btn-primary pic-btn active ">1</a>
                            <a href="javascript:;" class="btn btn-primary pic-btn  mg-x-15 ">2</a>
                        </div>
                    </div>
				</div>
            </div>
        </div>
        <div class="channel-name d-flex align-items-center mg-x-30	mg-t-30	mg-y-20 tx-gray-700">
            <i class="fa fa-eye tx-26 mg-r-5"></i>
            <h5 class="tx-20 mg-b-0">功能开关</h5>
        </div>
        <div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-10">
            <div class="br-content-box pd-20">
                <div class="row mg-0-force">
                    <div class="col-sm-4 pd-0-force mg-t-20">


                        <div class="row flex-row align-items-center mg-b-15" id="tr_allowcomment">
                            <label class="left-fn-title wd-150" id='desc_allowcomment'>文章评论功能：</label>
                            <input type='hidden' name='allowcomment' id='allowcomment' value="<%=allowcomment%>" >
                            <div class='toggle-wrapper'>
                                <div class='toggle toggle-light success' <%if(allowcomment==0){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='allowcomment'></div>
                            </div>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_showtype">
                            <label class="left-fn-title wd-150" id='desc_showtype'>自定义内容标识：</label>
                            <input type='hidden' name='showtype' id='showtype' value="<%=showtype%>" >
                            <div class='toggle-wrapper'>
                                <div class='toggle toggle-light success' <%if(showtype==0){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='showtype'></div>
                            </div>
                           
                        </div>

                        <div class="row flex-row align-items-center mg-b-15" id="tr_showcomment">
                            <label class="left-fn-title  wd-150" id="desc_showcomment">文章评论数：</label>
                            <input type='hidden' name='showcomment' id='showcomment'  value="<%=showcomment%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(showcomment==0){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='showcomment'></div>
                            </div>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_juxiancreate">
                            <label class="left-fn-title  wd-150" id="desc_juxiancreate">聚现云服务：</label>
                            <input type='hidden' name='juxiancreate' id='juxiancreate'  value="<%=juxiancreate%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(juxiancreate==0){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='juxiancreate'></div>
                            </div>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_function_switch1">
                            <label class="left-fn-title  wd-150" id="desc_function_switch1">语音播报：</label>
                            <input type='hidden' name='function_switch1' id='function_switch1'  value="<%=function_switch1%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(function_switch1.equals("2")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='function_switch1'></div>
                            </div>
                            
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_showread">
                            <label class="left-fn-title  wd-150" id="desc_showread">阅读量：</label>
                            <input type='hidden' name='showread' id='showread' value="<%=showread%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(showread==0){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='showread'></div>
                            </div>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_showcommunity">
                            <label class="left-fn-title  wd-150" id="desc_showcommunity">社区相关信息：</label>
                            <input type='hidden' name='showcommunity' id='showcommunity' value="<%=showcommunity%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(showcommunity==0){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='showcommunity'></div>
                            </div>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_customcategory">
                            <label class="left-fn-title  wd-150" id="desc_customcategory">订阅栏目：</label>
                            <input type='hidden' name='customcategory' id='customcategory'  value="<%=customcategory%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(customcategory==0){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='customcategory'></div>
                            </div>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_function_switch2">
                            <label class="left-fn-title  wd-150" id="desc_function_switch2">爆料中视频提交按钮：</label>
                            <input type='hidden' name='function_switch2' id='function_switch2'  value="<%=function_switch2%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(function_switch2.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='function_switch2'></div>
                            </div>
                           
                        </div>
                        <!-- 新增 -->
                        <div class="row flex-row align-items-center mg-b-15" id="bugly">
                            <label class="left-fn-title  wd-150" id="desc_bugly">开启bugly：</label>
                            <input type='hidden' name='bugly' id='bugly1' value="<%=bugly%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(bugly.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='bugly1'></div>
                            </div>
                           
                        </div>
                        
                        <div class="row flex-row align-items-center mg-b-15" id="tongji">
                            <label class="left-fn-title  wd-150" id="desc_tongji">数据分析：</label>
                            <input type='hidden' name='tongji' id='tongji1' value="<%=tongji%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(tongji.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='tongji'></div>
                            </div>
                           
                        </div>
                        
                        <div class="row flex-row align-items-center mg-b-15" id="baidu_tongji">
                            <label class="left-fn-title  wd-150" id="desc_baidu_tongji">百度统计：</label>
                            <input type='hidden' name='baidu_tongji' id='baidu_tongji1' value="<%=baidu_tongji%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(baidu_tongji.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='baidu_tongji'></div>
                            </div>
                           
                        </div>
						
							<div class="row flex-row align-items-center mg-b-15" id="globalBanned">
								<label class="left-fn-title  wd-150" id="desc_globalBanned">全局禁言：</label>
								<input type='hidden' name='globalBanned' id='globalBanned1' value="<%=globalBanned%>" >

								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(globalBanned.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='globalBanned'></div>
								</div>
                           
							</div>
						
							<div class="row flex-row align-items-center mg-b-15" id="BanInteract">
								<label class="left-fn-title  wd-150" id="desc_BanInteract">禁止交互：</label>
								<input type='hidden' name='BanInteract' id='BanInteract1' value="<%=BanInteract%>" >

								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(BanInteract.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='BanInteract'></div>
								</div>
                           
							</div>
							<div class="row flex-row align-items-center mg-b-15" id="sensitive_word">
								<label class="left-fn-title  wd-150" id="desc_sensitive_word">敏感词：</label>
								<input type='hidden' name='sensitive_word' id='sensitive_word1' value="<%=sensitive_word%>" >

								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(sensitive_word.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='sensitive_word'></div>
								</div>
                           
							</div>
						
							<div class="row flex-row align-items-center mg-b-15" id="Audit_avator">
								<label class="left-fn-title  wd-150" id="desc_Audit_avator">头像审核：</label>
								<input type='hidden' name='Audit_avator' id='Audit_avator1' value="<%=Audit_avator%>" >

								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(Audit_avator.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='Audit_avator'></div>
								</div>
                           
							</div>
						
							<div class="row flex-row align-items-center mg-b-15" id="Audit_nickname">
								<label class="left-fn-title  wd-150" id="desc_Audit_nickname">呢称审核：</label>
								<input type='hidden' name='Audit_nickname' id='Audit_nickname1' value="<%=Audit_nickname%>" >

								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(Audit_nickname.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='Audit_nickname'></div>
								</div>
                           
							</div>
							
							<div class="row flex-row align-items-center mg-b-15" id="baoliao">
								<label class="left-fn-title  wd-150" id="desc_baoliao">内容页爆料入口：</label>
								<input type='hidden' name='baoliao' id='baoliao1' value="<%=baoliao%>" >

								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(baoliao.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='baoliao'></div>
								</div>
                           
							</div>
							
							<div class="row flex-row align-items-center mg-b-15" id="wenzheng">
								<label class="left-fn-title  wd-150" id="desc_wenzheng">内容页问政入口：</label>
								<input type='hidden' name='wenzheng' id='wenzheng1' value="<%=wenzheng%>" >
								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(wenzheng.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='wenzheng'></div>
								</div>
							</div>
							
							<div class="row flex-row align-items-center mg-b-15" id="recommend">
								<label class="left-fn-title  wd-150" id="desc_recommend">内容页相关推荐：</label>
								<input type='hidden' name='recommend' id='recommend1' value="<%=recommend%>" >
								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(recommend.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='recommend'></div>
								</div>
							</div>
							
							<div class="row flex-row align-items-center mg-b-15" id="scan">
								<label class="left-fn-title  wd-150" id="desc_scan">扫一扫：</label>
								<input type='hidden' name='scan' id='pageScan1' value="<%=scan%>" >
								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(scan.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='scan'></div>
								</div>
							</div>
							
							<div class="row flex-row align-items-center mg-b-15" id="audit_summary">
								<label class="left-fn-title  wd-150" id="desc_audit_summary">简介审核：</label>
								<input type='hidden' name='audit_summary' id='audit_summary1' value="<%=audit_summary%>" >
								<div class="toggle-wrapper">
									<div class='toggle toggle-light success' <%if(audit_summary.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='audit_summary'></div>
								</div>
							</div>
                        
                        <div class="row flex-row align-items-center mg-b-15" id="tr_third_option1" hidden="hidden">
                            <label class="left-fn-title  wd-150" id="desc_third_option1">微信：</label>
                            <input type='hidden' name='third_option1' id='third_option1'  value="<%=third_option1%>" >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(third_option1.equals("1")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='third_option1'></div>
                            </div>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_third_option2" hidden="hidden">
                            <label class="left-fn-title  wd-150" id="desc_third_option2">微博：</label>
                            <input type='hidden' name='third_option2' id='third_option2'  value="<%=third_option2%>"  >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(third_option2.equals("2")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='third_option2'></div>
                            </div>
                        </div>
                        <div class="row flex-row align-items-center mg-b-15" id="tr_third_option3" hidden="hidden">
                            <label class="left-fn-title  wd-150" id="desc_third_option3">腾讯qq：</label>
                            <input type='hidden' name='third_option3' id='third_option3' value="<%=third_option3%>"  >

                            <div class="toggle-wrapper">
                                <div class='toggle toggle-light success' <%if(third_option3.equals("3")){%>data-toggle-on='true'<%}else {%> data-toggle-on='false'<%}%> field='third_option3'></div>
                            </div>
                        </div>

                    </div>
                    <div class="col-sm-8 pd-0-force">
                        <div class="tx-18 tx-gray-700">客户端展现示例：</div>
                        <div class="app-img-box">
                            <img src="../images/appconfig/basicinfo.png">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="br-pagebody mg-r-20 mg-t-40" url="" id="">

            <div class="br-content-box pd-20">
                <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
                <input type="hidden" name="ItemID" value="<%=ItemID%>">
                <div class="row flex-row align-items-center mg-b-15 justify-content-center" id=>
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
<%--<script src="../common/document.js"></script>--%>
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
<script src="../lib/2018/spectrum/spectrum.js"></script>
<script src="../common/2018/bracket.js"></script>
<script src="../common/2018/apppack.js"></script>




<script>
    var background=<%=background%>;
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
    //主题色
    var themeColor=new showColor('<%=background_color%>',"colorpicker","colorinput");
    //订阅栏目文字颜色
        var themeColor=new showColor('<%=WordColor%>',"colorpicker1","WordColor");
    //手机状态栏颜色
    var stateColor=new showColor('<%=background_color%>',"colorpickertop","colorinputtop");
    //创作端按钮颜色
    var buttonColor=new showColor('<%=background_color%>',"jxcolorpicker","jxcolor");
    });
     $(function(){
       
        var val=$('input:radio[id="start_type_1"]:checked').val();
        if(val!=null){

            $(".start_type_item").removeClass("show");
            $(".start_type_item_1").addClass("show");
            $(".start_type_item_4").addClass("show");
            $(".start_type_item_5").addClass("show");
            $("#start_type_item_6").css("display","none");
            $("#start_type_item_7").css("display","none");
            $("#start_type_item_8").css("display","");
        }
        var val2=$('input:radio[id="start_type_2"]:checked').val();
        if(val2!=null){
            $(".start_type_item").removeClass("show");
            $(".start_type_item_2").addClass("show");
            $(".start_type_item_4").addClass("show");
            $(".start_type_item_5").addClass("show");
            $("#start_type_item_6").css("display","");
            $("#start_type_item_7").css("display","");
            $("#start_type_item_8").css("display","none");
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
                    $("#start_type_item_6").css("display","none");
                    $("#start_type_item_7").css("display","none");
                    $("#start_type_item_8").css("display","");
                    break;
                case 2:
                    $(".start_type_item").removeClass("show");
                    $(".start_type_item_2").addClass("show");
                    $(".start_type_item_4").addClass("show");
                    $(".start_type_item_5").addClass("show");
                    $("#start_type_item_6").css("display","");
                    $("#start_type_item_7").css("display","");
                    $("#start_type_item_8").css("display","none");
                    break;
                case 3:
                    $(".start_type_item").removeClass("show");
                     $(".start_type_item_2").removeClass("show");
                    $(".start_type_item_3").addClass("show");
                    $(".start_type_item_4").removeClass("show");
                    $(".start_type_item_5").addClass("show");
                default:
                    break;
            }
        })

        //切换
        $(' input[type="radio"][name=background_area]').click(function(){
            var value =parseInt($(' input[type="radio"][name=background_area]:checked').attr("value"))   ;

            $("#start_type_item_7").find(".pics-ul li").hide().eq(value).show();
            $("#start_type_item_7").find("a").removeClass("active").eq(value).addClass("active");
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
        $.ajax({
            url:"app_setting_submit.jsp",
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
        var	dialog =new TideDialog();
        dialog.setWidth(730);
        dialog.setHeight(550);
        dialog.setLayer(2);
        dialog.setUrl("../content/insertfile.jsp?ChannelID="+channelid+"&Type="+type+"&fieldname="+fieldname);
        dialog.setTitle("上传文件");
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
    		$("#"+id).val("0");//开
    		if(id=="third_option1"){
    	    	$("#third_option1").val("1");//开
    		}
			if(id=="function_switch2"){
		    	$("#function_switch2").val("1");//开
            }
			if(id=="bugly1"){
		    	$("#bugly1").val("1");//开
            }
			if(id=="tongji"){
		    	$("#tongji1").val("1");//开
            }
			if("baidu_tongji"==id){
		    	$("#baidu_tongji1").val("1");//开
            }
			if("globalBanned"==id){
		    	$("#globalBanned1").val("1");//开
            }
			if("BanInteract"==id){
		    	$("#BanInteract1").val("1");//开
            }
			if("sensitive_word"==id){
		    	$("#sensitive_word1").val("1");//开
            }
			if("Audit_avator"==id){
		    	$("#Audit_avator1").val("1");//开
            }
			if("Audit_nickname"==id){
		    	$("#Audit_nickname1").val("1");//开
            }
			if("baoliao"==id){
		    	$("#baoliao1").val("1");//开
            }
			if("wenzheng"==id){
		    	$("#wenzheng1").val("1");//开
            }
			if("recommend"==id){
		    	$("#recommend1").val("1");//开
            }
			if("scan"==id){
		    	$("#pageScan1").val("1");//开
            }
			if("audit_summary"==id){
		    	$("#audit_summary1").val("1");//开
            }
            if(id=="function_switch1"){
		    	$("#function_switch1").val("1");//开
            }
    	}else{
    		$("#"+id).val("1");//关
    		if("bugly1"==id){
		    	$("#bugly1").val("0");//关
            }
    		if("tongji"==id){
		    	$("#tongji1").val("0");//关
            }
    		if("baidu_tongji"==id){
		    	$("#baidu_tongji1").val("0");//关
            }
			if("BanInteract"==id){
		    	$("#BanInteract1").val("0");//关
            }
			if("globalBanned"==id){
		    	$("#globalBanned1").val("0");//关
            }
			if("sensitive_word"==id){
		    	$("#sensitive_word1").val("0");//关
            }
			if("Audit_avator"==id){
		    	$("#Audit_avator1").val("0");//关
            }
			if("Audit_nickname"==id){
		    	$("#Audit_nickname1").val("0");//关
            }
			if("baoliao"==id){
		    	$("#baoliao1").val("0");//关
            }
			if("wenzheng"==id){
		    	$("#wenzheng1").val("0");//关
            }
			if("recommend"==id){
		    	$("#recommend1").val("0");//关
            }
			if("scan"==id){
		    	$("#pageScan1").val("0");//关
            }
			if("audit_summary"==id){
		    	$("#audit_summary1").val("0");//关
            }
    	    if(id=="third_option1"){
    	    	$("#third_option1").val("0");//guan 
    		}
		    if(id=="function_switch2"){
		    	$("#function_switch2").val("0");//关
            }
        	if(id=="function_switch1"){
	    	    $("#function_switch1").val("0");//关
	    	}
    	}

	})
	
	$(".br-content-box-right .pics-btn a.btn").click(function(){
		var _index = $(this).index();
        $(this).parent().parent().find(".pics-btn a").removeClass("active")
		$(this).addClass("active");
		$(this).parent().parent().find(".pics-ul li").hide().eq(_index).show();
		//$(".pics-ul li").hide().eq(_index).show();
	})


</script>



</body>
</html>

