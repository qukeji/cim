<%@ page import="tidemedia.cms.system.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);%>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}


	int		ChannelID		= getIntParameter(request,"ChannelID");
	int		GroupID			= getIntParameter(request,"GroupID");
	int		FieldID			= getIntParameter(request,"FieldID");
	int		show_fieldid	= getIntParameter(request,"show_fieldid");
	String	Action			= getParameter(request,"Action");
	String FieldGroupTab	= getParameter(request,"FieldGroupTab");

	if(Action.equals("UpdateGroup"))
	{
		Field field = new Field(FieldID);
		field.updateGroup(GroupID);
	}

	if(Action.equals("Delete"))
	{
		Field field = new Field(FieldID);

		field.Delete();
//System.out.println(ChannelID);
		response.sendRedirect("form_view.jsp?ChannelID="+ChannelID);return;
	}

	if(Action.equals("DeleteGroup"))
	{//System.out.println(GroupID);
		FieldGroup fieldGroup = new FieldGroup(GroupID);

		fieldGroup.Delete();

		response.sendRedirect("form_view.jsp?ChannelID="+ChannelID);return;
	}

	Channel channel = CmsCache.getChannel(ChannelID);
	ArrayList fieldGroupArray = channel.getFieldGroupInfo();
	int group = fieldGroupArray.size();

	int show_groupid = 0;
	if(show_fieldid>0)
	{
		Field f = new Field(show_fieldid);
		show_groupid=f.getGroupID();
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<style> 
.edit-main{margin:0;position:Static;}
.edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
.edit-con{position:Static;margin:-1px 0 0;}
.edit-con .center_main{position:absolute;top:76px;bottom:50px;right:0;left:0;}
.form_main{top:55px;}
.form_top{top:40px;}

</style>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<script type="text/javascript" src="../common/jquery.scrollTo-min.js"></script>
<script language="javascript">
var group = <%=group%>;
var channelid = <%=ChannelID%>;

function addField()
{
	var url="channel/field_add.jsp?ChannelID=<%=ChannelID%>&GroupID="+getSelectedTabID();
	var	dialog = new top.TideDialog();
	dialog.setWidth(550);
	dialog.setHeight(430);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("添加字段");
	dialog.setScroll('auto');
	dialog.show(); 
}

function addFieldGroup()
{
	var url="channel/fieldgroup_add.jsp?ChannelID=<%=ChannelID%>";
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(250);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("添加分组");
	dialog.show();
}

function addAppGroup()
{
	var url="channel/appgroup.jsp?ChannelID="+channelid;
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(250);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("添加功能组");
	dialog.show();
}

function addFieldGroup2()
{
	var url="channel/fieldgroup_add.jsp?ChannelID="+channelid+"&Type=3";
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(250);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("添加集合组");
	dialog.show();
}

function editFieldGroup()
{
	var url="channel/fieldgroup_edit.jsp?id="+getSelectedTabID();
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(250);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("修改组名");
	dialog.show();
}

function delFieldGroup()
{
	if(confirm('你确认要删除吗?')) 
	{
		this.location = "form_view.jsp?Action=DeleteGroup&GroupID="+getSelectedTabID()+"&ChannelID=<%=channel.getId()%>";
	}
}

function delField(fid,name)
{
	if(confirm('你确认要删除字段 ' + name + ' 吗? 删除以后无法恢复!')) 
	{
		var url="../channel/field_delete.jsp?id="+fid;
		jQuery.ajax({
			type: "GET",
			url: url,
			success: function(msg){
					$("#tr_"+fid).remove();
				}
	 		});
	}
}

function editField(fieldid) 
{
	var url="channel/field_edit.jsp?FieldID="+fieldid;
	var	dialog = new top.TideDialog();
	dialog.setWidth(550);
	dialog.setHeight(400);
	dialog.setSuffix('_3');
	dialog.setUrl(url);
	dialog.setTitle("字段信息");
	dialog.show();
}

function selectItem(obj)
{

}

function Order(i) {
	//i==0 up i==1 down
	var curr_id = getSelectedItemID();
	if(curr_id==0){alert("请先选择要预览的文件！");return;}

	document.order.direction.value = i;
	document.order.id.value = curr_id;
	document.order.submit();
/*
	var http = new HTTPRequest();
	var url = "field_order.jsp?id=" + curr_id + "&direction=" + i;//alert(url);
	http.open("GET",url,true);
	http.onreadystatechange = function (){document.form.submit();};
	http.send(null);*/
}

function getSelectedItemID()
{
	var curr_row;
	for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
	{
	  if(oTable.rows[curr_row].className=="rows3")
		{
			return oTable.rows[curr_row].ItemID;
		}
	}

	return 0;
}

var beginMoving=false;
var startScrollTop = 0;


function checkTarget(x,y)
{
	var num = <%=fieldGroupArray.size()%>;
	for(i=1;i<=num;i++)
	{
		var o = eval("form"+i+"_td");
		var rect = o.getBoundingClientRect();
		if(x>=rect.left&&x<=rect.right&&y>=rect.top&&y<=rect.bottom)
			return o.groupid;
	}

	return 0;
}

function checkOrder(obj)
{
	var objBottom = getTopPos(obj)+obj.offsetHeight;
	document.title=objBottom;
	var curr_row;
	for (curr_row = 1; curr_row < oTable.rows.length; curr_row++)
	{
		var o = oTable.rows[curr_row];
		var oBottom = getTopPos(o)+o.offsetHeight;
		if(objBottom<oBottom && oBottom>0) return (curr_row);
		//document.title=document.title+":"+oBottom;
	}

	return 0;
}

function getTopPos(inputObj)
{		
  var returnValue = inputObj.offsetTop;
  while((inputObj = inputObj.offsetParent) != null){
  	if(inputObj.tagName!='HTML')returnValue += inputObj.offsetTop;
  }
  return returnValue;
}

function setReturnValue(o){
	if(o.refresh){
		var s = "../channel/form_view.jsp?ChannelID="+channelid;
		if(o.field) s += "&show_fieldid="+o.field;
		document.location.href=s;
	}
}

function showTab(j)
{
	for(i=1;i<=group;i++)
	{
		jQuery("#form"+i).hide();
		jQuery("#form"+i+"_td").removeClass("cur");
	}
	
	jQuery("#form"+j).show();
	jQuery("#form"+j+"_td").addClass("cur");
	sort(j);
}

function getSelectedTabID()
{
	
	for(i=1;i<=group;i++)
	{
		var o = $("#form"+i+"_td");
		if(o.hasClass("cur"))
		{
			return o.attr("groupid");
		}
	}

	return 0;
}

function sort(o)
{
	var start_sort = false;
	jQuery("#form"+o).sortable({items:"tr",axis:"y",cursor:"move",
		start:function(e,ui){
			var $p=jQuery(ui.placeholder);
			$p.css({visibility:'visible',height:'20px'});
			$p.html('<td colspan="7">&nbsp;&nbsp;&nbsp;</td>');
				/*if(!start_sort)
				{
					$("#selectNo").trigger("click");
					ui.helper.find(":checkbox").trigger("click");
					var th = $("#oTable_th").children();//alert(th[1].clientWidth);
					var child = ui.helper.children();
					for(var j = 0;j<child.size();j++)
						{(child[j].width=(th[j].clientWidth)+"px");
						}
					start_sort = true;
				}*/
			},
		stop:function(e,ui){
				start_sort = false;
			},
		update:function(e,ui){
			start_sort = false;
			var child = ui.item.children();
			for(var j = 0;j<child.size();j++)
			{
				if(window.ActiveXObject)
					child[j].width="";
				else
					child[j].width=("px");
			}
			var ItemID=ui.item.attr("ItemID");
			var NextItemID = 0;//alert(ui.item.next());
			if(ui.item.next().attr("ItemID"))
				NextItemID = ui.item.next().attr("ItemID");
			var url="../channel/field_order.jsp";
			var data="ChannelID="+channelid+"&ItemID="+ItemID+"&NextItemID="+NextItemID;//alert(data);
			jQuery.ajax({
				type: "GET",
				url: url,
				async:false,
				data: data,
				success: function(msg){
					document.location.href=document.location.href;
				}
	 		});
	}});

	jQuery("#form"+o).sortable("enable");
}

function init()
{
sort(1);
<%if(show_fieldid>0){%>$("#form_main").scrollTo($("#tr_<%=show_fieldid%>"),800);<%}%>
}
</script>
</head>

<body onLoad="init()">
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%=channel.getName()%></div>
    <div class="content_new_post">
	<input type="button" class="tidecms_btn3" value="添加字段" onClick="addField()"/>
	<input type="button" class="tidecms_btn3" value="添加组" onClick="addFieldGroup()"/>
	<input type="button" class="tidecms_btn3" value="添加功能组" onClick="addAppGroup()"/>
	<%if(group>0){%><input type="button" class="tidecms_btn3" value="重命名" onClick="editFieldGroup()"/>
	<input type="button" class="tidecms_btn3" value="删除" onClick="delFieldGroup()"/><%}%>
    </div>
</div>
<%if(fieldGroupArray.size()>0){%>
<div class="edit_main dialog_editForm">
	<div class="edit_nav">
    	<ul>
<%for (int i = 0; i < fieldGroupArray.size(); i++) 
{
	FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
	boolean gshow = false;
	if(show_groupid>0)
	{
		if(fieldGroup.getId()==show_groupid) gshow = true;
	}
	else if(i==0) gshow = true;
%>
        	<li><a <%=(gshow)?"class='cur'":""%> href="javascript:showTab(<%=i+1%>);" id="form<%=i+1%>_td" groupid="<%=fieldGroup.getId()%>"><span><%=fieldGroup.getName()%></span></a></li>
<%}%>
        </ul>
        <div class="clear"></div>
    </div>
    <div class="edit_con">
    	 
		<div class="center_main">

<%
for (int j = 0; j < fieldGroupArray.size(); j++) 
{
	FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(j);
	boolean gshow = false;
	if(show_groupid>0)
	{
		if(fieldGroup.getId()==show_groupid) gshow = true;
	}
	else if(j==0) gshow = true;
%>
<div class="center" id="form<%=j+1%>" <%=(gshow?"":"style=\"display:none;\"")%>>

<table width="100%" border="0" cellspacing="0" cellpadding="5" id="oTable" class="view_table">
<thead>
		<tr id="oTable_th">
    				<th align="left" width="100" valign="middle">&nbsp;描述</th>
    				<th width="120" align="left" valign="middle">名称</th>
    				<th align="left" valign="middle"></th>
    				<th width="50" align="center" valign="middle">>></th>
  		</tr>
</thead>
<%
ArrayList arraylist = channel.getFieldsByGroup(fieldGroup.getId(),j);

int jj = 0;
for (int i = 0; i < arraylist.size(); i++) 
{
	Field field = (Field) arraylist.get(i);

	boolean canDrag = true;
	//if(field.getName().equals("Title")||field.getName().equals("PublishDate")||field.getName().equals("DocFrom"))
	//	canDrag = false;

	jj++;

	String fieldname = field.getName();
	String fielddesc = field.getDescription();
	if(field.getIsHide()==1)
		fielddesc = "<font color='#dddddd'>" + field.getDescription() + "</font>";
	String fieldhtml = field.getFieldHtml();
	if(field.getFieldType().equals("label")) fieldhtml = field.getOther();
	int fid = field.getId();
%>
	<tr id="tr_<%=fid%>" ItemID="<%=fid%>">	
		<td>&nbsp;<%=fielddesc%></td>
		<td><%=fieldname%> </td>
		<td><%=fieldhtml%></td>
        <td align="center"><a href="javascript:editField(<%=fid%>)"><img src="../images/inner_menu_edit.gif"></a><%if(field.getFieldLevel()==2){%><a href="javascript:delField(<%=fid%>,'<%=fieldname%>')"><img src="../images/inner_menu_del.gif"></a><%}%></td>
	</tr>
<%}%>
<%out.println("</table></div>");}%>

<script language="javascript">
<%if(!FieldGroupTab.equals("")){%>
showTab('<%=FieldGroupTab%>');
<%}%>
</script>

        </div>
         
    </div>
</div>
<%}else{%>

<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main" id="form_main">
<div class="form_main_m" id="form1">
<table width="100%" border="0" cellspacing="0" cellpadding="5" id="oTable">
<%
ArrayList arraylist = channel.getFieldInfo();

int jj = 0;
for (int i = 0; i < arraylist.size(); i++) 
{
	Field field = (Field) arraylist.get(i);

	jj++;

	String fieldname = field.getName();
	String fielddesc = field.getDescription();
	int fid = field.getId();
	if(field.getIsHide()==1)
		fielddesc = "<font color='#dddddd'>" + field.getDescription() + "</font>";
%>
		<%if(field.getFieldType().equals("label")){%>
	<tr id="tr_<%=fid%>" class="<%=(jj%2==0)?"rows2":"rows1"%>" oldclass="<%=(jj%2==0)?"rows2":"rows1"%>"  ItemID="<%=fid%>" onDblClick="showInfo(<%=fid%>);">	
		<td><a href="#" onClick="showInfo(<%=fid%>);">&nbsp;</a></td>
		<td><%=fieldname%> </td>
		<td><%=field.getOther()%></td>
        <td>&nbsp;</td>
	</tr>
      <%}else{%>
	<tr id="tr_<%=fid%>" class="<%=(jj%2==0)?"rows2":"rows1"%>" oldclass="<%=(jj%2==0)?"rows2":"rows1"%>"  ItemID="<%=fid%>" onDblClick="showInfo(<%=fid%>);"> 
      	<td><a href="#" onClick="showInfo(<%=fid%>);">&nbsp;<%=fielddesc%> </a></td>
		<td><%=fieldname%> </td>
		<td><%=field.getFieldHtml()%></td>
        <td>&nbsp;</td>
	</tr>
      <%}%>
<%}%>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<%}%>
<!-- end-->

<form name="form" action="form_view.jsp?ShowAll=1&ChannelID=<%=ChannelID%>" method="post">
<input type="hidden" name="FieldGroupTab" value="">
<input type="hidden" name="GroupID" value="">
<input type="hidden" name="FieldID" value="">
<input type="hidden" name="Action" value="">
</form>
<form name="order" action="field_order.jsp"	method="post">
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
<input type="hidden" name="number" value="">
<input type="hidden" name="FieldGroupTab" value="">
<input type="hidden" name="id" value="">
<input type="hidden" name="direction" value="">
</form>

</body>
</html>
