<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				tidemedia.cms.util.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
 *	姓名		日期		备注
 *	
 *	王海龙		20131231	添加采集周期字段
 */
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
Spider  s = new Spider(id);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Name			= getParameter(request,"Name");
	int		Channel			= getIntParameter(request,"Channel");
	String	Url				= getParameter(request,"Url");
	String	Url_First		= getParameter(request,"Url_First");
	String	ListStart		= getParameter(request,"ListStart");
	String	ListEnd			= getParameter(request,"ListEnd");
	String	ListReg			= getParameter(request,"ListReg");
	String	Charset			= getParameter(request,"Charset");
	String	ItemCharset		= getParameter(request,"ItemCharset");
	String	HrefReg			= getParameter(request,"HrefReg");
	String	ImageFolder		= getParameter(request,"ImageFolder");
	String	Program			= getParameter(request,"Program");
	String	TitleKeyword    = getParameter(request,"TitleKeyword");
	int		GroupID			= getIntParameter(request,"GroupID");
	int		ItemStatus		= getIntParameter(request,"ItemStatus");
	int		ItemGid		= getIntParameter(request,"ItemGid");
	int		IsDownloadImage	= getIntParameter(request,"IsDownloadImage");
    int		Period		= getIntParameter(request,"Period");
    
    String transfer = getParameter(request,"transfer");
	
	s.setName(Name);
	s.setChannel(Channel);
	s.setUrl(Url);
	s.setUrl_First(Url_First);
	s.setListStart(ListStart);
	s.setListEnd(ListEnd);
	s.setListReg(ListReg);
	s.setCharset(Charset);
	s.setItemCharset(ItemCharset);
	s.setHrefReg(HrefReg);
	s.setImageFolder(ImageFolder);
	s.setProgram(Program);
	s.setItemStatus(ItemStatus);
	s.setIsDownloadImage(IsDownloadImage);
	s.setGroup(GroupID);
	s.setTitleKeyword(TitleKeyword);
    s.setPeriod(Period);
	s.setIsGlobalID(ItemGid);

	s.setTransfer(transfer);
	
	s.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
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
  <!--  <link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" /> 
        <script type="text/javascript" src="../common/jquery.js"></script> -->
<!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet"> 
    
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
	 <script src="../lib/2018/jquery/jquery.js"></script>
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	
</style>
<script type="text/javascript">
function init()
{
	document.form.Code.focus();
}

