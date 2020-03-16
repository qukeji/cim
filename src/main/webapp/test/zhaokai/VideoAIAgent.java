package tidemedia.cms.video.ai;

import java.io.DataOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.commons.io.IOUtils;
import org.json.JSONException;
import org.json.JSONObject;

import com.baidubce.services.vca.model.QueryResultResponse;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ItemUtil;
import tidemedia.cms.system.Log;
import tidemedia.cms.util.TideJson;
import tidemedia.cms.util.Util;

import tidemedia.cms.video.TranscodeGlobalBean;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.Channel;

/**
 * 线程，从数据库获取视频信息，提交分析，将结果保存数据库
 * @author cpw
 * @2019年5月20日
 */
public class VideoAIAgent implements Runnable{
	private Thread 	runner;
	
	public void start()
	{
		if(runner==null)
		{
	        runner = new Thread(this);
	        runner.start();
		}
	}
	
	@Override
	public void run() {
		TideJson aiParameter = null;
		System.out.println("AI识别功能进程运行");

		do{
			try {
                aiParameter = CmsCache.getParameter("ai_info").getJson();
                //根据系统参数判断是否开启AI功能（1:开启，0：关闭）
                if(aiParameter.getInt("open") == 1){
                    submitVideo();//提交视频进行AI分析
                    queryResult();//查询分析结果
                }

				Thread.sleep(1000*60);//休眠1分钟

			} catch (Exception e) {
				System.out.println("VideoAIAgent error:" + e.getMessage());
				e.printStackTrace(System.out);
			}
		}while(true);
	}
	
	/**
	 * 1.将为提交分析的视频提交分析  并且 将未分析状态修改为 正在分析
	 * isanaly 未分析(0) 分析成功(1) 分析中(2) 分析失败(3)
	 * @throws Exception 
	 */
	public void submitVideo() throws MessageException, SQLException {
		//ai配置
		TideJson tidejson = CmsCache.getParameter("ai_info").getJson();
		int voice = tidejson.getInt("voice");
		int text = tidejson.getInt("text");
		int face = tidejson.getInt("face");
		int label = tidejson.getInt("label");
		int authorization = tidejson.getInt("authorization");
		//String company = tidejson.getString("company");



		Channel channel = CmsCache.getChannel("video_ai_result");//ai智能识别信息

		TableUtil tu = new TableUtil();
		//查出所有需要分析的视频，提交百度分析
		String sql = "select * from " + channel.getTableName() + " where Status=1 and isanaly = 0 limit 10";
		ResultSet Rs = tu.executeQuery(sql);

		ArrayList array = new ArrayList();
		while (Rs.next()) {
			int Globalid = Rs.getInt("globalid");
			int Parent = Rs.getInt("Parent");//视频库id
			int Company = Rs.getInt("thread_comapny");
			String Title = Rs.getString("Title");
			//Document document = CmsCache.getDocument(id);
			String Source = getTranscodingPath(Parent);//document.getId()视频库id
			System.out.println("submitVideo AI:" + Parent + "," + Title + "," + Source);
			if (Source.length() > 0) {
				HashMap map = new HashMap();
				map.put("globalid", Globalid);
				map.put("parent", Parent);
				map.put("company", Company);
				map.put("title", Title);
				map.put("source", Source);
				array.add(map);
			}
		}
		tu.closeRs(Rs);

		for (int i = 0; i < array.size(); i++) {
			HashMap map = (HashMap) array.get(i);
			int globalid = (int) map.get("globalid");
			int parent = (int) map.get("parent");
			int company = (int) map.get("company");
			String title = (String) map.get("title");
			String source = (String) map.get("source");
			Videoanalyze v = new Videoanalyze();
			try {
				if(company==0){
					v.setVideoAnalysis(source);//提交百度分析
					System.out.println("submitVideo AI:submit to baidu");
				}
				if(company==1){//提交腾讯分析
					//腾讯ai
					TideJson baidu_tidejson = CmsCache.getParameter("tengxun_ai_info").getJson();
					String tx_url = baidu_tidejson.getString("tx_url");
					String tx_callback_url = baidu_tidejson.getString("tx_callback_url");
					JSONObject data = new JSONObject();
					data.put("mediaGuid",globalid);
					data.put("mediaUrl",getTengXunPath(parent));
					data.put("name",title);
					data.put("sourceSystem","");
					data.put("type","video");
					int index = source.indexOf(".");
					String format = source.substring(index+1);
					data.put("format",format);//
					JSONObject video = new JSONObject();
					video.put("face",face);
					video.put("voice",voice);
					video.put("label",label);
					data.put("taskInfo",video);
					data.put("callbackUrl",tx_callback_url);
					doHttpPost( data.toString(), tx_url);
					System.out.println("submitVideo AI:submit to tengxun");
				}

				String sql_ = "update " + channel.getTableName() + " set isanaly = 2 where Parent = " + parent;
				new TableUtil().executeUpdate(sql_);
			}catch(Exception e)
			{
				System.out.println("submitVideo AI:submit to baidu error");
				String sql_ = "update " + channel.getTableName() + " set isanaly = 3 where Parent = " + parent;
				new TableUtil().executeUpdate(sql_);
				Log.SystemLog("AI识别","接口提交失败 视频ID:"+parent+",source:"+source+",info:"+e.getMessage());
			}
		}

		//System.out.println("submitVideo AI: " + array.size());
	}

