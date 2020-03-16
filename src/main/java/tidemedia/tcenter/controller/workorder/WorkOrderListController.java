package tidemedia.tcenter.controller.workorder;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.solr.common.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.*;
import tidemedia.cms.user.UserGroup;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.TideJson;
import tidemedia.cms.util.Util;

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
 * 工单列表页
 * from:content2018
 */
@Controller
@Api(value = "工单列表页", description = "工单列表页")
public class WorkOrderListController {

    private static final Logger logger = LoggerFactory.getLogger(WorkOrderListController.class);


//    private WorkOrderService workOrderService;

    /**
     * 工单列表页
     *
     * @return
     */
    @RequestMapping(value = "admin/workorder_list")
    @ApiOperation(value = "工单列表页", notes = "工单列表页")
    public String listPage(HttpServletRequest request,HttpServletResponse response, ModelMap modelMap) throws Exception {

        try {
            UserInfo userinfo_session = new UserInfo();
            userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
            int company = userinfo_session.getCompany();//企业编号
            System.out.println(company+"----租户编号");
            int WorkOrderChannel = ChannelUtil.getApplicationChannel("workorder").getId();//工单记录频道id
            String uri = request.getRequestURI();
            long begin_time = System.currentTimeMillis();

            int id = WorkOrderChannel;//固定查询

            int currPage = CommonUtil.getIntParameter(request, "currPage");
            int rowsPerPage = CommonUtil.getIntParameter(request, "rowsPerPage");
            int sortable = CommonUtil.getIntParameter(request, "sortable");
            int rows = CommonUtil.getIntParameter(request, "rows");
            int cols = CommonUtil.getIntParameter(request, "cols");
            int category = CommonUtil.getIntParameter(request, "id");
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
            if(category!=WorkOrderChannel){
                channel = CmsCache.getChannel(category);
            }
            //当前登录用户绑定了租户,此频道下面是租户频道(聚融，大屏)
            if (company != 0 ) {
                id = new Tree().getChannelID(id, userinfo_session);
                channel = CmsCache.getChannel(id);
            }else{
                id=category;
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

//            HashMap<String, Object> searchRequest = new HashMap<>();
            String WhereSql="";

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
                pageName = pageName.substring(pindex +
                        1);

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
            modelMap.addAttribute("question_sort", question_sort);



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
//                    searchRequest.put("userid", S_UserID);
                    WhereSql +=" and userid = "+S_UserID+" ";

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

            String ListSql=" select id,GlobalID,Title,PublishDate,User,Summary,question_sort,operation_status,userid,companyid from channel_work_order where Active = 1 ";
            String CountSql=" select count(*) from channel_work_order where Active=1 ";
            if (!StringUtils.isEmpty(S_Title))
                WhereSql+=" and Title like '%"+Util.SQLQuote(S_Title)+"%' ";
            if (!operation_status.equals("-1")) {
                WhereSql+=" and operation_status = '"+Util.SQLQuote(operation_status)+"' ";
            }
            if (!StringUtils.isEmpty(question_sort))
                 WhereSql+=" and question_sort = '"+Util.SQLQuote(question_sort)+"' ";
            if (!StringUtils.isEmpty(S_startDate)) {
                SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
                Date d = sf.parse(S_startDate);
                WhereSql+=" and PublishDate >= '"+(d.getTime() / 1000)+"' ";
            }
            if (!StringUtils.isEmpty(S_endDate)) {
                SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
                Date d = sf.parse(S_endDate);
                WhereSql+=" and PublishDate <= '"+(d.getTime() / 1000)+"' ";
            }

            int listnum = rowsPerPage;
            if(listType==2) listnum = cols*rows;

            if(company!=0 ){
                WhereSql+=" and category="+id;
            }else if(category!=WorkOrderChannel&&company==0){
                WhereSql+=" and category="+category;
            }
            WhereSql+=" order by PublishDate desc";
            ListSql+=WhereSql;
            CountSql+=WhereSql;
            TableUtil tu = channel.getTableUtil();
            ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
            int TotalPageNumber = tu.pagecontrol.getMaxPages();
            int TotalNumber = tu.pagecontrol.getRowsCount();

            int start = rowsPerPage * (currPage - 1);
            
           /* if (TotalNumber % listnum != 0&&TotalNumber/listnum==0) {
                TotalPageNumber++;
            }*/
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
            modelMap.addAttribute("userinfo_session", userinfo_session);
            int j = 0;
            int m = 0;
            int temp_gid = 0;
            String doc_typeString = "";

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            while(Rs.next()){
                int id_ = Rs.getInt("id");
                String Title = Rs.getString("Title");
                Long PublishDate = Rs.getLong("PublishDate");

                String Summary = Rs.getString("Summary");
                int questionSort = Rs.getInt("question_sort");
                int operationStatus = Rs.getInt("operation_status");
                int user =Rs.getInt("User");
                int TopStatus = 0;
                int GlobalID = Rs.getInt("GlobalID");
                if (temp_gid != 0) {
                    globalids += ",";
                }
                temp_gid++;
                globalids += GlobalID + "";
                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                String PublishDateStr = dateFormat.format(PublishDate * 1000);
                String UserName = CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
                String StatusDesc = "";
                if (operationStatus == 0)
                    StatusDesc = "<span class='tx-danger'>待处理</span>";
                else if (operationStatus == 1)
                    StatusDesc = "<span class='tx-success'>处理中</span>";
                else
                    StatusDesc = "<span class='tx-orange'>已结束</span>";

                String questionDesc = "";
                if (questionSort == 1)
                    questionDesc = "<span>bug类</span>";
                else if (questionSort == 2)
                    questionDesc = "<span>财务类</span>";
                else
                    questionDesc = "<span>其它</span>";

                if (gids.length() > 0) {
                    gids += "," + GlobalID + "";
                } else {
                    gids = GlobalID + "";
                }
                int OrderNumber = TotalNumber - j - ((currPage - 1) * rowsPerPage);
                j++;


                HashMap<String, Object> map = new HashMap<>();
                map.put("id_", id_);
                map.put("Status", operationStatus);
                map.put("user", user);
                map.put("active", 0);
                map.put("Title", Title);
                map.put("TopStatus", TopStatus);
                map.put("GlobalID", GlobalID);
                map.put("globalids", globalids);
                map.put("temp_gid", temp_gid);
                map.put("StatusDesc", StatusDesc);
                map.put("questionDesc", questionDesc);
                map.put("UserName", UserName);
                map.put("PublishDate", PublishDateStr);
                map.put("Summary", Summary);
                map.put("questionSort", questionSort);
                map.put("OrderNumber", OrderNumber);
                map.put("IsPhotoNews", 0);
                map.put("gids", gids);
                map.put("j", j++);
                map.put("m", m++);
                list.add(map);
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

        return "workOrderList";
    }


    @ApiOperation(value = "工单详情页", notes = "工单详情页")
    @GetMapping(value = "admin/workorder_preview")
    public String previewPage(HttpServletRequest request, ModelMap modelMap) throws Exception {
        String id = CommonUtil.getParameter(request, "ItemID");
        logger.info(id + "=================");
       // List<HashMap<String, Object>> result = workOrderService.getWorkOrderDetail(id);
        logger.info(request + "=================================");

        Document doc=CmsCache.getDocument(Util.parseInt(id),CmsCache.getChannel("work_order").getId());

        if (doc!=null) {
            //整理工单详情相关数据
            modelMap.addAttribute("Title", doc.getTitle());
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Long PublishDate = doc.getPublishDateL();
            String PublishDateStr = dateFormat.format(PublishDate * 1000);
            modelMap.addAttribute("PublishDate", PublishDateStr);
            int userid = doc.getUser();
            String UserName = CmsCache.getUser(userid).getName();
            modelMap.addAttribute("UserName", UserName);
            int operationStatus = doc.getIntValue("operation_status");
            String StatusDesc = "";
            if (operationStatus == 0)
                StatusDesc = "<span class='tx-danger'>待处理</span>";
            else if (operationStatus == 1)
                StatusDesc = "<span class='tx-success'>处理中</span>";
            else
                StatusDesc = "<span class='tx-orange'>已结束</span>";
            UserInfo userinfo_session = new UserInfo();
            userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
            boolean myCreate = false;
            if(userid == userinfo_session.getId()){
                myCreate = true;
            }
            int company = userinfo_session.getCompany();
            modelMap.addAttribute("myCreate", myCreate);
            modelMap.addAttribute("company", company);
            modelMap.addAttribute("operationStatus", operationStatus);
            modelMap.addAttribute("operation_status", StatusDesc);
            modelMap.addAttribute("Summary", doc.getSummary());
            modelMap.addAttribute("id", id);



            //整理回复信息相关数据
            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

            TableUtil tu=new TableUtil();
            String sql="select * from "+CmsCache.getChannel("work_order_reply").getTableName()+"  where  parent="+id+" and active=1 ";
            ResultSet rs=tu.executeQuery(sql);
            while(rs.next()){
                if (!StringUtils.isEmpty((String) rs.getString("Summary"))) {
                    HashMap<String, Object> map = new HashMap<>();
                    int from_userid =  rs.getInt("from_userid");
                    String fromUserName = CmsCache.getUser(from_userid).getName();
                    map.put("fromUser", fromUserName);
                    map.put("replySummary", rs.getString("Summary"));
                    Long replyDate = rs.getLong("PublishDate");
                    String replyDateStr = dateFormat.format(replyDate * 1000);
                    map.put("replyDate", replyDateStr);
                    list.add(map);
                }
            }
            tu.closeRs(rs);


            logger.info(list + "=================");
            modelMap.addAttribute("replyList", list);
        } else {
            logger.error("根据id获取工单信息异常");
        }
        logger.info(id + "=================");
        return "workOrderPreview";
    }

    /**
     * 保存工单回复信息
     *
     * @return
     */
    @RequestMapping(value = "workorder/preview/add")
    @ResponseBody
    @ApiOperation(value = "保存工单回复信息", notes = "保存工单回复信息")
    public String previewAdd(HttpServletRequest request) throws Exception {
        int parentId = CommonUtil.getIntParameter(request, "parentId");
        String Title = CommonUtil.getParameter(request, "Title");
        String replySummary = CommonUtil.getParameter(request, "replySummary");
        UserInfo userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
        int replyUser = userinfo_session.getId();
        HashMap map = new HashMap();
        ItemUtil it = new ItemUtil();
        map.put("parent", String.valueOf(parentId));
        map.put("Title", Title);
        map.put("Summary", replySummary);
        map.put("from_userid", String.valueOf(replyUser));
        it.addItemGetGlobalID(CmsCache.getChannel("work_order_reply").getId(), map);
        return "";
    }


    /**
     * 新增工单时  获取用户ID 和 租户ID
     *
     * @return
     */
    @GetMapping(value = "workorder/add")
    @ResponseBody
    @ApiOperation(value = "保存工单回复信息", notes = "保存工单回复信息")
    public String workorder_add(HttpServletRequest request, int id, int action_user) throws Exception {
        try {
//            HashMap<String, Object> Map_Insert = new HashMap<String, Object>();
//            Map_Insert.put("userid", action_user);
//            Map_Insert.put("companyid", CmsCache.getUser(action_user).getCompany());
//            Map_Insert.put("id", id);
            new TableUtil().executeUpdate(" update channel_work_order set userid = "+action_user+" , companyid = "+CmsCache.getUser(action_user).getCompany()+" +  where  `id` ="+id+"");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }


    /**
     * 修改工单状态
     *
     * @return
     */
    @RequestMapping(value = "workorder/upadteState")
    @ResponseBody
    public String upadteState(HttpServletRequest request) throws Exception {
        int id = CommonUtil.getIntParameter(request, "id");
        String operation_status = CommonUtil.getParameter(request, "operation_status");
        UserInfo userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
        int userid = userinfo_session.getId();
        HashMap map = new HashMap();
        map.put("operation_status", operation_status);
        ItemUtil it = new ItemUtil();
        it.updateItemById(CmsCache.getChannel("work_order").getId(), map, id, userid);
        return "";
    }

    @RequestMapping(value = "default/orderlist2019")
    @ApiOperation(value = "工单新建页", notes = "工单新建页")
    public ModelAndView document(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {
        ModelAndView modelAndView = new ModelAndView();

        UserInfo userinfo_session = null;
        try {
            userinfo_session = new UserInfo();

            userinfo_session = (UserInfo) request.getSession().getAttribute("CMSUserInfo");

            String uri = request.getRequestURI();
            long begin_time = System.currentTimeMillis();
            int ChannelID = CommonUtil.getIntParameter(request, "ChannelID");
            int ItemID = CommonUtil.getIntParameter(request, "ItemID");
            logger.info(ChannelID + ItemID + "===============================================");
            int RecommendItemID = CommonUtil.getIntParameter(request, "RecommendItemID");
            int RecommendChannelID = CommonUtil.getIntParameter(request, "RecommendChannelID");
            String RecommendTarget = CommonUtil.getParameter(request, "RecommendTarget");
            int RecommendOutItemID = CommonUtil.getIntParameter(request, "ROutItemID");
            int RecommendOutChannelID = CommonUtil.getIntParameter(request, "ROutChannelID");
            /*云资源采用*/
            int CloudItemID = CommonUtil.getIntParameter(request, "CloudItemID");
            int CloudChannelID = CommonUtil.getIntParameter(request, "CloudChannelID");
            String ROutTarget = CommonUtil.getParameter(request, "ROutTarget");
            int parentGlobalID = CommonUtil.getIntParameter(request, "pid");
            int ContinueNewDocument = CommonUtil.getIntParameter(request, "ContinueNewDocument");
            int NoCloseWindow = CommonUtil.getIntParameter(request, "NoCloseWindow");
            String From = CommonUtil.getParameter(request, "From");
            int IsDialog = CommonUtil.getIntParameter(request, "IsDialog");//如果是弹出窗口，值设为1
            int Parent = CommonUtil.getIntParameter(request, "Parent");//如果设置了Parent,就设置Parent字段的值
            String transfer_article = CommonUtil.getParameter(request, "transfer_article");//一键转载url
            int GlobalID = 0;
            String QRcode = "";
            String title = "";
            ChannelPrivilege cp = new ChannelPrivilege();

            if (!cp.hasRight(userinfo_session, ChannelID, 2)) {
                response.sendRedirect("../close_pop.jsp");
                // update 20190925
//            modelAndView.setViewName("../close_pop.jsp");
                return modelAndView;
            }

            Document item = null;
            Channel channel = CmsCache.getChannel(ChannelID);
            if (channel.getDocumentProgram().length() > 0 && uri.endsWith("/content/document.jsp")) {
                String url = channel.getDocumentProgram() + "?ChannelID=" + ChannelID + "&ItemID=" + ItemID + "&ROutTarget=" + ROutTarget + "&ROutChannelID=" + RecommendOutChannelID + "&ROutItemID=" + RecommendOutItemID + "&RecommendItemID=" + RecommendItemID + "&RecommendChannelID=" + RecommendChannelID + "&RecommendTarget=" + RecommendTarget + "&CloudItemID=" + CloudItemID + "&CloudChannelID=" + CloudChannelID;
                response.sendRedirect(url);
            }
            if (channel.isVideoChannel()) {
                response.sendRedirect("../video/document.jsp?ItemID=" + ItemID + "&ChannelID=" + ChannelID);
//            modelAndView.setViewName("../video/document.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID);
                // update 20190925
                return modelAndView;
            }

            if (ItemID > 0) {
                item = CmsCache.getDocument(ItemID, ChannelID);

                //解决同步问题，2012.09.19
                if (item.getChannel().getId() != ChannelID) {
                    ChannelID = item.getChannel().getId();
                    item = CmsCache.getDocument(ItemID, ChannelID);
                    channel = CmsCache.getChannel(ChannelID);
                }
            }

            if (item != null) {
                GlobalID = item.getGlobalID();
                QRcode = "";
                title = item.getTitle();
            }
            ArrayList fieldGroupArray = channel.getFieldGroupInfo();
            String SiteAddress = channel.getSite().getUrl();

            String check2 = "";

            boolean editCategory = false;

            if (channel.isTableChannel() && channel.getType2() == 8) editCategory = true;

            String userGroup = "";

            try {
                userGroup = new UserGroup(userinfo_session.getGroup()).getName();
            } catch (Exception e) {
            }

            TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
            String inner_url = "", outer_url = "";
            if (photo_config != null) {
                int sys_channelid_image = photo_config.getInt("channelid");
                Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
                inner_url = img_site.getUrl();
                outer_url = img_site.getExternalUrl();
            }

            int ApproveScheme = channel.getApproveScheme();//是否配置了审核方案
            int Version = channel.getVersion();//是否开启了版本功能


            ApproveAction approve = new ApproveAction(GlobalID, 0);//最近一次审核操作
            int id_aa = approve.getId();//审核操作id
            int approveId = approve.getApproveId();//审核环节id
            int action = approve.getAction();//是否通过
            int end = approve.getEndApprove();//是否终审

            int data_approve = 0;//是否显示右侧审核栏
            int data_yl = 0;//是否为审核预览

            if (id_aa != 0) {//说明已提交审核
                data_approve = 1;//是否显示右侧审核栏
                data_yl = 0;//是否为审核预览
            }

//        modelMap.addAttribute("item", item);
            ArrayList<Map> list = new ArrayList<>();
            if (item != null && item.getTotalPage() > 1) {
                for (int i = 2; i < item.getTotalPage(); i++) {
                    item.setCurrentPage(i);
                    HashMap<String, Object> map = new HashMap<>();
                    map.put("i", i);


                    String content = Util.JSQuote(item.getContent());
                    map.put("content", content);

                    list.add(map);
                    map = null;
                }
                modelMap.addAttribute("list", list);
            }
//        modelMap.addAttribute("list", list);
//        String content = Util.JSQuote(item.getContent());
//        modelMap.addAttribute("content", content);
            modelMap.addAttribute("ParentChannelPath", channel.getParentChannelPath());
            modelMap.addAttribute("userinfo_session", userinfo_session);

            logger.info("userinfo_session " + userinfo_session.getName());

            modelMap.addAttribute("userGroup", userGroup);
            modelMap.addAttribute("ChannelID", ChannelID);
            modelMap.addAttribute("QRcode", QRcode);
            modelMap.addAttribute("fieldGroupArray_size", fieldGroupArray.size());
            modelMap.addAttribute("begin_time", begin_time / 1000);
            modelMap.addAttribute("SiteAddress", SiteAddress);
            modelMap.addAttribute("GlobalID", GlobalID);
            modelMap.addAttribute("inner_url", inner_url);
            modelMap.addAttribute("outer_url", outer_url);
            modelMap.addAttribute("ChannelID", ChannelID);
            modelMap.addAttribute("NoCloseWindow", NoCloseWindow);
            modelMap.addAttribute("cp", cp);
            boolean hasRight = cp.hasRight(userinfo_session, ChannelID, 3);
            modelMap.addAttribute("hasRight", hasRight);
            modelMap.addAttribute("IsDialog", IsDialog);
            modelMap.addAttribute("RecommendItemID", RecommendItemID);
            modelMap.addAttribute("RecommendChannelID", RecommendChannelID);
            modelMap.addAttribute("RecommendTarget", RecommendTarget);
            modelMap.addAttribute("RecommendOutItemID", RecommendOutItemID);
            modelMap.addAttribute("RecommendOutChannelID", RecommendOutChannelID);
            modelMap.addAttribute("CloudChannelID", CloudChannelID);
            modelMap.addAttribute("CloudItemID", CloudItemID);
            modelMap.addAttribute(transfer_article, transfer_article);
            modelMap.addAttribute("transfer_article_length", transfer_article.length());
            modelMap.addAttribute("channelParentChannelPath", channel.getParentChannelPath());
            modelMap.addAttribute("item", item);
//        modelMap.addAttribute("itemTitle", item.getTitle());

//        logger.info("内容页面 itemTitle :" + item.getTitle());

            ArrayList<Map> list1 = new ArrayList<>();
            for (int i = 0; i < fieldGroupArray.size(); i++) {
                HashMap<Object, Object> map = new HashMap<>();
                FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
                map.put("i", i);
                map.put("fieldGroup", fieldGroup);
                list1.add(map);
                map = null;
            }
            modelMap.addAttribute("list1", list1);
            int vercount = (!QRcode.equals("")) ? fieldGroupArray.size() + 2 : fieldGroupArray.size() + 1;
            modelMap.addAttribute("Version", Version);
            modelMap.addAttribute("vercount", vercount);
            String ParentChannelPath = channel.getParentChannelPath().replaceAll(">", " / ");
            modelMap.put("ParentChannelPath", ParentChannelPath);
            modelMap.addAttribute("ApproveScheme", ApproveScheme);
            modelMap.addAttribute("action", action);
            modelMap.addAttribute("id_aa", id_aa);
            modelMap.addAttribute("ItemID", ItemID);
            modelMap.addAttribute("end", end);
            int size = channel.getChannelTemplates(2).size();
            modelMap.put("size", size);

            ArrayList<Map> list2 = new ArrayList<>();
            int j = 0;
            do {
                HashMap<String, Object> map = new HashMap<>();


                String padding = "";
                FieldGroup fieldGroup = null;//字段分组
                int fieldGroupID = 0;
                if (fieldGroupArray.size() > 0) {
                    fieldGroup = (FieldGroup) fieldGroupArray.get(j);
                    fieldGroupID = fieldGroup.getId();
                }
                map.put("fieldGroup", fieldGroup);


                String url = "";
                if (fieldGroupArray.size() > 0 && fieldGroup.getUrl().length() > 0) {
                    url = fieldGroup.getUrl();
                    url = url.replace("$globalid", GlobalID + "");
                    url = url.replace("$itemid", ItemID + "");
                    url = url.replace("$channelid", ChannelID + "");
                    boolean b = url.contains("?");
                    String c = "";
                    if (!url.contains("itemid="))
                        c += "&itemid=" + ItemID;
                    if (!url.contains("globalid="))
                        c += "&globalid=" + GlobalID;
                    c += "&channelid=" + ChannelID + "&fieldgroup=" + (j + 1);
                    url += ((b) ? "" : "?") + c;
                }
                if (fieldGroupID > 0 && !fieldGroup.getUrl().equals("")) {
                    padding = "clear-padding";
                } else {
                    padding = "";
                }

                map.put("url", url);
                map.put("j", j);
                map.put("padding", padding);
                map.put("fieldGroupID", fieldGroupID);
                String fieldGroupUrl = fieldGroup.getUrl();
                map.put("fieldGroupUrl", fieldGroupUrl);

                if (fieldGroupID > 0 && !fieldGroup.getUrl().equals("")) {
                } else {
                    Field field_title = channel.getFieldByFieldName("Title");
                    map.put("field_title", field_title);
                    int length = field_title.getJS().length();
                    map.put("length", length);

                    if (editCategory) {
                        map.put("editCategory_bol", true);

                        ArrayList categorys = channel.listAllSubChannels(Channel.Category_Type);
                        ArrayList<Object> list3 = new ArrayList<>();
                        if (categorys != null && categorys.size() > 0) {
                            map.put("categorys_isExist", true);
                            for (int i = 0; i < categorys.size(); i++) {
                                HashMap<Object, Object> map1 = new HashMap<>();
                                Channel subcategory = (Channel) categorys.get(i);
                                map1.put("subcategory", subcategory);
                                String bol = (item != null && subcategory.getId() == item.getCategoryID()) ? "selected" : "";
                                map1.put("bol", bol);
                                list3.add(map1);

                                map.put("list3", list3);
                                map1 = null;
                            }
                        } else {
                            map.put("categorys_isExist", false);
                        }
                    } else {
                        map.put("editCategory_bol", false);
                    }
                }

                ArrayList arraylist = channel.getFieldsByGroup(fieldGroupID, j);
                int jj = 0;
                ArrayList<Map> list4 = new ArrayList<>();
                for (int i = 0; i < arraylist.size(); i++) {
                    HashMap<String, Object> map1 = new HashMap<>();

                    Field field = (Field) arraylist.get(i);
                    map1.put("field", field);

                    if (channel.isShowField(field.getName()) && field.getIsHide() == 0) {
                        if (field.getDisableBlank() == 1) {
                            check2 += "	if(isEmpty(document.form." + field.getName() + ",'请输入" + field.getDescription() + ".'))";
                            check2 += "	return false;";
                        }
                        if (field.getName().equalsIgnoreCase("Content")) {
                            map1.put("nameEqualsContent", true);
                        } else {
                            map1.put("nameEqualsContent", false);
                        }

                        String displayHtml_ = field.getDisplayHtml_(item != null ? item.getPublishDate() : Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
                        String displayHtml_1 = channel.getFieldByFieldName("Weight").getDisplayHtml_(item != null ? item.getWeight() + "" : "");
                        map1.put("displayHtml_", displayHtml_);
                        map1.put("displayHtml_1", displayHtml_1);

                        String displayHtml_2 = field.getDisplayHtml_(item != null ? item.getValue(field.getName()) : "");
                        map1.put("displayHtml_2", displayHtml_2);

                        String displayHtml2018 = field.getDisplayHtml2018(item);
                        map1.put("displayHtml2018", displayHtml2018);

                    } else {
                        map1.put("nameEqualsContent", false);
                    }

//                if(field.getFieldType().equals("label")){
//
//                } else {
//
//                }


                    if (item != null) {
                        item.setCurrentPage(1);
                        String currcontent = Util.JSQuote(item.getContent().replaceAll(outer_url, inner_url));
                        map1.put("currcontent", currcontent);
                    }

                    list4.add(map1);
                    map1 = null;
                }
                modelMap.addAttribute("list4", list4);


                list2.add(map);
                map = null;

                j++;
            } while (j < fieldGroupArray.size());
            modelMap.addAttribute("list2", list2);
            modelMap.addAttribute("data_approve", data_approve);
            modelMap.addAttribute("data_yl", data_yl);

            String title1 = item != null ? Util.HTMLEncode(item.getValue("Title")) : "";
            modelMap.addAttribute("title1", title1);
            modelMap.addAttribute("editCategory", editCategory);

            modelMap.addAttribute("j", j);
            modelMap.addAttribute("fieldGroupArraySize;", fieldGroupArray.size() + 1);
            modelMap.addAttribute("From;", From);
            modelMap.addAttribute("parentGlobalID;", parentGlobalID);
            modelMap.addAttribute("ContinueNewDocument;", ContinueNewDocument);

            boolean jsLength = channel.getDocumentJS().length() > 0;
            modelMap.addAttribute("jsLength", jsLength);

            String documentJS = channel.getDocumentJS();
            modelMap.addAttribute("documentJS", documentJS);
            modelMap.addAttribute("Parent", Parent);


        } catch (MessageException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        modelAndView.addAllObjects(modelMap);
        modelAndView.setViewName("orderlist2019");

        return modelAndView;
    }
}
