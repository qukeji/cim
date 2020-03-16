<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%@ include file="../approve/approve_config.jsp"%>
<%
    int channelid = getIntParameter(request,"channelid");//channelid
    channelid=16085;
    int userid = getIntParameter(request,"userid");//用户id
    Integer task_status = getIntParameter(request,"task_status");
    Channel channel = CmsCache.getChannel(channelid);
    String Table = channel.getTableName();
    String whereSql=" where Active=1 ";
    String ListSql = "select id,Title,Photo,Weight,GlobalID,User,task_status,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews from " + Table;
    if(userid!=0){
        whereSql+=" and User="+userid;
    }
   
    if(task_status!=null&&task_status!=0){
        Integer  task_status3=task_status-1;
        whereSql+=" and task_status="+task_status3;
    }
    whereSql+=" order by ModifiedDate desc limit 10";
    ListSql += whereSql;
    System.out.println(ListSql);
    TableUtil tu=new TableUtil();
    ResultSet Rs = tu.executeQuery(ListSql);
    int temp_gid=0;
    String globalids="";
    JSONArray jsonArray=new JSONArray();
  
    while(Rs.next()){
        JSONObject jsonObject=new JSONObject();
        int id_ = Rs.getInt("id");
        int Status = Rs.getInt("Status");
        int task_status2 = Rs.getInt("task_status");
        String task_statusDesc="";
        if(task_status2==0){
        task_statusDesc="审核中";
        }else if (task_status2==1){
            task_statusDesc="审核通过";
        }else if (task_status2==2){
            task_statusDesc="审核未通过";
        }else if(task_status2==3){
            task_statusDesc="已完成";
        }
        int category = Rs.getInt("Category");
        int user = Rs.getInt("User");
        int active = Rs.getInt("Active");
        String Title	= convertNull(Rs.getString("Title"));
        int IsPhotoNews = Rs.getInt("IsPhotoNews");
        int TopStatus = 0;
        String parentChannelPath2="";

        if(category>0)
            Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
        parentChannelPath2 = CmsCache.getChannel(category).getParentChannelPath().replaceAll("/",">");

        int Weight=Rs.getInt("Weight");
        int GlobalID=Rs.getInt("GlobalID");

        Document doc=new Document( GlobalID);
        int cat_channelid =doc.getChannelID();
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
        ModifiedDate=Util.FormatDate("yyyy-MM-dd HH:mm",ModifiedDate);
        String UserName	= CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
        jsonObject.put("Title",Title);
        jsonObject.put("approve_status",approve_status);
        jsonObject.put("ModifiedDate",ModifiedDate);
        jsonObject.put("approve_status",approve_status);
        jsonObject.put("approve_status",approve_status);
        jsonObject.put("id",id_);
        jsonObject.put("GlobalID",GlobalID);
        jsonObject.put("task_status2",task_status2);
        jsonObject.put("task_statusDesc",task_statusDesc);
        jsonObject.put("shipinma","en");
        jsonObject.put("parentChannelPath2",parentChannelPath2);


        jsonArray.put(jsonObject);
    }
    out.println(jsonArray.toString());

%>
