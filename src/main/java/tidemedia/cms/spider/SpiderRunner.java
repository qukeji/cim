package tidemedia.cms.spider;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import org.quartz.Job;
import org.quartz.JobExecutionContext;


import org.quartz.JobExecutionException;
import redis.clients.jedis.Jedis;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.publish.PublishManager;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.CmsFile;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.Field;
import tidemedia.cms.system.ItemUtil;
import tidemedia.cms.system.Log;
import tidemedia.cms.system.LogAction;
import tidemedia.cms.system.Site;
import tidemedia.cms.util.FileUtil;
import tidemedia.cms.util.TideJson;
import tidemedia.cms.util.Util;

public class SpiderRunner implements Runnable {
	private Thread runner;	

	public int spider_id = 0;

	public SpiderRunner(int id) throws SQLException, MessageException
	{
		spider_id = id;
	}
	
	public void Start() {	
		if (runner == null) {
			runner = new Thread(this);
			runner.start();
		}
	}
	
	public void run()
	{
		try {		
			TableUtil tu = new TableUtil();
			Spider s = new Spider(spider_id);
			
			Log.SystemLog(LogAction.systemlog_spider, "开始采集<"+s.getName()+">," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
			String sql = "update spider set PrevRunTime=UNIX_TIMESTAMP() where id=" + spider_id;
			tu.executeUpdate(sql);
			
			getItems(spider_id);
			
			sql = "update spider set NextRunTime=UNIX_TIMESTAMP()+Period*60 where id=" + spider_id;
			tu.executeUpdate(sql);
			Log.SystemLog(LogAction.systemlog_spider, "结束采集<"+s.getName()+">," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));			
		} catch (Exception e) {
			e.printStackTrace();
			try {
				Log.SystemLog(LogAction.systemlog_spider, e.getMessage());
			} catch (Exception e1) {
			}
			
		}
		SpiderAgent.RunDone(spider_id);
	}

	/*
	 * 获取采集内容
	 * 
	 * @author wanghailong
	 * 
	 * @action modify
	 * 
	 * @date 2013/12/30
	 */
	public void getItems(int id) throws MessageException, SQLException {
		Spider s = new Spider(id);
		// 如果url里面含有{100}，说明总页面是100，抓取所有页面
		String url = s.getUrl();
		String oldurl = url;
		// if(s.getStatus()==0) return;

		if (url.length() == 0 || !url.startsWith("http://"))
			return;
		if (s.getListStart().length() == 0 || s.getListEnd().length() == 0)
			return;
		if (s.getChannel() == 0) {
			Log.SystemLog(LogAction.systemlog_spider, "没有配置频道," + s.getName());
			return;
		}
		//2015-10-29日修改  默认图片存储在/images2目录下   故此判断省略
		//		if (s.getImageFolder().length() == 0) {
		//			Log
		//					.SystemLog(LogAction.systemlog_spider, "没有配置图片路径,"
		//							+ s.getName());
		//			return;
		//		}
		Channel channel = CmsCache.getChannel(s.getChannel());
		if (channel==null) {
			Log.SystemLog(LogAction.systemlog_spider, "对应频道不存在," + s.getName());
			return;
		}		
		Field field = channel.getFieldByFieldName("SpiderUrl");
		if (field == null) {
			Log.SystemLog(LogAction.systemlog_spider, "对应频道没有SpiderUrl字段,"
					+ s.getName());
			return;
		}

		try {
			int ii = url.indexOf("{");
			int jj = url.indexOf("}");
			int pagenum = 0;
			if (ii != -1 && jj != -1) {
				pagenum = Util.parseInt(url.substring(ii + 1, jj));
				if (pagenum > 0) {
					s.enable(2);// 一次性
				}
			}

			for (int iii = pagenum; iii >= 0; iii--) {
				// pagenum大于0，说明要获取多页
				if (pagenum > 0)
					url = oldurl.replace("{" + pagenum + "}", iii + "");
				Log.SystemLog(LogAction.systemlog_spider, "采集地址：" + url);

				HashMap hash = getContentHrefByListUrl(s, url);
				ArrayList arr = (ArrayList) hash.get("items");

				for (int j = arr.size() - 1; j >= 0; j--) {
					getItem(s, (String) arr.get(j));
				}
			}
		} catch (Exception e) {
			Log.SystemLog(LogAction.systemlog_spider, e.getMessage());
			// System.out.println("spiderid:"+s.getId()+"\r\n");
			// e.printStackTrace(System.out);
		}
	}

