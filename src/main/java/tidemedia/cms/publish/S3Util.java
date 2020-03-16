package tidemedia.cms.publish;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONException;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.Protocol;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.AccessControlList;
import com.amazonaws.services.s3.model.GroupGrantee;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.PutObjectResult;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.publish.PublishScheme;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.Log;

/**
 * 
 * @author guoqingguang 2015.09.25	区分util包中的FileUtil。
 * 
 * 
 *
 */
public class S3Util {
	public static String accessKeyID = "";//"JYWWJF0GBSLBFHOGEG87";
	public static String secretKey = "";//"HYaKB6ioMe0j4hycAJsbTaxgYM4c7a7GmNrGtGst";
	public static String bucketName = "";//"tmzskj";
	public static String endPoint = "";//"s3.bj.xs3cnc.com"; // s3.xs3cnc.com
	public static String httpVideoHead = "";
	//public static String video_dest_folder="";
	//public static boolean isRunning = false;//是否在运行
	public static int 	transcode_channelid = 5611;
	//public static String send_video_type = "1,2";//需要发送到hp存储的视频转码编号,多个以逗号间隔
	public static AWSCredentials credentials;
	static ClientConfiguration clientConfig;
	public static AmazonS3 conn;
	
	public static boolean copy(PublishScheme ps,String FileName,String ToFileName,String TempFolder) throws MessageException, SQLException{
		boolean returnValue	=	false;
		initCloudSend(ps);
		returnValue=startS3VideoSend(FileName,ToFileName,TempFolder);
		return returnValue;
	}
	
	

	private static boolean startS3VideoSend(String filename,String tofilename,String video_dest_folder) {
		// TODO Auto-generated method stub
		boolean returnValue = false;
		try {
			String video_dest = filename;
			String filefullpath = video_dest_folder+video_dest;
			if(!checkFileExist(filefullpath)){
				Log.SystemLog("发送到云", "视频不存在，filepath = "+filefullpath);
				//returnValue =  false;
			}else{
				//String formatVideoPath="";
				sendOneVideo(filefullpath,tofilename);
				updateVideoDest(tofilename,filename);
				returnValue = true;
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return returnValue;
		
	}
	
	private static void updateVideoDest(String formatVideoPath,String beforeFileName) throws MessageException, SQLException {
		// TODO Auto-generated method stub
		if(!formatVideoPath.startsWith("/")){
			formatVideoPath = "/"+formatVideoPath;
		}
		Channel ch = CmsCache.getChannel(transcode_channelid);
		String http_video_dest = httpVideoHead+formatVideoPath; 
		String sql = "update "+ch.getTableName()+" set videoSend=1,video_dest='"+http_video_dest+"' where video_dest='"+beforeFileName+"'";
		TableUtil tu2 = ch.getTableUtil();
		tu2.executeUpdate(sql);
		
	}
	public static void sendOneVideo(String filefullpath,String tofilename) throws FileNotFoundException {
		// 初始化AmazonS3Client
		Conn();

		// 获取制定文件的输入流
		File file = new File(filefullpath);
		InputStream input = new FileInputStream(file);

		// 创建上传文件的metadata
		ObjectMetadata meta = new ObjectMetadata();
		meta.setContentLength(file.length());
		
		AccessControlList acl = new AccessControlList();
		//acl.grantAllPermissions(new CanonicalGrantee(""),Permission.);
		acl.grantPermission(GroupGrantee.AuthenticatedUsers, com.amazonaws.services.s3.model.Permission.Read);
		// 上传文件
		//PutObjectResult result = conn.putObject(bucketName, "text/2015/9/25/a.txt", input,meta);
		//注意，相对地址不能以 / 开头
		if(tofilename.startsWith("/")){
			tofilename = tofilename.replaceFirst("/", "");
		}
		
		PutObjectResult result = conn.putObject(new PutObjectRequest(bucketName, tofilename, file).withAccessControlList(acl));
		// 打印ETag
		System.out.println(result.getETag());
	}
/**
 * 
 * @param publishscheme	转码配置中，发布方案id所在对象
 * @throws SQLException 
 * @throws MessageException 
 */
	private static void initCloudSend(PublishScheme publishscheme) throws MessageException, SQLException {
		// TODO Auto-generated method stub
		
		//初始化 s3需要参数
		if(accessKeyID.length()==0||secretKey.length()==0||bucketName.length()==0||endPoint.length()==0){
			accessKeyID = publishscheme.getAccessKeyID();
			secretKey = publishscheme.getSecretKey();
			bucketName = publishscheme.getBucketName();
			endPoint = publishscheme.getEndPoint();
			httpVideoHead = publishscheme.getVideoHttpHead();
			if(httpVideoHead.length()==0){
				httpVideoHead = "http://"+bucketName+"."+endPoint;
			}
			//httpVideoHead 如果填写时末尾有/,则去掉，否则后面可能出现 //video/ 现象
			if(httpVideoHead.endsWith("/")){
				httpVideoHead = httpVideoHead.substring(0,httpVideoHead.lastIndexOf("/"));
			}
			
		}
	}
	
	public static void Conn() {
		Cred();

		// 初始化账户信息
		// credentials = new BasicAWSCredentials(accessKeyID, secretKey);
		clientConfig = new ClientConfiguration();
		clientConfig.setProtocol(Protocol.HTTP);

		// 初始化AmazonS3Client
		conn = new AmazonS3Client(credentials, clientConfig);
		conn.setEndpoint(endPoint);
		
		System.out.println("conn succ!");
	}
	public static void Cred() {
		credentials = new BasicAWSCredentials(accessKeyID, secretKey);
		System.out.println("testCred succ!");
	}
	
	public static boolean checkFileExist(String filefullpath){
		boolean isExist = false;
		File file = new File(filefullpath);
		isExist = file.exists();
		return isExist;
	}
}
