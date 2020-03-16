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
    //部门数据统计
%>
<%!
public void getMianList(){
	try{
		//部门统计statisticalformain
		TideJson statisticalformain = CmsCache.getParameter("statisticalformain").getJson();
		int channelid1 = statisticalformain.getInt("statisticalformainid");
		Channel channel1 = CmsCache.getChannel(channelid1);
	   
		//查询部门  
		TideJson politics = CmsCache.getParameter("politics").getJson();
		int channelid = politics.getInt("politicsid");
		Channel channel = CmsCache.getChannel(channelid);
		TableUtil tu = new TableUtil();
		String sql = "select * from channel where parent="+channelid;
		ResultSet rs = tu.executeQuery(sql);
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		JSONArray arr = new JSONArray();
		while(rs.next()){
			Map<String, String> map = new HashMap<String, String>();
			map.put("id", String.valueOf(rs.getInt("id")));
			map.put("Name", rs.getString("Name"));
			list.add(map);
		}
		 for(Map<String, String> map : list){
		 	  JSONObject o = new JSONObject();
			  int id =  Integer.valueOf(map.get("id"));
			  String channelName = map.get("Name");
			  int num=getNumber(id,0,0);//各部门问题总数
			  int num1=getNumber(id,4,0)+getNumber(id,5,0)+getNumber(id,6,0);//各部门受理数量=已受理+已回复+平台回复
			  int num2=getNumber(id,7,0);//完结数量=各部门完结数量
			  int num3=getNumber(id,5,0)+getNumber(id,6,0);//回复数量=已回复+部门回复
			  int num4=getNumber(id,7,1);//满意数量
			   DecimalFormat df = new DecimalFormat("0.00");
				String reply = df.format((float)num3/num);//回复率
	
				String satisfaction=df.format((float)num4/num);//满意率
				
				String finished=df.format((float)num2/num);//完结率
				
				System.out.println("==============================num:"+num+",num1:"+num1+"num2:"+num2+"num3:"+num3+"num4:"+num4+",reply:"+reply+"satisfaction:"+satisfaction+"finished:"+finished);
	
				//System.out.println(num+":"+num1+":"+satisfaction1+":"+satisfaction);
				
				//查询统计部门 
				HashMap politicsmap=new HashMap();
				int tongji_id = exist(channelid1,id) ;
				if(tongji_id!=0){//部门已存在  
				    politicsmap.put("Title",channelName+"");
					politicsmap.put("total",num+"");
					if(num!=0){
	    		    	politicsmap.put("reply_num",reply+"");
	    				politicsmap.put("satisfy_num",satisfaction+"");
	    				politicsmap.put("finished_num",finished+"");
					
					}
				ItemUtil.updateItemById(channelid1, politicsmap,tongji_id,1);
				}else{
					//插入数据
					politicsmap.put("Title",channelName+"");
					politicsmap.put("parent",id+"");
					politicsmap.put("total",num+"");
					if(num!=0){
					    politicsmap.put("reply_num",reply+"");
	    				politicsmap.put("satisfy_num",satisfaction+"");
	    				politicsmap.put("finished_num",finished+"");
					}
				    
					ItemUtil.addItemGetGlobalID(channelid1, politicsmap);
				}
		}
	      tu.closeRs(rs);
	}catch(Exception e){
		e.printStackTrace();
	}
}

    //查询数量;参数，频道id,问题状态，评价
    public int getNumber(int channelid,int probstatus,int evaluation) throws MessageException, SQLException
    {
        int num = 0;
        Channel channel = CmsCache.getChannel(channelid);
        
        String whereSql = " where Active=1 ";
        if (channelid!=0){
            whereSql += "and Category=" + channelid;
        }
		if(probstatus!=0){
			whereSql += " and probstatus="+probstatus;
		}
		if(evaluation!=0){
			whereSql += " and evaluation="+evaluation;
		}

        String Sql = "select count(*) from " + channel.getTableName() + whereSql;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(Sql);
        if (rs.next())
            num = rs.getInt(1);
        tu.closeRs(rs);

        return num;
    }

	//判断是否存在
	public int exist(int channelid,int parent) throws MessageException, SQLException
    {
        int id = 0 ;
        Channel channel = CmsCache.getChannel(channelid);

        String sql = "select * from "+channel.getTableName()+" where parent="+parent+" and Active=1";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next())
            id = rs.getInt("id");
        tu.closeRs(rs);

        return id;
    }

%>

<%
    getMianList();

%>