function check()
{
	if(isEmpty(document.form.Code,"请输入代码."))
		return false;

	//document.form.Button2.disabled  = true;

	return true;
}
</script>  
</head>
 
   <body class="" >
    <div class="bg-white modal-box">
      <form name="form" action="spider_edit2018.jsp" method="post" onSubmit="return check();">
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">
	       	  <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">	       		  	 
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">名称：</label>
			              <label class="wd-230">
			                <input name="Name" id="Name" class="form-control" placeholder="" type="text" value="<%=s.getName()%>">
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">转载地址：</label>
			               <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="transfer" id="transfer" rows="3" class="form-control" placeholder=""><%=s.getTransfer()%></textarea>
				              <br>(每行一个地址)
 						  </div>	
	       		  	  </div>
	       		  	 
	       		  	  <!--标识名-->
	       		  	   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">采集地址：</label>
			               <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="Url" id="Url" rows="3" class="form-control" placeholder=""><%=s.getUrl()%></textarea>			              
 						  </div>										            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">一次性采集地址：</label>
			             <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="Url_First" id="Url_First" rows="3" class="form-control" placeholder=""><%=s.getUrl_First()%></textarea>			              
 						  </div>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	      <label class="left-fn-title">列表开始代码：</label>
			            <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="ListStart"  rows="3" class="form-control" placeholder=""><%=s.getListStart()%></textarea>			              
 					   </div>
			              
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">列表结束代码：</label>
			              <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="ListEnd"  rows="3" class="form-control" placeholder=""><%=s.getListEnd()%></textarea>			              
 					      </div>							            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">标题关键词：</label>
			              <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="TitleKeyword"  rows="3" class="form-control" placeholder=""><%=s.getTitleKeyword()%></textarea>			              
 					          <br/>关键词用逗号分隔，填写以后只采集标题含有关键词的文章。<br/>
						  </div>								            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">列表正则表达式：</label>
			              <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="ListReg" rows="3" class="form-control" placeholder=""><%=s.getListReg()%></textarea>
				            </div>									            
	       		  	  </div> 
					   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">链接正则表达式：</label>
			                <label class="wd-230">
			                <input name="HrefReg" id="HrefReg" size="32" class="form-control" placeholder="" type="text" value="<%=Util.HTMLEncode(s.getHrefReg())%>">
			               </label>	
                            <label class="mg-l-5">(为空使用默认值)</label>						   
	       		  	  </div> 	       		  	  
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">内容分析代理程序：</label>
			               <label class="wd-230">
			                <input name="Program" id="Program" size="32" class="form-control" placeholder="" type="text" value="<%=s.getProgram()%>">
			               </label>							             
	       		  	  </div>
					  <div class="row">                   		  	  		   		  	  		  
			              <label class="left-fn-title">列表页编码：</label>               		  	  		 
		  	  		  	  <select name="Charset" class="form-control wd-230 ht-40 select2" data-placeholder="">						                          
						         <option <%=(s.getCharset().equals("utf-8")?"selected='selected'":"")%> value="utf-8">Unicode(UTF-8)</option>
						         <option <%=(s.getCharset().equals("gb2312")?"selected='selected'":"")%> value="gb2312">简体中文(GB2312)</option>				                              							                           
						   </select>     					             
	       		  	  </div>	
                       <div class="row">                   		  	  		   		  	  		  
			              <label class="left-fn-title">内容页编码：</label>               		  	  		 
		  	  		  	  <select name="ItemCharset" class="form-control wd-230 ht-40 select2" data-placeholder="">						                          
						         <option  <%=(s.getItemCharset().equals("utf-8")?"selected='selected'":"")%> value="utf-8">Unicode(UTF-8)</option>
						         <option <%=(s.getItemCharset().equals("gb2312")?"selected='selected'":"")%> value="gb2312">简体中文(GB2312)</option>				                              							                           
						   </select>     					             
	       		  	  </div>
                       <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">对应频道编号：</label>
			               <label class="wd-230">
			                <input name="Channel" id="Channel"  class="form-control" placeholder="" type="text" value="<%=s.getChannel()%>">
			               </label>							             
	       		  	  </div>		
                       <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">图片路径：</label>
			               <label class="wd-230">
			                <input name="ImageFolder" id="ImageFolder"  class="form-control" placeholder="" type="text" value="<%=s.getImageFolder()%>">
			               </label>							             
	       		  	  </div>	
                      <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">采集周期：</label>
			               <label class="wd-230">
			                <input name="Period" id="Period"  class="form-control" placeholder="" type="text" value="<%=s.getPeriod()%>">
			               </label>		
                           <label class="mg-l-5">(分钟)</label>							   
	       		  	  </div>						  
	       		  	   <div class="row">                  		  	  	
	   		  	  		  <label class="left-fn-title">图片是否本地化：</label>
			              <label class="rdiobox">
			                <input name="IsDownloadImage" id="IsDownloadImage_1" <%=s.getIsDownloadImage()==1?"checked":""%> type="radio" value="1" class="textfield" ><span>需要</span>
			              </label>
				          <label class="rdiobox">
			                <input name="IsDownloadImage" id="IsDownloadImage_0"  <%=s.getIsDownloadImage()==0?"checked":""%> type="radio" value="0" class="textfield"><span>不需要</span>
			              </label>
	       		  	  </div>
					  <div class="row">                  		  	  	
	   		  	  		  <label class="left-fn-title">文档默认状态：</label>
			              <label class="rdiobox">
			                <input name="ItemStatus" id="ItemStatus_1" type="radio" value="1" <%=s.getItemStatus()==1?"checked":""%> class="textfield" ><span>已发</span>
			              </label>
				          <label class="rdiobox">
			                <input name="ItemStatus" id="ItemStatus_0" value="0" type="radio" class="textfield"><span>草稿</span>
			              </label>
	       		  	  </div>
					   <div class="row">                  		  	  	
	   		  	  		  <label class="left-fn-title">否需要文章编号：</label>
			              <label class="rdiobox">
			                <input name="ItemGid" id="ItemStatus_1" type="radio" value="1" class="textfield" <%=s.getIsGlobalID()==1?"checked":""%>><span>是</span>
			              </label>
				          <label class="rdiobox">
			                <input name="ItemGid" id="ItemStatus_0"  type="radio" value="0" class="textfield" <%=s.getIsGlobalID()==0?"checked":""%>><span>否</span>
			              </label>
	       		  	  </div>
					    <div class="row">                   		  	  		   		  	  		  
			              <label class="left-fn-title">组名：</label>               		  	  		 
		  	  		  	  <select name="GroupID" class="form-control wd-230 ht-40 select2" data-placeholder="">						                          
						         <option value="0">请选择</option>
						          <%
									SpiderGroup userGroup=new SpiderGroup();
									List groups=userGroup.getGroups();
									Iterator iter=groups.iterator();
									while(iter.hasNext()){
									SpiderGroup  groupOne=(SpiderGroup)iter.next();
									if(groupOne.getId()!=s.getGroup()){
												out.println("<option value=\""+groupOne.getId()+"\">"+groupOne.getName()+"</option>");
									}else{
									out.println("<option value=\""+groupOne.getId()+"\"  selected>"+groupOne.getName()+"</option>");
									}
									}
									 %> 				                              							                           
						   </select>     					             
	       		  	  </div>
	       		  </li>      	    
	       	  </ul>
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
      	<div class="modal-footer" >
		      <input type="hidden" name="Submit" value="Submit">
              <input type="hidden" name="id" value="<%=id%>">
		      <button  name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
		      <button  name="btnCancel1" id="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
        </div> 
      </div>
   </form>     
    </div>	
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
  </body>
</html>
