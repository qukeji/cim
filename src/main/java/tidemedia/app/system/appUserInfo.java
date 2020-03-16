//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package tidemedia.app.system;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;

public class appUserInfo extends Table implements Serializable {
    private int id;
    private String Title = "";
    private String PublishDate = "";
    private String Photo = "";
    private String phone = "";
    private String avatar = "";
    private String IP = "";
    private String serial = "";
    private int sex = 1;
    private String QQ = "";
    private String wechat = "";
    private String weibo = "";
    private int siteflag = 1;
    private String Truename = "";
    private int score = 1;
    private String designation = "";
    private int level = 1;

    public appUserInfo() throws MessageException, SQLException {
    }

    public appUserInfo(int userid, String table) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String Sql = "select id,Title,PublishDate,Photo,phone,avatar,IP,serial,sex,QQ,wechat,weibo,siteflag,Truename,score,designation,level from " + table + " where id=" + userid;
        ResultSet Rs = null;
        Rs = tu.executeQuery(Sql);
        if (Rs.next()) {
            this.setId(userid);
            this.setTitle(this.convertNull(Rs.getString("Title")));
            this.setPublishDate(this.convertNull(Rs.getString("PublishDate")));
            this.setPhoto(this.convertNull(Rs.getString("Photo")));
            this.setPhone(this.convertNull(Rs.getString("phone")));
            this.setAvatar(this.convertNull(Rs.getString("avatar")));
            this.setIP(this.convertNull(Rs.getString("IP")));
            this.setSerial(this.convertNull(Rs.getString("serial")));
            this.setSex(Rs.getInt("sex"));
            this.setQQ(this.convertNull(Rs.getString("QQ")));
            this.setWechat(Rs.getString("wechat"));
            this.setWeibo(Rs.getString("weibo"));
            this.setSiteflag(Rs.getInt("siteflag"));
            this.setTruename(this.convertNull(Rs.getString("Truename")));
            this.setScore(Rs.getInt("score"));
            this.setDesignation(this.convertNull(Rs.getString("designation")));
            this.setLevel(Rs.getInt("level"));
        }

        tu.closeRs(Rs);
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return this.Title;
    }

    public void setTitle(String title) {
        this.Title = title;
    }

    public String getPublishDate() {
        return this.PublishDate;
    }

    public void setPublishDate(String publishDate) {
        this.PublishDate = publishDate;
    }

    public String getPhoto() {
        return this.Photo;
    }

    public void setPhoto(String photo) {
        this.Photo = photo;
    }

    public String getPhone() {
        return this.phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return this.avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getIP() {
        return this.IP;
    }

    public void setIP(String IP) {
        this.IP = IP;
    }

    public String getSerial() {
        return this.serial;
    }

    public void setSerial(String serial) {
        this.serial = serial;
    }

    public int getSex() {
        return this.sex;
    }

    public void setSex(int sex) {
        this.sex = sex;
    }

    public String getQQ() {
        return this.QQ;
    }

    public void setQQ(String QQ) {
        this.QQ = QQ;
    }

    public String getWechat() {
        return this.wechat;
    }

    public void setWechat(String wechat) {
        this.wechat = wechat;
    }

    public String getWeibo() {
        return this.weibo;
    }

    public void setWeibo(String weibo) {
        this.weibo = weibo;
    }

    public int getSiteflag() {
        return this.siteflag;
    }

    public void setSiteflag(int siteflag) {
        this.siteflag = siteflag;
    }

    public String getTruename() {
        return this.Truename;
    }

    public void setTruename(String truename) {
        this.Truename = truename;
    }

    public int getScore() {
        return this.score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getDesignation() {
        return this.designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public int getLevel() {
        return this.level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public void Add() throws SQLException, MessageException {
    }

    public void Delete(int arg0) throws SQLException, MessageException {
    }

    public void Update() throws SQLException, MessageException {
    }

    public boolean canAdd() {
        return false;
    }

    public boolean canDelete() {
        return false;
    }

    public boolean canUpdate() {
        return false;
    }
}
