<%@ page import="java.sql.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}
long begin_time = System.currentTimeMillis();
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int Scheme = getIntParameter(request,"Scheme");
int SiteId=getIntParameter(request,"SiteId");
int type=getIntParameter(request,"type");
String ids=getParameter(request,"ids");
String S_Title=Util.getParameter(request,"S_Title");
int Status=getIntParameter(request,"Status");//状态  0:查看待发布文件  1:已发布文件  2:正在发布  3:发布失败
int Status_publish_item=0;//数据库publish_item表中实际Status字段
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 50;
	
switch(Status){
	case 0:
		Status_publish_item=0;
		break;
	case 1:
		Status_publish_item=1;
		break;
	case 2:
		Status_publish_item=3;
		break;
	case 3:
		Status_publish_item=4;
		break;

}


//System.out.println(currPage+"*************");
String queryString="&SiteId="+SiteId+"&Scheme="+Scheme+"&S_Title="+S_Title+"&Status="+Status+"";
String queryString1="&SiteId="+SiteId+"&Scheme="+Scheme+"&Status="+Status+"&type="+type;
String Action = getParameter(request,"Action");
String searchTitle="publish_task_custom.jsp?rowsPerPage="+rowsPerPage+queryString1;
String endSearch="publish_task_custom.jsp?rowsPerPage="+rowsPerPage+queryString1;
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	String Sql = "delete from publish_item where  id=" + id;

	if(Status_publish_item!=0){
		Sql+=" and Status="+Status_publish_item+"";
	}else{
		Sql+=" and (Status=0 or Status=2)";
	}
	
	System.out.println(Sql+"=============del");
	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);
	//System.out.println("publish_task_custom.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString+"==========");
	response.sendRedirect("publish_task_custom.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString);
	
	return;
}
else if(Action.equals("Clear"))
{
	//String Sql = "delete from publish_item where Status=1";
	String Sql ="DELETE FROM publish_item WHERE id=id ";
	//Sql+=" and publish_item.Status=1";

	if(Status_publish_item!=0){
		Sql+=" and Status="+Status_publish_item+"";
	}else{
		Sql+=" and (Status=0 or Status=2)";
	}
	
		
	TableUtil tu = new TableUtil();
	System.out.println(Sql+"=============clear");
	tu.executeUpdate(Sql);
	
	response.sendRedirect("publish_task_custom.jsp?a=a"+queryString);return;
}
else if(Action.equals("Publish"))
{ 
     String []ids_group=ids.split(",");
      for(String id:ids_group){
            TableUtil tu_update=new TableUtil();
	    String sql="update publish_item set status=0 where status=4 and id="+id+"";
           // System.out.println("sql_mark"+sql);
            tu_update.executeUpdate(sql);
     }
		PublishManager.getInstance().CopyFileNow();
       response.sendRedirect("publish_task_custom.jsp?a=a"+queryString);
       return;
}else if(Action.equals("AgainPublish"))
{ 
     String []ids_group=ids.split(",");
      for(String id:ids_group){
            TableUtil tu_update=new TableUtil();
	    String sql="update publish_item set status=0 where status=3 and id="+id+"";
           // System.out.println("sql_mark"+sql);
            tu_update.executeUpdate(sql);
     }
	 PublishManager.getInstance().CopyFileNow();
       response.sendRedirect("publish_task_custom.jsp?a=a"+queryString);
       return;
}else if(Action.equals("AllPublish")){
	    TableUtil tu_update=new TableUtil();
	    String sql="update publish_item set status=0 where status=4 ";
		//out.println(sql+"---发布全部失败文件----");
        tu_update.executeUpdate(sql);
}else if(Action.equals("AllPublish_running")){
	    TableUtil tu_update=new TableUtil();
	    String sql="update publish_item set status=0 where status=3 ";
		//out.println(sql+"---发布全部待发文件----");
        tu_update.executeUpdate(sql);
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script language="javascript">
function change(obj)
{
	if(obj!=null)
		this.location = "publish_task_custom.jsp?rowsPerPage="+obj.value+"<%=queryString%>&type=<%=type%>";
}

function getCheckbox(){
	var id="";
	jQuery("#oTable input:checked").each(function(i){
		if(i==0)
			id+=jQuery(this).val();
		else
			id+=","+jQuery(this).val();
	});
	var obj={length:jQuery("#oTable input:checked").length,id:id};
	return obj;
}

function again_publishing()
{
		

           var obj=getCheckbox();
		   if(obj.length==0){
				alert("请先选择要发布文档！");
			return;
			}
	       this.location = "../publish/publish_task_custom.jsp?Action=AgainPublish&ids=" + obj.id +"<%=queryString%>" ;
		
}
function again_publishing_all()
{
		

         
	       this.location = "../publish/publish_task_custom.jsp?Action=AllPublish_running<%=queryString%>" ;
		
}
function again_publish()
{
               var obj=getCheckbox();
			    if(obj.length==0){
				alert("请先选择要发布文档！");
			return;
			}
	       this.location = "../publish/publish_task_custom.jsp?Action=Publish&ids=" + obj.id +"<%=queryString%>" ;
		
}
function again_publish_all()
{
	       this.location = "../publish/publish_task_custom.jsp?Action=AllPublish<%=queryString%>" ;
		
}

function ClearItems()
{
	if(confirm("确实要清空所有发布记录吗？")) 
	{
		this.location = "publish_task_custom.jsp?Action=Clear<%=queryString%>";
	}
}

function MM_jumpMenu(obj){ //v3.0
	if(obj!=null)
	{
		if(document.getElementById("rowsPerPage")!=null)
			this.location = "publish_task_custom.jsp?Scheme=" + obj.value+"&rowsPerPage="+document.getElementById("rowsPerPage").value+"&SiteId=<%=SiteId%>";
		else
			this.location = "publish_task_custom.jsp?Scheme=" + obj.value+"&SiteId=<%=SiteId%>";
	}
}

function Details(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(340);
	dialog.setScroll("auto");
	dialog.setUrl("publish/publish_task_custom_details.jsp?id=" + id);
	dialog.setTitle("错误信息");
	dialog.show();
}


function openSearch(obj)
{
var SearchArea=document.getElementById("SearchArea");
	if(SearchArea.style.display == "none")
	{
		SearchArea.style.display = "";
	}
	else
	{
	   SearchArea.style.display = "none";
       this.location="<%=endSearch%>";
	}
}
function search_submit(){
var S_Title=document.getElementById("S_Title").value;
this.location="<%=searchTitle%>&S_Title="+S_Title;
}

 //发布用时排序
function SortItems(type)
{
	if(type==0){
		this.location="publish_task_custom.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=1";
	}else if(type==1){
		this.location="publish_task_custom.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=2";
	}else{
		this.location="publish_task_custom.jsp?currPage=<%=currPage%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=0";
	} 
 
}
	
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav"> <a href="../system/manager.jsp" class="first">返回</a></div>
    <div class="content_new_post">
    	<a href="javascript:openSearch();" class="first">检索</a>
		<a href="javascript:ClearItems();" class="second">清空</a>
    </div>
</div>
<div class="viewpane_c1" id="SearchArea"  style="display:<%=(!S_Title.trim().equals("")?"":"none")%>">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20"> </td>
    <td>检索：文件名<input name="S_Title"  id="S_Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
    <input type="button" name="button" class="tidecms_btn3" value="查找" onclick="search_submit()"></td>
    <td width="20"> </td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
	<div class="toolbar">

	<div class="toolbar_l">
        	
        	<ul class="toolbar3" style="display:none;">
            	<li id="displayOperation">
                	<p><span>全部<img src="../images/toolbar2_list.gif" /></span></p>
                </li>
            </ul>
            <ul class="toolbar2">
                <li class="first"><a href="../publish/publish_task_custom.jsp?Status=0">待发布文件</a></li>
                <li><a href="../publish/publish_task_custom.jsp?Status=1">已发布文件</a></li>
                <li><a href="../publish/publish_task_custom.jsp?Status=2">正在发布</a></li>
                <li class="last"><a href="../publish/publish_task_custom.jsp?Status=3">发布失败</a></li>
               <!-- <li class="last"><a href="javascript:again_publish();">重新发布</a></li>-->
            </ul>
            
			<%if(Status_publish_item==4){%><span class="toolbar1">操作：</span>
            <ul class="toolbar2">				
              
					<li class="first"><a href="javascript:again_publish();">重新发布</a></li>
					<li class="last"><a href="javascript:again_publish_all();">全部重发</a></li>
			
            </ul>
			<%}%>
			<%if(Status_publish_item==3){%><span class="toolbar1">操作：</span>
            <ul class="toolbar2">				
              
					<li class="first"><a href="javascript:again_publishing();">重新发布</a></li>
					<li class="last"><a href="javascript:again_publishing_all();">全部重发</a></li>
			
            </ul>
			<%}%>
        </div>
	</div>
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
                                 <%if(Status_publish_item==4||Status_publish_item==3){%>                                       
                                   <th class="v1" width="25" align="center" valign="middle">  </th>       
                                 <%}%>
    				<th class="v1" width="25" align="center" valign="middle">编号</th>
					<th class="v3" align="center" valign="middle">站点</th>
                                <th class="v3" style="padding-left:10px;text-align:left;">发布方案</th>
    				<th class="v1"	align="left" valign="left">文件名</th>
					<th class="v1"	align="center" valign="middle">入队列时间</th>
					<th class="v1"	align="center" valign="middle">可发布时间</th>
					<th class="v1"	align="center" valign="middle">发布时间</th>
					<th class="v1"	align="center" valign="middle"><a href="javascript:SortItems('<%=type%>');" style="color:#26619e">发布用时</a></th>
					<th class="v1"	align="center" valign="middle">信息</th>
					<th class="v9" width="55" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody> 
<%			//System.out.println("list begin....");
PublishScheme pt = new PublishScheme();
//String ListSql = "select publish_item.FileName,publish_item.CreateDate,publish_item.id,publish_item.ErrorNumber,publish_scheme.Name from publish_item left join publish_scheme on publish_item.PublishScheme=publish_scheme.id  where publish_item.Status=1 ";

//String ListSql = "select * from publish_item where Status=1 ";
//String ListSql = "select publish_item.FileName,publish_item.CreateDate,publish_item.id,publish_item.PublishScheme,publish_item.ErrorNumber,publish_scheme.Name from publish_item left join publish_scheme on publish_item.PublishScheme=publish_scheme.id  where publish_item.Status=1 ";
//String CountSql = "select count(*) from publish_item left join publish_scheme on publish_item.PublishScheme=publish_scheme.id where publish_item.Status=1";

//使用上面的SQL 性能提高一倍 2007 09 19


String ListSql = "select site,UsedTime ,FileName,CreateDate,id,PublishScheme,FROM_UNIXTIME(AddTime,'%m-%d %H:%i:%s') as AddTime,FROM_UNIXTIME(CanCopyTime,'%m-%d %H:%i:%s') as CanCopyTime,FROM_UNIXTIME(CopyedTime,'%m-%d %H:%i:%s') as CopyedTime,Message from publish_item  ";
	
	if(Status_publish_item!=0){
		ListSql+=" where Status="+Status_publish_item+"";
	}else{
		ListSql+=" where Status=0 or Status=2";
	}
String CountSql = "select count(*) from publish_item  ";

	if(Status_publish_item!=0){
		CountSql+=" where Status="+Status_publish_item+"";
	}else{
		CountSql+=" where Status=0 or Status=2";
	}
if(Scheme>0){
	ListSql += " and PublishScheme=" + Scheme;
	CountSql += " and PublishScheme=" + Scheme;
}
if(SiteId>0){
	ListSql+=" and Site="+SiteId;
	CountSql += " and Site="+SiteId;
}

if(!S_Title.trim().equals("")){
	ListSql+=" and FileName like '%"+S_Title+"%'";
	CountSql += " and FileName like '%"+S_Title+"%'";
}	

if(type==2){
	ListSql += " order by UsedTime asc ";
}else if(type==1){
	ListSql += " order by UsedTime desc ";
}else{
	ListSql += " order by id desc ";
}

//String CountSql = "select count(*) from publish_item where Status=1";


ResultSet Rs = pt.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = pt.pagecontrol.getMaxPages();
int TotalNumber = pt.pagecontrol.getRowsCount();
if(pt.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				int siteId=Rs.getInt("site");
				tidemedia.cms.system.Site site=new tidemedia.cms.system.Site(siteId);
				String siteName=site.getName();
				int psid = Rs.getInt("PublishScheme");
				PublishScheme ps = tidemedia.cms.system.CmsCache.getPublishScheme(psid);
				String Name = ps.getName();
				String FileName = convertNull(Rs.getString("FileName"));
				String time1 = convertNull(Rs.getString("AddTime"));
				String time2 = convertNull(Rs.getString("CanCopyTime"));
				String time3 = convertNull(Rs.getString("CopyedTime"));
				String Message = convertNull(Rs.getString("Message"));
				int time4 = Rs.getInt("UsedTime");
				int second = time4/1000;
				String usedTime = "";
				if(second<=0)
					usedTime = time4 + "毫秒";
				else if(second>0&&second<60) 

					usedTime = second +"秒";
				else if(second>=60&&second<3600) 
					usedTime = second/60+"分钟";
				else 
					usedTime = second/3600+"小时";
				int id = Rs.getInt("id");

				j++;
%>

	<tr>
                <%if(Status_publish_item==4||Status_publish_item==3){%>
                     <td class="v1" width="25" align="center" valign="middle"><span><input name="id" value="<%=id%>" type="checkbox"/></span></td>
                <%}%>
                
				<td class="v1" width="25" align="center" valign="middle"><%=j%></td>
				<td class="v1" width="70" align="left" valign="middle"><%=siteName%></td>
		<td class="v3" style="font-weight:700;"><%=Name%></td>
		<td class="v1" align="left" valign="middle"><%=FileName%></td>
		<td class="v4"  style="color:#666666;"><%=time1%></td>
		<td class="v4"  style="color:#666666;"><%=time2%></td>
		<%if(Status==1){%>
		<td class="v4"  style="color:#666666;"><%=time3%></td>
		<%}else{%>
		<td class="v4"  style="color:#666666;"><%=time3%></td>
		<%}%>
		<%if(Status==1){%>
			<td class="v4"  style="color:#666666;"><%=usedTime%></td>
		<%}else{%>
			<td class="v4"  style="color:#666666;"></td>
		<%}%>
		<td class="v4"  style="color:#666666;"><%=Message%></td>
	<td class="v9" style="padding:2px"><%if(Status==3||Status==2){%><div class="v9_button" onclick="Details(<%=id%>);"><img src="../images/v9_button_2.gif" title="查看错误" /></div><%}%>
&nbsp;<a href="publish_task_custom.jsp?Action=Del&id=<%=id%><%=queryString%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;"><lable>删除</lable></a></td>
  </tr>
<%
			}
}
			//System.out.println("pt.close begin...");
			pt.closeRs(Rs);
			//System.out.println("pt.close end...");
			//System.out.println("list end....");
%>
  
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
		
        	<div class="select"><%if(Status_publish_item==4||Status_publish_item==3){%>选择：<span id="selectAll">全部</span><span id="selectNo">无</span><%}%></div>
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="publish_task_custom.jsp?currPage=1&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="publish_task_custom.jsp?currPage=<%=currPage-1%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="publish_task_custom.jsp?currPage=<%=currPage+1%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="publish_task_custom.jsp?currPage=<%=TotalPageNumber%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
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
  </div>
 
</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
 
<script type="text/javascript"> 	
	function change(obj)
	{
		if(obj!=null)		this.location="publish_task_custom.jsp?rowsPerPage="+obj.value+"<%=queryString%>&type=<%=type%>";
	}

	function sort_select(obj){	

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
		var href="publish_task_custom.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=queryString%>&type=<%=type%>";
		document.location.href=href;
	});

});

 $("#selectAll").click(function(){
		//$("#oTable .tide_item").addClass("cur");
		//alert("-------");
		$(":checkbox",$("#oTable")).attr("checked",true);
	});

	$("#selectNo").click(function(){
		$(":checkbox",$("#oTable")).attr("checked",false);
	});
</script>
</body></html>
