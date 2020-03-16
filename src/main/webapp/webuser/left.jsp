<%@ page import="tidemedia.cms.system.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
String menu = getParameter(request,"menu");
//out.println("menu="+menu);
//Tree tree = new Tree();

//String channel_tree_string = "";
//int id = getIntParameter(request,"id");
//Channel ch = CmsCache.getChannel(id);
//channel_tree_string = tree.listChannel_content_JS(id,"tree",userinfo_session,100);
JSONArray ja = new JSONArray();
String leftname = "";
if(menu.equalsIgnoreCase("webuser")){
	leftname = "用户管理";
	JSONObject jo = new JSONObject();
	jo.put("id",0);
	jo.put("name","注册用户");
	jo.put("url","user_content.jsp");
	jo.put("img","../images/channel_icon/07.png");
	ja.put(jo);
}else if(menu.equalsIgnoreCase("manage")){
	leftname = "交互管理";
	JSONObject jo = new JSONObject();
	jo.put("id",0);
	jo.put("name","评论");
	jo.put("img","../images/channel_icon/30.png");
	jo.put("url","content_comments.jsp");
	ja.put(jo);
	jo = new JSONObject();
	jo.put("id",3);
	jo.put("name","收藏");
	jo.put("img","../images/channel_icon/32.png");
	jo.put("url","content_collection.jsp");
	ja.put(jo);
	jo = new JSONObject();
	jo.put("id",1);
	jo.put("name","爆料");
	jo.put("img","../images/channel_icon/07.png");
	jo.put("url","content_baoliao.jsp");
	ja.put(jo);
	jo = new JSONObject();
	jo.put("id",2);
	jo.put("name","意见反馈");
	jo.put("img","../images/channel_icon/47.png");
	jo.put("url","content_feedback.jsp");
	ja.put(jo);
	jo = new JSONObject();
	jo.put("id",4);
	jo.put("name","图片");
	jo.put("img","../images/channel_icon/170.png");
	jo.put("url","content_pic.jsp");
	ja.put(jo);
	jo = new JSONObject();
	jo.put("id",5);
	jo.put("name","动作");
	jo.put("url","content_action.jsp");
	ja.put(jo);
}else if(menu.equalsIgnoreCase("content")){
	leftname = "内容管理";
	JSONObject jo = new JSONObject();
	jo.put("id",0);
	jo.put("name","视频");
	jo.put("url","../content/content_video.jsp");
	ja.put(jo);

	jo = new JSONObject();
	jo.put("id",2);
	jo.put("name","文章");
	jo.put("url","../content/content_doc.jsp");
	ja.put(jo);
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<style>
html{*padding:69px 0 4px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/xtree_drag.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>


<script language=javascript>
var ja = <%=ja%>;
var channel_tree_id_path = getCookie("webuser_<%=menu%>");
var node = null;

function init()
{
	//ContextMenu.intializeContextMenu()
	//try{

	if(channel_tree_id_path)
	{//alert(channel_tree_id_path);
		node = tree;
		var array = channel_tree_id_path.split(",");
		parent.frames["ifm_right"].location = "../content/content.jsp?id=" + array[array.length-1];
		doExpandByCookie();

	}
}

function doExpandByCookie()
{//alert(channel_tree_id_path + ":" + node.text + ":" + node.src);
	if(!channel_tree_id_path || channel_tree_id_path=="") return;
	var array = channel_tree_id_path.split(",");
	for(var i = 0; i < array.length; i++)
	{//alert(node.text + ":" + node.src+":"+array.length);
		var id = array[i];
		if(node && node.src!="")
		{
			var s = "";
			for(j=i;j<array.length;j++)
			{
				if(j==i) 
					s = array[j];
				else
					s += "," + array[j];
			}
			channel_tree_id_path = s;
			break;
		}
		else
		{
			node = getNodeByChannelID(node,id);
			if(id>0 && i!=array.length-1) node.expand();
		}

		if(array.length-1 == i && node) 	{channel_tree_id_path="";node.select();}
	}
}

function doExpandXmlNodeByCookie()
{//alert(channel_tree_id_path + ":" + node.src);
	if(!channel_tree_id_path || channel_tree_id_path=="") return;
	var array = channel_tree_id_path.split(",");
	for(var i = 0; i < 1; i++)
	{//alert(i + ":" + node.src);
		var id = array[i];
		var s = "";
		for(j=1;j<array.length;j++)
		{
			if(j==1) 
				s = array[j];
			else
				s += "," + array[j];
		}
		channel_tree_id_path = s;//node.expand();//alert(node);
		node = getNodeByChannelID(node,id);

		if(array.length-1 == i && node) 	{channel_tree_id_path=""; node.select();node.parentNode.deSelect();}
		else{node.expand();}
	}
}

function getNodeByChannelID(node,id)
{//alert(channel_tree_id_path);
	if(id==0) return tree;
	if(node==null || node.childNodes==null) return null;
	for (var i = 0; i < node.childNodes.length; i++) {
		if(document.getElementById(node.childNodes[i].id+"-anchor").getAttribute("ChannelID")==id)
			return node.childNodes[i];
	}
	return null;
}

function OnDropTarget(event,obj)
{
	var objid = obj.id;
	var right_window = tidecms.getRightIfm();
	if(!right_window)
		return true;

	var ChannelID_Source = 0;
	if(right_window.CategoryID>0)
		ChannelID_Source = right_window.CategoryID;
	else
		ChannelID_Source = right_window.ChannelID;

	obj = $("#"+obj.id + '-anchor');
	var ChannelID_Dest = obj.attr("ChannelID");

	if(ChannelID_Dest != ChannelID_Source)
	{
		var curr_row;
		var selectedNumber = 0;
		var selectedItem = "";
		var selectedItemTitle = "";

		var rightObj=right_window.getCheckbox();
		
		if(rightObj.length==0){
				alert("请先选择要复制的文档！");
				return false;
		}
	
	    var message;
        var type=0;
		if(event.ctrlKey || event.shiftKey){
			 message ="确实要移动这"+rightObj.length+"项到 \"" + obj.text() + "\" 吗？";
			 type=1;
		}else{
			 message ="确实要复制这"+rightObj.length+"项到 \"" + obj.text() + "\" 吗？";
			 type=0;
		}
		if(confirm(message))
			{
			  //window.frames["CopyDocuments"].location = "document_copy.jsp?ItemID=" + rightObj.id+"&SourceChannel="+ChannelID_Source+"&DestChannel="+ChannelID_Dest+"&Type="+type;
			  var url="../content/document_copy.jsp?ItemID=" + rightObj.id+"&SourceChannel="+ChannelID_Source+"&DestChannel="+ChannelID_Dest+"&Type="+type;
			  //alert(url);
			  $.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg)
					 {
					 if(type==1) {alert("移动成功.");parent.right.location.reload();}
					 if(type==0) alert("复制成功.");
					 document.getElementById(objid + '-anchor').style.border = "";
					 }   
			});  
			}
			$("#"+objid).css("background","");
			return false;
	}

	return false;
}

