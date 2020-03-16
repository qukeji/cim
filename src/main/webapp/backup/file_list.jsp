<%@ page import="tidemedia.cms.util.*,
				java.io.File,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!

	 /**
	  * 用途 ：下载模板备份或者数据库备份
	  *	1，丁文豪       20150402      增加操作记录日志
	  * 2， 丁文豪      20150416      获取备份文件列表的路径改为由参数获取
	  * 3. 丁文豪     20150417     删除没有用到的function html_backup()、backup_config() 及其相关带代码
	  */
public  File[] getFiles(File []files,int start,int end,String title)
{
	if(files==null) return null;
	File[]files2=new File[files.length];
	int num=0;
	if(title.trim().equals(""))
	{
		for(File file:files)
		{
			if(!file.isDirectory())
			{
				files2[num++]=file;
			}
		}
	}
	else
	{	
		for(File file:files)
		{
			if(!file.isDirectory()&&file.getName().contains(title))
			{
				files2[num++]=file;
			}
		}

	}
	
	File[]files3=new File[num];	
	for(int j=0;j<num;j++)
	{
	  files3[j]=files2[j];
	}
	
	File []fileNew=new File[num];
	num=0;
	for(int i=start;start>=0&&i<end&&i<files3.length;i++)
	{
		fileNew[num++]=files3[i];
	}
	
	File []fileNew2=new File[num];
	
	for(int i=0;i<num;i++)
	{
		fileNew2[i]=fileNew[i];
	}
	
	return fileNew2;
}
	
 public  int getFileslength(File []files,String title )
{
	if(files==null) return 0;
 	if(title.trim().equals(""))
 	{
 		return files.length;
 	}
 	else
 	{
 		int num=0;
 		for(File file:files)
 		{
			if(!file.isDirectory()&&file.getName().contains(title))
			{
				num++;
			}
		}
 		return num;
 	}
	
}
	public void Order(File[] files,final String content){
		 java.util.Arrays.sort(files,new java.util.Comparator(){   
          public int compare(Object o1,   Object o2)   {   
          File f1 = (File)o1;File   f2   =   (File)o2;
		  long diff = 0;
		  if(content.equals("date"))
             diff = f2.lastModified() - f1.lastModified();
		  else if (content.equals("size"))
			 diff = f1.length() - f2.length();
           if (diff > 0)
              return 1;
           else if (diff == 0)
              return 0;
           else
              return -1;  
      }});
	}
 %>
<%
	if(!userinfo_session.isAdministrator())
	{
		response.sendRedirect("../noperm.jsp");
		return;
	}
	TideJson tj=CmsCache.getParameter("sys_backup_cfg").getJson();
	String   backuppath  =tj.getString("db_path")+"";
	if(backuppath.equals(""))
    	backuppath="/web/backup/";
	//request.setCharacterEncoding("iso-8859-1");
	
	 String sort=Util.getParameter(request,"sort");
	 int currPage=Util.getIntParameter(request,"currPage");
	 int rowsPerPage=Util.getIntParameter(request,"rowsPerPage");
	 int TotalPageNumber=-1;
	 int S_OpenSearch=Util.getIntParameter(request,"S_OpenSearch");;
	 String S_Title=Util.getParameter(request,"S_Title");
	 if(rowsPerPage==0)
	 {
	    rowsPerPage=50;
	  }
	 if(currPage==0||currPage<1)
	 {
	    currPage=1;
	 }
	File[] files = null;
	File file = new File(backuppath);

	if(file.exists())
		files = file.listFiles();

	if(files!=null)
 		Order(files,"date");

	double PageNumbe=Math.ceil((double)getFileslength(files,S_Title)/(double)rowsPerPage);
 	TotalPageNumber=(int)PageNumbe;
 
	int startPage=(currPage-1)*rowsPerPage;
	int endPage=currPage*rowsPerPage;
	
	files=getFiles(files,startPage,endPage,S_Title);
	
   String querystring="&FolderName="+backuppath+"&sort="+sort+"&rowsPerPage="+rowsPerPage+"&S_Title="+S_Title+"&S_OpenSearch="+S_OpenSearch;
   String querystring2="&FolderName="+backuppath+"&sort="+sort+"&S_OpenSearch="+S_OpenSearch;
   String pagePre="file_list.jsp?currPage="+(currPage-1)+querystring;
   String pageNext="file_list.jsp?currPage="+(currPage+1)+querystring;
   String pageStart="file_list.jsp?currPage=1"+querystring;
   String pageEnd="file_list.jsp?currPage="+TotalPageNumber+querystring;
   String changerowsPerPage="file_list.jsp?currPage=1"+querystring2;
   String searchTitle="file_list.jsp?currPage=1"+querystring2+"&rowsPerPage="+rowsPerPage;
   String endSearch="file_list.jsp?currPage=1&rowsPerPage="+rowsPerPage+"&FolderName="+backuppath+"&sort="+sort;
	if(files!=null)	
    if(sort.equals("date")){
       Order(files,"date");
    }else if(sort.equals("size")){
       Order(files,"size");
    }else
       Order(files,"date");
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
  <script src="../common/ieemu.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>

