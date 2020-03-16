package tidemedia.tcenter.mapper.train;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;
import tidemedia.tcenter.entity.train.TrainingManagerBean;
import tidemedia.tcenter.entity.train.TrainingManagerMini;

import java.util.HashMap;
import java.util.List;

@Repository
public interface TrainingMapper {
    /**
     * 查看当前培训
     *
     */
    @Select({"<script>"," select id, Title,PublishDate,Summary,Content,Photo,video,source_type from channel_training_manager  where  1=1  " +
            "and id=${id} ","</script>"})
    List<TrainingManagerBean> getAllTrainManager(@Param("id") int id);

    /**
     * 查看当前培训
     *
     */
    @Select({"<script>"," select id, Title,PublishDate,source_type from channel_training_manager  where  1=1 and status=1 " +
            " <when test='id!=0'>  and id=${id}  </when>","</script>"})
    List<TrainingManagerMini> getAllTrainManagerMini(@Param("id") int id);

    /**
     * 查看当前培训map
     *
     */
    @Select({"<script>"," select id, Title,PublishDate,source_type from channel_training_manager  where  1=1 and status=1 " +
            " <when test='id!=0'>  and id=${id}  </when>"+
            " <when test='title !=\"\"'>  and Title like "+"'%"+"${title}"+"%'"+"</when>"+
            " <when test='source_type!=0'>  and source_type=${source_type}  </when>"+
            " <when test='startDate!=0'> and  PublishDate  <![CDATA[>]]>${startDate}  </when>"+
            " <when test='endDate!=0'> and PublishDate <![CDATA[<]]>${endDate}  </when>"+
            "limit ${start},${limit}" ,"</script>"})
    List<HashMap<String,Object>> getAllTrainManagerMiniMap(@Param("id") int id, @Param("title") String title, @Param("source_type") int source_type, @Param("startDate") Long startDate, @Param("endDate") Long endDate, @Param("start") int start, @Param("limit") int limit);


    /**
     * 查看当前培训map
     *
     */
    @Select({"<script>"," select count(1) from channel_training_manager  where  1=1 and status=1 " +
            " <when test='id!=0'>  and id=${id}  </when>"+
            " <when test='title!=\"\"'>  and Title like "+"'%"+"${title}"+"%'"+" </when>"+
            " <when test='source_type!=0'>  and source_type=${source_type}  </when>"+
            " <when test='startDate!=0'> and PublishDate  <![CDATA[>]]>${startDate}  </when>"+
            " <when test='endDate!=0'> and PublishDate <![CDATA[<]]>${endDate}  </when>","</script>"})
    Integer getAllTrainManagerMiniCount(@Param("id") int id, @Param("title") String title, @Param("source_type") int source_type, @Param("startDate") Long startDate, @Param("endDate") Long endDate);


}
