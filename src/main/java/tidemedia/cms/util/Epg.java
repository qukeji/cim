/**
 * @author hailong
 */
package tidemedia.cms.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import org.apache.commons.fileupload.FileItem;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.ItemUtil;

public class Epg
{
	public static int totalNum = 0;
	public static String errorDay = "";
	
	// 判断是某个频道下是否存在某一天的节目单
	/*
	 * private static boolean isExist(int channelid,String day) throws
	 * SQLException,MessageException { Channel channel =
	 * CmsCache.getChannel(channelid); TableUtil tu = channel.getTableUtil();
	 * String sql = "select id from "+channel.getTableName()+
	 * " where Active=1 and Broadcast_Date='"+day+"'";
	 * if(channel.getType()==Channel.Category_Type) sql
	 * +=" and category="+channelid; ResultSet rs = tu.executeQuery(sql);
	 * if(rs.next()) return true; return false; }
	 */
	
	private static long parseDateTime(String datetime)
	{
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		try
		{
			Date date = format.parse(datetime);
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			return cal.getTimeInMillis() / 1000;
		} catch (ParseException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return 0;
	}
	
	private static String getDate(String date, int days)
	{
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Calendar calendar = Calendar.getInstance();
		try
		{
			Date temp = df.parse(date);
			calendar.setTime(temp);
			calendar.set(Calendar.DAY_OF_YEAR , calendar.get(Calendar.DAY_OF_YEAR) - days);
		} catch (ParseException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return df.format(calendar.getTime());
		
	}
	
	public static void main(String[] args)
	{
		System.out.println("08:49:23".compareTo("11:59:23"));
		// System.out.println(getDate("2015/2/21 11:30:00",-1));
	}
	
	private static boolean importData(HashMap<String, String> map, int channelId)
	{
		
		boolean success = true;
		
		try
		{
			ItemUtil.addItem(channelId , map).getId();
			totalNum = totalNum += 1;
		} catch (MessageException e)
		{
			e.printStackTrace();
			success = false;
		} catch (SQLException e)
		{
			e.printStackTrace();
			success = false;
		}
		return success;
	}
	
	
	public static boolean epgDeal(FileItem item, int ChannelID, int user)
	{
		
		boolean uploadResult = true;
		// 数据清空
		errorDay = "";
		totalNum = 0;
		try
		{
			String FileName = item.getName();
			if (!FileName.equals(""))
			{
				InputStream is = item.getInputStream();
				BufferedReader br = new BufferedReader(new InputStreamReader(is , "GBK"));
				String strLine = "";
				// String programType = "";
				String broadcastDate = "";
				boolean result = true;
				
				// 下一次循环时，把前一次的数据入库，针对某一天的最后一次数据单独入库
				String startTime = "";
				String title = "";
				while ((strLine = br.readLine()) != null)
				{
					
					
					String summary = "";
					if (strLine.startsWith("日期"))
					{
						
						/*
						 * if(!result) { //入库，针对一次导入多天的情况的，某一天最后一条记录
						 * //uploadResult = importData(title, startTime,
						 * "23:59:59", summary, broadcastDate, ChannelID);
						 * uploadResult = importData(title,
						 * broadcastDate+" "+startTime,
						 * broadcastDate+" 23:59:59", summary, ChannelID); }
						 */
						
						// result = true;
						broadcastDate = (strLine.split(","))[1];
						// 如果某个频道已经存在了某天的数据，则不进行导入,直接退出
						/*
						 * if(isExist(ChannelID,broadcastDate)) { uploadResult =
						 * false; errorDay = broadcastDate; break outer; }
						 */
						continue;
					}
					
					if (strLine.startsWith("起始时间"))
					{
						continue;
					}
					
					// 把一行数据分割成多个字段
					String[] lines = strLine.split(",");
					
					if (lines.length == 3)
					{
						summary = lines[2];
					}
					if (result)
						result = false;
					else
					{
						String begin = broadcastDate + " " + startTime;// 2015-05-12
						//title = lines[1];                                       // 23:39:23
						                                               // 2015-05-12
						                                               // 23:49:23
						String end = broadcastDate + " " + lines[0];// 2015-05-12
						                                            // 03:23:23
						System.out.println(begin + "---" + end+"----" +title);
						if (parseDateTime(begin) > parseDateTime(end))// 跨天
						// if(startTime.compareTo(lines[0])>0)//跨天
						{
							end = getDate(end , -1);
							broadcastDate = end.substring(0 , 10);
						}
						HashMap<String, String> map = new HashMap<String, String>();
						map.put("Title" , title);
						map.put("start_time" , begin);
						map.put("end_time" , end);
						map.put("Summary" , summary);
						// map.put("tidecms_addGlobal","1"); 不需要gid
						map.put("User" , user + "");
						uploadResult = importData(map , ChannelID);
						// uploadResult = importData(title, startTime, lines[0],
						// summary, broadcastDate, ChannelID);
					}
					title = lines[1];
					startTime = lines[0];
				}
				// 整个节目单文件的最后一条节目信息入库
				// uploadResult = importData(title, broadcastDate+" "+startTime,
				// broadcastDate+" 23:59:59", summary, ChannelID);
			}
		} catch (Exception e)
		{
			
			e.printStackTrace();
			uploadResult = false;
		}
		return uploadResult;
		
	}
	
//	public static boolean epgDeal(FileItem item, int ChannelID, int user,int parent)
//	{
//		
//		boolean uploadResult = true;
//		// 数据清空
//		errorDay = "";
//		totalNum = 0;
//		try
//		{
//			String FileName = item.getName();
//			if (!FileName.equals(""))
//			{
//				InputStream is = item.getInputStream();
//				BufferedReader br = new BufferedReader(new InputStreamReader(is , "GBK"));
//				String strLine = "";
//				// String programType = "";
//				String broadcastDate = "";
//				boolean result = true;
//				
//				// 下一次循环时，把前一次的数据入库，针对某一天的最后一次数据单独入库
//				String startTime = "";
//				while ((strLine = br.readLine()) != null)
//				{
//					String title = "";
//					
//					String summary = "";
//					if (strLine.startsWith("日期"))
//					{
//						
//						/*
//						 * if(!result) { //入库，针对一次导入多天的情况的，某一天最后一条记录
//						 * //uploadResult = importData(title, startTime,
//						 * "23:59:59", summary, broadcastDate, ChannelID);
//						 * uploadResult = importData(title,
//						 * broadcastDate+" "+startTime,
//						 * broadcastDate+" 23:59:59", summary, ChannelID); }
//						 */
//						
//						// result = true;
//						broadcastDate = (strLine.split(","))[1];
//						// 如果某个频道已经存在了某天的数据，则不进行导入,直接退出
//						/*
//						 * if(isExist(ChannelID,broadcastDate)) { uploadResult =
//						 * false; errorDay = broadcastDate; break outer; }
//						 */
//						continue;
//					}
//					
//					if (strLine.startsWith("起始时间"))
//					{
//						continue;
//					}
//					
//					// 把一行数据分割成多个字段
//					String[] lines = strLine.split(",");
//					
//					if (lines.length == 3)
//					{
//						summary = lines[2];
//					}
//					if (result)
//						result = false;
//					else
//					{
//						String begin = broadcastDate + " " + startTime;// 2015-05-12
//						title = lines[1];                                       // 23:39:23
//						                                               // 2015-05-12
//						                                               // 23:49:23
//						String end = broadcastDate + " " + lines[0];// 2015-05-12
//						                                            // 03:23:23
//						System.out.println(begin + "---" + end + "---"+title);
//						if (parseDateTime(begin) > parseDateTime(end))// 跨天
//						// if(startTime.compareTo(lines[0])>0)//跨天
//						{
//							end = getDate(end , -1);
//							broadcastDate = end.substring(0 , 10);
//						}
//						HashMap<String, String> map = new HashMap<String, String>();
//						map.put("Title" , title);
//						map.put("start_time" , begin);
//						map.put("end_time" , end);
//						map.put("Summary" , summary);
//						map.put("parent", parent+"");
//						// map.put("tidecms_addGlobal","1"); 不需要gid
//						map.put("User" , user + "");
//						uploadResult = importData(map , ChannelID);
//						// uploadResult = importData(title, startTime, lines[0],
//						// summary, broadcastDate, ChannelID);
//					}
//					
//					startTime = lines[0];
//				}
//				// 整个节目单文件的最后一条节目信息入库
//				// uploadResult = importData(title, broadcastDate+" "+startTime,
//				// broadcastDate+" 23:59:59", summary, ChannelID);
//			}
//		} catch (Exception e)
//		{
//			
//			e.printStackTrace();
//			uploadResult = false;
//		}
//		return uploadResult;
//		
//	}
	
}
