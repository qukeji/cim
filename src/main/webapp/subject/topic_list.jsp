<%@page import="org.json.JSONArray"%>
<%@page import="tidemedia.cms.util.Util"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="tidemedia.cms.system.Channel"%>
<%@page import="tidemedia.cms.system.CmsCache"%>
<%@page import="tidemedia.cms.base.TableUtil"%>
<%@page import="tidemedia.cms.system.Document"%>
<%@page import="java.util.List"%>
<%@page import="tidemedia.cms.system.ItemUtil"%>
<%@page import="org.json.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="../config1.jsp" %>
<%

/**
大屏选题列表
*/

int id = getIntParameter(request, "id");
//type==-1 全部 type=0 未审核 type=1  审核通过 type=2毙稿 type=3 完成
int type = getIntParameter(request, "type");
int page_ = getIntParameter(request, "page");
int per_num = getIntParameter(request, "per_num");

String keyword = getParameter(request, "keyword");
String callback = getParameter(request, "callback");

int uid = getIntParameter(request, "uid");
int chid = getIntParameter(request, "chid");


JSONObject res = new JSONObject();

if(chid<=0)
{
	res.put("500", "参数缺少！");
	
	if(callback.length()>0)
		out.println(callback+"("+res.toString()+")");
	else
		out.println(res.toString());
	return ;
}
Channel ch= CmsCache.getChannel(chid);

res.put("code",200);
res.put("message","成功");

if(uid>0)
{//查询某个用户最新选题状态，uid是聚现用户编号
	String listSql = "select id,title,summary,publisher,publisher_name,UNIX_TIMESTAMP(start_time) as start_time,task_status from "+ch.getTableName()+" where User= "+uid+" order by id desc limit 1";
	TableUtil tu = new TableUtil();
	ResultSet rs = tu.executeQuery(listSql);
	if(rs.next())
	{
		int status = rs.getInt("task_status");
		String desc = "等待审核";
		if(status==1)
			desc = "审核通过";
		else if(status==2)
			desc = "审核不通过";
		else if(status==3)
			desc = "完成";
		res.put("status", desc);
	}
	else{
		res.put("status","未发布选题");
	}
	
	if(callback.length()>0)
		out.println(callback+"("+res.toString()+")");
	else
		out.println(res.toString());
	return ;
}

else
{//查询选题列表

JSONObject result = new JSONObject();
JSONArray list = new JSONArray();




if(page_==0)
	page_ = 1;
if(per_num==0)
	per_num = 10;




String listSql = "select id,title,summary,publisher,publisher_name,UNIX_TIMESTAMP(start_time) as start_time,task_status from "+ch.getTableName();
String countSql = "select count(*) from "+ch.getTableName();
String whereSql = " where active=1 ";
if(type>-1)
	whereSql += " and task_status="+type;

if(!"".equals(keyword))
	whereSql +=" and title like '%"+keyword+"%'";
whereSql+=" order by id desc";
listSql +=whereSql;
countSql +=whereSql;

TableUtil tu = ch.getTableUtil();
ResultSet Rs = tu.List(listSql,countSql,page_,per_num);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
while(Rs.next())
{
	JSONObject obj = new JSONObject();
	int task_id = Rs.getInt("id");
	String title = Rs.getString("title");
	String summary = Rs.getString("summary");
	String publisher_name = convertNull(Rs.getString("publisher_name"));
	int publisher = Rs.getInt("publisher");
	String start	= convertNull(Rs.getString("start_time"));
	if(start!=""){
	    System.out.println("================="+start);
	    start=Util.FormatDate("yyyy-MM-dd HH:mm:ss",Long.parseLong(start)*1000,"Asia/Shanghai");
	}
	//start=Util.FormatDate("yyyy-MM-dd HH:mm:ss",start);
	int status= Rs.getInt("task_status");
	String desc = "等待审核";
	if(status==1)
		desc = "审核通过";
	else if(status==2)
		desc = "审核不通过";
	else if(status==3)
		desc = "完成";
	
	obj.put("id",task_id);
	obj.put("title",title);
	obj.put("summary",summary);
	obj.put("publisher_name",publisher_name);
	obj.put("publisher",publisher);
	obj.put("start",start);
	obj.put("status",status);
	obj.put("desc",desc);
	list.put(obj);
}
tu.closeRs(Rs);

int all = ItemUtil.listItems(chid, " where active=1").size();
int no = ItemUtil.listItems(chid, " where active=1 and task_status=0").size();
int yes = ItemUtil.listItems(chid, " where active=1 and task_status=1").size();
int ok = ItemUtil.listItems(chid, " where active=1 and task_status=3").size();
result.put("list", list);
result.put("all",all);
result.put("no",no);
result.put("yes",yes);
result.put("ok",ok);
res.put("result", result);

if(callback.length()>0)
	out.println(callback+"("+res.toString()+")");
else
	out.println(res.toString());

}



%>
 
