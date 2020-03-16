<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				java.io.*,
				java.net.*,
				java.util.*,
				org.json.JSONObject,
				org.dom4j.Element,
				org.dom4j.Attribute,
				org.dom4j.io.SAXReader"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>


<%
    JSONObject jsonObject = new JSONObject();
    try{
        int cloud_id	=	getIntParameter(request,"id");//globalid
        int parent = getIntParameter(request,"parent");//父频道id
        int channelid = getIntParameter(request,"sourceid");
        String NewChannelName=getParameter(request,"NewChannelName");
        String NewFolder=getParameter(request,"NewFolder");
        String keyword=getParameter(request,"keyword");
        org.dom4j.Document  xml_document = null;
        boolean import_template = true;
        boolean import_public = true;
        boolean import_document = true;

        String description=getParameter(request,"description");

		TideJson special = CmsCache.getParameter("special").getJson();
        String url = special.getString("url")+"/temp/"+channelid+".zip";//"http://jushi.tidemedia.com/cms/api/special_channelfile.jsp?globalid="+cloud_id;
        String tempPath= getClass().getClassLoader().getResource("../../").getPath() + "temp/import/";

        System.out.println("tempPath："+tempPath);
        String filename = channelid+".zip";
        String zippath=tempPath+filename;
        File file=new File(zippath);
        //如果文件不存在
        if(!file.exists()){
            downloadFile(url,tempPath,filename);
        }
        //实例化类
        ChannelImport channel_import = new ChannelImport();
        String  xmlpath="";
        boolean r = channel_import.InitTemplateFileMd5();
        if(!r) {return ;}
        if(filename.endsWith(".zip")){
            System.out.println("import:"+zippath);
            if (filename.lastIndexOf(".")!=-1){
                filename=filename.substring(0,filename.lastIndexOf("."));
                xmlpath=tempPath+filename+"/"+filename+".xml";
            }
            //解压zip到当前目录下面
            channel_import.unZipFiles(file,tempPath+filename+"/");
        }else if (filename.endsWith(".xml")){
            xmlpath=tempPath+filename;
        }else {
            jsonObject.put("message","只支持zip和xml文件");
            return;
        }

        Channel channel = CmsCache.getChannel(parent);
        //设置基本值
        channel_import.setChannelid(parent);
        System.out.println("云专题频道parent:"+parent);
        channel_import.setFilename(filename);
        channel_import.setUserid(userinfo_session.getId());
        channel_import.setImport_document(true);
        channel_import.setImport_template(true);
        channel_import.setImport_channel(true);


        //修改xml文件里面的属性名称
        SAXReader reader = new SAXReader();
        xml_document = reader.read(new File(xmlpath));
        channel_import.setXml_document(xml_document);
        Element rootElement = xml_document.getRootElement();
        List nodes = rootElement.elements("channel");
        int i=0 ;
        int GroupID = 0 ;

        for (Iterator it = nodes.iterator(); it.hasNext();) {
            i++ ;

            Element element = (Element) it.next();

            if(i==1&&import_template){
                //新建模板分组

                Attribute channelName = element.attribute("Name");
                channelName.setValue(NewChannelName);


                Attribute folder = element.attribute("FolderName");
                folder.setValue(NewFolder);


                String  channelName2 = element.attributeValue("Name");
                System.out.println("云专题频道6channelName2:"+channelName2);
                if(!import_public){

                    channelName2 = channel.getSite().getName()+System.currentTimeMillis()/1000/60;
                }

                GroupID = channel_import.templategroup(channelName2);

            }


            System.out.println("云专题频道9channel:"+channel.getId());
            channel_import.ImportChannelInfo_(element,channel.getId(),GroupID);


        }
		//频道导入成功后，下载静态文件
		Site site = channel.getSite();
		String SiteFolder = site.getSiteFolder();
		String RealPath = SiteFolder + (SiteFolder.endsWith("/") ? "" : "/")+channel.getFullPath()+NewFolder+"/";//站点真实目录
		String url1 = special.getString("url")+"/temp/"+channelid+"_html.zip";//静态文件下载地址
		File special_file=new File(RealPath+channelid+"_html.zip");
        //如果文件不存在
        if(!special_file.exists()){
            downloadFile(url1,RealPath,channelid+"_html.zip");
			channel_import.unZipFiles(special_file,RealPath);
        }

		//页面频道
		channel_import.copyOnePage();


        //是否导入文章
        if(import_document)
        {
            HashMap map_channel=channel_import.getMap_channel();
            DocumentImport documentimport = new DocumentImport();
            documentimport.setFilename(filename);
            documentimport.setMap_channel(map_channel);
            documentimport.setUserid(userinfo_session.getId());
            documentimport.Start();
        }else {

            //删除解压的文件
            System.out.println("删除路径tempPath:"+tempPath);
            System.out.println("删除路径filename:"+filename);
            File file1=new File(tempPath+filename);
            deleteFile(file1);
        }


		jsonObject.put("status","0");
		jsonObject.put("message","导入成功");
		out.println(jsonObject.toString());
        
    }catch(Exception e){
   
        jsonObject.put("status","1");
        jsonObject.put("message","程序异常:"+e.toString());
        out.println(jsonObject.toString());
       
    }
