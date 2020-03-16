<%@ page import="tidemedia.cms.system.*,
				java.sql.*,java.util.ArrayList"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../config.jsp"%>
<script type="text/javascript" src="../common/common.js"></script>
<%
	int id = getIntParameter(request,"id");
	int currPage = getIntParameter(request,"currPage");
	int rowsPerPage = getIntParameter(request,"rowsPerPage");
	if(currPage<1)
		currPage = 1;
	if(rowsPerPage<=0)
		rowsPerPage = 20;

	Channel channel = new Channel();
	if(id==0||id==-1)
	{
		channel = channel.getRootChannel();
	}
	else
		channel = CmsCache.getChannel(id);
	
	//Leener add 2007-03-05
	Field field = new Field();

	ResultSetMetaData rsmd = channel.getColumn();
	ArrayList arraylist = channel.getFieldInfo();
	//End;
	
	Channel parentchannel = null;
	int ChannelID = channel.getId();
	
	String S_Title = getParameter(request,"Title");
	String S_CreateDate	= getParameter(request,"CreateDate");
	String S_CreateDate1	=	getParameter(request,"CreateDate1");
	String S_User			=	getParameter(request,"User");
	int S_Status			=	getIntParameter(request,"Status");
	int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
	int S_OpenSearch		=	getIntParameter(request,"OpenSearch");

	String querystring = "";
	querystring = "&Title="+S_Title+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch;

	String Action = getParameter(request,"Action");
	int channelid = getIntParameter(request,"c_id");
	if(Action.equals("Del"))
	{
		App app = new App();
		app.DeleteTable(channelid,channel.getTableName());
		response.sendRedirect("app.jsp?id="+id);return;
	}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="../common/WebFX-ContextMenu.css">
<link href="../common/xwebmenu.css" rel="stylesheet" type="text/css">
<script src="../common/ieemu.js"></script>
<script src="../common/ContextMenu.js"></script>
<script src="../common/XWebMenuClass.js"></script>

<script language=javascript>

var myObject = new Object();

var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;

