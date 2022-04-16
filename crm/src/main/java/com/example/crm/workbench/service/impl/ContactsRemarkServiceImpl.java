package com.example.crm.workbench.service.impl;

import com.example.crm.workbench.entity.ContactsRemark;
import com.example.crm.workbench.mapper.ContactsRemarkMapper;
import com.example.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Override
    public List<ContactsRemark> queryContactsRemarkByContactsId(String contactsId) {
        return contactsRemarkMapper.selectContactsRemarkByContactsId(contactsId);
    }

    @Override
    public int saveCreateContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insertSelective(contactsRemark);
    }

    @Override
    public int saveEditContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.updateByPrimaryKeySelective(contactsRemark);
    }

    @Override
    public int deleteContactsRemarkById(String id) {
        return contactsRemarkMapper.deleteByPrimaryKey(id);
    }
}
