<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 20;

Channel channel = CmsCache.getChannel(id);
Channel parentchannel = null;
int ChannelID = channel.getId();

if(channel.getType()==2)
{
	response.sendRedirect("page_info.jsp?id="+id);
	return;
}
if(channel.getType()==1)
{
//	parentchannel = new Channel(channel.getParentTableChannel());
//	ChannelID = parentchannel.getId();
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
int IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&IsIncludeSubChannel="+IsIncludeSubChannel;

int Status1			=	getIntParameter(request,"Status1");
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="../common/WebFX-ContextMenu.css">
<script type="text/javascript" src="../common/ieemu.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/ContextMenu.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script language=javascript>

var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;

var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var S_Parameter ="&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
function addDocument()
{
	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .85 );
	var leftm  = Math.floor( screen.width  * .1);
	var topm   = Math.floor( screen.height * .05);
	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
	var url="document.jsp?ItemID=0&ChannelID=" + <%=ChannelID%>;
	window.open(url,"",Feature);
}

function editDocument(obj)
{
	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .8 );
	var leftm  = Math.floor( screen.width  * .1)+30;
	var topm   = Math.floor( screen.height * .05)+30;
 	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  	var url="document.jsp?ItemID="+obj.ItemID+"&ChannelID=" +obj.ChannelID;
  	window.open(url,"",Feature);
}

function editDocument1()
{
	var curr_row;
	for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
	{
	  if(oTable.rows[curr_row].className=="rows3")
		{
		 editDocument(oTable.rows[curr_row]);
		 return;
		}
	}
	alert("请先选择要编辑的文件！");
}

function Preview()
{
		var curr_row;
		for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
		{
		  if(oTable.rows[curr_row].className=="rows3")
			{
			 window.open("document_preview.jsp?ItemID=" + oTable.rows[curr_row].ItemID + "&ChannelID="+ oTable.rows[curr_row].ChannelID + S_Parameter);
			 return;
			}
		}
		alert("请先选择要预览的文件！");
}

function Order(action)
{
		var curr_row;
		for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
		{
		  if(oTable.rows[curr_row].className=="rows3")
			{
				var myObject = new Object();
				myObject.title = "排序";
				var Feature = "dialogWidth:24em; dialogHeight:18em;center:yes;status:no;help:no";
				var retu = window.showModalDialog
				("../modal_dialog.jsp?target=content/document_order.jsp&ItemID=" + oTable.rows[curr_row].ItemID + "&OrderNumber="+oTable.rows[curr_row].OrderNumber + Parameter,myObject,Feature);
				if(retu!=null)
					window.location.reload();
				return;
			  //this.location = "document_order.jsp?Action="+action+"&ItemID=" + oTable.rows[curr_row].ItemID + Parameter;
			}
		}
		alert("请先选择要操作的文件！");
}

function contextForBody(obj)
{
	//alert(window.event.srcElement.tagName);
   var tagName = window.event.srcElement.tagName;
   if(tagName == "TD")
	{
	   //alert(window.event.srcElement.parentElement.parentElement.parentElement.id);
	   if(window.event.srcElement.parentElement.parentElement.parentElement.id == "oTable")
		{
		   var classname = window.event.srcElement.parentElement.className;
		   if(classname!="rows3" && classname!="")
			   selectItem(window.event.srcElement.parentElement);
		}
	}
   var eobj,popupoptions
   popupoptions = [
					    <%if(channel.hasRight(userinfo_session,2)){%>
   						new ContextItem("新建文档",function(){addDocument();}),
						<%}%>
   						new ContextItem("编辑文档",function(){editDocument1();}),
   						new ContextItem("预览文档",function(){Preview();}),
						new ContextSeperator(),
						<%if(channel.hasRight(userinfo_session,3)){%>
   						new ContextItem("审批通过",function(){document_operation("Approved");}),
						<%}%>
   						new ContextItem("立即发布",function(){document_operation("Publish");}),
					   <%if(channel.hasRight(userinfo_session,4)){%>
						new ContextSeperator(),
   						new ContextItem("删除文档",function(){document_operation("Delete");}),
						<%}%>
						new ContextItem("撤稿",function(){document_operation("Delete2");}),
						new ContextSeperator(),
   						new ContextItem("刷　　新",function(){window.location.reload();})
   				  ]
   ContextMenu.display(popupoptions)
}

