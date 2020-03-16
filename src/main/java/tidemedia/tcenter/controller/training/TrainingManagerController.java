package tidemedia.tcenter.controller.training;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelPrivilegeItem;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.Util;

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import static tidemedia.cms.util.Util2.convertNull;

/**
 * 运营中心培训管理列表页
 * from:content2018
 */
@Api(value = "运营中心培训管理", description = "运营中心培训管理")
@Controller
@RequestMapping("/admin")
public class TrainingManagerController {


    /**
     * 培训管理列表页
     *
     * @return
     */
    @ApiOperation(value = "培训管理列表页", notes = "培训管理列表页")
    @RequestMapping(value = "/training_list")
    public ModelAndView trainingListPage(HttpServletRequest request, ModelMap modelMap) throws MessageException, SQLException, ParseException {

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("training/trainingManager");

        UserInfo userinfo_session = new UserInfo();
        userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
        int currPage = CommonUtil.getIntParameter(request, "currPage");
        int rowsPerPage = CommonUtil.getIntParameter(request, "rowsPerPage");
        int rows = CommonUtil.getIntParameter(request, "rows");
        int cols = CommonUtil.getIntParameter(request, "cols");
        String S_Title = CommonUtil.getParameter(request, "Title");
        String S_startDate = CommonUtil.getParameter(request, "startDate");
        String S_endDate = CommonUtil.getParameter(request, "endDate");
        String S_User = CommonUtil.getParameter(request, "User");
        String source_type = CommonUtil.getParameter(request, "source_type");
        String Status = CommonUtil.getParameter(request, "Status");


        if (currPage < 1)
            currPage = 1;
        if (rowsPerPage == 0)
            rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new", request.getCookies()));
        if (rowsPerPage <= 0)
            rowsPerPage = 10;
        if (rows == 0)
            rows = Util.parseInt(Util.getCookieValue("rows_new", request.getCookies()));
        if (cols == 0)
            cols = Util.parseInt(Util.getCookieValue("cols_new", request.getCookies()));
        if (rows == 0)
            rows = 10;
        if (cols == 0)
            cols = 5;

        int listType = 0;
        listType = CommonUtil.getIntParameter(request, "listtype");
        if (listType == 0) listType = 1;

        Channel channel = CmsCache.getChannel(16398);

        int ChannelID = channel.getId();
        String ChannelName = channel.getName();

        String pageName = "/tcenter" + request.getServletPath();
        boolean canApprove = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanApprove);
        boolean canDelete = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanDelete);
        boolean createCategory = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CreateCategory);
        boolean hasRight = channel.hasRight(userinfo_session, 1);

        int IsClick = channel.getIsClick();
        int IsComment = channel.getIsComment();
        boolean IsTopStatus = false;//是否置顶
        if (channel.getIsTop() == 1) {
            IsTopStatus = true;
        }
        int IsWeight = channel.getIsWeight();

        String parentChannelPath = "培训管理";

        //整理查询SQL
        String TableName = channel.getTableName();
        String ListSql = "select id,GlobalID,Title,PublishDate,source_type,Status,User from " + TableName;
        String CountSql = "select count(*) from " + TableName;
        //判断查询条件
        if (!StringUtils.isEmpty(Status)) {
            if ("2".equals(Status)) {
                ListSql += " where  Active= 0 and Status = 0";
                CountSql += " where  Active= 0 and Status = 0";
            } else {
                ListSql += " where  Active= 1 and  Status =" + Status;
                CountSql += " where  Active= 1 and  Status =" + Status;
            }
        } else {
            ListSql += " where  Active= 1";
            CountSql += " where  Active= 1";
            Status = "-1";
        }


        if (!StringUtils.isEmpty(S_Title)) {
            ListSql += " and  Title like'%" + S_Title + "%'";
            CountSql += " and  Title like'%" + S_Title + "%'";
        }
        if (!StringUtils.isEmpty(S_startDate)) {
            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
            Date d = sf.parse(S_startDate);
            ListSql += " and  PublishDate >=" + d.getTime() / 1000;
            CountSql += " and  PublishDate >=" + d.getTime() / 1000;
        }
        if (!StringUtils.isEmpty(S_endDate)) {
            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
            Date d = sf.parse(S_endDate);
            long endTime = d.getTime() / 1000 + 86400;
            ListSql += " and  PublishDate <=" + endTime;
            CountSql += " and  PublishDate <=" + endTime;
        }
        if (!StringUtils.isEmpty(S_User)) {
            int S_UserID = 0;
            String sql2 = "select id from userinfo where Name='" + S_User + "'";
            TableUtil tu2 = new TableUtil("user");
            ResultSet Rs2 = tu2.executeQuery(sql2);
            if (Rs2.next()) {
                S_UserID = Rs2.getInt("id");
                ListSql += " and  User =" + S_UserID;
                CountSql += " and  User =" + S_endDate;
            } else {
                S_UserID = 0;
            }
        }
        if (!StringUtils.isEmpty(source_type)) {
            ListSql += " and  source_type =" + source_type;
            CountSql += " and  source_type =" + source_type;
        }


        //设置排序条件
        ListSql += " order by PublishDate desc";
        TableUtil tu = channel.getTableUtil();
        ResultSet Rs = tu.List(ListSql, CountSql, currPage, rowsPerPage);
        int TotalPageNumber = tu.pagecontrol.getMaxPages();
        int TotalNumber = tu.pagecontrol.getRowsCount();
        int j = 0;
        int m = 0;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        while (Rs.next()) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("ItemId", Rs.getInt("id"));
            map.put("GlobalID", Rs.getInt("GlobalID"));
            map.put("Title", convertNull(Rs.getString("Title")));
            long PublishDate = Long.parseLong(convertNull(Rs.getString("PublishDate")));
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            String PublishDateStr = dateFormat.format(PublishDate * 1000);
            map.put("PublishDate", PublishDateStr);
            Integer type = Rs.getInt("source_type");
            String typeDesc = "文件";
            if (type == 2) {
                typeDesc = "视频";
            }
            map.put("typeDesc", typeDesc);
            map.put("source_type", type);

            Integer status = Rs.getInt("Status");
            String StatusDesc = "";
            if (status == 0)
                StatusDesc = "<span class='tx-orange'>草稿</span>";
            else if (status == 1)
                StatusDesc = "<span class='tx-success'>已发</span>";
            else
                StatusDesc = "<span class='tx-danger'>已删除</span>";
            map.put("StatusDesc", StatusDesc);
            map.put("Status", status);

            int user = Rs.getInt("User");
            String UserName = CmsCache.getUser(user).getName();
            map.put("UserName", UserName);
            map.put("j", j++);
            map.put("m", m++);
            list.add(map);
        }
        tu.closeRs(Rs);
        modelMap.put("list", list);
        modelMap.addAttribute("TotalNumber", TotalNumber);
        modelMap.addAttribute("TotalPageNumber", TotalPageNumber);
        modelMap.addAttribute("listType", listType);
        modelMap.addAttribute("rowsPerPage", rowsPerPage);
        modelMap.addAttribute("currPage", currPage);
        modelMap.addAttribute("pageName", pageName);
        modelMap.addAttribute("stat", Status);
        modelMap.addAttribute("rows", rows);
        modelMap.addAttribute("id", channel.getId());
        modelMap.addAttribute("cols", cols);
        modelMap.addAttribute("ChannelID", ChannelID);
        modelMap.addAttribute("ChannelName", ChannelName);
        modelMap.addAttribute("channel", channel);
        modelMap.addAttribute("canApprove", canApprove);
        modelMap.addAttribute("createCategory", createCategory);
        modelMap.addAttribute("canDelete", canDelete);
        modelMap.addAttribute("IsWeight", IsWeight);
        modelMap.addAttribute("IsTopStatus", IsTopStatus);
        modelMap.addAttribute("hasRight", hasRight);
        modelMap.addAttribute("IsComment", IsComment);
        modelMap.addAttribute("IsClick", IsClick);
        modelMap.addAttribute("parentChannelPath", parentChannelPath);
        modelMap.addAttribute("S_Title", S_Title);
        modelMap.addAttribute("S_startDate", S_startDate);
        modelMap.addAttribute("S_endDate", S_endDate);
        modelMap.addAttribute("S_User", S_User);
        modelMap.addAttribute("source_type", source_type);


        modelAndView.addAllObjects(modelMap);


        return modelAndView;
    }


}
