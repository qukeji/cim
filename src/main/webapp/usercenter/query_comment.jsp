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
					String sql_ = "select id from channel_tidehome_comment  where Active=1 and userid =" + userid;
					ResultSet rs_ = tu.executeQuery(sql_);	
					if(rs_.next())
					{
					  totalsize ++;
					  int id_ = rs_.getInt("id");
					 }
					tu.closeRs(rs_);  					   
					String  sql = "select id,Status,url,Content,CreateDate from channel_tidehome_comment where userid ="+ userid+" and Active=1 order by id desc  limit "+rowspage+",12";					
					System.out.println("查询文章语句"+sql);
					ResultSet rs = tu.executeQuery(sql);			
					if(rs.next())
					{
					  JSONObject group=new JSONObject();						 
					  int id_ = rs.getInt("id");
					  String url	= rs.getString("url"); 
					  String Content	= rs.getString("Content");    
					  int Status = rs.getInt("Status");  
					  String CreateDate	= rs.getString("CreateDate");
					  group.put("id",id_);	
					  group.put("Status",Status);	
					  group.put("url",url);
					  group.put("CreateDate",CreateDate);
					  group.put("Content",Content);							 
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
				   }catch(Exception e){
					e.printStackTrace();
					modle.put("status",2);
					modle.put("message","访问发生异常，请稍后再试");
				   out.println( modle.toString());	  			
				   }			   
              		   
%>
