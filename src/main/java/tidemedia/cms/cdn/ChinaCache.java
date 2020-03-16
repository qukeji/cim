package tidemedia.cms.cdn;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.TemplateFile;
import tidemedia.cms.util.StringUtils;
import tidemedia.cms.util.Util;

public class ChinaCache {
	public static void Refresh(String url)
	{
		//if(canRefresh())
		//{
		//System.out.println(url);
			ChinaCacheRunner cc = new ChinaCacheRunner();
			cc.setUrl(url);
			cc.Start();
			
			/*
			if(url.startsWith("http://www.vodone.com"))
			{
				ChinaCacheRunner ccc = new ChinaCacheRunner();
				ccc.setUrl(StringUtils.replace(url, "www.vodone.com", "v.vodone.com"));
				ccc.Start();
			}
			*/
/*			try {
			String lurl = "http://59.151.3.80:18080/cgi-bin/recache.sh?urls=" + url;
			//System.out.println(lurl);
			java.net.URL l_url = new java.net.URL(lurl); 
			java.net.HttpURLConnection con = (java.net.HttpURLConnection) l_url.openConnection();
			HttpURLConnection.setFollowRedirects(true);
			con.setInstanceFollowRedirects(false);
			con.connect(); 
			InputStream l_urlStream = con.getInputStream(); 
			java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream)); 
			//String sCurrentLine = "";
			//String sTotalString = "";
			while ((l_reader.readLine()) != null) 
			{ 
				//sTotalString = sCurrentLine;
			}
	
			l_reader.close();
			con.disconnect();
			
			} catch (Exception e) {
				e.printStackTrace(System.out);
			}*/
		//}
	}
	
	public static boolean canRefresh()
	{
		return true;
	}
	
	public static String addUrl(String url,String FileName,int site) throws MessageException, SQLException
	{
		String domain = CmsCache.getSite(site).getExternalUrl();
		FileName = Util.ClearPath(FileName);
		if(!FileName.startsWith("/")) FileName = "/" + FileName;
		
		//对msn做单独处理，2009-11-04
		
		//if(FileName.startsWith("/sh/")) domain = "http://sh.vodone.com";
		
		/*if(!(FileName.startsWith("/vodplayer") 
				|| FileName.startsWith("/xml/") 
				|| FileName.startsWith("/vodplayer/list")
				|| FileName.startsWith("/msn/vodplayer") 
				|| FileName.startsWith("/msn/xml/") 
				|| FileName.startsWith("/msn/list")
				
				|| FileName.startsWith("/cncmax") 
				|| FileName.startsWith("/vodplayer/content_2008")
				|| FileName.startsWith("/vodplayer/text_2008")
				|| FileName.startsWith("/album/")
				))
		{//cncmax的页面发布的时候，不需要刷新cache 2008.04.10
		*/
		
			url += (url.equals("")?"":"%0D%0A") +  domain + FileName;
			if(url.endsWith("index.shtml"))
			{
				url += (url.equals("")?"":"%0D%0A") +  domain + StringUtils.replace(FileName, "index.shtml", "");
				url += (url.equals("")?"":"%0D%0A") +  domain + StringUtils.replace(FileName, "/index.shtml", "");
			}
		//}
		//System.out.println("cdn url:"+url);
		return url;
	}
	
	/*
	public void RefreshItem(int globalid) throws MessageException, SQLException
	{			
		TableUtil tu = new TableUtil();
		String sql = "select * from generate_files where GlobalID=" + globalid + " and TemplateType=" + TemplateFile.ContentTemplateType;
		
		String url = "";
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next())
		{
			String filename = tu.convertNull(rs.getString("FileName"));
			int channelid = rs.getInt("ChannelID");
			
			Channel ch = CmsCache.getChannel(channelid);
			
			url = ChinaCache.addUrl(url, filename,ch.getSiteID());
		}
		
		tu.closeRs(rs);		
		
		if(!url.equals("")) ChinaCache.Refresh(url); 
	}*/
}
