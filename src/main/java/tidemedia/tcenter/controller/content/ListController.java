package tidemedia.tcenter.controller.content;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.*;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.entity.channel.ChannelListHeader;
import tidemedia.tcenter.entity.channel.ChannelListSearch;
import tidemedia.tcenter.service.channel.ChannelListFastSearchService;
import tidemedia.tcenter.service.channel.ChannelListHeaderService;
import tidemedia.tcenter.service.channel.ChannelListMenuService;
import tidemedia.tcenter.service.channel.ChannelListSearchService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.util.*;

import static tidemedia.cms.util.Util2.convertNull;

@RestController
@Api(value = "默认列表页", description = "默认列表页")
public class ListController {

    @Autowired
    private ChannelListHeaderService channelListHeaderService;

    @Autowired
    private ChannelListMenuService channelListMenuService;

    @Autowired
    private ChannelListFastSearchService channelListFastSearchService;

    @Autowired
    private ChannelListSearchService channelListSearchService;

    private static final Logger logger = LoggerFactory.getLogger(ListController.class);

    @GetMapping(value = "/content/content")
    @ApiOperation(value = "默认列表页", notes = "默认列表页")
    public ModelAndView listPage(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {

        ModelAndView modelAndView = new ModelAndView();

        String page = getList_(request, response, modelMap, null);

        modelAndView.setViewName(page);

        return modelAndView;
    }


    //测试列表页 table插件用
    @GetMapping(value = "/content/content2")
    @ApiOperation(value = "默认列表页", notes = "默认列表页")
    public ModelAndView listPage2(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {

        System.out.println("content2");
        ModelAndView modelAndView = new ModelAndView();

        getList2019(request, response, modelMap);

        modelAndView.setViewName("content/content2");
        System.out.println("content/content2");
        return modelAndView;
    }

    protected final String getList2019(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
        // 默认字段
        UserInfo userinfo_session = new UserInfo();
        userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
        //
        String uri = request.getRequestURI();
        long begin_time = System.currentTimeMillis();
        int id = CommonUtil.getIntParameter(request, "id");
        int currPage = CommonUtil.getIntParameter(request, "currPage");
        int rowsPerPage = CommonUtil.getIntParameter(request, "rowsPerPage");
        int sortable = CommonUtil.getIntParameter(request, "sortable");
        int rows = CommonUtil.getIntParameter(request, "rows");
        int cols = CommonUtil.getIntParameter(request, "cols");
        if (rows == 0)
            rows = Util.parseInt(Util.getCookieValue("rows_new", request.getCookies()));
        if (cols == 0)
            cols = Util.parseInt(Util.getCookieValue("cols_new", request.getCookies()));
        if (rows == 0)
            rows = 10;
        if (cols == 0)
            cols = 5;
        if (currPage < 1)
            currPage = 1;

        if (rowsPerPage == 0)
            rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new", request.getCookies()));

        if (rowsPerPage <= 0)
            rowsPerPage = 20;

        Channel channel = CmsCache.getChannel(id);
        //List<ChannelListHeader> list_ = channelListHeaderService.list(id);
        String channel_header = channelListHeaderService.list_json(id);
        modelMap.put("channel_header", channel_header);

        String channel_menu = "";
        channel_menu = channelListMenuService.list_json(channel, userinfo_session);
        modelMap.put("channel_menu", channel_menu);

        String channel_fastSearch = channelListFastSearchService.list_json(id);
        modelMap.put("channel_fast_search", channel_fastSearch);

        String channel_Search = channelListSearchService.list_json(id);
        modelMap.put("channel_search", channel_Search);

        //
        //当前登录用户绑定了租户,此频道下面是租户频道(聚融，大屏)
        String a = channel.getApplication();
        if (userinfo_session.getCompany() != 0 && (a.startsWith("pgc_") || a.startsWith("screen") || a.startsWith("task") || a.startsWith("shenpian") || a.startsWith("shengao"))) {
            //获取符合条件的租户频道,替换ch对象，后面逻辑不变
            id = new Tree().getChannelID(id, userinfo_session);
            channel = CmsCache.getChannel(id);
        }
        boolean IsTopStatus = false;//是否置顶
        if (channel.getIsTop() == 1) {
            IsTopStatus = true;
        }
        if (channel == null || channel.getId() == 0) {
            response.sendRedirect("../content/content_nochannel.jsp");
            return null;
        }
        //
        Channel parentchannel = null;
        int ChannelID = channel.getId();
        String ChannelName = channel.getName();
        int IsWeight = channel.getIsWeight();
        int IsComment = channel.getIsComment();
        int IsClick = channel.getIsClick();
        String gids = "";
        //
        if (channel.getListProgram().length() > 0 && uri.endsWith("/content/content2018.jsp")) {
            response.sendRedirect(channel.getListProgram() + "?id=" + id);
            return null;
        }
        //
        int ApproveScheme = channel.getApproveScheme();

        if(ApproveScheme!=0){
            response.sendRedirect("../approve/content_approve.jsp?id="+id);
            return null;
        }

        //
        String S_Title = CommonUtil.getParameter(request, "Title");
        String S_startDate = CommonUtil.getParameter(request, "startDate");
        String S_endDate = CommonUtil.getParameter(request, "endDate");
        String S_User = CommonUtil.getParameter(request, "User");
        int S_IsIncludeSubChannel = CommonUtil.getIntParameter(request, "IsIncludeSubChannel");
        int S_Status = CommonUtil.getIntParameter(request, "Status");
        int S_IsPhotoNews = CommonUtil.getIntParameter(request, "IsPhotoNews");
        int S_OpenSearch = CommonUtil.getIntParameter(request, "OpenSearch");
        int IsDelete = CommonUtil.getIntParameter(request, "IsDelete");
        int Status1 = CommonUtil.getIntParameter(request, "Status1");
        int listType = CommonUtil.getIntParameter(request, "listtype");
        /*int listType = 0;
        listType = CommonUtil.getIntParameter(request,"listtype");
        if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list_new",request.getCookies()));
        if(listType==0) listType = 1;*/
        if (listType == 0) {
            if (channel.getViewType() == 0) {
                listType = 1;
            } else if (channel.getViewType() == 2) {
                listType = 2;
            }
        }
        if (channel.getParent() == -1) {//说明是站点
            S_IsIncludeSubChannel = 0;
        }

        //
        if (channel.getType() == 2) {
            response.sendRedirect("../page/content_page.jsp?id=" + id);
            return null;
        }
        // 如果是“新建应用”；
        if (channel.getType() == 3) {
            response.sendRedirect("app.jsp?id=" + id);
            return null;
        }

        // 返回内容组装
        String querystring = "";

        querystring = "&Title=" + URLEncoder.encode(S_Title, "UTF-8") + "&startDate=" + S_startDate + "&endDate=" + S_endDate + "&User=" + S_User + "&Status=" + S_Status + "&IsPhotoNews=" + S_IsPhotoNews + "&OpenSearch=" + S_OpenSearch + "&IsDelete=" + IsDelete + "&Status1=" + Status1;
        //
        String pageName = request.getServletPath();
        int pindex = pageName.lastIndexOf("/");
        if (pindex != -1)
            pageName = pageName.substring(pindex + 1);
        //
        if (!channel.hasRight(userinfo_session, 1)) {
            response.sendRedirect("../noperm.jsp");
            return null;
        }
        boolean canApprove = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanApprove);
        boolean canDelete = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanDelete);
        boolean createCategory = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CreateCategory);
        //获取频道路径
        String parentChannelPath = channel.getParentChannelPath().replaceAll(">", " / ");
        modelMap.addAttribute("listType", listType);
        modelMap.addAttribute("rows", rows);
        modelMap.addAttribute("cols", cols);
        logger.info("cols 列为: " + cols);
        modelMap.addAttribute("ChannelID", ChannelID);
        modelMap.addAttribute("ChannelName", ChannelName);
        modelMap.addAttribute("pageName", pageName);
        modelMap.addAttribute("id", id);
        modelMap.addAttribute("parentChannelPath", parentChannelPath);
        modelMap.addAttribute("IsClick", IsClick);
        modelMap.addAttribute("Status1", Status1);
        modelMap.addAttribute("IsDelete", IsDelete);
        modelMap.addAttribute("S_OpenSearch", S_OpenSearch);
        modelMap.addAttribute("sortable", sortable);
        modelMap.addAttribute("querystring", querystring);
        modelMap.addAttribute("currPage", currPage);
        modelMap.addAttribute("rowsPerPage", rowsPerPage);
        modelMap.addAttribute("canApprove", canApprove);
        modelMap.addAttribute("createCategory", createCategory);
        modelMap.addAttribute("channel", channel);
        modelMap.addAttribute("IsWeight", IsWeight);
        modelMap.addAttribute("IsTopStatus", IsTopStatus);
        modelMap.addAttribute("canDelete", canDelete);
        modelMap.addAttribute("S_Title", S_Title);
        modelMap.addAttribute("S_Status", S_Status);
        boolean hasRight = channel.hasRight(userinfo_session, 1);
        modelMap.addAttribute("hasRight", hasRight);
        modelMap.addAttribute("IsComment", IsComment);
        modelMap.addAttribute("S_startDate", S_startDate);
        modelMap.addAttribute("S_endDate", S_endDate);
        modelMap.addAttribute("S_User", S_User);
        return "";
    }

    @RequestMapping(value = "/content/list_info/json")
    public JSONObject list_info(HttpServletRequest request, HttpServletResponse response) throws Exception {

        JSONObject obj = new JSONObject();
        // 定制化字段列表
        String listByByCustomSql = "";

        // 默认字段
        UserInfo userinfo_session = new UserInfo();
        userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
        //
        String uri = request.getRequestURI();
        long begin_time = System.currentTimeMillis();
        int id = CommonUtil.getIntParameter(request, "ChannelID");
        int currPage = CommonUtil.getIntParameter(request, "currPage");
        int rowsPerPage = CommonUtil.getIntParameter(request, "rowsPerPage");
        int sortable = CommonUtil.getIntParameter(request, "sortable");
        int rows = CommonUtil.getIntParameter(request, "rows");
        int cols = CommonUtil.getIntParameter(request, "cols");
        String globalids = "";
        //
        if (currPage < 1)
            currPage = 1;
        if (rowsPerPage == 0)
            rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new", request.getCookies()));
        if (rowsPerPage <= 0)
            rowsPerPage = 20;
        if (rows == 0)
            rows = Util.parseInt(Util.getCookieValue("rows_new", request.getCookies()));
        if (cols == 0)
            cols = Util.parseInt(Util.getCookieValue("cols_new", request.getCookies()));
        if (rows == 0)
            rows = 10;
        if (cols == 0)
            cols = 5;
        Channel channel = CmsCache.getChannel(id);
        //
        //当前登录用户绑定了租户,此频道下面是租户频道(聚融，大屏)
        String a = channel.getApplication();
        if (userinfo_session.getCompany() != 0 && (a.startsWith("pgc_") || a.startsWith("screen") || a.startsWith("task") || a.startsWith("shenpian") || a.startsWith("shengao"))) {
            //获取符合条件的租户频道,替换ch对象，后面逻辑不变
            id = new Tree().getChannelID(id, userinfo_session);
            channel = CmsCache.getChannel(id);
        }
        boolean IsTopStatus = false;//是否置顶
        int top_status = channelListMenuService.getByCode(id, "changeTop1").getStatus();
        if (top_status == 1) {
            IsTopStatus = true;
        }
        if (channel == null || channel.getId() == 0) {
            response.sendRedirect("../content/content_nochannel.jsp");
            return null;
        }
        //
        Channel parentchannel = null;
        int ChannelID = channel.getId();
        String ChannelName = channel.getName();
        int IsWeight = channel.getIsWeight();
        int IsComment = channel.getIsComment();
        int IsClick = channel.getIsClick();
        String gids = "";
        //
        if (channel.getListProgram().length() > 0 && uri.endsWith("/content/content2018.jsp")) {
            response.sendRedirect(channel.getListProgram() + "?id=" + id);
            return null;
        }
        //
        int ApproveScheme = channel.getApproveScheme();

        //
        int S_IsIncludeSubChannel = CommonUtil.getIntParameter(request, "IsIncludeSubChannel");
        int S_OpenSearch = CommonUtil.getIntParameter(request, "OpenSearch");

        List<ChannelListSearch> list1 = channelListSearchService.list(ChannelID);

        int fastSearchId = CommonUtil.getIntParameter(request, "fastSearchId");//快捷检索Id
        int listType = Util.parseInt(Util.getCookieValue(id + "_list_new", request.getCookies()));
        if (listType == 0) {
            if (channel.getViewType() == 0) {
                listType = 1;
            } else if (channel.getViewType() == 2) {
                listType = 2;
            }
        }
        //
        boolean listAll = false;
        //
        if (channel.getParent() == -1) {//说明是站点
            S_IsIncludeSubChannel = 0;
        }
        //
        if (channel.isTableChannel() && channel.getType2() == 8) listAll = true;
        if (channel.getIsListAll() == 1) listAll = true;
        if (S_IsIncludeSubChannel == 1) listAll = true;
        //
        if (channel.getType() == 2) {
            response.sendRedirect("../page/content_page.jsp?id=" + id);
            return null;
        }
        // 如果是“新建应用”；
        if (channel.getType() == 3) {
            response.sendRedirect("app.jsp?id=" + id);
            return null;
        }

        String pageName = request.getServletPath();
        int pindex = pageName.lastIndexOf("/");
        if (pindex != -1)
            pageName = pageName.substring(pindex + 1);
        //
        if (!channel.hasRight(userinfo_session, 1)) {
            response.sendRedirect("../noperm.jsp");
            return null;
        }

        boolean canApprove = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanApprove);
        boolean canDelete = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanDelete);
        boolean canAdd = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanAdd);
        boolean createCategory = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CreateCategory);
        int canExcel = channel.getIsExportExcel();//是否导出Excel
        int canWord = channel.getIsImportWord();//是否导出world
        String SiteAddress = channel.getSite().getUrl();
        //获取频道路径
        String parentChannelPath = channel.getParentChannelPath().replaceAll(">", " / ");


        long weightTime = 0;
        int IsActive = 1;
        if (fastSearchId == -1) IsActive = 0;

        if (channel.getIsWeight() == 1) {
            //权重排序
            Calendar nowDate = new GregorianCalendar();
            nowDate.set(Calendar.HOUR_OF_DAY, 0);
            nowDate.set(Calendar.MINUTE, 0);
            nowDate.set(Calendar.SECOND, 0);
            nowDate.set(Calendar.MILLISECOND, 0);
            weightTime = nowDate.getTimeInMillis() / 1000;
        }
        String Table = channel.getTableName();
        String ListSql = "select id,Title,Photo,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews,Summary,DocFrom";
        // 定制字段组装
        listByByCustomSql = ChannelListHeaderService.getFieldName(id);
        ListSql += listByByCustomSql;
        String FieldStr = ",DocTop,DocTopTime";
        if (IsTopStatus) {
            ListSql += FieldStr;
        }
        //
        if (listType == 2) {
            ListSql += ",Content,Keyword";
        }
        if (channel.getIsWeight() == 1)
            ListSql += ",case when CreateDate>" + weightTime + " then (Weight+" + weightTime + ") else CreateDate end  as newtime";
        ListSql += " from " + Table;
        String CountSql = "select count(*) from " + Table;
        if (!listAll) {
            if (channel.getType() == Channel.Category_Type) {
                ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
                CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
            } else if (channel.getType() == Channel.MirrorChannel_Type) {
                Channel linkChannel = channel.getLinkChannel();
                if (linkChannel.getType() == Channel.Category_Type) {
                    ListSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                    CountSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                } else {
                    ListSql += " where Category=0 and Active=" + IsActive;
                    CountSql += " where Category=0 and Active=" + IsActive;
                }
            } else {
                if (fastSearchId == -1) {
                    ListSql += " where " + (!listAll ? Table + ".Category=0 " : "");
                    CountSql += " where " + (!listAll ? Table + ".Category=0 " : "");
                } else {
                    ListSql += " where " + (!listAll ? Table + ".Category=0 and " : "") + " Active=" + IsActive;
                    CountSql += " where " + (!listAll ? Table + ".Category=0 and " : "") + " Active=" + IsActive;
                }
            }
        } else {
            ListSql += " where ChannelCode like '" + channel.getChannelCode() + "%' and Active=" + IsActive;
            CountSql += " where ChannelCode like '" + channel.getChannelCode() + "%' and Active=" + IsActive;
        }
        String WhereSql = "";
        if (fastSearchId != 0) {//快捷检索
            String wheresql = "";
            if (fastSearchId == -1) {
                wheresql = " Active=0";
            } else {
                wheresql = channelListFastSearchService.getById(fastSearchId).getWheresql();
            }
            WhereSql += " and " + wheresql;
        }

        String S_User = "";

        String querystring = "";
        //搜索项目逻辑
        for (int i = 0; i < list1.size(); i++) {
            ChannelListSearch channelListSearch = list1.get(i);
            String fieldName = channelListSearch.getFieldName();
            if (fieldName.equals("Author")) {//根据作者检索
                S_User = CommonUtil.getParameter(request, "User");
                if (!S_User.equals("")) {
                    String sql2 = "select * from userinfo where Name='" + S_User + "'";
                    TableUtil tu2 = new TableUtil("user");
                    ResultSet Rs2 = tu2.executeQuery(sql2);
                    if (Rs2.next()) {
                        int S_UserID = Rs2.getInt("id");
                        WhereSql += " and User=" + S_UserID;
                    }else{
                        WhereSql += " and User=-1";
                    }
                    tu2.closeRs(Rs2);
                }
                querystring+="&User="+S_User;
            } else if (fieldName.equals("CreateDate")) {//根据创建时间检索
                String S_startDate = CommonUtil.getParameter(request, fieldName + "_start");
                String S_endDate = CommonUtil.getParameter(request, fieldName + "_end");
                if (!S_startDate.equals("")) {
                    long startTime = Util.getFromTime(S_startDate, "");
                    WhereSql += " and " + fieldName + ">=" + startTime;
                }
                if (!S_endDate.equals("")) {
                    long endTime = Util.getFromTime(S_endDate, "");
                    WhereSql += " and " + fieldName + "<" + (endTime + 86400);
                }
                querystring+="&"+fieldName + "_start="+S_startDate+"&"+fieldName + "end="+S_endDate;
            } else if (fieldName.equals("Status")) {//根据状态检索
                int Status = CommonUtil.getIntParameter(request, "Status");
                if (Status != 0) {
                    WhereSql += " and Status = " + (Status-1);
                }
                querystring+="&Status="+Status;
            } else {
                Field field = new Field(fieldName, ChannelID);
                if (field.getDataType() == 0) {//字符
                    if (fieldName.contains("Date")) {
                        String S_startDate = CommonUtil.getParameter(request, fieldName + "_start");
                        String S_endDate = CommonUtil.getParameter(request, fieldName + "_end");
                        if (!S_startDate.equals("")) {
                            long startTime = Util.getFromTime(S_startDate, "");
                            WhereSql += " and " + fieldName + ">=" + startTime;
                        }
                        if (!S_endDate.equals("")) {
                            long endTime = Util.getFromTime(S_endDate, "");
                            WhereSql += " and " + fieldName + "<" + (endTime + 86400);
                        }
                        querystring+="&"+fieldName + "_start="+S_startDate+"&"+fieldName + "end="+S_endDate;
                    } else {
                        String parameter = CommonUtil.getParameter(request, fieldName);
                        if (fieldName.equals("Title")&&parameter.length()>0) {//根据标题检索
                            String tempTitle = parameter.replaceAll("%", "\\\\%");
                            WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
                        } else {
                            if (parameter.length() > 0) {
                                WhereSql += " and " + fieldName + " like '%" + parameter + "%'";
                            }
                        }
                        querystring+="&"+fieldName+"="+URLEncoder.encode(parameter, "UTF-8");
                    }
                } else {//数字
                    int intParameter = CommonUtil.getIntParameter(request, fieldName);
                    if (intParameter != 0) {
                        WhereSql += " and " + fieldName + " = " + intParameter;
                    }
                    querystring+="&"+fieldName+"="+intParameter;
                }
            }
        }
        querystring+="&fastSearchId="+fastSearchId;

        ListSql += WhereSql;
        CountSql += WhereSql;
        if (channel.getIsWeight() == 1) {
            ListSql += " order by newtime desc,id desc";
        } else {
            if (IsTopStatus) {
                ListSql += " order by  DocTop desc ,DocTopTime  desc  ,OrderNumber desc ";
            } else {
                ListSql += " order by OrderNumber desc ";
            }
        }
        int listnum = rowsPerPage;
        if (listType == 2) listnum = cols * rows;
        System.out.println("listsql是" + ListSql);
        TableUtil tu = channel.getTableUtil();
        ResultSet Rs = tu.List(ListSql, CountSql, currPage, listnum);
        int TotalPageNumber = tu.pagecontrol.getMaxPages();
        int TotalNumber = tu.pagecontrol.getRowsCount();


        boolean hasRight = channel.hasRight(userinfo_session, 1);

        //
        int j = 0;
        int m = 0;
        int temp_gid = 0;
        String doc_typeString = "";
        //
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        //
        while (Rs.next()) {
            int id_ = Rs.getInt("id");
            int Status = Rs.getInt("Status");
            int category = Rs.getInt("Category");
            int user = Rs.getInt("User");
            int active = Rs.getInt("Active");
            String docFrom = Rs.getString("DocFrom");
            String Summary = Rs.getString("Summary");
            String Title = convertNull(Rs.getString("Title"));
            int IsPhotoNews = Rs.getInt("IsPhotoNews");

            int TopStatus = 0;
            if (IsTopStatus) {
                TopStatus = Rs.getInt("DocTop");
            }
            if (listAll) {
                if (category > 0)
                    Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
            }
            int Weight = Rs.getInt("Weight");
            int GlobalID = Rs.getInt("GlobalID");
            if (temp_gid != 0) {
                globalids += ",";
            }
            temp_gid++;
            globalids += GlobalID + "";
            String ModifiedDate = convertNull(Rs.getString("ModifiedDate"));
            ModifiedDate = Util.FormatDate("yyyy-MM-dd HH:mm", ModifiedDate);
            String UserName = CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
            String StatusDesc = "";
            if (fastSearchId != -1) {
                if (Status == 0)
                    StatusDesc = "<span class='tx-orange'>草稿</span>";
                else if (Status == 1)
                    StatusDesc = "<span class='tx-success'>已发</span>";
            } else {
                StatusDesc = "<span class='tx-danger'>已删除</span>";
            }
            if (gids.length() > 0) {
                gids += "," + GlobalID + "";
            } else {
                gids = GlobalID + "";
            }
            int OrderNumber = TotalNumber - j - ((currPage - 1) * rowsPerPage);
            //j++;

            String photoAddr = "";
            if (listType == 2) {
                String Photo = convertNull(Rs.getString("Photo"));

                if (Photo.startsWith("http://"))
                    photoAddr = Photo;
                else
                    photoAddr = SiteAddress + Photo;

                if (m == cols) {
                    m = 0;
                }
            }

            HashMap<String, Object> map = new HashMap<>();

            //新增字段
            String[] strings = Util.StringToArray(listByByCustomSql, ",");
            for (int i = 0; i < strings.length; i++) {
                String fieldName = strings[i];
                Field field = new Field(fieldName,id);
                if(field.getDataType()==0){
                    String fieldvalue = convertNull(Rs.getString(fieldName));
                    map.put(fieldName,fieldvalue);
                }else {
                    int fieldvalue = Rs.getInt(fieldName);
                    map.put(fieldName,fieldvalue);
                }
            }

            map.put("photoAddr", photoAddr);
            map.put("id_", id_);
            map.put("Status", Status);
            map.put("user", user);
            map.put("active", active);
            map.put("Title", Title);
            map.put("IsPhotoNews", IsPhotoNews);
            map.put("TopStatus", TopStatus);
            map.put("Weight", Weight);
            map.put("GlobalID", GlobalID);
            map.put("globalids", globalids);
            map.put("temp_gid", temp_gid);
            map.put("ModifiedDate", ModifiedDate);
            map.put("StatusDesc", StatusDesc);
            map.put("UserName", UserName);
            map.put("OrderNumber", OrderNumber);
            map.put("gids", gids);
            map.put("UserName", UserName);
            map.put("DocFrom", docFrom);
            map.put("Summary", Summary);
            map.put("j", ++j);
            map.put("m", ++m);
            list.add(map);
        }
        tu.closeRs(Rs);

        obj.put("list", list);
        obj.put("TotalPageNumber", TotalPageNumber);
        obj.put("TotalNumber", TotalNumber);
        obj.put("currPage", currPage);
        obj.put("rowsPerPage", rowsPerPage);
        obj.put("querystring", querystring);
        return obj;
    }


    /**
     * 定制 ftl 页面字段新增解析
     *
     * @param additionaCustomList
     * @return
     * @throws Exception
     */
    private static String getListByByCustom(List<String> additionaCustomList) throws Exception {

        String customs = "";
        if (additionaCustomList != null && additionaCustomList.size() > 0) {
            for (String custom : additionaCustomList) {
                customs += "," + custom;
            }
        }
        return customs;
    }

    /**
     * 定制化页面的内容注入
     *
     * @param request
     * @param response
     * @param modelMap
     * @param additionaCustomList 定制字段
     * @return
     * @throws Exception
     */
    protected static final String getList_(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, List<String> additionaCustomList) throws Exception {

        // 定制化字段列表
        String listByByCustomSql = "";
        if (additionaCustomList != null) {
            listByByCustomSql = getListByByCustom(additionaCustomList);
        }

        // 默认字段
        UserInfo userinfo_session = new UserInfo();
        userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
        //
        String uri = request.getRequestURI();
        long begin_time = System.currentTimeMillis();
        int id = CommonUtil.getIntParameter(request, "id");
        int currPage = CommonUtil.getIntParameter(request, "currPage");
        int rowsPerPage = CommonUtil.getIntParameter(request, "rowsPerPage");
        int sortable = CommonUtil.getIntParameter(request, "sortable");
        int rows = CommonUtil.getIntParameter(request, "rows");
        int cols = CommonUtil.getIntParameter(request, "cols");
        String globalids = "";
        //
        if (currPage < 1)
            currPage = 1;
        if (rowsPerPage == 0)
            rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new", request.getCookies()));
        if (rowsPerPage <= 0)
            rowsPerPage = 20;
        if (rows == 0)
            rows = Util.parseInt(Util.getCookieValue("rows_new", request.getCookies()));
        if (cols == 0)
            cols = Util.parseInt(Util.getCookieValue("cols_new", request.getCookies()));
        if (rows == 0)
            rows = 10;
        if (cols == 0)
            cols = 5;
        Channel channel = CmsCache.getChannel(id);
        //
        //当前登录用户绑定了租户,此频道下面是租户频道(聚融，大屏)
        String a = channel.getApplication();
        if (userinfo_session.getCompany() != 0 && (a.startsWith("pgc_") || a.startsWith("screen") || a.startsWith("task") || a.startsWith("shenpian") || a.startsWith("shengao"))) {
            //获取符合条件的租户频道,替换ch对象，后面逻辑不变
            id = new Tree().getChannelID(id, userinfo_session);
            channel = CmsCache.getChannel(id);
        }
        boolean IsTopStatus = false;//是否置顶
        if (channel.getIsTop() == 1) {
            IsTopStatus = true;
        }
        if (channel == null || channel.getId() == 0) {
            response.sendRedirect("../content/content_nochannel.jsp");
            return null;
        }
        //
        Channel parentchannel = null;
        int ChannelID = channel.getId();
        String ChannelName = channel.getName();
        int IsWeight = channel.getIsWeight();
        int IsComment = channel.getIsComment();
        int IsClick = channel.getIsClick();
        String gids = "";
        //
        if (channel.getListProgram().length() > 0 && uri.endsWith("/content/content2018.jsp")) {
            response.sendRedirect(channel.getListProgram() + "?id=" + id);
            return null;
        }
        //
        int ApproveScheme = channel.getApproveScheme();

        if (ApproveScheme != 0) {
//            response.sendRedirect("../approve/content_approve.jsp?id="+id);
            response.sendRedirect("../default/approvePreview?id=" + id);
            return null;
        }
//        else {
//
//            //
//            response.sendRedirect("../default/content2018?id=" + id);
//        }

        //
        String S_Title = CommonUtil.getParameter(request, "Title");
        String S_startDate = CommonUtil.getParameter(request, "startDate");
        String S_endDate = CommonUtil.getParameter(request, "endDate");
        String S_User = CommonUtil.getParameter(request, "User");
        int S_IsIncludeSubChannel = CommonUtil.getIntParameter(request, "IsIncludeSubChannel");
        int S_Status = CommonUtil.getIntParameter(request, "Status");
        int S_IsPhotoNews = CommonUtil.getIntParameter(request, "IsPhotoNews");
        int S_OpenSearch = CommonUtil.getIntParameter(request, "OpenSearch");
        int IsDelete = CommonUtil.getIntParameter(request, "IsDelete");
        int Status1 = CommonUtil.getIntParameter(request, "Status1");
        int listType = 0;
        listType = CommonUtil.getIntParameter(request, "listtype");
        if (listType == 0) listType = Util.parseInt(Util.getCookieValue(id + "_list_new", request.getCookies()));
        if (listType == 0) listType = 1;
        //
        boolean listAll = false;
        //
        if (channel.getParent() == -1) {//说明是站点
            S_IsIncludeSubChannel = 0;
        }
        //
        if (channel.isTableChannel() && channel.getType2() == 8) listAll = true;
        if (channel.getIsListAll() == 1) listAll = true;
        if (S_IsIncludeSubChannel == 1) listAll = true;
        //
        if (channel.getType() == 2) {
            response.sendRedirect("../page/content_page.jsp?id=" + id);
            return null;
        }
        // 如果是“新建应用”；
        if (channel.getType() == 3) {
            response.sendRedirect("app.jsp?id=" + id);
            return null;
        }

        // 返回内容组装
        String querystring = "";
        querystring = "&Title=" + URLEncoder.encode(S_Title, "UTF-8") + "&startDate=" + S_startDate + "&endDate=" + S_endDate + "&User=" + S_User + "&Status=" + S_Status + "&IsPhotoNews=" + S_IsPhotoNews + "&OpenSearch=" + S_OpenSearch + "&IsDelete=" + IsDelete + "&Status1=" + Status1;
        //
        String pageName = request.getServletPath();
        int pindex = pageName.lastIndexOf("/");
        if (pindex != -1)
            pageName = pageName.substring(pindex + 1);
        //
        if (!channel.hasRight(userinfo_session, 1)) {
            response.sendRedirect("../noperm.jsp");
            return null;
        }
        boolean canApprove = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanApprove);
        boolean canDelete = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanDelete);
        boolean canAdd = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanAdd);
        boolean createCategory = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CreateCategory);
        int canExcel = channel.getIsExportExcel();//是否导出Excel
        int canWord = channel.getIsImportWord();//是否导出world
        String SiteAddress = channel.getSite().getUrl();
        //获取频道路径
        String parentChannelPath = channel.getParentChannelPath().replaceAll(">", " / ");
        modelMap.addAttribute("listType", listType);
        modelMap.addAttribute("rows", rows);
        modelMap.addAttribute("cols", cols);
        logger.info("cols 列为: " + cols);
        modelMap.addAttribute("ChannelID", ChannelID);
        modelMap.addAttribute("rowsPerPage", rowsPerPage);
        modelMap.addAttribute("currPage", currPage);
        modelMap.addAttribute("ChannelName", ChannelName);
        modelMap.addAttribute("pageName", pageName);
        modelMap.addAttribute("id", id);
        modelMap.addAttribute("parentChannelPath", parentChannelPath);
        modelMap.addAttribute("IsClick", IsClick);
        modelMap.addAttribute("Status1", Status1);
        modelMap.addAttribute("IsDelete", IsDelete);
        modelMap.addAttribute("S_OpenSearch", S_OpenSearch);
        modelMap.addAttribute("sortable", sortable);
        modelMap.addAttribute("querystring", querystring);
        int S_UserID = 0;
        long weightTime = 0;
        int IsActive = 1;
        if (IsDelete == 1) IsActive = 0;
        if (!S_User.equals("")) {
            String sql2 = "select * from userinfo where Name='" + S_User + "'";
            TableUtil tu2 = new TableUtil("user");
            ResultSet Rs2 = tu2.executeQuery(sql2);
            if (Rs2.next()) {
                S_UserID = Rs2.getInt("id");
            } else {
                S_UserID = 0;
            }
        }
        if (channel.getIsWeight() == 1) {
            //权重排序
            Calendar nowDate = new GregorianCalendar();
            nowDate.set(Calendar.HOUR_OF_DAY, 0);
            nowDate.set(Calendar.MINUTE, 0);
            nowDate.set(Calendar.SECOND, 0);
            nowDate.set(Calendar.MILLISECOND, 0);
            weightTime = nowDate.getTimeInMillis() / 1000;
        }
        String Table = channel.getTableName();
        String ListSql = "select id,Title,Photo,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews";
        // 定制字段组装
        ListSql += listByByCustomSql;
        //
        String FieldStr = ",DocTop,DocTopTime";
        if (IsTopStatus) {
            ListSql += FieldStr;
        }
        //
        if (listType == 2) {
            ListSql += ",Summary,Content,Keyword";
        }
        if (channel.getIsWeight() == 1)
            ListSql += ",case when CreateDate>" + weightTime + " then (Weight+" + weightTime + ") else CreateDate end  as newtime";
        ListSql += " from " + Table;
        String CountSql = "select count(*) from " + Table;
        if (!listAll) {
            if (channel.getType() == Channel.Category_Type) {
                ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
                CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
            } else if (channel.getType() == Channel.MirrorChannel_Type) {
                Channel linkChannel = channel.getLinkChannel();
                if (linkChannel.getType() == Channel.Category_Type) {
                    ListSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                    CountSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                } else {
                    ListSql += " where Category=0 and Active=" + IsActive;
                    CountSql += " where Category=0 and Active=" + IsActive;
                }
            } else {
                ListSql += " where " + (!listAll ? Table + ".Category=0 and " : "") + " Active=" + IsActive;
                CountSql += " where " + (!listAll ? Table + ".Category=0 and " : "") + " Active=" + IsActive;
            }
        } else {
            ListSql += " where ChannelCode like '" + channel.getChannelCode() + "%' and Active=" + IsActive;
            CountSql += " where ChannelCode like '" + channel.getChannelCode() + "%' and Active=" + IsActive;
        }
        String WhereSql = "";
        if (!S_Title.equals("")) {
            String tempTitle = S_Title.replaceAll("%", "\\\\%");
            WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
        }
        if (!S_startDate.equals("")) {
            long startTime = Util.getFromTime(S_startDate, "");
            WhereSql += " and CreateDate>=" + startTime;
        }
        if (!S_endDate.equals("")) {
            long endTime = Util.getFromTime(S_endDate, "");
            WhereSql += " and CreateDate<" + (endTime + 86400);
        }
        if (S_UserID > 0) {
            WhereSql += " and User=" + S_UserID;
        }
        if (S_IsPhotoNews == 1)
            WhereSql += " and IsPhotoNews=1";
        if (S_Status != 0)
            WhereSql += " and Status=" + (S_Status - 1);
        if (Status1 != 0) {
            if (Status1 == -1)
                WhereSql += " and Status=0";
            else
                WhereSql += " and Status=" + Status1;
        }
        ListSql += WhereSql;
        CountSql += WhereSql;
        if (channel.getIsWeight() == 1) {
            ListSql += " order by newtime desc,id desc";
        } else {
            if (IsTopStatus) {
                ListSql += " order by  DocTop desc ,DocTopTime  desc  ,OrderNumber desc ";
            } else {
                ListSql += " order by OrderNumber desc ";
            }
        }
        int listnum = rowsPerPage;
        if (listType == 2) listnum = cols * rows;

        TableUtil tu = channel.getTableUtil();
        ResultSet Rs = tu.List(ListSql, CountSql, currPage, listnum);
        int TotalPageNumber = tu.pagecontrol.getMaxPages();
        int TotalNumber = tu.pagecontrol.getRowsCount();

        modelMap.addAttribute("TotalNumber", TotalNumber);
        modelMap.addAttribute("TotalPageNumber", TotalPageNumber);
        modelMap.addAttribute("canApprove", canApprove);
        modelMap.addAttribute("createCategory", createCategory);
        modelMap.addAttribute("channel", channel);
        modelMap.addAttribute("IsWeight", IsWeight);
        modelMap.addAttribute("IsTopStatus", IsTopStatus);
        modelMap.addAttribute("canDelete", canDelete);
        modelMap.addAttribute("S_Title", S_Title);
        modelMap.addAttribute("S_Status", S_Status);
        boolean hasRight = channel.hasRight(userinfo_session, 1);
        modelMap.addAttribute("hasRight", hasRight);
        modelMap.addAttribute("IsComment", IsComment);
        modelMap.addAttribute("S_startDate", S_startDate);
        modelMap.addAttribute("S_endDate", S_endDate);
        modelMap.addAttribute("S_User", S_User);
        //
        int j = 0;
        int m = 0;
        int temp_gid = 0;
        String doc_typeString = "";
        //
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        //
        while (Rs.next()) {
            int id_ = Rs.getInt("id");
            int Status = Rs.getInt("Status");
            int category = Rs.getInt("Category");
            int user = Rs.getInt("User");
            int active = Rs.getInt("Active");
            String Title = convertNull(Rs.getString("Title"));
            int IsPhotoNews = Rs.getInt("IsPhotoNews");
            int TopStatus = 0;
            if (IsTopStatus) {
                TopStatus = Rs.getInt("DocTop");
            }
            if (listAll) {
                if (category > 0)
                    Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
            }
            int Weight = Rs.getInt("Weight");
            int GlobalID = Rs.getInt("GlobalID");
            if (temp_gid != 0) {
                globalids += ",";
            }
            temp_gid++;
            globalids += GlobalID + "";
            String ModifiedDate = convertNull(Rs.getString("ModifiedDate"));
            ModifiedDate = Util.FormatDate("yyyy-MM-dd HH:mm", ModifiedDate);
            String UserName = CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
            String StatusDesc = "";
            if (IsDelete != 1) {
                if (Status == 0)
                    StatusDesc = "<span class='tx-orange'>草稿</span>";
                else if (Status == 1)
                    StatusDesc = "<span class='tx-success'>已发</span>";
            } else {
                StatusDesc = "<span class='tx-danger'>已删除</span>";
            }
            if (gids.length() > 0) {
                gids += "," + GlobalID + "";
            } else {
                gids = GlobalID + "";
            }
            int OrderNumber = TotalNumber - j - ((currPage - 1) * rowsPerPage);
            j++;

            String photoAddr = "";
            if (listType == 2) {
                String Photo = convertNull(Rs.getString("Photo"));

                if (Photo.startsWith("http://"))
                    photoAddr = Photo;
                else
                    photoAddr = SiteAddress + Photo;

                if (m == cols) {
                    m = 0;
                }
            }

            HashMap<String, Object> map = new HashMap<>();
            // 列表页定制字段追加
            if (additionaCustomList != null && additionaCustomList.size() > 0) {
                String[] customs = listByByCustomSql.substring(1).split(",");
                for (String custom : customs) {
                    map.put(custom, Util.convertNull(Rs.getObject(custom) + ""));
                }
            }
            map.put("photoAddr", photoAddr);
            map.put("id_", id_);
            map.put("Status", Status);
            map.put("user", user);
            map.put("active", active);
            map.put("Title", Title);
            map.put("IsPhotoNews", IsPhotoNews);
            map.put("TopStatus", TopStatus);
            map.put("Weight", Weight);
            map.put("GlobalID", GlobalID);
            map.put("globalids", globalids);
            map.put("temp_gid", temp_gid);
            map.put("ModifiedDate", ModifiedDate);
            map.put("StatusDesc", StatusDesc);
            map.put("UserName", UserName);
            map.put("OrderNumber", OrderNumber);
            map.put("gids", gids);
            map.put("UserName", UserName);
            map.put("j", j++);
            map.put("m", m++);
            list.add(map);
        }
        tu.closeRs(Rs);
        modelMap.put("m_", m);
        modelMap.put("list", list);

        return "content2018";
    }
}
