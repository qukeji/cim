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
int id = Util.getIntParameter(request,"id");
int currPage = Util.getIntParameter(request,"currPage");
int rowsPerPage = Util.getIntParameter(request,"rowsPerPage");
int	vstatus=	 Util.getIntParameter(request,"vstatus");
String sortable = Util.getParameter(request,"sortable");
if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 20;

Channel channel = CmsCache.getChannel(id);
Channel parentchannel = null;
int ChannelID = channel.getId();
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();

boolean listAll = false;

if(channel.isTableChannel() && channel.getType2()==8) listAll = true;

if(channel.getType()==2)
{
	response.sendRedirect("page_info.jsp?id="+id);
	return;
}


//如果是“新建应用”；
if(channel.getType()==3)
{
	response.sendRedirect("app.jsp?id="+id);
	return;
}

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
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&vstatus="+vstatus;

int Status1			=	getIntParameter(request,"Status1");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms7.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<script type="text/javascript" src="../common/jquery.jeditable.js"></script>
<script>
function Drag(){
	window.event.dataTransfer.setData("Text","");
	if (window.event.shiftKey==true){
		event.dataTransfer.effectAllowed="move";
		}
	else{
		event.dataTransfer.effectAllowed="copy";
		}
}



function selectdate(fieldname){
	var args="font-size:10px;dialogWidth:286px;dialogHeight:290px;center:yes;status:no;help:no";
	var Feature=new Array();
	var selectdate=window.showModalDialog("selectdate.htm",Feature,args);
	//alert(document.all(fieldname));
	if (selectdate!=null)
	{
		if(document.all(fieldname).value!="")
		{
			arrayOfStrings = document.all(fieldname).value.split(" ");
			if(arrayOfStrings.length==1)
				document.all(fieldname).value = selectdate;
			else
				document.all(fieldname).value = selectdate + " " + arrayOfStrings[1];
		}
		else
			document.all(fieldname).value=selectdate;
	}
}


function openSearch()
{
	jQuery("#SearchArea").toggle();
}



function getGlobalID(){
	var id="";
	jQuery("#oTable input:checked").each(function(i){
		var obj=jQuery(this).parent().parent();
		if(i==0)
			id+=jQuery(obj).attr("GlobalID");
		else
			id+=","+jQuery(obj).attr("GlobalID");
	});
	var obj={length:jQuery("#oTable input:checked").length,id:id};
	return obj;
}

function  RefreshItem(){
	var obj=getGlobalID();
	if(obj.length==0){
		alert("请先选择要刷新的文件！");
		return;
	}
	
	if(obj.length>1){
		alert("请先选择一个刷新的文件！");
		return;
	}

	jQuery.ajax({
	 type: "POST",
	 url: "refresh_item.jsp",
	 data: "GlobalID="+obj.id,
	 error:function(){alert("刷新失败!");},
	 success: function(msg){
		alert("刷新成功!");
	 } 
	});
	
}



function Preview2(id)
{
		 window.open("../content/document_preview.jsp?ItemID=" + id + Parameter);
}

function Preview3(id)
{
		 window.open("../content/document_preview2.jsp?ItemID=" + id + Parameter);
}



function Publish(){
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要发布的文档！");
		return;
	}

	var message = "确实要发布这"+obj.length+"项吗？";
	if(!confirm(message))
	{
				return;
	}
	 document.location.href = "../content/document_publish.jsp?ItemID=" + obj.id + Parameter;
	
}



function addDocument()
{
	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .85 );
	var leftm  = Math.floor( screen.width  * .1);
	var topm   = Math.floor( screen.height * .05);
	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
	var url="../content/document.jsp?ItemID=0&ChannelID=" + ChannelID;
	window.open(url,"",Feature);
}


