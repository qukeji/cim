<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.report.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

    int		type	= getIntParameter(request,"type");
    long begin_time = System.currentTimeMillis();
    int id = Util.getIntParameter(request,"id");

    int currPage = Util.getIntParameter(request,"currPage");
    int rowsPerPage = Util.getIntParameter(request,"rowsPerPage");
    int TotalPageNumber=0;
    String sortable = Util.getParameter(request,"sortable");
    if(currPage<1)
        currPage = 1;

    if(rowsPerPage==0)
        rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

    if(rowsPerPage<=0)
        rowsPerPage = 15;

    Channel channel = CmsCache.getChannel(id);

    String Extra1=channel.getExtra1();
    int vmsId=0;
    if(Extra1.length()>0&&Extra1!=null) {
        System.out.println("Extra1：" + Extra1);
        JSONObject jsonObject = new JSONObject(Extra1);
        vmsId = (int) jsonObject.get("vms");
    }
    System.out.println("编辑视频id"+vmsId);
    Channel parentchannel = null;
    int ChannelID = channel.getId();
    int IsWeight=channel.getIsWeight();
    int	IsComment=channel.getIsComment();
    int	IsClick=channel.getIsClick();

    boolean listAll = false;

    if(channel.isTableChannel() && channel.getType2()==8) listAll = true;

    String S_Title			=	getParameter(request,"Title");
    String S_startDate		=	getParameter(request,"startDate");
    String S_endDate		=	getParameter(request,"endDate");
    String S_User			=	getParameter(request,"User");
    int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
    int S_Status			=	getIntParameter(request,"Status");
    int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
    int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
    int IsDelete			=	getIntParameter(request,"IsDelete");

    String querystring = "";
    querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&type="+type;

    String uri=request.getRequestURI();
    String path=request.getContextPath();
    int Status1			=	getIntParameter(request,"Status1");
    int listType=10;
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
    Product product = new Product("TideVMS");
    String vms2018=product.getUrl();

	int video_type = CmsCache.getParameter("sys_editor_video_type").getIntValue();

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS 7 列表</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">

    <style>
        .collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
        .search-box {display: none;}
        .border-radius-5{border-radius: 5px;}
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>

    <script>
        var ChannelID = <%=ChannelID%>;
        var currRowsPerPage = <%=rowsPerPage%>;
        var currPage = <%=currPage%>;
        var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
        var listType = <%=listType%>;
        function openSearch()
        {
            jQuery("#SearchArea").toggle();
        }

        function datepicker(id){
            jQuery('#'+id).datepicker({
                monthNames: ['一月','二月','三月','四月','五月','六月', '七月','八月','九月', '十月','十一月','十二月'],
                dateFormat:'yy-mm-dd',currentText:'今天',closeText: '关闭',
                clearText: '清除',
                dayNamesMin:['日','一','二','三','四','五','六']});
        }


        function select_change()
        {
            var value=jQuery("#ChannelID").val();
            document.location.href = "<%=uri%>?id="+value;
        }

        function change(s,id)
        {
            var value=jQuery(s).val();
            var exp  = new Date();
            exp.setTime(exp.getTime() + 300*24*60*60*1000);
            document.cookie = "rowsPerPage="+value;
            document.location.href = "<%=uri%>?id="+id+"&rowsPerPage="+value;
        }
    </script>
</head>
<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">

    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">当前位置：<%=channel.getName()%></span>
        </nav>
        <div class="mg-l-auto">
            <a href="javascript:jumpVms('<%=vmsId%>')" class="btn btn-info mg-r-10 pd-x-10-force pd-y-5-force "><span>上传
            </span></a>
            <a href="javascript:;" class="btn btn-info mg-r-10 pd-x-10-force pd-y-5-force btn-search"><i class="fa fa-search mg-r-3"></i><span>检索</span></a>
        </div><!-- btn-group -->
    </div><!-- br-pageheader -->

        <%

