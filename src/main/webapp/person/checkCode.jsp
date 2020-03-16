<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	if(!(new UserPerm().canManageUser(userinfo_session)))
	{response.sendRedirect("../noperm.jsp");return;}

	String code = getParameter(request,"code");
	String phone = getParameter(request,"phone");
	int userId = userinfo_session.getId();
		
	String result = "" ;
	int type = 0 ;
	TableUtil tu = new TableUtil("user");
	String sql = "select * from userinfo where Tel='"+phone+"'";
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next()){
		int id = rs.getInt("id");
		if(id==userId){
			result = "" ;//此手机号已被自己绑定
			type = 1;
		}else{
			String Name = convertNull(rs.getString("Name"));
			result = "此手机号已被"+Name+"绑定" ;
			type = 2;
		}
		
	}
	tu.closeRs(rs);
	
	if(type==0){//手机号未被绑定,判断验证码是否正确
		
		if(code.equals("")){//验证码为空
			result = "请输入验证码";
		}else{
			String sql1 = "select * from validation where Phone='"+phone+"' and Code='"+code+"' and ExpireDate>=now()";
			ResultSet rs1 = tu.executeQuery(sql1);
			if(!rs1.next()){
				result = "验证码错误";//
			}
			tu.closeRs(rs1);
		}
	}
	out.println(result);
%>