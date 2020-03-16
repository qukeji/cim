package tidemedia.cms.user;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelPrivilegeItem;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Parameter;
import tidemedia.cms.util.TideJson;
import tidemedia.cms.util.Util;

public class UserInfoUtil {

	//0 登录失败 1登录成功 2登录失败，帐号过期 3代表1小时内登陆失败次数过多
	public static int Authorization(HttpServletRequest request,HttpServletResponse response,String username,String password,boolean cookie) throws SQLException, MessageException
	{
		if(password.equals(""))
			return 0;
		
		TableUtil tu = new TableUtil();
		TableUtil tu_user = new TableUtil("user");
		
		int isCookie = 0;
		
		if(cookie)
		{
	        String values[] = decodePasswordCookie(password, new String(new char[] {'\023', 'C', 'i'}));
	        if(values == null)
	        {
	            password = "";
	            username = "";
	        }
	        else
	        {
	        	username = values[0];
	        	password = values[1];
	        }
	        isCookie = 1;
		}
		
		if(!can_login(username))//代表1小时内登陆失败次数过多
			return 3;
		
		String Sql = "select id,Status,Username,UNIX_TIMESTAMP(ExpireDate) as ExpireDate,Password from userinfo where Username='" + tu.SQLQuote(username) + "'";
		if(cookie) 
			Sql += " and Password=('" + tu.SQLQuote(password) + "')";
		else
			Sql += " and Password=md5('" + tu.SQLQuote(password) + "')";
		
		ResultSet Rs = null;
		
		try
		{
			Rs = tu_user.executeQuery(Sql);
		}
		catch(Exception e)
		{
			//System.out.println("---------------------------------------------");
			//System.out.println(e.getMessage());
			//System.out.println("---------------------------------------------");
			System.out.println("close all conneciton.");
			tu_user = new TableUtil("user");
			Rs = tu_user.executeQuery(Sql);
		}
		
		String ip = request.getHeader("HTTP_X_FORWARDED_FOR");

		if (ip  == null)
			ip = request.getRemoteAddr();
		
		if(Rs.next())
		{
			String str = tu.convertNull(Rs.getString("Username"));
			int User_ID = Rs.getInt("id");
			int status = Rs.getInt("Status");
			long ExpireDate = Rs.getInt("ExpireDate");
			String pass = tu.convertNull(Rs.getString("Password"));
			//String User_Name = convertNull(Rs.getString("Name"));		
				
			tu_user.closeRs(Rs);
			
			
			
			//if(password.equals(str))
			if(username.equals(str) && status==1)
			{
				if(ExpireDate>0 && System.currentTimeMillis()/1000>ExpireDate)
				{
					return 2;//帐号过期
				}
				
				
				HttpSession session = request.getSession();
				UserInfo userinfo = new UserInfo(User_ID);
			
				if(userinfo.getUsername().equals(username))
				{
					
					Sql = "insert into login_log(Username,User,IsSuccess,IsCookie,IP,Host,Date) values('" + 
					tu.SQLQuote(username) + "',"+User_ID+",1,"+isCookie+",'"+ ip + "','" + tu.SQLQuote(request.getRemoteHost()) + "',now())";
					//System.out.println(Sql);
					tu.executeUpdate(Sql);
					Sql = "update userinfo set LastLoginDate=now() where id="+userinfo.getId();
					tu_user.executeUpdate(Sql);
					
					String username2 = encodePasswordCookie(username, pass, new String(new char[] {'\023','C','i'}));
					userinfo.setUsername2(username2);
					
					int    CookieLogin	= Util.getIntParameter(request,"CookieLogin");
					if(CookieLogin==1 && !cookie)
						SavePasswordCookie(response,username2);
					
					//统一登录用
					SaveTokenCookie(response,username2);
					
					session.setAttribute("CMSUserInfo",userinfo);
					return 1;
				}
				else
				{
					Sql = "insert into login_log(Username,User,IsSuccess,IsCookie,IP,Host,Date) values('" + 
					tu.SQLQuote(username) + "',"+User_ID+",0,"+isCookie+",'" + ip + "','" + tu.SQLQuote(request.getRemoteHost()) + "',now())";
					tu.executeUpdate(Sql);			
					return 0;
				}
			}
			Sql = "insert into login_log(Username,User,IsSuccess,IsCookie,IP,Host,Date) values('" + 
			tu.SQLQuote(username) + "',"+User_ID+",0,"+isCookie+",'" + ip + "','" + tu.SQLQuote(request.getRemoteHost()) + "',now())";
			tu.executeUpdate(Sql);
			return 0;
		}
		else
		{
			Sql = "insert into login_log(Username,User,IsSuccess,IsCookie,IP,Host,Date) values('" + 
			tu.SQLQuote(username) + "',0,0,"+isCookie+",'" + ip + "','" + tu.SQLQuote(request.getRemoteHost()) + "',now())";
			tu.executeUpdate(Sql);		
			
			tu_user.closeRs(Rs);
			return 0;
		}
	}

