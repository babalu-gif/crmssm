package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.TranRemark;
import com.example.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class TranRemarkController {

    @Autowired
    private TranRemarkService tranRemarkService;

    @RequestMapping("/workbench/transaction/saveCreateTranRemark.do")
    @ResponseBody
    public Object saveCreateTranRemark(TranRemark tranRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        tranRemark.setId(UUIDUtils.getUUID());
        tranRemark.setCreateBy(user.getName());
        tranRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranRemark.setEditFlag("0");
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = tranRemarkService.saveCreateTranRemark(tranRemark);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(tranRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }

        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/transaction/deleteTranRemarkById.do")
    @ResponseBody
    public Object deleteTranRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = tranRemarkService.deleteTranRemarkById(id);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }

        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/transaction/saveEditTranRemark.do")
    @ResponseBody
    public Object saveEditTranRemark(TranRemark tranRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        tranRemark.setEditFlag("1");
        tranRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        tranRemark.setEditBy(user.getName());
        try {
            int result = tranRemarkService.editTranRemark(tranRemark);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(tranRemark);
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