	//查询结果
	//isanaly 未分析(0) 分析成功(1) 分析中(2) 分析失败(3)
	public void queryResult() throws Exception {
		Channel channel = CmsCache.getChannel("video_ai_result");//ai智能识别信息
		TableUtil tu = new TableUtil();
		TableUtil tu2 = new TableUtil();
		//查出所有需要分析的视频，提交百度分析
		String sql = "select * from " + channel.getTableName() + " where Status=1 and thread_comapny=0 and isanaly = 2 limit 10";
		ResultSet Rs = tu.executeQuery(sql);

		ArrayList array = new ArrayList();
		while (Rs.next()) {
			int id = Rs.getInt("id");
			int Parent = Rs.getInt("Parent");//视频库id
			String title = Rs.getString("Title");
			//Document document = CmsCache.getDocument(id);
			String source = getTranscodingPath(Parent);//document.getId()视频库id
			System.out.println("queryResult AI:" + id + "," + title + "," + source);
			if (source.length() > 0) {
				HashMap map = new HashMap();
				map.put("id",id);
				map.put("source", source);
				array.add(map);
			}
		}
		tu.closeRs(Rs);

		for (int i = 0; i < array.size(); i++) {
			HashMap map = (HashMap) array.get(i);
			int id = (int)map.get("id");

			String source = (String) map.get("source");

			Videoanalyze v = new Videoanalyze();
			QueryResultResponse response = null;
			response = (QueryResultResponse) v.getVideoanalyze(source);

			String voice    = "";
			String words    = "";
			String face    = "";
			String tags    = "";
			System.out.println("response==="+response);
			//当视频分析状态为 未分析时，更新为 已分析
			String status = response.getStatus();//返回视频结果状态
			if("FINISHED".equals(status)){
				String subTaskResponse1 = v.querySubTaskResult(source, "speech");//语音识别json
				String subTaskResponse2 = v.querySubTaskResult(source,"character");//文字识别json
				String subTaskResponse3 = "";
				//v.querySubTaskResult(source,"face_recognition_thumbnail");//非tracking版本的公有人脸识别模型
				//if(subTaskResponse3.length() == 0) {
					subTaskResponse3 = v.querySubTaskResult(source,"face_recognition_tracking");//tracking版本的公有人脸识别模型
				//}
				voice  = tu2.convertNull(subTaskResponse1);
				words   = tu2.convertNull(subTaskResponse2);
				face    = tu2.convertNull(subTaskResponse3);
				tags = tu.convertNull(getNewStr(response + "")); //标签json
				//tags = tu.convertNull(response + "");
			}
			String jsonResponse = "";
			jsonResponse = v.getNewStr(response);
			String log = "地址为：" + source + " 的视频AI分析结果为：" + jsonResponse;
			//insertlog(log);//添加日志
			//Log.SystemLog("AI识别",log);

			HashMap<String, String> map2 = new HashMap<String, String>();
			map2.put("Status", "1");
			//当返回状态为 FINISHED 时，将返回结果写入 analy_result 字段
			if("FINISHED".equals(status)){
				map2.put("isanaly", "1");//分析成功
			}else if("ERROR".equals(status)){
				map2.put("isanaly", "3");//分析失败
			}else if("PROVISIONING".equals(status) || "PROCESSING".equals(status)) {//PROVISIONING-视频分析排队中     PROCESSING	-视频分析进行中
				continue;
			}else if("CANCELLED".equals(status)) { //CANCELLED 分析取消，视频排队时可以取消分析
				map2.put("isanaly", "3");//分析失败
			}

			//maps1.put("isanaly", maps1.get("isanaly"));
			map2.put("analy_result", log);
			map2.put("ai_speech", voice);
			map2.put("ai_character", words);
			map2.put("ai_face", face);
			map2.put("ai_tag", tags);
			System.out.println("queryResult AI:updateItem id:"+id+",ai_speech:"+voice);
			ItemUtil.updateItemById(channel.getId(), map2,id, 0);
		}
	}

	/**
	 * 百度返回数据不是正常的json数据，在此处理
	 */
	public String getNewStr(String str) throws JSONException {
    	//去掉这三个“类名”
		str = str.replace("QueryResultResponse{", "{");
		str = str.replace("TagsResult{", "{");
		str = str.replace("ResultItem{", "{");
		str = str.replace("VcaError{", "{");
		
		//key重复，重命名
		str = str.replace("publishTime", "publishTime1");
		str = str.replaceFirst("publishTime1", "publishTime2");
		
		//将 = 替换为 :
		str = str.replace("=", ":");
		//转换json
		JSONObject json =  new JSONObject(str);
		String jsonStr = json.toString();
		return jsonStr;
		
	}

