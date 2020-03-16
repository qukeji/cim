package tidemedia.cms.util;

import java.io.IOException;
import java.io.StringReader;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.wltea.analyzer.IKSegmentation;
import org.wltea.analyzer.Lexeme;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.*;

public class LuceneUtil {


	public static void addLucene(ItemSnap item) throws MessageException, SQLException
	{

		addLucene(item,false);

	}


	public static void addLucene(ItemSnap item,boolean update)
	{
        EsThread et = new EsThread(item);
        et.start();

/*        TransportClient client = null;
        try{
            long begin_time = System.currentTimeMillis();
            TideJson ES_json = CmsCache.getParameter("ES_itemsnap").getJson();
            String HOST = ES_json.getString("host");//"123.56.71.230";
            int PORT = ES_json.getInt("port");//9300;
            String database = ES_json.getString("database");
            String es_table = ES_json.getString("es_table");
/*             String clustername = ES_json.getString("clustername");

            //初始化
            Map<String, String> map = new HashMap();
            map.put("cluster.name", clustername);
            Settings.Builder settings = Settings.builder().put(map);
            client = new PreBuiltTransportClient(settings.build()).addTransportAddresses(
                    new InetSocketTransportAddress(InetAddress.getByName(HOST),PORT));
*/
/*
            TransportClient client = ESUtil.getClient();

            String date_ = stampToDate(item.getCreateDateL(),"yyyy_MM");//获取文章创建日期
            String index = database + "_" + date_ ;
            IndicesExistsRequest request = new IndicesExistsRequest(index);
            IndicesExistsResponse response1 = client.admin().indices().exists(request).actionGet();
            if (!response1.isExists()) {//索引不存在，先创建索引
                client.admin().indices().prepareCreate(index).setSettings(Settings.builder().put("number_of_replicas", "3")).get();
            }

            IndexResponse response = client.prepareIndex(index, es_table, item.getGlobalID()+"")
                    .setSource(XContentFactory.jsonBuilder().startObject()
                    .field("Title", item.getTitle())
                    .field("Keyword", item.getKeyword())
                    .field("Tag", item.getTag())
                    .field("ChannelCode", item.getChannelCode())
                    .field("CreateDate", item.getCreateDateL())
                    .field("PublishDate", item.getPublishDateL())
                    .field("GlobalID", item.getGlobalID())
                    .field("User", item.getUser())
                    .field("ChannelID", item.getChannelID())
                    .field("ItemID", item.getItemID())
                    .field("OrderNumber", item.getOrderNumber())
                    .field("Status", item.getStatus())
                    .field("Active", item.getActive())
                    .endObject()).get();

 //           System.out.println("ES入库用时："+(System.currentTimeMillis()-begin_time)+"毫秒");
        } catch (Exception e) {
            Log.SystemLog("ES数据同步",item.getTitle()+"同步失败："+e.getMessage());
            System.out.println(e.getMessage());
        }/*finally {
            if(client!=null){
                //关闭客户端
                client.close();
            }

        }*/
	}
    //时间戳转日期
    public static String stampToDate(long l,String pattern) throws ParseException{
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        return sdf.format(new java.util.Date(l*1000));
    }


    //是否是内容中心下的频道
    public static boolean isContentChannel(Channel channel) throws MessageException
    {
        Map map = CmsCache.getSites();
        for(Object o : map.keySet()){
            Site site = (Site)map.get(o);
            int cid = site.getContentChannelID();
            if(cid>0)
            {
                Channel channel2 = CmsCache.getChannel(cid);
                if(channel.getChannelCode().startsWith(channel2.getChannelCode()))
                    return true;
            }
        }
        return false;
    }

    public static void delLucene(int globalid) throws MessageException, SQLException{
        ItemSnap item = new ItemSnap(globalid);
        addLucene(item,true);

//        String lucene_itemsnap = CmsCache.getParameterValue("lucene_itemsnap");
//        if(lucene_itemsnap.length()==0)
//            return;
//
//
    }

    //根据标题和内容，提取关键词
    public String[] getKeyword(String title, String content) {
        // 标题的权重为5，用lucene进行分词时，增加标题中词语的出现次数
        for (int i = 0; i < 5; i++) {
            content = title + " " + content;
        }
        // content 为纯文本形式
        IKSegmentation seg = new IKSegmentation(new StringReader(content), true);
        Map<String, Integer> map = new TreeMap<String, Integer>();
        // 分词，添加到数组中
        ArrayList list = new ArrayList();
        try {
            for (Lexeme word = seg.next(); word != null; word = seg.next()) {
                String k = word.getLexemeText();
                // 过滤掉数字
                if (checkIsNumber(k)) {
                } else {
                    if (k != null && k.length() != 1){
                        if (map.containsKey(k)) {
                            map.put(k, new Integer(((Integer) map.get(word.getLexemeText())).intValue() + 1));
                        } else {
                            map.put(k, new Integer(1));
                        }
                    }
                }
            }
            ArrayList<Entry<String, Integer>> infoIds = new ArrayList<Map.Entry<String, Integer>>(
                    map.entrySet());
            // 排序前
            for (int i = 0; i < infoIds.size(); i++) {
                String id = infoIds.get(i).toString();
                //System.out.println(id+"---------");
            }
            // 排序
            Collections.sort(infoIds, new Comparator<Map.Entry<String, Integer>>() {
                public int compare(Map.Entry<String, Integer> o1,
                                   Map.Entry<String, Integer> o2) {
                    return (o2.getValue() - o1.getValue());
                }
            });
            // 排序后
            for (int i = 0; i < 5; i++) {
                String id = infoIds.get(i).toString();
                String keyword = id.split("=")[0];
                int value = Integer.parseInt(id.split("=")[1]);
                if(value>1){
                    //System.out.println(keyword+"---"+id);
                    list.add(keyword);
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        // 返回字符串数组
        String arr[] = new String[list.size()];
        for (int i = 0; i < list.size(); i++)
            arr[i] = list.get(i).toString();
        return arr;
    }

    //正则去数字形式的关键词
    public boolean checkIsNumber(String word) {
        boolean flag = false;
        String regxp = "^-?[0-9]\\d*$";
        Pattern pattern = Pattern.compile(regxp);
        Matcher matcher = pattern.matcher(word);
        flag = matcher.find();
        ;
        return flag;
    }

    class P implements Comparable<P> {
        int docid;
        Integer ordernumber;

        P(int a,int b) {
            docid = a;ordernumber = b;
        }

        P(String a,String b) {
            docid = Util.parseInt(a);ordernumber = Util.parseInt(b);
        }

        public int compareTo(P msg2) {
            return ordernumber.compareTo(msg2.ordernumber);
        }
    }

    public static void main(String[] args) throws IOException, ParseException {

    }
}
