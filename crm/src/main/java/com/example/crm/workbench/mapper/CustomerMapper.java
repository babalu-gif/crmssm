package com.example.crm.workbench.mapper;

import com.example.crm.workbench.entity.Customer;

import java.util.List;

public interface CustomerMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbg.generated Wed Mar 30 17:09:05 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbg.generated Wed Mar 30 17:09:05 CST 2022
     */
    int insert(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbg.generated Wed Mar 30 17:09:05 CST 2022
     */
    int insertSelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbg.generated Wed Mar 30 17:09:05 CST 2022
     */
    Customer selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbg.generated Wed Mar 30 17:09:05 CST 2022
     */
    int updateByPrimaryKeySelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbg.generated Wed Mar 30 17:09:05 CST 2022
     */
    int updateByPrimaryKey(Customer record);

    /**
     * 根据条件查询顾客信息
     * @param customer
     * @return
     */
    List<Customer> selectCustomerByCondition(Customer customer);

    /**
     * 根据id查询顾客的信息
     * @param id
     * @return
     */
    Customer selectCustomerById(String id);

    /**
     * 根据id删除客户
     * @param ids
     * @return
     */
    int deleteCustomerByIds(String[] ids);

    /**
     * 结合用户表，根据id查询客户信息
     * @param id
     * @return
     */
    Customer selectCustomerOwnerById(String id);

    /**
     * 模糊查询所有客户的名称
     * @return
     */
    List<String> selectAllCustomerName();

    /**
     * 根据名字精确查询客户
     */
    Customer selectCustomerByName(String name);
}