function showText(obj)
{
	self.status=obj.innerText
}

function contextForSpan(obj)
{
   var eobj,popupoptions
   popupoptions = [
   						new ContextItem("Show Text",function(){showText(obj);})
   				  ]
   ContextMenu.display(popupoptions)
}
function hideIt(obj)
{
	obj.style.display='none'
} 

function contextForButton(obj)
{
   var eobj,popupoptions
   popupoptions = [
   						new ContextItem("<b>Hide</b>",function(){hideIt(obj);}),
   						new ContextItem("Show Text",function(){showText(obj);})
   				  ]
   ContextMenu.display(popupoptions)
}

function selectItem(obj)
{
	//alert(obj.className);
	if(obj.className!="rows3")
	{
		var curr_row;

		if(window.event.ctrlKey!=true)
		{
			for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
			{
			  if(oTable.rows[curr_row].className=="rows3")
				  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
			}
		}
		obj.className = "rows3";
	}
	else
		obj.className = obj.oldclass;
}

function selectItem_key(flag)
{

	var curr_row;

	if(flag==1)
	{

		for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
		{
		  if(oTable.rows[curr_row].className=="rows3")
			{
			  if(flag==1)
				{
				  if(curr_row>1)
					{
					  if(window.event.shiftKey!=true)
						  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
					  oTable.rows[curr_row-1].className = "rows3";
					}
				}
				break;
			}
		}
	}
	else if(flag==2)
	{
		for (curr_row = oTable.rows.length-1; curr_row > 0; curr_row--)
		{
		  if(oTable.rows[curr_row].className=="rows3")
			{
			  if((curr_row+1)<oTable.rows.length)
				{
				  if(window.event.shiftKey!=true)
					  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
				  oTable.rows[curr_row+1].className = "rows3";
				}
				break;
			}
		}

	}
}

function double_click(obj)
{
	if(obj.className!="rows3")
	{
		obj.className = "rows3";
	}

	editDocument(obj);
}

function change(obj)
{
	if(obj!=null)
		this.location = "content.jsp?id=<%=id%>&rowsPerPage="+obj.value;
}

function onkeyboard()
{
	key = event.keyCode;
	if(key == 'd'.charCodeAt() || key == 'D'.charCodeAt())
		deleteFile();
	else if(key == 13)
		editDocument1();
	//alert(key);
}

function onkeyboard1()
{
	key = event.keyCode;
	if(key==38)
	{
		selectItem_key(1);
	}
	else if(key==40)
		selectItem_key(2);
	else if(key==46)
		deleteFile();

	//alert(key);
}

function SelectStart()
{
	if(event.srcElement.tagName.toLowerCase()=="body" && event.ctrlKey && event.button==0)
	{
		//全选,第1行是Table Title
		for (curr_row = 1; curr_row < oTable.rows.length; curr_row++)
		{
			  oTable.rows[curr_row].className = "rows3";
		}
	}

	return false;
}

function Drag(){
	window.event.dataTransfer.setData("Text","");
	if (window.event.shiftKey==true){
		event.dataTransfer.effectAllowed="move";
		}
	else{
		event.dataTransfer.effectAllowed="copy";
		}
	}

function openSearch()
{
	if(SearchArea.style.display == "none")
	{
		document.search_form.OpenSearch.value="1";
		SearchArea.style.display = "";
	}
	else
	{
		document.search_form.OpenSearch.value="0";
		SearchArea.style.display = "none";
	}
}

function recommendItem()
{
	<%if(CmsCache.getConfig().getCustomer().equals("vodone")){%>
	 commendItem();
	<%}else{%>
	var myObject = new Object();
    myObject.title = "选择推荐条目";
	myObject.ChannelID = "<%=channel.getId()%>";

	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .85 );
	var leftm  = Math.floor( screen.width  * .1);
	var topm   = Math.floor( screen.height * .05);
	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height=" + height;
	var url="../content/recommend_item.jsp?ChannelID=" + myObject.ChannelID;
	window.open(url,"",Feature);
	<%}%>
}

