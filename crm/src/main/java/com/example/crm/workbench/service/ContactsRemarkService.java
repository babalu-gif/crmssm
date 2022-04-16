package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {
    List<ContactsRemark> queryContactsRemarkByContactsId(String contactsId);

    int saveCreateContactsRemark(ContactsRemark contactsRemark);

    int saveEditContactsRemark(ContactsRemark contactsRemark);

    int deleteContactsRemarkById(String id);
}
