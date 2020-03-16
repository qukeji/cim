package tidemedia.cms.util;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.*;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

/*
 * ES创建索引库、ES数据入库
 */
public class EsThread  extends Thread{

    public static String database = "";// 索引
    public static ESUtil2019 eu = null;
    ItemSnap item = null;

    public EsThread(ItemSnap item){

        this.item = item;
    }

    // 重写run方法
    public void run() {
        init();
        if(eu!=null){
            addES();//item_snap数据同步ES
            addDocumentES();//document数据同步ES
        }
    }
    //初始化参数
    public static void init(){
        try {
            TideJson ES_json = CmsCache.getParameter("ES_Config").getJson();
            database = ES_json.getString("database");
            eu = ESUtil2019.getInstance();
        } catch (MessageException e) {
            e.printStackTrace();
            ErrorLog.SaveErrorLog("其他错误.","ES系统参数错误",0,e);
        } catch (SQLException e) {
            e.printStackTrace();
            ErrorLog.SaveErrorLog("其他错误.","ES系统参数错误",0,e);
        }
    }

    //同步item数据
    @SuppressWarnings("unused")
    public void addES() {
        try {
            String date_ = stampToDate(item.getCreateDateL(),"yyyy");//获取文章创建日期
            String index = database + "_" + date_ ;
            if (!eu.indexExists(index)) {//索引不存在，先创建索引
                createIndex1(index);
            }

            //添加文档
            Map<String, Object> jsonObject = new HashMap<String, Object>();
            jsonObject.put("Title", item.getTitle());
            jsonObject.put("Keyword", item.getKeyword());
            jsonObject.put("Tag", item.getTag());
            jsonObject.put("ChannelCode", item.getChannelCode());
            jsonObject.put("CreateDate", item.getCreateDateL());
            jsonObject.put("PublishDate", item.getPublishDateL());
            jsonObject.put("ModifiedDate", item.getModifiedDateL());
            jsonObject.put("GlobalID", item.getGlobalID());
            jsonObject.put("User", item.getUser());
            jsonObject.put("ChannelID", item.getChannelID());
            jsonObject.put("ItemID", item.getItemID());
            jsonObject.put("OrderNumber", item.getOrderNumber());
            jsonObject.put("Status", item.getStatus());
            jsonObject.put("Active", item.getActive());
            jsonObject.put("SiteId", item.getSiteId());

            eu.addDocument(index,"_doc", item.getGlobalID()+"",jsonObject);

        } catch (ParseException e) {
            e.printStackTrace();
            ErrorLog.SaveErrorLog("其他错误.","ES入库错误",item.getChannelID(),e);
        }
    }

    //全文搜索库
    public void addDocumentES(){
        try {
            if (!eu.indexExists("tidemedia_content")) {//索引不存在，先创建索引
                createIndex("tidemedia_content");
            }

            String PublishDate = item.getPublishDate();
            if(PublishDate.equals("")){
                PublishDate = Util.getCurrentDate("yyy-MM-dd HH:mm:ss") ;
            }
            String CreateDate = item.getCreateDate();
            if(CreateDate.equals("")){
                CreateDate = Util.getCurrentDate("yyy-MM-dd HH:mm:ss") ;
            }
            int globalid = item.getGlobalID();//文章编号
            Document doc = CmsCache.getDocument(globalid);

            //添加文档
            Map<String, Object> jsonObject = new HashMap<String, Object>();
            jsonObject.put("id", globalid);
            jsonObject.put("channelid", item.getChannelID());
            jsonObject.put("SiteId", item.getSiteId());
            jsonObject.put("channelcode", item.getChannelCode());
            jsonObject.put("Status", item.getStatus());
            jsonObject.put("Active", item.getActive());
            jsonObject.put("User", item.getUser());
            jsonObject.put("Title", item.getTitle());
            jsonObject.put("Keyword", Util.XMLQuote(item.getKeyword()).replaceAll(";", " "));
            jsonObject.put("Tag", Util.XMLQuote(item.getTag()));
            jsonObject.put("dateline", item.getPublishDate());
            jsonObject.put("PublishDate", PublishDate);
            jsonObject.put("CreateDate", CreateDate);
            jsonObject.put("Summary", Util.XMLQuote(doc.getSummary()));
            jsonObject.put("Content", Util.XMLQuote(doc.getContent()));
            jsonObject.put("Photo", doc.getValue("Photo"));
            jsonObject.put("href", doc.getHttpHref());
            jsonObject.put("VirtualPV", doc.getIntValue("pv_virtual"));
            jsonObject.put("PV", doc.getIntValue("pv"));

            eu.addDocument("tidemedia_content","_doc", globalid+"",jsonObject);
            //测试发现type只能填“_doc”,具体原因需要再排查

        } catch (SQLException e) {
            e.printStackTrace();
            ErrorLog.SaveErrorLog("其他错误.","ES入库错误",item.getChannelID(),e);
        } catch (MessageException e) {
            e.printStackTrace();
            ErrorLog.SaveErrorLog("其他错误.","ES入库错误",item.getChannelID(),e);
        }
    }

