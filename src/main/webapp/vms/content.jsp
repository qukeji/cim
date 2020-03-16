<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
*		修改人		修改时间		备注
*		郭庆光		20130625		添加 从视频库中选择功能。修改弹出层
*       王海龙      20131107        添加转码状态弹出层
*		王海龙      20140219		视频未转码会显示“未转码” 而不是“转码完成” 
*									转码失败用红色字体提示 
*									鼠标移到转码状态列，只有 显示“正在转码”的进度条才会自动更新，转码完成、转码失败、未转码的不会自动更新
*									转码完成自动刷新音频媒资列表页
*		王海龙     20140304			转码状态值（status2）从转码列表读取改为从音视频媒资下读取
*		王海龙     20140424			增加右键排序功能
*		王海龙     20140424         整合音视频媒资下删除同时删除转码后视频，原视频，转码截图功能
*		王海龙     20140525         去除刷新cache功能
**/
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 20;

if(rows==0)
	rows = Util.parseInt(Util.getCookieValue("rows",request.getCookies()));
if(cols==0)
	cols = Util.parseInt(Util.getCookieValue("cols",request.getCookies()));

if(rows==0)
	rows = 10;
if(cols==0)
	cols = 5;

Channel channel = CmsCache.getChannel(id);
if(channel==null || channel.getId()==0)
{
	response.sendRedirect("../content/content_nochannel.jsp");
	return;
}

Channel parentchannel = null;
int ChannelID = channel.getId();
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();
String gids = "";


String S_Title			=	getParameter(request,"Title");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list",request.getCookies()));
if(listType==0) listType =3;
//if(listType==2)//图片列表形式
//	response.sendRedirect("content_image.jsp?id="+id);

boolean listAll = false;

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
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}

boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);
boolean canDelete = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanDelete);
boolean canAdd = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanAdd);
String SiteAddress = channel.getSite().getUrl();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<%if(IsWeight==1){%><script type="text/javascript" src="../common/jquery.jeditable.js"></script><%}%>
<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>

<script>
var listType = <%=listType%>;
var rows = <%=rows%>;
var cols = <%=cols%>;
var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var pageName = "<%=pageName%>";
if(pageName=="") pageName = "content.jsp";


function addDocument()
{	
	var url="document.jsp?ItemID=0&ChannelID=" + ChannelID;
	window.open(url);
}

function editDocument(itemid)
{	
  	var url="document.jsp?ItemID="+itemid+"&ChannelID=" + ChannelID;
  	window.open(url);
}

function gopage(currpage)
{
	var url = pageName + "?currPage="+currpage+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
	this.location = url;
}

function list(str)
{
	var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
	if(typeof(str)!='undefined')
		url += "&" + str;
	this.location = url;
}
function uploadVideo()
{
	var dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(400);
	dialog.setUrl("vms/video_upload.jsp?FolderName=&SiteId=4&ChannelID="+ChannelID);
	dialog.setTitle("上传视频");
	dialog.show();
}

function chooseVideo()
{
	var dialog = new top.TideDialog();
	dialog.setWidth(800);
	dialog.setHeight(500);
	dialog.setScroll("yes");
	dialog.setUrl("vms/file_list_index.jsp?ChannelID="+ChannelID);
	dialog.setTitle("选择视频");
	dialog.show();
}

