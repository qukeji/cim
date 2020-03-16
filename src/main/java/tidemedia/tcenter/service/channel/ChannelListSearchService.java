package tidemedia.tcenter.service.channel;

import com.alibaba.fastjson.JSON;
import org.springframework.stereotype.Service;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Field;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.controller.channel.ListConfigController;
import tidemedia.tcenter.entity.channel.ChannelListHeader;
import tidemedia.tcenter.entity.channel.ChannelListSearch;
import tidemedia.tcenter.mapper.channel.ChannelListSearchMapper;

import javax.annotation.Resource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

@Service
public class ChannelListSearchService {
    @Resource
    private ChannelListSearchMapper listSearchMapper;

    public List<ChannelListSearch> list(int channelId) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        if(channel.getIsListConfig()==0){
            Channel parentChannel = ListConfigController.findIndeParent(channel);
            if(parentChannel!=null)
                channelId = parentChannel.getId();
        }
        return listSearchMapper.list(channelId);
    }

    public ChannelListSearch getById(int id) {
        return listSearchMapper.getById(id);
    }

    public String list_json(int channelId) throws MessageException, SQLException {
        //临时解决这个错误：
        //Error:(87, 70) java: 不兼容的类型: com.alibaba.fastjson.JSONObject无法转换为java.util.List<tidemedia.tcenter.entity.ChannelListHeader>

        List<ChannelListSearch> list = list(channelId);
        List<ChannelListSearch> list2 = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            ChannelListSearch channelListSearch =  list.get(i);
            if(channelListSearch.getStatus()==1){
                list2.add(list.get(i));
            }
        }
        String str = JSON.toJSON(list2).toString();
        return str;
    }

    //搜索项目提交接口
    public void setSearch(String id1,int channelId) throws MessageException, SQLException {
        String[] idArray = id1.split(",");
        String[] idArray2 = new String[idArray.length];
        System.arraycopy(idArray, 0, idArray2, 0, idArray.length);
        Arrays.sort(idArray2);
        TableUtil tu = new TableUtil();
        for (int i = 0; i < idArray.length; i++) {
            String sql = "update channel_list_search set OrderNumber=" + idArray2[i] + " where id =" + idArray[i];
            tu.executeUpdate(sql);
        }
        String sql = "update channel_list_search set status = 0 where channel = "+channelId;
        String sql1 = "update channel_list_search set status = 1 where id in ("+id1+")";
        tu.executeUpdate(sql);
        tu.executeUpdate(sql1);
    }

    public void add(ChannelListSearch listSearch) throws MessageException, SQLException {
        listSearchMapper.add(listSearch);
        int id = listSearch.getId();//获取主键
        String sql = "update channel_list_search set OrderNumber = id where id = " + id;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }

    public int delete(int id) {
        return listSearchMapper.delete(id);
    }

    public int update(ChannelListSearch listSearch) {
        return listSearchMapper.update(listSearch);
    }

    //创建频道时生成默认的搜索项目
    public static void addSearchList(int channelId) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql = "insert into channel_list_search (title,status,script,FieldName,channel,ordernumber,isDefault) values " +
                "('标题',1,'','Title'," + channelId + ",1,1)," +
                "('时间',1,'','CreateDate'," + channelId + ",2,1)," +
                "('作者',1,'','Author'," + channelId + ",3,1)," +
                "('发布状态',0,'','Status'," + channelId + ",4,1)";
        tu.executeUpdate(sql);
    }

    //删除频道时删除对应搜索项目数据
    public static void deleteByChannel(int channelId) throws MessageException, SQLException {
        String sql = "delete from channel_list_search where channel="+channelId;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }

    //表单列表接口
    public List<Map<String, Object>> fieldList(int channelId) throws MessageException, SQLException {

        Channel channel = CmsCache.getChannel(channelId);
        ArrayList<Field> fieldInfo = channel.getFieldInfo();
        String sql = "select fieldname from channel_list_search where channel = " + channelId;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        List<String> fieldNames = new ArrayList<>();
        while (rs.next()) {
            String fieldname = rs.getString("fieldname");
            fieldNames.add(fieldname);
        }
        tu.closeRs(rs);
        List<Map<String, Object>> list = new ArrayList<>();
        for (Field field : fieldInfo) {
            //筛选未被关联的字段,内容字段，图片和文件类型字段
            if(fieldNames.contains(field.getName())||field.getName().equals("Content")||field.getFieldType().equals("image")||field.getFieldType().equals("file")){
                continue;
            }
            Map<String, Object> map = new HashMap<>();
            map.put("id", field.getId());
            map.put("Title", field.getName());
            map.put("Description", field.getDescription());
            list.add(map);
        }
        return list;
    }

    //删除字段时删除对应搜索项目数据
    public static void deleteByFieldName(String fieldName) throws MessageException, SQLException {
        String sql = "delete from channel_list_search where FieldName='" + fieldName+"'";
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }
}
