<%@ page import="tidemedia.cms.util.*,
				 tidemedia.cms.system.*,
				 org.json.JSONObject,
				 org.json.JSONException,
				 org.json.JSONArray,
				 tidemedia.cms.app.*,
				 java.util.*,
                 tidemedia.cms.base.TableUtil,
                 java.sql.ResultSet,
                  java.text.SimpleDateFormat,
                java.util.Date,
                java.util.Calendar

"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%@ include file="common.jsp"%>
<%
    Integer pages = getIntParameter(request,"page");
	Integer page_num = getIntParameter(request,"page_num");
	Integer userid = getIntParameter(request,"userid");
	Integer site = getIntParameter(request,"site");
	CoinsInfo coinsInfo =new CoinsInfo(TIDE.get("channel_cms_goldaddition")+"",TIDE.get("channel_cms_golddetail")+"",CmsCache.getChannel((String)(TIDE.get("channel_cms_golddetail_serialno"))).getId(),TIDE.get("cms_register")+"");
	out.print(coinsInfo.getCoinsInfoList(pages,page_num,userid,TIDE.get("cms_register")+"").toString());
%>
