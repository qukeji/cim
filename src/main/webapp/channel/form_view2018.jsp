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


	int		ChannelID		= getIntParameter(request,"ChannelID"); //频道编码
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
		response.sendRedirect("form_view2018.jsp?ChannelID="+ChannelID);return;
	}

	if(Action.equals("DeleteGroup"))
	{//System.out.println(GroupID);
		FieldGroup fieldGroup = new FieldGroup(GroupID);

		fieldGroup.Delete();

		response.sendRedirect("form_view2018.jsp?ChannelID="+ChannelID);return;
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
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
	<title>TideCMS</title>
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">   
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">  
    <link rel="stylesheet" href="../style/2018/common.css">  
<style>
  	html,body{width: 100%;height: 100%;}
  	label{margin-bottom: 0;}
  </style>
 <script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<!--<script type="text/javascript" src="../common/jquery.js"></script>-->
<!-- <script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script> -->
<script type="text/javascript" src="../common/jquery.scrollTo-min.js"></script>
<script language="javascript">
var group = <%=group%>;
var channelid = <%=ChannelID%>;

function addField()
{
	var url="field_add2018.jsp?ChannelID=<%=ChannelID%>&GroupID="+getSelectedTabID();
	var	dialog = new top.TideDialog();
	dialog.setWidth(650);
	dialog.setHeight(550);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("添加字段");
	dialog.setScroll('auto');
	dialog.show(); 
}

function addFieldGroup()
{
	var url="fieldgroup_add2018.jsp?ChannelID=<%=ChannelID%>";
	var	dialog = new top.TideDialog();
	dialog.setWidth(550);
	dialog.setHeight(450);
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
	dialog.setHeight(350);
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
	dialog.setHeight(350);
	dialog.setUrl(url);
	dialog.setTitle("添加集合组");
	dialog.show();
}

function editFieldGroup()
{
	var url="fieldgroup_edit2018.jsp?GroupID="+getSelectedTabID();
	var	dialog = new top.TideDialog();
	dialog.setWidth(550);
	dialog.setHeight(350);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("修改组名");
	dialog.show();
}

function delFieldGroup()
{
	var url="fieldgroup_del2018.jsp?Groupid="+getSelectedTabID();
	var	dialog = new top.TideDialog();
	dialog.setWidth(320);
	dialog.setHeight(260);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("删除分组");
	dialog.show();		
	//if(confirm('你确认要删除吗?')) 
	//{
	//	this.location = "form_view2018.jsp?Action=DeleteGroup&GroupID="+getSelectedTabID()+"&ChannelID=<%=channel.getId()%>";
	//}
}

function delField(fid,name)
{
	
	var url="field_del2018.jsp?fid="+fid+"&FieldName="+name;
	var	dialog = new top.TideDialog();
	dialog.setWidth(320);
	dialog.setHeight(260);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("删除字段");
	dialog.show();	
	//if(confirm('你确认要删除字段 ' + name + ' 吗? 删除以后无法恢复!')) 
	//{
	//	var url="../channel/field_delete.jsp?id="+fid;
	//	jQuery.ajax({
	//		type: "GET",
	//		url: url,
	//		success: function(msg){
	//				$("#tr_"+fid).remove();
	//			}
	// 		});
	//}
}

function editField(fieldid) 
{
	var url="field_edit2018.jsp?FieldID="+fieldid;
	var	dialog = new top.TideDialog();
	dialog.setWidth(620);
	dialog.setHeight(550);
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
		var s = "form_view2018.jsp?ChannelID="+channelid;
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
		if(o.hasClass("active"))
		{
			return o.attr("groupid");
		}
	}

	return 0;
}

