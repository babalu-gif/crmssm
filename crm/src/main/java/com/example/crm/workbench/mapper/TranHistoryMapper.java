package com.example.crm.workbench.mapper;

import com.example.crm.workbench.entity.TranHistory;

import java.util.List;

public interface TranHistoryMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbg.generated Sun Apr 03 08:36:39 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbg.generated Sun Apr 03 08:36:39 CST 2022
     */
    int insert(TranHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbg.generated Sun Apr 03 08:36:39 CST 2022
     */
    int insertSelective(TranHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbg.generated Sun Apr 03 08:36:39 CST 2022
     */
    TranHistory selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbg.generated Sun Apr 03 08:36:39 CST 2022
     */
    int updateByPrimaryKeySelective(TranHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbg.generated Sun Apr 03 08:36:39 CST 2022
     */
    int updateByPrimaryKey(TranHistory record);

    /**
     * 根据tranId查询交易历史的明细信息
     * @param tranId
     * @return
     */
    List<TranHistory> selectTranHistoryByTranId(String tranId);

    /**
     * 根据tranId删除交易历史活动
     * @param tranId
     * @return
     */
    int deleteTranHistoryByTranId(String[] tranId);
}