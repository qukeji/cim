package tidemedia.tcenter.entity.train;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;



@ApiModel(value = "培训管理表")
public class TrainingManagerBean {

    @ApiModelProperty(value = "培训管理表id", dataType = "int")
    private int id;
    @ApiModelProperty(value = "标题", dataType = "String")
    private String 	Title;
    @ApiModelProperty(value = "发布日期", dataType = "String")
    private String 	PublishDate;
    @ApiModelProperty(value = "简介", dataType = "String")
    private String 	Summary;
    @ApiModelProperty(value = "内容", dataType = "String")
    private String 	Content;
    @ApiModelProperty(value = "图片", dataType = "String")
    private String 	Photo;
    @ApiModelProperty(value = "视频地址", dataType = "String")
    private String 	video;
    @ApiModelProperty(value = "类型", dataType = "String")
    private String source_type;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String title) {
        Title = title;
    }

    public String getPublishDate() {
        return PublishDate;
    }

    public void setPublishDate(String publishDate) {
        PublishDate = publishDate;
    }

    public String getSummary() {
        return Summary;
    }

    public void setSummary(String summary) {
        Summary = summary;
    }

    public String getContent() {
        return Content;
    }

    public void setContent(String content) {
        Content = content;
    }

    public String getPhoto() {
        return Photo;
    }

    public void setPhoto(String photo) {
        Photo = photo;
    }

    public String getVideo() {
        return video;
    }

    public void setVideo(String video) {
        this.video = video;
    }

    public String getSource_type() {
        return source_type;
    }

    public void setSource_type(String source_type) {
        this.source_type = source_type;
    }
}
