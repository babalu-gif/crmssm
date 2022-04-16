package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.Customer;

import java.util.List;

public interface CustomerService {
    List<Customer> queryCustomerByCondition(Customer customer);

    int saveCreateCustomer(Customer customer);

    Customer queryCustomerById(String id);

    int editCreateCustomer(Customer customer);

    void deleteCustomerByIds(String[] ids);

    Customer queryCustomerOwnerById(String id);

    List<String> queryAllCustomerName();
}