function sortable(){
	jQuery("#oTable").sortable({items:"tr:gt(0)",axis:"y",cursor:"move",
		start:function(e,ui){
			var $p=jQuery(ui.placeholder);
			$p.css({visibility:'visible',height:'20px'});
			$p.html('<td colspan="7">&nbsp;&nbsp;&nbsp;</td>');
			},
		stop:function(e,ui){
			},
		update:function(e,ui){
			var ItemID=ui.item.attr("ItemID");
			var OrderNumber=parseInt(ui.item.attr("OrderNumber"));
			var OrderNumber_next=parseInt(ui.item.next().attr("OrderNumber"));
			var OrderNumber_prev=parseInt(ui.item.prev().attr("OrderNumber"));
			var Direction=0;
			var Number=0;
			//alert(OrderNumber+":"+OrderNumber_next+":"+OrderNumber_prev);
			if(OrderNumber!=OrderNumber_next){
				if((OrderNumber-OrderNumber_next)>0){
					Direction=0;
					Number=OrderNumber-OrderNumber_next;
					Number=Number-1;
				}else{
					Direction=1;
					Number=OrderNumber_next-OrderNumber;					
				}
			}else{
				if((OrderNumber-OrderNumber_prev)>0){
					Direction=0;
					Number=OrderNumber-OrderNumber_prev;
				}else{
					Direction=1;
					Number=OrderNumber_prev-OrderNumber;
				}
			}
			var url="document_operation.jsp";
			var url_Refresh="content.jsp?currPage="+page.currPage+"&id="+page.id+"&rowsPerPage="+page.rowsPerPage+page.querystring+"&sortable=enable";	
			var data="Action=Order&ChannelID="+ChannelID+"&ItemID="+ItemID;
				data+="&Direction="+Direction+"&Number="+Number;		
			jQuery.ajax({
				type: "GET",
				url: url,
				async:false,
				data: data,
				error: function(){},
				beforeSend:function(){},
				complete:function(){},
				success: function(msg){
					jQuery("#loadding").html("");
					if(jQuery.trim(msg)=="Refresh"){
						document.location=url_Refresh;
					}
				}
	 		});	
	}});
	
}

function sortableEnable(){
	jQuery("#oTable").sortable("enable");
}

function sortableDisable(){
	jQuery("#oTable").sortable("disable");
}
/**改变每页显示*/
function change(s,id)
{
	var value=jQuery(s).val();
	var exp  = new Date();
	exp.setTime(exp.getTime() + 300*24*60*60*1000);
	document.cookie = "rowsPerPage="+value;
	document.location.href = "club_content.jsp?id="+id+"&rowsPerPage="+value;
}

function editDocument(itemid)
{
	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .8 );
	var leftm  = Math.floor( screen.width  * .1)+30;
	var topm   = Math.floor( screen.height * .05)+30;
 	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  	var url="../content/document.jsp?ItemID="+itemid+"&ChannelID=" + ChannelID;
  	window.open(url,"",Feature);
}

function editDocument1()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要编辑的文件！");
	}else if(obj.length>1){
		alert("请先选择一个要编辑的文件！");
	}else{
		  editDocument(obj.id);
	}
}


function double_click()
{
	jQuery("#oTable tr:gt(0)").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		obj.trigger("click");
		editDocument(obj.val());
	});
	
}


/**操作**/
function operation(page,obj){
	
}
/***/
function otherOperation(o){
	jQuery(o.id).click(function(evt){
		jQuery(o.showid).toggle();
		//window.event.cancelBubble = true;
		if (!evt)
			window.event.cancelBubble = true;
		else
			evt.stopPropagation();
	});
}


function closeDiv()
{
	jQuery('#otherOperation ul').hide();
	jQuery('#otherOperation2 ul').hide();
	jQuery('#otherOperation3 ul').hide();
	jQuery('#displayOperation ul').hide();
}

