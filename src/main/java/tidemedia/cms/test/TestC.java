package tidemedia.cms.test;

import java.io.File;
import java.util.Iterator;
import java.util.List;

import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import tidemedia.cms.util.RandomUtil;

public class TestC implements Runnable{

	/**
	 * @param args
	 * @throws DocumentException 
	 */
	public static void main(String[] args) throws DocumentException {
		// TODO Auto-generated method stub
		SAXReader reader = new SAXReader();    
		String path = "d:/web/15966.xml";
		org.dom4j.Document xml_document = reader.read(new File(path));
		Element root = xml_document.getRootElement();
		Element ele_template_files = xml_document.getRootElement().element("template_files");
		List nodes = ele_template_files.elements("template_file");
		for (Iterator it = nodes.iterator(); it.hasNext();) { 
			Element e = (Element) it.next();
			String content = e.getText();
			
			System.out.println(content);
		}
		System.out.println("ok");
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		long time = System.currentTimeMillis() / 1000;
		int num = RandomUtil.getRandom(time);
		System.out.println(time+":"+num);
	}
}
