package com.example.crm.workbench.service.impl;

import com.example.crm.workbench.entity.CustomerRemark;
import com.example.crm.workbench.mapper.CustomerRemarkMapper;
import com.example.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Override
    public List<CustomerRemark> queryCustomerRemarkByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkByCustomerId(customerId);
    }

    @Override
    public int deleteCustomerRemarkById(String id) {
        return customerRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int saveCreateCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertSelective(customerRemark);
    }

    @Override
    public int saveEditCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateByPrimaryKeySelective(customerRemark);
    }
}
