<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,				 
				java.util.*,
				java.net.URLEncoder,
				java.security.*,
				java.sql.*,
				org.apache.commons.lang.StringEscapeUtils,
				java.sql.Connection,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%  
             //  HttpSession session_ = request.getSession();
		     //  session_.setAttribute("userid",title);        			   
			   int type = getIntParameter(request,"type");
			   int page_ = getIntParameter(request,"page"); 
               int rowspage=(page_-1)*12;			   
               int userid= (Integer)session.getAttribute("userid");
		       JSONObject modle=new JSONObject();//整体
		       JSONArray  grouparray=new JSONArray();//group数组   		   
			  try{			
			    TableUtil tu= new TableUtil();
				int totalsize=0;
				String sql ="";
				if(type!=1){     
                    String sql_ = "select id from channel_tidehome_collect  where  Active=1 and userid = " + userid;
					ResultSet rs_ = tu.executeQuery(sql_);	
					if(rs_.next())
					{
					  totalsize ++;
					  int id_ = rs_.getInt("id");
					 }
					tu.closeRs(rs_);  	
					
					sql = "select id,url,Title,Photo,item_gid from channel_tidehome_collect  where userid = " + userid + " and type= "+ type +" and Active=1  order by PublishDate desc limit "+rowspage+", 12";					   		
					ResultSet rs = tu.executeQuery(sql);			
					if(rs.next())
					{
					  JSONObject group=new JSONObject();	
					  int id_ = rs.getInt("id");
					  String url	= rs.getString("url"); 
					  String Title	= rs.getString("Title"); 
					  String Photo	= rs.getString("Photo"); 
					   int item_gid = rs.getInt("item_gid");
					  group.put("Href",url);
					  group.put("Photo",Photo);
					  group.put("Title",Title);	
                      group.put("id",item_gid);						  
					  grouparray.put(group);				  
					}
					 tu.closeRs(rs);
					 int count=0;
					if(totalsize>12){				
					     count=totalsize/12;
					 int count_=count*12;
					 if(count_<totalsize){
						 count=count+1;
					 }
					}else{
						count=1;
					}
                     modle.put("totalpage",count);						
					 modle.put("status",1);
					 modle.put("message",grouparray);                     	             
					 out.println(modle.toString());	  	
					return;		
				}else{		
				     String sql_ = "select item_gid from channel_tidehome_collect  where  Active=1 and userid = " + userid;
					ResultSet rs_ = tu.executeQuery(sql_);	
					if(rs_.next())
					{
					  totalsize ++;
					  int id_ = rs_.getInt("id");
					 }
					tu.closeRs(rs_);  	
					 
					sql = "select id,url,Title,PublishDate,item_gid from channel_tidehome_collect where userid ="+ userid + " and type="+ type +" and Active=1  order by PublishDate desc  limit "+rowspage+",12";					
					System.out.println("查询文章语句"+sql);
					ResultSet rs = tu.executeQuery(sql);			
					if(rs.next())
					{
					  JSONObject group=new JSONObject();						 
					  int id_ = rs.getInt("id");
					  int item_gid = rs.getInt("item_gid");
					  String url	= rs.getString("url"); 
					  System.out.println("查询文章语句url"+url);
					  String Title	= rs.getString("Title"); 
					  String PublishDate	= rs.getString("PublishDate"); 
					  group.put("Href",url);
					  group.put("PublishDate",PublishDate);
					  group.put("Title",Title);		
					  group.put("id",item_gid);	
					  grouparray.put(group);				  
					}
					 tu.closeRs(rs);
					  int count=0;
					 if(totalsize>12){				
					     count=totalsize/12;
					 int count_=count*12;
					 if(count_<totalsize){
						 count=count+1;
					 }
					}else{
						count=1;
					}
                     modle.put("totalpage",count);	
					 modle.put("status",1);
					 modle.put("message",grouparray);		             
					 out.println(modle.toString());	  	
					return;		
					}				
				   }catch(Exception e){
					e.printStackTrace();
					modle.put("status",2);
					modle.put("message","访问发生异常，请稍后再试");
				   out.println( modle.toString());	  			
				   }			   
              		   
%>
