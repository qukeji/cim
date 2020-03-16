package tidemedia.tcenter.entity.video;

import org.json.JSONArray;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

//创建photo实体类封装数据
public class Video implements Serializable {
    private static final long serialVersionUID = 1L;
    private String title = "";//标题
    private int globalId = 0;
    private String createDate = "";//创建日期
    private int duration = 0;//时长
    private String coverhref = "";//视频封面图
    private List<Map<String, Object>> videolist = new ArrayList<>();

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

    public List<Map<String, Object>> getVideolist() {
        return videolist;
    }

    public void setVideolist(List<Map<String, Object>> videolist) {
        this.videolist = videolist;
    }

    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getCoverhref() {
        return coverhref;
    }

    public void setCoverhref(String coverhref) {
        this.coverhref = coverhref;
    }

    @Override
    public String toString() {
        return "Video{" +
                "title='" + title + '\'' +
                ", globalId=" + globalId +
                ", createDate='" + createDate + '\'' +
                ", duration=" + duration +
                ", coverhref='" + coverhref + '\'' +
                ", videolist=" + videolist +
                '}';
    }
}
