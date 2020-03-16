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
<%/*! public void removeItems(int channelid,TableUtil tu) throws SQLException,MessageException
{
	String Sql = "select * from channel where Parent=" + channelid;
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		removeItems(Rs.getInt("id"),tu);

		if(Rs.getInt("Type")==0 && Rs.getInt("Parent")!=-1)
		{
			tu.executeUpdate("TRUNCATE  channel_"+Rs.getString("SerialNo"));
		}
		System.out.println("<br>"+Rs.getString("SerialNo")+".....clear");
	}
}*/
%>
<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();

//2009-07-04
//增加generate_files表索引
tu.executeUpdate("ALTER TABLE generate_files ADD INDEX FileName(FileName);");
//增加item_snap表索引
tu.executeUpdate("ALTER TABLE item_snap ADD INDEX index_2(OrderNumber,ChannelCode,Status,Active),ADD INDEX index_3(ChannelCode,Status,Active,OrderNumber);");

tu.executeUpdate("ALTER TABLE item_snap ADD INDEX index_4(OrderNumber,ChannelID,Status)");
tu.executeUpdate("ALTER TABLE item_snap ADD INDEX index_4(ChannelID,Status,OrderNumber)");

//2017-02-16
//江苏卫视200w数据item表查询慢，后来增加一个索引解决
tu.executeUpdate("ALTER TABLE item_snap ADD INDEX index_5(Status,ChannelID)");

//给工作量统计用
ALTER TABLE item_snap ADD INDEX index_5(ChannelCode,CreateDate,User,Status)

//不清楚OrderNumber放在前面还是后面好 2012-11-17

//增加related_doc表索引
tu.executeUpdate("ALTER TABLE related_doc ADD INDEX index_2(GlobalID),add index index_3(RelatedGlobalID);");

//解决频道树慢，频道太多的情况
ALTER TABLE channel ADD INDEX SerialNo(SerialNo)

ALTER TABLE `tidemedia_cms_2`.`channel_s5_a` DROP INDEX `Active`,
 ADD INDEX `Active` USING BTREE(`OrderNumber`, `Active`);

Add Index category using betrr('category','status');

ALTER TABLE `tidemedia_cms_2`.`channel_s13_a` ADD INDEX `ordernumber`(`OrderNumber`, `IsPhotoNews`);

ALTER TABLE `tidemedia_cms_2`.`page_module` ADD INDEX `page`(`Page`);

ALTER TABLE `tidemedia_cms_2`.`channel_template` ADD INDEX `channel`(`Channel`);

ALTER TABLE `tidemedia_cms_2`.`field_desc` ADD INDEX `channel`(`ChannelID`);

ALTER TABLE `tidemedia_cms_2`.`page_module_content` ADD INDEX `module`(`Module`);

ALTER TABLE files_info ADD INDEX Name(Name);

//大频道索引
ALTER TABLE channel_s10_a ADD INDEX `ordernumber`(OrderNumber, IsPhotoNews),add index active(Category,Active,OrderNumber);
ALTER TABLE channel_s10_a ADD INDEX 'index_6' (ChannelCode, Active,OrderNumber);

alter table channel_s5_a add index GlobalID(GlobalID);

alter table document_content add index Channel(Channel,Document);

alter table uchome_blog add index tide(hot,dateline);

//拆条素材
alter table channel_chaitiao_f4v add index chaitiao_channel(chaitiao_channel);


alter table channel_s30_b add index report(User,CreateDate);

DROP INDEX email ON fuinfo;

//20200116
ALTER TABLE publish_item ADD INDEX Status(Status);

//20200120 图片库
ALTER TABLE channel_photo ADD INDEX Parent(Parent);

//查看索引
//SHOW   INDEX   FROM   table
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!