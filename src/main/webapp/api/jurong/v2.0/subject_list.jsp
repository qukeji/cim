<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%@ include file="../../../approve/approve_config.jsp"%>

<%
    //选题列表，只给选题使用 20190711，里面混杂的有文稿代码
%>
<%!
    //状态，选题栏目编号，类型，用户编号
    public HashMap<String, Object> getList(int type,int column_id,int data_type_,int status,int userId,int pages,int pagesize){

        HashMap<String, Object> map = new HashMap<String, Object>() ;

        try{

            if(type==0||data_type_==0){

                map.put("status",501);
                map.put("message","参数缺少");

            }else{
                TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
                int channel_reason = jurong.getInt("review_reason");//审核结果频道编号
                Channel channel_review = ChannelUtil.getApplicationChannel("task_doc");
                int channelid = channel_review.getId() ;//选题频道编号

                if(data_type_==1){//稿件
                }else if(data_type_==2){//选题
                    map = getTopicList(type,column_id,data_type_,status,userId,channelid,channel_reason,pages,pagesize);
                }
            }
        }catch(Exception e){
            map.put("status",500);
            map.put("message","程序异常"+e.toString());
            e.printStackTrace();
        }
        return map ;
    }
    //选题列表
    public HashMap<String, Object> getTopicList(int type,int column_id,int data_type_,int status1,int userId,int parent_column,int channel_reason,int pages,int pagesize){

        HashMap<String, Object> map = new HashMap<String, Object>() ;

        try{
            JSONArray jsonArr = new JSONArray();
            map.put("status",200);
            map.put("message","成功");

		/* 20190701
		String ChannelIds = getUserChannelString( userId, parent_column, data_type_);//用户频道权限
		if(ChannelIds.equals("")){//无权限
			map.put("result",jsonArr);
			map.put("num",0);
			return map ;
		}*/

            String whereSql = " where Active=1";
            if(type==3) type = 0 ;
            if(type==1){
                whereSql += " and task_status=0";
            }else if(type==2){
                whereSql += " and task_status!=0";
            }
            if(status1!=0){
                whereSql += " and task_status="+status1;
            }
            if(column_id!=0){//说明指定了某个子频道
                whereSql += " and Category="+column_id;
            }else{
                //whereSql += " and Category in ("+ChannelIds+")";
            }

            Channel channel = CmsCache.getChannel(parent_column);
            String sql = "select id from " + channel.getTableName() + whereSql + " order by id desc";
            String sql_count = "select count(*) from " + channel.getTableName() + whereSql ;
            TableUtil tu = channel.getTableUtil();
            ResultSet rs = tu.List(sql,sql_count,pages,pagesize);
            int num = tu.pagecontrol.getRowsCount();
            while(rs.next()){
                int id_ = rs.getInt("id");

                Document doc = CmsCache.getDocument(id_,parent_column);
                String url = doc.getHref("app");//稿件地址
                int gid = doc.getGlobalID();//文章编号

                //获取工作流审核状态

                String approve_status = "未提交审核";
                ApproveAction approve = new ApproveAction(gid,0);//最近一次审核操作
                int id_aa = approve.getId();//审核操作id
                int approveId = approve.getApproveId();//审核环节id	}

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
                        int type2 = ai.getType();
                        String userIds = ai.getUsers();

                        if(!userIds.equals("")){
                            String[] users = userIds.split(",");
                            JSONObject json = getUserNames(users,getAction(gid),gid,ai.getId());
                            int size = json.getInt("size");
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
                String reviewer = doc.getValue("reviewer");//审核人
                String review_date = doc.getValue("review_date") ;//审核时间
                int status = doc.getIntValue("task_status");
                String status_ = "";
                if(status==0){
                    status_ = "未审核";
                }else if(status==1){
                    status_ = "审核通过";
                }else if(status==2){
                    status_ = "审核未通过";
                }else if(status==3){
                    status_ = "已完成";
                }
                int childId = doc.getCategoryID();//所属子频道编号
                if(childId==0) childId = parent_column ;
                String childPath = CmsCache.getChannel(childId).getName();//选题频道名

                //审核结果
                String whereSql1 = " where Active=1 and parent="+gid+" order by id desc limit 1";
                ArrayList<Document> arr1= ItemUtil.listItems(channel_reason,whereSql1);
                for(int j=0;j<arr1.size();j++){
                    Document doc1 = arr1.get(j);
                    reviewer = doc1.getValue("username");
                    review_date = doc1.getValue("review_date") ;
                }
                if(!review_date.equals("")){
                    review_date = Util.FormatDate("yyyy-MM-dd HH:mm:ss",review_date);
                }

                JSONObject o = new JSONObject();
                o.put("id",id_);
                o.put("gid",gid);
                o.put("publisher",doc.getValue("publisher_name"));//发起人
                o.put("publish_date",doc.getCreateDate());//发起时间
                o.put("name",doc.getTitle());//名称
                o.put("summary",doc.getSummary());//摘要
                o.put("status",status_);//任务状态
                o.put("finish_date","");//结束时间
                o.put("type",1);//数据类型
                o.put("tip",childPath);
                o.put("url",url);
                o.put("reviewer",reviewer);
                o.put("review_date",review_date);
                o.put("approve_status",approve_status);

                jsonArr.put(o);
            }
            tu.closeRs(rs);

            map.put("result",jsonArr);
            map.put("num",num);

        }catch(Exception e){
            map.put("status",500);
            map.put("message","程序异常"+e.toString());
            e.printStackTrace();
        }
        return map ;
    }

%>

<%
    JSONObject json = new JSONObject();


    int type = getIntParameter(request,"type");//状态 1待我审核的，2我审核通过的
    int column_id = getIntParameter(request,"column_id");//栏目编号
    int data_type = getIntParameter(request,"data_type");//类型 1.稿件，2.选题
    int status = getIntParameter(request,"status");//状态 1审核通过
    int pages = getIntParameter(request,"page");//页码
    int pagesize = getIntParameter(request,"pagesize");
    if(data_type==0) data_type = 2;
    if(pages<1) pages = 1;
    if(pagesize<=0) pagesize = 20;

    Channel channel = CmsCache.getChannel(column_id);
    if(!channel.hasRight(userinfo_session,1))
    {
        json.put("status",500);
        json.put("message","没有权限");
        out.println(json);
        return ;
    }

    //int userid = userinfo_session.getId();//当前登录用户id

    //System.out.println("审核列表参数："+type+":"+column_id+":"+data_type+":"+userid);
    HashMap<String, Object> map = getList( type, column_id, data_type,status, userid, pages, pagesize);
    json = new JSONObject(map);
    out.println(json);
%>
