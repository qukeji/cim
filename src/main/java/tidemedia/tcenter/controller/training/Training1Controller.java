package tidemedia.tcenter.controller.training;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.solr.common.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelPrivilegeItem;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Tree;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.service.train.TrainService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 培训管理列表页
 * from:content2018
 */
@Controller
@Api(value = "培训管理列表页", description = "培训管理列表页")
public class Training1Controller {

    private static final Logger logger = LoggerFactory.getLogger(Training1Controller.class);

    @Autowired
    private TrainService trainService;

    /**
     * 培训管理列表页
     *
     * @return
     */
    @RequestMapping(value = "train1/content_trail")
    @ApiOperation(value = "培训管理列表页", notes = "培训管理列表页")
    public String listPage(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
        try {
            UserInfo userinfo_session = new UserInfo();
            userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
            int company = userinfo_session.getCompany();//企业编号
            int WorkOrderChannel = CmsCache.getChannel("training_manager").getId();
            String uri = request.getRequestURI();
            long begin_time = System.currentTimeMillis();

            int id = WorkOrderChannel;//固定查询

            int currPage = CommonUtil.getIntParameter(request, "currPage");
            int rowsPerPage = CommonUtil.getIntParameter(request, "rowsPerPage");
            int sortable = CommonUtil.getIntParameter(request, "sortable");
            int rows = CommonUtil.getIntParameter(request, "rows");
            int cols = CommonUtil.getIntParameter(request, "cols");
            String globalids = "";

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

//          update by glp
            Channel channel = CmsCache.getChannel(WorkOrderChannel);

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

            Channel parentchannel = null;
            int ChannelID = channel.getId();
            String ChannelName = channel.getName();
            int IsWeight = channel.getIsWeight();
            int IsComment = channel.getIsComment();
            int IsClick = channel.getIsClick();
            String gids = "";

            if (channel.getListProgram().length() > 0 && uri.endsWith("/content/content2018.jsp")) {
                response.sendRedirect(channel.getListProgram() + "?id=" + id);
                return null;
            }

            int ApproveScheme = channel.getApproveScheme();
            if (ApproveScheme != 0) {
                response.sendRedirect("../approve/content_approve.jsp?id=" + id);
                return null;
            }

            HashMap<String, Object> searchRequest = new HashMap<>();

            String S_Title = CommonUtil.getParameter(request, "Title");
            String S_startDate = CommonUtil.getParameter(request, "startDate");
            String S_endDate = CommonUtil.getParameter(request, "endDate");
            String S_User = CommonUtil.getParameter(request, "User");
            int S_IsIncludeSubChannel = CommonUtil.getIntParameter(request, "IsIncludeSubChannel");
            String operation_status = CommonUtil.getParameter(request, "operation_status");
            if (StringUtils.isEmpty(operation_status))
                operation_status = "-1";
            String question_sort = CommonUtil.getParameter(request, "question_sort");
            int S_Status = CommonUtil.getIntParameter(request, "Status");
            int S_IsPhotoNews = CommonUtil.getIntParameter(request, "IsPhotoNews");
            int S_OpenSearch = CommonUtil.getIntParameter(request, "OpenSearch");
            int IsDelete = CommonUtil.getIntParameter(request, "IsDelete");

            int Status1 = CommonUtil.getIntParameter(request, "Status1");

            int listType = 0;
            listType = CommonUtil.getIntParameter(request, "listtype");
            if (listType == 0) listType = Util.parseInt(Util.getCookieValue(id + "_list_new", request.getCookies()));
            if (listType == 0) listType = 1;

            boolean listAll = false;

            if (channel.getParent() == -1) {//说明是站点
                S_IsIncludeSubChannel = 0;
            }

            if (channel.isTableChannel() && channel.getType2() == 8) listAll = true;
            if (channel.getIsListAll() == 1) listAll = true;
            if (S_IsIncludeSubChannel == 1) listAll = true;

            if (channel.getType() == 2) {
                response.sendRedirect("../page/content_page.jsp?id=" + id);
                return null;
            }

            //如果是“新建应用”；
            if (channel.getType() == 3) {
                response.sendRedirect("app.jsp?id=" + id);
                return null;
            }

            String querystring = "";
            querystring = "&Title=" + URLEncoder.encode(S_Title, "UTF-8") + "&startDate=" + S_startDate + "&endDate=" + S_endDate + "&User=" + S_User + "&Status=" + S_Status + "&IsPhotoNews=" + S_IsPhotoNews + "&OpenSearch=" + S_OpenSearch + "&IsDelete=" + IsDelete + "&Status1=" + Status1;

            String pageName = request.getServletPath();
            int pindex = pageName.lastIndexOf("/");
            if (pindex != -1)
                pageName = pageName.substring(pindex + 1);

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
            modelMap.addAttribute("operation_status", operation_status);
            modelMap.addAttribute("IsDelete", IsDelete);
            modelMap.addAttribute("S_OpenSearch", S_OpenSearch);
            modelMap.addAttribute("sortable", sortable);
            modelMap.addAttribute("querystring", querystring);

            int S_UserID = 0;
            long weightTime = 0;
            int IsActive = 1;
            if (IsDelete == 1) IsActive = 0;

            if (!S_User.equals("")) {
                String sql2 = "select id from userinfo where Name='" + S_User + "'";
                TableUtil tu2 = new TableUtil("user");
                ResultSet Rs2 = tu2.executeQuery(sql2);
                if (Rs2.next()) {
                    S_UserID = Rs2.getInt("id");
                    searchRequest.put("userid", S_UserID);
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
            channel.getCompany();
            searchRequest.put("id", 0);
            if (!StringUtils.isEmpty(S_Title)){
                searchRequest.put("Title", S_Title);
            }else {
                searchRequest.put("Title", "");
            };
            if (!operation_status.equals("-1")) {
                searchRequest.put("source_type", Integer.valueOf(operation_status));
            }else{
                searchRequest.put("source_type", 0);
            }
            if (!StringUtils.isEmpty(question_sort))
                searchRequest.put("question_sort", question_sort);
            if (!StringUtils.isEmpty(question_sort))
                searchRequest.put("question_sort", question_sort);
            if (!StringUtils.isEmpty(S_startDate)) {
                SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
                Date d = sf.parse(S_startDate);
                searchRequest.put("startDate", d.getTime() / 1000);
            }else {
                searchRequest.put("startDate", (long)0);
            }
            if (!StringUtils.isEmpty(S_endDate)) {
                SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
                Date d = sf.parse(S_endDate);
                searchRequest.put("endDate", d.getTime() / 1000);
            }else{
                searchRequest.put("endDate", (long)0);
            }

            int start = rowsPerPage * (currPage - 1);
            searchRequest.put("start", start);
            searchRequest.put("limit", rowsPerPage);


            logger.info("工单检索" + searchRequest);

            List<HashMap<String, Object>> result = null;


            result = trainService.getAllTrainManagerMiniMap(searchRequest);

            int TotalNumber = trainService.getAllTrainManagerMiniCount(searchRequest);


            int listnum = rowsPerPage;

            int TotalPageNumber = TotalNumber / listnum;
            if (TotalNumber % listnum != 0) {
                TotalPageNumber++;
            }
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
            int j = 0;
            int m = 0;
            int temp_gid = 0;
            String doc_typeString = "";

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            if(result!=null&&result.size()!=0) {
                for (HashMap<String, Object> item : result) {
                    int id_ = (int) item.get("id");
                    String Title = (String) item.get("Title");
                    Long PublishDate = (Long) item.get("PublishDate");
                    int operationStatus = (int) item.get("source_type");
                    int TopStatus = 0;
                    temp_gid++;
                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    String PublishDateStr = dateFormat.format(PublishDate * 1000);
                    String StatusDesc = "";
                    if (operationStatus == 2)
                        StatusDesc = "<span class='tx-danger'>视频</span>";
                    else if (operationStatus == 1)
                        StatusDesc = "<span class='tx-success'>文件</span>";

                    String questionDesc = "";
                    int OrderNumber = TotalNumber - j - ((currPage - 1) * rowsPerPage);
                    j++;


                    HashMap<String, Object> map = new HashMap<>();
                    map.put("id_", id_);
                    map.put("Status", operationStatus);
                    map.put("user", 1);
                    map.put("active", 0);
                    map.put("Title", Title);
                    map.put("TopStatus", TopStatus);
                    map.put("GlobalID", 1);
                    map.put("globalids", globalids);
                    map.put("temp_gid", temp_gid);
                    map.put("StatusDesc", StatusDesc);
                    map.put("questionDesc", questionDesc);
                    map.put("UserName", 1);
                    map.put("PublishDate", PublishDateStr);
                    map.put("OrderNumber", OrderNumber);
                    map.put("IsPhotoNews", 0);
                    map.put("gids", gids);
                    map.put("j", j++);
                    map.put("m", m++);
                    list.add(map);
                }
            }
            modelMap.put("m_", m);
            modelMap.put("list", list);
        } catch (MessageException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "content_trail";
    }


   }