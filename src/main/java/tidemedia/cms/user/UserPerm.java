/*
 * Created on 2005-6-26
 *
 */
package tidemedia.cms.user;

import java.sql.SQLException;

import tidemedia.cms.base.MessageException;

/**
 * @author Administrator
 *
 */
public class UserPerm {

	public boolean canAddPublishScheme(UserInfo userinfo) throws SQLException, MessageException
	{
		if(userinfo.getUsername().equals("admin"))
			return true;
		
		if(userinfo.isAdministrator() && !userinfo.hasPermission("DisableAddPublishScheme"))
			return true;
		else
			return false;
	}

	public boolean canEditConfig(UserInfo userinfo) throws SQLException, MessageException
	{
		if(userinfo.getUsername().equals("admin"))
			return true;
		
		if(userinfo.isAdministrator() && !userinfo.hasPermission("DisableChangeConfig"))
			return true;
		else
			return false;
	}

	public boolean canManageAdminUser(UserInfo userinfo) throws SQLException, MessageException
	{
		if(userinfo.getUsername().equals("admin"))
			return true;
		
		if(userinfo.isAdministrator() && !userinfo.hasPermission("DisableManageAdminUser"))
			return true;
		else
			return false;
	}

	public boolean canManageUser(UserInfo userinfo) throws SQLException, MessageException
	{
		if(userinfo.getUsername().equals("admin"))
			return true;
		
		if(userinfo.isAdministrator() && !userinfo.hasPermission("DisableManageUser"))
			return true;
		else
			return false;
	}
	
	public boolean canDeleteChannel(UserInfo userinfo) throws SQLException, MessageException
	{
		if(userinfo.getUsername().equals("admin"))
			return true;
		
		if(userinfo.isAdministrator() && !userinfo.hasPermission("DisableDeleteChannel"))
			return true;
		else
			return false;
	}
}
