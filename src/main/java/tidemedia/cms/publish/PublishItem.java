package tidemedia.cms.publish;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Administrator
 * <p>
 * 用于发布的文件的信息描述，用于arraylist
 */
public class PublishItem implements Serializable {
    private static final long serialVersionUID = -7128203829971899888L;

    public PublishItem() {
        super();
        // TODO Auto-generated constructor stub
    }

    private int id;
    private int publishscheme;
    private String FileName = "";
    private String ToFileName = "";//目标文件

    public String getToFileName() {
        return ToFileName;
    }

    public void setToFileName(String toFileName) {
        ToFileName = toFileName;
    }

    private String TempFolder = "";
    private int ErrorNumber;
    private int User;
    private int Site;
    private String CreateDate;
    private String PublishedDate;
    private int Status;

    /**
     * @return Returns the fileName.
     */
    public String getFileName() {
        return FileName;
    }

    /**
     * @param fileName The fileName to set.
     */
    public void setFileName(String fileName) {
        FileName = fileName;
    }

    /**
     * @return Returns the id.
     */
    public int getId() {
        return id;
    }

    /**
     * @param id The id to set.
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * @return Returns the publishscheme.
     */
    public int getPublishscheme() {
        return publishscheme;
    }

    /**
     * @param publishscheme The publishscheme to set.
     */
    public void setPublishscheme(int publishscheme) {
        this.publishscheme = publishscheme;
    }

    /**
     * @return Returns the tempFolder.
     */
    public String getTempFolder() {
        return TempFolder;
    }

    /**
     * @param tempFolder The tempFolder to set.
     */
    public void setTempFolder(String tempFolder) {
        TempFolder = tempFolder;
    }

    public String getCreateDate() {
        return CreateDate;
    }

    public void setCreateDate(String createDate) {
        CreateDate = createDate;
    }

    public int getErrorNumber() {
        return ErrorNumber;
    }

    public void setErrorNumber(int errorNumber) {
        ErrorNumber = errorNumber;
    }

    public String getPublishedDate() {
        return PublishedDate;
    }

    public void setPublishedDate(String publishedDate) {
        PublishedDate = publishedDate;
    }

    public int getStatus() {
        return Status;
    }

    public void setStatus(int status) {
        Status = status;
    }

    public int getUser() {
        return User;
    }

    public void setUser(int user) {
        User = user;
    }

    public void setSite(int site) {
        Site = site;
    }

    public int getSite() {
        return Site;
    }

    public String getSelect(String SelectName, String TableName, String Col1, String Col2, String Value, String firstOption, int site) throws SQLException, MessageException, SQLException, MessageException {
        String Sql = "";
        String HtmlSelect = "";
        Sql = "select " + Col1 + "," + Col2 + " from " + TableName;
        if (site > 0) {
            Sql += " where site=" + site;
        }
        TableUtil tu = new TableUtil();
        ResultSet Rs = tu.executeQuery(Sql);

        HtmlSelect = "<select name=\"" + SelectName + "\">\n";

        HtmlSelect += firstOption + "\n";

        while (Rs.next()) {
            String a = tidemedia.cms.util.Util.convertNull(Rs.getString(1));
            String b = tidemedia.cms.util.Util.convertNull(Rs.getString(2));
            if (Value == null || Value.equals("") || !Value.equals(a))
                HtmlSelect += "<option value=\"" + a + "\">" + b + "</option>\n";
            else
                HtmlSelect += "<option value=\"" + a + "\" selected>" + b + "</option>\n";
        }
        HtmlSelect += "</select>\n";
        tu.closeRs(Rs);

        return HtmlSelect;
    }

}
