package tidemedia.tcenter.controller.channel;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.util.CommonUtil;
import tidemedia.tcenter.base.ResultJson;
import tidemedia.tcenter.entity.channel.ChannelListHeader;
import tidemedia.tcenter.service.channel.ChannelListHeaderService;

import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;

@RestController
@RequestMapping("/channel/list")
@Api(tags = {"列表项目接口"})
public class ChannelListHeaderController {
    @Autowired
    private ChannelListHeaderService channelListHeaderService;

    //列表项目详情接口
    @RequestMapping(value = "/header/get",method = RequestMethod.GET)
    @ApiOperation(value = "列表项目详情", notes="列表项目详情")
    @ApiImplicitParam(name = "id", value = "列表项目id", paramType = "query", required = true, dataType = "int")
    public ResultJson getById(@RequestParam int id) {
        if (id == 0) {
            return ResultJson.error("请传递正确的id参数");
        }
        return ResultJson.success(channelListHeaderService.getById(id));
    }

    //关联表单列表接口
    @RequestMapping(value = "/header/field/list",method = RequestMethod.GET)
    @ApiOperation(value = "关联表单列表", notes="关联表单列表")
    @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int")
    public ResultJson fieldList(@RequestParam("channel") int channelId) throws MessageException, SQLException {
        if (channelId == 0) {
            return ResultJson.error("请传递正确的channelId参数");
        }
        return ResultJson.success(channelListHeaderService.fieldList(channelId));
    }

    //列表项目接口(获取列表项目表字段信息)
    @RequestMapping(value = "/header/list",method = RequestMethod.GET)
    @ApiOperation(value = "列表项目接口1(获取列表项目表字段信息)", notes="列表项目接口1(获取列表项目表字段信息)")
    @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int")
    public ResultJson list(@RequestParam("channel") int channelId) throws MessageException, SQLException {
        if (channelId == 0) {
            return ResultJson.error("请传递正确的channelId参数");
        }
        return ResultJson.success(channelListHeaderService.list(channelId));
    }

    //列表项目接口(获取频道表字段信息)
    @RequestMapping(value = "/header/list2",method = RequestMethod.GET)
    @ApiOperation(value = "列表项目接口2(获取频道表字段信息)", notes="列表项目接口2(获取频道表字段信息)")
    @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int")
    public ResultJson list2(@RequestParam("channel") int channelId) throws MessageException {
        if (channelId == 0) {
            return ResultJson.error("请传递正确的channelId参数");
        }
        return ResultJson.success(channelListHeaderService.list2(channelId));
    }

    //增加列表项目接口
    @RequestMapping(value = "/header/add",method = RequestMethod.POST)
    @ApiOperation(value = "增加列表项目", notes="增加列表项目")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "title", value = "列表项目名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "width", value = "显示宽度", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "fieldName", value = "关联表单名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "script", value = "列表项目脚本", paramType = "query", required = false, dataType = "String"),
            @ApiImplicitParam(name = "status", value = "使用状态", paramType = "query", required = true, dataType = "int")
    })
    public ResultJson addListHeader(@RequestParam int channel,@RequestParam String title,@RequestParam int width,@RequestParam String fieldName,@RequestParam(required = false) String script,@RequestParam int status) throws MessageException, SQLException {
        ChannelListHeader listHeader = new ChannelListHeader();
        listHeader.setChannel(channel);
        listHeader.setTitle(title);
        listHeader.setWidth(width);
        listHeader.setFieldName(fieldName);
        listHeader.setScript(script);
        listHeader.setStatus(status);
        if (listHeader.getTitle().length() == 0 || listHeader.getFieldName().length() == 0) {
            return ResultJson.error("参数不完整!");
        }
        channelListHeaderService.add(listHeader);
        return ResultJson.success("");
    }

    //删除列表项目接口
    @RequestMapping(value = "/header/delete",method = RequestMethod.POST)
    @ApiOperation(value = "删除列表项目", notes="删除列表项目")
    @ApiImplicitParam(name = "id", value = "列表项目id", paramType = "query", required = true, dataType = "int")
    public ResultJson deleteListHeader(@RequestParam int id) {
        if (id == 0) {
            return ResultJson.error("请传递正确的id参数");
        }
        channelListHeaderService.delete(id);
        return ResultJson.success("");
    }

    //修改列表项目
    @RequestMapping(value = "/header/update",method = RequestMethod.POST)
    @ApiOperation(value = "修改列表项目", notes="修改列表项目")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "列表项目id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "title", value = "列表项目名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "width", value = "显示宽度", paramType = "query", required = false, dataType = "int"),
            @ApiImplicitParam(name = "fieldName", value = "关联表单名称", paramType = "query", required = false, dataType = "String"),
            @ApiImplicitParam(name = "script", value = "列表项目脚本", paramType = "query", required = false, dataType = "String")
    })
    public ResultJson update(@RequestParam int id,@RequestParam String title,@RequestParam(required = false) int width,@RequestParam(required = false) String fieldName,@RequestParam(required = false) String script) {
        ChannelListHeader listHeader = new ChannelListHeader();
        listHeader.setId(id);
        listHeader.setTitle(title);
        listHeader.setWidth(width);
        listHeader.setFieldName(fieldName);
        listHeader.setScript(script);
        if (listHeader.getId() == 0 || listHeader.getTitle().length() == 0 || listHeader.getFieldName().length() == 0) {
            return ResultJson.error("参数不完整!");
        }
        channelListHeaderService.update(listHeader);
        return ResultJson.success("");
    }

    //列表项目提交接口
    @RequestMapping(value = "/header/set",method = RequestMethod.POST)
    @ApiOperation(value = "列表项目提交", notes="列表项目提交")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "viewType", value = "列表页视图", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "other", value = "其他功能", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "channelId", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "id1", value = "列表项目id", paramType = "query", required = true, dataType = "String")
    })
    public ResultJson setHeader(HttpServletRequest request) throws MessageException, SQLException {
        int viewType = CommonUtil.getIntParameter(request, "viewType");
        String other = CommonUtil.getParameter(request, "other");
        int channelId = CommonUtil.getIntParameter(request, "channel");
        String id1 = CommonUtil.getParameter(request, "id1");
        if (channelId == 0||id1.length()==0||other.length()==0) {
            return ResultJson.error("参数不完整！");
        }
        channelListHeaderService.updateChannelField(viewType, other, channelId);
        channelListHeaderService.setHeader(id1,channelId);
        return ResultJson.success("");
    }
}
