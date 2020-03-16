package tidemedia.cms.publish;

import com.aliyun.oss.OSSClient;
import com.baidubce.auth.DefaultBceCredentials;
import com.baidubce.services.bos.BosClient;
import com.baidubce.services.bos.BosClientConfiguration;
import com.baidubce.services.bos.model.PutObjectResponse;
import org.apache.commons.net.ftp.FTPClient;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Log;
import tidemedia.cms.util.QiniuOssUtil;
import tidemedia.cms.util.Util;

import java.io.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

//import tidemedia.cms.vodone.ChinaCache;

public class CopyFile2015 implements Runnable {

    private Thread runner;
    private String FileSeparator = "/";//文件名分隔符,unix "/" windows "\"
    private long threadid = 0;
    private long start_time = 0;

    private String copyingFileName = "";//正在copy的文件
    private int type = 0; //0 第一个队列 2第二个队列

    private int publish_item_id = 0;//要发布的任务编号

    public void Start() {
        //主系统才开启线程 20160608
        if (!CmsCache.getConfig().getActive().equals("1"))
            return;

        if (runner == null) {
            runner = new Thread(this);
            start_time = System.currentTimeMillis();
            runner.start();

            threadid = runner.getId();
            //System.out.println("CopyFile#"+threadid+" Start");
        }
    }

    public void run() {
        try {
            int i = 0;
            boolean needcopy = false;

            needcopy = copyFile();

            runner = null;//线程结束
            //PublishManager.getInstance().clearFileName(0);
            long usetime = (System.currentTimeMillis() - start_time) / 1000;
            if (usetime > 5)//大于5秒
                System.out.println("CopyFile#" + type + "#" + threadid + " end.>>> " + usetime + "秒");
        } catch (Exception e) {
            ErrorLog.SaveErrorLog("发布文件错误.", "", -1, e);
            e.printStackTrace(System.out);
            runner = null;
        }

        FilePublishAgent.CopyFileDone();
    }

