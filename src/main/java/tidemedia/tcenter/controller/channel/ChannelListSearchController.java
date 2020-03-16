package tidemedia.tcenter.controller.channel;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import tidemedia.cms.base.MessageException;
import tidemedia.tcenter.base.ResultJson;
import tidemedia.tcenter.entity.channel.ChannelListSearch;
import tidemedia.tcenter.service.channel.ChannelListSearchService;

import java.sql.SQLException;

@RestController
@RequestMapping("/channel/list")
@Api(tags = {"搜索项目接口"})
public class ChannelListSearchController {
    @Autowired
    private ChannelListSearchService listSearchService;

    //搜索项目列表接口
    @RequestMapping(value = "/search/list",method = RequestMethod.GET)
    @ApiOperation(value = "搜索项目列表", notes="搜索项目列表")
    @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int")
    public ResultJson list(@RequestParam("channel") int channelId) throws MessageException, SQLException {
        return ResultJson.success(listSearchService.list(channelId));
    }

    //搜索项目详情接口
    @RequestMapping(value = "/search/get",method = RequestMethod.GET)
    @ApiOperation(value = "搜索项目详情", notes="搜索项目详情")
    @ApiImplicitParam(name = "id", value = "搜索项目id", paramType = "query", required = true, dataType = "int")
    public ResultJson getById(@RequestParam int id) {
        if (id == 0) {
            return ResultJson.error("请传递正确的id参数");
        }
        return ResultJson.success(listSearchService.getById(id));
    }

    //关联表单列表接口
    @RequestMapping(value = "/search/field/list",method = RequestMethod.GET)
    @ApiOperation(value = "关联表单列表", notes="关联表单列表")
    @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int")
    public ResultJson fieldList(@RequestParam("channel") int channelId) throws MessageException, SQLException {
        if (channelId == 0) {
            return ResultJson.error("请传递正确的channelId参数");
        }
        return ResultJson.success(listSearchService.fieldList(channelId));
    }

    //搜索项目提交接口
    @PostMapping("/search/set")
    @ApiOperation(value = "搜索项目提交", notes="搜索项目提交")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "id1", value = "搜索项目id", paramType = "query", required = true, dataType = "String")
    })
    public ResultJson setHeader(@RequestParam("channel") Integer channelId,@RequestParam String id1) throws MessageException, SQLException {
        if (channelId == 0||id1.length()==0) {
            return ResultJson.error("参数不完整！");
        }
        listSearchService.setSearch(id1,channelId);
        return ResultJson.success("");
    }

    //增加搜索项目接口
    @PostMapping("/search/add")
    @ApiOperation(value = "增加搜索项目", notes="增加搜索项目")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "title", value = "名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "fieldName", value = "关联表单名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "script", value = "搜索项目脚本", paramType = "query", required = false, dataType = "String"),
            @ApiImplicitParam(name = "status", value = "使用状态", paramType = "query", required = true, dataType = "int")
    })
    public ResultJson addListHeader(@RequestParam int channel,@RequestParam String title,@RequestParam String fieldName,@RequestParam(required = false) String script,@RequestParam int status) throws MessageException, SQLException {
        ChannelListSearch listSearch = new ChannelListSearch();
        listSearch.setChannel(channel);
        listSearch.setTitle(title);
        listSearch.setFieldName(fieldName);
        listSearch.setScript(script);
        listSearch.setStatus(status);
        if(channel==0||title.length()==0||fieldName.length()==0){
            return ResultJson.error("参数不完整!");
        }
        listSearchService.add(listSearch);
        return ResultJson.success("");
    }

    //删除搜索项目接口
    @PostMapping("/search/delete")
    @ApiOperation(value = "删除搜索项目", notes="删除搜索项目")
    @ApiImplicitParam(name = "id", value = "搜索项目id", paramType = "query", required = true, dataType = "int")
    public ResultJson deleteListHeader(@RequestParam int id) {
        listSearchService.delete(id);
        return ResultJson.success("");
    }

    //修改搜索项目接口
    @PostMapping(value = "/search/update")
    @ApiOperation(value = "修改搜索项目", notes="修改搜索项目")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "搜索项目id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "title", value = "名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "fieldName", value = "关联表单名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "script", value = "搜索项目脚本", paramType = "query", required = false, dataType = "String")
    })
    public ResultJson update(@RequestParam int id,@RequestParam String title,@RequestParam String fieldName,@RequestParam(required = false) String script) {
        ChannelListSearch listSearch = new ChannelListSearch();
        listSearch.setId(id);
        listSearch.setTitle(title);
        listSearch.setFieldName(fieldName);
        listSearch.setScript(script);
        if (listSearch.getId() == 0 || listSearch.getTitle().length() == 0 || listSearch.getFieldName().length() == 0) {
            return ResultJson.error("参数不完整！");
        }
        listSearchService.update(listSearch);
        return ResultJson.success("");
    }
}
