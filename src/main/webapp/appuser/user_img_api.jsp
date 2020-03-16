<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
					java.io.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    //新增注册用户数量
%>
<%
        String callback=getParameter(request,"callback");
        int number = getIntParameter(request,"number");
   
   
        JSONArray arr = new JSONArray();
     
             int channelid=14263;
            Channel channel = CmsCache.getChannel(channelid);
            String sql="";
            if (number==0){
                number=10;
            }
            sql="select id, Title, avatar,FROM_UNIXTIME(CreateDate) as CreateDate from "+channel.getTableName()+" where Active=1  order by CreateDate desc  limit "+number;
            TableUtil tu = new TableUtil();
            ResultSet rs1 = tu.executeQuery(sql);

            while (rs1.next()){
                int userid=rs1.getInt("id");
                String 	Title=rs1.getString("Title");
                String avatar=convertNull(rs1.getString("avatar"));
            	String CreateDate	= convertNull(rs1.getString("CreateDate"));
            	CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm",CreateDate);
            	JSONObject o = new JSONObject();
                File file1=new File(avatar);
                
                o.put("avatar",avatar);
                o.put("userid",userid);
                o.put("Title",Title);
              
                 o.put("CreateDate",CreateDate);
                arr.put(o);
            }
      
            out.println(arr);
%>
