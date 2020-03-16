<%--
  Created by IntelliJ IDEA.
  User: csd
  Date: 2019/10/15
  Time: 14:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%--<%!
    //获取数据库当前时间
    public static int getCurrentTimeSql() throws Exception{
        TableUtil tu=new TableUtil();
        int CurrentTimeL=0;
        String sql="select UNIX_TIMESTAMP() as now";
        ResultSet rs=tu.executeQuery(sql);
        while(rs.next()){
            CurrentTimeL=rs.getInt("now");
        }
        tu.closeRs(rs);
        return CurrentTimeL;
    }
%>--%>
<%
    long begin_time = System.currentTimeMillis();
    int id = getIntParameter(request,"id");
    int way = getIntParameter(request,"way");
    String items = getParameter(request,"ids");
    //制造doctop 查询现在最大的doc+1
    Channel channel2=new Channel(id);
    String table=channel2.getTableName();
    String doc_sql="select Title,DocTop from "+table;
    String wheresql=" where Active=1 ";
    if(channel2.getType()==Channel.Category_Type){
        wheresql +=" and Category=" + channel2.getId();
    }
    wheresql+=" order by  DocTop desc limit 1 ";
    doc_sql=doc_sql+wheresql;
    System.out.println("置顶doc_sql"+doc_sql);
    TableUtil tu=new TableUtil();
    ResultSet rs=tu.executeQuery(doc_sql);
    int doc_top_=0;
    String title="";
    if (rs.next()){
        doc_top_=rs.getInt("DocTop");
    }
    tu.closeRs(rs);

    Channel channel = CmsCache.getChannel(id);
    if(channel==null || channel.getId()==0)
    {
        response.sendRedirect("../content/content_nochannel.jsp");
        return;
    }
    String [] idsgroup=items.split(",");
    int doc_top=0;
    if (way==1&&doc_top_!=0){
        doc_top=doc_top_;
    }
    int item_doctop=0;
    for(String itemid:idsgroup){
        int itemid_int=Util.parseInt(itemid);
        //获取doctop
        Channel channel3=new Channel(id);
        String doc_sql2="select Title,DocTop from "+channel3.getTableName();
        String wheresql2=" where Active=1 ";
        if(channel3.getType()==channel3.Category_Type){
            wheresql2 +=" and Category=" + channel3.getId();
        }
        wheresql2+=" and id="+itemid_int;
        TableUtil tu3=new TableUtil();
        ResultSet rs3=tu3.executeQuery(doc_sql2+wheresql2);
        if (rs3.next()){
            item_doctop=rs3.getInt("DocTop");
        }
        tu3.closeRs(rs3);
        Document doc =  CmsCache.getDocument(itemid_int,id);
        int gid=doc.getGlobalID();
        int status = doc.getStatus();
        HashMap<String,String> map = new HashMap<String,String>();
        //如果way=2取消置顶，并且
        if(way==2) {
            doc_top = 0;
            if (way==2){
                String update_way2="update "+channel.getTableName()+" set DocTop=DocTop-1";
                String wheresql_way2=" where Active=1 ";
                if(channel.getType()==Channel.Category_Type){
                    wheresql_way2 +=" and Category=" + id;
                }
                wheresql_way2+=" and DocTop>"+item_doctop;
                update_way2=update_way2+wheresql_way2;
                System.out.println("update_way2"+update_way2);
                TableUtil tuway2=new TableUtil();
                tu.executeUpdate(update_way2);
            }

        }else if(way==1){//置顶
            if (item_doctop<=0){
                doc_top=doc_top+1;
            }else {
                String sql_max="select Title,DocTop from "+channel.getTableName();
                String wheresql_max=" where Active=1 ";
                if(channel.getType()==Channel.Category_Type){
                    wheresql_max +=" and Category=" + channel.getId();
                }
                wheresql_max+=" order by  DocTop desc limit 1 ";
                sql_max=sql_max+wheresql_max;
                System.out.println("最大doc_sql"+sql_max);
                TableUtil tu_max=new TableUtil();
                ResultSet rs_max=tu_max.executeQuery(sql_max);
                int doctop_max=0;
                if (rs_max.next()){
                    doctop_max=rs_max.getInt("DocTop");
                }
                doc_top=doctop_max+1;
                //数据减一
                String update_way1="update "+channel.getTableName()+" set DocTop=DocTop-1";
                String wheresql_way1=" where Active=1 ";
                if(channel.getType()==Channel.Category_Type){
                    wheresql_way1 +=" and Category=" + id;
                }
                wheresql_way1+=" and DocTop>"+item_doctop;
                update_way1=update_way1+wheresql_way1;
                System.out.println("update_way2"+update_way1);
                TableUtil tuway2=new TableUtil();
                tu.executeUpdate(update_way1);
            }
        }
        System.out.println(doc_top+"doc_topdoc_top");
        map.put("DocTop",doc_top+"");
        ItemUtil.updateItem(id,map,gid,userinfo_session.getId());
        //如果是草稿
        if(status!=0){
            doc.Approve(doc.getId()+"",doc.getChannelID());
            //System.out.println("发布耶也");
        }
        Log l = new Log();
        l.setTitle(doc.getTitle());
        l.setUser(userinfo_session.getId());
        l.setItem(itemid_int);
        if(way==1){
            l.setLogAction(1700);
        }else{
            l.setLogAction(1701);
        }
        l.setFromType("channel");
        l.setFromKey((new StringBuilder()).append(id).append("").toString());
        l.Add();
    }
    //撤销之后需要更新之前的数据统一减去撤销的数量

    out.println("success");
%>
