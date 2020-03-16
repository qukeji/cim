<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    //问政部门列表
%>
<%!
    public HashMap<String, Object> getList(int company){
        HashMap<String, Object> map = new HashMap<String, Object>() ;
        try{

            Channel channel = ChannelUtil.getApplicationChannel("screen");
            int channelid = channel.getId() ;

            TableUtil tu = new TableUtil();
            String wheresql=" where 1=1 ";
            if (company!=0){
                wheresql+=" and company="+company;
            }
            wheresql+=" and parent="+channelid;
            String sql = "select * from channel "+wheresql;
            ResultSet rs = tu.executeQuery(sql);
            JSONArray arr = new JSONArray();
            while(rs.next()){
                JSONObject o = new JSONObject();
                int id = rs.getInt("id");
                o.put("id",id);
                o.put("contentid",getContentId(id));
                o.put("name",rs.getString("Name"));
                o.put("num",getNumber(id));
                arr.put(o);
            }
            tu.closeRs(rs);
            map.put("result",arr);
            map.put("status",200);
            map.put("message","成功");
        }catch(Exception e){
            map.put("status",500);
            map.put("message","程序异常"+e.toString());
            e.printStackTrace();
        }
        return map ;
    }

    //指定频道编号
    public int getNumber(int channelid) throws MessageException, SQLException
    {
        int num = 0;
        Channel channel = CmsCache.getChannel(channelid);
        if(channel.getType()!=0 && channel.getType()!=1) return 0;

        String Sql = "select count(*) from " + channel.getTableName() + " where Active!=0";
        if(channel.getType()==1)
            Sql += " and Category=" + channelid;
        else
            Sql += " and Category=0";

        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(Sql);
        if (rs.next())
            num = rs.getInt(1);
        tu.closeRs(rs);

        return num;
    }
    //获取文章id
    public int  getContentId(int channelid) throws MessageException, SQLException
    {
        int id = 0;
        Channel channel = CmsCache.getChannel(channelid);

        String Sql = "select id from " + channel.getTableName() + " where Active!=0 and Category="+channelid;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(Sql);
        while(rs.next()){

            id=rs.getInt("id");

        }
        tu.closeRs(rs);

        return id;
    }
%>
<%
    String callback=getParameter(request,"callback");
    int company=userinfo_session.getCompany();
    JSONObject json = new JSONObject();
    HashMap<String, Object> map = getList(company);
    json = new JSONObject(map);
    out.println(json.toString());

%>