	//使用token登录 0 登录失败 1登录成功 2登录失败，帐号过期
	public static int AuthByToken(String token) throws SQLException, MessageException
	{
		if(token.equals(""))
			return 0;
		
		TableUtil tu = new TableUtil("user");
		
		String Sql = "select id,Status,Username,UNIX_TIMESTAMP(ExpireDate) as ExpireDate from userinfo where Token='" + tu.SQLQuote(token) + "'";
		ResultSet Rs = null;
		
		try
		{
			Rs = tu.executeQuery(Sql);
		}
		catch(Exception e)
		{
			System.out.println("close all conneciton.");
			tu = new TableUtil();
			Rs = tu.executeQuery(Sql);
		}

		
		if(Rs.next())
		{
			//String str = tu.convertNull(Rs.getString("Username"));
			int User_ID = Rs.getInt("id");
			int status = Rs.getInt("Status");
			long ExpireDate = Rs.getInt("ExpireDate");
			//String User_Name = convertNull(Rs.getString("Name"));		
				
			tu.closeRs(Rs);
			
			//if(password.equals(str))
			if(status==1)
			{
				if(ExpireDate>0 && System.currentTimeMillis()/1000>ExpireDate)
				{
					return 2;//帐号过期
				}				
					
				Sql = "update userinfo set LastLoginDate=now() where id="+User_ID;
				tu.executeUpdate(Sql);
					
				return 1;

			}

			return 0;
		}
		else
		{			
			tu.closeRs(Rs);
			return 0;
		}
	}
	
	//返回用户编号
	public static int AuthUserByToken(String token) throws SQLException, MessageException
	{
		if(token.equals(""))
			return 0;
		
		TableUtil tu = new TableUtil("user");
		
		String Sql = "select id,Status,Username,UNIX_TIMESTAMP(ExpireDate) as ExpireDate from userinfo where Token='" + tu.SQLQuote(token) + "'";
		ResultSet Rs = null;
		
		try
		{
			Rs = tu.executeQuery(Sql);
		}
		catch(Exception e)
		{
			System.out.println("close all conneciton.");
			tu = new TableUtil();
			Rs = tu.executeQuery(Sql);
		}

		
		if(Rs.next())
		{
			//String str = tu.convertNull(Rs.getString("Username"));
			int User_ID = Rs.getInt("id");
			int status = Rs.getInt("Status");
			long ExpireDate = Rs.getInt("ExpireDate");
			//String User_Name = convertNull(Rs.getString("Name"));		
				
			tu.closeRs(Rs);
			
			//if(password.equals(str))
			if(status==1)
			{
				if(ExpireDate>0 && System.currentTimeMillis()/1000>ExpireDate)
				{
					return 0;//帐号过期
				}				
					
				Sql = "update userinfo set LastLoginDate=now() where id="+User_ID;
				tu.executeUpdate(Sql);
					
				return User_ID;

			}

			return 0;
		}
		else
		{			
			tu.closeRs(Rs);
			return 0;
		}
	}
	
	public static void SavePasswordCookie(HttpServletResponse response,String password)
	{
        Cookie cookie = new Cookie("Username2", password);
        cookie.setPath("/");//2014.10.13添加
        cookie.setMaxAge(365*24*60*60);
        response.addCookie(cookie);
	}

	//把token保存到cookie中，浏览器关闭后cookie失效，用于统一平台登录
	public static void SaveTokenCookie(HttpServletResponse response,String password)
	{
        Cookie cookie = new Cookie("token", password);
        cookie.setPath("/");//2014.10.13添加
        cookie.setMaxAge(-1);
        response.addCookie(cookie);
	}
    
