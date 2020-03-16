package tidemedia.cms.chaitiao2;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ItemUtil;
import tidemedia.cms.util.StringUtils;
import tidemedia.cms.util.Util;
/**
 * 
 * @author wanghailong
 * @date  20140402	
 * @action add
 * @info 自动拆条
 */
public class AutoChaiTiao {
	
	public static String rootfolder = "";//要截图的拆条文件的跟目录
	//自动拆条参数
	public static String chaitiao_publishfolder="";
	public static int chaitiao_xml_channelid=0;
	public static int chaitiao_channelid_relation=0;//直播频道与cms频道关联表
	public static int chaitiao_auto_channelid=0;
	private static AutoChaiTiao autoChaiTiao =null;
	
	public static AutoChaiTiao getInstance()
	{
		if(autoChaiTiao==null)
			autoChaiTiao = new AutoChaiTiao(); 
		return autoChaiTiao;
		
	}
	private AutoChaiTiao()
	{
		try {
			rootfolder = CmsCache.getParameterValue("chaitiao_rootfolder");
			chaitiao_publishfolder=CmsCache.getParameterValue("chaitiao_publishfolder");
			chaitiao_xml_channelid=CmsCache.getParameter("chaitiao_xml_channelid").getIntValue();
			chaitiao_auto_channelid=CmsCache.getParameter("chaitiao_auto_channelid").getIntValue();
			chaitiao_channelid_relation=CmsCache.getParameter("chaitiao_channelid_relation").getIntValue();
			
		} catch (MessageException e) {
			e.printStackTrace(System.out);
		} catch (SQLException e) {
			e.printStackTrace(System.out);
		}
		
		rootfolder = Util.ClearPath(rootfolder);
	}
	
	private static String getChaiChannelID(int cmsChannelID) throws MessageException, SQLException {
		Channel ch = CmsCache.getChannel(chaitiao_channelid_relation);
		String tablename = ch.getTableName();
		String sql = "select * from "+tablename+" where cmsChannelID="+cmsChannelID+" and Status=1";
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		String chai_channelid="";
		if(rs.next()){
			chai_channelid = rs.getString("channel_id");
		}
		tu.closeRs(rs);
		return chai_channelid;
	}
	
	
	//自动拆条xml拼接
	private static String getXML(String title, int cmsChannelID,
			long publishdate, String segments,String chai_channelid) {
		// TODO Auto-generated method stub
		
		String xml="<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><creation>"+publishdate+"</creation>"+
				"<title><![CDATA["+Util.XMLQuote(title)+"]]></title><publishid>"+cmsChannelID+"</publishid>"+
		        "<channelid>"+chai_channelid+"</channelid><segmentsuffix>f4v</segmentsuffix><images/>"+
		        segments+"</root>";

		return xml;
	}

	public static String getItemsByTime(String starttime, String endtime)
			throws ParseException {
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date sdate = df.parse(starttime);
		long slong = sdate.getTime();
		java.util.Date edate = df.parse(endtime);
		long elong = edate.getTime();
		long now = System.currentTimeMillis();
		String ymd = getFormatTime(now, "yyyyMMdd");
		String hm = getFormatTime(slong, "HHmm");
		String item = "";
		
		if (elong - slong > 0) {// 开始时间小于结束时间
			item += "<segments>";
			String scut = starttime.replace("-", "").replace(":", "").replace(" ", "");
			String ecut = endtime.replace("-", "").replace(":", "").replace(" ", "");
			String  ess = ecut.substring(12, 14);
			String sss = scut.substring(12, 14);

			if ((elong - slong) / 60000 > 0	|| Util.parseInt(ess) - Util.parseInt(sss) < 0) {// 跨分钟
				slong = getLastSecond(slong);
				item += "<item>" + ymd + "," + hm + ",00:00:" + sss	+ ".000,00:01:00.000</item>\n";

				long temp = 0;
				while (slong < elong) {
					long s = getZoroSecond(slong);
					if (temp > 0) {
						ymd = getFormatTime(s, "yyyyMMdd");
						hm = getFormatTime(s, "HHmm");
						item += "<item>" + ymd + "," + hm + ",-1,-1"+ "</item>";
					}
					temp = slong;
					slong = getNextMinute(slong);
				}
				ymd = ecut.substring(0, 8);
				hm = ecut.substring(8, 12);
				if(!ess.equals("00")){
					item += "<item>" + ymd + "," + hm + ",00:00:00.000,00:00:" + ess+ ".000</item>\n";
				}

			} else {// 没有跨分钟

				item += "<item>" + ymd + "," + hm + ",00:00:" + sss
						+ ".000,00:00:" + ess + ".000</item>\n";
			}
			item += "</segments>";
		} else {
			System.out.println("时间格式不符合规范");
		}
		return item;
	}

