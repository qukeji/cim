<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.report.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		type	= getIntParameter(request,"type");
long begin_time = System.currentTimeMillis();
int id = Util.getIntParameter(request,"id");
if(id==0){
	id=12935;
}
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
Channel parentchannel = null;
int ChannelID = channel.getId();
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();

boolean listAll = false;

if(channel.isTableChannel() && channel.getType2()==8) listAll = true;

String S_Title			=	getParameter(request,"Title");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&type="+type;

String uri=request.getRequestURI();
String path=request.getContextPath();
int Status1			=	getIntParameter(request,"Status1");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="<%=path%>/style/tidecms7.css" type="text/css" rel="stylesheet" />
<link href="../style/flora.datepicker.css" type="text/css" rel="stylesheet" />
<style>
html,body{height:100%;}
</style>
<script type="text/javascript" src="<%=path%>/common/common.js"></script>
<script type="text/javascript" src="<%=path%>/common/jquery.js"></script>
<script type="text/javascript" src="../common/ui.datepicker.js"></script>
<script>
var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
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
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"   scrolling="auto">
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%=channel.getName()%></div>
    <div class="content_new_post">
		<div class="top_button button_inline_block">
			<a href="javascript:openSearch();" style="display:inline;">
				<div class="top_button_outer button_inline_block">
					<div class="top_button_inner button_inline_block">
						<span class="img"><img src="../images/icon/preview.png" /></span>
						<span class="txt">检索</span>
					</div>
				</div>
			</a>
		</div>
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
    <td width="20">&nbsp;</td>
    <td><form name="search_form" action="<%=uri%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：标题
		  <input name="Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
		  创建日期
		  <select name="CreateDate1" >
		    <option value=">" <%=(S_CreateDate1.equals(">")||S_CreateDate1.equals("")?"selected":"")%>>大于</option>
		    <option value="=" <%=(S_CreateDate1.equals("=")?"selected":"")%>>等于</option>
		    <option value="<" <%=(S_CreateDate1.equals("<")?"selected":"")%>>小于</option>
      </select>
		  <input name="CreateDate" type="text" size="10"  class="textfield" value="<%=S_CreateDate%>" id="CreateDate">
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
    <input type="submit" name="Submit" class="tidecms_btn3" value="查找"><input type="hidden" name="OpenSearch" id="OpenSearch" value="0">
	<input type="hidden" name="type" id="type" value="<%=type%>">
	</form></td>
    <td width="20">&nbsp;</td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>

<div class="content" style="padding:0;border:none;">
  	<div class="viewpane" style="margin:0;">
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;">标题</th>
    	
    				<th class="v9" width="70" align="center" valign="middle">>></th>
  				</tr>
