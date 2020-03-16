<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.video.*,
				tidemedia.cms.util.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
*	创建人/修改人	最后修改时间		备注
*	郭庆光			20130620			被cms/video/server_list.jsp调用，调用转码
*/
	//out.println("this is a test");
	int id = getIntParameter(request,"id");
	//out.println("id="+id);
	Server s = new Server(id);
	String url = s.getUrl();
	//url = http://localhost:889/cms_transcode_test/
	url = url+"/video/api_refresh.jsp";
	String content=Util.connectHttpUrl(url);
	out.println(content);
%>