</script>
<head>

<body onload="init();">
<div class="menu_top_2012">
	<div class="m_t_main">
		<div class="m_t_title"><img src="../images/sns.png" />当前结构</div>
	</div>
</div>
<div class="menu_main_2012" id="div1">
<script language="javascript">
function show(id)
{
	var url = "";
	for(var i=0; i<ja.length; i++)  
	{  
		if(ja[i].id==id){
			url = ja[i].url;
		}
 	}
	
	
	parent.frames["ifm_right"].location = url;
}

function showsource(id)
{
	try{
	if (tree.getSelected())
	{
		//alert(document.getElementById(tree.getSelected().id + '-anchor').ChannelID);
		var channel_tree_id_path = getNodePath("",tree.getSelected()) + id;
		var expires = new Date();
		expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
		//document.cookie = "source_channel_path=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
	}
	}catch(e){}

	if(id<0)
		return;

	parent.frames["ifm_right"].location = "../source/source_content.jsp?id=" + id;
}

//function init()
//{
if (document.getElementById) {
	var tree = new WebFXTree('<%=leftname%>','javascript:show(0)\" ChannelID=\"0');
	tree.setBehavior('classic');
 for(var o in ja){  

	//alert(o);  
    //alert(ja[o]);  
    //alert("text:"+ja[o].name+" value:"+ja[o].id ); 
 }
 for(var i=0; i<ja.length; i++)  
 {  
	var one = new WebFXTreeItem(ja[i].name,'javascript:show('+ja[i].id+');','', ja[i].img, ja[i].img);
	tree.add(one);  
 }
	document.write(tree);
	if(tree.childNodes.length==1)
		tree.childNodes[0].expand();
}
//}
show(0);
</script>
</div>
<div style="display:none"><iframe id="CopyDocuments" style="display:none;width: 0; height: 0;" src="about:blank"></iframe></div>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