var progress_ids="";
var progress_ids_="";
var timer = null;
var timer_ = null;
//转码进度
function transcodeProgress(globalid)
{
	var html ='';
	$.ajax({
		url: "displaytranscodeinfo.jsp", 
		data:"globalid="+globalid,
		type:"post",  
		success: function(data)
		{
			 var json = eval(data); 				   
			
			for(i=0;i<json.length;i++)
			{
				var status2 = json[i].status2;
				var itemid = json[i].itemid;
				var progress = json[i].progress;
						
				var description = "";
				if(status2=="2")
					description = "<font color=blue>转码完成</font><font color=blue>("+progress+"%)</font>";
				else if(status2=="3")
					description = "<font color=red>转码失败</font>";
				else if(status2=="0")
					description = "<font color=red>等待分发</font><font color=blue>("+progress+"%)</font>";
				else if(status2=="1")
				{
					progress_ids += (progress_ids==""?"":",") + itemid;
					description = "<font color=red>正在转码</font><font color=blue>("+progress+"%)</font>";
					//if(progress=="100")
					//	document.location.href=document.location.href;
				}
				else if(status2=="4")
					description = "<font color=blue>视频未转码</font>";

				html +='<tr id="item_"+itemid><td class="v1 progress_desc" align="center" valign="middle">'+json[i].type+'</td> <td class="v1 progress_desc" align="center" valign="middle">'+description +'</td></tr>';
		    }
			$("#oTable1 > tbody").html(html);  
	     }
		});	
  if(progress_ids=="")
		clearInterval(timer);
 }

function dispalyInfo(globalid){
	var x,y; 
	var e = e||window.event; 
	x=e.clientX+document.body.scrollLeft+document.documentElement.scrollLeft-200;//200为弹出框的宽度
	y=e.clientY+document.body.scrollTop+document.documentElement.scrollTop;
	var style="position:absolute;left:"+x+"px;top:"+y+"px;width:230px;height:150px;";
	$("#dialog_tips").attr("style",style); 
	timer = setInterval("transcodeProgress("+globalid+")",2000); 
}

function hideInfo()
{
	$("#dialog_tips").attr("style","display:none");
	$("#content").html("");
	 if(timer!=null)clearInterval(timer);
}

function Preview2(id)
{
	tidecms.dialog("vms/video_player_byvideoid.jsp?id="+id+"&channelid="+ChannelID,640,550,"视频预览");
}

//转码成功或失败刷新音视频媒资列表
function refresh()
{
	$.getJSON("video_progress.jsp?id="+progress_ids_+"&ChannelID="+ChannelID, function(data){
			var res = data.status2;
			if(res==2||res==3)
			{ 
				document.location.href=document.location.href;				
			}	
	});
	if(progress_ids_=="")
			clearInterval(timer_);
}

$(function(){	 
	$(".tide_item").each(function(i){
		var s = $(this).attr("status2");		
		if(s=="1")//正在转码		 
		{
			progress_ids_ += (progress_ids_==""?"":",") + $(this).attr("ItemID");
			timer_ = setInterval("refresh()",2000);
		}
	}); 

});

//右键排序
function SortDoc(){
	var myObject = new Object();
	var size = $(".cur").length;
	if(size>1||size<=0){
		alert("请选择一个待排序的选项");
	}else{
    myObject.title="排序";
	myObject.ChannelID =ChannelID;
	myObject.ItemId =$(".cur").attr("ItemID");
	myObject.OrderNumber = $(".cur").attr("OrderNumber");		
 
	var url= "content/document_sort.jsp?ChannelID="+ChannelID+"&ItemID="+myObject.ItemId+"&OrderNumber="+myObject.OrderNumber;
	var	dialog = new top.TideDialog();
		dialog.setWidth(250);
		dialog.setHeight(162);
		dialog.setUrl(url);
		dialog.setTitle(myObject.title);
		dialog.show();
	}
}

//视频相关文件删除
function deleteFile(){
	var obj=getCheckbox();
	var message = "将会删除视频原文件、转码后视频文件、转码截图!\n 确实要删除这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要删除的文件！");
	}else{
		 if(confirm(message)){
			 var url="document_delete.jsp?ItemID=" + obj.id + Parameter;
			  $.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.href=document.location.href;}   
			});  
		}
	}
}

