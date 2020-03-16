package tidemedia.cms.base;

import com.alibaba.fastjson.JSON;
import org.apache.commons.pool2.impl.GenericObjectPoolConfig;
import org.json.JSONException;
import org.json.JSONObject;
import redis.clients.jedis.*;
import tidemedia.cms.publish.PublishItem;
import tidemedia.cms.publish.PublishTaskMessageBean;
import tidemedia.cms.system.CmsCache;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

/*
 * Redis
 */
public class RedisUtil {
    //	redis地址：master-10.20.12.50:13790   slave-10.20.12.51:13790
//	slave-10.20.12.52:13790
	/*
        {
            "redis": "true",
            "server": "10.20.12.20",
            "maxactive": 0,
            "maxidle": 0,
            "maxwait": 10000,
            "port": 6379,
            "nodes": "10.20.12.50:26379,10.20.12.51:26379,10.20.12.52:26379",
            "mastername": "mymaster"
        }
	*/
    public static final String PUBLISH_MESSAGE_KEY = "tidepublishfile_ready:queue";//文件待发布队列Key
    public static final String PUBLISH_TEMPLATE_MESSAGE_KEY = "tidetemplatefile_ready:queue";//模板文件待发布队列Key


    public static JedisPool pool;//单体方式
    public static JedisCluster jedisCluster;//集群方式
    public static JedisSentinelPool jspool;//哨兵模式
    public static boolean redis = true;
    static boolean isCluster = false;
    public static boolean isSentinelPool = false;//是否开启哨兵模式
    public static String MASTER_NAME = "";//主节点名字
    public static int db=0;//切换Redis分组

    public static boolean isRedis() {
        return redis;
    }

    private RedisUtil() throws MessageException, SQLException {
        InitJedis();
    }

    private static RedisUtil ru = null;

    public static RedisUtil getInstance() throws MessageException, SQLException {
        if (ru == null) {
            ru = new RedisUtil();
        }
        return ru;
    }

    //初始化
    public static void InitJedis() throws MessageException, SQLException {
        int active = 0;
        int idle = 0;
        long wait = 0;
        String server = "";
        int port = 6379;
        String password="";
        String[] node = {};
        String r = CmsCache.getParameterValue("redis");
        Set<String> sentinels = new HashSet<>();
        if (r.length() == 0)
            redis = false;
        else {
            try {
                JSONObject o = new JSONObject(r);
                String rr = o.getString("redis");
                server = o.getString("server");
                if (rr.equals("true")) redis = true;
                else redis = false;
                active = o.getInt("maxactive");
                idle = o.getInt("maxidle");
                wait = o.getLong("maxwait");
                password=o.getString("password");
                db=o.getInt("db");
                port = o.getInt("port");
                if(!o.getString("nodes").equals("")){
                    node = o.getString("nodes").split(",");
                }
                MASTER_NAME=o.getString("mastername");
                for (String oneNode : node) {
                    sentinels.add(oneNode);
                }
            } catch (JSONException e) {
                e.printStackTrace(System.out);
            }
        }
        if (!redis) return;
        System.out.println("jedis init");

        JedisPoolConfig config = new JedisPoolConfig();
        if (active < 1000) active = 1000;
        if (idle < 500) idle = 500;
        if (wait < 1000) wait = 1000;
        System.out.println("active:" + active + ",idle:" + idle + ",wait:" + wait + ",server:" + server + " port:" + port);
        config.setMaxTotal(active);
        config.setMaxIdle(idle);
        config.setMaxWaitMillis(wait);
        config.setTestOnBorrow(true);
        if (node.length == 0) {
            if(password.length()==0){
                pool = new JedisPool(config, server, port,0);
            }else{
                pool = new JedisPool(config, server, port,0,password);
            }
        } else {
            isSentinelPool = true;
            if(password.length()==0){
                jspool = new JedisSentinelPool(MASTER_NAME, sentinels, config,0);
            }else{
                jspool = new JedisSentinelPool(MASTER_NAME, sentinels, config,0,password);
            }
        }
    }

    public static JedisPool getJedisPool() {
        return pool;
    }

    /**
     * 哨兵模式
     *
     * @return
     */
    public static JedisSentinelPool getSentinelspool() {
        return jspool;
    }

