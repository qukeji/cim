<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
    //数据表敏感词库标题查询
%>
<%
    String word=getParameter(request,"word");
    TableUtil tu = new TableUtil();
    String title = "";
    StringBuffer Title = new StringBuffer();
    ResultSet Rs = null;
    boolean flag = false;
    JSONObject json = new JSONObject();
    try{
        String Sql = "select Title from channel_sensitive_word where Active=1";
        Rs = tu.executeQuery(Sql);
        while(Rs.next()){
            title = convertNull(Rs.getString("Title"));
            if(word.contains(title)){
                if(Title.length()>0){
                    Title.append("、"+ title);
                    continue;
                }
                Title.append( title );
            }
        }
        tu.closeRs(Rs);
        if(Title.length()==0){
            json.put("code",200);
            json.put("type",0);
            //接口请求成功，不存在敏感词
        }else{
            json.put("code",200);
            json.put("type",1);
            json.put("word",Title.toString());
        }
    }catch(Exception e){
        json.put("code",500);
        json.put("msg","接口请求错误");
        //接口请求失败
    }finally{
        out.println(json);
    }

%>
