<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.user.*,
                 tidemedia.cms.util.*,
                 java.sql.*,
                 org.json.*,
                 java.util.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config1.jsp" %>
<%
    //线索汇聚接口
%>
<%!
    public HashMap<String, Object> getItems(int type, int pages, int pagesize) {
        HashMap<String, Object> map = new HashMap<String, Object>();

        try {

            TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
            int channelId = jurong.getInt("collect");//线索汇聚全部16189;


            int channelid1 = jurong.getInt("webCollect");//16194;
            int channelid2 = jurong.getInt("weixinCollect");//16194;
            int channelid3 = jurong.getInt("weiboCollect");//16194;
            String channelcode1 = CmsCache.getChannel(channelid1).getChannelCode();
            String channelcode2 = CmsCache.getChannel(channelid2).getChannelCode();
            String channelcode3 = CmsCache.getChannel(channelid3).getChannelCode();


            String type_desc = "";
            if (type == 1) {
                channelId = channelid1;//16194;
                //type_desc = "网站";
            } else if (type == 2) {
                channelId = channelid2;//16192;
                //type_desc = "微信";
            } else if (type == 3) {
                channelId = channelid3;//16193;
                //type_desc = "微博";
            }

            Channel channel = CmsCache.getChannel(channelId);
            TableUtil tu1 = new TableUtil();
            String listSql = "select Title,SpiderUrl,Photo,Content,Summary,id,DocFrom,PublishDate,Category,ChannelCode from " + channel.getTableName() + " where Active=1 and  TO_DAYS(CURDATE())-TO_DAYS(FROM_UNIXTIME(CreateDate))<30";
            if (type != 0) {
                listSql += " and ChannelCode like '" + channel.getChannelCode() + "%'";
            }
            listSql += " order by id desc limit " + (pages * pagesize) + "," + pagesize;
            ResultSet rs1 = tu1.executeQuery(listSql);
            JSONArray jsonArray = new JSONArray();
            while (rs1.next()) {
                int id_ = rs1.getInt("id");
                String Title = convertNull(rs1.getString("Title"));
                String SpiderUrl = convertNull(rs1.getString("SpiderUrl"));
                String Photo = convertNull(rs1.getString("Photo"));
                String content = convertNull(rs1.getString("Content"));
                String Summary = convertNull(rs1.getString("Summary"));
                String DocFrom = convertNull(rs1.getString("DocFrom"));
                String PublishDate = Util.FormatTimeStamp("", rs1.getLong("PublishDate"));
                int Category = rs1.getInt("Category");
                if (Category != 0) {
                    type_desc = CmsCache.getChannel(Category).getName();
                }

                String ChannelCode = convertNull(rs1.getString("ChannelCode"));
                int type1 = 0;
                if (ChannelCode.startsWith(channelcode1)) {//网站
                    type1 = 1;
                } else if (ChannelCode.startsWith(channelcode2)) {//微信
                    type1 = 2;
                } else if (ChannelCode.startsWith(channelcode3)) {//微博
                    type1 = 3;
                }

                Document doc = new Document(id_, channelId);
                SpiderUrl = doc.getHttpHref();

                JSONObject o = new JSONObject();
                o.put("id", id_);
                o.put("ChannelId", channelId);
                o.put("title", Title);
                o.put("url", SpiderUrl);
                o.put("summary", Summary);
                o.put("photo", Photo);
                o.put("from", DocFrom);
                o.put("date", PublishDate);
                o.put("type", type1);
                o.put("type_desc", type_desc);
                jsonArray.put(o);
            }
            tu1.closeRs(rs1);
            JSONArray jsonArray2 = new JSONArray();
            int count1 = getNumber(channelid1, 1);//网站
            int count2 = getNumber(channelid2, 2);//微信
            int count3 = getNumber(channelid3, 3);//微波
            JSONObject jsonObject1 = new JSONObject();
            JSONObject jsonObject2 = new JSONObject();
            JSONObject jsonObject3 = new JSONObject();

            jsonObject1.put("lable", "网站");
            jsonObject1.put("data", count1);
            jsonObject2.put("lable", "微信");
            jsonObject2.put("data", count2);
            jsonObject3.put("lable", "微博");
            jsonObject3.put("data", count3);


            jsonArray2.put(jsonObject1);
            jsonArray2.put(jsonObject2);
            jsonArray2.put(jsonObject3);

            map.put("status", 200);
            map.put("message", "成功");
            map.put("moduleType", 6);
            map.put("moduleIcon", "线索汇聚");
            map.put("moduleName", "线索汇聚");
            map.put("name", "我的稿件");
            map.put("addJs", "siderightNewContent()");
            map.put("tablist", jsonArray2);
            map.put("result", jsonArray);
            map.put("message", "成功");

        } catch (Exception e) {
            map.put("status", 500);
            map.put("message", "程序异常");
            e.toString();
            e.printStackTrace();
        }
        return map;
    }
%>
<%
    int type = getIntParameter(request, "type");
    type = type + 1;
    int pages = getIntParameter(request, "page");
    int pagesize = getIntParameter(request, "pagesize");
    if (pages > 0) pages = pages - 1;
    if (pagesize <= 0) pagesize = 20;

    HashMap<String, Object> map = getItems(type, pages, pagesize);

    JSONObject json = new JSONObject(map);

    out.println(json);
%>
<%!
    //查询数量
    public int getNumber(int channelid, int probstatus) throws MessageException, SQLException {
        int num = 0;
        Channel channel = CmsCache.getChannel(channelid);

        String whereSql = " where Active=1 ";

        if (probstatus != 0) {
            whereSql += " and ChannelCode like '" + channel.getChannelCode() + "%' and TO_DAYS(CURDATE())-TO_DAYS(FROM_UNIXTIME(CreateDate))<30";
        }
        String Sql = "select count(*) from " + channel.getTableName() + whereSql;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(Sql);
        if (rs.next())
            num = rs.getInt(1);
        tu.closeRs(rs);

        return num;
    }
%>
