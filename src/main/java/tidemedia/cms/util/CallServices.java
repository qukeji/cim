package tidemedia.cms.util;

import java.sql.SQLException;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;

public class CallServices {

	public void call(Document document,String action) throws MessageException, SQLException
	{
		return;
		/*
		call2(document,action);
		
		String customer = CmsCache.getConfig().getCustomer();
		String endpoint = "http://bbs.v1.cn/api/services.php";
		
		if(customer.equals("caishijie"))
			endpoint = "http://bbs.v1.cn/api/servicestest.php";//��Ʊ����
		
		Service service = new Service();
		Call call = null;
		try {
			if(action.equals(""))
				action = "new";
			
			call = (Call) service.createCall();
			call.setOperationName("vodContentToBbs");
			call.setTargetEndpointAddress(new java.net.URL(endpoint));
			//call.addParameter("contentXML",org.apache.axis.Constants.XSD_STRING);
			String xmlContent = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><contents><content>";
			long cid = document.getGlobalID() + 8000000;
			xmlContent += "<op>" + action + "</op>";
			
			if(customer.equals("caishijie"))
				xmlContent += "<source>1</source>";//��Ʊר��
			
			xmlContent += "<contentid>-" + cid + "</contentid><title><![CDATA[" + Util.XMLQuote(document.getTitle()) + "]]></title>";
			xmlContent += "<catalog>2</catalog><coverhref><![CDATA[]]></coverhref><copyright><![CDATA[]]></copyright>";
			xmlContent += "<summary><![CDATA[" + document.getSummary() + "]]></summary>";
			xmlContent += "<article><![CDATA[" + Util.substring(Util.removeHtml(document.getContent()), 200) + "]]></article>";
			xmlContent += "<href>"+document.getHttpHref()+"</href>";
			xmlContent += "<keyword><![CDATA[" + document.getKeyword() + "]]></keyword><mediatype>205</mediatype><duration>0</duration><restrictions><![CDATA[1]]></restrictions>";
			xmlContent += "<catalogcode>4019_4020</catalogcode><plugURL><![CDATA[www.vodone.com]]></plugURL><Embeded><![CDATA[Embeded]]></Embeded><userid><![CDATA[1960873]]></userid><username><![CDATA[kkhy998]]></username>";
			xmlContent += "</content></contents>";	
			
			String ret=(String)call.invoke(new Object[]{"","",xmlContent});		
			//System.out.println(xmlContent);
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		//call2(document,action);
	}
	
	public void call2(Document document,String action) throws MessageException, SQLException
	{
		String customer = CmsCache.getConfig().getCustomer();
		String endpoint = "http://face.v1.cn/index.php?r=api/webservice/webs&ws=1";
		
		if(customer.equals("caishijie"))
			return;
		
		Service service = new Service();
		Call call = null;
		try {
			if(action.equals(""))
				action = "new";
			
			call = (Call) service.createCall();
			call.setOperationName("vodContentToBbs");
			call.setTargetEndpointAddress(new java.net.URL(endpoint));
			//call.addParameter("contentXML",org.apache.axis.Constants.XSD_STRING);
			String xmlContent = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><contents><content>";
			long cid = document.getGlobalID() + 8000000;
			xmlContent += "<op>" + action + "</op>";
			
			if(customer.equals("caishijie"))
				xmlContent += "<source>1</source>";//��Ʊר��
			
			xmlContent += "<contentid>-" + cid + "</contentid><title><![CDATA[" + Util.XMLQuote(document.getTitle()) + "]]></title>";
			xmlContent += "<catalog>2</catalog><coverhref><![CDATA[]]></coverhref><copyright><![CDATA[]]></copyright>";
			xmlContent += "<summary><![CDATA[" + document.getSummary() + "]]></summary>";
			xmlContent += "<article><![CDATA[" + Util.substring(Util.removeHtml(document.getContent()), 200) + "]]></article>";
			xmlContent += "<href>"+document.getHttpHref()+"</href>";
			xmlContent += "<keyword><![CDATA[" + document.getKeyword() + "]]></keyword><mediatype>205</mediatype><duration>0</duration><restrictions><![CDATA[1]]></restrictions>";
			xmlContent += "<catalogcode>4019_4020</catalogcode><plugURL><![CDATA[www.vodone.com]]></plugURL><Embeded><![CDATA[Embeded]]></Embeded><userid><![CDATA[1960873]]></userid><username><![CDATA[kkhy998]]></username>";
			xmlContent += "</content></contents>";	
			
			String ret=(String)call.invoke(new Object[]{"","",xmlContent});		
			//System.out.println(xmlContent);
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}	
}
