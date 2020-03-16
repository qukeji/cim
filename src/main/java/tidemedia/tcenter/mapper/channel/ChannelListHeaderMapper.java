package tidemedia.tcenter.mapper.channel;
import org.apache.ibatis.annotations.*;
import tidemedia.tcenter.entity.channel.ChannelListHeader;

import java.util.List;
import java.util.Map;

public interface ChannelListHeaderMapper {

    @Select("select * from channel_list_header where Channel = #{channelId} order by ordernumber")
    List<ChannelListHeader> get(int channelId);

    @Select("select * from channel_list_header where id = #{id}")
    ChannelListHeader getById(int id);

    @Insert("insert into channel_list_header (Title,Status,FieldName,Channel,Width,Script) values (#{title},#{status},#{fieldName},#{channel},#{width},#{script})")
    @Options(useGeneratedKeys=true,keyProperty="id")
    int add(ChannelListHeader listHeader);

    @Delete("delete from channel_list_header where id=#{id}")
    int delete(int id);

    @Delete("delete from channel_list_header where channel=#{channelId}")
    int deleteByChannel(int channelId);

    @Update("update channel_list_header set Title=#{title},Width=#{width},FieldName=#{fieldName},Script=#{script} where id = #{id}")
    int update(ChannelListHeader listHeader);
}
