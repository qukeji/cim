package tidemedia.cms.system;

import org.apache.commons.lang.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.Util;

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author 作者 E-mail:
 * @version 创建时间：2019年7月23日 下午5:12:22
 * 类说明
 */
public class ApproveDocument extends Table {

    private int id;
    private int UserId;
    private String UserName;
    private String Title = "";//审核文章名称judge
    private int GlobalID;//审核文章编号globalid
    private int ItemID;//稿件ID
    private int ChannelID;//频道ID
    private int ApproveItemId;//审核环节编号
    private String ApproveItemName = "";//审核环节名称
    private int Action;//审核动作-1不需要操作0等待操作1执行了通2执行了驳回
    private String CreateDate = "";//提交审核时间
    private String ActionDate = "";//审核操作时间
    private String ActionMessage = "";//审核驳回理由
    private int EndApprove;//是否是终审
    private String application;//审核类型  频道application

    public ApproveDocument() throws MessageException, SQLException {
        super();
    }

    public ApproveDocument(int id) throws SQLException, MessageException {
        String Sql = "";

        Sql = "select * from approve_document where id=" + id;

        ResultSet Rs = executeQuery(Sql);
        if (Rs.next()) {
            setId(Rs.getInt("id"));
            setUserId(Rs.getInt("UserId"));
            setUserName(convertNull(Rs.getString("UserName")));
            setTitle(convertNull(Rs.getString("Title")));
            setGlobalID(Rs.getInt("GlobalID"));
            setItemID(Rs.getInt("ItemID"));
            setChannelID(Rs.getInt("ChannelID"));
            setApproveItemId(Rs.getInt("ApproveItemId"));
            setApproveItemName(convertNull(Rs.getString("ApproveItemName")));
            setAction(Rs.getInt("Action"));
            setCreateDate(convertNull(Rs.getString("CreateDate")));
            setActionDate(convertNull(Rs.getString("ActionDate")));
            setActionMessage(convertNull(Rs.getString("ActionMessage")));
            setEndApprove(Rs.getInt("EndApprove"));
            setApplication(convertNull(Rs.getString("application")));
            closeRs(Rs);
        } else {
            closeRs(Rs);
        }
    }

    public ApproveDocument(String title, int globalID, int itemID, int channelID, String approveItemName, int action, String createDate) throws MessageException, SQLException {
        Title = title;
        GlobalID = globalID;
        ItemID = itemID;
        ChannelID = channelID;
        ApproveItemName = approveItemName;
        Action = action;
        CreateDate = createDate;
    }

    //根据用户ID，审核环节ID，稿件全局ID，审核状态获取唯一稿件审核对象
    public ApproveDocument(int UserId, int ApproveId, int GlobalID, int Action) throws SQLException, MessageException {
        String Sql = "";

        Sql = "select * from approve_document where UserId=" + UserId + " and ApproveItemId=" + ApproveId + " and GlobalID=" + GlobalID + " and Action=0";

        ResultSet Rs = executeQuery(Sql);
        if (Rs.next()) {
            setId(Rs.getInt("id"));
            setUserId(Rs.getInt("UserId"));
            setUserName(convertNull(Rs.getString("UserName")));
            setTitle(convertNull(Rs.getString("Title")));
            setGlobalID(Rs.getInt("GlobalID"));
            setItemID(Rs.getInt("ItemID"));
            setChannelID(Rs.getInt("ChannelID"));
            setApproveItemId(Rs.getInt("ApproveItemId"));
            setApproveItemName(convertNull(Rs.getString("ApproveItemName")));
            setAction(Rs.getInt("Action"));
            setCreateDate(convertNull(Rs.getString("CreateDate")));
            setActionDate(convertNull(Rs.getString("ActionDate")));
            setActionMessage(convertNull(Rs.getString("ActionMessage")));
            setEndApprove(Rs.getInt("EndApprove"));
            setApplication(convertNull(Rs.getString("application")));
            closeRs(Rs);
        } else {
            closeRs(Rs);
        }
    }

