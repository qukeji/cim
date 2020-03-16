<%@ page import="tidemedia.cms.util.*,
				java.io.File,java.math.*,
				org.json.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<% 
/**
*		修改人		修改时间		备注
*		郭庆光		20130624		选择服务器上某目录下的视频进行转码 ，目录配置sys_video_path
*		郭庆光		20130624		样式修改以及上传后列表页刷新
*		张赫东      2013711          上传视频添加作者
*		王海龙		20131122		添加服务器上传视频不转码功能
*       王海龙      20140117        选择视频增加右侧树形结构
*/
int currPage=-1;
int rowsPerPage=-1;
int TotalPageNumber=-1;
int S_OpenSearch=0;
String sortid="0";
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int userid = userinfo_session.getId();
String filename = "";

request.setCharacterEncoding("utf-8");

String FolderName = Util.ClearPath(getParameter(request,"FolderName"));
int ChannelID = Util.getIntParameter(request,"channelid");
int number = getIntParameter(request,"number");

String t = CmsCache.getParameterValue("sys_video");
JSONObject oooo = new JSONObject(t);

TideJson tj = CmsCache.getParameter("sys_video").getJson();
JSONArray array = new JSONArray(tj.getString("select_folder"));
JSONArray o = new JSONArray(tj.getString("birate"));
JSONObject jo = array.getJSONObject(number);
String root = jo.getString("value");
String url = jo.getString("url");
int copy = jo.getInt("copy");
String RealPath = root+"/"+FolderName; 

