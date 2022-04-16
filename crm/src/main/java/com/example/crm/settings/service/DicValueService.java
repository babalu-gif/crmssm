package com.example.crm.settings.service;

import com.example.crm.settings.entity.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
