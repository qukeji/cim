<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
%>
<%


/*
		try {
			TableUtil tu = new TableUtil();
			String sql="";
			sql="select id,type from channel where type=0";
			ResultSet rs = tu.executeQuery(sql);
			int channelid=0;
			while(rs.next()){
				channelid = rs.getInt("id");
				Channel ch = CmsCache.getChannel(channelid);
				String sql2 ="";
				if(channelid==17394){
					sql2 = "alter table "+ch.getTableName()+" add publishtime datetime";
					TableUtil tu2 = new TableUtil();
					tu2.executeUpdate(sql2);
				}
			}
			tu.closeRs(rs);
		} catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace(System.out);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace(System.out);
		}
		*/
/*

int ChannelID=17394;
int GroupID=0;
String FieldName="test_publishtime";
String Description="test_publishtime_chn";

Field field = new Field();
field.setChannelID(ChannelID);
field.setGroupID(GroupID);

field.setName(FieldName);
field.setDescription(Description);
field.setFieldType("datetime");
field.setOptions("");

//ChannelID=17394,GroupID=6392,IsHide=0,DisableBlank=0,DisableEdit=0,FieldName=publishtime,Description=��ʱ����,FieldType=datetime,Options=,DefaultValue=,Other=,HtmlTemplate=,DictCode=,Size=0,Style=,RecommendChannel=,RecommendValue=,GroupChannel=,DataType=0,RelationChannelID=0
		
		field.Add();
		*/
		TableUtil tu = new TableUtil();
		String sql = "";
		sql = "select id,type from channel where type=0";
		ResultSet rs = tu.executeQuery(sql);
		int channelid = 0;
		while (rs.next()) {
			channelid = rs.getInt("id");
			Channel ch = CmsCache.getChannel(channelid);
			String sql2 = "";
			
				int ChannelID = channelid;
				int GroupID = 0;
				String FieldName = "SetPublishDate";
				String Description = "定时发布日期";
			try {
				
					Field field = new Field();
					field.setChannelID(ChannelID);
					field.setGroupID(GroupID);
					field.setName(FieldName);
					field.setDescription(Description);
					field.setFieldType("datetime");
					field.Add();
				

			} catch (MessageException e) {
				// TODO Auto-generated catch block
				e.printStackTrace(System.out);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace(System.out);
			}
		}
		tu.closeRs(rs);
%>
