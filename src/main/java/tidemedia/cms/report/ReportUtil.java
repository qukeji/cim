package tidemedia.cms.report;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.excel.TableToXls;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.Site;
import tidemedia.cms.user.UserGroup;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.FileUtil;
import tidemedia.cms.util.RandomUtil;

/**
 * 工作量统计工具类
 * 
 * @author jiangzeyin
 * 
 */
public class ReportUtil
{
	static FileUtil fu = new FileUtil();
	
	/**
	 * 查询一行一列
	 * 
	 * @param sql
	 * @param type
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	private static String selectOnlyOne(String sql, String type)
	    throws MessageException, SQLException
	{
		TableUtil tu = null;
		if (type == null)
			tu = new TableUtil();
		else
			tu = new TableUtil(type);
		ResultSet rs = tu.executeQuery(sql);
		String result = "0";
		if (rs.next())
		{
			result = rs.getString(1);
		}
		tu.closeRs(rs);
		return result;
	}
	
	/**
	 * 获取发稿量
	 * 
	 * @param id
	 *            对应id
	 * @param dateway
	 *            查询时间类型
	 * @param type
	 *            查询类型
	 * @return
	 * @throws NumberFormatException
	 * @throws MessageException
	 * @throws SQLException
	 */
	public static int getReport(int id, String dateway, String type)
	    throws NumberFormatException, MessageException, SQLException
	{
		String[] time = getToDayTime(dateway);
		String sql = "select count(GlobalID) as count FROM item_snap use index(index_2) where Status=1 ";
		switch (reportType.valueOf(type))
		{
			case person:
				sql += "and user=" + id;
				break;
			case column:
				sql += "and ChannelID =" + id;
				break;
			case depart:
			{
				String sql_ = "select group_concat(id) from userinfo where GroupID=" + id;
				String uid = selectOnlyOne(sql_ , "user");
				sql += "and User in(" + uid + ")";
				break;
			}
			case site:
			{
				String sql_ = "select group_concat(id) from channel where site=" + id;
				String cid = selectOnlyOne(sql_ , null);
				sql += "and ChannelID in(" + cid + ")";
				break;
			}
			default:
				break;
		}
		sql += " and CreateDate>=" + time[0] + " and CreateDate<" + time[1];
		return Integer.parseInt(selectOnlyOne(sql , null));
	}
	
	/**
	 * 获取部门的人数
	 * 
	 * @param groupId
	 * @return
	 * @throws SQLException
	 * @throws MessageException
	 */
	public static int getDepartUserCount(int groupId)
	    throws SQLException, MessageException
	{
		String sql = "select count(id) from userinfo where GroupID=" + groupId;
		return Integer.parseInt(selectOnlyOne(sql , "user"));
	}
	
	/**
	 * 获取站点栏目数
	 * 
	 * @param siteid
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	public static int getSiteChannelCount(int siteid)
	    throws MessageException, SQLException
	{
		String sql = "select count(id) from channel where site=" + siteid;
		return Integer.parseInt(selectOnlyOne(sql , null));
	}
	
	/**
	 * 获取发稿量图标数据
	 * 
	 * @param id
	 * @param dateway
	 * @param type
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 * @throws JSONException
	 */
	public static String getReportChart(int id, String dateway, String type)
	    throws MessageException, SQLException, JSONException
	{
		dateway = dateway.trim().toLowerCase();
		String[] time = getToDayTime(dateway);
		JSONObject jo = null;
		String name = "";
		String sql = "select CreateDate FROM item_snap use index(index_2) where  Active=1 and Status=1 ";
		switch (reportType.valueOf(type))
		{
			case person:
			{
				sql += "and user=" + id;
				jo = getReportChart(sql , dateway);
				name = new UserInfo(id).getName();
				break;
			}
			case column:
			{
				sql += "and ChannelID =" + id;
				jo = getReportChart(sql , dateway);
				name = new Channel(id).getName();
				break;
			}
			case depart:
			{
				String sql_ = "select group_concat(id) from userinfo where GroupID=" + id;
				String uid = selectOnlyOne(sql_ , "user");
				sql += "and User in(" + uid + ")";
				name = new UserGroup(id).getName();
				break;
			}
			case site:
			{
				String sql_ = "select group_concat(id) from channel where site=" + id;
				String cid = selectOnlyOne(sql_ , null);
				sql += "and ChannelID in(" + cid + ")";
				name = new Site(id).getName();
				break;
			}
			default:
				break;
		}
		sql += " and CreateDate>=" + time[0] + " and CreateDate<" + time[1];
		jo = getReportChart(sql , dateway);
		jo.put("name" , name);
		return jo.toString();
	}
	
