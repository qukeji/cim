package tidemedia.cms.excel;

import java.io.File;

import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Properties;
import java.util.Random;
import java.util.Scanner;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.exception.ParseErrorException;
import org.apache.velocity.exception.ResourceNotFoundException;
import org.apache.velocity.exception.VelocityException;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.publish.Publish;
import tidemedia.cms.publish.PublishManager;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelTemplate;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Log;
import tidemedia.cms.system.TemplateFile;
import tidemedia.cms.util.Util;

public class ExcelDriver {
	private String ErrorMessage = "";
	private int ErrorChannelID = 0;

	public String getflag_random() {
		Random r = new Random();
		String Aa = "abcdefghijklmnopqrstwvuxyzABCDEFGHIJKLMNOPQRSTWVUXYZ";
		String flag = "";

		for (int i = 0; i < 8; i++) {
			int random = r.nextInt(51);
			if (random != 0) {
				flag += Aa.substring(random - 1, random);
			} else {
				flag += Aa.substring(random, random + 1);
			}
		}
		return flag;
	}

	public String getflag_excel_name() {
		String excel_name = "";
		long date = System.currentTimeMillis() / 1000;
		excel_name = "excel_" + date + "";
		return excel_name;
	}

	public String templateMerge(int ChannelID,
			String FileName, ChannelTemplate ct, String Charset,String tomcatPath,int templateFileId)
			throws MessageException, SQLException {
		
		VelocityContext context = new VelocityContext();
		tidemedia.cms.system.Controller controller = new tidemedia.cms.system.Controller();
		controller.setChannelID(ChannelID);
		controller.setPublishMode(2);
		int Rows = ct.getRows();
		int TitleWord = ct.getTitleWord();
		//String TemplateName = ct.getTemplateFile().getName();
		//String TargetName = ct.getTargetName();
		controller.init();
		
		context.put("Controller", controller);
		context.put("channel", controller.getChannel());
		context.put("util", new Util());
		context.put("Rows", new Integer(Rows));
		context.put("rows", new Integer(Rows));
		context.put("label", ct.getLabel());
		context.put("TitleWord", new Integer(TitleWord));
		context.put("template", ct.getBean());
		Properties p = new Properties();
		p.setProperty("resource.loader", "test");
		p.setProperty("test.resource.loader.class",
				"tidemedia.cms.publish.TideResourceLoader");
		p.setProperty("runtime.log.logsystem.class",
				"org.apache.velocity.runtime.log.NullLogSystem");
		Channel channel = new Channel(ChannelID);
		VelocityEngine ve = new VelocityEngine();
		ve.init(p);

		String fullFileName = Util.ClearPath(tomcatPath+"/temp/" + FileName);
		File file = new File(fullFileName);
		// boolean flag=file.mkdirs();
		// System.out.println(fullFileName+"---------------------"+flag);
		//PublishManager.getInstance().waitFor(fullFileName, 1);

		Template template = null;
		try {
			//System.out.println("+++++" + ct.getTemplateFile().getContent());
			
			if(templateFileId!=0){
			//	System.out.println("----用模板文件id获得");
				template=ve.getTemplate(new TemplateFile(templateFileId).getContent(),
				"utf-8");
			}else{
			//System.out.println("-----------用频道模id获得");
				template = ve.getTemplate(ct.getTemplateFile().getContent(),
				"utf-8");
			}
			Writer writer = new OutputStreamWriter(new FileOutputStream(
					fullFileName), Charset);
			template.setEncoding(Charset);
			template.merge(context, writer);
			writer.flush();
			writer.close();

			// PublishManager.getInstance().clearFileName(1);
			//
			// InsertToBePublished(FileName, SiteFolder, this.channel);
			//new Publish(ChannelID).addToGenerateFiles(FileName, 0, ChannelID,
			//		ct.getTemplateID(), 1, channel.getSiteID());
		} catch (ResourceNotFoundException e) {
			ErrorLog.SaveErrorLog("没有找到模板文件.", this.ErrorMessage,
					this.ErrorChannelID, e);
			return "";
		} catch (ParseErrorException e) {
			ErrorLog.SaveErrorLog("模板语言解析错误.", this.ErrorMessage,
					this.ErrorChannelID, e);
			return "";
		} catch (VelocityException e) {
			ErrorLog.SaveErrorLog("模板处理错误.", this.ErrorMessage,
					this.ErrorChannelID, e);
			return "";
		} catch (IOException e) {
			ErrorLog.SaveErrorLog("IO错误.", this.ErrorMessage,
					this.ErrorChannelID, e);
			return "";
		} catch (Exception e) {
			ErrorLog.SaveErrorLog("其他错误.", this.ErrorMessage,
					this.ErrorChannelID, e);
			e.printStackTrace(System.out);
			return "";
		}
		return fullFileName;
	}

	public HashMap exportExcell(String html_path, int userid,String tomcatpath,String Html_txt)
			 {
		try{
		HashMap map = new HashMap();
		File file = new File(html_path);
		if (!file.exists()&&(Html_txt.equals("")||Html_txt==null)) {
			Log.SystemLog("Excel导出", "模板文件:" + html_path + " 不存在！");
		}else if(html_path.equals("")&&Html_txt!=null&&!Html_txt.equals("")){
			StringBuilder html = new StringBuilder();
			html.append(Html_txt);
			String newfilename = getflag_excel_name() + ".xls";
			String newfile_path = tomcatpath+"/temp/" + newfilename;
			File file_output = new File(newfile_path);
			if (file_output.exists()) {
				file_output.delete();
			}
			file_output.createNewFile();
			FileOutputStream fout = new FileOutputStream(newfile_path);
			fout.write(TableToXls.process(html));
			fout.close();
			map.put("template", html_path);
			map.put("excel_path", newfile_path);
			map.put("excel_folder", tomcatpath+"/temp/");
			map.put("excelname", newfilename);
			return map;
		} else {
			StringBuilder html = new StringBuilder();
			FileReader fr = new FileReader(html_path);
			Scanner s = new Scanner(fr);
			while (s.hasNext()) {
				// System.out.println(s.nextLine());
				html.append(s.nextLine());
			}
			s.close();
			String newfilename = getflag_excel_name() + ".xls";
			String newfile_path = tomcatpath+"/temp/" + newfilename;
			File file_output = new File(newfile_path);
			if (file_output.exists()) {
				file_output.delete();
			}
			file_output.createNewFile();
			FileOutputStream fout = new FileOutputStream(newfile_path);
			fout.write(TableToXls.process(html));
			fout.close();
			map.put("template", html_path);
			map.put("excel_path", newfile_path);
			map.put("excel_folder", tomcatpath+"/temp/");
			map.put("excelname", newfilename);
			return map;
		}
			return null;
		}catch(Exception e){
			e.printStackTrace();
			Log.SystemLog("Excel导出", "生成Excel文件异常，错误信息："+e.toString()+"");
			return null;
		}
	}

	public static void main(String[] args) throws MessageException, IOException {
		StringBuilder html = new StringBuilder();
		FileReader fr=new FileReader("sample.html");
		Scanner s = new Scanner(fr);
		while (s.hasNext()) {
			html.append(s.nextLine());
		}
		s.close();
		File file=new File("data.xls");
		if(file.exists()){
			file.delete();
		}
		file.createNewFile();
		FileOutputStream fout = new FileOutputStream("data.xls");
		fout.write(TableToXls.process(html));
		fout.close();
	}
}
