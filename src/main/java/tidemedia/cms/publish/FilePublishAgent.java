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
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author Administrator
 */
public class FilePublishAgent implements Runnable {

    private Thread runner;
    // private long NoTask_BeginTime =
    // 0;//没有发布任务开始的时间，如果没有任务超过10分钟，则结束PublishAgent运行
    private int SleepTime;// 线程睡眠周期
    private int number = 1;// 线程编号
    private static int max_thread_number = 1;// 最大文件发布线程数量
    //AtomicInteger 线程安全
    private static AtomicInteger copying_thread_number = new AtomicInteger(0);// 正在使用的模板发布线程数量
    private static String message = "";//进程信息

    //public static ArrayList<String> copying_files2_2016 = new ArrayList<String>();
    private static ConcurrentHashMap<String, String> copying_files2_2016 = new ConcurrentHashMap<String, String>();// 正在发布的文件，同一个发布方案要避免发布同一个文件


    private Jedis jedis = null;

    public void init() throws MessageException, SQLException {
        if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis才使用此种方式初始化
            if (RedisUtil.getInstance().isSentinelPool) {
                jedis = RedisUtil.getInstance().getSentinelspool().getResource();
                jedis.select(RedisUtil.getInstance().db);
            } else {
                jedis = RedisUtil.getInstance().getJedisPool().getResource();
                jedis.select(RedisUtil.getInstance().db);
            }
        }

    }

    public FilePublishAgent() throws MessageException, SQLException {
        init();
    }

    public FilePublishAgent(int number, int time) {
        this.number = number;
        this.SleepTime = time;
    }

    public void Start() {
        // 主系统才开启线程 20160608
        if (!CmsCache.getConfig().getActive().equals("1")) {
            message = Util.getCurrentDate("MM-dd HH:mm:ss") + " active为0，引擎关闭";
            return;
        }

        message = Util.getCurrentDate("MM-dd HH:mm:ss") + " 已经启动";

        if (runner == null) {
            runner = new Thread(this);
            runner.start();
        }
    }

    /**
     * 数据库遍历发布队列的方式
     */
    public void SQLQuery(){
        try {
            // 0 待发布
            // 1 已经发布
            // 3 正在发布
            // 4 发布失败
            while (true) {

                //如果发生数据库错误，继续执行
                try{
                    String last_file_name = "";
                    //System.out.println("max_copy_thread_number:" + max_thread_number + ",copying_thread_number:"	+ copying_thread_number);
                    max_thread_number = CmsCache.getParameter("file_publish_thread_number").getIntValue();
                    int num = max_thread_number - copying_thread_number.get();
                    message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 可用线程数量:"+num;

                    int num1 = 0;
                    int num2 = 0;

                    if (num > 0) {
                        // 还有可用的发布线程
                        //String Sql = "select * from publish_item where Status=0 and UNIX_TIMESTAMP()>=CanCopyTime order by id limit " + num;
                        String Sql = "select * from publish_item where Status=0 order by id limit " + num;
                        TableUtil tu = new TableUtil();
                        TableUtil tu1 = new TableUtil();
                        ResultSet Rs = tu.executeQuery(Sql);

                        HashMap<Integer, String> map = new HashMap();
                        while (Rs.next()) {
                            int id_ = Rs.getInt("id");
                            int publishscheme = Rs.getInt("PublishScheme");
                            String FileName = Util.ClearPath(tu.convertNull(Rs.getString("FileName")));
                            map.put(id_, publishscheme + "_" + FileName);
                        }
                        tu.closeRs(Rs);

                        Iterator iter = map.entrySet().iterator();
                        while (iter.hasNext()) {
                            Map.Entry entry = (Map.Entry) iter.next();
                            int id = (Integer)entry.getKey();
                            String filename = (String)entry.getValue();
                            last_file_name = filename;
                            message = Util.getCurrentDate("MM-dd HH:mm:ss")+" id:"+id+",FileName:"+filename;
                            if (!checkCopyingFile(filename)) {
                                num1++;
                                message = Util.getCurrentDate("MM-dd HH:mm:ss")+" id:"+id+",add FileName:"+filename;
                                copying_files2_2016.put(filename, Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));//加入正在发布的文件队列中
                                tu1.executeUpdate("update publish_item set Status=3,Message='开始发布' where id=" + id);
                                CopyFile2015 cf = new CopyFile2015();
                                cf.setPublish_item_id(id);
                                cf.Start();
                                copying_thread_number.incrementAndGet();
                                message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 正在分发文件线程数量:"+copying_thread_number;
                                System.out.println("begin file publish:" + id + ",copying_thread_number:" + copying_thread_number);
                            }
                            else
                            {
                                num2++;
                                message = Util.getCurrentDate("MM-dd HH:mm:ss")+" id:"+id+",FileName:"+filename+",已经在发布";
                            }
                        }
                    }
                    message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 线程休眠  本次"+num1+"个分发，"+num2+"个已经在发，最后一个："+last_file_name;
                    Thread.sleep(100);// 休眠500毫秒
                }catch (SQLException e) {
                    message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
                    ErrorLog.SaveErrorLog("文件发布进程错误", "", 0, e);
                    e.printStackTrace(System.out);
                }
            }

        } catch (MessageException e) {
            message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
            ErrorLog.SaveErrorLog("文件发布进程错误", "", 0, e);
            e.printStackTrace(System.out);
        }  catch (InterruptedException e) {
            message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
            ErrorLog.SaveErrorLog("文件发布进程错误", "", 0, e);
            e.printStackTrace(System.out);
        }
        message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 进程结束";
    }

    /**
     * Redis队列遍历方式
     */
    public void RedisQueue() throws SQLException {
        try {
            // 0 待发布
            // 1 已经发布
            // 3 正在发布
            // 4 发布失败
            while (true) {

                //如果发生数据库错误，继续执行
                try {
                    String last_file_name = "";
                    //System.out.println("max_copy_thread_number:" + max_thread_number + ",copying_thread_number:"	+ copying_thread_number);
                    max_thread_number = CmsCache.getParameter("file_publish_thread_number").getIntValue();
                    int num = max_thread_number - copying_thread_number.get();
                    message = Util.getCurrentDate("MM-dd HH:mm:ss") + " 可用线程数量:" + num;

                    int num1 = 0;
                    int num2 = 0;
                    if (num > 0) {
                        HashMap<Integer, String> map = new HashMap();
                        List<String> brpop = jedis.brpop(0, RedisUtil.PUBLISH_MESSAGE_KEY);//0是timeout,返回的是一个集合，第一个是消息的key，第二个是消息的内容
                        if (brpop.size() != 0) {
                            String key = brpop.get(0);//Key
                            String TextJson = brpop.get(1); //Value
                            if (TextJson.equals("")) {//如果为空  则跳出
                                continue;
                            }
                            PublishItem resulObject = JSON.parseObject(TextJson, PublishItem.class);//序列化转换为对象

                            int id_ = resulObject.getId();
                            int publishscheme = resulObject.getPublishscheme();
                            String FileName = Util.ClearPath(resulObject.getFileName());
                            map.put(id_, publishscheme + "_" + FileName);

                            String filename = publishscheme + "_" + FileName;
                            last_file_name = filename;
                            message = Util.getCurrentDate("MM-dd HH:mm:ss") + " id:" + id_ + ",FileName:" + filename;
                            if (!checkCopyingFile(filename)) {
                                num1++;
                                message = Util.getCurrentDate("MM-dd HH:mm:ss") + " id:" + id_ + ",add FileName:" + filename;
                                copying_files2_2016.put(filename, Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));//加入正在发布的文件队列中
                                new TableUtil().executeUpdate("update publish_item set Status=3,Message='开始发布' where id=" + id_);
                                //调用发布
                                TidePublishFile cf = new TidePublishFile();
                                cf.setPublish_item_id(resulObject.getId());
                                cf.setItem(resulObject);
                                cf.Start();

                                copying_thread_number.incrementAndGet();
                                message = Util.getCurrentDate("MM-dd HH:mm:ss") + " 正在分发文件线程数量:" + copying_thread_number;
                                System.out.println("begin file publish:" + id_ + ",copying_thread_number:" + copying_thread_number);
                            } else {
                                num2++;
                                RedisUtil.getInstance().putMessage(resulObject, RedisUtil.PUBLISH_MESSAGE_KEY);//发布不了的话  就放回redis中
                                message = Util.getCurrentDate("MM-dd HH:mm:ss") + " id:" + id_ + ",FileName:" + filename + ",已经在发布";
                            }

                        }

                        message = Util.getCurrentDate("MM-dd HH:mm:ss") + " 线程休眠  本次" + num1 + "个分发，" + num2 + "个已经在发，最后一个：" + last_file_name;
                    }
                } catch (SQLException e) {
                    message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss") + " 错误：" + e.getMessage();
                    ErrorLog.SaveErrorLog("文件发布进程错误", "", 0, e);
                    e.printStackTrace(System.out);
                }catch(JedisConnectionException e){//Redis异常，此处怀疑是多线程访问同一连接池导致，此处设置了重置机制
                    PublishManager.getInstance().clearCopyingFile();
                    PublishManager.getInstance().StartFilePublishAgent();
                    PublishManager.getInstance().getCopying_files_2016().clear();
                    FilePublishAgent.clearCopyingFiles2();
                    if(RedisUtil.getInstance().isRedis()){//开启Redis
                        RedisUtil.getInstance().ResetQueue(1);//重置全部文件发布任务
                    }
                }

            }
        } catch (MessageException e) {
            message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss") + " 错误：" + e.getMessage();
            ErrorLog.SaveErrorLog("文件发布进程错误", "", 0, e);
            e.printStackTrace(System.out);
        }
        message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss") + " 进程结束";
    }
    public void run() {
        try {
            if(RedisUtil.getInstance().isRedis()) {//如果开启了Redis才使用Redis队列
                RedisQueue();
            }else{
                SQLQuery();
            }
        } catch (MessageException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void CopyFileDone() {
        copying_thread_number.decrementAndGet();
        if (copying_thread_number.get() < 0) {
            System.out.println("有错误发生，copying_thread_number为负数");
            copying_thread_number.set(0);
        }
        //System.out.println("down publish item copying_thread_number:" + copying_thread_number);
        // if(copying_thread_number==0)
        // copyingfiles.clear();
    }

    //synchronized使用会导致死锁
    //另外需要说明的是, 当sync加在 static的方法上的时候, 由于是类级别的方法, 所以锁住的对象是当前类的class实例. 同样也可以写程序进行证明.这里略.
    //http://www.jiacheo.org/blog/317
    // 检查文件是否正在被copy，发布方案编号+文件名
    public boolean checkCopyingFile(String file) {
        message = Util.getCurrentDate("MM-dd HH:mm:ss") + " 检查文件：" + file;

        String s = copying_files2_2016.get(file);
        if (s == null) {
            message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss") + " 检查文件：" + file + " false";
            System.out.println(message);
            return false;
        } else {
            message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss") + " 检查文件：" + file + " true";
            System.out.println(message);
            return true;
        }

		/*for (int i = 0; i < copying_files2_2016.size(); i++) {
			String s = (String) copying_files2_2016.get(i);
			if (s.equals(file))
				return true;
		}
		return false;*/
    }

    //从正在发布中去除，发布方案编号+文件名
    public static void removeCopyingFiles2(String file) {
        //System.out.println("调用删除文件呢 "+file);
        String s = copying_files2_2016.get(file);
        if (s == null)
            return;
        else
            copying_files2_2016.remove(file);
		/*
		for(int i = 0;i<copying_files2_2016.size();i++)
		{
			String s = (String)copying_files2_2016.get(i);
			if(s.equals(file))
			{
				System.out.println("remove copyingfile "+file+","+copying_files2_2016.size());
				copying_files2_2016.remove(i);
				return;
			}
		}*/
    }

    public static void clearCopyingFiles2() {
        copying_files2_2016.clear();
    }

    public static void clearCopyingNumber() {
        copying_thread_number.set(0);
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

    public void setNumber(int number) {
        this.number = number;
    }

    public int getNumber() {
        return number;
    }

    public static int getMax_thread_number() {
        return max_thread_number;
    }

    public static int getCopying_thread_number() {
        return copying_thread_number.get();
    }

    public static ConcurrentHashMap<String, String> getCopying_files2_2016() {
        return copying_files2_2016;
    }

    public static String getMessage() {
        return message;
    }

    public static void setMessage(String message) {
        FilePublishAgent.message = message;
    }
}
