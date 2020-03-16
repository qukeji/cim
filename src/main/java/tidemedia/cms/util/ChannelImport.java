package tidemedia.cms.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.page.Page;
import tidemedia.cms.page.PageModule;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Field;
import tidemedia.cms.system.TemplateFile;

public class ChannelImport {
	private int channelid = 0;
	private int userid = 0;
	private boolean import_document = false;//是否导入文章
	private boolean import_channel = false;//是否导入频道结构
	private boolean import_template = false;//是否导入模板
	private boolean import_public = false;//是否导入公共模板
	
	private String filename = "";//要导入的zip文件名
	private org.dom4j.Document   xml_document = null;
	private HashMap<Integer, Integer> map_channel = new HashMap<Integer, Integer>();//老频道编号，新频道编号
    private HashMap current_map_templatefile = new HashMap();//oldid,newid  旧模板ID，新模板ID
    private ArrayList<HashMap> PageList = new ArrayList<HashMap>();//首页集合


	
	public String start() throws MessageException, SQLException, IOException
	{
		String result = "导入成功";
		if(channelid<=0) return "频道不存在";
		
		String dir = getClass().getClassLoader().getResource("../../").getPath() + "temp/import/" ;
		String zippath = dir + filename;
		String xmlpath = "";

		File file = new File(zippath);
		if(!file.exists())
			return "文件不存在";
		
		boolean r = InitTemplateFileMd5();
		if(!r) return "";
		
		if(filename.endsWith(".zip"))
		{
			System.out.println("import:"+zippath);		
			if(filename.lastIndexOf(".")!=-1){
				filename = filename.substring(0, filename.lastIndexOf("."));
				xmlpath = dir + filename + "/" + filename + ".xml";
			}
			//解压zip文件到当前目录
			unZipFiles(file,dir+filename+"/");
		}
		else if(filename.endsWith(".xml"))
		{
			xmlpath = dir + filename;
		}
		else
		{
			return "只支持zip文件和xml文件";
		}
		
		Channel channel = CmsCache.getChannel(channelid);
				
		if(import_channel){
			ImportChannelInfo(channel,xmlpath);
			copyOnePage();
		}
		System.out.println("map_channel1:"+map_channel);
		if(import_document)
		{
			DocumentImport documentimport = new DocumentImport();
			documentimport.setFilename(filename);
			documentimport.setMap_channel(map_channel);
			documentimport.setUserid(userid);
			documentimport.Start();
		}
		
		return result;
	}
	
	
	
	public void ImportChannelInfo(Channel channel,String path)
	{
		System.out.println("ImportChannelInfo");
		SAXReader reader = new SAXReader();             
	    try {
	    	xml_document = reader.read(new File(path));
			Element root = xml_document.getRootElement();
			List nodes = root.elements("channel");
			int i=0 ;
			int GroupID = 0 ;
			for (Iterator it = nodes.iterator(); it.hasNext();) {
				i++ ;
				System.out.println("a");
				Element element = (Element) it.next();
				
				if(i==1&&import_template){
					//新建模板分组
					String channelName = element.attributeValue("Name");
					if(!import_public){
						channelName = channel.getSite().getName()+System.currentTimeMillis()/1000/60;
					}
					GroupID = templategroup(channelName);
				}
				ImportChannelInfo_(element,channel.getId(),GroupID);
			} 
		} catch (DocumentException | SQLException | MessageException | IOException e) {
			ErrorLog.SaveErrorLog("导入频道",e.getMessage(),channel.getId(),e);
			e.printStackTrace(System.out);
		} 
	}
	
