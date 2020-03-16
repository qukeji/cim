package tidemedia.cms.publish;

import java.io.StringWriter;
import java.util.Properties;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import org.apache.velocity.app.VelocityEngine;

public class VelocityUtil {

	public VelocityUtil()
	{
		
	}
	
	//字符串模板
	public String TemplateMerge(String template,VelocityContext context)
	{
		String s = "";
		try {
			
	     	Properties p = new Properties();   
	     	p.setProperty("resource.loader", "test");//给你的加载器随便取个名字   
	     	p.setProperty("test.resource.loader.class","tidemedia.cms.publish.TideResourceLoader");//配置一下你的加载器实现类 
	     	p.setProperty(VelocityEngine.RUNTIME_LOG_LOGSYSTEM_CLASS,"org.apache.velocity.runtime.log.NullLogSystem");//关闭日志
	     	
			Velocity.init(p);
			StringWriter w = new StringWriter();
			Velocity.evaluate(context, w, "mystring", template);
			s = w.toString();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		
		return s;
	}
}
