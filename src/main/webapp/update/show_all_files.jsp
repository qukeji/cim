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
<%!
    public static String getModifiedTime(String path){   
        File f = new File(path);               
        Calendar cal = Calendar.getInstance();   
        long time = f.lastModified();   
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");          
        cal.setTimeInMillis(time);     
        //System.out.println("修改时间[2] " + formatter.format(cal.getTime()));      
        //输出：修改时间[2]    2009-08-17 10:32:38   
        return formatter.format(cal.getTime());
    }   


	public static List showFiles(String root, List list,int rtype)throws ParseException {
		File file = new File(root);
		//Boolean isFile = false;
		//System.out.println("rtype="+rtype);
		Long filesize=(long) 0;
		if (file.isDirectory()) {
			//System.out.println(file.getPath() + " is a dir");
			File files[] = file.listFiles();
			for (int i = 0; i < files.length; i++) {
				String name = files[i].getName();
				String path = files[i].getPath();
				String lastModifiedTime = getModifiedTime(path);
				filesize=getfileSize(path);
				
				int filetype = 0;
				if (files[i].isFile()){
					filetype=0;
				}else{
					filetype=1;
				}

				if(rtype == 1){
					list.add(path + "," + lastModifiedTime + "," + filesize+","+filetype);
				}else if(rtype == 0){
					if(lastModifiedTime.indexOf(Util.getCurrentDate("yyyy-MM-dd"))>=0){
					//System.out.println(lastModifiedTime);
						list.add(path + "," + lastModifiedTime + "," + filesize+","+filetype);
					}
				}else if(rtype == 2){
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					java.util.Date date = df.parse(lastModifiedTime);
					long lastdate=date.getTime();
					long now=System.currentTimeMillis();
					//System.out.println("7天 ");

					if(lastdate>now-1000*60*60*24*7){
						list.add(path + "," + lastModifiedTime + "," + filesize+","+filetype);
					}
				}else if(rtype ==3){
					//System.out.println("in rtype==3  ");
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					java.util.Date date = df.parse(lastModifiedTime);
					long lastdate=date.getTime();
					long now=System.currentTimeMillis();
					//System.out.println("1个月");
					//System.out.println(lastdate);
					//System.out.println(now-1000*60*60*24*30);
					if(lastdate>now-1000*60*60*24*15-1000*60*60*24*15){
						//System.out.println("in   lastdate> now-1000*60*60*24*30="+(now-1000*60*60*24*30));
						list.add(path + "," + lastModifiedTime + "," + filesize+","+filetype);
					}
				}
				// System.out.println(name);
				if (files[i].isDirectory()) {
					showFiles(path, list,rtype);
				}
			}

		}
		return list;

	}
	public static Long getfileSize(String path){
		File file = new File(path);
		Long filesize = (long) 0;
		if(file.isFile()){
			filesize=file.length();
		}else if(file.isDirectory()){
			File []files = file.listFiles();
			for(int i=0;i<files.length;i++){
				if(files[i].isFile()){
					filesize+=files[i].length();
				}else{
					filesize+=getfileSize(files[i].getPath());
				}
			}
		}
		return filesize;
	}
  public static String formateFileSize(Long filesize){
    	float f;
    	DecimalFormat df = new DecimalFormat("0.0");
    	if(filesize == 0){
    		return "0k";
    	}else if(filesize<1024*1024&&filesize>0){
    		f=(float)filesize/(float)1024;
    		df.format(f);
    		return df.format(f)+"k";
    	}else{
    		f = (float)filesize/(float)(1024*1024);
    		return df.format(f)+"M";
    	}
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
int gid=getIntParameter(request,"globalid");
int index=getIntParameter(request,"index");
int itemid=getIntParameter(request,"itemid");

int rtype=0;
rtype = getIntParameter(request,"rtype");
//out.println(rtype);
//out.println("itemtid="+itemid);
//out.println("show all files");

String cmsPath=request.getSession().getServletContext().getRealPath("");
//out.println("cmsPath"+cmsPath);
cmsPath=cmsPath.replace("\\","/");
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
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<%if(IsWeight==1){%><script type="text/javascript" src="../common/jquery.jeditable.js"></script><%}%>
<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
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
		}
	});
	//top.TideDialogClose();

}
function filecopy(){
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择要添加的文件");
		return;
	}
	var message = "确实要添加这"+obj.length+"项吗？";
	if(!confirm(message)){
		return;
	}
	//alert(obj);
	$.ajax({
	type:"get",
	url:"updated_all_files.jsp?path="+obj.id+"&itemid="+<%=itemid%>+"&globalid="+<%=gid%>,
	async:true,
	success: function(msg){
		alert(msg);
		self.close();
		}
	});
} 
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：批量上传</div>
    <div class="content_new_post"></div>