	public void ImportChannelInfo_(Element element,int channelid,int GroupID) throws SQLException, MessageException, IOException
	{
		Channel parent = CmsCache.getChannel(channelid);
		System.out.println("import channel info id:"+element.attributeValue("Id")+",name:"+element.attributeValue("Name"));
		
		String SerialNo = "";
		
		String flag = element.attributeValue("auto") ;//是否自动生成标识名
		if(flag!=null&&flag.equals("false")){
			
			//获取原频道的站点编号
			String SiteID = element.attributeValue("SiteID") ;
			int newSiteId = parent.getSiteID();
			
			SerialNo = element.attributeValue("SerialNo");
			if(SerialNo.contains("s"+SiteID)){//包含站点编号，替换新站点编号（s53_phone_code > s54_phone_code）
				SerialNo = SerialNo.replace(SiteID, newSiteId+"");
			}else{
				SerialNo = "s"+newSiteId+"_"+SerialNo ;//不包含站点编号，增加站点编号 （phone_code > s54_phone_code)
			}
			
			TableUtil tu = new TableUtil();
			String Sql = "select * from channel where SerialNo='" + tu.SQLQuote(SerialNo)
			+ "'";
			// System.out.println(Sql);
			if (tu.isExist(Sql)) {
				SerialNo = parent.getAutoSerialNo();
			}
		}else{
			SerialNo = parent.getAutoSerialNo();
		}
		
		
		int Company = 0;
		String Application = "";
		if(element.attributeValue("Company")!=null){
			Company = Integer.parseInt(element.attributeValue("Company"));
		}
		if(element.attributeValue("Application")!=null){
			Application = element.attributeValue("Application");
		}

		Channel channel = new Channel();
		channel.setName(element.attributeValue("Name"));
		channel.setParent(channelid);
		channel.setFolderName(element.attributeValue("FolderName"));//使用原来的目录名
		channel.setImageFolderName(element.attributeValue("ImageFolderName"));

		channel.setSerialNo(SerialNo);//如果原来的SerialNo没有使用，就继续使用
		channel.setIsDisplay(element.attributeValue("IsDisplay"));
		channel.setIsWeight(Integer.parseInt(element.attributeValue("IsWeight")));
		channel.setIsComment(Integer.parseInt(element.attributeValue("IsComment")));
		channel.setIsClick(Integer.parseInt(element.attributeValue("IsClick")));
		channel.setIsShowDraftNumber(Integer.parseInt(element.attributeValue("IsShowDraftNumber")));
		channel.setType(Integer.parseInt(element.attributeValue("Type")));
		channel.setHref(element.attributeValue("Href"));
		channel.setExtra1(element.attributeValue("Extra1"));
		channel.setListJS(element.attributeValue("ListJS"));
		channel.setDocumentJS(element.attributeValue("DocumentJS"));
		channel.setListProgram(element.attributeValue("ListProgram"));
		channel.setDocumentProgram(element.attributeValue("DocumentProgram"));
		channel.setTemplateInherit(Integer.parseInt(element.attributeValue("TemplateInherit")));
		channel.setCompany(Company);
		channel.setApplication(Application);
		channel.setActionUser(userid);
		channel.Add();	
		int new_id = channel.getId();
/*				
		int Type = Integer.parseInt(element.attributeValue("Type"));
		if(Type==2){//首页
			Page p_ = new Page();
			p_.setName(element.attributeValue("Name"));
			p_.setParent(channelid);
			p_.setType(2);
			p_.setTemplate("index.shtml");
			p_.setTargetName("index.shtml");
			p_.Add();	
			new_id = p_.getId();
		}else{
			channel.Add();	
			new_id = channel.getId();
		}
*/				
		map_channel.put(Util.parseInt(element.attributeValue("Id")), new_id);
		int channel_type = Util.parseInt(element.attributeValue("Type"));
		
		//独立表单
		if(channel_type==0)
		{
			ImportChannelFields(element,new_id);
		}
		
		
		if(import_template) ImportChannelTemplate(element,new_id,GroupID);
		
		//导入页面频道
		List nodes_page = element.elements("page");
		for (Iterator it_page = nodes_page.iterator(); it_page.hasNext();) { 
			Element e = (Element) it_page.next();
			ImportPageInfo_(e,new_id,GroupID);
		}
		
		//导入普通频道
		List nodes = element.elements("channel");
		for (Iterator it = nodes.iterator(); it.hasNext();) { 
			System.out.println("a");
			Element e = (Element) it.next();
			ImportChannelInfo_(e,new_id,GroupID);
		}
	}
	
