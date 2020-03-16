<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.*"%>
<%@ page import="tidemedia.tcenter.controller.channel.ListConfigController" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public String getParentChannelPath(Channel channel) throws Exception{

    String path = "";
    ArrayList arraylist = channel.getParentTree();

    if ((arraylist != null) && (arraylist.size() > 0))
    {
      for (int i = 0; i < arraylist.size(); ++i)
      {
        Channel ch = (Channel)arraylist.get(i);

		if((i+1)==arraylist.size()){//当前频道名
			path = path  + ch.getName() ;// + ((i < arraylist.size() - 1) ? ">" : "");
		}else{
			path = path  + ch.getName() + " > ";// + ((i < arraylist.size() - 1) ? ">" : "");
		}        
      }
    }

    arraylist = null;

    return path;
}
%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

int ChannelID = getIntParameter(request,"ChannelID");
int chooseIndex = getIntParameter(request,"chooseIndex");

ChannelRecommend channelRecommend =  new ChannelRecommend();
List<ChannelRecommend> crlist1  = channelRecommend.getChannelRecommendListByChannelId(ChannelID, 1);
List<ChannelRecommend> crlist2 = channelRecommend.getChannelRecommendListByChannelId(ChannelID, 2);

Channel channel = new Channel(ChannelID);
int  attr1 = ChannelUtil.getFieldValueType(channel.getId(),"Attribute1");
int  reco = ChannelUtil.getFieldValueType(channel.getId(),"RecommendOut");
String IconFolder = request.getContextPath() + "/images/channel_icon/";
//System.setProperty("file.encoding","gb2312");
String Name = getParameter(request,"Name");
if(!Name.equals(""))
{
	String	FolderName				= getParameter(request,"FolderName");
	String	ImageFolderName			= getParameter(request,"ImageFolderName");
	String	SerialNo				= getParameter(request,"SerialNo");
	String	Href					= getParameter(request,"Href");
	//String	Attribute1				= getParameter(request,"Attribute1");
	String	Attribute2				= getParameter(request,"Attribute2");
	//String	RecommendOut			= getParameter(request,"RecommendOut");
	String	RecommendOutRelation	= getParameter(request,"RecommendOutRelation");
	String  Extra1					= getParameter(request,"Extra1");
	//String	ListJS					= getParameter(request,"ListJS");
	String	ListSearchField			= getParameter(request,"ListSearchField");
	String	ListShowField			= getParameter(request,"ListShowField");
	String  DocumentJS				= getParameter(request,"DocumentJS");
	//String	ListProgram				= getParameter(request,"ListProgram");
	String	DocumentProgram			= getParameter(request,"DocumentProgram");
	String  Extra2					= getParameter(request,"Extra2");
	String	Icon					= getParameter(request,"Icon");
	String  DataSource              = getParameter(request,"DataSource");

	int		IsDisplay				= getIntParameter(request,"IsDisplay");
	int		TemplateInherit			= getIntParameter(request,"TemplateInherit");
	int		IsWeight				= getIntParameter(request,"IsWeight");
	int		IsComment				= getIntParameter(request,"IsComment");
	int		IsClick					= getIntParameter(request,"IsClick");
	int		IsShowDraftNumber		= getIntParameter(request,"IsShowDraftNumber");
	int		ImageFolderType			= getIntParameter(request,"ImageFolderType");
	int	    ViewType				= getIntParameter(request,"ViewType");
	int		IsListAll			    = getIntParameter(request,"IsListAll");
	int		IsTop					= getIntParameter(request,"IsTop");
	int		IsPublishFile			= getIntParameter(request,"IsPublishFile");
	int		IsImportWord			= getIntParameter(request,"IsImportWord");
	int		IsExportExcel			= getIntParameter(request,"IsExportExcel");
	int     Version                 = getIntParameter(request,"Version");

	int	Attribute1_Type				= getIntParameter(request,"Attribute1_Type");
	int	Attribute2_Type				= getIntParameter(request,"Attribute2_Type");
	int	RecommendOut_Type			= getIntParameter(request,"RecommendOut_Type");
	int	RecommendOutRelation_Type	= getIntParameter(request,"RecommendOutRelation_Type");
	//int	ListProgram_Type			= getIntParameter(request,"ListProgram_Type");
	int	DocumentProgram_Type		= getIntParameter(request,"DocumentProgram_Type");
	//int	ListJS_Type					= getIntParameter(request,"ListJS_Type");
	int	DocumentJS_Type				= getIntParameter(request,"DocumentJS_Type");
	int	IsListConfig				= getIntParameter(request,"IsListConfig");

	//if(Attribute1_Type==0) Attribute1 = "***";
	if(Attribute2_Type==0) Attribute2 = "***";
	//if(RecommendOut_Type==0) RecommendOut = "***";
	if(RecommendOutRelation_Type==0) RecommendOutRelation = "***";
	//if(ListProgram_Type==0) ListProgram = "***";
	if(DocumentProgram_Type==0) DocumentProgram = "***";
	//if(ListJS_Type==0) ListJS = "***";
	if(DocumentJS_Type==0) DocumentJS = "***";

	channel.setName(Name);
	if(!channel.isRootChannel())
	{
		if(!channel.getFolderName().equals(FolderName))
		{
			//如果改变了频道的目录名，则更新full path
			channel.setFolderName(FolderName);
			channel.UpdateFullPath();
		}		
	}
	channel.setImageFolderName(ImageFolderName);
	channel.setImageFolderType(ImageFolderType);
	if(!channel.isRootChannel())
		channel.setSerialNo(SerialNo);
	channel.setIsDisplay(IsDisplay);
	channel.setIsWeight(IsWeight);
	channel.setIsComment(IsComment);
	channel.setIsClick(IsClick);
	channel.setIsShowDraftNumber(IsShowDraftNumber);
	channel.setHref(Href);
	//channel.setAttribute1(Attribute1);
	channel.setAttribute2(Attribute2);
	//channel.setRecommendOut(RecommendOut);
	channel.setRecommendOutRelation(RecommendOutRelation);
	channel.setExtra1(Extra1);
	channel.setExtra2(Extra2);
	//channel.setListJS(ListJS);
	channel.setListSearchField(ListSearchField);
	channel.setListShowField(ListShowField);
	channel.setDocumentJS(DocumentJS);
	//channel.setListProgram(ListProgram);
	channel.setDocumentProgram(DocumentProgram);
	channel.setIcon(Icon);
	channel.setViewType(ViewType);
	channel.setIsListAll(IsListAll);
	channel.setIsTop(IsTop);
	channel.setIsPublishFile(IsPublishFile);
	channel.setIsImportWord(IsImportWord);
	channel.setIsExportExcel(IsExportExcel);
	channel.setDataSource(DataSource);
	channel.setVersion(Version);
//	channel.setRootPath(application.getRealPath(RootPath));

	channel.setActionUser(userinfo_session.getId());
	channel.setTemplateInherit(TemplateInherit);
	int isListConfig = channel.getIsListConfig();
	channel.setIsListConfig(IsListConfig);
	channel.Update();
	if(!channel.isRootChannel()){
		if(IsListConfig==0&&isListConfig!=IsListConfig){
			ListConfigController.openInherit(ChannelID);
		}else if(IsListConfig==1&&isListConfig!=IsListConfig){
			ListConfigController.closeInherit(ChannelID);
		}
	}

	session.removeAttribute("channel_tree_string");

	String o = "{action:1,id:\""+channel.getId()+"\",name:\""+channel.getName()+"\",icon:\""+Icon+"\"}";
	
	
	Channel channelParent = new Channel(channel.getParent());
    if(channel.getParent()==-1){
	out.println("<script>top.TideDialogClose({refresh:'left',returnNavValue:{currentid:"+ChannelID+",parentid:-1,type:3,site:true}});</script>");return;
	}else if(channelParent.getParent()==-1){
	out.println("<script>top.TideDialogClose({refresh:'left',returnNavValue:{currentid:"+ChannelID+",parentid:"+channel.getParent()+",type:1,site:true}});</script>");return;
	}else{
 	out.println("<script>top.TideDialogClose({refresh:'left',returnNavValue:{currentid:"+ChannelID+",parentid:"+channel.getParent()+",type:1,site:false}});</script>");return;
	} 
}
%>
<!DOCTYPE html>
<html>
  <head>
 <meta charset="utf-8">
 <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
 <meta name="robots" content="noindex, nofollow">
 <link rel="Shortcut Icon" href="/cms2018/favicon.ico">
 <!-- Meta -->
<meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
<meta name="author" content="ThemePixels">
<title>TideCMS</title>

<!-- vendor css -->
 <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
 <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
 <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
 <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
 
 <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
 <link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
 <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
<!-- Bracket CSS -->
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>	
    
<style>
  html,body{
  		width: 100%;
  		height: 100%;
  	}
  	.lock-unlock{
  		min-width: 20px;
  	}
  	.tooltip-inner {padding: 8px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #e9ecef;opacity: 1;}
		.tooltip.bs-tooltip-bottom .arrow::before,
		.tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {border-bottom-color: #e9ecef;	}
		.tooltip.bs-tooltip-top .arrow::before,
		.tooltip.bs-tooltip-auto[x-placement^="top"] .arrow::before {border-top-color: #e9ecef;}
		.mg-t--10{margin-top: -10px;}
  	
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
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">基本信息</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">扩展信息</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">推荐设置</a></li>
          <%--<li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">列表设置</a></li>--%>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab">内容设置</a></li>
        </ul>
      </div>
      <form name="form" action="channel_edit2018.jsp" method="post" onSubmit="return check();">
	    <div class="modal-body pd-20 overflow-y-auto">
	        <div class="config-box">
	       	  <ul>
	       	  	<!--基本信息-->
	       		 <!-- <li class="block"> -->
	       		  <li >
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">名称：</label>
			              <label class="wd-230">
			                <input class="form-control" placeholder="" type="text" name="Name" value="<%=channel.getName()%>">
			              </label>									            
	       		  	  </div>
					  <%if(!channel.isRootChannel()){%>
	       		  	  <div class="row">
	   		  	  		  <label class="left-fn-title">模板方式：</label>
			              <label class="rdiobox">
			                <input id="s003" type="radio" name="TemplateInherit" value="1" <%=channel.getTemplateInherit()==1?"checked":""%>><span class="d-inline-block">继承上级模板</span>
			              </label>
				            <label class="rdiobox">
			                <input type="radio" id="s004" name="TemplateInherit" value="0" <%=channel.getTemplateInherit()==0?"checked":""%>><span class="d-inline-block">独立模板</span>
			              </label>
	       		  	  </div>
					  <div class="row">
						  <label class="left-fn-title">列表页继承方式：</label>
						  <label class="rdiobox">
							  <input id="s006" type="radio" name="IsListConfig" value="0" <%=channel.getIsListConfig()==0?"checked":""%>><span class="d-inline-block">继承上级</span>
						  </label>
						  <label class="rdiobox">
							  <input type="radio" id="s005" name="IsListConfig" value="1" <%=channel.getIsListConfig()==1?"checked":""%>><span class="d-inline-block">独立配置</span>
						  </label>
					  </div>
					  <%}%>
	       		  	  <!--标识名-->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">标识名：</label>
			              <label class="wd-230">                                                   
			                <%if(channel.isRootChannel()){%><%=channel.getSerialNo()%><%}else{%><input class="form-control" placeholder="" type="text" name="SerialNo"  onBlur="initOther()" value="<%=channel.getSerialNo()%>"><%}%>
			              </label>									            
	       		  	  </div>	       		  	  
					  <%if(channel.getDataSource()!=null&&!channel.getDataSource().equals("")){%>  
					   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">数据源：</label>
			              <label class="wd-230">                                                     
			                <input class="form-control" placeholder="" type="text" name="DataSource" value ="<%=channel.getDataSource()%>" >
			              </label>									            
	       		  	  </div>
					  <%}%>
					  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">目录名：</label>
			              <label class="wd-230">                                                    
			                <%if(channel.isRootChannel()){%><%=channel.getFolderName()%><%}else{%><input class="form-control" placeholder="" type="text" name="FolderName" value="<%=channel.getFolderName()%>"><%}%>
			              </label>									            
	       		  	  </div>
	       		  	  <!---->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">图片上传目录：</label>
			              <label class="wd-230">
			                <input class="form-control" placeholder="" type="text" name="ImageFolderName"  value="<%=channel.getImageFolderName()%>">
			              </label>
			              <label class="mg-l-5"> *为空使用站点默认目录</label>
	       		  	  </div>
	       		  	  <!--图片目录规则-->
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">图片目录规则：</label>               		  	  		 
		  	  		      <select class="form-control wd-230 ht-40 select2" data-placeholder="系统默认" name="ImageFolderType">						                          
					       <option value="0" <%=channel.getImageFolderType()==0?"selected":""%>>系统默认</option> 
					       <option value="1" <%=channel.getImageFolderType()==1?"selected":""%>>按年份命名，每年一个目录</option>
		                               <option value="2" <%=channel.getImageFolderType()==2?"selected":""%>>按年月命名，每月一个目录</option>
		                               <option value="3" <%=channel.getImageFolderType()==3?"selected":""%>>按年月日命名，每日一个目录</option>
		                               <option value="4" <%=channel.getImageFolderType()==4?"selected":""%>>按每天一个目录</option>							                           
					      </select>               		  	  		 						            
	       		  	  </div>
	       		  	  
	       		  	  <div class="row" style="display: none;">                   		  	  	
	   		  	  		  <label class="left-fn-title">application：</label>
	   		  	  		  <label class="wd-230">
			                <input class="form-control" placeholder="" type="text" name="application" readonly="readonly" value="<%=channel.getApplication()%>">
			              </label>
	       		  	  </div>
					   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">链接：</label>
			              <label class="wd-230">                                                    
			                <%if(channel.isRootChannel()){%><%=channel.getHref()%><%}else{%><input class="form-control" placeholder="" type="text" name="Href" value="<%=channel.getHref()%>"><%}%>
			              </label>									            
	       		  	  </div>
	       		  	  <%if(!channel.isRootChannel()){%>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">是否在导航出现：</label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsDisplay" value="1" class="textfield" <%=channel.getIsDisplay()==1?"checked":""%>><span></span>
			              </label>								             
	       		  	  </div>
					  <%}%>
	       		  </li>
				  <!--此位置原jsp中有一个继续新建选项 静态页中没有 以静态页为准-->
       	      <!--拓展信息-->
       	      <li>
       		  	  <div class="row">                   		  	  	
   		  	  		  <label class="left-fn-title">附加属性1：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea rows="3" class="form-control" placeholder="" name="Extra1" ><%=channel.getExtra1()%></textarea>
			            </div>									            
       		  	  </div> 
       		  	  <div class="row">                   		  	  	
   		  	  		  <label class="left-fn-title">附加属性2：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea rows="3" class="form-control" placeholder="" name="Extra2" ><%=channel.getExtra2()%></textarea>
			            </div>										            
       		  	  </div> 
	       		  </li>
	           <!--推荐设置-->
       	      <li>
       		  	 <div class="push-setting">
       		  	 			<div class="d-flex mg-b-10 align-items-center justify-content-between">
									<div class="d-flex mg-b-10 align-items-center">
										<span>推荐设置：</span>
									  <div class="bth-group">
										 	<%if(reco == 1){%>
												<input type="button" class="btn btn-primary btn-sm mg-r-8 tx-13"  onclick="pushSet('推荐配置',1)" value="配置"/>
												<input type="button" class="btn btn-primary btn-sm mg-r-8 tx-13"  onclick="applySubChannelRecommend(1)" value="应用到子频道"/>
											<%}%>
											</div>
										</div>
										<input type="hidden" value="<%=reco%>" id="reco" name="RecommendOut"/>
									<%if(channel.getParent()!=-1){%>
										<div class="d-flex align-items-center">
											<label class="mg-b-0">继承上级：</label>
											<div class="toggle-wrapper" onclick="lockUnlockRecommend(1)">
												<%if(reco == 1){%><!-- 独立关系 -->
												<div class="toggle toggle-light success" data-toggle-on="false"></div>
												<%}else{%><!-- 继承上级 -->
													<div class="toggle toggle-light success" data-toggle-on="true"></div>
												<%}%>
											</div>
											<label><span id="" class="mg-l-10"></span></label>								
										</div>
									<%}%>
									</div>
									<div class="bd">
										<table class="table mg-b-0" id="templet-table">
												<thead>
													<tr>	               
														<th class="tx-12-force tx-mont tx-medium wd-50p">目标频道</th>
														<th class="tx-12-force tx-mont tx-medium wd-15p">类型</th>
														<th class="tx-12-force tx-mont tx-medium wd-20p">对应关系</th>               
														<th class="tx-12-force tx-mont tx-medium wd-15p">操作</th>	               
													</tr>
												</thead>
												<tbody class="tx-12">
											<%for(ChannelRecommend cr1 :crlist1){
												//获取频道路径
												int cid = cr1.getRelationID();
												Channel channel1 = CmsCache.getChannel(cid);
												String parentChannelPath = getParentChannelPath(channel1);
											%>
												  <tr>	                
													<!-- <td><span class="pd-l-5"><%=cr1.getRelationID()%></span></td> -->
													<td><span class="pd-l-5"><%=parentChannelPath%></span></td>
													<%if(cr1.getRelationchannelType() == 0){ %>
														<td class="hidden-xs-down">网站</td>
													<%}%>
													<%if(cr1.getRelationchannelType() == 1){ %>
														<td class="hidden-xs-down">APP</td>
													<%}%>
													<%if(cr1.getRelationchannelType() == 2){ %>
														<td class="hidden-xs-down">两微</td>
													<%}%>
													<%if(cr1.getRelationchannelType() == 3){ %>
														<td class="hidden-xs-down">三方媒体</td>
													<%}%>
													<%if(cr1.getRelationchannelType() == 4){ %>
														<td class="hidden-xs-down">电视端</td>
													<%}%>
													<%if(cr1.getRelationchannelType() == 5){ %>
														<td class="hidden-xs-down">其他</td>
													<%}%>
													<!--<td class="hidden-xs-down"><%=cr1.getRelationship()%></td> --> 
													<%if(cr1.getFieldRelation() == 1){%>
														<td class="hidden-xs-down">自定义关系</td>
													<%}else{%>   
													  	<td class="hidden-xs-down">默认关系</td>
													<%}%> 										
													<td class=" hidden-xs-down">
														<a href="javascript:;" class="btn pd-0" title="删除" onclick="delchannelRelation(<%=cr1.getId() %>,1)"><i class="fa fa-trash-o tx-18"></i></a>
													</td>
												</tr>
										  
											 <%}%>
			
											</tbody>
										</table>								
									</div>
								</div>
       		  	  <div class="pull-setting mg-t-30">
       		  	  	<div class="d-flex mg-b-10 align-items-center justify-content-between">
       		  	  	<div class="d-flex mg-b-10 align-items-center">
       		  	  		<span>引用设置：</span>
	       		  	  	 		<div class="bth-group">
		       		  	  	   <%if(attr1 == 1){%>
		       		  	  			<input type="button" class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="pushSet('引用配置',2)" value="配置"/>            
		       		  	  			<input type="button" class="btn btn-primary btn-sm mg-r-8 tx-13"  onclick="applySubChannelRecommend(2)" value="应用到子频道"/>
		       		  	  		<%}%>
       		  	  			</div>
						</div>
       		  	  		<input type="hidden" value="<%=attr1%>" id="attr1" name="Attribute1"/>
						<%if(channel.getParent()!=-1){%>
	       		  	  	<div class="d-flex align-items-center">
							<label class="mg-b-0">继承上级：</label>
							<div class="toggle-wrapper" onclick="lockUnlockRecommend(2)">
								<%if(attr1 == 1){%><!-- 独立关系 -->
								<div class="toggle toggle-light success" data-toggle-on="false"></div>
								<%}else{%><!-- 继承上级 -->
									<div class="toggle toggle-light success" data-toggle-on="true"></div>
								<%}%>
							</div>
							<label><span id="" class="mg-l-10"></span></label>								
						</div>
						<%}%>
       		  	  	</div>
       		  	  	<div class="bd">
       		  	  		<table class="table mg-b-0" id="templet-table">
       		  	  				<thead>
       		  	  					<tr>	               
       		  	  						<th class="tx-12-force tx-mont tx-medium wd-50p">源频道</th>
       		  	  						<th class="tx-12-force tx-mont tx-medium wd-15p">类型</th>
       		  	  						<th class="tx-12-force tx-mont tx-medium wd-20p">对应关系</th>               
       		  	  						<th class="tx-12-force tx-mont tx-medium wd-15p">操作</th>	               
       		  	  					</tr>
       		  	  				</thead>
       		  	  				<tbody class="tx-12">
			      		  	  	<%for(ChannelRecommend cr2 :crlist2){
			      		  	  	//获取频道路径
								int cid1 = cr2.getRelationID();
								Channel channel2 = CmsCache.getChannel(cid1);
								String parentChannelPath = getParentChannelPath(channel2);
							%>
								  <tr>	                
									<!-- <td><span class="pd-l-5"><%=cr2.getRelationID()%></span></td> -->
									<td><span class="pd-l-5"><%=parentChannelPath%></span></td>
									<%if(cr2.getRelationchannelType() == 0){ %>
										<td class="hidden-xs-down">网站</td>
									<%}%>
									<%if(cr2.getRelationchannelType() == 1){ %>
										<td class="hidden-xs-down">APP</td>
									<%}%>
									<%if(cr2.getRelationchannelType() == 2){ %>
										<td class="hidden-xs-down">两微</td>
									<%}%>
									<%if(cr2.getRelationchannelType() == 3){ %>
										<td class="hidden-xs-down">三方媒体</td>
									<%}%>
									<%if(cr2.getRelationchannelType() == 4){ %>
										<td class="hidden-xs-down">电视端</td>
									<%}%>
									<%if(cr2.getRelationchannelType() == 5){ %>
										<td class="hidden-xs-down">其他</td>
									<%}%>
									<!-- <td class="hidden-xs-down"><%=cr2.getRelationship()%></td>	 -->
									<%if(cr2.getFieldRelation() == 1){%>
										<td class="hidden-xs-down">自定义关系</td>
									<%}else{%>   
									  	<td class="hidden-xs-down">默认关系</td>
									<%}%> 						
									<td class=" hidden-xs-down">
										<a href="javascript:;" class="btn pd-0 mg-r-5" title="配置" onclick="setRelation(<%=cr2.getId() %>,'引用配置',2)"><i class="fa fa-cog tx-18"></i></a>
										<a href="javascript:;" class="btn pd-0" title="删除" onclick="delchannelRelation(<%=cr2.getId() %>,2)"><i class="fa fa-trash-o tx-18"></i></a>
									</td>
								</tr>
						  
							 <%}%>
       		  	  			</tbody>
       		  	  		</table>								
       		  	  	</div>
       		  	  </div>  
	       		  </li>
	       	    <!--列表设置-->
       	      <%--<li>
       		  	  <div class="row">                  		  	  	
   		  	  		  <label class="left-fn-title">默认视图：</label>
		              <label class="rdiobox">
		                <input name="ViewType" value="0"  type="radio" <%=channel.getViewType()==0?"checked":""%> id="ViewType_0"><span class="d-inline-block">文字</span>
		              </label>
			            <label class="rdiobox">
		                <input name="ViewType" value="1"  type="radio" <%=channel.getViewType()==1?"checked":""%> id="ViewType_1"><span class="d-inline-block">详细</span>
		              </label>
		               <label class="rdiobox">
		                <input name="ViewType" value="2"  type="radio" <%=channel.getViewType()==2?"checked":""%> id="ViewType_2"><span class="d-inline-block">图片</span>
		              </label>
       		  	  </div> 
       		  	  <div class="row ckbox-row">                  		  	  	   		  	  		  
			              <label class="ckbox">
			                <input type="checkbox" name="IsWeight" value="1"  id="IsWeight" <%=channel.getIsWeight()==1?"checked":""%>><span>是否使用权重</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsComment" value="1"  id="IsComment" <%=channel.getIsComment()==1?"checked":""%>><span>是否显示评论</span>
			              </label>	
			              <label class="ckbox">
			                <input type="checkbox" name="IsClick" value="1"  id="IsClick" <%=channel.getIsClick()==1?"checked":""%>><span>是否显示点击数</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsShowDraftNumber" value="1"  id="IsShowDraftNumber" <%=channel.getIsShowDraftNumber()==1?"checked":""%>><span>是否显示草稿数</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsListAll" value="1"  id="IsListAll" <%=channel.getIsListAll()==1?"checked":""%>><span>是否包含子频道</span>
			              </label>	
			              <label class="ckbox">
			                <input type="checkbox" name="IsTop" value="1" id="IsTop" <%=channel.getIsTop()==1?"checked":""%>><span>是否允许置顶</span>
			              </label>	
			              <label class="ckbox">
			                <input type="checkbox" name="IsPublishFile" value="1" id="IsPublishFile" <%=channel.getIsPublishFile()==1?"checked":""%>><span>文件发布审核</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsImportWord" value="1" id="IsImportWord" <%=channel.getIsImportWord()==1?"checked":""%>><span>导入Word</span>
			              </label>	
			              <label class="ckbox">
			                <input type="checkbox" name="IsExportExcel" value="1" id="IsExportExcel" <%=channel.getIsExportExcel()==1?"checked":""%>><span>导出Excel</span>
			              </label>	
						  <label class="ckbox">
			                <input type="checkbox" name="Version" value="1" id="Version" <%=channel.getVersion()==1?"checked":""%>><span>版本功能</span>
			              </label>
       		  	  </div> 
       		  	  <div class="hr_line"></div>
       		  	  <div class="row">                  		  	  	   		  	  		  
			              <label class="left-fn-title">使用定制列表：</label>
       		  	  </div> 
       		  	  <div class="row">                  		  	  	   		  	  		  
			          <label class="left-fn-title">列表页程序：</label>		          
			          <label class="wd-400">
			            <input name="ListProgram" id="ListProgram" size="64" class="form-control textBox" placeholder=""  type="text" value="<%=channel.getListProgram()%>">
			          </label>	
			          <input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"ListProgram")%>" name="ListProgram_Type" id="ListProgram_Type" class="FieldValueType" value2="ListProgram">	       		  	     
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
			              <textarea name="ListJS" id="ListJS" rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('ListJS')"><%=channel.getListJS()%></textarea>
			            	</div>	
			              <input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"ListJS")%>" name="ListJS_Type" id="ListJS_Type" class="FieldValueType" value2="ListJS">	
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
			              <textarea name="ListSearchField" id="ListSearchField" rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('ListSearchField')"><%=channel.getListSearchField()%></textarea>
			            	</div>
       		  	  </div>
       		  	  <div class="row">                  		  	  	   		  	  		  
			              <label class="left-fn-title">列表字段：</label>
			              <div class="col-lg pd-l-0 pd-r-0 wd-400">
			              <textarea name="ListShowField" id="ListShowField" rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('ListShowField')"><%=channel.getListShowField()%></textarea>
			            	</div>				              
       		  	  </div>
       		  	  
	       		  </li>--%>
	       		  <!--内容设置-->
       	      <li>
       		  	   	<div class="hr_line"></div>
	       		  	  <div class="row">                  		  	  	   		  	  		  
				              <label class="left-fn-title">使用定制内容模型：</label>
	       		  	  </div> 
	       		  	  <div class="row">                  		  	  	   		  	  		  
				              <label class="left-fn-title">内容页程序：</label>
				              <label class="wd-400">
				                <input name="DocumentProgram" id="DocumentProgram" size="64" value="<%=channel.getDocumentProgram()%>" class="form-control textBox" placeholder="" type="text">
				              </label>	
				             <input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"DocumentProgram")%>" name="DocumentProgram_Type" id="DocumentProgram_Type" class="FieldValueType" value2="DocumentProgram">	
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
				              <textarea name="DocumentJS" id="DocumentJS"  rows="3" class="form-control textBox" placeholder="" onDblClick="autoChange('DocumentJS')"><%=channel.getDocumentJS()%></textarea>
				            	</div>	
				             <input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"DocumentJS")%>" name="DocumentJS_Type" id="DocumentJS_Type" class="FieldValueType" value2="DocumentJS">	
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
		     <input type="hidden" id="ChannelID" name="ChannelID" value="<%=ChannelID%>">
	         <input type="hidden" id="Icon" name="Icon" value="<%=channel.getIcon()%>">
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
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

    <script src="../lib/2018/select2/js/select2.min.js"></script>
    
    <script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
    <script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/TideDialog2018.js"></script>
    
    <script>

     function lockUnlock(_this){
      	var textBox = $(_this).parent(".row").find(".textBox") ;       	
       	if($(_this).find("i").hasClass("fa-lock")){      	 
       	 	$(_this).find("i").removeClass("fa-lock").addClass("fa-unlock");       	 	
       	 	textBox.removeAttr("disabled","").removeClass("disabled")
       	}else{      	 	
       	 	$(_this).find("i").removeClass("fa-unlock").addClass("fa-lock");
       	 	textBox.attr("disabled",true).addClass("disabled")
       	}
      }
     
         function setReturnValue(o){
    	var ChannelID = $("#ChannelID").val();
    	if(o.icon!=null){
			$("#iconimg").attr("src","<%=IconFolder%>"+o.icon).show();
			$("#Icon").val(o.icon);
		}
   		if(o.refresh){
   			var s = "channel_edit2018.jsp?ChannelID="+ChannelID+"&chooseIndex=2";
   			//if(o.field) s += "&show_fieldid="+o.field;
   			document.location.href=s;
   		}
   	}
     
    function lockUnlockRecommend(Operation){
    	var reco = $("#reco").val(); //= 0 显示 独立关系(继承上级)  =1显示继承上级(独立关系)
    	var attr1 = $("#attr1").val();
    	if(Operation == 1){//推荐
    		if(reco == 0){//设置独立关系
    			//alert("当前频道关系为继承上级,无法进行该操作");
	    		 if(confirm('当前频道将设置为独立关系,请确认要执行该操作吗?')){
	    			 setAlone(1);
	    		 }
    			return;
    		}else{//设置继承上级
    			if(confirm('继承上级将会用上级配置覆盖当前配置,请确认要执行该操作吗?')){
    				setExtend(1);
    			}
    		}
    	}else{//引用
    		if(attr1 == 0){//设置独立关系
    			//alert("当前频道关系为继承上级,无法进行该操作");
    			 if(confirm('当前频道将设置为独立关系,请确认要执行该操作吗?')){
    				setAlone(2);
    			 }
    			return;
    		}else{//设置继承上级
    			if(confirm('继承上级将会用上级配置覆盖当前配置,请确认要执行该操作吗?')){
    				setExtend(2);
    			}
    		}
    	}
    }
     
     function setExtend(Operation){//设置继承上级
    	 $.ajax({
    		 type:'post',
				url:"channel_extendandalone.jsp",
				data:{optype:1,ChannelID:$("#ChannelID").val(),Operation:Operation},
				dataType:"json",
				success:function(res){
					setReturnValue({refresh:true});
					alert(res.message);
				}
    	 })
     }
     
     /* $(function(){
      	$("#form_nav li").click(function(){
      		var _index = $(this).index();
      		console.log(_index)
      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
      	})*/
       
        function setAlone(Operation){//设置独立关系
    	 $.ajax({
    		 type:'post',
				url:"channel_extendandalone.jsp",
				data:{optype:2,ChannelID:$("#ChannelID").val(),Operation:Operation},
				dataType:"json",
				success:function(){
					setReturnValue({refresh:true});
					alert("设置成功");
				}
    	 })
     }
    
    function pushSet(title,Operation){//添加
    	var reco = $("#reco").val(); //= 0 显示 独立关系(继承上级)  =1显示继承上级(独立关系)
    	var attr1 = $("#attr1").val();
    	if(Operation == 1){
    		if(reco == 0){
    			alert("当前频道关系为继承上级,无法进行该操作");
    			return;
    		}
    	}else{
    		if(attr1 == 0){
    			alert("当前频道关系为继承上级,无法进行该操作");
    			return;
    		}
    	}
    	var	dialog = new top.TideDialog();
		dialog.setWidth(700);
		dialog.setHeight(620);
		dialog.setUrl("push_setting.jsp?ChannelID="+<%=ChannelID%>+"&Operation="+Operation);
		dialog.setTitle(title);
		dialog.setChannelName('<%=channel.getName()%>');
		dialog.show();
    }
    
	function setRelation(id,title,Operation){//编辑推荐/引用配置
		var reco = $("#reco").val(); //=  0 显示 独立关系(继承上级)  =1显示继承上级(独立关系)
    	var attr1 = $("#attr1").val();
    	if(Operation == 1){
    		if(reco == 0){
    			alert("当前频道关系为继承上级,无法进行该操作");
    			return;
    		}
    	}else{
    		if(attr1 == 0){
    			alert("当前频道关系为继承上级,无法进行该操作");
    			return;
    		}
    	}
		var	dialog = new top.TideDialog();
		dialog.setWidth(700);
		dialog.setHeight(620);
		dialog.setUrl("push_setting.jsp?id="+id+"&Operation="+Operation);
		dialog.setTitle(title);
		dialog.setChannelName('<%=channel.getName()%>');
		dialog.show();
    }
	
	function delchannelRelation(id,Operation){
		var reco = $("#reco").val(); //= 0 显示 独立关系(继承上级)  =1显示继承上级(独立关系)
    	var attr1 = $("#attr1").val();
    	if(Operation == 1){
    		if(reco == 0){
    			alert("当前频道关系为继承上级,无法进行该操作");
    			return;
    		}
    	}else{
    		if(attr1 == 0){
    			alert("当前频道关系为继承上级,无法进行该操作");
    			return;
    		}
    	}
		if(confirm("确定要删除该配置吗?")){
			$.ajax({
				type:'get',
				url:"channel_delcommend.jsp",
				data:{did:id},
				success:function(){
					setReturnValue({refresh:true});
					alert("删除成功");
				}
			})
		}
	}
	var  chooseIndex = <%=chooseIndex%>;
      $(function(){
	   	 if(chooseIndex != 2){
	   		$(".config-box ul li").removeClass("block").eq(0).addClass("block");
	   		$("#form_nav li a").removeClass("active").eq(0).addClass("active");
	   		$("#form_nav li").click(function(){
	      		var _index = $(this).index();
	      		console.log(_index)
	      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
	      		$("#form_nav li a").removeClass("active").eq(_index).addClass("active");
	      	})
	   	 }else{//刷新推荐设置
	   		$(".config-box ul li").removeClass("block").eq(2).addClass("block");
      		$("#form_nav li a").removeClass("active").eq(2).addClass("active");
      		$("#form_nav li").click(function(){
	      		var _index = $(this).index();
	      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
	      		$("#form_nav li a").removeClass("active").eq(_index).addClass("active");
	      	})
	   	 }
       //推荐设置锁定图片切换
//    $(".lock-unlock").click(function(){    
//     	var textBox = $(this).parent(".row").find(".textBox") ;       	
//     	if($(this).find("i").hasClass("fa-lock")){      	 
//     	 	$(this).find("i").removeClass("fa-lock").addClass("fa-unlock");       	 	
//     	 	textBox.removeAttr("disabled","").removeClass("disabled")
//     	}else{      	 	
//     	 	$(this).find("i").removeClass("fa-unlock").addClass("fa-lock");
//     	 	textBox.attr("disabled",true).addClass("disabled")
//     	}
//    })
//    	//开关相关
        //初始化
        $('.toggle').toggles({        
          height: 25,
          width:60
        });
      });
    </script>
      
    <script type="text/javascript">
