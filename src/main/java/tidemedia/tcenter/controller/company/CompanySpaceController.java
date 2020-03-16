package tidemedia.tcenter.controller.company;

import com.alibaba.fastjson.JSONObject;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.controller.content.ListController;
import tidemedia.tcenter.service.company.CompanySpaceService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

@RestController
@RequestMapping("company/space")
public class CompanySpaceController {

    @Autowired
    private CompanySpaceService spaceService;

    private static final Logger logger = LoggerFactory.getLogger(ListController.class);

    @RequestMapping("/list")
    @ApiOperation(value = "租户运营中心存储管理列表页", notes = "租户运营中心存储管理列表页")
    public ModelAndView list(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {

        ModelAndView modelAndView = new ModelAndView();

        String page = getList_(request, response, modelMap, null);

        modelAndView.setViewName(page);

        return modelAndView;
    }

    @RequestMapping("/details")
    public ModelAndView details(HttpServletRequest request, ModelMap modelMap) {

        ModelAndView modelAndView = new ModelAndView();

        int id = CommonUtil.getIntParameter(request, "id");
        double usePhotoSpace = Double.parseDouble(CommonUtil.getParameter(request, "usePhotoSpace").replace("G", ""));//图片
        double useVideoSpace = Double.parseDouble(CommonUtil.getParameter(request, "useVideoSpace").replace("G", ""));//视频
        double useFileSpace = Double.parseDouble(CommonUtil.getParameter(request, "useFileSpace").replace("G", ""));//文件
        double space = Double.parseDouble(CommonUtil.getParameter(request, "space").replace("G", ""));//总
        double useTotal = usePhotoSpace + useVideoSpace + useFileSpace;//已使用
        double residue = space - useTotal;//剩余
        String photoRatio = "";
        String videoRatio = "";
        String fileRatio = "";
        if (space == 0) {
            photoRatio = "0.00%";
            videoRatio = "0.00%";
            fileRatio = "0.00%";
        } else {
            photoRatio = String.format("%.2f",  usePhotoSpace / space * 100) + "%";//图片占比
            videoRatio = String.format("%.2f",  useVideoSpace / space * 100) + "%";//视频占比
            fileRatio = String.format("%.2f", useFileSpace / space * 100) + "%";//文件占比
        }
        modelMap.put("id", id);
        modelMap.put("usePhotoSpace",String.format("%.1f",usePhotoSpace) );
        modelMap.put("useVideoSpace",String.format("%.1f",useVideoSpace) );
        modelMap.put("useFileSpace",String.format("%.1f",useFileSpace) );
        modelMap.put("useTotal",String.format("%.1f",useTotal) );
        modelMap.put("residue",String.format("%.1f",residue) );
        modelMap.put("space", space);
        modelMap.put("photoRatio", photoRatio);
        modelMap.put("videoRatio", videoRatio);
        modelMap.put("fileRatio", fileRatio);
        modelAndView.setViewName("editstorage");

        return modelAndView;
    }

    @RequestMapping("/update")
    public void update(@RequestParam int id, @RequestParam int space) throws MessageException, SQLException {
        spaceService.update(id, space);
    }

    /**
     * 定制化页面的内容注入
     *
     * @param request
     * @param response
     * @param modelMap
     * @param additionaCustomList 定制字段
     * @return
     * @throws Exception
     */
    protected final String getList_(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, List<String> additionaCustomList) throws Exception {

        //入参
        int currPage = CommonUtil.getIntParameter(request, "currPage");
        int rowsPerPage = CommonUtil.getIntParameter(request, "rowsPerPage");
        String companyName = CommonUtil.getParameter(request, "companyName");

        if (currPage < 1)
            currPage = 1;
        if (rowsPerPage == 0)
            rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new", request.getCookies()));
        if (rowsPerPage <= 0)
            rowsPerPage = 20;

        String S_Title = CommonUtil.getParameter(request, "Title");
        String S_startDate = CommonUtil.getParameter(request, "startDate");
        String S_endDate = CommonUtil.getParameter(request, "endDate");
        String S_User = CommonUtil.getParameter(request, "User");
        int S_Status = CommonUtil.getIntParameter(request, "Status");
        int S_IsPhotoNews = CommonUtil.getIntParameter(request, "IsPhotoNews");
        int S_OpenSearch = CommonUtil.getIntParameter(request, "OpenSearch");
        int IsDelete = CommonUtil.getIntParameter(request, "IsDelete");
        int Status1 = CommonUtil.getIntParameter(request, "Status1");

        // 返回内容组装
        String querystring = "";
        querystring = "&Title=" + URLEncoder.encode(S_Title, "UTF-8") + "&startDate=" + S_startDate + "&endDate=" + S_endDate + "&User=" + S_User + "&Status=" + S_Status + "&IsPhotoNews=" + S_IsPhotoNews + "&OpenSearch=" + S_OpenSearch + "&IsDelete=" + IsDelete + "&Status1=" + Status1;
        //
        String pageName = request.getServletPath();
        int pindex = pageName.lastIndexOf("/");
        if (pindex != -1)
            pageName = pageName.substring(pindex + 1);

        //获取频道路径
        modelMap.addAttribute("listType", 1);
        modelMap.addAttribute("rowsPerPage", rowsPerPage);
        modelMap.addAttribute("currPage", currPage);
        modelMap.addAttribute("pageName", pageName);
        modelMap.addAttribute("Status1", Status1);
        modelMap.addAttribute("IsDelete", IsDelete);
        modelMap.addAttribute("S_OpenSearch", S_OpenSearch);
        modelMap.addAttribute("querystring", querystring);
        modelMap.addAttribute("S_Title", S_Title);
        modelMap.addAttribute("S_Status", S_Status);
        modelMap.addAttribute("S_startDate", S_startDate);
        modelMap.addAttribute("S_endDate", S_endDate);
        modelMap.addAttribute("S_User", S_User);

        //去掉mapper和service
        List<Map<String, Object>> list = new ArrayList<>();
        List<Map<String, Object>> list1 = new ArrayList<>();
        TableUtil tu = new TableUtil("user");
        String sql = "select id,Name,useFileSpace,space from company";
        String countSql = "select count(*) from company";
        if (companyName.length() > 0) {
            sql += " where Name like '%" + companyName+"%'";
            countSql += " where Name like '%" + companyName+"%'";
        }
        ResultSet rs = tu.List(sql, countSql, currPage, rowsPerPage);
        int TotalPageNumber = tu.pagecontrol.getMaxPages();
        int TotalNumber = tu.pagecontrol.getRowsCount();
        while (rs.next()) {
            long id = rs.getLong("id");
            int useFileSpace = rs.getInt("useFileSpace");
            int space = rs.getInt("space");
            String name = rs.getString("Name");
            Map<String, Object> map = new HashMap<>();
            map.put("id", id);
            map.put("useFileSpace", useFileSpace);
            map.put("space", space);
            map.put("name", name);
            list.add(map);
        }
        tu.closeRs(rs);
        String url = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
        for (int i = 0; i < list.size(); i++) {
            Map<String, Object> map = list.get(i);
            long companyId = (long) map.get("id");
            String tcenterResult = Util.connectHttpUrl(url+"/tcenter/storage/size/ziyuan_tongji.jsp?company=" + companyId);//请求tcenter下的计算图片大小接口
            double tcenterImageSize = JSONObject.parseObject(tcenterResult).getDoubleValue("pic_totle_size");//tcentert图片占用空间
            String vmsResult = Util.connectHttpUrl(url+"/vms/storage/size/ziyuan_tongji.jsp?company=" + companyId);//请求vms下的计算视频与图片大小接口
            double vmsImageSize = JSONObject.parseObject(vmsResult).getDoubleValue("pic_totle_size");//vms图片占用空间
            double videoSize = JSONObject.parseObject(vmsResult).getDoubleValue("video_totle_size");//视频占用空间
            double space = Double.valueOf((int)map.get("space"));//总空间
            double useFileSpace =Double.parseDouble(((int) map.get("useFileSpace") +""))/1024/1024; //文件占用空间
            double imageSize = tcenterImageSize + vmsImageSize;//图片占用空间
            double space1 = space - (imageSize + videoSize + useFileSpace);//剩余空间
            String space2 = "";//超出空间
            if (space1 < 0) {
                space2 =String.format("%.1f",Math.abs(space1)) ;
                space1 = 0;
            }
            if("0.0".equals(space2)){
                space2="";
            }
            Map<String, Object> map1 = new HashMap<>();
            map1.put("id", map.get("id"));
            map1.put("companyName", map.get("name"));
            map1.put("space", space + "G");
            map1.put("usePhotoSpace",String.format("%.1f", imageSize) + "G");
            map1.put("useVideoSpace",String.format("%.1f", videoSize)  + "G");
            map1.put("useFileSpace",String.format("%.1f", useFileSpace)  + "G");
            map1.put("space1",String.format("%.1f", space1) );
            map1.put("space2", space2);
            list1.add(map1);
        }
        modelMap.put("list", list1);
        modelMap.put("TotalPageNumber", TotalPageNumber);
        modelMap.put("TotalNumber", TotalNumber);
        modelMap.put("CompanyName", companyName);
        return "storageContent";
    }
}