    //0 2 待发布
    //1 已经发布
    //3 正在发布
    //4 发布失败
    public boolean copyFile() throws MessageException, SQLException {
        System.out.println("copy file begin...." + publish_item_id);
        long start_time_ = System.currentTimeMillis();
        int copyfile_success = 0;
        int copyfile_fail = 0;
        String url = "";
        String chinacache = CmsCache.getParameterValue("sys_chinacache");

        ArrayList<PublishItem> filearray = new ArrayList<PublishItem>();

        //java.util.Calendar startDate = new java.util.GregorianCalendar();//拷贝文件开始时间

        long begin_ = System.currentTimeMillis();
        long update_sql_time = 0;
        long wait_time = 0;//等待时间
        long only_ftp_time = 0;//真正的ftp发布时间
        long ftp_time = 0;
        String ps_name = "";

        String Sql = "select * from publish_item where id=" + publish_item_id;

        TableUtil tu = new TableUtil();
        ResultSet Rs = tu.executeQuery(Sql);

        while (Rs.next()) {
            int id = Rs.getInt("id");
            int publishscheme = Rs.getInt("PublishScheme");
            int site = Rs.getInt("Site");
            String FileName = tu.convertNull(Rs.getString("FileName"));
            String ToFileName = tu.convertNull(Rs.getString("ToFileName"));
            String TempFolder = tu.convertNull(Rs.getString("TempFolder"));
            PublishItem item = new PublishItem();
            item.setId(id);
            item.setPublishscheme(publishscheme);
            item.setFileName(FileName);
            item.setToFileName(ToFileName);
            item.setTempFolder(TempFolder);
            item.setSite(site);

            filearray.add(item);
        }
        tu.closeRs(Rs);
        System.out.println("list 100:" + (System.currentTimeMillis() - begin_) + "," + publish_item_id);
        for (int i = 0; i < filearray.size(); i++) {
            long begin = System.currentTimeMillis();

            PublishItem item = (PublishItem) filearray.get(i);

            int id = item.getId();
            int publishscheme = item.getPublishscheme();
            String FileName = item.getFileName();

            String copying_file = publishscheme + "_" + Util.ClearPath(FileName);

            String ToFileName = item.getToFileName();
            String TempFolder = item.getTempFolder();
            if (FileSeparator.equals("/")) {
                TempFolder = TempFolder.replace("\\", "/");
                FileName = FileName.replace("\\", "/");
                ToFileName = ToFileName.replace("\\", "/");
            } else if (FileSeparator.equals("\\")) {
                TempFolder = TempFolder.replace("/", "\\");
                FileName = FileName.replace("/", "\\");
                ToFileName = ToFileName.replace("/", "\\");
            }

            boolean Copy_Success = false;//所有文件复制任务全部完成为true,有一个出错为false;
            String message = "";

            PublishScheme ps = CmsCache.getPublishScheme(publishscheme);//new PublishScheme(publishscheme);

            if (ps.getCopyMode() == 1) {

                System.out.println("copy mode," + publish_item_id);

                long begin_1 = System.currentTimeMillis();
                String fullFileName = Util.ClearPath(TempFolder + "/" + FileName);
                ps_name = ps.getName() + "(" + ps.getServer() + ")(" + fullFileName + ")";
                //临时注释
                setCopyingFileName(fullFileName);
                //PublishManager.getInstance().waitFor(fullFileName,0);
                Sql = "update publish_item set Message='检查能否发布' where id=" + id;
                tu.executeUpdate(Sql);
                //PublishManager.getInstance().waitForCopy(fullFileName);
                waitForCopy(fullFileName, 0);
                wait_time = System.currentTimeMillis() - begin_1;
                //System.out.println("waitFor:"+(System.currentTimeMillis()-begin_));
                //System.out.println("ftp2 "+FileName+","+(System.currentTimeMillis()-begin));
                long begin_2 = System.currentTimeMillis();
                String[] result = FtpCopy(id, ps, FileName, ToFileName, TempFolder);
                only_ftp_time = System.currentTimeMillis() - begin_2;
                if (result[0].equals("1"))
                    Copy_Success = true;
                else {
                    Copy_Success = false;
                    message = result[1];//错误信息
                }
                //begin_ = System.currentTimeMillis();
                Sql = "update publish_item set Message='从在发布对象去除 ' where id=" + id;
                tu.executeUpdate(Sql);
                //PublishManager.getInstance().removeCopyingFile(fullFileName);
                PublishManager.getCopying_files_2016().remove(fullFileName);
            } else if (ps.getCopyMode() == 2) {
                String fullFileName = Util.ClearPath(TempFolder + "/" + FileName);
                //PublishManager.getInstance().waitForCopy(fullFileName);
                waitForCopy(fullFileName, 0);

                Copy_Success = FileCopy(ps, FileName, ToFileName, TempFolder);

                PublishManager.getInstance().removeCopyingFile(fullFileName);
            } else if (ps.getCopyMode() == 3) {
                //Copy_Success = S3Util.copy(ps,FileName,ToFileName,TempFolder);
            } else if (ps.getCopyMode() == 4) {
                //Copy_Success = HpUtil.copy(ps,FileName,ToFileName,TempFolder);
            } else if (ps.getCopyMode() == 5)//同步到阿里云存储
            {
                long begin_1 = System.currentTimeMillis();
                String fullFileName = Util.ClearPath(TempFolder + "/" + FileName);
                ps_name = ps.getName() + "(" + ps.getServer() + ")(" + fullFileName + ")";
                //临时注释
                setCopyingFileName(fullFileName);
                //PublishManager.getInstance().waitFor(fullFileName,0);
                Sql = "update publish_item set Message='检查能否发布' where id=" + id;
                tu.executeUpdate(Sql);
                waitForCopy(fullFileName, 0);
                wait_time = System.currentTimeMillis() - begin_1;
                //System.out.println("waitFor:"+(System.currentTimeMillis()-begin_));
                //System.out.println("ftp2 "+FileName+","+(System.currentTimeMillis()-begin));
                long begin_2 = System.currentTimeMillis();


                String[] result = AliPublish(id, ps, FileName, ToFileName, TempFolder);
                only_ftp_time = System.currentTimeMillis() - begin_2;
                if (result[0].equals("1"))
                    Copy_Success = true;
                else {
                    Copy_Success = false;
                    message = result[1];//错误信息
                }
                //begin_ = System.currentTimeMillis();
                Sql = "update publish_item set Message='从在发布对象去除 ' where id=" + id;
                tu.executeUpdate(Sql);
                //PublishManager.getInstance().removeCopyingFile(fullFileName);
                PublishManager.getCopying_files_2016().remove(fullFileName);


                //Copy_Success = HpUtil.copy(ps,FileName,ToFileName,TempFolder);
            } else if (ps.getCopyMode() == 6)//同步到百度云存储
            {
                long begin_1 = System.currentTimeMillis();
                String fullFileName = Util.ClearPath(TempFolder + "/" + FileName);
                ps_name = ps.getName() + "(" + ps.getServer() + ")(" + fullFileName + ")";
                //临时注释
                setCopyingFileName(fullFileName);
                //PublishManager.getInstance().waitFor(fullFileName,0);
                Sql = "update publish_item set Message='检查能否发布' where id=" + id;
                tu.executeUpdate(Sql);
                waitForCopy(fullFileName, 0);
                wait_time = System.currentTimeMillis() - begin_1;
                //System.out.println("waitFor:"+(System.currentTimeMillis()-begin_));
                //System.out.println("ftp2 "+FileName+","+(System.currentTimeMillis()-begin));
                long begin_2 = System.currentTimeMillis();


                String[] result = BaiduPublish(id, ps, FileName, ToFileName, TempFolder);
                only_ftp_time = System.currentTimeMillis() - begin_2;
                if (result[0].equals("1"))
                    Copy_Success = true;
                else {
                    Copy_Success = false;
                    message = result[1];//错误信息
                }
                //begin_ = System.currentTimeMillis();
                Sql = "update publish_item set Message='从在发布对象去除 ' where id=" + id;
                tu.executeUpdate(Sql);
                //PublishManager.getInstance().removeCopyingFile(fullFileName);
                PublishManager.getCopying_files_2016().remove(fullFileName);
                //Copy_Success = HpUtil.copy(ps,FileName,ToFileName,TempFolder);
            }else if (ps.getCopyMode() == 7)//同步到七牛云
            {
                long begin_1 = System.currentTimeMillis();
                String fullFileName = Util.ClearPath(TempFolder + "/" + FileName);
                ps_name = ps.getName() + "(" + ps.getServer() + ")(" + fullFileName + ")";
                //临时注释
                setCopyingFileName(fullFileName);
                Sql = "update publish_item set Message='检查能否发布' where id=" + id;
                tu.executeUpdate(Sql);
                waitForCopy(fullFileName, 0);
                wait_time = System.currentTimeMillis() - begin_1;
                long begin_2 = System.currentTimeMillis();

                System.out.println(id+"---"+FileName+"----"+ToFileName+"-----"+TempFolder);
                String[] result = new QiniuOssUtil().QiniufileUpload(id, ps, FileName, ToFileName, TempFolder);
                only_ftp_time = System.currentTimeMillis() - begin_2;
                if (result[0].equals("1"))
                    Copy_Success = true;
                else {
                    Copy_Success = false;
                    message = result[1];//错误信息
                }
                Sql = "update publish_item set Message='从在发布对象去除 ' where id=" + id;
                tu.executeUpdate(Sql);
                PublishManager.getCopying_files_2016().remove(fullFileName);
            }

            ftp_time = System.currentTimeMillis() - begin;

            begin_ = System.currentTimeMillis();

            //System.out.println("ftp5 "+FileName+","+(System.currentTimeMillis()-begin)+","+Copy_Success);
            if (Copy_Success) {
                //2015.10.13 sql执行发生错误：Deadlock found when trying to get lock; try restarting transaction
                copyfile_success++;
                long begin__ = System.currentTimeMillis();
                Sql = "update publish_item set Status=1,CopyedTime=UNIX_TIMESTAMP(),UsedTime=" + ftp_time + " where id=" + id;

                if (CmsCache.getConfig().getCustomer().equals("tibet")) {
                    //设置同名文件发布通过，避免重复,给西藏网使用 2015-9-16
                    Sql = "update publish_item set Status=1,CopyedTime=UNIX_TIMESTAMP(),UsedTime=" + ftp_time + " where Status!=1 and PublishScheme=" + publishscheme;
                    //Sql += " and FileName='" + tu.SQLQuote(item.getFileName()) + "' and Site="+item.getSite();
                    Sql += " and FileName='" + tu.SQLQuote(item.getFileName()) + "'";
                }
                //这个sql会消耗几十毫秒，大量浪费时间 2015-9-16
                //System.out.println(Sql);
                //临时处理
                //try{tu.executeUpdate(Sql);}catch(Exception e){System.out.println(e.getMessage());}

                PublishManager.getInstance().executeUpdate(Sql);

                update_sql_time = (System.currentTimeMillis() - begin__);
                //System.out.println("update publish_item:"+(System.currentTimeMillis()-begin__));
                /* 调用发布接口，用于香港服务器中转文件*/

                if (CmsCache.getConfig().getCustomer().equals("tibet")) {
                    tidemedia.cms.util.TibetUtil tibetutil = new tidemedia.cms.util.TibetUtil();
                    tibetutil.setFileName(item.getFileName());
                    tibetutil.setTempFolder(item.getTempFolder());
                    tibetutil.setSite(item.getSite());
                    tibetutil.setScheme(publishscheme);
                    tibetutil.Start();
                }

               // if (chinacache.equals("true")) url = ChinaCache.addUrl(url, FileName, item.getSite());
            } else {
                copyfile_fail++;

                //if(message.contains("Broken pipe") || message.contains("Connection closed without indication"))
                if (message.startsWith("ftp error：")) {
                    //如果错误信息是ftp error：开头的，就尝试5次
                    int errornumber = 0;
                    Sql = "select * from publish_item where id=" + id;
                    ResultSet rs = tu.executeQuery(Sql);
                    if (rs.next()) {
                        errornumber = rs.getInt("ErrorNumber");
                    }
                    tu.closeRs(rs);

                    if (errornumber < 5) {
                        Sql = "update publish_item set ErrorNumber=ErrorNumber+1,Status=0,Message='" + tu.SQLQuote(message) + "' where id=" + id;
                        tu.executeUpdate(Sql);
                    } else {
                        message = message + ",尝试次数：" + errornumber;
                        Sql = "update publish_item set Status=4,Message='" + tu.SQLQuote(message) + "' where id=" + id;
                        //System.out.println(Sql);
                        tu.executeUpdate(Sql);
                    }
                } else if (message.startsWith("ftp login error")) {
                    //ftp登录错误，把对应的ftp
                    ps.Pause();//暂停发布方案
                    message = ",ftp登录问题，暂停发布方案，" + message;
                    Sql = "update publish_item set Status=4,Message='" + tu.SQLQuote(message) + "' where Status=0 and PublishScheme=" + ps.getId();
                    tu.executeUpdate(Sql);
                    Log.SystemLog("发布方案", "ftp登录问题，暂停发布方案：" + ps.getName() + "(" + ps.getId() + "),信息：" + message);
                } else {
                    Sql = "update publish_item set Status=4,Message=Concat(Message,'" + tu.SQLQuote(message) + "') where id=" + id;
                    //System.out.println(Sql);
                    tu.executeUpdate(Sql);
                }
            }

            if (i % 20 == 0) {
//                if (!url.equals("")) ChinaCache.Refresh(url);
////                url = "";
            }
            System.out.println("after ftp:" + (System.currentTimeMillis() - begin_) + ",copying_file:" + copying_file);

            //从正在发布中去除
            FilePublishAgent.removeCopyingFiles2(copying_file);
            //System.out.println("after ftp:"+(System.currentTimeMillis()-begin_)+",UsedTime:"+UsedTime);
        }

        if (chinacache.equals("true")) {
//            if (!url.equals("")) ChinaCache.Refresh(url);
//            url = "";
        }
        long after_ftp_time = (System.currentTimeMillis() - begin_);
        //System.out.println("copy file end:"+(System.currentTimeMillis()-begin_));
        String message_ = "文件拷贝，成功数：" + copyfile_success + ",失败数：" + copyfile_fail + "，用时：" + (System.currentTimeMillis() - start_time_) + "ms";
        message_ += ",update：" + update_sql_time + "ms";
        message_ += ",ftp:" + ftp_time + "ms";
        message_ += ",onlyfty:" + only_ftp_time + "ms";
        message_ += ",wait:" + wait_time + "ms";
        message_ += ",after ftp:" + after_ftp_time + "ms";
        message_ += ",scheme:" + ps_name;
        message_ += "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss");
        System.out.println(message_);