int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;
if(IsDelete==1) IsActive=0;

if(!S_User.equals("")){
	TableUtil tu2 = new TableUtil();
	String sql2="select * from userinfo where Name='"+tu2.SQLQuote(S_User)+"'";
	ResultSet Rs2 = tu2.executeQuery(sql2);
	if(Rs2.next()){
		S_UserID=Rs2.getInt("id");
	}else{
		S_UserID=0;
	}
}

if(channel.getIsWeight()==1)
{
	//权重排序
	java.util.Calendar nowDate = new java.util.GregorianCalendar();
	nowDate.set(Calendar.HOUR_OF_DAY,0);
	nowDate.set(Calendar.MINUTE,0);
	nowDate.set(Calendar.SECOND,0);
	nowDate.set(Calendar.MILLISECOND,0);
	weightTime = nowDate.getTimeInMillis()/1000;
}

String Table = channel.getTableName();
String ListSql = "select id,Title,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Category,User,Photo";

if(channel.getIsWeight()==1)
	ListSql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
ListSql += " from " + Table;
String CountSql = "select count(*) from "+Table;


if(channel.getType()==Channel.Category_Type)
{
	ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
	CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
}
else if(channel.getType()==Channel.MirrorChannel_Type)
{
	Channel linkChannel = channel.getLinkChannel();
	if(linkChannel.getType()==Channel.Category_Type)
	{
		ListSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
		CountSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
	}
	else
	{
		ListSql += " where Category=0 and Active=" + IsActive;
		CountSql += " where Category=0 and Active=" + IsActive;
	}
}
else
{
	ListSql += " where "+ (!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
	CountSql += " where "+(!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
}

String WhereSql = "";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
}
if(!S_startDate.equals("")){
	long startTime=Util.getFromTime(S_startDate,"");
	WhereSql += " and CreateDate>="+startTime ;
}
if(!S_endDate.equals("")){
	long endTime=Util.getFromTime(S_endDate,"");
	WhereSql += " and CreateDate<"+(endTime+86400);
}

if(S_UserID>0)
{
	WhereSql += " and User="+S_UserID;
}

if(S_IsPhotoNews==1)
	WhereSql += " and IsPhotoNews=1";
if(S_Status!=0)
	WhereSql += " and Status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and Status=0";
	else
		WhereSql += " and Status=" + Status1;
}

WhereSql+= " and Status!=0 ";

ListSql += WhereSql;
CountSql += WhereSql;

if(channel.getIsWeight()==1)
{
	ListSql += " order by newtime desc,id desc";
}
else
{
	ListSql += " order by OrderNumber desc,id desc";
}
//System.out.println(ListSql);
TableUtil tu = new TableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();

