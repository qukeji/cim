<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.email.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");
int GroupID = getIntParameter(request,"GroupID");

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 100;

if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");
	EmailAddress ea = new EmailAddress(id);

	ea.Delete(id);

	response.sendRedirect("email_list.jsp");return;
}
else if(Action.equals("Clear"))
{
	String Sql = "delete from email_address";

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("email_list.jsp");return;
}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language=javascript>
	var myObject = new Object();
	myObject.title = "";

function change(obj)
{
	if(obj!=null)
		this.location = "email_list.jsp?rowsPerPage="+obj.value;
}

function addEmail()
{
    myObject.title = "添加邮件地址";
	var Feature = "dialogWidth:32em; dialogHeight:20em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=email/email_add.jsp",myObject,Feature);
	if(retu!=null)
		window.location.reload();
}

function importEmail()
{
    myObject.title = "导入邮件地址";
	var Feature = "dialogWidth:32em; dialogHeight:20em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=email/email_import.jsp",myObject,Feature);
	if(retu!=null)
		window.location.reload();
}

function clearEmail()
{
	if(confirm("确实要清空所有的邮件地址吗？")) 
	{
		this.location = "email_list.jsp?Action=Clear";
	}	
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top"><table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
        <tr> 
          <td align="right"> 		  
		  </td>
          <td align="right"><a href="#" onClick="addEmail()">添加邮件地址</a> &nbsp;&nbsp;<a href="#" onClick="importEmail()">导入邮件地址</a> &nbsp;&nbsp;<a href="#" onClick="clearEmail()">清空邮件地址</a>&nbsp;&nbsp;</td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="8" cellpadding="0">
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="5" id="oTable">
              <tr align="center"> 
                <td width="38" class="box-blue"><span class="font-white">编号</span></td>
                <td width="134" class="box-blue"><span class="font-white">姓名</span></td>
                <td width="291" class="box-blue"><span class="font-white">电子邮件</span></td>
                <td width="144" class="box-blue"><span class="font-white">&nbsp;</span></td>
              </tr>
<%
EmailAddress ea = new EmailAddress();
String ListSql = "select * from email_address";
String CountSql = "select count(*) from email_address";

ResultSet Rs = ea.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = ea.pagecontrol.getMaxPages();

if(ea.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				String Name = convertNull(Rs.getString("Name"));
				String Email = convertNull(Rs.getString("EmailAddress"));

				int id = Rs.getInt("id");

				j++;
%>
              <tr class="<%=(j%2==0)?"rows2":"rows1"%>"> 
                <td width="38" ><%=j%></td>
                <td width="134" ><a href="javascript:showUser(<%=id%>);" class="operate"><%=Name%></a></td>
                <td width="291" ><%=Email%></td>
                <td width="144" ><a href="email_list.jsp?Action=Del&id=<%=id%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td>
              </tr>
<%
			}
}
ea.closeRs(Rs);
%>
            </table>
<%if(TotalPageNumber>0){%>            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="box-blue">
              <tr> 
                <td height="26" class="font">　　<a href="email_list.jsp?currPage=1&rowsPerPage=<%=rowsPerPage%>"><span class="font-white">&lt;&lt; 
                  第一页</span></a> <%if(currPage>1){%><a href="email_list.jsp?currPage=<%=currPage-1%>&rowsPerPage=<%=rowsPerPage%>"><span class="font-white">&lt; 上页</span></a><%}%> 　　<%if(currPage<TotalPageNumber){%><a href="email_list.jsp?currPage=<%=currPage+1%>&rowsPerPage=<%=rowsPerPage%>"&><span class="font-white">下页 &gt;</span></a><%}%> <a href="email_list.jsp?currPage=<%=TotalPageNumber%>&rowsPerPage=<%=rowsPerPage%>"><span class="font-white">最后一页&gt;&gt;</span></a></td>
                <td align="right" class="font"><span class="font-white">共<%=TotalPageNumber%>页 当前第<%=currPage%>页 每页显示 
                  <select name="num_perpage" onChange="change(this);" id="rowsPerPage">
                    <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="25">25</option>
                    <option value="30">30</option>
                    <option value="50">50</option>
                    <option value="80">80</option>
                    <option value="100">100</option>
                  </select>
                  条</span>　　　</td>
              </tr>
<script language=javascript>
rowsPerPage.value = <%=rowsPerPage%>;
</script>					
            </table><%}%>
            </table>
			</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
