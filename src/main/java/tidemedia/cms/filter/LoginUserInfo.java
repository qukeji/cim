/*
 * Created on 2004-6-22
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package tidemedia.cms.filter;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.Util;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class LoginUserInfo {
	
	private int		id;
	private int 	ActionUser = 0;
	private String 	Username = "";
	private String 	Password = "";
	private	String 	Name = "";
	private String 	Email = "";
	private String	Tel = "";
	private String 	Comment = "";	
	private String 	CreateDate = "";
	private int		Role;
	private String	RoleName = "";
	private int 	Status;
	private int 	Group;
	
	private int	MessageType = 0;
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public LoginUserInfo() throws MessageException, SQLException {
		super();
	}

	public LoginUserInfo(int id) throws SQLException, MessageException
	{
		String Sql = "select * from userinfo where id="+id;
		TableUtil tu = new TableUtil("mysql");
		ResultSet Rs = null;
		Rs = tu.executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setName(tu.convertNull(Rs.getString("Name")));
			setEmail(tu.convertNull(Rs.getString("Email")));
			setUsername(tu.convertNull(Rs.getString("Username")));

			setTel(tu.convertNull(Rs.getString("Tel")));
			setComment(tu.convertNull(Rs.getString("Comment")));
			setRole(Rs.getInt("Role"));
			if(Role==1)
				RoleName = "系统管理员";
			else if(Role==2)
				RoleName = "频道管理员";
			else if(Role==3)
				RoleName = "编辑";
			else if(Role==4)
				RoleName = "记者";
			else if(Role==5)
				RoleName = "视客管理员";
			
			setGroup(Rs.getInt("GroupID"));
			
			tu.closeRs(Rs);
		}
		else
			{tu.closeRs(Rs);}//throw new MessageException("该用户不存在!");}
	}

	/* (non-Javadoc)
	 * @see tidemedia.enite.system.Table#canAdd()
	 */
	public boolean canAdd() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.enite.system.Table#canDelete()
	 */
	public boolean canDelete() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.enite.system.Table#canUpdate()
	 */
	public boolean canUpdate() {
		return false;
	}


	/**
	 * @return
	 */
	public String getCreateDate() {
		return CreateDate;
	}

	/**
	 * @return
	 */
	public String getEmail() {
		return Email;
	}

	/**
	 * @return
	 */
	public int getId() {
		return id;
	}

	/**
	 * @return
	 */
	public String getName() {
		return Name;
	}

	/**
	 * @return
	 */
	public String getPassword() {
		return Password;
	}

	/**
	 * @return
	 */
	public int getStatus() {
		return Status;
	}

	/**
	 * @param string
	 */
	public void setCreateDate(String string) {
		CreateDate = string;
	}

	/**
	 * @param string
	 */
	public void setEmail(String string) {
		Email = string;
	}

	/**
	 * @param i
	 */
	public void setId(int i) {
		id = i;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		Name = string;
	}

	/**
	 * @param string
	 */
	public void setPassword(String string) {
		Password = string;
	}

	/**
	 * @param i
	 */
	public void setStatus(int i) {
		Status = i;
	}

	public boolean Authorization(HttpServletRequest request,HttpServletResponse response,String username,String password,boolean cookie) throws SQLException, MessageException
	{
		if(username.equals("") || password.equals(""))
			return false;
		TableUtil tu = new TableUtil("mysql");
		
		if(cookie)
		{
	        String values[] = decodePasswordCookie(password, new String(new char[] {'\023', 'C', 'i'}));
	        if(values == null)
	            password = "";
	        else
	        {
	        	password = values[1];
	        }
		}
		
		String Sql = "select * from userinfo where Username='" + tu.SQLQuote(username) + "' and Password=md5('" + tu.SQLQuote(password) + "')";
		ResultSet Rs = null;
		
		try
		{
			Rs = tu.executeQuery(Sql);
		}
		catch(Exception e)
		{
			System.out.println("---------------------------------------------");
			System.out.println(e.getMessage());
			System.out.println("---------------------------------------------");
			System.out.println("close all conneciton.");
			tu = new TableUtil();
			Rs = tu.executeQuery(Sql);
		}
		
		if(Rs.next())
		{
			String str = tu.convertNull(Rs.getString("Username"));
			int User_ID = Rs.getInt("id");
			//String User_Name = convertNull(Rs.getString("Name"));		
				
			tu.closeRs(Rs);
			
			//if(password.equals(str))
			if(username.equals(str))
			{
				HttpSession session = request.getSession();
				LoginUserInfo userinfo = new LoginUserInfo(User_ID);
			
				if(userinfo.getUsername().equals(username))
				{
					int    CookieLogin	= Util.getIntParameter(request,"CookieLogin");
					if(CookieLogin==1 && !cookie)
						SavePasswordCookie(response,encodePasswordCookie(username, password, new String(new char[] {'\023','C','i'})));

					session.setAttribute("CMSUserInfo",userinfo);
					return true;
				}
				else
				{
		
					return false;
				}
			}

			return false;
		}
		else
		{
			tu.closeRs(Rs);
			return false;
		}
	}


	/**
	 * @return
	 */
	public String getUsername() {
		return Username;
	}

	/**
	 * @param string
	 */
	public void setUsername(String string) {
		Username = string;
	}

	/**
	 * @return
	 */
	public String getComment() {
		return Comment;
	}

	/**
	 * @return
	 */
	public String getTel() {
		return Tel;
	}

	/**
	 * @param string
	 */
	public void setComment(String string) {
		Comment = string;
	}

	/**
	 * @param string
	 */
	public void setTel(String string) {
		Tel = string;
	}

	/**
	 * @return
	 */
	public int getRole() {
		return Role;
	}

	/**
	 * @param i
	 */
	public void setRole(int i) {
		//if(i!=1 && i!=2 && i!=3 && i!=4)
		//	i = 0;
			
		Role = i;
	}

	public boolean isAdministrator()
	{
		if(Role==1)
			return true;
		else
			return false;
	}
	
	public boolean isSuperEditor()
	{
		if(Role==2)
			return true;
		else
			return false;
	}
	
	public boolean isEditor()
	{
		if(Role==3)
			return true;
		else
			return false;
	}

	public String getRoleName() {
		return RoleName;
	}

	public void setRoleName(String string) {
		RoleName = string;
	}

	public int getMessageType() {
		return MessageType;
	}

	public void setMessageType(int i) {
		MessageType = i;
	}


	/**
	 * @return Returns the group.
	 */
	public int getGroup() {
		return Group;
	}
	/**
	 * @param group The group to set.
	 */
	public void setGroup(int group) {
		Group = group;
	}


	public int getActionUser() {
		return ActionUser;
	}

	public void setActionUser(int actionUser) {
		ActionUser = actionUser;
	}

	public static void SavePasswordCookie(HttpServletResponse response,String password)
	{
        Cookie cookie = new Cookie("Username2", password);
        cookie.setMaxAge(365*24*60*60);
        response.addCookie(cookie);
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
        System.out.println("passwordcookie:"+buf.toString());
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
}

