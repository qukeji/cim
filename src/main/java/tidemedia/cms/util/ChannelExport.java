package tidemedia.cms.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.page.Page;
import tidemedia.cms.page.PageModule;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelTemplate;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Field;
import tidemedia.cms.system.FieldGroup;
import tidemedia.cms.system.TemplateFile;

/**频道导出*/
public class ChannelExport{
	private int channelid = 0;
	private int include_sub_channel = 0;//0不包含 1 包含
	private boolean document_export = false;//是否导出文章
	private int doc_number = 0;//文章数量
	private ArrayList<Integer> template_ids = new ArrayList<Integer>();//需要去重
//	private HashMap<Integer, Integer> map_channel = new HashMap<Integer, Integer>();//首页频道id，模板频道id


	public String export() throws MessageException, SQLException, IOException
	{
		if(channelid<=0) return "";
		
		String path1 = getClass().getClassLoader().getResource("../../").getPath() + "temp/";
		String path = path1 + channelid + "/";

		Channel channel = CmsCache.getChannel(channelid);
		ExportChannelInfo(channel);
		
		//打包文件
		String zip = path1 + "/" + channelid + ".zip";
				
		if(document_export && doc_number>0)
		{
			if(doc_number>10000) doc_number = 10000;//最多10000
			DocumentExport documentexport = new DocumentExport();
			documentexport.setChannelid(channelid);
			documentexport.setDoc_number(doc_number);
			documentexport.Start();
		}else{
			
			File zipfile = new File(zip);
			try {
				new FileUtil().zipFiles(new File(path),zipfile);
			} catch (IOException e) {
				e.printStackTrace(System.out);
			}
		}
		
		return zip;
	}
	
	//导出频道结构信息
	public void ExportChannelInfo(Channel channel) throws SQLException, MessageException, IOException
	{
		org.dom4j.Document xml = DocumentHelper.createDocument();
		
		xml.addComment("频道结构信息，创建时间："+Util.getCurrentDateTime());
		Element root = xml.addElement("root");

		ExportChannelInfo_(channel,root);
				
		
		//添加模板文件信息
		Element xml_template_files = root.addElement("template_files");
		Set set = new HashSet();
		List newList = new ArrayList();
		for (Integer cd : template_ids) {
			if (set.add(cd)) {
				newList.add(cd);
			}
		}
		for (int i = 0; i < newList.size(); i++){
			int template_file_id = (Integer) newList.get(i);
			Element xml_template_file = xml_template_files.addElement("template_file");
			TemplateFile tf = CmsCache.getTemplate(template_file_id);
			xml_template_file.addAttribute("id", tf.getId()+"");
			xml_template_file.addAttribute("Name", tf.getName()+"");
			xml_template_file.addAttribute("FileName", tf.getFileName()+"");
			xml_template_file.addAttribute("Description", tf.getDescription()+"");
			xml_template_file.addAttribute("Title", tf.getTitle()+"");
			xml_template_file.addCDATA(tf.getContent());
/*
			//判断是否是首页模板
			if(map_channel!=null&&map_channel.containsKey(tf.getId())){
				Page p = new Page(map_channel.get(tf.getId()));
				String template_content = p.getContent();
				System.out.println("首页内容："+p.getContent());
				if(template_content==null){template_content="";};
				xml_template_file.addCDATA(template_content);
			}else{
				xml_template_file.addCDATA(tf.getContent());	
			}	
*/		
		}


		String path1 = getClass().getClassLoader().getResource("../../").getPath() + "temp/"+channel.getId()+"/";
		String path =  path1 + channel.getId()+".xml";
		System.out.println("xml:"+path);
		File file = new File(path1);
		if(!file.exists())
			file.mkdirs();
		OutputFormat format = OutputFormat.createPrettyPrint();
		format.setEncoding("utf-8");
		try {
			//Writer out = new FileWriter(path);
			XMLWriter writer = new XMLWriter(new FileOutputStream(new File(path)), format);
			//XMLWriter writer = new XMLWriter(out, format);
			writer.write(xml);
			writer.close();
		} catch (IOException e) {
			ErrorLog.SaveErrorLog("导出频道结构",e.getMessage(),channel.getId(),e);
			e.printStackTrace(System.out);
		}
	}
	
