<%@page import="java.net.URLDecoder"%>
<%@ page
        import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.net.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../../config1.jsp"%>
<%@ include file="common.jsp"%>
<%
    /**
     * 帖子管理视频获取
     *
     */
    JSONObject json = new JSONObject();
    String message = "";
    int  page_num = getIntParameter(request,"page") ;
    int per_num = getIntParameter(request,"per_num") ;
    int site =getIntParameter(request,"site") ;
    String sessionid =getParameter(request,"session") ;

    if (page_num<=0){
        page_num=1;
    }
    if (per_num<=0){
        per_num=10;
    }
    String sql="select id,Title,thumbnail_width,thumbnail_heigth,duration,Photo,GlobalID,txtContent,PublishDate,userid,doc_type,doctop,videourl,localtion from "+TIDE.get("cms_community_topic");
    String wheresql=" where Active=1 and Status=1  and doc_type=1 and siteflag="+site;
    wheresql+=" order by PublishDate desc";
    sql=sql+wheresql;
    String countsql="select count(*) from "+TIDE.get("cms_community_topic");
    System.out.println("sql"+sql);
    TableUtil tu=new TableUtil();
    ResultSet rs=tu.List(sql,countsql,page_num,per_num);

    JSONArray array=new JSONArray();
    while(rs.next()){
        JSONObject data=new JSONObject();
        String title=convertNull(rs.getString("Title"));
        int id=rs.getInt("id");
        int gid=rs.getInt("GlobalID");
        int doctype=rs.getInt("doc_type");
        String txtContent=convertNull(rs.getString("txtContent"));
        int doctop=rs.getInt("doctop");
        String date=convertNull(rs.getString("PublishDate"));
        String videourl=convertNull(rs.getString("videourl"));
        int thumbnail_width=rs.getInt("thumbnail_width");
        int thumbnail_heigth=rs.getInt("thumbnail_heigth");
        String Photo=convertNull(rs.getString("Photo"));
        String duration=convertNull(rs.getString("duration"));
        String localtion=convertNull(rs.getString("localtion"));
        int userid=rs.getInt("userid");
        String shareurl2=(String)TIDE.get("pic_path")+(String)TIDE.get("share_path");
        shareurl2= shareurl2.replace(".shtml","_"+id+".shtml");
        String contenturl=shareurl2;
        String shareurl=shareurl2;
        //查询用户
        String name="";//用户名称
        String avatar="";//用户头像
        int gender=0;
        String level="幼儿园";
        String sql_user="select avatar,Title,sex,designation from "+TIDE.get("cms_register")+" where id="+userid;
        TableUtil tu_user=new TableUtil();
        ResultSet rs_user=tu_user.executeQuery(sql_user);
        if (rs_user.next()){
            name=convertNull(rs_user.getString("Title"));
            avatar=convertNull(rs_user.getString("avatar"));
            gender=rs_user.getInt("sex");
            level=rs_user.getString("designation");
        }
        tu_user.closeRs(rs_user);
        //查询当前文章的点赞列表和总数
        String avater_zan="";//点赞用户头像
        int count_zan=0;//点赞总数
        String
                sql_zan_count="select count(1) from "+TIDE.get("cms_community_zan")+"  where Active=1 and Status=1 and docid="+gid+" and siteflag="+site;
        count_zan=getNumber(sql_zan_count);
        String
                sql_zan="select userid from "+TIDE.get("cms_community_zan")+"  where Active=1 and Status=1 and docid="+gid+" and siteflag="+site+" order by CreateDate desc limit 6";
        TableUtil tu_zan=new TableUtil();
        ResultSet rs_zan=tu_zan.executeQuery(sql_zan);
        JSONArray zan_arry=new JSONArray();
        while (rs_zan.next()){
            JSONObject zan_object=new JSONObject();
            int userid_zan=rs_zan.getInt("userid");
            //获取点赞用户头像
            String zan_user_sql="select avatar,Title,sex,designation from "+TIDE.get("cms_register")+" where id="+userid_zan;
            TableUtil tu_zanuser=new TableUtil();
            ResultSet rs_zanuser=tu_zanuser.executeQuery(zan_user_sql);
            if (rs_zanuser.next()){
                avater_zan=rs_zanuser.getString("avatar");
            }
            zan_object.put("avatar",avater_zan);
            zan_arry.put(zan_object);
        }
        tu_zan.closeRs(rs_zan);

        //获取当前文章评论总数和列表（最新六个）
        int pinglun_count=0;
        String sql_pinglun_count="select  count(1) from "+TIDE.get("cms_community_comment")+" where siteflag=" +site+" and Active=1 and Status=1 and item_gid="+gid;
        pinglun_count=getNumber(sql_pinglun_count);

        data.put("title",title);
        data.put("contentid",gid);
        data.put("doc_type",doctype);
        data.put("content",txtContent);
        data.put("doctop",doctop);
        data.put("date",date);
        data.put("videourl",videourl);
        data.put("videothumbnail","");
        data.put("name",name);
        data.put("avatar",avatar);
        data.put("userid",userid);
        data.put("contenturl",contenturl);
        data.put("shareurl",shareurl);
        data.put("zanlist",zan_arry);
        data.put("zancount",count_zan);
        data.put("commentcount",pinglun_count);
        data.put("thumbnail_width",thumbnail_width);
        data.put("thumbnail_height",thumbnail_heigth);
        data.put("duration",duration);
        data.put("photo",Photo);
        array.put(data);
    }
    tu.closeRs(rs);
    json.put("result",array);
    json.put("status",1);
    json.put("message","成功");
    out.print(json);
%>
<%!
    //查询数量;参数，频道id,问题状态，评价
    public int getNumber(String sql) throws MessageException, SQLException
    {
        int num = 0;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next())
            num = rs.getInt(1);
        tu.closeRs(rs);
        return num;
    }
%>
