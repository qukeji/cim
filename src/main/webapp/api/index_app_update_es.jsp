<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 java.io.*,
                 java.sql.*,
                 java.text.*,
                 java.util.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp" %>
<!--
作用：聚视资源入ES
-->
<%!
    //入库
    public static void addES(int globalid) throws IOException, ParseException, SQLException, MessageException {
        ESUtil2019 eu = ESUtil2019.getInstance();
        if (!eu.indexExists("tidemedia_app")) {//索引不存在，先创建索引
            createIndex("tidemedia_app", "document", eu);
        }

        int sys_photo_channelid = 0;
        TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
        sys_photo_channelid = photo_config.getInt("channelid");

        Document doc = new Document(globalid);
        if (doc.getStatus() == 1 && doc.getIntValue("Parent") == 0 && doc.getIntValue("juxian_liveid") == 0 && doc.getIntValue("item_type") != 4 && doc.getIntValue("item_type") != 6 && doc.getIntValue("doc_type") != 6) {//更新
            System.out.println("add");
            int showcomment = 0;
            int showread = 0;
            int allowcomment = 0;
            int showtime = 0;
            int showtype = 0;
            Channel channel = doc.getChannel();
            String channelcode = channel.getChannelCode();
            TableUtil tu = new TableUtil();
            String sql = "select showcomment,showread,allowcomment,showtime,showtype from channel_s" + doc.getChannel().getSite().getId() + "_config where active=1 ";
            ResultSet rs = tu.executeQuery(sql);
            if (rs.next()) {
                showcomment = rs.getInt("showcomment");
                showread = rs.getInt("showread");
                allowcomment = rs.getInt("allowcomment");
                showtime = rs.getInt("showtime");
                showtype = rs.getInt("showtype");
            }
            tu.closeRs(rs);

            String Photo = "";
            if (doc.getIntValue("item_type") == 5 || doc.getIntValue("item_type") == 2) {
                Photo = doc.getValue("Photo4");
            } else {
                Photo = doc.getValue("Photo");
            }
            String hrefapp = doc.getValue("href_app");
            if (hrefapp.equals("")) {
                if (doc.listChildItems(sys_photo_channelid).size() > 0) {
                    hrefapp = doc.getHttpHref("pic");
                } else {
                    hrefapp = doc.getHttpHref("app");
                }
            }

            //添加文档
            Map<String, Object> jsonObject = new HashMap<String, Object>();
            jsonObject.put("id", globalid);
            jsonObject.put("channelid", doc.getChannelID());
            jsonObject.put("docfrom", doc.getValue("DocFrom"));
            jsonObject.put("isphotonews", doc.getIsPhotoNews());
            jsonObject.put("channelcode", channelcode);
            jsonObject.put("title", doc.getTitle());
            jsonObject.put("dateline", doc.getPublishDate());
            jsonObject.put("siteid", doc.getChannel().getSite().getId());
            jsonObject.put("summary", doc.getSummary());
            jsonObject.put("photo", Photo);
            jsonObject.put("photo2", Util.convertNull(doc.getValue("Photo2")));
            jsonObject.put("photo3", Util.convertNull(doc.getValue("Photo3")));
            jsonObject.put("contenttype", Util.convertNull(doc.getValue("content_type")));
            jsonObject.put("doctype", doc.getIntValue("doc_type"));
            jsonObject.put("itemtype", doc.getIntValue("item_type"));
            jsonObject.put("videoid", doc.getIntValue("videoid"));
            jsonObject.put("href", doc.getHttpHref());
            jsonObject.put("showcomment", showcomment);
            jsonObject.put("showread", showread);
            jsonObject.put("allowcomment", allowcomment);
            jsonObject.put("showtime", showtime);
            jsonObject.put("showtype", showtype);
            jsonObject.put("hrefapp", Util.convertNull(hrefapp));
            jsonObject.put("frame", doc.getIntValue("frame"));
            jsonObject.put("secondcategory", doc.getIntValue("secondcategory"));
            jsonObject.put("jumptype", doc.getIntValue("jumptype"));
            eu.addDocument("tidemedia_app", "document", globalid + "", jsonObject);
        } else {
            eu.delDocument("tidemedia_app","document",globalid+"");
        }

    }
    //创建索引
    public static void createIndex(String index, String type,ESUtil2019 eu) {

        Map<String, Object> properties = new HashMap<>();

        Map<String, Object> id = new HashMap<>();
        id.put("type", "integer");
        properties.put("id", id);
        Map<String, Object> channelid = new HashMap<>();
        channelid.put("type", "integer");
        properties.put("channelid", channelid);
        Map<String, Object> docfrom = new HashMap<>();
        docfrom.put("type", "keyword");
        properties.put("docfrom", docfrom);
        Map<String, Object> isphotonews = new HashMap<>();
        isphotonews.put("type", "integer");
        properties.put("isphotonews", isphotonews);
        Map<String, Object> channelcode = new HashMap<>();
        channelcode.put("type", "keyword");
        properties.put("channelcode", channelcode);
        Map<String, Object> Title = new HashMap<>();
        Title.put("type", "keyword");
        properties.put("Title", Title);
        Map<String, Object> dateline = new HashMap<>();
        dateline.put("type", "keyword");
        properties.put("dateline", dateline);
        Map<String, Object> siteid = new HashMap<>();
        siteid.put("type", "integer");
        properties.put("siteid", siteid);
        Map<String, Object> Summary = new HashMap<>();
        Summary.put("type", "text");
        Summary.put("store", true);//参数需要研究是什么意思
        Summary.put("index", true);//参数需要研究是什么意思
        Summary.put("analyzer", "standard");//参数需要研究是什么意思
        properties.put("Summary", Summary);
        Map<String, Object> photo = new HashMap<>();
        photo.put("type", "keyword");
        properties.put("photo", photo);
        Map<String, Object> photo2 = new HashMap<>();
        photo2.put("type", "keyword");
        properties.put("photo2", photo2);
        Map<String, Object> photo3 = new HashMap<>();
        photo3.put("type", "keyword");
        properties.put("photo3", photo3);
        Map<String, Object> contenttype = new HashMap<>();
        contenttype.put("type", "keyword");
        properties.put("contenttype", contenttype);
        Map<String, Object> doctype = new HashMap<>();
        doctype.put("type", "integer");
        properties.put("doctype", doctype);
        Map<String, Object> itemtype = new HashMap<>();
        itemtype.put("type", "integer");
        properties.put("itemtype", itemtype);
        Map<String, Object> videoid = new HashMap<>();
        videoid.put("type", "integer");
        properties.put("videoid", videoid);
        Map<String, Object> href = new HashMap<>();
        href.put("type", "keyword");
        properties.put("href", href);
        Map<String, Object> showcomment = new HashMap<>();
        showcomment.put("type", "integer");
        properties.put("showcomment", showcomment);
        Map<String, Object> showread = new HashMap<>();
        showread.put("type", "integer");
        properties.put("showread", showread);
        Map<String, Object> allowcomment = new HashMap<>();
        allowcomment.put("type", "integer");
        properties.put("allowcomment", allowcomment);
        Map<String, Object> showtime = new HashMap<>();
        showtime.put("type", "integer");
        properties.put("showtime", showtime);
        Map<String, Object> showtype = new HashMap<>();
        showtype.put("type", "integer");
        properties.put("showtype", showtype);
        Map<String, Object> hrefapp = new HashMap<>();
        hrefapp.put("type", "keyword");
        properties.put("hrefapp", hrefapp);
        Map<String, Object> frame = new HashMap<>();
        frame.put("type", "integer");
        properties.put("frame", frame);
        Map<String, Object> secondcategory = new HashMap<>();
        secondcategory.put("type", "integer");
        properties.put("secondcategory", secondcategory);
        Map<String, Object> jumptype = new HashMap<>();
        jumptype.put("type", "integer");
        properties.put("jumptype", jumptype);

        eu.createIndex(index, type, properties);
    }

    //时间戳转日期
    public static String stampToDate(long l, String pattern) throws ParseException {

        SimpleDateFormat sdf = new SimpleDateFormat(pattern);

        return sdf.format(new java.util.Date(l * 1000));
    }

%>
<%
    int globalId = getIntParameter(request, "globalid");
%>
<%
    try {
        if (globalId != 0) {

            long beginTime = System.currentTimeMillis();

            addES(globalId);
        }
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }
%>
