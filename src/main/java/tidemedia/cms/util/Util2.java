package tidemedia.cms.util;

import java.io.*;
import java.sql.SQLException;
import java.util.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.security.Key;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.StringTokenizer;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.json.JSONException;
import org.json.JSONObject;

import sun.misc.BASE64Encoder;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;

/**
 * @author 李永海(liyonghai@163.net)
 * 2004/06/24
 *
 */
public class Util2 {
	/**
	 * 获取当前的日期字串,格式是"yyyy-MM-dd"
	 * @return String
	 */
	public static String getCurrentDate() {
		java.util.Calendar nowDate = new java.util.GregorianCalendar();
		int year = nowDate.get(Calendar.YEAR);
		int month = nowDate.get(Calendar.MONTH) + 1;
		int day = nowDate.get(Calendar.DATE);
		return year + "-" + month + "-" + day;
	}

	/**
	 * 获取当前的日期字串,格式是"yyyy-MM-dd" yyyy-MM-dd HH:mm:ss
	 * @return String
	 */
	public static String getCurrentDate(String pattern) {
		java.util.Calendar nowDate = new java.util.GregorianCalendar();
		DateFormat df = new SimpleDateFormat(pattern);
		return df.format(nowDate.getTime());
	}

	/**
	 * 获取当前的日期时间字串
	 * @return String
	 */
	public static String getCurrentDateTime() {
		java.util.Calendar nowDate = new java.util.GregorianCalendar();
		int year = nowDate.get(Calendar.YEAR);
		int month = nowDate.get(Calendar.MONTH) + 1;
		int day = nowDate.get(Calendar.DATE);
		return year
				+ "-"
				+ month
				+ "-"
				+ day
				+ " "
				+ nowDate.get(Calendar.HOUR_OF_DAY)
				+ ":"
				+ nowDate.get(Calendar.MINUTE);
	}


	//格式化日期
	public static String FormatDate(String pattern, String date) {
		return FormatDate(pattern,date,"","");
	}

	//格式化日期，带时区 lang英文或中文，默认中文
	public static String FormatDate(String pattern,String date,String zone,String lang) {
		String returnDate = "";
		if(zone.length()==0) zone = "Asia/Shanghai";//默认是上海
		DateFormat df = null;
		if(lang.equals("en"))
			df = new SimpleDateFormat(pattern,Locale.ENGLISH);
		else
			df = new SimpleDateFormat(pattern);

		df.setTimeZone(TimeZone.getTimeZone(zone));
		Date TempDate = null;
		SimpleDateFormat ThisDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//2003/09/19 加入setLenient(true),否则判断会不准确
		ThisDateFormat.setTimeZone(TimeZone.getTimeZone("Asia/Shanghai"));//输入的日期固定是上海时区
		ThisDateFormat.setLenient(true);//是否严格控制日期准确性
		try {
			TempDate = ThisDateFormat.parse(date);
			returnDate = df.format(TempDate);
		} catch (ParseException e) {
			return "";
		}

		return returnDate;
	}

	//格式化日期
	public static String FormatDate(String pattern, long date) {
		return FormatDate(pattern,date,"");
	}

	//格式化日期
	public static String FormatDate(String pattern,long date,String zone) {
		if(pattern.length()==0)
			pattern = "yyyy-MM-dd HH:mm:ss";
		java.util.Calendar nowDate = new java.util.GregorianCalendar();
		//System.out.println(nowDate.getTimeInMillis());
		nowDate.setTimeInMillis(date);
		DateFormat df = new SimpleDateFormat(pattern);
		//System.out.println("date:"+nowDate);
		//2017.6.5 wanghailong 修改
		//df.setTimeZone(java.util.TimeZone.getTimeZone("GMT"));
		df.setTimeZone(java.util.TimeZone.getTimeZone(zone));
		return df.format(nowDate.getTime());
	}

	//格式化日期
	public static String FormatDate(String pattern, int date) {
		if(pattern.length()==0)
			pattern = "yyyy-MM-dd HH:mm:ss";
		java.util.Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.setTimeInMillis(date);
		DateFormat df = new SimpleDateFormat(pattern);
		df.setTimeZone(java.util.TimeZone.getTimeZone("GMT"));
		return df.format(nowDate.getTime());
	}