	private static String getFormatTime(long slong, String pattern) {
		// TODO Auto-generated method stub
		 DateFormat df = new SimpleDateFormat(pattern);
		java.util.Date date = new java.util.Date();
		date.setTime(slong);
		String ss = df.format(date.getTime());
		return ss;
	}

	private static long getZoroSecond(long date) {
		Calendar sDate = new java.util.GregorianCalendar();
		sDate.setTimeInMillis(date);
		sDate.set(Calendar.SECOND, 0);
		return sDate.getTimeInMillis();

	}


	private static long getLastSecond(long date) {
		// TODO Auto-generated method stub
		Calendar sDate = new java.util.GregorianCalendar();
		sDate.setTimeInMillis(date);
		sDate.set(Calendar.SECOND, 59);
		return sDate.getTimeInMillis();
	}

	private static long getNextMinute(long date) {
		// TODO Auto-generated method stub
		Calendar sDate = new java.util.GregorianCalendar();
		sDate.setTimeInMillis(date);
		sDate.add(Calendar.MINUTE, 1);
		return sDate.getTimeInMillis();
	}

	public  void startAutoChai()throws MessageException, SQLException,ParseException {
		
		long now = System.currentTimeMillis();
		String nowDate = Util.FormatDate("yyyy-MM-dd", now);
		String nowDateTime = getFormatTime(now,"HH:mm:ss");
		String random=StringUtils.randomString(7);
		
		HashMap temp = new HashMap();
		temp.put("task_date", nowDate);
		temp.put("Status", "1");
		
		Channel ch = CmsCache.getChannel(chaitiao_auto_channelid);
		TableUtil tu = ch.getTableUtil();
		String sql = "select * from " + ch.getTableName() + " where status=1 and  end < '"+nowDateTime+"' and task_date !='"+nowDate+"'";
		ResultSet rs = tu.executeQuery(sql);
		
		while (rs.next()) {
			/* 
			String cycle = rs.getString("cycle");
			if(!cycle.equals(""))
			{
				//获取当前星期 看cycle是否包含当前星期 如果包含
				 * 拼接starttime,endtime
			}*/
			 
			String title = rs.getString("Title");
			int GlobalID = rs.getInt("GlobalID");
			int cmsChannelID = rs.getInt("cmsChannelID");			
			String chai_channelid = getChaiChannelID(cmsChannelID);
			String starttime = rs.getString("start");
			String endtime = rs.getString("end");
			if(starttime.compareTo(endtime)>0)
			{
				Date d=new Date(now-1000*60*60*24);
				SimpleDateFormat sp=new SimpleDateFormat("yyyy-MM-dd");
				starttime = sp.format(d) +" "+starttime;
			}
			else
				starttime = nowDate +" "+starttime;
			endtime = nowDate +" "+endtime;
			//System.out.println(starttime+"=="+endtime);
			String segments = getItemsByTime(starttime, endtime);
			String summary = getXML(title,cmsChannelID,now,segments,chai_channelid);
			HashMap map = new HashMap();
			map.put("Title", title+"_"+now);
			map.put("Summary", summary);
			map.put("FileName", chaitiao_publishfolder+"/"+chai_channelid+"_"+GlobalID+"_"+random+".xml");//拆条时 用的字段，后续处理时 再删除
			map.put("Status2","0");
			map.put("tidecms_addGlobal", "1");
			
			ItemUtil.addItem(chaitiao_xml_channelid, map);
			
			ItemUtil.updateItemByGid(chaitiao_auto_channelid, temp, GlobalID, 1);
		}
		tu.closeRs(rs);
	}

}