	// 判断标题是否含有关键词
	public boolean canAdd(String keywords, String title) {
		if (keywords.length() > 0) {
			String arr[] = keywords.split(",");
			for (String temp : arr) {
				if (title.contains(temp))
					return true;
			}
			return false;
		}
		return true;
	}

	// 读取内容页的内容
	public void getItem(Spider s, String url) throws MessageException,
			SQLException {
		// System.out.println("getitem:"+url);
		TableUtil tu = new TableUtil();
		boolean can = canSpider(s, url);
		if (!can)
			return;

		Channel channel = CmsCache.getChannel(s.getChannel());

		Log.SystemLog(LogAction.systemlog_spider, "正在采集(" + s.getName() + "):"
				+ url);
		// 读取内容页

		String content = Util.connectHttpUrl(url, s.getItemCharset());

		if (CmsCache.redis) {
			Jedis jedis = new Jedis("localhost");
			String jkey = "spider_url_" + url;
			jedis.set(jkey, "1");
			jedis.expire(jkey, 864000);// 10天过期
		}

		if (content.length() == 0) {
			Log.SystemLog(LogAction.systemlog_spider, "没有读取到内容," + url);
			return;
		}
		HashMap hash = new HashMap();

		hash = getFieldValueByContentUrl(s, url, false, content);// 根据字段配置分析数据
		HashMap hash1 = getFieldValueByProgram(s, url, content);// 从代理程序获取数据

		HashMap<String, String> map = (HashMap) hash.get("map");
		HashMap map1 = (HashMap) hash1.get("map");

		if (map1 != null && map1.size() > 0) {
			Iterator iter = map1.entrySet().iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry) iter.next();
				String key = (String) entry.getKey();
				String val = (String) entry.getValue();
				// System.out.println(key+","+val);
				map.put(key, val);
			}
		}

		// HashMap map = (HashMap)hash.get("map");

		int gid = 0;
		map.put("Status", s.getItemStatus() + "");
		String title = (String) map.get("Title");
		String tidecms_items = Util.convertNull((String) map
				.get("tidecms_items"));
		if (title == null || title.length() == 0)
			Log.SystemLog(LogAction.systemlog_spider, "没有找到标题," + url);
		else {
			String keywords = s.getTitleKeyword();

			if (canAdd(keywords, title)) {// 包含关键词

				// 如果tidecms_items有内容，或者需要设置全局编号
				if (tidecms_items.length() > 0 || s.getIsGlobalID() == 1) {
					map.put("tidecms_addGlobal", "1");
					gid = ItemUtil.addItemGetGlobalID(s.getChannel(), map);
					if(s.getItemStatus()==1)
					{
						//要发布
						Document document = CmsCache.getDocument(gid);					
						ItemUtil.Approve(document, 0);
					}
				} else
				{
					Document document = ItemUtil.addItem(s.getChannel(), map);
					if(s.getItemStatus()==1)
					{
						//要发布				
						ItemUtil.Approve(document, 0);
					}				
				}
			}
		}

		// 处理下级文档
		// System.out.println("tidecms_items:"+tidecms_items);
		if (tidecms_items.length() > 0) {
			JSONObject json = Util.getJson(tidecms_items);
			try {
				JSONArray jsonarray = json.getJSONArray("items");

				for (int i = 0; i < jsonarray.length(); i++) {
					JSONObject jsono = jsonarray.getJSONObject(i);
					int channelid = Util.parseInt(jsono.getString("channelid"));
					HashMap submap = new HashMap();
					Iterator keys = jsono.keys();
					while (keys.hasNext()) {
						String key = (String) keys.next();
						String value = "";
						value = (String) jsono.get(key);
						// System.out.println("submap key:"+key+","+value+",channelid:"+channelid);
						submap.put(key, value);
					}
					submap.put("Status", "1");// 默认是已发
					submap.put("Parent", gid + "");
					if (gid > 0)
						ItemUtil.addItem(channelid, submap);
				}
			} catch (JSONException e) {
				Log.SystemLog(LogAction.systemlog_spider, s.getName()
						+ " 子集JSON解析错误," + url);
				e.printStackTrace(System.out);
				// System.out.println(e.getMessage());
			}

		}
	}

	// 根据一个列表URL采集数据，用于手工采集
	public JSONObject spiderByOneUrlFirst(Spider s, String url)
			throws MessageException, SQLException, JSONException {
		JSONObject json = new JSONObject();
		HashMap hash = getContentHrefByListUrl(s, url);
		ArrayList arr = (ArrayList) hash.get("items");
		int num1 = 0;
		int num2 = 0;
		json.put("total", arr.size());
		for (int j = arr.size() - 1; j >= 0; j--) {
			String item_url = (String) arr.get(j);
			try {
				getItem(s, item_url);
				num1++;
			} catch (Exception e) {
				num2++;
				Log.SystemLog(LogAction.systemlog_spider, "采集发生错误,地址："
						+ item_url + ",信息：" + e.getMessage());
			}
		}
		json.put("success", num1);
		json.put("false", num2);
		return json;
	}

	// 读取列表页内容,分析链接
	public HashMap getContentHrefByListUrl(Spider s, String url) {
		HashMap hash = new HashMap();
		String message = "";
		String content = Util.connectHttpUrl(url, s.getCharset());
		int i = content.indexOf(s.getListStart());
		if (i == -1)
			message += "没有找到开始符号";
		else
			content = content.substring(i + s.getListStart().length());

		i = content.indexOf(s.getListEnd());

		if (i == -1)
			message += "没有找到结束符号";
		else
			content = content.substring(0, i);
		// System.out.println("listurl:"+url+","+content);
		hash.put("content", content);

		String reg = "<a.*href=[\"'](.+?)[\"'](.*?)>(.+?)</a>";
		if (s.getHrefReg().length() > 0)
			reg = s.getHrefReg();

		ArrayList<String> arr = new ArrayList<String>();

		Pattern p = Pattern.compile(reg);
		Matcher m = p.matcher(content);
		while (m.find()) {
			// System.out.println((s.getUrl2() + m.group(1))+","+m.group(2));
			String mm = m.group(1);
			if (!mm.startsWith("http://")) {
				if (mm.startsWith("/"))
					mm = s.getUrl2() + mm;
				else if (mm.startsWith("../")) {
					int mmm = mm.lastIndexOf("../");
					int num = (mmm + 3) / 3;
					String[] str = Util.StringToArray(s.getUrl3().replace(
							"http://", ""), "/");
					String newurl = "";
					for (int n = 0; n < str.length - num; n++) {
						newurl = str[n] + "/";
					}
					mm = "http://" + newurl + mm.substring(mmm + 3);
				} else
					mm = s.getUrl3() + "/" + mm;
			}

			arr.add(mm);
		}

		hash.put("items", arr);
		hash.put("message", message);
		return hash;
	}

	public HashMap getFieldValueTest(Spider s, String url)
			throws MessageException, SQLException {
		HashMap hash = new HashMap();
		String content = Util.connectHttpUrl(url, s.getItemCharset());
		hash = getFieldValueByContentUrl(s, url, true, content);// 根据字段配置分析数据
		HashMap hash1 = getFieldValueByProgram(s, url, content);// 从代理程序获取数据

		String message = (String) hash.get("message");
		message += (String) hash1.get("message") + "\r\n";
		HashMap map = (HashMap) hash.get("map");
		HashMap map1 = (HashMap) hash1.get("map");

		if (map1 != null && map1.size() > 0) {
			Iterator iter = map1.entrySet().iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry) iter.next();
				String key = (String) entry.getKey();
				String val = (String) entry.getValue();
				// System.out.println("getFieldValueTest key:"+key+",val:"+val);
				map.put(key, val);
			}
		}

		hash.put("message", message);
		hash.put("map", map);

		return hash;
	}

	/**
	 * 检查字符串是否在ArrayList里面
	 * 
	 * @param field
	 * @param fields
	 * @return
	 */
	public static boolean checkInArray(String field, ArrayList fields) {
		for (int i = 0; i < fields.size(); i++) {
			if (fields.equals((String) fields.get(i)))
				return true;
		}
		return false;
	}

	/**
	 * 根据内容分析对应字段的值
	 * 
	 * @param s
	 * @param url
	 * @param test
	 * @param content
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	public HashMap getFieldValueByContentUrl(Spider s, String url,
			boolean test, String content) throws MessageException, SQLException {
		HashMap hash = new HashMap();
		String message = "";
		HashMap<String, String> map = new HashMap<String, String>();

		ArrayList<SpiderField> arr = s.getFields();
		ArrayList fields = new ArrayList();
		ArrayList messages = new ArrayList();
		for (int i = 0; i < arr.size(); i++) {
			SpiderField sf = (SpiderField) arr.get(i);
			String c = "";

			// 判断字段是否已经处理过
			if (!checkInArray(sf.getField(), fields)) {
				// 先不处理分页
				if (sf.getCodeStart().length() > 0
						&& sf.getCodeEnd().length() > 0
						&& !sf.getField().equals("Page")) {
					int m = content.indexOf(sf.getCodeStart());
					if (m != -1) {
						c = content.substring(m + sf.getCodeStart().length());
						int n = c.indexOf(sf.getCodeEnd());
					//	System.out.println("----------n====" + n);
						if (n != -1) {
							c = c.substring(0, n);
							//System.out.println("-------" + test);
							if (!test)
								c = downloadImage(s, c, url);
							//System.out.println("------------c----" + c);
						} else {
							if (!test) {
								messages.add(new String[] { sf.getField(),
										sf.getName() + ":没有找到结束符号." });
								// Log.SystemLog("采集系统",s.getName()+" "+sf.getName()+",没有找到结束符号.");
							} else
								message += sf.getName() + ",没有找到结束符号.";
							// System.out.println(sf.getCodeEnd()+","+c);
							c = "";
						}
					} else {
						if (!test) {
							messages.add(new String[] { sf.getField(),
									sf.getName() + ":没有找到开始符号." });
							// Log.SystemLog("采集系统",s.getName()+" "+sf.getName()+",没有找到开始符号.");
						} else
							message += sf.getName() + ",没有找到开始符号.";

						c = "";
					}

					if (sf.getField().equals("PublishDate")) {
						c = c.trim();
						if (c.length() == 0)
							c = Util.getCurrentDate();
						c = c.replace("年", "-").replace("月", "-").replace("日",
								" ");
					}
				}

				if (c.length() > 0) {
					// System.out.println(sf.getField()+",content:"+c);
					map.put(sf.getField(), c);
					fields.add(sf.getField());
				}
			}
			// System.out.println(sf.getCodeStart()+","+sf.getName());
		}

		String message_ = "";
		for (int j = 0; j < messages.size(); j++) {
			String[] m = (String[]) messages.get(j);

			// System.out.println(url+","+m[0]+","+m[1]);
			if (!checkInArray(m[0], fields)) {
				message_ += m[1];
			}
		}

		if (message_.length() > 0)
			Log.SystemLog(LogAction.systemlog_spider, message_);

		// 处理分页情况
		for (int i = 0; i < arr.size(); i++) {
			SpiderField sf = (SpiderField) arr.get(i);
			if (sf.getField().equals("Page")) {
				String content_ = (String) map.get("Content");
				if (content_ != null && content_.length() > 0) {
					int m = content_.indexOf(sf.getCodeStart());
					if (m != -1) {
						String content2 = content_.substring(m
								+ sf.getCodeStart().length());
						int n = content2.indexOf(sf.getCodeEnd());
						if (n != -1) {
							String page_content = content2.substring(0, n);
							String content__ = content_.substring(0, m)
									+ content2.substring(n);
							map.put("Content", content__);
						} else {
							if (!test)
								Log.SystemLog(LogAction.systemlog_spider, s
										.getName()
										+ " " + sf.getName() + ",没有找到结束符号.");
							else
								message += sf.getName() + ",没有找到结束符号.";
						}
					} else {
						if (!test)
							Log.SystemLog(LogAction.systemlog_spider, s
									.getName()
									+ " " + sf.getName() + ",没有找到开始符号.");
						else
							message += sf.getName() + ",没有找到开始符号.";
					}
				}
			}
		}

		map.put("SpiderUrl", url);
		hash.put("map", map);
		hash.put("message", message);
		return hash;
	}

	// 从代理程序获取内容
	public HashMap getFieldValueByProgram(Spider s, String item_url,
			String content) {
		HashMap map = new HashMap();
		HashMap hash = new HashMap();

		if (s.getProgram().length() == 0)
			return hash;

		String message = "";
		// System.out.println(s.getProgram()+"?url="+item_url);
		String data = "";
		try {
			if (content.length() > 0)
				data = "content=" + URLEncoder.encode(content, "utf-8");
			else
				data = "url=" + item_url;
			data += "&spiderid=" + s.getId();
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		// System.out.println("data length:"+data.length());
		String content2 = Util.postHttpUrl(s.getProgram(), data);
		message += "代理程序返回值：" + content2 + "\r\n";
		// System.out.println(message);
		JSONObject json = null;
		try {
			json = new org.json.JSONObject(content2);
		} catch (JSONException e) {
			message += content2 + "\r\n";
		}

		if (json != null) {
			Iterator keys = json.keys();
			while (keys.hasNext()) {
				String key = (String) keys.next();
				String value = "";
				try {
					value = (String) json.get(key);
				} catch (JSONException e) {
					message += e.getMessage();
				}
				// System.out.println("getFieldValueByProgram key:"+key+",value:"+value);
				map.put(key, value);
			}
		}

		hash.put("map", map);
		hash.put("message", message);

		return hash;
	}

	/**
	 * 从字符串中提取图片地址 
	 * 注：由于对大写img标签解析存在问题，此方法暂时停用，使用jsoup方式解析
	 * 
	 * @param c
	 * @return
	 */
	public  ArrayList getImagesHref_(String c) {
		ArrayList array = new ArrayList();
		// String reg = " src\\s*=\\s*([\"'])?([^ \"']*)";
		String reg = "<img.*src\\s*=\\s*([\"'])?([^ \"']*)";
		// <img.*src=(.*?)[^>]*?> http://sbear.iteye.com/blog/583970
		Pattern p = Pattern.compile(reg);
		Matcher m = p.matcher(c);
		while (m.find()) {
			String img = m.group(2);
			// System.out.println("img1:"+img);
			array.add(img);
		}
	
		return array;
	}
	
	/**
	 * 从字符串中提取图片地址 
	 * 注：对大写小写的img标签都可以解析
	 * 
	 * @param c
	 * @return
	 */
	public  ArrayList getImagesHref(String c) {
		ArrayList array = new ArrayList();
		
		org.jsoup.nodes.Document doc_jsoup = Jsoup.parse(c);// jsoup解析内容
		Elements ele = doc_jsoup.select("img");// 获取图片标签
		if (ele != null && ele.size() > 0) {
			for (int i = 0; i < ele.size(); i++) {
					String photo_src = ele.get(i).attr("src");
					array.add(photo_src);
				}
			}
		return array;
	}

	public  String getRealImageHref(String img, String itemurl) {
		String imgurl = "";
		if (img.startsWith("http"))// http开头的
			imgurl = img;
		else if (img.startsWith("/"))// 以/开头
		{
			String itemurl_ = "";
			int ii = itemurl.replace("http://", "").indexOf("/");
			if (ii != -1)
				itemurl_ = "http://"
						+ itemurl.replace("http://", "").substring(0, ii);
			else
				itemurl_ = itemurl;
			imgurl = itemurl_ + img;
		} else if (img.startsWith("../")) {
			int mmm = img.lastIndexOf("../");
			int num = (mmm + 3) / 3;
			String[] str = Util.StringToArray(itemurl.replace("http://", ""),
					"/");
			String newurl = "";
			for (int n = 0; n < str.length - num; n++) {
				newurl = str[n] + "/";
			}
			imgurl = "http://" + newurl + img.substring(mmm + 3);
		} else {
			String path = itemurl.substring(0, itemurl.lastIndexOf("/"));
			imgurl = path + "/" + img;
		}
		return imgurl;
	}
	
	/**
	 * 获取采集图片的保存路径
	 * @param ch
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	public static String getdownloadImageFolder(Channel ch,Spider spider) throws MessageException, SQLException
	  {
	    String folder = "";
	    int foldertype = 0;
	    String spider_image=spider.getImageFolder();//采集配置的图片路径
	    Site s = ch.getSite();
	    
	    if(spider_image.length()>0){
	    	folder=spider_image;
	    }else{
	    	  folder="images2";
	    }
	  
	    
	    if (ch.getImageFolderType() == 0)
	    {
	      foldertype = s.getImageFolderType();
	    }
	    else
	    {
	      foldertype = ch.getImageFolderType();
	    }

	    if (foldertype > 0)
	    {
	      String SubFolder = "";

	      Calendar publishdate = new GregorianCalendar();
	      int year = publishdate.get(1);
	      int month = publishdate.get(2) + 1;
	      int day = publishdate.get(5);
	      if (foldertype == 1)
	        SubFolder = year + "/";
	      else if (foldertype == 2)
	        SubFolder = year + "/" + month + "/";
	      else if (foldertype == 3)
	        SubFolder = year + "/" + month + "/" + day + "/";
	      else if (foldertype == 4) {
	        SubFolder = year + "-" + month + "-" + day + "/";
	      }

	      folder = folder + ((folder.endsWith("/")) ? "" : "/") + SubFolder;
	    }

	    folder = Util.ClearPath(folder);

	    if (!(folder.startsWith("/")))
	      folder = ch.getFullPath() + "/" + folder;

	    return folder;
	  }
	
	public String downloadImage(Spider s, String c, String itemurl)
			throws MessageException, SQLException {
		String Path = "";
		String SiteUrl = "";
		Site site = null;
		boolean need_httpurl = true;
		TideJson photo_config = CmsCache.getParameter("sys_config_photo")
				.getJson();// 图片及图片库配置
		int sys_channelid_image = photo_config.getInt("channelid");
		int force_httpurl = photo_config.getInt("force_httpurl");
		Channel channel;
		if (sys_channelid_image > 0) {
			// 配置了图片库
			Channel channel2 = CmsCache.getChannel(s.getChannel());
			channel = CmsCache.getChannel(sys_channelid_image);
			site = channel.getSite();
			Path = getdownloadImageFolder(channel,s);//此处获取图片保存路径(采集图片存储在images2中)
			SiteUrl = site.getExternalUrl();
			// System.out.println("siteid:"+channel2.getSiteID()+","+channel.getSiteID()+","+force_httpurl);
			if (channel2.getSiteID() == channel.getSiteID()
					&& force_httpurl == 0) {
				need_httpurl = false;
			}
			// System.out.println("need_httpurl:"+need_httpurl+","+Path);
		}
		String SiteFolder = site.getSiteFolder();
		String RealPath = SiteFolder + (SiteFolder.endsWith("/") ? "" : "/")
				+ Path;
		File file = new File(RealPath);
		if (!file.exists())
			file.mkdirs();

		//System.out.println("-----qukeji RealPath" + RealPath);
		CmsFile cmsfile = new CmsFile();
		ArrayList array = getImagesHref(c);
		for (int i = 0; i < array.size(); i++) {
			String img = (String) array.get(i);
			// System.out.println("img1:"+img);
			String ext = Util.getFileExt(img);
			//System.out.println("----qukejiimg-----" + img);
			if (ext.equalsIgnoreCase("jpg") || ext.equalsIgnoreCase("png")
					|| ext.equalsIgnoreCase("bmp")
					|| ext.equalsIgnoreCase("gif")) {
				String FileName = img.substring(img.lastIndexOf("\\") + 1);
				String NewFileName = cmsfile.getNewFileName(FileName, "", 8);

				String imgurl = getRealImageHref(img, itemurl);

				//System.out.println("qukejijimg:" + imgurl);
				boolean result = false;
				try {
					URL url = new URL(imgurl);
					URLConnection con = url.openConnection();
					InputStream is = con.getInputStream();
					byte[] bs = new byte[1024];
					int len;
					OutputStream os = new FileOutputStream(RealPath + "/"
							+ NewFileName);
				//	System.out.println("---------save image" + RealPath + "/"
				//			+ NewFileName);

					while ((len = is.read(bs)) != -1) {
						os.write(bs, 0, len);
					}

					os.close();
					is.close();

					result = true;
				} catch (Exception e) {
					Log.SystemLog(LogAction.systemlog_spider, "采集图片失败,页面地址："
							+ itemurl + ",图片地址：" + imgurl);
				}
				//System.out.println("---------下载结果" + result);
				if (result) {
					String ReturnValue = "";
					if (need_httpurl) {
						ReturnValue += Util.ClearPath(SiteUrl + Path + "/"
								+ NewFileName);
					}
					String newimghref = Util.ClearPath(ReturnValue);
			
					c = c.replace(img, newimghref);
//					Publish publish = new Publish();
//					publish.InsertToBePublished(newimghref, SiteFolder, site);
					FileUtil fileutil = new FileUtil();
					fileutil.PublishFiles(NewFileName, RealPath.replace(SiteFolder, ""),
							SiteFolder, 0, site);
					
					
				}
			}
		}

		PublishManager publishmanager = PublishManager.getInstance();
		publishmanager.FilePublish(0);
		return c;
	}

//	public static void main(String[] args) {
//		String a = "<p align=\"center\"><IMG alt=\"兰州安宁回应&ldquo;执法局长与女下属开房&rdquo;:早前已查处\" src=\"http://img1.gtimg.com/news/pics/hv1/175/178/1952/126974365.jpg\" /></p><p style=\"TEXT-INDENT: 2em\">10月27日，&ldquo;兰州安宁城管执法局局长与女下属开房&rdquo;的视频在网上传播，引发大量网友关注。网络截图摄</p><p align=\"center\"><img alt=\"兰州回应&ldquo;执法局长与女下属开房&rdquo;：已查处\" src=\"http://img1.gtimg.com/news/pics/hv1/178/178/1952/126974368.jpg\" /></p><p style=\"TEXT-INDENT: 2em\">10月27日，针对网传安宁区执法局局长阿迪力违反八项规定受到处分一事，官方做出了回应。兰州市安宁区人民政府网摄</p><p style=\"TEXT-INDENT: 2em\">中新网兰州10月27日电 一段&ldquo;兰州安宁城管执法局局长与女下属开房&rdquo;的视频在网上传播。27日，安宁区政府新闻办披露，7月3日，该区纪委就接到群众关于该局长的相关举报，并及时开展了调查。</p><p style=\"TEXT-INDENT: 2em\">经核实，2015年6月16日至6月22日，该局局长阿迪力&middot;艾尔肯在深圳休假期间，与同事接受与单位有业务往来的经商人员吃请购物，其行为违反了廉洁自律有关规定和中央八项规定精神。2015年9月29日，安宁区纪委给予阿迪力&middot;艾尔肯党内严重警告处分。</p><p style=\"TEXT-INDENT: 2em\">当日热传的&ldquo;开房&rdquo; 之说，官方称目前没有证据，将作进一步调查。</p>";
//		
//		ArrayList<String> arr=getImagesHref(a);
//		for(String b:arr){
//			System.out.println(b);
//		}
//	}

	// 根据给定的起始字符串和结束字符串，从大的字符串中截取出来
	public static String cutString(String content, String begin, String end) {
		String s = "";
		int m = content.indexOf(begin);
		if (m != -1) {
			String content1 = content.substring(m + begin.length());
			int n = content1.indexOf(end);
			if (n != -1) {
				s = content1.substring(0, n);
			}
		}

		return s;
	}

	/**
	 * 判断是否需要采集内容页
	 * 
	 * @param s
	 * @param url
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	public synchronized boolean canSpider(Spider s, String url)
			throws MessageException, SQLException {
		boolean can = true;
		int value = 0;

		if (CmsCache.redis) {
			Jedis jedis = new Jedis("localhost");
			String key = "spider_url_" + url;
			value = Util.parseInt(jedis.get(key));
		}
		if (value > 0) {
			can = false;
		} else {
			Channel channel = CmsCache.getChannel(s.getChannel());
			TableUtil tu = new TableUtil();
			String sql = "select id from " + channel.getTableName()
					+ " where Active=1 and SpiderUrl='" + tu.SQLQuote(url)
					+ "'";
			// System.out.println(sql);
			ResultSet rs = tu.executeQuery(sql);
			if (rs.next()) {
				can = false;
			}
			tu.closeRs(rs);
		}
		return can;
	}

	public Thread getRunner() {
		return runner;
	}
}
