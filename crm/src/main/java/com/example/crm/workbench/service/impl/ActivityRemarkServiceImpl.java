package com.example.crm.workbench.service.impl;

import com.example.crm.workbench.entity.ActivityRemark;
import com.example.crm.workbench.mapper.ActivityRemarkMapper;
import com.example.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarkByActivityId(String id) {
        return activityRemarkMapper.selectActivityRemarkByActivityId(id);
    }

    @Override
    public int saveCreateActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int deleteActivityRemarkById(String id) {
        return activityRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public ActivityRemark queryActivityRemarkById(String id) {
        return activityRemarkMapper.selectByPrimaryKey(id);
    }

    @Override
    public int saveEditActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateActivityRemark(activityRemark);
    }
}
