<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
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
int S_Level				=	getIntParameter(request,"Level_");
int S_Parent			=	getIntParameter(request,"Parent");

int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

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

//获取频道路径
String parentChannelPath = getParentChannelPath(channel);
%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>内容列表</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">  
    <link rel="stylesheet" href="../style/2018/common.css">
	 <script src="../lib/2018/jquery/jquery.js"></script>
     <script type="text/javascript" src="../common/2018/common2018.js"></script>
     <script type="text/javascript" src="../common/2018/content.js"></script>

	<style>
      ul,li{list-style: none;}
      .collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
      .search-box {display: none;}
      .border-radius-5{border-radius: 5px;}
      .topic-list-box{padding: 20px;min-height: 700px;}
      .topicItem{float: left;}
      .topicItem:nth-child(n+2){border-left: none;}
      .topicItem1{width:199px;border: 1px solid #bbbbbb;height: 720px;}      
      ul li{padding: 0px 10px;cursor: pointer;border-bottom: 1px solid #bbbbbb;
      	line-height: 36px;display: flex;
      	justify-content: space-between;align-items: center;}
      ul li a{color: #495057;display: inline-block;}
      ul li .fa{font-size: 20px;display: none;}
      ul li.on{background: #ced4da;}
      ul li.on a{color: #000;}
      ul li[hasnext="1"] .fa{display: block;}
      ul li.cur{background: #23bf08;}
      ul li.cur a{color: #fff;}
      ul li.cur .fa{color: #fff;}
    </style>
<script>
var globalid_=0;
var ChannelID = <%=ChannelID%>;
var listType=0;
</script>	
  </head>
  <body class="collapsed-menu" onload="importFirst()"> 
    <div class="br-mainpanel br-mainpanel-file" id="js-source">      
      <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active"><%=parentChannelPath%></span>
        </nav>
       </div><!-- br-pageheader -->
      <div class="br-pagebody pd-x-20 mg-t-25" id="category">
        <div class="card bd-0 shadow-base">
		   <input type="hidden" name="hide" id="hideinfo" value=""/>
          <div class="topic-list-box class_manage c_m_main" id="category_manage">
          	
          </div>         
        </div>
      </div><!-- br-pagebody -->
       
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

   
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>    
    <script src="../common/2018/bracket.js"></script>    
    <script>
      $(function(){
       
//      $('.topicItem').perfectScrollbar();
        $(".topicItem").delegate("li","click",function(){
        	$(".topicItem li.cur").removeClass("cur");
        	$(this).addClass("cur");
        })
  
      });
	//获取屏幕的宽高
	var viewH = $(window).height();
	var viewW = $(window).width();

function importFirst()
{
	//跳转到返回页面
	var url="../category/shownextinfo_new2018.jsp?channelid="+ChannelID+"&level=0";
	$.ajax({
		type: "GET",
		url: url,
		success: function(msg)
		{
			$(".c_m_main").append(msg);
			clickinfo();
		}
	});
}
 
function double_click()
{
	$(".class_manage li").dblclick(function(){
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
		var url="../category/shownextinfo_new2018.jsp?itemid="+itemid+"&channelid="+ChannelID+"&level="+level+"&haschild="+haschild;
		
			$.ajax({
				type: "GET",
				url: url,
				success: function(msg)
				{
					//关闭子类信息
					var size = $(".c_m_box").length;
					
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
 $(function(){
	$(".topicItem").delegate("li","click",function(){
		$(".topicItem li.cur").removeClass("cur");
		$(this).addClass("cur");
	})

 }); 

function getRadio(){
	var result = "";
	
	var globalid = $(".cur").attr("globalid");
	var level = $(".cur").attr("level");

	if(level==1){
		alert("请选择二级话题！");
	    return "false";	
	}

	if(typeof(globalid) == 'undefined'){

		alert("请选择一个话题！");
	    return "false";	
	}

	result = globalid;

	return result;	
}

    </script>
  </body>
</html>