function sort(o)
{
	var start_sort = false;
	var fixHelper = function(e, ui) {  
	    //console.log(ui)   
	    ui.children().each(function() {  
		    $(this).width($(this).width());  //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理
		    $(this).css({"background":"#f2f2f2"})
		});  
	    return ui;  
	}; 
	jQuery("#form"+o).sortable({
		items:"tr",
		axis:"y",
		cursor:"move",
		helper: fixHelper,
		handle:".drag-list",
		containment: "table",
		start:function(e,ui){
			//var $p=jQuery(ui.placeholder);
			//$p.css({visibility:'visible',height:'20px'});
			//$p.html('<td colspan="7">   </td>');
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
function NewSort(classNum,ItemId,GroupNum){
	var url="field_order2018.jsp?GroupID="+getSelectedTabID()+"&ChannelID="+channelid+"&classNum="+classNum+"&ItemID="+ItemId+"&GroupNum="+GroupNum;
	var	dialog = new top.TideDialog();
	dialog.setWidth(300);
	dialog.setHeight(230);
	dialog.setSuffix('_2');
	dialog.setUrl(url);
	dialog.setTitle("排序");
	dialog.show();		
}
</script>
</head>
<body class="" onLoad="init()">
<div class="bg-white modal-box">
      <%if(fieldGroupArray.size()>0){%>
      <div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
        <ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
<%
int active=0;
for (int i = 0; i < fieldGroupArray.size(); i++) 
{
	active++;
	FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
	boolean gshow = false;
	if(show_groupid>0)
	{
		if(fieldGroup.getId()==show_groupid) gshow = true;
	}
	else if(i==0) gshow = true;
%>		
          <li class="nav-item "><a class="nav-link <%=(active!=1 ?"":"active")%> <%=(gshow)?"cur":""%>" data-toggle="tab" href="javascript:;" role="tab" id="form<%=active%>_td" groupid="<%=fieldGroup.getId()%>"><%=fieldGroup.getName()%></a></li>
<%}%>                  
        </ul>        
        <ul id="" class="mg-l-10 add-group list-inline" >          
          <li class=""><a id="" class="" href="javascript:;" role="tab" onClick="addFieldGroup()"><i class="fa fa-plus-circle mg-r-2 tx-black"></i>添加组</a></li>
        </ul>        
      </div>
	    <div class="modal-body pd-20 overflow-y-auto" >
	        <div class="config-box">
	       	  <ul >
<%
int block=0;
for (int j = 0; j < fieldGroupArray.size(); j++) 
{
	block++;
	FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(j);
	boolean gshow = false;
	if(show_groupid>0)
	{
		if(fieldGroup.getId()==show_groupid) gshow = true;
	}
	else if(j==0) gshow = true;
%>
	       	  	<!--基本信息-->
	       		  <li <%=(block!=1 ?"":"class=\"block\"")%> id="form<%=j+1%>">
	       		  	<div class="bd">	       		  		
		       		  	<table class="table mg-b-0 templet-table">
				            <thead>
				              <tr>	               
				                <th class="tx-12-force tx-mont tx-medium wd-180">描述</th>
				                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-130">名称</th>
								  <!--<th class="tx-12-force tx-mont tx-medium hidden-xs-down">字段内容</th>-->
				                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120">操作</th>	               
				              </tr>
				            </thead>
				            <tbody class="handle-list">
<%
ArrayList arraylist = channel.getFieldsByGroup(fieldGroup.getId(),j );

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
				                <td><span class="pd-l-5"><%=fielddesc%></span></td>
				                <td class="hidden-xs-down"><%=fieldname%> </td>
				                <%--<td class="hidden-xs-down">--%>
				                	<%--<label class="wd-300">--%>
						                <%--<input class="form-control" placeholder="" type="text" >--%>
						              <%--</label>--%>
				                <%--</td>	                			                --%>
				                <td class=" hidden-xs-down">
				                	<a href="javascript:NewSort(<%=jj%>,<%=fid%>,<%=j%>);" class="mg-r-10 drag-handle drag-list"><i class="fa fa-arrows tx-20" aria-hidden="true"></i> </a>
				                  <a href="javascript:editField(<%=fid%>)" class="drag-handle"><i class="fa fa-pencil-square-o tx-20" aria-hidden="true"></i></a>           			                        
				                   <%if(field.getFieldLevel()==2){%>
								   <a class="mg-l-5" href="javascript:delField(<%=fid%>,'<%=fieldname%>')" class="drag-handle"><i class="fa fa-trash-o tx-20" aria-hidden="true"></i> </a>
							       <%}%>
							  </td>
				              </tr>
				            
<%}%>
                             </tbody>
				          </table>				          
	       		  	</div>	       	
	       		  </li>
<%}%>       		  
	       	  </ul>
	        </div>
	                   
	    </div><!-- modal-body -->

<%}else{%>    
  <div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">       
        <ul id="" class="mg-l-10 add-group list-inline" >          
          <li class=""><a id="" class="" href="javascript:;" role="tab"><i class="fa fa-plus-circle mg-r-2 tx-black"></i>添加组</a></li>
        </ul>        
      </div>
	    <div class="modal-body pd-20 overflow-y-auto">
	        <div class="config-box">
	       	  <ul >
	       	  	<!--基本信息-->
	       		  <li >
	       		  	<div class="bd">	       		  		
		       		  	<table class="table mg-b-0 templet-table">				            							
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
				              <tr id="tr_<%=fid%>"  oldclass="<%=(jj%2==0)?"rows2":"rows1"%>"  ItemID="<%=fid%>" onDblClick="showInfo(<%=fid%>);">	                
				                <td><a href="#" onClick="showInfo(<%=fid%>);"> </a></td>
				                <td class="hidden-xs-down"><%=fieldname%> </td>
				                <td class="hidden-xs-down"><%=field.getOther()%></td>	                			                
				                <td class=" hidden-xs-down"> </td>
				              </tr>
				          <%}else{%> 
                           <tr id="tr_<%=fid%>" oldclass="<%=(jj%2==0)?"rows2":"rows1"%>"  ItemID="<%=fid%>" onDblClick="showInfo(<%=fid%>);">	                
				                <td><a href="#" onClick="showInfo(<%=fid%>);"> <%=fielddesc%> </a></td>
				                <td class="hidden-xs-down"><%=fieldname%></td>
				                <td class="hidden-xs-down"><%=field.getFieldHtml()%></td>	                			                
				                <td class=" hidden-xs-down"> </td>
				           </tr>
						  <%}%> 
						  <%}%>
				          </table>				          
	       		  	</div>	       	
	       		  </li>
	       		  
	       	  </ul>
	        </div>	                   
	    </div>
<%}%>
 <div class="btn-box" >
      	<div class="modal-footer" >
      		<button type="button" class="btn btn-primary tx-size-xs" onClick="addField()">添加字段</button>
		     <%if(group>0){%><button type="button" class="btn btn-primary tx-size-xs" onClick="editFieldGroup()">重命名</button>
		      <button type="button"  class="btn btn-primary tx-size-xs" onClick="delFieldGroup()">删除本组</button><%}%>
		    </div> 
      </div>
<form name="form" action="form_view2018.jsp?ShowAll=1&ChannelID=<%=ChannelID%>" method="post">
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
</div>

    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    
    <!-- <script src="../common/2018/Sortable.min.js"></script> -->
    <script src="../common/2018/bracket.js"></script>
    
    <script>    	 	
      $(function(){
      	//表单组切换
      	$("#form_nav").delegate("li","click",function(){
      		var _index = $(this).index();
      		console.log(_index)
      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
      	  // initSort();
      	   $(".modal-body").scrollTop(0) ;
      	});
      	
      	//新增字段组       
        function addGroup(){
        	var groupHtml ='<li>' +
                '<div class="bd">	'+
		       		  	'<table class="table mg-b-0 templet-table">'+
				            '<thead>'+
				              '<tr>'+	               
				                '<th class="tx-12-force tx-mont tx-medium wd-180">名称</th>'+
				                '<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-130">字段名</th>'+
				                '<th class="tx-12-force tx-mont tx-medium hidden-xs-down">字段样式</th>	'	+	                          
				                '<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120">操作</th>	'     +          
				              '</tr>'+
				            '</thead>'+
				            '<tbody class="handle-list">'+
				            '</tbody>'+
				          '</table>'+				          
	       		  	'</div>'+
	       		  '</li>'  ;
        	var groupNameHtml = '<li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">组1</a></li>' ;
        	$(".config-box ul").append(groupHtml) ;
        	$("#form_nav").append(groupNameHtml) ;        	
        }
        
       	//推荐设置锁定图片切换
	      $(".lock-unlock").click(function(){    
	       	var textBox = $(this).parent(".row").find(".textBox") ;       	
	       	if($(this).find("i").hasClass("fa-lock")){      	 
	       	 	$(this).find("i").removeClass("fa-lock").addClass("fa-unlock");       	 	
	       	 	textBox.removeAttr("disabled","").removeClass("disabled")
	       	}else{      	 	
	       	 	$(this).find("i").removeClass("fa-unlock").addClass("fa-lock");
	       	 	textBox.attr("disabled",true).addClass("disabled")
	       	}
	      });
	     
      });
    </script>
</body>
</html>
