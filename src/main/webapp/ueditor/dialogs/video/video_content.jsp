<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.report.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../../config.jsp"%>
<%
String fieldname = getParameter(request,"fieldname");
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
        rowsPerPage = 10;

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
    <link rel="Shortcut Icon" href="../../../favicon.ico">
    <title>音视频库</title>
    <link href="../../../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../../../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../../../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../../../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../../../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../../../style/2018/bracket.css">
    <link rel="stylesheet" href="../../../style/2018/common.css">

    <style>
    	body{background: #fff;}
    	.br-pageheader{background: #fff;}
        .collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
        .search-box {display: none;}
        .border-radius-5{border-radius: 5px;}
        .select2-container--default .select2-selection--single{ height: 30px; }
        .select2-container--default .select2-selection--single .select2-selection__arrow{height: 30px;}
        .search-content { padding: 10px 15px; min-height: auto;}
        #tide_content_tfoot1 {padding: .75rem;display: flex;border-top: none;align-items: center;color: #000;}
        td>label{cursor: pointer;}
    </style>

    <script src="../../../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../../../common/2018/content.js"></script>

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
            <a href="javascript:;" class="btn btn-primary mg-r-10 pd-x-10-force pd-y-5-force btn-search"><i class="fa fa-search mg-r-3"></i><span>检索</span></a>
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
if(id!=0){
    ListSql +=",Duration";
}
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
        
    <!--æç´¢-->
    <div class="search-box" style="display:none;">
        <div class="search-content bg-white">
            <form name="search_form" action="<%=uri%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">
                <div class="row">
                    <!--æ é¢-->
                    <div class="mg-r-10 search-item">
                        <input class="form-control search-title" placeholder="标题" type="text" name="Title" value=""  onClick="this.select()">
                    </div>
                </div><!-- row -->
            </form>
        </div>
    </div><!--æç´¢-->

    <!--åè¡¨-->
    <div class="br-pagebody pd-x-15 mg-t-10 mg-b-15">
        <div class="card bd-0 shadow-base">
            
            <table class="table mg-b-0  ui-sortable" id="content-table">
				<thead>
					<tr>
						<th class="wd-5p wd-60" style="text-align: center"><span class="pd-l-10">选择</span></th>
						<th class="tx-12-force tx-mont tx-medium header" style="text-align: center">标题</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120 wd-author header" style="text-align: center">码率</th>
						<th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down wd-80 header" style="text-align: center">预览</th>
					</tr>
				</thead>
					<tbody>
					
<%
                    int j = 0;

                    while(Rs.next())
                    {
                        int id_ = Rs.getInt("id");
                        int category = Rs.getInt("Category");
                        int user = Rs.getInt("User");
                        String Title	= convertNull(Rs.getString("Title"));
                        String  Photo = convertNull(Rs.getString("Photo"));
                        String duration = convertNull(Rs.getString("Duration"));
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
                        if(docs.size()==0){
                        	--TotalNumber;
                        	continue;
                        }
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
                        int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
                        j++;
                %>
                <tr class="tide_item" No="<%=j%>"  videoid="<%=videoid%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  GlobalID="<%=GlobalID%>" id="jTip<%=j%>_id">
			            <td class="valign-middle" align="center" valign="middle">
			              <label class="rdiobox mg-b-0 mg-l-10">
							<input type="radio" name="choose" value="<%=GlobalID%>"><span></span>
						  </label>
			            </td>
						<td class="hidden-xs-down" align="center" valign="middle"><%=Title%></td>
						<td class="hidden-xs-down"align="center" valign="middle">
							<select name="rowsPerPage" class="form-control select2 wd-150" data-placeholder="状态">
		                        <%
		                            for(int n= 0;n<docs.size();n++){ 
		                                Document d2 = (Document)docs.get(n);
		                                //flvurl = Util.base64(Util.ClearPath(d.getValue("video_dest")));
		                                flvurl = Util.ClearPath(d2.getValue("Url"));//Util.base64(Util.ClearPath(d.getValue("Url")));
		                                int videoID2=0;
		                                if(flvurl!="")  videoID2 = d2.getId();
		                                String video_desc2=d2.getValue("video_desc");
										 %>
		                       			 <option GlobalID="<%=GlobalID%>" Photo="<%=Photo%>" value="<%=videoID2%>" flvurl="<%=flvurl%>" coverhref="<%=coverhref%>" Title="<%=Title%>" duration="<%=duration%>"><%=video_desc2%></option>
		                        <% } %>
		                    </select>
						</td>
						<td class="dropdown hidden-xs-down" align="center" valign="middle">
			    			<a href="javascript:Preview2(<%=videoID%>,'jTip<%=j%>_id');" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
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
                
                <div class="btn-group mg-l-auto">
                    <%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a><%}%>
                    <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a><%}%>
                </div><!-- btn-group -->
            </div><!--分页-->
            <%}%>
            
        </div>
    </div><!--åè¡¨-->

    <div class="content_bot">
        <div class="left"></div>
        <div class="right"></div>
    </div>
        

    <script src="../../../lib/2018/popper.js/popper.js"></script>
    <script src="../../../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../../../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../../../lib/2018/moment/moment.js"></script>
    <script src="../../../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../../../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../../../lib/2018/peity/jquery.peity.js"></script>

    <script src="../../../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
    <script src="../../../lib/2018/select2/js/select2.min.js"></script>
    <script src="../../../common/2018/bracket.js"></script>
    <script>

        jQuery("#rowsPerPage").val(<%=rowsPerPage%>);
        var fieldname = '<%=fieldname%>';
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

        function getCheckRadio()
        {
           var check_radio = $("input[type='radio']:checked");
           var check_radio_val = check_radio.val();
           if(typeof(check_radio_val)=="undefined"){
				alert("请先选中视频");
				return;
           }
			var check_tr = check_radio.parent().parent().parent();
			var check_option = check_tr.find("option:selected");
			var check_option_val = check_option.val();
			if(typeof(check_option_val)=="undefined"){
				alert("请选中有转码的视频");
				return;
           }
			var videoID2 = check_option.attr("value");
			var flvurl = check_option.attr("flvurl");
			var coverhref = check_option.attr("coverhref");
			ok2(videoID2,flvurl,coverhref);
			return;
        }
        function getVideoUrl()
        {
           var check_radio = $("input[type='radio']:checked");
           var check_radio_val = check_radio.val();
           if(typeof(check_radio_val)=="undefined"){
				alert("请先选中视频");
				return;
           }
			var check_tr = check_radio.parent().parent().parent();
			var check_option = check_tr.find("option:selected");
			var check_option_val = check_option.val();
			if(typeof(check_option_val)=="undefined"){
				alert("请选中有转码的视频");
				return;
           }
			var flvurl = check_option.attr("flvurl");
			var globalid=check_option.attr("GlobalID");
			var title=check_option.attr("Title");
			var photo=check_option.attr("Photo");
			var duration=check_option.attr("duration");
            window.parent.parent.parent.$("#videoid").val(globalid);
			window.parent.parent.parent.$("#"+fieldname).val(flvurl);
            window.parent.parent.parent.$("#duration").val(duration);
			var Title = window.parent.parent.parent.$("#Title").val();
			var Photo = window.parent.parent.parent.$("#Photo").val();
			if(Title.trim()==""){
                window.parent.parent.parent.$("#Title").val(title);
            }
            if(Photo.trim()==""){
                window.parent.parent.parent.$("#Photo").val(photo);
            }
        }
        function Preview3(id,ChannelID)
        {
            window.open("../../../util/showvideo.jsp?ItemID=" + id + "&ChannelID="+ChannelID);
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

                window.parent.parent.ueditor.focus();
                window.parent.parent.ueditor.execCommand('inserthtml',html);
                //$(window.parent.parent.parent.document).find('.edui-dialog-closebutton div[title="关闭对话框"]').trigger("click");
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
			
			//æç´¢
            $(".btn-search").click(function(){
                $(".search-box").toggle(0);
                window.parent.setTimeoutIfa();
            })

        });
    </script>
</body>
</html>
