package com.example.crm.workbench.service.impl;

import com.example.crm.workbench.entity.TranHistory;
import com.example.crm.workbench.mapper.TranHistoryMapper;
import com.example.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranHistoryServiceImpl implements TranHistoryService {

    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    @Override
    public List<TranHistory> queryTranHistoryByTranId(String tranId) {
        return tranHistoryMapper.selectTranHistoryByTranId(tranId);
    }
}
