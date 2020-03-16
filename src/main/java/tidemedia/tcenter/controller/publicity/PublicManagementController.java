package tidemedia.tcenter.controller.publicity;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import tidemedia.tcenter.service.publicity.PublicityService;
import tidemedia.tcenter.util.PageUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;


@Controller
@RequestMapping
@Api(value = "宣告管理列表页",description = "宣告管理列表页")
public class PublicManagementController{

    @Autowired
    PublicityService publicityService;

    private static final Logger logger = LoggerFactory.getLogger(PublicManagementController.class);

    @GetMapping(value = "content/publicManager")
    @ApiOperation(value = "宣告管理列表页", notes = "宣告管理列表页")
    public ModelAndView noticeManagerListPage(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {

        ModelAndView modelAndView = new ModelAndView();

        List<String> additionaCustom = new ArrayList<String>();

        additionaCustom.add("notice_sort");

        long begin = System.currentTimeMillis();
//      String page = getList_(request, response, modelMap, additionaCustom);

        modelMap = PageUtils.getListModelMap(request, response, modelMap, additionaCustom);

        logger.info("宣传管理页面返回参数：" + modelMap.toString() + "\n 宣传管理页面加载耗时：" + (System.currentTimeMillis() - begin) + " ms" );

        modelAndView.addAllObjects(modelMap);
        modelAndView.setViewName("content_document/publicManagementContent");

        return modelAndView;
    }

    @RequestMapping(value = "content/reportManager")
    @ApiOperation(value = "上报管理列表页", notes = "上报管理列表页")
    public ModelAndView reportListPage(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {

        ModelAndView view = new ModelAndView();

        List<String> additionaCustomList = new ArrayList<String>();
        additionaCustomList.add("doc_type"); // 宣传类型 0:图文 1:视频

        long begin = System.currentTimeMillis();
        modelMap = PublicManagementPageController.getListModelMap(request, response, modelMap, additionaCustomList);

        logger.info("宣传管理页面返回参数：" + modelMap.toString() + "\n 宣传管理页面加载耗时：" + (System.currentTimeMillis() - begin) + " ms");

        view.addAllObjects(modelMap);
        view.setViewName("content_document/reportManagementContent");

        return view;
    }

    /**
     * 下发管理 16346
     * 社会     16347
     * 时政     16348
     * @param request
     * @param response
     * @param modelMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "content/issuedManager")
    @ApiOperation(value = "下发管理列表页（id:16346），社会列表页（id:16347），时政列表页（id:16348）", notes = "下发管理列表页（id:16346），社会列表页（id:16347），时政列表页（id:16348）")
    public ModelAndView issuedListPage(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {

        ModelAndView modelAndView = new ModelAndView();

        List<String> additionaCustom = new ArrayList<String>();
        additionaCustom.add("doc_type"); // 宣传类型 0:图文 1:视频

        long begin = System.currentTimeMillis();
        modelMap = publicityService.getListModelMap(request, response, modelMap, additionaCustom);
        logger.info("下发管理页面返回参数：" + modelMap.toString() + "\n 下发管理页面加载耗时：" + (System.currentTimeMillis() - begin) + " ms" );

        modelAndView.setViewName("content_document/issuedManagementContent");
        modelAndView.addAllObjects(modelMap);

        return modelAndView;
    }
}
