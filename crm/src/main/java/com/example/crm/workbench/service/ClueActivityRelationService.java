package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {
    int saveCreateActivityClueRelationByList(List<ClueActivityRelation> list);

    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation relation);
}