function commendItem()
{
	var myObject = new Object();
    myObject.title = "选择推荐条目";
	myObject.ChannelID = "<%=channel.getId()%>";
	myObject.ChannelName = "<%=channel.getName()%>";

 	var Feature = "dialogWidth:56em; dialogHeight:44em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=vodone/commend_item.jsp&ChannelID=<%=channel.getId()%>",myObject,Feature);
	if(retu!=null)
		window.location.reload();
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

function document_operation(Action){
	if(jQuery("#oTable tr.rows3").length==1){
	var selectedItem = "";
	var ItemID="";
	var ChannelID="";
	var url="document_operation.jsp";
	var data="";
	var url_Refresh="content_search.jsp?currPage=<%=currPage%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";	
	var title="";
		jQuery("#oTable tr.rows3").each(function(i){
			if(i==0){
				selectedItem+=jQuery(this).attr("ItemID");
				ItemID=jQuery(this).attr("ItemID");
				ChannelID=jQuery(this).attr("ChannelID");
				title=jQuery(this).find("span").text();
			}else{
				selectedItem+=","+jQuery(this).attr("ItemID");
			}
		});
		data="Action="+Action+"&ItemID="+ItemID+"&ChannelID="+ChannelID;
		switch(Action){
		case 'Delete':
			  if(!confirm("你确实要删除"+title+"吗?")){
			  		return ;
			  }
			break;
		case 'Delete2':
			  if(!confirm("确实要撤稿"+title+"吗?")){
			  		return ;
			  }
			break;
		}
		jQuery.ajax({
			type: "GET",
			url: url,
			data: data,
			error: function(){},
			success: function(msg){
				if(jQuery.trim(msg)=="Refresh"){
					document.location=url_Refresh;
				}
			}
 		});

	}else{
		alert("请选择一个要操作的文档!");
	}	
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="ContextMenu.intializeContextMenu()" oncontextmenu="return contextForBody(this)" onselectstart="return SelectStart();">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top"><table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
        <tr> 
		<td>频道：<%=channel.getName()%>&nbsp;&nbsp;&nbsp;选择：<a href="content.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>"><span class="font-green">全部</span></a>&nbsp;&nbsp;<a href="content.jsp?id=<%=id%>&Status1=-1&rowsPerPage=<%=rowsPerPage%>"><span class="font-green">待审</span></a>&nbsp;&nbsp;<a href="content.jsp?id=<%=id%>&Status1=1&rowsPerPage=<%=rowsPerPage%>"><span class="font-green">审批通过</span></a>&nbsp;&nbsp;
		<a href="content.jsp?id=<%=id%>&IsDelete=1&rowsPerPage=<%=rowsPerPage%>">
		<span class="font-green">已删除</span></a>&nbsp;&nbsp;</td>
          <td align="right"><%if(!channel.getAttribute1().equals("")){%><a href="javascript:recommendItem();"><img src="../images/icon_32_commend.gif" width="32" height="32" align="absmiddle" border="0"> <span class="font"> 
            推荐</span></a><%}%> <a href="javascript:openSearch();"><img src="../images/icon_32_search.gif" width="32" height="32" align="absmiddle" border="0"> <span class="font"> 
            查找</span></a><a href="javascript:addDocument();"><img src="../images/icon_new_s.gif" width="32" height="32" align="absmiddle" border="0"><span class="font"> 
            添加文档</span></a></td>
          <td width="20" align="right"></td>
        </tr>
      </table>
<div id="SearchArea" style="display:<%=(S_OpenSearch==1?"":"none")%>">
<table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20">&nbsp;</td>
    <td><form name="search_form" action="content_search.jsp?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：标题
		  <input name="Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
		  创建日期
		  <select name="CreateDate1" >
		    <option value=">" <%=(S_CreateDate1.equals(">")||S_CreateDate1.equals("")?"selected":"")%>>大于</option>
		    <option value="=" <%=(S_CreateDate1.equals("=")?"selected":"")%>>等于</option>
		    <option value="<" <%=(S_CreateDate1.equals("<")?"selected":"")%>>小于</option>
      </select>
		  <input name="CreateDate" type="text" size="10"  class="textfield" value="<%=S_CreateDate%>"><img align="absmiddle" src="../images/calendar.gif" onclick="selectdate('CreateDate');">
		   
		  作者
		  <input name="User" type="text" size="10"  class="textfield" value="<%=S_User%>">
		  状态
		  <select name="Status" >
		    <option value="0" <%=(S_Status==0?"selected":"")%>></option>
		    <option value="2" <%=(S_Status==2?"selected":"")%>>审核通过</option>
		    <option value="1" <%=(S_Status==1?"selected":"")%>>未审核</option>
      </select>
	<!--   图片新闻
		  <input type="checkbox" name="IsPhotoNews" value="1" <%=(S_IsPhotoNews==1?"checked":"")%>> -->
		 包含子频道
		  <input type="checkbox" name="IsIncludeSubChannel" value="1" <%=(IsIncludeSubChannel==1?"checked":"")%>> 
    <input type="submit" name="Submit" class="tidecms_btn3" value="查找"><input type="hidden" name="OpenSearch" value="0"></form></td>
    <td width="20">&nbsp;</td>
  </tr>
</table>
</div>
      <table width="100%" border="0" cellspacing="8" cellpadding="0" onkeypress="onkeyboard()" onkeydown="onkeyboard1()">
<%if(channel.hasRight(userinfo_session,1)){%>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="5" id="oTable">
              <tr align="left"> 
                <td width="34" class="box-blue"><span class="font-white">编号</span></td>
                <td width="413" class="box-blue"><span class="font-white">标题</span></td>
                <td width="44" class="box-blue"><span class="font-white">作者</span></td>
                <td width="150" class="box-blue"><span class="font-white">修改时间</span></td>
                <td width="72" class="box-blue"><span class="font-white">状态</span></td>
              </tr>
<%
int IsActive = 1;
if(IsDelete==1) IsActive=0;

//String Table = channel.getTableName();
String Table ="item_snap";
String ListSql = "select "+Table+".GlobalID,"+Table+".Title,"+Table+".ChannelID,"+Table+".ItemID,"+Table+".User,"+Table+".ModifiedDate,"+Table+".Status,userinfo.Name from "+Table+" left join userinfo on "+Table+".User=userinfo.id";
String CountSql = "select count(*) from "+Table+" ";

if(!S_User.equals(""))
	CountSql = "select count(*) from "+Table+" left join userinfo on "+Table+".User=userinfo.id";

if(channel.getType()==Channel.Category_Type)
{
	ListSql += " where  "+Table+".Active=" + IsActive;
	CountSql += " where "+Table+".Active=" + IsActive;
}
else if(channel.getType()==Channel.MirrorChannel_Type)
{
	Channel linkChannel = channel.getLinkChannel();
	if(linkChannel.getType()==Channel.Category_Type)
	{
		ListSql += " where  "+Table+".Active=" + IsActive;
		CountSql += " where  "+Table+".Active=" + IsActive;
	}
	else
	{
		ListSql += " where  "+Table+".Active=" + IsActive;
		CountSql += " where  "+Table+".Active=" + IsActive;
	}
}
else
{
	ListSql += " where "+Table+".Active=" + IsActive;
	CountSql += " where "+Table+".Active=" + IsActive;
}

String WhereSql = "";

if(!S_Title.equals(""))
	WhereSql += " and " + Table + ".Title like '%" + channel.SQLQuote(S_Title) + "%'";
if(!S_CreateDate.equals(""))
	WhereSql += " and DATE(" + Table + ".CreateDate)" + S_CreateDate1 + "'" + channel.SQLQuote(S_CreateDate) + "'";
if(!S_User.equals(""))
	WhereSql += " and userinfo.Name='" + channel.SQLQuote(S_User) + "'";
if(S_IsPhotoNews==1)
	WhereSql += " and " + Table + ".IsPhotoNews=1";
if(S_Status!=0)
	WhereSql += " and " + Table + ".Status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and " + Table + ".Status=0";
	else
		WhereSql += " and " + Table + ".Status=" + Status1;
}

if(IsIncludeSubChannel==1){
	WhereSql += " and " + Table + ".ChannelCode like '"+channel.getChannelCode()+"%'";
}else{
	WhereSql += " and " + Table + ".ChannelID="+ChannelID;
}
ListSql += WhereSql;
CountSql += WhereSql;
//System.out.println(ListSql);
ListSql += " order by "+Table+".OrderNumber desc," + Table + ".GlobalID desc";

ResultSet Rs = channel.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = channel.pagecontrol.getMaxPages();
int TotalNumber = channel.pagecontrol.getRowsCount();
int j = 0;

while(Rs.next())
{
	int S_ItemID = Rs.getInt(Table+".ItemID");
	int S_ChannelID=Rs.getInt(Table+".ChannelID");
	int GlobalID=Rs.getInt(Table+".GlobalID");
	int Status = Rs.getInt(Table+".Status");
	Channel S_channel = CmsCache.getChannel(S_ChannelID);
	String Title		= convertNull(Rs.getString(Table+".Title"));
	String ModifiedDate	= convertNull(Rs.getString(Table+".ModifiedDate"));
	String Name	= convertNull(Rs.getString("userinfo.Name"));
	String StatusDesc = "";
	if(IsDelete!=1){
	if(Status==0)
		StatusDesc = "<font color=red>待审</font>";
	else if(Status==1)
		StatusDesc = "<font color=blue>审批通过</font>";
	}else{
		StatusDesc = "<font color=blue>已删除</font>";
	}
	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;
%>
              <tr class="<%=(j%2==0)?"rows2":"rows1"%>" oldclass="<%=(j%2==0)?"rows2":"rows1"%>" onClick="selectItem(this);" onDblClick ="double_click(this);" No="<%=j%>" ItemID="<%=S_ItemID%>"  GlobalID="<%=GlobalID%>" ChannelID="<%=S_ChannelID%>"  OrderNumber="<%=OrderNumber%>"> 
                <td width="34"><img src="../images/icon_file_html.gif" ondragstart="Drag()" onclick="return(false)"><%=OrderNumber%></td>
                <td width="413" > 
                  <span id="Title<%=j%>">
                    <font color='blue'>
				  <%if(IsIncludeSubChannel==1) 
	                out.print("["+S_channel.getName()+"]");
				 %>
				  </font>
                  <%=Title%></span>
                </td>
                <td width="44"> <%=Name%> </td>
                <td width="150"> <%=ModifiedDate%> </td>
                <td width="72"> <%=StatusDesc%> </td>
              </tr>
<%}
channel.closeRs(Rs);

%>
            </table>
<%if(TotalPageNumber>0){%>            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="box-blue">
              <tr> 
                <td height="26" class="font">　　<a href="content_search.jsp?currPage=1&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>"><span class="font-white">&lt;&lt; 
                  第一页</span></a> <%if(currPage>1){%><a href="content_search.jsp?currPage=<%=currPage-1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>">
                  <span class="font-white">&lt; 上页</span></a><%}%> 　　<%if(currPage<TotalPageNumber){%><a href="content_search.jsp?currPage=<%=currPage+1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>"&><span class="font-white">下页 &gt;</span></a><%}%> <a href="content_search.jsp?currPage=<%=TotalPageNumber%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>"><span class="font-white">最后一页&gt;&gt;</span></a></td>
                <td align="right" class="font"><span class="font-white">共<%=TotalPageNumber%>页 当前第<%=currPage%>页 每页显示 
                  <select name="num_perpage" onChange="change(this);" id="rowsPerPage">
                    <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="25">25</option>
                    <option value="30">30</option>
                    <option value="50">50</option>
                    <option value="80">80</option>
                    <option value="100">100</option>
                  </select>
                  条</span>　　　</td>
              </tr>
<script language=javascript>
rowsPerPage.value = <%=rowsPerPage%>;
</script>					
            </table><%}%>
		  </td>
        </tr>
<%}%>
      </table></td>
  </tr>
</table>
</body>
</html>
