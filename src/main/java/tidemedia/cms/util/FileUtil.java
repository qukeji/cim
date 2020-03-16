/*
 * Created on 2004-8-31
 *
 */
package tidemedia.cms.util;

import java.awt.Dimension;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.SocketException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipException;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import magick.CompositeOperator;
import magick.ImageInfo;
import magick.MagickException;
import magick.MagickImage;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;
import org.apache.tools.zip.ZipOutputStream;
import org.im4java.core.CompositeCmd;
import org.im4java.core.ConvertCmd;
import org.im4java.core.IM4JavaException;
import org.im4java.core.IMOperation;
import org.im4java.core.IdentifyCmd;
import org.im4java.process.ArrayListOutputConsumer;
import org.im4java.process.ProcessStarter;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.publish.Publish;
import tidemedia.cms.publish.PublishManager;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Log;
import tidemedia.cms.system.LogAction;
import tidemedia.cms.system.Site;
import tidemedia.cms.system.Watermark;
import tidemedia.cms.util.Util;

import com.sun.xml.internal.messaging.saaj.packaging.mime.internet.MimeUtility;

import de.innosystec.unrar.Archive;
import de.innosystec.unrar.rarfile.FileHeader;

/**
 * @author 李永海(yonghai2008@gmail.com)
 *
 */
public class FileUtil {

	private ArrayList<String> ExcludeFiles = new ArrayList<String>();
	private ArrayList<String> ExcludeFileExts = new ArrayList<String>();
	private ArrayList<String> ExcludeFolders = new ArrayList<String>();
	
	public int 	actionuser;

	public FileUtil() {
	}

	public void DeleteFolder(File file)
	{
		File[] files = file.listFiles();
		if(files!=null && files.length!=0)
		{
			for(int i = 0;i<files.length;i++)
			{
				if(files[i].isDirectory())
				{
					DeleteFolder(files[i]);
				}
				else
				{
					files[i].delete();
				}
			}
		}
		file.delete();
	}

	public void PublishFiles(String FileName,String Path,String rootpath,int userid,Site site) throws MessageException, SQLException
	{
		Publish publish = new Publish();
		String[] files = Util.StringToArray(FileName,",");
		if(files!=null && files.length>0)
		{
			for(int i=0;i<files.length;i++)
			{				
				String InsertFileName = Path + "/" + files[i];
				new Log().FileLog(LogAction.file_publish, InsertFileName, userid,site.getId());
				publish.InsertToBePublished(InsertFileName,rootpath,site);
			}
		}
		
		PublishManager publishmanager = PublishManager.getInstance();		
		publishmanager.FilePublish(userid);			
	}
	
	public void PublishFolder(File file,String rootpath,int userid,Site site) throws MessageException, SQLException
	{
		new Log().FileLog(LogAction.folder_publish, rootpath, userid,site.getId());
		File file2 = new File(rootpath);
		PrePublishFolder(file,file2.getPath(),site);
		
		PublishManager publishmanager = PublishManager.getInstance();	
		publishmanager.FilePublish(userid);
	}
	
	public void PrePublishFolder(File file,String rootpath,Site site) throws MessageException, SQLException
	{
		String InsertFileName = "";	
		Publish publish = new Publish();
		File[] files = file.listFiles();
		if(files!=null && files.length!=0)
		{
			for(int i = 0;i<files.length;i++)
			{
				if(files[i].isDirectory())
				{
					PrePublishFolder(files[i],rootpath,site);
				}
				else
				{
					InsertFileName = files[i].getPath();
					InsertFileName = InsertFileName.substring(rootpath.length());
					publish.InsertToBePublished(InsertFileName,rootpath,site);
				}
			}
		}
		
		if(file.isFile())
		{
			InsertFileName = file.getPath();
			System.out.println("file:"+InsertFileName+",root:"+rootpath);
			InsertFileName = InsertFileName.substring(rootpath.length());
			publish.InsertToBePublished(InsertFileName,rootpath,site);
		}
	}

	public void PublishFile(String FileName,String rootpath,int userid,Site site) throws MessageException, SQLException
	{
		Publish publish = new Publish();
		publish.InsertToBePublished(FileName,rootpath,site);
		
		PublishManager publishmanager = PublishManager.getInstance();	
		publishmanager.FilePublish(userid);			
	}
	
	public static long getSize(File file)
	{
		if(file.length()==0)
			return 0;
		return Math.round(file.length()/1024+0.5);
	}
	
	public String getExt(File file)
	{
		String ext = "";
		int index = file.getName().lastIndexOf(".");
		if(index==-1)
			return "";
		else
		{
			ext = file.getName().substring(index+1);
			return ext;
		}
	}
	
	public String lastModified(File file)
	{
		String pattern = "yyyy-MM-dd HH:mm";
		java.util.Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.setTimeInMillis(file.lastModified());
		DateFormat df = new SimpleDateFormat(pattern);
		return df.format(nowDate.getTime());		
	}

