package tidemedia.cms.test;

import java.io.File;
import java.util.Iterator;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class xml {
	public static void main(String[] args) throws DocumentException {
		System.out.println("ImportChannelInfo");
		SAXReader reader = new SAXReader();
		String path = "d:/v1/channel_16099.xml";
	    Document	xml_document = reader.read(new File(path));
		Element root = xml_document.getRootElement();
		List nodes = root.elements("field");
		for (Iterator it = nodes.iterator(); it.hasNext();) { 
			
			Element element = (Element) it.next();
			String a = element.attributeValue("Options");
			System.out.println("a:"+a);
		} 
		System.out.println("ok");
	}
}