    @Override
    public void Add() throws SQLException, MessageException {
        String Sql = "";
        Sql = "insert into approve_document (";

        Sql += "UserId,UserName,Title,GlobalID,ItemID,ChannelID,ApproveItemId,ApproveItemName,Action,CreateDate,ActionMessage,EndApprove,application";
        Sql += ") values(";
        Sql += "" + UserId + "";
        Sql += ",'" + SQLQuote(UserName) + "'";
        Sql += ",'" + SQLQuote(Title) + "'";
        Sql += "," + GlobalID + "";
        Sql += "," + ItemID + "";
        Sql += "," + ChannelID + "";
        Sql += "," + ApproveItemId + "";
        Sql += ",'" + SQLQuote(ApproveItemName) + "'";
        Sql += "," + Action + "";
        Sql += ",now()";
        Sql += ",'" + SQLQuote(ActionMessage) + "'";
        Sql += "," + EndApprove + "";
        Sql += ",'" + SQLQuote(application) + "'";
        Sql += ")";
        int insertId = executeUpdate_InsertID(Sql);
        setId(insertId);
    }

    @Override
    public void Update() throws SQLException, MessageException {

        String Sql = "";

        Sql = "update approve_document set ";
        Sql += "UserId=" + UserId + ",";
        Sql += "UserName='" + SQLQuote(UserName) + "',";
        Sql += "Title='" + SQLQuote(Title) + "',";
        Sql += "GlobalID=" + GlobalID + ",";
        Sql += "ItemID=" + ItemID + ",";
        Sql += "ChannelID=" + ChannelID + ",";
        Sql += "ApproveItemId=" + ApproveItemId + ",";
        Sql += "ApproveItemName='" + SQLQuote(ApproveItemName) + "',";
        Sql += "Action=" + Action + ",";
        Sql += "ActionDate='" + SQLQuote(ActionDate) + "',";
        Sql += "ActionMessage='" + SQLQuote(ActionMessage) + "',";
        Sql += "EndApprove=" + EndApprove + ",";
        Sql += "application='" + SQLQuote(application) + "'";
        Sql += " where id=" + id;

        executeUpdate(Sql);
    }

    @Override
    public void Delete(int id) throws SQLException, MessageException {

        String Sql = "";
        Sql = "delete from approve_document where id=" + id;

        TableUtil tu = new TableUtil();
        tu.executeUpdate(Sql);
    }

    //根据gid删除
    public static void DeleteByGid(String gids) throws SQLException, MessageException {
        String Sql = "";
        Sql = "delete from approve_document where GlobalID in (" + gids + ")";
        TableUtil tu = new TableUtil();
        tu.executeUpdate(Sql);
    }

    //根据channelId,itemID删除
    public static void DeleteByCAI(String ItemIds, int channelID) throws SQLException, MessageException {
        String Sql = "";
        Sql = "delete from approve_document where ChannelID = " + channelID + " and ItemID in (" + ItemIds + ")";
        TableUtil tu = new TableUtil();
        tu.executeUpdate(Sql);
    }

    //根据channelId删除
    public static void DeleteByChannel(int channelID) throws SQLException, MessageException {
        String Sql = "";
        Sql = "delete from approve_document where ChannelID = " + channelID;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(Sql);
    }

    //下一审核环节信息入库
    public static void next(int gid, String title, int approveId, int itemID, int channelID, int approveSchemeId, String application) throws SQLException, MessageException, JSONException {
        ApproveItems approve_item = new ApproveItems();
        if (approveId == 0) {
            approve_item = new ApproveItems();
        } else {
            approve_item = new ApproveItems(approveId);
        }
        JSONObject json = new JSONObject();
        json = approve_item.getApproveName(approveSchemeId);
        int approveItemId = json.getInt("approveItemId");
        ApproveItems approveItems = new ApproveItems(approveItemId);
        if (approveItems != null) {
            String user1 = approveItems.getUsers();
            String approveName = approveItems.getTitle();
            if (user1 != null && user1.length() > 0) {
                String[] userArray = user1.split(",");
                for (String userString : userArray) {
                    if ( !"".equals(userString)) {
                        int userId = Integer.parseInt(userString);
                        String userName = CmsCache.getUser(userId).getName();
                        ApproveDocument appDocument2 = new ApproveDocument();
                        appDocument2.setUserId(userId);
                        appDocument2.setUserName(userName);
                        appDocument2.setTitle(title);
                        appDocument2.setGlobalID(gid);
                        appDocument2.setItemID(itemID);
                        appDocument2.setChannelID(channelID);
                        appDocument2.setApproveItemId(approveItemId);
                        appDocument2.setApproveItemName(approveName);
                        appDocument2.setAction(0);
                        appDocument2.setActionMessage("");
                        appDocument2.setCreateDate(Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
                        appDocument2.setApplication(application);
                        appDocument2.Add();
                    }
                }
            }
            HashMap map = new HashMap();
            int ApproveStatus = json.getInt("step");
            if(ApproveStatus!=0){
                map.put("ApproveStatus",ApproveStatus+"");
                ItemUtil.updateItemByGid(channelID,map,gid,1);
            }

        }
    }

    //获取该稿件此环节未进行审核的用户组
    public static String getPermUser(int globalId, int approveId) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql = "select UserId from approve_document where GlobalID = " + globalId + " and ApproveItemId = " + approveId + " and action = 0";
        ResultSet rs = tu.executeQuery(sql);
        String users = "";
        while (rs.next()) {
            if (users.length() > 0) {
                users += "," + rs.getInt("UserId");
            } else {
                users += rs.getInt("UserId");
            }
        }
        tu.closeRs(rs);
        return users;
    }

