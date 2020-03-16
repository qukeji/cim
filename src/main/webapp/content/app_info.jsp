<%@ page import="java.sql.*,
				tidemedia.cms.system.*,java.io.File,java.util.ArrayList"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
	int id = getIntParameter(request,"ChannelID");
	int ItemID = getIntParameter(request,"ItemID");

	Channel channel = new Channel();
	
	if(id==0||id==-1)
	{
		channel = channel.getRootChannel();
	}
	else
		channel = CmsCache.getChannel(id);
	
	Field field = new Field();
	
	String Table = channel.getTableName();

	ResultSetMetaData rsmd = channel.getColumn();
	ArrayList arraylist = channel.getFieldInfo();
%>

<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="1" topmargin="1" marginwidth="1" marginheight="1">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
	<tr> 
    	<td valign="top" class="box-tint">
      		<table width="100%" height="24"  border="0" cellpadding="0" cellspacing="0" class="box-gray">
        		<tr>
          			<td >
          				<span >&nbsp;&nbsp;表单详细信息：</span>
          			</td>
        		</tr>
      		</table>
	<div id="info">
			<table width="100%" border="0" cellspacing="0" cellpadding="10">
        		 <%
          				int cols = rsmd.getColumnCount();
          				App app = new App();
          				String Description = "";
          				for (int i = 1; i <= cols; i++) 
          				{
        					String FieldName = rsmd.getColumnName(i);
        					if(!FieldName.equalsIgnoreCase("id"))
        					{
        						//FieldValue fv = field.getFieldValue(FieldName, arraylist);
        					  field=channel.getFieldByFieldName(FieldName);
        						//Description = fv.getDescription();
        					
        						Description=field.getDescription();
        					
        					
        			%>		
	        			<%if(field.getFieldType().equals("label")){%>	
	        				<tr align="center">
	        						<td align="left">
	        							
	        						</td>
	          						<td class="lin28" align="left">
	            	  					<%=field.getOther()%>
	       		     				</td>
	       		     			</tr>
	       		     	<%}else{%>
    							<tr align="center">
	        						<td align="left">
	        							<%=Description%>:
	        						</td>
	          						<td class="lin28" align="left">
	            	  					<%=app.getFieldValue(Table,ItemID,FieldName)%>
	       		     				</td>
	       		     			</tr>	   	
       	
        			<%		}
        					}
        				}
          			%>
        		
      		</table>
  	 </div>
    	</td>
	</tr>
  	<tr>
    	<td height="50" align="center" class="box-gray">
    		<input type="hidden" name="ItemID" id="ItemID" value="<%=ItemID%>">
    		<input name="Submit2" type="button" class="tidecms_btn3" value="  关  闭  " onClick="self.close();">
		</td>
    </tr>
</table>
</body>
</html>
