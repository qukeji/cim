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
    //我的问政H5app显示
%>
<%!
    public HashMap<String ,Object> getOwnPolitics(String phone){
        HashMap<String, Object> map = new HashMap<String, Object>() ;
        try{
            if (phone.equals("")){
                map.put("message","缺少参数");
                map.put("status",500);
            }else {
                TideJson politics=CmsCache.getParameter("politics").getJson();
                int channelid=politics.getInt("politicsid");
                Channel channel=CmsCache.getChannel(channelid);
                TableUtil tu=new TableUtil();
                String sql = "select Status2,count(*) as num from " + channel.getTableName() + " where Active=1 and phone="+ phone +" group by Status2";
                ResultSet rs = tu.executeQuery(sql);
                JSONArray arr = new JSONArray();
                while (rs.next()){
                    JSONObject o = new JSONObject();
                    int num=0;   
                    int status=rs.getInt("Status2");
                    num=rs.getInt("num");
                    String status_="";
                    if(status==0){
                        status_="待办理";
                    }
                    else if(status==1){
                        status_="办理中";
                    }
                    else if(status==2){
                        status_="已办理";
                    }
                    o.put("status",status_);
                    o.put("status2",status);
                    o.put("num",num);
                    o.put("message","fff");
                    arr.put(o);

                }
                tu.closeRs(rs);
                map.put("result",arr);
                map.put("message","成功");
                map.put("status",200);
            }   
           
        }catch (Exception e){
            map.put("status",500);
            map.put("message","程序异常");
            e.printStackTrace();
        }
        return map;
    }
%>

<%
	String callback=getParameter(request,"callback");

    JSONObject json = new JSONObject();

    String phone		= getParameter(request,"phone");
    HashMap<String, Object> map = getOwnPolitics(phone);
    json = new JSONObject(map);
    out.println(callback+"("+json.toString()+")");

%>
