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
    //问政列表
%>
<%!

    //问政列表
    public HashMap<String, Object> getPoliticList(){

        HashMap<String, Object> map = new HashMap<String, Object>() ;
        try {

            String special_template = CmsCache.getParameterValue("sys_special_template_json");//
            TideJson special = CmsCache.getParameter("special").getJson();
            int channelid = special.getInt("specialid");
            TableUtil tu = new TableUtil();
            String sql = "select * from channel where parent="+channelid;
            ResultSet rs = tu.executeQuery(sql);
            JSONArray arr = new JSONArray();
            while(rs.next()){

                int id = rs.getInt("id");
                //验证用户权限
                String name=rs.getString("Name");
                JSONArray j1 = new JSONArray(special_template);
                for (int i1 = 0; i1 <= j1.length()-1 ; i1++) {
                    JSONObject o = new JSONObject();
                    JSONObject jso = j1.getJSONObject(i1);
                    String special_id = jso.getString("id");
                    String  special_name = jso.getString("name");
                    if(special_name.equals(name)){
                        o.put("special_id",special_id);
                        o.put("channelid",channelid);
                        o.put("special_name",special_name);
                        arr.put(o);
                    }
                }
               
            }
            tu.closeRs(rs);
             map.put("result",arr);
        }catch(Exception e){
            map.put("status",500);
            map.put("message","程序异常"+e.getMessage());
            e.printStackTrace();
        }
        return map ;
    }



%>

<%
    JSONObject json = new JSONObject();
    HashMap<String, Object> map = getPoliticList();
    json = new JSONObject(map);
    out.println(json.toString());
%>








