<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
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

int ChannelID = id;
int listType = 0;

boolean listAll = false;

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

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

String sys_cloud_source = CmsCache.getParameterValue("sys_cloud_source");

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

int TotalPageNumber  = 0;
int TotalNumber = 0;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/tidecms7.css" type="text/css" rel="stylesheet" />
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
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
if(currRowsPerPage==0){
	currRowsPerPage=20;
}
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var pageName = "<%=pageName%>";
var total=0;
var totalpagenum=0;
if(pageName=="") pageName = "content.jsp";
$(document).ready(function(){
	if(typeof(page)=="object")
	{
		$("#rowsPerPage").val(page.rowsPerPage);
	} 
})
function gopage(currpage)
{
	currPage = currpage;
	loaditems()
	//var url = pageName + "?currPage="+currpage+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
	//this.location = url;
}

function list(str)
{
	var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
	if(typeof(str)!='undefined')
		url += "&" + str;
	this.location = url;
}
var pageNum=1;
var total=0;
var cid =0;
function loaditems()
{
	$("#msg_load").show();
	$.ajax({
	  url: "<%=sys_cloud_source%>getitems.jsp",
	  data:"id=" + ChannelID+"&currPage="+currPage+"&rowsPerPage="+currRowsPerPage+"<%=querystring%>",
	  dataType : "jsonp",
	  type:"get",
	  success: function(o){
		$("#msg_load").hide();
		var items = o.items;
		total = o.total;
		
		var html = "";
		//alert(items.length);
		for(var i = 0;i<items.length;i++)
		  {
			var status_ = "";
			var item = items[i];
			html += '<tr class="tide_item" channelid="'+item.channelid+'" id="item_'+item.id+'" url="'+item.SpiderUrl+'" status="'+item.Status+'"><td class="v1 checkbox" width="25" align="center" valign="middle"><input name="id" value="'+item.id+'" type="checkbox"/></td><td class="v3" style="font-weight:700;" ondragstart="OnDragStart (event)">	<img  src="../images/tree6.png"/>'+item.Title+'</td>';
			html += '<td>'+item.ContentDesc+'</td><td class="v1" align="center" valign="middle">';
			if(item.Status=="0"){
				status_="<font color=red>草稿</font>";
			}else{
				status_="<font color=blue>已发</font>";
			}
			html +=status_+'</td><td class="v8" > '+item.PublishDate+' </td>	<td class="v9"><div class="v9_button" onclick="Preview2(\''+item.SpiderUrl+'\');"><img src="../images/v9_button_2.gif" title="预览" /></div></td>  </tr>';
			//total=item.total;
			cid = item.channelid;
			
		  }
		 totalpagenum = (total%currRowsPerPage)>0 ? (Math.floor(total/currRowsPerPage)+1):Math.floor(total/currRowsPerPage);
		 
		 
		
		 addPages();//加载分页
		 $("#tbody_list").html(html);
		 click_();//加载点击事件
		 $("#rowsPerPage").val(currRowsPerPage);
	  }
	});
}
//单击
function click_(){
	 $("#oTable .tide_item").click(function(e){
		 
			var o = $(this);
			var oo = $(e.target);
			if(o.hasClass("cur"))
				unselectOne(o);
			else
			{
				if(e.target.nodeName!="INPUT" && !oo.hasClass("checkbox")) $("#selectNo").trigger("click");
				selectOne(o);
			}
		});
}

function recommendOut()
{
	var id="";
	var approved = true;
	var fromchannelid=0;
	$("#oTable input:checked").each(function(i){
		if(i==0)
			id+=$(this).val();
		else
			id+=","+$(this).val();
		var status=$("#item_"+$(this).val()).attr("status");
		fromchannelid=$("#item_"+$(this).val()).attr("channelid");
		
		if(status!="1") approved = false;
	});

	var obj=getCheckbox();
	if(id==""){
		alert("请选择要被采用的文档！");
		return;
	}
	
	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(450);
	dialog.setUrl("source/recommend_out_index.jsp?ItemID="+id+"&fromchannelid="
					+fromchannelid+"&SourceChannelID="+ChannelID);
	dialog.setTitle("采用");
	dialog.show();	
}
function Preview()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要预览的文件！");
	}else if(obj.length>1){
		alert("请先选择一个预览的文件！");
	}else{
		//window.console.info(obj.id);
		var trid = "item_"+obj.id;
		var url = $("#"+trid).attr("url");
		Preview2(url);
	}
} 
function Preview2(href){
	window.open(href);
}
function caiyong(){

}

var t;
function refresh()
{
	//window.console.info("refresh "+$("#auto_refresh").attr("checked"));
	clearInterval(t);
	if($("#auto_refresh").attr("checked") == "checked")
	{
		//window.console.info("refresh2");
		var sec = $("#selectTime").val();
		t=setInterval("loaditems()",sec*1000);
	}
}

