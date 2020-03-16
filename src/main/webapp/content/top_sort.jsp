<%--
  Created by IntelliJ IDEA.
  User: root
  Date: 2019/10/15
  Time: 17:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="tidemedia.cms.system.*,
                    java.sql.*"%>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    int		ChannelID		=	getIntParameter(request,"ChannelID");
    int		ItemID			=	getIntParameter(request,"ItemID");
    int		Direction		=	getIntParameter(request,"Direction");//1上移，0下移
    int     Number = getIntParameter(request,"Number");//移动行数
    Channel channel = CmsCache.getChannel(ChannelID);

    //获取当前文章信息
    int Doctop=0;//当前的doctop
    String doc_sql="select Title,DocTop from "+channel.getTableName();
    String wheresql_now=" where Active=1 ";
    if(channel.getType()==channel.Category_Type){
        wheresql_now +=" and Category=" + channel.getId();
    }
    wheresql_now+=" and id="+ItemID;
    TableUtil tu_doc=new TableUtil();
    ResultSet rs_doc=tu_doc.executeQuery(doc_sql+wheresql_now);
    String title="";
    if (rs_doc.next()){
        Doctop=rs_doc.getInt("DocTop");
        title=rs_doc.getString("Title");
    }
    tu_doc.closeRs(rs_doc);
    System.out.println("当前doctop:"+Doctop);
    if (Direction==1){
        //上移
        // 1.通过上移行数对应找到上移的相邻的数据，在此数据之间的数据doctop统一减1
        // 2.通过doctop去定位需要跟新数据区间
        //3.更新当前数据的doctop为当前doctop+Number
        //4.获取最大doctop，最大只能为最大值
        String sql_max="select Title,DocTop from "+channel.getTableName();
        String wheresql_max=" where Active=1 ";
        if(channel.getType()==Channel.Category_Type){
            wheresql_max +=" and Category=" + channel.getId();
        }
        wheresql_max+=" order by  DocTop desc limit 1 ";
        sql_max=sql_max+wheresql_max;
        System.out.println("最大doc_sql"+sql_max);
        TableUtil tu=new TableUtil();
        ResultSet rs=tu.executeQuery(sql_max);
        int doctop_max=0;
        String title2="";
        if (rs.next()){
            doctop_max=rs.getInt("DocTop");
        }
        tu.closeRs(rs);
        int DocTop_=Doctop+Number;//需要把当前数据的doctop改成  Doctop_
        if (DocTop_>doctop_max){
            DocTop_=doctop_max;
        }
        // 期间的数据的doctop全部减去一
        String desc_sql="update "+channel.getTableName()+" set DocTop=DocTop-1";
        String wheresql2=" where Active=1 ";
        if(channel.getType()==Channel.Category_Type){
            wheresql2 +=" and Category=" + ChannelID;
        }
        wheresql2+=" and DocTop>"+Doctop+" and DocTop<="+DocTop_;
        desc_sql=desc_sql+wheresql2;
        updateItems(desc_sql);
        //修改当前Doctop到Doctop_的数据
        updateItem(ChannelID ,ItemID,DocTop_);

    }
    if (Direction==0){
        //下移
        int DocTop_=Doctop-Number;//需要把当前数据的doctop改成  Doctop_
        if (DocTop_<=0){
            DocTop_=1;
        }
        // 期间的数据的doctop全部加1
        String desc_sql="update "+channel.getTableName()+" set DocTop=DocTop+1";
        String wheresql2=" where Active=1 ";
        if(channel.getType()==Channel.Category_Type){
            wheresql2 +=" and Category=" + ChannelID;
        }
        wheresql2+=" and DocTop<"+Doctop+" and DocTop>="+DocTop_;
        desc_sql=desc_sql+wheresql2;
        updateItems(desc_sql);
        //修改当前Doctop到Doctop_的数据
        updateItem(ChannelID ,ItemID,DocTop_);
    }
    out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
%>
<%!
    //批量更新区间数据
    public void  updateItems(String sql) throws MessageException, SQLException {
        System.out.println("执行的sql"+sql);
        TableUtil tu=new TableUtil();
        tu.executeUpdate(sql);
    }
%>
<%!
    //更新当前数据doctop
    public void  updateItem(int channeilid,int item ,int doctop) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channeilid);
        HashMap map=new HashMap();

        String update_sql="update "+channel.getTableName()+" set DocTop="+doctop;
        String wheresql=" where Active=1";
        if(channel.getType()==Channel.Category_Type){
            wheresql +=" and Category=" + channeilid;
        }
        wheresql+=" and id="+item;
        update_sql=update_sql+wheresql;
        System.out.println("更新单挑数据sql2233"+update_sql);
        TableUtil tu=new TableUtil();
        tu.executeUpdate(update_sql);
    }
%>

