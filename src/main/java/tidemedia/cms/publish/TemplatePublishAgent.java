/*
 * Created on 2004-12-26
 *
 * Window - Preferences - Java - Code Style - Code Templates
 */
package tidemedia.cms.publish;

import com.alibaba.fastjson.JSON;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.exceptions.JedisConnectionException;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.RedisUtil;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.util.Util;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;


/**
 * @author Administrator
 */
public class TemplatePublishAgent implements Runnable {

    private Thread runner;
    //private long  	NoTask_BeginTime = 0;//没有发布任务开始的时间，如果没有任务超过10分钟，则结束PublishAgent运行
    private int SleepTime;//线程睡眠周期
    private int number = 1;//线程编号
    private Publish publish = null;
    private static int max_thread_number = 1;//最大模板发布线程数量
    private static AtomicInteger publishing_thread_number = new AtomicInteger(0);
    ;//正在使用的模板发布线程数量
    private static String message = "";//进程信息


    private Jedis jedis = null;

    public void init() throws MessageException, SQLException {
        if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis才使用此种方式初始化
            if (RedisUtil.getInstance().isSentinelPool) {
                System.out.println("模板发布用的是哨兵源");
                jedis = RedisUtil.getInstance().getSentinelspool().getResource();
                jedis.select(RedisUtil.getInstance().db);
            } else {
                System.out.println("模板发布用的是普通源");
                jedis = RedisUtil.getInstance().getJedisPool().getResource();
                jedis.select(RedisUtil.getInstance().db);
            }
        }
    }

    public TemplatePublishAgent() throws MessageException, SQLException {
        init();
    }

    public TemplatePublishAgent(int number, int time) {
        this.number = number;
        this.SleepTime = time;
    }

    public void Start() {
        //主系统才开启线程 20160608
        if (!CmsCache.getConfig().getActive().equals("1")) {
            message = Util.getCurrentDate("MM-dd HH:mm:ss") + " active为0，引擎关闭";
            return;
        }

        message = Util.getCurrentDate("MM-dd HH:mm:ss") + " 引擎启动";

        if (runner == null) {
            runner = new Thread(this);
            runner.start();
        }
    }

    /**
     * 批量将模板发布任务从队列中移除（主要防止模板重复发布）
     * @throws MessageException
     * @throws SQLException
     */
    public void DelChannelTemplateRedisQueue(int ChannelID,int ChannelTemplateID) throws MessageException, SQLException {

        TableUtil tu = new TableUtil();
        String Sql = "select * from publish_task  where Status=0 and ChannelID=" + ChannelID + " and ChannelTemplateID=" + ChannelTemplateID ;
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
            RedisUtil.getInstance().MessageDel(ItemBean);   //从队列中将模板发布任务删除
        }

    }

    /**
     * 数据库遍历队列方式
     */
    public void SQLQueue(){
        try {

            while(true) {
                //0待发布
                //1 已经发布
                //2 正在发布
                //3 发布失败
                //System.out.println("max_publish_thread_number:"+max_thread_number+",publishing_thread_number:"+publishing_thread_number);

                try{
                    max_thread_number = CmsCache.getParameter("template_publish_thread_number").getIntValue();
                    int num = max_thread_number-publishing_thread_number.get();
                    message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 可用线程数量:"+num;
                    if(num>0)
                    {
                        //还有可用的发布线程
                        String Sql = "select * from publish_task where Status=0 and UNIX_TIMESTAMP()>=CanPublishTime order by id limit " + num ;
                        //System.out.println(Sql);
                        TableUtil tu;
                        tu = new TableUtil();
                        TableUtil tu1 = new TableUtil();
                        ResultSet Rs = tu.executeQuery(Sql);

                        while(Rs.next())
                        {
                            int id_ = Rs.getInt("id");
                            int channelid 			= Rs.getInt("ChannelID");
                            int publishtype = Rs.getInt("PublishType");
                            int ChannelTemplateID = Rs.getInt("ChannelTemplateID");
                            long PublishBegin = System.currentTimeMillis();

                            message = Util.getCurrentDate("MM-dd HH:mm:ss")+" id:"+id_+",channelid:"+channelid;
                            //频道发布
                            if(publishtype== Publish.CHANNEL_PUBLISH)
                            {
                                tu1.executeUpdate("update publish_task set Status=2,Message=concat(Message,'开始发布\r\n'),PublishBegin="+PublishBegin+" where Status=0 and ChannelID="+channelid+" and ChannelTemplateID="+ChannelTemplateID);
                            }
                            else
                            {
                                tu1.executeUpdate("update publish_task set Status=2,Message=concat(Message,'开始发布\r\n'),PublishBegin="+PublishBegin+" where id="+id_);
                            }


                            System.out.println("begin publish task "+id_);
                            publishing_thread_number.incrementAndGet();
                            Publish2015 p = new Publish2015();
                            //publishing_thread.add(p);
                            p.setPublish_task_id(id_);
                            p.Start();

                            message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 正在发布线程数量:"+publishing_thread_number;
                            //System.out.println("begin publish item:"+id_+",publishing_thread_number:"+publishing_thread_number);
                        }
                        tu.closeRs(Rs);
                    }

                    message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 线程休眠";
                    Thread.sleep(500);// 休眠500毫秒
                }catch (SQLException e) {
                    message = message+","+ Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
                    ErrorLog.SaveErrorLog("模板发布进程错误","",0,e);
                    e.printStackTrace(System.out);
                }
            }

        } catch (MessageException e) {
            message = message+","+ Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
            ErrorLog.SaveErrorLog("模板发布进程错误","",0,e);
            e.printStackTrace(System.out);
        } catch (InterruptedException e) {
            message = message+","+ Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
            ErrorLog.SaveErrorLog("模板发布进程错误","",0,e);
            e.printStackTrace(System.out);
        }
        message = message+","+ Util.getCurrentDate("MM-dd HH:mm:ss")+" 进程结束";
    }

    /**
     * Redis队列遍历方式
     */
    public void RedisQueue(){
        try {

            while (true) {
                //0待发布
                //1 已经发布
                //2 正在发布
                //3 发布失败
                //System.out.println("max_publish_thread_number:"+max_thread_number+",publishing_thread_number:"+publishing_thread_number);

                try {
                    max_thread_number = CmsCache.getParameter("template_publish_thread_number").getIntValue();
                    int num = max_thread_number - publishing_thread_number.get();
                    message = Util.getCurrentDate("MM-dd HH:mm:ss") + " 可用线程数量:" + num;
                    if (num > 0) {
                        List<String> brpop = jedis.brpop(0, RedisUtil.PUBLISH_TEMPLATE_MESSAGE_KEY);// 0是timeout,返回的是一个集合，第一个是消息的key，第二个是消息的内容
                        if (brpop.size() != 0) {
                            String key = brpop.get(0);//Key
                            String TextJson = brpop.get(1); //Value
                            if (TextJson.equals("")) {//如果为空  则跳出
                                continue;
                            }
                            PublishTaskMessageBean resulObject = JSON.parseObject(TextJson, PublishTaskMessageBean.class);//序列化转换为对象


                            int id_ = resulObject.getTaskID();
                            int channelid = resulObject.getChannelID();
                            int publishtype = resulObject.getPublishType();
                            int ChannelTemplateID = resulObject.getChannelTemplateID();
                            long PublishBegin = System.currentTimeMillis();
                            message = Util.getCurrentDate("MM-dd HH:mm:ss") + " id:" + id_ + ",channelid:" + channelid;
                            //频道发布
                            if (publishtype == Publish.CHANNEL_PUBLISH) {
                                DelChannelTemplateRedisQueue(channelid,ChannelTemplateID);//将重复发布的模板从队列中清理掉
                                new TableUtil().executeUpdate("update publish_task set Status=2,Message=concat(Message,'开始发布\r\n'),PublishBegin=" + PublishBegin + " where Status=0 and ChannelID=" + channelid + " and ChannelTemplateID=" + ChannelTemplateID);
                            } else {
                                new TableUtil().executeUpdate("update publish_task set Status=2,Message=concat(Message,'开始发布\r\n'),PublishBegin=" + PublishBegin + " where id=" + id_);
                            }


                            System.out.println("begin publish task " + id_);
                            publishing_thread_number.incrementAndGet();
                            Publish2015 p = new Publish2015();
                            p.setPublish_task_id(id_);
                            p.Start();

                            message = Util.getCurrentDate("MM-dd HH:mm:ss") + " 正在发布线程数量:" + publishing_thread_number;
                            //System.out.println("begin publish item:"+id_+",publishing_thread_number:"+publishing_thread_number);
                        }


                    }

                    message = Util.getCurrentDate("MM-dd HH:mm:ss") + " 线程休眠";
                    //Thread.sleep(500);// 休眠500毫秒
                } catch (SQLException e) {
                    message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss") + " 错误：" + e.getMessage();
                    ErrorLog.SaveErrorLog("模板发布进程错误", "", 0, e);
                    e.printStackTrace(System.out);
                }catch(JedisConnectionException e){//Redis异常，此处怀疑是多线程访问同一连接池导致，此处设置了重置机制
                    PublishManager.getInstance().StartTemplatePublishAgent();
                    TemplatePublishAgent.clearPublishingNumber();
                    if(RedisUtil.getInstance().isRedis()){//开启Redis
                        RedisUtil.getInstance().ResetQueue(2);//重置全部模板发布任务
                    }
                    //正在发布线程归0
                }
            }

        } catch (MessageException | SQLException e) {
            message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss") + " 错误：" + e.getMessage();
            ErrorLog.SaveErrorLog("模板发布进程错误", "", 0, e);
            e.printStackTrace(System.out);
        }
        message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss") + " 进程结束";
    }
    public void run() {
        try {
            if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis才使用此种队列
                RedisQueue();
            }else{
                SQLQueue();
            }
        } catch (MessageException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static synchronized void PublishDone() {
        publishing_thread_number.decrementAndGet();
        if (publishing_thread_number.get() < 0) {
            System.out.println("有错误发生，publishing_thread_number为负数");
            publishing_thread_number.set(0);
        }
        System.out.println("down publish item publishing_thread_number:" + publishing_thread_number);
    }


    public static void clearPublishingNumber() {
        publishing_thread_number.set(0);
    }

    /**
     * @return Returns the runner.
     */
    public Thread getRunner() {
        return runner;
    }

    /**
     * @param runner The runner to set.
     */
    public void setRunner(Thread runner) {
        this.runner = runner;
    }

    /**
     * @return Returns the sleepTime.
     */
    public int getSleepTime() {
        return SleepTime;
    }

    /**
     * @param sleepTime The sleepTime to set.
     */
    public void setSleepTime(int sleepTime) {
        SleepTime = sleepTime;
    }

    public String getPublishingFileName() {
        return publish.getPublishingFileName();
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public int getNumber() {
        return number;
    }

    public static int getMax_thread_number() {
        return max_thread_number;
    }

    public static int getPublishing_thread_number() {
        return publishing_thread_number.get();
    }

    public static String getMessage() {
        return message;
    }

    public static void setMessage(String message) {
        TemplatePublishAgent.message = message;
    }
}
