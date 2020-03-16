<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
                tidemedia.cms.base.*,
				java.sql.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%!
public String getParentChannelPath(Channel channel) throws MessageException, SQLException{

    String path = "";
    ArrayList arraylist = channel.getParentTree();

    if ((arraylist != null) && (arraylist.size() > 0))
    {
      for (int i = 0; i < arraylist.size(); ++i)
      {
        Channel ch = (Channel)arraylist.get(i);
		path = path  + ch.getId()  + ((i < arraylist.size() - 1) ? "," : "");  
      }
    }

    arraylist = null;

    return path;
}
%>
<%

int id = getIntParameter(request,"ChannelID");

String channelPath = getParentChannelPath(CmsCache.getChannel(id));


out.println( channelPath );
%>
