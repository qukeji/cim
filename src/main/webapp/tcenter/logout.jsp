<%
tidemedia.cms.util.Util.Logout(session);
Cookie cookie = new Cookie("token", "");
cookie.setPath("/");
cookie.setMaxAge(0);
response.addCookie(cookie);

Cookie cookie2 = new Cookie("Username2", "");
cookie2.setPath("/");
cookie2.setMaxAge(0);
response.addCookie(cookie2);

response.sendRedirect("index.jsp");
%>
