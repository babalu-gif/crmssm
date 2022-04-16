package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.ClueRemark;
import com.example.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ClueRemarkController {

    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    @ResponseBody
    public Object saveCreateClueRemark(ClueRemark clueRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setCreateBy(user.getName());
        clueRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        clueRemark.setEditFlag(Contants.REMARK_EDIT_NO);

        try {
            int result = clueRemarkService.saveCreateClueRemark(clueRemark);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(clueRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveEditClueRemark.do")
    @ResponseBody
    public Object saveEditClueRemark(ClueRemark clueRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        clueRemark.setEditBy(user.getName());
        clueRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        clueRemark.setEditFlag(Contants.REMARK_EDIT_YES);

        try {
            int result = clueRemarkService.saveEditClueRemark(clueRemark);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(clueRemark);
                returnObject.setMessage("修改成功");
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    @ResponseBody
    public Object deleteClueRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = clueRemarkService.deleteClueRemarkById(id);
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
