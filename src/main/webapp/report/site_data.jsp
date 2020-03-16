<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：工作量统计 报表 站点数据
* 1,李永海 20140101 创建
* 2,
* 3,
* 4,
* 5,
*/

	Channel ch = CmsCache.getChannel(-1);
	ArrayList<Integer> childs = ch.getChildChannelIDs();
	ArrayList<Map<String,String>> list = new ArrayList<Map<String,String>>();
	if (childs!=null && childs.size()>0)
	{
		for(int i = 0;i<childs.size();i++)
		{
			Map<String,String> map = new HashMap<String,String>();
			int channelid = (Integer)childs.get(i);
			Channel child = CmsCache.getChannel(channelid);
			if(child.getType()!=Channel.Site_Type) continue;
			Site site = child.getSite();
			if(site.getContentChannelID()==0) continue;
			Channel newch = CmsCache.getChannel(site.getContentChannelID());
			int id = newch.getId();
			String name = newch.getParentChannel().getName() ;
			if(name.equals("")) name = newch.getName();
			map.put("id",id+"") ;
			map.put("name",name);
			list.add(map);
										
		}
	}
           
JSONArray jo = new JSONArray(list);
out.println(jo.toString());

%>
