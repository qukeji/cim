<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    public  Integer getParent_Channel(Integer id,Integer flag)throws MessageException, SQLException
    {    flag+=1;
        Channel channel_= CmsCache.getChannel(id);
        int channel_id = channel_.getParent();
        if(id == 15894 || id == 15922 || id == 15943 || channel_id == 15894 || channel_id == 15922 || channel_id == 15943){
            return  channel_id;
        }else if(channel_id == -1){
            return  channel_id ;
        }else if(flag==10){
            return  -1;
        }else{
            return getParent_Channel(channel_id,flag);
        }
    }
%>
<%!

    public String getParentChannelPath(Channel channel) throws MessageException, SQLException{

        String path = "";
        ArrayList arraylist = channel.getParentTree();

        if ((arraylist != null) && (arraylist.size() > 0))
        {
            for (int i = 0; i < arraylist.size(); ++i)
            {
                Channel ch = (Channel)arraylist.get(i);

                if((i+1)==arraylist.size()){//当前频道名
                    path = path + ch.getName() ;// + ((i < arraylist.size() - 1) ? " / " : "");
                }else{
                    path = path + ch.getName() +" / ";// javascript:jumpContent("+ch.getId()+")
                }
            }
        }

        arraylist = null;

        return path;
    }
    
%>
<%
    /**
     * 用途：文档列表页
     * 1,李永海 20140101 创建
     * 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
     * 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
     */
    
    TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
    int wenzhengid = politics.getInt("politicsid");//问政编号信息
    int id = wenzhengid;
    
    
    String uri = request.getRequestURI();
    long begin_time = System.currentTimeMillis();
    int processstate = getIntParameter(request,"id");
    int currPage = getIntParameter(request,"currPage");
    int rowsPerPage = getIntParameter(request,"rowsPerPage");
    int sortable = getIntParameter(request,"sortable");
    int rows = getIntParameter(request,"rows");
    int cols = getIntParameter(request,"cols");
    int GlobalID=getIntParameter(request,"GlobalID");
    String globalids="";
    if(currPage<1)
        currPage = 1;

    if(rowsPerPage==0)
        rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new",request.getCookies()));

    if(rowsPerPage<=0)
        rowsPerPage = 20;

    if(rows==0)
        rows = Util.parseInt(Util.getCookieValue("rows_new",request.getCookies()));
    if(cols==0)
        cols = Util.parseInt(Util.getCookieValue("cols_new",request.getCookies()));

    if(rows==0)
        rows = 10;
    if(cols==0)
        cols = 5;

    Channel channel = CmsCache.getChannel(id);
    Channel wenzhengchannel = channel;
    
     //查询子频道条件sql
    String categoryWhere = "";
    if(!channel.hasRight(userinfo_session,1)){
        TableUtil authortu = new TableUtil();
		String authorsql = "select * from channel where parent="+id;
		ResultSet authorrs = authortu.executeQuery(authorsql);
		while(authorrs.next()){
		    int childid = authorrs.getInt("id");
//		    System.out.println("======================================childid="+childid);
			String childname=authorrs.getString("Name");
			Channel childchannel = CmsCache.getChannel(childid);
			if(childchannel.hasRight(userinfo_session,1)){
//			    System.out.println("======================================哈哈哈哈childid="+childid);
			    channel = CmsCache.getChannel(childid);
			    if(channel != null){
			        categoryWhere = " and category = "+childid;
//			        System.out.println("======================================categoryWhere="+categoryWhere);
			    }
			}
		    
		}
		authortu.closeRs(authorrs);

    }
    
    boolean IsTopStatus=false;//是否置顶
    if(channel.getIsTop()==1){
        IsTopStatus=true;
    }
    if(wenzhengchannel==null||channel==null || channel.getId()==0)
    {
        response.sendRedirect("../content/content_nochannel.jsp");
        return;
    }

    Channel parentchannel = null;
    int ChannelID = channel.getId();
    String ChannelName = channel.getName();
    int IsWeight=channel.getIsWeight();
    int	IsComment=channel.getIsComment();
    int	IsClick=channel.getIsClick();
    String gids = "";


    if(channel.getListProgram().length()>0 && uri.endsWith("/content/content2018.jsp"))
    {response.sendRedirect(channel.getListProgram()+"?id="+id);return;}

    String S_Title				=	getParameter(request,"Title");
    String S_startDate			=	getParameter(request,"startDate");
    String S_endDate			=	getParameter(request,"endDate");
    String S_User				=	getParameter(request,"User");
    int S_IsIncludeSubChannel	=	getIntParameter(request,"IsIncludeSubChannel");
    int S_Status				=	getIntParameter(request,"Status");
    int S_IsPhotoNews			=	getIntParameter(request,"IsPhotoNews");
    int S_OpenSearch			=	getIntParameter(request,"OpenSearch");
    int IsDelete				=	getIntParameter(request,"IsDelete");

    int Status1			=	getIntParameter(request,"Status1");
    int Status2			=	getIntParameter(request,"Status2");
    int S_probstatus			=	getIntParameter(request,"probstatus");
    
    int S_belong			=	getIntParameter(request,"belong");
    


    int listType = 0;
    listType = getIntParameter(request,"listtype");
    if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list_new",request.getCookies()));
    if(listType==0) listType = 1;

    boolean listAll = false;

    if(channel.getParent()==-1){//说明是站点
        S_IsIncludeSubChannel = 0;
    }

    if(channel.isTableChannel() && channel.getType2()==8) listAll = true;
    if(channel.getIsListAll()==1) listAll = true;
    if(S_IsIncludeSubChannel==1) listAll = true;

    if(channel.getType()==2)
    {
        response.sendRedirect("../page/content_page.jsp?id="+id);
        return;
    }


