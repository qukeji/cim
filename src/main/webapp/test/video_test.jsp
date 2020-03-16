<%@ page import="java.io.*,org.json.*"%>
<%@ page import="tidemedia.cms.system.Log" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%
    BufferedReader streamReader = new BufferedReader( new InputStreamReader(request.getInputStream()));
    StringBuilder responseStrBuilder = new StringBuilder();
    String inputStr;
    while ((inputStr = streamReader.readLine()) != null) responseStrBuilder.append(inputStr);
    JSONObject json = new JSONObject(responseStrBuilder.toString());

    //Log.SystemLog("视频分析回调",json.toString());
    System.out.println("测试video");
    out.println(json.toString());
%>