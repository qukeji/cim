/*
 * Created on 2005-12-4
 */
package tidemedia.cms.system;

import org.apache.commons.pool2.impl.GenericObjectPoolConfig;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.json.JSONException;
import org.json.JSONObject;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisSentinelPool;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.plugin.TideApi;
import tidemedia.cms.publish.PublishManager;
import tidemedia.cms.publish.PublishScheme;
import tidemedia.cms.spider.SpiderAgent;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.SerializeUtil;
import tidemedia.cms.util.Util;

import java.io.StringReader;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

/**
 * @author 李永海(yonghai2008 @ gmail.com)
 */


public class CmsCache extends CmsCacheL {

    private static ConcurrentHashMap<Integer, Channel> channels = new ConcurrentHashMap<Integer, Channel>();
    private static ConcurrentHashMap<Integer, UserInfo> users = new ConcurrentHashMap<Integer, UserInfo>();
    //private static ConcurrentHashMap<String, tidemedia.cms.vodone.Channel> videochannels=new ConcurrentHashMap<String, tidemedia.cms.vodone.Channel>();
    private static ConcurrentHashMap<Integer, PublishScheme> publish_schemes = new ConcurrentHashMap<Integer, PublishScheme>();
    private static ConcurrentHashMap<Integer, TemplateFile> templatefiles = new ConcurrentHashMap<Integer, TemplateFile>();
    private static ConcurrentHashMap<Integer, TemplateGroup> templategroups = new ConcurrentHashMap<Integer, TemplateGroup>();
    private static ConcurrentHashMap<String, Parameter> parameters = new ConcurrentHashMap<String, Parameter>();
    //private static ArrayList<tidemedia.cms.vodone.ChannelTemplate> videochanneltemplates = new ArrayList<tidemedia.cms.vodone.ChannelTemplate>();
    //private static ArrayList<tidemedia.cms.vodone.VideoPrivilege> videoPrivilege = new ArrayList<tidemedia.cms.vodone.VideoPrivilege>();
    private static ConcurrentHashMap<Integer, Company> companys = new ConcurrentHashMap<Integer, Company>();
    private static ConcurrentHashMap<Integer, ApproveScheme> approveschemes = new ConcurrentHashMap<Integer, ApproveScheme>();


    private static ArrayList<TideApi> tideapis = new ArrayList<TideApi>();

    private static ConcurrentHashMap<Integer, Site> sites = new ConcurrentHashMap<Integer, Site>();

    //private static Config config;
    private static Site defaultsite;
    //private static boolean isOracle = false;
    //private static boolean isMysql = false;
    //private static DataSource dataSource = null;

    private static String cacheapi = "";//刷新cache的API

    public static boolean ehcache = false;
    public static boolean slowquery = false;//是否统计慢查询
    public static boolean redis = true;//是否使用redis缓存

    static boolean isCluster = false;
    public static boolean isSentinelPool = false;//是否开启哨兵模式
    public static String MASTER_NAME = "";//主节点名字
    public static int db = 0;//切换Redis分组

    //license end
    private static SpiderAgent spider_agent = null;

    private static JedisPool pool;
    private static JedisSentinelPool jspool;//哨兵模式

