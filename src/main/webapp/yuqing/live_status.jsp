<%@ page import="tidemedia.cms.util.*,
				 tidemedia.cms.system.*,
				 java.io.InputStreamReader,
				 java.io.BufferedReader,
				 java.io.IOException,
				 java.io.PrintWriter,
				 org.json.JSONObject,
				 org.json.JSONException,
				 org.json.JSONArray,
				 java.util.*,
               tidemedia.cms.base.TableUtil,
               tidemedia.cms.system.ItemUtil,
               tidemedia.cms.system.CmsCache,
               tidemedia.cms.system.Channel,
               tidemedia.cms.system.Document,
               tidemedia.cms.base.MessageException,
               java.sql.ResultSet


"%>
<%@ include file="../../../../config1.jsp"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
    /*

               更改活动状态


    */
    // out.print(request.getMethod());
    JSONObject  jsonObject = new JSONObject();
    try {
        int id		= getIntParameter(request,"id");//栏目编号
        int action		= getIntParameter(request,"action");//栏目编号
        if(id==0||action==0){
            jsonObject.put("code","500");
            jsonObject.put("message","参数不全");
            out.print(jsonObject.toString());

        }else{
            jsonObject = new JSONObject();
            jsonObject.put("id",id);
            jsonObject.put("action",action);
            jsonObject = enteringDate(jsonObject);
            out.print(jsonObject.toString());
        }
    } catch (Exception e) {
        jsonObject.put("code","500");
        jsonObject.put("message","异常:"+e.toString());
        out.print(jsonObject.toString());
        e.printStackTrace();
    }
%>
<%!
    public JSONObject enteringDate(JSONObject data) throws Exception{
       JSONObject reJson = new JSONObject();
                int sourcechannelid = 0;
				String channelSql = "select * from channel where application = 'pgc_live'";
                TableUtil tuChannel= new TableUtil();
				ResultSet channelRs= tuChannel.executeQuery(channelSql);
				if(channelRs.next()){
					sourcechannelid= channelRs.getInt("id");
				}
				tuChannel.closeRs(channelRs);
            HashMap map = new HashMap();
			String action = data.getString("action");
			if(data.getInt("action")==2||data.getInt("action")==3)action = "2";
			if(data.getInt("action")==4)action ="3";
            map.put("state", action); //未直播(0)  直播中(1) 直播结束(2) 直播关闭(3)
            TableUtil tu_exist = new TableUtil();
            String sql_exist = "select * from "
                            + CmsCache.getChannel(sourcechannelid)
                            .getTableName()
                            + " where Active=1 and  juxian_liveid="
                            + data.getString("id") + " ";
            ResultSet rs_exist = tu_exist.executeQuery(sql_exist);
            ItemUtil it = new ItemUtil();
            if (rs_exist.next()) {
                 int globalid = rs_exist.getInt("globalid");
                /*int ModifyDate = rs_exist.getInt("ModifiedDate");
                if (ModifyDate <data.getInt("modify_date")) {*/
                    it.updateItemByGid(sourcechannelid,map,globalid,0);
                    if(rs_exist.getInt("status")==1){
                        //发布
                        Document document = new Document();
                        document.Approve(rs_exist.getString("id"),sourcechannelid);
                    }
                    reJson.put("code",200);
                    reJson.put("message","活动状态更改");
               /* }else{
                    reJson.put("code",500);
                    reJson.put("message","database.modifiedDate > data.modifiedDate");
                }*/
            }else{
                reJson.put("code",500);
                reJson.put("message","id不存在");
            }
            tu_exist.closeRs(rs_exist);
        return reJson;
    }
%>