	/**
	 * 获取发稿量图标数据
	 * 
	 * @param sql
	 * @param dateway
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 * @throws JSONException
	 */
	@SuppressWarnings("unchecked")
	private static JSONObject getReportChart(String sql, String dateway)
	    throws MessageException, SQLException, JSONException
	{
		dateway = dateway.trim().toLowerCase();
		// 得到时间差
		TableUtil tu = new TableUtil();
		Object[] obj = getDateWayType(dateway);
		HashMap<String, Integer> map = (HashMap<String, Integer>) obj[0];
		List<String> xaxis = (List<String>) obj[1];
		List<Integer> value = new ArrayList<Integer>();
		// 数据库查询
		ResultSet rs = tu.executeQuery(sql);
		while (rs.next())
		{
			String t = rs.getString("CreateDate");
			// 得到当前时间对应值
			String key = getDateCurr(t , dateway) + "";
			System.out.println(key + "  " + map.size());
			int n = map.get(key) + 1;
			map.put(key , n);
		}
		tu.closeRs(rs);
		// 取出值
		Iterator<Map.Entry<String, Integer>> entries = map.entrySet().iterator();
		while (entries.hasNext())
		{
			Entry<String, Integer> entry = entries.next();
			value.add(entry.getValue());
		}
		JSONObject jo = new JSONObject();
		jo.put("xaxis" , xaxis);
		jo.put("value" , value);
		return jo;
	}
	
	/**
	 * 根据时间类型得到map 和x轴
	 * 
	 * @param dateway
	 * @return Object[0] x对应点值 Object[1] 对应x轴
	 */
	private static Object[] getDateWayType(String dateway)
	{
		Object[] obj = new Object[2];
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		List<String> xaxis = new ArrayList<String>();
		// 创建x轴 和对应键值对
		switch (dateWay.valueOf(dateway))
		{
			case today:
				for (int i = 0; i < 24; i += 2)
				{
					map.put(i + "" , 0);
					if (i < 23)
						xaxis.add((i + 1) + "");
					else
						xaxis.add((i + 1) + "/时");
				}
				break;
			case week:
				for (int i = 0; i < 7; i++)
				{
					map.put((i + 1) + "" , 0);
					if (i < 6)
						xaxis.add((i + 1) + "");
					else
						xaxis.add((i + 1) + "/星期");
				}
			case month:
				Calendar aCalendar = Calendar.getInstance(Locale.CHINA);
				int day = aCalendar.getActualMaximum(Calendar.DATE);
				for (int i = 0; i < day; i++)
				{
					map.put((i + 1) + "" , 0);
					if (i < day - 1)
						xaxis.add((i + 1) + "");
					else
						xaxis.add((i + 1) + "/日");
				}
			case year:
				for (int i = 0; i < 12; i++)
				{
					map.put((i + 1) + "" , 0);
					if (i < 11)
						xaxis.add((i + 1) + "");
					else
						xaxis.add((i + 1) + "/月");
				}
			default:
				break;
		}
		obj[0] = map;
		obj[1] = xaxis;
		return obj;
	}
	
	/**
	 * 获取所有站点数据
	 * 
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 * @throws JSONException
	 */
	public static String getSiteData()
	    throws MessageException, SQLException, JSONException
	{
		JSONArray jo = new JSONArray();
		String sql = "select id,name from site";
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		while (rs.next())
		{
			if (rs.getInt("id") == 1)
				continue;
			JSONObject job = new JSONObject();
			job.put("id" , rs.getInt("id"));
			job.put("name" , rs.getString("name"));
			jo.put(job);
		}
		tu.closeRs(rs);
		return jo.toString();
	}
	
