package tidemedia.tcenter.controller.channel;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelUtil;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.base.ResultJson;
import tidemedia.tcenter.service.channel.ChannelListFastSearchService;
import tidemedia.tcenter.service.channel.ChannelListHeaderService;
import tidemedia.tcenter.service.channel.ChannelListMenuService;
import tidemedia.tcenter.service.channel.ChannelListSearchService;

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/channel/list")
public class ListConfigController {
    /**
     * 点击列表页配置跳转
     *
     * @param modelMap
     * @param request
     * @return
     */
    @RequestMapping("/config")
    public ModelAndView listConfig(ModelMap modelMap, HttpServletRequest request) throws MessageException, SQLException {
        int channelID = CommonUtil.getIntParameter(request, "ChannelID");
        int listProgramType = ChannelUtil.getFieldValueType(channelID, "ListProgram");
        int listJSType = ChannelUtil.getFieldValueType(channelID, "ListJS");
        String listJS = CmsCache.getChannel(channelID).getListJS();
        String listProgram = CmsCache.getChannel(channelID).getListProgram();
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("channel/list-config");
        modelMap.put("channelID", channelID);
        modelMap.put("listProgram", listProgram);
        modelMap.put("listProgramType", listProgramType);
        modelMap.put("listJS", listJS);
        modelMap.put("listJSType", listJSType);
        return modelAndView;
    }

    /**
     * 列表项目新增编辑页
     *
     * @param modelMap
     * @param request
     * @return
     */
    @RequestMapping("/config/header/eoa")
    public ModelAndView editAddHeader(ModelMap modelMap, HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        int id = CommonUtil.getIntParameter(request, "id");
        int status = CommonUtil.getIntParameter(request, "status");
        int isadd = CommonUtil.getIntParameter(request, "isadd");
        int channelid = CommonUtil.getIntParameter(request, "channelid");
        int isDefault = CommonUtil.getIntParameter(request, "isDefault");
        modelMap.put("id", id);
        modelMap.put("status", status);
        modelMap.put("isadd", isadd);
        modelMap.put("channelid", channelid);
        modelMap.put("isDefault", isDefault);
        modelAndView.setViewName("channel/new-list-item");
        return modelAndView;
    }

    /**
     * 功能菜单新增编辑页
     *
     * @param modelMap
     * @param request
     * @return
     */
    @RequestMapping("/config/menu/eoa")
    public ModelAndView editAddListMenu(ModelMap modelMap, HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        int itemid = CommonUtil.getIntParameter(request, "itemid");
        int isadd = CommonUtil.getIntParameter(request, "isadd");
        int isview = CommonUtil.getIntParameter(request, "isview");
        int channelid = CommonUtil.getIntParameter(request, "channelid");
        int isDefault = CommonUtil.getIntParameter(request, "isDefault");
        modelMap.put("itemid", itemid);
        modelMap.put("isadd", isadd);
        modelMap.put("isview", isview);
        modelMap.put("channelid", channelid);
        modelMap.put("isDefault", isDefault);
        modelAndView.setViewName("channel/new-function-menu");
        return modelAndView;
    }

    /**
     * 搜索项目新增编辑页
     *
     * @param modelMap
     * @param request
     * @return
     */
    @RequestMapping("/config/search/eoa")
    public ModelAndView editAddListSearch(ModelMap modelMap, HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        int itemid = CommonUtil.getIntParameter(request, "itemid");
        int status = CommonUtil.getIntParameter(request, "status");
        int isadd = CommonUtil.getIntParameter(request, "isadd");
        int channelid = CommonUtil.getIntParameter(request, "channelid");
        int isDefault = CommonUtil.getIntParameter(request, "isDefault");
        modelMap.put("itemid", itemid);
        modelMap.put("status", status);
        modelMap.put("isadd", isadd);
        modelMap.put("channelid", channelid);
        modelMap.put("isDefault", isDefault);
        modelAndView.setViewName("channel/editsearchconfig");
        return modelAndView;
    }

    /**
     * 快捷搜索新增编辑页
     *
     * @param modelMap
     * @param request
     * @return
     */
    @RequestMapping("/config/fastsearch/eoa")
    public ModelAndView editAddListFastSearch(ModelMap modelMap, HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        int itemid = CommonUtil.getIntParameter(request, "itemid");
        int status = CommonUtil.getIntParameter(request, "status");
        int isadd = CommonUtil.getIntParameter(request, "isadd");
        int channelid = CommonUtil.getIntParameter(request, "channelid");
        int isDefault = CommonUtil.getIntParameter(request, "isDefault");
        modelMap.put("itemid", itemid);
        modelMap.put("status", status);
        modelMap.put("isadd", isadd);
        modelMap.put("channelid", channelid);
        modelMap.put("isDefault", isDefault);
        modelAndView.setViewName("channel/editfastsearch");
        return modelAndView;
    }

