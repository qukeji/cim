<%--
  Created by IntelliJ IDEA.
  User: root
  Date: 2019/10/15
  Time: 17:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.base.TableUtil,
                 java.util.HashMap,
                 java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    int		ChannelID		=	getIntParameter(request,"ChannelID");
    int		ItemID			=	getIntParameter(request,"ItemID");
    int		direction		=	getIntParameter(request,"Direction");//1上移，0下移
    int     Number = getIntParameter(request,"Number");//移动行数

    System.out.println("获取的参数:"+"channelid:"+ChannelID+"ItemID:"+ItemID+"direction:"+direction+"Number:"+Number);
    String Symbol1 = "";
    String Symbol2 = "";
    String Symbol3 = "";
    if (direction == 1)// Up,increase order number,选择该记录上方的记录做ordernumber交换
    {
        Symbol1 = ">";
        Symbol2 = "asc";
        Symbol3 = "max";
    } else if (direction == 0)// down,decrease order
    // number,选择该记录下方的记录做ordernumber交换
    {
        Symbol1 = "<";
        Symbol2 = "desc";
        Symbol3 = "min";
    } else
        return;
    //查询当前文档数据
    int globalID = 0;
    String Sql="";
    String TableName="navigation";
    ResultSet Rs;
    TableUtil tu =new TableUtil("user");
    TableUtil tu2 =new TableUtil("user") ;
    TableUtil tu3 = new TableUtil("user");

    Sql = "select ordernumber ,Parent from " + TableName + " where id=" + ItemID;
    Rs = tu.executeQuery(Sql);
    int  ordernumber_now=0;//当前文章ordernumber
    int parent=0;
    if (Rs.next()) {
        ordernumber_now = Rs.getInt("ordernumber");
         parent = Rs.getInt("Parent");
    }
    tu.closeRs(Rs);
    //判断是否有重复得doctop
    Sql = "select count(id) from " + TableName + " where ordernumber="
            + ordernumber_now;
    Rs = tu.executeQuery(Sql);
    if (Rs.next()) {
        int count = Rs.getInt(1);
        if (count > 1) {
            System.out.println("ordernumber 重复,table:" + TableName
                    + ",ordernumber:" + ordernumber_now);
        }
    }
    tu.closeRs(Rs);
    //查询最大点数和最小点数，上移查询良哥最大点数，下移查询最小良哥点数
    int ordernumber1 = 0;// 大点的数
    int ordernumber2 = 0;// 小点的数
    int nn = 0;
    Sql = "SELECT ordernumber FROM " + TableName + " where ordernumber"
            + Symbol1 + ordernumber_now +" and Parent="+parent;
    Sql += " order by ordernumber " + Symbol2 + " limit "
            + (Number + 1);
    System.out.println("sql:" + Sql);
    Rs = tu.executeQuery(Sql);
    while (Rs.next()) {
        nn++;
        int nnn = Rs.getInt(1);
        System.out.println("nnn:" + nnn);
        if (nn == 1) {
            ordernumber1 = nnn;
            ordernumber2 = nnn;
        }
        if (direction == 1)// 找两个最大的数
        {
            if (nnn > ordernumber1) {
                ordernumber2 = ordernumber1;
                ordernumber1 = nnn;
            }
            if (nnn < ordernumber1 && nnn > ordernumber2)
                ordernumber2 = nnn;
        }
        if (direction == 0)// 找两个最小的数
        {
            if (nnn < ordernumber2) {
                ordernumber1 = ordernumber2;
                ordernumber2 = nnn;
            }
            if (nnn > ordernumber2 && nnn < ordernumber1)
                ordernumber1 = nnn;
        }
    }
    tu.closeRs(Rs);
    System.out.println("nn数据："+nn);
    System.out.println("parent数据："+parent);
    System.out.println("Number数据："+Number);
    System.out.println("parentordernumber1："+ordernumber1);
    System.out.println("Numberordernumber2："+ordernumber2);
    if (nn < (Number + 1))// 说明移动到最低，或最高
    {
        if (direction == 1)
            ordernumber2 = ordernumber1 + 50;
        if (direction == 0)
            ordernumber2 = ordernumber1 - 50;
    }
    System.out.println("er1："+ordernumber1);
    System.out.println("er2："+ordernumber2);
    //如果目前得最大最小两个数相邻
    if ((ordernumber1 - ordernumber2) == 1) {
        System.out.println("两个ordernumer相邻.ordernumber:" + ordernumber1);
        for (int i = 0; i <=Number; i++) {
            Sql = "select id,ordernumber from " + TableName
                    + " where id!=" + ItemID;
            Sql += " and ordernumber" + Symbol1 +ordernumber_now
                    + " order by ordernumber " + Symbol2;
            System.out.println("xianglingsql" + Sql);
            Rs = tu.executeQuery(Sql);
            // System.out.println(Sql);
            if (Rs.next()) {
                // 交换ordernumber值
                int j = Rs.getInt("id");
                int  ordernumber = Rs.getInt("ordernumber");
                // System.out.println("O:"+OrderNumber+",o:"+ordernumber+",j:"+j);
                Sql = "update " + TableName + " set ordernumber="
                        + ordernumber_now + " where id=" + j;
                tu2.executeUpdate(Sql);

                tu3.executeUpdate(Sql);
                Sql = "update " + TableName + " set ordernumber="
                        +  ordernumber + " where id=" + ItemID;
                tu2.executeUpdate(Sql);
                tu3.executeUpdate(Sql);
                ordernumber_now =  ordernumber;
            } else {
                tu2.closeRs(Rs);
                tu3.closeRs(Rs);
                break;
            }

            // System.out.println("i:"+i);
            tu.closeRs(Rs);
        }
    } else if (ordernumber2 > 0 && ordernumber1 > 0) {
        int nnn = ordernumber1 + Math.round((ordernumber2 - ordernumber1) / 2);
        System.out.println("nnn>>" + nnn);
        Sql = "update " + TableName + " set ordernumber=" + nnn+ " where id=" + ItemID;
        System.out.println("排序:"+Sql);
        tu2.executeUpdate(Sql);
        // Document(globalID);
        Log l = new Log();
        l.setUser(userinfo_session.getId());
        l.setItem(ordernumber_now);
        l.setLogType("排序");
        l.setLogAction(LogAction.document_order);
        l.setFromType("channel");
        l.Add();
    }
    out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
%>

