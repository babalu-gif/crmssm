package com.example.crm.workbench.service;

import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> queryContactsByName(String contactsName);

   List<Contacts> queryContactsByCustomerId(String customerId);

    List<Contacts> queryContactsByCondition(Contacts contacts);

    void saveCreateContacts(Contacts contacts, User user);

    void deleteContactsById(String id);

    Contacts queryContactsById(String id);

    void editContacts(Contacts contacts, User user);

    void deleteContactsByIds(String[] ids);
}
