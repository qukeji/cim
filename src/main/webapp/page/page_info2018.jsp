<%@ page import ="tidemedia.cms.system.*,
                tidemedia.cms.user.*,
				tidemedia.cms.page.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.*,
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
			path = path + "<span class=\"breadcrumb-item active\">" + ch.getName() + "</span>";// + ((i < arraylist.size() - 1) ? "/" : "");
		}else{
			path = path + "<a class=\"breadcrumb-item\" href=\"javascript:jumpChannel("+ch.getId()+")\">" + ch.getName() + "</a>";// + ((i < arraylist.size() - 1) ? "/" : "");
		}        
      }
    }

    arraylist = null;

    return path;
}
%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"ChannelID");

Channel channel = CmsCache.getChannel(id);

Page p = new Page(id);

String CategoryName = "";
String CategorySerialNo = "";

//if(channel.getType()==2)
//{
//	response.sendRedirect("page.jsp?id="+id);return;
//}

String Action = getParameter(request,"Action");

if(Action.equals("ChangeCanCategory"))
{
	int Status = getIntParameter(request,"Status");
	channel.setCanCategory(Status);

	channel.UpdateCanCategory();

	response.sendRedirect("channel2018.jsp?id="+id);return;
}

String PublishModeDesc = "";
PublishModeDesc = "静态发布";
//获取频道路径
String parentChannelPath = getParentChannelPath(channel);

Channel channelParent = new Channel(channel.getParent());
Channel channelParentParent = new Channel(channelParent.getParent());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
    <title>TideCMS 列表</title>
    
    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
    <link href="../lib/2018/morris.js/morris.css" rel="stylesheet">
    <!--<link href="../../lib/2018/datatables/jquery.dataTables.css" rel="stylesheet">-->
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!--<link href="../../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">-->
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">  
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>
    	.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
    </style>
    <script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
	
<script src="../common/2018/TideDialog2018.js"></script>
    <!--  <script type="text/javascript" src="../common/jquery.js"></script> -->
<script type="text/javascript">

function Page()
{
	  	var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		//var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;

  		var url="../page/page.jsp?id=<%=id%>&Type=1";
		//window.open(url,"",Feature);
		window.open(url,"");
}

function Content()
{
	  	var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		//var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;

  		var url="../page/page.jsp?id=<%=id%>";
		//window.open(url,"",Feature);
		window.open(url,"");
}

function editPage()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(450);
	dialog.setUrl("../page/page_edit22018.jsp?ChannelID=<%=id%>");
	dialog.setTitle("页面属性");
	dialog.show();
}

function deletePage()
{
	var ChannelID = <%=id%>;
	var ChannelName = "<%=channel.getName()%>";
   
    var channelParent = "<%=channel.getParent()%>";
    var channelParentParent = "<%=channelParentParent.getId()%>"
	if(confirm("确实要删除\"" + ChannelName + "\"吗?\r\n警告：页面被删除后不能恢复，如果下面有子频道也将一并删除!")) 
	{
	//	var channel_tree_id_path = tidecms.getCookie("channel_path");//alert(channel_tree_id_path);
	//	if(channel_tree_id_path)
	//	{
	//		channel_tree_id_path = channel_tree_id_path.replace(ChannelID, "");
	//		tidecms.setCookie("channel_path",channel_tree_id_path);
	//	}

	//	tidecms.message("正在删除...");
		var url = "../channel/channel_delete2018.jsp?Action=Delete&id="+ChannelID;
		$.ajax({type:"get",dataType:"json",url: url,success: function(msg){
			//tidecms.notify("删除成功");
			//top.tidecms.getLeftIfm().action({action:3,id:ChannelID});
			if(channelParent == -1){
				top.TideDialogClose({refresh:'left',returnNavValue:{currentid:ChannelID,parentid:-1,type:2,site:true}});
			}else if(channelParentParent==-1){
				top.TideDialogClose({refresh:'left',returnNavValue:{currentid:ChannelID,parentid:channelParent,type:2,site:true}});
			}else{
			    top.TideDialogClose({refresh:'left',returnNavValue:{currentid:ChannelID,parentid:channelParent,type:2,site:false}});
			}
			return;
		}}); 
	}
}
</script>
</head>
<body class="collapsed-menu email">
<div class="content_t1">
	<div class="br-mainpanel br-mainpanel-file" id="channel-manage">      
		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active"><%=channel.getParentChannelPath().replace(">"," / ")%></span>
			</nav>
		</div><!-- br-pageheader -->
		<div class="channel-name mg-l-30 mg-r-30">
      		<div class="channel-name-box">
      			<div class="set-img-box">
      				<img src="../images/2018/channel-setting.png" />
      			</div>
      			<div class="right-info">
					<h5 class="tx-22"><%=channel.getName()%></h5>
					<p class="tx-12">您可以进一步进行页面中模块的内容维护或页面属性的编辑。</p>
      			</div>
      		</div>      	
		</div>
		<div class="br-pagebody">
	  		<div class="br-section-wrapper">
			 <%if (channel.getType()!=3){%>
	  			<div class="channel-preview">
				    <span class="tx-14 mg-r-10">页面属性：<%=channel.getName()%></span>
	  				<span class="tx-14 mg-r-10">[名称：<%=channel.getName()%></span>
	  				<span class="tx-14 mg-r-10">页面地址：<a href="<%=Util.ClearPath(p.getSite().getUrl()+"/"+p.getFullTargetName())%>" target="_blank"><span class="font-blue"><%=p.getTargetName()%></span></a></span>
	  				<span class="tx-14 mg-r-10">编号：<%=channel.getId()%>  ]</span>	  				
	  			</div>
			<%}%>	
	  			<div class="channel-handle mg-t-20 mg-b-20">
	  				<div class="">
					<%if (channel.getType()!=3){%>
					  <a name="Publish" href="javascript:;" class="btn btn-info mg-r-5 mg-b-10" onClick="Content()">维护页面</a>
					  <%if(userinfo_session.isAdministrator() || userinfo_session.getUsername().equals("liuyun")){%>
					  <a name="Publish" href="javascript:;" class="btn btn-info mg-r-5 mg-b-10" onClick="Page()">编辑页面</a>
					  <%}%>					 
					  <%}%>
					   <a href="javascript:;" class="btn btn-info mg-r-5 mg-b-10" onClick="editPage();">修改属性</a>	
					  <%if(!channel.isRootChannel()){%>
					    <a href="javascript:;" class="btn btn-info mg-r-5 mg-b-10" onClick="deletePage();">删除页面</a>  
                      <%}%>	
                       				  
					</div>
	  			</div>
	  		</div>
	  	</div>			
</div>
</div>
</body>
</html>