$(document).ready(function(){
  loaditems();
});
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<span id="msg_load"><font color=red><b>正在加载 ... </b></font></span></div>
    <div class="content_new_post">
		<div class="top_button button_inline_block" onClick="openSearch();">
				<div class="top_button_outer button_inline_block">
					<div class="top_button_inner button_inline_block">
						<span class="img"><img src="../images/icon/preview.png" /></span>
						<span class="txt">检索</span>
					</div>
				</div>	
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
    <td><form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：标题
		  <input name="Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
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
    <input type="submit" name="Submit" class="tidecms_btn3" value="查找"><input type="hidden" name="OpenSearch" id="OpenSearch" value="0"></form></td>
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
<div class="content">
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
               
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
               
                <li class="first"><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:recommendOut();">采用</a></li>
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;自动刷新<input type="checkbox" id="auto_refresh" onClick="refresh();">
				<select id="selectTime" onChange="refresh();">   
				    <option value="5">5</option>
                    <option value="10">10</option>
                    <option value="30">30</option>
                    <option value="60">60</option>
                    <option value="120">120</option>
                    <option value="300">300</option>
                </select>秒</li>
            </ul>
        </div>
		<!-- <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
            <li class="<%=listType==2?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(2);"></li>
        </ul>  -->
       
    </div>
<div class="viewpane">
        <div class="<%=listType==2?"viewpane_pic_list":"viewpane_tbdoy"%>">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr id="oTable_th">
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;">标题</th>
					<th class="v1"	align="center" valign="middle">内容</th>
    				<th class="v1"	align="center" valign="middle">状态</th>
    				<th class="v8"  align="center" valign="middle">日期</th>
    				<th class="v9" width="75" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody id="tbody_list"> 

 </tbody> 
</table>
</div>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:totalpagenum};
function addPages(){
	if(total>0){
		var html2 = "";
		html2+= '<div class="select">选择：<span id="selectAll">全部</span><span id="selectNo">无</span></div>'+
				'<div class="left">共'+total+'条 '+currPage+'/'+totalpagenum+'页    ';
		if(totalpagenum>1){
			html2 += '跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span>';
		}	
		html2 +='</div>';
		if(totalpagenum>1){
			html2 +='<div class="center"><a href="javascript:gopage(1);" title="首页"><img src="../images/viewpane_pages1.png" alt="首页"/></a>';
			if(currPage>1){
				html2 += '<a href="javascript:gopage('+currPage+'-1);" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a>'
			}
			if(currPage<totalpagenum){
				html2 += '<a href="javascript:gopage('+currPage+'+1);" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a>';
			}
			html2 += '<a href="javascript:gopage('+totalpagenum+');" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>';
		}
		 html2 +='<div class="right">'+
            	'<div style="float:left;">每页显示</div>'+
            	'<div class="right_s1">'+
                '<div class="right_s2">'+
            	    '<select name="rowsPerPage" onChange="change(\'#rowsPerPage\','+cid+');" id="rowsPerPage">'+
                    '<option value="10">10</option>'+
                    '<option value="15">15</option>'+
                    '<option value="20">20</option>'+
                    '<option value="25">25</option>'+
                    '<option value="30">30</option>'+
                    '<option value="50">50</option>'+
                    '<option value="80">80</option>'+
                    '<option value="100">100</option>'+
                  '</select>'+
                '</div>'+
                '</div>'+
            	'<div style="float:left;">条</div></div>';
		$(".viewpane_pages").html(html2);+

		jQuery("#goToId").click(function(){
			var num=jQuery("#jumpNum").val();
			if(num==""){
				alert("请输入数字!");
				jQuery("#jumpNum").focus();
				return;
			}
			var reg=/^[0-9]+$/;
			if(!reg.test(num)){
				alert("请输入数字!");
				jQuery("#jumpNum").focus();
				return;
			} 
			
			if(num>totalpagenum)
				num=totalpagenum;
			if(num<1)
				num=1;
			gopage(num);
		});
	}
}
 
 
function change(s,id)
{
	var value=jQuery(s).val();
	var exp = new Date();
	exp.setTime(exp.getTime() + 300*24*60*60*1000);
	document.cookie = "rowsPerPage="+value;
	currRowsPerPage = value;
	loaditems();
	//document.location.href = pageName+"?id="+cid+"&rowsPerPage="+value;
} 
</script>
<div class="viewpane_pages">
	
</div>     
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
                 
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
               
            <!--   <li><a href="javascript:Publish();">发布</a></li> -->  
                <li class="first"><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:recommendOut();">采用</a></li>
				 
            </ul>
        </div>
		<!-- <ul class="toolbar_r">
        	<li class="<%=listType==1?"b1_cur":"b1"%>" title="文字列表" onClick="changeList(1);"></li>
            <li class="<%=listType==2?"b3_cur":"b3"%>" title="图片平铺" onClick="changeList(2);"></li>
        </ul> -->
        
    </div>

</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>

<script type="text/javascript">
jQuery(document).ready(function(){

<%if(listType==2){%>
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
 
  {'<img src="../images/inner_menu_preview.gif" title="预览"/>预览':function(menuItem,menu) {Preview(); }},
  {'<img src="../images/inner_menu_edit.gif" title="采用"/>采用':function(menuItem,menu) {recommendOut(); }}
];
 jQuery('#oTable tr:gt(0)').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
//$("#img_1").draggable({ iframeFix: true } );
</script>
</body>
</html>
