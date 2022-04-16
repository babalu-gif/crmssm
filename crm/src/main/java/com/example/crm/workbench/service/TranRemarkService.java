package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.TranRemark;

import java.util.List;

public interface TranRemarkService {
    List<TranRemark> queryTranRemarkByClueId(String tranId);

    int saveCreateTranRemark(TranRemark tranRemark);

    int deleteTranRemarkById(String id);

    int editTranRemark(TranRemark tranRemark);
}