</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%=channel.getName()%>
<%
ArrayList cts = channel.getChannelTemplates(1);//获取配置的索引页列表
if(cts!=null && cts.size()>0)
{
	for(int i = 0;i<cts.size();i++)
	{
		ChannelTemplate ct = (ChannelTemplate)cts.get(i);
		String TargetName = ct.getTargetName();
		int id_ = ct.getId();
		int templateID=ct.getTemplateID();
		TemplateFile tf = CmsCache.getTemplate(templateID);
		%>			
         <a href="<%=Util.ClearPath(SiteAddress+(TargetName.startsWith("/")?"":channel.getFullPath()+"/")+TargetName)%>"
							target="_blank"><span class="font-blue"><%=TargetName%></span></a>  
<%}}%>
	</div>
    <div class="content_new_post" >
		
		<div class="tidecms_btn" onClick="openSearch();">
				<div class="t_btn_pic">
					 <img src="../images/icon/preview.png" /> 
				</div>
				<div class="t_btn_txt">检索</div>			 
		</div>
<!--
		<div class="tidecms_btn" onClick="uploadVideo();">				 
				<div class="t_btn_pic">
					 <img src="../images/icon/add.png" />
				</div>
				<div class="t_btn_txt">上传视频</div>	
		</div>

		<div class="tidecms_btn" onClick="chooseVideo();">				 
				<div class="t_btn_pic">
					 <img src="../images/icon/add.png" />
				</div>
				<div class="t_btn_txt">选择视频</div>	
		</div>
               -->
		
		<%if(canAdd){%>
		<div class="tidecms_btn" onClick="addDocument();">				
				<div class="t_btn_pic">
					<img src="../images/icon/add.png" />
				</div>
				<div class="t_btn_txt">新建</div>
		</div>
		<%}%>
    </div>
</div>
<div class="viewpane_c1" id="SearchArea" style="display:<%=(S_OpenSearch==1?"":"none")%>">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20"> </td>
    <td><form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post">检索：标题
		  <input name="Title" type="text" size="18" class="textfield" value="<%=S_Title%>"  onClick="this.select()">
		  创建日期
		  <select name="CreateDate1" >
		    <option value=">" <%=(S_CreateDate1.equals(">")||S_CreateDate1.equals("")?"selected":"")%>>大于</option>
		    <option value="=" <%=(S_CreateDate1.equals("=")?"selected":"")%>>等于</option>
		    <option value="<" <%=(S_CreateDate1.equals("<")?"selected":"")%>>小于</option>
      </select>
		  <input id="CreateDate" name="CreateDate" type="text" size="10"  class="textfield" value="<%=S_CreateDate%>">		   
		  作者
		  <input name="User" type="text" size="10"  class="textfield" value="<%=S_User%>">
		  状态
		  <select name="Status" >
		    <option value="0" <%=(S_Status==0?"selected":"")%>></option>
		    <option value="2" <%=(S_Status==2?"selected":"")%>>已发</option>
		    <option value="1" <%=(S_Status==1?"selected":"")%>>草稿</option>
      </select>
	<!-- 图片新闻
		  <input type="checkbox" name="IsPhotoNews" value="1" <%=(S_IsPhotoNews==1?"checked":"")%>> -->	
		 包含子频道
		  <input type="checkbox" name="IsIncludeSubChannel" value="1" <%=(S_IsIncludeSubChannel==1?"checked":"")%>> 
    <input type="submit" name="Submit" class="tidecms_btn2" value="查找"><input type="hidden" name="OpenSearch" id="OpenSearch" value="1"></form></td>
    <td width="20"> </td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>

