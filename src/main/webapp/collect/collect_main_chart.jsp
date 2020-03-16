<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.text.SimpleDateFormat,
				org.json.JSONObject,
				java.text.ParseException,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
    public static String getCurrentDate(java.util.Date date){
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return df.format(calendar.getTime());
    }

    public static String getZeroDate(java.util.Date date,int days){
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MONTH,calendar.get(Calendar.MONTH) - days);
        return df.format(calendar.getTime());
    }

    public static List<String> getDate(String start,String end,List<Integer> pvs) throws ParseException {

        List<String> xaxis= new ArrayList<String>();

        java.util.Date d1 = new SimpleDateFormat("yyyy-MM").parse(start);
        java.util.Date d2 = new SimpleDateFormat("yyyy-MM").parse(end);//定义结束日期
        Calendar dd = Calendar.getInstance();//

        dd.setTime(d1);

        while(dd.getTime().before(d2)){

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
            String str = sdf.format(dd.getTime());
            xaxis.add(str);
            pvs.add(0);

            dd.add(Calendar.MONTH, 1);
        }

        return xaxis;
    }


    //
    public static void setNum(int id,String begintime,String endtime,List<String> xaxis,List<Integer> list) throws ParseException,SQLException,MessageException {


        TableUtil tu = new TableUtil();
        Map<String,List> res = new HashMap<String,List>();

        String tableName = CmsCache.getChannel(id).getTableName();


        String sql = "select from_unixtime(CreateDate,'%Y-%m-%d') as CreateDate,count(*) as num";
        sql += " from "+tableName+" where Active=1 and from_unixtime(CreateDate,'%Y-%m') >= '"+begintime+"' and from_unixtime(CreateDate,'%Y-%m')<'"+endtime +"' group by from_unixtime(CreateDate,'%Y-%m')";
        System.out.println(sql);

        ResultSet rs1 = tu.executeQuery(sql);
        while(rs1.next())
        {
            int num = rs1.getInt("num");
            String CreateDate	= rs1.getString("CreateDate");
            CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm",CreateDate);
            String date_ = rs1.getTimestamp("CreateDate").toString();

            String day = date_.substring(0,7);

            int i = xaxis.indexOf(day);
            list.set(i,num);
            res.put("wenzheng",list);

        }
        tu.closeRs(rs1);
        System.out.println("list:list:"+list);

    }


%>
<%

    TideJson collect = CmsCache.getParameter("collect").getJson();
    int parent = collect.getInt("collect");//
    int collect_could = collect.getInt("collect_could");//
    int collect_paihang = collect.getInt("collect_paihang");// 
    int collect_local = collect.getInt("collect_local");// 
    //16317云资源频道ID，16408热度排行频道id，13097本地采集频道id
    int channelid[]={collect_could,collect_paihang,collect_local};


    long current = System.currentTimeMillis();
    java.util.Date date = new java.util.Date();
    String begintime = getZeroDate(date,11);
    java.util.Date date1 = new java.util.Date();

    Calendar cal = Calendar.getInstance();
    cal.setTime(date1);
    cal.add(Calendar.MONTH, 1);
    String endtime = getZeroDate(cal.getTime(),0);




//ºá×ø±ê

    Map<String,List> res = new HashMap<String,List>();
    List<Integer> num1 = new ArrayList<Integer>();//16317云资源
    List<Integer> num2 = new ArrayList<Integer>();//16408热度排行
    List<Integer> num3 = new ArrayList<Integer>();//13097本地采集

    List<Integer> num4 = new ArrayList<Integer>();
    for (int a = 0; a < channelid.length; a++) {
        if(channelid[a]==collect_could){

            List<String> xaxis= new ArrayList<String>();
            xaxis = getDate(begintime,endtime,num1) ;
            res.put("xaxis",xaxis);
            setNum(channelid[a],begintime,endtime,xaxis,num1);
            res.put("num1",num1);
        }else if(channelid[a]==collect_paihang){

            List<String> xaxis= new ArrayList<String>();
            xaxis = getDate(begintime,endtime,num2) ;
            res.put("xaxis",xaxis);
            setNum(channelid[a],begintime,endtime,xaxis,num2);
            res.put("num2",num2);
        }else if(channelid[a]==collect_local){

            List<String> xaxis= new ArrayList<String>();
            xaxis = getDate(begintime,endtime,num3) ;
            res.put("xaxis",xaxis);
            setNum(channelid[a],begintime,endtime,xaxis,num3);
            res.put("num3",num3);
        }
    }
    for(int i=0;i<num1.size();i++){
        int num5=num1.get(i);
        int num6=num2.get(i);
        int num7=num5+num6;
        num4.add(num7);
    }
    res.put("num4",num4);
    JSONObject jo = new JSONObject(res);
    out.println(jo.toString());

%>

