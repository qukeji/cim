package tidemedia.cms.filter;

import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class LoginFilterConfig {
	
	private static String rootPath = "";
	
	
	static
	{
		init();
	}

	private static void init()
	{
		java.io.InputStream inputStream = LoginFilterConfig.class.getResourceAsStream("filter_config.xml");
		SAXReader reader = new SAXReader(); 
		org.dom4j.Document doc;
		try {
			doc = reader.read(inputStream);
			Element root = doc.getRootElement();
			System.out.println(root.asXML());
			setRootPath(root.elementText("rootPath"));
		} catch (DocumentException e) {
			e.printStackTrace();
		}
	}

	public static void setRootPath(String rootPath) {
		LoginFilterConfig.rootPath = rootPath;
	}

	public static String getRootPath() {
		return rootPath;
	}
}
