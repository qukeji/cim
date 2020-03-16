<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    int		ChannelID	=	getIntParameter(request,"ChannelID");
    String  ItemID      =   getParameter(request,"ItemID");
    String[] ItemIDArr=ItemID.split(",");

    int		CategoryID	=	getIntParameter(request,"CategoryID");
    int		check	=	getIntParameter(request,"check");
    JSONObject json=new JSONObject();
    if(ChannelID!=0 && !ItemID.equals(""))
    {
        for (String id : ItemIDArr) {
            int id1 = Integer.parseInt(id.trim());
            Channel channel = CmsCache.getChannel(ChannelID);

            String Table = channel.getTableName();
            String ListSql = "select id,Title,Photo,code from " + Table + " where id=" + id1;
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(ListSql);
            if (rs.next()) {
                String code = rs.getString("code");
                boolean result = false;
                if (check == 1) {
                    result = ItemUtil2.checkHasRecommendOut(ItemID, ChannelID);
                }

                if (!result)//Ã»ÓÐ±»ÍÆ¼ö³öÈ¥»òÇ¿ÖÆÉ¾³ý
                {
                    ChannelPrivilege cp = new ChannelPrivilege();
                    if (cp.hasRight(userinfo_session, CategoryID > 0 ? CategoryID : ChannelID, 4)) {
                        Document document = new Document();
                        document.setUser(userinfo_session.getId());
                        if (code.length() > 0&&(code.equals("feedback")||code.equals("share")||code.equals("account")||code.equals("setup"))) {
                            json.put("status", 1);
                            json.put("message","系统默认不能撤稿");
                        } else {
                            document.Delete2(ItemID, ChannelID);
                            
                        }
                    }
                } else {
                    json.put("status",3 );
                }
            }
        }
    }
      out.println(json);
   
%>
