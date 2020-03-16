<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.TableUtil,
				java.io.*,
				tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id=Util.getIntParameter(request,"site");

Site site = new Site();
org.json.JSONObject jo = new org.json.JSONObject();
jo.put("msg","");
jo.put("status","0");
if(id>0)
{
    site=CmsCache.getSite(id);
	boolean cando = true;
	if(site.getUrl().length()==0)
	{
		jo.put("msg","站点地址为空");
		cando = false;
	}

	String apache = CmsCache.getParameterValue("sys_apache_home");
	if(apache.length()==0)
	{
		jo.put("msg","没有配置apache路径");
		cando = false;
	}
	String folder = site.getSiteFolder();
	File f = new File(folder);
	if(!f.exists())
	{
		String canwritefolder = CmsCache.getParameterValue("sys_site_canwritefolder");
		if(canwritefolder.length()==0)
		{
			jo.put("msg","没有配置可以自动建立站点目录的目录.");
			cando = false;
		}
		else
		{
			if(folder.startsWith(canwritefolder))
			{
				f.mkdirs();
				BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(folder+"/index.shtml",false),"utf-8"));
				String filecontent = "网站测试，该文件由<a href='http://www.tidecms.com'>TideCMS 8.0</a>自动生成.";
				ot.write(filecontent,0,filecontent.length());
				ot.close();
			}
			else
			{
				jo.put("msg","站点目录不在被允许的范围之内.");
				cando = false;
			}
		}
	}

	if(cando)
	{
		File file = new File(apache + "/conf/httpd.conf");
		if(!file.exists())
		{
			jo.put("msg","没有找到apache配置文件");
			cando = false;
		}
		else
		{
			BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
			String LineString;
			String TotalString = "";
			while ((LineString = in .readLine())!=null)
			{
				TotalString += LineString+"\r\n";
			}
			in.close();
			//jo.put("msg",TotalString);
			
			java.net.URL url = new java.net.URL(site.getUrl());
			String host = url.getHost();
			int port = url.getPort();

			String flag_str = "";
			if(port==-1)
			{
				flag_str = host;
			}
			else
			{
				flag_str = "VirtualHost *:"+port+"";
			}

			if(TotalString.contains(flag_str))
			{
				jo.put("msg","apache配置文件中已经存在:" + flag_str);
				cando = false;
			}

			if(cando)
			{
			String s = "\r\n#add by tidecms " + Util.getCurrentDate();
				s += "\r\nListen "+port;
				s += "\r\n<VirtualHost *:"+port+">";
				s += "\r\n\tServerName " + host;
				s += "\r\n\tDocumentRoot \""+site.getSiteFolder()+"\"";
				s += "\r\n\t<Directory />";
				s += "\r\n\tOptions FollowSymLinks Includes";
				s += "\r\n\tAllowOverride None";
				s += "\r\n\tOrder deny,allow";
				s += "\r\n\tAllow from all";
				s += "\r\n\t</Directory>";
			s += "\r\n</VirtualHost>";

			String filecontent = TotalString + s;
			BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false)));

			ot.write(filecontent,0,filecontent.length());
			ot.close();
			jo.put("status","1");
			}
		}
	}

	if(cando)
	{
		jo.put("msg",""); 
		jo.put("status","2");
		String cmd = apache + "/bin/httpd.exe -k restart";
		Process process = Runtime.getRuntime().exec(cmd);     //执行一个系统命令
		
		/*
		InputStream fis = process.getInputStream();
		BufferedReader br = new BufferedReader(new InputStreamReader(fis));
		String line = null;
		String cmdout = "";

		while ((line = br.readLine()) != null) {
			cmdout += (System.getProperty("line.separator"));
		}
		System.out.println(cmdout);
		*/
	}

}
out.println(jo);
%>