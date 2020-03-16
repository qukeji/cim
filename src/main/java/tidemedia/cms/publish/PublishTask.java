package tidemedia.cms.publish;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.RedisUtil;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Administrator
 *
 */
public class PublishTask extends Table implements Serializable{
	private static final long serialVersionUID = -7128203829971899888L;

	public PublishTask() throws MessageException, SQLException {
		super();
	}

	private int 	TaskID;
	private int 	PublishType;
	private int 	UserID;
	private int 	ChannelID;
	private int 	ItemID;
	private long	CanPublishTime = 0;//允许发布时间，为0表示不限制时间，时间戳，单位是秒 2015/10/16
	private int		ChannelTemplateID = 0;//配置模板编号
	private int 	PublishAllItems;//发布所有内容,0 只发布还未发布的内容 1 重新发布所有内容	
	
    //发布类型
    public static final int	FILE_PUBLISH = 0;//文件发布
    public static final int CHANNEL_PUBLISH = 1;//频道发布
    public static final int	APPROVE_DOCUMENT_PUBLISH = 2;//审核文档后发布
    public static final int EDIT_DOCUMENT_PUBLISH = 3;//编辑文档后发布
    public static final int ORDER_DOCUMENT_PUBLISH = 4;//排序文档后发布
    public static final int DELETE_DOCUMENT_PUBLISH = 5;//删除文档后发布   
    public static final int ExtraTemplate_PUBLISH = 6;//只发布附加模板
    public static final int ONLYTHISTemplate_PUBLISH = 7;//只发布指定模板
    public static final int ONLY_DOCUMENT_PUBLISH = 8;//只发布指定文档	
	
    
	public PublishTask(int id) throws SQLException, MessageException
	{
		String Sql = "";
		TableUtil tu = new TableUtil();
		
		Sql = "select * from publish_task where id=" + id;
				
		ResultSet Rs = tu.executeQuery(Sql);
		if(Rs.next())
		{
			setTaskID(Rs.getInt("id"));
			setChannelID(Rs.getInt("ChannelID"));
			setPublishAllItems(Rs.getInt("PublishAllItems"));
			setPublishType(Rs.getInt("PublishType"));
			setItemID(Rs.getInt("ItemID"));
			setUserID(Rs.getInt("User"));
			setChannelTemplateID(Rs.getInt("ChannelTemplateID"));
		}
		
		tu.closeRs(Rs);			
	}
	
	/**
	 * @return Returns the channelID.
	 */
	public int getChannelID() {
		return ChannelID;
	}
	/**
	 * @param channelID The channelID to set.
	 */
	public void setChannelID(int channelID) {
		ChannelID = channelID;
	}

	/**
	 * @return Returns the taskID.
	 */
	public int getTaskID() {
		return TaskID;
	}
	/**
	 * @param taskID The taskID to set.
	 */
	public void setTaskID(int taskID) {
		TaskID = taskID;
	}
	/**
	 * @return Returns the publishType.
	 */
	public int getPublishType() {
		return PublishType;
	}
	/**
	 * @param publishType The publishType to set.
	 */
	public void setPublishType(int publishType) {
		PublishType = publishType;
	}
	/**
	 * @return Returns the userID.
	 */
	public int getUserID() {
		return UserID;
	}
	/**
	 * @param userID The userID to set.
	 */
	public void setUserID(int userID) {
		UserID = userID;
	}
	/**
	 * @return Returns the itemID.
	 */
	public int getItemID() {
		return ItemID;
	}
	/**
	 * @param itemID The itemID to set.
	 */
	public void setItemID(int itemID) {
		ItemID = itemID;
	}
	/**
	 * @return Returns the publishAllItems.
	 */
	public int getPublishAllItems() {
		return PublishAllItems;
	}
	/**
	 * @param publishAllItems The publishAllItems to set.
	 */
	public void setPublishAllItems(int publishAllItems) {
		PublishAllItems = publishAllItems;
	}
	
	@Override
	public void Add() throws SQLException, MessageException {
	 	String Sql = "";
	 	
	 	Sql = "insert publish_task (PublishType,ChannelID,ItemID,User,PublishAllItems,ChannelTemplateID,CanPublishTime,Status,CreateDate) values(";
	 	Sql += PublishType + "," + ChannelID + "," + ItemID + "," + UserID + "," +PublishAllItems;
	 	Sql += ","+ChannelTemplateID;
	 	
	 	if(CanPublishTime>0)
	 		Sql += ","+CanPublishTime;
	 	else
	 		Sql += ",UNIX_TIMESTAMP()";//当前时间
	 	
	 	Sql += ",0,now())";

	 	int TaskId=executeUpdate_InsertID(Sql);
	 	setTaskID(TaskId);

		/** 2019-07-26 曲科籍  将模板任务放置在Redis队列 **/
		PublishTaskMessageBean TaskMessageItem = new PublishTaskMessageBean();
		TaskMessageItem.setTaskID(TaskId);
		TaskMessageItem.setChannelID(ChannelID);
		TaskMessageItem.setPublishAllItems(PublishAllItems);
		TaskMessageItem.setPublishType(PublishType);
		TaskMessageItem.setItemID(ItemID);
		TaskMessageItem.setUserID(UserID);
		TaskMessageItem.setChannelTemplateID(ChannelTemplateID);
		if(RedisUtil.getInstance().isRedis()) {
			RedisUtil.getInstance().putTemplateMessage(TaskMessageItem, RedisUtil.PUBLISH_TEMPLATE_MESSAGE_KEY);//推送至Redis队列
		}
	}


	@Override
	public void Delete(int id) throws SQLException, MessageException {
		
	}
	
	@Override
	public void Update() throws SQLException, MessageException {
		
	}
	
	@Override
	public boolean canAdd() {
		return false;
	}
	
	@Override
	public boolean canDelete() {
		return false;
	}
	
	@Override
	public boolean canUpdate() {
		return false;
	}
	public long getCanPublishTime() {
		return CanPublishTime;
	}
	public void setCanPublishTime(long canPublishTime) {
		CanPublishTime = canPublishTime;
	}
	public int getChannelTemplateID() {
		return ChannelTemplateID;
	}
	public void setChannelTemplateID(int channelTemplateID) {
		ChannelTemplateID = channelTemplateID;
	}

}
