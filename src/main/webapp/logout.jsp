<%
tidemedia.cms.util.Util.Logout(session);
Cookie cookie = new Cookie("Username2", "");
cookie.setPath("/");
cookie.setMaxAge(0);
response.addCookie(cookie);

Cookie cookie2 = new Cookie("token", "");
cookie2.setPath("/");
cookie2.setMaxAge(0);
response.addCookie(cookie2);

Cookie cookie3 = new Cookie("JSESSIONID", "");
cookie3.setPath("/vms");
cookie3.setMaxAge(0);
response.addCookie(cookie3);

//System.out.println("logout");

response.sendRedirect("/tcenter/index.jsp");
%>
