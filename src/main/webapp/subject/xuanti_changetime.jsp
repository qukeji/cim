 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				tidemedia.cms.util.*,
				java.sql.SQLException,
				java.sql.Timestamp,
				java.text.ParseException,
				java.text.SimpleDateFormat,
				java.util.Date,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
public static String longToDate(int data){
		Long lo = Long.parseLong(data+"000");
        Date date = new Date(lo);
        System.out.println("=================================时间："+date);
        SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sd.format(date);
    }
%>
<%
//改变时间接口
	try{
        String ListSql="select id,GlobalID,Category,start from "+CmsCache.getChannel(16085).getTableName()+" where Active=1";
        TableUtil tu = new TableUtil();
        ResultSet Rs = tu.executeQuery(ListSql);
        int i = 0;
        while(Rs.next()){
            int id=Rs.getInt("id");
            int GlobalID=Rs.getInt("GlobalID");
            int Category=Rs.getInt("Category");
            int start=Rs.getInt("start");
            String start_time = "";
            if(start!=0){
                 start_time = longToDate(start);
            }
            
            System.out.println("=================================时间戳："+start);
            System.out.println("=================================时间："+start_time);
            int ChannelID = 16085;
            if(Category!=0){
                ChannelID = Category;
            }
            Document doc = CmsCache.getDocument(id,ChannelID);
            if(doc!=null&&start!=0){
                HashMap<String, String> map = new HashMap<String, String>();
                map.put("start_time",start_time+"");
                ItemUtil.updateItemById(ChannelID, map, id, 1);
                if(doc.getStatus()==1){
                    doc.Approve(id+"", ChannelID);//发布
                }

            }
            i++;
            
        }
        System.out.println("=================================总数："+i);
        tu.closeRs(Rs);
	}catch(Exception e){
        e.printStackTrace();
	}
	 
%>