</thead>
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
String ListSql = "select id,Title,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Category,User";

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
if(!S_CreateDate.equals("")){
	Report report=new Report();
	report.setStartDate(S_CreateDate);
	report.setStartTime("00:00");
	long fromTime=report.getFromTime();
	if(S_CreateDate1.equals("=")){
		WhereSql += " and CreateDate>="+fromTime;
		WhereSql += " and CreateDate<"+(fromTime+86400);
	}else{
		WhereSql += " and CreateDate" + S_CreateDate1+fromTime;
	}
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
//out.println(ListSql);
//System.out.println("id:"+channel.getId());
TableUtil tu = new TableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
 TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;

while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int category = Rs.getInt("Category");
	int user = Rs.getInt("User");
	String Title	= convertNull(Rs.getString("Title"));

	String videoid="";
	String contentid="";
	String catalogcode="";
	String itemid="";
	String coverhref="";
	
	

	if(listAll)
	{
		if(category>0)
			Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
	}
	int Weight=Rs.getInt("Weight");
	int GlobalID=Rs.getInt("GlobalID");
//System.out.println("GlobalID:"+GlobalID);//  取到了
	Document docc = CmsCache.getDocument(GlobalID);
	ArrayList docs = docc.listChildItems(5611);
	String flvurl = "";
	//System.out.println(GlobalID+"size:"+docs.size());
	for(int i = 0;i<docs.size();i++)
	{
		Document d = (Document)docs.get(i);

		flvurl = Util.ClearPath(d.getValue("video_dest"));
		//System.out.println("-----flvurl---16--"+flvurl+"Title:"+Title);//没取到
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
    <td class="v1" width="25" align="center" valign="middle"><input name="id" value="<%=videoid%>" type="radio" category="<%=category%>"  contentid="<%=contentid%>" catalogcode="<%=catalogcode%>" itemid="<%=itemid%>" id_="<%=flvurl%>" coverhref="<%=coverhref%>"/></td>
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png"/><%=Title%></td>
	<td class="v9">
    <div class="v9_button" onclick="Preview2(<%=id_%>,'<%=category%>');"><img src="../images/v9_button_2.gif" title="预览" /></div>
	<div class="v9_button" onclick="Preview3(<%=id_%>,'<%=category%>');"><img src="../images/preview2.gif" title="正式地址预览" /></div>
	</td>
  </tr>
  <%}
tu.closeRs(Rs);
%>
 </tbody> 
</table>
<div style="position:absolute;right:0;top:120px;display:none;"  id="jTipId">
        <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
                <li  class="first"><a href="javascript:approve();">发布</a></li>
                <!--<li><a href="javascript:Publish();">发布</a></li>-->
                <li><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:editDocument1();">编辑</a></li>
                <li class="last list" id="otherOperation2">
                	<p>其他<img src="../images/toolbar2_list.gif" /></p>
                    <ul id="ul1" style="display:none;">
                    	<li onclick="deleteFile2();">撤稿</li>
						<%if(!channel.getRecommendOut().equals("")){%>	
						<li onClick="recommendOut();">推荐</li>
						<%}%>
						<%if(!channel.getAttribute1().equals("")){%>
						<li onClick="recommendIn();">引用</li>
						<%}%>
						<%if(IsWeight!=1){%>
						<li onClick="sortableEnable();">排序</li>
						<%}%>
						<li onClick="RefreshItem();">刷新Cache</li>
						<!--<li class="list_no">复制</li>
						<li class="list_no">移动</li>-->
						<li onclick="deleteFile();"><font style="color:red;">删除</font></li>
                       
                    </ul>
                </li>
            </ul>
    	</div>

        </div>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
</script>        
<%if(TotalPageNumber>0){%> 
        <div class="viewpane_pages">
        	<div class="left" style="left:20px;">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center" style="margin:0 0 0 230px;"><a href="<%=uri%>?currPage=1&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="<%=uri%>?currPage=<%=currPage-1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="<%=uri%>?currPage=<%=currPage+1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="<%=uri%>?currPage=<%=TotalPageNumber%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
            <div class="right">
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
            </div>
        </div>
  <%}%>      
  </div>

</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
<%if(type==2){%>
<div class="form_button">
	<input type="button" onclick="ok();" id="startButton" value="确定" class="button" name="startButton"/>
	<input type="button" onclick="top.getDialog().Close();" id="btnCancel1" value="取消" class="button" name="btnCancel1"/>
</div>
<%}%>
<script>

jQuery("#rowsPerPage").val(<%=rowsPerPage%>);
datepicker("CreateDate");

function Preview2(id,ChannelID)
{
		// window.open("../util/showvideo.jsp?ItemID=" + id + Parameter);
		window.open("../util/showvideo.jsp?ItemID=" + id + "&ChannelID="+ChannelID);
}

function Preview3(id,ChannelID)
{
		window.open("../util/showvideo.jsp?ItemID=" + id + "&ChannelID="+ChannelID);
		// window.open("../util/showvideo.jsp?ItemID=" + id + Parameter);
}



function double_click()
{
	jQuery("#oTable tr:gt(0)").dblclick(function(){
		ok();
	});
	
}

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

jQuery("#goToId").click(function(){
		goToPage();
});


function getRadio()
{
	var id_ = "";
	jQuery("#oTable input:checked").each(function(i){
			id_=jQuery(this).attr("id_");
	});
	//alert(id_);
	return id_;
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
			id_=jQuery(this).attr("id_");
			coverhref=jQuery(this).attr("coverhref");
	});
	if(category=="4373"){
		html='<script type="text/javascript">var _setVideoID="'+contentid+'";var _setCatalogCode="'+catalogcode+'";';
		html+='var _setAutoPlay="false";<\/script>';
		html+='<script type="text/javascript" ';
		html+='src="http://www.vodone.com/js/player/showConetntPlayer.js" charset="utf-8"><\/script>';
	}else if(category=="5017"){
		html='<object width="480" height="420">\
		<param name="movie" value="http://club.vodone.com/images/flashplayer/vodoneplayer.swf?site=http://club.vodone.com&vid=06IKIIMKJGQIGGPGLHPHGGIGH&itemid='+itemid+'"></param>\
<param name="wmode" value="transparent"></param>\
<param name="allowScriptAccess" value="always"></param>\
<embed src="http://club.vodone.com/images/flashplayer/vodoneplayer.swf?site=http://club.vodone.com&vid=06IKIIMKJGQIGGPGLHPHGGIGH&itemid='+itemid+'" type="application/x-shockwave-flash" wmode="transparent" allowFullScreen="true" allowScriptAccess="always" quality="high" width="480" height="420"></embed>\
</object>';
	}else if(category==6651){
		html='<script>var video_contentid ="'+id+'";<\/script>';
		html+='<script src="http://uflv.vodone.com/qinglv/video_r.js"><\/script>';
	}else{
		html='<script type="text/javascript" src="http://www.vodone.com/player/cmsVodone/videoPlayer.js"><\/script><script>writeAlbumHtml({id:"'+id_+'"});<\/script>';
	}
	var obj={html:html,length:jQuery("#oTable input:checked").length,coverhref:coverhref,type:'<%=type%>'};
	return obj;
}
</script>
</body>
</html>