File file = new File(RealPath);
if(file.exists()){
File[] files2 = file.listFiles();
int total= 0 ;
if(files2!=null){
	if(request.getParameter("sortid")!=null){
	  sortid=request.getParameter("sortid");
	}
   if(sortid.equals("1")){
	    	java.util.Arrays.sort(files2,new java.util.Comparator(){   
      public int compare(Object o1,   Object o2)   {   
          File f1 = (File)o1;File   f2   =   (File)o2;
           long diff = f2.lastModified() - f1.lastModified();
           if (diff > 0)
              return 1;
           else if (diff == 0)
              return 0;
           else
              return -1;  
      }});
   }else{
	   if(sortid.equals("2")){
		       	java.util.Arrays.sort(files2,new java.util.Comparator(){   
      public int compare(Object o1,   Object o2)   {   
          File f1 = (File)o1;File   f2   =   (File)o2;
          long diff = f1.length() - f2.length();
           if (diff > 0)
              return 1;
           else if (diff == 0)
              return 0;
           else
              return -1;  
      }});
	   }else{
	java.util.Arrays.sort(files2);}
	}
}
int f2=0;
for(int i = 0;i<files2.length;i++){
  if(!files2[i].isDirectory()){
    f2++;
  }
}
File[] files=new File[f2];
File[] files_find=new File[f2];
f2=0;
for(int i = 0;i<files2.length;i++){
  if(!files2[i].isDirectory()){
    files[f2]=files2[i];
	f2++;
  }
}
f2=0;

String OpenSearch=request.getParameter("OpenSearch")+"";
String S_Title=request.getParameter("Title");
String srowsPerPage= request.getParameter("rowsPerPage");
if(OpenSearch.equals("1")){
	S_OpenSearch=1;
}else{
 S_OpenSearch=0;
//S_Title="";
}

if((S_Title!=null)&&(!S_Title.equals(""))){   //实现查找
    S_OpenSearch=1;
  for(int i=0;i<files.length;i++){
    if(files[i].getName().contains(S_Title) ){
    files_find[f2]=files[i];
	 f2++;
	}
  }
 files=new File[f2];
 for(int i=0;i<f2;i++){
 files[i]=files_find[i];
 }
}else{
S_Title="";
  //S_OpenSearch=0;
}

	if((srowsPerPage!=null)&&(!srowsPerPage.equals(""))){
          rowsPerPage=Integer.parseInt(srowsPerPage);
	}else{
		  rowsPerPage=2;
	} 
	String scurrPage= request.getParameter("currPage");
	if((scurrPage!=null)&&(!scurrPage.equals(""))){
            currPage=Integer.parseInt(scurrPage);
	}else{
	   currPage=1;
	}
  String querystring="&FolderName="+FolderName+"&Title="+S_Title+"&sortid="+sortid+"&OpenSearch="+S_OpenSearch+"&rowsPerPage="+rowsPerPage+"&copy="+copy;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/explorer.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript">
	
	var ChannelID="<%=ChannelID%>";

	var	upload_dialog = new top.TideDialog();
	var TCNDDU = TCNDDU || {};
	var files = null;
	var uploaded_count = 0;
	var dropContainer;
    
	$(function()
	{
		$("#selectAll").click(function()
		{
			$(":checkbox",$("#oTable")).attr("checked",true);
		});

		$("#selectNo").click(function()
		{
			$(":checkbox",$("#oTable")).attr("checked",false);
		});
	});	

	function choose_submit()
	{
		//alert("test");
		var obj=getCheckbox();
		//alert("obj.length="+obj.length);
		if(obj.length==0)
		{
			alert("请选择要转码的文件！");
			return;
		}
		 var transcode_need = 0;
		 if($("#transcode_need").is(":checked")) transcode_need = 1;
		 var videotype2 = $("input[name='videotype2']:checked").val();
		 var videotype="";
		jQuery("#oTable2 input:checked").each(function(i)
		{
			if(i==0)
			videotype+=jQuery(this).val();
			else
			videotype+=","+jQuery(this).val();
		}); 
		//选择编码时的提示信息
	
		if(transcode_need==1  && typeof(videotype2)=="undefined"){//不转码的提示
			alert("请选择与本视频相同的码流格式");
			return;
		}	
	
		if(transcode_need==0&&videotype=="")
		{
			alert("请选择一种，或多种转码格式！");
			return;
		}
		//var url="video_upload_choose_submit.jsp?ChannelID=<%=ChannelID%>&filename="+obj.id+"&filepath="+"&userid=<%=userid%>&videotype="+videotype;
		 
		$.ajax({		
			type:"POST",
			url:"video_upload_choose_submit.jsp",
			data:"ChannelID=<%=ChannelID%>&filename="+obj.id+"&root=<%=root%>&foldername=<%=FolderName%>&userid=<%=userid%>&videotype="+videotype+"&transcode_need="+transcode_need+"&videotype2="+videotype2+"&copy=<%=copy%>&url=<%=url%>",
			async:true,
			success:function(msg){
				top.TideDialogClose({refresh:'right'});
			}
		});
		 
	}

	function showMaliuSelect()
	{
		if($("#transcode_need").is(":checked"))
		{   $("<label id='label_need'>请选择视频文件码率</label>").insertAfter( $("#transcode_need"));
			$("#maliu_select2").show();
			$("#maliu_select1").hide();
		}
		else
		{	$("#label_need").remove();
			$("#maliu_select2").hide();
			$("#maliu_select1").show();
		}
	}
</script>
</head>
<body>

<form action="video_upload_choose_submit.jsp" enctype="multipart/form-data" method="post"  name="form" onSubmit="return check();">
<div class="iframe_form">
	<div class="form_top">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="form_main">
    	<div class="form_main_m"  style="height:290px;">
<table  border="0" id="oTable3">
   
  <tr>
    <td valign="middle" width="900"  colspan="2">
	<div class="viewpane_tbdoy">
  	<div class="viewpane">

        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    				<th class="v3" style="padding-left:10px;text-align:left;"><a href="javascript:sort_select('0')">名称</a></th>
    				<th class="v1"	align="center" valign="middle"><a href="javascript:sort_select('2')">大小</a></th>
    				<th class="v8"  align="center" valign="middle"><a href="javascript:sort_select('0')">类型</a></th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;"><a href="javascript:sort_select('1')">最后修改时间</a></th>
  				</tr>
</thead>
 <tbody> 
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
	//TotalPageNumber=files.length/rowsPerPage+1;
	 // double PageNumbe=Math.round(files.length/rowsPerPage+0.5);
	
	int startPage=(currPage-1)*rowsPerPage;
	int endPage=currPage*rowsPerPage;
	int j = 0;
	FileUtil fileutil = new FileUtil();

	String videoext = CmsCache.getParameterValue("local_video_type");
	//out.println("videoext="+videoext);
	for(int i = 0;i<files.length;i++)	
	{
	 if((i>=startPage)&&(i<endPage))
	 {
		 String FileExt  = fileutil.getExt(files[i]);
		if(!files[i].isDirectory()&&videoext.indexOf(FileExt)>=0)
		{
			j++;
			String FileSize = fileutil.getSize(files[i]) + "KB";
			
			String lastModified = fileutil.lastModified(files[i]);
	%>

	<tr id="jTip<%=j%>_id">
    <td class="v1" width="25" align="center" valign="middle"><input name="id" value="<%=files[i].getName()%>" type="checkbox"/></td>
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png"/><%=files[i].getName()%></td>
    
	<td class="v1" align="center" valign="middle"><%=FileSize%></td>
    <td class="v8" ><%=FileExt%></td>
     <td class="v4"  style="color:#666666;"><%=lastModified%></td>
  </tr>
<%
		}
	 }
	}
    total = j ;
	double PageNumbe=Math.ceil((double)j/(double)rowsPerPage);
	TotalPageNumber=(int)PageNumbe;
}
%>
  
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
        	<div class="select">选择：<span id="selectAll">全部</span><span id="selectNo">无</span>			</div>
        	<div class="left" style="left:255px">共<%=total%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			</div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="file_list_choose.jsp?currPage=1<%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="file_list_choose.jsp?currPage=<%=currPage-1%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="file_list_choose.jsp?currPage=<%=currPage+1%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="file_list_choose.jsp?currPage=<%=TotalPageNumber%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
            <div class="right">
            	<div style="float:left;"></div>
            	<div style="float:left;"></div>
            </div>
        </div>
  </div>
 
