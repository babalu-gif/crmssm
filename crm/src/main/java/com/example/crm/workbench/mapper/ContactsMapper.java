package com.example.crm.workbench.mapper;

import com.example.crm.workbench.entity.Contacts;
import com.example.crm.workbench.entity.Tran;

import java.util.List;

public interface ContactsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Thu Mar 31 09:58:19 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Thu Mar 31 09:58:19 CST 2022
     */
    int insert(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Thu Mar 31 09:58:19 CST 2022
     */
    int insertSelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Thu Mar 31 09:58:19 CST 2022
     */
    Contacts selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Thu Mar 31 09:58:19 CST 2022
     */
    int updateByPrimaryKeySelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbg.generated Thu Mar 31 09:58:19 CST 2022
     */
    int updateByPrimaryKey(Contacts record);

    /**
     * 根据contactsName迷糊查询联系人信息
     * @param contactsName
     * @return
     */
    List<Contacts> selectContactsByName(String contactsName);

    /**
     * 根据customerId查询联系人信息
     * @param customerId
     * @return
     */
    List<Contacts> selectContactsByCustomerId(String customerId);

    /**
     * 根据条件查询联系人信息
     * @param contacts
     * @return
     */
    List<Contacts> selectContactsByCondition(Contacts contacts);

    /**
     * 根据id查询联系人信息
     * @param id
     * @return
     */
    Contacts selectContactsById(String id);

    /**
     * 根据id删除联系人
     * @param ids
     * @return
     */
    int deleteContactsByIds(String[] ids);
}