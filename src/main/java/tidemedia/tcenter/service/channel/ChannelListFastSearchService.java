package tidemedia.tcenter.service.channel;

import com.alibaba.fastjson.JSON;
import org.springframework.stereotype.Service;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.tcenter.controller.channel.ListConfigController;
import tidemedia.tcenter.entity.channel.ChannelListFastSearch;
import tidemedia.tcenter.mapper.channel.ChannelListFastSearchMapper;

import javax.annotation.Resource;
import java.sql.SQLException;
import java.util.*;

@Service
public class ChannelListFastSearchService {
    @Resource
    private ChannelListFastSearchMapper listFastSearchMapper;

    public List<ChannelListFastSearch> list(int channelId) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        if(channel.getIsListConfig()==0){
            Channel parentChannel = ListConfigController.findIndeParent(channel);
            if(parentChannel!=null)
                channelId = parentChannel.getId();
        }
        return listFastSearchMapper.list(channelId);
    }

    public ChannelListFastSearch getById(int id) {
        return listFastSearchMapper.getById(id);
    }

    public String list_json(int channelId) throws MessageException, SQLException {
        //临时解决这个错误：
        //Error:(87, 70) java: 不兼容的类型: com.alibaba.fastjson.JSONObject无法转换为java.util.List<tidemedia.tcenter.entity.ChannelListFastSearch>

        List<ChannelListFastSearch> list = list(channelId);
        List<ChannelListFastSearch> list2 = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            ChannelListFastSearch listFastSearch =  list.get(i);
            if(listFastSearch.getStatus()==1){
                list2.add(list.get(i));
            }
        }
        String str = JSON.toJSON(list2).toString();
        return str;
    }

    //快捷搜索提交接口
    public void setFastSearch(String id1,int channelId) throws MessageException, SQLException {
        String[] idArray = id1.split(",");
        String[] idArray2 = new String[idArray.length];
        System.arraycopy(idArray, 0, idArray2, 0, idArray.length);
        Arrays.sort(idArray2);
        TableUtil tu = new TableUtil();
        for (int i = 0; i < idArray.length; i++) {
            String sql = "update channel_list_fastsearch set OrderNumber=" + idArray2[i] + " where id =" + idArray[i];
            tu.executeUpdate(sql);
        }
        String sql = "update channel_list_fastsearch set status = 0 where channel = " + channelId;
        String sql1 = "update channel_list_fastsearch set status = 1 where id in (" + id1 + ")";
        tu.executeUpdate(sql);
        tu.executeUpdate(sql1);
    }

    public void add(ChannelListFastSearch listFastSearch) throws MessageException, SQLException {
        listFastSearchMapper.add(listFastSearch);
        int id = listFastSearch.getId();//获取主键
        String sql = "update channel_list_fastsearch set OrderNumber = id where id = " + id;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }

    public int delete(int id) {
        return listFastSearchMapper.delete(id);
    }

    public int update(ChannelListFastSearch listFastSearch) {
        return listFastSearchMapper.update(listFastSearch);
    }

    //创建频道时生成默认的快捷搜索
    public static void addSearchList(int channelId) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql = "insert into channel_list_fastsearch (title,status,script,wheresql,channel,ordernumber,isDefault,code) values " +
                "('全部',1,'',''," + channelId + ",1,1,'allList')," +
                "('草稿',1,'','Status=0'," + channelId + ",2,1,'draftList')," +
                "('已发',1,'','Status=1'," + channelId + ",3,1,'publishList')," +
                "('已删除',1,'','IsDelete=1'," + channelId + ",4,1,'deleteList')," +
                "('搜索',1,'',''," + channelId + ",5,1,'search')";
        tu.executeUpdate(sql);
    }

    //删除频道时删除对应快捷搜索数据
    public static void deleteByChannel(int channelId) throws MessageException, SQLException {
        String sql = "delete from channel_list_fastsearch where channel="+channelId;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }
}