        return true;
    }




    //发布到百度云
    public String[] BaiduPublish(int itemid, PublishScheme ps, String FileName, String ToFileName, String TempFolder) {

        long begin = System.currentTimeMillis();
        String BosaccessKeyId = ps.getBosaccessKeyId();//百度AccessKey
        String BosaccessKeySecret = ps.getBosaccessKeySecret();//百度Secrect
        String BosbucketName = ps.getBosbucketName();//百度Bucket


        try {
            BosClientConfiguration config = new BosClientConfiguration();
            config.setCredentials(new DefaultBceCredentials(BosaccessKeyId, BosaccessKeySecret));
            BosClient client = new BosClient(config);
            TableUtil tu = new TableUtil();
            String Sql = "update publish_item set Message='获取百度云BOS连接对象' where id=" + itemid;
            tu.executeUpdate(Sql);
            if ((System.currentTimeMillis() - begin) > 1000) {
                System.out.println("getBOSClient slow:" + ps.getServer() + "," + FileName + "," + (System.currentTimeMillis() - begin));
            }
            // 获取指定文件
            File file = new File(Util.ClearPath(TempFolder + FileSeparator + FileName));
            if (!file.exists() || !file.isFile()) {
                Log.SystemLog("文件上传", TempFolder + FileSeparator + FileName + ",文件未发现!");
                return new String[]{"0", "文件不存在 " + TempFolder + FileSeparator + FileName};
            }
            String BOS_dir = Util.ClearPath(FileName);
            while (BOS_dir.startsWith("/")) {
                BOS_dir = BOS_dir.replaceFirst("/", "");
            }

            // 以文件形式上传Object
            PutObjectResponse putObjectFromFileResponse = client.putObject(BosbucketName, BOS_dir, file);

            System.out.println(putObjectFromFileResponse.getETag());

            return new String[]{"1", ""};
            // return generatePresignedUrl(client, BosbucketName, BOS_dir, -1);

        } catch (Exception e) {

            System.out.println("BOS copy error:" + e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));

            //if(ossClient!=null) System.out.println(tideftp+",getLast_use_time:"+(System.currentTimeMillis()-tideftp.getLast_use_time()));
            e.printStackTrace(System.out);

            //if(tideftp!=null) tideftp.setUsed(false);
            return new String[]{"0", "BOS error ：" + e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")};
        }


    }

    //发布到阿里云
    public String[] AliPublish(int itemid, PublishScheme ps, String FileName, String ToFileName, String TempFolder) {
        String endpoint = ps.getOssendpoint();//调用接口地址
        String accessKeyId = ps.getOssaccessKeyId();//获取接口Key
        String accessKeySecrect = ps.getOssaccessKeySecret();//获取接口Secrect
        String bucketName = ps.getOSSbucketName();//获取Bucket名字
        long begin = System.currentTimeMillis();
        try {
            OSSClient ossClient = new OSSClient(endpoint, accessKeyId,
                    accessKeySecrect);
            TableUtil tu = new TableUtil();
            String Sql = "update publish_item set Message='获取OSSClient连接对象' where id=" + itemid;
            tu.executeUpdate(Sql);
            if ((System.currentTimeMillis() - begin) > 1000) {
                System.out.println("getOSSClient slow:" + ps.getServer() + "," + FileName + "," + (System.currentTimeMillis() - begin));
            }

            String LocalFilePath = Util.ClearPath(TempFolder + FileSeparator + FileName);
            if (!new File(LocalFilePath).exists()) {
                Log.SystemLog("文件上传", TempFolder + FileSeparator + FileName + ",文件未发现!");
                return new String[]{"0", "文件不存在 " + TempFolder + FileSeparator + FileName};
            }

            //String OSS_root = Util.ClearPath(ps.getRemoteFolder() + "/");
            String OSS_dir = Util.ClearPath(FileName);


            while (OSS_dir.startsWith("/")) {
                OSS_dir = OSS_dir.replaceFirst("/", "");
            }
            //System.out.println("OSS_dirpath"+OSS_dir);
            InputStream inputStream = new FileInputStream(LocalFilePath);
            ossClient.putObject(bucketName, OSS_dir, inputStream);
            return new String[]{"1", ""};
        } catch (Exception e) {
            System.out.println("OSS copy error:" + e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));

            //if(ossClient!=null) System.out.println(tideftp+",getLast_use_time:"+(System.currentTimeMillis()-tideftp.getLast_use_time()));
            e.printStackTrace(System.out);

            //if(tideftp!=null) tideftp.setUsed(false);
            return new String[]{"0", "OSS error ：" + e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")};
        }
        //return null;

    }

    //Ftp上传
    public String[] FtpCopy(int itemid, PublishScheme ps, String FileName, String ToFileName, String TempFolder) {//System.out.println(FileName);
        long begin = System.currentTimeMillis();
        TideFtpClient tideftp = null;

        try {
            tideftp = FtpManager.getFtp(ps.getId());
            TableUtil tu = new TableUtil();
            String Sql = "update publish_item set Message='获取ftp连接对象' where id=" + itemid;
            tu.executeUpdate(Sql);
            if ((System.currentTimeMillis() - begin) > 1000) {
                System.out.println("getftp slow:" + ps.getServer() + "," + FileName + "," + (System.currentTimeMillis() - begin));
            }
            String[] s = FtpCopy2(itemid, tideftp, ps, FileName, ToFileName, TempFolder);
            tideftp.setUsed(false);
            System.out.println(tideftp.toString() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss") + "," + ps.getName());
            return s;
        } catch (Exception e) {
            System.out.println("ftp copy error:" + e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));

            if (tideftp != null)
                System.out.println(tideftp + ",getLast_use_time:" + (System.currentTimeMillis() - tideftp.getLast_use_time()));
            e.printStackTrace(System.out);

            if (tideftp != null) tideftp.setUsed(false);
            return new String[]{"0", "ftp error：" + e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")};
        }
    }

    //Ftp上传
    public String[] FtpCopy2(int itemid, TideFtpClient tideftp, PublishScheme ps, String FileName, String ToFileName, String TempFolder) throws SQLException, MessageException, IOException {//System.out.println(FileName);
        boolean copy_success = false;
        long begin = System.currentTimeMillis();
        String message_ = "";
        //TideFtpClient tideftp = FtpManager.getFtp(ps.getId());
        FTPClient ftp = tideftp.getFtp();
        if (ftp == null) {
            System.out.println("ftp is null " + tideftp.getMessage());
            if (tideftp.getMessage().startsWith("登录错误")) {
                return new String[]{"0", "ftp login error：" + tideftp.getMessage()};
            } else
                return new String[]{"0", "ftp error：" + tideftp.getMessage()};
        }

        TableUtil tu = new TableUtil();
        String Sql = "update publish_item set Message='ftp连接对象可用' where id=" + itemid;
        tu.executeUpdate(Sql);

        //System.out.println(FileName+",ftp connect:"+ftp.isConnected()+",work dir:"+ftp.printWorkingDirectory()+","+tideftp.toString());
        InputStream is = null;
        File file = null;
        try {
            file = new File(TempFolder + FileSeparator + FileName);
            is = new FileInputStream(file);
        } catch (FileNotFoundException e1) {
            copy_success = true;//文件不存在也算是发布成功
            System.out.println(TempFolder + FileSeparator + FileName + ",文件未发现!");
            Log.SystemLog("文件上传", TempFolder + FileSeparator + FileName + ",文件未发现!");
            return new String[]{"0", "文件不存在 " + TempFolder + FileSeparator + FileName};
        }
        Sql = "update publish_item set Message='文件存在' where id=" + itemid;
        tu.executeUpdate(Sql);
        //System.out.println("ftpcopy4 "+FileName+" "+(System.currentTimeMillis()-begin));
        if (ToFileName.length() > 0) FileName = ToFileName;
        //文件名，不包括目录
        String OnlyFileName = FileName.substring(FileName.lastIndexOf(FileSeparator) + 1);
        String tempStr = FileName;
        //System.out.println("tempStr:"+tempStr);
        String Directory = "";
        int position = 0;

        String ftp_root = Util.ClearPath(ps.getRemoteFolder() + "/");

        String ftp_dir = Util.ClearPath(ftp_root + Util.getFilePath(FileName) + "/");
        boolean hasChangeDir = false;//切换目录状态
        boolean makeDir = false;//创建目录状态
        try {
            hasChangeDir = ftp.changeWorkingDirectory(ftp_dir);
        } catch (Exception e) {
            System.out.println("ftp_dir:" + ftp_dir + "," + e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss") + "," + FileName);
            //e.printStackTrace(System.out);
            hasChangeDir = ftp.changeWorkingDirectory(ftp_dir);
            System.out.println("ftp_dir:" + ftp_dir + "," + hasChangeDir);
        }

        if (!hasChangeDir) {
            //可能目录不存在
            String[] result = makeDirectories(ftp, ftp_dir);//ftp.makeDirectory(ftp_dir);
            if (result[0].equals("0")) {
                //有错误
                return result;
            } else
                hasChangeDir = true;
            //hasChangeDir = makeDirectories(ftp,ftp_dir);//ftp.makeDirectory(ftp_dir);
        }

        message_ += (ps.getServer() + "," + FileName + ",用时：" + (System.currentTimeMillis() - begin));

        //if(!hasChangeDir)
        //{
        //if(!makeDir)
        //{
        //	System.out.println("目录创建失败,可能是权限不够，文件:"+FileName+",目录："+ftp_dir+",发布方案："+ps.getName()+",Ftp Server："+ps.getServer());
        //	Log.SystemLog("文件上传","目录创建失败,可能是权限不够，文件:"+FileName+",目录："+ftp_dir+",发布方案："+ps.getName()+",Ftp Server："+ps.getServer());
        //}
        //else
        //{
        //	System.out.println("目录切换失败,可能是权限不够，文件:"+FileName+",目录："+ftp_dir+",发布方案："+ps.getName()+",Ftp Server："+ps.getServer());
        //	Log.SystemLog("文件上传","目录切换失败,可能是权限不够，文件:"+FileName+",目录："+ftp_dir+",发布方案："+ps.getName()+",Ftp Server："+ps.getServer());
        //}
        //}

        String message = "";

        if (is != null && hasChangeDir) {
            boolean storefile = false;

            String work_dir = Util.ClearPath(ftp.printWorkingDirectory() + "/");
            if (ftp_dir.equals(work_dir)) {
                long begin__ = System.currentTimeMillis();
                Sql = "update publish_item set Message='开始上传内容 " + Util.getCurrentDate("MM-dd HH:mm:ss") + "' where id=" + itemid;
                tu.executeUpdate(Sql);
                storefile = ftp.storeFile(OnlyFileName, is);
                Sql = "update publish_item set Message='上传结束 " + storefile + "' where id=" + itemid;
                tu.executeUpdate(Sql);
                message_ += "," + (System.currentTimeMillis() - begin__);

                //System.out.println("ftp folder is ok，" + FileName+",work:"+ftp.printWorkingDirectory()+","+tideftp.toString());
            } else {
                System.out.println("ftp folder is error，" + FileName + ",ftp_dir：" + ftp_dir + ",work：" + work_dir + "," + tideftp.toString());
            }

            is.close();

            if (!storefile) {
                copy_success = false;
                message = "ftp error：上传失败,可能是权限不够，文件:" + FileName + ",发布方案：" + ps.getName() + ",Ftp Server：" + ps.getServer();
                //System.out.println("上传失败,可能是权限不够，文件:"+FileName+",发布方案："+ps.getName()+",Ftp Server："+ps.getServer());
                Log.SystemLog("文件上传", "上传失败,可能是权限不够，文件:" + FileName + ",发布方案：" + ps.getName() + ",Ftp Server：" + ps.getServer());
                ftp.logout();//失败后退出
            } else
                copy_success = true;
        } else {
            String isnull = "";
            if (is == null) isnull = "is null";
            message = "ftp更换目录:" + hasChangeDir + ",文件对象:" + isnull;
        }

        is.close();

        message_ += "," + (System.currentTimeMillis() - begin);

        if ((System.currentTimeMillis() - begin) > 1000)
            System.out.println("ftp slow:" + message_);

        if (copy_success)
            return new String[]{"1", ""};
        else
            return new String[]{"0", message};
    }

    public static String[] makeDirectories(FTPClient ftpClient, String dirPath) throws IOException {
        //String[] result = {"0",""};

        String[] pathElements = Util.StringToArray(dirPath, "/");
        if (pathElements != null && pathElements.length > 0) {
            for (String singleDir : pathElements) {
                boolean existed = ftpClient.changeWorkingDirectory(singleDir);
                if (!existed) {
                    boolean created = ftpClient.makeDirectory(singleDir);//不能创建多级目录
                    if (created) {
                        boolean r = ftpClient.changeWorkingDirectory(singleDir);

                        if (!r) {
                            return new String[]{"0", "ftp error：ftp切换目录失败，当前ftp目录：" + ftpClient.printWorkingDirectory() + ",要切换目录：" + singleDir};
                        }

                    } else {
                        System.out.println("COULD NOT create directory: " + singleDir + "," + dirPath + "," + ftpClient.printWorkingDirectory());
                        return new String[]{"0", "ftp error：ftp创建目录失败，当前ftp目录：" + ftpClient.printWorkingDirectory() + ",要创建目录：" + singleDir};
                    }
                }
            }
        }
        return new String[]{"1", ""};
    }


    //文件拷贝
    public boolean FileCopy(PublishScheme ps, String FileName, String ToFileName, String TempFolder) throws SQLException, MessageException {
        boolean Copy_Success = true;
        String OutputFile = "";
        String inputfile = TempFolder + FileSeparator + FileName;

        if (ToFileName.length() > 0) FileName = ToFileName;

        if (ps.getDestFolder().endsWith(FileSeparator) || FileName.startsWith(FileSeparator))
            OutputFile = ps.getDestFolder() + FileName;
        else
            OutputFile = ps.getDestFolder() + FileSeparator + FileName;

        //检查目录是否存在，不存在则创建
        String tFolder = "";
        tFolder = OutputFile;
        tFolder = (tFolder).substring(0, tFolder.lastIndexOf(FileSeparator));

        File file = new File(tFolder);
        if (!file.exists())
            file.mkdirs();
        file = null;

        FileInputStream input = null;
        FileOutputStream output = null;

        try {
            input = new FileInputStream(inputfile);
        } catch (FileNotFoundException e) {
            //文件未找到，发布失败
            Copy_Success = false;
            System.out.println(inputfile + ",文件未找到!");
        }

        try {
            output = new FileOutputStream(OutputFile);
        } catch (FileNotFoundException e1) {
            //无法创建文件，发布失败
            Copy_Success = false;
            System.out.println(OutputFile + ",无法创建文件!");
        }

        if (input != null && output != null) {
            byte[] b = new byte[1024 * 5];
            int len = 0;
            try {
                while ((len = input.read(b)) != -1) {
                    output.write(b, 0, len);
                }

                output.flush();
                output.close();
                input.close();
            } catch (IOException e2) {
                //发布失败
                Copy_Success = false;
                e2.printStackTrace();
            }
        }

        return Copy_Success;
    }

    public String getFileSeparator() {
        return FileSeparator;
    }

    public void setFileSeparator(String fileSeparator) {
        FileSeparator = fileSeparator;
    }

    public void setRunner(Thread runner) {
        this.runner = runner;
    }

    public Thread getRunner() {
        return runner;
    }

    public void setCopyingFileName(String copyingFileName) {
        this.copyingFileName = copyingFileName;
    }

    public String getCopyingFileName() {
        return copyingFileName;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }

    public long getStart_time() {
        return start_time;
    }

    public void setStart_time(long start_time) {
        this.start_time = start_time;
    }

    public int getPublish_item_id() {
        return publish_item_id;
    }

    public void setPublish_item_id(int publish_item_id) {
        this.publish_item_id = publish_item_id;
    }

    public void waitForCopy(String file, int number) {
        do {
            boolean result = PublishManager.getInstance().checkCando(1, file);
            if (result)
                break;

            if (number > 300)
                break;

            number++;

            try {
                Thread.sleep(1000);
                TableUtil tu = new TableUtil();
                String Sql = "update publish_item set Message='检查允许分发次数：" + (number) + "' where id=" + getPublish_item_id();
                tu.executeUpdate(Sql);
            } catch (InterruptedException e) {
                e.printStackTrace(System.out);
            } catch (MessageException e) {
                e.printStackTrace(System.out);
            } catch (SQLException e) {
                e.printStackTrace(System.out);
            }
        } while (true);
    }

    public void waitForCopy_(String file, int number) {
        boolean result = PublishManager.getInstance().checkCando(1, file);
        if (!result) {
            do {
                if (number > 300)
                    break;

                try {
                    Thread.sleep(1000);
                    TableUtil tu = new TableUtil();
                    String Sql = "update publish_item set Message='检查允许分发次数：" + (number + 1) + "' where id=" + getPublish_item_id();
                    tu.executeUpdate(Sql);
                    waitForCopy(file, number++);
                } catch (InterruptedException e) {
                    e.printStackTrace(System.out);
                } catch (MessageException e) {
                    e.printStackTrace(System.out);
                } catch (SQLException e) {
                    e.printStackTrace(System.out);
                }
            }
            while (true);
        }
    }

}
