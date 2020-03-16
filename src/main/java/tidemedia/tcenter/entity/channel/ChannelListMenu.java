package tidemedia.tcenter.entity.channel;

import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.io.Serializable;

/**
 * 功能菜单
 */
public class ChannelListMenu implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id = 0;//主键
    private String title = "";//名称
    private int status = 0;//列表页是否显示  0不显示1显示
    private String icon = "";//图标
    private String script = "";//脚本
    private int isview = 0;//是否显示图标    0不显示1显示
    private int channel = 0;//频道id
    private int orderNumber = 0;//序列号
    private String code = "";//唯一标识
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

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getScript() {
        return script;
    }

    public void setScript(String script) {
        this.script = script;
    }

    public int getIsview() {
        return isview;
    }

    public void setIsview(int isview) {
        this.isview = isview;
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getIsDefault() {
        return isDefault;
    }

    public void setIsDefault(int isDefault) {
        this.isDefault = isDefault;
    }

    @Override
    public String toString() {
        return "ChannelListMenu{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", status=" + status +
                ", icon='" + icon + '\'' +
                ", script='" + script + '\'' +
                ", isview=" + isview +
                ", channel=" + channel +
                ", orderNumber=" + orderNumber +
                ", code='" + code + '\'' +
                ", isDefault=" + isDefault +
                '}';
    }
}
