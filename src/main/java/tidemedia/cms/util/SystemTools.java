package tidemedia.cms.util;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;

public class SystemTools {
	/**分组 getFieldGroup*/
	public String getFieldGroup(int ChannelID)throws Exception{
		StringBuilder buf=new StringBuilder();
		String sql="select * from field_group where channel="+ChannelID;
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		ResultSetMetaData rsmd = rs.getMetaData();
		int  ColumnCount=rsmd.getColumnCount();
		while(rs.next()){
			buf.append("<Group>");
			for(int i=1;i<=ColumnCount;i++){
				buf.append("<"+rsmd.getColumnName(i)+">");
				buf.append(tu.convertNull(rs.getString(rsmd.getColumnName(i))));
				buf.append("</"+rsmd.getColumnName(i)+">");
			}
			buf.append("</Group>");
		}
		tu.closeRs(rs);
		return buf.toString();
	}
	/**模板*/
	public String getChannelTemplate(int ChannelID)throws Exception{
		StringBuilder buf=new StringBuilder();
		String sql="select * from channel_template where channel="+ChannelID;
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		ResultSetMetaData rsmd = rs.getMetaData();
		int  ColumnCount=rsmd.getColumnCount();
		while(rs.next()){
			buf.append("<Template>");
			for(int i=1;i<=ColumnCount;i++){
				buf.append("<"+rsmd.getColumnName(i)+">");
				buf.append(tu.convertNull(rs.getString(rsmd.getColumnName(i))));
				buf.append("</"+rsmd.getColumnName(i)+">");
			}
			buf.append("</Template>");
		}
		tu.closeRs(rs);
		return buf.toString();
	}
	
	/**表的字段描述*/
	public String getFieldDesc(int ChannelID,String FieldName)throws Exception{
		StringBuilder buf=new StringBuilder();
		String sql="select * from field_desc where ChannelID="+ChannelID;
		sql+=" and FieldName='"+FieldName+"'";
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		ResultSetMetaData rsmd = rs.getMetaData();
		int  ColumnCount=rsmd.getColumnCount();
		if(rs.next()){	
			for(int i=1;i<=ColumnCount;i++){
				buf.append("<"+rsmd.getColumnName(i)+">");
				buf.append(tu.convertNull(rs.getString(rsmd.getColumnName(i))));
				buf.append("</"+rsmd.getColumnName(i)+">");
			}
		}
		tu.closeRs(rs);
		return buf.toString();
	}
	
	/**频道 getChannelXML*/
	public String getChannelXML(Channel channel)throws Exception{
		StringBuilder buf=new StringBuilder();
		String sql="select * from channel where id="+channel.getId();
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		ResultSetMetaData rsmd = rs.getMetaData();
		int  ColumnCount=rsmd.getColumnCount();
		buf.append("<Attribute>");
		if(rs.next()){	
			for(int i=1;i<=ColumnCount;i++){
				buf.append("<"+rsmd.getColumnName(i)+">");
				buf.append(tu.convertNull(rs.getString(rsmd.getColumnName(i))));
				buf.append("</"+rsmd.getColumnName(i)+">");
			}
		}
		buf.append("</Attribute>");
		tu.closeRs(rs);
		tu=new TableUtil();
	 	sql="select * from "+channel.getTableName();
	 	rs=tu.executeQuery(sql);
	 	rsmd = rs.getMetaData();
	 	ColumnCount=rsmd.getColumnCount();
		buf.append("<Fields>");
		if(rs.next()){	
			for(int i=1;i<=ColumnCount;i++){
				String f=getFieldDesc(channel.getId(),rsmd.getColumnName(i));
				if(!f.equals("")){
				buf.append("<Field>");
				buf.append(f);
				buf.append("</Field>");
				}
			}
		}
		tu.closeRs(rs);
		buf.append("</Fields>");
		
		buf.append("<Templates>");
		buf.append(getChannelTemplate(channel.getId()));
		buf.append("</Templates>");
		
		buf.append("<Groups>");
		buf.append(getFieldGroup(channel.getId()));
		buf.append("</Groups>");
		
		buf.append("<Channels>");
		ArrayList list=channel.listSubChannels();
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Channel c=(Channel)list.get(i);
				buf.append("<Channel>");
				buf.append(getChannelXML(c));
				buf.append("</Channel>");
			}
		}
		buf.append("</Channels>");
		return buf.toString();
	}
	
	public String makeChannelXML(int id) throws Exception{
		Channel channel = CmsCache.getChannel(id);
		StringBuilder buf=new StringBuilder();
		buf.append("<Channel>");
		buf.append(getChannelXML(channel));
		buf.append("<DataTime>");
		buf.append(Util.getCurrentDate("yyyy-MM-dd"));
		buf.append("</DataTime>");
		buf.append("</Channel>");
		return buf.toString();
	}
	
}
