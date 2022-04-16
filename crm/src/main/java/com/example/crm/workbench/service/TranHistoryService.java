package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.TranHistory;

import java.util.List;

public interface TranHistoryService {
    List<TranHistory> queryTranHistoryByTranId(String tranId);
}
