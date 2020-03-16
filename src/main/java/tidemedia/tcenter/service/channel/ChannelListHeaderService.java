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
import tidemedia.tcenter.mapper.channel.ChannelListHeaderMapper;

import javax.annotation.Resource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

@Service
public class ChannelListHeaderService {
    @Resource
    private ChannelListHeaderMapper listHeaderMapper;

    public List<ChannelListHeader> list(int channelId) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        if(channel.getIsListConfig()==0){
            Channel parentChannel = ListConfigController.findIndeParent(channel);
            if(parentChannel!=null)
                channelId = parentChannel.getId();
        }
        List<ChannelListHeader> list = listHeaderMapper.get(channelId);
        if(channel.getIsWeight()==1){
            ChannelListHeader listHeader = new ChannelListHeader();
            listHeader.setChannel(channelId);
            listHeader.setFieldName("Weight");
            listHeader.setTitle("权重");
            listHeader.setStatus(1);
            int i = 0;
            for (;i < list.size(); i++) {
                ChannelListHeader channelListHeader =  list.get(i);
                if(channelListHeader.getTitle().equals("标题")){
                    break;
                }
            }
            list.add(i+1,listHeader);
        }
        return list;
    }

    public String list_json(int channelId) throws MessageException, SQLException {
        //临时解决这个错误：
        //Error:(87, 70) java: 不兼容的类型: com.alibaba.fastjson.JSONObject无法转换为java.util.List<tidemedia.tcenter.entity.ChannelListHeader>

        List<ChannelListHeader> list = list(channelId);
        List<ChannelListHeader> list2 = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            ChannelListHeader channelListHeader = list.get(i);
            if (channelListHeader.getStatus() == 1) {
                list2.add(list.get(i));
            }
        }
        String str = JSON.toJSON(list2).toString();
        return str;
    }

    public Map<String, Object> list2(int channelId) throws MessageException {
        Channel channel = CmsCache.getChannel(channelId);
        int viewType = channel.getViewType();
        int isListAll = channel.getIsListAll();
        int isShowDraftNumber = channel.getIsShowDraftNumber();
        int isWeight = channel.getIsWeight();
        Map<String, Object> map = new HashMap<>();
        map.put("viewType", viewType);
        map.put("other", isListAll + "," + isShowDraftNumber + "," + isWeight);
        return map;
    }

    public void add(ChannelListHeader listHeader) throws MessageException, SQLException {
        listHeaderMapper.add(listHeader);
        int id = listHeader.getId();//获取主键
        String sql = "update channel_list_header set OrderNumber = id where id = " + id;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }

    public int delete(int id) {
        return listHeaderMapper.delete(id);
    }

    public int update(ChannelListHeader listHeader) {
        return listHeaderMapper.update(listHeader);
    }

    //表单提交接口(默认方法)
    public void setHeader(String id1, int channelId) throws MessageException, SQLException {
        String[] idArray = id1.split(",");
        String[] idArray2 = new String[idArray.length];
        System.arraycopy(idArray, 0, idArray2, 0, idArray.length);
        Arrays.sort(idArray2);
        TableUtil tu = new TableUtil();
        for (int i = 0; i < idArray.length; i++) {
            String sql = "update channel_list_header set OrderNumber=" + idArray2[i] + " where id =" + idArray[i];
            tu.executeUpdate(sql);
        }
        String sql = "update channel_list_header set status = 0 where channel = " + channelId;
        String sql1 = "update channel_list_header set status = 1 where id in (" + id1 + ")";
        tu.executeUpdate(sql);
        tu.executeUpdate(sql1);
    }

    //表单提交接口(修改频道属性)
    public void updateChannelField(int viewType, String other, int channelId) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        channel.setViewType(viewType);
        if (other != null) {
            int[] others = Util.StringToIntArray(other, ",");
            channel.setIsListAll(others[0]);
            channel.setIsShowDraftNumber(others[1]);
            channel.setIsWeight(others[2]);
            if(others[2]==1){
                String sql = "update channel_list_header set OrderNumber = id where channel = "+channelId;
                TableUtil tu = new TableUtil();
                tu.executeUpdate(sql);
            }
        }
        channel.Update();
    }

    //创建频道时生成默认的列表项目
    public static void addHeaderList(int channelId) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql = "insert into channel_list_header (title,status,FieldName,width,script,channel,ordernumber,isDefault) values " +
                "('选择',1,'',50,''," + channelId + ",1,1)," +
                "('标题',1,'Title',0,''," + channelId + ",2,1)," +
                "('状态',1,'Status',60,''," + channelId + ",3,1)," +
                "('创建日期',1,'CreateDate',60,''," + channelId + ",4,1)," +
                "('作者',1,'UserName',80,''," + channelId + ",5,1)," +
                "('操作',1,'',100,0," + channelId + ",6,1)," +
                "('来源',0,'DocFrom',100,''," + channelId + ",7,1)," +
                "('摘要',0,'Summary',150,''," + channelId + ",8,1)";
        tu.executeUpdate(sql);
    }

    //表单列表接口
    public List<Map<String, Object>> fieldList(int channelId) throws MessageException, SQLException {

        Channel channel = CmsCache.getChannel(channelId);
        ArrayList<Field> fieldInfo = channel.getFieldInfo();
        String sql = "select fieldname from channel_list_header where channel = " + channelId;
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
            //筛选已被关联的字段,内容字段，图片和文件类型字段
            if (fieldNames.contains(field.getName()) || field.getName().equals("Content") || field.getFieldType().equals("image") || field.getFieldType().equals("file")) {
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

    public ChannelListHeader getById(int id) {
        return listHeaderMapper.getById(id);
    }

    //删除频道时删除对应列表项目数据
    public static void deleteByChannel(int channelId) throws MessageException, SQLException {
        String sql = "delete from channel_list_header where channel=" + channelId;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }
    //获取非默认字段名
    public static String getFieldName(int channelId) throws MessageException, SQLException {
        String sql = "select * from channel_list_header where channel=" + channelId;
        TableUtil tu = new TableUtil();
        ResultSet resultSet = tu.executeQuery(sql);
        String result = "";
        while (resultSet.next()){
            String fieldName = resultSet.getString("FieldName");
            if(fieldName.length()==0||fieldName.equals("Title")||fieldName.equals("Status")||fieldName.equals("CreateDate")||fieldName.equals("UserName")||fieldName.equals("Summary")||fieldName.equals("DocFrom")){
                continue;
            }
            result+=","+fieldName;
        }
        tu.closeRs(resultSet);
        return result;
    }

    //删除字段时删除对应列表项目数据
    public static void deleteByFieldName(String fieldName) throws MessageException, SQLException {
        String sql = "delete from channel_list_header where FieldName='" + fieldName+"'";
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }
}
