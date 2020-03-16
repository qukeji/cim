package tidemedia.tcenter.entity.photo;

import java.io.Serializable;

//创建photo实体类封装数据
public class Photo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String title = "";//标题
    private int globalId = 0;//全局ID
    private String photoAddr = "";//地址

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getGlobalId() {
        return globalId;
    }

    public void setGlobalId(int globalId) {
        this.globalId = globalId;
    }

    public String getPhotoAddr() {
        return photoAddr;
    }

    public void setPhotoAddr(String photoAddr) {
        this.photoAddr = photoAddr;
    }

    @Override
    public String toString() {
        return "Photo{" +
                "title='" + title + '\'' +
                ", globalId=" + globalId +
                ", photoAddr='" + photoAddr + '\'' +
                '}';
    }
}