	//格式化时间戳，参数为秒，不需要乘以1000
	public static String FormatTimeStamp(String pattern, long date) {
		if(pattern.length()==0)
			pattern = "yyyy-MM-dd HH:mm:ss";
		java.util.Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.setTimeInMillis(date*1000);
		DateFormat df = new SimpleDateFormat(pattern);
		return df.format(nowDate.getTime());
	}

	//格式化时长，pattern例如**时**分**秒,**分**秒，*分*秒
	public static String formatDuration(int duration, String pattern) {
		pattern = pattern.replace("*", "#");
		String times = "";
		String sec = "";
		String minute = "";
		String hour = "";
		int second = 0;
		int min = 0;
		int gsm = 0;
		if (duration % 60 > 0) {
			second = duration % 60;// 秒
		}
		if ((duration / 60) % 60 > 0) {
			min = (duration / 60) % 60;// 分
		}
		if ((duration / 60 / 60) % 60 > 0) {
			gsm = (duration / 60 / 60) % 60;// 小时
		}
		if (second == 0 || second < 10) {
			sec = "0" + second;
		} else {
			sec = second + "";
		}
		if (min == 0 || min < 10) {
			minute = "0" + min;
		} else {
			minute = min + "";
		}
		if (gsm == 0 || gsm < 10) {
			hour = "0" + gsm;
		} else {
			hour = gsm + "";
		}
		//System.out.println(pattern+","+pattern.indexOf("##"));
		if (pattern.indexOf("##") >= 0) {
			String pats = pattern.replace("##", "#");
			String[] mode = pats.split("#");
			if (mode.length == 4) {
				times = hour + mode[1] + minute + mode[2] + sec + mode[3];
			} else if (mode.length == 3) {
				times = minute + mode[1] + sec + mode[2];
			}
		} else {
			String[] mode = pattern.split("#");
			times = min + mode[1] + second + mode[2];
		}
		return times;
	}

	//根据日期获取calendar对象，比如getCalendar("2010-06-10 00:00:00")
	public static GregorianCalendar getCalendar(String date,String pattern)
	{
		SimpleDateFormat ThisDateFormat = new SimpleDateFormat(pattern);
		ThisDateFormat.setLenient(true);
		java.util.Date day11;
		java.util.GregorianCalendar day1 = null;
		try {
			day11 = ThisDateFormat.parse(date);
			day1 = new java.util.GregorianCalendar();
			day1.setTimeInMillis(day11.getTime());
		} catch (ParseException e) {
			return day1;
		}

		return day1;
	}