<div class="content_2012">
	<div class="toolbar">
    	<div class="toolbar_l">
        	<span class="toolbar1">显示：</span>
        	<ul class="toolbar3" style="display:none;">
            	<li id="displayOperation">
                	<p><span>全部<img src="../images/toolbar2_list.gif" /></span></p>
                </li>
            </ul>
            <ul class="toolbar2">
                <li class="first"><a href="javascript:list();">全部</a></li>
                <li><a href="javascript:list('Status1=-1');">草稿</a></li>
                <li><a href="javascript:list('Status1=1');">已发</a></li>
                <li class="last"><a href="javascript:list('IsDelete=1');">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">				
                <%if(canApprove){%>
					<li class="first"><a href="javascript:approve();">发布</a></li>
					<li><a href="javascript:Preview();">预览</a></li>
			   <%}else{%>
					<li class="first"><a href="javascript:Preview();">预览</a></li>
			   <%}%>
                <li><a href="javascript:editDocument1();">编辑</a></li>
				 <li><a href="javascript:deleteFile2();">撤稿</a></li>
				<%if(!channel.getRecommendOut().equals("")){%>	
					<li><a href="javascript:recommendOut();">推荐</a></li>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
				<li><a href="javascript:recommendIn();">引用</a></li>
				<%}%>
				<%if(IsWeight!=1){%>
					<li><a href="javascript:sortableEnable();">排序</a></li>
				<%}%>
					<!--
					<li><a href="javascript:RefreshItem();">刷新Cache</a></li>-->
				<%if(canDelete){%>
					<li class="last"><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
				<%}%>
            </ul>
        </div>
        <ul class="toolbar_page">
        	<%if(currPage>1){%><li class="prev" title="上一页" onClick="gopage(<%=currPage-1%>)">上一页</li><%}%>
            <li class="next" title="下一页" onClick="gopage(<%=currPage+1%>)">下一页</li>
        </ul>
        <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
			<li class="<%=listType==2?"b2_cur":"b2"%>" title="图文列表" onClick="changeList(2);"></li>
            <li class="<%=listType==3?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(3);"></li>
        </ul>
    </div>
