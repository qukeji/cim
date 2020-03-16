<%@ page import="tidemedia.cms.util.*,
				java.io.File,java.math.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int currPage=-1;
int rowsPerPage=-1;
int TotalPageNumber=-1;
int S_OpenSearch=0;
String sortid="0";
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
int SiteId = Util.getIntParameter(request,"SiteId");

String FolderName = request.getRealPath("/") + "images/channel_icon/";//"images\\channel_icon\\"; error on linux 
String ImgSrc = request.getContextPath() + "/images/channel_icon/";

String RealPath = FolderName;
File file = new File(RealPath);

File[] files2 = file.listFiles();
if(files2!=null){
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
		  rowsPerPage=500;
	} 
	String scurrPage= request.getParameter("currPage");
	if((scurrPage!=null)&&(!scurrPage.equals(""))){
            currPage=Integer.parseInt(scurrPage);
	}else{
	   currPage=1;
	}
  String querystring="&FolderName="+FolderName+"&Title="+S_Title+"&sortid="+sortid+"&OpenSearch="+S_OpenSearch+"&rowsPerPage="+rowsPerPage+"&SiteId="+SiteId;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms7.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<style>
body{background:#efefef;}
.form_button{text-align:center;padding:15px 0;}
.channel_icon ul{overflow:auto;}
.channel_icon li{float:left;text-align:center;padding:10px 8px;}
.channel_icon li img{display:block;margin:0 auto;}
.toolbar{padding:0 0 15px 10px;border-bottom:1px solid #bbb;}
</style>
<script>
function submit_btn(){
	var item = $("input[name='icon']:checked").val();

	if(item==""){
		alert("请选择图标!");
		return;
	}
	//alert(obj.id);return;
	top.TideDialogClose({recall:true,returnValue:{icon:item}});
}

function uploadFile()
{
	tidecms.dialog("channel/icon_upload.jsp",600,400,"上传图标");
}

function deleteFile(){
	var item = $("input[name='icon']:checked").val();

	if(!item || item==""){
		alert("请选择图标!");
		return;
	}

	tidecms.message("正在删除...");
	var url = "icon_delete.jsp?Name="+encodeURI(item);
	$.ajax({type:"get",dataType:"json",url: url,success: function(msg){
		$("input[value='"+item+"']").parent().remove();
		//$("#icon_"+item).parent().remove();
		tidecms.notify("删除成功");
		//notify.html("<font color=red>删除成功</font>");
		//notify[0].timerId = setTimeout(function (){notify.html("");}, 500);				  
	}}); 
}

</script>
</head>

<body>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
	<div class="toolbar">
    	<span class="toolbar1">操作：</span>
        <ul class="toolbar2">
        	<li class="first"><a href="javascript:uploadFile();">上传</a></li>
			<li class="last"><a href="javascript:deleteFile();"><font style="color:red;">删除</font></a></li>
        </ul>
		<div class="tidecms_notify" id="tidecms_notify"><div class="tn_top"></div><div class="tn_main"></div><div class="tn_bot"></div></div>
    </div>
	<div class="channel_icon">
    	<ul>
<%
	int startPage=(currPage-1)*rowsPerPage;
	int endPage=currPage*rowsPerPage;
	int j = 0;
	FileUtil fileutil = new FileUtil();

	for(int i = 0;i<files.length;i++)
	{
	 if((i>=startPage)&&(i<endPage))
	 {
		if(!files[i].isDirectory())
		{
			j++;
			String FileSize = fileutil.getSize(files[i]) + "KB";
			String FileExt  = fileutil.getExt(files[i]);
			String lastModified = fileutil.lastModified(files[i]);
%>
        	<li><label for="icon_<%=files[i].getName()%>"><img src="<%=ImgSrc  + files[i].getName()%>" /></label><input type="radio" value="<%=files[i].getName()%>" name="icon" id="icon_<%=files[i].getName()%>"></li>
<%
		}
	 }
	}
%>
        </ul>
    </div>
</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
	<input type="button" onclick="submit_btn();" id="startButton" value="确定" class="button" name="startButton"/>
	<input type="button" onclick="top.getDialog().Close({suffix:'_2'});" id="btnCancel1" value="取消" class="button" name="btnCancel1"/>
</div>
</body>
</html>