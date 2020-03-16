package tidemedia.cms.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Field;
import tidemedia.cms.system.Log;

public class DocumentExport implements Runnable{

	private int channelid = 0;
	private int include_subchannel = 0;//是否包括子频道
	private int doc_number = 0;//导出文章条数
	
	private Thread 	runner;
	private static String message = "";//进程信息
	private ArrayList<Integer> arraylist = new ArrayList<Integer>();
	private String root_path = "";
	
	public void Start()
	{
		setMessage(Util.getCurrentDate("MM-dd HH:mm:ss")+" 引擎启动");
		
		Channel channel;
		try {
			root_path = getClass().getClassLoader().getResource("../../").getPath() + "temp/" + channelid;
			channel = CmsCache.getChannel(channelid);
			ArrayList<Integer> arraylist_ = channel.listAllSubChannelIDs();

			arraylist = (ArrayList<Integer>) arraylist_.clone();
			
			arraylist.add(new Integer(channelid));
			
			System.out.println("arraylist:"+arraylist.size());
		} catch (MessageException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		 
		if(doc_number<=1000)
		{
			run();
		}
		else
		{
			if(runner==null)
			{
		        runner = new Thread(this);
		        runner.start();
			}
		}
	}
	
	@Override
	public void run() {
		Channel c;
		try {
		c = CmsCache.getChannel(channelid);
		Log.SystemLog("文章导出", "导出文章开始，频道："+channelid+","+c.getName()+",子频道："+arraylist.size());
		System.out.println("arraylist1:"+arraylist.size());
		while(arraylist.size()>0) {
			int cid = (Integer) arraylist.get(0);
			ExportDocument(cid);
		}
		
		//打包
		String zip = root_path + ".zip";
		File zipfile = new File(zip);
		
		try {
			new FileUtil().zipFiles(new File(root_path+"/"),zipfile);
		} catch (IOException e) {
			e.printStackTrace(System.out);
		}
		
		Log.SystemLog("文章导出", "结束导出文章，频道："+channelid+","+c.getName());
		} catch (MessageException | SQLException e) {
			e.printStackTrace(System.out);
		}	
	}

	public void ExportDocument(int channelid) throws MessageException, SQLException
	{
		Channel channel = CmsCache.getChannel(channelid);
		System.out.println("频道："+channel.getName()+" 开始导出文章");
		String sql = "select id from "+channel.getTableName()+" where Active=1";
		if(channel.getType()==1)
			sql += " and Category="+channelid;
		else
			sql += " and Category=0";
		
		sql += " order by OrderNumber,id limit " + doc_number;
		//System.out.println(sql);
		
		int num = 0;
		boolean exist = false;
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next())
		{
			exist = true;
			int itemid = rs.getInt("id");
			//System.out.println("id:"+itemid);
			Document doc = CmsCache.getDocument(itemid, channelid);			
			
			ExportOneDocument(doc,channelid);
			num ++;
		}
		tu.closeRs(rs);
		System.out.println("频道："+channel.getName()+" 结束导出文章，导出数量："+num);
		int a = arraylist.size();
		//没有可导出文章了
		//if(!exist)
		//{
			arraylist.remove((Integer)channelid);
		//}
		//System.out.println("size:"+a+","+arraylist.size());
	}
	
	public void ExportOneDocument(Document doc,int channelid) throws MessageException, SQLException
	{
		String path = root_path + "/" + channelid;
		//System.out.println("doc:"+doc.getTitle()+",path:"+path);
		File file = new File(path);
		if(!file.exists())
			file.mkdirs();
		
		org.dom4j.Document xml = DocumentHelper.createDocument();
		xml.addComment("文章信息，创建时间："+Util.getCurrentDateTime());
		Element root = xml.addElement("root");
		
		root.addElement("ChannelID").setText(channelid+"");
		root.addElement("Status").setText(doc.getStatus()+"");
		root.addElement("TotalPage").setText(doc.getTotalPage()+"");
        
		Channel channel = CmsCache.getChannel(channelid);
		ArrayList<Field> arraylist = channel.getFieldInfo();
		for (int i = 0; i < arraylist.size(); i++){
			Field f = (Field) arraylist.get(i);
			String fieldname = f.getName();
			String value = doc.getValue(fieldname);
			value = value.replaceAll("[\\x00-\\x08\\x0b-\\x0c\\x0e-\\x1f]", "") ;
			Element e = root.addElement(fieldname);
	        e.setText(value);
		}
        
		String file_path = path + "/" + doc.getId() + ".xml";
		//System.out.println("xml:"+path);
		OutputFormat format = OutputFormat.createPrettyPrint();
		format.setEncoding("utf-8");
		try {
			//Writer out = new FileWriter(file_path);
			XMLWriter writer = new XMLWriter(new FileOutputStream(new File(file_path)), format);
			//XMLWriter writer = new XMLWriter(out, format);
			writer.write(xml);
			writer.close();
		} catch (IOException e) {
			ErrorLog.SaveErrorLog("导出文档信息",e.getMessage(),channel.getId(),e);
			e.printStackTrace(System.out);
		}
	}
	
	public int getChannelid() {
		return channelid;
	}

	public void setChannelid(int channelid) {
		this.channelid = channelid;
	}

	public int getInclude_subchannel() {
		return include_subchannel;
	}

	public void setInclude_subchannel(int include_subchannel) {
		this.include_subchannel = include_subchannel;
	}

	public static String getMessage() {
		return message;
	}

	public static void setMessage(String message) {
		DocumentExport.message = message;
	}

	public int getDoc_number() {
		return doc_number;
	}

	public void setDoc_number(int doc_number) {
		this.doc_number = doc_number;
	}

}
