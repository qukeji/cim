 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
                java.util.Calendar,
				tidemedia.cms.util.*,
				java.sql.SQLException,
				java.sql.Timestamp,
				java.text.ParseException,
				java.text.SimpleDateFormat,
				java.util.Date,
				java.util.regex.Pattern,
				java.util.Collections,
				java.util.Comparator,
				java.util.List,
				java.util.Map,
				java.util.Map.Entry,
				java.util.TreeMap,
				java.util.ArrayList"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%!
//获取当天24点的时间戳
public static int getTimesnight(){ 
    Calendar cal = Calendar.getInstance(); 
    cal.set(Calendar.HOUR_OF_DAY, 24); 
    cal.set(Calendar.SECOND, 0); 
    cal.set(Calendar.MINUTE, 0); 
    cal.set(Calendar.MILLISECOND, 0); 
    return (int) (cal.getTimeInMillis()/1000); 
    } 

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

//Map排序
public static ArrayList<Map.Entry<Integer,Integer>> sortMap(Map map){
     List<Map.Entry<Integer, Integer>> entries = new ArrayList<Map.Entry<Integer, Integer>>(map.entrySet());
     Collections.sort(entries, new Comparator<Map.Entry<Integer, Integer>>() {
         public int compare(Map.Entry<Integer, Integer> obj1 , Map.Entry<Integer, Integer> obj2) {
             return obj2.getValue() - obj1.getValue();
         }
     });
      return (ArrayList<Entry<Integer, Integer>>) entries;
    }
%>

<%
    JSONArray jsonArray = new JSONArray();  
	try{
	int returnDays = getIntParameter(request,"returnDays");

    TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
    int wenzhengid = politics.getInt("politicsid");//问政编号信息
    int statisticsid = politics.getInt("statisticsid");//问政统计信息频道
    Channel channel = CmsCache.getChannel(statisticsid);

    int endtime = getTimesnight();
    int starttime = endtime;

    if(returnDays!=0){
        starttime=endtime-(86400*returnDays);


    }

    int allnum = 0;
    int acceptnum = 0;
    int endnum = 0;
    
    Map map=new TreeMap ();
    
    Map<Integer,String> channelnamemap = new HashMap<Integer,String>();
    
    String sql = "select Title,parent,total from "+CmsCache.getChannel(statisticsid).getTableName() +" where active = 1";
    TableUtil tu = new TableUtil();
    ResultSet Rs = tu.executeQuery(sql);
    while(Rs.next()) {
        int parent = Rs.getInt("parent");
        int total =  Rs.getInt("total");
        String channelname = convertNull(Rs.getString("Title"));
        
        map.put(parent, total);
        channelnamemap.put(parent,channelname);
        
    }
    tu.closeRs(Rs);
    
    String name = "";
    ArrayList<Map.Entry<Integer,Integer>> entries= sortMap(map);
    for( int i=0;i<5;i++){
        System. out.println(entries.get(i).getKey()+":" +entries.get(i).getValue());
        
        String deptsql = "select count(*) as num from "+CmsCache.getChannel(wenzhengid).getTableName() +" where Category = "+entries.get(i).getKey()+" and active = 1 and CreateDate>=" + starttime +" and CreateDate<" + endtime;
    
        System.out.println("===============================================================sql:="+deptsql);
        Document doc = CmsCache.getDocument(entries.get(i).getKey());

        allnum=getNum(deptsql);
        acceptnum=getNum(deptsql+" and (probstatus = 4 or probstatus = 5 or probstatus = 6)");
        endnum=getNum(deptsql+" and probstatus = 7");
        
        for(Map.Entry<Integer,String> str : channelnamemap.entrySet()){
		  if((entries.get(i).getKey()+"").equals(str.getKey()+"")){
			  name = str.getValue();
		  }
        }

        JSONObject o = new JSONObject();
        o.put("name",name);
        o.put("allnum",allnum);
        o.put("acceptnum",acceptnum);
        o.put("endnum",endnum);
        jsonArray.put(o);
    }


	}catch(Exception e){
        e.printStackTrace();
	}
	 
	out.println(jsonArray.toString());
%>



