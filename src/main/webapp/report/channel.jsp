<%@ page language="java" import="java.util.*,tidemedia.cms.system.*" pageEncoding="utf-8"%>
<%@page import="org.json.JSONArray"%>
<%@ include file="../config.jsp" %>
<%!
	public String getMaterialCategoryTree(int channelid) throws Exception
	{   
		 String xmltree = "";
		Channel ch = CmsCache.getChannel(channelid);
	    String channelname = "";
	    channelname = ch.getName();
	    if (ch.hasChild())
	    {
	        xmltree = xmltree +"{id:"+channelid+",pId:"+ch.getParent()+",name:'"+channelname+"',open:false,gid:"+channelid+"},";
	      
	      ArrayList<Integer> list = ch.getChildChannelIDs();
	      for (int i=0;i<list.size();i++ )
	      { 
	      	 int id = list.get(i);
	         xmltree +=getMaterialCategoryTree(id);
	      }
	    } 
	    else
	    {
	      xmltree += getLastString(xmltree,channelname, channelid,ch.getParent());
	    }
	    return xmltree;
	}

	public String getLastString(String xmltree,String channelname, int channelid,int parent)
	{
		  xmltree = xmltree +"{id:"+channelid+",pId:"+parent+",name:'"+channelname+"',gid:"+channelid+"},";
		  return xmltree;
	}
 %>
<%
	int parent = getIntParameter(request,"site");
	/*[
			{id:1, pId:0, name:"北京"},
			{id:2, pId:0, name:"天津"},
			{id:3, pId:0, name:"上海"},
			{id:6, pId:0, name:"重庆"},
			{id:4, pId:0, name:"河北省", open:true},
		]*/
	
	String tree = getMaterialCategoryTree(parent);
	String result = "["+tree.substring(0,tree.length()-1)+"]";
	out.println(new JSONArray(result));
%>
 