function getAbsoluteTop(objectId) {
	o = document.getElementById(objectId)
	oTop = o.offsetTop;
	var i=0;
	while(o.offsetParent!=null) { 
		if(i<1){
		oParent = o.offsetParent;
		oTop += oParent.offsetTop;
		o = oParent;
		i++;
		}else{
		break;
		}
	}
	return oTop+3;
}
/******修改权重******/
function UpdateWeight(){
	 jQuery(".weightClass").each(function(){
		 var selfObj=this;
		 var url="update_weight.jsp?Action=setWeight&ChannelID="+page.id+"&ItemID="+jQuery(selfObj).attr("ItemID");
		 jQuery(selfObj).editable(url, {
		  name:'weight', 	
		  style:'inherit',
		 width:'22px',
		 refresh:true,
		 onblur:'submit',	  
		  data: function(value, settings) {
		  var retval = value.replace(/<br[\s\/]?>/gi, '\n');
		  return retval;
		  },
		  onsubmit:function(settings,self){
			var obj=jQuery('input',self);
			var value=jQuery(obj).val();
			var reg=/^[0-9]+$/;
			var revert=jQuery.trim(self.revert);
			if(revert==value){
				jQuery(self).html(revert);
				self.editing   = false;
				return false;
			}else if(reg.test(value)){
				return true;
			}else{
				jQuery(self).html(revert);
				self.editing   = false;
				alert("权重必须是数字!");
				return false;
			}
		 }
	  });
	 
	 });
	
}

function Lfill0(num){
	return (num>9?num:"0"+num);
}

/******权重加颜色******/
function WeightAddColor(){
	var date = new Date();
	var day = Lfill0(date.getDate());
	var month =Lfill0(date.getMonth()+1);
	var year = date.getFullYear();
	var text=month+"-"+day;
	jQuery("#oTable tr:contains('"+text+"')").each(function(){
		var cur=jQuery(this);
		jQuery(".weightClass",cur).css("color","blue");
	});
}
jQuery(document).ready(function() {
	document.onclick=closeDiv;
	/**给行加当前样式***/
	UpdateWeight();//修改权重
	jQuery(":checkbox",jQuery("#oTable")).click(function(){
		closeDiv();
		var obj=jQuery(this).parent().parent();
		obj.toggleClass("cur");
	});

	jQuery("#oTable td:has(img)").click(function(){
		closeDiv();
		jQuery("#selectNo").trigger("click");
		var obj=jQuery(this).parent();
		var obj2=jQuery(":checkbox",jQuery(obj));
		obj2.trigger("click");
	});

	jQuery("#selectAll").click(function(){
		jQuery("#oTable tr").addClass("cur");
		var obj=jQuery(":checkbox",jQuery("#oTable"));
		obj.attr("checked","checked");
	});

	jQuery("#selectNo").click(function(){
		jQuery("#oTable tr").removeClass("cur");
		var obj=jQuery(":checkbox",jQuery("#oTable"));
		obj.removeAttr("checked","checked");
		jQuery("#jTipId").hide();
	});

	jQuery("#goToId").click(function(){
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

		if(num>page.TotalPageNumber)
			num=page.TotalPageNumber;
		if(num<1)
			num=1;
		var href="content.jsp?currPage="+num+"&id="+page.id+"&rowsPerPage="+page.rowsPerPage+page.querystring;
		document.location.href=href;
	});
	double_click();
	jQuery("#oTable").tablesorter({headers: { 0: { sorter: false}}});

});

function recommendOut()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择要推荐出去的文档！");
		return;
	}
	
	if(obj.length>1){
		alert("请选择一个要推荐出去的文档！");
		return;
	}

    var text=jQuery("#oTable tr.cur").text();
	
	if(text.indexOf('草稿')!=-1){
		alert("请发布后再推荐!");
		return;
	}

		  //alert(obj.id);
		  	var myObject = new Object();
			myObject.title = "推荐";
			var Feature = "dialogWidth:52em; dialogHeight:24em;center:yes;status:no;help:no";
			var retu = window.showModalDialog
			("../modal_dialog.jsp?target=content/recommend_out.jsp&ItemID="+obj.id + "&ChannelID="+ChannelID,myObject,Feature);
}