//如果是“新建应用”；
    if(channel.getType()==3)
    {
        response.sendRedirect("app.jsp?id="+id);
        return;
    }

    String querystring = "";
    querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

    String pageName = request.getServletPath();
    int pindex = pageName.lastIndexOf("/");
    if(pindex!=-1)
        pageName = pageName.substring(pindex+1);

    if(!channel.hasRight(userinfo_session,1))
    {
        response.sendRedirect("../noperm.jsp");return;
    }
    //权限
    boolean wenzhengcanDelete = wenzhengchannel.hasRight(userinfo_session,ChannelPrivilegeItem.CanDelete);
    boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);
    boolean canDelete = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanDelete);
    int canExcel=channel.getIsExportExcel();//是否导出Excel
    int canWord=channel.getIsImportWord();//是否导出world
    String SiteAddress = channel.getSite().getUrl();


//获取频道路径
    String parentChannelPath = getParentChannelPath(channel);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS 列表</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />
    <style>
        .collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
        table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
        table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
            border-collapse: collapse !important;}
        .list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;}
        .list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}
        @media (max-width: 575px){
            #content-table .hidden-xs-down {word-break: normal;	}
        }
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>
    <script>
        var listType = <%=listType%>;
        var rows = <%=rows%>;
        var cols = <%=cols%>;
        var ChannelID = <%=ChannelID%>;
        var currRowsPerPage = <%=rowsPerPage%>;
        var currPage = <%=currPage%>;
        var ChannelName = "<%=ChannelName%>";
        var GlobalID=<%=GlobalID%>
        var Parameter = "&ChannelID=" + ChannelID + "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
        var pageName = "<%=pageName%>";
        if (pageName == "") pageName = "content.jsp";

        function gopage(currpage) {
            var url = pageName + "?currPage=" + currpage + "&id=<%=processstate%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
            this.location = url;
        }

        function list(str) {
            var url = pageName + "?id=<%=processstate%>&rowsPerPage=<%=rowsPerPage%>";
            if (typeof(str) != 'undefined')
                url += "&" + str;
            this.location = url;
        }
        function recommendOut1(id)
        {
            var	dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(400);
            dialog.setUrl("../recommend/out_index.jsp?ChannelID="+ChannelID+"&ItemID="+id);
            dialog.setTitle('推荐');
            dialog.setChannelName(ChannelName);
            dialog.show();

        }

        function ChangeStatus2(){

            var obj=getCheckbox();
            if(obj.length==0){
                TideAlert("提示","请选择改变状态的选项!");
            }else{

                ChangeStatus22(obj.id);
            }
        }
        function ChangeStatus22(id){

            var url= "../wenzheng/changestatus2.jsp?ChannelID="+ChannelID+"&ItemID="+ id + Parameter;

            var	dialog = new top.TideDialog();
            dialog.setWidth(350);
            dialog.setHeight(230);
            dialog.setUrl(url);
            dialog.setTitle("批量改变状态");
            dialog.show();
        }
        function reply(){

            var obj=getCheckbox();
            if(obj.length==0){
                TideAlert("提示","请选择回复栏目选项!");
            }else{

                reply2(obj.id);
            }
        }
        function reply2(id){


            var url= "../wenzheng/wenzheng_reply.jsp?ChannelID="+ChannelID+"&ItemID="+id+"&GlobalID="+GlobalID;

            var	dialog = new top.TideDialog();
            dialog.setWidth(800);
            dialog.setHeight(630);
            dialog.setUrl(url);
            dialog.setTitle("回复");
            dialog.show();
        }
        function changeList(i)
        {
        	var expires = new Date();
        	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
        	document.cookie = ChannelID+"_list_new=" + i + ";path=/;expires=" + expires.toGMTString();
        	document.location.href = pageName + '?listtype=' + i + '&cookie=1&id=<%=processstate%>'+Parameter;
        }
function wz_start(s)
{
	var url="../wenzheng/wenzheng_checkin.jsp?ChannelID=<%=ChannelID%>&ItemID="+s+"&probstatus=4";
	$.ajax({
		type: "GET",
		url: url,
		success: function(msg){document.location.href=document.location.href;}   
	});  
}

