package tidemedia.cms.util;

import com.google.gson.Gson;
import com.qiniu.common.QiniuException;
import com.qiniu.common.Zone;
import com.qiniu.http.Response;
import com.qiniu.storage.BucketManager;
import com.qiniu.storage.Configuration;
import com.qiniu.storage.UploadManager;
import com.qiniu.storage.model.BatchStatus;
import com.qiniu.storage.model.DefaultPutRet;
import com.qiniu.util.Auth;
import com.qiniu.util.StringMap;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.publish.PublishScheme;
import tidemedia.cms.system.Log;

import java.io.File;

public class QiniuOssUtil {

    private String FileSeparator = "/";//文件名分隔符,unix "/" windows "\"
    public Zone getZone(){
        Zone z = new Zone();
        Zone.Builder builder = new Zone.Builder();
        z = builder.build();
        return z;
    }
    //发布到七牛云
    public String[] QiniufileUpload(int itemid, PublishScheme ps, String FileName, String ToFileName, String TempFolder) {
        long starttime = System.currentTimeMillis();
        System.out.println("开始上传时间" + starttime);

        String accessKey = ps.getQiniuAccessKey();
        String secretKey = ps.getQiniuSecrectKey();
        String bucket = ps.getQiniubucketName();
        Zone z=getZone();
        Auth auth = Auth.create(accessKey, secretKey);
        //定义七牛云存储一些域名，默认无需这种配置，本地化私有部署需要配置这些域名


        try {
            Configuration cfg = new Configuration(z);
            UploadManager uploadManager = new UploadManager(cfg);
            String Sql = "update publish_item set Message='获取七牛云连接对象' where id=" + itemid;
            new TableUtil().executeUpdate(Sql);
            if ((System.currentTimeMillis() - starttime) > 1000) {
                System.out.println("getQiNiuClient slow:" + ps.getServer() + "," + FileName + "," + (System.currentTimeMillis() - starttime));
            }
            //...生成上传凭证，然后准备上传


            String key = Util.ClearPath(FileName);

            if (key.startsWith("/")) {//OSSKey去掉最前端的/  否则预览时只有 http://test-demo.record.jstv.com//video/2019/5/4/2019541556937817285_1.mp4 可以预览
                key = key.substring(1);
            }

            System.out.println(key + "--------");
            String accessToken  = auth.uploadToken(bucket, key, 3600, new StringMap().put("insertOnly", 0));
            File uploadfile = new File(Util.ClearPath(TempFolder + "/" + FileName));
            if (!uploadfile.exists() || !uploadfile.isFile()) {
                Log.SystemLog("文件上传", TempFolder + FileSeparator + FileName + ",文件未发现!");
                return new String[]{"0", "文件不存在 " + TempFolder + FileSeparator + FileName};
            }

            Response response = uploadManager.put(Util.ClearPath(TempFolder + "/" + FileName), key, accessToken);
            //解析上传成功的结果
            DefaultPutRet putRet = new Gson().fromJson(response.bodyString(), DefaultPutRet.class);
            System.out.println(putRet.key);
            System.out.println(putRet.hash);
            long endtime = System.currentTimeMillis();
            System.out.println(endtime - starttime + "：上载耗时");
            System.out.println("上传结果" + response);
            return new String[]{"1", ""};
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Qiniu copy error:" + e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
            e.printStackTrace(System.out);
            return new String[]{"0", "Qiniu error ：" + e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")};
        }


    }

    /**
     * 删除七牛文件
     *
     * @param ps       发布方案对象
     * @param FileName 目标文件名
     * @return
     */
    public boolean QiniuDeleteFile(PublishScheme ps, String FileName) {
        boolean flag = false;
        long starttime = System.currentTimeMillis();
        System.out.println("开始操作删除时间" + starttime);

        String accessKey = ps.getQiniuAccessKey();
        String secretKey = ps.getQiniuSecrectKey();
        String bucket = ps.getQiniubucketName();


        //定义七牛云存储一些域名，默认无需这种配置，本地化私有部署需要配置这些域名
        Zone z = getZone();
        //构造一个带指定Zone对象的配置类
        Configuration cfg = new Configuration(z);
        Auth auth = Auth.create(accessKey, secretKey);
        String key = FileName;
        if (key.startsWith("/")) {
            key = key.substring(1);
        }
        BucketManager bucketManager = new BucketManager(auth, cfg);
        try {
            bucketManager.delete(bucket, key);
            flag = true;
        } catch (QiniuException ex) {
            //如果遇到异常，说明删除失败
            System.err.println(ex.code());
            System.err.println(ex.response.toString());
        }
        return flag;
    }


    /**
     * 查看七牛云是否存在该文件
     *
     * @param ps       发布方案对象
     * @param FileName 目标文件名
     * @return
     */
    public boolean QiniuExistFile(PublishScheme ps, String FileName) {
        boolean flag = false;
        String accessKey = ps.getQiniuAccessKey();
        String secretKey = ps.getQiniuSecrectKey();
        String bucket = ps.getQiniubucketName();

        //定义七牛云存储一些域名，默认无需这种配置，本地化私有部署需要配置这些域名
        Zone z = getZone();
        //构造一个带指定Zone对象的配置类
        Configuration cfg = new Configuration(z);
        Auth auth = Auth.create(accessKey, secretKey);
        String key = FileName;
        if (key.startsWith("/")) {
            key = key.substring(1);
        }
        BucketManager bucketManager = new BucketManager(auth, cfg);
        try {
            String[] keyList = {key};
            BucketManager.BatchOperations batchOperations = new BucketManager.BatchOperations();
            batchOperations.addStatOps(bucket, keyList);
            Response response = bucketManager.batch(batchOperations);
            BatchStatus[] batchStatusList = response.jsonToObject(BatchStatus[].class);
            for (int i = 0; i < batchStatusList.length; i++) {
                BatchStatus status = batchStatusList[i];
                System.out.print(key + "\t");
                if (status.code == 200) {
                    flag = true;
                } else {
                    System.out.println(status.data.error);
                }
            }
        } catch (QiniuException ex) {
            //如果遇到异常，说明删除失败
            System.err.println(ex.code());
            System.err.println(ex.response.toString());
        }
        return flag;
    }

}