</div>
<div class="toolbar_l">
        	<span class="toolbar1" style="padding-left:10px;text-align:left;">显示：</span>
            <ul class="toolbar2">
                <li class="first"><a href="show_all_files.jsp?globalid=<%=gid%>&itemid=<%=itemid%>&rtype=0">今天</a></li>
                <li><a href="show_all_files.jsp?globalid=<%=gid%>&itemid=<%=itemid%>&rtype=2">7天内</a></li>
                <li><a href="show_all_files.jsp?globalid=<%=gid%>&itemid=<%=itemid%>&rtype=3">30天内</a></li>
                <li class="last"><a href="show_all_files.jsp?globalid=<%=gid%>&itemid=<%=itemid%>&rtype=1">全部</a></li>
            </ul>
</div>


<div class="content">
<div class="toolbar">
    	<div class="toolbar_l">
        </div>
</div>
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
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;">文件路径</th>
					<th class="v1"	align="center" valign="middle">最后修改时间</th>
    				<th class="v1"	align="center" valign="middle">大小</th>
					
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
String filename="";
//out.println("cmspath前"+cmsPath);
String cmsPath_=cmsPath.replace("/","\\");
//out.println("cmsPath_ ="+cmsPath_);
cmsPath=cmsPath.replace("\\\\","//");
cmsPath=cmsPath.replace("\\","/");
//out.println("cmspath后="+cmsPath);
File file=new File(cmsPath);
//fileFind ff = new fileFind();

String path="";
String[] temp = new String[2];
List<String> list = new ArrayList<String>();
list.clear();

String rootLastModifiedTime = getModifiedTime(cmsPath);
Long rootFileSize=getfileSize(cmsPath);

list.add("/,"+rootLastModifiedTime+","+rootFileSize+",1");


	//out.println(items.length);


	int file_id=0;
	list=showFiles(cmsPath, list,rtype);
for (String li : list) {
	if (li.equals("") || li == null) {
		continue;
	} else {
	path=li.replace(cmsPath_,"");
	path = path.replace("\\","/");
	file_id++;
	String[]items=path.split(",");
	String[] arr = items[0].split("/");

	
%>
  <tr class="tide_item">

     <td class="v1 checkbox" width="25" filepath="<%=items[0]%>" align="center" valign="middle"><input name="id" value="<%=items[0]%>" type="checkbox"/></td>
    <td class="v3" ondragstart="OnDragStart (event)">
	<img id="img_<%=j%>" src="../images/tree6.png"/><%=items[0]%></td>
	<td class="v3" align="center" valign="middle"><%if(items[3].equals("1")){%><%}else{%><%=items[1]%><%}%></td>
	<td class="v1" align="center" valign="middle"><%if(items[3].equals("1")){%><%}else{%><%=formateFileSize(Long.parseLong(items[2]))%><%}%></td>
	
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
<%}else{%>
<script>
var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',TotalPageNumber:0};
</script> 
<%}%>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<div   align="center">
<input name="startButton" type="button" class="button" value=" 确定 " id="submitButton" onclick="filecopy(<%=gid%>);" />
      &nbsp; 

<input type="button" class="button"  id="buttonClose"onclick="top.TideDialogClose('');" value=" 取消 " ></input>
<script>
$(".checkbox").click(function(){
        var path = $(this).attr("filepath");
     $("input[type='checkbox']").each(function(){
        var filepath = $(this).val();
        if(path.indexOf(".")<0){
            if(filepath.indexOf(path)==0){
                $(this).attr("checked",true);
            }
        }
        
    });
})



</script>
</div>
</body>
</html>
