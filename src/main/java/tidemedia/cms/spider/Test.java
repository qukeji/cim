package tidemedia.cms.spider;

import java.io.IOException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import tidemedia.cms.util.Util;

public class Test {

	public static void main(String[] args) {

		String s = "asdfasdf/asdfasdf";
		String ss = s.replace("/","");
		System.out.println(ss);

		/*
		//读取内容页内容
		String url = "http://gx.people.com.cn/n2/2019/0917/c179430-33363160.html";
		String content = Util.connectHttpUrl(url, "gb2312");
		SpiderJob sj = new SpiderJob();
		ArrayList arr = sj.getImagesHref(content);
		for(int i = 0;i<arr.size();i++)
        {
            String img = (String)arr.get(i);
            System.out.println(img+","+sj.getRealImageHref(img,url));
        }
		System.out.println(arr.size());*/
	}

	public static void main_(String[] args) {
		String content = Util.connectHttpUrl("http://china.caixin.com/medicare/", "utf-8");
		
		String message = "";
		String start = "<div class=\"stitXtuwen_list\">";
		int i = content.indexOf(start);
		if (i == -1)
			message += "没有找到开始符号";
		else
			content = content.substring(i + start.length());
		
		String end = "<div class=\"pageNavBox\">";
		i = content.indexOf(end);

		if (i == -1)
			message += "没有找到结束符号";
		else
			content = content.substring(0, i);
		
		//String content = '<dl><dd><div class="pic"><a href="http://china.caixin.com/2018-01-30/101205072.html"><img src="http://img.caixin.com/2018-01-30/1517309742877451_145_97.jpg" border="0" alt="教育部首次发布本科专业质量国标 20%专业先创世界一流"/></a></div><h4><a href="http://china.caixin.com/2018-01-30/101205072.html">教育部首次发布本科专业质量国标 20%专业先创世界一流</a> <span class="icon_time"  title="限时免费"></span></h4><span>2018年01月30日 </span><p>此前曾有将高等教育“工业化”的担忧。教育部最终决定发布首个高等学校本科专业类教学质量国家标准，并提出2022年20大召开前中国20%的专业可以达到世界一流水平</p></dd></dl><dl><dd><div class="pic">';
		String reg = "<a[^>]*href=[\"'](.+?)[\"']>(.+?)</a>";
		Pattern p = Pattern.compile(reg);
		Matcher m = p.matcher(content);
		while (m.find()) {
			String mm = m.group(1);
			System.out.println("mm:"+mm);
		}
		
	}

}
