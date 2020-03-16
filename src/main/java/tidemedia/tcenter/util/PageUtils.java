package tidemedia.tcenter.util;

import org.springframework.ui.ModelMap;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelPrivilegeItem;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Tree;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.Util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.util.*;

import static tidemedia.cms.util.Util2.convertNull;

public class PageUtils {

    public static ModelMap getListModelMap(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, List<String> additionaCustomList) throws Exception {
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
        int ApproveScheme = channel.getApproveScheme();

        if(ApproveScheme!=0){
//            response.sendRedirect("../approve/content_approve.jsp?id="+id);
            response.sendRedirect("../default/approvePreview?id="+id);
            return null;
        }
//        else {
//
//            //
//            response.sendRedirect("../default/content2018?id=" + id);
//        }

        //
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
//        logger.info("cols 列为: " + cols);
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
            if (additionaCustomList != null && additionaCustomList.size() > 0){
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

        return modelMap;
    }
    /**
     * 定制 ftl 页面字段新增解析
     * @param additionaCustomList
     * @return
     * @throws Exception
     */
    private static String getListByByCustom(List<String> additionaCustomList) throws Exception{
        String customs = "";
        if (additionaCustomList != null && additionaCustomList.size() > 0) {
            for(String custom : additionaCustomList) {
                customs += "," + custom;
            }
        }
        return customs;
    }
}
