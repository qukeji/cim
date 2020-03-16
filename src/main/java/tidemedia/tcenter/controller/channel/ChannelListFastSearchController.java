package tidemedia.tcenter.controller.channel;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import tidemedia.cms.base.MessageException;
import tidemedia.tcenter.base.ResultJson;
import tidemedia.tcenter.entity.channel.ChannelListFastSearch;
import tidemedia.tcenter.service.channel.ChannelListFastSearchService;

import java.sql.SQLException;

@RestController
@RequestMapping("/channel/list")
@Api(tags = {"快捷搜索接口"})
public class ChannelListFastSearchController {
    @Autowired
    private ChannelListFastSearchService listFastSearchService;

    //快捷搜索列表接口
    @RequestMapping(value = "/fastsearch/list",method = RequestMethod.GET)
    @ApiOperation(value = "快捷搜索列表", notes="快捷搜索列表")
    @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int")
    public ResultJson list(@RequestParam("channel") int channelId) throws MessageException, SQLException {
        return ResultJson.success(listFastSearchService.list(channelId));
    }

    //快捷搜索详情接口
    @RequestMapping(value = "/fastsearch/get",method = RequestMethod.GET)
    @ApiOperation(value = "快捷搜索详情", notes="快捷搜索详情")
    @ApiImplicitParam(name = "id", value = "快捷搜索id", paramType = "query", required = true, dataType = "int")
    public ResultJson getById(@RequestParam int id) {
        if (id == 0) {
            return ResultJson.error("请传递正确的id参数");
        }
        return ResultJson.success(listFastSearchService.getById(id));
    }

    //快捷搜索提交接口
    @PostMapping("/fastsearch/set")
    @ApiOperation(value = "快捷搜索提交", notes="快捷搜索提交")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "id1", value = "快捷搜索提交id", paramType = "query", required = true, dataType = "String")
    })
    public ResultJson setHeader(@RequestParam("channel") Integer channelId,@RequestParam String id1) throws MessageException, SQLException {
        if (channelId == 0||id1.length()==0) {
            return ResultJson.error("参数不完整！");
        }
        listFastSearchService.setFastSearch(id1,channelId);
        return ResultJson.success("");
    }

    //增加快捷搜索接口
    @PostMapping("/fastsearch/add")
    @ApiOperation(value = "增加快捷搜索", notes="增加快捷搜索")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "channel", value = "频道id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "title", value = "名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "wheresql", value = "条件SQL", paramType = "query", required = false, dataType = "String"),
            @ApiImplicitParam(name = "script", value = "快捷搜索脚本", paramType = "query", required = false, dataType = "String"),
            @ApiImplicitParam(name = "status", value = "使用状态", paramType = "query", required = true, dataType = "int"),
    })
    public ResultJson addListHeader(@RequestParam int channel,@RequestParam String title,@RequestParam("wheresql") String wheresSql,@RequestParam(required = false) String script,@RequestParam int status) throws MessageException, SQLException {
        ChannelListFastSearch listFastSearch = new ChannelListFastSearch();
        listFastSearch.setChannel(channel);
        listFastSearch.setTitle(title);
        listFastSearch.setScript(script);
        listFastSearch.setWheresql(wheresSql);
        listFastSearch.setStatus(status);
        if (listFastSearch.getTitle().length() == 0||(listFastSearch.getWheresql().length()==0&&listFastSearch.getScript().length()==0)) {
            return ResultJson.error("参数不完整!");
        }
        listFastSearchService.add(listFastSearch);
        return ResultJson.success("");
    }

    //删除快捷搜索接口
    @PostMapping("/fastsearch/delete")
    @ApiOperation(value = "删除快捷搜索", notes="删除快捷搜索")
    @ApiImplicitParam(name = "id", value = "快捷搜索id", paramType = "query", required = true, dataType = "int")
    public ResultJson deleteListHeader(@RequestParam int id) {
        listFastSearchService.delete(id);
        return ResultJson.success("");
    }

    //修改快捷搜索接口
    @PostMapping(value = "/fastsearch/update")
    @ApiOperation(value = "修改快捷搜索", notes="修改快捷搜索")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "快捷搜索id", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "title", value = "名称", paramType = "query", required = true, dataType = "String"),
            @ApiImplicitParam(name = "wheresql", value = "条件SQL", paramType = "query", required = false, dataType = "String"),
            @ApiImplicitParam(name = "script", value = "快捷搜索脚本", paramType = "query", required = false, dataType = "String")
    })
    public ResultJson update(@RequestParam int id,@RequestParam String title,@RequestParam("wheresql") String whereSql,@RequestParam(required = false) String script) {
        ChannelListFastSearch listFastSearch = new ChannelListFastSearch();
        listFastSearch.setId(id);
        listFastSearch.setTitle(title);
        listFastSearch.setWheresql(whereSql);
        listFastSearch.setScript(script);
        if(listFastSearch.getId()==0||listFastSearch.getTitle().length()==0||(listFastSearch.getWheresql().length()==0&&listFastSearch.getScript().length()==0)){
            return ResultJson.error("参数不完整！");
        }
        listFastSearchService.update(listFastSearch);
        return ResultJson.success("");
    }
}
