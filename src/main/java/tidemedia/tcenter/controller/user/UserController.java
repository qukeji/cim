package tidemedia.tcenter.controller.user;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.user.UserInfo;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.SQLException;

/**
 * 用户登录控制器
 */

@Controller
@RequestMapping("/user")
public class UserController {

    @RequestMapping(method = RequestMethod.POST, value = {"/login"})
    @ResponseBody
    public String login(@RequestParam String Username,
                        @RequestParam String Password,
                        @RequestParam(required = false) String Url,
                        HttpServletResponse response,
                        HttpServletRequest request) throws MessageException, SQLException, UnsupportedEncodingException {
        int result = 0;
        if (!Username.equals("")) {
            if (!Password.equals("")) {
                UserInfo userinfo = new UserInfo();

                Cookie cookie = new Cookie("Username", URLEncoder.encode(Username, "UTF-8"));
                cookie.setMaxAge(365 * 24 * 60 * 60);
                response.addCookie(cookie);

                byte[] bytes = Password.getBytes("UTF-8");
                byte[] decoded = java.util.Base64.getDecoder().decode(bytes);
                Password = new String(decoded);

                result = userinfo.Authorization(request, response, Username, Password);
                //0 登录失败 1登录成功 2登录失败，帐号过期 3登陆次数太多

            } else {
                result = 4;//请输入密码
            }
        } else {
            result = 5;//请输入用户名
        }

        return result + "";
    }
}
