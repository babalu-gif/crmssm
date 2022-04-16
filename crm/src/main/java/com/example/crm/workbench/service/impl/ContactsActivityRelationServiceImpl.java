package com.example.crm.workbench.service.impl;

import com.example.crm.workbench.entity.ContactsActivityRelation;
import com.example.crm.workbench.mapper.ContactsActivityRelationMapper;
import com.example.crm.workbench.service.ContactsActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Override
    public int deleteContactsActivityRelationByContactsIdActivityId(ContactsActivityRelation relation) {
        return contactsActivityRelationMapper.deleteContactsActivityRelationByContactsIdActivityId(relation);
    }

    @Override
    public int saveCreateContactsActivityRelationByList(List<ContactsActivityRelation> relationList) {
        return contactsActivityRelationMapper.saveCreateContactsActivityRelationByList(relationList);
    }
}