	//遍历获取xml中全部 Page 以及 PageModule对象
    public void ImportPageInfo_(Element element,int channelid,int GroupID) throws MessageException, SQLException {
    	
    	if (xml_document == null) return; 
    	
    	Element pageContent = element.element("pageContent");
    	String pagename=pageContent.attributeValue("pagename");//首页频道名称;
        String page_template_file_name =pageContent.attributeValue("page_template_file_name");//模板文件名
        
    	//先创建页面模板
        String pageContentText = pageContent.getText();//首页中内容  
        String md5 = StringUtils.getMD5(pageContentText);
        
        int insertid = 0;
        String Sql = "";
        TableUtil tu = new TableUtil(); 
        		
		boolean exist = false;
		if(import_public){//公共模板			
			Sql = "select id from template_files where ContentMd5='" + md5 + "'";
			ResultSet rs = tu.executeQuery(Sql);
			if(rs.next())
			{
				exist = true;
				insertid  =  rs.getInt("id") ;
			}
			tu.closeRs(rs);
		}
        
		if(!exist){
			//判断模板文件是否存在
	        Sql = "select id from template_files where Name='" + tu.SQLQuote(pagename) + "' and FileName='" + tu.SQLQuote(page_template_file_name) + "' and GroupID=" + GroupID;
	        ResultSet rs1 = tu.executeQuery(Sql);
	        if (rs1.next()) {
	            insertid = rs1.getInt("id");
	        }
	        tu.closeRs(rs1);
	        
	        if (insertid == 0) {
	            TemplateFile tf = new TemplateFile();
	            tf.setFileName(page_template_file_name);
	            tf.setName(pagename);
	            tf.setPhoto("");
	            tf.setDescription("");
	            tf.setGroup(GroupID);
	            tf.setActionUser(userid);
	            tf.Add();
	            insertid = tf.getId();
	        } else {
	            //更新模板内容
	            TemplateFile tf = new TemplateFile(insertid);
	            tf.setContent(pageContentText.replace("<!--#include", "<!--\\#include"));
	            tf.setActionUser(userid);
	            tf.UpdateContent();
	        }	
		}  
        
        //创建页面频道
		Page newPage = new Page();
        newPage.setName(pagename);
        newPage.setParent(channelid);
        newPage.setType(2);
        newPage.setTemplateID(insertid);
        newPage.setTemplate(page_template_file_name);
        newPage.setTargetName("index.shtml");
        newPage.setActionUser(userid);
        newPage.Add();
        int newPageID = newPage.getId();        
        
        //创建模块页面
        List PageModules = element.elements("pageModule");//获取频道对象下面的pageModule节点
        for (Iterator it_page = PageModules.iterator(); it_page.hasNext(); ) {
        	Element ModuleElement = (Element) it_page.next();//首页模板对象
        	int oldchannel = Util.parseInt(ModuleElement.attributeValue("oldchannel"));//模块所绑定栏目的ID
        	int oldtemplateid = Util.parseInt(ModuleElement.attributeValue("oldtemplateid"));//旧模板ID templatefiles中ID
            int moduleid = Util.parseInt(ModuleElement.attributeValue("moduleid"));//旧栏目ID
            int moduletype = Util.parseInt(ModuleElement.attributeValue("moduletype"));//模块类型
            String modulecontent = ModuleElement.getText();//模块内容
            
            HashMap map_module = new HashMap();
            map_module.put("newPageID",newPageID);
            map_module.put("oldchannel",oldchannel);
            map_module.put("oldtemplateid",oldtemplateid);
            int newmoduleid = 0 ;
            PageModule pm = new PageModule();
            if (moduletype == PageModule.ModuleDirectEdit)//直接编辑内容的模块
            {
                pm.setType(moduletype);
                pm.setContent(modulecontent);
                pm.setCharset("utf-8");
                //直接维护数据
                pm.setPage(newPageID);//这里稍等再做
                pm.setActionUser(userid);
                pm.Add();
                newmoduleid = pm.getId();
                pageContentText = pageContentText.replace("<!-- TideCMS Module " + moduleid + " begin -->", "<!-- TideCMS Module " + pm.getId() + " begin -->");
                pageContentText = pageContentText.replace("<!-- TideCMS Module " + moduleid + " end   -->", "<!-- TideCMS Module " + pm.getId() + " end   -->");
  
            }else if (moduletype == PageModule.ModuleChannelTemplate) {
            	
                //数据从频道中获取
                pm.setType(moduletype);
                pm.setCharset("utf-8");
                pm.setPage(newPageID);//这里稍等再做
                pm.setActionUser(userid);
                
//                Integer newChannelID = 0;//新系统中频道ID
//                Integer new_templateid = 0;//新系统中模板id  template_files中ID
//                new_templateid = (Integer) current_map_templatefile.get(oldtemplateid + "");//获取新系统中模板ID
//                newChannelID = (Integer) map_channel.get(oldchannel);//新系统中频道ID
//                
//                int newChannelTemplateID = 0;//频道与模板关联的记录id
//                TableUtil tutu = new TableUtil();
//                
//                if (new_templateid == null || new_templateid == 0) {//如果是0  就跳过
//                    continue;
//                }
//                String sql = "select * from channel_template where channel=" + newChannelID + " and  templateid=" + new_templateid + "";
//                System.out.println("页面模板sql:"+sql);
//                ResultSet rs = tutu.executeQuery(sql);
//                if (rs.next()){
//                    newChannelTemplateID = rs.getInt("id");
//                }
//                tutu.closeRs(rs);
//                System.out.println("页面模板newChannelTemplateID:"+newChannelTemplateID);
//
//                pm.setTemplate(newChannelTemplateID);
                pm.Add();
                newmoduleid = pm.getId();
                pageContentText = pageContentText.replace("<!-- TideCMS Module " + moduleid + " begin -->", "<!-- TideCMS Module " + pm.getId() + " begin -->");
                pageContentText = pageContentText.replace("<!-- TideCMS Module " + moduleid + " end   -->", "<!-- TideCMS Module " + pm.getId() + " end   -->");

//                String s1 = "<!-- TideCMS Module " + pm.getId() + " begin -->";
//                String s2 = "<!-- TideCMS Module " + pm.getId() + " end   -->";
//                String s3 = "";
//                try {
//                    s3 = pm.getContent() + "";
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
//                int index1 = pageContentText.indexOf(s1);
//                int index2 = pageContentText.indexOf(s2);
//                if (index1 != -1 && index2 != -1)
//                	pageContentText = pageContentText.substring(0, index1 + s1.length()) + s3 + pageContentText.substring(index2);
            }
            map_module.put("moduleid",newmoduleid);
            PageList.add(map_module);
            
        }
        newPage.setActionUser(userid);
        newPage.setContent(pageContentText);
        newPage.savePage();
    }
    