	//date为空，返回当前时间日历对象
	public static GregorianCalendar getCalendar(String date)
	{
		if(date.length()==0) return new java.util.GregorianCalendar();
		return getCalendar(date,"yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 统一的关闭页面
	 * @return String
	 */
	public static String getClose() {
		String str;
		str = "		  <div align=center><p><br>\r\n";
		str
				+= "    <a href=\"javascript:window.close();\"><font color=black><u><b>Close</b></u></font></a></p>\r\n";
		str += "  <p>&nbsp;</p></div>\r\n";
		return str;
	}

	/**
	 * 换行
	 * @param input
	 * @return String
	 */
	public static String convertNewlines(String input) {
		if (input == null)
			return "";
		String result = StringUtils.replace(input, "\r\n", "<br>");
		return StringUtils.replace(result, "\n", "<br>");
	}

	/**
	 * JavaScript格式化
	 * @param input
	 * @return String
	 */
	public static String JSQuote(String input) {
		if (input == null)
			return "";
		/*
		String result = StringUtils.replace(input, "\r\n", "\\r\\n");
		result = StringUtils.replace(result, "'", "\\'");
		result = StringUtils.replace(result, "\"", "\\\"");
		result = StringUtils.replace(result, "/", "\\/");
		//var a = "--><script> </script>";
		return StringUtils.replace(result, "\n", "\\n");
		*/
		input = input.replace("\r", "\\r");
		input = input.replace("'", "\\'");
		input = input.replace("\"", "\\\"");
		input = input.replace("/", "\\/");
		input = input.replace("\n", "\\n");

		return input;
	}

	//清理路径中的"//"或"///"
	//2006-07-05
	public static String ClearPath(String input)
	{
		input = input.replace('\\', '/');
		return ClearPath_(input);
	}

	public static String ClearPath_(String input)
	{
		int from = 0;
		int j = input.indexOf("://");
		if(j!=-1)
			from = j + 3;

		int i = input.indexOf("//",from);
		if(i==-1)
			return input;
		else
		{
			String input_ = input.substring(0,i) + "/" + input.substring(i+2);
			return Util.ClearPath_(input_);
		}
	}

	//获取文件路径，去除文件名
	public static String getFilePath(String filename)
	{
		String ext = "";
		int index = filename.lastIndexOf("/");
		if(index==-1)
			return filename;
		else
		{
			ext = filename.substring(0,index);
			return ext;
		}
	}

	//获取文件名，去除文件路径
	public static String getFileName(String filename)
	{
		String ext = "";
		int index = filename.lastIndexOf("/");
		if(index==-1)
			return filename;
		else
		{
			ext = filename.substring(index+1);
			return ext;
		}
	}

	//Html代码格式化
	public static String HTMLEncode( String input )
	{
		if( input == null || input.length() == 0 ) {
			return input;
		}
		input = input.replace("<","&lt;");
		input = input.replace(">","&gt;");
		input = input.replace("\"","&quot;");
		return input;
	}

	//URL编码
	public static String URLEncode(String input,String enc)
	{
		String retu = "";
		if(input == null)
			retu = "";
		else
		{
			try {
				return java.net.URLEncoder.encode(input,enc);
			} catch (UnsupportedEncodingException e) {
			}
		}
		return retu;
	}

	/**
	 * 返回字符串,如果为Null,返回空字符串
	 * @param input
	 * @return String
	 */
	public static String convertNull(String input) {
		if (input == null)
			return "";
		else
			return input;
		//return convertEncode(input);
	}

	/**
	 * 格式化SQL语句,适用于MySql
	 * @param input
	 * @return String
	 */
	public static String SQLQuote(String input) {
		//For MySQL
		//Check if the string is null or zero length -- if so, return
		//what was sent in.
		if (input == null || input.length() == 0) {
			return input;
		}
		//Use a StringBuffer in lieu of String concatenation -- it is
		//much more efficient this way.
		StringBuffer buf = new StringBuffer(input.length() + 6);
		char ch = ' ';
		for (int i = 0; i < input.length(); i++) {
			ch = input.charAt(i);
			//System.out.println(ch+"");
			if (ch == '\'') {
				buf.append("\\'");
			}
			else if (ch == '\\') {
				buf.append("\\\\");
			}
			//else if( ch == '\"' ) {
			//					buf.append( "\\\"" );
			//}
			else {
				buf.append(ch);
			}
			//System.out.println(buf);
		}
		//去掉decode，2013-7-2,否则会乱码
		//return DeCode(buf.toString());
		return buf.toString();
	}

	public static String XMLQuote(String input)
	{
		//For XML
		if (input == null || input.length() == 0) {
			return input;
		}
		//Use a StringBuffer in lieu of String concatenation -- it is
		//much more efficient this way.
		StringBuffer buf = new StringBuffer(input.length() + 6);
		char ch = ' ';
		for (int i = 0; i < input.length(); i++) {
			ch = input.charAt(i);
			if (ch == '<') {
				buf.append("&lt;");
			}
			else if (ch == '>') {
				buf.append("&gt;");
			}
			else if (ch == '"') {
				buf.append("&quot;");
			}
			else if (ch == '\'') {
				buf.append("&apos;");
			}
			else if (ch == '&') {
				buf.append("&amp;");
			}
			else {
				buf.append(ch);
			}
		}
		//return buf.toString();
		return (buf.toString());
	}


	/**
	 *  增加了 tab符处理  
	 *  优化原有针对换行符的处理
	 *   qukeji 2018-05-04
	 * @param input
	 * @return String
	 */
	public static String JSONQuote(String input) {
		if (input == null || input.length() == 0) {
			return input;
		}
		//Use a StringBuffer in lieu of String concatenation -- it is
		//much more efficient this way.
		StringBuffer buf = new StringBuffer(input.length() + 6);
		char ch = ' ';
		for (int i = 0; i < input.length(); i++) {
			ch = input.charAt(i);
			if (ch == '"') {
				buf.append("\\\"");
			}
			else if(ch == '\r')
			{
				buf.append("\\r");
			}
			else if(ch == '\n')
			{
				buf.append("\\n");
			}
			else if(ch == '\t')
			{
				buf.append("\\t");
			}
			else {
				buf.append(ch);
			}
		}
		//return buf.toString();
		return (buf.toString());
	}

	/**
	 * Method getParameter.
	 * @param request
	 * @param str
	 * @return String
	 */
	public static String getParameter(HttpServletRequest request, String str) {
		if (request.getParameter(str) == null)
			return "";
		else
			return request.getParameter(str);
	}

	/**
	 * Method getIntParameter.
	 * @param request
	 * @param str
	 * @return int
	 */
	public static int getIntParameter(HttpServletRequest request, String str) {
		String tempstr = getParameter(request, str);
		if (tempstr.equals(""))
			return 0;
		else
			return Integer.valueOf(tempstr).intValue();
	}

	/**
	 * 从HashMap中获取字符串值.
	 */
	public static String getParameter(HashMap map, String key) {
		Object o = map.get(key);
		if (o == null)
			return "";
		else
			return (String)o;
	}

	/**
	 * 从HashMap中获取数字类型的值.
	 */
	public static int getIntParameter(HashMap map, String key) {
		String tempstr = getParameter(map,key);
		if (tempstr.equals(""))
			return 0;
		else
			return Integer.valueOf(tempstr).intValue();
	}

	/**
	 * Method getIntSession.
	 * @param session
	 * @param str
	 * @return int
	 */
	public static int getIntSession(HttpSession session, String str) {
		if (session.getAttribute(str) != null)
			return Integer.parseInt((String) session.getAttribute(str));
		else
			return -1;
	}

	/**
	 * Method getSession.
	 * @param session
	 * @param str
	 * @return String
	 */
	public static String getSession(HttpSession session, String str) {
		if (session.getAttribute(str) != null)
			return (String) session.getAttribute(str);
		else
			return "";
	}

	/**
	 * 格式化货币字串
	 * @param x
	 * @return String
	 */
	public static String getCurrencyFormat(double x) {
		DecimalFormat df = new DecimalFormat(",##0.00");
		return df.format(x);
	}

	/**
	 * 格式化字串，自定义格式
	 * 2003-05-10
	 */
	public static String getCurrencyFormat(double x,String pattern) {
		DecimalFormat df = new DecimalFormat(pattern);
		return df.format(x);
	}

	/**
	 * 格式化货币字串.
	 * @param x
	 * @return String
	 */
	public static String getCurrencyFormat(String x) {
		double xx;
		try {
			xx = Double.parseDouble(x);
		} catch (Exception e) {
			xx = 0;
		}
		DecimalFormat df = new DecimalFormat(",##0.00");
		return df.format(xx);
	}

	/**
	 * Method getQuantityFormat.
	 * @param x
	 * @return String
	 */
	public static String getQuantityFormat(double x) {
		DecimalFormat df = new DecimalFormat(",##0");
		return df.format(x);
	}

	/**
	 * Method getQuantityFormat.
	 * @param x
	 * @return String
	 */
	public static String getQuantityFormat(String x) {
		double xx;
		try {
			xx = Double.parseDouble(x);
		} catch (Exception e) {
			xx = 0;
		}
		DecimalFormat df = new DecimalFormat(",##0");
		return df.format(xx);
	}



	/**
	 * 编码.
	 * @param str
	 * @return String
	 */
	public static String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GB2312");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}

	public static String convertEncode(String str)
	{
		if(str==null)
			return "";
		try
		{
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("iso-8859-1");
			String temp = new String(temp_t,"GB2312");
			return temp;
		}
		catch(Exception e)
		{
		}
		return "";
	}
	/**
	 * 写文件.
	 * @param FileName
	 * @param Content
	 * @throws IOException
	 */
	public static void WriteFile(String FileName, String Content)
			throws IOException {
		PrintWriter out =
				new PrintWriter(new BufferedWriter(new FileWriter(FileName, true)));
		out.println(Content);
		out.close();
	}

	/**
	 * Method ArrayToString.
	 * @param array
	 * @param separator
	 * @return String
	 */
	public static String ArrayToString(String[] array, String separator) {
		if (array == null || array.length == 0)
			return "";
		else {
			String str = "";
			for (int i = 0; i < array.length; i++) {
				if (i == 0)
					str += array[i];
				else
					str += separator + array[i];
			}
			return str;
		}
	}

	/**
	 * Method StringToArray.
	 * @param str
	 * @param separator
	 * @return String[]
	 */
	public static String[] StringToArray(String str, String separator) {
		if (str == null || separator == null)
			return null;
		else {
			String[] array;
			int i = 0;
			StringTokenizer st = new StringTokenizer(str, separator);
			array = new String[st.countTokens()];
			while (st.hasMoreTokens()) {
				array[i++] = st.nextToken();
			}
			return array;
		}
	}

	/**
	 * Method StringToArrayList.
	 * @param str
	 * @param separator
	 * @return String[]
	 */
	public static ArrayList<String> StringToArrayList(String str, String separator) {
		ArrayList<String> arr = new ArrayList<String>();
		if (str == null || separator == null)
			return arr;
		else {
			StringTokenizer st = new StringTokenizer(str, separator);
			while (st.hasMoreTokens()) {
				arr.add(st.nextToken());
			}
			return arr;
		}
	}


	public static int[] StringToIntArray(String str, String separator) {
		if (str == null || separator == null)
			return null;
		else {
			int[] array;
			int i = 0;
			StringTokenizer st = new StringTokenizer(str, separator);
			array = new int[st.countTokens()];
			while (st.hasMoreTokens()) {
				array[i++] = parseInt(st.nextToken());
			}
			return array;
		}
	}

	/**
	 * Method StringInArray.
	 * @param array
	 * @param str
	 * @return boolean
	 */
	public static boolean StringInArray(String[] array, String str) {
		if (array == null || array.length == 0 || str == null)
			return false;
		else {
			for (int i = 0; i < array.length; i++) {
				if (array[i].equals(str))
					return true;
			}
			return false;
		}
	}

	/**
	 * Method IntInArray.
	 * @param array
	 * @param str
	 * @return boolean
	 */
	public static boolean IntInArray(String[] array, int str) {
		if (array == null || array.length == 0)
			return false;
		else {
			for (int i = 0; i < array.length; i++) {
				if (str == Integer.parseInt(array[i]))
					return true;
			}
			return false;
		}
	}

	//检查日期的合法性
	//2003-05-09
	public static boolean CheckDate(String InputDateFormat, String DateString) {
		//Date TempDate = null;
		SimpleDateFormat ThisDateFormat = new SimpleDateFormat(InputDateFormat);
		//2003/09/19 加入setLenient(true),否则判断会不准确
		ThisDateFormat.setLenient(true);
		try {
			ThisDateFormat.parse(DateString);
			return true;
		}   catch(ParseException e) {
			return false;
		}
	}

	//如果是0,输出空格
	//2003-05-10
	public static String convertZero(int i)
	{
		if(i==0)
			return "";
		else
			return ""+i;
	}

	//如果是0,输出空格，如果不是0，保留两位小数输出
	//2003-05-10
	public static String convertZero(float i)
	{
		if(i==0)
			return "";
		else
			return ""+getCurrencyFormat(i);
	}

	//2003-09-25
	//增加parseInt,parseFloat,parseDouble    
	public static int parseInt(String num)
	{
		if(num==null || num.length()==0) return 0;

		try
		{
			return(Integer.parseInt(num));
		}
		catch(NumberFormatException e)
		{
			return 0;
		}
	}

	public static long parseLong(String num)
	{
		try
		{
			return(Long.parseLong(num));
		}
		catch(NumberFormatException e)
		{
			return 0;
		}
	}

	public static float parseFloat(String num)
	{
		try
		{
			return(Float.parseFloat(num));
		}
		catch(NumberFormatException e)
		{
			return 0;
		}
	}

	public static double parseDouble(String num)
	{
		try
		{
			return(Double.parseDouble(num));
		}
		catch(NumberFormatException e)
		{
			return 0;
		}
	}
	/**得到时间戳**/
	public static String parseDate(String date)
	{
		Date TempDate = null;
		SimpleDateFormat ThisDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//2003/09/19 加入setLenient(true),否则判断会不准确
		ThisDateFormat.setLenient(true);
		try {
			TempDate = ThisDateFormat.parse(date);
		} catch (ParseException e) {
			return "";
		}
		return TempDate.getTime()+"";
	}

	// 去掉所有html元素,  
	public static String removeHtml(String input) {
		if (input == null) {
			return "";
		}

		String str = input.replaceAll("\\&[a-zA-Z]{1,10};", "").replaceAll(
				"<[^>]*>", "");
		str = str.replaceAll("[(/>)<]", "");

		return str;
	}

	public static boolean isHasSubFolder(String path)
	{
		File file = new File(path);
		File[] files = file.listFiles();
		if(files!=null)
		{
			for(int i = 0;i<files.length;i++)
			{
				if(files[i].isDirectory())
					return true;
			}
		}
		return false;
	}

	@SuppressWarnings("unchecked")
	public static void Logout(HttpSession session) {
		Enumeration<String> iterator = session.getAttributeNames();
		while (iterator.hasMoreElements())
		{
			String name = (String) iterator.nextElement();
			session.removeAttribute(name);
		}
	}

	/*
	//用于截断文字 不能区分半角和全角
	public static String substring(String str,int len)
	{
		if(str==null)
			return "";
		
		if(str.length()<=len)
			return str;
		else
		{
			str = str.substring(0,len) + "...";
		}
		
		return str;
	}*/

	//用于截断文字 能区分半角和全角
	public static String substring(String str,int len,String str1)
	{
		len = len * 2;
		StringBuffer sb = new StringBuffer();
		int counter = 0;
		boolean b_str1 = false;
		for (int i = 0; i < str.length(); i++)
		{
			char c = str.charAt(i);
			if (c < 255) {
				counter++;
			} else {
				counter = counter + 2;
			}
			if (counter > len) {
				b_str1 = true;//需要加上后缀
				break;
			}
			sb.append(c);
		}

		return sb.toString() + (b_str1?str1:"");
	}

	// 用于截断文字
	public static String substring(String str,int len)
	{
		return substring(str,len,"...");
	}

	//访问http链接,以后逐步废弃
	public static String connectHttpUrl(String url,boolean print)
	{
		return connectHttpUrl(url,"");
	}

	//访问http链接
	public static String connectHttpUrl(String url,String charset)
	{
		String content = "";
		String sCurrentLine = "";
		java.net.URL l_url;
		try {
			if(charset.length()==0) charset = "utf-8";
			l_url = new java.net.URL(url);
			java.net.HttpURLConnection con = (java.net.HttpURLConnection) l_url.openConnection();
			HttpURLConnection.setFollowRedirects(true);
			con.setConnectTimeout(60000);//连接超时,1分钟,防止网络异常，程序僵死
			con.setReadTimeout(60000);//读操作超时,1分钟
			con.setInstanceFollowRedirects(true);//支持重定向
			con.connect();
			java.io.InputStream l_urlStream = con.getInputStream();
			java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream,charset));
			while ((sCurrentLine = l_reader.readLine()) != null)
			{
				content+=sCurrentLine + "\r\n";
			}
		} catch (MalformedURLException e) {
			System.out.println("cann't connect " + url);
			//e.printStackTrace(System.out);
		} catch (IOException e) {
			System.out.println("cann't connect " + url);
			//e.printStackTrace(System.out);
		}

		return content;
	}