    public static void RedisSet(String key, String value, int expire) {
        if (!redis) return;
        Jedis jedis;
        if (isSentinelPool) {
            jedis = jspool.getResource();
        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        jedis.set(key, value);
        if (expire > 0) jedis.expire(key.getBytes(), expire);
//        if(!isSentinelPool&&!isCluster)pool.returnResource(jedis);
        if (jedis != null) {
            jedis.close();
        }

    }

    public static String RedisGet(String key) {
        if (!redis) return null;

        Jedis jedis;
        if (isSentinelPool) {
            jedis = jspool.getResource();
        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        String value = jedis.get(key);
//        if(!isSentinelPool&&!isCluster)pool.returnResource(jedis);
        if (jedis != null) {
            jedis.close();
        }
        return value;
    }

    public static void RedisDel(String key) {
        Jedis jedis;
        if (isSentinelPool) {
            jedis = jspool.getResource();
        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        jedis.del(key);
//        if(!isSentinelPool&&!isCluster)pool.returnResource(jedis);
        if (jedis != null) {
            jedis.close();
        }
    }

    /**
     * 文件发布任务到消息队列
     *
     * @param message
     */
    public void putMessage(PublishItem message, String ActionKey) {
        Jedis jedis;
        if (isSentinelPool) {
             System.out.println("获取了哨兵模式连接源");
            jedis = jspool.getResource();
        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        String JSONStr = JSON.toJSONString(message);//对象转换为JSON
        Long size = jedis.lpush(ActionKey, JSONStr);
        //System.out.println(size + "---设置的Value" + JSONStr);
//        if(!isSentinelPool&&!isCluster)pool.returnResource(jedis);
        if (jedis != null) {
            jedis.close();
        }
    }

    /**
     * 模板发布任务到消息队列
     *
     * @param message
     */
    public void putTemplateMessage(PublishTaskMessageBean message, String ActionKey) {
        Jedis jedis;
        if (isSentinelPool) {
            jedis = jspool.getResource();
        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        String JSONStr = JSON.toJSONString(message);//模板任务对象转换为JSON
        Long size = jedis.lpush(ActionKey, JSONStr);
//        if(!isSentinelPool&&!isCluster)pool.returnResource(jedis);
        if (jedis != null) {
            jedis.close();
        }
    }


    /**
     * 根据对象 控制删除不同队列中记录
     *
     * @param message
     */
    public void MessageDel(Object message) {
        Jedis jedis;
        if (isSentinelPool) {
            jedis = jspool.getResource();
        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        String JSONStr = JSON.toJSONString(message);//模板任务对象转换为JSON
        if (message instanceof PublishItem) {//文件发布对象
            jedis.lrem(PUBLISH_MESSAGE_KEY, 0, JSONStr);
        } else if (message instanceof PublishTaskMessageBean) {//模板发布对象
            jedis.lrem(PUBLISH_TEMPLATE_MESSAGE_KEY, 0, JSONStr);
        }
//        if(!isSentinelPool&&!isCluster)pool.returnResource(jedis);
        if (jedis != null) {
            jedis.close();
        }
    }

    /**
     * @param action 1:重置文件发布队列      2：重置模板发布队列
     *               重置方式：将Redis中Key删除，重新将待发布模板、文件任务重新写入List
     */
    public void ResetQueue(int action) throws MessageException, SQLException {
        Jedis jedis;
        if (isSentinelPool) {
            jedis = jspool.getResource();
        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        switch (action) {
            case 1://文件发布队列
                jedis.del(PUBLISH_MESSAGE_KEY);//删除
                jedis.lpush(PUBLISH_MESSAGE_KEY, "");//插入个空对象，要不下面待发布任务无法插入
                RestartRedisQueue(0);//批量重置
//                if(!isSentinelPool&&!isCluster)pool.returnResource(jedis);
                break;
            case 2://模板发布队列
                jedis.del(PUBLISH_TEMPLATE_MESSAGE_KEY.getBytes());//删除
                jedis.lpush(PUBLISH_TEMPLATE_MESSAGE_KEY, "");//插入个空对象，要不下面待发布任务无法插入
                RestartTemplateFile(0);//批量重置
//                if(!isSentinelPool&&!isCluster)pool.returnResource(jedis);
                break;
        }
        if (jedis != null) {
            jedis.close();
        }
    }


    /**
     * 批量重置发布状态
     *
     * @param Status
     * @throws MessageException
     * @throws SQLException
     */
    public void RestartRedisQueue(int Status) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String Sql = "select * from publish_item  where status=" + Status + " ";
        ResultSet rs = tu.executeQuery(Sql);
        ArrayList<PublishItem> PublishItemList = new ArrayList<PublishItem>();
        while (rs.next()) {
            PublishItem MessageItem = new PublishItem();
            MessageItem.setId(rs.getInt("id"));
            MessageItem.setPublishscheme(rs.getInt("PublishScheme"));
            MessageItem.setFileName(rs.getString("FileName"));
            MessageItem.setToFileName(rs.getString("ToFileName"));
            MessageItem.setTempFolder(rs.getString("TempFolder"));
            MessageItem.setSite(rs.getInt("Site"));
            PublishItemList.add(MessageItem);
        }
        tu.closeRs(rs);

        for (PublishItem ItemBean : PublishItemList) {
            putMessage(ItemBean, RedisUtil.PUBLISH_MESSAGE_KEY);//推送至Redis队列
        }

    }

    /**
     * 批量重置发布状态
     *
     * @param Status
     * @param id_group
     * @throws MessageException
     * @throws SQLException
     */
    public void RestartRedisQueue(int Status, String[] id_group) throws MessageException, SQLException {
        String idstr = "";
        for (String id : id_group) {
            idstr += "," + id;
        }
        if (idstr.startsWith(",")) {
            idstr = idstr.substring(1);
        }
        TableUtil tu = new TableUtil();
        String Sql = "select * from  publish_item  where  id in(" + idstr + ") status=" + Status + " ";
        ResultSet rs = tu.executeQuery(Sql);
        ArrayList<PublishItem> PublishItemList = new ArrayList<PublishItem>();
        while (rs.next()) {
            PublishItem MessageItem = new PublishItem();
            MessageItem.setId(rs.getInt("id"));
            MessageItem.setPublishscheme(rs.getInt("PublishScheme"));
            MessageItem.setFileName(rs.getString("FileName"));
            MessageItem.setToFileName(rs.getString("ToFileName"));
            MessageItem.setTempFolder(rs.getString("TempFolder"));
            MessageItem.setSite(rs.getInt("Site"));
            PublishItemList.add(MessageItem);
        }
        tu.closeRs(rs);

        for (PublishItem ItemBean : PublishItemList) {
            putMessage(ItemBean, RedisUtil.PUBLISH_MESSAGE_KEY);//推送至Redis队列
        }

    }

    /**
     * 从队列中删除
     *
     * @param id
     * @throws MessageException
     * @throws SQLException
     */
    public void DelRedisQueue(int id) throws MessageException, SQLException {

        TableUtil tu = new TableUtil();
        String Sql = "select * from  publish_item  where  id = " + id + "";
        ResultSet rs = tu.executeQuery(Sql);
        while (rs.next()) {
            PublishItem MessageItem = new PublishItem();
            MessageItem.setId(rs.getInt("id"));
            MessageItem.setPublishscheme(rs.getInt("PublishScheme"));
            MessageItem.setFileName(rs.getString("FileName"));
            MessageItem.setToFileName(rs.getString("ToFileName"));
            MessageItem.setTempFolder(rs.getString("TempFolder"));
            MessageItem.setSite(rs.getInt("Site"));
            MessageDel(MessageItem);//从Redis队列中删除
        }
        tu.closeRs(rs);
    }

    /**
     * 批量删除发布任务
     *
     * @throws MessageException
     * @throws SQLException
     */
    public void DelAllRedisQueue(int Status_publish_item) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String Sql = "select * FROM publish_item WHERE id=id ";
        //Sql+=" and publish_item.Status=1";

        if (Status_publish_item != 0) {
            Sql += " and Status=" + Status_publish_item + "";
        } else {
            Sql += " and (Status=0 or Status=2)";
        }
        ResultSet rs = tu.executeQuery(Sql);
        ArrayList<PublishItem> PublishItemList = new ArrayList<PublishItem>();
        while (rs.next()) {
            PublishItem MessageItem = new PublishItem();
            MessageItem.setId(rs.getInt("id"));
            MessageItem.setPublishscheme(rs.getInt("PublishScheme"));
            MessageItem.setFileName(rs.getString("FileName"));
            MessageItem.setToFileName(rs.getString("ToFileName"));
            MessageItem.setTempFolder(rs.getString("TempFolder"));
            MessageItem.setSite(rs.getInt("Site"));
            PublishItemList.add(MessageItem);
        }
        tu.closeRs(rs);

        for (PublishItem ItemBean : PublishItemList) {
            MessageDel(ItemBean);//推送至Redis队列
        }

    }


    /**
     * 批量重置发布状态
     *
     * @param Status
     * @throws MessageException
     * @throws SQLException
     */
    public void RestartTemplateFile(int Status) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String Sql = "select * from publish_task  where status=" + Status + " ";
        ResultSet rs = tu.executeQuery(Sql);
        ArrayList<PublishTaskMessageBean> PublishTaskList = new ArrayList<PublishTaskMessageBean>();
        while (rs.next()) {
            /** 2019-07-26 曲科籍  将模板任务放置在Redis队列 **/
            PublishTaskMessageBean TaskMessageItem = new PublishTaskMessageBean();
            TaskMessageItem.setTaskID(rs.getInt("id"));
            TaskMessageItem.setChannelID(rs.getInt("ChannelID"));
            TaskMessageItem.setPublishAllItems(rs.getInt("PublishAllItems"));
            TaskMessageItem.setPublishType(rs.getInt("PublishType"));
            TaskMessageItem.setItemID(rs.getInt("itemid"));
            TaskMessageItem.setUserID(rs.getInt("user"));
            TaskMessageItem.setChannelTemplateID(rs.getInt("ChannelTemplateID"));
            PublishTaskList.add(TaskMessageItem);
        }
        tu.closeRs(rs);

        for (PublishTaskMessageBean ItemBean : PublishTaskList) {
            putTemplateMessage(ItemBean, RedisUtil.PUBLISH_TEMPLATE_MESSAGE_KEY);//推送至Redis队列
        }

    }

    /**
     * 批量重置发布状态
     *
     * @param id_group
     * @throws MessageException
     * @throws SQLException
     */
    public void RestartTemplateFile(String[] id_group) throws MessageException, SQLException {
        String idstr = "";
        for (String id : id_group) {
            idstr += "," + id;
        }
        if (idstr.startsWith(",")) {
            idstr = idstr.substring(1);
        }
        TableUtil tu = new TableUtil();
        String Sql = "select * from  publish_task  where  id in (" + idstr + ") ";
        ResultSet rs = tu.executeQuery(Sql);
        ArrayList<PublishTaskMessageBean> PublishTaskList = new ArrayList<PublishTaskMessageBean>();
        while (rs.next()) {
            /** 2019-07-26 曲科籍  将模板任务放置在Redis队列 **/
            PublishTaskMessageBean TaskMessageItem = new PublishTaskMessageBean();
            TaskMessageItem.setTaskID(rs.getInt("id"));
            TaskMessageItem.setChannelID(rs.getInt("ChannelID"));
            TaskMessageItem.setPublishAllItems(rs.getInt("PublishAllItems"));
            TaskMessageItem.setPublishType(rs.getInt("PublishType"));
            TaskMessageItem.setItemID(rs.getInt("itemid"));
            TaskMessageItem.setUserID(rs.getInt("user"));
            TaskMessageItem.setChannelTemplateID(rs.getInt("ChannelTemplateID"));
            PublishTaskList.add(TaskMessageItem);
        }
        tu.closeRs(rs);

        for (PublishTaskMessageBean ItemBean : PublishTaskList) {
            putTemplateMessage(ItemBean, RedisUtil.PUBLISH_TEMPLATE_MESSAGE_KEY);//推送至Redis队列
        }

    }


    /**
     * 批量删除模板发布任务
     *
     * @param Status
     * @throws MessageException
     * @throws SQLException
     */
    public void DelAllTemplateFile(int Status) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();

        String Sql = "select * from publish_task where Status=" + Status;

        ResultSet rs = tu.executeQuery(Sql);
        ArrayList<PublishTaskMessageBean> PublishTaskList = new ArrayList<PublishTaskMessageBean>();
        while (rs.next()) {
            /** 2019-07-26 曲科籍  将模板任务放置在Redis队列 **/
            PublishTaskMessageBean TaskMessageItem = new PublishTaskMessageBean();
            TaskMessageItem.setTaskID(rs.getInt("id"));
            TaskMessageItem.setChannelID(rs.getInt("ChannelID"));
            TaskMessageItem.setPublishAllItems(rs.getInt("PublishAllItems"));
            TaskMessageItem.setPublishType(rs.getInt("PublishType"));
            TaskMessageItem.setItemID(rs.getInt("itemid"));
            TaskMessageItem.setUserID(rs.getInt("user"));
            TaskMessageItem.setChannelTemplateID(rs.getInt("ChannelTemplateID"));
            PublishTaskList.add(TaskMessageItem);
        }
        tu.closeRs(rs);

        for (PublishTaskMessageBean ItemBean : PublishTaskList) {
            MessageDel(ItemBean);//推送至Redis队列
        }

    }


    /**
     * 批量删除模板发布任务
     *
     * @throws MessageException
     * @throws SQLException
     */
    public void DelAllTemplateFile(int SiteId, int Scheme) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String Sql = " select * from publish_item where Status!=1 ";
        if (SiteId > 0) {
            Sql += " and site=" + SiteId;
        }
        if (Scheme > 0) {
            Sql += " and PublishScheme=" + Scheme;
        }
        ResultSet rs = tu.executeQuery(Sql);
        ArrayList<PublishItem> PublishItemList = new ArrayList<PublishItem>();
        while (rs.next()) {
            PublishItem MessageItem = new PublishItem();
            MessageItem.setId(rs.getInt("id"));
            MessageItem.setPublishscheme(rs.getInt("PublishScheme"));
            MessageItem.setFileName(rs.getString("FileName"));
            MessageItem.setToFileName(rs.getString("ToFileName"));
            MessageItem.setTempFolder(rs.getString("TempFolder"));
            MessageItem.setSite(rs.getInt("Site"));
            PublishItemList.add(MessageItem);
        }
        tu.closeRs(rs);

        for (PublishItem ItemBean : PublishItemList) {
            MessageDel(ItemBean);//从Redis队列中删除
        }

    }

}