<div class="viewpane">
<%if(channel.hasRight(userinfo_session,1)){
String listcss = "";
if(listType==1) listcss = "viewpane_tbdoy";
if(listType==2) listcss = "viewpane_pic_txt";
if(listType==3) listcss = "viewpane_pic_list";
	%>
        <div class="<%=listcss%>">
<table width="100%" border="0" id="oTable" class="view_table">
<%if(listType==1){%>
<thead>
		<tr id="oTable_th">
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;">标题</th>
					<%if(IsWeight==1){%>
					<th class="v5" align="center" valign="middle">权重</th>
					<%}%>
					<th class="v1"	align="center" valign="middle">转码状态</th>
    				<th class="v1"	align="center" valign="middle">状态</th>					
    				<th class="v8"  align="center" valign="middle">日 期</th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;">作者</th>
    				<%if(IsComment==1){%>
    				<th class="v7" align="center" valign="middle">评论</th>
    				<%}%>	
    				<%if(IsClick==1){%>
    				<th class="v6" align="center" valign="middle">点击量</th>
    				<%}%>
    				<th class="v9" width="75" align="center" valign="middle">>></th>
  				</tr>
</thead>
<%}%>
 <tbody> 
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

//System.out.println("time:"+weightTime);
String Table = channel.getTableName();
//System.out.println("table11="+Table);
String ListSql = "select Status2,id,Title,Photo,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category";

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

if(!listAll)
{
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
	ListSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
	CountSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
}

String WhereSql = "";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
}
if(!S_CreateDate.equals("")){
	long fromTime=Util.getFromTime(S_CreateDate,"");
	if(S_CreateDate1.equals("=")){
		WhereSql += " and CreateDate>="+fromTime;
		WhereSql += " and CreateDate<"+(fromTime+86400);
	}else{
		WhereSql += " and CreateDate" + S_CreateDate1+fromTime;
	}
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

ListSql += WhereSql;
CountSql += WhereSql;

if(channel.getIsWeight()==1)
{
	ListSql += " order by newtime desc,id desc";
}
else
{
	ListSql += " order by OrderNumber desc";
}

//out.println(ListSql);

int listnum = rowsPerPage;
if(listType==3) listnum = cols*rows;

TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;
int m = 0;

while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int category = Rs.getInt("Category");
	int user = Rs.getInt("User");
	int active = Rs.getInt("Active");
	int Status2=Rs.getInt("Status2");
	String Status2_="";
	if(Status2==2){
		Status2_ = "<font  color=blue>转码完成</font>";
	}else if(Status2==3){
		Status2_ = "<font color=red>转码失败</font>";
	}else if(Status2==0){
		Status2_ = "<font color=red>等待分发</font>";
	}else if(Status2==1){
		Status2_ = "<font color=red>正在转码</font>";
	}else if(Status2==4){
		Status2_ = "<font color=blue>视频未转码</font>";
	}
	
	String Title	= convertNull(Rs.getString("Title"));
	if(listAll)
	{
		if(category>0)
			Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
	}
	int Weight=Rs.getInt("Weight");
	int GlobalID=Rs.getInt("GlobalID");
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

	if(gids.length()>0){gids+=","+GlobalID+"";}else{gids=GlobalID+"";}

	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;
	if(listType==1)
	{
%>
 <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  status="<%=Status%>" status2="<%=Status2%>" GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item">
    <td class="v1 checkbox" width="25" align="center" valign="middle"><input name="id" value="<%=id_%>" type="checkbox"/></td>
    <td class="v3" style="font-weight:700;" ondragstart="OnDragStart (event)" title="位置：<%=channel.getParentChannelPath()%>">
	<img id="img_<%=j%>" src="../images/tree6.png"/><%=Title%></td>
    <%if(IsWeight==1){%><td class="v5" width="43" align="center" valign="middle"><span class="weightClass"  ItemID="<%=id_%>"><%=Weight%></span></td><%}%>
	 <td class="v1" align="center" valign="middle" onmouseover="dispalyInfo(<%=GlobalID%>);" onmouseout="hideInfo();"><%=Status2_%></td> 
 
	<td class="v1" align="center" valign="middle"><%=StatusDesc%></td>
    <td class="v8" > <%=ModifiedDate%></td>
     <td class="v4" style="color:#666666;"><%=UserName%></td>
	 <%if(IsComment==1){%><td class="v7"><span id="comment_<%=GlobalID%>"></span></td><%}%>
	<%if(IsClick==1){%><td class="v6"></td><%}%>
	<td class="v9">
	<%if(active==1 && canApprove){%><div class="v9_button" onclick="approve2(<%=id_%>);"><img src="../images/v9_button_1.gif" title="发布" /></div><%}%>
	<%if(active==0 && userinfo_session.isAdministrator()){%><div class="v9_button" onclick="resume(<%=id_%>);"><img src="../images/icon/16.png" title="恢复" /></div><%}else{%>
    <div class="v9_button" onclick="Preview2(<%=id_%>);"><img src="../images/v9_button_2.gif" title="预览" /></div>
	<div class="v9_button" onclick="Preview3(<%=id_%>);"><img src="../images/preview2.gif" title="正式地址预览" /></div>
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
		String Summary = convertNull(Rs.getString("Summary"));
		if(Summary.length()==0)
		{
			String Content = convertNull(Rs.getString("Content"));
			Summary = Util.substring(Util.removeHtml(Content),156);
		}

		String path = "";
		if(category>0)
			path = CmsCache.getChannel(category).getParentChannelPath();
		else
			path = channel.getParentChannelPath();
		String keyword = convertNull(Rs.getString("Keyword"));
%>
<tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  status="<%=Status%>" GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item">
	<td class="checkbox" width="33" align="center" valign="top"><input name="id" value="<%=id_%>" type="checkbox"/></td>
	<td width="132" valign="top"><div class="vpc_pic"><img type="tide" src="<%=photoAddr%>" /></div></td>
	<td valign="top">
	<div class="vpc_txt">
		<div class="vpc_txt_title"><%=Title%></div>
	    <div class="vpc_txt_info">[目录：<%=path%>] [分类：] [关键词：<%=keyword%>]</div>
	    <div class="vpc_txt_summary">摘要：<%=Summary%></div>
	    <div class="vpc_txt_tools">
	<%if(active==1 && canApprove){%><div class="v9_button" onclick="approve2(<%=id_%>);"><img src="../images/v9_button_1.gif" title="发布" /></div><%}%>
	<%if(active==0 && userinfo_session.isAdministrator()){%><div class="v9_button" onclick="resume(<%=id_%>);"><img src="../images/icon/16.png" title="恢复" /></div><%}else{%>
    <div class="v9_button" onclick="Preview2(<%=id_%>);"><img src="../images/v9_button_2.gif" title="预览" /></div>
	<div class="v9_button" onclick="Preview3(<%=id_%>);"><img src="../images/preview2.gif" title="正式地址预览" /></div>
	<%}%>
		</div>
	</div>
	</td>
</tr>
<%
	}

	if(listType==3)
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
    			<td id="item_<%=id_%>" status="<%=Status%>" class="tide_item" align="center" valign="top" class="c">
                	<div class="pic">
                    	<table border="0" width="100%">
  							<tr>
    							<td align="center" valign="middle"><img type="tide" src="<%=photoAddr%>"/></td>
						  	</tr>
						</table>
                    </div>
                    <div class="txt">
                    	<span class="check"><input name="id" value="<%=id_%>" type="checkbox"/></span>
                        <span class="title"><%=Title%>(<%=StatusDesc%>)</span>
	<br>
	<%if(active==1 && canApprove){%><div class="v9_button" onclick="approve2(<%=id_%>);"><img src="../images/v9_button_1.gif" title="发布" /></div><%}%>
	<%if(active==0 && userinfo_session.isAdministrator()){%><div class="v9_button" onclick="resume(<%=id_%>);"><img src="../images/icon/16.png" title="恢复" /></div><%}else{%>
    <div class="v9_button" onclick="Preview2(<%=id_%>);"><img src="../images/v9_button_2.gif" title="预览" /></div>
	<div class="v9_button" onclick="Preview3(<%=id_%>);"><img src="../images/preview2.gif" title="正式地址预览" /></div>
	<%}%>
                    </div>
                </td>
<%
		if(m==cols){ out.println("</tr>");m=0;}
	}
}

