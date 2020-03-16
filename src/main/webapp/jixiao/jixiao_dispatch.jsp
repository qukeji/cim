<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    TableUtil tu = new TableUtil();
    String sql = "select * from channel_connector_setting";
    ResultSet rs = tu.executeQuery(sql);
    if (rs.next()){
        String webDocument = rs.getString("WebDocument");
        String webDocumentPv = rs.getString("WebDocumentPv");
        String appDocument = rs.getString("AppDocument");
        String appDocumentPv = rs.getString("AppDocumentPv");
        String weixinDocument = rs.getString("WeixinDocument");
        String weixinDocumentPv = rs.getString("WeixinDocumentPv");
        String subjectUse = rs.getString("SubjectUse");
        String videoUpload = rs.getString("VideoUpload");
        if(!webDocument.equals("")){
            Util.connectHttpUrl(webDocument+"?assessIndicator=1");
        }else if(!webDocumentPv.equals("")){
            Util.connectHttpUrl(webDocumentPv+"?assessIndicator=2");
        }else if(!appDocument.equals("")){
            Util.connectHttpUrl(appDocument+"?assessIndicator=3");
            System.out.println("客户端发稿量接口地址是"+appDocument);
        }else if(!appDocumentPv.equals("")){
            Util.connectHttpUrl(appDocumentPv+"?assessIndicator=4");
        }else if(!weixinDocument.equals("")){
            Util.connectHttpUrl(weixinDocument+"?assessIndicator=5");
        }else if(!weixinDocumentPv.equals("")){
            Util.connectHttpUrl(weixinDocumentPv+"?assessIndicator=6");
        }else if(!subjectUse.equals("")){
            Util.connectHttpUrl(subjectUse+"?assessIndicator=7");
        }else if(!videoUpload.equals("")){
            Util.connectHttpUrl(videoUpload+"?assessIndicator=8");
        }
    }
    tu.closeRs(rs);
%>