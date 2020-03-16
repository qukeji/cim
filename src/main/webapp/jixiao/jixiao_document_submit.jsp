<%@page import="java.util.Date" %>
<%@ page
        import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,java.text.*,java.sql.*,tidemedia.cms.base.*,org.json.*,tidemedia.cms.scheduler.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp" %>
<%
    /**
     * 用途：内容页提交程序
     * 1,李永海 20140101 创建
     * 2,此文件编码必须是ANSI
     * 3,
     * 4,
     * 5,
     */
    String Action = getParameter(request, "Action");
    if (!Action.equals("")) {
        int ChannelID = getIntParameter(request, "ChannelID");//当前频道id
        String RecommendChannelIDs = getParameter(request, "RecommendChannelIDs");//推荐到的频道id
        int close_window_type = getIntParameter(request, "Close_Window_Type");
        String RelatedItemsList = getParameter(request, "RelatedItemsList");
        String users_id = getParameter(request, "users_id");
        int ContinueNewDocument = getIntParameter(request, "ContinueNewDocument");
        int NoCloseWindow = getIntParameter(request, "NoCloseWindow");//不关闭窗口
        //int	AutoSave			= getIntParameter(request,"AutoSave");//自动保存

        int Approve = getIntParameter(request, "Approve");
        int ItemID = getIntParameter(request, "ItemID");

        String WeixinIds = getParameter(request, "WeixinIds");//目前只有一个公众号id

        Channel channel = CmsCache.getChannel(ChannelID);
        int gid = 0;
        HashMap map = new HashMap();
        Enumeration enumeration = request.getParameterNames();
        try {
            while (enumeration.hasMoreElements()) {
                String name = (String) enumeration.nextElement();
                String values[] = request.getParameterValues(name);
                String values2 = "";
                if (values != null) {
                    if (values.length == 1)
                        values2 = values[0];
                    else
                        values2 = Util.ArrayToString(values, ",");
                }
                if (name.equals("Content")) {
                    //处理热词
                    values2 = WordUtil.processHotword(values2);
                }

                map.put(name, values2);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        tidemedia.cms.system.Document document = new tidemedia.cms.system.Document();

        document.setRelatedItemsList(RelatedItemsList);
        document.setChannelID(ChannelID);
        document.setUser(userinfo_session.getId());
        document.setModifiedUser(userinfo_session.getId());
        //gid = document.getGlobalID();
        if (Action.equals("Add")) {//2013-07-15 15:41:34
            document.AddDocument(map);
        }
        if (Action.equals("Update")) {
            document.UpdateDocument(map);
        }
        int itemId = document.getId();

        //参与人员表入库
        TableUtil tu = new TableUtil();
        String sql1 = "delete from channel_jixiao_participant where jixiao_id = "+itemId;
        tu.executeUpdate(sql1);

        for (String user_id : users_id.split(",")){
            int userId = 0;
            if(!user_id.equals("")){
                userId = Integer.parseInt(user_id);
            }
            HashMap<String, String> map1 = new HashMap<>();
            map1.put("user_id", userId + "");
            map1.put("jixiao_id", itemId + "");
            map1.put("Title", CmsCache.getUser(userId).getName());
            ItemUtil.addItem(new JiXiaoUtil().JIXIAOPARTICIPANTID, map1);
        }

        gid = document.getGlobalID();
        tidemedia.cms.system.Document doc = new tidemedia.cms.system.Document(gid);
        int status = doc.getStatus();
        String title = doc.getValue("Title");
        if (Approve == 1 && gid != 0) {//提交审核
            ApproveAction aa = new ApproveAction();
            aa.setTitle(title);
            aa.setParent(gid);
            aa.setUserid(doc.getUser());
            aa.setAction(0);
            aa.setApproveId(0);
            aa.setEndApprove(0);
            aa.Add();

            int userId = userinfo_session.getId();
            String userName = userinfo_session.getName();
            int approveSchemeId = channel.getApproveScheme();
            String application1 = channel.getApplication();
            //稿件审核入库
            ApproveDocument appDocument = new ApproveDocument();
            appDocument.setUserId(userId);
            appDocument.setUserName(userName);
            appDocument.setTitle(title);
            appDocument.setGlobalID(gid);
            appDocument.setItemID(ItemID);
            appDocument.setChannelID(ChannelID);
            appDocument.setApproveItemId(0);
            appDocument.setAction(-1);
            appDocument.setApplication(application1);
            appDocument.Add();
            //下一审核环节入库
            ApproveDocument.next(gid, title, 0, ItemID, ChannelID, approveSchemeId, application1);

            Log l = new Log();
            l.setTitle(title);
            l.setUser(userId);
            l.setItem(ItemID);

            l.setLogAction(1600);
            l.setFromType("channel");
            l.setFromKey((new StringBuilder()).append(ChannelID).append("").toString());
            l.Add();

        }

        //一稿多发
        if (!RecommendChannelIDs.equals("")) {
            ChannelPrivilege cp = new ChannelPrivilege();
            String[] ids = Util.StringToArray(RecommendChannelIDs, ",");
            for (int i = 0; i < ids.length; i++) {
                int channelid_ = Util.parseInt(ids[i]);
                if (cp.hasRight(userinfo_session, channelid_, 2)) {
                    new Recommend().recommendOutItems(channelid_, itemId + "", ChannelID, status, userinfo_session.getId());
                }
            }
        }

        //一稿多发微信公众号文章入库推荐表
        if (!WeixinIds.equals("")) {
            String Weixin_uuid = UUID.randomUUID().toString().replaceAll("-", "");
            ChannelRecommend cr = new ChannelRecommend();
            //String accountid =  cr.findWeiXinAccountId(userinfo_session.getId());

            String sql = "insert into weixin_newsitem (author,content,description,title,create_date,accountid,isshow,leave_word,content_md5,ID)";
            sql += " values('" + userinfo_session.getName() + "','" + doc.getContent() + "','" + doc.getSummary() + "','" + doc.getTitle() + "',now(),'" + WeixinIds + "',0,0,'','" + Weixin_uuid + "')";
            tu.executeUpdate(sql);

            new Recommend().saveWeixinRecommend(gid, 0, ChannelID, itemId, userinfo_session.getId(), Weixin_uuid);
        }


        SetPublishJobUtil job = new SetPublishJobUtil();
        SetRemoveJobUtil job2 = new SetRemoveJobUtil();
        String spd = Util.convertNull(doc.getValue("SetPublishDate"));
        String spd2 = Util.convertNull(doc.getValue("Revoketime"));
        spd = spd.replace(".0", "");
        spd2 = spd2.replace(".0", "");
        if (status == 0 && spd != null && spd.length() > 0 && Util.getCalendar(spd, "yyyy-MM-dd HH:mm").getTimeInMillis() > System.currentTimeMillis()) {
            //必须是草稿状态 一次判断 不为null，length，时间
            System.out.println("执行定时发布");
            job.setPublishJob(gid);
        }
        if (spd2 != null && spd2.length() > 0 && Util.getCalendar(spd2, "yyyy-MM-dd HH:mm").getTimeInMillis() > System.currentTimeMillis()) {
            //必须是已发状态 一次判断 不为null，length，时间
            System.out.println("执行定时撤稿");
            job2.setPublishJob2(gid);
        }

        if (close_window_type == 0) close_window_type = 1;
        String message = document.getMessage();
        if (NoCloseWindow == 1) {
            //自动保存 不关闭窗口
            out.println("{\"id\":\"" + document.getId() + "\",\"channelid\":\"" + ChannelID + "\"}");
        } else {
            if (message.length() > 0) {
                out.println("{\"message\":\"" + message + "\"}");
            } else {
                out.println("{\"message\":\"\"}");
            }
        }
    }
%>
<%!
    public static String formatDate() {
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String format = simpleDateFormat.format(date);
        return format;
    }
%>