function recommendIn()
{
		  	var myObject = new Object();
			myObject.title = "选择推荐条目";
			myObject.ChannelID =page.id;

			var width  = Math.floor( screen.width  * .8 );
			var height = Math.floor( screen.height * .85 );
			var leftm  = Math.floor( screen.width  * .1);
			var topm   = Math.floor( screen.height * .05);
			var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height=" + height;
			var url="../content/recommend_item.jsp?ChannelID=" + myObject.ChannelID;
			window.open(url,"",Feature);
	
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script>
var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
</script>
<style>
.viewpane_tbdoy tbody td{border-bottom:2px solid #EEEEEE;}
</style>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%=channel.getName()%></div>
    <div class="content_new_post">
		<div class="top_button button_inline_block">
			<a href="javascript:openSearch();">
				<div class="top_button_outer button_inline_block">
					<div class="top_button_inner button_inline_block">
						<span class="img"><img src="../images/icon/preview.png" /></span>
						<span class="txt">检索</span>
					</div>
				</div>
			</a>
		</div>
	<div class="top_button button_inline_block">
			<a href="javascript:addDocument();">
				<div class="top_button_outer button_inline_block">
					<div class="top_button_inner button_inline_block">
						<span class="img"><img src="../images/icon/add.png" /></span>
						<span class="txt">新建</span>
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
    <td><form name="search_form" action="club_content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：标题
		  <input name="Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
		  创建日期
		  <select name="CreateDate1" >
		    <option value=">" <%=(S_CreateDate1.equals(">")||S_CreateDate1.equals("")?"selected":"")%>>大于</option>
		    <option value="=" <%=(S_CreateDate1.equals("=")?"selected":"")%>>等于</option>
		    <option value="<" <%=(S_CreateDate1.equals("<")?"selected":"")%>>小于</option>
      </select>
		  <input name="CreateDate" type="text" size="10"  class="textfield" value="<%=S_CreateDate%>"><img align="absmiddle" src="../images/icon/26.png" onclick="selectdate('CreateDate');">
		   
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
                    <ul style="display:none;">
                    	<li><a href="club_content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>">全部</a></li>
                    	<li><a href="club_content.jsp?id=<%=id%>&Status1=-1&rowsPerPage=<%=rowsPerPage%>">草稿 
</a></li>
                        <li><a href="club_content.jsp?id=<%=id%>&Status1=1&rowsPerPage=<%=rowsPerPage%>">已发</a></li>
                        <li><a href="club_content.jsp?id=<%=id%>&IsDelete=1&rowsPerPage=<%=rowsPerPage%>">已删除</a></li>
                    </ul>
                </li>
            </ul>
            <ul class="toolbar2">
            	<li class="first"><a href="club_content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>">全部</a></li>
				<li><a href="club_content.jsp?id=<%=id%>&vstatus=2&rowsPerPage=<%=rowsPerPage%>">处理中</a></li>
				<li><a href="club_content.jsp?id=<%=id%>&vstatus=3&rowsPerPage=<%=rowsPerPage%>">处理完成</a></li>
                <li><a href="club_content.jsp?id=<%=id%>&Status1=-1&rowsPerPage=<%=rowsPerPage%>">草稿</a></li>
                <li><a href="club_content.jsp?id=<%=id%>&Status1=1&rowsPerPage=<%=rowsPerPage%>">已发</a></li>
                <li class="last"><a href="club_content.jsp?id=<%=id%>&IsDelete=1&rowsPerPage=<%=rowsPerPage%>">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
                <li  class="first"><a href="javascript:approve();">发布</a></li>
            <!--   <li><a href="javascript:Publish();">发布</a></li> -->  
                <li><a href="javascript:Preview();">预览</a></li>
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
					<li><a href="javascript:RefreshItem();">刷新Cache</a></li>
						<!--<li class="list_no">复制</li>
						<li class="list_no">移动</li>-->
					<li><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
                <li class="last list" id="otherOperation"  style="display:none;">
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
        <ul class="toolbar_r">
        	<li class="b1_cur" title="竖排"></li>
            <li class="b2" title="竖排"></li>
            <li class="b3" title="竖排"></li>
        </ul>
    </div>
  	<div class="viewpane">
<%if(channel.hasRight(userinfo_session,1)){%>
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable">
<thead>
		<tr>
   				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    			<th class="v3"></th>
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
String ListSql = "select id,Title,Weight,Summary,vid,aid,videostatus,Username,piccount,filepath,itemid,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Category,User";

if(channel.getIsWeight()==1)
	ListSql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
ListSql += " from " + Table;
String CountSql = "select count(*) from "+Table;

//if(!S_User.equals(""))
	//CountSql = "select count(*) from "+Table+" ";

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
	long fromTime=Util.getFromTime(S_CreateDate,"");
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

if(vstatus!=0){
	if(vstatus==2){
		WhereSql += " and videostatus like '%" + channel.SQLQuote("处理中") + "%'";
	}else if(vstatus==3){
		WhereSql += " and videostatus like '%" + channel.SQLQuote("处理完成") + "%'";
	}
}
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
System.out.println("id:"+channel.getId());
TableUtil tu = new TableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
int j = 0;

while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int category = Rs.getInt("Category");
	int user = Rs.getInt("User");
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
	String	vid=convertNull(Rs.getString("vid")); 
	String	aid=convertNull(Rs.getString("aid")); 
	String	videostatus=convertNull(Rs.getString("videostatus"));
	String	filepath=convertNull(Rs.getString("filepath")); 
	String	itemid=convertNull(Rs.getString("itemid")); 
	
	String	Username2=convertNull(Rs.getString("Username"));
	String	piccount=convertNull(Rs.getString("piccount"));
	int count=0;
	if(!piccount.equals("")){
		count=Integer.parseInt(piccount);
	}
	String	Summary=convertNull(Rs.getString("Summary"));
	if(videostatus.equals("")){
	videostatus="正在处理";
	}
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
  <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  GlobalID="<%=GlobalID%>" id="jTip<%=j%>_id">
    <td class="v1" width="25" align="center" valign="middle"><input name="id" aid="<%=aid%>" itemid2="<%=itemid%>" value="<%=id_%>" type="checkbox" vid="<%=vid%>" Status="<%=Status%>" filepath="<%=filepath%>"/></td>
       <td class="v3" style="font-weight:700;">
<style>
.vlog tbody td{border:none;}

</style>
		<table width="100%" cellspacing="4" cellpadding="0" border="0" class="vlog">
          <tr>
            <td valign="top">
			<a target="_blank" href="show_club_pic.jsp?vid=<%=vid%>&piccount=<%=piccount%>">
<%for(int c=1;c<=6&&c<=count;c++){%>
<img height="74" width="100" border="0" src="http://clubpic.vodone.com/ssvideo/thumb/<%=vid%>/<%=c%>_s.jpg"/>
<%}%>
 </a><br/>            </td>
          <tr>
            <td><img src="../images/tree6.png" ondragstart="Drag()"/>标题：<span id="Title1"><%=Title%></span></td>
          </tr>
          <tr>
            <td>审核状态：<%=StatusDesc%>&nbsp;&nbsp;视频处理状态:<%=videostatus%></td>
          </tr>
          <tr>
            <td>上传时间：<%=ModifiedDate%>&nbsp;&nbsp;上传者:<%=Username2%></td>
          </tr>
        </table></td>
	<td class="v9">
	<div class="v9_button" onclick="approve2(<%=id_%>,'<%=aid%>-<%=itemid%>');"><img src="../images/v9_button_1.gif" title="发布" /></div>
    <div class="v9_button" onclick="Preview_club('<%=Status%>','<%=vid%>','<%=itemid%>','<%=filepath%>');"><img src="../images/v9_button_2.gif" title="预览" /></div>
	<div class="v9_button" onclick="Preview_club2('<%=Status%>','<%=vid%>','<%=itemid%>','<%=filepath%>');"><img src="../images/preview2.gif" title="正式地址预览" /></div>
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
        	<div class="select">选择：<span id="selectAll">全部</span><span id="selectNo">无</span>			</div>
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="club_content.jsp?currPage=1&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="club_content.jsp?currPage=<%=currPage-1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="club_content.jsp?currPage=<%=currPage+1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="club_content.jsp?currPage=<%=TotalPageNumber%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
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
  
<div class="toolbar" style="margin:14px 0 0;">
    	<div class="toolbar_l">
        	<span class="toolbar1">显示：</span>
        	<ul class="toolbar3" style="display:none;">
            	<li id="displayOperation">
                	<p><span>全部<img src="../images/toolbar2_list.gif" /></span></p>
                    <ul style="display:none;">
                    	<li><a href="club_content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>">全部</a></li>
                    	<li><a href="club_content.jsp?id=<%=id%>&Status1=-1&rowsPerPage=<%=rowsPerPage%>">草稿 
</a></li>
                        <li><a href="club_content.jsp?id=<%=id%>&Status1=1&rowsPerPage=<%=rowsPerPage%>">已发</a></li>
                        <li><a href="club_content.jsp?id=<%=id%>&IsDelete=1&rowsPerPage=<%=rowsPerPage%>">已删除</a></li>
                    </ul>
                </li>
            </ul>
            <ul class="toolbar2">
            	<li class="first"><a href="club_content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>">全部</a></li>
                <li><a href="club_content.jsp?id=<%=id%>&Status1=-1&rowsPerPage=<%=rowsPerPage%>">草稿</a></li>
                <li><a href="club_content.jsp?id=<%=id%>&Status1=1&rowsPerPage=<%=rowsPerPage%>">已发</a></li>
                <li class="last"><a href="club_content.jsp?id=<%=id%>&IsDelete=1&rowsPerPage=<%=rowsPerPage%>">已删除</a></li>
            </ul>
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
                <li  class="first"><a href="javascript:approve();">发布</a></li>
            <!--   <li><a href="javascript:Publish();">发布</a></li> -->  
                <li><a href="javascript:Preview();">预览</a></li>
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
					<li><a href="javascript:RefreshItem();">刷新Cache</a></li>
						<!--<li class="list_no">复制</li>
						<li class="list_no">移动</li>-->
					<li><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
                <li class="last list" id="otherOperation3" style="display:none;">
                	<p>其他<img src="../images/toolbar2_list.gif" /></p>
                    <ul id="ul1" style="display:none;top:-123px;">
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
        <ul class="toolbar_r">
        	<li class="b1_cur" title="竖排"></li>
            <li class="b2" title="竖排"></li>
            <li class="b3" title="竖排"></li>
        </ul>
    </div>


</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
<%}else{%>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
</script> 
<%}%>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(S_OpenSearch!=1){%>
	sortable();
	sortableDisable();
	<%if(sortable.equals("enable")){%>
		sortableEnable();
	<%}%>
<%}%>

var beforeShowFunc = function() {}
var menu = [
  {'<img src="../images/inner_menu_release.gif" title="发布"/>发布':function(menuItem,menu) {approve();} },
  {'<img src="../images/inner_menu_preview.gif" title="预览"/>预览':function(menuItem,menu) {Preview(); }},
  {'<img src="../images/inner_menu_edit.gif" title="编辑"/>编辑':function(menuItem,menu) {editDocument1(); }},
  {'<img src="../images/inner_menu_recall.gif" title="撤稿"/>撤稿':function(menuItem,menu) {deleteFile2(); }},
	<%if(!channel.getRecommendOut().equals("")){%>{'<img src="../images/inner_menu_recommend.gif" title="推荐"/>推荐':function(menuItem,menu) {recommendOut();}},<%}%>
	<%if(!channel.getAttribute1().equals("")){%>{'<img src="../images/inner_menu_quote.gif" title="引用"/>引用':function(menuItem,menu) {recommendIn();}},<%}%>
	<%if(IsWeight!=1){%>{'<img src="../images/inner_menu_taxis.gif" title="排序"/>排序':function(menuItem,menu) {sortableEnable(); }},<%}%>
  {'<img src="../images/inner_menu_cache.gif" title="刷新Cache"/>刷新Cache':function(menuItem,menu) {RefreshItem(); }},
  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile(); }}
];
 jQuery("tr[ItemID!='']").contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
 <%if(IsWeight==1){%>WeightAddColor();<%}%>
});

 function double_click()
{
	
}
jQuery("tr[ItemID!='']").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		obj.trigger("click");
		editDocument(obj.val());
	});

