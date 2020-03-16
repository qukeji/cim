<%@ page import="tidemedia.cms.base.TableUtil,
                java.sql.ResultSet"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="tidemedia.tcenter.service.channel.ChannelListHeaderService" %>
<%@ page import="tidemedia.tcenter.service.channel.ChannelListMenuService" %>
<%@ page import="tidemedia.tcenter.service.channel.ChannelListSearchService" %>
<%@ page import="tidemedia.tcenter.service.channel.ChannelListFastSearchService" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    TableUtil tu = new TableUtil();
    String sql10 = "update channel set islistconfig=0";
    String sql11 = "update channel set islistconfig=1 where parent = -1";

    tu.executeUpdate(sql10);
    tu.executeUpdate(sql11);

    String sql = "select count(*) sum from channel_list_header";
    String sq2 = "select count(*) sum from channel_list_menu";
    String sq3 = "select count(*) sum from channel_list_search";
    String sq4 = "select count(*) sum from channel_list_fastsearch";
    String sql1 = "select id from channel where parent = -1";
    ResultSet rs = tu.executeQuery(sql);
    if (rs.next()){
        out.println("列表项目表之前有"+rs.getInt("sum")+"数据");
    }
    rs.close();
    ResultSet rs2 = tu.executeQuery(sq2);
    if (rs2.next()){
        out.println("功能菜单表之前有"+rs2.getInt("sum")+"数据");
    }
    rs2.close();
    ResultSet rs3 = tu.executeQuery(sq3);
    if (rs3.next()){
        out.println("搜索项目表之前有"+rs3.getInt("sum")+"数据");
    }
    rs3.close();
    ResultSet rs4 = tu.executeQuery(sq4);
    if (rs4.next()){
        out.println("快捷搜索表之前有"+rs4.getInt("sum")+"数据");
    }
    rs4.close();
    ResultSet rs1 = tu.executeQuery(sql1);
    List<Integer> list = new ArrayList<>();
    while (rs1.next()){
        int id = rs1.getInt("id");
        list.add(id);
    }
    rs1.close();
    for (int i = 0; i < list.size(); i++) {
        Integer insertid =  list.get(i);
        ChannelListHeaderService.addHeaderList(insertid);//生成列表项目

        ChannelListMenuService.addMenuList(insertid);//生成功能菜单

        ChannelListSearchService.addSearchList(insertid);//生成搜索项目

        ChannelListFastSearchService.addSearchList(insertid);//生成快捷检索
    }

    ResultSet rs5 = tu.executeQuery(sql);
    if (rs5.next()){
        out.println("列表项目表现在有"+rs5.getInt("sum")+"数据");
    }
    rs5.close();
    ResultSet rs6 = tu.executeQuery(sq2);
    if (rs6.next()){
        out.println("功能菜单表现在有"+rs6.getInt("sum")+"数据");
    }
    rs6.close();
    ResultSet rs7 = tu.executeQuery(sq3);
    if (rs7.next()){
        out.println("搜索项目表现在有"+rs7.getInt("sum")+"数据");
    }
    rs7.close();
    ResultSet rs8 = tu.executeQuery(sq4);
    if (rs8.next()){
        out.println("快捷搜索表现在有"+rs8.getInt("sum")+"数据");
    }
    rs8.close();
    tu.freeConnection();
%>
