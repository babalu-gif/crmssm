package com.example.crm.workbench.service;

import com.example.crm.settings.entity.User;
import com.example.crm.workbench.entity.FunnelVO;
import com.example.crm.workbench.entity.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
    List<Tran> queryTranByCustomerId(String customerId);

    List<Tran> queryTranByCondition(Tran tran);

    void saveCreateTran(Map<String, Object> map);

    Tran queryTranById(String id);

    List<FunnelVO> queryCountOfTranGroupByStage();

    void saveEditTran(Tran tran, User user);

    Tran queryTran(String id);

    void deleteTranByIds(String[] ids);

    void deleteTranById(String id);

    List<Tran> queryTranByContactsId(String contactsId);
}
