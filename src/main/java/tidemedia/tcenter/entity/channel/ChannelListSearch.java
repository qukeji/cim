package tidemedia.tcenter.entity.channel;

import java.io.Serializable;

/**
 * 搜索项目
 */
public class ChannelListSearch implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id = 0;
    private String title = "";//名称
    private int status = 0;//列表页是否显示
    private String script = "";//脚本
    private String fieldName = "";//字段名称  因为字段编号需要和field_desc表关联，创建日期字段没有在field_desc
    private int channel = 0;//频道id
    private int orderNumber = 0;//序列号
    private int isDefault = 0;//是否是默认项  0否1是

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getScript() {
        return script;
    }

    public void setScript(String script) {
        this.script = script;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public int getChannel() {
        return channel;
    }

    public void setChannel(int channel) {
        this.channel = channel;
    }

    public int getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(int orderNumber) {
        this.orderNumber = orderNumber;
    }

    public int getIsDefault() {
        return isDefault;
    }

    public void setIsDefault(int isDefault) {
        this.isDefault = isDefault;
    }

    @Override
    public String toString() {
        return "ChannelListSearch{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", status=" + status +
                ", script='" + script + '\'' +
                ", fieldName='" + fieldName + '\'' +
                ", channel=" + channel +
                ", orderNumber=" + orderNumber +
                ", isDefault=" + isDefault +
                '}';
    }
}
