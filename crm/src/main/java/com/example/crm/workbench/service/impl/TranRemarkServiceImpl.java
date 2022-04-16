package com.example.crm.workbench.service.impl;

import com.example.crm.workbench.entity.TranRemark;
import com.example.crm.workbench.mapper.TranRemarkMapper;
import com.example.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranRemarkServiceImpl implements TranRemarkService {

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public List<TranRemark> queryTranRemarkByClueId(String tranId) {
        return tranRemarkMapper.selectTranRemarkByTranId(tranId);
    }

    @Override
    public int saveCreateTranRemark(TranRemark tranRemark) {
        return tranRemarkMapper.insertSelective(tranRemark);
    }

    @Override
    public int deleteTranRemarkById(String id) {
        return tranRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int editTranRemark(TranRemark tranRemark) {
        return tranRemarkMapper.updateByPrimaryKeySelective(tranRemark);
    }
}
