package com.example.crm.workbench.service.impl;

import com.example.crm.workbench.entity.Customer;
import com.example.crm.workbench.mapper.CustomerMapper;
import com.example.crm.workbench.mapper.CustomerRemarkMapper;
import com.example.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Override
    public List<Customer> queryCustomerByCondition(Customer customer) {
        return customerMapper.selectCustomerByCondition(customer);
    }

    @Override
    public int saveCreateCustomer(Customer customer) {
        return customerMapper.insertSelective(customer);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int editCreateCustomer(Customer customer) {
        return customerMapper.updateByPrimaryKeySelective(customer);
    }

    @Override
    public void deleteCustomerByIds(String[] ids) {
        customerMapper.deleteCustomerByIds(ids);
        customerRemarkMapper.deleteCustomerRemarkByIds(ids);
    }

    @Override
    public Customer queryCustomerOwnerById(String id) {
        return customerMapper.selectCustomerOwnerById(id);
    }

    @Override
    public List<String> queryAllCustomerName() {
        return customerMapper.selectAllCustomerName();
    }


}