	public void ExportChannelInfo_(Channel channel,Element parent) throws MessageException, SQLException, IOException
	{
		if(channel.getType()==2){//页面频道
			ExportPageInfo_(channel,parent);
			return;
		}
		
		
		Element xml_channel = parent.addElement("channel");
		
		xml_channel.addAttribute("ListProgram", channel.getListProgram());
		xml_channel.addAttribute("DocumentProgram", channel.getDocumentProgram()+"");
		xml_channel.addAttribute("FolderName", channel.getFolderName()+"");
		xml_channel.addAttribute("Type", channel.getType()+"");
		xml_channel.addAttribute("Id", channel.getId()+"");
		xml_channel.addAttribute("Name", channel.getName()+"");
		xml_channel.addAttribute("ImageFolderName", channel.getImageFolderName()+"");
		xml_channel.addAttribute("SerialNo", channel.getSerialNo()+"");
		xml_channel.addAttribute("SiteID", channel.getSiteID()+"");
		xml_channel.addAttribute("AutoSerialNo", channel.getAutoSerialNo()+"");
		xml_channel.addAttribute("IsDisplay", channel.getIsDisplay()+"");
		xml_channel.addAttribute("IsWeight", channel.getIsWeight()+"");
		xml_channel.addAttribute("IsComment", channel.getIsComment()+"");
		xml_channel.addAttribute("IsClick", channel.getIsClick()+"");
		xml_channel.addAttribute("IsShowDraftNumber", channel.getIsShowDraftNumber()+"");
		xml_channel.addAttribute("Href", channel.getHref()+"");
		xml_channel.addAttribute("Extra1", channel.getExtra1()+"");
		xml_channel.addAttribute("ListJS", channel.getListJS()+"");
		xml_channel.addAttribute("ListProgram", channel.getListProgram()+"");
		xml_channel.addAttribute("DocumentJS", channel.getDocumentJS()+"");
		xml_channel.addAttribute("DocumentProgram", channel.getDocumentProgram()+"");
		xml_channel.addAttribute("TemplateInherit", channel.getTemplateInherit()+"");
		xml_channel.addAttribute("Company", channel.getCompany()+"");
		xml_channel.addAttribute("Application", channel.getApplication()+"");

		//表单信息
		if(channel.getType()==0)
		{
			Element xml_fields = xml_channel.addElement("fields");
			
			ArrayList fieldGroupArray = channel.getFieldGroupInfo();//频道表单分组
			for (int i = 0; i < fieldGroupArray.size(); i++){
			
				FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
				int fieldGroupId = fieldGroup.getId();//表单组ID

				Element xml_group = xml_fields.addElement("group");//设置第一个分组节点
				xml_group.addAttribute("id", fieldGroup.getId()+"");
				xml_group.addAttribute("Name", fieldGroup.getName());
				xml_group.addAttribute("Extra", fieldGroup.getExtra());
				xml_group.addAttribute("Url", fieldGroup.getUrl());
				xml_group.addAttribute("LinkChannel", fieldGroup.getLinkChannel()+"");
				xml_group.addAttribute("Type", fieldGroup.getType()+"");
			}

			ArrayList arraylist = channel.getFieldInfo();//分组内所有字段
			for (int j = 0; j < arraylist.size(); j++) {

				Field field = (Field) arraylist.get(j);
				Element xml_field = xml_fields.addElement("field");   //设置field节点
				xml_field.addAttribute("Name", field.getName());
				xml_field.addAttribute("GroupID", field.getGroupID()+"");
				xml_field.addAttribute("IsHide", field.getIsHide()+"");
				xml_field.addAttribute("DisableBlank", field.getDisableBlank()+"");
				xml_field.addAttribute("DisableEdit", field.getDisableEdit()+"");
				xml_field.addAttribute("Description", field.getDescription()+"");
				xml_field.addAttribute("FieldType", field.getFieldType()+"");
				xml_field.addAttribute("Options", field.getOptions()+"");
				xml_field.addAttribute("DefaultValue", field.getDefaultValue()+"");
				xml_field.addAttribute("Other", field.getOther()+"");
				xml_field.addAttribute("HtmlTemplate", field.getHtmlTemplate()+"");
				xml_field.addAttribute("DictCode", field.getDictCode()+"");
				xml_field.addAttribute("Size", field.getSize()+"");
				xml_field.addAttribute("Style", field.getStyle()+"");
				xml_field.addAttribute("RecommendChannel", field.getRecommendChannel()+"");
				xml_field.addAttribute("RecommendValue", field.getRecommendValue()+"");
				xml_field.addAttribute("GroupChannel", field.getGroupChannel()+"");
				xml_field.addAttribute("DataType", field.getDataType()+"");
				xml_field.addAttribute("Caption", field.getCaption()+"");
				xml_field.addAttribute("RelationChannelID", field.getRelationChannelID()+"");
				
				String Options = "";
				ArrayList<String[]> fieldoptions = field.getFieldOptions();
				if(fieldoptions!=null && fieldoptions.size()>0)
				{
					for (int k = 0; k < fieldoptions.size(); k++) 
					{
						String[] ss = (String[])fieldoptions.get(k);
						
						Options += ss[0];
						if(field.getDataType()==1) Options += "("+ss[1]+")";//数字
						Options += "$tidemedia$";
//						空格 (& #x0020;) 
//						Tab (& #x0009;) 
//						回车 (& #x000D;) 
//						换行 (& #x000A;)
					}
				}
				
				xml_field.addAttribute("Options", Options);
				//添加field节点到group节点内
			}
		}
		
		//模板信息
		Element xml_templates = xml_channel.addElement("templates");
		ArrayList cts = channel.getChannelTemplates();
		if(cts!=null && cts.size()>0)
		{
			for(int i = 0;i<cts.size();i++)
			{
				ChannelTemplate ct = (ChannelTemplate)cts.get(i);
				template_ids.add(ct.getTemplateID());
				Element xml_template = xml_templates.addElement("template");
				xml_template.addAttribute("TemplateID", ct.getTemplateID()+"");
				xml_template.addAttribute("ChannelID", ct.getChannelID()+"");
				xml_template.addAttribute("LinkTemplate", ct.getLinkTemplate()+"");
				xml_template.addAttribute("Charset",ct.getCharset());
				xml_template.addAttribute("RowsPerPage",ct.getRowsPerPage()+"");
				xml_template.addAttribute("SubFolderType",ct.getSubFolderType()+"");
				xml_template.addAttribute("TemplateType",ct.getTemplateType()+"");
				xml_template.addAttribute("FileNameType",ct.getFileNameType()+"");
				xml_template.addAttribute("FileNameField",ct.getFileNameField()+"");
				xml_template.addAttribute("Rows",ct.getRows()+"");
				xml_template.addAttribute("WhereSql",ct.getWhereSql()+"");
				xml_template.addAttribute("Lable",ct.getLabel()+"");
				xml_template.addAttribute("TitleWord",ct.getTitleWord()+"");
				xml_template.addAttribute("Href",ct.getHref()+"");
				xml_template.addAttribute("PublishInterval",ct.getPublishInterval()+"");
				xml_template.addAttribute("IncludeChildChannel",ct.getIncludeChildChannel()+"");
				xml_template.addAttribute("IsInherit",ct.getIsInherit()+"");
				xml_template.addAttribute("TargetName",ct.getTargetName()+"");
				
/*				
				//判断是否是首页
				if(channel.getType()==2){
					map_channel.put(ct.getTemplateID(), ct.getChannelID());
				}
*/
			}
		}
		
		//包含子频道
		if(include_sub_channel==1)
		{
			ArrayList<Integer> childs = channel.getAllChildChannelIDs();
			if (childs!=null && childs.size()>0) {
				for(int i = 0;i<childs.size();i++){
					int channelid = (Integer)childs.get(i);
					Channel child = CmsCache.getChannel(channelid);
					ExportChannelInfo_(child,xml_channel);
				}
			}
		}
	}
	
