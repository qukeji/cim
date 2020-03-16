<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 tidemedia.cms.user.*,
                 java.util.*,
                 org.json.*,
                 java.sql.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%@ include file="../approve/approve_config.jsp" %>
<%
    int typeo = getIntParameter(request, "type");
    Channel task_doc = ChannelUtil.getApplicationChannel("task_doc");
    int channelid = task_doc.getId();
    if(userinfo_session.getCompany()!=0){
        channelid = new Tree().getChannelID(channelid,userinfo_session);
    }
    int userid = userinfo_session.getId();
    Integer status = getIntParameter(request, "status");
    Channel channel = CmsCache.getChannel(channelid);
    if (!channel.hasRight(userinfo_session, 1)) {
        response.sendRedirect("../noperm.jsp");
        return;
    }
    String Table = channel.getTableName();
    String whereSql = " where Active=1 ";
    //String ListSql = "select id,Title,Photo,Weight,GlobalID,User,status,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews from " + Table;
    String ListSql = "select * from " + Table;
    if (userid != 0 && typeo != 1) {
        whereSql += " and User=" + userid;
    }
    if(userinfo_session.getCompany()!=0){
        whereSql += " and Category = "+channelid;
    }
    if (status != 0) {
        status = status - 1;
        whereSql += " and task_status=" + status;
    }
    whereSql += " order by ModifiedDate desc limit 10";
    ListSql += whereSql;

    System.out.println("task sql="+ListSql);
    String url = request.getRequestURL() + "";
    String base = url.replace(request.getRequestURI(), "");
    String ContextPath = request.getContextPath();
    TableUtil tu = new TableUtil();
    ResultSet Rs = tu.executeQuery(ListSql);
    int temp_gid = 0;
    String globalids = "";
    JSONObject jso = new JSONObject();
    JSONArray arr = new JSONArray();

    while (Rs.next()) {
        JSONObject jsonObject = new JSONObject();
        int id_ = Rs.getInt("id");
        int Status = Rs.getInt("Status");
        int task_status2 = Rs.getInt("task_status");
        String task_statusDesc = "";
        if (task_status2 == 0) {
            task_statusDesc = "<span class='tx-orange'>审核中</span>";
            //task_statusDesc="审核中";
        } else if (task_status2 == 1) {
            task_statusDesc = "<span class='tx-green'>审核通过</span>";
            //task_statusDesc="审核通过";
        } else if (task_status2 == 2) {
            task_statusDesc = "<span class='tx-danger'>审核未通过</span>";
            //task_statusDesc="审核未通过";
        } else if (task_status2 == 3) {
            task_statusDesc = "<span class='tx-green'>已完成</span>";
            //task_statusDesc="已完成";
        }
        int category = Rs.getInt("Category");
        int user = Rs.getInt("User");
        int active = Rs.getInt("Active");
        String Title = convertNull(Rs.getString("Title"));
        int IsPhotoNews = Rs.getInt("IsPhotoNews");
        int TopStatus = 0;
        String parentChannelPath2 = "";

        if (category > 0)
            Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
        parentChannelPath2 = CmsCache.getChannel(category).getParentChannelPath().replaceAll("/", ">");
        Channel channel2 = CmsCache.getChannel(category);
        String channelName = channel2.getName();

        int Weight = Rs.getInt("Weight");
        int GlobalID = Rs.getInt("GlobalID");

        Document doc = new Document(GlobalID);
        int ChannelID = doc.getChannelID();

        int cat_channelid = doc.getChannelID();
        if (temp_gid != 0) {
            globalids += ",";
        }
        temp_gid++;
        globalids += GlobalID + "";

        String approve_status = "未提交审核";
        ApproveAction approve = new ApproveAction(GlobalID, 0);//最近一次审核操作
        int id_aa = approve.getId();//审核操作id
        int approveId = approve.getApproveId();//审核环节id
        int action = approve.getAction();//是否通过
        int end = approve.getEndApprove();//是否终审
        int editables = 0;
        Document document = CmsCache.getDocument(GlobalID);
        JSONObject json1 = null;
        if (id_aa != 0) {//说明已配置审核环节
            ApproveItems ai = new ApproveItems(approveId);//审核环节
            if (approveId == 0) {//审核环节编号为0，此文章状态为提交审核
                json1 = ai.getApproveName(channel.getApproveScheme());
                approve_status = json1.get("ApproveName") + "待审核";
                editables = (int) json1.get("Editable");
            } else {
                json1 = ai.getApproveName(0);
                approve_status = json1.get("ApproveName") + "待审核";
                editables = (int) json1.get("Editable");
                int type = ai.getType();
                String userIds = ai.getUsers();

                if (!userIds.equals("")) {
                    String[] users = userIds.split(",");
                    JSONObject json = getUserNames(users, getAction(GlobalID), GlobalID, ai.getId());
                    int size = json.getInt("size");
                    if (type == 1) {//并签要判断其他人是否审核通过
                        if (size > 0) {
                            approve_status = approve.getApproveName() + "待审核";
                        }
                    }
                }

                if (action == 1) {//未通过
                    approve_status = approve.getApproveName() + "驳回";
                }
                if (action == 0 && end == 1) {
                    approve_status = approve.getApproveName() + "通过";
                }
            }

        }
        String path = base + ContextPath + "/content/document.jsp?ItemID=" + id_ + "&ChannelID=" + ChannelID;
        String CreateDate = Util.FormatTimeStamp("", Rs.getLong("CreateDate"));
        String ModifiedDate = convertNull(Rs.getString("ModifiedDate"));
        ModifiedDate = Util.FormatDate("yyyy-MM-dd HH:mm", ModifiedDate);
        String UserName = CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
        jsonObject.put("title", Title);
        jsonObject.put("category", category);
        //jsonObject.put("approve_status",approve_status);
        //jsonObject.put("ModifiedDate",ModifiedDate);
        jsonObject.put("date", CreateDate);
        //jsonObject.put("approve_status",approve_status);
        //jsonObject.put("approve_status",approve_status);
        jsonObject.put("id", id_);
        //jsonObject.put("GlobalID",GlobalID);
        //jsonObject.put("task_status2",task_status2);
        jsonObject.put("ChannelID", ChannelID);

        jsonObject.put("StatusDesc", task_statusDesc);
        jsonObject.put("channelPath", parentChannelPath2);
        jsonObject.put("channelName", channelName);
        jsonObject.put("user", UserName);
        jsonObject.put("path", path);
        jsonObject.put("type", 3);


        arr.put(jsonObject);
    }
    JSONArray jsonArray = new JSONArray();
    int count = getNumber(userid, channelid, 0);//
    int count2 = getNumber(userid, channelid, 1);//审核中
    int count3 = getNumber(userid, channelid, 2);//审核通过
    int count4 = getNumber(userid, channelid, 3);//审核未通过
    int count5 = getNumber(userid, channelid, 4);//已完成
    JSONObject jsonObject1 = new JSONObject();
    JSONObject jsonObject2 = new JSONObject();
    JSONObject jsonObject3 = new JSONObject();
    JSONObject jsonObject4 = new JSONObject();
    JSONObject jsonObject5 = new JSONObject();

    jsonObject1.put("lable", "全部");
    jsonObject1.put("data", count);
    jsonObject2.put("lable", "审核中");
    jsonObject2.put("data", count2);
    jsonObject3.put("lable", "审核通过");
    jsonObject3.put("data", count3);
    jsonObject4.put("lable", "审核未通过");
    jsonObject4.put("data", count4);
    jsonObject5.put("lable", "已完成");
    jsonObject5.put("data", count5);

    jsonArray.put(jsonObject1);
    jsonArray.put(jsonObject2);
    jsonArray.put(jsonObject3);
    jsonArray.put(jsonObject4);
    jsonArray.put(jsonObject5);

    jso.put("status", 200);
    jso.put("message", "成功");
    jso.put("moduleType", 5);
    jso.put("moduleIcon", "<i class='fa fa-star-o mg-r-10 tx-22'></i>");
    jso.put("moduleName", "我的选题");
    jso.put("name", "我的选题");
    jso.put("addJs", "siderightNewContent2(" + channelid + ")");
    jso.put("tablist", jsonArray);
    jso.put("result", arr);

    out.println(jso);

%>
<%!
    //查询数量;参数，频道id,问题状态，评价
    public int getNumber(int userid, int channelid, int probstatus) throws MessageException, SQLException {
        int num = 0;
        Channel channel = CmsCache.getChannel(channelid);

        String whereSql = " where Active=1 ";
        if (probstatus != 0) {
            int status3 = probstatus - 1;
            whereSql += " and status=" + probstatus;
        }
        if (userid != 0) {
            whereSql += " and User=" + userid;
        }

        String Sql = "select count(*) from " + channel.getTableName() + whereSql;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(Sql);
        if (rs.next())
            num = rs.getInt(1);
        tu.closeRs(rs);

        return num;
    }
%>
