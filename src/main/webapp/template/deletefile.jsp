<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*
				"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
  *		姓名				日期            备注
  *
  *		wanghailong			20140505		设置用户（setActionUser）
  *
  */
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String		Action = getParameter(request,"Action");
String		ItemID	=	getParameter(request,"ItemID");
String		GroupID =   getParameter(request,"GroupID");

if(Action.equals("Delete"))
{
	String[] ids = Util.StringToArray(ItemID, ",");
	int a = ids.length;
	int b = 0;
	for (int i = 0; i < ids.length; i++) 
	{
		int id_ = Util.parseInt(ids[i]);
		TemplateFile ct = new TemplateFile(id_);

		//System.out.println(id_+","+ct.getId()+","+ct.getName()+","+ct.getUsedNumber());
		if(ct.getUsedNumber()==0)
		{
			ct.setActionUser(userinfo_session.getId());
			ct.Delete(id_);

			//out.println(JsonUtil.success("删除成功."));
		}
		else
			b++;	
	}

	if(b>0) out.println(JsonUtil.fail("要删除"+a+"个模板，其中"+b+"个模板在使用中，无法删除."));
	//response.sendRedirect("template_list.jsp?GroupID=" + GroupID);
}
%>