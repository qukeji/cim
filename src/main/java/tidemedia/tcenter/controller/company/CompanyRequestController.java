package tidemedia.tcenter.controller.company;


import io.swagger.annotations.ApiOperation;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.servlet.ModelAndView;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.*;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CommonUtil;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.entity.company.CompanyRequestEntity;
import tidemedia.tcenter.service.company.CompanyRequestService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.sql.ResultSet;
import org.springframework.web.bind.annotation.RequestParam;
import java.sql.SQLException;
import java.util.*;

import static tidemedia.cms.util.Util2.convertNull;


/**
 * @author gengliao
 * @date 2019/12/05 10:12 AM
 */
@RestController
@RequestMapping("/company/request")
public class CompanyRequestController {
    @Autowired
    private CompanyRequestService companyRequestService;

    private static final Logger logger = LoggerFactory.getLogger(CompanyRequestController.class);

    @RequestMapping(value = "/list")
    @ApiOperation(value = "默认列表页", notes = "默认列表页")
    public ModelAndView listPage(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception{
        ModelAndView modelAndView = new ModelAndView();
        String page = getList_(request, response, modelMap, null);
        modelAndView.setViewName(page);
        return modelAndView;
    }

    /**
     * 定制 ftl 页面字段新增解析
     * @param additionaCustomList
     * @return
     * @throws Exception
     */
    private static String getListByByCustom(List<String> additionaCustomList) throws Exception{

        String customs = "";
        if (additionaCustomList != null && additionaCustomList.size() > 0) {
            for(String custom : additionaCustomList) {
                customs += "," + custom;
            }
        }
        return customs;
    }

    /**
     * 定制化页面的内容注入
     * @param request
     * @param response
     * @param modelMap
     * @param additionaCustomList 定制字段
     * @return
     * @throws Exception
     */
    protected  final String getList_(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, List<String> additionaCustomList) throws Exception {

        // 定制化字段列表
        String listByByCustomSql = "";
        if (additionaCustomList != null){
            listByByCustomSql = getListByByCustom(additionaCustomList);
        }
        // 默认字段
        UserInfo userinfo_session = new UserInfo();
        userinfo_session = (UserInfo)request.getSession().getAttribute("CMSUserInfo");
        //
        String uri = request.getRequestURI();
        long begin_time = System.currentTimeMillis();
        int currPage = CommonUtil.getIntParameter(request, "currPage") ;
        int rowsPerPage = CommonUtil.getIntParameter(request, "rowsPerPage");
        int rows = CommonUtil.getIntParameter(request,"rows");
        int cols = CommonUtil.getIntParameter(request,"cols");
        //
        if(currPage<1)
            currPage = 1;
        if(rowsPerPage==0)
            rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new",request.getCookies()));
        if(rowsPerPage<=0)
            rowsPerPage = 20;
        if(rows==0)
            rows = Util.parseInt(Util.getCookieValue("rows_new",request.getCookies()));
        if(cols==0)
            cols = Util.parseInt(Util.getCookieValue("cols_new",request.getCookies()));
        if(rows==0)
            rows = 10;
        if(cols==0)
            cols = 5;

        String S_companyName			=	CommonUtil.getParameter(request,"companyName");
        String S_productName			=	CommonUtil.getParameter(request,"productName");
        String S_requestDate		=	CommonUtil.getParameter(request,"requestDate");
        int S_Status				=	CommonUtil.getIntParameter(request,"Status");
        int Status1			        =	CommonUtil.getIntParameter(request,"Status1");
        int listType = 0;
        listType = CommonUtil.getIntParameter(request,"listtype");

        // 返回内容组装
        String querystring = "";
        querystring = "&companyName="+ URLEncoder.encode(S_companyName,"UTF-8")+"&requestDate="+S_requestDate+"&productName="+S_productName+"&Status="+S_Status+"&Status1="+Status1;
        //
        String pageName = request.getServletPath();
        int pindex = pageName.lastIndexOf("/");
        if(pindex!=-1)
            pageName = pageName.substring(pindex+1);

        String listSql = "select * from tidemedia_user.company_request where 1=1 ";
        String CountSql = "select count(*) from tidemedia_user.company_request where 1=1 ";
        String whereSql = "";
        if(!S_companyName.equals("")){
            whereSql+="  and companyName like '%" + S_companyName + "%'";
        }
        if(!S_productName.equals("")){
            whereSql+="  and productName like '%" + S_productName + "%'";
        }
        if(!S_requestDate.equals("")){
            whereSql += " and DATE_FORMAT(requestDate,'%Y-%m-%d')='"+S_requestDate+"'";
        }
        if(Status1!=0)
        {
            if(Status1==-1)
                whereSql += " and Status=0";
            else
                whereSql += " and Status=" + Status1;
        }
        if(S_Status!=0) {
            whereSql += " and Status=" + (S_Status - 1);
        }
        whereSql += " order by requestDate desc";
        listSql += whereSql;
        CountSql += whereSql;
        int listnum = rowsPerPage;
        TableUtil tu = new TableUtil("user");
        ResultSet Rs = tu.List(listSql,CountSql,currPage,listnum);
        int TotalPageNumber = tu.pagecontrol.getMaxPages();
        int TotalNumber = tu.pagecontrol.getRowsCount();

        modelMap.addAttribute("listType", listType);
        modelMap.addAttribute("rows", rows);
        modelMap.addAttribute("cols", cols);
        logger.info("cols 列为: " + cols);
        modelMap.addAttribute("rowsPerPage", rowsPerPage);
        modelMap.addAttribute("currPage", currPage);
        modelMap.addAttribute("S_requestDate", S_requestDate);
        modelMap.addAttribute("pageName", pageName);
        modelMap.addAttribute("Status1", Status1);
        modelMap.addAttribute("querystring", querystring);
        modelMap.addAttribute("S_companyName", S_companyName);
        modelMap.addAttribute("S_Status", S_Status);
        modelMap.addAttribute("S_productName", S_productName);
        List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
        while(Rs.next()){
            int id= Rs.getInt("id");
            int status = Rs.getInt("status");
            String companyName	= convertNull(Rs.getString("companyName"));
            String productName	= convertNull(Rs.getString("productName"));
            String requestDate	= convertNull(Rs.getString("requestDate"));
            String openDate	= convertNull(Rs.getString("openDate"));
            HashMap<String, Object> map = new HashMap<>();
            map.put("id", id);
            map.put("status", status);
            map.put("companyName", companyName);
            map.put("productName", productName);
            map.put("requestDate", requestDate);
            map.put("openDate", openDate);
            list.add(map);
        }
        tu.closeRs(Rs);
        modelMap.addAttribute("TotalNumber", TotalNumber);
        modelMap.addAttribute("TotalPageNumber", TotalPageNumber);
        modelMap.put("list", list);
        return "companyProList";
    }

    @RequestMapping("/product")
    public String getComopanyProduct(@RequestParam int companyid) throws SQLException, MessageException, JSONException {
        List<Product> products= companyRequestService.getProducts();
        List<CompanyRequestEntity> requestList = companyRequestService.getComopanyRequest(companyid);
        String companyProducts = new Company(companyid).getProducts();
        String productIds[] = companyProducts.split(",");
        JSONArray yyzc = new JSONArray();
        JSONArray yyfb = new JSONArray();
        JSONArray zyhj = new JSONArray();
        JSONArray scgj = new JSONArray();

        for (Product p :products) {
            int id = p.getId();
            int groupid = p.getGroupId();
            JSONObject obj = new JSONObject();
            int flag = 0;
            if(Arrays.asList(productIds).contains(id+"")){
                flag=1;
            }
            for(CompanyRequestEntity c:requestList){
                if(id==c.getProductId()){
                    flag=2;
                }
            }
            if("tcenter".equals(p.getCode())||"operate".equals(p.getCode())||"company".equals(p.getCode())){
                continue;
            }
            obj.put("logo",p.getLogo());
            obj.put("Name",p.getName());
            obj.put("groupId",groupid);
            obj.put("flag",flag);
            obj.put("pid",id);
            if(groupid==1){
                yyzc.put(obj);
            }else if(groupid==2){
                yyfb.put(obj);
            }else if(groupid==3){
                zyhj.put(obj);
            }else if(groupid==4){
                scgj.put(obj);
            }
        }
        JSONObject result = new JSONObject();
        result.put("yyzc",yyzc);
        result.put("yyfb",yyfb);
        result.put("zyhj",zyhj);
        result.put("scgj",scgj);
        return result.toString();
    }

    /**
     * 租户申请开通产品接口:
     * 申请开通时写入数据
     * @param companyRequestEntity
     * @return
     */
    @RequestMapping("/add")
    public String add(CompanyRequestEntity companyRequestEntity) throws JSONException, MessageException, SQLException {
        JSONObject jsonObject = new JSONObject();
        companyRequestService.addCompanyRequest(companyRequestEntity);
        jsonObject.put("status", 200);
        jsonObject.put("message", "申请成功!");
        return jsonObject.toString();
    }

    @RequestMapping("/update")
    public String update(@RequestParam String ids) throws JSONException, SQLException, MessageException {
        JSONObject jsonObject = new JSONObject();
        companyRequestService.agreeCompanyRequest(ids);
        jsonObject.put("status", 200);
        jsonObject.put("message", "开通成功!");
        return jsonObject.toString();
    }

    @RequestMapping("/details")
    public String details(@RequestParam int id) throws MessageException, SQLException {
        JSONObject jsonObject = new JSONObject(companyRequestService.companyRequestDetails(id));
        return jsonObject.toString();
    }


}
