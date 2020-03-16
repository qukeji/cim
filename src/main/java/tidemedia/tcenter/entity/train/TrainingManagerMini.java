package tidemedia.tcenter.entity.train;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;


@ApiModel(value = "培训管理表")
public class TrainingManagerMini {

    @ApiModelProperty(value = "培训管理表id", dataType = "int")
    private int id;
    @ApiModelProperty(value = "标题", dataType = "String")
    private String 	Title;
    @ApiModelProperty(value = "发布日期", dataType = "String")
    private String 	PublishDate;
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

    public String getSource_type() {
        return source_type;
    }

    public void setSource_type(String source_type) {
        this.source_type = source_type;
    }
}
