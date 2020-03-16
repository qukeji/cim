<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.MessageException,
				 tidemedia.cms.base.TableUtil,
				 tidemedia.cms.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public  void deleteLinkChildItems_button(String table,int channelid, int globalid, String childGlobalID, int user)
    throws MessageException, SQLException
  {
    TableUtil tu = new TableUtil();
    String sql = "";
 // String table = "relation_" + channelid + "_" + link_channelid;

    String[] ids = Util.StringToArray(childGlobalID, ",");
    if ((ids != null) && (ids.length > 0))
    {
      for (int i = 0; i < ids.length; i++) {
        int id_ = Util.parseInt(ids[i]);
        sql = "delete from " + table + " where GlobalID=" + globalid + " and ChildGlobalID=" + id_;
        tu.executeUpdate(sql);
      }

      Document document = new Document(globalid);
      Log l = new Log();
      l.setTitle(document.getTitle());
      l.setUser(user);
      l.setItem(document.getId());
      l.setLogAction(111);
      l.setFromType("channel");
      l.setFromKey(channelid+"");
      l.Add();
    }
  }
%>
<%
 
int		ChannelID		=	getIntParameter(request,"ChannelID");
String		ItemID		=	getParameter(request,"ItemID");
int		GlobalID		=	getIntParameter(request,"GlobalID");
int		LinkChannelID	=	getIntParameter(request,"LinkChannelID");
String table="relation_button";
if(ChannelID!=0 && !ItemID.equals(""))
{
	ChannelPrivilege cp = new ChannelPrivilege();
	if(cp.hasRight(userinfo_session,ChannelID,4))
	{
		deleteLinkChildItems_button(table,ChannelID,GlobalID,ItemID,userinfo_session.getId());
		}
}
%>