function getCheckbox(){
	var id="";
	var aid="";
	var itemid2="";
	var vid="";
	var Status="";
	var filepath="";
	var videoid="";
	jQuery("#oTable input:checked").each(function(i){
		if(i==0){
			id+=jQuery(this).val();
			aid+=jQuery(this).attr("aid");
			itemid2+=jQuery(this).attr("itemid2");
			vid+=jQuery(this).attr("vid");
			Status+=jQuery(this).attr("Status");
			filepath+=jQuery(this).attr("filepath");
			videoid+=aid+"-"+itemid2;
		}
		else{
			aid+=","+jQuery(this).attr("aid");
			itemid2+=","+jQuery(this).attr("itemid2");
			id+=","+jQuery(this).val();
			vid+=","+jQuery(this).attr("vid");
			Status+=","+jQuery(this).attr("Status");
			filepath+=","+jQuery(this).attr("filepath");
			videoid+=","+jQuery(this).attr("aid")+"-"+jQuery(this).attr("itemid2");
		}
	});
	var obj={length:jQuery("#oTable input:checked").length,id:id,aid:aid,itemid2:itemid2,vid:vid,Status:Status,filepath:filepath,videoid:videoid};
	return obj;
}

function approve(){
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要发布的文档！");
		return;
	}
	var message = "确实要发布这"+obj.length+"项吗？";
	var p="&videoid="+obj.videoid;
	if(!confirm(message)){
			return;
	}

	document.location.href = "../util/approvedocument.jsp?ItemID=" + obj.id + Parameter+p;
}


