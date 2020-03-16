<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.util.regex.Matcher,
				java.util.regex.Pattern,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	/**
	 * 用途：聚视创建聚现直播
	 */
%>
<%!
	//计算签名
	public static String getSign(String s1){
		String sign = "";
		try{
			//base64加密替换
			s1 = Util.base64(s1);
			if(s1.contains("=")){
				s1 = s1.replaceAll("=", "|");
			}
			//字符串转换
			String regEx = "[^1-9]";//匹配1-9的数字
			Pattern p = Pattern.compile(regEx);
			Matcher m = p.matcher(s1);
			String s2 = m.replaceAll("").trim();
			s2 = s2.replaceAll("(?s)(.)(?=.*\\1)", "");//去重

			char[] s =s1.toCharArray();
			for(int i=0;i<s2.length();i++){
				char c = s2.charAt(i);
				int index = Integer.parseInt(String.valueOf(c));//获取要转换字符的位置

				if(s.length>=index&&!Character.isDigit(s[index-1])){//原字符长度大于index并且不是数字

					if(s[index-1]>='a'&&s[index-1]<='z'){
						s[index-1] -= 32;//小写转大写
					}else{
						s[index-1] += 32;
					}
				}
			}
			String s3 = String.valueOf(s);
			//获取签名
			sign=StringUtils.getMD5(StringUtils.getMD5(s3));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sign ;
	}
%>
<%
	String code = CmsCache.getServerCode();//"647754c49e3b9febf1c80934c32cf86e";//CmsCache.getServerCode();//获取机器码
	int timestamp = (int) (System.currentTimeMillis()/1000) ;//1515745172;//(int) (System.currentTimeMillis()/1000) ;//时间戳
	int uid = userinfo_session.getId() ;//23;//userinfo_session.getId() ;//用户id
	String uname = userinfo_session.getUsername() ;//"wanghailong";//userinfo_session.getUsername() ;//用户名

	String s1 = "juxiancode"+code+"timestamp"+timestamp+"uid"+uid+"uname"+uname;
	String sign = getSign(s1);

	//拼接接口请求参数
	String parameter = "timestamp="+timestamp+"&code="+code+"&uid="+uid+"&uname="+uname+"&sign="+sign;
//	out.println(parameter);
	 TideJson  json   =   CmsCache.getParameter("juxian_api").getJson();
	 String liveurl   = json.getString("live_url");
	String url  =  liveurl+"?"+parameter;
//	String result = Util.postHttpUrl("http://testconsole.juyun.tv/v1/auth.php",parameter);
	out.println(url);
%>
