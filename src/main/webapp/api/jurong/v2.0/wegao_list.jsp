<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.*,
                tidemedia.cms.user.*,
                tidemedia.cms.util.*,
                java.sql.*,
                org.json.*,
                java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%@ include file="include/config.jsp"%>
<%@ include file="../../../approve/approve_config.jsp"%>

<%
    //审核列表

    String pageName = request.getServletPath();
    int pindex = pageName.lastIndexOf("/");
    if(pindex!=-1){
        pageName = pageName.substring(pindex+1);
    }

    JSONObject json = new JSONObject();

    int type = getIntParameter(request,"type");//状态 1待我审核的，2我审核通过的
    if(type==0){
        type=1 ;
    }
    int column_id = getIntParameter(request,"column_id");//栏目编号
    int data_type = getIntParameter(request,"data_type");//类型 1.稿件，2.选题
    int status = getIntParameter(request,"status");//状态 1审核通过
    int pages= getIntParameter(request,"page");//页码
    int pagesize = getIntParameter(request,"pagesize");
    if(data_type==0) data_type = 2;
    if(pages<1) pages = 1;
    if(pagesize<=0) pagesize = 20;

    String style2="";
    String style1="";
    if(type==1){
        style1="active";
    }
    if(type==2){
        style2="active";
    }

    JSONArray arr = new JSONArray();
    String ChannelIds = getChannel(userinfo_session);
    String sql = "select * from item_snap where Active=1 and ChannelID in("+ChannelIds+")";
    String sql_count = "select count(*) from item_snap where Active=1 and ChannelID in("+ChannelIds+")";
    if(type!=0){
        sql += " and Status="+(type-1);
        sql_count += " and Status="+(type-1);
    }
    sql += " order by GlobalID desc ";
    System.out.println("审核例表："+sql);
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.List(sql,sql_count,pages,pagesize);
    int num = tu.pagecontrol.getRowsCount();
    JSONArray array=new JSONArray();
    while(rs.next()){
        int GlobalID = rs.getInt("GlobalID");
        //int id_ = rs.getInt("id");
        int childId = rs.getInt("ChannelID");
        int status2 = rs.getInt("Status") ;

        String status_ = "";//任务状态
        if(status2==0){
            status_ = "未审核";
        }else if(status2==1){
            status_ = "审核通过";
        }
        Channel child = new Channel(childId);

        String childPath = child.getParentChannelPath();

        Document doc = new Document(GlobalID);
        String UserName = doc.getUserName();
        int ModifiedUser = doc.getModifiedUser();
        String reviewer = CmsCache.getUser(ModifiedUser).getName();
        String review_date = Util.FormatTimeStamp("", rs.getLong("PublishDate"));
        String url = doc.getHref("app");//稿件地址
        if(url.equals("")||url.equals("/")){
            url = doc.getContent();
        }


        String approve_status = "未提交审核";
        ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
        int id_aa = approve.getId();//审核操作id
        int approveId = approve.getApproveId();//审核环节id }

        int action  = approve.getAction();//是否通过
        int end = approve.getEndApprove();//是否终审
        int editables = 0;

        JSONObject json1 = null;
        if(id_aa!=0){//说明已配置审核环节
            ApproveItems ai = new ApproveItems(approveId);//审核环节
            review_date =approve.getCreateDate();
            review_date=Util.FormatDate("yyyy-MM-dd HH:mm:ss",review_date);


            if(approveId==0){//审核环节编号为0，此文章状态为提交审核
                json1 = ai.getApproveName(child.getApproveScheme());
                approve_status = json1.get("ApproveName")+"待审核";
                editables = (int) json1.get("Editable");
            }else{
                json1 = ai.getApproveName(0);
                approve_status = json1.get("ApproveName")+"待审核";
                editables = (int) json1.get("Editable");
                int type2 = ai.getType();
                String userIds = ai.getUsers();

                if(!userIds.equals("")){
                    String[] users = userIds.split(",");
                    JSONObject json3 = getUserNames(users,getAction(GlobalID),GlobalID,ai.getId());
                    int size = json3.getInt("size");
                    if(type2==1){//并签要判断其他人是否审核通过
                        if(size>0){
                            approve_status = approve.getApproveName()+"待审核";
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

        JSONObject o = new JSONObject();
        String Title=convertNull(rs.getString("Title"));
        String publish_date=Util.FormatTimeStamp("", rs.getLong("CreateDate"));
        o.put("publisher",UserName);//发起人
        String summary=doc.getSummary();//摘要
        o.put("status_",status_);
        o.put("approve_status",approve_status);
        o.put("title",Title);
        o.put("review_date",review_date);
        o.put("reviewer",reviewer);
        o.put("childPath",childPath);
        o.put("GlobalID",GlobalID);
        o.put("publish_date",publish_date);
        o.put("num",num);
        arr.put(o);
    }
    tu.closeRs(rs);
    json.put("result",arr);
    out.print(json);

%>

<%!
    //租户频道
    public String getChannel(UserInfo userinfo){
        int parent = 0 ;
        String parents="";
        try{
            TableUtil tu = new TableUtil();
            String sql = "";
            int company = userinfo.getCompany();//关联的租户编号
            Channel channel = ChannelUtil.getApplicationChannel("shengao");
            int channelid = channel.getId() ;//频道编号
            if(company!=0){//用户关联了租户
                sql = "select id from channel where parent="+channelid+" and company="+company;
                ResultSet rs = tu.executeQuery(sql);
                if(rs.next()){
                    parent = rs.getInt("id");
                }
                tu.closeRs(rs);
            }else{
                parent = channelid ;
            }
            String sql2 = "select id from channel where parent="+parent;
            TableUtil tu2 = new TableUtil();
            ResultSet rs2 = tu2.executeQuery(sql2);
            int  catgrey=0;
            System.out.println("sql2:"+sql2);
            while (rs2.next()){
                catgrey = rs2.getInt("id");
                parents+=catgrey+",";
                System.out.println("parents:"+parents);

            }
            tu2.closeRs(rs2);
            parents=parents+parent;
        }catch(Exception e){
            e.printStackTrace();
        }
        return  parents;
    }

%>
