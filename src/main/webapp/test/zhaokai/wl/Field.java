/*
 * Created on 2004-9-9
 *
 */
package tidemedia.cms.system;

import java.io.Serializable;
import java.io.StringReader;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.dict.Dict;
import tidemedia.cms.dict.DictGroup;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.service.channel.ChannelListHeaderService;
import tidemedia.tcenter.service.channel.ChannelListSearchService;

/**
 * @author 李永海(liyonghai @ tom.com)
 */
public class Field implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private int ChannelID;
    private int GroupID;//组编号
    private String Name = "";
    private String Description = "";
    private String FieldType = "";
    // private String FieldTypeDesc = "";
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
    private int DataType = 0;//数据类型，0 为字符，1为数字
    private int RelationChannelID = 0;//关联字段对应的频道编号
    private String JS = "";//脚本
    private String Caption = "";//说明

    private ArrayList<String[]> FieldOptions = null;//第一个是显示，第二个是值
    private ArrayList<Dict> FieldOptions2 = null;
    private HashMap<String, String> RecommendOutValueMap = null;

    public Field() throws MessageException, SQLException {

    }

    public Field(int id) throws SQLException, MessageException {
        Field_(id);
    }

    public Field(String fieldname, int channelid) throws MessageException, SQLException {

        Channel channel = CmsCache.getChannel(channelid);

        String Sql = "select id from field_desc where ChannelID=" + channel.getTableChannelID() + " and FieldName='" + fieldname + "'";

        TableUtil tu = new TableUtil();
        ResultSet Rs = tu.executeQuery(Sql);
        int fieldid = 0;
        if (Rs.next()) {
            fieldid = Rs.getInt("id");
        }
        tu.closeRs(Rs);

        Field_(fieldid);
    }

    public void Field_(int id) throws SQLException, MessageException {
        TableUtil tu = new TableUtil();
        String Sql = "select * from field_desc where id=" + id;

        ResultSet Rs = tu.executeQuery(Sql);
        if (Rs.next()) {
            setId(id);
            setName(tu.convertNull(Rs.getString("FieldName")));
            setDescription(tu.convertNull(Rs.getString("Description")));
            setFieldType(tu.convertNull(Rs.getString("FieldType")));
            setIsHide(Rs.getInt("IsHide"));
            setDisableEdit(Rs.getInt("DisableEdit"));
            setDisableBlank(Rs.getInt("DisableBlank"));
            setFieldLevel(Rs.getInt("FieldLevel"));
            setEditorType(Rs.getInt("EditorType"));
            setStyle(tu.convertNull(Rs.getString("Style")));
            setDefaultValue(tu.convertNull(Rs.getString("DefaultValue")));
            setOther(tu.convertNull(Rs.getString("Other")));
            setHtmlTemplate(tu.convertNull(Rs.getString("HtmlTemplate")));
            setDictCode(tu.convertNull(Rs.getString("DictCode")));
            setSize(Rs.getInt("Size"));
            setChannelID(Rs.getInt("ChannelID"));
            setGroupID(Rs.getInt("GroupID"));
            setDataType(Rs.getInt("DataType"));
            setRecommendChannel(tu.convertNull(Rs.getString("RecommendChannel")));
            setRecommendValue(tu.convertNull(Rs.getString("RecommendValue")));
            setGroupChannel(tu.convertNull(Rs.getString("GroupChannel")));
            setRelationChannelID(Rs.getInt("RelationChannelID"));
            setJS(tu.convertNull(Rs.getString("JS")));
            setCaption(tu.convertNull(Rs.getString("Caption")));
            if (getFieldType().equalsIgnoreCase("select") || getFieldType().equalsIgnoreCase("checkbox") || getFieldType().equalsIgnoreCase("radio")) {
                Sql = "select * from field_options where ChannelID=" + ChannelID + " and FieldName='" + Name + "' order by id";

                TableUtil tu2 = new TableUtil();

                FieldOptions = new ArrayList<String[]>();

                ResultSet rs = tu2.executeQuery(Sql);

                while (rs.next()) {

                    String s = tu2.convertNull(rs.getString("OptionValue"));
                    Options += s + "\r\n";
                    String[] ss = new String[]{s, s};
                    int i = s.lastIndexOf("(");
                    int j = s.lastIndexOf(")");
                    //System.out.println("channelid:"+ChannelID+",i:"+i+",j:"+j);

                    if (DataType == 1) {
                        if (i != -1 && j != -1 && i < j) {//System.out.println("v:"+s.substring(i+1,j));
                            ss[0] = s.substring(0, i);//System.out.println("text:"+ss[0]);
                            ss[1] = Util.parseInt(s.substring(i + 1, j)) + "";
                        } else
                            ss[1] = "0";
                    }

                    FieldOptions.add(ss);

                }

                tu2.closeRs(rs);

            }

            if (getFieldType().equals("select_dict") || getFieldType().equals("checkbox_dict") || getFieldType().equals("radio_dict")) {
                DictGroup group = new DictGroup(getDictCode());
                Sql = "select * from dict where GroupID=" + group.getId() + " order by id";
                TableUtil tu2 = new TableUtil();
                FieldOptions2 = new ArrayList<Dict>();
                ResultSet rs = tu.executeQuery(Sql);
                while (rs.next()) {
                    int dictid = rs.getInt("id");
                    String name = tu2.convertNull(rs.getString("Name"));
                    Dict dict = new Dict();
                    dict.setId(dictid);
                    dict.setName(name);

                    FieldOptions2.add(dict);
                }
                tu2.closeRs(rs);
            }

            if (getFieldType().equals("recommendout")) {
                InitRecommentOutValue();
            }

            tu.closeRs(Rs);
        } else {
            tu.closeRs(Rs);
            throw new MessageException("该记录不存在!");
        }
    }


    @SuppressWarnings("unchecked")
    public void InitRecommentOutValue() {
        RecommendOutValueMap = new HashMap();
        String xml = getRecommendValue();
        if (xml.length() == 0) return;
        SAXReader reader = new SAXReader();
        org.dom4j.Document doc;
        try {
            StringReader strInStream = new StringReader(xml);
            doc = reader.read(strInStream);
            Element root = doc.getRootElement();
            Element foo;

            for (Iterator<Element> i = root.elementIterator("item"); i.hasNext(); ) {
                foo = (Element) i.next();

                String a = foo.elementText("channel");
                String b = foo.elementText("rule");

                RecommendOutValueMap.put(a, b);
            }
        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }

    //添加字段
    public void Add() throws SQLException, MessageException {
        TableUtil tu = new TableUtil();
        Channel channel = CmsCache.getChannel(ChannelID);

        String Sql = "";
        String FieldType_Sql = "";

        String ch = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789";
        for (int i = 0; i < Name.length(); i++) {
            boolean exist = false;
            for (int j = 0; j < ch.length(); j++) {
                if (Name.charAt(i) == ch.charAt(j)) {
                    exist = true;
                }
            }

            if (!exist)
                throw new MessageException("字段名称必须由英文字母或数字或下划线组成!",
                        MessageException.ALERT_CLOSE_WINDOW_MODAL);
        }

        // 检查字段是否已经存在
        ResultSetMetaData rsmd = channel.getColumn();
        int cols = rsmd.getColumnCount();
        if (cols > 0) {
            for (int i = 1; i <= cols; i++) {
                if (rsmd.getColumnName(i).equals(Name))
                    throw new MessageException("该字段已经存在!",
                            MessageException.ALERT_HISTORY_BACK_MODAL);
            }
        }

        TableUtil datasource_tu = channel.getTableUtil();
        int channelid = channel.getId();
        if (!channel.isTableChannel())
            channelid = (channel.getParentTableChannelID());

        if (FieldType.equalsIgnoreCase("text")) {
            FieldType_Sql = "varchar(250)";
        } else if (FieldType.equalsIgnoreCase("textarea")) {
            FieldType_Sql = "text";
        } else if (FieldType.equalsIgnoreCase("number")) {
            FieldType_Sql = "int";
        } else if (FieldType.equalsIgnoreCase("float")) {
            //FieldType_Sql = "float";修改成double 2015.3.24 否则保存3071434.38会不一致
            FieldType_Sql = "double";
        } else if (FieldType.equalsIgnoreCase("select")) {
            FieldType_Sql = "varchar(250)";
        } else if (FieldType.equalsIgnoreCase("file")) {
            FieldType_Sql = "varchar(250)";
        } else if (FieldType.equalsIgnoreCase("switch")) {
            FieldType_Sql = "tinyint";
        } else if (FieldType.equalsIgnoreCase("image")) {
            FieldType_Sql = "varchar(250)";
        } else if (FieldType.equalsIgnoreCase("video")) {
            FieldType_Sql = "varchar(250)";
        } else if (FieldType.equalsIgnoreCase("datetime")) {
            FieldType_Sql = "datetime";
        } else if (FieldType.equalsIgnoreCase("label")) {
            FieldType_Sql = "varchar(10)";
        } else if (FieldType.equalsIgnoreCase("checkbox")) {
            FieldType_Sql = "varchar(250)";
            //if(DataType==1) FieldType_Sql = "int";
        } else if (FieldType.equalsIgnoreCase("radio")) {
            FieldType_Sql = "varchar(250)";
            if (DataType == 1) FieldType_Sql = "int";
        } else if (FieldType.equalsIgnoreCase("select_dict")) {
            FieldType_Sql = "int";
        } else if (FieldType.equalsIgnoreCase("checkbox_dict")) {
            FieldType_Sql = "varchar(255)";
        } else if (FieldType.equalsIgnoreCase("radio_dict")) {
            FieldType_Sql = "int";
        } else if (FieldType.equalsIgnoreCase("recommend")) {
            FieldType_Sql = "varchar(250)";
        } else if (FieldType.equalsIgnoreCase("recommendout")) {
            FieldType_Sql = "varchar(250)";
        } else if (FieldType.equalsIgnoreCase("group_parent")) {
            FieldType_Sql = "varchar(250)";
        } else if (FieldType.equalsIgnoreCase("group_child")) {
            FieldType_Sql = "varchar(250)";
        } else if (FieldType.equals("relation"))//关联字段,还需要建一个空字段，但无实际用途
        {
            Sql = "";
            Sql += "CREATE TABLE relation2_" + channelid + "_" + RelationChannelID + " (";
            Sql += "  id int(11) NOT NULL auto_increment,";
            Sql += "  GlobalID int(11),";
            Sql += "  ChildGlobalID int(11),";
            Sql += "  UNIQUE KEY id (id)";
            Sql += ") ENGINE=InnoDB DEFAULT CHARSET=utf8;";

            datasource_tu.executeUpdate(Sql);

            FieldType_Sql = "int";
        } else {
            return;
        }


        if (FieldType_Sql.length() > 0) {
            //FieldType_Sql有内容才执行sql
            Sql = " ALTER TABLE " + channel.getTableName() + " ADD " + Name + " " + FieldType_Sql;
            if (DefaultValue.length() > 0) Sql += " default '" + tu.SQLQuote(DefaultValue) + "'";
            // System.out.println("ChannelID="+ChannelID);

            //集合频道不需要建字段
            if (!(FieldType.equalsIgnoreCase("group_parent") || FieldType.equalsIgnoreCase("group_child")))
                datasource_tu.executeUpdate(Sql);
        }

        Sql = "insert into field_desc (";

        Sql += "ChannelID,GroupID,FieldName,Description,FieldType,GroupChannel,RecommendChannel,";
        Sql += "RecommendValue,IsHide,DisableBlank,DisableEdit,FieldLevel,EditorType,OrderNumber,Size,Other,HtmlTemplate,JS,Caption,";
        Sql += "DictCode,DefaultValue,Style,RelationChannelID,DataType";
        Sql += ") values(";

        Sql += channelid;
        Sql += "," + GroupID + "";
        Sql += ",'" + tu.SQLQuote(Name) + "'";
        Sql += ",'" + tu.SQLQuote(Description) + "'";
        Sql += ",'" + tu.SQLQuote(FieldType) + "'";
        Sql += ",'" + tu.SQLQuote(GroupChannel) + "'";
        Sql += ",'" + tu.SQLQuote(RecommendChannel) + "'";
        Sql += ",'" + tu.SQLQuote(RecommendValue) + "'";
        Sql += "," + IsHide + "";
        Sql += "," + DisableBlank + "";
        Sql += "," + DisableEdit + "";
        Sql += ",2";
        Sql += "," + EditorType + "";
        Sql += "," + 0;
        Sql += "," + Size;
        Sql += ",'" + tu.SQLQuote(Other) + "'";
        Sql += ",'" + tu.SQLQuote(HtmlTemplate) + "'";
        Sql += ",'" + tu.SQLQuote(JS) + "'";
        Sql += ",'" + tu.SQLQuote(Caption) + "'";
        Sql += ",'" + tu.SQLQuote(DictCode) + "'";
        Sql += ",'" + tu.SQLQuote(DefaultValue) + "'";
        Sql += ",'" + tu.SQLQuote(Style) + "'";
        Sql += "," + RelationChannelID + "";
        Sql += "," + DataType + "";

        Sql += ")";

        //System.out.println(Sql);
        int insertid = tu.executeUpdate_InsertID(Sql);
        setId(insertid);

        //更新序数
        Sql = "update field_desc set OrderNumber=id*100 where OrderNumber=0";
        tu.executeUpdate(Sql);

        if ((FieldType.equalsIgnoreCase("select") || FieldType.equalsIgnoreCase("checkbox") || FieldType.equalsIgnoreCase("radio")) && !Options.equals("")) {
            String[] options = Util.StringToArray(Options, "\n");

            for (int i = 0; i < options.length; i++) {
                Sql = "insert into field_options (";

                Sql += "ChannelID,FieldName,OptionValue";
                Sql += ") values(";
                Sql += channelid;
                Sql += ",'" + tu.SQLQuote(Name) + "'";
                Sql += ",'" + tu.SQLQuote(options[i].replace("\r", "")) + "'";

                Sql += ")";
                // System.out.println("add:"+Sql);
                tu.executeUpdate(Sql);
            }
        }

        delChannelFromCache(ChannelID);
    }

    public void Delete() throws SQLException, MessageException {
        TableUtil tu = new TableUtil();
        Channel channel = CmsCache.getChannel(ChannelID);
        if (channel.getType() != 3) {
            if (getFieldLevel() != 2) {
                throw new MessageException("系统定义的字段不能删除!",
                        MessageException.ALERT_CLOSE_WINDOW);
            }
        }

        String Sql = "";
        TableUtil datasource_tu = channel.getTableUtil();
        int channelid = channel.getId();
        if (!channel.isTableChannel())
            channelid = (channel.getParentTableChannelID());

        if ((FieldType.equals("group_parent") || FieldType.equals("group_child"))) {
        } else {
            Sql = "ALTER TABLE " + channel.getTableName() + " DROP COLUMN " + Name;
            datasource_tu.executeUpdate(Sql);

            if (FieldType.equals("relation")) {
                //删除关联字段对应的关联关系表
                Sql = "DROP TABLE IF EXISTS relation2_" + channelid + "_" + RelationChannelID;
                datasource_tu.executeUpdate(Sql);
            }
        }

        Sql = "delete from field_desc where id=" + id;

        tu.executeUpdate(Sql);

        Sql = "delete from field_options where ChannelID=" + ChannelID + " and FieldName='" + tu.SQLQuote(Name) + "'";
        tu.executeUpdate(Sql);

        delChannelFromCache(ChannelID);
        //删除字段时删除对应频道配置数据
        ChannelListHeaderService.deleteByFieldName(Name);
        ChannelListSearchService.deleteByFieldName(Name);
    }

    //更新字段信息
    public void Update() throws SQLException, MessageException {
        TableUtil tu = new TableUtil();
        //Channel channel = CmsCache.getChannel(ChannelID);

        String Sql = "";
        //String SerialNo = "";

        Sql = "update field_desc set ";

        Sql += "Description='" + tu.SQLQuote(Description) + "'";
        Sql += ",IsHide=" + IsHide + "";
        Sql += ",DisableEdit=" + DisableEdit + "";
        Sql += ",DisableBlank=" + DisableBlank + "";
        Sql += ",EditorType=" + EditorType + "";
        Sql += ",Other='" + tu.SQLQuote(Other) + "'";
        Sql += ",DefaultValue='" + tu.SQLQuote(DefaultValue) + "'";
        Sql += ",HtmlTemplate='" + tu.SQLQuote(HtmlTemplate) + "'";
        Sql += ",JS='" + tu.SQLQuote(JS) + "'";
        Sql += ",Caption='" + tu.SQLQuote(Caption) + "'";
        Sql += ",DictCode='" + tu.SQLQuote(DictCode) + "'";
        Sql += ",GroupChannel='" + tu.SQLQuote(GroupChannel) + "'";
        Sql += ",RecommendChannel='" + tu.SQLQuote(RecommendChannel) + "'";
        Sql += ",RecommendValue='" + tu.SQLQuote(RecommendValue) + "'";
        Sql += ",Size=" + Size + "";
        Sql += ",Style='" + Style + "'";
        Sql += ",GroupID=" + GroupID + "";
        //end;RelationChannelID字段不提供更新

        Sql += " where id=" + id;

        //System.out.println("Field_update="+Sql);
        tu.executeUpdate(Sql);

        Channel channel = CmsCache.getChannel(ChannelID);

        if (DefaultValue.length() > 0) {
            TableUtil datasource_tu = channel.getTableUtil();
            Sql = " ALTER TABLE " + channel.getTableName() + " alter " + Name + " set default '" + tu.SQLQuote(DefaultValue) + "'";
            //System.out.println(Sql);
            datasource_tu.executeUpdate(Sql);
        }

        if ((FieldType.equalsIgnoreCase("select") || FieldType.equalsIgnoreCase("checkbox") || FieldType.equalsIgnoreCase("radio")) && !Options.equals("")) {
            Sql = "delete from field_options where ChannelID=" + ChannelID + " and FieldName='" + Name + "'";
            tu.executeUpdate(Sql);

            String[] options = Util.StringToArray(Options, "\n");

            for (int i = 0; i < options.length; i++) {
                Sql = "insert into field_options (";

                Sql += "ChannelID,FieldName,OptionValue";
                Sql += ") values(";
                Sql += "'" + ChannelID + "'";
                Sql += ",'" + tu.SQLQuote(Name) + "'";
                Sql += ",'" + tu.SQLQuote(options[i].replace("\r", "")) + "'";

                Sql += ")";
                //System.out.println(Sql);
                tu.executeUpdate(Sql);
            }
        }

        delChannelFromCache(ChannelID);
    }

    public void updateGroup(int groupid) throws SQLException, MessageException {
        FieldGroup group = new FieldGroup(groupid);
        if (group.getChannel() == getChannelID()) {
            TableUtil tu = new TableUtil();
            String Sql = "update field_desc set ";

            Sql += "GroupID=" + groupid + "";
            Sql += " where id=" + id;

            tu.executeUpdate(Sql);

            delChannelFromCache(ChannelID);
        }
    }

    public String getDefaultValue() {
        return DefaultValue;
    }

    public String getOther() {
        return Other;
    }

    public String getSite() {
        return Site;
    }

    public int getSize() {
        return Size;
    }

    public String getStyle() {
        return Style;
    }

    public void setDefaultValue(String defaultValue) {
        DefaultValue = defaultValue;
    }

    public void setOther(String other) {
        Other = other;
    }

    public void setSite(String site) {
        Site = site;
    }

    public void setSize(int size) {
        Size = size;
    }

    public void setStyle(String style) {
        Style = style;
    }

    public boolean canAdd() {
        return false;
    }

    public boolean canUpdate() {
        return false;
    }

    public boolean canDelete() {
        return false;
    }

    public String getDescription() {
        return Description;
    }

    public String getName() {
        return Name;
    }

    public void setDescription(String string) {
        Description = string;
    }

    public void setName(String string) {
        Name = string;
    }

    public int getChannelID() {
        return ChannelID;
    }

    public void setChannelID(int i) {
        ChannelID = i;
    }

    public String getFieldType() {
        return FieldType;
    }

    public void setFieldType(String string) {
        FieldType = string;
    }

    public String getOptions() {
        return Options;
    }

    public void setOptions(String string) {
        Options = string;
    }

    /**
     * @return Returns the fieldTypeDesc.
     */
    public String getFieldTypeDesc() {
        String desc = "";
        if (FieldType.equals(""))
            desc = "";
        else if (FieldType.equalsIgnoreCase("text"))
            desc = "单行文本";
        else if (FieldType.equalsIgnoreCase("textarea"))
            desc = "多行文本";
        else if (FieldType.equalsIgnoreCase("number"))
            desc = "整数";
        else if (FieldType.equalsIgnoreCase("float"))
            desc = "小数";
        else if (FieldType.equalsIgnoreCase("select"))
            desc = "下拉列表";
        else if (FieldType.equalsIgnoreCase("select_dict"))
            desc = "下拉列表(字典)";
        else if (FieldType.equalsIgnoreCase("image"))
            desc = "图片";
        else if (FieldType.equalsIgnoreCase("video"))
            desc = "视频";
        else if (FieldType.equalsIgnoreCase("file"))
            desc = "文件";
        else if (FieldType.equalsIgnoreCase("switch"))
            desc = "开关";
        else if (FieldType.equalsIgnoreCase("datetime"))
            desc = "日期";
        else if (FieldType.equalsIgnoreCase("label"))
            desc = "标签";
        else if (FieldType.equalsIgnoreCase("checkbox"))
            desc = "多选";
        else if (FieldType.equalsIgnoreCase("radio"))
            desc = "单选";
        else if (FieldType.equalsIgnoreCase("checkbox_dict"))
            desc = "多选(字典)";
        else if (FieldType.equalsIgnoreCase("radio_dict"))
            desc = "单选(字典)";
        else if (FieldType.equalsIgnoreCase("recommend"))
            desc = "推荐";
        else if (FieldType.equalsIgnoreCase("recommendout"))
            desc = "荐出";
        else if (FieldType.equalsIgnoreCase("group_parent"))
            desc = "父集";
        else if (FieldType.equalsIgnoreCase("group_child"))
            desc = "子集";
        return desc;
    }

    /*
     * (non-Javadoc)
     *
     * @see tidemedia.cms.base.Table#Delete(int)
     */
    public void Delete(int id) throws SQLException, MessageException {

    }

    /**
     * @return Returns the isHide.
     */
    public int getIsHide() {
        return IsHide;
    }

    /**
     * @param isHide The isHide to set.
     */
    public void setIsHide(int isHide) {
        this.IsHide = isHide;
    }

    /**
     * @return Returns the fieldLevel.
     */
    public int getFieldLevel() {
        return FieldLevel;
    }

    /**
     * @param fieldLevel The fieldLevel to set.
     */
    public void setFieldLevel(int fieldLevel) {
        FieldLevel = fieldLevel;
    }

    //字段排序
    public void Order(int NextItemID) throws SQLException, MessageException {
        TableUtil tu = new TableUtil();

        String Sql = "";
        int order1 = 0;
        int order2 = 0;
        int order3 = 0;

        Sql = "select OrderNumber from field_desc where id=" + NextItemID + " and ChannelID=" + getChannelID();
        ResultSet Rs = tu.executeQuery(Sql);
        if (Rs.next()) {
            order1 = Rs.getInt("OrderNumber");
        }
        tu.closeRs(Rs);

        Sql = "select max(OrderNumber) from field_desc where OrderNumber<" + order1 + " and ChannelID=" + getChannelID();
        Rs = tu.executeQuery(Sql);
        if (Rs.next()) {
            order2 = Rs.getInt(1);
        }
        tu.closeRs(Rs);

        order3 = order2 + Math.round((order1 - order2) / 2);

        Sql = "update field_desc set OrderNumber=" + order3 + " where id=" + getId();

        tu.executeUpdate(Sql);

        delChannelFromCache(getChannelID());
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public ArrayList<String[]> getFieldOptions() {
        return FieldOptions;
    }

    @SuppressWarnings("unchecked")
    public void setFieldOptions(ArrayList fieldOptions) {
        FieldOptions = fieldOptions;
    }

    public void delChannelFromCache(int channelid) throws MessageException, SQLException {
        Channel channel = CmsCache.getChannel(channelid);
        CmsCache.delChannel(channelid);
        if (!channel.isTableChannel()) {
            channel = channel.getParentTableChannel();
        }

        ArrayList<Channel> arraylist = channel.listAllSubChannels();
        for (int i = 0; i < arraylist.size(); i++) {
            CmsCache.delChannel(((Channel) arraylist.get(i)).getId());
        }
    }

    public String getValue() {
        return Value;
    }

    public int getIntValue() {
        return Util.parseInt(Value);
    }

    public void setValue(String value) {
        Value = value;
    }

    //用于后台查看，表单设置中
    public String getFieldHtml() {
        String FieldHtml = "";

        if (FieldLevel != 0) {
            //int size = getSize();
            //if(size==0)
            int size = 65;
            if (FieldType.equalsIgnoreCase("text") || FieldType.equals("")) {
                FieldHtml = "<input type='text' size='" + size + "' class='textfield'>";
            } else if (FieldType.equalsIgnoreCase("number")) {
                FieldHtml = "<input type='text' size='" + size + "' class='textfield'>";
            } else if (FieldType.equalsIgnoreCase("float")) {
                FieldHtml = "<input type='text' size='" + size + "' class='textfield'>";
            } else if (FieldType.equalsIgnoreCase("textarea")) {
                //if(getSize()==0) size = 75;
                FieldHtml = "<textarea cols=" + size + " rows=6 class='textfield'></textarea>";
            } else if (FieldType.equalsIgnoreCase("select")) {
                ArrayList<String[]> fieldoptions = getFieldOptions();
                //if (field != null)
                //	fieldoptions = field.getFieldOptions();
                FieldHtml = "<select>";
                for (int j = 0; j < fieldoptions.size(); j++) {
                    String[] ss = (String[]) fieldoptions.get(j);
                    FieldHtml += "<option value=\"" + ss[1] + "\">" + ss[0] + "</option>";
                }
                FieldHtml += "</select>";
            } else if (FieldType.equals("select_dict")) {
                FieldHtml = "<select>";
                for (int j = 0; j < FieldOptions2.size(); j++) {
                    Dict dict = (Dict) FieldOptions2.get(j);
                    FieldHtml += "<option value=\"" + dict.getId() + "\">" + dict.getName() + "</option>";
                }
                FieldHtml += "</select>";
            } else if (FieldType.equalsIgnoreCase("file")) {
                FieldHtml = "<input type='text' size='58' class='textfield'><input type='button' value='...' class='textfield'>";
            } else if (FieldType.equalsIgnoreCase("image")) {
                FieldHtml = "<input type='text' size='58' class='textfield'><input type='button' value='...' class='textfield'>";
            } else if (FieldType.equalsIgnoreCase("datetime")) {
                FieldHtml = "<input type='text' size='" + size + "' class='textfield'><img src='../images/icon/26.png'>";
            } else if (FieldType.equalsIgnoreCase("label")) {
                FieldHtml = getName();
            } else if (FieldType.equalsIgnoreCase("checkbox")) {
                ArrayList<String[]> fieldoptions = getFieldOptions();
                for (int j = 0; j < fieldoptions.size(); j++) {
                    String[] ss = (String[]) fieldoptions.get(j);
                    FieldHtml += "<input type='checkbox' value='" + ss[1] + "' name='" + Name + "' id='" + Name + "' />" + ss[0];
                }
            } else if (FieldType.equalsIgnoreCase("radio")) {
                ArrayList<String[]> fieldoptions = getFieldOptions();
                for (int j = 0; j < fieldoptions.size(); j++) {
                    String[] ss = (String[]) fieldoptions.get(j);
                    FieldHtml += "<input type='radio'  value='" + ss[1] + "' name='" + Name + "' id='" + Name + "' />" + ss[0];
                }
            } else if (FieldType.equalsIgnoreCase("checkbox_dict")) {
                for (int j = 0; j < FieldOptions2.size(); j++) {
                    Dict dict = (Dict) FieldOptions2.get(j);
                    FieldHtml += "<input type='checkbox' value='" + dict.getId() + "' name='" + Name + "' id='" + Name + "' />" + dict.getName();
                }
            } else if (FieldType.equalsIgnoreCase("radio_dict")) {
                for (int j = 0; j < FieldOptions2.size(); j++) {
                    Dict dict = (Dict) FieldOptions2.get(j);
                    FieldHtml += "<input type='radio'  value='" + dict.getId() + "' name='" + Name + "' id='" + Name + "' />" + dict.getName();
                }
            } else if (FieldType.equalsIgnoreCase("recommend")) {
                FieldHtml = "<input type='text' size='" + size + "' class='textfield'>";
            } else if (FieldType.equalsIgnoreCase("group_parent")) {
                FieldHtml = "<input type='text' size='" + size + "' class='textfield'>";
            } else if (FieldType.equalsIgnoreCase("group_child")) {
                FieldHtml = "<input type='text' size='" + size + "' class='textfield'>";
            }
        }

        return FieldHtml;
    }

    //用于前台页面显示，可以定义字段显示的模板
    public String getDisplayHtmlTemplate(String value) {
        String html = "";

        html = getHtmlTemplate();
        html = html.replace("$Name", getName());
        html = html.replace("$Value", value);
        html = html.replace("$HtmlValue", Util.HTMLEncode(value));
        html = html.replace("$Description", getDescription());

        return html;
    }

    /**
     * 用于前台字段显示，如果有显示模板，先取显示模板
     *
     * @param doc
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public String getDisplayHtml2012_can_del(Document doc) throws SQLException, MessageException {
        String html = "";
        String value = doc != null ? doc.getValue(getName()) : getDefaultValue();//新建文档的时候使用默认值
        String blank_class = "";
        if (getDisableBlank() == 1) {
            blank_class = "disable_blank";
        }

        if (getHtmlTemplate().length() > 0) {
            html = getDisplayHtmlTemplate(value);
            if (html.contains("$displayhtml")) {
                String html2 = "<tr id=\"tr_" + getName() + "\"><td><div class=\"line " + blank_class + "\" id='desc_" + getName() + "'>" + getDescription() + "：</div></td>";
                html2 += "<td><div class=\"line\" id=\"field_" + getName() + "\">" + getDisplayHtml_can_del(value) + "</div></td></tr>";
                html = html.replace("$displayhtml", html2);
            }
        } else {
            html = "<tr id=\"tr_" + getName() + "\"><td><div class=\"line\" id='desc_" + getName() + "'>" + getDescription() + "：</div></td>";
            html += "<td><div class=\"line " + blank_class + "\" id=\"field_" + getName() + "\">" + getDisplayHtml_can_del(value) + "</div></td></tr>";
            //html = getDisplayHtml(value);
        }

        //处理脚本
        if (getJS().length() > 0) {
            html += "<script>" + getJS() + "</script>";
        }

        return html;
    }

    public String getDisplayHtml2018(Document doc) throws SQLException, MessageException, JSONException {
        String html = "";
        String value = doc != null ? doc.getValue(getName()) : getDefaultValue();//新建文档的时候使用默认值
        String blank_class = "";
        if (getDisableBlank() == 1) {
            blank_class = "disable_blank";
        }

        String divClass = "wd-content-lable";
        if (FieldType.equals("checkbox") || FieldType.equals("checkbox_dict") || FieldType.equals("recommendout") || FieldType.equals("radio") || FieldType.equals("radio_dict")) {
            divClass = "wd-content-ckx";
        }

        if (getHtmlTemplate().length() > 0) {
            html = getDisplayHtmlTemplate(value);
            if (html.contains("$displayhtml")) {
                String html2 = "<div class=\"row flex-row align-items-center mg-b-15\" id=\"tr_" + getName() + "\"><label class=\"left-fn-title wd-150 " + blank_class + "\" id='desc_" + getName() + "'>" + getDescription() + "：</label>";

                html2 += "<label class=\"" + divClass + " d-flex\" id=\"field_" + getName() + "\">" + getDisplayHtml_(value) + "</label></div>";
                html = html.replace("$displayhtml", html2);
            }
        } else {
            html = "<div class=\"row flex-row align-items-center mg-b-15\" id=\"tr_" + getName() + "\"><label class=\"left-fn-title wd-150\" id='desc_" + getName() + "'>" + getDescription() + "：</label>";
            html += "<label class=\"" + divClass + " d-flex " + blank_class + "\" id=\"field_" + getName() + "\">" + getDisplayHtml_(value) + "</label></div>";
        }

        //字段说明
        if (!Caption.equals("")) {
            html += "<div class='row mg-t--10' id=\"Caption_" + getName() + "\"><label class='left-fn-title wd-150'> </label>";
            html += "<label class='d-flex align-items-center tx-gray-800 tx-12'><i class='icon ion-information-circled tx-16 tx-gray-900 mg-r-5'></i>" + Caption + "</label></div>";
        }
        //处理脚本
        if (getJS().length() > 0) {
            html += "<script>" + getJS() + "</script>";
        }

        return html;
    }

    //用于前台页面显示
    @SuppressWarnings("unchecked")
    public String getDisplayHtml_can_del(String value) throws SQLException, MessageException {
        String html = "";

        int size = getSize();
        if (size == 0) size = 80;


        if (getDisableEdit() == 1) {
            html = value;
            return html;
        }

        if (FieldType.equals("text")) {
            if (getName().equals("Weight")) {
                if (getIsHide() == 0) {
                    html = "权重：";
                    html += html = "<input type=\"text\" class=\"textfield\" size=\"4\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\"> ";
                    ;
                }
            } else {
                html = "<input type=\"text\" class=\"textfield\" size=\"" + size + "\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + Util.HTMLEncode(value) + "\"> ";
                if (getName().toLowerCase().indexOf("href") != -1) {
                    html += "<input type=\"button\" value=\"预览\" onClick=\"previewFile(\'" + getName() + "\')\" class=\"tidecms_btn3\">";
                }
            }

            //关键词
            if (getName().equals("Keyword") || getName().equals("Tag")) {
                html += "<input type=\"button\" value=\"自动提取\" onClick=\"getAutoKeyword(\'" + getName() + "\')\" class=\"tidecms_btn3\">";
            }
        } else if (FieldType.equals("number")) {
            html += html = "<input type=\"text\" class=\"textfield\" size=\"10\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\"> ";
            ;
        } else if (FieldType.equals("float")) {
            html += html = "<input type=\"text\" class=\"textfield\" size=\"10\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\"> ";
            ;
        } else if (FieldType.equals("textarea") && !getName().equals("Content")) {
            if (getSize() == 0) size = 77;
            html = "<textarea cols=\"" + size + "\" class=\"textfield\" rows=5 name=\"" + getName() + "\"";
            html += " onDblClick=\"showEditor('" + getName() + "')\" id=\"" + getName() + "\">" + Util.HTMLEncode(value) + "</textarea>";
        } else if (FieldType.equals("datetime")) {
            html = "<input type='text' name='" + getName() + "' id='" + getName() + "' value='" + value + "' class='textfield date' size='24'>\r\n";
        } else if (FieldType.equals("file")) {
            html = "<input type=\"text\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\" class=\"textfield upload\" size=\"" + size + "\">\r\n" +
                    "<input type=\"button\" value=\"选择\" onClick=\"selectFile(\'" + getName() + "\')\" class=\"tidecms_btn3\"> " +
                    "<input type=\"button\" value=\"预览\" onClick=\"previewFile(\'" + getName() + "\')\" class=\"tidecms_btn3\">";
        } else if (FieldType.equals("image")) {
            html = "<input type=\"text\" name=\"" + getName() + "\"  id=\"" + getName() + "\" value=\"" + value + "\" class=\"textfield upload field_image\" title=\"\" size=\"" + size + "\">\r\n" +
                    "<input type=\"button\" value=\"选择\" onClick=\"selectImage(\'" + getName() + "\')\" class=\"tidecms_btn3\"> " +
                    "<input type=\"button\" value=\"预览\" onClick=\"previewFile(\'" + getName() + "\')\" class=\"tidecms_btn3\"> "
            ;
        } else if (FieldType.equals("select")) {
            ArrayList<String[]> fieldoptions = getFieldOptions();
            html = "<select name=\"" + getName() + "\" id=\"" + getName() + "\">";
            for (int k = 0; k < fieldoptions.size(); k++) {
                String[] ss = (String[]) fieldoptions.get(k);
                html += "<option " + (value.equals(ss[1]) ? "selected" : "") + " value=\"" + ss[1] + "\">" + ss[0] + "</option>\r\n";
            }
            html += "</select>";
        } else if (FieldType.equals("select_dict")) {
            html = "<select name=\"" + getName() + "\" id=\"" + getName() + "\">";
            for (int k = 0; k < FieldOptions2.size(); k++) {
                Dict dict = (Dict) FieldOptions2.get(k);
                //System.out.println("value:"+value+","+dict.getId());
                html += "<option " + (value.equals(dict.getId() + "") ? "selected" : "") + " value=\"" + dict.getId() + "\">" + dict.getName() + "</option>\r\n";
            }
            html += "</select>";
        } else if (FieldType.equals("checkbox")) {
            if (getName().equals("IsPhotoNews")) {
                html += "<input type=\"checkbox\" value=\"1\" name=\"" + getName() + "\" id=\"" + getName() + "\" " + (value.equals("1") ? "checked" : "") + ">\r\n";
            } else {
                ArrayList<String[]> fieldoptions = getFieldOptions();
                String[] arr = Util.StringToArray(value, ",");
                for (int k = 0; k < fieldoptions.size(); k++) {
                    String[] ss = (String[]) fieldoptions.get(k);
                    String id_ = getName() + "_" + k;
                    html += "<input type='checkbox' value='" + ss[1] + "' name='" + getName() + "' id='" + id_ + "' " + (Util.StringInArray(arr, ss[1]) ? "checked" : "") + ">";
                    html += "<label for='" + id_ + "'>" + ss[0] + "</label>\r\n";
                    //html += "<input type=\"checkbox\" value=\""+ss[1]+"\" name=\""+getName()+"\" " + (Util.StringInArray(arr, ss[1])?"checked":"") + ">"+ss[0]+"\r\n" ;
                }
            }
        } else if (FieldType.equals("checkbox_dict")) {
            if (getName().equals("IsPhotoNews")) {
                html += "<input type=\"checkbox\" value=\"1\" name=\"" + getName() + "\" id=\"" + getName() + "\" " + (value.equals("1") ? "checked" : "") + ">\r\n";
            } else {
                String[] arr = Util.StringToArray(value, ",");
                for (int k = 0; k < FieldOptions2.size(); k++) {
                    Dict dict = (Dict) FieldOptions2.get(k);
                    html += "<input type=\"checkbox\" value=\"" + dict.getId() + "\" name=\"" + getName() + "\" " + (Util.StringInArray(arr, dict.getId() + "") ? "checked" : "") + ">" + dict.getName() + "\r\n";
                }
            }
        } else if (FieldType.equals("radio")) {
            ArrayList<String[]> fieldoptions = getFieldOptions();
            for (int k = 0; k < fieldoptions.size(); k++) {
                String[] ss = (String[]) fieldoptions.get(k);
                String id_ = getName() + "_" + k;
                html += "<input type=\"radio\" value=\"" + ss[1] + "\" id=\"" + id_ + "\" name=\"" + getName() + "\" " + (value.equals(ss[1]) ? "checked" : "") + ">";
                html += "<label for='" + id_ + "'>" + ss[0] + "</label>\r\n";
                //html += ss[0]+"\r\n" ;
            }
        } else if (FieldType.equals("radio_dict")) {
            for (int k = 0; k < FieldOptions2.size(); k++) {
                Dict dict = (Dict) FieldOptions2.get(k);
                //System.out.println("value:"+value+","+dict.getId());
                html += "<input type=\"radio\" value=\"" + dict.getId() + "\" id=\"" + getName() + "\" name=\"" + getName() + "\" " + (value.equals(dict.getId() + "") ? "checked" : "") + ">" + dict.getName() + "\r\n";
            }
        } else if (FieldType.equals("label")) {
            html = getDescription();
        } else if (FieldType.equals("recommend")) {
            html = "<input type=\"text\" class=\"textfield\" size=\"" + size + "\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\"> ";
            if (getName().toLowerCase().indexOf("href") != -1) {
                html += "<input type=\"button\" value=\"预览\" onClick=\"previewFile(\'" + getName() + "\')\" class=\"tidecms_btn3\">";
            }
            html += "<input type=\"button\" value=\"推荐\" onClick=\"recommendItem('" + getId() + "')\" class=\"tidecms_btn3\">";
        } else if (FieldType.equals("recommendout"))//荐出
        {
            html = "";
            //System.out.println(RecommendOutValue.size());
            if (RecommendOutValueMap != null && RecommendOutValueMap.size() > 0) {
                String value2 = "," + value + ",";
                Iterator iter = RecommendOutValueMap.entrySet().iterator();
                while (iter.hasNext()) {
                    Map.Entry entry = (Map.Entry) iter.next();
                    String key = (String) entry.getKey();
                    int[] keys = Util.StringToIntArray(key, ",");
                    for (int i = 0; i < keys.length; i++) {
                        int channelid = keys[i];
                        try {
                            Channel ch = CmsCache.getChannel(channelid);
                            String checked = (value2.contains("," + channelid + ",")) ? "checked" : "";
                            html += ch.getName() + "<input type='checkbox' name='" + getName() + "' id='" + getName() + "' value='" + channelid + "' " + checked + ">&nbsp;&nbsp;";
                        } catch (Exception e) {

                        }
                    }
                }
            }
        } else if (FieldType.equals("group_parent")) {
            int gid = Util.parseInt(value);
            String ftitle = "";
            int fid = 0;
            if (gid > 0) {
                try {
                    ItemSnap itemsnap = new ItemSnap(gid);
                    ftitle = itemsnap.getTitle();
                    fid = itemsnap.getGlobalID();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            html = "<input type=\"text\" class=\"textfield\" size=\"" + size + "\" name=\"" + getName() + "_Title\" value=\"" + ftitle + "\" disabled>";
            html += "<input type=\"hidden\" name=\"" + getName() + "\" value=\"" + fid + "\"> ";
            html += "<input type=\"button\" value=\"选择\" onClick=\"groupItem('" + getId() + "')\" class=\"tidecms_btn3\">";
            html += " <input type=\"button\" value=\"清除\" onClick=\"clearGroupItem('" + getName() + "')\" class=\"tidecms_btn3\">";
        } else if (FieldType.equals("group_child")) {
            html = "<input type=\"button\" value=\"选择\" onClick=\"groupChildItem('" + getId() + "')\" class=\"tidecms_btn3\">";
            html += " <input type=\"button\" value=\"清除\" onClick=\"clearGroupChildItem('" + getName() + "')\" class=\"tidecms_btn3\">";
            html += "<table width=\"100%\" border=\"0\" id=\"" + getName() + "_Table\">";
            String[] ids = Util.StringToArray(value, ",");
            if (ids != null && ids.length > 0) {
                for (int i = 0; i < ids.length; i++) {
                    int id_ = Util.parseInt(ids[i]);
                    try {
                        ItemSnap itemsnap = new ItemSnap(id_);
                        html += "<tr><td>" + itemsnap.getTitle() + "</td></tr>";
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } catch (MessageException e) {
                        e.printStackTrace();
                    }
                }
            }
            html += "</table>";
        } else if (FieldType.equals("relation")) {
            int gid = Util.parseInt(value);
            String ftitle = "";
            int ChildGlobalID = 0;
            if (gid > 0) {
                ItemSnap itemsnap = new ItemSnap(gid);
                ftitle = itemsnap.getTitle();
                ChildGlobalID = itemsnap.getGlobalID();
            }
            html = "<input type=\"text\" class=\"textfield\" size=\"" + size + "\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + Util.HTMLEncode(ftitle) + "\" disabled> ";
            html += "<input type='hidden' value='" + ChildGlobalID + "' id='" + getName() + "_id' name='" + getName() + "_id'>";
            html += "<input type=\"button\" value=\"选择\" onClick=\"relation_select('" + getId() + "')\" class=\"tidecms_btn3\">";
        }

        return html;
    }

    public String getDisplayHtml_(String value) throws SQLException, MessageException, JSONException {
        String html = "";

        int size = getSize();
        if (size == 0) size = 80;


        if (getDisableEdit() == 1) {
            html = value;
            return html;
        }

        if (FieldType.equals("text")) {
            if (getName().equals("Weight")) {
                if (getIsHide() == 0) {
                    html = "权重：";
                    html += html = "<input type=\"text\" class=\"textfield form-control\" size=\"4\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\"> ";
                    ;
                }
            } else {
                html = "<input type=\"text\" class=\"textfield form-control\" size=\"" + size + "\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + Util.HTMLEncode(value) + "\"> ";
                if (getName().toLowerCase().indexOf("href") != -1) {
                    html += "</label><label><input type=\"button\" value=\"预览\" onClick=\"previewFile(\'" + getName() + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\">";
                }
            }

            //关键词
            if (getName().equals("Keyword") || getName().equals("Tag")) {
                html += "</label><label><input type=\"button\" value=\"自动提取\" onClick=\"getAutoKeyword(\'" + getName() + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\">";
            }
        } else if (FieldType.equals("number")) {
            html += html = "<input type=\"text\" class=\"textfield form-control\" size=\"10\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\"> ";
            ;
        } else if (FieldType.equals("float")) {
            html += html = "<input type=\"text\" class=\"textfield form-control\" size=\"10\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\"> ";
            ;
        } else if (FieldType.equals("textarea") && !getName().equals("Content")) {
            if (getSize() == 0) size = 81;
            html = "<textarea cols=\"" + size + "\" class=\"textfield form-control\" rows=5 name=\"" + getName() + "\"";
            html += " onDblClick=\"showEditor('" + getName() + "')\" id=\"" + getName() + "\">" + Util.HTMLEncode(value) + "</textarea>";
        } else if (FieldType.equals("datetime")) {
            html = "<input type='text' name='" + getName() + "' id='" + getName() + "' value='" + value + "' class='textfield date form-control' size='24'>\r\n";
        } else if (FieldType.equals("file")) {
            html = "<input type=\"text\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\" class=\"textfield upload form-control\" size=\"" + size + "\">\r\n" +
                    "</label><label><input type=\"button\" value=\"选择\" onClick=\"selectFile(\'" + getName() + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label> " +
                    "<label><input type=\"button\" value=\"预览\" onClick=\"previewFile(\'" + getName() + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\">";
        } else if (FieldType.equals("switch")) {
            String flag = "false";
            if (value.equals("1")) {
                flag = "true";//开
            }
            html = "<input type='hidden' name='" + getName() + "' id='" + getName() + "' value='" + value + "' >\r\n";
            html += "<div class='toggle-wrapper'>\r\n";
            html += "<div class='toggle toggle-modern primary' data-toggle-on='" + flag + "' field='" + getName() + "'></div>\r\n";
            html += "</div>\r\n";
        } else if (FieldType.equals("image")) {
            html = "<input type=\"text\" name=\"" + getName() + "\"  id=\"" + getName() + "\" value=\"" + value + "\" class=\"textfield upload field_image form-control\" title=\"\" size=\"" + size + "\" >\r\n" +
                    "</label><label><input type=\"button\" value=\"选择\" onClick=\"selectImage(\'" + getName() + "\',\'" + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>" +
                    "</label><label><input type=\"button\" value=\"编辑\" onClick=\"editImage(\'" + getName() + "\',\'" + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>" +
                    "<label><input type=\"button\" value=\"预览\" onClick=\"previewFile(\'" + getName() + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\">";
        } else if (FieldType.equals("video")) {
            html = "<input type=\"text\" name=\"" + getName() + "\"  id=\"" + getName() + "\" value=\"" + value + "\" class=\"textfield upload field_image form-control\" title=\"\" size=\"" + size + "\" >\r\n" +
                    "</label><label><input type=\"button\" value=\"选择\" onClick=\"selectVideo(\'" + getName() + "\',\'" + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>" +
                    "</label><label><input type=\"button\" value=\"编辑\" onClick=\"editVideo(\'" + getName() + "\',\'" + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>" +
                    "<label><input type=\"button\" value=\"预览\" onClick=\"previewVideo(\'" + getName() + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\">";
        } else if (FieldType.equals("select")) {
            ArrayList<String[]> fieldoptions = getFieldOptions();
            html = "<select name=\"" + getName() + "\" id=\"" + getName() + "\" class=\"form-control wd-230 ht-40 select2\">";
            for (int k = 0; k < fieldoptions.size(); k++) {
                String[] ss = (String[]) fieldoptions.get(k);
                html += "<option " + (value.equals(ss[1]) ? "selected" : "") + " value=\"" + ss[1] + "\">" + ss[0] + "</option>\r\n";
            }
            html += "</select>";
        } else if (FieldType.equals("select_dict")) {
            html = "<select name=\"" + getName() + "\" id=\"" + getName() + "\" class=\"form-control wd-230 ht-40 select2\">";
            for (int k = 0; k < FieldOptions2.size(); k++) {
                Dict dict = (Dict) FieldOptions2.get(k);
                //System.out.println("value:"+value+","+dict.getId());
                html += "<option " + (value.equals(dict.getId() + "") ? "selected" : "") + " value=\"" + dict.getId() + "\">" + dict.getName() + "</option>\r\n";
            }
            html += "</select>";
        } else if (FieldType.equals("checkbox")) {
            if (getName().equals("IsPhotoNews")) {
                html += "<label class=\"ckbox\"><input type=\"checkbox\" value=\"1\" name=\"" + getName() + "\" id=\"" + getName() + "\" " + (value.equals("1") ? "checked" : "") + "><span></span></label>\r\n";
            } else {
                ArrayList<String[]> fieldoptions = getFieldOptions();
                String[] arr = Util.StringToArray(value, ",");
                html += "";
                for (int k = 0; k < fieldoptions.size(); k++) {
                    String[] ss = (String[]) fieldoptions.get(k);
                    String id_ = getName() + "_" + k;
                    html += "<label class=\"ckbox mg-r-15\"><input type='checkbox' value='" + ss[1] + "' name='" + getName() + "' id='" + id_ + "' " + (Util.StringInArray(arr, ss[1]) ? "checked" : "") + ">";
                    html += "<span for='" + id_ + "'>" + ss[0] + "</span></label>\r\n";
                    //html += "<input type=\"checkbox\" value=\""+ss[1]+"\" name=\""+getName()+"\" " + (Util.StringInArray(arr, ss[1])?"checked":"") + ">"+ss[0]+"\r\n" ;
                }
                html += "";
            }
        } else if (FieldType.equals("checkbox_dict")) {
            if (getName().equals("IsPhotoNews")) {
                html += "<label class=\"ckbox\"><input type=\"checkbox\" value=\"1\" name=\"" + getName() + "\" id=\"" + getName() + "\" " + (value.equals("1") ? "checked" : "") + "><span></span></label>\r\n";
            } else {
                String[] arr = Util.StringToArray(value, ",");
                html += "";
                for (int k = 0; k < FieldOptions2.size(); k++) {
                    Dict dict = (Dict) FieldOptions2.get(k);
                    html += "<label class=\"ckbox mg-r-15\"><input type=\"checkbox\" value=\"" + dict.getId() + "\" name=\"" + getName() + "\" " + (Util.StringInArray(arr, dict.getId() + "") ? "checked" : "") + "><span>" + dict.getName() + "</span></label>\r\n";
                }
                html += "";
            }
        } else if (FieldType.equals("radio")) {
            ArrayList<String[]> fieldoptions = getFieldOptions();
            html += "";
            for (int k = 0; k < fieldoptions.size(); k++) {
                String[] ss = (String[]) fieldoptions.get(k);
                String id_ = getName() + "_" + k;
                html += "<label class=\"rdiobox mg-r-15\"><input type=\"radio\" value=\"" + ss[1] + "\" id=\"" + id_ + "\" name=\"" + getName() + "\" " + (value.equals(ss[1]) ? "checked" : "") + ">";
                html += "<span for='" + id_ + "'>" + ss[0] + "</span></label>\r\n";
                //html += ss[0]+"\r\n" ;
            }
            html += "";
        } else if (FieldType.equals("radio_dict")) {
            html += "";
            for (int k = 0; k < FieldOptions2.size(); k++) {
                Dict dict = (Dict) FieldOptions2.get(k);
                //System.out.println("value:"+value+","+dict.getId());
                html += "<label class=\"rdiobox mg-r-15\"><input type=\"radio\" value=\"" + dict.getId() + "\" id=\"" + getName() + "\" name=\"" + getName() + "\" " + (value.equals(dict.getId() + "") ? "checked" : "") + "><span>" + dict.getName() + "<span></label>\r\n";
            }
            html += "";
        } else if (FieldType.equals("label")) {
            html = getDescription();
        } else if (FieldType.equals("recommend")) {
            html = "<input type=\"text\" class=\"textfield form-control\" size=\"" + size + "\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + value + "\"></label>";
            if (getName().toLowerCase().indexOf("href") != -1) {
                html += "<label><input type=\"button\" value=\"预览\" onClick=\"previewFile(\'" + getName() + "\')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>";
            }
            html += "<label><input type=\"button\" value=\"推荐\" onClick=\"recommendItem('" + getId() + "')\" class=\"btn btn-primary tx-size-xs mg-l-10\">";
        } else if (FieldType.equals("recommendout"))//荐出
        {
            html = "";
            //System.out.println(RecommendOutValue.size());
            if (RecommendOutValueMap != null && RecommendOutValueMap.size() > 0) {
                String value2 = "," + value + ",";
                Iterator iter = RecommendOutValueMap.entrySet().iterator();
                while (iter.hasNext()) {
                    Map.Entry entry = (Map.Entry) iter.next();
                    String key = (String) entry.getKey();
                    int[] keys = Util.StringToIntArray(key, ",");
                    for (int i = 0; i < keys.length; i++) {
                        int channelid = keys[i];
                        try {
                            Channel ch = CmsCache.getChannel(channelid);
                            String checked = (value2.contains("," + channelid + ",")) ? "checked" : "";
                            html += ch.getName() + "<label class=\"ckbox\"><input type='checkbox' name='" + getName() + "' id='" + getName() + "' value='" + channelid + "' " + checked + "><span></span></label>&nbsp;&nbsp;";
                        } catch (Exception e) {

                        }
                    }
                }
            }
        } else if (FieldType.equals("group_parent")) {
            int gid = Util.parseInt(value);
            String ftitle = "";
            int fid = 0;
            if (gid > 0) {
                try {
                    ItemSnap itemsnap = new ItemSnap(gid);
                    ftitle = itemsnap.getTitle();
                    fid = itemsnap.getGlobalID();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            html = "<input type=\"text\" class=\"textfield form-control\" size=\"" + size + "\" name=\"" + getName() + "_Title\" value=\"" + ftitle + "\" disabled>";
            html += "</label><label><input type=\"hidden\" name=\"" + getName() + "\" value=\"" + fid + "\"></label>";
            html += "<label><input type=\"button\" value=\"选择\" onClick=\"groupItem('" + getId() + "')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>";
            html += "<label><input type=\"button\" value=\"清除\" onClick=\"clearGroupItem('" + getName() + "')\" class=\"btn btn-primary tx-size-xs mg-l-10\">";
        } else if (FieldType.equals("group_child")) {
            html = "</label><label><input type=\"button\" value=\"选择\" onClick=\"groupChildItem('" + getId() + "')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>";
            html += " <label><input type=\"button\" value=\"清除\" onClick=\"clearGroupChildItem('" + getName() + "')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>";
            html += "<label><table width=\"100%\" border=\"0\" id=\"" + getName() + "_Table\">";
            String[] ids = Util.StringToArray(value, ",");
            if (ids != null && ids.length > 0) {
                for (int i = 0; i < ids.length; i++) {
                    int id_ = Util.parseInt(ids[i]);
                    try {
                        ItemSnap itemsnap = new ItemSnap(id_);
                        html += "<tr><td>" + itemsnap.getTitle() + "</td></tr>";
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } catch (MessageException e) {
                        e.printStackTrace();
                    }
                }
            }
            html += "</table>";
        } else if (FieldType.equals("relation")) {
            int gid = Util.parseInt(value);
            String ftitle = "";
            int ChildGlobalID = 0;
            if (gid > 0) {
                ItemSnap itemsnap = new ItemSnap(gid);
                ftitle = itemsnap.getTitle();
                ChildGlobalID = itemsnap.getGlobalID();
            }
            html = "<input type=\"text\" class=\"textfield form-control\" size=\"" + size + "\" name=\"" + getName() + "\" id=\"" + getName() + "\" value=\"" + Util.HTMLEncode(ftitle) + "\" disabled> ";
            html += "</label><label><input type='hidden' value='" + ChildGlobalID + "' id='" + getName() + "_id' name='" + getName() + "_id'></label>";
            html += "<label><input type=\"button\" value=\"选择\" onClick=\"relation_select('" + getId() + "')\" class=\"btn btn-primary tx-size-xs mg-l-10\">";
        }

        return html;
    }

    public int getGroupID() {
        return GroupID;
    }

    public void setGroupID(int groupID) {
        GroupID = groupID;
    }

    public String getRecommendChannel() {
        return RecommendChannel;
    }

    public void setRecommendChannel(String recommendChannel) {
        RecommendChannel = recommendChannel;
    }

    public String getRecommendValue() {
        return RecommendValue;
    }

    public void setRecommendValue(String recommendValue) {
        RecommendValue = recommendValue;
    }

    public int getDisableBlank() {
        return DisableBlank;
    }

    public void setDisableBlank(int disableBlank) {
        DisableBlank = disableBlank;
    }

    public void setGroupChannel(String groupChannel) {
        GroupChannel = groupChannel;
    }

    public String getGroupChannel() {
        return GroupChannel;
    }

    public void setHtmlTemplate(String htmlTemplate) {
        HtmlTemplate = htmlTemplate;
    }

    public String getHtmlTemplate() {
        return HtmlTemplate;
    }

    public void setDictCode(String dictCode) {
        DictCode = dictCode;
    }

    public String getDictCode() {
        return DictCode;
    }

    public void setRecommendOutValueMap(HashMap<String, String> recommendOutValueMap) {
        RecommendOutValueMap = recommendOutValueMap;
    }

    public HashMap<String, String> getRecommendOutValueMap() {
        return RecommendOutValueMap;
    }

    public void setDataType(int dataType) {
        DataType = dataType;
    }

    public int getDataType() {
        return DataType;
    }

    public int getDisableEdit() {
        return DisableEdit;
    }

    public void setDisableEdit(int disableEdit) {
        DisableEdit = disableEdit;
    }

    public int getRelationChannelID() {
        return RelationChannelID;
    }

    public void setRelationChannelID(int relationChannelID) {
        RelationChannelID = relationChannelID;
    }

    public String getJS() {
        return JS;
    }

    public void setJS(String jS) {
        JS = jS;
    }

    public int getEditorType() {
        return EditorType;
    }

    public void setEditorType(int editorType) {
        EditorType = editorType;
    }

    public String getCaption() {
        return Caption;
    }

    public void setCaption(String caption) {
        Caption = caption;
    }
}
