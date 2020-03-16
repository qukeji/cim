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
int id = getIntParameter(request,"ChannelID");
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
int S_Level				=	getIntParameter(request,"Level_");
int S_Parent			=	getIntParameter(request,"Parent");

int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

String field = getParameter(request,"field");
String type = getParameter(request,"type");
boolean listAll = false;

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1+"&Level"+S_Level+"&Parent="+S_Parent;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}

boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);

String SiteAddress = channel.getSite().getUrl();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>分类结构功能</title>
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
<link href="../style/tidecms7.css" type="text/css" rel="stylesheet" />
</head>
<script>
var globalid_=0;
var ChannelID = <%=ChannelID%>;
var listType=0;

//定义一个数组，来接收各级文本内容
var path = new Array();

//递归调用，从最后一级向前遍历
function iteretors(level,pid)
{
	var i=level-1;
	//获取从最后一级的上一级li标签内容，赋值给pre对象
	var pre = $("li[level="+i+"]");
	//遍历pre
	$.each(pre,function(index,obj)
	{
		//得到pre对象的itemid
		var temp = $(obj).attr("itemid");
		//判断得到itemid和最后一级父元素的parent是否相等
		if(temp==pid)
		{	
			//得到pre对象的level，parent和文本内容
			var pre_level = $(obj).attr("level");
			var pre_title = $(obj).text();
			pid = $(obj).attr("parent"); 
			//把得到的文本内容追加到path数组的最前面位置
			path.unshift(pre_title);
			
			//判断level属于哪一级
			if(pre_level>0)
			{
				//递归
				iteretors(pre_level,pid);
			}
		}
	});		
}

//对最后一级实现双击事件，获取parent，level和本文内容
function selectContent(obj,field)
{
		
	var parent_gid = $(obj).attr("parent");
	var level = $(obj).attr("level");
	var title = $(obj).text();
	//把得到的文本内容追加到path数组的最前面位置
	path.unshift(title);
	//调用iteretors函数
	iteretors(level,parent_gid);	
	//当双击事件触发后，对话框关闭，并把得到path数组转换成String类型并显示给ID为kind的input
	parent.getDialog().Close(
		{
				close:function()
				{
					path.shift();//删除第一个元素
					parent.$("#"+field).val(path.join())
				}
			}
		);
}
</script>
<body onload="importFirst()">
 
<div class="content_2012" id="category"><!-- 此处class名由“content”改为“content_2012”，并删除content-top、content_bot两个层 -->
    <div class="viewpane">
		<input type="hidden" name="hide" id="hideinfo" value=""/>
    	<div id="category_manage" class="class_manage" style="height:505px;width:900px;"><!-- 高度=屏幕高度-105px，宽度=屏幕宽度-244px -->
        	<div class="c_m_main" style="width:606px;"><!-- 宽度=c_m_box的个数x200px-1px -->
                
            </div>
        </div>
    </div>
</div>
<script>
//获取屏幕的宽高
var viewH = $(window).height();
var viewW = $(window).width();
function importFirst(){
	var url="../category/shownextinfo.jsp?channelid="+ChannelID+"&level=0&field=<%=field%>&type=<%=type%>";
	$.ajax({
		type: "GET",
		url: url,
		success: function(msg){
			$(".c_m_main").append(msg);
			//$(".c_m_box").width(500);
			$(".c_m_box").height(viewH-105);
			$(".class_manage").height(viewH-105);
			var size = $(".c_m_box").length;
			$(".c_m_main").width(size*200-1);
			$(".class_manage").width(size*200-1);
			clickinfo();
			//double_click();
			//document.location.href=document.location.href;
		}
	});
}
 
function double_click()
{
	$(".class_manage li").dblclick(function()
	{
		var itemid = $(".cur").attr("itemid");
		window.console.info(itemid);
	});
}

function clickinfo()
{
	$(".c_m_box ul li").click(function()
	{

		$(".c_m_box ul li[class='cur']").attr("class","on");
		$(".c_m_box ul li").removeClass("cur");
		
		$(this).addClass("on cur");
		
		var leve = $(".c_m_box ul li[class='on cur']").attr("level");
		 
		$(".c_m_box ul li[level="+leve+"]").removeClass("on");

		var haschild = $(".cur").attr("hasNext");	
		
		if(haschild==0)
		{
			var leve2 = $(".c_m_box ul li[class='no_arrow on cur']").attr("level");
			$(".c_m_box ul li[level="+leve2+"]").removeClass("on");
		}
		var itemid = $(".cur").attr("itemid");
		var level = $(".cur").attr("level");
		var url="../category/shownextinfo.jsp?itemid="+itemid+"&channelid="+ChannelID+"&level="+level+"&haschild="+haschild+"&field=<%=field%>";
		
			$.ajax({
				type: "GET",
				url: url,
				success: function(msg)
				{
					//关闭子类信息
					var size = $(".c_m_box").length;
					//window.console.info("size1:"+size);
					for(var i=size ; i>0 ; i--)
					{
						$("#level"+(parseInt(level)+i)).remove();
					}
					$(".c_m_main").append(msg);
					var size2 = $(".c_m_box").length;
					for(var i=size2 ; i>1 ; i--)
					{
						$("#level"+(parseInt(level)+i)).remove();
					}
					var size2 = $(".c_m_box").length;
					//设置宽高
					$(".c_m_box").height(viewH-105);
					$(".c_m_main").width(size2*200-1);
					$(".class_manage").width(size2*200-1);
					$(".class_manage").height(viewH-105);
					
					var m_w = $(".class_manage").width();
					
					if(((size2)*200-1)>(viewW-36))
					{
						$(".class_manage").width(viewW-36);
					}
					
					document.getElementById('category_manage').scrollLeft = (document.documentElement.scrollWidth);
					clickinfo();
				}
				
			});

		$(".c_m_box ul li").unbind('click');//解除绑定
	});
}
/*
1、class_manage层：高度=屏幕高度-105px；（当宽度>c_m_main层的宽度时，宽度=c_m_box层的个数x200px-1px，当宽度<c_m_main层的宽度时，宽度=屏幕宽度-244px；）
2、c_m_main层：宽度=c_m_box层的个数x200px-1px；
3、c_m_box层：高度=屏幕高度-105px；第一个c_m_box层需要加first类名； 屏幕$(window).height()$(window).width()
*/

function update(json){
	
	var action = json.action;
	var itemid = json.itemid;
	var globalid = json.globalid;
	var title = json.title;
	var level = json.level;
	
	//action=3更新
	if(action==3)
	{
		$(".c_m_box ul li[class *='cur']").html(title);
	}
	else
	{
		//action其它情况都是添加操作
		if(level==0)
		{
			level=1;
		}
		
		var str = "<li globalid=\""+globalid+"\" level=\""+level+"\" itemid=\""+itemid+"\" hasnext=\"0\" class=\"no_arrow\">"+title+"</li>";
		
		$("#level"+level+" ul").append(str);
		
		if(action==2)
		{
			var le  = 	$(".c_m_box ul li[class='no_arrow cur']").attr("level");
			$(".c_m_box ul li[class='no_arrow cur']").attr("hasnext","1");
			$(".c_m_box ul li[class='no_arrow cur']").attr("class","cur");
			$(".c_m_box ul li[class='cur']").click(function(){});
			$(".c_m_box ul li[class='cur']").click();
		}
	}
	clickinfo();
}

</script>

</body>
</html>
