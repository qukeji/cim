package tidemedia.tcenter.mapper.channel;

import org.apache.ibatis.annotations.*;
import tidemedia.tcenter.entity.channel.ChannelListMenu;

import java.util.List;

public interface ChannelListMenuMapper {
    @Select({"select * from channel_list_menu where Channel = #{channelId} order by ordernumber"})
    List<ChannelListMenu> list(int channelId);

    @Select("select * from channel_list_menu where id = #{id}")
    ChannelListMenu getById(int id);

    @Select("select * from channel_list_menu where Channel = #{channelId} and code = #{code}")
    ChannelListMenu getByCode(@Param("channelId") int channelId, @Param("code") String code);

    @Insert("insert into channel_list_menu (Title,Channel,Icon,Script,Status) values (#{title},#{channel},#{icon},#{script},#{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int add(ChannelListMenu listMenu);

    @Delete("delete from channel_list_menu where id=#{id}")
    int delete(int id);

    @Delete("delete from channel_list_menu where channel=#{channelId}")
    int deleteByChannel(int channelId);

    @Update("update channel_list_menu set Isview=#{isview} where id = #{id}")
    int update(ChannelListMenu listMenu);

    @Update("update channel_list_menu set title=#{title},icon=#{icon},script=#{script} where id = #{id}")
    int update2(ChannelListMenu listMenu);
}
