<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
    //问政回复提交接口
    
%>
<%!
 public static HashMap<String ,Object> addPoliticsReason( int ChannelID,int id,String reasonR1){
    HashMap<String ,Object> map= new HashMap<String,Object>();
    try{

    if(reasonR1.equals("")){
        map.put("message","回复内容不能为空");
    } else{
        
    TideJson politicsreason = CmsCache.getParameter("politicsreason").getJson();//问政接口信息
    int channelid = politicsreason.getInt("politicsreasonid");//问政编号信息
    Channel channelreason = CmsCache.getChannel(channelid);
    Channel channel = CmsCache.getChannel(ChannelID);
     //查询到问政GId
    String sql="select * from "+channel.getTableName()+" where id="+id;
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql); 
        rs.next();
        int GlobalID=rs.getInt("GlobalID");
        //通过GID找到问题详情
        String sql2="select * from "+channelreason.getTableName()+" where parent="+GlobalID+" ORDER BY CreateDate DESC LIMIT 1";
        ResultSet rs2 = tu.executeQuery(sql2);
        if(rs2.next()) {
            int Itemid1 = rs2.getInt("id");
            int parentr1=rs2.getInt("parent");
            String Titler1=rs2.getString("Title");
            String reason=rs2.getString("reason");
            //如果回复内容为空怎更新回复不插入数据
            if(reason==null){
                String sql1=" UPDATE "+ channelreason.getTableName()+ " set reason= " +"'"+reasonR1+"'"+ " where parent IN ("+GlobalID+")";
                TableUtil tu1 = new TableUtil();
                int gid2=tu1.executeUpdate(sql1);
                if(gid2!=0){
                map.put("gid2",gid2);
                map.put("status",200);
                 }else{
                     map.put("message","失败");
                 }
            //否则插入数据
            }else{
                HashMap politicsmapreason=new HashMap();
                politicsmapreason.put("Title",Titler1);
                politicsmapreason.put("reason",reasonR1);
                politicsmapreason.put("parent",String.valueOf(parentr1));
                int gid = ItemUtil.addItemGetGlobalID(channelid, politicsmapreason);    
            }
            
        }
         map.put("ChannelID",ChannelID);
         map.put("reasonR1",reasonR1);
         map.put("id",id);
         tu.closeRs(rs);
        }
    }catch(Exception e){
        map.put("status","500");
        map.put("message","更新失败");
        e.printStackTrace();
    }    
    return map;
   }

%>


<%
    JSONObject json = new JSONObject();
    int		ChannelID	=	getIntParameter(request,"ChannelID");
    int		id		=	getIntParameter(request,"ItemID");
    String  reasonR1	= getParameter(request,"Extra1");//回复内容
    HashMap<String, Object> map = addPoliticsReason(ChannelID,id,reasonR1);
    json = new JSONObject(map);
    out.println(json);
    response.sendRedirect("../wenzheng/wenzheng_reply.jsp?ChannelID="+ChannelID+"&ItemID="+id);

%>