    /**
     * 功能菜单图标页
     *
     * @param modelMap
     * @param request
     * @return
     */
    @RequestMapping("/config/menuicon")
    public ModelAndView menuIcon(ModelMap modelMap, HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("channel/menu-icon-list");
        return modelAndView;
    }

    /**
     * 关联表单页
     *
     * @param modelMap
     * @param request
     * @return
     */
    @RequestMapping("/config/relatedfield")
    public ModelAndView relatedField(ModelMap modelMap, HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        int channelid = CommonUtil.getIntParameter(request, "channelid");
        String type = CommonUtil.getParameter(request, "type");
        modelMap.put("channelid", channelid);
        modelMap.put("type", type);
        modelAndView.setViewName("channel/list-relatedfield");
        return modelAndView;
    }

    /**
     * 开启继承上级
     *
     * @param channelId
     * @return
     */
    public static ResultJson openInherit(int channelId) throws MessageException, SQLException {
        deleteChannelConfig(channelId);
        return ResultJson.success("");
    }


    /**
     * 关闭继承上级(开启独立配置)
     *
     * @param channelId
     * @return
     */
    public static ResultJson closeInherit(int channelId) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        Channel parentChannel = findIndeParent(channel);
        if (parentChannel != null) {
            addChannelListHeader(channelId, parentChannel);
            addChannelListMenu(channelId, parentChannel);
            addChannelListSearch(channelId, parentChannel);
            addChannelListFastSearch(channelId, parentChannel);
        }
        return ResultJson.success("");
    }

    /**
     * 应用到子频道
     *
     * @param channelId
     * @return
     */
    @RequestMapping("/config/useChild")
    public ResultJson useChildChannel(int channelId) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelId);
        ArrayList<Integer> childChannelIDs = channel.getAllChildChannelIDs();
        for (int i = 0; i < childChannelIDs.size(); i++) {
            Integer cid = childChannelIDs.get(i);
            Channel c = CmsCache.getChannel(channelId);
            deleteChannelConfig(cid);
            c.setIsListConfig(0);
        }
        return ResultJson.success("");
    }

    /**
     * 取消应用到子频道
     *
     * @param channelId
     * @return
     */
    @RequestMapping("/config/cancelChild")
    public ResultJson cancelChildChannel(int channelId) throws MessageException, SQLException {
        return ResultJson.success("");
    }

    /**
     * 删除频道配置表数据
     *
     * @param channelId 频道ID
     * @throws MessageException
     * @throws SQLException
     */
    public static void deleteChannelConfig(int channelId) throws MessageException, SQLException {
        ChannelListHeaderService.deleteByChannel(channelId);
        ChannelListMenuService.deleteByChannel(channelId);
        ChannelListSearchService.deleteByChannel(channelId);
        ChannelListFastSearchService.deleteByChannel(channelId);
    }

    /**
     * 获取该频道的独立配置父频道
     *
     * @param channel
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static Channel findIndeParent(Channel channel) throws MessageException, SQLException {
        Channel parentChannel = channel.getParentChannel();
        if (parentChannel.getIsListConfig() == 0) {
            parentChannel = findIndeParent(parentChannel);
        }
        return parentChannel;
    }

    /**
     * @param request
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    @RequestMapping("/config/channel/update")
    public static void channelEdit(HttpServletRequest request) throws MessageException, SQLException {
        UserInfo userInfo = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
        int userId = userInfo.getId();
        int channelId = CommonUtil.getIntParameter(request, "channelid");
        int ListProgram_Type = CommonUtil.getIntParameter(request, "ListProgram_Type");
        int ListJS_Type = CommonUtil.getIntParameter(request, "ListJS_Type");
        String ListProgram = CommonUtil.getParameter(request, "ListProgram");
        String ListJS = CommonUtil.getParameter(request, "ListJS");
        if (ListProgram_Type == 0) ListProgram = "***";
        if (ListJS_Type == 0) ListJS = "***";
        Channel channel = new Channel(channelId);
        channel.setListJS(ListJS);
        channel.setListProgram(ListProgram);
        channel.setActionUser(userId);
        channel.Update();
    }

    //复制列表项目表父频道数据到本频道
    public static void addChannelListHeader(int channelId, Channel parentChannel) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql = "select * from channel_list_header where channel = " + parentChannel.getId();
        ResultSet rs = tu.executeQuery(sql);
        List<String> list = new ArrayList<>();
        while (rs.next()) {
            String title = rs.getString("title");
            int status = rs.getInt("status");
            String fieldname = rs.getString("fieldname");
            int width = rs.getInt("width");
            String script = rs.getString("script");
            int isdefault = rs.getInt("isdefault");
            String string = "'" + title + "'," + status + ",'" + fieldname + "'," + width + ",'" + script + "'," + isdefault;
            list.add(string);
        }
        tu.closeRs(rs);
        for (int i = 0; i < list.size(); i++) {
            String s = list.get(i);
            String[] strings = Util.StringToArray(s, ",");
            String string1 = "insert into channel_list_header (title,status,fieldname,width,script,isdefault,channel) values";
            for (int j = 0; j < strings.length; j++) {
                if (j == 0) {
                    string1 += " (" + strings[j];
                } else {
                    string1 += "," + strings[j];
                }
            }
            string1 += "," + channelId + ")";
            tu.executeUpdate(string1);
        }
        String updateOrdernumberSql = "update channel_list_header set ordernumber = id where ordernumber is null or ordernumber = 0";
        tu.executeUpdate(updateOrdernumberSql);
    }

    //复制功能菜单表父频道数据到本频道
    public static void addChannelListMenu(int channelId, Channel parentChannel) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql = "select * from channel_list_menu where channel = " + parentChannel.getId();
        ResultSet rs = tu.executeQuery(sql);
        List<String> list = new ArrayList<>();
        while (rs.next()) {
            String title = rs.getString("title");
            int status = rs.getInt("status");
            String Icon = rs.getString("Icon");
            String script = rs.getString("script");
            int Isview = rs.getInt("Isview");
            String code = rs.getString("code");
            int isdefault = rs.getInt("isdefault");
            String string = "'" + title + "'," + status + ",'" + Icon + "','" + script + "'," + Isview + ",'" + code + "'," + isdefault;
            list.add(string);
        }
        tu.closeRs(rs);
        for (int i = 0; i < list.size(); i++) {
            String s = list.get(i);
            String[] strings = Util.StringToArray(s, ",");
            String string1 = "insert into channel_list_menu (title,status,Icon,script,Isview,code,isdefault,channel) values";
            for (int j = 0; j < strings.length; j++) {
                if (j == 0) {
                    string1 += " (" + strings[j];
                } else {
                    string1 += "," + strings[j];
                }
            }
            string1 += "," + channelId + ")";
            tu.executeUpdate(string1);
        }
        String updateOrdernumberSql = "update channel_list_menu set ordernumber = id where ordernumber is null or ordernumber = 0";
        tu.executeUpdate(updateOrdernumberSql);
    }

    //复制搜索项目表父频道数据到本频道
    public static void addChannelListSearch(int channelId, Channel parentChannel) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql = "select * from channel_list_search where channel = " + parentChannel.getId();
        ResultSet rs = tu.executeQuery(sql);
        List<String> list = new ArrayList<>();
        while (rs.next()) {
            String title = rs.getString("title");
            int status = rs.getInt("status");
            String script = rs.getString("script");
            String fieldname = rs.getString("fieldname");
            int isdefault = rs.getInt("isdefault");
            String string = "'" + title + "'," + status + ",'" + script + "'," + ",'" + fieldname + "'," + isdefault;
            list.add(string);
        }
        tu.closeRs(rs);
        for (int i = 0; i < list.size(); i++) {
            String s = list.get(i);
            String[] strings = Util.StringToArray(s, ",");
            String string1 = "insert into channel_list_search (title,status,script,fieldname,isdefault,channel) values";
            for (int j = 0; j < strings.length; j++) {
                if (j == 0) {
                    string1 += " (" + strings[j];
                } else {
                    string1 += "," + strings[j];
                }
            }
            string1 += "," + channelId + ")";
            tu.executeUpdate(string1);
        }
        String updateOrdernumberSql = "update channel_list_search set ordernumber = id where ordernumber is null or ordernumber = 0";
        tu.executeUpdate(updateOrdernumberSql);
    }

    //复制快捷搜索表父频道数据到本频道
    public static void addChannelListFastSearch(int channelId, Channel parentChannel) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql = "select * from channel_list_fastsearch where channel = " + parentChannel.getId();
        ResultSet rs = tu.executeQuery(sql);
        List<String> list = new ArrayList<>();
        while (rs.next()) {
            String title = rs.getString("title");
            int status = rs.getInt("status");
            String script = rs.getString("script");
            String wheresql = rs.getString("wheresql");
            int isdefault = rs.getInt("isdefault");
            String code = rs.getString("code");
            String string = "'" + title + "'," + status + ",'" + script + "'," + ",'" + wheresql + "'," + isdefault + ",'" + code + "'";
            list.add(string);
        }
        tu.closeRs(rs);
        for (int i = 0; i < list.size(); i++) {
            String s = list.get(i);
            String[] strings = Util.StringToArray(s, ",");
            String string1 = "insert into channel_list_fastsearch (title,status,script,wheresql,isdefault,code,channel) values";
            for (int j = 0; j < strings.length; j++) {
                if (j == 0) {
                    string1 += " (" + strings[j];
                } else {
                    string1 += "," + strings[j];
                }
            }
            string1 += "," + channelId + ")";
            tu.executeUpdate(string1);
        }
        String updateOrdernumberSql = "update channel_list_fastsearch set ordernumber = id where ordernumber is null or ordernumber = 0";
        tu.executeUpdate(updateOrdernumberSql);
    }
}