//结束
function overDocument(){
	var obj=getCheckbox();
	var message = "确实要结束这"+obj.length+"项吗？";
	if(obj.length==0){
		TideAlert("提示","请先选择要删除的文件！");
	}else{
		if(!approve_check(2)){
			TideAlert("提示","请选择审核通过或未提交审核的文档！");
			return;
		}

		if(confirm(message)){
			overDocument_confirm(obj.id,obj.length);
		}
	}
}
function overDocument1(id){
	var message = "确实要结束这1项吗？";
	if(confirm(message)){
		overDocument_confirm(id,0);
	}
}
function overDocument_confirm(id,length){
	
	$.ajax({
    	type: "GET",
    	url: "../wenzheng/wenzheng_dataupdate.jsp",
        data: {ChannelID:<%=ChannelID%>,ItemID:id,operation:8},
    	success: function(msg){document.location.href=document.location.href;}   
	}); 
}

//直接回复        
function replyDocument(id_){

    var url= "../wenzheng/wenzheng_back.jsp?ChannelID=<%=ChannelID%>&ItemID="+id_+"&operation=4&islist=1";

    var	dialog = new top.TideDialog();
    dialog.setWidth(540);
    dialog.setHeight(320);
    dialog.setUrl(url);
    dialog.setTitle("直接回复");
    dialog.show();
    }
//回复   
function replyDocument2(id_){

    var url= "../wenzheng/wenzheng_back.jsp?ChannelID=<%=ChannelID%>&ItemID="+id_+"&operation=7&islist=1";

    var	dialog = new top.TideDialog();
    dialog.setWidth(540);
    dialog.setHeight(320);
    dialog.setUrl(url);
    dialog.setTitle("回复");
    dialog.show();
    }
    
window.onload=function(){
var selectVal = <%=S_belong%>;
          $.ajax({
                 timeout: 3000,
                 async: false,
                 type: "GET",
                 url: "../lib/channel_json.jsp?ChannelID=<%=wenzhengid%>",
                 dataType: "json",
                 success: function (data) {
                	 //alert(data[0].time);
                	 //alert(data[1].time);
                	 //alert(data[2].time);
                     for (var i = 0; i < data.length; i++) {
                    	 //if(selectVal==data[i].id){
                    	     //$("#belong").append("<option value = '"+data[i].id+ "' 'selected'>" + data[i].name + "</option>");
                    	 //}else{
                    	      $("#belong").append("<option value = '"+data[i].id+ "'>" + data[i].name + "</option>");
                    	      
                    	      $("#belong").val(selectVal); 
                    	 //}
                         

                              //'在循环中设置 默认选中  为true'
                              //if (select.options[i].value == selectVal){  
                              //  select.options[i].selected = true;  
                              //}  
                     }
                }
          });
    }
    </script>
</head>

