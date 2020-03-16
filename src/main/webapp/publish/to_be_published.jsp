<%@ page import="java.sql.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
 *	修改人		日期		备注
 *	王海龙		20131112	清空的sql语句 删除条件改为：publish_item.Status!=1
 *	王海龙		20131202	修改清空待发布进程sql
 */
if(!userinfo_session.isAdministrator())
{out.close();return;}

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int Scheme = getIntParameter(request,"Scheme");
int SiteId=getIntParameter(request,"SiteId");
String S_Title=Util.getParameter(request,"S_Title");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 20;

String queryString="&SiteId="+SiteId+"&Scheme="+Scheme+"&S_Title="+S_Title;
String queryString1="&SiteId="+SiteId+"&Scheme="+Scheme;
String Action = getParameter(request,"Action");
String searchTitle="to_be_published.jsp?rowsPerPage="+rowsPerPage+queryString1;
String endSearch="to_be_published.jsp?rowsPerPage="+rowsPerPage+queryString1;
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	String Sql = "delete from publish_item where id=" + id;
   // System.out.println("clear sql :"+Sql);
	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("to_be_published.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString);return;
}
else if(Action.equals("Clear"))
{
	
	/*
	 String Sql ="DELETE FROM publish_item USING publish_item,publish_scheme WHERE publish_item.PublishScheme=publish_scheme.id ";
     Sql+=" and publish_item.Status=0";
	if(SiteId>0){
	Sql+=" and publish_scheme.site="+SiteId;
	}
	if(Scheme>0){
	Sql+=" and publish_item.PublishScheme="+Scheme;
	}
	*/
	String Sql = "delete from publish_item where Status!=1";
	if(SiteId>0){
	Sql+=" and site="+SiteId;
	}
	if(Scheme>0){
	Sql+=" and PublishScheme="+Scheme;
	}
	TableUtil tu = new TableUtil();
	//System.out.println("clear sql :"+Sql);
	int res = tu.executeUpdate(Sql);
    // System.out.println("res=="+res);
	response.sendRedirect("to_be_published.jsp?a=b"+queryString);return;
}
else if(Action.equals("Publish"))
{
	String Sql ="update publish_item set CanCopyTime=AddTime where Status!=1 and Site="+SiteId;
	
	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	PublishManager.getInstance().CopyFileNow();

	response.sendRedirect("to_be_published.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage+queryString);return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script language="javascript">
function ClearItems()
{
	if(confirm("确实要清空所有待发布记录吗？")) 
	{
		this.location = "to_be_published.jsp?Action=Clear<%=queryString%>";
	}	
}

function PublishItems()
{
	if(confirm("确实要发布所有待发布记录吗？")) 
	{
		this.location = "to_be_published.jsp?Action=Publish<%=queryString%>";
	}	
}

function change(obj)
{
	if(obj!=null)
		this.location = "to_be_published.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
}

function MM_jumpMenu(obj){ //v3.0
	if(obj!=null)
	{
		if(document.all("num_perpage")!=null)
			this.location = "to_be_published.jsp?Scheme=" + obj.value+"&rowsPerPage="+document.all("num_perpage").value+"&SiteId=<%=SiteId%>";
		else
			this.location = "to_be_published.jsp?Scheme=" + obj.value+"&SiteId=<%=SiteId%>";
	}
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

function DeleteItems(){
	var ids=getIDs();
	var message = "确实要删除吗？";
	if(ids!="")
	{
		if(confirm(message)){
			 var url="../publish/publish_delete.jsp?ItemID=" + ids;
			  $.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.href=document.location.href;}   
			});  
		}
	}
}

function getIDs(){
	var id="";
	$("input[id=checkbox_id]:checked").each(function(i){
		if(id=="")
			id+=jQuery(this).val();
		else
			id+=","+jQuery(this).val();
	});
	return id;
}

