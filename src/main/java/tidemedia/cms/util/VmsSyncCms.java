/**
 * author admin	
 * created on 2014-7-21下午01:38:20
 */
package tidemedia.cms.util;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.ItemUtil;
import tidemedia.cms.system.Log;

public class VmsSyncCms 
{
	//判断频道是否存在
	public static int isExist(int parent,int child)	throws MessageException,SQLException
	{ 
		Channel channel = CmsCache.getChannel(parent);
		if(channel.getExtra1().contains("{\"vms\":"+child+"}"))
		//if(channel.getExtra1().contains("{\"vmsChannelID\":"+child+"}"))
			return channel.getId(); 
		ArrayList<Channel> list = channel.listAllSubChannels();
		for(Channel temp :list)
		{   
			if(temp.getExtra1().contains("{\"vms\":"+child+"}"))
			//if(temp.getExtra1().contains("{\"vmsChannelID\":"+child+"}"))                            
				return  temp.getId();
		 }
		
		return -1;
	}
	//添加频道
	//12.24 whl 同步到cms的频道列表页和内容页继承父频道
	//12.24 whl 频道对应的目录也vms一一对应
	//public synchronized void addNewChannel(int cms,int vms,String url,HttpSession session)
	public static synchronized void addNewChannel(int cms,String vms,String url,HttpSession session,String token) throws MessageException,SQLException
	{       
	
	  String[] parents = vms.split(",");
	  int parent =cms;
	  for(int i=0;i<parents.length;i++)
	  {             
	  		int result = isExist(cms,Integer.parseInt(parents[i]));
	  		if(result!=-1) 
	  			parent=result; 
	  		else
	  		{  
	  			//System.out.println(parent+"==parent");		       
		        Channel p = CmsCache.getChannel(parent);
		        String content_url = p.getListProgram();
		        String document_url = p.getDocumentProgram();
		        
		        String serialno = p.getAutoSerialNo();
		      	int ii = serialno.lastIndexOf("_");
		       	String foldername = serialno.substring(ii + 1);
				
				String channelinfo = Util.connectHttpUrl(url+"?channelid="+parents[i]+"&token="+token,"utf-8"); 	  			   
		        JSONObject object;
				try {
					object = new JSONObject(channelinfo);
					Channel channel = new Channel();
					channel.setName(object.getString("Name"));
					channel.setParent(parent);
					//channel.setFolderName(foldername );
					channel.setFolderName(object.getString("FolderName"));
					channel.setImageFolderName(object.getString("ImageFolderName"));
					 channel.setSerialNo(serialno);
					channel.setIsDisplay(object.getInt("IsDisplay"));
					channel.setIsWeight(object.getInt("IsWeight"));
					channel.setIsComment(object.getInt("IsComment"));
					channel.setIsClick(object.getInt("IsClick"));
					channel.setIsShowDraftNumber(object.getInt("IsShowDraftNumber"));	
					channel.setType(object.getInt("ChannelType"));
					channel.setHref(object.getString("Href"));
					channel.setAttribute1(object.getString("Attribute1"));
					channel.setAttribute2(object.getString("Attribute2"));
					channel.setRecommendOut(object.getString("RecommendOut"));
					channel.setRecommendOutRelation(object.getString("RecommendOutRelation"));
					channel.setExtra1("{\"vms\":"+object.getInt("Id")+"}");
					//channel.setExtra1("{\"vmsChannelID\":"+object.getInt("Id")+"}");
					
					channel.setExtra2("");
					channel.setListJS(object.getString("ListJS"));
					channel.setDocumentJS(object.getString("DocumentJS"));
					//channel.setListProgram(object.getString("ListProgram"));
					//channel.setDocumentProgram(object.getString("DocumentProgram"));
					channel.setListProgram(content_url);
					channel.setDocumentProgram(document_url);
					channel.setTemplateInherit(object.getInt("TemplateInherit"));
					channel.setDataSource(object.getString("DataSource"));	
					channel.setActionUser(1);
					channel.setViewType(object.getInt("ViewType"));
					channel.setIsListAll(object.getInt("IsListAll"));
					channel.Add();
					parent = channel.getId();
					session.removeAttribute("channel_tree_string");					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace(System.out);
					System.out.println("connect api:"+url+",resturn:"+channelinfo);
				}
				

	  		}
	  }
	  
	}
	private static boolean hasField(int channelid,String fieldname)
		throws MessageException,SQLException
	{        
                 boolean res = false;
		Channel ch = CmsCache.getChannel(channelid);
		String sql = "desc "+ch.getTableName()+" "+fieldname;
		TableUtil tu = ch.getTableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())	res= true;
        tu.closeRs(rs);
		return res;
	}
	//添加字段
	public static synchronized void addField(int cms,JSONObject object)
		throws SQLException,MessageException,JSONException
	{
		 int id = object.getInt("channel");
		 int channelid = isExist(cms,id);
		 if(channelid>0)
		 {//频道存在
		 	Channel ch = CmsCache.getChannel(channelid);
		 	TableUtil tu = ch.getTableUtil();
		 	JSONArray array = object.getJSONArray("field");
			for(int i=0;i<array.length();i++)
			{	
				HashMap field = new HashMap();
				//字段属性
				JSONObject jo = array.getJSONObject(i);
				String name = jo.getString("name");
				String type = jo.getString("type");
				
				if(type.equals("number"))
					type = " int default 0";
				else if(type.equals("textarea"))
					type="text";
				else 
					type="varchar(255)";
					 
				if(!hasField(channelid,name))
				{
					tu.executeUpdate("ALTER TABLE " +ch.getTableName()+" ADD "+name+" "+type);
				}
			}
		 }
		 
	}
	
	public static synchronized int hasRecord(int cms,String wheresql )	throws MessageException,SQLException
	{
		int res = -1;
		Channel ch = CmsCache.getChannel(cms);
		String sql = "select * from "+ch.getTableName()+ wheresql;
		TableUtil tu = ch.getTableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
		{
			res = rs.getInt("globalid");
		}
		tu.closeRs(rs);
		return res;
	}
	
	//获取字段名与值
	private static HashMap getFieldMap(JSONArray array)
		throws JSONException
	{
			HashMap map = new HashMap();
			for(int i=0;i<array.length();i++)
			{	
				HashMap field = new HashMap();
				//字段属性
				JSONObject jo = array.getJSONObject(i);
				String name = jo.getString("name");
				String value = jo.optString("value","");
				String type = jo.getString("type");
				if(type.equals("number") && value.equals(""))value="0";
				/*if(name.equals("PublishStatus")&&value.equals(""))value="0";	
				if(name.equals("Status2")&&value.equals(""))value="0";	
				if(name.equals("Status")&&value.equals(""))value="0";	
				if(name.equals("Duration")&&value.equals(""))value="0";	
				if(name.equals("uid")&&value.equals(""))value="0";	
				if(name.equals("progress")&&value.equals(""))value="0";*/
				if(!name.equals("Weight")&&!name.equals("IsPhotoNews")&&!name.equals("ugc_itemid")&&!name.equals("PublishDate")&&!name.equals("globalid")) 
					map.put(name,value);
			}
            map.put("tidecms_addGlobal","1");
			//map.put("User","1"); //1224 whl注释，数据同步到cms后 用户和vms保持一致
			return map;
	}
	
	//添加视频地址信息 operateTransocde
	public static synchronized void addUrl(int action,int parent,int vgid,String token) throws SQLException,MessageException
	{
		TideJson tj = CmsCache.getParameter("vms_sync_cms").getJson();
		int transcode = 4;//固定频道编号 tj.getInt("transcode");
		String url = tj.getString("transcode_url");
		String result = Util.connectHttpUrl(url+"?parent="+vgid+"&token="+token,"utf-8");
		JSONArray jArray;
		try {
			
			TableUtil tu = new TableUtil();
			String sql = "delete from " + CmsCache.getChannel(transcode).getTableName()+" where Parent="+parent;
			tu.executeUpdate(sql);
			
			jArray = new JSONArray(result);
			for(int i=0;i<jArray.length();i++)
			{
				JSONObject o = jArray.getJSONObject(i);
				//System.out.println(o.getString("globalid"));
				int gid = o.getInt("globalid");
				int video_type = o.getInt("video_type");
				String video_dest = o.getString("video_dest");
				String desc = o.optString("video_desc");
				
				HashMap map = new HashMap();
				map.put("Title", video_dest);
				map.put("Parent", parent+"");
				map.put("VideoID",gid+"");
				map.put("Url", video_dest);
				map.put("video_type", video_type+"");
				map.put("Status", "1");
				map.put("video_desc", desc);
				ItemUtil.addItem(transcode,map);

			}			
		} catch (JSONException e) {
			Log.SystemLog("同步vms视频", "读取接口错误："+url+",VideoID:"+vgid);
			e.printStackTrace(System.out);
			System.out.println("connect api:"+url+",resturn:"+result);
		}

		 
	}
	
	
	//记录更新，修改，删除
	public static synchronized void operateRecord(int action,int cms_channelid,JSONObject object,String token) throws MessageException, JSONException, SQLException, IOException, ParseException {
		 TideJson tj = CmsCache.getParameter("vms_sync_cms").getJson();
		 int transcode = 14259;//tj.getInt("transcode");
		 int id = object.getInt("channel");
		 int channelid = isExist(cms_channelid,id);
		 int vgid = object.getInt("globalid");
		 int status = object.getInt("status");
		 int user = object.getInt("user");
		 if(channelid>0)
		 {
			//频道存在
		 	Channel ch = CmsCache.getChannel(channelid);
		 	TableUtil tu = ch.getTableUtil();
		 	JSONArray array = object.getJSONArray("field");
		 	
			HashMap map = getFieldMap(array);
			String title = (String)map.get("Title");
			map.put("VideoID",vgid+"");
			map.put("Status",status+"");
			map.put("User",user+"");//user从vms同步过来 1224 whl
			int gid = hasVideo(channelid,vgid);
			//if(action==1) 
				//gid = ItemUtil.addItem(channelid,map).getGlobalID();

			Document doc = null;
 
			if(action!=6)
			{
				if(gid==0)
				{
					doc = ItemUtil.addItem(channelid, map);
					gid = doc.getGlobalID();
					
					Log.SystemLog("同步vms视频", "添加视频："+title+",频道:"+ch.getName()+"("+channelid+")");
				}
				else
				{
					 
					ItemUtil.updateItemByGid(channelid,map,gid,1);
					doc = new Document(gid);
					
					//doc.UpdateDocument(map);//同时发布文件
					Log.SystemLog("同步vms视频", "修改视频："+title+",频道:"+ch.getName()+"("+channelid+")");
				}
				if(status==1)
					doc.Publish(doc.getId()+"", channelid);
				
				addUrl(action,gid,vgid,token);
			}
			else if(action==6)//删除
			{
				Document document = new Document(gid);
				ArrayList<Document> tList =ItemUtil.listItems(transcode," where parent= "+gid);
				//先删除转码视频
				for(Document d:tList)					 
					d.Delete(d.getId()+"", transcode);
				//删除视频库视频
				document.Delete(document.getId()+"",channelid);		
				Log.SystemLog("同步vms视频", "删除视频："+title+",频道:"+ch.getName()+"("+channelid+")");
			}
			/*
		   if((action==4||action==5)&&gid==-1)
			//if((action==4||action==5||action==1)&&gid==-1)//action==1是自动发布
		    {
				//发布或保存并发布且cms不存在时添加
				gid = ItemUtil.addItem(channelid,map).getGlobalID();
			}
			else if((action==4||action==5||action==2||action==3)&&gid>0)
			{
				//同步更新cms
				ItemUtil.updateItemByGid(channelid,map,gid,1);
			}
			else if(action==6&&gid>0)
			{					
				Document document = new Document(gid);
				ArrayList<Document> tList =ItemUtil.listItems(transcode," where parent= "+gid);
				//先删除转码视频
				for(Document d:tList)					 
					d.Delete(d.getId()+"", transcode);
				//删除视频库视频
				document.Delete(document.getId()+"",channelid);
			}
			*/
			//转码记录
			
		 }
		 else
		 {
			 Log.SystemLog("同步vms视频", "对应频道不存在，频道编号："+cms_channelid);
		 }
	}
	
	//视频是否存在
	public static int hasVideo(int cms,int vgid)	throws MessageException,SQLException
	{
		int gid = 0;
		Channel ch = CmsCache.getChannel(cms);
		String sql = "select globalid from "+ch.getTableName()+ " where Active=1 and VideoID="+vgid;
		//System.out.println(sql);
		TableUtil tu = ch.getTableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
		{
			gid = rs.getInt("globalid");
		}
		tu.closeRs(rs);
		
		return gid;
	}	
}
