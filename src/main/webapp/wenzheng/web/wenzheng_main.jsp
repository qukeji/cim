<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.*,
                tidemedia.cms.user.*,
                tidemedia.cms.util.*,
                java.sql.*,
                org.json.*,
                 java.text.DecimalFormat,
                java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
    //首页数据显示
%>
<%!
    public HashMap<String, Object> getMianList(int userId){
        HashMap<String, Object> map = new HashMap<String, Object>() ;

        try{

            UserInfo userinfo = new UserInfo(userId);

            TideJson statisticalformain = CmsCache.getParameter("statisticalformain").getJson();
            int channelid= statisticalformain.getInt("statisticalformainid");
            Channel channel = CmsCache.getChannel(channelid);
            boolean ischild = channel.hasChild();
            
            TableUtil tu = new TableUtil();
            String sql = "select * from "+channel.getTableName()+" where Active=1 order by satisfy_num DESC";
            System.out.println(sql+"dsjkffffffffffffffffffffffffffv");


            ResultSet rs = tu.executeQuery(sql);
            JSONArray arr = new JSONArray();
            while(rs.next()){
                JSONObject o = new JSONObject();
                int id = rs.getInt("id");
                //验证用户权限

                o.put("id",id);
                o.put("channelName",convertNull(rs.getString("Title")));
                int total=  rs.getInt("total");
                DecimalFormat df = new DecimalFormat("0.00");
               // String reply_num = df.format((float)rs.getString("reply_num"));

              //int reply_num=rs.getInt("reply_num");
                String satisfy_num= rs.getString("satisfy_num");
                String reply_num= rs.getString("reply_num");
                o.put("total",total);
                o.put("reply_num",reply_num);
                o.put("satisfy_num",satisfy_num);
                o.put("a",1);
                arr.put(o);
                        
                }
            tu.closeRs(rs);
           // map.put("totalzong",gettotal(userId));//total问政总数
           // map.put("count",getconut(userId));//已解决总数
            map.put("totalnum",gettotal(userId));
            map.put("count",getconut(userId));
            map.put("result",arr);
            map.put("status",200);
            map.put("message","成功");

        }catch(Exception e){
            map.put("status",500);
            map.put("message","程序异常");
            e.printStackTrace();
        }
        return map ;
    }


%>

<%!

    //问政总数
    public  int gettotal(int userid ) throws MessageException, SQLException{
        int num = 0;
        TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
        int channelid = politics.getInt("politicsid");//问政编号信息
        Channel channel = CmsCache.getChannel(channelid);
        String whereSql = " where Active=1";
        //total问政总数
        if (userid!=0){
            whereSql = " where Active=1 and UserId="+userid;
        }


        String sql = "select * ,count(1) as total from " + channel.getTableName() + whereSql+" order by id desc";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next())
            num = rs.getInt("total");
        tu.closeRs(rs);
        return num;
    }
%>

<%!

    //问政已解决总数
    public  int getconut(int userid) throws MessageException, SQLException{
        int num = 0;
        TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
        int channelid = politics.getInt("politicsid");//问政编号信息
        Channel channel = CmsCache.getChannel(channelid);
        String whereSql = " where Active=1";
        //total问政总数
        if (userid!=0){
            whereSql = " where Active=1 and UserId="+userid;
        }
        String sql = "select * ,count(1) as count from " + channel.getTableName() + whereSql+" and Status2=2 order by id desc";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next())
            num = rs.getInt("count");
        tu.closeRs(rs);
        return num;
    }
%>


<%
    String callback=getParameter(request,"callback");

    JSONObject json = new JSONObject();    
    int userId = getIntParameter(request,"userid");
    int status = getIntParameter(request,"status");
    int type = getIntParameter(request,"type");
    int pages = getIntParameter(request,"page");//页码
    int pagesize = getIntParameter(request,"pagesize");
    if(pages<1) pages = 1;//if(pages>0) pages = pages-1;
    if(pagesize<=0) pagesize = 20;
    int userid = 123;//当前登录用户id

    HashMap<String, Object> map = getMianList(userId);
    json = new JSONObject(map);

    out.println(callback+"("+json.toString()+")");

%>
