<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：工作量统计 报表 用户组数据
* 1,李永海 20140101 创建
* 2,
* 3,
* 4,
* 5,
*/
	ArrayList<Map<String,String>> list = new ArrayList<Map<String,String>>();
           
	UserGroup userGroup=new UserGroup();
	List groups=userGroup.getGroups();
	Iterator iter=groups.iterator();
	while(iter.hasNext())
	{
		UserGroup  groupOne=(UserGroup)iter.next();
		String groupName=groupOne.getName();
		Map<String,String> map = new HashMap<String,String>();
		int id = groupOne.getId();
		String name = groupOne.getName();
		map.put("id",id+"");
		map.put("name",name);
		list.add(map);
	 
	}
	JSONArray jo = new JSONArray(list);
	out.println(jo.toString());

%>
