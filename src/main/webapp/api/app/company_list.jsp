 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				tidemedia.cms.util.*,
				java.sql.SQLException,
				java.sql.Timestamp,
				java.text.ParseException,
				java.text.SimpleDateFormat,
				java.util.Date,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%!
public static int getCurrentSourceChannel(int sourcechannelid, int CompanyId) throws JSONException,MessageException,SQLException {
	//查询媒体号频道id
    int CurrentSourceChannel = 0;
    TableUtil tu_s = new TableUtil();
    String sql_s = "select id,Extra2 from channel  where Parent="+sourcechannelid+"";
    ResultSet rs_s = tu_s.executeQuery(sql_s);
    while(rs_s.next()) {
        if(rs_s.getString("Extra2").length()>0){
        JSONObject jsonEx = new JSONObject(rs_s.getString("Extra2"));
            if(jsonEx.has("company")){
                if(jsonEx.getInt("company")==CompanyId){ 
                    CurrentSourceChannel = rs_s.getInt("Id");
                }
            }
        }
    } 
    tu_s.closeRs(rs_s);
    return CurrentSourceChannel;
}
    
%>

<%
//获取媒体号数据接口
    String callback=getParameter(request,"callback");
    JSONObject oo = new JSONObject();

	try{
	int SiteId = getIntParameter(request,"siteid");
    String companyId = getParameter(request,"companyid");
    String[] companyIdArray = companyId.split(",");
    int num = getIntParameter(request,"num");
    if(num==0){
        num=2;
    }

    //String keywords = CmsCache.getParameterValue("keywords");
	//int videoroot = CmsCache.getParameter("wenzheng_operating_record").getIntValue();

	 if(SiteId==0){
		    oo.put("status",500);
			oo.put("message","站点id有误");
	 }else if(companyId==null||companyId.equals("")){
			oo.put("status",500);
			oo.put("message","媒体号id有误");
	 }else{


        int sourcechannelid = 0;
        TableUtil tu_source = new TableUtil();
        // 查询站点父频道id
        String sql_source = "select id from channel  where SerialNo='company_s" + SiteId + "_source' ";
        ResultSet rs_source = tu_source.executeQuery(sql_source);
        if(rs_source.next()) {
            sourcechannelid = rs_source.getInt("id");
        } 
        tu_source.closeRs(rs_source);

        if(sourcechannelid==0){
            oo.put("status",500);
			oo.put("message","获取媒体号父频道错误");
        }else{
        
            //String currentSourceChannel = "";
            //int tempCompanyId = 0;
            JSONArray list = new JSONArray();
            for (int i = 0; i < companyIdArray.length; i++) {
                int CompanyId = Integer.parseInt(companyIdArray[i]);
                if(CompanyId!=0){
                    int CurrentSourceChannel = getCurrentSourceChannel(sourcechannelid,CompanyId);
                    if(CurrentSourceChannel!=0){
                        JSONObject ooo = new JSONObject();
                    
                        JSONArray data = new JSONArray();
                        //获取媒体号已发布，未删除的前num条内容
                    	String ListSql="select id,GlobalID,Title,PublishDate,Photo from "+CmsCache.getChannel(CurrentSourceChannel).getTableName()+" where Category="+CurrentSourceChannel+" and Active=1 and Status=1 and doc_type=0 order by PublishDate desc limit "+num;
                        TableUtil tu = new TableUtil();
                        ResultSet Rs = tu.executeQuery(ListSql);
                        while(Rs.next()){
                            int id=Rs.getInt("id");
                            int GlobalID=Rs.getInt("GlobalID");
        
                            String Title=convertNull(Rs.getString("Title"));
                            String PublishDate = convertNull(Rs.getString("PublishDate"));
                            PublishDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",Long.parseLong(PublishDate+"000"),"Asia/Shanghai");
                            //System.out.println("============================================"+PublishDate);
                            String Photo = convertNull(Rs.getString("Photo"));
                            
                            //创建文章对象获取contentUrl
                            Document doc = CmsCache.getDocument(GlobalID);
                            //Document doc=CmsCache.getDocument(id,CurrentSourceChannel);
                            String contentUrl = "";
                            contentUrl = doc.getFullHref("app");
        
                            JSONObject o = new JSONObject();
                            o.put("Title",Title);
                            o.put("PublishDate",PublishDate);
                            o.put("Photo",Photo);
                            o.put("contentUrl",contentUrl);
                            data.put(o);
                        }
                        tu.closeRs(Rs);
                        ooo.put("data",data);
                        ooo.put("CompanyId",CompanyId);
                        
                        list.put(ooo);
                        
                    }
                }
                
            }
            oo.put("list",list);
            oo.put("message","获取成功！");
            oo.put("status",200);

        }
        
      }
    	}catch(Exception e){
    			oo.put("message","接口调用失败，请检查传值参数");
    			oo.put("status",500);
    	}
    	if(callback!=null&&callback!=""){
    	    out.println(callback+"("+oo.toString()+")");
    	}else{
    	    out.println(oo.toString());
    	}
    	 
%>



