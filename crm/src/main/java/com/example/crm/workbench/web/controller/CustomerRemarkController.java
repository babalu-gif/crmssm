package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.ActivityRemark;
import com.example.crm.workbench.entity.CustomerRemark;
import com.example.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class CustomerRemarkController {

    @Autowired
    private CustomerRemarkService customerRemarkService;

    @RequestMapping("/workbench/customer/deleteCustomerRemarkById.do")
    @ResponseBody
    public Object deleteCustomerRemarkById(String id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = customerRemarkService.deleteCustomerRemarkById(id);
            if (result > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e) {
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            e.printStackTrace();
        }
        return returnObject;
    }


    @RequestMapping("/workbench/customer/saveCreateCustomerRemark.do")
    @ResponseBody
    public Object saveCreateCustomerRemark(CustomerRemark customerRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        customerRemark.setId(UUIDUtils.getUUID());
        customerRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        customerRemark.setEditFlag(Contants.REMARK_EDIT_NO);
        customerRemark.setCreateBy(user.getName());

        try {
            int result = customerRemarkService.saveCreateCustomerRemark(customerRemark);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(customerRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/saveEditCustomerRemark.do")
    @ResponseBody
    public Object saveEditCustomerRemark(CustomerRemark customerRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        customerRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        customerRemark.setEditBy(user.getName());
        customerRemark.setEditFlag("1");
        // 调用service层方法，保存修改的市场活动备注
        try {
            int result = customerRemarkService.saveEditCustomerRemark(customerRemark);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(customerRemark);
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