<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active"><%=parentChannelPath%></span>
        </nav>
    </div>
    <!-- br-pageheader -->
    <%
        int S_UserID = 0;
        long weightTime = 0;
        int IsActive = 1;
        if(IsDelete==1) IsActive=0;

        if(!S_User.equals("")){
            String sql2="select * from userinfo where Name='"+S_User+"'";
            TableUtil tu2 = new TableUtil("user");
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

//System.out.println("time:"+weightTime);
        String Table = channel.getTableName();
//添加判断有内容类型的频道
        int   doc_type_channel = getParent_Channel(id,0);
        String ListSql ="";
        if(doc_type_channel== -1){
            ListSql = "select id,Title,Photo,Status2,Weight,GlobalID,User,UserName,phone,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews,probstatus";
        }else{
            ListSql = "select id,Title,doc_type,Status2,Photo,Weight,GlobalID,User,UserName,phone,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews,probstatus";
        }


        String FieldStr=",DocTop,DocTopTime";
        if(IsTopStatus){
            ListSql+=FieldStr;
        }


        if(listType==2)
        {
            ListSql += ",Summary,Content,Keyword";
        }
        if(channel.getIsWeight()==1)
            ListSql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
        ListSql += " from " + Table;
        String CountSql = "select count(*) from "+Table;

//if(!S_User.equals(""))
        //CountSql = "select count(*) from "+Table+" ";

 //       if(!listAll)
 //       {
        
        //判断是拥有权限是子节点还是父节点
        if(categoryWhere==""){
            if(S_belong!=0){
                ListSql += " where Active=" + IsActive + " and category = " + S_belong;
                CountSql += " where Active=" + IsActive + " and category = " + S_belong;
            }else{
                ListSql += " where Active=" + IsActive;
                CountSql += " where Active=" + IsActive;
            }
            
        }else{
            ListSql += " where Active=" + IsActive + categoryWhere;
            CountSql += " where Active=" + IsActive + categoryWhere;
        }
        
/*
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
    }
        else
        {
            ListSql += " where Active=" + IsActive + categoryWhere;;
            CountSql += " where Active=" + IsActive + categoryWhere;;
        }
*/
    

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

/*
if(S_IsIncludeSubChannel==1)
{
	WhereSql += " and ChannelCode like '"+channel.getChannelCode() + "%'";
}*/

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
        if(S_probstatus!=0){
            WhereSql += " and probstatus=" + S_probstatus;
        }

        if(Status2==3){
            WhereSql += " and Status2=0";
        }else if(Status2==1){
            WhereSql += " and Status2=1";
        }else if(Status2==2){
            WhereSql += " and Status2=2";
        }
        
        //判断状态节点
        if(processstate==1){
            WhereSql += " and Status2=0";
        }else if(processstate==2){
            WhereSql += " and Status2=1";
        }else if(processstate==3){
            WhereSql += " and Status2=2";
        }

        ListSql += WhereSql;
        CountSql += WhereSql;

        if(channel.getIsWeight()==1)
        {
            ListSql += " order by newtime desc,id desc";
        }
        else
        {
            if(IsTopStatus){
                ListSql += " order by  DocTop desc ,DocTopTime  desc  ,OrderNumber desc ";
            }else {
                ListSql += " order by ModifiedDate desc ";
            }
        }

//System.out.println("==========================================================="+ListSql);

        int listnum = rowsPerPage;
        if(listType==2) listnum = cols*rows;

        TableUtil tu = channel.getTableUtil();
        ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
        int TotalPageNumber = tu.pagecontrol.getMaxPages();
        int TotalNumber = tu.pagecontrol.getRowsCount();

    %>
    <!--操作-->
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

        <!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
            <div class="dropdown-menu pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:list();" class="nav-link list_all">全部</a>
                    <a href="javascript:list('IsDelete=1');" class="nav-link list_delete">已删除</a>
                    <a href="#" class="nav-link">搜索</a>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端-->

        <div class="btn-group hidden-xs-down">
            <a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
            <a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
        </div>
        <!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-xs-down">
            <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
            <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">

    
            <%if(wenzhengcanDelete&&(processstate==0||processstate==3)){%>
            <a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>
            <%}%>

        </div>
        <!-- START: 按钮过多时的部分功能下拉 -->
        <div class="dropdown hidden-md-1500-up hidden-sm-down mg-l-10">
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 按钮过多时的部分功能下拉 -->
        <!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <!--上一页 下一页-->
        <div class="btn-group mg-l-10">
            <%if(currPage>1){%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if(currPage<TotalPageNumber){%>
            <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
            <%}%>
        </div>
        <!-- btn-group -->

    </div>
    <!--操作-->

    <!--搜索-->
    <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
        <div class="search-content bg-white">
            <form name="search_form" action="<%=pageName%>?id=<%=processstate%>&rowsPerPage=<%=rowsPerPage%>" method="post" onsubmit="return check();">
                <div class="row">
                    <!--标题-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <input class="form-control search-title" placeholder="主题" type="text" name="Title" value="<%=S_Title%>" onClick="this.select()">
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
                    <!--状态-->
                    <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="问题状态" name="probstatus">
                            <option label="Choose one"></option>
                            <option value="0">全部</option>
                            <option value="1" <%=(S_probstatus==1?"selected":"")%>>未审核</option>
                            <option value="2" <%=(S_probstatus==2?"selected":"")%>>审核未通过</option>
                            <option value="3" <%=(S_probstatus==3?"selected":"")%>>未受理</option>
                            <option value="4" <%=(S_probstatus==4?"selected":"")%>>已受理</option>
                            <option value="5" <%=(S_probstatus==5?"selected":"")%>>平台回复</option>
                            <option value="6" <%=(S_probstatus==6?"selected":"")%>>已回复</option>
                            <option value="7" <%=(S_probstatus==7?"selected":"")%>>已完结</option>
                        </select>
                    </div>
                    <%if(wenzhengchannel.hasRight(userinfo_session,1)){%>
                    <!--部门-->
                    <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="部门" id="belong" name="belong">
                            <option label="Choose one"></option>
                            <option value="0">全部</option>
                        </select>
                    </div>
                    <%}%>
                    <div class="search-item mg-b-30">
                        <input type="hidden" name="IsIncludeSubChannel" value="1">
                        <input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                        <input type="hidden" name="OpenSearch" id="OpenSearch" value="1">
                    </div>
                </div>
                <!-- row -->
            </form>
        </div>
    </div>
    <!--搜索-->

    <%if(channel.hasRight(userinfo_session,1)){%>
    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0 <%=listType==2?"table-fixed":""%>" id="content-table">
                <%if(listType==1){%>
                <thead>
                <tr>
                    <th class="wd-5p wd-80">选择</th>
                    <th class="tx-12-force tx-mont tx-medium">主题</th>
                    <th class="tx-12-force tx-mont tx-medium wd-80">部门归属</th>
                    <%if(doc_type_channel != -1){%>
                    <th class="tx-12-force tx-mont tx-medium wd-80">内容类型</th>
                    <%}%>
                    <%if(IsWeight==1){%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">权重</th>
                    <%}%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120">问题状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-100">处理状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120 wd-author">用户名</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120">手机号</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-180">日期</th>
                    <%if(IsComment==1){%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">评论</th>
                    <%}%>
                    <%if(IsClick==1){%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">点击量</th>
                    <%}%>
                    <th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down">操作</th>
                </tr>
                </thead>
                <%}%>
                <tbody>
                <%

                    int j = 0;
                    int m = 0;
                    int temp_gid=0;
                    String doc_typeString ="";
                    while(Rs.next())
                    {
                        int id_ = Rs.getInt("id");
                        if(doc_type_channel != -1){
                            int doc_type = Rs.getInt("doc_type");
                            if(doc_type==0){
                                doc_typeString="图文";
                            }else if(doc_type==1){
                                doc_typeString="视频";
                            }else if(doc_type==2){
                                doc_typeString="图集";
                            }else if(doc_type==3){
                                doc_typeString="专题";
                            }else if(doc_type==4){
                                doc_typeString="聚现直播";
                            }else if(doc_type==5){
                                doc_typeString="PDF文档";
                            }else if(doc_type==6){
                                doc_typeString="栏目跳转";
                            }else if(doc_type==7){
                                doc_typeString="外链";
                            }else if(doc_type==8){
                                doc_typeString="直播";
                            }
                        }

                        int Status = Rs.getInt("Status");
                        int Status22 = Rs.getInt("Status2");
                        int category = Rs.getInt("Category");
                        int user = Rs.getInt("User");
                        int active = Rs.getInt("Active");
                        //问题状态
                        int probstatus = Rs.getInt("probstatus");
                        
                        String probstatusDesc = "";
                        if(probstatus==1){
                            probstatusDesc="<span class='tx-danger'>未审核</span>";
                        }else if(probstatus==2){
                            probstatusDesc="<span class='tx-danger'>审核未通过</span>";
                        }else if(probstatus==3){
                            probstatusDesc="<span class='hidden-xs-down'>未受理</span>";
                        }else if(probstatus==4){
                            probstatusDesc="<span class='tx-danger'>已受理</span>";
                        }else if(probstatus==5){
                            probstatusDesc="<span class='tx-orange'>平台回复</span>";
                        }else if(probstatus==6){
                            probstatusDesc="<span class='tx-orange'>已回复</span>";
                        }else if(probstatus==7){
                            probstatusDesc="<span class='tx-success'>已完结</span>";
                        }
                        


                        String Title	= convertNull(Rs.getString("Title"));
                        int IsPhotoNews = Rs.getInt("IsPhotoNews");
                        String phone	= convertNull(Rs.getString("phone"));
                        String UserName	= convertNull(Rs.getString("UserName"));

                        int TopStatus = 0;

                        if(IsTopStatus){
                            TopStatus = Rs.getInt("DocTop");
                        }

                        int Weight=Rs.getInt("Weight");
                        GlobalID=Rs.getInt("GlobalID");


                        if(temp_gid!=0){
                            globalids+=",";
                        }
                        temp_gid++;
                        globalids+=GlobalID+"";


                        String ModifiedDate	= convertNull(Rs.getString("ModifiedDate"));
                        ModifiedDate=Util.FormatDate("yyyy-MM-dd HH:mm",ModifiedDate);

                        String StatusDesc = "";
                        if(IsDelete!=1){
                            if(Status==0)
                                StatusDesc = "<span class='tx-orange'>草稿</span>";
                            else if(Status==1)
                                StatusDesc = "<span class='tx-success'>已发</span>";
                        }else{
                            StatusDesc = "<span class='tx-danger'>已删除</span>";
                        }
                        //办理状态
                        String Status2Desc="";
                        //
                        if(IsDelete!=1){
                        if(Status22==0){
                            Status2Desc="待办理";
                        }else if(Status22==1){
                            Status2Desc="办理中";
                        }else if(Status22==2){
                            Status2Desc="已办理";
                        }
                        }else{
                            Status2Desc = "<span class='tx-danger'>已删除</span>";
                        }
                        if(gids.length()>0){gids+=","+GlobalID+"";}else{gids=GlobalID+"";}

                        int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
                        j++;

                        if(listType==1)
                        {
                %>
                <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>" status="<%=Status%>" GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item">
                    <td class="valign-middle">
                        <label class="ckbox mg-b-0">
                            <input type="checkbox" name="id" value="<%=id_%>"><span></span>
                        </label>
                    </td>
                    <td ondragstart="OnDragStart(event)">
                        <%if(IsPhotoNews==1){%>
                        <i class="fa fa-picture-o tx-18 tx-primary lh-0 valign-middle" id="img_<%=j%>"></i>
                        <%}else{%>
                        <i class="icon ion-clipboard tx-22 tx-warning lh-0 valign-middle" id="img_<%=j%>"></i>
                        <%}%>
                        <%if(TopStatus==0){%><%}else{%>
                        <i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_<%=j%>" title="置顶"></i>
                        <%}%>
                        <span class="pd-l-5 tx-black"><%=Title%></span>
                    </td>
                    <%if(doc_type_channel != -1){%>
                    <td class="hidden-xs-down">
                        <%=doc_typeString%>
                    </td>
                    <%}%>
                    <%if(IsWeight==1){%>
                    <td class="hidden-xs-down"><span ItemID="<%=id_%>"><%=Weight%></span></td>
                    <%}%>
                    
                    <td class="hidden-xs-down">
                        <%=category==0?"":CmsCache.getChannel(category).getName()%>
                    </td>
                    
                    <td class="hidden-xs-down">
                        <%=probstatusDesc%>
                    </td>
                    
                    <td class="hidden-xs-down">
                        <%=Status2Desc%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=UserName%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=phone%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=ModifiedDate%>
                    </td>
                    <%if(IsComment==1){%>
                    <td class="hidden-xs-down"><span id="comment_<%=GlobalID%>"></span></td>
                    <%}%>
                    <%if(IsClick==1){%>
                    <td class="hidden-xs-down"><span id="click_<%=GlobalID%>"></span></td>
                    <%}%>
                    <td class="hidden-xs-down">
                    <%if(active==0){
                    if(wenzhengchannel.hasRight(userinfo_session,1)){%>
                        <a class="mg-r-5" href="javascript:resume(<%=id_%>);" ><span title="恢复" class="icon fa fa-reply tx-18" ></a>
                    <%}
                    }else{
                    if(wenzhengchannel.hasRight(userinfo_session,1)){%>
                    <%if((Status22==0)&&probstatus==1){%>
                        <!-- 审核 -->
        				<a class="mg-r-5" href="javascript:editDocument(<%=id_%>);" ><span title="审核" class="icon fa fa-search tx-18" ></span></a>
        		    <%}
                    if(Status22==1&&probstatus==5){%>
                        <a class="mg-r-5" href="javascript:replyDocument(<%=id_%>);" ><span title="回复" class="icon fa fa-envelope-open-o tx-18" ></span></a>
        		        <!-- 结束 -->
        				<a class="mg-r-5" href="javascript:overDocument1(<%=id_%>);" ><span title="结束" class="icon fa fa-retweet tx-18" ></span></a>
        		    <%}
                    }else{%>
        		    <!-- 状态待办理、问题未审核或者状态办理中、问题已回复 -->
        		    <%if((Status22==0&&probstatus==1)||(Status22==0&&probstatus==5)){%>
        		        <!-- 直接回复 已删除-->
        				<!-- <a href="javascript:replyDocument(<%=id_%>);" ><span title="直接回复" class="icon fa fa-envelope-open-o" style="font-size: 24px;"></span></a> -->
        				
        		    <%}%>
        		    <%if(Status22==0&&probstatus==3){%>
        				<a class="mg-r-5" href="javascript:editDocument(<%=id_%>);" ><span title="开始办理" class="icon fa fa-play-circle-o tx-18" ></span></a>
        		    <%}%>
        		    <!-- 状态办理中、问题已办理或者已回复 -->
        		    <%if(Status22==1&&(probstatus==4||probstatus==6)){%>
        		        <!-- 回复 -->
        				<a class="mg-r-5" href="javascript:replyDocument2(<%=id_%>);" ><span title="回复" class="icon fa fa-envelope-open-o tx-18" ></span></a>
        		    <%}%>
                        
                    <%if(Status22==1&&probstatus==6){%>
        		    <!-- 结束 -->
        			<a class="mg-r-5" href="javascript:overDocument1(<%=id_%>);" ><span title="结束" class="icon fa fa-retweet tx-18" ></span></a>
        		    <%}
                    }%>
        		    <!-- 根据权限判断，5或者6分别为平台或者用户可以结束的选项 -->

                    <%if(wenzhengcanDelete&&Status22==2){%>
                    <a class="mg-r-5" href="javascript:deleteFile1(<%=id_%>);" ><span title="删除" class="icon fa fa-trash-o tx-18"></span></a>
                    <%}%>
                    
                    <%}%>
        			</td>
                </tr>
                <%}
                    if(listType==2)
                    {
                        String Photo	= convertNull(Rs.getString("Photo"));
                        String photoAddr = "";
                        if(Photo.startsWith("http://"))
                            photoAddr = Photo;
                        else
                            photoAddr = SiteAddress + Photo;

                        if(m==0) out.println("<tr>");
                        m++;
                %>
                <td id="item_<%=id_%>" status="<%=Status%>" class="tide_item" class="c">
                    <div class="row">
                        <div class="col-md">
                            <div class="card bd-0">
                                <div class="list-pic-box">
                                    <img class="card-img-top" src="<%=photoAddr%>" alt="Image" onerror="checkLoad(this);" >
                                </div>
                                <div class="card-body bd-t-0 rounded-bottom">
                                    <p class="card-text"><%if(IsPhotoNews==1){%><i class="icon ion-image tx-22 tx-warning lh-0 valign-middle"></i><%}%><%=Title%>(<%=StatusDesc%>)</p>
                                    <div class="row mg-l-0 mg-r-0 mg-t-5">
                                        <label class="ckbox mg-b-0 d-inline-block mg-r-5">
                                            <input name="id" value="<%=id_%>" type="checkbox"><span></span>
                                        </label>
                                        <%if(active==0 && userinfo_session.isAdministrator()){%>
                                        <a href="javascript:resume(<%=id_%>);" class="btn pd-0 mg-r-5" title="恢复"><i class="fa fa-reply tx-18 handle-icon" aria-hidden="true"></i></a>
                                        <%}else{
                                        if(wenzhengchannel.hasRight(userinfo_session,1)){%>
                                        <%if((Status22==0)&&probstatus==1){%>
                                            <!-- 审核 -->
                            				<a href="javascript:editDocument(<%=id_%>);" ><span title="审核" class="icon fa fa-search" style="font-size: 18px;"></span></a>
                            		    <%}
                                        if(Status22==1&&probstatus==5){%>
                                            <a href="javascript:replyDocument(<%=id_%>);" ><span title="回复" class="icon fa fa-envelope-open-o" style="font-size: 18px;"></span></a>
                            		        <!-- 结束 -->
                            				<a href="javascript:overDocument1(<%=id_%>);" ><span title="结束" class="icon fa fa-retweet" style="font-size: 18px;"></span></a>
                            		    <%}
                                        }else{%>
                            		    <!-- 状态待办理、问题未审核或者状态办理中、问题已回复 -->
                            		    <%if((Status22==0&&probstatus==1)||(Status22==0&&probstatus==5)){%>
                            		        <!-- 直接回复 已删除-->
                            				<!-- <a href="javascript:replyDocument(<%=id_%>);" ><span title="直接回复" class="icon fa fa-envelope-open-o" style="font-size: 24px;"></span></a> -->
                            				
                            		    <%}%>
                            		    <%if(Status22==0&&probstatus==3){%>
                            				<a href="javascript:editDocument(<%=id_%>);" ><span title="开始办理" class="icon fa fa-play-circle-o" style="font-size: 18px;"></span></a>
                            		    <%}%>
                            		    <!-- 状态办理中、问题已办理或者已回复 -->
                            		    <%if(Status22==1&&(probstatus==4||probstatus==6)){%>
                            		        <!-- 回复 -->
                            				<a href="javascript:replyDocument2(<%=id_%>);" ><span title="回复" class="icon fa fa-envelope-open-o" style="font-size: 18px;"></span></a>
                            		    <%}%>
                                            
                                        <%if(Status22==1&&probstatus==6){%>
                            		    <!-- 结束 -->
                            			<a href="javascript:overDocument1(<%=id_%>);" ><span title="结束" class="icon fa fa-retweet" style="font-size: 18px;"></span></a>
                            		    <%}
                                        }%>
                            		    <!-- 根据权限判断，5或者6分别为平台或者用户可以结束的选项 -->
                    
                                        <%if(wenzhengcanDelete&&Status22==2){%>
                                        <a href="javascript:deleteFile1(<%=id_%>);" ><span title="删除" class="icon fa fa-trash-o" style="font-size: 18px;"></span></a>
                                        <%}%>
                                        
                                        <%}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </td>
                <%
                            if(m==cols){ out.println("</tr>");m=0;}
                        }
                    }
                    if(listType==2 && m<cols) out.println("</tr>");
                    tu.closeRs(Rs);
                %>
                </tbody>
            </table>

            <script>
                var page = {
                    id: '<%=id%>',
                    currPage: '<%=currPage%>',
                    rowsPerPage: '<%=rowsPerPage%>',
                    querystring: '<%=querystring%>',
                    TotalPageNumber: <%=TotalPageNumber%>
                };
            </script>

            <%if(TotalPageNumber>0){%>
            <!--分页-->
            <div id="tide_content_tfoot">
                <label class="ckbox mg-b-0 mg-r-30 ">
                    <input type="checkbox" id="checkAll_1"><span></span>
                </label>
                <span class="mg-r-20 ">共<%=TotalNumber%>条</span>
                <span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

                <%if(TotalPageNumber>1){%>
                <div class="jump_page ">
                    <span class="">跳至:</span>
                    <label class="wd-60 mg-b-0">
                        <input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
                    </label>
                    <span class="">页</span>
                    <a href="javascript:jumpPage();" class="tx-14">Go</a>
                </div>
                <%}%>
                <%if(listType==1){%>
                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="20">20</option>
                        <option value="25">25</option>
                        <option value="30">30</option>
                        <option value="50">50</option>
                        <option value="80">80</option>
                        <option value="100">100</option>
                        <option value="500">500</option>
                        <option value="1000">1000</option>
                        <option value="5000">5000</option>
                    </select>
                    <span class="">条</span>
                </div>
                <%}
                    if(listType==2){%>

                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select name="rows" class="form-control select2 wd-80" data-placeholder="" onChange="changeRowsCols();" id="rows">
                        <option value="3">3</option>
                        <option value="5">5</option>
                        <option value="8">8</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
                    </select>
                    <span class="">行</span>
                    <select name="cols" class="form-control select2 wd-80" data-placeholder="" onChange="changeRowsCols();" id="cols">
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="10">10</option>
                        <option value="16">16</option>
                    </select>
                    <span class="">列</span>
                </div>

                <%}%>
            </div>
            <!--分页-->
            <%}%>
            <div class="table-page-info" style="display: none;">
                <div class="ckbox-parent">
                    <label class="ckbox mg-b-0">
                        <input type="checkbox" id="checkAll"><span></span>
                    </label>
                </div>
            </div>

        </div>
    </div>
    <!--列表-->

    <!--操作-->
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

        <!--<button id="showSubLeft" class="btn btn-secondary mg-r-10 hidden-lg-up"><i class="fa fa-navicon"></i></button>-->

        <!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
            <div class="dropdown-menu pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:list();" class="nav-link list_all">全部</a>
                    
                    <a href="javascript:list('IsDelete=1');" class="nav-link list_delete">已删除</a>
                    <a href="#" class="nav-link">搜索</a>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->
        <div class="btn-group hidden-xs-down">
            <a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
            <a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
        </div>
        <!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-xs-down">
            <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
            <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <%if(canDelete&&(processstate==0||processstate==3)){%>
            <a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>
            <%}%>
        </div>

        <!-- START: 按钮过多时的部分功能下拉 -->
        <div class="dropdown hidden-md-1500-up hidden-sm-down mg-l-10">
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 按钮过多时的部分功能下拉 -->
        <!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->
        <!-- btn-group -->
        <!--<div class="btn-group mg-l-10 hidden-sm-down">-->
        <div class="btn-group mg-l-10">
            <%if(currPage>1){%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
            <%}%>
        </div>
        <!-- btn-group -->
    </div>
    <!--操作-->

    <%}else{%>
    <script>
        var page = {
            id: '<%=id%>',
            currPage: '<%=currPage%>',
            rowsPerPage: '<%=rowsPerPage%>',
            querystring: '<%=querystring%>',
            TotalPageNumber: 0
        };
    </script>
    <%}%>


    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>
    <script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>
    <script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
    <script>
        //==========================================Status2
        //设置高亮
        var Status1_ = <%=Status1%>;
        var Status2_ = <%=Status2%>;
        var IsDelete_ = <%=IsDelete%>;
        $(function() {


            if (Status1_ == -1) {

                $(".list_draft").addClass("active");

            } else if (Status1_ == 1) {

                $(".list_publish").addClass("active");

            } else if (Status2_ == 1) {

                $(".list_calling").addClass("active");

            }   else if (Status2_ == 2) {

                $(".list_called").addClass("active");

            }  else if (Status2_ == 3) {

                $(".list_nocall").addClass("active");

            }else if (IsDelete_ == 1) {

                $(".list_delete").addClass("active");

            } else {
                $(".list_all").addClass("active");
            }
        });



        //===========================================
        $(function() {
            'use strict';

            //show only the icons and hide left menu label by default
            $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

            $(document).on('mouseover', function(e) {
                e.stopPropagation();
                if ($('body').hasClass('collapsed-menu')) {
                    var targ = $(e.target).closest('.br-sideleft').length;
                    if (targ) {
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

            $('#showMailBoxLeft').on('click', function(e) {
                e.preventDefault();
                if ($('body').hasClass('show-mb-left')) {
                    $('body').removeClass('show-mb-left');
                    $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
                } else {
                    $('body').addClass('show-mb-left');
                    $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
                }
            });


            $("#content-table tr:gt(0) td").click(function() {
                var _tr = $(this).parent("tr")
                if(!$("#content-table").hasClass("table-fixed")){
                    if( _tr.find(":checkbox").prop("checked") ){
                        _tr.find(":checkbox").removeAttr("checked");
                        $(this).parent("tr").removeClass("bg-gray-100");
                    }else{
                        _tr.find(":checkbox").prop("checked", true);
                        $(this).parent("tr").addClass("bg-gray-100");
                    }
                }
            });

            $("#checkAll,#checkAll_1").click(function() {
                if($("#content-table").hasClass("table-fixed")){
                    var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
                }else{
                    var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
                }
                var existChecked = false;
                for (var i = 0; i < checkboxAll.length; i++) {
                    if (!checkboxAll.eq(i).prop("checked")) {
                        existChecked = true;
                    }
                }
                if (existChecked) {
                    checkboxAll.prop("checked", true);
                    checkboxAll.parents("tr").addClass("bg-gray-100");
                    $(this).prop("checked", true);
                } else {
                    checkboxAll.removeAttr("checked");
                    checkboxAll.parents("tr").removeClass("bg-gray-100");
                    $(this).prop("checked", false);
                }
                return;
            })
            $(".btn-search").click(function() {
                $(".search-box").toggle(100);
            })
            //表头排序
            $("#content-table").tablesorter({headers: { 0: { sorter: false}}});
            // Datepicker
            tidecms.setDatePicker(".fc-datepicker");

        });

        $(function(){
            $('tbody').on('mousedown','tr td',function(e){

                /*			if($("#content-table").hasClass("table-fixed")){
                                var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
                            }else{
                                var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
                            }
                            checkboxAll.removeAttr("checked");
                            $(this).parent("tr").find("td").find(":checkbox").prop("checked", true);
                            $("tbody tr").removeClass("bg-gray-100");
                            $(this).parent("tr").addClass("bg-gray-100") ;
                */
            })
            var beforeShowFunc = function() {
                //console.log( getActiveNav() )
            };
            var menu = [
                {'<i class="fa fa-edit mg-r-5 fa"></i>查看':function(menuItem,menu) {editDocument1(); }},
                // {'<img src="../images/inner_menu_cache.gif" title="刷新Cache"/>刷新Cache':function(menuItem,menu) {RefreshItem(); }}
            ];
            $('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
        })
        
    </script>

</div>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>

</html>