    public void copyOnePage() throws MessageException, SQLException, IOException {
//    	System.out.println("PageList:"+PageList);
    	for (HashMap PageMap : PageList) {
    		int PageContentID = (Integer) PageMap.get("newPageID");//首页ID
    		int moduleid = (Integer) PageMap.get("moduleid");//模块ID
    		int oldchannel = (Integer) PageMap.get("oldchannel");
    		int oldtemplateid = (Integer) PageMap.get("oldtemplateid");
    		
    		Integer newChannelID = 0;//新系统中频道ID
	        Integer new_templateid = 0;//新系统中模板id  template_files中ID
	        new_templateid = (Integer) current_map_templatefile.get(oldtemplateid + "");//获取新系统中模板ID
	        newChannelID = (Integer) map_channel.get(oldchannel);//新系统中频道ID	          	        
	          
	        if (new_templateid == null || new_templateid == 0 || moduleid == 0) {//如果是0  就跳过
	            continue;
	        }
    		
    		PageModule pm = new PageModule(moduleid);
	        if (pm.getType() != PageModule.ModuleChannelTemplate) {
	        	continue;
	        }
	        
	        int newChannelTemplateID = 0;//频道与模板关联的记录id
	        TableUtil tutu = new TableUtil();
	        String sql = "select * from channel_template where channel=" + newChannelID + " and  templateid=" + new_templateid + "";
//	        System.out.println("页面模板sql:"+sql);
	        ResultSet rs = tutu.executeQuery(sql);
	        if (rs.next()){
	            newChannelTemplateID = rs.getInt("id");
	        }
	        tutu.closeRs(rs);
//	        System.out.println("页面模板newChannelTemplateID:"+newChannelTemplateID);

	        
	        pm.setTemplate(newChannelTemplateID);
	        pm.setActionUser(userid);
	        pm.Update();
	        
	        Page page = new Page(PageContentID);
	        String content = page.getContent();
	        
	        String s1 = "<!-- TideCMS Module " + moduleid + " begin -->";
            String s2 = "<!-- TideCMS Module " + moduleid + " end   -->";
            String s3 = "";
            try {
                s3 = pm.getContent() + "";
            } catch (IOException e) {
                e.printStackTrace();
            }
            int index1 = content.indexOf(s1);
            int index2 = content.indexOf(s2);
            if (index1 != -1 && index2 != -1)
            	content = content.substring(0, index1 + s1.length()) + s3 + content.substring(index2);
    		
            page.setActionUser(userid);
            page.setContent(content);
            page.savePage();
    	}
    }
	