	//post提交数据 data数据如："username=aa&password=b"
	public static String postHttpUrl(String httpurl,String data)
	{
		return postHttpUrl(httpurl,data,"utf-8");
	}

	//post提交数据 data数据如："username=aa&password=b"
	public static String postHttpUrl(String httpurl,String data,String charset)
	{
		String content = "";
		URL url;
		try {
			url = new URL(httpurl);
			java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
			connection.setDoOutput(true);
			connection.setUseCaches(false);
			connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
			connection.setRequestMethod("POST");
			connection.connect();
			OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());

			out.write(data);
			out.flush();

			String sCurrentLine = "";

			java.io.InputStream l_urlStream = connection.getInputStream();
			java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream,charset));
			while ((sCurrentLine = l_reader.readLine()) != null)
			{
				content+=sCurrentLine;
			}

			//System.out.println(content);
			out.close();
			out = null;
			connection.disconnect();
			connection = null;
		} catch (MalformedURLException e) {
			System.out.println(e.getMessage());
		} catch (IOException e) {
			System.out.println(e.getMessage());
		}

		return content;
	}

	public static String connectHttpUrl(String url)
	{
		String content = "";

		InputStream in = null;

		try {
			in = new URL(url).openStream();
			content = IOUtils.toString(in);
		} catch (MalformedURLException e) {
			System.out.println("cann't connect " + url);
		} catch (IOException e) {
			System.out.println("cann't connect " + url);
		} finally {
			if(in!=null)
				IOUtils.closeQuietly(in);
		}
		return content;
	}

	//从一个arraylist中截取部分,第一个为1
	@SuppressWarnings("unchecked")
	public static ArrayList getArray(ArrayList arraylist,int from,int end)
	{
		ArrayList array = new ArrayList();

		if(arraylist!=null && arraylist.size()>0)
		{
			for (int i = 0; i < arraylist.size(); i++)
			{
				if(i>=(from-1) && i<=(end-1))
					array.add(arraylist.get(i));
			}
		}
		return array;
	}

	//得到一个初始化的arraylist，模板里面需要
	public static ArrayList getArray()
	{
		return new ArrayList();
	}

	public static String getCookieValue(String name,Cookie[] cs)
	{
		String str = "";

		if(!name.equals("") && cs!=null && cs.length>0)
		{
			for(int i = 0;i<cs.length;i++)
			{
				Cookie c = cs[i];
				if(c.getName().equals(name))
					return c.getValue();
			}
		}
		return str;
	}

	//暂停时间
	public static void consumeTime(long millis) {
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {

		}
	}

	/**
	 * 根据给定时间,获取时间戳 
	 * startDate:格式是"yyyy-MM-dd"
	 * startTime:格式是"HH:mm"
	 * @return long
	 */
	public static long getFromTime(String startDate,String startTime){
		Calendar nowDate = new java.util.GregorianCalendar();
		long fromtime=0;
		if(startTime.equals("")){
			startTime="00:00";
		}
		if(!startDate.equals("")){
			String []s=startDate.split("-");
			nowDate = new java.util.GregorianCalendar();
			nowDate.set(Calendar.DAY_OF_MONTH,Integer.parseInt(s[2]));
			nowDate.set(Calendar.MONTH,Integer.parseInt(s[1])-1);
			nowDate.set(Calendar.YEAR,Integer.parseInt(s[0]));

			String []t=startTime.split(":");
			nowDate.set(Calendar.HOUR_OF_DAY,Integer.parseInt(t[0]));
			nowDate.set(Calendar.MINUTE,Integer.parseInt(t[1]));
			nowDate.set(Calendar.SECOND,0);
			fromtime = nowDate.getTimeInMillis()/1000;
		}
		return fromtime;
	}

	//获取文件扩展名
	public static String getFileExt(String filename)
	{
		String ext = "";
		int index = filename.lastIndexOf(".");
		if(index==-1)
			return "";
		else
		{
			ext = filename.substring(index+1);
			return ext;
		}
	}

	public static ArrayList getObject(String classname)
	{
		try {
			ProxyObject a = (ProxyObject)Class.forName(classname).newInstance();
			return a.getRealObject();
		} catch (Exception e) {
			e.printStackTrace();
			return new ArrayList();
		}
	}

	public static JSONObject getJson(String s)
	{
		try {
			return new org.json.JSONObject(s);
		} catch (JSONException e) {
			e.printStackTrace();
			return new org.json.JSONObject();
		}
	}

	public static TideJson getMyJson(String s)
	{
		TideJson tj = new TideJson();
		tj.setJson(Util.getJson(s));
		return tj;
	}

	public static int getRandom(int i)
	{
		return new java.util.Random().nextInt(i);
	}

	public static ArrayList<String> getMatch(String s,String reg,int group)
	{
		ArrayList<String> a = new ArrayList<String>();

		Pattern p = Pattern.compile(reg);
		Matcher m = p.matcher(s);
		while (m.find()) {
			a.add(m.group(group));
		}

		return a;
	}

	public static void sendQQ(String to,String message)
	{
		QQ q = new QQ();
		q.Send(to, message);
	}

	//从网络上下载文件
	public static boolean downloadFile(String fileurl,String target)
	{
		boolean result = false;
		URL url;
		try {
			url = new URL(fileurl);
			URLConnection con = url.openConnection();
			InputStream is = con.getInputStream();
			byte[] bs = new byte[1024];
			int len;
			String target2 = target;
			int jj = target.lastIndexOf("/");
			if(jj!=-1)
				target2 = target.substring(0,jj);
			File f = new File(target2);
			if(!f.exists())
				f.mkdirs();

			OutputStream os = new FileOutputStream(target);

			while ((len = is.read(bs)) != -1) {
				os.write(bs, 0, len);
			}

			os.close();
			is.close();
			result = true;
		} catch (MalformedURLException e) {
			//e.printStackTrace();
			System.out.println("下载失败："+fileurl+",错误信息:"+e.getMessage());
		} catch (IOException e) {
			//e.printStackTrace();
			System.out.println("下载失败："+fileurl+",错误信息:"+e.getMessage());
		}

		return result;
	}

	//base64编码
	public static String base64(String s){
		if (s == null) return "";
		char[] ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".toCharArray();
		byte[] buf = s.getBytes();
		int size = buf.length;
		char[] ar = new char[((size + 2) / 3) * 4];
		int a = 0;
		int i=0;
		while(i < size){
			byte b0 = buf[i++];
			byte b1 = (i < size) ? buf[i++] : 0;
			byte b2 = (i < size) ? buf[i++] : 0;

			int mask = 0x3F;
			ar[a++] = ALPHABET[(b0 >> 2) & mask];
			ar[a++] = ALPHABET[((b0 << 4) | ((b1 & 0xFF) >> 4)) & mask];
			ar[a++] = ALPHABET[((b1 << 2) | ((b2 & 0xFF) >> 6)) & mask];
			ar[a++] = ALPHABET[b2 & mask];
		}
		switch(size % 3){
			case 1: ar[--a]  = '=';
			case 2: ar[--a]  = '=';
		}
		return new String(ar);
		//return (new sun.misc.BASE64Encoder()).encode( s.getBytes() ); 
	}
	//aes加密
	public static String AES_Encrypt(String keyStr,String AESTYPE,String plainText) {
		byte[] encrypt = null;
		try{
			if(AESTYPE.equals("")){
				AESTYPE="AES/ECB/PKCS5Padding";
			}
			Key key = generateKey(keyStr);
			Cipher cipher = Cipher.getInstance(AESTYPE);
			cipher.init(Cipher.ENCRYPT_MODE, key);
			encrypt = cipher.doFinal(plainText.getBytes());
		}catch(Exception e){
			e.printStackTrace();
		}
		return new String(new BASE64Encoder().encode(encrypt));
	}
	private static Key generateKey(String key)throws Exception{
		try{
			SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(), "AES");
			return keySpec;
		}catch(Exception e){
			e.printStackTrace();
			throw e;
		}

	}

	//获取token中的用户id
	public static String getUser(String token)
	{
		List<String> list =  JWT.decode(token).getAudience();
		if(list!=null && list.size()>1)
			return list.get(0);
		else
			return "0";
	}

	public static String createToken(int uid,String phone,String avatar,int cid,int type) throws MessageException, SQLException {

		TideJson tidejson = CmsCache.getParameter("juxian_api").getJson();
		String key = tidejson.getString("key");

		Calendar nowTime = Calendar.getInstance();
		nowTime.add(Calendar.MONTH,2);
		Date expireDate = nowTime.getTime();
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("alg","HS256");
		map.put("typ","JWT");
		String token = JWT.create()
				.withIssuedAt(new Date())//签名时间
				// .withExpiresAt(expireDate)//token有效期2个月
				.withHeader(map)
				.withClaim("uid",uid)
				.withClaim("phone",phone)
				.withClaim("avatar",avatar)
				.withClaim("cid",cid)
				.withClaim("type",type)
				.sign(Algorithm.HMAC256(key));
		//System.out.println("执行到这里啦4");
		return token;
	}

	public static DecodedJWT decodeToken(String token) throws MessageException, SQLException {
		DecodedJWT jwt = null;
		TideJson tidejson = CmsCache.getParameter("juxian_api").getJson();
		String key = tidejson.getString("key");

		// 使用了HMAC256(HS256)加密算法。
		// mysecret是用来加密数字签名的密钥。
		JWTVerifier verifier = JWT.require(Algorithm.HMAC256(key))
				//.withIssuer("auth0")
				.build(); //Reusable verifier instance
		jwt = verifier.verify(token);

		return jwt;
	}
}