package tidemedia.cms.publish;

import java.io.Serializable;

public class PublishTaskMessageBean implements Serializable {
    private int 	TaskID;
    private int 	PublishType;
    private int 	UserID;
    private int 	ChannelID;
    private int 	ItemID;
    private long	CanPublishTime = 0;//允许发布时间，为0表示不限制时间，时间戳，单位是秒 2015/10/16
    private int		ChannelTemplateID = 0;//配置模板编号
    private int 	PublishAllItems;//发布所有内容,0 只发布还未发布的内容 1 重新发布所有内容

    public int getTaskID() {
        return TaskID;
    }

    public void setTaskID(int taskID) {
        TaskID = taskID;
    }

    public int getPublishType() {
        return PublishType;
    }

    public void setPublishType(int publishType) {
        PublishType = publishType;
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int userID) {
        UserID = userID;
    }

    public int getChannelID() {
        return ChannelID;
    }

    public void setChannelID(int channelID) {
        ChannelID = channelID;
    }

    public int getItemID() {
        return ItemID;
    }

    public void setItemID(int itemID) {
        ItemID = itemID;
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

    public int getPublishAllItems() {
        return PublishAllItems;
    }

    public void setPublishAllItems(int publishAllItems) {
        PublishAllItems = publishAllItems;
    }
}