%>
    <!--搜索-->
    <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
        <div class="search-content bg-white">
            <form name="search_form" action="<%=uri%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">
                <div class="row">
                    <!--标题-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <input class="form-control search-title" placeholder="标题" type="text" name="Title" value="<%=S_Title%>"  onClick="this.select()">
                    </div>
                    <!--日期-->
                    <div class="wd-200 mg-b-30 mg-r-10 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="startDate" value="<%=S_startDate%>" id="startDate">
                        </div>
                    </div>
                    <div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
                    <div class="wd-200 mg-b-30 mg-r-10 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="endDate" value="<%=S_endDate%>" id="endDate">
                        </div>
                    </div>
                    <!-- wd-200 -->
                    <!--作者-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-person tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control search-author" placeholder="作者" name="User" value="<%=S_User%>">
                        </div>
                    </div>
                    <!--状态-->
                    <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="状态" name="Status">
                            <option label="Choose one"></option>
                            <option value="0">全部</option>
                            <option value="2" <%=(S_Status==2?"selected":"")%>>已发</option>
                            <option value="1" <%=(S_Status==1?"selected":"")%>>草稿</option>
                        </select>
                    </div>
                    <div class="search-item mg-b-30">
                        <input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                    </div>
                </div><!-- row -->
            </form>
        </div>
    </div><!--搜索-->

    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0" id="oTable">
                <thead>
                <tr>
                   
                    <th class="tx-12-force tx-mont tx-medium">标题</th>
                    <th class="tx-12-force wd-300 tx-mont tx-medium hidden-xs-down">操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int j = 0;

                    while(Rs.next())
                    {
                        int id_ = Rs.getInt("id");
                        int Status = Rs.getInt("Status");
                        int category = Rs.getInt("Category");
                        int user = Rs.getInt("User");
                        String Title	= convertNull(Rs.getString("Title"));
                        String  Photo = convertNull(Rs.getString("Photo"));

                        String videoid="";
                        String contentid="";
                        String catalogcode="";
                        String itemid="";
                        String coverhref=Photo;

                        if(listAll)
                        {
                            if(category>0)
                                Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
                        }
                        int Weight=Rs.getInt("Weight");
                        int GlobalID=Rs.getInt("GlobalID");
                        Document docc = CmsCache.getDocument(GlobalID);
                        ArrayList docs = docc.listChildItems(4);//转码频道
                        String flvurl = "";
                        int videoID = 0;
                        String video_desc="";
                        for(int i = 0;i<docs.size();i++)
                        {
                            Document d = (Document)docs.get(i);
                            //flvurl = Util.base64(Util.ClearPath(d.getValue("video_dest")));
                            flvurl = Util.ClearPath(d.getValue("Url"));//Util.base64(Util.ClearPath(d.getValue("Url")));
                            if(flvurl!="") videoID = d.getId();
                            video_desc=d.getValue("video_desc");


                        }
                        //docc.getChannel().getSite().getUrl()+"/"+
                        String ModifiedDate	= convertNull(Rs.getString("ModifiedDate"));
                        ModifiedDate=Util.FormatDate("MM-dd HH:mm",ModifiedDate);
                        String UserName	= CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
                        String StatusDesc = "";
                        if(IsDelete!=1){
                            if(Status==0)
                                StatusDesc = "<font color=red>草稿</font>";
                            else if(Status==1)
                                StatusDesc = "<font color=blue>已发</font>";
                        }else{
                            StatusDesc = "<font color=blue>已删除</font>";
                        }
                        int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
                        j++;
                %>
                <tr No="<%=j%>"  videoid="<%=videoid%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  GlobalID="<%=GlobalID%>" id="jTip<%=j%>_id">
                    
                    <td><img src="../images/tree6.png"/><span class="pd-l-5 tx-black"><%=Title%></span></td>
                    <td class="dropdown hidden-xs-down">
                        <a href="javascript:Preview2(<%=videoID %>,'jTip<%=j%>_id');" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
                        <%
                            for(int n= 0;n<docs.size();n++)
                            {
                                Document d2 = (Document)docs.get(n);
                                //flvurl = Util.base64(Util.ClearPath(d.getValue("video_dest")));
                                flvurl = Util.ClearPath(d2.getValue("Url"));//Util.base64(Util.ClearPath(d.getValue("Url")));
                                int videoID2=0;
                                if(flvurl!="")  videoID2 = d2.getId();
                                String video_desc2=d2.getValue("video_desc");

                        %>
                        <a href="javascript:ok2('<%=videoID2%>','<%=flvurl%>','<%=coverhref%>');" class="btn pd-0 mg-r-5"
                           title="发布"> <%=video_desc2%></a>
                        <%}%>
                    </td>
                </tr>
                <%}
                    tu.closeRs(Rs);
                %>
                </tbody>
            </table>

            <script>
                var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
            </script>

            <%if(TotalPageNumber>0){%>

            <!--分页-->
            <div id="tide_content_tfoot">
                <span class="mg-r-20 ">共<%=TotalNumber%>条</span>
                <span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>
                <%if(TotalPageNumber>1){%>
                <div class="jump_page ">
                    <span class="">跳至:</span>
                    <label class="wd-60 mg-b-0">
                        <input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
                    </label>
                    <span class="">页</span>
                    <a href="javascript:goToPage();" class="tx-14">Go</a>
                </div>
                <%}%>
                <div class="each-page-num ht-40 d-flex alig-items-center mg-l-20 ">
                    <span class="mg-r-2">每页显示:</span>
                    <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="状态" onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="20">20</option>
                        <option value="25">25</option>
                        <option value="30">30</option>
                        <option value="50">50</option>
                        <option value="80">80</option>
                        <option value="100">100</option>
                    </select>
                    <span class="mg-l-2">条</span>
                </div>
                <div class="btn-group mg-l-20">
                    <%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a><%}%>
                    <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a><%}%>
                </div><!-- btn-group -->
            </div><!--分页-->
            <%}%>
        </div>
    </div><!--列表-->

    <div class="content_bot">
        <div class="left"></div>
        <div class="right"></div>
    </div>
        <%if(type==2){%>
    <div class="form_button">
        <input type="button"  id="startButton" value="确定" class="button" name="startButton"/>
        <input type="button" onclick="top.getDialog().Close();" id="btnCancel1" value="取消" class="button" name="btnCancel1"/>
    </div>
        <%}%>

    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>

    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>
    <script>

        jQuery("#rowsPerPage").val(<%=rowsPerPage%>);

        function Preview2(videoid,id)
        {
            if(videoid!=0){

                var dialog = new top.TideDialog();
                dialog.setWidth(640);
                dialog.setHeight(532);
                dialog.setZindex(11111);
                dialog.setUrl("../video/video_player.jsp?id="+videoid);
                dialog.setTitle("视频预览");
                dialog.show();

            }
            else{
                alert("没有生成转码后视频");

            }
            return false;

        }
        function Preview3(id,ChannelID)
        {
            window.open("../util/showvideo.jsp?ItemID=" + id + "&ChannelID="+ChannelID);
            // window.open("../util/showvideo.jsp?ItemID=" + id + Parameter);
        }

        function gopage(currpage)
        {
            var href="<%=uri%>?currPage="+currpage+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";

            this.location = href;
        }

        function double_click()
        {
            jQuery("#oTable tr:gt(0)").dblclick(function(){

            });

        }
        var type=<%=type%>;
        

        function ok(){
            var obj=getRadio();
            if(obj.length<1){
                alert("请选择视频!");
                return;
            }
            top.select_submit(obj);
            top.getDialog().Close();
            //window.opener.select_submit(obj);
            //window.close();
        }
        double_click();


        function goToPage(){
            var num=jQuery("#jumpNum").val();
            if(num==""){
                alert("请输入数字!");
                jQuery("#jumpNum").focus();
                return;}
            var reg=/^[0-9]+$/;
            if(!reg.test(num)){
                alert("请输入数字!");
                jQuery("#jumpNum").focus();
                return;
            }
            if(num><%=TotalPageNumber%>)
                num=<%=TotalPageNumber%>;
            if(num<1)
                num=1;
            var href="<%=uri%>?currPage="+num+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
            document.location.href=href;
        }

        function getRadio()
        {
            var video= "";
            jQuery("#oTable").each(function(i){
                //mp4=jQuery(this).attr("mp4");
                video='{"video_url":"'+$(this).attr("mp4")+'","photo":"'+$(this).attr("coverhref")+'"}';
            });
            // alert(mp4);
            return video;
        }

        function getRadio_(){
            var id="";
            var category="";
            var contentid="";
            var catalogcode="";
            var html="";
            var itemid="";
            var id_="";
            var coverhref="";
            jQuery("#oTable input:checked").each(function(i){
                id=jQuery(this).val();
                category=jQuery(this).attr("category");
                contentid=jQuery(this).attr("contentid");
                catalogcode=jQuery(this).attr("catalogcode");
                itemid=jQuery(this).attr("itemid");
                id_=jQuery(this).attr("mp4");
                coverhref=jQuery(this).attr("coverhref");
            });

            var obj={html:html,length:jQuery("#oTable input:checked").length,coverhref:coverhref,type:'<%=type%>'};
            return obj;
        }
        function jumpVms(channelid)
        {
            var href="<%=basePath%><%=vms2018%>lib/index_tcenter.jsp?channelid="+channelid+"";

            window.open(href);
        }



		function ok2(videoID,mp4,photo){

            //console.log(mp4);
            //console.log(photo);
            //console.log(videoID);

            if(mp4!=""){
				var video_type = <%=video_type%>;

                var html="";
                html+= '<div style="width:100%; height:auto;margin:15px auto;" align="center">';
				if(video_type==1){
					html+= '<div id="tide_video"><span hidden="hidden">video</span>';
					html+= '<video src="'+mp4+'" controls="controls" poster="'+photo+'" width="100%" height="100%"></video>';
					html+= '</span>';
				}else{
					html+= '<span id="tide_video">';
					html+= '<script>tide_player.showPlayer({video:"'+mp4+'",cover:"'+photo+'",width:"100%",height:"100%"});<\/script>';
					html+= '</span>';
					html+='<img class="tide_video_fake" src="'+photo+'"  _fckfakelement="true" _fckrealelement="1">';
				}
                html+="</div>"

				
				//var obj={html:html,length:1,coverhref:"",type:'1',video_type:video_type};			
				//return obj;

                window.parent.parent.editor.focus();
                window.parent.parent.editor.execCommand('inserthtml',html);
                $(window.parent.parent.parent.document).find('.edui-dialog-closebutton div[title="关闭对话框"]').trigger("click");
            }else{
                alert("没有生成转码后视频");
                return false;
            }


            //editor.setContent(html,true);
            //window.opener.select_submit(obj);
            //window.close();
        }

    </script>
    <script>
        $(function(){
            'use strict';

            //show only the icons and hide left menu label by default
            $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

            $(document).on('mouseover', function(e){
                e.stopPropagation();
                if($('body').hasClass('collapsed-menu')) {
                    var targ = $(e.target).closest('.br-sideleft').length;
                    if(targ) {
                        $('body').addClass('expand-menu');

                        // show current shown sub menu that was hidden from collapsed
                        $('.show-sub + .br-menu-sub').slideDown();

                        var menuText = $('.menu-item-label,.menu-item-arrow');
                        menuText.removeClass('d-lg-none');
                        menuText.removeClass('op-lg-0-force');

                    } else {
                        $('body').removeClass('expand-menu');

                        // hide current shown menu
                        $('.show-sub + .br-menu-sub').slideUp();

                        var menuText = $('.menu-item-label,.menu-item-arrow');
                        menuText.addClass('op-lg-0-force');
                        menuText.addClass('d-lg-none');
                    }
                }
            });

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


            $("#content-table tr:gt(0)").click(function () {
                if ($(this).find(":checkbox").prop("checked"))// 此处要用prop不能用attr，至于为什么你测试一下就知道了。
                {
                    $(this).find(":checkbox").removeAttr("checked");
                }else{
                    $(this).find(":checkbox").prop("checked", true);
                }
            });
            $("#checkAll,#checkAll_1").click(function(){
                var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
                var existChecked = false ;
                for (var i=0;i<checkboxAll.length;i++) {
                    if(!checkboxAll.eq(i).prop("checked")){
                        existChecked = true ;
                    }
                }
                if(existChecked){
                    checkboxAll.prop("checked",true);
                }else{
                    checkboxAll.removeAttr("checked");
                }
                return;
            })
            $(".btn-search").click(function(){
                $(".search-box").toggle(100);
            })

            // Datepicker
            $('.fc-datepicker').datepicker({
                showOtherMonths: true,
                selectOtherMonths: true,
                dateFormat: "yy-mm-dd"
            });

        });
    </script>
</body>
</html>