var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;

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
	if(obj.className!="rows3")
	{
		var curr_row;

		if(getEvent().ctrlKey!=true)
		{
			for (curr_row = 0; curr_row < document.getElementById("oTable").rows.length; curr_row++)
			{
			  if(document.getElementById("oTable").rows[curr_row].className=="rows3")
				  document.getElementById("oTable").rows[curr_row].className = document.getElementById("oTable").rows[curr_row].oldclass;
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
	//alert(obj.getAttribute("ItemID"));
	showInfo(obj.getAttribute("ItemID"));
}

function showInfo(itemid)
{
	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .8 );
	var leftm  = Math.floor( screen.width  * .1)+30;
	var topm   = Math.floor( screen.height * .05)+30;
 	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  	var url = "app_info.jsp?ItemID="+itemid+"&ChannelID=<%=channel.getId()%>";
  
  	window.open(url,"",Feature);
}

function onkeyboard()
{
	key = event.keyCode;
	if(key == 'd'.charCodeAt() || key == 'D'.charCodeAt())
		deleteFile();
	else if(key == 13)
		editDocument1();
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

function selectdate(fieldname){
	var args="font-size:10px;dialogWidth:286px;dialogHeight:290px;center:yes;status:no;help:no";
	var Feature=new Array();
	var selectdate=window.showModalDialog("selectdate.htm",Feature,args);
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

function showInFo(id){
	var url1 = "../modal_dialog.jsp?target=content/app_info.jsp&channelid="+id+"&ChannelID=<%=channel.getId()%>";
	var url2 = "app_info.jsp&channelid="+id+"&ChannelID=<%=channel.getId()%>";
	
	var retu= showModal(580,530,url1,url2,myObject);
	if(retu!=null)
	window.location.reload();
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0"
	cellspacing="0">
	<tr>
		<td valign="top">
		<table width="100%" height="38" border="0" cellpadding="0"
			cellspacing="0" class="box-tint">
			<tr>
				<td>
					应用：<%=channel.getName()%>
				</td>
				<td align="right">
				&nbsp;
				</td>
				<td width="20" align="right"></td>
			</tr>
		</table>
<table width="100%" border="0" cellspacing="8" cellpadding="0" onkeypress="onkeyboard()" onkeydown="onkeyboard1()">
	<tr>
    	<td>
        	<table width="100%" border="0" cellspacing="0" cellpadding="5" id="oTable">
            	<tr align="left">
                	<td width="46" class="box-blue"><span class="font-white">编号</span></td>
                	<td width="400" class="box-blue"><span class="font-white">标题</span></td>
              		<td width="298" class="box-blue"><span class="font-white">内容</span></td>
              		<td width="62" class="box-blue"><span class="font-white">操作</span></td>
                </tr>
<% 	
	String Table = channel.getTableName();
	String ListSql = "select * from "+Table+" order by id desc";
	String CountSql = "select count(*) from "+Table+" ";

	ResultSet Rs = channel.List(ListSql,CountSql,currPage,rowsPerPage);
	
	int TotalPageNumber = channel.pagecontrol.getMaxPages();
	int TotalNumber = channel.pagecontrol.getRowsCount();
	int j = 0;

	while(Rs.next())
	{
		int id_ = Rs.getInt("id");	
		//System.out.println("id_="+id_);
		String Title = convertNull(Rs.getString("Title"));
		String Content = convertNull(Rs.getString("Content"));

		int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
		j++;
%>
<tr class="<%=(j%2==0)?" rows2 ":"rows1"%>" oldclass="<%=(j%2==0)?"rows2":"rows1"%>" onClick="selectItem(this);" onDblClick ="double_click(this);" No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"> 
                <td width="46">
                	<img src="../images/icon_file_html.gif" ondragstart="Drag()" onclick="return(false)"><%=OrderNumber%>
                </td>
                <td width="400"><%=Title%></td>
                <td width="298"><%=Content%></td>
                <td width="62" align="center">
      				<!-- <a href="javascript:showInFo(<%=id_%>);" class="operate">查看详情</a>  -->
        			<a href="app.jsp?Action=Del&c_id=<%=id_%>&id=<%=id%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;"> 删除</a>&nbsp;
                </td>
              </tr>
<%}
channel.closeRs(Rs);
%>
            </table>
           
<!-- 以下为分页操作程序 -->
<%if(TotalPageNumber>0){%>            
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="box-blue">
	<tr> 
    	<td height="26" class="font">　　
        	<a href="content.jsp?currPage=1&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>">
            	<span class="font-white">&lt;&lt; 第一页</span>
            </a> 
            <%if(currPage>1){%>
            <a href="content.jsp?currPage=<%=currPage-1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>">
                <span class="font-white">&lt; 上页</span>
            </a>
            <%}%> 　　
            <%if(currPage<TotalPageNumber){%>
            <a href="content.jsp?currPage=<%=currPage+1%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>"&>
                <span class="font-white">下页 &gt;</span>
            </a>
            <%}%> 
            <a href="content.jsp?currPage=<%=TotalPageNumber%>&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>">
                <span class="font-white">最后一页&gt;&gt;</span>
            </a>
		</td>
		<td align="right" class="font">
			<span class="font-white">共<%=TotalPageNumber%>页 当前第<%=currPage%>页 每页显示 
				<select name="num_perpage" onChange="change(this);" id="rowsPerPage">
					<option value="10">10</option>
					<option value="15">15</option>
					<option value="20">20</option>
					<option value="25">25</option>
					<option value="30">30</option>
					<option value="50">50</option>
					<option value="80">80</option>
					<option value="100">100</option>
				</select> 条
			</span>
		</td>
	</tr>
			<script language=javascript>
				document.getElementById("rowsPerPage").value = <%=rowsPerPage%>;
			</script>
</table>
		<%}%>
<!-- 分页操作结束 -->
		</td>
	</tr>
</table>
</td>
</tr>
</table>
</body>
</html>