	public void ImportChannelFields(Element element,int channelid) throws MessageException, SQLException
	{
		Channel channel = CmsCache.getChannel(channelid);
		HashMap map_group = new HashMap();
		
		//删除已经存在的field group
		TableUtil tu = new TableUtil();
		String Sql = "delete from field_group where Channel=" + channelid;
		tu.executeUpdate(Sql);
		
		//添加field group
		Element ele_fields = element.element("fields");
		List nodes = ele_fields.elements("group");
		for (Iterator it = nodes.iterator(); it.hasNext();) { 
			Element e = (Element) it.next();
			
			Sql = "insert into field_group (";
			
			Sql += "Name,Extra,Url,Channel,LinkChannel,Type,CreateDate";
			Sql += ") values(";
			Sql += "'" + tu.SQLQuote(e.attributeValue("Name")) + "'";
			Sql += ",'" + tu.SQLQuote(e.attributeValue("Extra")) + "'";
			Sql += ",'" + tu.SQLQuote(e.attributeValue("Url")) + "'";
			Sql += "," + channelid + "";
			Sql += "," + Util.parseInt(e.attributeValue("LinkChannel")) + "";
			Sql += "," + Util.parseInt(e.attributeValue("Type")) + "";
			Sql += ",now()";
			
			Sql += ")";
//			System.out.println(Sql);
			int insertid = tu.executeUpdate_InsertID(Sql);
			map_group.put(e.attributeValue("id"), insertid);
			
			//更新序数
			Sql = "update field_group set OrderNumber=" + insertid + " where id=" + insertid;
			tu.executeUpdate(Sql);
		}
		
		List nodes_field = ele_fields.elements("field");
		for (Iterator it = nodes_field.iterator(); it.hasNext();) { 
			Element e = (Element) it.next();
			String fieldname = e.attributeValue("Name");
			
			Field field = channel.getFieldByFieldName(fieldname);
			boolean exist = true;
			if(field==null)
			{
				exist = false;
				field = new Field();
				field.setChannelID(channelid);
			}

			int old_groupid = Util.parseInt(e.attributeValue("GroupID"));
			int groupid = 0;//允许groupid为0
			if(old_groupid>0) groupid = (Integer)map_group.get(e.attributeValue("GroupID"));
			field.setGroupID(groupid);
			field.setIsHide(Util.parseInt(e.attributeValue("IsHide")));
			field.setDisableBlank(Util.parseInt(e.attributeValue("DisableBlank")));
			field.setDisableEdit(Util.parseInt(e.attributeValue("DisableEdit")));
			field.setName(fieldname);
			field.setDescription(e.attributeValue("Description"));
			field.setFieldType(e.attributeValue("FieldType"));
			
			field.setDefaultValue(e.attributeValue("DefaultValue"));
			field.setOther(e.attributeValue("Other"));
			field.setHtmlTemplate(e.attributeValue("HtmlTemplate"));
			field.setDictCode(e.attributeValue("DictCode"));
			field.setSize(Util.parseInt(e.attributeValue("Size")));
			field.setStyle(e.attributeValue("Style"));
			field.setRecommendChannel(e.attributeValue("RecommendChannel"));
			field.setRecommendValue(e.attributeValue("RecommendValue"));
			field.setGroupChannel(e.attributeValue("GroupChannel"));
			field.setCaption(e.attributeValue("Caption"));
			
			field.setJS(e.attributeValue("JS"));
			field.setCaption(e.attributeValue("Caption"));
			
			int DataType = Util.parseInt(e.attributeValue("DataType"));
			field.setDataType(DataType);
			
			String oo  = e.attributeValue("Options");
			oo = oo.replace("$tidemedia$", "\n");
			field.setOptions(oo);
			
//			System.out.println("oo:"+oo);
			if(oo.length()>0)
			{
				String[] options = Util.StringToArray(oo, "\n");
				for (int i = 0; i < options.length; i++) {
//					System.out.println("options "+i+":"+options[i]);
				}
			}
			
			if(exist)
			{
				field.Update();
//				System.out.println("update fieldname:"+fieldname+",groupid:"+groupid);
			}
			else
			{
				field.Add();
//				System.out.println("add fieldname:"+fieldname+",groupid:"+groupid);
			}
		}
	}