    static {
        try {
            long beginTime = System.currentTimeMillis();
            System.out.println("\r\n系统开始启动");
            InitConfig();
            System.out.println("初始化配置：" + getConfig().getProduct());
            InitJedis();
            System.out.println("初始化缓存 redis:"+redis);
            InitSite();
            System.out.println("初始化站点");
            InitLicense();
            //System.out.println("license init end");
            InitChannel();
            System.out.println("初始化频道");
            InitUsers();
            System.out.println("初始化用户");
            InitTideApi();
            System.out.println("初始化接口");
            InitPublishScheme();
            System.out.println("初始化发布方案");
            InitTemplate();
            System.out.println("初始化模板");
            InitTemplateGroup();
            System.out.println("初始化模板组");
            PublishManager.getInstance().StartFilePublishAgent();
            System.out.println("启动文件分发引擎");
            PublishManager.getInstance().StartTemplatePublishAgent();
            System.out.println("启动模板发布引擎");
            InitCompany();
            System.out.println("初始化租户");

            if (getConfig().getActive().equals("1")) {
                InitQuartz();
                System.out.println("初始化调度完成");
                StartSpiderAgent();
                System.out.println("启动采集引擎完成");
            }

            checkUpdate();
            System.out.println(getConfig().getProduct() + " 9.0 启动完成，授权用户：" + getCompany() + ",用时：" + (System.currentTimeMillis() - beginTime) + "秒");
            //InitConfig();
            //System.out.println("time1:"+(System.currentTimeMillis()-beginTime)+"秒");
        } catch (Exception e1) {
            System.out.println("启动发生错误:"+e1.getMessage());
            e1.printStackTrace();
            e1.printStackTrace(System.out);
        }
    }

    public CmsCache() {

    }


