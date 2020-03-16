<%@ page import="tidemedia.cms.system.*,
				 tidemedia.cms.util.*,
				 java.util.*,
				 java.sql.*,
				 tidemedia.cms.base.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.jsoup.Jsoup" %>
<%@ page import="org.jsoup.select.Elements" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="java.io.File" %>
<%@ page import="tidemedia.cms.publish.Publish" %>
<%@ page import="tidemedia.cms.publish.PublishManager" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//导入微小宝编辑器模板
%>
<%!
	public int isExistSource(int Realchannelid,int sourceid)throws Exception{
		int id=0;
		TableUtil tu=new TableUtil();
		String sql="select * from "+CmsCache.getChannel(Realchannelid).getTableName()+" where Category="+Realchannelid+" and sourceid="+sourceid;
		ResultSet rs=tu.executeQuery(sql);
		if(rs.next()){
			id=rs.getInt("id");
		}
		tu.closeRs(rs);
		return id;
	}
	public void publishPhoto(String h5imageFolder,Site site) throws Exception{
		Publish publish = new Publish();
		publish.InsertToBePublished(Util.ClearPath(h5imageFolder),site.getSiteFolder(),site);
		PublishManager.getInstance().CopyFileNow();
	}
%>
<%
	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();// 图片及图片库配置
	int sys_channelid_image = photo_config.getInt("channelid");
	Channel channel = CmsCache.getChannel(sys_channelid_image);
	Site site = channel.getSite();
	String SiteUrl = site.getExternalUrl2();//访问目录
	String SiteFolder = site.getSiteFolder();
	String RealPath = SiteFolder + (SiteFolder.endsWith("/") ? "" : "/") + "images/h5/";//服务器真实路径
	File file = new File(RealPath);
	if (!file.exists())
		file.mkdirs();
%>
<%
	if(!userinfo_session.isAdministrator())
	{ response.sendRedirect("../noperm.jsp");return;}
	request.setCharacterEncoding("utf-8");


	String url = "https://api.wxb.com/style/tagList";//接口地址

	TideJson json = CmsCache.getParameter("relation_h5_source").getJson();//获取所有模板分组
	Iterator iterator = json.getJson().keys();
	while (iterator.hasNext())
	{
		String key = (String) iterator.next();//模板分组编号
		int value = json.getInt(key);//模板入库频道编号
		int page_=1;
		boolean flag = true;
		while(flag){
			String url1 = url + "?id="+key+"&page="+page_+"&pageSize=30";
			out.println("<br>url:"+url1+"<br>");

			String result = Util2.connectHttpUrl(url1);
			JSONObject obj = new JSONObject(result);
			boolean fileexist=true;
			if(obj.getInt("errcode")==0&&obj.getInt("totalCount")>0) {//说明有数据

				JSONArray arr = obj.getJSONArray("data");
				for(int i=0;i<arr.length();i++){
					JSONObject json_message = arr.getJSONObject(i);
					int template_id = json_message.getInt("id");//模板id
					out.println("template_id:"+template_id+" ; ");

					//判断本地是否已存在此模板
					int id1=isExistSource(value,template_id);
					if(id1!=0){//说明已经本地化
						flag = false;
					    break;
					}

					//未本地化的模板入库
					String html = json_message.getString("style");
					org.jsoup.nodes.Document doc = Jsoup.parse(html);

					//img标签图片本地化
					int j = 0 ;
					Elements elements = doc.getElementsByTag("img");
					for(Element element : elements){
						String img = element.attr("src") ;//img地址
						if(!img.equals("")){
							String img_new = key+"_"+template_id+"_"+(j++)+".png";
							String path = RealPath+"/"+img_new ;
							File file1 = new File(path);
							if(!file1.exists()){
								Util.downloadFile(img,path);//本地化图片
								publishPhoto("/images/h5/"+img_new,site);
							}
							element.attr("src", "/images/h5/"+img_new);//替换为相对路径
						}
					}

					//url背景图片本地化
					int n = 0 ;
					Elements allelements = doc.getElementsByAttribute("style");
					for(Element element : allelements){
						String style = element.attr("style");//style样式
						if(style.indexOf("url(")!=-1){
							String img_url = style.substring(style.indexOf("url")+4);//背景图地址
							if(img_url.startsWith("'")||img_url.startsWith("\"")){
								img_url = img_url.substring(1,img_url.indexOf(")")-1);
							}else{
								img_url = img_url.substring(0,img_url.indexOf(")"));
							}
							if(!img_url.equals("")){
								String img_new = "style_"+key+"_"+template_id+"_"+(n++)+".png";
								String path = RealPath+"/"+img_new ;
								File file1 = new File(path);
								if(!file1.exists()){
									Util.downloadFile(img_url,path);
									publishPhoto("/images/h5/"+img_new,site);
								}
								style = style.replace(img_url, "/images/h5/"+img_new);
								element.attr("style", style);
							}
						}
					}

					String content = doc.body().html().replaceAll("微小宝","").replaceAll("weixiaobao","").replaceAll("wxb","").replaceAll("WXB","");

					HashMap map=new HashMap ();
					map.put("Title",template_id+"");
					map.put("sourceid",template_id+"");
					map.put("Content",content);
					map.put("Status","1");
					map.put("update_time",json_message.getString("update_time"));
					map.put("create_time",json_message.getString("create_time"));

					ItemUtil tu=new ItemUtil();
					tu.addItemGetGlobalID(value,map);

				}
			}

			if(page_==10){
			    break;
			}
			page_++;
		}

	}



%>