if(listType==3 && m<cols) out.println("</tr>");

tu.closeRs(Rs);
%>
 </tbody> 
</table>
</div>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
</script>        
<%if(TotalPageNumber>0){%> 
        <div class="viewpane_pages">
        	<div class="select">选择：<span id="selectAll">全部</span><span id="selectNo">无</span>			</div>
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="javascript:gopage(1);" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>);" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>);" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="javascript:gopage(<%=TotalPageNumber%>);" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
            <div class="right">
<%if(listType==1){%>
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="rowsPerPage" onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
                    <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="25">25</option>
                    <option value="30">30</option>
                    <option value="50">50</option>
                    <option value="80">80</option>
                    <option value="100">100</option>
                  </select>
                </div>
                </div>
            	<div style="float:left;">条</div>
<%}
if(listType==3){%>
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="rows" onChange="changeRowsCols();" id="rows">
					<option value="3">3</option>
                    <option value="5">5</option>
                    <option value="8">8</option>
                    <option value="10">10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                  </select>
                </div>
                </div>
            	<div style="float:left;">行</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="cols" onChange="changeRowsCols();" id="cols">
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="10">10</option>
                    <option value="16">16</option>
                  </select>
                </div>
                </div>
            	<div style="float:left;">列</div>
<%}%>
            </div>
        </div>
  <%}%>      
  </div>
  
	<div class="toolbar" style="margin:14px 0 0;">
    	<div class="toolbar_l">
        	<span class="toolbar1">显示：</span>
        	<ul class="toolbar3" style="display:none;">
            	<li id="displayOperation">
                	<p><span>全部<img src="../images/toolbar2_list.gif" /></span></p>
                </li>
            </ul>
            <ul class="toolbar2">
                <li class="first"><a href="javascript:list();">全部</a></li>
                <li><a href="javascript:list('Status1=-1');">草稿</a></li>
                <li><a href="javascript:list('Status1=1');">已发</a></li>
                <li class="last"><a href="javascript:list('IsDelete=1');">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
              <%if(canApprove){%>
					<li class="first"><a href="javascript:approve();">发布</a></li>
					<li><a href="javascript:Preview();">预览</a></li>
			   <%}else{%>
					<li class="first"><a href="javascript:Preview();">预览</a></li>
			   <%}%>
                <li><a href="javascript:editDocument1();">编辑</a></li>
				<li><a href="javascript:deleteFile2();">撤稿</a></li>
				<%if(!channel.getRecommendOut().equals("")){%>	
					<li><a href="javascript:recommendOut();">推荐</a></li>
				<%}%>
				<%if(!channel.getAttribute1().equals("")){%>
				<li><a href="javascript:recommendIn();">引用</a></li>
				<%}%>
				<%if(IsWeight!=1){%>
					<li><a href="javascript:sortableEnable();">排序</a></li>
				<%}%>
					<!--<li><a href="javascript:RefreshItem();">刷新Cache</a></li>-->
				<%if(canDelete){%>
					<li class="last"><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
				<%}%>
            </ul>
        </div>
        <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
        	<li class="<%=listType==2?"b2_cur":"b2"%>" title="图文列表" onClick="changeList(2);"></li>
            <li class="<%=listType==3?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(3);"></li>
        </ul>
    </div>

