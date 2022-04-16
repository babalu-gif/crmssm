package com.example.crm.workbench.service.impl;

import com.example.crm.workbench.entity.ClueRemark;
import com.example.crm.workbench.mapper.ClueRemarkMapper;
import com.example.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueRemarkByClueId(String id) {
        return clueRemarkMapper.selectClueRemarkByClueId(id);
    }

    @Override
    public int saveCreateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertSelective(clueRemark);
    }

    @Override
    public int saveEditClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.updateByPrimaryKeySelective(clueRemark);
    }

    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteByPrimaryKey(id);
    }
}
