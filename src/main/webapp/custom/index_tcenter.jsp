<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.Date,
				tidemedia.cms.user.*,tidemedia.cms.util.*"%>
<%@page errorPage="/cms_error.jsp"%><%
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);

request.setCharacterEncoding("utf-8");
int max_perpage 	= 20;		//MAX DISPLAY RECORDS IN ONE PAGE//

tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();

tidemedia.cms.base.Config defaultConfig=tidemedia.cms.system.CmsCache.getConfig();
//check user validate
tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();

if(session.getAttribute("CMSUserInfo")!=null)
{
	userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
	response.sendRedirect("main.jsp");
}

if(userinfo_session==null || userinfo_session.getId()==0)
{

		String token = "";
		String url = "";
		String tcenter_session="";

		Cookie[] cookies = request.getCookies();

		if(cookies!=null)
		{ 

			for(int i=0;i<cookies.length;i++)
			{
				if(cookies[i].getName().equals("token"))
					token = cookies[i].getValue();	
				if(cookies[i].getName().equals("tcenter_token")){
					tcenter_session = cookies[i].getValue();	
				}
			}
		}
		
		if(!token.equals(""))
		{
				String UserName="";
				String[] values = new UserInfoUtil().decodePasswordCookie(token, new String(new char[] {'\023', 'C', 'i'}));
				if(values!=null){
					UserName = values[0];
				}
				tidemedia.cms.user.UserInfo userinfo = new tidemedia.cms.user.UserInfo();;
				String Result=Util.postHttpUrl("http://127.0.0.1:888/tcenter/getUser.jsp?username="+UserName+"&tcentersession="+tcenter_session,"");
				//System.out.println("http://127.0.0.1:888/tcenter/getUser.jsp?username="+UserName+"&tcentersession="+tcenter_session+"----结果"+Result);
				if(Result.trim().equals("1")){
					if(userinfo.Authorization(request,response,"",token,true)==1)
					{
						this.getServletContext()
						.setAttribute(UserName, session);// 以UserName为Key
						if(url.equals(""))
							response.sendRedirect("main.jsp");
						else
							response.sendRedirect(url);
						return;
					}
				}else{
					return;
				}
		}
}
%>