function approve2(id,vid){
	var message = "确实要发布这1项吗？";
	
	if(!confirm(message)){
			return;
	}
	var p="&videoid="+vid;
	document.location.href = "../util/approvedocument.jsp?ItemID=" + id + Parameter+p;
}

function deleteFile2(){
	var obj=getCheckbox();
	var message = "确实要撤稿这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要撤稿的文档！");
		return;
	}


	var p="&videoid="+obj.videoid;
		if(confirm(message)){
		  document.location.href = "../util/document_delete2.jsp?ItemID=" + obj.id + Parameter+p;
		}
	
}

function deleteFile(){
	var obj=getCheckbox();
	var message = "确实要删除这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要删除的文件！");
		return;
	}
	var p="&videoid="+obj.videoid;

	if(confirm(message)){
		  document.location.href = "../util/document_delete.jsp?ItemID=" + obj.id + Parameter+p;
		}
}

function Preview_club(Status,vid,itemid,filepath){//Status=0预览 Status=1正式地址预览
		var url='util/showclub.jsp?Status=0';
		url+='&vid='+vid;
		url+='&itemid='+itemid;
		url+='&filepath='+filepath;
		var	dialog = new top.TideDialog();
		dialog.setWidth(560);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle("播放视频");
		dialog.show();
}

function Preview_club2(Status,vid,itemid,filepath){//Status=0预览 Status=1正式地址预览
		var url='util/showclub.jsp?Status=1';
		url+='&vid='+vid;
		url+='&itemid='+itemid;
		url+='&filepath='+filepath;
		var	dialog = new top.TideDialog();
		dialog.setWidth(560);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle("播放视频");
		dialog.show();
}


function Preview()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要预览的文件！");
		return;
	}
	
	if(obj.length>1){
		alert("请先选择一个预览的文件！");
		return;
	}
	
		var url='util/showclub.jsp?Status=' +obj.Status;
		url+='&vid='+obj.vid;
		url+='&itemid='+obj.itemid2;
		url+='&filepath='+obj.filepath;
		var	dialog = new top.TideDialog();
		dialog.setWidth(560);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle("播放视频");
		dialog.show();	
}
	jQuery("#rowsPerPage").val("<%=rowsPerPage%>");
</script>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
