<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    Channel channel = ChannelUtil.getApplicationChannel("task_subject");
    int childChannel = channel.getId() ;
    int   userid=userinfo_session.getId();
    Integer TaskStatus = getIntParameter(request,"status");
    if(!channel.hasRight(userinfo_session,1))
    {
        response.sendRedirect("../noperm.jsp");return;
    }
    String Table = channel.getTableName();
    String whereSql=" where Active=1 ";
    String ListSql = "select * from " + Table;
    if(userid!=0){
        whereSql+=" and UserID="+userid;
    }
    if(TaskStatus!=null&&TaskStatus!=0){
        int status3=TaskStatus-1;
        whereSql+=" and TaskStatus="+status3;
    }

    whereSql+=" order by ModifiedDate desc limit 10";
    ListSql += whereSql;
    System.out.println(ListSql);
    String url = request.getRequestURL()+"";
    String base = url.replace(request.getRequestURI(),"");
    String ContextPath=request.getContextPath();
    TableUtil tu=new TableUtil();
    ResultSet rs = tu.executeQuery(ListSql);
    int temp_gid=0;
    String globalids="";
    JSONObject jso = new JSONObject();
    JSONArray arr = new JSONArray();
    JSONObject json = new JSONObject();
    while(rs.next()){
        int GlobalID = rs.getInt("GlobalID");
        int id_ = rs.getInt("id");
        Document document= new Document(GlobalID);

        int childId = document.getChannelID();
        String title = convertNull(rs.getString("Title"));
        String CreateDate = Util.FormatTimeStamp("", rs.getLong("CreateDate"));
        String UserName	= document.getUserName();
        int category =  document.getCategoryID();
        
        Channel channel2 = CmsCache.getChannel(childId);

        if(!channel2.hasRight(userinfo_session,1))
        {
            continue;
        }
        String path=base+ContextPath+"/content/document.jsp?ItemID="+id_+"&ChannelID="+childId;
        String channelName = channel2.getName();
        String parentChannelPath2 = CmsCache.getChannel(category).getParentChannelPath().replaceAll("/",">");
        int Status=document.getIntValue("TaskStatus");;
        String StatusDesc="";
        if(Status==0){
            StatusDesc = "<span class='tx-orange'>未开始</span>";
        }else if(Status==1){
            StatusDesc = "<span class='tx-orange'>执行中</span>";
        }else if(Status==2){
            StatusDesc = "<span class='tx-success'>已确认提交</span>";
        }else{
            StatusDesc = "<span class='tx-success'>已完成</span>";
        }
        JSONObject o = new JSONObject();
        o.put("id",id_);
        o.put("ChannelID",childId);
        o.put("title",title);
        o.put("user",UserName);
        o.put("date",CreateDate);
        o.put("path",path);
        o.put("category",category);
        o.put("channelPath",parentChannelPath2);
        o.put("channelName",channelName);
        o.put("StatusDesc",StatusDesc);
        o.put("type",1);
        arr.put(o);
    }
    tu.closeRs(rs);
    JSONArray jsonArray=new JSONArray();
    int count=getNumber(userid,childChannel,0);//总数
    int count2=getNumber(userid,childChannel,1);//未认领
    int count3=getNumber(userid,childChannel,2);//执行中
    int count4=getNumber(userid,childChannel,3);//已确认提交
    int count5=getNumber(userid,childChannel,4);//已完成
    JSONObject jsonObject1=new JSONObject();
    JSONObject jsonObject2=new JSONObject();
    JSONObject jsonObject3=new JSONObject();
    JSONObject jsonObject4=new JSONObject();
    JSONObject jsonObject5=new JSONObject();

    jsonObject1.put("lable","全部");
    jsonObject1.put("data",count);
    jsonObject2.put("lable","未开始");
    jsonObject2.put("data",count2);
    jsonObject3.put("lable","执行中");
    jsonObject3.put("data",count3);
    jsonObject4.put("lable","已确认提交");
    jsonObject4.put("data",count4);
    jsonObject5.put("lable","已完成");
    jsonObject5.put("data",count5);
    
    
    jsonArray.put(jsonObject1);
    jsonArray.put(jsonObject2);
    jsonArray.put(jsonObject3);
    jsonArray.put(jsonObject4);
    jsonArray.put(jsonObject5);
    json.put("status",200);
    json.put("message","成功");
    json.put("moduleType",5);
    json.put("moduleIcon","<i class='fa fa-list-ol mg-r-10 tx-22'></i>");
    json.put("moduleName","我的任务");
    json.put("name","我的任务");
    json.put("addJs","siderightNewContent()");
    json.put("tablist",jsonArray);
    json.put("result",arr);

    out.println(json);



%>
<%!
    //查询数量;参数，频道id,问题状态，评价
    public int getNumber(int userid,int channelid,int probstatus) throws MessageException, SQLException
    {
        int num = 0;
        Channel channel = CmsCache.getChannel(channelid);

        String whereSql = " where Active=1 ";
        if(probstatus!=0){
            int status3=probstatus-1;
            whereSql+=" and TaskStatus="+status3;
        }
     if(userid!=0){
            whereSql+=" and UserID="+userid;
        }
        String Sql = "select count(*) from " + channel.getTableName() + whereSql;
        
        // System.out.println("输出任务表：" + channel.getTableName() + "/t" +channel.getName()+ "/t" + channel.getSite().getName()+ "/t" +channel.getChannelCode());
        
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(Sql);
        if (rs.next())
            num = rs.getInt(1);
        tu.closeRs(rs);

        return num;
    }
%>