<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script>
     
	var myObject = new Object();
    myObject.title = "新建文件";
    myObject.FolderName = "<%=backuppath%>";
	var listType=1;

function deleteFile()
{
		var curr_row;
		var selectedNumber = 0;
		var selectedFile = "";

		for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
		{
		  if(oTable.rows[curr_row].className=="rows3")
			{
//			  alert(document.getElementById("FileName"+oTable.rows[curr_row].No).innerText);
			  if(selectedFile=="")
				  selectedFile += document.getElementById("FileName"+oTable.rows[curr_row].No).innerText;
			  else
				  selectedFile += ","+document.getElementById("FileName"+oTable.rows[curr_row].No).innerText;
			  selectedNumber ++;
			}
		}
//	alert(selectedFile);
	if (selectedNumber>0) 
		{ 
		var message = "";
		if(selectedNumber<5)
		{
			message = "删除此后将无法进行数据恢复,确实要删除\""+selectedFile+"\"吗？";
		}
		else
		{
			message = "删除此后将无法进行数据恢复，确实要删除这"+selectedNumber+"项吗？";
		}
		if(confirm(message)) 
		{
			this.location = "file_delete.jsp?Action=Delete&FolderName="+myObject.FolderName+"&FileName="+selectedFile;
		}
	}
	else
	{
		alert("请先选择要删除的文件！");
	}
} 

function selectItem(obj)
{
	//alert(obj.className);
	if(obj.className!="rows3")
	{
		var curr_row;

		//if(window.event.ctrlKey!=true)
		//{
			for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
			{
			  if(oTable.rows[curr_row].className=="rows3")
				  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
			}
		//}
		obj.className = "rows3";
	}
	else
		obj.className = obj.oldclass;
}

function selectItem_key(flag)
{

	var curr_row;
	var hasSelectedItem = 0;

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
			    hasSelectedItem = 1;
				break;
			}
		}
		if(hasSelectedItem==0)
		{
			oTable.rows[1].className = "rows3";
		}
	}
}

function double_click(obj)
{

}

function onkeyboard()
{
	key = event.keyCode
	if(key == 'd'.charCodeAt() || key == 'D'.charCodeAt())
		deleteFile();
	else if(key == 13)
		notepad();
	//alert(key);
}

function onkeyboard1()
{
	key = event.keyCode
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


function openSearch(obj)
{
var SearchArea=document.getElementById("SearchArea");
	if(SearchArea.style.display == "none")
	{
		document.search_form.OpenSearch.value="1";
		SearchArea.style.display = "";
	}
	else
	{
		document.search_form.OpenSearch.value="0";
	   SearchArea.style.display = "none";
       this.location="<%=endSearch%>";
	}
}

 
function sort_select(obj){
this.location="file_list.jsp?sort="+obj+"<%=querystring%>";
}

//20140208添加
function backupDatabase()
{
	var url="backup/backup_database.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(450);
		dialog.setHeight(400);
		dialog.setUrl(url);
		dialog.setTitle("数据库备份");
		dialog.show();
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onkeypress="onkeyboard()" onkeydown="onkeyboard1()" onselectstart="return SelectStart();">
<div class="content_t1">
	<div class="content_t1_nav">备份中心:</div>
    <div class="content_new_post">
		<div class="tidecms_btn" onClick="document.location='template_backup.jsp'">
			<div class="t_btn_txt">模板文件备份</div>
		</div>
		<div class="tidecms_btn" onClick="backupDatabase();">
			<div class="t_btn_txt">数据库备份</div>
		</div>
    </div>
</div>


<div class="content_2012">
	<div class="toolbar">
    	<div class="toolbar_l">
            <span class="toolbar1">操作：</span>
            <ul class="toolbar2">
				<li class="first"><a href="javascript:downloadFile2();">下载</a></li>
				<li class="last"><a href="javascript:deleteFile2_backup();"><font style="color:red;">删除</font></a></li>
            </ul>
        </div>
    </div>	
	<script>
function downloadFile2()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择要下载的文件！");
		return;
	}

	if(obj.length>1){
		alert("请选择一个要下载的文件！");
		return;
	}
	var files=(obj.id).split(",");
	for(var i=0;i<files.length;i++){
			 var  selectedFile =files[i];
				if(!jQuery("#Download"+i).length)
				{
				  var frame='<iframe id="Download'+i+'"  name="Download'+i+'" style="display:none;width:0px;height:0px;"></iframe>';
				  jQuery("body").append(frame);
				}
	
				if(window.frames["Download"+i]){
					window.frames["Download"+i].location = "download.jsp?Type=File&Template=backup&FileName="+selectedFile+"&FolderName=/";
				}

	}

}