	public void downloadFile(HttpServletResponse response,String sourceFilePathName,String contentType,String destFileName,int siteid)	throws IOException, MessageException, SQLException 
	{
		downloadFile(null,response,sourceFilePathName,contentType,destFileName,siteid);
	}
	/**
	 * 下载文件.
	 * @param response
	 * @param sourceFilePathName
	 * @param contentType
	 * @param destFileName
	 * @param blockSize
	 * @throws IOException
	 * @throws SQLException 
	 * @throws MessageException 
	 * siteid如果为0，直接下载文件
	 */
	public void downloadFile(HttpServletRequest request,HttpServletResponse response,String sourceFilePathName,String contentType,
		String destFileName,int siteid)	throws IOException, MessageException, SQLException 
	{
		String agent =  "";
		if(request!=null)
		{
			agent = request.getHeader("User-Agent");
			//System.out.println("agent:"+agent);
			//StringTokenizer st = new StringTokenizer(Agent,";");
			//st.nextToken();
			//得到用户的浏览器名
			//userbrowser = st.nextToken();
			//得到用户的操作系统名
			//String useros = st.nextToken();
		}
		String filename = "";
		if(siteid>0)
		{
			Site site=CmsCache.getSite(siteid);
			filename = site.getSiteFolder() + "/" + sourceFilePathName;
		}
		else
			filename = sourceFilePathName;
		
		if(filename.length()==0) return;
		
		new Log().FileLog(LogAction.file_download, sourceFilePathName, actionuser,siteid);
		File file = new File(filename);

		FileInputStream fileIn = new FileInputStream(file);
		long fileLen = file.length();
		int readBytes = 0;
		int totalRead = 0;
		int blockSize = 2048;
		byte b[] = new byte[blockSize];
		String charset = CmsCache.getDefaultsite().getCharset();
		if(charset.length()==0)
			charset = "utf-8";
		if (contentType == null)
			response.setContentType("application/x-msdownload;charset="+charset);
		else if (contentType.length() == 0)
			response.setContentType("application/x-msdownload;charset="+charset);
		else
		{
			if(contentType.indexOf("charset")==-1)
				contentType += ";charset=" + charset;
			//System.out.println(contentType);
			response.setContentType(contentType);
		}
		response.setContentLength((int) fileLen);
		String m_contentDisposition = "attachment;";
		//		m_contentDisposition = m_contentDisposition != null ? m_contentDisposition : "attachment;";
		StringBuffer buf = new StringBuffer();
		buf.append(String.valueOf(m_contentDisposition));
		buf.append(" filename=");
		if(agent.indexOf("Firefox")!=-1)
		{
			String name = MimeUtility.encodeText(destFileName,charset,"B");
			//name = name.replace(" ", "%20");
			buf.append(name);
		}
		else if(agent.indexOf("MSIE")!=-1)
			buf.append(URLEncoder.encode(destFileName,charset));
		else
			buf.append(destFileName);
		
		//buf.append(URLEncoder.encode(destFileName,charset));
		//System.out.println("destFileName:"+destFileName);
		//System.out.println(buf);
		response.setHeader("Content-Disposition",String.valueOf(buf));
		try{
		while ((long) totalRead < fileLen) {
			readBytes = fileIn.read(b, 0, blockSize);
			totalRead += readBytes;
			response.getOutputStream().write(b, 0, readBytes);
		}
		fileIn.close();
		}catch(java.net.SocketException e)
		{
			try {
				new Log().FileLog(LogAction.download_cancel, sourceFilePathName, actionuser,siteid);
			} catch (MessageException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
	}
	
	public void downloadFolder(HttpServletRequest request,HttpServletResponse response,String sourceFolder,int siteid)	throws IOException, MessageException, SQLException 
		{
			String contentType = "csv/downloadable";
			String agent =  "";
			if(request!=null)
			{
				agent = request.getHeader("User-Agent");
				//System.out.println("agent:"+agent);
				//StringTokenizer st = new StringTokenizer(Agent,";");
				//st.nextToken();
				//得到用户的浏览器名
				//userbrowser = st.nextToken();
				//得到用户的操作系统名
				//String useros = st.nextToken();
			}
			String foldername = "";
			if(siteid>0)
			{
				Site site=CmsCache.getSite(siteid);
				foldername = site.getSiteFolder() + "/" + sourceFolder;
			}
			
			if(foldername.length()==0) return;
			
			String destFileName = "";
			if(foldername.equals("\\"))
			{
				destFileName = "webroot.zip";
			}
			else
			{
				destFileName = foldername.substring(foldername.lastIndexOf("/")+1)+".zip";
			}
			File zipfile = new File(foldername + "/" + destFileName);
			zipFiles(new File(foldername),zipfile);
			
			new Log().FileLog(LogAction.folder_download, sourceFolder, actionuser,siteid);
			String filename = foldername + "/" + destFileName;
			File file = new File(filename);

			FileInputStream fileIn = new FileInputStream(file);
			long fileLen = file.length();
			int readBytes = 0;
			int totalRead = 0;
			int blockSize = 2048;
			byte b[] = new byte[blockSize];
			try{
			String charset = CmsCache.getDefaultsite().getCharset();
			if(charset.length()==0)
				charset = "utf-8";
			if (contentType == null)
				response.setContentType("application/x-msdownload;charset="+charset);
			else if (contentType.length() == 0)
				response.setContentType("application/x-msdownload;charset="+charset);
			else
			{
				if(contentType.indexOf("charset")==-1)
					contentType += ";charset=" + charset;
				response.setContentType(contentType);
			}
			response.setContentLength((int) fileLen);
			String m_contentDisposition = "attachment;";
			//		m_contentDisposition = m_contentDisposition != null ? m_contentDisposition : "attachment;";
			StringBuffer buf = new StringBuffer();
			buf.append(String.valueOf(m_contentDisposition));
			buf.append(" filename=");
			if(agent.indexOf("Firefox")!=-1)
			{
				String name = MimeUtility.encodeText(destFileName,charset,"B");
				//name = name.replace(" ", "%20");
				buf.append(name);
			}
			else if(agent.indexOf("MSIE")!=-1)
				buf.append(URLEncoder.encode(destFileName,charset));
			else
				buf.append(destFileName);

			response.setHeader("Content-Disposition",String.valueOf(buf));

			while ((long) totalRead < fileLen) {
				readBytes = fileIn.read(b, 0, blockSize);
				totalRead += readBytes;
				response.getOutputStream().write(b, 0, readBytes);
			}

			fileIn.close();
			}catch(java.net.SocketException e)
			{
				try {
					new Log().FileLog(LogAction.download_cancel, sourceFolder, actionuser,siteid);
				} catch (MessageException e1) {
					e1.printStackTrace();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			}
			catch(Exception e)
			{
				System.out.println(e.getMessage());
			}
			finally
			{
				zipfile.delete();
			}
		}
	
	/**
	 * @author wanghailong	
	 * @param request
	 * @param response
	 * @param sourceFilePathName
	 * @param contentType
	 * @param destFileName
	 * @throws IOException
	 * @throws MessageException
	 * @throws SQLException
	 */
	public void downloadBackupFile(HttpServletRequest request,HttpServletResponse response,String sourceFilePathName,String contentType,String destFileName)throws IOException, MessageException, SQLException 
	{
				 
		String agent =  "";
		if(request!=null)
		{
			agent = request.getHeader("User-Agent");
		}
		String filename = sourceFilePathName;			
		if(filename.length()==0) return;		
		File file = new File(filename);
		FileInputStream fileIn = new FileInputStream(file);
		long fileLen = file.length();
		int readBytes = 0;
		int totalRead = 0;
		int blockSize = 2048;
		byte b[] = new byte[blockSize];
		String charset = CmsCache.getDefaultsite().getCharset();
		if(charset.length()==0)
			charset = "utf-8";
		if (contentType == null)
			response.setContentType("application/x-msdownload;charset="+charset);
		else if (contentType.length() == 0)
			response.setContentType("application/x-msdownload;charset="+charset);
		else
		{
			if(contentType.indexOf("charset")==-1)
				contentType += ";charset=" + charset;
			response.setContentType(contentType);
		}
		response.setContentLength((int) fileLen);
		String m_contentDisposition = "attachment;";
		StringBuffer buf = new StringBuffer();
		buf.append(String.valueOf(m_contentDisposition));
		buf.append(" filename=");
		if(agent.indexOf("Firefox")!=-1)
		{
			String name = MimeUtility.encodeText(destFileName,charset,"B");
			buf.append(name);
		}
		else if(agent.indexOf("MSIE")!=-1)
			buf.append(URLEncoder.encode(destFileName,charset));
		else
			buf.append(destFileName);
		response.setHeader("Content-Disposition",String.valueOf(buf));
		try{
		while ((long) totalRead < fileLen)
		{
			readBytes = fileIn.read(b, 0, blockSize);
			totalRead += readBytes;
			response.getOutputStream().write(b, 0, readBytes);
		}
		fileIn.close();
		}
		catch(Exception e)
		{				
				e.printStackTrace();			 
		}
	}
	
	public void zipFiles(File folder,File zipFileName) throws IOException
	{
		//java自带的zip不支持中文,是一个BUG
		//byte[] buf = new byte[1024];
		int folderlen = folder.getPath().length();
		ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipFileName));
		
		out.setEncoding("GBK");
		_zipFiles(folder,out,folderlen,zipFileName);
		out.close();
	}
	
	public void _zipFiles(File folder,ZipOutputStream out,int folderlen,File zipFileName) throws IOException
	{
		if(!canZip(folder)) return;
		
		byte[] buf = new byte[1024];
		File[] files = folder.listFiles();
		if(files!=null && files.length!=0)
		{
			for(int i = 0;i<files.length;i++)
			{//System.out.println("file:"+files[i].getPath()+";"+zipFileName.getPath());
				if(files[i].isDirectory())
				{
					_zipFiles(files[i],out,folderlen,zipFileName);
				}
				else
				{
					if(!files[i].getPath().equals(zipFileName.getPath()) && canZip(files[i]))
					{
						FileInputStream in = new FileInputStream(files[i]);
						//System.out.println("zip:"+files[i].getPath().substring(folderlen));
						ZipEntry entry = new ZipEntry(files[i].getPath().substring(folderlen));
						//entry.setUnixMode(755);
						out.putNextEntry(entry);
				        int len;
				        while ((len = in.read(buf)) > 0) {
				               out.write(buf, 0, len);
				        }
			            out.closeEntry();
			            in.close();
					}
				}
			}
		}
	}
	
	public boolean canZip(File file)
	{
		if(file.isDirectory())
		{
			for (int i = 0; i < ExcludeFolders.size(); i++)
			{
				String folder = (String)ExcludeFolders.get(i);
				folder = folder.replace('/', '\\');
				//System.out.println(file.getPath());System.out.println(folder);
				if(file.getPath().startsWith(folder))	return false;
			}
		}
		else
		{
			for (int i = 0; i < ExcludeFiles.size(); i++)
			{
				String filename = (String)ExcludeFiles.get(i);
				if(file.getPath().startsWith(filename))	return false;
			}	
			
			for (int i = 0; i < ExcludeFileExts.size(); i++)
			{
				String fileext = (String)ExcludeFileExts.get(i);
				
				if(isFileExts(file.getPath(),fileext)) return false;
				
				if(!fileext.startsWith(".")) fileext = "." + fileext;
				if(file.getPath().endsWith(fileext))	return false;
			}	
		}
		return true;
	}
	
	public void addExclude(String type,String s)
	{
		if(type.equals("folder")) ExcludeFolders.add(s);
		else if(type.equals("file")) ExcludeFiles.add(s);
		else if(type.equals("ext")) ExcludeFileExts.add(s);
	}
	/**
	 * 判断filename，是否符合reg规则
	 * 
	 * **/
	public  boolean isFileExts(String filename,String reg){
		reg=reg.replaceAll("\\*","\\\\S*");
		Pattern p=Pattern.compile(reg);
		Matcher m=p.matcher(filename);
		return m.matches();
	}
	
	//解压
	public static void unZipFile(String filename)
	{
		try {
			int i = filename.lastIndexOf("/");
			if(i==-1) return;
			String path = filename.substring(0,i);
			ZipFile zipFile = new ZipFile(filename);     
			java.util.Enumeration<ZipEntry> e = zipFile.getEntries();        
			ZipEntry entry;			     
			InputStream in = null;  
			BufferedOutputStream dest = null;
			while (e.hasMoreElements()) 
			{  
			    entry = (ZipEntry)e.nextElement();  
			    int count;  
			    byte[] data = new byte[1024];   
			    File f = new File(path + "/" + entry.getName());
			    
			    FileOutputStream fos = new FileOutputStream(f);  
			  
			    in = new BufferedInputStream(zipFile.getInputStream(entry));  
			    dest = new BufferedOutputStream(fos);  
			    while ((count = in.read(data, 0,1024)) != -1) {  
			     dest.write(data, 0, count);  
			    }  
			    dest.flush();  
			    dest.close();  
			   }  
			   in.close();  			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (ZipException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	//使用ImageIO压缩图片
	public static void compressImage(String filename1,String filename2,int width,int height)
	{
		File file1 = new File(filename1);
		File file2 = new File(filename2);
		
		try {
			BufferedImage inputImage = ImageIO.read(file1);
			int width1 = inputImage.getWidth();
			int height1 = inputImage.getHeight();
			System.out.println("width1:"+width1+",height1:"+height1);
			if(width==0 && height>0)
			{System.out.println("ok:"+(height* width1)/height1);
				width = (width1*height)/height1;
			}
			if(height==0 && width>0)
			{
				height = (height1 * width)/width1;
			}
			System.out.println("width:"+width+",height:"+height);
			BufferedImage output = new BufferedImage(width, height,BufferedImage.TYPE_INT_RGB);   
			Image image = inputImage.getScaledInstance(output.getWidth(), output.getHeight(), output.getType());   
			output.createGraphics().drawImage(image, null, null);  
			String format = filename2.substring(filename2.lastIndexOf('.') + 1);    
			ImageIO.write(output, format,file2);  
		} catch (IOException e) {
			e.printStackTrace();
		}  
	}

	//使用magickimage缩放图片,不考虑变形
	public static void compressImage2(String filename1,String filename2,int width,int height)
	{
		compressImage2(filename1,filename2,width,height,0);
	}
	
	//使用magickimage缩放图片,flag=1 不变形
	public static void compressImage2(String filename1,String filename2,int width,int height,int flag)
	{
		//File file1 = new File(filename1);
		//File file2 = new File(filename2);
		System.setProperty("jmagick.systemclassloader","no");
		MagickImage scaled = null; 
		
		try {
			 ImageInfo info = new ImageInfo(filename1);  
			 MagickImage image = new MagickImage(info);   
			 Dimension imageDim = image.getDimension();    
             
			int width1 = imageDim.width;
			int height1 = imageDim.height;
			//System.out.println("width1:"+width1+",height1:"+height1);
			if(width==0 && height>0)
			{//System.out.println("ok:"+(height* width1)/height1);
				width = (width1*height)/height1;
			}
			if(height==0 && width>0)
			{
				height = (height1 * width)/width1;
			}
			
			if(width>0 && height>0 && flag==1)
			{
				//防止变形
				float a1 = (float)width/width1;
				float a2 = (float)height/height1;
				if(a1>a2)
				{
					width = (width1*height)/height1;
				}
				else
				{
					height = (height1 * width)/width1;
				}
			}
			
			scaled = image.scaleImage(width, height);
			scaled.setFileName(filename2);   
            scaled.writeImage(info);
            
			if (scaled != null) scaled.destroyImages(); 
			if (image != null) image.destroyImages(); 
            
		} catch (MagickException e) {
			e.printStackTrace(System.out);
		}finally{   
            if(scaled != null){   
                scaled.destroyImages();   
            } 
        } 		
	}
	
	public static String getIM4JAVAPath() throws MessageException, SQLException
	{
		String path = CmsCache.getParameterValue("sys_im4java_path");
		if(path.length()==0)
		{
			//默认为/usr/bin，2015/02/28修改
			path = "/usr/bin";
			//Log.SystemLog("参数配置", "sys_im4java_path需要配置");
		}
		return path;
	}
	
	//使用im4java magickimage缩放图片,flag=1 不变形，如果新的尺寸超过原图，以原图尺寸为主
	//成功返回true，错误返回false
	public static boolean compressImage2IM(String filename1,String filename2,int width,int height,int flag)
	{	
		boolean result = false;
		try {
			//sys_im4java_path im4java执行的cmd路径
			String path = getIM4JAVAPath();
			
			if(path.length()>0) 
				ProcessStarter.setGlobalSearchPath(path);
			else
				return false;
			
			//System.out.println("filename1:"+filename1);
			int[] dim = getSizeByIm4java(filename1);                
			int width1 = dim[0];
			int height1 = dim[1];
			
			if(width1==-1 && height1==-1) return false;
			
			//System.out.println("width1:"+width1+",height1:"+height1);
			if(width==0 && height>0)
			{//System.out.println("ok:"+(height* width1)/height1);
				width = (width1*height)/height1;
			}
			if(height==0 && width>0)
			{
				height = (height1 * width)/width1;
			}
			
			if(width>0 && height>0 && flag==1)
			{
				//防止变形
				float a1 = (float)width/width1;
				float a2 = (float)height/height1;
				if(a1>a2)
				{
					width = (width1*height)/height1;
				}
				else
				{
					height = (height1 * width)/width1;
				}
			}
			
			//如果新的尺寸超过原图，以原图尺寸为主
			if(width>width1 || height>height1)
			{
				width = width1;
				height = height1;
			}
			
			ConvertCmd cmd = new ConvertCmd();
			IMOperation op = new IMOperation();
			
			ArrayListOutputConsumer output = new ArrayListOutputConsumer();
			cmd.setOutputConsumer(output);
			ArrayList<String> cmdOutput = output.getOutput();
			/*
			String o = "";
			for(int i = 0;i<cmdOutput.size();i++)
				o += (String)cmdOutput.get(i);
			*/
			op.addImage(filename1);
			op.resize(width,height);
			op.addImage(filename2);

			// execute the operation
			cmd.run(op);
			result = true;
		} catch (Exception e) {
			result = false;
			e.printStackTrace(System.out);
		}finally{   
        } 	
		
		return result;
	}
	
	//利用im4java获取图片尺寸，宽和高   如果宽高都是-1，就是读取失败
	public static int[] getSizeByIm4java(String filename) throws MessageException, SQLException
	{
		int[] ii = {-1,-1};
		String path = "";
		path = getIM4JAVAPath();
		
		IdentifyCmd cmd = new IdentifyCmd();
		IMOperation op = new IMOperation();
		//op.format("width:%w,height:%h,path:%d%f,size:%b%[EXIF:DateTimeOriginal]");
		op.format("%w,%h");
		op.addImage(filename);
		if(path.length()>0)	cmd.setSearchPath(path);

		ArrayListOutputConsumer output = new ArrayListOutputConsumer();
		cmd.setOutputConsumer(output);

		try {
			cmd.run(op);
			ArrayList<String> cmdOutput = output.getOutput();
			
			String o = "";
			for(int i = 0;i<cmdOutput.size();i++)
				o += (String)cmdOutput.get(i);
			//System.out.println("output:"+o);
			String[] s = Util.StringToArray(o,",");//如果文件名有空格，会出问题，需要设置op.format
			if(s.length==2)
			{
				//String size = s[2];
				//int index = size.indexOf("x");
				ii[0] = Util.parseInt(s[0]);
				ii[1] = Util.parseInt(s[1]);
			}
		} catch (IOException e) {
			e.printStackTrace();
			Log.SystemLog("图片处理", cmd.getCommand()+","+e.getMessage());
		} catch (InterruptedException e) {
			e.printStackTrace();
			Log.SystemLog("图片处理", cmd.getCommand()+","+e.getMessage());
		} catch (IM4JavaException e) {
			e.printStackTrace();
			if(e.getMessage().contains("java.io.FileNotFoundException: identify"))
				Log.SystemLog("图片处理", "图片压缩工具没有安装，请检查. "+cmd.getCommand()+","+e.getMessage());
			else
				Log.SystemLog("图片处理", cmd.getCommand()+","+e.getMessage());
		}

		return ii;
	}
	
	//优化图片文件，减小文件大小
	public static boolean optimizeImage(String filename) throws MessageException, SQLException
	{
		boolean result = false;
		
		//gif文件不做处理
		if(filename.toLowerCase().endsWith(".gif")) return true;
		
		String path = getIM4JAVAPath();
		
		//convert -strip -interlace Plane -quality 80 source.jpg result.jpg		
		ConvertCmd cmd = new ConvertCmd();
		IMOperation op = new IMOperation();
		op.quality(80d);
		op.strip();
		op.interlace("Plane");
		
		op.addImage(filename);
		op.addImage(filename);
		if(path.length()>0)	cmd.setSearchPath(path);		
		
		try {
			cmd.run(op);
			//System.out.println("optimize:"+op.toString()+","+cmd.toString());
		} catch (Exception e) {
			//e.printStackTrace();
			StringWriter sw = new StringWriter();
	        PrintWriter pw = new PrintWriter(sw);
	        e.printStackTrace(pw);
			String message = sw.toString();
			if(message.contains("FileNotFoundException"))
				Log.SystemLog("图片处理", "图片压缩工具没有安装或路径不对，请检查. " + message);
			else
				Log.SystemLog("图片处理", message);
			result = false;
		}
		
		return result;
	}
	
	//图片锐化 2015/02/28 修改
	public static boolean sharpenImage(String filename) throws MessageException, SQLException
	{
		boolean result = false;
		
		String path = getIM4JAVAPath();
		ConvertCmd cmd = new ConvertCmd();
		IMOperation op = new IMOperation();
		op.sharpen(1.0,5.0);		
		op.addImage(filename);
		op.addImage(filename);
		if(path.length()>0)	cmd.setSearchPath(path);		
		
		try {
			cmd.run(op);
			//System.out.println("optimize:"+op.toString()+","+cmd.toString());
		} catch (Exception e) {
			//e.printStackTrace();
			StringWriter sw = new StringWriter();
	        PrintWriter pw = new PrintWriter(sw);
	        e.printStackTrace(pw);
			String message = sw.toString();
			if(message.contains("FileNotFoundException"))
				Log.SystemLog("图片处理", "图片压缩工具没有安装或路径不对，请检查. " + message);
			else
				Log.SystemLog("图片处理", message);
			result = false;
		}
		
		return result;
	}
	//添加水印 使用Im4java 从数据库中获取水印方案
	public static boolean waterMaskByIm4java(String filename,int waterid,String location) throws MessageException, SQLException
	{
		boolean success = true;
		Watermark watermark = new Watermark(waterid);
		String im4java_path = getIM4JAVAPath();
		
		try {
			String maskfile = watermark.getWaterMark();
			//System.out.println("maskfile:"+maskfile);
			int mask_width = watermark.getWidth();
			int mask_height = watermark.getHeight();
			int mask_offsetx = watermark.getLogoLeft();
			int mask_offsety = watermark.getLogoTop();
			int dissolve = watermark.getDissolve();
			int status = watermark.getStatus();
			if(status!=1) return false;
			
			String gravity = "NorthWest";
			if(location.equals("lefttop"))  
			{  
				gravity = "NorthWest";
			}  
			else if(location.equals("righttop"))  
			{  
				gravity = "NorthEast";
				//mask_offsetx = -mask_offsetx;
			}  
			else if(location.equals("middle"))  
			{  
				gravity = "Center";
				mask_offsetx = 0;
				mask_offsety = 0;
			}
			else if(location.equals("leftbottom"))
			{
				gravity = "SouthWest";
				//mask_offsety = - mask_offsety;
			}
			else if(location.equals("rightbottom"))  
			{  
				gravity = "SouthEast";
				//mask_offsetx = -mask_offsetx;
				//mask_offsety = -mask_offsety;
			} 			
			
			File mfile = new File(maskfile);
			if(mfile.exists())
			{
				IMOperation op = new IMOperation();
				op.gravity(gravity);
				op.dissolve(dissolve);
				op.geometry(mask_width,mask_height,mask_offsetx,mask_offsety);
				op.addImage(maskfile);//水印图片
				op.addImage(filename);//原图片
				op.addImage(filename);//目标图片
				CompositeCmd cmd = new CompositeCmd();
				cmd.setSearchPath(im4java_path);
				cmd.run(op);				
			}
			else
			{
				success = false;
				ErrorLog.Log("图片处理", "图片水印文件不存在,地址："+mfile.getPath(), "");
				return false;
			}

		} catch (IOException e) {
			success = false;
			e.printStackTrace(System.out);
		} catch (InterruptedException e) {
			success = false;
			e.printStackTrace(System.out);
		} catch (IM4JavaException e) {
			success = false;
			e.printStackTrace(System.out);
		}		
		
		return success;		
	}
	
	//添加水印 使用Im4java
	public static boolean waterMaskByIm4java(String filename,String location) throws MessageException, SQLException
	{
		boolean success = true;
		
		String watermask = CmsCache.getParameterValue("sys_watermask");//一个json串
		
		if(watermask.length()==0){ErrorLog.Log("图片处理", "图片水印参数sys_watermask没有配置", "");return false;}
		
		String im4java_path = getIM4JAVAPath();
		
		try {
			JSONObject o = new JSONObject(watermask);
			String maskfile = o.getString("path");
			//System.out.println("maskfile:"+maskfile);
			int mask_width = o.getInt("width");
			int mask_height = o.getInt("height");
			int mask_offsetx = o.getInt("offsetx");
			int mask_offsety = o.getInt("offsety");
			int dissolve = o.getInt("dissolve");
			int status = o.getInt("status");
			
			if(status!=1) return false;
			
			String gravity = "NorthWest";
			if(location.equals("lefttop"))  
			{  
				gravity = "NorthWest";
			}  
			else if(location.equals("righttop"))  
			{  
				gravity = "NorthEast";
				//mask_offsetx = -mask_offsetx;
			}  
			else if(location.equals("middle"))  
			{  
				gravity = "Center";
				mask_offsetx = 0;
				mask_offsety = 0;
			}
			else if(location.equals("leftbottom"))
			{
				gravity = "SouthWest";
				//mask_offsety = - mask_offsety;
			}
			else if(location.equals("rightbottom"))  
			{  
				gravity = "SouthEast";
				//mask_offsetx = -mask_offsetx;
				//mask_offsety = -mask_offsety;
			} 			
			
			File mfile = new File(maskfile);
			if(mfile.exists())
			{
				IMOperation op = new IMOperation();
				op.gravity(gravity);
				op.dissolve(dissolve);
				op.geometry(mask_width,mask_height,mask_offsetx,mask_offsety);
				op.addImage(maskfile);//水印图片
				op.addImage(filename);//原图片
				op.addImage(filename);//目标图片
				CompositeCmd cmd = new CompositeCmd();
				cmd.setSearchPath(im4java_path);
				cmd.run(op);				
			}
			else
			{
				success = false;
				ErrorLog.Log("图片处理", "图片水印文件不存在,地址："+mfile.getPath(), "");
				return false;
			}

		} catch (JSONException e1) {
			e1.printStackTrace(System.out);
			success = false;
		} catch (IOException e) {
			success = false;
			e.printStackTrace(System.out);
		} catch (InterruptedException e) {
			success = false;
			e.printStackTrace(System.out);
		} catch (IM4JavaException e) {
			success = false;
			e.printStackTrace(System.out);
		}		
		
		return success;		
	}
	
	//添加水印
	public static boolean waterMask(String filename,String location)
	{
		boolean success = true;
		System.setProperty("jmagick.systemclassloader","no");
		ImageInfo imageinfo;
		try {
			String maskfile = CmsCache.getParameterValue("sys_watermask_file");
			
			File mfile = new File(maskfile);
			if(mfile.exists())
			{
				imageinfo = new ImageInfo(filename);
				MagickImage mask = new MagickImage(new ImageInfo(maskfile));
				MagickImage image = new MagickImage(imageinfo);
				int w = image.getDimension().width;
				int h = image.getDimension().height;
				int w1 = mask.getDimension().width;
				int h1 = mask.getDimension().height;
				int x = w-10-w1;
				int y = h-10-h1;
				
				if(location.equals("lefttop"))  
				{  
					x = 10;y = 10;
				}  
				else if(location.equals("righttop"))  
				{  
					y = 10;
				}  
				else if(location.equals("middle"))  
				{  
					x = (w - w1)/2;y = (h - h1)/2; 
				}
				else if(location.equals("leftbottom"))
				{
					x = 10;
				}
				
				image.compositeImage(CompositeOperator.AtopCompositeOp,mask,x,y);
				image.writeImage(imageinfo);

				if (mask != null) mask.destroyImages(); 
				if (image != null) image.destroyImages(); 				
			}
			else
				success = false;
		} catch (MagickException e) {
			success = false;
			e.printStackTrace();
		} catch (MessageException e) {
			success = false;e.printStackTrace();
		} catch (SQLException e) {
			success = false;e.printStackTrace();
		}
		
		return success;		
	}
	
	public static boolean FtpUpload(FTPClient ftp,String localfile,String remotefile) throws IOException
	{
		boolean copy_success = false;
		if(!remotefile.startsWith("/")) remotefile = "/" + remotefile;
		String 	FileSeparator = "/";//文件名分隔符,unix "/" windows "\"
		//文件名，不包括目录
		String OnlyFileName = localfile.substring(localfile.lastIndexOf(FileSeparator)+1);
		InputStream is = null;
		File file = null;
		try {
			file = new File(localfile);
			is = new FileInputStream(file);
		} catch (FileNotFoundException e1) {
			copy_success = false;
			return copy_success;
		}
		System.out.println("remotefile:"+remotefile);
		String tempStr = remotefile;
		String Directory = "";
		int position = 0;
		
		position = tempStr.lastIndexOf(FileSeparator);
		if(position!=-1)
		{
			Directory = remotefile.substring(0,position);//文件目录	
			//System.out.println("Directory:"+Directory);
			if(!ftp.changeWorkingDirectory(Directory))
			{//转到此目录失败
				position = tempStr.indexOf(FileSeparator);
				while(position!=-1)
				{
					Directory = tempStr.substring(0,position);
					tempStr = tempStr.substring(position+1);
					position = tempStr.indexOf(FileSeparator);
					
					if(!Directory.equals(""))
					{
						if(!ftp.changeWorkingDirectory(Directory))
						{//System.out.println("mske dir:"+Directory);
							ftp.makeDirectory(Directory);
							ftp.changeWorkingDirectory(Directory);
						}
					}
					//System.out.println("Directory:"+Directory);
				}				
			}
		}
		System.out.println("work:"+ftp.printWorkingDirectory());
		if(is!=null)
		{	
				boolean storefile = false;
				System.out.println("开始上传" + OnlyFileName);
				storefile = ftp.storeFile(OnlyFileName,is);
				System.out.println("上传结果" + storefile);								
				if(!storefile)
				{
					copy_success = false;
					System.out.println("上传失败,文件:"+localfile);
				}
				else
					copy_success = true;
		} 
		
		is.close();
		
		return copy_success;		
	}
	
	public static boolean FtpCopy(FTPClient ftp,String filename,String filename2) throws IOException
	{
		return FtpUpload(ftp,filename,filename2);		
	}
		
    public static boolean FtpCopy(String server,String username,String password,String filename,String filename2) throws SocketException, IOException
    {//System.out.println(FileName);
    	
    	FTPClient ftp= getFtpClient(server,username,password);
		
		return FtpCopy(ftp,filename,filename2);
    }
    
    public static boolean copyFile(String source,String dest)
    {
    	boolean result = false;
    	FileInputStream in =null;  
        FileOutputStream out =null;  
        byte[] buffer = new byte[102400];
        try {
			in = new FileInputStream(source);
			File destf = new File(dest);
			if(!destf.exists())
			{//目标文件对应的目录不存在，创建新的目录  
                int index = new String(dest).lastIndexOf("/");  
                String path = dest.substring(0, index);  
                new File(path).mkdirs();  
            }  
			out = new FileOutputStream(dest); 
			int num =0;  
            while((num=in.read(buffer))!=-1){  
                out.write(buffer,0,num);  
            }
            result = true;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		finally{  
            try {  
                if(in!=null)  
                    in.close();  
                if(out!=null)  
                    out.close();  
            } catch (IOException ex){}              
        }  
        
    	return result;
    }
   
    public static FTPClient getFtpClient(String server,String username,String password) throws SocketException, IOException
    {
    	return getFtpClient(server,21,username,password,0);
    }
    
    public static FTPClient getFtpClient(String server,String username,String password,int mode) throws SocketException, IOException
    {
    	return getFtpClient(server,21,username,password,mode);
    }
    
    public static FTPClient getFtpClient(String server,int port,String username,String password,int mode) throws SocketException, IOException
    {
    	FTPClient ftp=new FTPClient();

		ftp.setDefaultTimeout(40000);
		ftp.setDefaultPort(port);
		ftp.connect(server);
		ftp.login(username,password);
		ftp.setSoTimeout(40000);
		ftp.setConnectTimeout(40000);
		ftp.setFileType(FTPClient.BINARY_FILE_TYPE);

		if(mode==1)
			ftp.enterLocalPassiveMode();
		
		String FtpRoot = ftp.printWorkingDirectory();		
		ftp.changeWorkingDirectory(FtpRoot);
		return ftp;
    }
    
    //ftp 下载 filename 远程文件 filename2 本地文件
    //result 0 失败 1成功 2 文件不存在 3 登录不上
	public static int FtpDownload(FTPClient ftp,String remotefile,String localfile)
	{
		int result = 0;
		
		if(!remotefile.startsWith("/")) remotefile = "/" + remotefile;
		
		if(ftp==null || !ftp.isConnected())
			return 3;
		
		try {
		if(ftp.listFiles(remotefile).length==0)
		{
			//文件不存在
			return 2;
		}
		
		localfile = localfile.replace('\\', '/');
		int i = localfile.lastIndexOf("/");
		String localfolder = localfile.substring(0,i);
		System.out.println("localfolder:"+localfolder);
		File folder = new File(localfolder);
		if(!folder.exists()) folder.mkdirs();
		folder = null;
		File file = new File(localfile);
		FileOutputStream fos = new FileOutputStream(file); 
		if(ftp.retrieveFile(remotefile, fos))
			result = 1;
		
		} catch (IOException e) {
			e.printStackTrace();
			return 2;
		}
		return result;
	}    
	
	//解压rar文件
	public static boolean unRarFile(File file,boolean rewrite)
	{
		//System.out.println("unrar:"+file.getPath());
        try {
            Archive archive = new Archive(file); 
            FileHeader fh = archive.nextFileHeader();
            //System.out.println(file.getPath());
            int i = file.getPath().lastIndexOf("/");
            String root = "";
            if(i==-1)
            	return false;
            root = file.getPath().substring(0,i);
            //System.out.println(file.getPath()+","+root);
            while(fh!=null){
            	
            	String newfile = Util.ClearPath(root + "/" + fh.getFileNameString().trim());
            	File nf = new File(Util.getFilePath(newfile));
            	if(!nf.exists()) nf.mkdirs();
            	//System.out.println("fh:"+fh.getFileNameString()+","+newfile);
            	
            	File out = new File(newfile);
            	if(!fh.isDirectory())
            	{            		
            		//System.out.println(out.getAbsolutePath());
            		if(!out.exists() || rewrite)
            		{
            			//System.out.println("newfile:"+newfile);
            			FileOutputStream os = new FileOutputStream(out);
            			archive.extractFile(fh, os);
            			os.close();
            		}
            	}
            	fh=archive.nextFileHeader();
            } 
            archive.close();
            return true;
        } catch (Exception e) {  
            e.printStackTrace(System.out);
            System.out.println(e.getMessage());
            return false;
        }  
	}
	
	public int getActionuser() {
		return actionuser;
	}

	public void setActionuser(int actionuser) {
		this.actionuser = actionuser;
	}	
}