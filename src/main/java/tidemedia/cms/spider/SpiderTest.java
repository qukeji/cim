package tidemedia.cms.spider;

import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.IOUtils;

import tidemedia.cms.util.Util;

public class SpiderTest {

	public static void main(String[] args)
	{
		list_href_test();
		//testimage();
	}
	
	public static void testimage()
	{ 
		String s = "";
		Clipboard sysClip = Toolkit.getDefaultToolkit().getSystemClipboard();
		Transferable clipTf = sysClip.getContents(null);
		try {
			s = (String) clipTf.getTransferData(DataFlavor.stringFlavor);
		} catch (UnsupportedFlavorException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(s);
		System.out.println("\r\n============");
		//ArrayList array = SpiderJob.getImagesHref(s);
		//for(int i=0;i<array.size();i++)
		//{
		//	String img = (String)array.get(i);
		//	System.out.println(img+","+SpiderJob.getRealImageHref(img, "http://news.xinhuanet.com/2012-08/07/c_123539502.htm"));
		//}
	}
	
	public static void list_href_test()
	{
		
		String[] s = new String[]{"","","","","","","","","",""};
		s[0] = "<span><a ID=\"ATitle\" target=\"_blank\" href=\"http://www.autohome.com.cn/news/201308/606470.html\" title='8月31日：90号汽油平均上调0.17元/升'>8月31日：90号汽油平均上调0.17元/升</a></span></div><div id=\"ArticlesTitlesRigth\">08月30日</div><div id=\"ArticlesTitlesLeft\"><span style=\"color:#000;\">・</span><span><a ID=\"ATitle\" target=\"_blank\" href=\"http://www.autohome.com.cn/news/201308/606706.html\" title='英菲尼迪启用新命名 QX50车型41.88万起'>英菲尼迪启用新命名 QX50车型41.88万起</a></span></div><div id=\"ArticlesTitlesRigth\">08月29日</div><div id=\"ArticlesTitlesLeft\"><span style=\"color:#000;\">・</span><span><a ID=\"ATitle\" target=\"_blank\" href=\"http://www.autohome.com.cn/news/201308/606562.html\" title='法国法院中止奔驰部分车型销售禁令'>法国法院中止奔驰部分车型销售禁令</a></span>";
		s[1] = "<a href=\"http://www.autohome.com.cn/news/201308/606470.html\" title='8月31日：90号汽油平均上调0.17元/升'>8月31日：90号汽油平均上调0.17元/升</a>";
		
		//[^>]匹配除>以外的所有字符 * 重复0或多次
		String reg = "<a[^>]*href=\"(.+?)\"[^>]*>(.+?)</a>";
		//<a.*href=[\"'](.+?)[\"'](.*?)>(.+?)</a>
		for(int i =0;i<s.length;i++)
		{
			String str = s[i];
			if(str.length()>0)
			{
				System.out.println("分析:"+str);
				Pattern p = Pattern.compile(reg);
				//Pattern p = Pattern.compile(reg,Pattern.DOTALL);
				Matcher m = p.matcher(str);
				while (m.find()) {
					System.out.println(m.groupCount()+","+m.group(1));
				  //a.add(m.group(group));
				}
			}
		}
	}
}
