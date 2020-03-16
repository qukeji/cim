<%
String root = (request.getRequestURL()+"").replace("/google_button_install.jsp","/google_button.jsp");
%><script>this.location="http://toolbar.google.com/buttons/add?url=<%=root%>";</script>