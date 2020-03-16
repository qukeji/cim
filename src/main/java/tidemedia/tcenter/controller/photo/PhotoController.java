package tidemedia.tcenter.controller.photo;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.user.UserInfo;
import tidemedia.tcenter.base.ResultJson;
import tidemedia.tcenter.service.photo.PhotoService;

import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;

@RequestMapping("/photo")
@RestController
@Api(tags = {"图片库管理接口"})
public class PhotoController {

    @Autowired
    private PhotoService photoService;

    @RequestMapping(value = "list", method = {RequestMethod.GET, RequestMethod.GET})
    @ApiOperation(value = "图片库列表", notes = "图片库列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "type", value = "图片库分类", paramType = "query", required = true, dataType = "int"),
            @ApiImplicitParam(name = "keyword", value = "关键词(图片标题)", paramType = "query", required = false, dataType = "String"),
            @ApiImplicitParam(name = "page", value = "页码", paramType = "query", required = false, dataType = "int"),
            @ApiImplicitParam(name = "pagenum", value = "每页显示数量", paramType = "query", required = false, dataType = "int")
    })
    public ResultJson list(HttpServletRequest request, @RequestParam int type, @RequestParam(defaultValue = "") String keyword, @RequestParam(value = "page", defaultValue = "1") int page, @RequestParam(value = "pagenum", defaultValue = "20") int pageNum) throws MessageException, SQLException {
        UserInfo user = (UserInfo) request.getSession().getAttribute("CMSUserInfo");
        int userId = user.getId();
        return ResultJson.success(photoService.list(userId, type, keyword, page, pageNum));
    }
}
