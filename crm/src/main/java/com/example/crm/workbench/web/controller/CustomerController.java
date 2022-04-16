package com.example.crm.workbench.web.controller;

import com.example.crm.commons.contants.Contants;
import com.example.crm.commons.entity.ReturnObject;
import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.DicValue;
import com.example.crm.settings.entity.User;
import com.example.crm.settings.service.DicValueService;
import com.example.crm.settings.service.UserService;
import com.example.crm.workbench.entity.Contacts;
import com.example.crm.workbench.entity.Customer;
import com.example.crm.workbench.entity.CustomerRemark;
import com.example.crm.workbench.entity.Tran;
import com.example.crm.workbench.service.ContactsService;
import com.example.crm.workbench.service.CustomerRemarkService;
import com.example.crm.workbench.service.CustomerService;
import com.example.crm.workbench.service.TranService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class CustomerController {

    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private TranService tranService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("/workbench/customer/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList", userList);
        return "workbench/customer/index";
    }

    @RequestMapping("/workbench/customer/Pagination.do")
    @ResponseBody
    public Object Pagination(Customer customer, int page, int pageSize){
        PageHelper.startPage(page, pageSize);
        List<Customer> customerList = customerService.queryCustomerByCondition(customer);
        PageInfo<Customer> pageInfo = new PageInfo<>(customerList);
        return pageInfo;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer.do")
    @ResponseBody
    public Object saveCreateCustomer(Customer customer, HttpSession session) {
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        customer.setCreateBy(user.getName());
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = customerService.saveCreateCustomer(customer);
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

    @RequestMapping("/workbench/customer/queryCustomerById.do")
    @ResponseBody
    public Object queryCustomerById(String id){
       Customer customer = customerService.queryCustomerById(id);
       return customer;
    }


    @RequestMapping("/workbench/customer/editCreateCustomer.do")
    @ResponseBody
    public Object editCreateCustomer(Customer customer, HttpSession session) {
        customer.setEditTime(DateUtils.formateDateTime(new Date()));
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        customer.setEditBy(user.getName());
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = customerService.editCreateCustomer(customer);
            if (result > 0) {
                Customer con = customerService.queryCustomerOwnerById(customer.getId());
                returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
                returnObject.setRetData(con);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            }
        } catch (Exception e) {
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            e.printStackTrace();
        }

        return returnObject;
    }

    @RequestMapping("/workbench/customer/deleteCustomerByIds.do")
    @ResponseBody
    public Object deleteCustomerByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            customerService.deleteCustomerByIds(id);
            returnObject.setCode(Contants.RETURN_OBJECT_SUCCESS);
        } catch (Exception e) {
            returnObject.setCode(Contants.RETURN_OBJECT_FAIL);
            e.printStackTrace();
        }

        return returnObject;
    }

    @RequestMapping("/workbench/customer/detailCustomer.do")
    public String detailCustomer(String id, HttpServletRequest request){
        Customer customer = customerService.queryCustomerOwnerById(id);
        List<CustomerRemark> remarkList = customerRemarkService.queryCustomerRemarkByCustomerId(id);
        List<Contacts> contactsList = contactsService.queryContactsByCustomerId(id);
        List<Tran> tranList = tranService.queryTranByCustomerId(id);
        List<User> userList = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");

        // 将查询出的数据存放到request作用域中
        request.setAttribute("customer", customer);
        request.setAttribute("remarkList", remarkList);
        request.setAttribute("tranList", tranList);
        request.setAttribute("contactsList", contactsList);
        request.setAttribute("userList", userList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("appellationList", appellationList);
        return "workbench/customer/detail";
    }

}