	// 是否具有某个频道的指定权限
	public static boolean hasChannelRight(int channelid,int permtype,ArrayList<ChannelPrivilegeItem> ChannelPermArray) throws SQLException,MessageException 
	{
		boolean right = false;
		Channel channel = CmsCache.getChannel(channelid);
		for(int i = 0;i<ChannelPermArray.size();i++)
		{
			ChannelPrivilegeItem ci = (ChannelPrivilegeItem)ChannelPermArray.get(i);
			//System.out.println(channelid+","+ci.getChannel()+","+ci.getPermType());
			if(ci.getChannel()==channelid)//本频道
			{
				int[] perms = ci.getPermArray();
				if(perms!=null)
				{
					//System.out.println("len:"+perms.length);
					for(int j=0;j<perms.length;j++)
					{
						int permtype1 = perms[j];
						if(permtype1==permtype)
						{//System.out.print("true");
							return true;
						}
						if(permtype1==(-1*permtype))
						{
							return false;
						}
					}
				}
			}
			else
			{
				Channel cichannel = null;
				try{
				cichannel = CmsCache.getChannel(ci.getChannel());
				}catch(Exception e){right = false;}//有可能该频道找不到
				//包括子频道和是其父频道
				//System.out.println("inherit:"+ci.getIsInherit()+","+channel.getChannelCode()+","+cichannel.getChannelCode());
				if(cichannel!=null && ci.getIsInherit()==1 && cichannel.getChannelCode().length()>0 && channel.getChannelCode().startsWith(cichannel.getChannelCode()))
				{
					int[] perms = ci.getPermArray();
					if(perms!=null)
					{
						for(int j=0;j<perms.length;j++)
						{
							int permtype1 = perms[j];
							if(permtype1==permtype)
							{
								right = true;//System.out.println("true");
							}
							if(permtype1==(-1*permtype))
							{
								right = false;
							}
						}
					}
				}
			}
		}
		
		return right;			
	}	
	
	public static boolean hasChannelShowRight(int channelid,ArrayList<ChannelPrivilegeItem> ChannelPermArray) throws SQLException,MessageException {
		boolean right = false;
		Channel channel = CmsCache.getChannel(channelid);
		for(int i = 0;i<ChannelPermArray.size();i++)
		{
			ChannelPrivilegeItem ci = (ChannelPrivilegeItem)ChannelPermArray.get(i);
			//System.out.println(channelid+","+ci.getChannel()+","+ci.getPermType());
			if(ci.getChannel()==channelid)//本频道
			{
				int[] perms = ci.getPermArray();
				if(perms!=null)
				{
					//System.out.println("len:"+perms.length);
					for(int j=0;j<perms.length;j++)
					{
						int permtype = perms[j];
						if(permtype==0||permtype==1||permtype==12)
						{//System.out.print("true");
							return true;
						}
						if(permtype==-1)
						{
							return false;
						}
					}
				}
			}
			else
			{
				Channel cichannel = CmsCache.getChannel(ci.getChannel());
				//包括子频道和是其父频道
				//System.out.println("inherit:"+ci.getIsInherit()+","+channel.getChannelCode()+","+cichannel.getChannelCode());
				if(ci.getIsInherit()==1 && cichannel.getChannelCode().length()>0 && channel.getChannelCode().startsWith(cichannel.getChannelCode()))
				{
					int[] perms = ci.getPermArray();
					if(perms!=null)
					{
						for(int j=0;j<perms.length;j++)
						{
							int permtype = perms[j];
							if(permtype==0||permtype==1||permtype==12)
							{
								right = true;//System.out.println("true");
							}
							if(permtype==-1)
							{
								right = false;
							}
						}
					}
				}
			}
		}
		
		return right;
	}

