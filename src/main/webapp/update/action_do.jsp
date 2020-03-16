<%@ page import="org.dom4j.Element,
				 org.dom4j.io.SAXReader,
				 org.json.JSONObject,
				 tidemedia.cms.base.MessageException,
				 tidemedia.cms.base.TableUtil" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.util.TideJson" %>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%@ include file="update_api.jsp" %>
<%
    int itemId = getIntParameter(request, "itemid");
    int siteid = getIntParameter(request, "siteid");
    TideJson update_api = CmsCache.getParameter("update_api").getJson();
    String url = "";
    String token = "";
    if (update_api != null) {
        url = update_api.getString("url");
        token = update_api.getString("token");
    } else {
        url = "http://jushi.tidemedia.com/cms/update_api/";
        token = "tidemedia";
    }
    String result = "";
    if (itemId != 0) {
        //执行语句
        result = Util.connectHttpUrl(url + "action_details.jsp?token=" + token + "&itemId=" + itemId, "UTF-8");
    }
    //System.out.println("result="+result);

    //回调升级日志逻辑
    Parameter system_ico = CmsCache.getParameter("system_ico");
    String title = URLEncoder.encode(system_ico.getJson().getString("title"),"UTF-8");//项目名称
    int parent = itemId;//在线升级文章id   URLEncoder.encode(userinfo_session.getName(),"UTF-8")
    String userName = URLEncoder.encode(userinfo_session.getName(),"UTF-8");
    StringBuffer requestURL = request.getRequestURL();
    String requestURI = request.getRequestURI();
    String url1 = requestURL.substring(0, requestURL.indexOf(requestURI));
    String ip = request.getRemoteAddr();

    JSONObject jsonObject = new JSONObject(result);
    String executeSql = jsonObject.getString("executeSql");
    String update_type = jsonObject.getString("update_type");
    String db = jsonObject.getString("db");
    TableUtil tu = null;
    if (db.equals("用户库")) {
        tu = new TableUtil("user");
    } else {
        tu = new TableUtil();
    }

    if (update_type.equals("执行SQL")) {
        if (!executeSql.equals("")) {
            String sql = "";
            try {
                String[] sql_ = Util.StringToArray(executeSql, "\n");

                for (int i = 0; i < sql_.length; i++) {
                    sql = sql_[i];
                    if (sql.length() > 0) tu.executeUpdate(sql);
                }
            } catch (Exception e) {
                Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
                out.println(e.getMessage() + "," + sql);
                return;
            }
            Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=1&ip="+ip);
            out.println("执行成功!");
        }
    }

    if (update_type.equals("频道调整")) {
        String channel_json = jsonObject.getString("channel_json");
        if (channel_json.length() == 0) {
            out.println("缺少配置参数");
            Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
            return;
        }

        SAXReader reader = new SAXReader();
        org.dom4j.Document document = reader.read(new ByteArrayInputStream(channel_json.getBytes("utf-8")));

        // 得到xml根元素
        Element root = document.getRootElement();
        //out.println(root);
        List nodes = root.elements("channel");
        for (Iterator it = nodes.iterator(); it.hasNext(); ) {
            Element element = (Element) it.next();
            //out.println("aa");
            String SerialNo = element.attributeValue("SerialNo");
            String ParentSerialno = element.attributeValue("ParentSerialno");
            String Name = element.attributeValue("Name");
            int type = Util.parseInt(element.attributeValue("Type"));
            //out.println(element);

            String parent_serialno = "s" + siteid + "_" + ParentSerialno;
            Channel parent_ch = CmsCache.getChannel(parent_serialno);
            if (parent_ch == null) {
                out.println("没找到父频道");
                Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
                return;
            }

            String serialno = "s" + siteid + "_" + SerialNo;
            String Sql = "select * from channel where SerialNo='" + tu.SQLQuote(serialno) + "'";
            if (tu.isExist(Sql)) {
                out.println("频道已存在!");
                Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
                return;
            }

            createChannel(Name, parent_ch.getId(), type, serialno, "");
            Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=1&ip="+ip);
            out.println("已创建频道：" + Name);
        }

/*
		JSONObject jsonObject1 = new JSONObject(channel_json);
		String parent_serialno = "s"+siteid+"_"+jsonObject1.getString("parent_serialno");
		Channel parent_ch = CmsCache.getChannel(parent_serialno);
		if(parent_ch==null)
		{
			out.println("没找到父频道");
			return;
		}
		
		String name = jsonObject1.getString("name");
		int type = jsonObject1.getInt("type");
		String serialno = "s"+siteid+"_"+jsonObject1.getString("serialno");
		String Sql = "select * from channel where SerialNo='" + tu.SQLQuote(serialno)+"'";
		if (tu.isExist(Sql)) {
			out.println("频道已存在!");
			return;
		}
		createChannel(name,parent_ch.getId(),type,serialno,"");
		out.println("频道已创建!");*/
    }


    if (update_type.equals("字段调整")) {
        String channel_json = jsonObject.getString("channel_json");
        if (channel_json.length() == 0) {
            out.println("缺少配置参数");
            Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
            return;
        }

        SAXReader reader = new SAXReader();
        org.dom4j.Document document = reader.read(new ByteArrayInputStream(channel_json.getBytes("utf-8")));

        // 得到xml根元素
        Element root = document.getRootElement();
        //out.println(root);
        List nodes = root.elements("channel");
        String message = "";
        for (Iterator it = nodes.iterator(); it.hasNext(); ) {
            Element element = (Element) it.next();

            String SerialNo = element.attributeValue("SerialNo");
            String SerialNo_ = SerialNo.replace("{$site}", siteid + "");//"s"+siteid+"_"+SerialNo;
            System.out.println("SerialNo_:" + SerialNo_);
            Channel ch = CmsCache.getChannel(SerialNo_);
            if (ch == null) {
                out.println("没找到对应频道");
                Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
                return;
            }

            Element ele_fields = element.element("fields");
            List nodes_field = ele_fields.elements("field");
            for (Iterator it2 = nodes_field.iterator(); it2.hasNext(); ) {

				/* 字段说明 勿删
				private String Options = "";
				private int IsHide;// 是否隐藏 0 不隐藏 1 隐藏
				private int DisableEdit = 0;//是否禁止编辑 1 禁止编辑 0 允许编辑
				private int DisableBlank;// 不允许为空 0 允许为空 1 不允许为空 
				private int FieldLevel;// 1,系统自带 2,用户自定义
				private int EditorType;//0 标准版编辑器 1精简版 2H5版
				private String Style;
				private String DefaultValue;
				private String Other;
				private String HtmlTemplate = "";//显示模板
				private String DictCode = "";//字典代码
				private int Size;
				private String Site;
				private String RecommendChannel = "";//推荐频道的标识
				private String RecommendValue = "";//推荐频道的对应关系
				private String Value = "";//字段对应的数值
				private String GroupChannel = "";//集合频道的标识
				private int		DataType = 0;//数据类型，0 为字符，1为数字
				private int 	RelationChannelID = 0;//关联字段对应的频道编号
				private String	JS = "";//脚本
				private String 	Caption = "";//说明
				*/


                Element e = (Element) it2.next();
                String Action = e.attributeValue("Action");
                String Name = e.attributeValue("Name");
                System.out.println("Action:" + Action + "," + Name);

                String Description = e.attributeValue("Description");
                String FieldType = e.attributeValue("FieldType");
                String DefaultValue = e.attributeValue("DefaultValue");
                String Caption = e.attributeValue("Caption");
                int DisableBlank = Util.parseInt(e.attributeValue("DisableBlank"));

                String Options = Util.convertNull(e.attributeValue("Options"));
                String Other = Util.convertNull(e.attributeValue("Other"));
                System.out.println("Options:" + Options);
                String DataType_ = Util.convertNull(e.attributeValue("DataType"));
                int DataType = Util.parseInt(DataType_);

                //if(Action.equals("add"))
                //{
                //增加字段
                Field field = null;
                try {
                    field = new Field(Name, ch.getId());
                } catch (MessageException ee) {
                    field = new Field();
                }

                System.out.println("field:" + Name + "," + field.getId());
                field.setChannelID(ch.getId());
                //field.setGroupID(GroupID);
                //field.setIsHide(IsHide);
                field.setDisableBlank(DisableBlank);
                //field.setDisableEdit(DisableEdit);
                field.setName(Name);
                field.setDescription(Description);
                field.setFieldType(FieldType);
                field.setOptions(Options);

                field.setDefaultValue(DefaultValue);
                field.setOther(Other);

                //field.setHtmlTemplate(HtmlTemplate);
                //field.setDictCode(DictCode);
                //field.setSize(Size);
                //field.setStyle(Style);
                //field.setRecommendChannel(RecommendChannel);
                //field.setRecommendValue(RecommendValue);
                //field.setGroupChannel(GroupChannel);
                field.setDataType(DataType);
                //field.setRelationChannelID(RelationChannelID);
                field.setCaption(Caption);
                //if(field.getId()
                if (field.getId() > 0) {
                    System.out.println("field1:" + Name + "," + field.getId());
                    try {
                        field.Update();
                    } catch (Exception ee) {
                        Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
                        ee.printStackTrace(System.out);
                        return;
                    }
                    Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=1&ip="+ip);
                    message += "频道：" + ch.getName() + " 更新字段：" + Description + "(" + Name + ")<br>";
                } else {
                    System.out.println("field2:" + Name + "," + field.getId());
                    try {
                        field.Add();
                    } catch (Exception ee) {
                        Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
                        ee.printStackTrace(System.out);
                        return;
                    }
                    Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=1&ip="+ip);
                    message += "频道：" + ch.getName() + " 创建字段：" + Description + "(" + Name + ")<br>";
                }
                //}
                //out.println("field name:"+fieldname);
            }
        }
        out.println(message);
    }

    if (update_type.equals("更新静态文件")) {
        System.out.println("==========更新静态文件==========");

        String files = jsonObject.getString("file");
        if (files.length() == 0) {
            out.println("缺少静态文件参数");
            Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
            return;
        }

        String siteFolder = "";
        String path = "http://tcenter-update.tidemedia.com";
        String message = "";
        if (siteid != 0) {
            Site site = new Site(siteid);
            siteFolder = site.getSiteFolder();
        } else {
            out.println("站点id为0");
            Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
            return;
        }

        if (siteFolder.length() == 0) {
            out.println("站点路径为空");
            Util.connectHttpUrl("http://jushi.tidemedia.com/cms/api/upgrade_log.jsp?Title="+title+"&parent="+parent+"&userName="+userName+"&url="+url1+"&status2=2&ip="+ip);
            return;
        }

        String[] file_ = Util.StringToArray(files, "\n");

        for (int i = 0; i < file_.length; i++) {
            /*file里面存的是文件路径   需要 域名等+站点+文件路径;  拉取获取到的文件判断项目中同目录下是
             *否有该文件 如果有 同步,如果没有 新建      并用out.println();输出信息
             * http://tcenter-update.tidemedia.com/a.txt
             */

			/*
	   	 	String file = file_[i];
	     	System.out.println("file"+i+"===="+file);
	     	System.out.println("siteFolder==="+siteFolder);
	     	String  sourcePath = path+file;//源文件
	     	String  destPath = siteFolder+file;//更新文件
	     	System.out.println("sourcePath ==="+sourcePath);
	     	System.out.println("destPath ==="+destPath);
     		String content = Util.postHttpUrl(sourcePath, "");
     		if(content.length() > 0){//读取文件内容不为空
     			message = "复制文件成功";
     			FileUtils.write(new File(destPath),content,"utf-8"); 
           	    System.out.println(message);
           	 	out.println(message);
     		}else{
     			message = "读取文件内容为空";
     			System.out.println(message);
     			out.println(message);
     		}
			*/
        }
    }
%>