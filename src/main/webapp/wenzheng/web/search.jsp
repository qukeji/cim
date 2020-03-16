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
    //问政搜索接口
%>
<%!
    public HashMap<String, Object> getPoliticList(int pages,int pagesize ,int status,int type,String title1,int Category1){

        HashMap<String, Object> map = new HashMap<String, Object>() ;
        try {
            
                TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
                int channelid = politics.getInt("politicsid");//问政编号信息
                Channel channel = CmsCache.getChannel(channelid);
                
                String whereSql = " where Active=1";
                
                if(type!=0){
                    whereSql += " and type="+type;
                }
                if(status!=0){
                    whereSql += " and Status2="+(status-1);
                }
                
                if(title1.length()!=0){
                   
                    whereSql +=" and Title LIKE '%" + title1 + "%'";
                    
                } 
                if (Category1!=0){
                    whereSql +=" and Category="+Category1;
                }
                
                String sql = "select * from " + channel.getTableName() + whereSql+" order by id desc";
                String sql_count = "select count(*) from " + channel.getTableName()+ whereSql+" order by id desc";
                TableUtil tu = channel.getTableUtil();
                ResultSet rs = tu.List(sql, sql_count, pages, pagesize);
                int num = tu.pagecontrol.getRowsCount();
                int TotalPageNumber = tu.pagecontrol.getMaxPages(); //总页数
                int TotalNumber = tu.pagecontrol.getRowsCount();//总条数
                JSONArray arr = new JSONArray();
                while (rs.next()) {
                    JSONObject o = new JSONObject();
                    int id_ = rs.getInt("id");
                    String username=rs.getString("UserName");
                    String falsephone="";
                    Document doc = new Document(id_, channelid);
                    int CategoryID =  rs.getInt("Category");
                    String channelName = CmsCache.getChannel(CategoryID ).getName();
                    int gid=rs.getInt("GlobalID"); 
                    String title=rs.getString("Title");
                    int Status2=rs.getInt("Status2");
                    String status_ = "";
                    if (Status2 == 0) {
                        status_ = "待办理";
                    } else if (Status2 == 1) {
                        status_ = "办理中";
                    } else if (Status2 == 2) {
                        status_ = "已办理";
                    }
                    type=rs.getInt("type");
                    type = doc.getIntValue("type");
                    //int Type=1;
                    String Type_ = "";
                    if (type == 1) {
                        Type_ = "投诉";
                    } else if (type == 2) {
                        Type_ = "咨询";
                    } else if (type == 3) {
                        Type_ = "问题";
                    } else if (type == 4) {
                        Type_ = "建议";
                    } else if (type == 5) {
                        Type_ = "反馈";
                    }
                   
                    o.put("Title", title);
                    o.put("Status2", status_);
                    o.put("type", Type_);
                    o.put("CreateDate", doc.getCreateDate());
                    o.put("UserName",username);
                    o.put("channelName",channelName);
                    if (Status2 == 2) {
                        o.put("reason", doc.getValue("reason"));
                    }
                    o.put("ModifiedDate", doc.getValue("ModifiedDate"));
                    o.put("Summary", doc.getSummary());
                    o.put("id", gid);
                    o.put("num",num);
                    arr.put(o);
                }
                tu.closeRs(rs);
                map.put("status", 200);
                map.put("message", "成功");
                map.put("result",arr);
                map.put("TotalPageNumber",TotalPageNumber);
                map.put("TotalNumber",TotalNumber);
            
        }catch(Exception e){
            map.put("status",500);
            map.put("message","程序异常"+e.getMessage());
            e.printStackTrace();
        }
        return map ;
    }
    
    
    
%>
<%
	String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();
    int status = getIntParameter(request,"status");//状态
    int type = getIntParameter(request,"type");//类型
    int pages = getIntParameter(request,"page");//页码
    int pagesize = getIntParameter(request,"pagesize");
    String title= getParameter(request,"title");
    int category= getIntParameter(request,"category");//频道部门编号
    if(pages<1) pages = 1;//if(pages>0) pages = pages-1;
    if(pagesize<=0) pagesize = 20;
    HashMap<String, Object> map = getPoliticList( pages, pagesize,status,type,title,category);
    json = new JSONObject(map);
   out.println(callback+"("+json.toString()+")");
%>