%>
<%!

    @SuppressWarnings("finally")
    public static File downloadFile(String urlPath, String downloadDir ,String filename) {
        File file = null;
        try {
			//System.out.println("urlPath:"+urlPath);
            // 统一资源
            URL url = new URL(urlPath);
            // 连接类的父类，抽象类
            URLConnection urlConnection = url.openConnection();
            // http的连接类
            HttpURLConnection httpURLConnection = (HttpURLConnection) urlConnection;
            //设置超时
            httpURLConnection.setConnectTimeout(1000*5);
            //设置请求方式，默认是GET
            httpURLConnection.setRequestMethod("POST");
            // 设置字符编码
            httpURLConnection.setRequestProperty("Charset", "UTF-8");
            // 打开到此 URL引用的资源的通信链接（如果尚未建立这样的连接）。
            httpURLConnection.connect();
            // 文件大小
            int fileLength = httpURLConnection.getContentLength();

            // 控制台打印文件大小
            System.out.println("您要下载的文件大小为:" + fileLength + "Byte");

            // 建立链接从请求中获取数据
            URLConnection con = url.openConnection();
            BufferedInputStream bin = new BufferedInputStream(httpURLConnection.getInputStream());
            // 指定文件名称(有需求可以自定义)
            String fileFullName = filename;
            // 指定存放位置(有需求可以自定义)
            String path = downloadDir + File.separatorChar + fileFullName;
            file = new File(path);
            // 校验文件夹目录是否存在，不存在就创建一个目录
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            OutputStream out = new FileOutputStream(file);
            int size = 0;
            int len = 0;
            byte[] buf = new byte[2048];
            while ((size = bin.read(buf)) != -1) {
                len += size;
                out.write(buf, 0, size);
                // 控制台打印文件下载的百分比情况
                System.out.println("下载了-------> " + len * 100 / fileLength + "%\n");
            }
            // 关闭资源
            bin.close();
            out.close();
            System.out.println("文件下载成功！");
        } catch (MalformedURLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            System.out.println("文件下载失败！");
        } finally {
            return file;
        }

    }
    //删除文件夹
    public static void deleteFile(File file) {
        if(file.exists()) {//判断路径是否存在
            if(file.isFile()){//boolean isFile():测试此抽象路径名表示的文件是否是一个标准文件。
                file.delete();
            }else{//不是文件，对于文件夹的操作
                //保存 路径D:/1/新建文件夹2  下的所有的文件和文件夹到listFiles数组中
                File[] listFiles = file.listFiles();//listFiles方法：返回file路径下所有文件和文件夹的绝对路径
                for (File file2 : listFiles) {
                    /*
                     * 递归作用：由外到内先一层一层删除里面的文件 再从最内层 反过来删除文件夹
                     *    注意：此时的文件夹在上一步的操作之后，里面的文件内容已全部删除
                     *         所以每一层的文件夹都是空的  ==》最后就可以直接删除了
                     */
                    deleteFile(file2);
                }
            }
            file.delete();
        }else {
            System.out.println("该file路径不存在！！");
        }
    }

%>