    //创建索引
    public static void createIndex(String index){

        Map <String,Object> properties = new HashMap <>();

        Map<String,Object> id = new HashMap<>();
        id.put("type","integer");
        properties.put("id",id);
        Map<String,Object> channelid = new HashMap<>();
        channelid.put("type","integer");
        properties.put("channelid",channelid);
        Map<String,Object> SiteId = new HashMap<>();
        SiteId.put("type","integer");
        properties.put("SiteId",SiteId);
        Map<String,Object> channelcode = new HashMap<>();
        channelcode.put("type","keyword");
        properties.put("channelcode",channelcode);
        Map<String,Object> Title = new HashMap<>();
        Title.put("type","keyword");
        properties.put("Title",Title);
        Map<String,Object> Summary = new HashMap<>();
        Summary.put("type","text");
        Summary.put("store",true);//参数需要研究是什么意思
        Summary.put("index",true);//参数需要研究是什么意思
        Summary.put("analyzer", "standard");//参数需要研究是什么意思
        properties.put("Summary",Summary);
        Map<String,Object> Content = new HashMap<>();
        Content.put("type","text");
        Content.put("store",true);
        Content.put("index",true);
        Content.put("analyzer", "standard");
        properties.put("Content",Content);
        Map<String,Object> Photo = new HashMap<>();
        Photo.put("type","keyword");
        properties.put("Photo",Photo);
        Map<String,Object> href = new HashMap<>();
        href.put("type","keyword");
        properties.put("href",href);
        Map<String,Object> Keyword = new HashMap<>();
        Keyword.put("type","keyword");
        properties.put("Keyword",Keyword);
        Map<String,Object> Tag = new HashMap<>();
        Tag.put("type","keyword");
        properties.put("Tag",Tag);
        Map<String,Object> dateline = new HashMap<>();
        dateline.put("type","keyword");
        properties.put("dateline",dateline);
        Map<String,Object> PublishDate = new HashMap<>();
        PublishDate.put("type","date");
        PublishDate.put("format","yyy-MM-dd HH:mm:ss");
        properties.put("PublishDate",PublishDate);
        Map<String,Object> CreateDate = new HashMap<>();
        CreateDate.put("type","date");
        CreateDate.put("format","yyy-MM-dd HH:mm:ss");
        properties.put("CreateDate",CreateDate);
        Map<String,Object> Status = new HashMap<>();
        Status.put("type","integer");
        properties.put("Status",Status);
        Map<String,Object> Active = new HashMap<>();
        Active.put("type","integer");
        properties.put("Active",Active);
        Map<String,Object> User = new HashMap<>();
        User.put("type","integer");
        properties.put("User",User);
        Map<String,Object> VirtualPV = new HashMap<>();
        VirtualPV.put("type","integer");
        properties.put("VirtualPV",VirtualPV);
        Map<String,Object> PV = new HashMap<>();
        PV.put("type","integer");
        properties.put("PV",PV);

        ESUtil2019 eu = ESUtil2019.getInstance();
        eu.createIndex(index,"docuemnt",properties);
    }

    public static void createIndex1(String index){
        Map <String,Object> properties = new HashMap <>();

        Map<String,Object> id = new HashMap<>();
        id.put("type","integer");
        properties.put("id",id);
        Map<String,Object> ChannelID = new HashMap<>();
        ChannelID.put("type","integer");
        properties.put("ChannelID",ChannelID);
        Map<String,Object> SiteId = new HashMap<>();
        SiteId.put("type","integer");
        properties.put("SiteId",SiteId);
        Map<String,Object> ItemID = new HashMap<>();
        ItemID.put("type","integer");
        properties.put("ItemID",ItemID);
        Map<String,Object> GlobalID = new HashMap<>();
        GlobalID.put("type","integer");
        properties.put("GlobalID",GlobalID);
        Map<String,Object> User = new HashMap<>();
        User.put("type","integer");
        properties.put("User",User);
        Map<String,Object> Status = new HashMap<>();
        Status.put("type","integer");
        properties.put("Status",Status);
        Map<String,Object> Active = new HashMap<>();
        Active.put("type","integer");
        properties.put("Active",Active);
        Map<String,Object> OrderNumber = new HashMap<>();
        OrderNumber.put("type","integer");
        properties.put("OrderNumber",OrderNumber);
        Map<String,Object> Title = new HashMap<>();
        Title.put("type","keyword");
        properties.put("Title",Title);
        Map<String,Object> Keyword = new HashMap<>();
        Keyword.put("type","keyword");
        properties.put("Keyword",Keyword);
        Map<String,Object> Tag = new HashMap<>();
        Tag.put("type","keyword");
        properties.put("Tag",Tag);
        Map<String,Object> ChannelCode = new HashMap<>();
        ChannelCode.put("type","keyword");
        properties.put("ChannelCode",ChannelCode);
        Map<String,Object> CreateDate = new HashMap<>();
        CreateDate.put("type","integer");
        properties.put("CreateDate",CreateDate);
        Map<String,Object> PublishDate = new HashMap<>();
        PublishDate.put("type","integer");
        properties.put("PublishDate",PublishDate);
        Map<String,Object> ModifiedDate = new HashMap<>();
        ModifiedDate.put("type","integer");
        properties.put("ModifiedDate",ModifiedDate);

        ESUtil2019 eu = ESUtil2019.getInstance();
        eu.createIndex(index,"docuemnt",properties);
    }


    //时间戳转日期
    public static String stampToDate(long l,String pattern) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        return sdf.format(new java.util.Date(l*1000));
    }
}
