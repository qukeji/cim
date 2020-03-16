<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int	ChannelID		=	getIntParameter(request,"ChannelID");
String Type			=	Util.getParameter(request,"Type");

Channel parentChannel = CmsCache.getChannel(ChannelID);
String ChannelName	=	parentChannel.getName();

String Name			=	getParameter(request,"Name");
//if(Name.length()>0)
//{
//String str = new String(request.getParameter("Name").getBytes(),"euc-kr");
//System.out.println("str:"+str);
//System.out.println("Name:"+Name);
//}
int ContinueAdd		=	getIntParameter(request,"ContinueAdd");
int Type2			=	getIntParameter(request,"Type2");//Type2==2 可配置数据源的频道
String Source		=	getParameter(request,"Source");//调用此页面的来源

if(!Name.equals(""))
{
	String	FolderName				= getParameter(request,"FolderName");
	String	ImageFolderName			= getParameter(request,"ImageFolderName");
	String	SerialNo				= getParameter(request,"SerialNo");
	String	Href					= getParameter(request,"Href");
	String	Attribute1				= getParameter(request,"Attribute1");
	String	Attribute2				= getParameter(request,"Attribute2");
	String	RecommendOut			= getParameter(request,"RecommendOut");
	String	RecommendOutRelation	= getParameter(request,"RecommendOutRelation");
	String  Extra1					= getParameter(request,"Extra1");
	String  Extra2					= getParameter(request,"Extra2");
	String	ListJS					= getParameter(request,"ListJS");
	String	ListSearchField			= getParameter(request,"ListSearchField");
	String	ListShowField			= getParameter(request,"ListShowField");
	String  DocumentJS				= getParameter(request,"DocumentJS");
	String	ListProgram				= getParameter(request,"ListProgram");
	String	DocumentProgram			= getParameter(request,"DocumentProgram");
	String	DataSource				= getParameter(request,"DataSource");
	int		Parent					= getIntParameter(request,"Parent");
	int		IsDisplay				= getIntParameter(request,"IsDisplay");
	int		ChannelType				= getIntParameter(request,"ChannelType");
	int		TemplateInherit			= getIntParameter(request,"TemplateInherit");
	int		IsWeight				= getIntParameter(request,"IsWeight");
	int		IsComment				= getIntParameter(request,"IsComment");
	int		IsClick					= getIntParameter(request,"IsClick");
	int		IsShowDraftNumber		= getIntParameter(request,"IsShowDraftNumber");
	int	    ViewType				= getIntParameter(request,"ViewType");
	int		IsListAll			    = getIntParameter(request,"IsListAll");
	int		IsTop					= getIntParameter(request,"IsTop");
	int		IsPublishFile			= getIntParameter(request,"IsPublishFile");
	int		IsImportWord			= getIntParameter(request,"IsImportWord");
	int		IsExportExcel			= getIntParameter(request,"IsExportExcel");

	int	Attribute1_Type				= getIntParameter(request,"Attribute1_Type");
	int	Attribute2_Type				= getIntParameter(request,"Attribute2_Type");
	int	RecommendOut_Type			= getIntParameter(request,"RecommendOut_Type");
	int	RecommendOutRelation_Type	= getIntParameter(request,"RecommendOutRelation_Type");
	int	ListProgram_Type			= getIntParameter(request,"ListProgram_Type");
	int	DocumentProgram_Type		= getIntParameter(request,"DocumentProgram_Type");
	int	ListJS_Type					= getIntParameter(request,"ListJS_Type");
	int	DocumentJS_Type				= getIntParameter(request,"DocumentJS_Type");
	int	IsListConfig				= getIntParameter(request,"IsListConfig");

	if(Attribute1_Type==0) Attribute1 = "***";
	if(Attribute2_Type==0) Attribute2 = "***";
	if(RecommendOut_Type==0) RecommendOut = "***";
	if(RecommendOutRelation_Type==0) RecommendOutRelation = "***";
	if(ListProgram_Type==0) ListProgram = "***";
	if(DocumentProgram_Type==0) DocumentProgram = "***";
	if(ListJS_Type==0) ListJS = "***";
	if(DocumentJS_Type==0) DocumentJS = "***";


	Channel channel = new Channel();
	
	channel.setName(Name);
	channel.setParent(Parent);
	channel.setFolderName(FolderName);
	channel.setImageFolderName(ImageFolderName);
	channel.setSerialNo(SerialNo);
	channel.setIsDisplay(IsDisplay);
	channel.setIsWeight(IsWeight);
	channel.setIsComment(IsComment);
	channel.setIsClick(IsClick);
	channel.setIsShowDraftNumber(IsShowDraftNumber);

	channel.setType(ChannelType);
	channel.setHref(Href);
	channel.setAttribute1(Attribute1);
	channel.setAttribute2(Attribute2);
	channel.setRecommendOut(RecommendOut);
	channel.setRecommendOutRelation(RecommendOutRelation);
	channel.setExtra1(Extra1);
	channel.setExtra2(Extra2);
	channel.setListJS(ListJS);
	channel.setListSearchField(ListSearchField);
	channel.setListShowField(ListShowField);
	channel.setDocumentJS(DocumentJS);
	channel.setListProgram(ListProgram);
	channel.setDocumentProgram(DocumentProgram);
	channel.setTemplateInherit(TemplateInherit);
	channel.setDataSource(DataSource);

	channel.setActionUser(userinfo_session.getId());
	channel.setViewType(ViewType);
	channel.setIsListAll(IsListAll);
	channel.setIsTop(IsTop);
	channel.setIsPublishFile(IsPublishFile);
	channel.setIsImportWord(IsImportWord);
	channel.setIsExportExcel(IsExportExcel);
	channel.setIsListConfig(IsListConfig);
	channel.Add();
    
	session.removeAttribute("channel_tree_string");
	
	
   
	if(Source.equals("Page"))
	{
		out.println("<script language=javascript>");
		out.println("var o = new Object();");
	    out.println("o.Name = '" + channel.getParentChannelPath() + "';");
		out.println("o.ChannelID = " + channel.getId() + ";");
	    out.println("window.returnValue=o;");
	    out.println("window.close();");
		out.println("</script>");
		return;
	}

	if(ContinueAdd==0)
	{
		Channel channelParent = new Channel(parentChannel.getParent());
		if(parentChannel.getParent()==-1){
			out.println("<script>top.TideDialogClose({refresh:'left',returnValue:{close:2},returnNavValue:{currentid:"+ChannelID+",parentid:-1,type:1,site:true}});</script>");return;
		}else if(channelParent.getParent()==-1){
			out.println("<script>top.TideDialogClose({refresh:'left',returnValue:{close:2},returnNavValue:{currentid:"+ChannelID+",parentid:"+parentChannel.getParent()+",type:1,site:true}});</script>");return;
		}else{
			out.println("<script>top.TideDialogClose({refresh:'left',returnValue:{close:2},returnNavValue:{currentid:"+ChannelID+",parentid:"+parentChannel.getParent()+",type:1,site:false}});</script>");return;
		} 
	}	
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
 <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
<title>TideCMS</title>
    <!--  <link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />  
    <link href="../../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../../lib/2018/select2/css/select2.min.css" rel="stylesheet">  --> 
    <!-- Bracket CSS 
    <link rel="stylesheet" href="../../style/2018/bracket.css">    
    <link rel="stylesheet" href="../../style/2018/common.css">  
    <script type="text/javascript" src="../common/jquery.js"></script>	-->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">   
	<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
	

<style>
  html,body{
  		width: 100%;
  		height: 100%;
  	}
  </style>

<!-- <style> 
.edit-main{margin:0;position:Static;}
.edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
.edit-con{position:Static;margin:-1px 0 0;}
.edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
</style>  -->
</head>
<body class="" >

    <div class="bg-white modal-box">
      <div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
        <ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
          <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#" role="tab">基本信息</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">扩展信息</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">推荐设置</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">列表设置</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">内容设置</a></li>
        </ul>
      </div>
      <form name="form" action="channel_add2018.jsp" method="post" onSubmit="return check();">
	    <div class="modal-body pd-20 overflow-y-auto">
	        <div class="config-box">
	       	  <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">
					  <div class="row" style="display:none;">                   		  	  	
	   		  	  		  <label class="left-fn-title">上级频道：</label>
			              <label class="wd-230" id="ParentName"><%=ChannelName%></label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">名称：</label>
			              <label class="wd-230">
			                <input class="form-control" placeholder="" type="text" name="Name">
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                  		  	  	
	   		  	  		  <label class="left-fn-title">表单方式：</label>
			              <label class="rdiobox">
			                <input name="ChannelType" id="s001" type="radio" value="1" checked><span class="d-inline-block">继承上级表单</span>
			              </label>
				            <label class="rdiobox">
			                <input type="radio" id="s002" name="ChannelType" value="0"><span class="d-inline-block">独立表单</span>
			              </label>
	       		  	  </div>
	       		  	  <div class="row">                  		  	  	
	   		  	  		  <label class="left-fn-title">模板方式：</label>
			              <label class="rdiobox">
			                <input name="TemplateInherit" id="s003" type="radio" value="1" checked><span class="d-inline-block">继承上级模板</span>
			              </label>
				            <label class="rdiobox">
			                <input type="radio" id="s004" name="TemplateInherit" value="0"><span class="d-inline-block">独立模板</span>
			              </label>
	       		  	  </div>
					  <div class="row">
						  <label class="left-fn-title">列表页继承方式：</label>
						  <label class="rdiobox">
							  <input id="s006" type="radio" name="IsListConfig" value="0" checked><span class="d-inline-block">继承上级</span>
						  </label>
						  <label class="rdiobox">
							  <input type="radio" id="s005" name="IsListConfig" value="1"><span class="d-inline-block">独立配置</span>
						  </label>
					  </div>
	       		  	  <!--标识名-->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">标识名：</label>
			              <label class="wd-230">                                                   
			                <input class="form-control" placeholder="" type="text" name="SerialNo"  onBlur="initOther()" value="">
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">目录名：</label>
			              <label class="wd-230">                                                     
			                <input class="form-control" placeholder="" type="text" name="FolderName" >
			              </label>									            
	       		  	  </div>
					  <%if(Type2==2){%>  
					   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">数据源：</label>
			              <label class="wd-230">                                                    
			                <input class="form-control" placeholder="" type="text" name="DataSource"  id="textfield">
			              </label>									            
	       		  	  </div>
					  <%}%>
	       		  	  <!---->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">图片上传目录：</label>
			              <label class="wd-230">
			                <input class="form-control" placeholder="" type="text" name="ImageFolderName"  id="textfield">
			              </label>
			              <label class="mg-l-5"> *为空使用站点默认目录</label>
	       		  	  </div>
	       		  	  <!--图片目录规则-->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">图片目录规则：</label>               		  	  		 
		  	  		  	  <select class="form-control wd-230 ht-40 select2" data-placeholder="系统默认" name="ImageFolderType">
						                <option label="choose one"></option>             
						                <option value="0">系统默认</option> 
						               <option value="1">按年份命名，每年一个目录</option>
		                               <option value="2">按年月命名，每月一个目录</option>
		                               <option value="3">按年月日命名，每日一个目录</option>
		                               <option value="4">按每天一个目录</option>							                           
						   </select>               		  	  		 						            
	       		  	  </div>
	       		  	  <!--是否在导航出现-->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">是否在导航出现：</label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsDisplay" value="1" class="textfield" checked><span></span>
			              </label>								             
	       		  	  </div>
					  <!--继续新建-->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">继续新建：</label>
			              <label class="ckbox">
			                <input type="checkbox" name="ContinueAdd" value="1" class="textfield"><span></span>
			              </label>								             
	       		  	  </div>
	       		  </li>
       	      <!--拓展信息-->
       	      <li>
       		  	  <div class="row">                   		  	  	
   		  	  		  <label class="left-fn-title">附加属性1：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea rows="3" class="form-control" placeholder="" name="Extra1" id="textfield"></textarea>
			            </div>									            
       		  	  </div> 
       		  	  <div class="row">                   		  	  	
   		  	  		  <label class="left-fn-title">附加属性2：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea rows="3" class="form-control" placeholder="" name="Extra2" id="textfield"></textarea>
			            </div>										            
       		  	  </div> 
	       		  </li>
	           <!--推荐设置-->
       	      <li>
       		  	  <div class="row">                   		  	  	
   		  	  		  <label class="left-fn-title">引用栏目：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea name="Attribute1" id="Attribute1" rows="3" class="form-control textBox"  disabled="disabled" placeholder="" onDblClick="autoChange('Attribute1')"></textarea>
			            </div>
			            <a href="javascript:;" class="mg-l-30 tx-20 lock-unlock"><i class="fa fa-lock"></i></a>
       		  	  </div>
       		  	  <div class="row">                   		  	  	
   		  	  		  <label class="left-fn-title">对应关系：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea name="Attribute2" id="Attribute2"  rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('Attribute2')"></textarea>
			            </div>
			            <a href="javascript:;" class="mg-l-30 tx-20 lock-unlock"><i class="fa fa-unlock"></i></a>			            
       		  	  </div>
       		  	  <div class="row">                   		  	  	
   		  	  		  <label class="left-fn-title">推荐栏目：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea name="RecommendOut" id="RecommendOut" rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('RecommendOut')"></textarea>
			            </div>
			            <a href="javascript:;" class="mg-l-30 tx-20 lock-unlock"><i class="fa fa-unlock"></i></a>
       		  	  </div>
       		  	  <div class="row">                   		  	  	
   		  	  		  <label class="left-fn-title">对应关系：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea name="RecommendOutRelation" id="RecommendOutRelation" rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('RecommendOutRelation')"></textarea>
			            </div>
			            <a href="javascript:;" class="mg-l-30 tx-20 lock-unlock"><i class="fa fa-unlock"></i></a>			            
       		  	  </div>   
       		  	  
	       		  </li>
	       	    <!--列表设置-->
       	      <li>
       		  	  <div class="row">                  		  	  	
   		  	  		  <label class="left-fn-title">默认视图：</label>
		              <label class="rdiobox">
		                <input name="ViewType" value="0"  id="ViewType_0" type="radio"><span class="d-inline-block">文字</span>
		              </label>
			            <label class="rdiobox">
		                <input name="ViewType" value="1"  id="ViewType_1" type="radio"><span class="d-inline-block">详细</span>
		              </label>
		               <label class="rdiobox">
		                <input name="ViewType" value="2"  id="ViewType_2" type="radio"><span class="d-inline-block">图片</span>
		              </label>
       		  	  </div> 
       		  	  <div class="row ckbox-row">                  		  	  	   		  	  		  
			              <label class="ckbox">
			                <input type="checkbox" name="IsWeight" value="1"  id="IsWeight"><span>使用权重</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsComment" value="1"  id="IsComment"><span>显示评论</span>
			              </label>	
			              <label class="ckbox">
			                <input type="checkbox" name="IsClick" value="1"  id="IsClick"><span>显示点击数</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsShowDraftNumber" value="1"  id="IsShowDraftNumber"><span>显示草稿数</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsListAll" value="1"  id="IsListAll"><span>包含子频道</span>
			              </label>	
			              <label class="ckbox">
			                <input type="checkbox" name="IsTop" value="1" id="IsTop"><span>允许置顶</span>
			              </label>	
			              <label class="ckbox">
			                <input type="checkbox" name="IsPublishFile" value="1" id="IsPublishFile"><span>文件发布审核</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsImportWord" value="1" id="IsImportWord"><span>导入Word</span>
			              </label>	
			              <label class="ckbox">
			                <input type="checkbox" name="IsExportExcel" value="1" id="IsExportExcel"><span>导出Excel</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="Version" value="1" id="IsExportExcel"><span>版本功能</span>
			              </label>
       		  	  </div> 
       		  	  <div class="hr_line"></div>
       		  	  <div class="row">                  		  	  	   		  	  		  
			              <label class="left-fn-title">使用定制列表：</label>
       		  	  </div> 
       		  	  <div class="row">                  		  	  	   		  	  		  
			              <label class="left-fn-title">列表页程序：</label>
			              <label class="wd-400">
			                <input name="ListProgram" id="ListProgram" size="64" class="form-control textBox disabled" placeholder="" disabled="disabled" type="text">
			              </label>	
			              <a href="javascript:;" class="mg-l-30 tx-20 lock-unlock"><i class="fa fa-lock"></i></a>	
       		  	  </div>
				  <div class="row mg-t--10" id="Caption_column_href">
					<label class="left-fn-title"> </label>
					<label class="d-flex align-items-center tx-gray-800 tx-12">
						<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
						示例：../custom/my_content.jsp
					</label>
				  </div>
       		  	  <div class="row">                  		  	  	   		  	  		  
			              <label class="left-fn-title">列表页脚本：</label>
			              <div class="col-lg pd-l-0 pd-r-0 wd-400">
			              <textarea name="ListJS" id="ListJS" rows="3" class="form-control disabled textBox" disabled="disabled" placeholder="" onDblClick="autoChange('ListJS')"></textarea>
			            	</div>	
			              <a href="javascript:;" class="mg-l-30 tx-20 lock-unlock"><i class="fa fa-lock"></i></a>	
       		  	  </div>
				  <div class="row mg-t--10" id="Caption_column_href">
					<label class="left-fn-title"> </label>
					<label class="d-flex align-items-center tx-gray-800 tx-12">
						<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
						注入JS脚本示例：$.getScript("../custom/demo.js");
					</label>
				  </div>
       		  	  <div class="row">                  		  	  	   		  	  		  
			              <label class="left-fn-title">搜索字段：</label>
			              <div class="col-lg pd-l-0 pd-r-0 wd-400">
			              <textarea name="ListSearchField" id="ListSearchField" rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('ListSearchField')"></textarea>
			            	</div>				              
       		  	  </div>
       		  	  <div class="row">                  		  	  	   		  	  		  
			              <label class="left-fn-title">列表字段：</label>
			              <div class="col-lg pd-l-0 pd-r-0 wd-400">
			              <textarea name="ListShowField" id="ListShowField" rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('ListShowField')"></textarea>
			            	</div>				              
       		  	  </div>
       		  	  
	       		  </li>
	       		  <!--内容设置-->
       	      <li>
       		  	   	<div class="hr_line"></div>
	       		  	  <div class="row">                  		  	  	   		  	  		  
				              <label class="left-fn-title">使用定制内容模型：</label>
	       		  	  </div> 
	       		  	  <div class="row">                  		  	  	   		  	  		  
				              <label class="left-fn-title">内容页程序：</label>
				              <label class="wd-400">
				                <input name="DocumentProgram" id="DocumentProgram" size="64" value="" class="form-control textBox disabled" placeholder="" disabled="disabled" type="text">
				              </label>	
				              <a href="javascript:;" class="mg-l-30 tx-20 lock-unlock"><i class="fa fa-lock"></i></a>	
	       		  	  </div>
					  <div class="row mg-t--10" id="Caption_column_href">
						<label class="left-fn-title"> </label>
						<label class="d-flex align-items-center tx-gray-800 tx-12">
							<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
							示例：../custom/my_document.jsp
						</label>
					  </div>
	       		  	  <div class="row">                  		  	  	   		  	  		  
				              <label class="left-fn-title">内容页脚本：</label>
				              <div class="col-lg pd-l-0 pd-r-0 wd-400">
				              <textarea name="DocumentJS" id="DocumentJS"  rows="3" class="form-control textBox disabled" disabled="disabled" placeholder="" onDblClick="autoChange('DocumentJS')"></textarea>
				            	</div>	
				              <a href="javascript:;" class="mg-l-30 tx-20 lock-unlock"><i class="fa fa-lock"></i></a>	
	       		  	  </div>
					  <div class="row mg-t--10" id="Caption_column_href">
						<label class="left-fn-title"> </label>
						<label class="d-flex align-items-center tx-gray-800 tx-12">
							<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
							注入JS脚本示例：$.getScript("../custom/demo.js");
						</label>
					  </div>
	       		  </li>
	       	  </ul>
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box" >
      	<div class="modal-footer" >
		      <input type="hidden" name="Parent" value="<%=ChannelID%>">
	          <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	          <input type="hidden" name="Source" id="Source" value="<%=Source%>">
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消 
                      </button>
       </div> 
      </div>
    </form>
   </div>
	</body>
<!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->
    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../common/2018/common2018.js"></script>  
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

    <script src="../lib/2018/select2/js/select2.min.js"></script>
    
    <script src="../common/2018/bracket.js"></script>
    
    <script>
      $(function(){
      	$("#form_nav li").click(function(){
      		var _index = $(this).index();
      		console.log(_index)
      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
      	})
       
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
      })
		   
      });
    </script>
    <script type="text/javascript">