</div>

<%}else{%>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
</script> 
<%}%>
<script type="text/javascript">
jQuery(document).ready(function(){

<%if(listType==2 || listType==3){%>
	$("img[type='tide']").each(function(i){
   autoLoadImage(true,120,120,"",$(this));
 });

$("#rows").val(rows);
$("#cols").val(cols);
<%}%>

<%if(S_OpenSearch!=1){%>
	sortable();
	sortableDisable();
	<%if(sortable==1){%>
		sortableEnable();
	<%}%>
<%}%>

var beforeShowFunc = function() {}
var menu = [
  <%if(canApprove){%>{'<img src="../images/inner_menu_release.gif" title="发布"/>发布':function(menuItem,menu) {approve();} },<%}%>
  {'<img src="../images/inner_menu_preview.gif" title="预览"/>预览':function(menuItem,menu) {Preview(); }},
  {'<img src="../images/inner_menu_edit.gif" title="编辑"/>编辑':function(menuItem,menu) {editDocument1(); }},
  {'<img src="../images/inner_menu_recall.gif" title="撤稿"/>撤稿':function(menuItem,menu) {deleteFile2(); }},
	<%if(!channel.getRecommendOut().equals("")){%>{'<img src="../images/inner_menu_recommend.gif" title="推荐"/>推荐':function(menuItem,menu) {recommendOut();}},<%}%>
	<%if(!channel.getAttribute1().equals("")){%>{'<img src="../images/inner_menu_quote.gif" title="引用"/>引用':function(menuItem,menu) {recommendIn();}},<%}%>
	<%if(IsWeight!=1){%>{'<img src="../images/inner_menu_taxis.gif" title="排序"/>排序':function(menuItem,menu) {SortDoc(); }}<%}%>
 // {'<img src="../images/inner_menu_cache.gif" title="刷新Cache"/>刷新Cache':function(menuItem,menu) {RefreshItem(); }},
 <%if(canDelete){%>
	 ,{'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile();}}
<%}%>
];
//$(document).bind("contextmenu",function(){return false;});
$('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
 <%if(IsWeight==1){%>WeightAddColor();<%} if(IsComment==1) out.println("showCommentCount('"+gids+"');");%>
});
//$("#img_1").draggable({ iframeFix: true } );
</script>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<!-- 弹出提示开始 -->
<div class="dialog_tips" id="dialog_tips" style="display:none;">
	<i class="d_tips_arrow"></i>
	<div class="d_tips_top"><i class="t_l"></i><i class="t_c"></i><i class="t_r"></i></div>
	<div class="d_tips_mid">
		<i class="m_l"></i>
		<div class="m_c">
		<!-- 弹出提示内容开始 -->
			<p class="" id="content" >
				<table width="100%" border="0" id="oTable1" class="view_table" >
					<thead><tr><th class="v1" align="center" valign="middle">视频类型</th> <th class="v1" align="center" valign="middle">转码状态</th></tr></thead>
					<tbody></tbody>
				</table>
           </p>
			<p></p>
		<!-- 弹出提示内容结束 -->
		</div>
		<i class="m_r"></i>
	</div>
	<div class="d_tips_bot"><i class="b_l"></i><i class="b_c"></i><i class="b_r"></i></div>
	<!--弹出提示结束-->
</div>
</body>
</html>
