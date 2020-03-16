package tidemedia.tcenter.controller.training;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.tcenter.base.ResultJson;
import tidemedia.tcenter.service.train.TrainService;

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.sql.SQLException;


@RestController
@RequestMapping("/train")
@Api(value = "培训管理", description = "培训管理")
public class TrainingController {

    private static final Logger logger = LoggerFactory.getLogger(TrainingController.class);

    @Autowired
    private TrainService trainService;

    /**
     * 获取全部产品列表
     *
     * @return
     */
    @PostMapping("/getAllTrain")
    @ApiOperation(value = "获取全部培训管理", notes = "获取全部培训管理")
    public ResultJson getAllTrain(@ApiParam(defaultValue = "0", value = "id,0为查全部") @RequestParam(required = false) int id) throws MessageException, SQLException {
        if (id < 0)
            return ResultJson.error("请传递正确的id值");
        return ResultJson.success(trainService.getAllTrainManagerMini(id));
    }


    /**
     * 资费管理
     *
     * @return
     */
    @PostMapping("/getTrainDetail")
    @ApiOperation(value = "获取细节接口", notes = "获取细节接口")
    public ResultJson getTrainDetail(@RequestParam int id, HttpServletRequest request) throws MessageException, SQLException {
        if (id <= 0)
            return ResultJson.error("请传递正确的id值");
        return ResultJson.success(trainService.getAllTrainManager(id));
    }

    /**
     * 增加培训实际在线人数
     *
     * @return
     */
    @GetMapping(value = "/addTrainingViewNum")
    @ApiOperation(value = "增加培训实际在线人数", notes = "增加培训实际在线人数")
    public Integer addTrainingViewNum(@ApiParam(defaultValue = "1", value = "培训条目的id") @RequestParam(value = "id", required = true) int id) throws Exception {
        int totalNum = 0;

        String ListSql = "select view_virtual,view_num from channel_training_manager where id = " + id;

        TableUtil tu = new TableUtil();

        ResultSet Rs = tu.executeQuery(ListSql);
        if (Rs.next()) {
            int view_num = Rs.getInt("view_num");
            int view_virtual = Rs.getInt("view_virtual");
            view_num++;
            totalNum = view_num + view_virtual;
            String updatesql = "update channel_training_manager set view_num = view_num+1 where id=" + id;
            tu.executeUpdate(updatesql);
            tu.closeRs(Rs);
        } else {
            tu.closeRs(Rs);
        }

        return totalNum;
    }
}
