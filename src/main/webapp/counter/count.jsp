<%String PageName = request.getParameter("PageName");
if(PageName==null)
	PageName = "";%>
document.write("<scrip" + "t src=http://www.tidemedia.com:888/cms/counter/count_.jsp?PageName=<%=PageName%>&Referer="+escape(document.referrer)+"&Width="+(screen.width)+"></sc" + "ript>");
