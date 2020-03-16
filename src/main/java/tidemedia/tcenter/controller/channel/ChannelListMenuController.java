package tidemedia.tcenter.controller.channel;

import io.swagger.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.util.CommonUtil;
import tidemedia.tcenter.base.ResultJson;
import tidemedia.tcenter.entity.channel.ChannelListMenu;
import tidemedia.tcenter.service.channel.ChannelListMenuService;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.sql.SQLException;

@RestController
@RequestMapping("/channel/list/menu")
@Api(tags = {"功能菜单接口"})
public class ChannelListMenuController {
    @Autowired
    private ChannelListMenuService channelListMenuService;

    //功能菜单接列表接口
    @RequestMapping(value = "/list",method = RequestMethod.GET)
    @ApiOperation(value = "功能菜单接列表", notes="功能菜单接列表")
    @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int")
    public ResultJson list(@RequestParam("channel") int channelId) throws MessageException, SQLException {
        if (channelId == 0) {
            return ResultJson.error("channelId为0");
        }
        return ResultJson.success(channelListMenuService.list(channelId));
    }

    //功能菜单详情接口1
    @RequestMapping(value = "get",method = RequestMethod.GET)
    @ApiOperation(value = "功能菜单详情1", notes="功能菜单详情1")
    @ApiImplicitParam(name = "id", value = "功能菜单id", paramType = "query", required = true, dataType = "int")
    public ResultJson getById(int id){
        if (id == 0) {
            return ResultJson.error("id为0");
        }
        return ResultJson.success(channelListMenuService.getById(id));
    }

    //功能菜单详情接口2
    @RequestMapping(value = "/getByCode",method = RequestMethod.GET)
    @ApiOperation(value = "功能菜单详情2", notes="功能菜单详情2")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "code", value = "方法名", paramType = "query", required = true, dataType = "String")
    })
    public ResultJson getByCode(@RequestParam("channel") int channelId,String code) throws MessageException, SQLException {
        if (channelId==0||code==null||code.equals("")) {
            return ResultJson.error("请检查参数是否正确");
        }
        return ResultJson.success(channelListMenuService.getByCode(channelId,code));
    }

    //功能菜单提交接口
    @RequestMapping(value = "/set",method = RequestMethod.POST)
    @ApiOperation(value = "功能菜单提交", notes="功能菜单提交")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "id1", value = "当前菜单功能id", paramType = "query", required = true, dataType = "String")
    })
    public ResultJson setHeader(@RequestParam String id1,@RequestParam("channel") int channelId) throws MessageException, SQLException {
        if (id1.length() == 0||channelId==0) {
            return ResultJson.error("参数不完整");
        }
        channelListMenuService.setHeader(id1,channelId);
        return ResultJson.success("");
    }

    //增加功能菜单接口
    @RequestMapping(value = "/add",method = RequestMethod.POST)
    @ApiOperation(value = "增加功能菜单", notes="增加功能菜单")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "title", value = "名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "script", value = "脚本", paramType = "query", required = false, dataType = "String"),
            @ApiImplicitParam(name = "icon", value = "图标", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "status", value = "使用状态", paramType = "query", required = true, dataType = "int")
    })
    public ResultJson addListHeader(HttpServletRequest request) throws MessageException, SQLException {
        String title = CommonUtil.getParameter(request, "title");
        String script = CommonUtil.getParameter(request, "script");
        String icon = CommonUtil.getParameter(request, "icon");
        int channel = CommonUtil.getIntParameter(request, "channel");
        int status = CommonUtil.getIntParameter(request, "status");
        ChannelListMenu listMenu = new ChannelListMenu();
        listMenu.setTitle(title);
        listMenu.setScript(script);
        listMenu.setIcon(icon);
        listMenu.setStatus(status);
        listMenu.setChannel(channel);
        channelListMenuService.add(listMenu);
        return ResultJson.success("");
    }

    //删除功能菜单接口
    @RequestMapping(value = "/delete",method = RequestMethod.POST)
    @ApiOperation(value = "删除功能菜单", notes="删除功能菜单")
    @ApiImplicitParam(name = "id", value = "功能菜单id", paramType = "query", required = true, dataType = "int")
    public ResultJson deleteListHeader(@RequestParam int id) {
        if (id == 0) {
            return ResultJson.error("id为0");
        }
        channelListMenuService.delete(id);
        return ResultJson.success("");
    }

    //编辑功能菜单图标显示接口
    @RequestMapping(value = "/update",method = RequestMethod.POST)
    @ApiOperation(value = "编辑功能菜单图标显示", notes="编辑功能菜单图标显示")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "菜单功能id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "isview", value = "是否显示图标,0不显示1显示", paramType = "query", required = true, dataType = "int")
    })
    public ResultJson update(@RequestParam int id,@RequestParam("isview") int isView) {
        if (id == 0) {
            return ResultJson.error("id为0");
        }
        ChannelListMenu listMenu = new ChannelListMenu();
        listMenu.setIsview(isView);
        listMenu.setId(id);
        channelListMenuService.update(listMenu);
        return ResultJson.success("");
    }

    //编辑功能菜单详情接口
    @RequestMapping(value = "/update2",method = RequestMethod.POST)
    @ApiOperation(value = "编辑功能菜单详情", notes="编辑功能菜单详情")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "title", value = "名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "script", value = "脚本", paramType = "query", required = false, dataType = "String"),
            @ApiImplicitParam(name = "icon", value = "图标", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "id", value = "功能菜单id", paramType = "query", required = true, dataType = "int")
    })
    public ResultJson update2(HttpServletRequest request) {
        String title = CommonUtil.getParameter(request, "title");
        String script = CommonUtil.getParameter(request, "script");
        String icon = CommonUtil.getParameter(request, "icon");
        int id = CommonUtil.getIntParameter(request, "id");
        ChannelListMenu listMenu = new ChannelListMenu();
        listMenu.setTitle(title);
        listMenu.setScript(script);
        listMenu.setIcon(icon);
        listMenu.setId(id);
        if (listMenu.getId() == 0||listMenu.getTitle().length()==0||listMenu.getIcon().length()==0) {
            return ResultJson.error("参数不完整");
        }
        channelListMenuService.update2(listMenu);
        return ResultJson.success("");
    }

}
