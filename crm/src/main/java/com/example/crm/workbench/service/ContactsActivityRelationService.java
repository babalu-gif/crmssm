package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationService {
    int deleteContactsActivityRelationByContactsIdActivityId(ContactsActivityRelation relation);

    int saveCreateContactsActivityRelationByList(List<ContactsActivityRelation> relationList);
}