	//传入一个频道数组，分析完返回,提高频道数量多的时候，推荐的展示性能
	public static ArrayList hasChannelShowRight(ArrayList<Channel> channels,UserInfo user) throws SQLException,MessageException {
		ArrayList arr = new ArrayList();

		//如果是管理员
		if(user.getRole()==1)
		{
			if(user.getCompany()==0)
				return channels;//平台管理员
			else
			{
				//租户管理员
				for(int m = 0;m<channels.size();m++)
				{
					Channel ch = (Channel) channels.get(m);

					int parent = ch.getParent();
					//站点频道,不是公共站点,用户无站点权限
					if(parent==-1&&(!ch.getApplication().equals("publishsite"))&&(user.getCompany()!=ch.getSite().getCompany())){
						continue ;
					}
					//是租户频道,但不是同一租户（如：vms音视频媒资下的临时租户频道）
					if(ch.getCompany()>0 && user.getCompany()!=ch.getCompany()){
						continue;
					}

					arr.add(ch);

					//if(ch.getCompany()==user.getCompany())//同一个租户
					//arr.add(ch);
				}

				return arr;
			}
		}

		ArrayList ChannelPermArray = user.getChannelPermArray();

		//Channel channel = CmsCache.getChannel(channelid);
		for(int i = 0;i<ChannelPermArray.size();i++)
		{
			ChannelPrivilegeItem ci = (ChannelPrivilegeItem)ChannelPermArray.get(i);
			Channel cichannel = CmsCache.getChannel(ci.getChannel());
			for(int m = 0;m<channels.size();m++) {
				Channel ch = (Channel)channels.get(m);
				//System.out.println(channelid+","+ci.getChannel()+","+ci.getPermType());
				if (ci.getChannel() == ch.getId())//本频道
				{
					int[] perms = ci.getPermArray();
					if (perms != null) {
						//System.out.println("len:"+perms.length);
						for (int j = 0; j < perms.length; j++) {
							int permtype = perms[j];
							if (permtype == 0 || permtype == 1||permtype==12) {//System.out.print("true");
								arr.add(ch);
								break;
							}
							if (permtype == -1) {
								//return false;
								break;
							}
						}
					}
				} else {
					//包括子频道和是其父频道
					//System.out.println("inherit:"+ci.getIsInherit()+","+channel.getChannelCode()+","+cichannel.getChannelCode());
					if (ci.getIsInherit() == 1 && cichannel.getChannelCode().length() > 0 && ch.getChannelCode().startsWith(cichannel.getChannelCode())) {
						int[] perms = ci.getPermArray();
						if (perms != null) {
							for (int j = 0; j < perms.length; j++) {
								int permtype = perms[j];
								if (permtype == 0 || permtype == 1||permtype==12) {
									//right = true;//System.out.println("true");
									arr.add(ch);
									break;
								}
								if (permtype == -1) {
									//right = false;
									break;
								}
							}
						}
					}
				}
			}
		}

		return arr;
	}

	public static String encodePasswordCookie(String username, String password, String encoding)
    {
        StringBuffer buf = new StringBuffer();
        if(username != null && password != null)
        {
            char offset1 = encoding == null || encoding.length() <= 1 ? 'C' : encoding.charAt(1);
            char offset2 = encoding == null || encoding.length() <= 2 ? 'i' : encoding.charAt(2);
            byte bytes[] = (username + '\023' + password).getBytes();
            for(int n = 0; n < bytes.length; n++)
            {
                int b = bytes[n] ^ 90 + n;
                buf.append((char)(offset1 + (b & 0xf)));
                buf.append((char)(offset2 + (b >> 4 & 0xf)));
            }

        }
       
        return buf.toString();
    }

