package tidemedia.tcenter.service.video;

import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Service;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelUtil;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.entity.video.Video;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class VideoService {

    public JSONObject list(int userId, int type, String keyword, int currPage, int pageNum) throws SQLException, MessageException {
        int videoChannelId = CmsCache.getChannel("video").getId();
        JSONObject jsonObject = new JSONObject();
        if (currPage < 1)
            currPage = 1;
        if (pageNum < 1)
            pageNum = 20;
        int startNum = (currPage - 1) * pageNum;
        Channel channel = CmsCache.getChannel(videoChannelId);
        String Table = channel.getTableName();
        String ListSql = "select *  from " + Table + " where active = 1 and trim(GlobalID) != '' and trim(video_source) != '' and Duration != 0";
        String CountSql = "select count(*) sum from " + Table + " where active = 1 and trim(GlobalID) != '' and trim(video_source) != '' and Duration != 0";
        int pgcChannelId = ChannelUtil.getApplicationChannel("pgc").getId();//pgc内容管理频道
        if (type == 2) {
            ListSql += " and Category = " + pgcChannelId;
            CountSql += " and Category = " + pgcChannelId;
        } else if (type == 0) {
            ListSql += " and User = " + userId;
            CountSql += " and User = " + userId;
        }
        if (keyword.length() > 0) {
            ListSql += " and title like '%" + keyword + "%'";
            CountSql += " and title like '%" + keyword + "%'";
        }
        ListSql += " order by createdate desc";
        ListSql += " limit " + startNum + "," + pageNum;
        System.out.println("videoservice.listsql=" + ListSql);
        List<Video> list = new ArrayList<>();
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(ListSql);
        while (rs.next()) {
            int GlobalID = rs.getInt("GlobalID");
            int Duration = rs.getInt("Duration");
            String title = rs.getString("Title");
            String createDate = rs.getString("CreateDate");
            createDate = Util.FormatTimeStamp("", Long.valueOf(createDate));
            Document doc = CmsCache.getDocument(GlobalID);
            String coverhref = doc.getValue("Photo");
            String flvurl = "";
            String desc = "";
            int videoId = 0;
            List<Map<String, Object>> videolist = new ArrayList<>();
            ArrayList docs = doc.listChildItems(4);
            if (docs.size() > 0) {
                for (int j = 0; j < docs.size(); j++) {
                    Document d = (Document) docs.get(j);
                    flvurl = Util.ClearPath(d.getValue("Url"));
                    if (flvurl.length() > 0) videoId = d.getId();
                    desc = d.getValue("video_desc");
                    Map<String, Object> map = new HashMap<>();
                    map.put("desc", desc);
                    map.put("videoId", videoId);
                    map.put("flvurl", flvurl);
                    videolist.add(map);
                }
            }
            Video video = new Video();
            video.setTitle(title);
            video.setGlobalId(GlobalID);
            video.setVideolist(videolist);
            video.setCreateDate(createDate);
            video.setDuration(Duration);
            video.setCoverhref(coverhref);
            list.add(video);
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
