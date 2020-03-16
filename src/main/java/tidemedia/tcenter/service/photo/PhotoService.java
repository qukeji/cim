package tidemedia.tcenter.service.photo;

import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Service;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.tcenter.entity.photo.Photo;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Service
public class PhotoService {

    public JSONObject list(int userId, int type, String keyword, int currPage, int pageNum) throws MessageException, SQLException {

        int photoChannelID = CmsCache.getChannel("photo_back").getId();
        int photoChannelId = CmsCache.getParameter("sys_config_photo").getJson().getInt("channelid");
        JSONObject jsonObject = new JSONObject();
        if (currPage < 1)
            currPage = 1;
        if (pageNum < 1)
            pageNum = 20;
        int startNum = (currPage - 1) * pageNum;
        Channel channel = CmsCache.getChannel(photoChannelId);
        String Table = channel.getTableName();
        String ListSql = "select * from " + Table + " where active = 1 and trim(GlobalID) != '' and trim(Photo) != ''";
        String CountSql = "select count(*) sum from " + Table + " where active = 1 and trim(GlobalID) != '' and trim(Photo) != ''";
        if (type == 1) {
            ListSql += " and Category = " + photoChannelID;
            CountSql += " and Category = " + photoChannelID;
        } else if (type == 2) {
            ListSql += " and User = " + userId;
            CountSql += " and User = " + userId;
        }
        if(keyword.length()>0){
            ListSql += " and title like '%" + keyword+"%'";
            CountSql += " and title like '%" + keyword+"%'";
        }
        ListSql += " order by createdate desc";
        ListSql += " limit " + startNum + "," + pageNum;
        System.out.println("photoservice.listsql==" + ListSql);
        String SiteAddress = channel.getSite().getUrl();
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(ListSql);
        List<Photo> list = new ArrayList<>();
        while (rs.next()) {
            int id = rs.getInt("id");
            int GlobalID = rs.getInt("GlobalID");
            String title = rs.getString("Title");
            String photoAddr = rs.getString("Photo");
            if (!photoAddr.startsWith("http://"))
                photoAddr = SiteAddress + photoAddr;
            Photo photo = new Photo();
            photo.setPhotoAddr(photoAddr);
            photo.setGlobalId(GlobalID);
            photo.setTitle(title);
            list.add(photo);
        }
        tu.closeRs(rs);
        ResultSet rs2 = tu.executeQuery(CountSql);
        int totalNumber = 0;
        while (rs2.next()) {
            totalNumber = rs2.getInt("sum");
        }
        tu.closeRs(rs2);
        int totalPageNumber = 0;
        if (totalNumber <= pageNum) {
            totalPageNumber = 1;
        } else {
            totalPageNumber = totalNumber / pageNum;
            if (totalNumber % pageNum > 0) {
                totalPageNumber++;
            }
        }
        jsonObject.put("list", list);
        jsonObject.put("totalNumber", totalNumber);
        jsonObject.put("totalPageNumber", totalPageNumber);
        jsonObject.put("currPage", currPage);
        return jsonObject;
    }
}