    public static String[] decodePasswordCookie(String cookieVal, String encoding)
    {
        if(cookieVal == null || cookieVal.length() <= 0)
            return null;
        char offset1 = encoding == null || encoding.length() <= 1 ? 'C' : encoding.charAt(1);
        char offset2 = encoding == null || encoding.length() <= 2 ? 'i' : encoding.charAt(2);
        char chars[] = cookieVal.toCharArray();
        byte bytes[] = new byte[chars.length / 2];
        int n = 0;
        int m = 0;
        for(; n < bytes.length; n++)
        {
            int b = chars[m++] - offset1;
            b |= chars[m++] - offset2 << 4;
            bytes[n] = (byte)(b ^ 90 + n);
        }

        cookieVal = new String(bytes);
        int pos = cookieVal.indexOf('\023');
        String username = pos >= 0 ? cookieVal.substring(0, pos) : "";
        String password = pos >= 0 ? cookieVal.substring(pos + 1) : "";
        return (new String[] {
            username, password
        });
    }	
    
    
  //一小时内登陆失败6次 禁止登陆
	private static boolean can_login(int userid)
		throws SQLException,MessageException
	{
		boolean result = true;
		//sys_login_fail_number 0 不禁止，-1 全部禁止登录 >0 默认尝试次数
		int number = CmsCache.getParameter("sys_login_fail_number").getIntValue();
		if(number==0)
			return true;
		else if(number==-1)
			return false;//禁止登陆
		
		TableUtil tu = new TableUtil();
		String sql = "select count(id) from login_log where IsSuccess=0 and user="+userid+" and UNIX_TIMESTAMP(Date)>=UNIX_TIMESTAMP(adddate(now(), INTERVAL -1 HOUR))";
		 
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next() )
		{	
			int count = rs.getInt(1);
			if(count>number)//1小时内登陆次数超过 number 就禁止登陆
			{
				result = false;
			}
			 
		}
		tu.closeRs(rs);
		return result;
	}
    
	
	    //一小时内登陆失败6次 禁止登陆
		private static boolean can_login(String username)
			throws SQLException,MessageException
		{
			boolean result = true;
			//sys_login_fail_number 0 不禁止，-1 全部禁止登录 >0 默认尝试次数
			int number = CmsCache.getParameter("sys_login_fail_number").getIntValue();
			if(number==0)
				return true;
			else if(number==-1)
				return false;//禁止登陆
			
			TableUtil tu = new TableUtil();
			String sql = "select count(id) from login_log where IsSuccess=0 and UserName='"+tu.SQLQuote(username)+"' and UNIX_TIMESTAMP(Date)>=UNIX_TIMESTAMP(adddate(now(), INTERVAL -1 HOUR))";
			 
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next() )
			{	
				int count = rs.getInt(1);
				if(count>number)//1小时内登陆次数超过 number 就禁止登陆
				{
					result = false;
				}
				 
			}
			tu.closeRs(rs);
			return result;
		}
		
		//获取当前登录用户的租户信息
		public static JSONObject getJuxianInfo(UserInfo user) throws MessageException, SQLException, JSONException{
			
			JSONObject json = new JSONObject();
			
			int companyid = user.getCompany();//用户的租户id
			if(companyid==0){//未绑定租户
				
				TideJson o  = CmsCache.getParameter("juxian_info").getJson();//获取聚现企业信息
				if(o!=null){
					json.put("JuxianID", o.getInt("juxian_id"));
					json.put("JuxianToken", o.getString("juxian_token"));
				}else{
					json.put("JuxianID", "");
					json.put("JuxianToken", "");
				}
			}else{
				TableUtil tu_user = new TableUtil("user");
				String Sql = "select * from company where id="+companyid;
				ResultSet Rs = tu_user.executeQuery(Sql);
				if(Rs.next())
				{
					json.put("JuxianID", Rs.getInt("JuxianID"));
					json.put("JuxianToken", tu_user.convertNull(Rs.getString("JuxianToken")));					
				}
				tu_user.closeRs(Rs);
			}
			return json ;
			
		}
	/*
	 * 根据租户id 返回用户信息
	 *
	 * */
	public  static ArrayList getUserList(UserInfo user) throws MessageException, SQLException, JSONException {
		int companyid = user.getCompany();//用户的租户id
		ArrayList arrayList=new ArrayList();

		String Sql = "select id from userinfo where company="+user.getCompany();//根据租户id查询用户
		TableUtil tu_user = new TableUtil("user");
		ResultSet Rs = tu_user.executeQuery(Sql);
		while (Rs.next()){
			int id =Rs.getInt("id");
			if (id==0)
			{
				continue;
			}
			UserInfo user_=CmsCache.getUser(id);
			arrayList.add(user_);;
		}

		return arrayList;
	}
	/*
	* 根据租户id 返回用户信息，过滤电话号码为空的用户
	* */
		public  static ArrayList getUserListForSubject(UserInfo user) throws MessageException, SQLException, JSONException {
			ArrayList arrayList=new ArrayList();//保存用户对象

			String Sql = "select id from userinfo where company="+user.getCompany();//根据租户id查询用户

			TableUtil tu_user = new TableUtil("user");
			ResultSet Rs = tu_user.executeQuery(Sql);

			while (Rs.next())
			{
				int id =Rs.getInt("id");
				if (id==0)
				{
					continue;
				}
				UserInfo user_=CmsCache.getUser(id);
				String phone=user_.getTel();//获取用户电话号码并判断
				if (phone==null||phone.equals("")) {
					continue;
				}
				arrayList.add(user_);;
			}

			return arrayList;
		}

		public static void main(String[] args) {
			System.out.println("-----");
		}
		
		
		
}
