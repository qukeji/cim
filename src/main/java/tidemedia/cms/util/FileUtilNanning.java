package tidemedia.cms.util;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLException;

import org.im4java.core.ConvertCmd;
import org.im4java.core.IMOperation;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.Log;

public class FileUtilNanning {

	//优化图片文件，减小文件大小
	public static boolean optimizeImage(String filename) throws MessageException, SQLException
	{
		boolean result = false;
		
		if(filename.toLowerCase().endsWith(".gif")) return true;
		
		String path = FileUtil.getIM4JAVAPath();
		
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
	
}
