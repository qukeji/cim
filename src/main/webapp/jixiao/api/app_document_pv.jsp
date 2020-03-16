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
    //客户端稿件PV入库接口
    int assessIndicator = getIntParameter(request,"assessIndicator");
    JiXiaoUtil jiXiaoUtil = new JiXiaoUtil();
    JSONArray jsonArray = jiXiaoUtil.traverseScheme(assessIndicator);//遍历绩效方案  4代表考核指标是客户端稿件PV
    jiXiaoUtil.clientPvDocument(assessIndicator,jsonArray);//客户端稿件PV入库
%>