$(function () {
	$(".FieldValueType").each(function(){
		//追加按钮
		var field = $(this).attr("value2");
		if($(this).val()==1)
		{

			var html ="<a href=\"javascript:cT('"+field+"');\" class=\"mg-l-25 tx-20 lock-unlock\" onclick=\"lockUnlock(this)\" ><i class=\"fa fa-unlock\" title=\"继承上级\"></i></a>"; 

		}else{

			//继承
			$("#"+field).attr("class","textinput_disabled").attr('disabled','disabled');
			$("#"+field).addClass("form-control textBox disabled");

			var html ="<a href=\"javascript:cT('"+field+"');\" class=\"mg-l-25 tx-20 lock-unlock\" onclick=\"lockUnlock(this)\" ><i class=\"fa fa-lock\" title=\"继承上级\"></i></a>"; 
		}
		
        html += " <a class=\"tx-20 mg-l-15 lock-unlock\" href=\"javascript:applySubChannel('"+field+"')\"><i class=\"fa fa-download\" aria-hidden=\"true\" title=\"应用到子频道\"></i></a>";

                      
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
		$("#"+field).attr("class","form-control textBox").removeAttr('disabled');

	}
	else
	{
		$("#"+field+"_Type").val("0");
		$("#"+field+"_img1").attr("src","../images/icon/13.png");
		$("#"+field).attr("class","textinput_disabled form-control textBox disabled").attr('disabled','disabled');
	}
	//alert($("#"+field+"_img1").attr("src"));
}

function init()
{

}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
<%if(channel.getType()==0 && !channel.isRootChannel()){%>
	if(isEmpty(document.form.FolderName,"请输入目录名."))
		return false;
	if(isEmpty(document.form.SerialNo,"请输入标识名."))
		return false;
<%}%>

	if(isExist(document.form.FolderName,"目录名已存在."))
{
//		TideConfirm("提示","目录名已存在.","","")
		return true;
	}
		
	return true;
}

function isExist(field,msg)
{	
	var flag = false;
	var url="checkFolderName.jsp?FolderName=" + field.value + "&parent=<%=ChannelID%>&type=1";
	$.ajax({
		type: "GET",
		url: url,
		async:false,
		dataType:"json",
		success: function(data){
			if(data.id != 0){//目录已存在

				alert(msg);
				field.focus();
				flag = true;
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
<%if(channel.getType()==0 ){%>
	if(document.form.SerialNo.value!="" && document.form.FolderName.value=="")
		document.form.FolderName.value = document.form.SerialNo.value;
<%}%>
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

function autoChange(id)
{
	var o = document.getElementById(id);
	if(o)
	{
		if(o.rows==4)
		{o.rows=20;}
		else
		{o.rows=4;}
	}
}

function openIconList()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(450);
	dialog.setSuffix('_2');
	dialog.setUrl("../channel/icon_list.jsp");
	dialog.setTitle("选择图标");
	dialog.setScroll('auto');
	dialog.show();
}

//修改推荐设置
function applySubChannelRecommend(Operation)
{
	if(confirm('当前频道及其所有子频道的对应属性都会被覆盖，请确认要复制该属性到子频道吗？')) 
	{
		var url="channel_applychildchannel.jsp";
		$.ajax({
			type: "POST",
			url: url,
			dataType:"json",
			data: {apply:1,ChannelID:$("#ChannelID").val(),Operation:Operation},
			success: function(res){
				setReturnValue({refresh:true});
				alert(res.message);
			}
		});
	}
}

function applySubChannel(field)
{
	var v = $("#"+field).val();
	if(confirm('当前频道及其所有子频道的对应属性都会被覆盖，请确认要复制该属性到子频道吗？属性内容是：'+v)) 
	{
		var url="channel_attribute_copy.jsp";
		$.ajax({
			type: "POST",
			url: url,
			data: {id:$("#ChannelID").val(),field:field,value:v},
			success: function(msg){alert("应用成功.");}});
	}
}
</script>
   
</html>
