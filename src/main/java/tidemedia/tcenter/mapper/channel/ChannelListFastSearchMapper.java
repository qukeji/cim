package tidemedia.tcenter.mapper.channel;

import org.apache.ibatis.annotations.*;
import tidemedia.tcenter.entity.channel.ChannelListFastSearch;

import java.util.List;

public interface ChannelListFastSearchMapper {

    @Select("select * from channel_list_fastsearch where Channel = #{channelId} order by ordernumber")
    List<ChannelListFastSearch> list(int channelId);

    @Select("select * from channel_list_fastsearch where id = #{id}")
    ChannelListFastSearch getById(int id);

    @Insert("insert into channel_list_fastsearch (Title,Status,wheresql,Channel,Script) values (#{title},#{status},#{wheresql},#{channel},#{script})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int add(ChannelListFastSearch listFastSearch);

    @Delete("delete from channel_list_fastsearch where id=#{id}")
    int delete(int id);

    @Delete("delete from channel_list_fastsearch where channel=#{channelId}")
    int deleteByChannel(int channelId);

    @Update("update channel_list_fastsearch set Title=#{title},wheresql=#{wheresql},Script=#{script} where id = #{id}")
    int update(ChannelListFastSearch listFastSearch);

}