    //审核操作
    public static void approveSubmit(int action, int userid, int approveId, int gid, String actionMessage, int endApprove, int type, String[] users, String title) throws SQLException, MessageException, JSONException {

        ApproveItems approve_item = new ApproveItems(approveId);
        int logAction = 0;
        String approve_Name = approve_item.getTitle();
        if (action == 0) {//符合稿件审核标准
            action = 1;
            approve_Name = approve_Name + "通过_" + title;
            logAction = 1602;
        } else if (action == 1) {
            action = 2;
            approve_Name = approve_Name + "驳回_" + title;
            logAction = 1601;
        }

        String sql = "select id from approve_document where UserId =" + userid + " and GlobalID =" + gid + " and ApproveItemId = " + approveId + " order by CreateDate desc limit 1";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        int id = 0;
        if (rs.next()) {//修改自身稿件审核状态
            id = rs.getInt("id");
            String updateSql = "update approve_document set ActionDate = now(),action = " + action + ",ActionMessage = '" + actionMessage + "',EndApprove = " + endApprove + " where id = " + id;
            tu.executeUpdate(updateSql);
        }
        tu.closeRs(rs);
        ApproveDocument appDocument = new ApproveDocument(id);
        String actionDate = appDocument.getActionDate();
        String application = appDocument.getApplication();
        int channelID2 = appDocument.getChannelID();
        int itemID2 = appDocument.getItemID();
        boolean isNextAdd = true;//下一审核环节是否入库
        HashMap map = new HashMap();
        if (action == 1) {//通过
            if (type == 0) {//或签
                updateStatus(users, userid, approveId, gid, actionDate);
            } else {//并签
                int hasOP = appDocument.noOpUser();//判断是否还有等待审核的用户
                if (hasOP == 1)//有
                    isNextAdd = false;
            }

            if (isNextAdd) {
                next(gid, title, approveId, itemID2, channelID2, 0, application);
            }
            if(endApprove==1){//终审
                System.out.println("终审100");
                //修改审核状态为0
                map.put("ApproveStatus",100+"");
                ItemUtil.updateItemByGid(channelID2,map,gid,1);
            }
        } else {//驳回
            updateStatus(users, userid, approveId, gid, actionDate);
            //修改审核状态为0
            map.put("ApproveStatus",0+"");
            ItemUtil.updateItemByGid(channelID2,map,gid,1);
        }

        Log l = new Log();
        l.setTitle(approve_Name);
        l.setUser(userid);
        l.setItem(itemID2);

        l.setLogAction(logAction);
        l.setFromType("channel");
        l.setFromKey((new StringBuilder()).append(channelID2).append("").toString());
        l.Add();
    }

    //是否有等待操作用户
    public int noOpUser() throws SQLException, MessageException {
        String sql = "select UserId from approve_document where ApproveItemId = " + ApproveItemId + " and UserId != " + UserId + " and GlobalID = " + GlobalID + " and Action = 0";
        ResultSet Rs = executeQuery(sql);
        int i = 0;
        if (Rs.next()) {
            i = 1;
        }
        closeRs(Rs);
        return i;
    }

