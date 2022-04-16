package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.ActivityRemark;
import com.example.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark activityRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        activityRemark.setId(UUIDUtils.getUUID());
        activityRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        activityRemark.setEditFlag(Contants.REMARK_EDIT_NO);
        activityRemark.setCreateBy(user.getName());

        try {
            int result = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(activityRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    @ResponseBody
    public Object deleteActivityRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        // 调用service层方法，删除备注
        try {
            int result = activityRemarkService.deleteActivityRemarkById(id);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setMessage("删除备注成功");
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityRemarkById.do")
    @ResponseBody
    public Object queryActivityRemarkById(String id){
        ActivityRemark activityRemark = activityRemarkService.queryActivityRemarkById(id);
        return activityRemark;
    }

    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    @ResponseBody
    public Object saveEditActivityRemark(ActivityRemark activityRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        activityRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        activityRemark.setEditBy(user.getName());
        activityRemark.setEditFlag("1");
        // 调用service层方法，保存修改的市场活动备注
        try {
            int result = activityRemarkService.saveEditActivityRemark(activityRemark);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(activityRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }
}