function deleteFile2_backup()
{
		var obj=getCheckbox();
		var curr_row;
		var selectedNumber = obj.length;
		var selectedFile = "";
		
	if (selectedNumber>0) 
		{ 
		var message = "";
		if(selectedNumber<5)
		{
			message = "确实要删除\""+obj.id+"\"吗？";
		}
		else
		{
			message = "确实要删除这"+selectedNumber+"项吗？";
		}
		if(confirm(message)) 
		{
			//this.location = "file_delete.jsp?Action=Delete&filename="+obj.id;
			$.ajax({
				type:"get",
				url:"file_delete.jsp?files="+obj.id,
				sync:true,
				success: function(msg){
					document.location.reload();
					//alert(msg);
					//self.close();
					//alert("下载完成");
				}
			});
		}
	}
	else
	{
		alert("请先选择要删除的文件！");
	}
}
	</script>
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
            <table width="100%" border="0" cellspacing="0" cellpadding="5" id="oTable" class="view_table">
              <tr align="center"> 
			    <th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
                <th class="v1" width="360" class="box-blue"><a href="javascript:sort_select('');"><span class="font-white">名称</span></a></th>
                <th class="v1" width="69" class="box-blue"><a href="javascript:sort_select('size');"><span class="font-white">大小</span></a></th>
                <th class="v1" width="89" class="box-blue"><a href="javascript:sort_select('');"><span class="font-white">类型</span></a></th>
                <th class="v1" width="158" class="box-blue"><a href="javascript:sort_select('date');"><span class="font-white">最后修改时间</span></a></th>
              </tr>
<%
if(files==null || files.length==0)
{
%>
<tr><td colspan=6 align=center><br><br>没有文件。</td></tr>
<%
}
else
{
%>
<%
	int j = 0;
	FileUtil fileutil = new FileUtil();

	for(int i = 0;i<files.length;i++)
	{
		if(!files[i].isDirectory())
		{
			j++;
			String FileSize = fileutil.getSize(files[i]) + "KB";
			String FileExt  = fileutil.getExt(files[i]);
			String lastModified = fileutil.lastModified(files[i]);
	%>
              <tr  class="tide_item" No="<%=j%>"> 
                <td class="v1 checkbox" width="25" align="center" valign="middle"><input name="id" value="<%=files[i].getName()%>" type="checkbox"/></td>
                <td class="v1" width="360"><img  src="../images/icon_file_html.gif" width="14" height="17"> 
                  <span id="FileName<%=j%>"><%=files[i].getName()%></span></td>
                <td class="v1" width="69"><%=FileSize%></td>
                <td class="v1" width="89" ><span class="fig"><%=FileExt%></span></td>
                <td class="v1" width="158" ><span class="fig"><%=lastModified%></span></td>
              </tr>
<%
		}
	}
}
%>
            </table>
        </div>
<%if(TotalPageNumber>0){%> 
         <div class="viewpane_pages">
        	<div class="select">选择：<span id="selectAll">全部</span><span id="selectNo">无</span>			</div>
        	<div class="left">共<%=files.length%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="file_list.jsp?currPage=1<%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="file_list.jsp?currPage=<%=currPage-1%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="file_list.jsp?currPage=<%=currPage+1%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="file_list.jsp?currPage=<%=TotalPageNumber%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
            <div class="right">
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="rowsPerPage" onChange="change(this);" id="rowsPerPage">
                    <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="25">25</option>
                    <option value="30">30</option>
                    <option value="50">50</option>
                    <option value="80">80</option>
                    <option value="100">100</option>
                  </select>
                </div>
                </div>
            	<div style="float:left;">条</div>
            </div>
        </div>
  <%}%> 
  </div>
 
</div>

<script type="text/javascript">

function change(obj)
{
		if(obj!=null)		this.location="file_list.jsp?rowsPerPage="+obj.value+"<%=querystring%>";
}


jQuery(document).ready(function(){
	 
	jQuery("#rowsPerPage").val('<%=rowsPerPage%>');

	jQuery("#goToId").click(function(){
		var num=jQuery("#jumpNum").val();
		if(num==""){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;}
		 var reg=/^[0-9]+$/;
		 if(!reg.test(num)){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;
		 }

		if(num<1)
			num=1;
		var href="file_list.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		document.location.href=href;
	});

});
</script>
</html>
