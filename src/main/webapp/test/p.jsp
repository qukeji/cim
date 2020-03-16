<%@ page import="org.apache.axis.client.*"%>
<%@ page contentType="text/html;charset=utf-8" %>

<%

		String endpoint = " http://forum.vodone.com/api/services.php";
		Service service = new Service();
		Call call = null;
		
			
			String	action = "new";
			
			call = (Call) service.createCall();
			call.setOperationName("vodContentToBbs");
			call.setTargetEndpointAddress(new java.net.URL(endpoint));
			call.addParameter("contentXML",org.apache.axis.Constants.XSD_STRING,javax.xml.rpc.ParameterMode.INOUT);
			String xmlContent = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><contents><content><op>new</op><contentid>-8580308</contentid><title><![CDATA[ 银监会官员：二套住房以家庭为单位认定]]></title><catalog>2</catalog><coverhref><![CDATA[]]></coverhref><copyright><![CDATA[]]></copyright><summary><![CDATA[昨天，中国银监会银行监管一部主任杨家才接受媒体采访时表示，二套住房以家庭为单位进行认定，包括本人、配偶及未成年子女。]]></summary><article><![CDATA[]]></article><keyword><![CDATA[二套住房 家庭 单位]]></keyword><mediatype>205</mediatype><duration>0</duration><restrictions><![CDATA[1]]></restrictions><catalogcode>4019_4020</catalogcode><plugURL><![CDATA[www.vodone.com]]></plugURL><Embeded><![CDATA[Embeded]]></Embeded><userid><![CDATA[1960873]]></userid><username><![CDATA[kkhy998]]></username></content></contents>";
			//System.out.println(xmlContent);
			//call.setReturnType(org.apache.axis.Constants.SOAP_STRING);
			call.invoke(new Object[]{xmlContent});	
			
		

%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!