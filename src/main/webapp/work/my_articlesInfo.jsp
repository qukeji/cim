<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.system.*,
				tidemedia.cms.util.TideJson,
				tidemedia.cms.util.Util,
				java.sql.ResultSet"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%@ include file="workes.jsp" %>
<%
    int userinfo_sessionid = userinfo_session.getId();
    int status = getIntParameter(request, "status");
    int type_flow = getIntParameter(request, "type");
    int pages = getIntParameter(request, "pages");//页码
    int pagesize = getIntParameter(request, "pagesize");//每页显示数量
    String S_Title = getParameter(request, "Title");
    String S_startDate = getParameter(request, "startDate");
    String S_endDate = getParameter(request, "endDate");
    int IsDelete = getIntParameter(request, "IsDelete");
    if (pages < 1) pages = 1;
    if (pagesize <= 0) pagesize = 20;
    if (status != 0) {
        status = status - 1;
    }
    int IsActive = 1;
    if(IsDelete==1) IsActive=0;

    //获取文稿管理编号
    Channel channel = ChannelUtil.getApplicationChannel("shengao");
    int channelId = channel.getId();
    if(userinfo_session.getCompany()!=0){
        channelId = new Tree().getChannelID(channelId,userinfo_session);
    }
    ChannelPrivilege cp = new ChannelPrivilege();
    boolean hasAddPerm = false;
    if(!channel.hasRight(userinfo_session,1)&&!channel.hasRight(userinfo_session,12))
    {
        out.print(new JSONObject());
        return;
    }
    if(cp.hasRight(userinfo_session,channelId,2)){
        hasAddPerm = true;
    }

    String Table = channel.getTableName();
    String ListSql = "select id,Title,Photo,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews";
    ListSql += " from " + Table;
    String CountSql = "select count(*) from "+Table;
    String WhereSql = " where Active = "+IsActive;
    if(userinfo_session.getCompany()!=0){
        WhereSql += " and Category = "+channelId;
    }
    if(!S_Title.equals("")){
        String tempTitle=S_Title.replaceAll("%","\\\\%");
        WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
    }
    if(!S_startDate.equals("")){
        long startTime=Util.getFromTime(S_startDate,"");
        WhereSql += " and CreateDate>="+startTime ;
    }
    if(!S_endDate.equals("")){
        long endTime=Util.getFromTime(S_endDate,"");
        WhereSql += " and CreateDate<"+(endTime+86400);
    }

    if(status!=0)
        WhereSql += " and Status=" + status;

    WhereSql += " and User = "+userinfo_sessionid;

    ListSql += WhereSql;
    CountSql += WhereSql;

    int listnum = pagesize;
    //if(listType==2) listnum = cols*rows;

    TableUtil tu = channel.getTableUtil();
    System.out.println("listsql=-="+ListSql);
    ResultSet Rs = tu.List(ListSql,CountSql,pages,listnum);
    int TotalPageNumber = tu.pagecontrol.getMaxPages();
    int TotalNumber = tu.pagecontrol.getRowsCount();

    JSONObject json = new JSONObject();
    JSONArray arr = new JSONArray();
    String url = request.getRequestURL()+"";
    String base = url.replace(request.getRequestURI(),"");
    String ContextPath=request.getContextPath();
    String photoTable = CmsCache.getChannel("photo").getTableName();//图片库频道表名
    String  channelcode = CmsCache.getChannel("s53_a_a").getChannelCode();//栏目管理频道channelcode
	//图片及图片库配置
	Channel channel_ = null;
	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();
	int sys_channelid_image = photo_config.getInt("channelid");
	channel_ = CmsCache.getChannel(sys_channelid_image);
	Site site = channel_.getSite();
	String SiteUrl = site.getExternalUrl();//图片库预览地址

    while(Rs.next()){
        	JSONObject o = new JSONObject();
    		JSONArray photojsonArray = new JSONArray();
            int GlobalID = Rs.getInt("GlobalID");
            Document document= new Document(GlobalID);
            int id_ = document.getId();
            int childId = document.getChannelID();
            String title = convertNull(Rs.getString("Title"));
            String CreateDate = document.getCreateDate();
            String UserName	= document.getUserName();
            int category =  document.getCategoryID();
            String childChannelCode = channel.getChannelCode();
            /*if(childChannelCode.contains(channelcode)){
            	int doc_type = document.getIntValue("doc_type");
                String videourl = document.getValue("videourl");
                o.put("doc_type", doc_type);
                o.put("videourl", videourl);
                String Photo4 = document.getValue("Photo4");
                String Photo2 = document.getValue("Photo2");
                String Photo3 = document.getValue("Photo3");
                if(!Photo4.startsWith("http")&&!Photo4.startsWith("https")&&(!"".equals(Photo4))){
                	Photo4=SiteUrl+Photo4;
                	photojsonArray.put(Photo4);
        		}
                if(!Photo2.startsWith("http")&&!Photo2.startsWith("https")&&(!"".equals(Photo2))){
                	Photo2=SiteUrl+Photo2;
                	photojsonArray.put(Photo2);
        		}
                if(!Photo3.startsWith("http")&&!Photo3.startsWith("https")&&(!"".equals(Photo3))){
                	Photo3=SiteUrl+Photo3;
                	photojsonArray.put(Photo3);
        		}
                
                
                
                if(doc_type==2){
                	TableUtil tu1 = new TableUtil();
                	String sql = "select * from "+photoTable+"  where active = 1 and  parent = "+GlobalID;
                	ResultSet rs = tu1.executeQuery(sql);
                	while(rs.next()){
                		String photo_ = tu1.convertNull(rs.getString("Photo"));
                		if(!photo_.startsWith("http")&&!photo_.startsWith("https")){
                			photo_=SiteUrl+photo_;
                		}
                		photojsonArray.put(photo_);
                	}
                	tu1.closeRs(rs);
                }
            }else{*/
            	o.put("doc_type", 0);
            String Photo = document.getValue("Photo");
            if(!Photo.startsWith("http")&&!Photo.startsWith("https")&&(!"".equals(Photo))){
            	Photo=SiteUrl+Photo;
            	photojsonArray.put(Photo);
    		}
            
            o.put("Photo", photojsonArray);
            String path=base+ContextPath+"/content/document.jsp?ItemID="+id_+"&ChannelID="+childId;
            String channelName = channel.getName();
            String parentChannelPath2 = CmsCache.getChannel(childId).getParentChannelPath().replaceAll("/",">");
            int Status=document.getStatus();
            String StatusDesc="";
            if(Status==0){
                StatusDesc = "<span class='tx-orange'>草稿</span>";
            }else if(Status==1){
                StatusDesc = "<span class='tx-success'>已发</span>";
            }else{
                StatusDesc = "<span class='tx-danger'>已删除</span>";
            }
            
            o.put("id",id_);
            o.put("ChannelID",childId);
            o.put("title",title);
            o.put("user",UserName);
            o.put("date",CreateDate);
            o.put("path",path);
            o.put("category",category);
            o.put("channelPath",parentChannelPath2);
            o.put("channelName",channelName);
            o.put("StatusDesc",StatusDesc);
            o.put("type",1);
            arr.put(o);
        }
        JSONArray jsonArray=new JSONArray();
        int count=getNumber(userinfo_sessionid,0);//总数
        int count2=getNumber(userinfo_sessionid,1);//草稿
        int count3=getNumber(userinfo_sessionid,2);//已发
        JSONObject jsonObject1=new JSONObject();
        JSONObject jsonObject2=new JSONObject();
        JSONObject jsonObject3=new JSONObject();


        jsonObject1.put("lable","全部");
        jsonObject1.put("data",count);
        jsonObject2.put("lable","草稿");
        jsonObject2.put("data",count2);
        jsonObject3.put("lable","已发");
        jsonObject3.put("data",count3);



        jsonArray.put(jsonObject1);
        jsonArray.put(jsonObject2);
        jsonArray.put(jsonObject3);

        json.put("status",200);

        json.put("message","成功");
        json.put("moduleType",5);
        json.put("moduleIcon","<i class='fa fa-file-text-o mg-r-10 tx-22'></i>");
        json.put("moduleName","我的稿件");
        json.put("name","我的稿件");
        json.put("addJs","siderightNewContent()");
        json.put("hasAddPerm",hasAddPerm);
        json.put("tablist",jsonArray);
        json.put("result",arr);

        out.println(json);
%>
