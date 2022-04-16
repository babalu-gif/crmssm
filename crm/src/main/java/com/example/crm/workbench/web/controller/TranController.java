package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class TranController {

    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TranService tranService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TranRemarkService tranRemarkService;
    @Autowired
    private TranHistoryService tranHistoryService;


    @RequestMapping("/workbench/transaction/index.do")
    public String index(HttpServletRequest request){
        // 调用service层，查询动态数据
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");

        // 将数据存储到request作用域中
        request.setAttribute("stageList", stageList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("typeList", typeList);
        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/queryPagination.do")
    @ResponseBody
    public PageInfo<Tran> queryPagination(Integer page, Integer pageSize, Tran tran){
        PageHelper.startPage(page, pageSize);
        List<Tran> tranList = tranService.queryTranByCondition(tran);
        PageInfo<Tran> pageInfo = new PageInfo<>(tranList);
        return pageInfo;
    }

    @RequestMapping("/workbench/transaction/toSave.do")
    public String toSave(HttpServletRequest request){
        // 调用service层，查询动态数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");

        // 将数据存储到request作用域中
        request.setAttribute("userList", userList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("typeList", typeList);

        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/toEdit.do")
    public String toEdit(String id, HttpServletRequest request){
        // 调用service层，查询动态数据
        Tran tran = tranService.queryTranById(id);
        Tran t = tranService.queryTran(id);
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");

        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(tran.getStage());

        // 将数据存储到request作用域中
        request.setAttribute("tran", tran);
        request.setAttribute("t", t);
        request.setAttribute("possibility", possibility);
        request.setAttribute("userList", userList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("typeList", typeList);

        return "workbench/transaction/edit";
    }

    @RequestMapping("/workbench/transaction/queryActivityForDetailByName.do")
    @ResponseBody
    public Object queryActivityForDetailByName(String activityName){
        // 调用service层，查询动态数据
        List<Activity> activityList = activityService.queryActivityByName(activityName);
        return activityList;
    }

    @RequestMapping("/workbench/transaction/queryContactsByName.do")
    @ResponseBody
    public Object queryContactsByName(String contactsName){
        // 调用service层，查询动态数据
        List<Contacts> contactsList = contactsService.queryContactsByName(contactsName);
        return contactsList;
    }

    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    @ResponseBody
    public Object getPossibilityByStage(String stageValue){
        // 处理properties文件
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);

        return  possibility;
    }

    @RequestMapping("/workbench/transaction/queryCustomerNameByName.do")
    @ResponseBody
    public Object queryCustomerNameByName(){
        List<String> nameList = customerService.queryAllCustomerName();
        return nameList;
    }

    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    @ResponseBody
    public Object saveCreateTran(@RequestParam Map<String, Object> map, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        map.put(Contants.SESSION_USER, user);
        ReturnObject returnObject = new ReturnObject();
        try {
            tranService.saveCreateTran(map);
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/transaction/detailTran.do")
    public String detailTran(String id, HttpServletRequest request){
        Tran tran = tranService.queryTranById(id);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(tran.getStage());
        List<TranRemark> remarkList = tranRemarkService.queryTranRemarkByClueId(id);
        List<TranHistory> historyList = tranHistoryService.queryTranHistoryByTranId(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");

        request.setAttribute("tran", tran);
        request.setAttribute("possibility", possibility);
        request.setAttribute("remarkList", remarkList);
        request.setAttribute("historyList", historyList);
        request.setAttribute("stageList", stageList);
        return  "workbench/transaction/detail";
    }

    @RequestMapping("/workbench/transaction/saveEditTran.do")
    @ResponseBody
    public Object saveEditTran(Tran tran, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        tran.setEditBy(user.getName());
        tran.setEditTime(DateUtils.formateDateTime(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try {
            tranService.saveEditTran(tran, user);
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/transaction/deleteTranByIds.do")
    @ResponseBody
    public Object deleteTranByIds(String[] id){

        ReturnObject returnObject = new ReturnObject();
        try {
           tranService.deleteTranByIds(id);
           returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/transaction/deleteTranById.do")
    @ResponseBody
    public Object deleteTranByIds(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            tranService.deleteTranById(id);
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
        }
        return  returnObject;
    }


}
