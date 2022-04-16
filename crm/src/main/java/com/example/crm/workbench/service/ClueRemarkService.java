package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkByClueId(String id);

    int saveCreateClueRemark(ClueRemark clueRemark);

    int saveEditClueRemark(ClueRemark clueRemark);

    int deleteClueRemarkById(String id);
}
