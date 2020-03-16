package tidemedia.cms.system;

import java.io.Serializable;

import tidemedia.cms.util.Util;

//implements Serializable 目的是支持session同步
public class ChannelPrivilegeItem implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int 		id;
	private int			User;
	private int			Channel;
	private String 		PermType;
	private int[]		PermArray;
	//权限
	//0可见 1浏览文档	2发表文档		3审批文档		4删除文档		5包括子频道    12只看自己
	//11 创建分类
	public static final int	CanSee = 0;
	public static final int CanList = 1;
	public static final int CanAdd = 2;
	public static final int CanApprove = 3;
	public static final int CanDelete = 4;
	public static final int IncludeSubChannels = 5;
	public static final int CreateCategory = 11;
	public static final int onlyMe = 12;
	
	private int	IsInherit;
	
	public ChannelPrivilegeItem() 
	{

	}

	public ChannelPrivilegeItem(int channel,String permtype,int isinherit) 
	{
		setChannel(channel);
		setPermType(permtype);
		setIsInherit(isinherit);
		initPermArray();
	}
	
	public void initPermArray()
	{
		PermArray = Util.StringToIntArray(getPermType(), ",");
	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}


	public String getPermType() {
		return PermType;
	}

	public void setPermType(String permType) {
		PermType = permType;
	}

	public int getIsInherit() {
		return IsInherit;
	}

	public void setIsInherit(int isInherit) {
		IsInherit = isInherit;
	}

	public int getUser() {
		return User;
	}

	public void setUser(int user) {
		User = user;
	}

	public int getChannel() {
		return Channel;
	}

	public void setChannel(int channel) {
		Channel = channel;
	}

	public void setPermArray(int[] permArray) {
		PermArray = permArray;
	}

	public int[] getPermArray() {
		return PermArray;
	}	
}
