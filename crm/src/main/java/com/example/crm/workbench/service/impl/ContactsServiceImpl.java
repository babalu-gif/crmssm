package com.example.crm.workbench.service.impl;

import com.example.crm.commons.utils.DateUtils;
import com.example.crm.commons.utils.UUIDUtils;
import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.Contacts;
import com.example.crm.workbench.entity.Customer;
import com.example.crm.workbench.mapper.ContactsActivityRelationMapper;
import com.example.crm.workbench.mapper.ContactsMapper;
import com.example.crm.workbench.mapper.ContactsRemarkMapper;
import com.example.crm.workbench.mapper.CustomerMapper;
import com.example.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Override
    public List<Contacts> queryContactsByName(String contactsName) {
        return contactsMapper.selectContactsByName(contactsName);
    }

    @Override
    public List<Contacts> queryContactsByCustomerId(String customerId) {
        return contactsMapper.selectContactsByCustomerId(customerId);
    }

    @Override
    public List<Contacts> queryContactsByCondition(Contacts contacts) {
        return contactsMapper.selectContactsByCondition(contacts);
    }

    @Override
    public void saveCreateContacts(Contacts contacts, User user) {
        Customer customer = customerMapper.selectCustomerByName(contacts.getCustomerId());
        Date date = new Date();

        // 如果客户不存在，则创建
        if (null == customer){
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setName(contacts.getCustomerId());
            customer.setCreateBy(user.getName());
            customer.setCreateTime(DateUtils.formateDateTime(date));
            customer.setOwner(user.getId());
            customerMapper.insertSelective(customer);
        }

        // 新建联系人
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateBy(user.getName());
        contacts.setCreateTime(DateUtils.formateDateTime(date));
        contacts.setCustomerId(customer.getId());
        contactsMapper.insertSelective(contacts);
    }

    @Override
    public void deleteContactsById(String id) {
        contactsMapper.deleteByPrimaryKey(id);
        contactsRemarkMapper.deleteByPrimaryKey(id);
        contactsActivityRelationMapper.deleteByPrimaryKey(id);

    }

    @Override
    public Contacts queryContactsById(String id) {
        return contactsMapper.selectContactsById(id);
    }

    @Override
    public void editContacts(Contacts contacts, User user) {
        Customer customer = customerMapper.selectCustomerByName(contacts.getCustomerId());
        Date date = new Date();

        // 如果客户不存在，则创建
        if (null == customer){
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setName(contacts.getCustomerId());
            customer.setCreateBy(user.getName());
            customer.setCreateTime(DateUtils.formateDateTime(date));
            customer.setOwner(user.getId());
            customerMapper.insertSelective(customer);
        }

        // 修改联系人
        contacts.setEditBy(user.getName());
        contacts.setEditTime(DateUtils.formateDateTime(date));
        contacts.setCustomerId(customer.getId());
        contactsMapper.updateByPrimaryKeySelective(contacts);
    }

    @Override
    public void deleteContactsByIds(String[] ids) {
        contactsMapper.deleteContactsByIds(ids);
        contactsRemarkMapper.deleteContactsRemarkByIds(ids);
        contactsActivityRelationMapper.deleteContactsActivityRelationByIds(ids);
    }
}
