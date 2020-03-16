<%@ page import="  java.io.File,
						 java.io.FileOutputStream,
						 java.io.IOException,
						 java.io.InputStream,
						 java.io.OutputStream,
						 java.net.HttpURLConnection,
						 java.net.MalformedURLException,
						 java.util.*,
						 java.net.URL,
						 java.net.URLConnection,
						 java.sql.SQLException,
						 org.jsoup.Jsoup,
						 org.jsoup.nodes.Attribute,
						 org.json.*,
						 org.jsoup.select.Elements,
						 tidemedia.cms.base.MessageException,
						 tidemedia.cms.system.Channel,
						 tidemedia.cms.system.CmsCache,
						 tidemedia.cms.system.CmsFile,
						 tidemedia.cms.system.Log,
						 tidemedia.cms.system.Site,
						 tidemedia.cms.util.FileUtil,
						 tidemedia.cms.util.TideJson,
						 tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"  %>
<%!
    // 2015-10-21更新，当图片地址为图片库域名时不继续下载。
    public  String getflag_random() {
        java.util.Random r = new java.util.Random();
        String Aa = "abcdefghijklmnopqrstwvuxyzABCDEFGHIJKLMNOPQRSTWVUXYZ";
        String flag = "";

        for (int i = 0; i < 8; i++) {
            int random = r.nextInt(51);
            if (random != 0) {
                flag += Aa.substring(random - 1, random);
            } else {
                flag += Aa.substring(random, random + 1);
            }
        }
        return flag;
    }

    private  boolean isConnect(String url) {
        URL urlStr;
        HttpURLConnection connection;
        int state = -1;
        String succ;
        int counts = 0;
        succ = null;
        if (url == null || url.length() <= 0) {
            return false;
        }
        while (counts < 5) {
            try {
                urlStr = new URL(url);
                connection = (HttpURLConnection) urlStr.openConnection();
                state = connection.getResponseCode();
                connection.setConnectTimeout(4000);
                // System.out.println(state);
                if (state == 200) {
                    succ = connection.getURL().toString();
                }
                return true;
            } catch (Exception ex) {

                ex.printStackTrace();
                return false;
            }
        }
        return true;
    }



    public boolean JudgePhoto(String url) {
        boolean flag = false;
        try {
            String Urls = CmsCache.getParameterValue("urllist");
            String[] list_url = Urls.split(",");
            for (String localurl : list_url) {
                if (url.contains(localurl)) {
                    flag = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;

    }

    public  HashMap getPhoto(String url, int userid) throws MessageException, SQLException {
        HashMap resultMap=new HashMap();
        try {

            TideJson photo_config = CmsCache.getParameter("sys_config_photo")
                    .getJson();// 图片及图片库配置
            int sys_channelid_image = photo_config.getInt("channelid");
            // int force_httpurl = photo_config.getInt("force_httpurl");

            Channel channel = CmsCache.getChannel(sys_channelid_image);
            Site site = channel.getSite();
            String Path = channel.getRealImageFolder();
            String SiteUrl = site.getExternalUrl2();

            String SiteFolder = site.getSiteFolder();
            String RealPath = SiteFolder
                    + (SiteFolder.endsWith("/") ? "" : "/") + Path;

            File file = new File(RealPath);
            if (!file.exists())
                file.mkdirs();
            String FileName = url.substring(url.lastIndexOf("/") + 1);
            String FileExt = "";
            int index = FileName.lastIndexOf(".");
            if (index != -1) {
                FileExt = FileName.substring(index + 1);
            }
            // 若图片地址没有扩展名，则取随机字符作为文件名

            if (FileExt.equals("")) {
                FileName = getflag_random() + ".jpg";
            }
            CmsFile cmsfile = new CmsFile();
            String NewFileName = cmsfile.getNewFileName(FileName, Path, 0);
            // File uploadedFile = new File(RealPath + "/" + NewFileName);
            String ReturnValue = "";
            String photo = Util.ClearPath(SiteUrl + Path + "/" + NewFileName);
            ReturnValue = Util.ClearPath(Path + "/" + NewFileName);

            if (isConnect(url)) {// 判断图片地址是否可用

                boolean download_flag = downloadFile(
                        url, RealPath + NewFileName);

                FileUtil fileutil = new FileUtil();
                fileutil.PublishFiles(NewFileName,
                        RealPath.replace(SiteFolder, ""), SiteFolder, userid,
                        site);

                if (download_flag) {
                    resultMap.put("photo",photo);
                    return resultMap;
                }
            }else{
                resultMap.put("message","链接地址无效");
            }
        } catch (Exception e) {
            Log.SystemLog("图片本地化失败", "错误信息如下:" + e.toString());
            e.printStackTrace();
            resultMap.put("photo","");
            resultMap.put("message",e.toString());
            return resultMap;
        }
        resultMap.put("photo","");
        return resultMap;

    }

    public  boolean downloadFile(String fileurl, String target)
    {
        boolean result = false;
        try
        {
            URL url = new URL(fileurl);
            URLConnection con = url.openConnection();
            con.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 5.0; Windows NT; DigExt)");
            InputStream is = con.getInputStream();
            byte[] bs = new byte[1024];

            String target2 = target;
            int jj = target.lastIndexOf("/");
            if (jj != -1)
                target2 = target.substring(0, jj);
            File f = new File(target2);
            if (!f.exists()) {
                f.mkdirs();
            }
            OutputStream os = new FileOutputStream(target);
            int len;
            while ((len = is.read(bs)) != -1)
            {

                os.write(bs, 0, len);
            }

            os.close();
            is.close();
            result = true;
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return result;
    }
    public JSONObject getContent(String Content, int userid) throws MessageException, SQLException, JSONException {
        JSONObject obj=new JSONObject();


        ArrayList<HashMap> PicStatus = new ArrayList<HashMap>();
        TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();// 图片及图片库配置
        int sys_channelid_image = photo_config.getInt("channelid");

        Channel channel = CmsCache.getChannel(sys_channelid_image);
        Site site = channel.getSite();
        String SiteUrl = site.getExternalUrl2();

		Content = Content.replaceAll("crossorigin=\"anonymous\"","");

        org.jsoup.nodes.Document doc_jsoup = Jsoup.parse(Content);// jsoup解析内容
        Elements ele_back = doc_jsoup.select("[style*=background-image]");// 获取图片background-image标签

        Elements ele = doc_jsoup.select("img");// 获取图片标签
        if (ele != null && ele.size() > 0||ele_back != null && ele_back.size() > 0) {
            //背景图片本地化
            for(int a = 0; a < ele_back.size(); a++){
                String back_image = ele_back.get(a).attr("style");

                HashMap status_map=new HashMap();
                status_map=cssStr(back_image,SiteUrl,userid,Content);
                PicStatus.add(status_map);

                String Content2=(String)status_map.get("Content");

                if(Content2!=null){
                    Content=Content2;
                }

            }

            for (int i = 0; i < ele.size(); i++) {
                HashMap status_map=new HashMap();
                String old_src = "";
                String old_data_src="";
                String photo_src = ele.get(i).attr("src");
                String photo_data_src = ele.get(i).attr("data-src");

                old_src = photo_src;// 为了替换原文本
                old_data_src = photo_data_src;

                status_map.put("old_src",photo_src);//即将本地化的地址

                List<Attribute> listAtt=ele.get(i).attributes().asList();
                for(Attribute at:listAtt){
                    if(at.html().startsWith("src")){
                        if(Content.indexOf(old_src)==-1){
                            old_src=at.html().replace("src=\"","").replace("\"", "").trim();//如果源图片被转义后   直接用attr获取的字符串会被取消转义
                        }
                    }
                    if(at.html().startsWith("data-src")){
                        if(Content.indexOf(old_data_src)==-1){
                            old_data_src=at.html().replace("data-src=\"","").replace("\"", "").trim();//如果源图片被转义后   直接用attr获取的字符串会被取消转义
                        }
                    }
                }



                //System.out.println("旧图片地址"+old_src);
                /*
                 * if (!photo_src.toLowerCase().startsWith("http://")) {
                 * photo_src = item_url + "/" + photo_src;//
                 * 若不带http头，则将图片相对地址与网站地址相拼接 }
                 */




                if ((photo_src.toLowerCase().startsWith("http://")|| photo_src.toLowerCase().startsWith("https://"))&&(old_data_src==null|| old_data_src.equals(""))) {
                    // out.println("执行标识"+save_image+"执行图片本地化");
                    // out.println("原图片"+photo_src);
                    String photo = "";
                    try {

                        if (!old_src.startsWith(SiteUrl)) {
                            HashMap resultmap=getPhoto(photo_src, userid);
                            photo = (String)resultmap.get("photo");
                            status_map.put("message",(String)resultmap.get("message"));//失败原因
                        }else{
                            status_map.put("status",0);//是否失败
                            status_map.put("message","已被本地化");//失败原因
                        }
                    } catch (Exception e) {
                        // TODO Auto-generated catch block
                        Log.SystemLog("内容页----图片本地化失败",
                                "错误信息如下:" + e.toString());
                        e.printStackTrace();
                        status_map.put("status",0);//是否失败
                        status_map.put("message",e.getMessage());//失败原因
                        continue;
                    }
                    if (!photo.equals("")) {// 图片下载失败，则原地址不改变原录入内容
                        Content = Content.replace(old_src, photo);
                        status_map.put("status",1);//成功
                        status_map.put("new_src",photo);
                    }else{
                        status_map.put("status",0);//是否失败
                        status_map.put("new_src","");
                    }

                }

                if ((photo_data_src.toLowerCase().startsWith("http://")|| photo_data_src.toLowerCase().startsWith("https://"))&&(photo_data_src!=null&& !photo_data_src.equals(""))) {
                    // out.println("执行标识"+save_image+"执行图片本地化");
                    // out.println("原图片"+photo_src);

                    String photo = "";
                    try {
                        if (!old_data_src.startsWith(SiteUrl)) {
                            HashMap resultmap=getPhoto(photo_data_src, userid);
                            photo = (String)resultmap.get("photo");
                            status_map.put("message",(String)resultmap.get("message"));//失败原因
                        }else{
                            status_map.put("status",0);//是否失败
                            status_map.put("message","已被本地化");//失败原因
                        }
                    } catch (Exception e) {
                        // TODO Auto-generated catch block
                        Log.SystemLog("内容页----图片本地化失败",
                                "错误信息如下:" + e.toString());
                        e.printStackTrace();
                        status_map.put("status",0);//是否失败
                        status_map.put("message",e.getMessage());//失败原因
                        continue;
                    }
                    if (!photo.equals("")) {// 图片下载失败，则原地址不改变原录入内容
                        Content = Content.replace(old_src, photo);
                        status_map.put("status",1);//是否失败
                        status_map.put("new_src",photo);
                    }else{
                        status_map.put("status",0);//是否失败
                        status_map.put("new_src","");
                    }

                }
                PicStatus.add(status_map);
            }

            int count=0;
            JSONArray array = new JSONArray();
            for(HashMap oneMap:PicStatus){
                count ++ ;
                int status=(Integer)oneMap.get("status");
                String old_src=(String)oneMap.get("old_src");
                String new_src=(String)oneMap.get("new_src");
                String message=convertNull((String)oneMap.get("message"));

                JSONObject jsonObject = new JSONObject();
                jsonObject.put("count",count);
                jsonObject.put("status",status);
                jsonObject.put("old_src",old_src);
                jsonObject.put("new_src",new_src);
                jsonObject.put("message",message);

                array.put(jsonObject);

            }
            obj.put("content",Content);
            obj.put("list",array);
            obj.put("message","");
        }else{
            obj.put("content",Content);
            obj.put("message","没有图片需要本地化");
            obj.put("list",new JSONArray());
        }



        return obj;
    }



    public HashMap cssStr(String str,String SiteUrl,int userid,String Content)
    {
        System.out.println("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"+str);

        String s1 = str.substring(str.indexOf("background-image: url(")+ 23, str.length());
        String s2 = s1.substring(0,s1.indexOf("\");"));
       //String reg = "\\w+\\.(jpg|gif|bmp|png)";

        String old_src= s2;
//		try{
//			if (s2.contains("png")){
//				old_src= str.substring(str.indexOf("background-image: url(") + 23, str.lastIndexOf(".png")+4);
//			}else if (s2.contains(".jpg")){
//				old_src= str.substring(str.indexOf("background-image: url(") + 23, str.lastIndexOf(".jpg")+4);
//			}else if (s2.contains(".gif")){
//				old_src= str.substring(str.indexOf("background-image: url(") + 23, str.lastIndexOf(".gif")+4);
//			}else if (s2.contains(".bmp")){
//				old_src= str.substring(str.indexOf("background-image: url(") + 23, str.lastIndexOf(".bmp")+4);
//			}
//        }catch(Exception e){
//			e.printStackTrace();
//		}
        
        HashMap status_map = new HashMap();
        status_map.put("old_src",old_src);//即将本地化的地址
        if(!old_src.equals("")||old_src.length()!=0) {
            String photo_src = old_src;
           
            if ((photo_src.toLowerCase().startsWith("http://") || photo_src.toLowerCase().startsWith("https://"))) {
                // out.println("执行标识"+save_image+"执行图片本地化");
                // out.println("原图片"+photo_src);
                String photo = "";

                try {

                    if (!old_src.startsWith(SiteUrl)) {
                        HashMap resultmap = getPhoto(photo_src, userid);
                        photo = (String) resultmap.get("photo");
                        status_map.put("message", (String) resultmap.get("message"));//失败原因
                    } else {
                        status_map.put("status", 0);//是否失败
                        status_map.put("message", "已被本地化");//失败原因
                    }
                } catch (Exception e) {
                    // TODO Auto-generated catch block
                    Log.SystemLog("内容页----图片本地化失败",
                            "错误信息如下:" + e.toString());
                    e.printStackTrace();
                    status_map.put("status", 0);//是否失败
                    status_map.put("message", e.getMessage());//失败原因
                }
                if (!photo.equals("")) {// 图片下载失败，则原地址不改变原录入内容
                    
                    Content = Content.replace(old_src, photo);
                    //System.out.println("5555Content+:" + Content);
                    status_map.put("new_src",photo);
                    status_map.put("Content", Content);

                    status_map.put("status", 1);//成功
                } else {
                    status_map.put("status", 0);//是否失败
                    status_map.put("new_src","");
                }
              
            }
        }else {
            status_map.put("message", "没有图片需要本地化");
        }
        return  status_map;
    }

%>
<%
    JSONObject obj = new JSONObject();
    try{
        String content = "";
        Enumeration enumeration = request.getParameterNames();
        while(enumeration.hasMoreElements()){
            String name=(String)enumeration.nextElement();
            String values[] = request.getParameterValues(name);
            if(name.equals("content")){
                content=values[0];
            }
        }
        obj = getContent(content,1);
        obj.put("status",1);
    }catch(Exception e){
        e.printStackTrace();
        obj.put("status",0);
        obj.put("message","本地化失败");
    }
    out.println(obj.toString());
%>
