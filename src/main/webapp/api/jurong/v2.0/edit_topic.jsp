 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%
//选题提交接口
%>

<%
	JSONObject json = new JSONObject();


	int gid				= getIntParameter(request,"id");//选题编号
	int column_id		= getIntParameter(request,"column_id");//栏目编号
	int start			= getIntParameter(request,"start");//选题时间
	String users_id		= getParameter(request,"users_id");//选题参与人编号
	String users		= getParameter(request,"users");//选题参与人
	String desc			= getParameter(request,"desc");//任务描述
	String bespeak		= getParameter(request,"bespeak");//预约车辆
	String name			= getParameter(request,"name");//任务名称
	String device		= getParameter(request,"device");//预约设备

	try {

		if(gid==0||column_id==0||start==0||users_id.equals("")||users.equals("")||desc.equals("")||name.equals("")){

			json.put("status",501);
			json.put("message","参数缺少");

		}else{
			HashMap map_doc = new HashMap();
			map_doc.put("start",start+"");
			map_doc.put("users_id",users_id);
			map_doc.put("users",users);
			map_doc.put("Summary",desc);
			map_doc.put("Title",name);
			map_doc.put("bespeak",bespeak);
			map_doc.put("task_status","0");
			map_doc.put("device",device);
			
			ItemUtil.updateItemByGid(column_id, map_doc,gid,userid);

			//发布
	        Document document = new Document(gid);
	        document.Approve(document.getId()+"",column_id);

			json.put("id",gid);
			json.put("status",200);
			json.put("message","成功");
		}
		out.print(json);

	}catch (Exception e) {
        json.put("code","500");
        json.put("message","异常:"+e.toString());
        out.print(json);
        e.printStackTrace();
    }

%>