    //修改同一环节其他用户action状态为不用操作
    public static void updateStatus(String[] users, int userid, int approveId, int gid, String actionDate) throws SQLException, MessageException {
        String user = StringUtils.join(users, ",");
        String sql = "update approve_document set ActionDate = '" + actionDate + "',Action = -1 where GlobalID = " + gid + " and ApproveItemId = " + approveId + " and UserId in (" + user + ") and UserId != " + userid;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(sql);
    }

    //根据用户id，审核状态，审核类型返回审核稿件
    public JSONObject getMyApprove(String approveItemIds, int UserId, int status, HttpServletRequest request, String application, int pagenum, int pagesize, String S_Title, String S_startDate, String S_endDate) throws SQLException, MessageException, JSONException {
        JSONObject object = new JSONObject();
        JSONArray jsonArray = new JSONArray();
        if (pagenum < 1)
            pagenum = 1;
        if (pagesize <= 0)
            pagesize = 20;
        int beginNum = (pagenum - 1) * pagesize;
        String sql = "select max(id) id from approve_document where 1 = 1";
        String sql1 = "select count(DISTINCT GlobalID) sum from approve_document where 1 = 1";
        if (UserId != 0) {
            sql += " and UserId = " + UserId;
            sql1 += " and UserId = " + UserId;
        }
        if (status == 0) {
            sql += " and Action > -1";
            sql1 += " and Action > -1";
        } else {
            sql += " and Action = " + (status - 1);
            sql1 += " and Action = " + (status - 1);
        }
        if (application.length() > 0) {
            sql += " and application = '" + application + "'";
            sql1 += " and application = '" + application + "'";
        }
        if (approveItemIds.length() > 0) {
            approveItemIds = "(" + approveItemIds + ")";
            sql += " and ApproveItemId in " + approveItemIds;
            sql1 += " and ApproveItemId in " + approveItemIds;
        }
        if (!S_Title.equals("")) {
            String tempTitle = S_Title.replaceAll("%", "\\\\%");
            sql += " and Title like '%" + this.SQLQuote(tempTitle) + "%'";
            sql1 += " and Title like '%" + this.SQLQuote(tempTitle) + "%'";
        }
        if (!S_startDate.equals("") && !S_endDate.equals("")) {
            sql += " and CreateDate between '" + S_startDate + "' and '" + S_endDate + "'";
            sql1 += " and CreateDate between '" + S_startDate + "' and '" + S_endDate + "'";
        }
        sql += " group by GlobalID order by id desc";
        if (pagenum != 0 && pagesize != 0) {
            sql += " limit " + beginNum + "," + pagesize;
        }
        TableUtil tu = new TableUtil();//建立JDBC对象
        ResultSet rs = tu.executeQuery(sql);
        ResultSet rs1 = tu.executeQuery(sql1);
        int totalNumber = 0;
        while(rs1.next()){
            totalNumber = rs1.getInt("sum");
        }
        rs1.close();
        String url = request.getRequestURL() + "";
        String base = url.replace(request.getRequestURI(), "");
        String ContextPath = request.getContextPath();
        List<Integer> list = new ArrayList<>();
        while(rs.next()){
            int id = rs.getInt("id");
            list.add(id);
        }
        for (int i = 0; i < list.size(); i++) {
            Integer id =  list.get(i);
            ApproveDocument approveDocument = new ApproveDocument(id);
            int globalID = approveDocument.getGlobalID();
            Document document = CmsCache.getDocument(globalID);
            int ItemID = document.getId();
            int ChannelID = document.getChannelID();
            String ApproveItemName = approveDocument.getApproveItemName();
            String Title = document.getTitle();
            int Action1 = approveDocument.getAction();
            String approveStatus = "";
            if (Action1 == 0) {
                approveStatus = "<span class='tx-orange'>" + ApproveItemName + "待审核<span>";
            } else if (Action1 == 1) {
                approveStatus = "<span class='tx-success'>" + ApproveItemName + "通过</span>";
            } else {
                approveStatus = "<span class='tx-danger'>" + ApproveItemName + "驳回<span>";
            }
            int category = document.getCategoryID();
            int active = document.getActive();
            if (active != 1) {
                totalNumber--;
                continue;
            }
            String CreateDate = document.getCreateDate();
            String UserName = document.getUserName();
            int Status = document.getStatus();
            String documentStatus = "";
            if (Status == 0) {
                documentStatus = "<span class='tx-orange'>草稿</span>";
            } else {
                documentStatus = "<span class='tx-success'>已发</span>";
            }
            Channel channel = CmsCache.getChannel(ChannelID);
            String channelName = channel.getName();
            String parentChannelPath = channel.getParentChannelPath().replaceAll("/", ">");
            String path = base + ContextPath + "/content/document.jsp?ItemID=" + ItemID + "&ChannelID=" + ChannelID;
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("title", Title);
            jsonObject.put("GlobalID", globalID);
            jsonObject.put("id", ItemID);
            jsonObject.put("ChannelID", ChannelID);
            jsonObject.put("ApproveItemName", ApproveItemName);
            jsonObject.put("Action1", Action1);
            jsonObject.put("date", CreateDate);
            jsonObject.put("documentStatus", documentStatus);
            jsonObject.put("StatusDesc", approveStatus);
            jsonObject.put("channelPath", parentChannelPath);
            jsonObject.put("channelName", channelName);
            jsonObject.put("path", path);
            jsonObject.put("category", category);
            jsonObject.put("user", UserName);
            jsonObject.put("type", 2);
            jsonArray.put(jsonObject);
        }
        tu.closeRs(rs);
        int totalPageNumber = 0;
        if (totalNumber <= pagesize) {
            totalPageNumber = 1;
        }else{
            totalPageNumber = totalNumber / pagesize;
            if (totalNumber % pagesize > 0) {
                totalPageNumber++;
            }
        }
        object.put("list", jsonArray);
        object.put("sum", totalNumber);
        object.put("pageNum", totalPageNumber);
        return object;
    }