	/**
	 * 获取转码路径
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public String getTranscodingPath(int id) throws MessageException, SQLException {
        int channelid = 8800;
//        List<Map<String,String>> list = new ArrayList<Map<String,String>>();
        int channelid_video = CmsCache.getParameter("sys_channelid_transcode").getIntValue();
         
        Channel channel = CmsCache.getChannel(channelid);
        
        TranscodeGlobalBean tgb = new TranscodeGlobalBean();
        String video_url = tgb.getVideo_url();
        
        //预览地址没有填写，预览视频时使用站点的预览地址
        if(video_url.length()==0)
        {
        	video_url = channel.getSite().getUrl();
        }
        Document doc = new Document(id,channelid);
        ArrayList<Document> docs = ItemUtil.listItems(channelid_video," where Parent= "+doc.getGlobalID()+" and Active=1 and Status2=2 ");
        
        if(docs.size()==0)
        {
        	return "";
        }
        
        String flv = "";	
    	Document d = docs.get(docs.size()-1);//获取第一条
    	if(d.getValue("video_dest").endsWith(".flv") || d.getValue("video_dest").endsWith(".mp4")){
    		String cloud_url=d.getValue("cloud_url");

    		if(cloud_url!=null&&!cloud_url.equals("")&&(!d.getValue("video_dest").startsWith("http://"))){
    			flv= Util.ClearPath(cloud_url+"/"+d.getValue("video_dest"));
    		}else if(cloud_url.length()==0&&!d.getValue("video_dest").startsWith("http://")){
    			flv= Util.ClearPath(video_url+"/"+d.getValue("video_dest"));
    		}else{
    			flv= Util.ClearPath(d.getValue("video_dest"));
    		}
    		flv = Util.HTMLEncode(flv);
    	}
        return flv;
    }

	/**
	 * 获取视频内网地址以提交腾讯分析
	 * @param id
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	public String getTengXunPath(int id) throws MessageException, SQLException {
		int channelid = 8800;
//        List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		int channelid_video = CmsCache.getParameter("sys_channelid_transcode").getIntValue();
		String address = CmsCache.getParameterValue("tengxun_ai_address");//腾讯视频分析所需项目内网地址
		Channel channel = CmsCache.getChannel(channelid);
		TranscodeGlobalBean tgb = new TranscodeGlobalBean();
		String video_url = tgb.getVideo_url();

		//预览地址没有填写，预览视频时使用站点的预览地址
		if(video_url.length()==0)
		{
			video_url = channel.getSite().getUrl();
		}
		Document doc = new Document(id,channelid);
		ArrayList<Document> docs = ItemUtil.listItems(channelid_video," where Parent= "+doc.getGlobalID()+" and Active=1 and Status2=2 ");

		if(docs.size()==0)
		{
			return "";
		}

		String flv = "";
		Document d = docs.get(docs.size()-1);//获取第一条
		if(d.getValue("video_dest").endsWith(".flv") || d.getValue("video_dest").endsWith(".mp4")){
			String cloud_url=d.getValue("cloud_url");
			if(cloud_url!=null&&!cloud_url.equals("")&&(!d.getValue("video_dest").startsWith("http://"))){
				flv= Util.ClearPath(address+"/"+d.getValue("video_dest"));
			}else if(cloud_url.length()==0&&!d.getValue("video_dest").startsWith("http://")){
				flv= Util.ClearPath(address+"/"+d.getValue("video_dest"));
			}else{
				flv= Util.ClearPath(d.getValue("video_dest"));
			}
			flv = Util.HTMLEncode(flv);
		}
		return flv;
	}

	public static String doHttpPost(String xmlInfo, String URL) {
		System.out.println("发起的数据:" + xmlInfo);
		byte[] xmlData = xmlInfo.getBytes();
		InputStream instr = null;
		java.io.ByteArrayOutputStream out = null;
		try {
			URL url = new URL(URL);
			URLConnection urlCon = url.openConnection();
			urlCon.setDoOutput(true);
			urlCon.setDoInput(true);
			urlCon.setUseCaches(false);
			urlCon.setRequestProperty("content-Type", "application/json");
			urlCon.setRequestProperty("charset", "utf-8");
			urlCon.setRequestProperty("Content-length",
					String.valueOf(xmlData.length));
			System.out.println(String.valueOf(xmlData.length));
			DataOutputStream printout = new DataOutputStream(
					urlCon.getOutputStream());
			printout.write(xmlData);
			printout.flush();
			printout.close();
			instr = urlCon.getInputStream();
			byte[] bis = IOUtils.toByteArray(instr);
			String ResponseString = new String(bis, "UTF-8");
			if ((ResponseString == null) || ("".equals(ResponseString.trim()))) {
				System.out.println("返回空");
			}
			System.out.println("返回数据为:" + ResponseString);
			return ResponseString;

		} catch (Exception e) {
			e.printStackTrace();
			return "0";
		} finally {
			try {
				out.close();
				instr.close();

			} catch (Exception ex) {
				return "0";
			}
		}
	}
}
