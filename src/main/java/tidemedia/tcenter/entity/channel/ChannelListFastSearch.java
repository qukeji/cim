package tidemedia.tcenter.entity.channel;

import java.io.Serializable;

/**
 * 快捷搜索
 */
public class ChannelListFastSearch implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id = 0;
    private String title = "";//名称
    private int status = 0;//列表页是否显示
    private String script = "";//脚本
    private String wheresql = "";//wheresql:用来拼接sql
    private int channel = 0;//频道id
    private int orderNumber = 0;//序列号
    private int isDefault = 0;//是否是默认项  0否1是
    private String code = "";//唯一标识，目前功能是判断是否允许编辑

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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getWheresql() {
        return wheresql;
    }

    public void setWheresql(String wheresql) {
        this.wheresql = wheresql;
    }

    @Override
    public String toString() {
        return "ChannelListFastSearch{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", status=" + status +
                ", script='" + script + '\'' +
                ", wheresql='" + wheresql + '\'' +
                ", channel=" + channel +
                ", orderNumber=" + orderNumber +
                ", isDefault=" + isDefault +
                ", code='" + code + '\'' +
                '}';
    }
}