	/***
	 * 根据指定参数返回对应时间戳（10位）
	 * 
	 * @param way
	 * @return String[0] 开始时间 String[1] 结束时间
	 */
	public static String[] getToDayTime(String way)
	{
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.SECOND , 0);
		cal.set(Calendar.MINUTE , 0);
		cal.set(Calendar.HOUR , 0);
		switch (dateWay.valueOf(way))
		{
			case today:
				break;
			case week:
				int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK) - 2;
				if (dayOfWeek == -1)
					dayOfWeek = 7;
				cal.set(Calendar.DATE , cal.get(Calendar.DATE) - dayOfWeek);
				break;
			case month:
				cal.set(Calendar.DATE , 1);
				break;
			case year:
				cal.set(Calendar.MONTH , 0);
				cal.set(Calendar.DATE , 1);
			default:
				break;
		}
		// SimpleDateFormat formatter = new
		// SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String bengin = (cal.getTimeInMillis() + "").substring(0 , 10);
		String end = (System.currentTimeMillis() + "").substring(0 , 10);
		return new String[]
		{ bengin, end };
	}
	
	// static SimpleDateFormat formatter = new
	// SimpleDateFormat("yyyyMMddHHmmss");
	/**
	 * 获取指定时间戳的指定数值
	 * 
	 * @param time
	 * @param dateway
	 * @return
	 */
	public static int getDateCurr(String time, String dateway)
	{
		Calendar c = Calendar.getInstance();
		if (time.length() == 10)
			time += "000";
		c.setTimeInMillis(Long.parseLong(time));
		switch (dateWay.valueOf(dateway))
		{
			case today:
				return c.get(Calendar.HOUR);
			case week:
				int week = c.get(Calendar.DAY_OF_WEEK) - 1;
				if (week == 0)
					week = 7;
				return week;
			case month:
				return c.get(Calendar.DATE);
			case year:
				return c.get(Calendar.MONTH) + 1;
			default:
				break;
		}
		return 0;
	}
	
	/**
	 * 时间类型
	 * 
	 * @author Administrator
	 * 
	 */
	enum dateWay
	{
		today, week, month, year
	}
	
	/**
	 * 工作量统计类型
	 * 
	 * @author Administrator
	 * 
	 */
	enum reportType
	{
		person, depart, column, site
	}
	
	/**
	 * 获取table html数据
	 * 
	 * @param type
	 * @param where
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 * @throws IOException
	 */
	public static String getDowanFileName(String type, String where)
	    throws MessageException, SQLException, IOException
	{
		StringBuffer sbf = new StringBuffer();
		String[] headers = new String[6];
		TableUtil tu = new TableUtil();
		HashMap<Integer, String[]> map = new HashMap<Integer, String[]>();
		Map<Integer, Long> sortMap = new TreeMap<Integer, Long>();
		long dayCount = 0;
		long weekCount = 0;
		long monthCount = 0;
		long yearCount = 0;
		long count = 0;
		int index = 0;
		ResultSet rs = null;
		headers[2] = "本天";
		headers[3] = "本周";
		headers[4] = "本月";
		headers[5] = "本年";
		switch (reportType.valueOf(type))
		{
			case person:
			{
				headers[0] = "发稿人";
				headers[1] = "所属部门";
				map.put(-1 , headers);
				String sql = "select * from userinfo where Username like '%" + where + "%'";
				TableUtil tu_user = new TableUtil("user");
				rs = tu_user.executeQuery(sql);
				while (rs.next())
				{
					count = 0;
					headers = new String[6];
					headers[0] = rs.getString("Name");
					try
					{
						UserGroup u = new UserGroup(rs.getInt("GroupID"));
						headers[1] = u.getName();
					} catch (Exception e)
					{
						// TODO: handle exception
						headers[1] = "";
					}
					int id = rs.getInt("id");
					headers[2] = getReport(id , "today" , type) + "";
					count += Long.parseLong(headers[2]);
					dayCount += Long.parseLong(headers[2]);
					headers[3] = getReport(id , "week" , type) + "";
					count += Long.parseLong(headers[3]);
					weekCount += Long.parseLong(headers[3]);
					headers[4] = getReport(id , "month" , type) + "";
					count += Long.parseLong(headers[4]);
					monthCount += Long.parseLong(headers[4]);
					headers[5] = getReport(id , "year" , type) + "";
					count += Long.parseLong(headers[5]);
					yearCount += Long.parseLong(headers[5]);
					map.put(index , headers);
					sortMap.put(index++ , count);
				}
				break;
			}
			case column:
			{
				headers[0] = "发稿频道";
				headers[1] = "对应站点";
				map.put(-1 , headers);
				String[] s = where.split(":");
				String channelCode = "";
				String ListSql = "select distinct * from item_snap where ChannelID in(" + s[0] + ")";
				// 包含子频道
				if ("1".equalsIgnoreCase(s[1]))
				{
					String sql = "select ChannelCode from item_snap where ChannelID in(" + s[0] + ")";
					ResultSet Rs = tu.executeQuery(sql);
					while (Rs.next())
					{
						channelCode += " ChannelCode like '" + Rs.getString(1) + "%' or";
					}
					// System.out.println("channel" + channelCode);
					if (channelCode.length() - 1 == channelCode.lastIndexOf("r") && channelCode.lastIndexOf("or") != -1)
					{
						channelCode = channelCode.substring(0 , channelCode.lastIndexOf("or"));
					}
					if (channelCode.length() > 0)
						ListSql += " or " + channelCode;
				}
				// System.out.println(ListSql);
				ListSql += " group by ChannelID";
				rs = tu.executeQuery(ListSql);
				while (rs.next())
				{
					count = 0;
					headers = new String[6];
					int id = rs.getInt("ChannelID");
					Channel ch = new Channel(id);
					headers[0] = ch.getName() + "";
					headers[1] = ch.getSite().getName() + "";
					headers[2] = getReport(id , "today" , type) + "";
					count += Long.parseLong(headers[2]);
					dayCount += Long.parseLong(headers[2]);
					headers[3] = getReport(id , "week" , type) + "";
					count += Long.parseLong(headers[3]);
					weekCount += Long.parseLong(headers[3]);
					headers[4] = getReport(id , "month" , type) + "";
					count += Long.parseLong(headers[4]);
					monthCount += Long.parseLong(headers[4]);
					headers[5] = getReport(id , "year" , type) + "";
					count += Long.parseLong(headers[5]);
					yearCount += Long.parseLong(headers[5]);
					map.put(index , headers);
					sortMap.put(index++ , count);
				}
				break;
			}
			case depart:
			{
				headers[0] = "发稿部门";
				headers[1] = "部门人数";
				map.put(-1 , headers);
				TableUtil tu_user = new TableUtil("user");
				String ListSql = "select * from user_group";
				rs = tu_user.executeQuery(ListSql);
				while (rs.next())
				{
					count = 0;
					headers = new String[6];
					headers[0] = rs.getString("Name") + "";
					int id = rs.getInt("id");
					headers[1] = getDepartUserCount(id) + "";
					headers[2] = getReport(id , "today" , type) + "";
					count += Long.parseLong(headers[2]);
					dayCount += Long.parseLong(headers[2]);
					headers[3] = getReport(id , "week" , type) + "";
					count += Long.parseLong(headers[3]);
					weekCount += Long.parseLong(headers[3]);
					headers[4] = getReport(id , "month" , type) + "";
					count += Long.parseLong(headers[4]);
					monthCount += Long.parseLong(headers[4]);
					headers[5] = getReport(id , "year" , type) + "";
					count += Long.parseLong(headers[5]);
					yearCount += Long.parseLong(headers[5]);
					map.put(index , headers);
					sortMap.put(index++ , count);
				}
				break;
			}
			case site:
			{
				headers[0] = "发稿站点";
				headers[1] = "栏目数";
				map.put(-1 , headers);
				String ListSql = "select * from site ";
				rs = tu.executeQuery(ListSql);
				while (rs.next())
				{
					count = 0;
					headers = new String[6];
					headers[0] = rs.getString("Name") + "";
					// 排除默认站点
					int id = rs.getInt("id");
					if (id == 1)
						continue;
					headers[1] = getSiteChannelCount(id) + "";
					headers[2] = getReport(id , "today" , type) + "";
					count += Long.parseLong(headers[2]);
					dayCount += Long.parseLong(headers[2]);
					headers[3] = getReport(id , "week" , type) + "";
					count += Long.parseLong(headers[3]);
					weekCount += Long.parseLong(headers[3]);
					headers[4] = getReport(id , "month" , type) + "";
					count += Long.parseLong(headers[4]);
					monthCount += Long.parseLong(headers[4]);
					headers[5] = getReport(id , "year" , type) + "";
					count += Long.parseLong(headers[5]);
					yearCount += Long.parseLong(headers[5]);
					map.put(index , headers);
					sortMap.put(index++ , count);
				}
				break;
			}
		}
		List<Entry<Integer, Long>> list = new ArrayList<Map.Entry<Integer, Long>>(sortMap.entrySet());
		// 然后通过比较器来实现排序
		Collections.sort(list , new Comparator<Map.Entry<Integer, Long>>()
		{
			// 升序排序
			public int compare(Entry<Integer, Long> o1, Entry<Integer, Long> o2)
			{
				return o2.getValue().compareTo(o1.getValue());
			}
		});
		
		String[] h = map.get(-1);
		sbf.append("<table><thead><tr>");
		// 添加表格头
		for (int i = 0; i < h.length; i++)
		{
			if (i == 0)
				sbf.append("<th style=\"text-align: left; font: 11pt; width: 15px;\">" + h[i] + "</th>");
			else if (i == 1)
				sbf.append("<th style=\"text-align: center; font: 11pt; width: 13px;\">" + h[i] + "</th>");
			else
				sbf.append("<th style=\"text-align: center; font: 11pt;\">" + h[i] + "</th>");
		}
		sbf.append("</tr></thead><tbody>");
		// 添加表格内容
		for (Map.Entry<Integer, Long> item : list)
		{
			Object value = map.get(item.getKey());
			h = (String[]) value;
			sbf.append("<tr>");
			for (int i = 0; i < h.length; i++)
			{
				if (i == 0)
					sbf.append("<th style=\"text-align: left; font: 11pt;\">" + h[i] + "</th>");
				else
					sbf.append("<th style=\"text-align: center; font: 11pt;\">" + h[i] + "</th>");
			}
			sbf.append("</tr>");
		}
		// 添加合计
		sbf.append("<thead><tr><td colspan=\"2\" style=\"text-align: right;\">合计</td>");
		sbf.append("<th style=\"text-align: center; font: 11pt;\">" + dayCount + "</th>");
		sbf.append("<th style=\"text-align: center; font: 11pt;\">" + weekCount + "</th>");
		sbf.append("<th style=\"text-align: center; font: 11pt;\">" + monthCount + "</th>");
		sbf.append("<th style=\"text-align: center; font: 11pt;\">" + yearCount + "</th>");
		sbf.append("</tr></thead>");
		sbf.append("</tbody></table>");
		// html转换为excel byte数据
		byte[] by = TableToXls.process(sbf);
		String fileName = getFileName();
		// 写文件
		FileOutputStream out = new FileOutputStream(fileName);
		out.write(by);
		File file = new File(fileName);
		if (!file.exists())
			return "";
		return fileName;
	}
	
	/**
	 * 获取文件名时间格式
	 * 
	 * @return String[0] 前一天 String[1]今天
	 */
	private static String[] getBeforeDayAndToDay()
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		Calendar cl = Calendar.getInstance();
		cl.setTimeInMillis(System.currentTimeMillis());
		int day = cl.get(Calendar.DATE);
		cl.set(Calendar.DATE , day - 1);
		String[] time = new String[2];
		time[0] = formatter.format(cl.getTime());
		time[1] = formatter.format(new Date());
		return time;
	}
	
	/**
	 * 获取文件名 并删除前一天生成的对应文件
	 * 
	 * @return
	 */
	private static String getFileName()
	{
		// excal_work_122
		String path = ReportUtil.class.getClassLoader().getResource("../../").getPath() + "temp/".toString();
		File file = new File(path);
		file.mkdirs();
		String[] time = getBeforeDayAndToDay();
		String yesterday = "excal_work_" + time[0];
		for (String f : file.list())
			if (f.contains(yesterday))
				new File(path + "" + f).delete();
		path = path + "excal_work_" + time[1] + RandomUtil.getRandom(System.currentTimeMillis()) + ".xls";
		return path;
	}
	
	public static void main(String[] args)
	    throws FileNotFoundException, MessageException, SQLException
	{
		
		// new ArrayList<E>().size()
		String s = "sdfsdf or";
		if (s.length() - 1 == s.lastIndexOf("r"))
		{
			s = s.substring(0 , s.lastIndexOf("or"));
		}
		// System.out.println(s);
		// System.out.println(Util.FormatTimeStamp("yyyyMMddHHmmss" ,
		// 1341542785));
	}
}