	public void ImportChannelTemplate(Element element,int channelid,int GroupID) throws MessageException, SQLException, IOException
	{
		if(xml_document==null) return;
		
		Channel channel = CmsCache.getChannel(channelid);
		HashMap map_templatefile = new HashMap();//oldid,newid
		
		//添加模板文件
		Element ele_template_files = xml_document.getRootElement().element("template_files");
		List nodes = ele_template_files.elements("template_file");
		
		TableUtil tu = new TableUtil();
		
		for (Iterator it = nodes.iterator(); it.hasNext();) { 
			Element e = (Element) it.next();
			//String content = e.attributeValue("Content");
			String content = e.getText();
			
//			System.out.println("===========");
//			System.out.println(content);
//			System.out.println("===========");
			String md5 = StringUtils.getMD5(content);
			
			boolean exist = false;
			String Sql = "";
			
			if(import_public){//公共模板
				
				Sql = "select id from template_files where ContentMd5='" + md5 + "'";
				ResultSet rs = tu.executeQuery(Sql);
				if(rs.next())
				{
					exist = true;
					map_templatefile.put(e.attributeValue("id"), rs.getInt("id"));
					current_map_templatefile.put(e.attributeValue("id"), rs.getInt("id"));
				}
				tu.closeRs(rs);
			}
			
			if(!exist)
			{								
				int insertid = 0;
				
				//判断模板文件是否存在
				Sql = "select id from template_files where Name='"+tu.SQLQuote((e.attributeValue("Name")))+"' and FileName='"+tu.SQLQuote((e.attributeValue("FileName")))+"' and GroupID="+GroupID;
				ResultSet rs1=tu.executeQuery(Sql);
				if(rs1.next()){
					insertid = rs1.getInt("id");
				}
				tu.closeRs(rs1);
				//System.out.println("模板："+Sql);
				
				if(insertid==0){
					Sql = "insert into template_files (";
					Sql += "Description,GroupID,Type,Name,FileName,Content,TemplateName,Title,Photo,CreateDate,ModifiedDate";
					Sql += ") values(";
					Sql += "'" + tu.SQLQuote(e.attributeValue("Description")) + "'";
					Sql += "," + GroupID + "";
					Sql += "," + Util.parseInt(e.attributeValue("Type")) + "";
					Sql += ",'" + tu.SQLQuote((e.attributeValue("Name"))) + "'";
					Sql += ",'" + tu.SQLQuote((e.attributeValue("FileName"))) + "'";
					Sql += ",'" + tu.SQLQuote((e.getText())) + "'";
					Sql += ",'" + tu.SQLQuote((e.attributeValue("TemplateName"))) + "'";
					Sql += ",'" + tu.SQLQuote((e.attributeValue("Title"))) + "'";
					Sql += ",'" + tu.SQLQuote((e.attributeValue("Photo"))) + "'";
					Sql += ",now(),now()";
					Sql += ")";					
					insertid = tu.executeUpdate_InsertID(Sql);	
				}else{
					//更新模板内容
					TemplateFile tf = new TemplateFile(insertid);
					tf.setContent(content);
					tf.setActionUser(userid);
					tf.UpdateContent();
				}
				
				//首页频道
				if(channel.getType()==2){
					
				}
				
				map_templatefile.put(e.attributeValue("id"), insertid);
				current_map_templatefile.put(e.attributeValue("id"),insertid);
			}
		}
		
		//遍历频道的模板配置
		Element ele_channel_template = element.element("templates");
		List nodes_field = ele_channel_template.elements("template");
		for (Iterator it = nodes_field.iterator(); it.hasNext();) { 
			
			
			Element e = (Element) it.next();
			int cid = Util.parseInt(e.attributeValue("ChannelID"));
			
			System.out.println("templates template old cid:"+cid+","+map_channel);
			
			int new_channelid = (int) map_channel.get(cid);
			
			System.out.println("templates template old cid:"+cid+",new cid:"+new_channelid);
			
			//判断模板是否已被引入
			String sql = "select id from channel_template where TemplateID="+map_templatefile.get(e.attributeValue("TemplateID"))+" and Channel="+new_channelid;
			ResultSet rs=tu.executeQuery(sql);
			int id = 0 ;
			if(rs.next()){
				id = rs.getInt("id");
			}
			tu.closeRs(rs);
			
			if(id!=0){
				continue ;
			}
			
			String Sql = "insert into channel_template (";
			Sql += "Channel,LinkTemplate,TemplateID,TargetName,Lable,TemplateType,Charset,WhereSql,RowsPerPage,SubFolderType,";
			Sql += "FileNameType,FileNameField,Category,RowsNumber,TitleWord,Href,PublishInterval,IncludeChildChannel,IsInherit,Active";
			Sql += ") values(";
			Sql += "" + new_channelid + "";
			Sql += "," + e.attributeValue("LinkTemplate") + "";
			Sql += "," + map_templatefile.get(e.attributeValue("TemplateID")) + "";
			Sql += ",'" + e.attributeValue("TargetName") + "'";
			Sql += ",'" + e.attributeValue("Lable") + "'";
			Sql += "," + e.attributeValue("TemplateType") + "";
			Sql += ",'" + e.attributeValue("Charset") + "'";
			Sql += ",'" + e.attributeValue("WhereSql") + "'";
			Sql += "," + e.attributeValue("RowsPerPage") + "";
			Sql += "," + e.attributeValue("SubFolderType") + "";
			Sql += "," + e.attributeValue("FileNameType") + "";
			Sql += ",'" + e.attributeValue("FileNameField") + "'";
			Sql += "," + 0 + "";
			Sql += "," + e.attributeValue("Rows") + "";
			Sql += "," + e.attributeValue("TitleWord") + "";
			Sql += ",'" + e.attributeValue("Href") + "'";
			Sql += "," + e.attributeValue("PublishInterval") + "";
			Sql += "," + e.attributeValue("IncludeChildChannel") + "";
			Sql += "," + e.attributeValue("IsInherit") + "";
			Sql += "," + 1 + "";
			Sql += "";
			Sql += ")";
			//System.out.println(Sql);
			int insertid = tu.executeUpdate_InsertID(Sql);
/*			
			Channel new_channel = CmsCache.getChannel(new_channelid);
			if(new_channel.getType()==2){
				Page p = new Page(new_channelid);
				int templateid = (int) map_templatefile.get(e.attributeValue("TemplateID"));
				p.setTemplateID(templateid);
				if(!p.TargetFileExist()){
					p.GenerateTargetFile();
				}
			}
*/
		}
		
		CmsCache.delChannel(channelid);
	}
	//获取模板分组
	public int templategroup(String name) throws MessageException, SQLException{
		int groupId = 0 ;
		
		String sql = "";
		TableUtil tu=new TableUtil();
		
		sql = "select id from template_group where Parent=-1";
		TableUtil tu1 = new TableUtil();
	    ResultSet Rs = tu1.executeQuery(sql);
	    int Parent = 0 ;
	    if (Rs.next())
	    {
	    	Parent = Rs.getInt("id");
	    }
	    tu.closeRs(Rs);
		
		//判断分组是否存在
	    sql = "select id from template_group where Parent="+Parent+" and Name='"+tu.SQLQuote(name)+"'";
		ResultSet rs=tu.executeQuery(sql);
		if(rs.next()){
			groupId = rs.getInt("id");
		}
		tu.closeRs(rs);
		
		if(groupId==0){
			sql = "insert into template_group (";
			sql += "Name,Parent,CreateDate,Status";
			sql += ") values(";
			sql += "'" + tu.SQLQuote(name) + "'";
			sql += "," + Parent + "";		
			sql += ",now(),1";
			sql += ")";
			
			groupId = tu.executeUpdate_InsertID(sql);
			sql = "update template_group set OrderNumber="+groupId+" where id="+groupId+" and OrderNumber is null or OrderNumber=0";
			tu.executeUpdate(sql);
		}
		return groupId ;
	}
	