function search_submit(){
	var S_Title=document.getElementById("S_Title").value;
	this.location="<%=searchTitle%>&S_Title="+S_Title;
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">  发布方案：<%=(new PublishItem()).getSelect("Scheme\" onChange=\"MM_jumpMenu(this)","publish_scheme","id","Name",Scheme+"","<option value='0'>全部方案</option>",SiteId)%>,待发布文件：</div>
    <div class="content_new_post">
		<div class="tidecms_btn" onClick="openSearch();">
			<div class="t_btn_pic"><img src="../images/icon/preview.png" /></div>
			<div class="t_btn_txt">检索</div>
		</div>
		<div class="tidecms_btn" onClick="PublishItems();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">发布</div>
		</div>
		<div class="tidecms_btn" onClick="ClearItems();">
			<div class="t_btn_pic"><img src="../images/icon/del.png" /></div>
			<div class="t_btn_txt">清空</div>
		</div>
		<div class="tidecms_btn" onClick="DeleteItems();">
			<div class="t_btn_pic"><img src="../images/icon/del.png" /></div>
			<div class="t_btn_txt">删除</div>
		</div>
    	 
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
    <td width="20">&nbsp;</td>
    <td>检索：文件名<input name="S_Title"  id="S_Title" type="text" size="18" class="textfield" value="<%=S_Title%>">
	<input name="button" type="button" class="tidecms_btn2" value="查找" onclick="search_submit()"/>
	</td>
    <td width="20">&nbsp;</td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
 
<div class="content_2012">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
			<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
			<th class="v1" width="25" align="center" valign="middle">编号</th>
			<th class="v3" style="padding-left:10px;text-align:left;">发布方案</th>
			<th class="v1"	align="center" valign="middle">文件名</th>
			<th class="v1"	align="center" valign="middle">入队列时间</th>
			<th class="v1"	align="center" valign="middle">可发布时间</th>
			<th class="v9" width="55" align="center" valign="middle">>></th>
  		</tr>
</thead>
 <tbody> 
<%
PublishScheme pt = new PublishScheme();
String ListSql = "select id,PublishScheme,FileName,FROM_UNIXTIME(AddTime,'%Y-%m-%d %H:%i:%s') as AddTime,FROM_UNIXTIME(CanCopyTime,'%Y-%m-%d %H:%i:%s') as CanCopyTime from publish_item where Status!=1";
String CountSql = "select count(*) from publish_item  where Status!=1";
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
ListSql += " order by PublishScheme,id desc";
//System.out.println(ListSql);
ResultSet Rs = pt.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = pt.pagecontrol.getMaxPages();
int TotalNumber = pt.pagecontrol.getRowsCount();
if(pt.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				PublishScheme ps = CmsCache.getPublishScheme(Rs.getInt("PublishScheme"));
				String Name = ps.getName();//convertNull(Rs.getString("publish_scheme.Name"));
				String FileName = convertNull(Rs.getString("FileName"));
				String time1 = convertNull(Rs.getString("AddTime"));
				String time2 = convertNull(Rs.getString("CanCopyTime"));
				//String time3 = convertNull(Rs.getString("CopyedTime"));
				int id = Rs.getInt("id");
				j++;
%>

	<tr>
	<td class="v1" width="25" align="center" valign="middle"><input id="checkbox_id" name="checkbox_id" value="<%=id%>" type="checkbox"/></td>
    <td class="v1" width="25" align="center" valign="middle"><%=j%></td>
    <td class="v3" style="font-weight:700;"><%=Name%></td>
	<td class="v1" align="center" valign="middle"><%=FileName%></td>
    <td class="v4"  style="color:#666666;"><%=time1%></td>
    <td class="v4"  style="color:#666666;"><%=time2%></td>
	<td class="v9"><a href="to_be_published.jsp?Action=Del&id=<%=id%><%=queryString%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td>
  </tr>
<%
			}			
}
			pt.closeRs(Rs);
%>
  
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
        	<div class="select">选择：<span id="selectAll" onClick="$('input[id=checkbox_id]').attr('checked','checked');">全部</span><span id="selectNo" onClick="$('input[id=checkbox_id]').attr('checked','');">无</span></div>
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="to_be_published.jsp?currPage=1&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="to_be_published.jsp?currPage=<%=currPage-1%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="to_be_published.jsp?currPage=<%=currPage+1%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="to_be_published.jsp?currPage=<%=TotalPageNumber%>&rowsPerPage=<%=rowsPerPage%><%=queryString%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
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
 <script type="text/javascript"> 	
	function change(obj)
	{
		if(obj!=null)		
			this.location="to_be_published.jsp?rowsPerPage="+obj.value+"<%=queryString%>";
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
		var href="to_be_published.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=queryString%>";
		document.location.href=href;
	});

});
</script>
</body>
</html>