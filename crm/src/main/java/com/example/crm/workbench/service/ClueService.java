package com.example.crm.workbench.service;

import com.example.crm.workbench.entity.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {
    List<Clue> queryPaginationClues(Clue clue);

    int saveCreateClue(Clue clue);

    void deleteClueByIds(String[] ids);

    Clue queryClueById(String id);

    int editClueById(Clue clue);

    Clue queryClueOwnerById(String id);

    void saveConvertClue(Map<String, Object> map);
}
