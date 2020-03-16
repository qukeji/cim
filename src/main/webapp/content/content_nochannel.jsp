<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
Channel ch = CmsCache.getChannel(-1);
		ArrayList<Integer> childs = ch.getChildChannelIDs();
		if (childs!=null && childs.size()>0) {
			for(int i = 0;i<childs.size();i++){
				int channelid = (Integer)childs.get(i);
				if(userinfo_session.hasChannelShowRight(channelid))
				{
					response.sendRedirect("content.jsp?id="+channelid);
					return;
				}
			}
		}
%>