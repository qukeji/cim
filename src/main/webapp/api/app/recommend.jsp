<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				java.net.URLDecoder,
 java.io.File,
 java.io.IOException,
 java.nio.charset.Charset,
java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>

<%
    /*
        接收热点数据
     */
    int site = getIntParameter(request,"site");
    int page_number = getIntParameter(request,"number");
    if (site==0){
        site=53;
    }
    if (page_number==0){
        page_number=1;
    }
    String sql="select * from channel_s"+site+"_a_a ORDER BY RAND() LIMIT "+page_number ;
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    JSONArray arr = new JSONArray();
    while(rs.next()){
        JSONObject o = new JSONObject();
        int id = rs.getInt("id");
        String  title = convertNull(rs.getString("Title"));
        String  content_type = convertNull(rs.getString("content_type"));
        String  PublishDate = convertNull(rs.getString("PublishDate"));
        String  DocFrom = convertNull(rs.getString("DocFrom"));
        String  Summary = convertNull(rs.getString("Summary"));
        String  Content = convertNull(rs.getString("Content"));
        String  Photo = convertNull(rs.getString("Photo"));
        String  Photo2 = convertNull(rs.getString("Photo2"));
        String  Photo3 = convertNull(rs.getString("Photo3"));
        String  Photo4 = convertNull(rs.getString("Photo4"));
        String  live_shareurl = convertNull(rs.getString("live_shareurl"));
        String  pdf = convertNull(rs.getString("pdf"));
        int doc_type=rs.getInt("doc_type");
        int showbuttontitle=rs.getInt("showbuttontitle");
        int GlobalID=rs.getInt("GlobalID");
        int parent=rs.getInt("Parent");
        Document document=CmsCache.getDocument(GlobalID);
        String sharepicurl= document.getFullHref("picwap");
        String sharewapurl=document.getFullHref();;
        if (doc_type==3||doc_type==7){
            sharewapurl=convertNull(rs.getString("href_app"));
        }
        if (doc_type==2){
            sharewapurl=document.getFullHref("picwap");
        }
        if (doc_type==1){
            sharewapurl=document.getFullHref("video");
        }
        if (doc_type==8){
            sharewapurl=document.getFullHref("live");
        }
        String contentUrl=document.getFullHref("app");
        if (parent!=0||doc_type==3||doc_type==7){
            contentUrl=convertNull(rs.getString("href_app"));
        }
        if (doc_type==2){
            contentUrl=document.getFullHref("pic");
        }
        int mediatype=rs.getInt("mediatype");
        String  duration = convertNull(rs.getString("duration"));
        int item_type=rs.getInt("item_type");
        int juxian_liveid=rs.getInt("juxian_liveid");
        int juxian_companyid=rs.getInt("juxian_companyid");
        int wenzheng_entrance=rs.getInt("wenzheng");
        String  baoliao_photo2 = convertNull(rs.getString("baoliao_photo2"));
        String  baoliao_photo3 = convertNull(rs.getString("baoliao_photo3"));
        String  baoliao_photo4 = convertNull(rs.getString("baoliao_photo4"));
        String  baoliao_photo5 = convertNull(rs.getString("baoliao_photo5"));

        o.put("title",title);
        o.put("contentID",GlobalID);
        o.put("content_type",content_type);
        o.put("PublishDate",PublishDate);
        o.put("sharepicurl",sharepicurl);
        o.put("docfrom",DocFrom);
        o.put("Summary",Summary);
        //o.put("Content",Content);
        o.put("photo",Photo);
        o.put("photo2",Photo2);
        o.put("photo3",Photo3);
        o.put("photo4",Photo4);
        o.put("parent",parent);
        o.put("pdf",pdf);
        o.put("live_shareurl",live_shareurl);
        o.put("contentUrl",contentUrl);
        o.put("sharewapurl",sharewapurl);
        o.put("mediatype",mediatype);
        o.put("duration",duration);
        o.put("item_type",item_type);
        o.put("juxian_liveid",juxian_liveid);
        o.put("juxian_companyid",juxian_companyid);
        o.put("wenzheng_entrance",wenzheng_entrance);
        o.put("baoliao_photo5",baoliao_photo5);
        o.put("baoliao_photo2",baoliao_photo2);
        o.put("baoliao_photo3",baoliao_photo3);
        o.put("baoliao_photo4",baoliao_photo4);

        o.put("doc_type",doc_type);
        o.put("showbuttontitle",showbuttontitle);
        arr.put(o);
    }
    out.println(arr);
%>
