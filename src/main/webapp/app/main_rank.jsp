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
    //APP媒体号排行接口
%>


<%
        String callback=getParameter(request,"callback");
        int number = getIntParameter(request,"number");
        JSONArray arr = new JSONArray();
     
            int channelid=14331;//用户关注记录频道id
            Channel channel = CmsCache.getChannel(channelid);
            //第一步    //获取媒体号id。和关注数量
           String sql="select   count(1) as num ,becompanyid from "+channel.getTableName()+" where Active=1 group by becompanyid  order by num desc";
            TableUtil tu = new TableUtil();
            ResultSet rs1 = tu.executeQuery(sql);

            while (rs1.next()){
                int num=rs1.getInt("num");
                int  becompanyid=rs1.getInt("becompanyid");
                if(becompanyid!=0){
            	JSONObject o = new JSONObject();
            	
                o.put("becompanyid",becompanyid);//媒体号id
                o.put("num",num);//媒体号被关注数量
                
                //第二步    通过媒体号查询媒体信息
                int channelid2=15918;//媒体号管理频道id
                Channel channel2 = CmsCache.getChannel(channelid2);
                
                String sql2="select Photo,Title from "+channel2.getTableName()+" where Active=1 and company_id="+becompanyid;
                TableUtil tu2 = new TableUtil(); 
                ResultSet rs2 = tu2.executeQuery(sql2);
                while (rs2.next()){
                    
                    String Title=convertNull(rs2.getString("Title"));
                    String Photo=convertNull(rs2.getString("Photo"));
                    if(Title.equals("")){
                    o.put("Title","");
                    }else{
                      o.put("Title",Title);
                    }
                    if(Photo.equals("")){
                    o.put("Photo","");
                    }else{
                      o.put("Photo","http://jushi-yanshi.tidemedia.com/"+Photo);
                    }
                    o.put("Photo","http://jushi-yanshi.tidemedia.com/"+Photo);
                } tu2.closeRs(rs2);
                
                
                //第三步    通过媒体号查询媒体的直播，图片，视频等信息
                int channelid3=15913;//jushi演示频道id
                Channel channel3 = CmsCache.getChannel(channelid3);
                //图片select id from channel where parent = 媒体号内容管理频道id and Extra2 = '{"company":'"+企业编号+"'}'
                //elect id from channel where parent = 媒体号内容管理频道id and extra2 = '{\"company\":'"+企业编号+"'}'

                String Extra2="{\"company\":"+becompanyid+"}";
                String sql3="select * from channel where parent="+channelid3+" and extra2 ='"+Extra2+"'";
                System.out.println(sql3);
                TableUtil tu3 = new TableUtil(); 
                ResultSet rs3 = tu3.executeQuery(sql3);
                int id = 0 ;
                if(rs3.next()){
                    id = rs3.getInt("id");//获取到企业频道编号
                     o.put("id",id);
                }
                String tablename = CmsCache.getChannel(id).getTableName();
                //根据频道id获取，直播，图文、视频
                String  sql4="select * from "+tablename+" where Active=1 and Category="+id;
                int videocount = 0 ;//视频
                int photocount = 0 ;//图文
                int zhibocount = 0;//直播
                TableUtil tu4 = new TableUtil(); 
                ResultSet rs4 = tu4.executeQuery(sql4);
                
                while (rs4.next()){
                    int doc_type=rs4.getInt("doc_type");
                    if(doc_type==1){
                      videocount++ ;
                    }else if(doc_type==0){
                     photocount++;
                    }else if(doc_type==4){
                    zhibocount++;
                    }

                }
                    o.put("videocount",videocount);
                    o.put("photocount",photocount);
                    o.put("zhibocount",zhibocount);
                arr.put(o);
                }
                
            }tu.closeRs(rs1);
      
            out.println(arr);
%>


<%!
//获取资源数
public int getNum(String sql){

	int num = 0 ;
	try{
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(sql);
		if(Rs.next()) {
			num = Rs.getInt("num");
		}
		tu.closeRs(Rs);
	}catch(Exception e) {
		e.printStackTrace();			
	}
	return num ;

} 

%>