$(function () {
	document.form.Name.focus();
	var	scr = document.createElement('script')
	scr.src = 'getserialno.jsp?Parent=<%=ChannelID%>&random=' + Math.random();
	document.getElementById('ParentName').appendChild(scr);

	$(".FieldValueType").each(function(){
		//追加按钮
		var field = $(this).attr("value2");
		var img1 = "13.png";
		if($(this).val()==1)
		{
			img1 = "14.png";
		}
		else
		{
			//继承
			$("#"+field).attr("class","textinput_disabled").attr('disabled','disabled');;
		}

		var html = "<a href=\"javascript:cT('"+field+"')\"><img id=\""+field+"_img1\" src=\"../images/icon/"+img1+"\" title=\"继承上级\" /></a>";
		//alert($(this));
		$(this).after(html);
	});
});

function cT(field)
{
	if($("#"+field+"_Type").val()==0)
	{
		//继承
		$("#"+field+"_Type").val("1");
		$("#"+field+"_img1").attr("src","../images/icon/14.png");
		$("#"+field).attr("class","textfield").removeAttr('disabled');

	}
	else
	{
		$("#"+field+"_Type").val("0");
		$("#"+field+"_img1").attr("src","../images/icon/13.png");
		$("#"+field).attr("class","textinput_disabled").attr('disabled','disabled');
	}
	//alert($("#"+field+"_img1").attr("src"));
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
	if(isEmpty(document.form.SerialNo,"请输入标识名."))
		return false;

	var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"; 

	if (document.form.ChannelType[1].checked){
	if(isEmpty(document.form.FolderName,"请输入目录名."))
		return false;
	for(var i=0;i<document.form.SerialNo.value.length;i++)
	{
		var exist = false;
		for(var j=0;j<smallch.length;j++)
		{
			if(document.form.SerialNo.value.charAt(i)==smallch.charAt(j))
			{
				exist = true;
			}
		}

		if(!exist)
		{
			alert("具有独立表单的频道的标识名必须由英文字母，数字或下划线组成.");
			document.form.SerialNo.focus();
			return false;
		}

	}
	}
	
	if(isExist(document.form.FolderName,"目录名已存在."))
		return false;

	document.form.startButton.disabled  = true;

	return true;
}
function isExist(field,msg)
{	
	var flag = false;
	var url="checkFolderName.jsp?FolderName=" + field.value + "&parent=<%=ChannelID%>&type=0";
	$.ajax({
		type: "GET",
		url: url,
		async:false,
		dataType:"json",
		success: function(data){
			if(data.id != 0){//目录已存在
				document.form.FolderName.value = data.FolderName ;
			}
		}
	});
	return flag;
}

