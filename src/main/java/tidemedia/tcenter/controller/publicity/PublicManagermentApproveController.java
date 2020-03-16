package tidemedia.tcenter.controller.publicity;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
import java.util.*;

import static tidemedia.cms.util.Util2.convertNull;

/**
 * 默认
 * from:content2018
 */
@Controller
@RequestMapping
@Api(value = "下发管理审核页面定制",description = "下发管理审核页面定制")
public class PublicManagermentApproveController {


    @RequestMapping(value = "custom/issuedManager_approvePreview")
    @ApiOperation(value = "下发管理审核页面定制", notes = "下发管理审核页面定制")
    public String listPage(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception{
        List<String> addCustomField=new ArrayList<>();
        addCustomField.add("doc_type");
        String page = getList(request, response, modelMap, addCustomField);

        return page;
    }

    /**
     * 定制 ftl 页面字段新增解析
     * @param additionaCustomList
     * @return
     * @throws Exception
     */
    private String getListByByCustom(List<String> additionaCustomList) throws Exception{

        String customs = "";
        if (additionaCustomList != null && additionaCustomList.size() > 0) {
            for(String custom : additionaCustomList) {
                customs += "," + custom;
            }
        }
        return customs;
    }

    /**
     * 定制化页面的内容注入
     * @param request
     * @param response
     * @param modelMap
     * @param additionaCustomList 定制字段
     * @return
     * @throws Exception
     */
    protected String getList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, List<String> additionaCustomList) throws Exception {

        // 定制化字段列表
        String listByByCustomSql = "";
        if (additionaCustomList != null){
            listByByCustomSql = getListByByCustom(additionaCustomList);
        }

        // 默认字段
        UserInfo userinfo_session = new UserInfo();
        userinfo_session = (UserInfo)request.getSession().getAttribute("CMSUserInfo");
        //
        String uri = request.getRequestURI();
        long begin_time = System.currentTimeMillis();
        int id = CommonUtil.getIntParameter(request, "id");
        int currPage = CommonUtil.getIntParameter(request, "currPage") ;
        int rowsPerPage = CommonUtil.getIntParameter(request, "rowsPerPage");
        int sortable = CommonUtil.getIntParameter(request,"sortable");
        int rows = CommonUtil.getIntParameter(request,"rows");
        int cols = CommonUtil.getIntParameter(request,"cols");
        String globalids="";
        //
        if(currPage<1)
            currPage = 1;
        if(rowsPerPage==0)
            rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new",request.getCookies()));
        if(rowsPerPage<=0)
            rowsPerPage = 20;
        if(rows==0)
            rows = Util.parseInt(Util.getCookieValue("rows_new",request.getCookies()));
        if(cols==0)
            cols = Util.parseInt(Util.getCookieValue("cols_new",request.getCookies()));
        if(rows==0)
            rows = 10;
        if(cols==0)
            cols = 5;
        Channel channel = CmsCache.getChannel(id);
        //
        //当前登录用户绑定了租户,此频道下面是租户频道(聚融，大屏)
        String a = channel.getApplication() ;
        if(userinfo_session.getCompany()!=0&&(a.startsWith("pgc_")||a.startsWith("screen")||a.startsWith("task")||a.startsWith("shenpian")||a.startsWith("shengao"))){
            //获取符合条件的租户频道,替换ch对象，后面逻辑不变
            id = new Tree().getChannelID(id, userinfo_session);
            channel = CmsCache.getChannel(id);
        }
        boolean IsTopStatus=false;//是否置顶
        if(channel.getIsTop()==1){
            IsTopStatus=true;
        }
        if(channel==null || channel.getId()==0)
        {
            response.sendRedirect("../content/content_nochannel.jsp");
            return null;
        }
        //
        Channel parentchannel = null;
        int ChannelID = channel.getId();
        String ChannelName = channel.getName();
        int IsWeight=channel.getIsWeight();
        int	IsComment=channel.getIsComment();
        int	IsClick=channel.getIsClick();
        String gids = "";
        //
        if(channel.getListProgram().length()>0 && uri.endsWith("/content/content2018.jsp"))
        {response.sendRedirect(channel.getListProgram()+"?id="+id);return null;}
        //
//        int ApproveScheme = channel.getApproveScheme();
////        if(ApproveScheme!=0){
////            response.sendRedirect("../approve/content_approve.jsp?id="+id);
////            return null;
////        }
        ApproveScheme approveScheme = new ApproveScheme(channel.getApproveScheme());
        int editable = approveScheme.getEditable();
        int userrole = userinfo_session.getRole();
        modelMap.put("userrole", userrole);
        modelMap.put("editable", editable);


        String S_Title				=	CommonUtil.getParameter(request,"Title");
        String S_startDate			=	CommonUtil.getParameter(request,"startDate");
        String S_endDate			=	CommonUtil.getParameter(request,"endDate");
        String S_User				=	CommonUtil.getParameter(request,"User");
        int S_IsIncludeSubChannel	=	CommonUtil.getIntParameter(request,"IsIncludeSubChannel");
        int S_Status				=	CommonUtil.getIntParameter(request,"Status");
        int S_IsPhotoNews			=	CommonUtil.getIntParameter(request,"IsPhotoNews");
        int S_OpenSearch			=	CommonUtil.getIntParameter(request,"OpenSearch");
        int IsDelete				=	CommonUtil.getIntParameter(request,"IsDelete");
        int Status1			        =	CommonUtil.getIntParameter(request,"Status1");
        int listType = 0;
        listType = CommonUtil.getIntParameter(request,"listtype");
        if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list_new",request.getCookies()));
        if(listType==0) listType = 1;
        //
        boolean listAll = false;
        //
        if(channel.getParent()==-1){//说明是站点
            S_IsIncludeSubChannel = 0;
        }
        //
        if(channel.isTableChannel() && channel.getType2()==8) listAll = true;
        if(channel.getIsListAll()==1) listAll = true;
        if(S_IsIncludeSubChannel==1) listAll = true;
        //
        if(channel.getType()==2)
        {
            response.sendRedirect("../page/content_page.jsp?id="+id);
            return null;
        }
        // 如果是“新建应用”；
        if(channel.getType()==3)
        {
            response.sendRedirect("app.jsp?id="+id);
            return null;
        }

        // 返回内容组装
        String querystring = "";
        querystring = "&Title="+ URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;
        //
        String pageName = request.getServletPath();
        int pindex = pageName.lastIndexOf("/");
        if(pindex!=-1)
            pageName = pageName.substring(pindex+1);
        //
        if(!channel.hasRight(userinfo_session,1))
        {
            response.sendRedirect("../noperm.jsp");return null;
        }
        boolean canApprove = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanApprove);
        boolean canDelete = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanDelete);
        boolean canAdd = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanAdd);
        boolean createCategory = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CreateCategory);
        int canExcel=channel.getIsExportExcel();//是否导出Excel
        int canWord=channel.getIsImportWord();//是否导出world
        String SiteAddress = channel.getSite().getUrl();
        //获取频道路径
        String parentChannelPath = channel.getParentChannelPath().replaceAll(">"," / ");
        modelMap.addAttribute("listType", listType);
        modelMap.addAttribute("rows", rows);
        modelMap.addAttribute("cols", cols);

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
        if(IsDelete==1) IsActive=0;
        if(!S_User.equals("")){
            String sql2="select * from userinfo where Name='"+S_User+"'";
            TableUtil tu2 = new TableUtil("user");
            ResultSet Rs2 = tu2.executeQuery(sql2);
            if(Rs2.next()){
                S_UserID=Rs2.getInt("id");
            }else{
                S_UserID=0;
            }
        }
        if(channel.getIsWeight()==1)
        {
            //权重排序
            Calendar nowDate = new GregorianCalendar();
            nowDate.set(Calendar.HOUR_OF_DAY,0);
            nowDate.set(Calendar.MINUTE,0);
            nowDate.set(Calendar.SECOND,0);
            nowDate.set(Calendar.MILLISECOND,0);
            weightTime = nowDate.getTimeInMillis()/1000;
        }
        String Table = channel.getTableName();
        String ListSql = "select id,Title,Photo,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews";
        // 定制字段组装
        ListSql += listByByCustomSql;
        //
        String FieldStr=",DocTop,DocTopTime";
        if(IsTopStatus){
            ListSql+=FieldStr;
        }
        //
        if(listType==2)
        {
            ListSql += ",Summary,Content,Keyword";
        }
        if(channel.getIsWeight()==1)
            ListSql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
        ListSql += " from " + Table;
        String CountSql = "select count(*) from "+Table;
        if(!listAll)
        {
            if(channel.getType()== Channel.Category_Type)
            {
                ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
                CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
            }
            else if(channel.getType()== Channel.MirrorChannel_Type)
            {
                Channel linkChannel = channel.getLinkChannel();
                if(linkChannel.getType()== Channel.Category_Type)
                {
                    ListSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                    CountSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                }
                else
                {
                    ListSql += " where Category=0 and Active=" + IsActive;
                    CountSql += " where Category=0 and Active=" + IsActive;
                }
            }
            else
            {
                ListSql += " where "+ (!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
                CountSql += " where "+(!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
            }
        }
        else
        {
            ListSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
            CountSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
        }
        String WhereSql = "";
        if(!S_Title.equals("")){
            String tempTitle=S_Title.replaceAll("%","\\\\%");
            WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
        }
        if(!S_startDate.equals("")){
            long startTime= Util.getFromTime(S_startDate,"");
            WhereSql += " and CreateDate>="+startTime ;
        }
        if(!S_endDate.equals("")){
            long endTime= Util.getFromTime(S_endDate,"");
            WhereSql += " and CreateDate<"+(endTime+86400);
        }
        if(S_UserID>0)
        {
            WhereSql += " and User="+S_UserID;
        }
        if(S_IsPhotoNews==1)
            WhereSql += " and IsPhotoNews=1";
        if(S_Status!=0)
            WhereSql += " and Status=" + (S_Status-1);
        if(Status1!=0)
        {
            if(Status1==-1)
                WhereSql += " and Status=0";
            else
                WhereSql += " and Status=" + Status1;
        }
        //下发管理如果非运营中心人员，只能查看已发的内容
        if(userinfo_session.getCompany()!=0){
            WhereSql+=" and status=1 ";
        }

        ListSql += WhereSql;
        CountSql += WhereSql;
        if(channel.getIsWeight()==1)
        {
            ListSql += " order by newtime desc,id desc";
        }
        else
        {
            if(IsTopStatus){
                ListSql += " order by  DocTop desc ,DocTopTime  desc  ,OrderNumber desc ";
            }else {
                ListSql += " order by OrderNumber desc ";
            }
        }
        int listnum = rowsPerPage;
        if(listType==2) listnum = cols*rows;

        TableUtil tu = channel.getTableUtil();
        ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
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
        int temp_gid=0;
        String doc_typeString ="";
        //
        List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
        //
        while(Rs.next()){
            int id_ = Rs.getInt("id");
            int Status = Rs.getInt("Status");
            int category = Rs.getInt("Category");
            int user = Rs.getInt("User");
            int active = Rs.getInt("Active");
            String Title	= convertNull(Rs.getString("Title"));
            int IsPhotoNews = Rs.getInt("IsPhotoNews");
            int TopStatus = 0;
            if(IsTopStatus){
                TopStatus = Rs.getInt("DocTop");
            }
            if(listAll)
            {
                if(category>0)
                    Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
            }
            int Weight=Rs.getInt("Weight");
            int GlobalID=Rs.getInt("GlobalID");
            if(temp_gid!=0){
                globalids+=",";
            }
            temp_gid++;
            globalids+=GlobalID+"";

            String approve_status = "未提交审核";
            ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
            int id_aa = approve.getId();//审核操作id
            int approveId = approve.getApproveId();//审核环节id
            int action	= approve.getAction();//是否通过
            int end = approve.getEndApprove();//是否终审
            int editables = 0;
            JSONObject json1 = null;
            if(id_aa!=0){//说明已配置审核环节
                ApproveItems ai = new ApproveItems(approveId);//审核环节
                if(approveId==0){//审核环节编号为0，此文章状态为提交审核
                    json1 = ai.getApproveName(channel.getApproveScheme());
                    approve_status = json1.get("ApproveName")+"待审核";
                    editables = (int) json1.get("Editable");
                }else{
                    json1 = ai.getApproveName(0);
                    approve_status = json1.get("ApproveName")+"待审核";
                    editables = (int) json1.get("Editable");
                    int endLink = (int)json1.get("endLink");
                    int type = ai.getType();
                    String userIds = ai.getUsers();
                    if(!userIds.equals("")){
                        String[] users = userIds.split(",");
                        JSONObject json = getUserNames(users,getAction(GlobalID),GlobalID,ai.getId());
                        int size = json.getInt("size");
                        if(type==1){//并签要判断其他人是否审核通过
                            if(size>0){
                                approve_status = approve.getApproveName()+"待审核";
                            }
                            //确保最后环节为并签时有用户审核通过导致稿件不可编辑
                            if(endLink == 1){
                                editables = 2;
                            }
                        }
                    }
                    if(action==1){//未通过
                        approve_status = approve.getApproveName()+"驳回";
                    }
                    if(action==0&&end==1){
                        approve_status = approve.getApproveName()+"通过";
                    }
                }
            }



            String ModifiedDate	= convertNull(Rs.getString("ModifiedDate"));
            ModifiedDate= Util.FormatDate("yyyy-MM-dd HH:mm",ModifiedDate);
            String UserName	= CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
            String StatusDesc = "";
            if(IsDelete!=1){
                if(Status==0)
                    StatusDesc = "<span class='tx-orange'>草稿</span>";
                else if(Status==1)
                    StatusDesc = "<span class='tx-success'>已发</span>";
            }else{
                StatusDesc = "<span class='tx-danger'>已删除</span>";
            }
            if(gids.length()>0){gids+=","+GlobalID+"";}else{gids=GlobalID+"";}
            int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
            j++;

            String photoAddr = "";
            if (listType == 2) {
                String Photo	= convertNull(Rs.getString("Photo"));

                if(Photo.startsWith("http://"))
                    photoAddr = Photo;
                else
                    photoAddr = SiteAddress + Photo;

                if(m==cols){
                    m=0;
                }
            }

            HashMap<String, Object> map = new HashMap<>();
            // 列表页定制字段追加
            if (additionaCustomList != null){
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

            map.put("id_aa", id_aa);
            map.put("action", action);
            map.put("end", end);
            map.put("editables", editables);
            map.put("approve_status", approve_status);

            list.add(map);
        }
        tu.closeRs(Rs);
        modelMap.put("m_", m);
        modelMap.put("list", list);

        boolean channelTemplatesSize = false;
        if(channel.getChannelTemplates(2).size()!=0){
            channelTemplatesSize = true;
        }
        modelMap.put("channelTemplatesSize", channelTemplatesSize);
        modelMap.put("administrator", userinfo_session.isAdministrator());
        modelMap.put("userinfo_session",userinfo_session);

        return "content_document/issuedManagermentApprove";
    }

    public String getHtml(String result,String time,int next,int end,int endStep,String userNames,String userIds,int approveId,int action){

        String html = "";
        html += "<div class=\"mg-y-5 sh-item d-flex justify-content-between align-items-center\">";
        html += "<p class=\"mg-b-0 tx-inverse tx-lato\">";
        html += result;
        html += "</p>";
        html += "<p class=\"mg-b-0 tx-sm\">"+time+"</p>";
        html += "</div>";

        if(!userNames.equals("")){
            html += "<div class=\"bg-gray-300 pd-x-10 pd-y-5 mg-y-5 tx-gray-700\">"+userNames+"</div>";
        }
        if(next==1){
            html += "<textarea id=\"approve\" class=\"form-control ht-100 mg-t-10\" cols=\"5\"  placeholder=\"请输入驳回理由，驳回到提交审核环节。如审核通过则不需要输入\" user=\""+userIds+"\" end=\""+end+"\" approveId=\""+approveId+"\"></textarea>";
        }
        if(endStep!=1&&end!=1&&action!=1){
            html += "<div class=\"mg-y-8 pd-l-20 tx-14\"><i class=\"fa fa-ellipsis-v\"></i> </div>";
        }

        return html ;
    }
    //获取用户名
    public org.json.JSONObject getUserNames(String[] users,int endActionId,int gid,int approveId) throws tidemedia.cms.base.MessageException, SQLException,org.json.JSONException{

        org.json.JSONObject json = new org.json.JSONObject();

        String userNames = "";
        String userIds = "";
        int size = 0 ;
        for(int i=0;i<users.length;i++){
            int userId = 0;
            if(users[i]!=""){
                userId = Integer.parseInt(users[i]);
            }
            if(isApprove(userId,endActionId,gid,approveId)){
                continue;
            }

            if(!userNames.equals("")){
                userNames += "、";
            }
            userNames += tidemedia.cms.system.CmsCache.getUser(userId).getName();
            if(!userIds.equals("")){
                userIds += ",";
            }
            userIds += userId;
            size++ ;
        }

        json.put("userNames",userNames);
        json.put("userIds",userIds);
        json.put("size",size);

        return json ;
    }
    //判断用户是否已审核通过
    public boolean isApprove(int userid,int endActionId,int gid,int approveId) throws tidemedia.cms.base.MessageException, SQLException{

        boolean flag = false ;

        String sql = "select * from approve_actions where parent="+gid+" and id>"+endActionId+" and userid="+userid+" and ApproveId="+approveId;
        tidemedia.cms.base.TableUtil tu = new tidemedia.cms.base.TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if(rs.next()){
            flag = true ;
        }
        tu.closeRs(rs);

        return flag;
    }
    //获取最后一次驳回操作编号
    public int getAction(int gid)throws tidemedia.cms.base.MessageException, SQLException{
        int actionId = 0;

        String sql = "select id from approve_actions where parent="+gid+" and endApprove=1 order by id asc";
        tidemedia.cms.base.TableUtil tu = new tidemedia.cms.base.TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if(rs.next()){
            actionId = rs.getInt("id") ;
        }
        tu.closeRs(rs);

        return actionId ;
    }
    //获取等待时长
    public String getTime(String date){

        String time_ = "";

        Long start = Long.parseLong(tidemedia.cms.util.Util.parseDate(date))/1000;
        Long now =  System.currentTimeMillis()/1000;

        int time = (int)(now-start);
        time_ = formatDuration(time);
        return time_ ;
    }
    //格式化时长，
    public static String formatDuration(int duration) {
        String times = "";

        String sec = "";
        String minute = "";
        String hour = "";

        int min = 0;
        int gsm = 0;

        if ((duration / 60) % 60 > 0) {
            min = (duration / 60) % 60;// 分
        }
        if ((duration / 60 / 60) % 60 > 0) {
            gsm = (duration / 60 / 60) % 60;// 小时
        }

        if(gsm>0) times += gsm+"小时";

        times += min+"分钟";

        return times;
    }


    @GetMapping(value = "custom/issuedManager_document")
    @ApiOperation(value = "宣管下发内容页", notes = "宣管下发内容页")
    public ModelAndView document(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap)  {
        ModelAndView modelAndView = new ModelAndView();

        UserInfo userinfo_session = null;
        try {
            userinfo_session = new UserInfo();

            userinfo_session = (UserInfo)request.getSession().getAttribute("CMSUserInfo");

            String	uri						= request.getRequestURI();
            long	begin_time				= System.currentTimeMillis();
            int		ChannelID				= CommonUtil.getIntParameter(request,"ChannelID");
            int		ItemID					= CommonUtil.getIntParameter(request,"ItemID");
            int		RecommendItemID			= CommonUtil.getIntParameter(request,"RecommendItemID");
            int		RecommendChannelID		= CommonUtil.getIntParameter(request,"RecommendChannelID");
            String	RecommendTarget			= CommonUtil.getParameter(request,"RecommendTarget");
            int		RecommendOutItemID		= CommonUtil.getIntParameter(request,"ROutItemID");
            int		RecommendOutChannelID	= CommonUtil.getIntParameter(request,"ROutChannelID");
            /*云资源采用*/
            int		CloudItemID				= CommonUtil.getIntParameter(request,"CloudItemID");
            int		CloudChannelID			= CommonUtil.getIntParameter(request,"CloudChannelID");
            String	ROutTarget				= CommonUtil.getParameter(request,"ROutTarget");
            int		parentGlobalID			= CommonUtil.getIntParameter(request,"pid");
            int ContinueNewDocument			= CommonUtil.getIntParameter(request,"ContinueNewDocument");
            int NoCloseWindow				= CommonUtil.getIntParameter(request,"NoCloseWindow");
            String From						= CommonUtil.getParameter(request,"From");
            int IsDialog					= CommonUtil.getIntParameter(request,"IsDialog");//如果是弹出窗口，值设为1
            int Parent						= CommonUtil.getIntParameter(request,"Parent");//如果设置了Parent,就设置Parent字段的值
            String transfer_article			= CommonUtil.getParameter(request,"transfer_article");//一键转载url
            int GlobalID					= 0;
            String QRcode					= "";
            String title = "";
            ChannelPrivilege cp = new ChannelPrivilege();

            if(!cp.hasRight(userinfo_session,ChannelID,2))
            {
                response.sendRedirect("../close_pop.jsp");
                // update 20190925
//            modelAndView.setViewName("../close_pop.jsp");
                return modelAndView;
            }

            Document item = null;
            Channel channel = CmsCache.getChannel(ChannelID);
            if(channel.getDocumentProgram().length()>0 && uri.endsWith("/content/document.jsp") ){
                String url = channel.getDocumentProgram()+"?ChannelID="+ChannelID+"&ItemID="+ItemID+"&ROutTarget="+ROutTarget+"&ROutChannelID="+RecommendOutChannelID+"&ROutItemID="+RecommendOutItemID+"&RecommendItemID="+RecommendItemID+"&RecommendChannelID="+RecommendChannelID+"&RecommendTarget="+RecommendTarget+"&CloudItemID="+CloudItemID+"&CloudChannelID="+CloudChannelID;
                response.sendRedirect(url);
            }
            if(channel.isVideoChannel())
            {
                response.sendRedirect("../video/document.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID);
//            modelAndView.setViewName("../video/document.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID);
                // update 20190925
                return modelAndView;
            }

            if(ItemID>0)
            {
                item = CmsCache.getDocument(ItemID,ChannelID);

                //解决同步问题，2012.09.19
                if(item.getChannel().getId()!=ChannelID)
                {
                    ChannelID = item.getChannel().getId();
                    item = CmsCache.getDocument(ItemID,ChannelID);
                    channel = CmsCache.getChannel(ChannelID);
                }
            }

            if(item!=null)
            {
                GlobalID = item.getGlobalID();
                QRcode ="";
                title = item.getTitle();
            }
            ArrayList fieldGroupArray = channel.getFieldGroupInfo();
            String SiteAddress = channel.getSite().getUrl();

            String check2 = "";

            boolean editCategory = false;

            if(channel.isTableChannel() && channel.getType2()==8) editCategory = true;

            String userGroup = "";

            try
            {
                userGroup = new UserGroup(userinfo_session.getGroup()).getName();
            }
            catch(Exception e){}

            TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
            String inner_url = "",outer_url="";
            if(photo_config != null)
            {
                int sys_channelid_image = photo_config.getInt("channelid");
                Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
                inner_url = img_site.getUrl();
                outer_url = img_site.getExternalUrl();
            }

            int ApproveScheme = channel.getApproveScheme();//是否配置了审核方案
            int Version = channel.getVersion();//是否开启了版本功能


            ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
            int id_aa = approve.getId();//审核操作id
            int approveId = approve.getApproveId();//审核环节id
            int action	= approve.getAction();//是否通过
            int end = approve.getEndApprove();//是否终审

            int data_approve = 0;//是否显示右侧审核栏
            int data_yl = 0;//是否为审核预览

            if(id_aa!=0){//说明已提交审核
                data_approve = 1;//是否显示右侧审核栏
                data_yl = 0;//是否为审核预览
            }

//        modelMap.addAttribute("item", item);
            ArrayList<Map> list = new ArrayList<>();
            if (item!=null && item.getTotalPage() > 1) {
                for (int i = 2; i<item.getTotalPage(); i ++) {
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


            modelMap.addAttribute("userGroup", userGroup);
            modelMap.addAttribute("ChannelID", ChannelID);
            modelMap.addAttribute("QRcode", QRcode);
            modelMap.addAttribute   ("fieldGroupArray_size", fieldGroupArray.size());
            modelMap.addAttribute("begin_time", begin_time/1000);
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
            for (int i = 0; i<fieldGroupArray.size(); i++) {
                HashMap<Object, Object> map = new HashMap<>();
                FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
                map.put("i", i);
                map.put("fieldGroup", fieldGroup);
                list1.add(map);
                map = null;
            }
            modelMap.addAttribute("list1", list1);
            int vercount = (!QRcode.equals(""))?fieldGroupArray.size()+2:fieldGroupArray.size()+1;
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
            do{
                HashMap<String, Object> map = new HashMap<>();



                String  padding="";
                FieldGroup fieldGroup = null;//字段分组
                int fieldGroupID = 0;
                if(fieldGroupArray.size()>0)
                {
                    fieldGroup = (FieldGroup) fieldGroupArray.get(j);
                    fieldGroupID = fieldGroup.getId();
                }
                map.put("fieldGroup", fieldGroup);


                String url = "";
                if(fieldGroupArray.size()>0 && fieldGroup.getUrl().length()>0)
                {
                    url = fieldGroup.getUrl();
                    url = url.replace("$globalid",GlobalID+"");
                    url = url.replace("$itemid",ItemID+"");
                    url = url.replace("$channelid",ChannelID+"");
                    boolean b = url.contains("?");
                    String c = "";
                    if(!url.contains("itemid="))
                        c += "&itemid=" + ItemID;
                    if(!url.contains("globalid="))
                        c += "&globalid=" + GlobalID;
                    c += "&channelid=" + ChannelID+"&fieldgroup="+(j+1);
                    url += ((b)?"":"?") + c;
                }
                if(fieldGroupID>0 && !fieldGroup.getUrl().equals(""))
                {
                    padding="clear-padding";
                }else{
                    padding="";
                }

                map.put("url", url);
                map.put("j", j);
                map.put("padding", padding);
                map.put("fieldGroupID", fieldGroupID);
                String fieldGroupUrl = fieldGroup.getUrl();
                map.put("fieldGroupUrl", fieldGroupUrl);

                if(fieldGroupID>0 && !fieldGroup.getUrl().equals("")){
                } else {
                    Field field_title = channel.getFieldByFieldName("Title");
                    map.put("field_title", field_title);
                    int length = field_title.getJS().length();
                    map.put("length", length);

                    if(editCategory){
                        map.put("editCategory_bol", true);

                        ArrayList categorys = channel.listAllSubChannels(Channel.Category_Type);
                        ArrayList<Object> list3 = new ArrayList<>();
                        if(categorys!=null && categorys.size()>0){
                            map.put("categorys_isExist", true);
                            for(int i = 0;i<categorys.size();i++){
                                HashMap<Object, Object> map1 = new HashMap<>();
                                Channel subcategory = (Channel)categorys.get(i);
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
                    }else{
                        map.put("editCategory_bol", false);
                    }
                }

                ArrayList arraylist = channel.getFieldsByGroup(fieldGroupID,j);
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
                        if(field.getName().equalsIgnoreCase("Content")){
                            map1.put("nameEqualsContent", true);
                        }else{
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


                    if(item!=null){
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
            }while(j < fieldGroupArray.size());
            modelMap.addAttribute("list2", list2);
            modelMap.addAttribute("data_approve", data_approve);
            modelMap.addAttribute("data_yl", data_yl);

            String title1 = item != null ? Util.HTMLEncode(item.getValue("Title")) : "";
            modelMap.addAttribute("title1", title1);
            modelMap.addAttribute("editCategory", editCategory);

            modelMap.addAttribute("j", j);
            modelMap.addAttribute("fieldGroupArraySize;", fieldGroupArray.size()+1);
            modelMap.addAttribute("From;", From);
            modelMap.addAttribute("parentGlobalID;", parentGlobalID);
            modelMap.addAttribute("ContinueNewDocument;", ContinueNewDocument);
            modelMap.addAttribute("userinfo_session",userinfo_session);
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
        modelAndView.setViewName("content_document/issuedManagementDocument");

        return modelAndView;
    }
}