</div>
	</div>
    </td>
  </tr>
	<tr>
		<td align="right" valign="middle"></td>
		<td valign="middle">
                      <label for="transcode_need">不转码</label>
		      <input type="checkbox" value="1" name="transcode_need" id="transcode_need" onClick="showMaliuSelect()">
		</td>
	  </tr>
<tbody id="maliu_select1">
	   <tr>
		<td valign="middle" width="380" id="oTable2" colspan="2">
		<label>转码格式：</label>
<%

//JSONArray o = new JSONArray(t);
for(int i =0;i<o.length();i++)
{
	JSONObject oo = o.getJSONObject(i);
	if(i>0 && i%3==0) out.println("<br><br>");
%>
<input type="checkbox" value="<%=oo.getString("value")%>" name="videotype" id="videotype_<%=i%>"><label for="videotype_<%=i%>"><%=oo.getString("name")%></label> 
<%}%>
 </td></tr>
</tbody>

<tbody id="maliu_select2" style="display:none">
<tr>
   
	<td valign="middle" width="380" colspan="2">
         <label>视频码率：</label>
<%
for(int i =0;i<o.length();i++)
{
	JSONObject oo = o.getJSONObject(i);
	if(i>0 && i%3==0) out.println("<br><br>");
        if(i==0){
%>
<input type="radio" value="<%=oo.getString("value")%>" name="videotype2" id="videotype2_<%=i%>" checked="checked"><label for="videotype2_<%=i%>"><%=oo.getString("name")%></label>  
<%}else{%>
<input type="radio" value="<%=oo.getString("value")%>" name="videotype2" id="videotype2_<%=i%>"><label for="videotype2_<%=i%>"><%=oo.getString("name")%></label>  
<%}}%>
  </td></tr>

</tbody>

</table>
		</div>
    </div>
    <div class="form_bottom">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
</div>

<div class="form_button">

	<input name="startButton" type="button" class="tidecms_btn2" value="确定" id="startButton"  onclick="choose_submit();"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('-2');"/>
</div>
</form>
</body></html><%}%>
