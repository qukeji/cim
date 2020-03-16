<%@ page import="java.sql.*,
				 org.json.*,
				 java.util.*,
				 tidemedia.cms.system.*,
				 tidemedia.cms.base.*,
				 tidemedia.cms.user.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>

<%
    String users = getParameter(request, "users");
    String[] userIds = users.split(",");

    JSONObject o = new JSONObject();

    long begin_time = System.currentTimeMillis();

    int GroupID = getIntParameter(request, "GroupID");

    String groupName = "";
    if (GroupID != -1) {
        UserGroup group = new UserGroup(GroupID);
        groupName = group.getName();
    }

    TableUtil tu_user = new TableUtil("user");
    String ListSql = "select id,Role,Status,LastLoginDate,Name,Email,Username,UNIX_TIMESTAMP(ExpireDate) as ExpireDate from userinfo";
    String CountSql = "select count(*) from userinfo";
//当前登录用户的租户id
    int companyid = userinfo_session.getCompany();
    if (GroupID == 0) {
        ListSql += " where GroupID=0 or GroupID is null order by Role,id";
        CountSql += " where GroupID=0 or GroupID is null";
    } else if (GroupID == -1) {
        ListSql += "";
        CountSql += "";
    } else {
        ListSql += " where GroupID=" + GroupID;
        CountSql += " where GroupID=" + GroupID;
    }

    Document document = CmsCache.getDocument(1082859);//查询记者信息
    String content = document.getSummary();
    System.out.println(content);

    if (companyid != 0) {
        if (GroupID == -1) {
            ListSql += " where company=" + companyid + " order by Role,id";
            CountSql += " where company=" + companyid;
        } else {
            ListSql += " and company=" + companyid;
            CountSql += " and company=" + companyid;
        }
    }

    if(!content.equals("")){
        if(ListSql.contains("where")){
            ListSql+=" and id in ("+content+")";
        }else{
            ListSql+=" where id in ("+content+")";
        }
    }

    long nowdate = System.currentTimeMillis() / 1000;
    System.out.println("listsql="+ListSql);
    ResultSet Rs = tu_user.List(ListSql, CountSql, 1, 0);
    String html = "";
    if (tu_user.pagecontrol.getRowsCount() > 0) {

        int m = 0;
        while (Rs.next()) {
            String Name = convertNull(Rs.getString("Name"));
            int id = Rs.getInt("id");

            String checkbox = "";
            if (Arrays.asList(userIds).contains(id + "")) {
                checkbox = "checked";
            }

            if (m == 0) {
                html += "<div class=\"row ckbox-row\">";
            }
            m++;

            html += "<label class=\"ckbox mg-r-20\">";
            html += "<input name=\"id\" type=\"checkbox\" value=\"" + id + "\" describe=\"" + Name + "\" " + checkbox + "><span>" + Name + "</span>";
            html += "</label>";

            if (m == 3) {
                html += "</div>";
                m = 0;
            }
        }
        tu_user.closeRs(Rs);
    }

    o.put("html", html);
    o.put("groupName", groupName);

    out.println(o);
%>