    public static void InitJedis() throws MessageException, SQLException {
        int active = 0;
        int idle = 0;
        long wait = 0;
        String server = "";
        int port = 6379;
        String r = getParameterValue("redis");
        String password = "";
        Set<String> sentinels = new HashSet<>();
        String[] node = {};
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
                port = o.getInt("port");
                password = o.getString("password");
                if (!o.getString("nodes").equals("")) {
                    node = o.getString("nodes").split(",");
                }
                db = o.getInt("db");
                MASTER_NAME = o.getString("mastername");
                for (String oneNode : node) {
                    sentinels.add(oneNode);
                }

            } catch (JSONException e) {
                e.printStackTrace();
                e.printStackTrace(System.out);
            }
        }
        if (!redis) return;
        System.out.println("jedis init");
        GenericObjectPoolConfig config = new GenericObjectPoolConfig();
        if (active < 1000) active = 1000;
        if (idle < 500) idle = 500;
        if (wait < 1000) wait = 1000;
        System.out.println("active:" + active + ",idle:" + idle + ",wait:" + wait + ",server:" + server + ",password：" + password);
        config.setMaxTotal(active);
        config.setMaxIdle(idle);
        config.setMaxWaitMillis(wait);
        config.setTestOnBorrow(true);
        config.setTestOnReturn(true);
        System.out.println(node.length + "--node节点数量");
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

    public static Parameter getParameter(String code) throws MessageException, SQLException {
        if (redis) {
            String key = "tidecms_parameter_" + code;
            byte[] obj = RedisGet(key);
            if (obj == null) {
                Parameter p = new Parameter(code);
                byte[] s = SerializeUtil.serialize(p);
                RedisSet(key, s, 0);
                return p;
            } else {
                return (Parameter) SerializeUtil.unserialize(obj);
            }
        } else {
            Parameter p = (Parameter) parameters.get(code);
            if (p == null) {
                p = new Parameter(code);
                parameters.put(p.getCode(), p);
            }

            return p;
        }
    }


    private static void InitChannel() throws MessageException, SQLException {
        String Sql = "";

        if (getConfig().getChannelCache().equals("true"))
            Sql = "select * from channel where Parent=-1 or Parent in(select id from channel where Parent=-1)";
        else if (getConfig().getChannelCache().equals("all"))
            Sql = "select * from channel where Type=0 or Type=1 or Type=2";
        else return;

        TableUtil tu = new TableUtil();
        channels.clear();

        Channel ch = new Channel(-1);
        if (redis) {
            RedisSet("tidecms_channel_" + (-1), SerializeUtil.serialize(ch), 0);
        } else
            channels.put(-1, ch);

        ResultSet Rs = tu.executeQuery(Sql);
        while (Rs.next()) {
            int id = Rs.getInt("id");
            //System.out.println("channnelid:"+id);
            Channel channel = new Channel(id);

            if (channel.isRootChannel())
                id = 0;

            if (redis) {
                RedisSet("tidecms_channel_" + id, SerializeUtil.serialize(channel), 0);
            } else
                channels.put(id, channel);
        }

        tu.closeRs(Rs);
    }
    private static void InitCompany() throws MessageException, SQLException {
        String Sql = "select * from company ";
        TableUtil tu_user = new TableUtil("user");
        companys.clear();
        ResultSet Rs = tu_user.executeQuery(Sql);
        while (Rs.next()) {
            int id = Rs.getInt("id");
            //System.out.println("channnelid:"+id);
            Company company = new Company(id);
            if (redis) {
                RedisSet("tidecms_company_" + id, SerializeUtil.serialize(company), 0);
            } else
                companys.put(id, company);
        }

        tu_user.closeRs(Rs);
    }
    public static Company getCompany(int companyid) throws MessageException {
        if (!hasValidLicense()) {
            throw new MessageException("invalid license", MessageException.INVALID_LICENSE);
        }

        if (redis) {
            String key = "tidecms_company_" + companyid;
            byte[] obj = RedisGet(key);
            if (obj == null) {
                Company company = null;
                try {
                    company = new Company(companyid);
                } catch (Exception e) {
                    e.printStackTrace(System.out);
                    return null;
                }
                byte[] s = SerializeUtil.serialize(company);
                RedisSet(key, s, 0);
                return company;
            } else {
                return (Company) SerializeUtil.unserialize(obj);
            }
        } else {
            Company company = (Company) companys.get(companyid);
            if (company == null) {//System.out.println("put:"+channelid);
                try {
                    company = new Company(companyid);
                } catch (Exception e) {
                    e.printStackTrace(System.out);
                    return null;
                }
                companys.put(companyid, company);
            }
            return company;
        }
    }

    public static void delCompany(int companyid) {
        if (redis) {
            try {
                Company company = getCompany(companyid);
                if (company != null) {
                    String key = "tidecms_company_" + companyid;
                    RedisDel(key);
                }
            } catch (MessageException e) {
                e.printStackTrace(System.out);
            }
        } else {
            companys.remove(companyid);//System.out.println(id);
            //System.out.println(channel.getParent());

        }
    }
    public static Channel getChannel(int channelid) throws MessageException {
        if (!hasValidLicense()) {
            throw new MessageException("invalid license", MessageException.INVALID_LICENSE);
        }

        if (redis) {
            String key = "tidecms_chennel_" + channelid;
            byte[] obj = RedisGet(key);
            if (obj == null) {
                Channel channel = null;
                try {
                    channel = new Channel(channelid);
                } catch (Exception e) {
                    e.printStackTrace(System.out);
                    return null;
                }
                byte[] s = SerializeUtil.serialize(channel);
                RedisSet(key, s, 0);
                return channel;
            } else {
                return (Channel) SerializeUtil.unserialize(obj);
            }
        } else {
            Channel channel = (Channel) channels.get(channelid);
            if (channel == null) {//System.out.println("put:"+channelid);
                try {
                    channel = new Channel(channelid);
                } catch (Exception e) {
                    e.printStackTrace(System.out);
                    return null;
                }
                channels.put(channelid, channel);
            }
            return channel;
        }

/*		if(ehcache)
		{
			String key = "getchannel_" + Util.getCurrentDate("yyyy_MM_dd_HH");
			CacheUtil.increment(key);
		}

		return channel;*/
    }

    public static Channel getChannel2(int channelid) throws MessageException, SQLException {
        Channel channel = null;
        if (redis) {
            String key = "tidecms_chennel_" + channelid;
            byte[] obj = RedisGet(key);
            if (obj == null) {
                try {
                    channel = new Channel(channelid);
                } catch (Exception e) {
                    e.printStackTrace(System.out);
                    return null;
                }
                byte[] s = SerializeUtil.serialize(channel);
                RedisSet(key, s, 0);
                return channel;
            } else {
                return (Channel) SerializeUtil.unserialize(obj);
            }
        } else {
            channel = (Channel) channels.get(channelid);
            if (channel == null) {
                channel = new Channel(channelid);
                channels.put(channelid, channel);
            }
        }
        return channel;
    }

    public static Channel getChannel(final String serialno) throws MessageException, SQLException {
        int channelid = 0;
        TableUtil tu = new TableUtil();

        String Sql = "select * from channel where SerialNo='" + serialno + "'";

        ResultSet Rs = tu.executeQuery(Sql);
        while (Rs.next()) {
            channelid = Rs.getInt("id");
        }

        tu.closeRs(Rs);

        if (channelid != 0)
            return getChannel(channelid);
        else
            return null;
    }

    public static void delChannel(int id) {
        if (redis) {
            try {
                Channel channel = getChannel(id);
                if (channel != null) {
                    String key = "tidecms_chennel_" + id;
                    RedisDel(key);
                    key = "tidecms_chennel_" + channel.getParent();
                    RedisDel(key);
                }
            } catch (MessageException e) {
                e.printStackTrace(System.out);
            }
        } else {
            Channel channel = (Channel) channels.get(id);
            channels.remove(id);//System.out.println(id);
            //System.out.println(channel.getParent());
            if (cacheapi.length() > 0) {
                Util.connectHttpUrl(cacheapi + "?id=" + id + "&type=channel");
            }
            if (channel != null) channels.remove(channel.getParent());
        }
    }


    /**
     * 根据itemid和channelid获取Document对象
     *
     * @param itemid
     * @param channelid
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static Document getDocument(int itemid, int channelid) throws SQLException, MessageException {
        if (redis) {
            Jedis jedis;
            if (isSentinelPool) {
                jedis = jspool.getResource();
            } else {
                jedis = pool.getResource();
            }
            jedis.select(db);//切换分组
            String key = "tidecms_item_" + itemid + "_" + channelid;
            byte[] document = jedis.get((key).getBytes());
            if (document == null) {
                Document doc = new Document(itemid, channelid);
                byte[] s = SerializeUtil.serialize(doc);
                jedis.set(key.getBytes(), s);
                jedis.expire(key.getBytes(), 864000);//10天过期
//                if (!isSentinelPool && !isCluster) pool.returnResource(jedis);
                if (jedis != null) {
                    jedis.close();
                }
                return doc;
            } else {
//                if (!isSentinelPool && !isCluster) pool.returnResource(jedis);
                if (jedis != null) {
                    jedis.close();
                }
                return (Document) SerializeUtil.unserialize(document);
            }
        } else {
            return new Document(itemid, channelid);
        }
    }

    public static Document getDocument(int globalid) throws SQLException, MessageException {
        if (redis) {
            Jedis jedis;
            if (isSentinelPool) {
                jedis = jspool.getResource();
            } else {
                jedis = pool.getResource();
            }
            jedis.select(db);//切换分组
            String key = "tidecms_item_" + globalid;
            byte[] document = jedis.get((key).getBytes());
            if (document == null) {
                Document doc = new Document(globalid);
                byte[] s = SerializeUtil.serialize(doc);
                jedis.set(key.getBytes(), s);
                jedis.expire(key.getBytes(), 864000);//10天过期
//                if (!isSentinelPool && !isCluster) pool.returnResource(jedis);
                if (jedis != null) {
                    jedis.close();
                }
                return doc;
            } else {
//                if (!isSentinelPool && !isCluster) pool.returnResource(jedis);
                if (jedis != null) {
                    jedis.close();
                }
                return (Document) SerializeUtil.unserialize(document);
            }
        } else {
            return new Document(globalid);
        }
    }

    public static void delDocument(int itemid, int channelid) {
        if (redis) {
            Jedis jedis;
            if (isSentinelPool) {
                jedis = jspool.getResource();
            } else {
                jedis = pool.getResource();
            }
            jedis.select(db);//切换分组
            String key = "tidecms_item_" + itemid + "_" + channelid;
            jedis.del(key.getBytes());
//            if (!isSentinelPool && !isCluster) pool.returnResource(jedis);
            if (jedis != null) {
                jedis.close();
            }
        }
    }

    public static void delDocument(int globalid) {
        if (redis) {
            Jedis jedis;
            if (isSentinelPool) {
                jedis = jspool.getResource();
            } else {
                jedis = pool.getResource();
            }
            jedis.select(db);//切换分组
            String key = "tidecms_item_" + globalid;
            jedis.del(key.getBytes());
//            if (!isSentinelPool && !isCluster) pool.returnResource(jedis);
            if (jedis != null) {
                jedis.close();
            }
        }
    }

    private static void InitUsers() throws MessageException, SQLException {
            TableUtil tu = new TableUtil("user");
            users.clear();

            String Sql = "select * from userinfo";
            ResultSet Rs = tu.executeQuery(Sql);
            while (Rs.next()) {
                int id = Rs.getInt("id");
                UserInfo user = new UserInfo(id);
                if (redis) {
                    RedisSet("tidecms_user_" + id, SerializeUtil.serialize(user), 0);
                } else {
                    users.put(id, user);
                }
            }

            tu.closeRs(Rs);
    }

    public static UserInfo getUser(int userid) throws MessageException, SQLException {
        UserInfo user = null;
        if (redis) {
            String key = "tidecms_user_" + userid;
            byte[] obj = RedisGet(key);
            if (obj == null) {
                user = new UserInfo(userid);
                byte[] s = SerializeUtil.serialize(user);
                RedisSet(key, s, 0);
            } else {
                user = (UserInfo) SerializeUtil.unserialize(obj);
            }
        } else {
            user = (UserInfo) users.get(userid);
            if (user == null) {
                user = new UserInfo(userid);
                users.put(userid, user);
            }
        }
        //if(user.getId()!=userid) System.out.println("error:"+user.getId()+",userid:"+userid);
        return user;
    }

    public static void delUser(int userid) {
        if (redis) {
            RedisDel("tidecms_user_" + userid);
        } else {
            users.remove(userid);//System.out.println(id);
            if (cacheapi.length() > 0) {
                Util.connectHttpUrl(cacheapi + "?id=" + userid + "&type=user");
            }
        }
    }


    public static void InitPublishScheme() throws MessageException, SQLException {
        //Init();
        //System.out.println("user cache init");
/*		TableUtil tu = new TableUtil();
		publish_schemes.clear();

		String Sql = "";
		Sql = "select * from publish_scheme where Status=1 Order by CopyMode desc";

		ResultSet Rs = tu.executeQuery(Sql);
		while(Rs.next())
		{
			int id = Rs.getInt("id");
			//System.out.println(id);
			PublishScheme ps = new PublishScheme(id);

			publish_schemes.put(id,ps);
		}

		tu.closeRs(Rs);*/
    }

    public static PublishScheme getPublishScheme(int id) throws MessageException, SQLException {
        PublishScheme ps = null;
        if (redis) {
            String key = "tidecms_publishscheme_" + id;
            byte[] obj = RedisGet(key);
            if (obj == null) {
                ps = new PublishScheme(id);
                byte[] s = SerializeUtil.serialize(ps);
                RedisSet(key, s, 0);
            } else {
                ps = (PublishScheme) SerializeUtil.unserialize(obj);
            }
        } else {
            ps = (PublishScheme) publish_schemes.get(id);
            if (ps == null) {
                ps = new PublishScheme(id);
                publish_schemes.put(id, ps);
            }
        }

        return ps;
    }

    public static void delPublishScheme(int id) {
        if (redis) {
            RedisDel("tidecms_publishscheme_" + id);
        } else {
            publish_schemes.remove(id);//System.out.println(id);
        }
    }

    private static void InitSite() throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        sites.clear();

        String Sql = "";
        Sql = "select * from site";

        ResultSet Rs = tu.executeQuery(Sql);
        while (Rs.next()) {
            int id = Rs.getInt("id");//System.out.println("siteid:"+id);
            Site site = new Site(id);
            if (site.getType() == 1) {
                defaultsite = site;
            }

            if (redis) {
                RedisSet("tidecms_site_" + id, SerializeUtil.serialize(site), 0);
            } else {
                sites.put(id, site);
            }
        }

        tu.closeRs(Rs);
    }

    public static Site getSite(int siteid) throws MessageException, SQLException {
        Site site = null;

        if (redis) {
            String key = "tidecms_site_" + siteid;
            byte[] obj = RedisGet(key);
            if (obj == null) {
                site = new Site(siteid);
                byte[] s = SerializeUtil.serialize(site);
                RedisSet(key, s, 0);
            } else {
                site = (Site) SerializeUtil.unserialize(obj);
            }
        } else {
            site = (Site) sites.get(siteid);
            if (site == null) {
                site = new Site(siteid);
                sites.put(siteid, site);
            }
        }

        return site;
    }

    public static void delSite(int id) {
        if (redis) {
            RedisDel("tidecms_site_" + id);
        } else {
            sites.remove(id);//System.out.println(id);
            if (cacheapi.length() > 0) {
                Util.connectHttpUrl(cacheapi + "?id=" + id + "&type=site");
            }
        }
    }

    public static Site getDefaultSite() throws MessageException, SQLException {
        return defaultsite;
    }

	/*
	private static void InitConfig() throws NamingException{
	    Context initctx=new InitialContext();
        Context envCtx=(Context) initctx.lookup("java:comp/env");//在webshere下面需要去掉
        config=(Config)envCtx.lookup("bean/Config");
	 	//System.out.println(config.getDatabase());

	 	if(config.getDatabase().equalsIgnoreCase("oracle"))
	 	{
	 		setOracle(true);
	 		setMysql(false);
	 		setDataSource((DataSource)envCtx.lookup("jdbc/myoracle"));
	 	}
	 	else if(config.getDatabase().equalsIgnoreCase("mysql"))
	 	{
	 		setOracle(false);
	 		setMysql(true);
	 		setDataSource((DataSource)envCtx.lookup("jdbc/mysql"));
	 	}
	 	cacheapi = config.getCacheapi();
	}*/

	/*
	public static boolean isOracle() {
		return isOracle;
	}

	public static void setOracle(boolean isOracle) {
		CmsCache.isOracle = isOracle;
	}

	public static boolean isMysql() {
		return isMysql;
	}

	public static void setMysql(boolean isMysql) {
		CmsCache.isMysql = isMysql;
	}*/

    public static void setTideapis(ArrayList<TideApi> tideapis) {
        CmsCache.tideapis = tideapis;
    }

    public static ArrayList<TideApi> getTideapis() {
        return tideapis;
    }

    public static void InitTideApi() throws MessageException, SQLException {
        //System.out.println("init tide api");
        tideapis.clear();
        int templateid = 0;
        TableUtil tu = new TableUtil();

        String Sql = "select * from template_files where FileName='tidemedia_api.xml'";

        ResultSet Rs = tu.executeQuery(Sql);
        while (Rs.next()) {
            templateid = Rs.getInt("id");
        }

        tu.closeRs(Rs);

        if (templateid == 0) return;
        //System.out.println("templateid:"+templateid);
        TemplateFile tf = CmsCache.getTemplate(templateid);
        StringReader strInStream = new StringReader(tf.getContent());

        SAXReader reader = new SAXReader();
        org.dom4j.Document doc;
        try {
            doc = reader.read(strInStream);
            Element root = doc.getRootElement();
            Element foo;
            for (Iterator<Element> i = root.elementIterator("Api"); i.hasNext(); ) {
                foo = (Element) i.next();

                String name = foo.elementText("Name");
                String channelid = foo.elementText("ChannelID");
                String channelcode = Util.convertNull(foo.elementText("ChannelCode"));
                String url = foo.elementText("Url");
                String method = foo.elementText("Method");
                String action = foo.elementText("Action");
                String template = foo.elementText("Template");
                String status = foo.elementText("Status");
                //System.out.println("api name:"+name);
                TideApi api = new TideApi();
                api.setName(name);
                api.setChannelID(channelid);
                api.setChannelCode(channelcode);
                //System.out.println(channelcode);
				/*
				if(channelcode.endsWith("*"))
				{
					api.setPrefixChannelCode(true);
					api.setChannelCode(channelcode.replace("*", ""));
				}
				*/
                api.setUrl(url);
                api.setMethod(method);
                api.setAction(action);
                api.setTemplate(template);

                for (Iterator<Element> j = foo.elementIterator("Field"); j.hasNext(); ) {
                    Element fooo = (Element) j.next();

                    String n = fooo.elementText("Name");
                    String v = fooo.elementText("Value");
                    String t = fooo.elementText("ValueType");
                    //System.out.println("n:"+n);
                    api.addField(new String[]{n, v, t});
                }

                if (status != null && status.equals("1")) {
                    tideapis.add(api);
                }
            }
        } catch (Exception e) {
            System.out.println("模板接口XML定义问题：" + e.getMessage());
        }
    }


    public static Site getDefaultsite() {
        return defaultsite;
    }

    public static void setDefaultsite(Site defaultsite) {
        CmsCache.defaultsite = defaultsite;
    }

    public static void InitTemplate() throws MessageException, SQLException {
/*		TableUtil tu = new TableUtil();
		templatefiles.clear();
		ResultSet Rs = tu.executeQuery("select * from template_files");
		while(Rs.next())
		{
			int id = Rs.getInt("id");
			TemplateFile tf = new TemplateFile(id);
			templatefiles.put(id,tf);
		}
		tu.closeRs(Rs);*/
    }

    public static TemplateFile getTemplate(int id) throws MessageException, SQLException {
        TemplateFile tf = (TemplateFile) templatefiles.get(id);
        if (tf == null) {
            tf = new TemplateFile(id);
            templatefiles.put(id, tf);
        }

        return tf;
    }

    public static void delTemplate(int id) {
        templatefiles.remove(id);//System.out.println(id);
        if (cacheapi.length() > 0) {
            Util.connectHttpUrl(cacheapi + "?id=" + id + "&type=template");
        }
    }

    public static void InitTemplateGroup() throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        templategroups.clear();
        ResultSet Rs = tu.executeQuery("select * from template_group");
        while (Rs.next()) {
            int id = Rs.getInt("id");
            TemplateGroup tg = new TemplateGroup(id);
            templategroups.put(id, tg);
        }
        tu.closeRs(Rs);
    }


    public static String getParameterValue(String code) throws MessageException, SQLException {
        Parameter p = (Parameter) parameters.get(code);
        if (p == null) {
            p = new Parameter(code);
            parameters.put(p.getCode(), p);
        }

        return p.getContent();
    }

    public static void delParameter(String code) {

        if (redis) {
            RedisDel("tidecms_parameter_" + code);
        } else {
            parameters.remove(code);
        }
        //System.out.println(id);
    }

    public static void InitParameters() throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        parameters.clear();
        ResultSet Rs = tu.executeQuery("select * from parameter");
        while (Rs.next()) {
            int id = Rs.getInt("id");
            Parameter p = new Parameter(id);
            parameters.put(p.getCode(), p);
        }
        tu.closeRs(Rs);
    }

    public static TemplateGroup getTemplateGroup(int id) throws MessageException, SQLException {
        TemplateGroup tg = (TemplateGroup) templategroups.get(id);
        if (tg == null) {
            tg = new TemplateGroup(id);
            templategroups.put(id, tg);
        }

        return tg;
    }

    public static void delTemplateGroup(int id) {
        templategroups.remove(id);//System.out.println(id);
    }

    public static void InitApprove() throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        approveschemes.clear();
        ResultSet Rs = tu.executeQuery("select * from approve_scheme");
        while (Rs.next()) {
            int id = Rs.getInt("id");
            ApproveScheme as = new ApproveScheme(id);
            approveschemes.put(id, as);
        }
        tu.closeRs(Rs);
    }

    public static ApproveScheme getApprove(int id) throws MessageException, SQLException {
        ApproveScheme as = (ApproveScheme) approveschemes.get(id);
        if (as == null) {
            as = new ApproveScheme(id);
            approveschemes.put(id, as);
        }

        return as;
    }

    public static void delApprove(int id) {
        approveschemes.remove(id);//System.out.println(id);
    }

    public static void InitQuartz() throws MessageException, SQLException {
        if (getConfig().getStartQuartz().equals("false")) return;
        TableUtil tu = new TableUtil();
        String sql = "select * from quartz_manager where status=1";
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()) {
            int qid = rs.getInt("id");
            try {
                new QuartzUtil().startJob(qid);
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
        }
        tu.closeRs(rs);

        //System.out.println("p:"+config.getProduct());
		/*
		if(getConfig().getProduct().equals("TideCMS"))
		{
			sql = "select * from spider where status=1";
			rs = tu.executeQuery(sql);
			while(rs.next())
			{
				int id = rs.getInt("id");
				int period = rs.getInt("Period");
				try {Spider.startJob(id, period);}
				catch (Exception e) {e.printStackTrace(System.out);}
			}
			tu.closeRs(rs);
		}*/
    }

    //检查更新
    public static void checkUpdate() {
        Scheduler sched;
        try {
            sched = QuartzUtil.getScheduler();
            JobDetail job = newJob(UpdateUtil.class).withIdentity("job_checkupdate", "group_tidecms").build();

            int hour = new java.util.Random().nextInt(4) + 1;
            int minute = new java.util.Random().nextInt(50) + 1;
            String cron = " 0 " + minute + " " + hour + " ? * *";//每天凌晨几点几分执行一次 0 15 10 ? * *	Fire at 10:15am every day
            CronTrigger trigger = newTrigger().withIdentity("trigger_checkupdate", "group_tidecms")
                    //.withSchedule(cronSchedule("0 0 "+(random+1)+" ? * L")) //每周星期天凌晨1点执行一次
                    .withSchedule(cronSchedule(cron))
                    .build();

            sched.scheduleJob(job, trigger);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public static void StartSpiderAgent() {
        if (spider_agent != null) {
            spider_agent.getRunner().stop();
        }
        spider_agent = null;
        spider_agent = new SpiderAgent();
        spider_agent.Start();
    }

    public static ConcurrentHashMap<Integer, Channel> getChannels() {
        return channels;
    }

    public static ConcurrentHashMap<Integer, UserInfo> getUsers() {
        return users;
    }

    public static ConcurrentHashMap<Integer, TemplateFile> getTemplatefiles() {
        return templatefiles;
    }

    public static ConcurrentHashMap<Integer, ApproveScheme> getApproveschemes() {
        return approveschemes;
    }

    public static ConcurrentHashMap<Integer, Site> getSites() {
        return sites;
    }

    public static JedisPool getJedisPool() {
        return pool;
    }

    public static void RedisSet(String key, byte[] obj, int expire) {

        if (!redis) return;
        Jedis jedis;
        if (isSentinelPool) {
            jedis = jspool.getResource();
        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        jedis.set(key.getBytes(), obj);
        if (expire > 0) jedis.expire(key.getBytes(), expire);
        //if (!isSentinelPool && !isCluster) pool.returnResource(jedis);
        if (jedis != null) {
            jedis.close();
        }

    }

    public static byte[] RedisGet(String key) {
        if (!redis) return null;
        Jedis jedis;
        if (isSentinelPool) {
            jedis = jspool.getResource();
        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        byte[] obj = jedis.get((key).getBytes());
//        if (!isSentinelPool && !isCluster) pool.returnResource(jedis);
        if (jedis != null) {
            jedis.close();
        }
        return obj;
    }

    public static void RedisDel(String key) {
        Jedis jedis;
        if (isSentinelPool) {
            jedis = jspool.getResource();

        } else {
            jedis = pool.getResource();
        }
        jedis.select(db);//切换分组
        jedis.del(key.getBytes());
//        if (!isSentinelPool && !isCluster) pool.returnResource(jedis);
        if (jedis != null) {
            jedis.close();
        }
    }

}