function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		alert(msg);
		field.focus();
		return true;
	}
	return false;
}

function initOther()
{
	if(document.form.SerialNo.value!="")
	{
		if(document.form.FolderName.value=="") 
		{
			var index = document.form.SerialNo.value.lastIndexOf("_");
			var folder = "";
			if(index!=-1)
				folder = document.form.SerialNo.value.substring(index+1);
			else
				folder = document.form.SerialNo.value;
			document.form.FolderName.value = folder;
			//document.form.ImageFolderName.value = folder + "/images";
		}

		var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789";

		if (document.form.ChannelType[1].checked){
		for(var i=0;i<document.form.SerialNo.value.length;i++)
		{
			var exist = false;
			for(var j=0;j<smallch.length;j++)
			{
				if(document.form.SerialNo.value.charAt(i)==smallch.charAt(j))
				{
					exist = true;
				}
			}

			if(!exist)
			{
				alert("具有独立表单的频道的标识名必须由英文字母，数字或下划线组成.");
				document.form.SerialNo.focus();
				return false;
			}
		}
		}

		scr = document.createElement('script')
		scr.src = 'checkserialno.jsp?SerialNo=' + document.form.SerialNo.value + '&random=' + Math.random();
		document.getElementById('ParentName').appendChild(scr);
	}
}

function showRecommend()
{
	var o = document.getElementById("RecommendArea");
	if(o)
	{
		if(o.style.display =="")
			o.style.display = "none";
		else
			o.style.display = "";
	}
}

function showTab(form,form_td)
{
	var num = 5;
	for(i=1;i<=num;i++)
	{
		jQuery("#form"+i).hide();
		jQuery("#form"+i+"_td").removeClass("cur");
	}
	
	jQuery("#"+form).show();
	jQuery("#"+form_td).addClass("cur");
}
</script>
  
</html>