	//导出首页内容
	public void ExportPageInfo_(Channel channel,Element parent) throws MessageException, SQLException, IOException
	{
		
		Page p = new Page(channel.getId());//页面内容
		
		Element xml_page = parent.addElement("page");
		Element xml_content = xml_page.addElement("pageContent");
		xml_content.addAttribute("channelid", channel.getId()+"");//频道id
		xml_content.addAttribute("pagename",p.getName());
        xml_content.addAttribute("page_template_file_name",new TemplateFile(p.getTemplateFileID()).getFileName());
        xml_content.addAttribute("page_template_id",p.getTemplateFileID()+"");
		xml_content.addCDATA(p.getContent());
		
		ArrayList<Integer> moduleids = new ArrayList<Integer>();//页面模块
		String sql = "select id from page_module where Page=" + channel.getId();
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next())
		{
			int moduleid = rs.getInt("id");
			moduleids.add(moduleid);
		}		
		tu.closeRs(rs);

		for (Integer moduleid : moduleids) {
			PageModule pm = new PageModule(moduleid);
			ChannelTemplate Channel_templat=new ChannelTemplate(pm.getTemplate());
			Element xml_module = xml_page.addElement("pageModule");
			xml_module.addAttribute("channelid", pm.getPage()+"");//频道id
			xml_module.addAttribute("moduleid", moduleid+"");//模块id
			xml_module.addAttribute("oldtemplateid", Channel_templat.getTemplateID()+"");//模板ID
            xml_module.addAttribute("oldchannel", Channel_templat.getChannelID()+"");//模块绑定频道编号
            xml_module.addAttribute("moduletype", pm.getType()+"");//模块类型
			xml_module.addCDATA(pm.getContent());
		}		
	}
	
	//导出模板信息
	public void ExportChannelTemplateInfo(Channel channel)
	{
		
	}
	
	//导出频道文章
	public void ExportChannelDocment(Channel channel)
	{
		
	}
	
	public ArrayList<Channel> listSubChannels(int channelid) throws SQLException,MessageException {
		ArrayList<Channel> arraylist = new ArrayList<Channel>();
		String Sql = "select * from channel where Parent=" + channelid;

		Sql += " order by OrderNumber,id";

		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(Sql);
		while (Rs.next()) {
			int i = Rs.getInt("id");
			Channel channel = CmsCache.getChannel(i);
			arraylist.add(channel);
		}
		tu.closeRs(Rs);
		return arraylist;
	}

	
	public int getChannelid() {
		return channelid;
	}

	public void setChannelid(int channelid) {
		this.channelid = channelid;
	}

	public boolean isDocument_export() {
		return document_export;
	}

	public void setDocument_export(boolean document_export) {
		this.document_export = document_export;
	}

	public int getDoc_number() {
		return doc_number;
	}

	public void setDoc_number(int doc_number) {
		this.doc_number = doc_number;
	}

	public int getInclude_sub_channel() {
		return include_sub_channel;
	}

	public void setInclude_sub_channel(int include_sub_channel) {
		this.include_sub_channel = include_sub_channel;
	}
}
