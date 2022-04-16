package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.ContactsRemark;
import com.example.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ContactsRemarkController {

    @Autowired
    private ContactsRemarkService contactsRemarkService;

    @RequestMapping("/workbench/contacts/saveCreateContactsRemark.do")
    @ResponseBody
    public Object saveCreateContactsRemark(ContactsRemark contactsRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        // 封装参数
        contactsRemark.setId(UUIDUtils.getUUID());
        contactsRemark.setCreateBy(user.getCreateBy());
        contactsRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        contactsRemark.setEditFlag("0");
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = contactsRemarkService.saveCreateContactsRemark(contactsRemark);
            if (result > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(contactsRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e) {
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            e.printStackTrace();
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/saveEditContactsRemark.do")
    @ResponseBody
    public Object saveEditContactsRemark(ContactsRemark contactsRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        contactsRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        contactsRemark.setEditBy(user.getName());
        contactsRemark.setEditFlag("1");
        // 调用service层方法，保存修改的市场活动备注
        try {
            int result = contactsRemarkService.saveEditContactsRemark(contactsRemark);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(contactsRemark);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/contacts/deleteContactsRemarkById.do")
    @ResponseBody
    public Object deleteContactsRemarkById(String id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = contactsRemarkService.deleteContactsRemarkById(id);
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
}
