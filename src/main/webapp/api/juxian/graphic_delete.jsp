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

                删除图片


     */



    // out.print(request.getMethod());
    JSONObject  jsonObject = new JSONObject();
    try {
        int id	= getIntParameter(request,"id");//栏目编号
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
                String sys_config = CmsCache.getParameterValue("sync_juxian_live");
                JSONObject ConfigObject = new JSONObject(sys_config);
                JSONArray SiteList = ConfigObject.getJSONArray("list");

                if(SiteList.length()==0){
                    reJson.put("code",500);
                    reJson.put("message","同步库不存在");
                    return reJson;
                }
                for (int i = 0; i < SiteList.length(); i++) {
                    JSONObject SiteObject = SiteList.getJSONObject(i);
                    int SiteId = SiteObject.getInt("site");
                    int sourcechannelid = 0;
                    TableUtil tu_source = new TableUtil();
                    // 判断该文章所属校园号是否有通过审核
                    String sql_source = "select id from channel  where SerialNo='company_s"
                            + SiteId + "_source'";
                    ResultSet rs_source = tu_source.executeQuery(sql_source);
                    while (rs_source.next()) {
                        sourcechannelid = rs_source.getInt("id");
                    }
                    tu_source.closeRs(rs_source);

                    TableUtil tu_exist = new TableUtil();
                    String sql_exist = "select * from "
                            + CmsCache.getChannel(sourcechannelid)
                            .getTableName()
                            + " where juxian_sourceid="
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
                }
                return reJson;
            }
%>