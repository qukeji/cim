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

               删除视频


    */
    // out.print(request.getMethod());
    JSONObject  jsonObject = new JSONObject();
    try {
        int id		= getIntParameter(request,"id");//栏目编号
        if(id==0){
            jsonObject.put("code","500");
            jsonObject.put("message","id不能为空");
            out.print(jsonObject.toString());
        }else{
            jsonObject = new JSONObject();
            jsonObject.put("id",id);
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

           public JSONObject enteringDate(JSONObject data)  throws Exception{
				JSONObject reJson = new JSONObject();
                int sourcechannelid = 0;
				String channelSql = "select * from channel where application = 'pgc_video'";
                TableUtil tuChannel= new TableUtil();
				ResultSet channelRs= tuChannel.executeQuery(channelSql);
				if(channelRs.next()){
					sourcechannelid= channelRs.getInt("id");
				}
				tuChannel.closeRs(channelRs);

                    TableUtil tu_exist = new TableUtil();
                    String sql_exist = "select * from "
                            + CmsCache.getChannel(sourcechannelid)
                            .getTableName()
                            + " where Active=1 and juxian_sourceid="
                            + data.getString("id") + " ";
                     /*   + CmsCache.getChannel(CurrentSourceChannel)
                                .getTableName()
                                + " where juxian_companyid="
                                + data.getString("company_id") + " juxian_liveid="
                                + data.getString("id") + " ";*/
                    ResultSet rs_exist = tu_exist.executeQuery(sql_exist);
                    ItemUtil it = new ItemUtil();
                    if (rs_exist.next()) {
                        String id = rs_exist.getString("id");
                        Document Doc = new Document();
                        Doc.Delete(id,sourcechannelid);
                        reJson.put("code",200);
                        reJson.put("message","删除成功");
                    }else{
                        reJson.put("code",500);
                        reJson.put("message","id不存在");
                    }
                    tu_exist.closeRs(rs_exist);
                return reJson;
            }
%>