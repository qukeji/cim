<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.concurrent.*,
				java.io.*,
				java.sql.*,
				org.json.*,
				java.net.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
/*
*通过接口获取文件路径，拼接url，到服务器下载文件
*/
		//String cmsPath=CmsCache.getParameterValue("cmsPath");//"D://tomcat_demo/webapps/cms_test/"
		String cmsPath=request.getSession().getServletContext().getRealPath("");
		//out.println("cmsPath="+cmsPath);
		int id=getIntParameter(request,"id");
		TableUtil tu = new TableUtil();
		
		String api_site="http://www.tidecms.com/cms/update/";
		String json2 = Util.connectHttpUrl(api_site+"api_getupdate.jsp?id="+id,"utf-8");

		JSONObject jo2=new JSONObject(json2);
		String dofilename = jo2.getString("do_after_updated");
		String updatedtitle=jo2.getString("title");

		//System.out.println("dofilename="+dofilename);
		//String api_download_site="http://www.tidecms.com/cms/update/api_download.jsp";
		String files="";
		String name="";
		String url="";
		String id_="";	
		String content_json = Util.connectHttpUrl(api_site+"api_getupdatefiles.jsp?id="+id,"utf-8");
		String from="";
		String to="";
		String filename="";
		String filepath="";

		JSONObject jo=new JSONObject(content_json);
		JSONArray ja = jo.getJSONArray("files");
		for(int i=0;i<ja.length();i++){
			JSONObject jo_=ja.getJSONObject(i);
			name=jo_.getString("name");
			url=jo_.getString("url");
			id_=jo_.getString("id");	
			filename=jo_.getString("filename");
			String path=url.replace("/"+name,"");
			String tempath=id_+path;
			from=api_site+"api_download.jsp?FileName="+filename+"&FolderName="+id_+url;
			//out.println("from="+from);
			String realto="";
			//String filepath=to.replace("/"+name,"");
			to=cmsPath+url+"/"+filename;
			//String folderpath = to.replace(name,"");
			to = to.replace("\\","/");
			filepath=to.replace(filename,"");
			File file=new File(filepath);
			if(!file.exists()){
				file.mkdirs();
			}
			//out.println("from="+from+"    to="+to+"    filepath="+filepath);
			//download(from,to);
			//System.out.println("-------------from="+from+"    to="+to);
			if(!dofilename.equals("")){
				if(filename.equals(id+".jsp")){
					from=api_site+"api_download.jsp?FileName="+id+".jsp"+"&FolderName=/do_after_update";
				}
			}
			File f2 = new File(to);
				if(f2.exists()){
				f2.delete();
				//out.println("删除完成");
			}
			URL url_file = new URL(from);
			HttpURLConnection connection = (HttpURLConnection) url_file.openConnection();
			InputStream input = connection.getInputStream();
			RandomAccessFile oSavedFile = new RandomAccessFile(to,"rw");
			byte[] b = new byte[1024];
			int nRead;
			while ((nRead = input.read(b, 0, 1024)) > 0) {
				oSavedFile.write(b, 0, nRead);
			}
			input.close();
			oSavedFile.close();
			connection.disconnect();
			
		}
		if(!dofilename.equals("")){
			String realPath1 = "http://" + request.getServerName()+ request.getContextPath()+request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")+1);
			String dourl = realPath1+id+".jsp";
			String ssss=Util.connectHttpUrl(dourl,"utf-8");
		}
		UserInfo userinfo = userinfo_session;
		int userid = userinfo.getId();
		long updatedtime = System.currentTimeMillis()/1000;
		String s_add  ="insert into tidecms_update (title,updatedid,userid,updatedtime) value ('"+updatedtitle+"','"+id+"','"+userid+"','"+updatedtime+"')";
		//System.out.println("update over!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		tu.executeUpdate(s_add);

		String s = "select * from tidecms_update order by updatedtime desc";
		ResultSet rs = tu.executeQuery(s);

		String title="";
		//int id=0;
		int updatedid=0;
		//int userid=0;
		//long updatedtime=(long)0;
		if(rs.next()){
			id = rs.getInt("id");
			updatedid=rs.getInt("updatedid");
			userid = rs.getInt("userid");
			updatedtime=rs.getLong("updatedtime");
			updatedtitle = rs.getString("title");

			//System.out.println("find it");
			out.println("id="+id+"    title="+updatedtitle+"    updatedid="+updatedid+"    userid="+userid+"    updatedtime="+updatedtime);
		}

%>