package com.example.crm.settings.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * url要和controller方法处理完请求后，响应信息返回的页面的资源目录保持一致
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        // 请求转发到登录页面
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd,
                        HttpServletRequest request, HttpServletResponse response, HttpSession session){
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);

        User user = userService.queryUserByLogin(map);
        ReturnObject returnObject = new ReturnObject();
        if (null == user){
            // 登录失败，用户名或密码错误
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            returnObject.setMessage("用户名或密码错误");

        } else { // 进一步判断账号是否合法
            String nowTime = DateUtils.formateDateTime(new Date());
            if (nowTime.compareTo(user.getExpireTime()) > 0){
                // 登录失败，账号已过期
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
                returnObject.setMessage("账号已过期");
            } else if ("0".equals(user.getLockState())){
                // 登录失败，账号被锁定
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
                returnObject.setMessage("账号被锁定");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())){
                // 登录失败，ip受限
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
                returnObject.setMessage("ip受限");
            } else {
                // 登录成功
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);

                // 把User对象保存到session中
                session.setAttribute(Contants.SESSION_USER, user);

                // 判断是否需要自动登录
                if ("true".equals(isRemPwd)){
                    Cookie cookie = new Cookie("loginAct", loginAct);
                    cookie.setMaxAge(10*24*60*60);
                    response.addCookie(cookie);
                    Cookie cookie1 = new Cookie("loginPwd", loginPwd);
                    cookie1.setMaxAge(10*24*60*60);
                    response.addCookie(cookie1);
                } else {
                    // 把没有过期的cookie删除
                    Cookie cookie = new Cookie("loginAct", "0");
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                    Cookie cookie1 = new Cookie("loginPwd", "0");
                    cookie1.setMaxAge(0);
                    response.addCookie(cookie1);
                }

            }
        }
        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response, HttpSession session){
        // 清除cookie
        Cookie cookie = new Cookie("loginAct", "0");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        Cookie cookie1 = new Cookie("loginPwd", "0");
        cookie1.setMaxAge(0);
        response.addCookie(cookie1);

        // 销毁session,释放内存
        session.invalidate();

        // 跳转到首页
        return "redirect:/";
    }

    @RequestMapping("/workbench/user/editPwd.do")
    @ResponseBody
    public Object editPwd(User user){
        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用service层方法，删除线索和市场活动的关联关系
            int result = userService.editPwd(user);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }
}
