package tidemedia.tcenter.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import tidemedia.tcenter.base.ResultJson;
import tidemedia.tcenter.service.DemoService;

@RestController
@RequestMapping("/demo/")
@Api(tags = {"示例接口"})
public class DemoController {

    @Autowired
    private DemoService demoService;

    @RequestMapping(value = "listall", method = {RequestMethod.GET, RequestMethod.GET})
    @ApiOperation(value = "列表", notes = "列表")
    public ResultJson getAll() {
        return ResultJson.success(demoService.getAll());
    }


    @RequestMapping(value = "delete", method = {RequestMethod.GET, RequestMethod.GET})
    @ApiOperation(value = "删除", notes = "删除")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "编号", paramType = "query", required = true, dataType = "int"),
    })
    public ResultJson delete(@RequestParam int id) {
        if(id==0)
        {
            return ResultJson.error("id为0");
        }

        // return new ResultJson(300,"特定错误代码","");
        demoService.delete(id);
        return ResultJson.success("");
    }

}