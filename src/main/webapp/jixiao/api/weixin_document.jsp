<%@ page import="tidemedia.cms.base.TableUtil,
                 tidemedia.cms.system.*,
                 java.math.BigDecimal,
                 java.sql.ResultSet" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp" %>
<%
    //客户端发稿量入库接口
    int assessIndicator = getIntParameter(request,"assessIndicator");
    JiXiaoUtil jiXiaoUtil = new JiXiaoUtil();
    JSONArray jsonArray = jiXiaoUtil.traverseScheme(assessIndicator);//遍历绩效方案  5代表考核指标是微信发稿量
    jiXiaoUtil.clientDocument(assessIndicator,jsonArray);//微信发稿量入库
%>
