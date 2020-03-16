package tidemedia.tcenter.controller.photo;


import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;

import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import tidemedia.cms.base.MessageException;
import java.sql.SQLException;


/**
 * @author gengliao
 * @date 2019/11/22 9:40 AM
 */
@RestController
@RequestMapping("/content")
@Api(tags = {"图片本地化接口"})
public class ImageEditController {
    @RequestMapping(value = "/editor_content_images_list", method = RequestMethod.POST)
    @ApiOperation(value = "图片本地化列表", notes = "图片本地化列表")
    @ApiImplicitParam(name = "content", value = "编辑器内容", paramType = "query", required = true, dataType = "String")
    public JSONObject getImageEdit(String content) throws MessageException, SQLException {
        JSONObject obj=new JSONObject();
        JSONArray json=new JSONArray();

        content = content.replaceAll("crossorigin=\"anonymous\"","");
        org.jsoup.nodes.Document doc_jsoup = Jsoup.parse(content);// jsoup解析内容
        Elements ele_back = doc_jsoup.select("[style*=background-image]");// 获取图片background-image标签
        Elements ele = doc_jsoup.select("img");// 获取图片标签

        int count=0;
        if (ele != null && ele.size() > 0||ele_back != null && ele_back.size() > 0) {
            for(int a = 0; a < ele_back.size(); a++){
                System.out.println("进来for1，，，");
                count++;
                JSONObject jsonObject=new JSONObject();
                //获取背景图片
                String back_image = ele_back.get(a).attr("style");
                String s1 = back_image.substring(back_image.indexOf("background-image: url(")+ 23, back_image.length());
                System.out.println("s1==="+s1);
                String s2 = "";
                if(s1.indexOf("\");")!=-1){
                    s2 = s1.substring(0,s1.indexOf("\");"));
                }
                System.out.println("s2"+s2);
                jsonObject.put("old_src",s2);
                jsonObject.put("count",count);
                json.add(jsonObject);

            }
            //获取标签
            for (int i = 0; i <ele.size() ; i++) {
                System.out.println("进来for2，，，");
                count++;
                JSONObject jsonObject=new JSONObject();
                String photo_src = ele.get(i).attr("src");
                jsonObject.put("old_src",photo_src.replace("\\","").replace("\\",""));
                jsonObject.put("count",count);
                json.add(jsonObject);
            }
        }
        obj.put("list",json);

        return obj;
    }

}
