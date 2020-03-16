package tidemedia.tcenter.service.channel;

import com.alibaba.fastjson.JSON;
import org.springframework.stereotype.Service;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelPrivilegeItem;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.user.UserInfo;
import tidemedia.tcenter.controller.channel.ListConfigController;
import tidemedia.tcenter.entity.channel.ChannelListMenu;
import tidemedia.tcenter.mapper.channel.ChannelListMenuMapper;

import javax.annotation.Resource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class ChannelListMenuService {
    @Resource
    private ChannelListMenuMapper listMenuMapper;

    public List<ChannelListMenu> list(int channelId) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        if(channel.getIsListConfig()==0){
            Channel parentChannel = ListConfigController.findIndeParent(channel);
            if(parentChannel!=null)
                channelId = parentChannel.getId();
        }
        return listMenuMapper.list(channelId);
    }

    public String list_json(Channel channel,UserInfo userinfo_session) throws SQLException, MessageException {
        //临时解决这个错误：
        //Error:(87, 70) java: 不兼容的类型: com.alibaba.fastjson.JSONObject无法转换为java.util.List<tidemedia.tcenter.entity.ChannelListMenu>

        boolean canApprove = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanApprove);//发布权限
        boolean canDelete = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanDelete);//删除权限
        boolean canAdd = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanAdd);//新建权限
        boolean createCategory = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CreateCategory);//创建分类权限
        int channelId = channel.getId();
        List<ChannelListMenu> list = list(channelId);
        List<ChannelListMenu> list2 = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            ChannelListMenu channelListMenu =  list.get(i);
            if(channelListMenu.getStatus()==0){//菜单未开启，跳过
                continue;
            }
            if(channelListMenu.getCode().equals("add")&&!canAdd){//新建按钮，用户无权限，跳过
                continue;
            }
            if(channelListMenu.getCode().equals("approve")&&!canApprove){//发布按钮，用户无权限，跳过
                continue;
            }
            if(channelListMenu.getCode().equals("deleteFile2")&&!canApprove){//撤稿按钮，用户无权限，跳过
                continue;
            }
            if(channelListMenu.getCode().equals("deleteFile")&&!canDelete){//删除按钮，用户无权限，跳过
                continue;
            }
            if(channelListMenu.getCode().equals("createCategory2")&&!createCategory){//创建分类按钮，用户无权限，跳过
                continue;
            }
            list2.add(list.get(i));
        }
        String str = JSON.toJSON(list2).toString();
        return str;
    }

    public void add(ChannelListMenu listMenu) throws MessageException, SQLException {
        listMenuMapper.add(listMenu);
        int id = listMenu.getId();//获取主键
        String sql = "update channel_list_menu set OrderNumber = id where id = "+id;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }

    public  ChannelListMenu getById(int id){
        return listMenuMapper.getById(id);
    }

    public ChannelListMenu getByCode(int channelId,String code) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        if(channel.getIsListConfig()==0){
            Channel parentChannel = ListConfigController.findIndeParent(channel);
            if(parentChannel!=null)
                channelId = parentChannel.getId();
        }
        return listMenuMapper.getByCode(channelId,code);
    }

    public static int getByCodeS(int channelId,String code) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        if(channel.getIsListConfig()==0){
            Channel parentChannel = ListConfigController.findIndeParent(channel);
            if(parentChannel!=null)
                channelId = parentChannel.getId();
        }
        String sql = "select * from channel_list_menu where Channel = "+channelId+" and code = '"+code+"'";
        TableUtil tu = new TableUtil();
        ResultSet resultSet = tu.executeQuery(sql);
        int status = 0;
        if (resultSet.next()){
            status = resultSet.getInt("status");
        }
        return status;
    }

    public void setHeader(String id1,int channelId) throws MessageException, SQLException {
        String[] idArray = id1.split(",");
        String[] idArray2 = new String[idArray.length];
        System.arraycopy(idArray, 0, idArray2, 0, idArray.length);
        Arrays.sort(idArray2);
        TableUtil tu = new TableUtil();
        for (int i = 0; i < idArray.length; i++) {
            String sql = "update channel_list_menu set OrderNumber=" + idArray2[i] + " where id =" + idArray[i];
            tu.executeUpdate(sql);
        }
        String sql = "update channel_list_menu set status = 0 where channel = "+channelId;
        String sql1 = "update channel_list_menu set status = 1 where id in ("+id1+")";
        tu.executeUpdate(sql);
        tu.executeUpdate(sql1);
    }

    public int delete(int id) {
        return listMenuMapper.delete(id);
    }

    public int update(ChannelListMenu listMenu) {
        return listMenuMapper.update(listMenu);
    }

    public int update2(ChannelListMenu listMenu) {
        return listMenuMapper.update2(listMenu);
    }

    //创建频道时生成默认的功能菜单
    public static void addMenuList(int channelId) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql = "insert into channel_list_menu (title,status,Icon,script,Isview,channel,ordernumber,code,isDefault) values " +
                "('新建',1,'<i class=\"fa fa-plus mg-r-5 fa\"></i>','addDocument();',0," + channelId + ",1,'add',1)," +
                "('查看',1,'<i class=\"fa fa-search-plus mg-r-5 fa\"></i>','view();\nview($itemid$);',0," + channelId + ",2,'view',1)," +
                "('发布',1,'<i class=\"fa fa-paper-plane mg-r-5 fa\"></i>','approve();\napprove2($itemid$);',1," + channelId + ",3,'approve',1)," +
                "('编辑',1,'<i class=\"fa fa-pencil mg-r-5 fa\"></i>','editDocument1();\neditDocument($itemid$);',0," + channelId + ",4,'edit',1)," +
                "('删除',1,'<i class=\"fa fa-trash mg-r-5 fa\"></i>','deleteFile();\ndeleteFile1($itemid$);',0," + channelId + ",5,'deleteFile',1)," +
                "('本地预览',1,'<i class=\"fa fa-search mg-r-5 fa\"></i>','Preview_();\nPreview2_($itemid$);',1," + channelId + ",6,'Preview2',1)," +
                "('正式预览',1,'<i class=\"fa fa-eye mg-r-5 fa\"></i>','Preview3();\nPreview3_($itemid$);',1," + channelId + ",7,'Preview3',1)," +
                "('撤稿',1,'<i class=\"fa fa-arrow-down mg-r-5 fa\"></i>','deleteFile2();\ndeleteFile3($itemid$);',0," + channelId + ",8,'deleteFile2',1)," +
                "('复制',1,'<i class=\"fa fa-clone mg-r-5 fa\"></i>','copy(0);\ncopy_(0,$itemid$);',0," + channelId + ",9,'copy1',1)," +
                "('移动',1,'<i class=\"fa fa-exchange mg-r-5 fa\"></i>','copy(1);\ncopy_(1,$itemid$);',0," + channelId + ",10,'copy2',1)," +
                "('排序',1,'<i class=\"fa fa-sort-alpha-desc mg-r-5 fa\"></i>','SortDoc();\nSortDoc1($itemid$);',0," + channelId + ",11,'sortDoc',1),"+
                "('置顶',1,'<i class=\"fa fa-upload mg-r-5 fa\"></i>','ChangeTop($channelid$,1);\nCancleTop($channelid$,1,$itemid$);',0," + channelId + ",12,'changeTop1',1),"+
                "('撤销置顶',1,'<i class=\"fa fa-arrow-circle-o-down mg-r-5 fa\"></i>','ChangeTop($channelid$,2);\nCancleTop($channelid$,2,$itemid$);',0," + channelId + ",13,'changeTop2',1),"+
                "('新建分类',1,'<i class=\"fa fa-tags mg-r-5 fa\"></i>','createCategory($channelid$);\ncreateCategory($channelid$);',0," + channelId + ",14,'createCategory2',1),"+
                "('导入文档',0,'<i class=\"fa fa-file-word-o mg-r-5 fa\"></i>','import();\nimport_($itemid$);',0," + channelId + ",15,'import',1),"+
                "('导出列表',0,'<i class=\"fa fa-list mg-r-5 fa\"></i>','export_list();\nexport_list_($itemid$);',0," + channelId + ",16,'export_list',1),"+
                "('导出内容',0,'<i class=\"fa fa-file-text mg-r-5 fa\"></i>','export_content();\nexport_list_($itemid$);',0," + channelId + ",17,'export_content',1)";
        tu.executeUpdate(sql);
    }

    //删除频道时删除对应功能菜单数据
    public static void deleteByChannel(int channelId) throws MessageException, SQLException {
        String sql = "delete from channel_list_menu where channel="+channelId;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }

    public static String selectSaI(int channelId) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        if(channel.getIsListConfig()==0){
            Channel indeParent = ListConfigController.findIndeParent(channel);
            channelId = indeParent.getId();
        }
        String sql = "select * from channel_list_menu where Title = '查看' and Channel = "+channelId;
        System.out.println(sql);
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        String result = "";
        if (rs.next()){
            int status = rs.getInt("status");
            int isview = rs.getInt("isview");
            result+=status+","+isview;
        }
        tu.closeRs(rs);
        return result;
    }
}