    //查询数量;参数，频道id,问题状态，评价
    public int getNumber(int userid, int status) throws MessageException, SQLException {
        int num = 0;
        String sql = "";
        if (status == 0) {
            sql = "select count(*) from approve_document where UserId =" + userid + " and Action > -1  ";
        } else {
            sql = "select count(*) from  approve_document where UserId =" + userid + " and Action = " + (status - 1);
        }
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next()) {
            num = rs.getInt(1);
        }
        tu.closeRs(rs);
        return num;
    }

    @Override
    public boolean canAdd() {

        return false;
    }

    @Override
    public boolean canUpdate() {

        return false;
    }

    @Override
    public boolean canDelete() {

        return false;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return UserId;
    }

    public void setUserId(int userId) {
        UserId = userId;
    }

    public String getUserName() {
        return UserName;
    }

    public void setUserName(String userName) {
        UserName = userName;
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String title) {
        Title = title;
    }

    public int getGlobalID() {
        return GlobalID;
    }

    public void setGlobalID(int globalID) {
        GlobalID = globalID;
    }

    public int getItemID() {
        return ItemID;
    }

    public void setItemID(int itemID) {
        ItemID = itemID;
    }

    public int getChannelID() {
        return ChannelID;
    }

    public void setChannelID(int channelID) {
        ChannelID = channelID;
    }

    public int getApproveItemId() {
        return ApproveItemId;
    }

    public void setApproveItemId(int approveItemId) {
        ApproveItemId = approveItemId;
    }

    public String getApproveItemName() {
        return ApproveItemName;
    }

    public void setApproveItemName(String approveItemName) {
        ApproveItemName = approveItemName;
    }

    public int getAction() {
        return Action;
    }

    public void setAction(int action) {
        Action = action;
    }

    public String getCreateDate() {
        return CreateDate;
    }

    public void setCreateDate(String createDate) {
        CreateDate = createDate;
    }

    public String getActionDate() {
        return ActionDate;
    }

    public void setActionDate(String actionDate) {
        ActionDate = actionDate;
    }

    public String getActionMessage() {
        return ActionMessage;
    }

    public void setActionMessage(String actionMessage) {
        ActionMessage = actionMessage;
    }

    public int getEndApprove() {
        return EndApprove;
    }

    public void setEndApprove(int endApprove) {
        EndApprove = endApprove;
    }

    public String getApplication() {
        return application;
    }

    public void setApplication(String application) {
        this.application = application;
    }
}
