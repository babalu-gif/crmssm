package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {
    List<CustomerRemark> queryCustomerRemarkByCustomerId(String customerId);

    int deleteCustomerRemarkById(String id);

    int saveCreateCustomerRemark(CustomerRemark customerRemark);

    int saveEditCustomerRemark(CustomerRemark customerRemark);
}
