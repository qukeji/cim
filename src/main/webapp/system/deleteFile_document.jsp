<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				org.json.JSONObject,
				java.sql.*,
				java.net.URL"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
*用处：URL撤稿
*/
%>

<%
	//接收参数
	String url	= getParameter(request,"url");
%>
<%
	JSONObject json = new JSONObject();
	try{
		URL url_ = new URL(url);
		String Protocol = url_.getProtocol();// 协议
		String host = url_.getHost();// 主机名 
		String Port = "";// 端口
		if(url_.getPort()!=-1){
			Port = ":"+url_.getPort();
		}			
		String ExternalUrl = Protocol+"://"+host+Port;//外部站点地址
		String filePath = url_.getPath();//文件路径

		//查询site编号
		String sql = "select id from site where ExternalUrl='"+ExternalUrl+"'";
		TableUtil tu=new TableUtil();
		ResultSet Rs=tu.executeQuery(sql);
		int siteid = 0;
		while(Rs.next()){
			siteid = Rs.getInt("id");
		}
		tu.closeRs(Rs);
		if(siteid==0){
			json.put("status", 0);
			json.put("message", "无对应站点");
			out.println(json);
			return;
		}

		//查找对应文章globalID
		sql = "select globalid,FileName from generate_files where Site="+siteid;
		TableUtil tu1=new TableUtil();
		ResultSet Rs1=tu1.executeQuery(sql);
		int globalid = 0;
		while(Rs1.next()){
			String FileName = Rs1.getString("FileName");
			if(FileName!=null&&FileName.equals(filePath)){
				globalid = Rs1.getInt("globalid");
			}
		}
		tu1.closeRs(Rs1);
		if(globalid==0){
			json.put("status", 0);
			json.put("message", "无对应文章");
			out.println(json);
			return;
		}

		//获取文章itemid和channelid
		Document doc = new Document(globalid);
		int itemId = doc.getId();
		int channelid = doc.getChannelID();
		int CategoryID = doc.getCategoryID();
		String Title = doc.getTitle();//文章名
		Channel channel = new Channel(channelid);
		String channelName = channel.getName();//频道名 

		String message = "频道名："+channelName+"，文章名："+Title;
		//判断文章是否被推荐
		boolean result = ItemUtil2.checkHasRecommendOut(itemId+"",channelid);
		if(result){
			message += "，文章已被推荐";
		}
		message += "，请问是否确定撤稿。";
		json.put("status", 1);
		json.put("itemId", itemId);
		json.put("channelid", channelid);
		json.put("CategoryID", CategoryID);
		json.put("message", message);
		out.println(json);
	} catch (Exception e){
		json.put("status", 0);
		json.put("message", "撤稿失败");
		out.println(json);
		return ;
	}
%>