	public boolean InitTemplateFileMd5()
	{
		String Sql = "select id,Content,ContentMd5,SystemMd5 from template_files";
		String Sql2 = "";
		TableUtil tu;
		try {
			tu = new TableUtil();
			TableUtil tu2 = new TableUtil();
			ResultSet rs = tu.executeQuery(Sql);
			while(rs.next())
			{
				int id = rs.getInt("id");
				String md5 = tu.convertNull(rs.getString("ContentMd5"));
				String md5_ = tu.convertNull(rs.getString("SystemMd5"));
				String now_md5 = StringUtils.getMD5(rs.getString("Content"));
				if(md5.length()==0)
				{
					Sql2 = "update template_files set ContentMd5='" + now_md5 +"'" + " where id=" + id;
					tu2.executeUpdate(Sql2);
				}
				
				if(md5_.length()==0)
				{
					Sql2 = "update template_files set SystemMd5='" + now_md5 +"'" + " where id=" + id;
					tu2.executeUpdate(Sql2);
				}
			}
			tu.closeRs(rs);
		} catch (MessageException | SQLException e) {
			ErrorLog.SaveErrorLog("导入频道","Md5字段不存在",0,e);
			e.printStackTrace(System.out);
			return false;
		}
		
		return true;
	}
	
	//解压zip文件
	public void unZipFiles(File zipFile,String descDir) throws IOException{  
		File pathFile = new File(descDir);  
		if(!pathFile.exists()){  
			pathFile.mkdirs();  
		}  
		if(!descDir.endsWith("/")){descDir += "/";}
		ZipFile zip = new ZipFile(zipFile);  
		for(Enumeration entries = zip.getEntries();entries.hasMoreElements();){  
			ZipEntry entry = (ZipEntry)entries.nextElement();  
			String zipEntryName = entry.getName();  
			InputStream in = zip.getInputStream(entry);  
			String outPath = (descDir+zipEntryName).replaceAll("\\*", "/");;  
			//判断路径是否存在,不存在则创建文件路径  
			File file = new File(outPath.substring(0, outPath.lastIndexOf('/')));  
			if(!file.exists()){  
				file.mkdirs();  
			}  
			//判断文件全路径是否为文件夹,如果是上面已经上传,不需要解压  
			if(new File(outPath).isDirectory()){  
				continue;  
			}                
			OutputStream out = new FileOutputStream(outPath);  
			byte[] buf1 = new byte[1024];  
			int len;  
			while((len=in.read(buf1))>0){  
				out.write(buf1,0,len);  
			}  
			in.close();  
			out.close();  
		}  
		System.out.println("******************解压完毕********************");  
	}  
	
	public int getChannelid() {
		return channelid;
	}
	
	public void setChannelid(int channelid) {
		this.channelid = channelid;
	}

	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}

	public int getUserid() {
		return userid;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}
	
	public boolean isImport_document() {
		return import_document;
	}

	public void setImport_document(boolean import_document) {
		this.import_document = import_document;
	}

	public boolean isImport_channel() {
		return import_channel;
	}

	public void setImport_channel(boolean import_channel) {
		this.import_channel = import_channel;
	}

	public boolean isImport_template() {
		return import_template;
	}

	public void setImport_template(boolean import_template) {
		this.import_template = import_template;
	}

	public boolean isImport_public() {
		return import_public;
	}

	public void setImport_public(boolean import_public) {
		this.import_public = import_public;
	}

	public HashMap<Integer, Integer> getMap_channel() {
		return map_channel;
	}

	public org.dom4j.Document getXml_document() {
		return xml_document;
	}

	public void setXml_document(org.dom4j.Document xml_document) {
		this.xml_document = xml_document;
	}	
	
}
