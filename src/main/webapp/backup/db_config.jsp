<%@ page import="tidemedia.cms.system.*,
				 tidemedia.cms.util.*,
				 org.dom4j.Element,
				 org.dom4j.io.SAXReader,
				 org.dom4j.Document,
				 java.util.*,
				 java.io.File,
				 org.apache.commons.io.FileUtils,
				 org.apache.commons.io.filefilter.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
		 /**
		  * 用途 ：扫描catalina目录下的xml  读取用户名密码 
		  *	1，丁文豪   20150410     将原来的从conf/server.xml读取密码 修改为从  Catalina/localhost 读取
		  * 2.丁文豪    20150410  优化筛选重复数据库的方法
		  * 
		  */
		if(!userinfo_session.isAdministrator())
		{ 
			response.sendRedirect("../noperm.jsp");
			return;
		}
		TideJson tj=CmsCache.getParameter("sys_backup_cfg").getJson();
        String db_xml_path=tj.getString("xml_path");
		File file=new File(db_xml_path);
		List list=(List)FileUtils.listFiles(file,FileFilterUtils.suffixFileFilter(".xml"),DirectoryFileFilter.INSTANCE);
		SAXReader saxReader=new SAXReader();
        List<String> list2=new ArrayList<String>();
        Set<String> databases = new HashSet<String>();
        String string="";
		//读取 用户名、密码、数据库名、IP
		for(int i=0;i<list.size();i++)
		{             
			Document doc=saxReader.read(list.get(i)+"");
			List xmlList = doc.selectNodes("//Context/Resource");
			
			for (Object childNodes : xmlList)
		    {
				Element element = (Element) childNodes; 
				String username=element.attributeValue("username");
				String password=element.attributeValue("password");
				String url=element.attributeValue("url");
				
				if(url!=null)
				{
					String  []str=url.split("//");
					String  []str1=str[1].split("/");
					String  ip=url.split("//")[1].split("/")[0].split(":")[0];
					String  databaseName=url.split("//")[1].split("/")[1].split("[?]")[0];
					string="{\"name\":\""+ url.substring(url.indexOf("3306")+5,url.lastIndexOf("?")) + "\",\"username\":\"" + username + "\",\"password\":\"" + password + "\",\"url\":\"" + url.substring(url.indexOf("//") + 2,
									url.lastIndexOf(":"))+"\"},";
					if(databases.add(string))
						list2.add(string);
                  
				 }
			  }
		}

		String str="";
		for(String ss:list2)
		{
			str+=ss;
		}
		out.println("{\"databases\":["+str.substring(0,str.length()-1)+"]}");
%>
