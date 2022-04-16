package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.DicValue;
import com.example.crm.settings.entity.User;
import com.example.crm.settings.service.DicValueService;
import com.example.crm.settings.service.UserService;
import com.example.crm.workbench.entity.*;
import com.example.crm.workbench.service.*;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ContactsController {

    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private TranService tranService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;


    @RequestMapping("/workbench/contacts/index.do")
    public String index(HttpServletRequest request){
        // 调用service层，查询动态数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");

        // 将数据存储到request作用域中
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("userList", userList);
        return "workbench/contacts/index";
    }

    @RequestMapping("/workbench/contacts/queryPagination.do")
    @ResponseBody
    public PageInfo<Contacts> queryPagination(Integer page, Integer pageSize, Contacts contacts){
        PageHelper.startPage(page, pageSize);
        List<Contacts> contactsList = contactsService.queryContactsByCondition(contacts);
        PageInfo<Contacts> pageInfo = new PageInfo<>(contactsList);
        return pageInfo;
    }

    @RequestMapping("/workbench/contacts/saveCreateContacts.do")
    @ResponseBody
    public Object saveCreateContacts(Contacts contacts, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        try {
            contactsService.saveCreateContacts(contacts, user);
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            returnObject.setRetData(contacts);
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/contacts/deleteContactsById")
    @ResponseBody
    public Object deleteContactsById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            contactsService.deleteContactsById(id);
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/contacts/queryContactsById.do")
    @ResponseBody
    public Object queryContactsById(String id){
        Contacts contacts = contactsService.queryContactsById(id);
        return  contacts;
    }

    @RequestMapping("/workbench/contacts/editContacts.do")
    @ResponseBody
    public Object editContacts(Contacts contacts, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        try {
            contactsService.editContacts(contacts, user);
            Contacts con = contactsService.queryContactsById(contacts.getId());
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
            returnObject.setRetData(con);
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/contacts/deleteContactsByIds.do")
    @ResponseBody
    public Object deleteContactsByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            contactsService.deleteContactsByIds(id);
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("workbench/contacts/detailContacts.do")
    public String detailContacts(String id, HttpServletRequest request){
        Contacts contacts = contactsService.queryContactsById(id);
        List<User> userList = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<ContactsRemark> remarkList = contactsRemarkService.queryContactsRemarkByContactsId(id);
        List<Tran> tranList = tranService.queryTranByContactsId(id);
        List<Activity> activityList = activityService.queryActivityForDetailByContactsId(id);

        request.setAttribute("contacts", contacts);
        request.setAttribute("userList", userList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("remarkList", remarkList);
        request.setAttribute("tranList", tranList);
        request.setAttribute("activityList", activityList);

        return "workbench/contacts/detail";
    }

    @RequestMapping("/workbench/contacts/saveUnbund.do")
    @ResponseBody
    public Object saveUnbund(ContactsActivityRelation relation){
        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用service层方法，删除线索和市场活动的关联关系
            int result = contactsActivityRelationService.deleteContactsActivityRelationByContactsIdActivityId(relation);
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

    @RequestMapping("/workbench/contacts/queryActivityForDetailByNameContactsId.do")
    @ResponseBody
    public Object queryActivityForDetailByNameContactsId(String activityName, String contactsId){
        // 封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("contactsId", contactsId);
        // 调用service层方法
        List<Activity> activityList = activityService.queryActivityForDetailByNameContactsId(map);
        return activityList;
    }

    @RequestMapping("/workbench/contacts/saveBund.do")
    @ResponseBody
    public Object saveBund(String[] activityId, String contactsId){
        ReturnObject returnObject = new ReturnObject();
        // 封装参数
        ContactsActivityRelation car = null;
        List<ContactsActivityRelation> list = new ArrayList<>();

        for (String aid : activityId){
            car = new ContactsActivityRelation();
            car.setId(UUIDUtils.getUUID());
            car.setContactsId(contactsId);
            car.setActivityId(aid);
            list.add(car);
        }

        // 调用service层方法，保存创建市场活动与线索的关联
        try {
            int result = contactsActivityRelationService.saveCreateContactsActivityRelationByList(list);
            if (result > 0){
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);

                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);
                returnObject.setRetData(activityList);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }

        return returnObject;
    }
}
