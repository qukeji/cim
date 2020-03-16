package tidemedia.tcenter.mapper.channel;

import org.apache.ibatis.annotations.*;
import tidemedia.tcenter.entity.channel.ChannelListSearch;

import java.util.List;

public interface ChannelListSearchMapper {

    @Select("select * from channel_list_search where Channel = #{channelId} order by ordernumber")
    List<ChannelListSearch> list(int channelId);

    @Select("select * from channel_list_search where id = #{id}")
    ChannelListSearch getById(int id);

    @Insert("insert into channel_list_search (Title,Status,FieldName,Channel,Script) values (#{title},#{status},#{fieldName},#{channel},#{script})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int add(ChannelListSearch listSearch);

    @Delete("delete from channel_list_search where id=#{id}")
    int delete(int id);

    @Delete("delete from channel_list_search where channel=#{channelId}")
    int deleteByChannel(int channelId);

    @Update("update channel_list_search set Title=#{title},FieldName=#{fieldName},Script=#{script} where id = #{id}")
    int update(ChannelListSearch listSearch);

}
