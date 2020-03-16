<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.net.*,
				java.text.*,
				java.io.*,
				org.json.*,
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
int gid=getIntParameter(request,"globalid");
String updated_message="";
String update_before_message="";
String content_ = Util.connectHttpUrl("http://www.tidecms.com/cms/update/api_getupdate.jsp","utf-8");
//out.println("gid="+gid+"    content_="+content_);
JSONArray ja_ = new JSONArray(content_);
for(int i=0;i<ja_.length();i++){
	JSONObject jo_ = ja_.getJSONObject(i);

	int id_=jo_.getInt("id");
				
	if(gid==id_){
		updated_message=jo_.getString("updated_message");
		update_before_message=jo_.getString("update_before_message");
	}
}
//out.println("updated_message="+updated_message);
//out.println("update_before_message="+update_before_message);


//gid=6;
int index=getIntParameter(request,"index");
//out.println("gid="+gid);
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

if(channel.getListProgram().length()>0)
{response.sendRedirect(channel.getListProgram()+"?id="+id);return;}


int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list",request.getCookies()));
if(listType==0) listType = 1;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}

boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);
boolean canDelete = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanDelete);
boolean canAdd = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanAdd);
String SiteAddress = channel.getSite().getUrl();
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
<script>
var listType = <%=listType%>;
var rows = <%=rows%>;
var cols = <%=cols%>;
var ChannelID = <%=ChannelID%>;
var currRowsPerPage = <%=rowsPerPage%>;
var currPage = <%=currPage%>;
var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var pageName = "<%=pageName%>";
if(pageName=="") pageName = "content.jsp";

function gopage(currpage)
{
	var url = pageName + "?currPage="+currpage+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
	this.location = url;
}

function list(str)
{
	var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
	if(typeof(str)!='undefined')
		url += "&" + str;
	this.location = url;
}
function double_click()
{

}
function shengji(index)
{
	var url='update/files_content.jsp?index='+index;
	//url+='&ChannelName=<%=java.net.URLEncoder.encode(channel.getName(),"UTF-8")%>';
	var	dialog = new top.TideDialog();
		dialog.setWidth(600);
		dialog.setHeight(400);
		dialog.setUrl(url);
		dialog.setTitle("新建专题频道");
		dialog.show();
}
function download(gid)
{

	$.ajax({
		type:"get",
		url:"download_update.jsp?id="+gid,
		//data:"globalid="+ gid ,
		async:true,
		success: function(msg){
			//$(".v2").val('已下载');
			//alert(msg);
			$(".isdownload").html("<font color='green'>已下载</font>");
			//&("#submitButton").html("style:'display:none'");
			document.getElementById("submitButton").type="hidden";
			//document.getElementById("submitButton").type="hidden";
			document.getElementById("buttonClose").value="关闭";
			$("#update_before_message").hide();
			$("#updated_message").show();
		}
	});
	//top.TideDialogClose();

}
</script>
</head>
<body>


<div class="content">
<div class="viewpane">
<%if(channel.hasRight(userinfo_session,1)){
String listcss = "";
if(listType==1) listcss = "viewpane_tbdoy";
	%>
        <div class="<%=listcss%>">
<table width="100%" border="0" id="oTable" class="view_table">
<%if(listType==1){%>
<thead>
		<tr id="oTable_th">
    				
    				<th class="v3" style="padding-left:10px;text-align:left;">文件名</th>
					<th class="v1"	align="center" valign="middle">大小</th>
    				
					
					<th class="v2"	align="center" valign="middle">状态</th>
  				</tr>
</thead>
<%}%>
 <tbody> 
<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;


int j=0;
int m=0;

int TotalPageNumber=2;
int TotalNumber=0;

String title_json="";
String summary_json="";
String content_json = Util.connectHttpUrl("http://www.tidecms.com/cms/update/api_getupdatefiles.jsp?id="+gid,"utf-8");
String files="";
String filename="";
String fileurl="";
String filesize="";
String publishdate_json="";
String publishdate="";
JSONObject jo=new JSONObject(content_json);
JSONArray ja = jo.getJSONArray("files");
for(int i=0;i<ja.length();i++){
	JSONObject jo_=ja.getJSONObject(i);
	filename=jo_.getString("filename");
	fileurl=jo_.getString("url");
	filesize=jo_.getString("filesize");
	publishdate_json=jo_.getString("PublishDate");
	publishdate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",Long.parseLong(publishdate_json)*1000);
	int filesize2=Integer.parseInt(filesize);
	if(filesize2>=0){
		filesize = filesize2/1024 +1 +"k";
	}
if(listType==1)
{
%>
  <tr class="tide_item">
    
    <td class="v3" style="font-weight:700;" ondragstart="OnDragStart (event)">
	<img id="img_<%=j%>" src="../images/tree6.png"/><%=fileurl+filename%></td>
	<td class="v3" align="center" valign="middle"><%=filesize%></td>
	
	
	<td class="v2" align="center" valign="middle"><span class="isdownload"><font color='red'>等待下载</font></span></td>
  </tr>
  <%

	}
					
			
}
%>


 </tbody> 
</table>
</div>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',TotalPageNumber:<%=TotalPageNumber%>};
</script>        
   
  </div>
</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div id="update_before_message">
<%=update_before_message%>
</div>
<div id="updated_message" style="display:none">
<%=updated_message%>
</div>
<%}else{%>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',TotalPageNumber:0};
</script> 
<%}%>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<div   align="center">
<input name="startButton" type="button" class="button" value=" 确定 " id="submitButton" onclick="download(<%=gid%>);" />
      &nbsp; 
<input name="Submit2" type="button" class="button" value="  取  消  " id="buttonClose" onclick="top.TideDialogClose();"/>
</div>
</body>
</html>
