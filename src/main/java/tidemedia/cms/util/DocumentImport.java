package tidemedia.cms.util;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Field;
import tidemedia.cms.system.FieldGroup;
import tidemedia.cms.system.Log;

public class DocumentImport implements Runnable{

	private String filename = "";//根据文件名得到导入文章的原频道编号
	private int old_channelid = 0;//原来的频道编号
	private int now_channelid = 0;//现在的频道编号
	private int include_subchannel = 0;//是否包括子频道
	private int doc_number = 0;//导出文章条数
	private int	userid = 0;
	
	private Thread 	runner;
	private static String message = "";//进程信息
	private ArrayList arraylist = new ArrayList();
	private String root_path = "";
	private HashMap map_channel = new HashMap();//老频道id，新频道id
	
	public void Start()
	{
		setMessage(Util.getCurrentDate("MM-dd HH:mm:ss")+" 引擎启动");
		
		Channel channel;
		try {
			//导入文章的目录 /temp/import/channelid/
			System.out.println("导入文章");
			
			old_channelid = Util.parseInt(filename);//Util.parseInt(filename.replace(".xml", "").replace("channel_", ""));
			root_path = getClass().getClassLoader().getResource("../../").getPath() + "temp/import/" + old_channelid;
			//System.out.println("old_channelid:"+old_channelid+","+map_channel);
			int now_channelid = (int) map_channel.get(old_channelid);
			System.out.println("old channel:"+old_channelid+",now channel:"+now_channelid);
			channel = CmsCache.getChannel(now_channelid);

		} catch (MessageException e) {
			e.printStackTrace(System.out);
		} 
		 
		if(runner==null)
		{
	        runner = new Thread(this);
	        runner.start();
		}
	}
	
	@Override
	public void run() {
		Channel c;
		try {
		c = CmsCache.getChannel(now_channelid);
		Log.SystemLog("文章导入", "导导入文章开始，频道："+now_channelid+","+c.getName()+",子频道："+arraylist.size());
		boolean need_import = true;
		while(need_import) {
			String import_file = getImportFile();
//			System.out.println("import_file:"+import_file);
			if(import_file.length()==0)
				need_import = false;
			else
			{
				ImportOneDocument(import_file);
			}
		}
		//文章导入结束，删除解压后的文件夹
		File dir = new File(root_path);
		deleteFile(dir);
		Log.SystemLog("文章导入", "结束导入文章，频道："+now_channelid+","+c.getName());
		} catch (MessageException | SQLException e) {
			e.printStackTrace(System.out);
		}	
	}
	
	//删除文件夹
    public static void deleteFile(File file) {
        if(file.exists()) {//判断路径是否存在
            if(file.isFile()){//boolean isFile():测试此抽象路径名表示的文件是否是一个标准文件。
                file.delete();
            }else{//不是文件，对于文件夹的操作
                //保存 路径D:/1/新建文件夹2  下的所有的文件和文件夹到listFiles数组中
                File[] listFiles = file.listFiles();//listFiles方法：返回file路径下所有文件和文件夹的绝对路径
                for (File file2 : listFiles) {
                    /*
                     * 递归作用：由外到内先一层一层删除里面的文件 再从最内层 反过来删除文件夹
                     *    注意：此时的文件夹在上一步的操作之后，里面的文件内容已全部删除
                     *         所以每一层的文件夹都是空的  ==》最后就可以直接删除了
                     */
                    deleteFile(file2);
                }
            }
            file.delete();
        }else {
            System.out.println("该file路径不存在！！");
        }
    }
	
	public String getImportFile()
	{
		File dir = new File(root_path);
		File[] files = dir.listFiles(); 
        if (files == null) 
        {
        	return "";
        }
        
        for (int i = 0; i < files.length; i++) { 
            if (files[i].isDirectory()) { 
                File[] files_ = files[i].listFiles();
 //               if(files_!=null) System.out.println(files[i].getAbsolutePath()+",files:"+files.length);
 //               else System.out.println(files[i].getAbsolutePath());
                if(files_!=null && files_.length>0)
                	return files_[0].getAbsolutePath();
            }
        }
        
        return "";
	}
	
	public void ImportOneDocument(String filename) throws MessageException, SQLException
	{
		//String path = root_path + "/" +"doc_"+channelid;
		File file = new File(filename);
		if(!file.exists())
			return;
		
		//System.out.println("ImportOneDocument userid:"+getUserid());
		SAXReader reader = new SAXReader();             
	    try {
	    	org.dom4j.Document xml_document = reader.read(file);
			Element root = xml_document.getRootElement();
			
			HashMap map = new HashMap();
			Document doc = new Document();
			doc.setUser(getUserid());
			doc.setModifiedUser(getUserid());
			
			List<Element> listElement=root.elements();//所有一级子节点的list  
			for(Element e:listElement){//遍历所有一级子节点  
				if(e.getName().equals("ChannelID"))
				{
					int now_channelid_ = (int) map_channel.get(Util.parseInt(e.getStringValue()));
					//System.out.println("one doc:"+e.getStringValue()+",now channelid:"+now_channelid_);
					doc.setChannelID(now_channelid_);
				}
				else if(e.getName().equals("PublishDate"))
				{
					String d = e.getStringValue();//Util.FormatTimeStamp("", Util.parseLong(e.getStringValue()));
					if(!d.contains("-")){//说明是时间戳，需要转换格式
						d = Util.FormatTimeStamp("", Util.parseLong(d));
					}
					map.put(e.getName(), d);
				}
				else if(e.getName().equals("TotalPage"))
				{
					map.put("Page", e.getStringValue());
				}
				else
					map.put(e.getName(), e.getStringValue());
			}  
			
			//System.out.println(map);
			
			
			doc.AddDocument(map);
			
			file.delete();
		} catch (DocumentException | IOException | ParseException e) {
			ErrorLog.SaveErrorLog("导入频道",e.getMessage(),0,e);
			e.printStackTrace(System.out);
		} 
	}
	

	public static String getMessage() {
		return message;
	}

	public static void setMessage(String message) {
		DocumentImport.message = message;
	}

	public int getDoc_number() {
		return doc_number;
	}

	public void setDoc_number(int doc_number) {
		this.doc_number = doc_number;
	}

	public HashMap getMap_channel() {
		return map_channel;
	}

	public void setMap_channel(HashMap map_channel) {
		this.map_channel = map_channel;
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public int getUserid() {
		return userid;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}

}
